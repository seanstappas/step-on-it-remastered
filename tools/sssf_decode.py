#!/usr/bin/env python3
"""Faithful sssf sprite decoder — reimplements the game's pixel producer
(FUN_10000944) as reverse-engineered from the PowerPC disassembly.

The producer walks TWO byte streams with a small state machine:
  * control stream: alternating run lengths (opaque run R, transparent run M, ...)
  * data stream:    literal palette indices for opaque pixels (a literal 0 -> 1)
Per row it emits `leading_skip` transparent pixels, then W-`leading_skip` content
pixels; index 0 = transparent.

Frame header (big-endian, from FUN_10000358):
  @0 u16 W, @2 u16 H, @8 u32 data-stream offset (from frame start).
The control stream starts right after the fixed header and runs up to the data
offset; this script lets us confirm the exact control offset visually.
"""
from __future__ import annotations
import os, struct, sys, zlib
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402

GFX = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "._SOI Graphics"
OUT = Path("extracted") / "sprites"


def write_png(path: Path, w: int, h: int, rgba_rows: list[bytes]) -> None:
    def chunk(typ, data):
        c = typ + data
        return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
    raw = b"".join(b"\x00" + r for r in rgba_rows)
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr)
                     + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


def decode_palette(res: dict) -> list[tuple[int, int, int]]:
    e = next(x for x in res["clut"] if x["name"].strip().startswith("ss Super Palette"))
    d = e["data"]
    _seed, _flags, size = struct.unpack_from(">IHH", d, 0)
    pal = [(0, 0, 0)] * 256
    for i in range(size + 1):
        value, r, g, b = struct.unpack_from(">HHHH", d, 8 + i * 8)
        if 0 <= value < 256:
            pal[value] = (r >> 8, g >> 8, b >> 8)
    return pal


def frame_offsets(d: bytes) -> list[int]:
    (count,) = struct.unpack_from(">I", d, 0)
    offs = [struct.unpack_from(">I", d, 4 + i * 4)[0] for i in range(count)]
    return offs


def decode_frame(d: bytes, off: int, ctrl_off: int, lead: int) -> tuple[int, int, list[int]]:
    """Decode one frame to a flat list of palette indices (0 = transparent)."""
    w, h = struct.unpack_from(">HH", d, off)
    data_rel = struct.unpack_from(">I", d, off + 8)[0]
    ctrl = off + ctrl_off
    data = off + data_rel
    out = []
    state = 0          # 0 = opaque run, 1 = transparent run
    run = 0
    for _row in range(h):
        skip = lead
        rem = w
        col = 0
        while col < w:
            if skip > 0:
                out.append(0); skip -= 1; col += 1; continue
            if rem == 0:
                out.append(0); col += 1; continue
            rem -= 1
            # advance the run/state machine until a pixel is produced
            produced = False
            while not produced:
                if state != 0:                      # transparent run
                    if run > 0:
                        run -= 1; out.append(0); produced = True
                    else:
                        run = d[ctrl] if ctrl < len(d) else 0; ctrl += 1
                        state = 0
                else:                                # opaque run
                    if run > 0:
                        run -= 1
                        v = d[data] if data < len(d) else 0; data += 1
                        out.append(v if v != 0 else 1); produced = True
                    else:
                        run = d[ctrl] if ctrl < len(d) else 0; ctrl += 1
                        state = 1
            col += 1
    return w, h, out


def render(name, res, pal, ctrl_off, lead, nframes=6, scale=4):
    e = next((x for x in res["sssf"] if x["name"] == name), None)
    if not e:
        print(f"  no sssf {name!r}"); return
    d = e["data"]
    offs = [o for o in frame_offsets(d) if 0 < o < len(d)]
    for fi, off in enumerate(offs[:nframes]):
        w, h = struct.unpack_from(">HH", d, off)
        if not (0 < w <= 128 and 0 < h <= 128):
            continue
        w, h, px = decode_frame(d, off, ctrl_off, lead)
        rows = []
        for y in range(h):
            row = bytearray()
            for x in range(w):
                idx = px[y * w + x] if y * w + x < len(px) else 0
                r, g, b = pal[idx]
                a = 0 if idx == 0 else 255
                for _ in range(scale):
                    row += bytes((r, g, b, a))
            for _ in range(scale):
                rows.append(bytes(row))
        out = OUT / f"{name.replace(' ', '_')}_f{fi:02d}_{w}x{h}.png"
        write_png(out, w * scale, h * scale, rows)
    print(f"  {name!r}: wrote {min(len(offs), nframes)} frames (ctrl_off={ctrl_off}, lead={lead})")


def dump_header(name, res):
    e = next((x for x in res["sssf"] if x["name"] == name), None)
    d = e["data"]
    offs = [o for o in frame_offsets(d) if 0 < o < len(d)]
    off = offs[0]
    w, h = struct.unpack_from(">HH", d, off)
    print(f"{name!r}: count-region; frame0 @ {off:#x}  W={w} H={h}")
    print("  header bytes @frame0:", " ".join(f"{b:02x}" for b in d[off:off + 24]))
    print("  u32@4 =", struct.unpack_from(">I", d, off + 4)[0],
          " u32@8 =", struct.unpack_from(">I", d, off + 8)[0])


def main():
    res = parse_resource_fork(read_resource_fork(GFX))
    pal = decode_palette(res)
    for n in ("blocks", "weapons"):
        dump_header(n, res)
    ctrl_off = int(sys.argv[1]) if len(sys.argv) > 1 else 0x0c
    lead = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    for n in ("blocks", "weapons", "ant sprites"):
        render(n, res, pal, ctrl_off, lead)


if __name__ == "__main__":
    main()
