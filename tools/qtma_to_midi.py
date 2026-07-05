#!/usr/bin/env python3
"""Extract the game's music from its QuickTime Music (QTMA) movies to Standard
MIDI Files.

Each movie (raw_game/Step On It!/Step On It!  Movies/<name>) is a QuickTime
movie whose sample data (an `mdat` atom in the DATA fork) is a stream of QTMA
music events, and whose `moov` (track/media structure + tune header) lives in the
RESOURCE fork (__MACOSX/Step On It!  Movies/._<name>).

QTMA event stream (big-endian u32 events; CONFIRMED against the data):
  * Rest  : top 3 bits == 000  -> advance time by (event & 0x1FFFFFFF).
  * Note  : top 3 bits == 001  -> part=(e>>24)&0x1f, pitch=((e>>18)&0x3f)+32,
            velocity=(e>>11)&0x7f, duration=e&0x7ff (short note-with-duration).
  * General/extended events (top bits >= 010) carry a word count in their 2nd
    long (e & 0xFFFF gives the extra long count for the 0x6.. "general" form);
    we skip them but keep timing intact.

The QTMA note "pitch" field is a MIDI-ish key (field + 32). Durations/rests are in
the media timescale; we emit MIDI with division = timescale and tempo = 1e6 us/qn
so 1 QTMA time unit == 1 MIDI tick == 1/timescale second (timing preserved).

Because the movie stores NOTES + General-MIDI instruments (not baked audio), the
result is fully editable: swap instruments, soundfont, tempo, etc.

Usage:  py tools/qtma_to_midi.py [name ...]      (default: all movies)
Output: extracted/music/<name>.mid
"""
from __future__ import annotations
import struct, sys, os
from pathlib import Path

MOVIES = Path("raw_game") / "Step On It\u2122" / "Step On It!  Movies"
RESFK = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "Step On It!  Movies"
OUT = Path("extracted") / "music"


def find_atom(d: bytes, fourcc: bytes, start=0):
    """Return the offset of a fourcc atom's DATA (just past the type), or -1."""
    i = d.find(fourcc, start)
    return i + 4 if i >= 0 else -1


def read_timescale(resfork: bytes) -> int:
    o = find_atom(resfork, b"mdhd")
    if o < 0:
        return 600
    # mdhd data: version+flags(4) created(4) modified(4) timescale(4) duration(4)
    ts = struct.unpack_from(">I", resfork, o + 12)[0]
    return ts if 0 < ts < 100000 else 600


# General MIDI instrument name -> program (0-based). Enough to cover the tune
# headers seen; falls back to fuzzy word match, else Acoustic Grand.
GM = {
    "acoustic grand piano": 0, "grand piano": 0, "bright acoustic piano": 1,
    "electric grand piano": 2, "honky-tonk piano": 3, "electric piano 1": 4,
    "electric piano 2": 5, "harpsichord": 6, "clavinet": 7, "celesta": 8,
    "glockenspiel": 9, "music box": 10, "vibraphone": 11, "marimba": 12,
    "xylophone": 13, "tubular bells": 14, "dulcimer": 15, "drawbar organ": 16,
    "percussive organ": 17, "rock organ": 18, "church organ": 19, "reed organ": 20,
    "accordion": 21, "harmonica": 22, "tango accordion": 23, "acoustic guitar": 24,
    "nylon": 24, "steel": 25, "jazz guitar": 26, "clean guitar": 27,
    "muted guitar": 28, "overdriven guitar": 29, "distortion guitar": 30,
    "guitar harmonics": 31, "acoustic bass": 32, "fingered bass": 33,
    "picked bass": 34, "fretless bass": 35, "slap bass 1": 36, "slap bass 2": 37,
    "synth bass 1": 38, "synth bass 2": 39, "violin": 40, "viola": 41, "cello": 42,
    "contrabass": 43, "tremolo strings": 44, "pizzicato strings": 45,
    "orchestral harp": 46, "timpani": 47, "string ensemble": 48,
    "string ensemble 1": 48, "string ensemble 2": 49, "synth strings 1": 50,
    "synth strings 2": 51, "aah choir": 52, "choir aahs": 52, "ooh choir": 53,
    "synth voice": 54, "orchestra hit": 55, "trumpet": 56, "trombone": 57,
    "tuba": 58, "muted trumpet": 59, "french horn": 60, "brass section": 61,
    "synth brass 1": 62, "synth brass 2": 63, "soprano sax": 64, "alto sax": 65,
    "tenor sax": 66, "baritone sax": 67, "oboe": 68, "english horn": 69,
    "bassoon": 70, "clarinet": 71, "piccolo": 72, "flute": 73, "recorder": 74,
    "pan flute": 75, "blown bottle": 76, "shakuhachi": 77, "whistle": 78,
    "ocarina": 79, "square lead": 80, "sawtooth lead": 81, "calliope": 82,
    "chiff lead": 83, "charang": 84, "voice lead": 85, "fifths lead": 86,
    "bass lead": 87, "fantasy": 88, "new age": 88, "warm pad": 89, "polysynth": 90,
    "poly synth": 90, "choir pad": 91, "bowed glass": 92, "metallic pad": 93,
    "halo pad": 94, "sweep pad": 95,
}


def gm_program(name: str) -> int:
    n = name.strip().lower()
    if n in GM:
        return GM[n]
    for k, v in GM.items():
        if k in n or n in k:
            return v
    for word in ("bass", "piano", "organ", "guitar", "string", "choir", "pad",
                 "synth", "brass", "sax", "vibraphone", "harp"):
        if word in n:
            for k, v in GM.items():
                if word in k:
                    return v
    return 0


