#!/usr/bin/env python3
"""Tile the exported PNG frames of one sprite folder into a single contact sheet
for quick visual identification."""
import sys, struct, zlib
from pathlib import Path

def read_png(p: Path):
    d = p.read_bytes(); assert d[:8] == b"\x89PNG\r\n\x1a\n"
    i = 8; w = h = 0; idat = b""
    while i < len(d):
        ln = struct.unpack_from(">I", d, i)[0]; typ = d[i+4:i+8]; body = d[i+8:i+8+ln]
        if typ == b"IHDR": w, h = struct.unpack_from(">II", body, 0)
        elif typ == b"IDAT": idat += body
        elif typ == b"IEND": break
        i += 12 + ln
    raw = zlib.decompress(idat); px = bytearray(); stride = w*4
    for y in range(h):
        f = raw[y*(stride+1)]; assert f == 0
        px += raw[y*(stride+1)+1:y*(stride+1)+1+stride]
    return w, h, px

def write_png(path: Path, w, h, px):
    def chunk(t, dt):
        c = t+dt; return struct.pack(">I", len(dt))+c+struct.pack(">I", zlib.crc32(c)&0xFFFFFFFF)
    rows = b"".join(b"\x00"+bytes(px[y*w*4:(y+1)*w*4]) for y in range(h))
    path.write_bytes(b"\x89PNG\r\n\x1a\n"+chunk(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0))
                     +chunk(b"IDAT", zlib.compress(rows, 9))+chunk(b"IEND", b""))

def main():
    folder = Path(sys.argv[1]); cols = int(sys.argv[2]) if len(sys.argv) > 2 else 12
    cell = int(sys.argv[3]) if len(sys.argv) > 3 else 40
    files = sorted(folder.glob("f*.png"))
    rows_n = (len(files)+cols-1)//cols
    W, H = cols*cell, rows_n*cell
    out = bytearray(b"\x20\x20\x20\xff"*(W*H))  # dark grey bg
    for k, f in enumerate(files):
        w, h, px = read_png(f)
        ox = (k % cols)*cell + max(0, (cell-w)//2); oy = (k//cols)*cell + max(0, (cell-h)//2)
        for y in range(min(h, cell)):
            for x in range(min(w, cell)):
                a = px[(y*w+x)*4+3]
                if a:
                    di = ((oy+y)*W + (ox+x))*4
                    out[di:di+4] = px[(y*w+x)*4:(y*w+x)*4+4]
    dest = folder.parent / ("_sheet_%s.png" % folder.name)
    write_png(dest, W, H, out)
    print("wrote", dest, "%dx%d" % (W, H), len(files), "frames")

if __name__ == "__main__":
    main()
