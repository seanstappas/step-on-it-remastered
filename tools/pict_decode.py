#!/usr/bin/env python3
"""Decode the game's QuickDraw `PICT` resources (full-screen art + the playfield
frame/HUD background) to PNG.

PICT layout in the resource (big-endian, no 512-byte file wrapper):
  @0 u16 picSize, @2 Rect picFrame(top,left,bottom,right), then opcodes.
We handle the handful of opcodes these pictures actually use: version/header,
clip, PackBitsRect / DirectBitsRect / (Packed)BitsRect pixmaps, and end.
"""
from __future__ import annotations
import os, struct, sys, zlib
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402

GFX = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "._SOI Graphics"
OUT = Path("extracted") / "pict"


def write_png(path: Path, w: int, h: int, rgba: bytes) -> None:
    def chunk(typ, data):
        c = typ + data
        return struct.pack(">I", len(data)) + c + struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
    stride = w * 4
    raw = b"".join(b"\x00" + rgba[y * stride:(y + 1) * stride] for y in range(h))
    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr)
                     + chunk(b"IDAT", zlib.compress(raw, 9)) + chunk(b"IEND", b""))


def unpackbits_row(d, off, dst_len):
    """PackBits-decompress one row of `dst_len` bytes; return (bytes, new_off)."""
    out = bytearray()
    while len(out) < dst_len:
        n = d[off]; off += 1
        if n < 0x80:                    # literal run of n+1 bytes
            cnt = n + 1
            out += d[off:off + cnt]; off += cnt
        elif n > 0x80:                  # repeat next byte (257-n) times
            cnt = 257 - n
            out += bytes([d[off]]) * cnt; off += 1
        # n == 0x80 is a no-op
    return bytes(out[:dst_len]), off


def read_color_table(d, off):
    seed, flags, count = struct.unpack_from(">IHH", d, off); off += 8
    pal = [(0, 0, 0)] * 256
    n = (count + 1) if count < 256 else 256
    for _ in range(n):
        idx, r, g, b = struct.unpack_from(">HHHH", d, off); off += 8
        if 0 <= idx < 256:
            pal[idx] = (r >> 8, g >> 8, b >> 8)
    if os.environ.get("PICT_DBG"):
        nz = sum(1 for c in pal if c != (0, 0, 0))
        print("   clut seed=%d flags=%#x count=%d nonblack=%d sample=%s" % (
            seed, flags, count, nz, pal[1:5]))
    return pal, off


def decode(d, master_pal, trace=False):
    _picsize, top, left, bottom, right = struct.unpack_from(">Hhhhh", d, 0)
    off = 10
    cw, ch = right - left, bottom - top
    rgba = bytearray(b"\x00\x00\x00\x00" * (cw * ch))

    def blit(pm, pix, pal, stride):
        for y in range(pm["h"]):
            base = y * stride
            cy = pm["top"] - top + y
            if cy < 0 or cy >= ch:
                continue
            for x in range(pm["w"]):
                r, g, b = pal[pix[base + x]]
                cx = pm["left"] - left + x
                if 0 <= cx < cw:
                    di = (cy * cw + cx) * 4
                    rgba[di:di + 4] = bytes((r, g, b, 255))

    while off + 2 <= len(d):
        op = struct.unpack_from(">H", d, off)[0]; off += 2
        if trace and op != 0:
            print("  @%#06x op=%#06x" % (off - 2, op))
        if op == 0x0000:
            continue
        elif op == 0x0011:              # Version
            off += 2
        elif op == 0x0C00:              # HeaderOp
            off += 24
        elif op == 0x001E:              # DefHilite
            pass
        elif op == 0x0001:              # Clip region (u16 size includes itself)
            off += struct.unpack_from(">H", d, off)[0]
        elif op == 0x00A0:              # ShortComment
            off += 2
        elif op == 0x00A1:              # LongComment
            _kind, sz = struct.unpack_from(">HH", d, off); off += 4 + sz
        elif op in (0x0098, 0x0099, 0x009A, 0x009B):
            direct = op in (0x009A, 0x009B)
            if direct:
                off += 4                # baseAddr (DirectBits only)
            row_bytes = struct.unpack_from(">H", d, off)[0]; off += 2
            is_pixmap = bool(row_bytes & 0x8000)
            rb = row_bytes & 0x3FFF
            t, l, b2, r2 = struct.unpack_from(">hhhh", d, off); off += 8
            pm = {"rowBytes": rb, "top": t, "left": l, "w": r2 - l, "h": b2 - t}
            packType = 0
            if is_pixmap:
                (pmVersion, packType, packSize, hResF, vResF, pixelType, pixelSize,
                 cmpCount, cmpSize, planeBytes, pmTable, pmReserved) = \
                    struct.unpack_from(">HHIIIHHHHIII", d, off)
                off += 36               # size of the PixMap fields after bounds
            pal = master_pal
            if is_pixmap and not direct:
                pal, off = read_color_table(d, off)
            if trace:
                print("   pm %dx%d rb=%d pix=%d pack=%d palcolors=%s" % (
                    pm["w"], pm["h"], rb, (pixelSize if is_pixmap else 1), packType,
                    "master" if pal is master_pal else "embedded"))
            off += 8 + 8 + 2            # srcRect, dstRect, mode
            if op in (0x0099, 0x009B):  # region variant -> skip region
                off += struct.unpack_from(">H", d, off)[0]
            if direct:
                if trace: print("   (direct bits %dx%d skipped)" % (pm["w"], pm["h"]))
                continue
            pix = bytearray()
            if packType == 1 or rb < 8:
                for _ in range(pm["h"]):
                    pix += d[off:off + rb]; off += rb
            else:
                for _ in range(pm["h"]):
                    if rb > 250:
                        off += 2        # row byte count (u16)
                    else:
                        off += 1        # row byte count (u8)
                    row, off = unpackbits_row(d, off, rb)
                    pix += row
            if off & 1:
                off += 1            # opcodes resume on an even boundary
            blit(pm, pix, pal, rb)
        elif op == 0x00FF:              # EndOfPicture
            break
        else:
            if trace:
                print("   unknown op %#06x at %#06x - stopping" % (op, off - 2))
            break
    return cw, ch, bytes(rgba)


def main():
    res = parse_resource_fork(read_resource_fork(GFX))
    from sssf_decode import decode_palette
    master = decode_palette(res)
    args = sys.argv[1:]
    trace = "-t" in args
    ids = [int(a, 0) for a in args if a.lstrip("-").isdigit()]
    for p in res.get("PICT", []):
        if ids and p["id"] not in ids:
            continue
        name = (p.get("name", "") or ("pict_%d" % p["id"])).strip()
        safe = "".join(c if (c.isalnum() or c in "._-") else "_" for c in name)
        try:
            w, h, rgba = decode(p["data"], master, trace)
            write_png(OUT / ("%d_%s.png" % (p["id"], safe)), w, h, rgba)
            print("PICT %-5d %-26s -> %dx%d" % (p["id"], repr(name), w, h))
        except Exception as e:
            print("PICT %-5d %-26s FAILED: %s" % (p["id"], repr(name), e))


if __name__ == "__main__":
    main()