def read_instruments(resfork: bytes) -> list[int]:
    """Ordered GM programs (per part) from the tune header's Pascal-string
    instrument names (skips synthesizer/handler names)."""
    o = resfork.find(b"musi")
    if o < 0:
        return []
    seg = resfork[o: o + 1200]
    progs, i = [], 0
    while i < len(seg):
        ln = seg[i]
        if 3 <= ln <= 24 and i + 1 + ln <= len(seg):
            s = seg[i + 1: i + 1 + ln]
            if all(32 <= c < 127 for c in s):
                txt = s.decode("ascii")
                low = txt.lower()
                if not any(w in low for w in ("synthesizer", "handler", "apple", "media", "alias")):
                    progs.append(gm_program(txt))
                    i += 1 + ln
                    continue
        i += 1
    return progs



def mdat_events(datafork: bytes) -> bytes:
    o = datafork.find(b"mdat")
    if o < 0:
        return b""
    size = struct.unpack_from(">I", datafork, o - 4)[0]
    return datafork[o + 4: o - 4 + size] if size > 8 else datafork[o + 4:]


def parse_events(stream: bytes):
    """Yield ('note', t, part, pitch, vel, dur) and advance a shared clock via rests."""
    notes = []
    t = 0
    i = 0
    n = len(stream)
    while i + 4 <= n:
        e = struct.unpack_from(">I", stream, i)[0]
        i += 4
        top = e >> 29
        if e == 0:
            continue
        if top == 0:                      # Rest -> advance time
            t += e & 0x1FFFFFFF
        elif top == 1:                    # Note (short, with duration)
            part = (e >> 24) & 0x1F
            pitch = ((e >> 18) & 0x3F) + 32
            vel = (e >> 11) & 0x7F
            dur = e & 0x7FF
            notes.append((t, part, pitch, vel, dur))
        elif top == 3:                    # extended note (2 longs): part/pitch/vel/dur
            if i + 4 > n:
                break
            e2 = struct.unpack_from(">I", stream, i)[0]; i += 4
            part = (e >> 16) & 0xFFF
            pitch = (e >> 8) & 0xFF
            vel = e & 0xFF
            dur = (e2 >> 0) & 0xFFFFFF
            notes.append((t, part & 0x1F, pitch, vel & 0x7F, dur & 0x7FFF))
        else:                             # general/control/extended: skip extra longs
            # 0x6..... general event: low 16 bits = count of following longs
            extra = 0
            if top in (2, 5, 6, 7):
                extra = (e & 0xFFFF) if top in (6, 7) else 0
            i += extra * 4
    return notes


def write_midi(path: Path, notes, timescale: int, instruments=None):
    # collect per (part) -> channel; build one merged track (format 0)
    events = []  # (tick, order, bytes)
    # program changes (part -> channel) at t=0
    instruments = instruments or []
    for part, prog in enumerate(instruments):
        ch = part & 0x0F
        events.append((0, -1, bytes([0xC0 | ch, prog & 0x7F])))
    for (t, part, pitch, vel, dur) in notes:
        ch = part & 0x0F
        if not (0 <= pitch <= 127):
            continue
        events.append((t, 0, bytes([0x90 | ch, pitch, max(1, vel)])))
        events.append((t + max(1, dur), 1, bytes([0x80 | ch, pitch, 0])))
    events.sort(key=lambda e: (e[0], e[1]))

    def vlq(n):
        out = bytearray([n & 0x7F]); n >>= 7
        while n:
            out.insert(0, 0x80 | (n & 0x7F)); n >>= 7
        return bytes(out)

    trk = bytearray()
    trk += vlq(0) + b"\xFF\x51\x03" + struct.pack(">I", 1000000)[1:]  # tempo 1e6 us/qn
    last = 0
    for (tick, _o, msg) in events:
        trk += vlq(tick - last) + msg
        last = tick
    trk += vlq(0) + b"\xFF\x2F\x00"  # end of track
    div = max(1, min(timescale, 0x7FFF))
    hdr = b"MThd" + struct.pack(">IHHH", 6, 0, 1, div)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(hdr + b"MTrk" + struct.pack(">I", len(trk)) + bytes(trk))


def convert(name: str):
    df = MOVIES / name
    rf = RESFK / ("._" + name)
    if not df.exists():
        print("  missing:", name); return
    data = df.read_bytes()
    res = rf.read_bytes() if rf.exists() else b""
    ts = read_timescale(res)
    instruments = read_instruments(res)
    ev = mdat_events(data)
    notes = parse_events(ev)
    if not notes:
        print("  %-18s no notes (events=%d bytes)" % (name, len(ev))); return
    write_midi(OUT / (name.replace(" ", "_") + ".mid"), notes, ts, instruments)
    dur = max((t + d) for (t, _p, _k, _v, d) in notes) / ts
    parts = sorted(set(p for (_t, p, _k, _v, _d) in notes))
    gm_names = {v: k for k, v in GM.items()}
    inst = ", ".join(gm_names.get(p, str(p)) for p in instruments[:8])
    print("  %-18s %4d notes, %2d parts, ~%.0fs  [%s]"
          % (name, len(notes), len(parts), dur, inst))


def main():
    names = sys.argv[1:] or [f.name for f in sorted(MOVIES.iterdir()) if f.is_file()]
    for n in names:
        convert(n)


if __name__ == "__main__":
    main()
