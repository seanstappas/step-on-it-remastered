#!/usr/bin/env python3
"""Decode the game's `cicn` (colour icon) resources to PNG — the real HUD icons
(smiley face = lives, rocket = magic arrows, potion = shield) and UI buttons.

cicn layout (Inside Macintosh, Imaging With QuickDraw):
  PixMap iconPMap (50B) | BitMap iconMask (14B) | BitMap iconBMap (14B) |
  Handle iconData (4B)  | mask rows | bw rows | ColorTable | pixmap rows
The mask BitMap gives transparency; the PixMap (indexed via its ColorTable) is
the colour image.
"""
from __future__ import annotations
import os, struct, sys, zlib
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402

GFX = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "._SOI Graphics"
OUT = Path("extracted") / "cicn"


def write_png(path: Path, w: int, h: int, rgba: bytes) -> None:
    def chunk(t, d):
        c = t + d
        return struct.pack(">I", len(d)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
    raw = b"".join(b"\x00" + rgba[y * w * 4:(y + 1) * w * 4] for y in range(h))
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(b"\x89PNG\r\n\x1a\n"
                     + chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
                     + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


def decode_cicn(d: bytes):
    # PixMap (50B)
    pm_rowBytes = struct.unpack_from(">H", d, 4)[0] & 0x3FFF
    pm_t, pm_l, pm_b, pm_r = struct.unpack_from(">hhhh", d, 6)
    pm_pixelSize = struct.unpack_from(">H", d, 4 + 2 + 8 + 2 + 2 + 4 + 4 + 4 + 2)[0]
    pw, ph = pm_r - pm_l, pm_b - pm_t
    o = 50
    # iconMask BitMap (14B)
    mk_rowBytes = struct.unpack_from(">H", d, o + 4)[0]
    mk_t, mk_l, mk_b, mk_r = struct.unpack_from(">hhhh", d, o + 6)
    mh = mk_b - mk_t
    o += 14
    # iconBMap BitMap (14B)
    bm_rowBytes = struct.unpack_from(">H", d, o + 4)[0]
    bm_t, bm_l, bm_b, bm_r = struct.unpack_from(">hhhh", d, o + 6)
    bh = bm_b - bm_t
    o += 14
    o += 4                                   # iconData handle
    mask = d[o: o + mk_rowBytes * mh]; o += mk_rowBytes * mh
    o += bm_rowBytes * bh                     # b&w bitmap (unused)
    # ColorTable
    seed, flags, ctSize = struct.unpack_from(">IHH", d, o); o += 8
    pal = [(0, 0, 0)] * 256
    for _ in range(ctSize + 1):
        idx, r, g, b = struct.unpack_from(">HHHH", d, o); o += 8
        if 0 <= idx < 256:
            pal[idx] = (r >> 8, g >> 8, b >> 8)
    pix = d[o: o + pm_rowBytes * ph]
    # compose RGBA using the mask (1bpp: 1 = opaque)
    rgba = bytearray(pw * ph * 4)
    for y in range(ph):
        for x in range(pw):
            mbyte = mask[y * mk_rowBytes + (x >> 3)] if (y < mh and (x >> 3) < mk_rowBytes) else 0
            opaque = (mbyte >> (7 - (x & 7))) & 1
            di = (y * pw + x) * 4
            if not opaque:
                continue
            if pm_pixelSize == 8:
                v = pix[y * pm_rowBytes + x] if y * pm_rowBytes + x < len(pix) else 0
            elif pm_pixelSize == 4:
                byte = pix[y * pm_rowBytes + (x >> 1)] if y * pm_rowBytes + (x >> 1) < len(pix) else 0
                v = (byte >> 4) if (x & 1) == 0 else (byte & 0xF)
            elif pm_pixelSize == 2:
                byte = pix[y * pm_rowBytes + (x >> 2)] if y * pm_rowBytes + (x >> 2) < len(pix) else 0
                v = (byte >> (6 - 2 * (x & 3))) & 3
            else:  # 1bpp
                byte = pix[y * pm_rowBytes + (x >> 3)] if y * pm_rowBytes + (x >> 3) < len(pix) else 0
                v = (byte >> (7 - (x & 7))) & 1
            r, g, b = pal[v]
            rgba[di:di + 4] = bytes((r, g, b, 255))
    return pw, ph, bytes(rgba)


def main():
    res = parse_resource_fork(read_resource_fork(GFX))
    ok = 0
    for c in res.get("cicn", []):
        try:
            w, h, rgba = decode_cicn(c["data"])
            if 0 < w <= 128 and 0 < h <= 128:
                write_png(OUT / ("%d.png" % c["id"]), w, h, rgba)
                ok += 1
        except Exception as e:
            print("cicn %d FAILED: %s" % (c["id"], e))
    print("decoded %d cicn -> %s" % (ok, OUT))


if __name__ == "__main__":
    main()
