#!/usr/bin/env python3
"""Dump a BORD file's tile grid as a type-id map, to correlate tile types with
the original game's rendered sprites (white block / red block / red ball / coin
/ key / etc.). Grid is 19 rows x 13 cols; loader stores type at [row][col]."""
import sys, struct, glob, os

ROWS, COLS = 19, 13

def parse(path):
    b = open(path, "rb").read()
    grid = [[0] * COLS for _ in range(ROWS)]
    off = 0x18
    while off + 4 <= len(b):
        tile = struct.unpack_from(">I", b, off)[0]
        off += 4
        if tile == 0:
            break
        while off + 2 <= len(b):
            a, c = b[off], b[off + 1]
            off += 2
            if a == 100 or c == 100:
                break
            if 0 <= a < ROWS and 0 <= c < COLS:
                grid[a][c] = tile
    return grid, b

def show(path):
    grid, b = parse(path)
    p1 = struct.unpack_from(">HH", b, 0x06)  # col,row
    types = set()
    print(f"== {os.path.basename(path)}  P1start(col,row)={p1} ==")
    for r in range(ROWS):
        row = ""
        for c in range(COLS):
            t = grid[r][c]
            types.add(t)
            row += " . " if t == 0 else f"{t:2X} "
        print(row)
    print("types:", sorted(types))

if __name__ == "__main__":
    if len(sys.argv) > 1:
        for p in sys.argv[1:]:
            show(p); print()
    else:
        for p in sorted(glob.glob("extracted/levels/*.bord")):
            show(p); print()
