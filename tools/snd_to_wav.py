"""snd_to_wav.py — convert a classic Mac 'snd ' resource (Format 1/2, sampled)
into a standard little-endian WAV.

Handles the two headers that cover the game's SFX:
  * standard  (encode 0x00): 8-bit **unsigned** mono PCM
  * extended  (encode 0xFF): 8/16-bit PCM, mono or stereo (16-bit is byte-swapped
    from Mac big-endian to WAV little-endian)
Compressed (cmpSH, 0xFE = MACE) is not supported and returns None (the game's
short SFX are effectively all uncompressed sampled sounds).

Reference: Inside Macintosh: Sound, "Sound Manager" — 'snd ' format & sampled
sound headers.
"""
from __future__ import annotations

import struct

_U16 = lambda b, o: struct.unpack_from(">H", b, o)[0]
_U32 = lambda b, o: struct.unpack_from(">I", b, o)[0]

# sampled sound header encode bytes
_STD_SH = 0x00
_EXT_SH = 0xFF
_CMP_SH = 0xFE

# sound commands that carry a sampled-sound-header offset
_SOUND_CMD = 80   # 0x50
_BUFFER_CMD = 81  # 0x51


def _find_sound_header(data: bytes) -> int | None:
    """Walk the 'snd ' command list and return the offset of the sampled sound
    header (from the resource start), or None."""
    if len(data) < 4:
        return None
    fmt = _U16(data, 0)
    o = 2
    if fmt == 1:
        ndt = _U16(data, o)
        o += 2 + ndt * 6         # each data-type entry: u16 type + u32 init
    elif fmt == 2:
        o += 2                   # refCount (u16)
    else:
        return None
    if o + 2 > len(data):
        return None
    ncmd = _U16(data, o)
    o += 2
    for _ in range(ncmd):
        if o + 8 > len(data):
            break
        cmd = _U16(data, o) & 0x7FFF     # strip dataOffsetFlag (0x8000)
        p2 = _U32(data, o + 4)
        o += 8
        if cmd in (_SOUND_CMD, _BUFFER_CMD):
            return p2
    return None


def _wav(pcm: bytes, channels: int, bits: int, rate: int) -> bytes:
    rate = int(rate) if rate else 22254
    block_align = channels * bits // 8
    byte_rate = rate * block_align
    return (
        b"RIFF" + struct.pack("<I", 36 + len(pcm)) + b"WAVE"
        + b"fmt " + struct.pack("<IHHIIHH", 16, 1, channels, rate, byte_rate, block_align, bits)
        + b"data" + struct.pack("<I", len(pcm)) + pcm
    )


def snd_to_wav(data: bytes) -> bytes | None:
    """Return WAV bytes for a 'snd ' resource, or None if unsupported/malformed."""
    off = _find_sound_header(data)
    if off is None or off + 22 > len(data):
        return None

    length = _U32(data, off + 4)           # stdSH: sample count; extSH: numChannels here
    rate_fixed = _U32(data, off + 8)
    encode = data[off + 20]
    sample_rate = rate_fixed / 65536.0

    if encode == _STD_SH:
        n = length
        pcm = data[off + 22: off + 22 + n]
        if not pcm:
            return None
        return _wav(pcm, 1, 8, round(sample_rate))

    if encode == _EXT_SH:
        num_channels = _U32(data, off + 4)     # extSH reuses this field for channels
        num_frames = _U32(data, off + 22)
        sample_size = _U16(data, off + 48)     # 8 or 16
        if num_channels not in (1, 2) or sample_size not in (8, 16):
            return None
        hdr = off + 64                          # extended header is 64 bytes
        n = num_frames * num_channels * sample_size // 8
        pcm = data[hdr: hdr + n]
        if not pcm:
            return None
        if sample_size == 16:
            # Mac stores big-endian signed 16-bit; WAV wants little-endian
            pcm = bytearray(pcm)
            pcm[0::2], pcm[1::2] = pcm[1::2], pcm[0::2]
            pcm = bytes(pcm)
        return _wav(pcm, num_channels, sample_size, round(sample_rate))

    return None   # cmpSH / unknown
