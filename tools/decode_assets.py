#!/usr/bin/env python3
"""Validate the clut + sssf decode by rendering to PNG (dependency-free).

Writes:
  extracted/preview/palette.png         -- the 256-colour master palette as a swatch
  extracted/preview/<name>_fNN.png      -- sample sprite frames (raw-index hypothesis)

Usage:  python tools/decode_assets.py
"""
from __future__ import annotations

import os
import struct
import sys
import zlib
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402

GFX = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "._SOI Graphics"
OUT = Path("extracted") / "preview"


# ---- minimal PNG writer (RGBA, 8-bit) --------------------------------------
def write_png(path: Path, w: int, h: int, rows: list[bytes]) -> None:
    def chunk(typ: bytes, data: bytes) -> bytes:
        c = typ + data
        return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
    raw = b"".join(b"\x00" + r for r in rows)
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


def render_palette_swatch(pal: list[tuple[int, int, int]]) -> None:
    cell = 20
    w = h = 16 * cell
    rows = []
    for y in range(h):
        row = bytearray()
        for x in range(w):
            idx = (y // cell) * 16 + (x // cell)
            r, g, b = pal[idx]
            row += bytes((r, g, b, 255))
        rows.append(bytes(row))
    write_png(OUT / "palette.png", w, h, rows)
    print(f"  wrote {OUT / 'palette.png'}")


def sssf_frames(data: bytes) -> list[tuple[int, int]]:
    """Return (offset, ) list of nonzero frame offsets (absolute from resource start)."""
    (count,) = struct.unpack_from(">I", data, 0)
    offs = [struct.unpack_from(">I", data, 4 + i * 4)[0] for i in range(count)]
    return [o for o in offs if 0 < o < len(data)]


def render_sprite_rle(name: str, res: dict, pal: list[tuple[int, int, int]], scale: int = 4) -> None:
    """Test the (run_length, palette_index) RLE hypothesis; pixels start right after w,h."""
    e = next((x for x in res["sssf"] if x["name"] == name), None)
    if not e:
        return
    d = e["data"]
    offs = sssf_frames(d)
    for fi, off in enumerate(offs[:2]):
        w, h = struct.unpack_from(">HH", d, off)
        if not (0 < w <= 256 and 0 < h <= 256):
            continue
        end = offs[fi + 1] if fi + 1 < len(offs) else len(d)
        p = off + 4
        px = bytearray()
        need = w * h
        while p + 1 < end and len(px) < need:
            count, idx = d[p], d[p + 1]
            p += 2
            px += bytes([idx]) * count
        filled = len(px)
        px = px[:need] + bytes(max(0, need - len(px)))
        rows = []
        for y in range(h):
            row = bytearray()
            for x in range(w):
                idx = px[y * w + x]
                r, g, b = pal[idx]
                a = 0 if idx == 0 else 255
                for _ in range(scale):
                    row += bytes((r, g, b, a))
            for _ in range(scale):
                rows.append(bytes(row))
        out = OUT / f"rle_{name.replace(' ', '_')}_f{fi:02d}_{w}x{h}.png"
        write_png(out, w * scale, h * scale, rows)
        print(f"    RLE {name!r} f{fi}: filled {filled}/{need} px -> {out.name}")


def render_sprite(name: str, res: dict, pal: list[tuple[int, int, int]], scale: int = 4, hdr: int = 8) -> None:
    e = next((x for x in res["sssf"] if x["name"] == name), None)
    if not e:
        print(f"  (no sssf named {name!r})")
        return
    d = e["data"]
    offs = sssf_frames(d)
    print(f"  {name!r}: frames-with-data={len(offs)} first offsets={[hex(o) for o in offs[:4]]}")
    for fi, off in enumerate(offs[:3]):
        w, h = struct.unpack_from(">HH", d, off)
        if not (0 < w <= 256 and 0 < h <= 256):
            print(f"    frame@{off:#x}: implausible w,h={w},{h} -> skip (encoding not raw?)")
            continue
        # pixels start after w,h (4) + a per-frame sub-header (hdr bytes); clamp to next frame.
        start = off + 4 + hdr
        limit = offs[fi + 1] if fi + 1 < len(offs) else len(d)
        px = d[start:min(start + w * h, limit)]
        if len(px) < w * h:
            px = px + bytes(w * h - len(px))
        rows = []
        for y in range(h):
            row = bytearray()
            for x in range(w):
                idx = px[y * w + x]
                r, g, b = pal[idx]
                a = 0 if idx == 0 else 255  # test: index 0 = transparent
                for _ in range(scale):
                    row += bytes((r, g, b, a))
            for _ in range(scale):
                rows.append(bytes(row))
        out = OUT / f"{name.replace(' ', '_')}_f{fi:02d}_{w}x{h}.png"
        write_png(out, w * scale, h * scale, rows)
        print(f"    wrote {out} (w={w} h={h}, hdr={hdr}, px_avail={min(w*h, limit-start)}/{w*h})")


def main() -> None:
    res = parse_resource_fork(read_resource_fork(GFX))
    pal = decode_palette(res)
    print("Palette decoded; sample [0,1,2,255]:", [pal[i] for i in (0, 1, 2, 255)])
    render_palette_swatch(pal)
    for name in ("blocks", "weapons", "ant sprites"):
        render_sprite(name, res, pal)
    print("RLE hypothesis test:")
    for name in ("weapons", "blocks", "ant sprites", "hippo sprites"):
        render_sprite_rle(name, res, pal)


if __name__ == "__main__":
    main()
