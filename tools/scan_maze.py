#!/usr/bin/env python3
"""Throwaway scan: find boards containing red(0x0D)/green(0x13)/blue(0x19)
blocks (the concentric-maze colors) and/or walker seeds (0x400 badguy bit with
low byte 0x10/0x11/0x12 -> FUN_10008618/8b18/90a4 block-laying walkers)."""
import struct, glob, os

ROWS, COLS = 19, 13
COLORS = {0x0D: "red", 0x13: "green", 0x19: "blue"}
WALKERS = {0x10, 0x11, 0x12}

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
    return grid

for p in sorted(glob.glob("extracted/levels/board_*.bord")):
    grid = parse(p)
    cols = {}
    walk = []
    for r in range(ROWS):
        for c in range(COLS):
            t = grid[r][c]
            if t == 0:
                continue
            lb = t & 0xFF
            if lb in COLORS and (t & 0x300):  # colored block (perm/supportive)
                cols[COLORS[lb]] = cols.get(COLORS[lb], 0) + 1
            if (t & 0x400) and lb in WALKERS:
                walk.append((r, c, lb))
    ncol = len(cols)
    if ncol >= 2 or walk:
        flag = "  <== ALL3" if ncol == 3 else ""
        print(f"{os.path.basename(p):20} colors={cols} walkers={walk}{flag}")
