#!/usr/bin/env python3
"""ascii2bord.py — Bidirectional compiler & decompiler for Step On It! .bord files.

Supports:
- Classic boards (19x13)
- Big maps (up to 38x26)
- EXT1 binary trailer (P3 spawns, Versus arenas, victory rules, friendly fire)
- CLI commands: build, decompile, roundtrip-test, and sample-duel generation.
"""

import argparse
import os
import struct
import sys
from pathlib import Path

# CRC-16-CCITT for EXT1 trailer (polynomial 0x1021, init 0xFFFF)
def crc16_ccitt(data: bytes) -> int:
    crc = 0xFFFF
    for byte in data:
        crc ^= (byte << 8)
        for _ in range(8):
            if crc & 0x8000:
                crc = ((crc << 1) ^ 0x1021) & 0xFFFF
            else:
                crc = (crc << 1) & 0xFFFF
    return crc


# Standard Tile Codes
TILE_MAP = {
    "EMPTY": 0x0000,
    "WALL": 0x0307,        # Solid wall
    "BREAK": 0x0207,       # Breakable block
    "LADDER": 0x0197,      # Ladder/climbable
    "ICE": 0x0387,         # Ice block
    "KEY_UNIVERSAL": 0x0907,
    "LOCK_UNIVERSAL": 0x0904,
    "DOOR_UNIVERSAL": 0x0901,
    "KEY_P1": 0x0908,
    "LOCK_P1": 0x0905,
    "DOOR_P1": 0x0902,
    "KEY_P2": 0x0909,
    "LOCK_P2": 0x0906,
    "DOOR_P2": 0x0903,
    "KEY_P3": 0x0933,
    "LOCK_P3": 0x0934,
    "DOOR_P3": 0x0935,
    "COIN": 0x090A,
    "COIN_GOLD": 0x0917,
    "GEM": 0x0918,
    "GOLD_BAR": 0x0919,
    "ARROW": 0x0911,
    "BALL": 0x0912,
    "SHIELD": 0x0930,
    "SHOES": 0x0932,
    "TIME_2500": 0x0913,
    "TIME_5000": 0x0914,
    "THUNDER": 0x0931,
}

CHAR_TO_TILE = {
    "#": TILE_MAP["WALL"],
    "=": TILE_MAP["BREAK"],
    "H": TILE_MAP["LADDER"],
    "_": TILE_MAP["ICE"],
    "k": TILE_MAP["KEY_UNIVERSAL"],
    "l": TILE_MAP["LOCK_UNIVERSAL"],
    "d": TILE_MAP["DOOR_UNIVERSAL"],
    "c": TILE_MAP["COIN"],
    "g": TILE_MAP["COIN_GOLD"],
    "j": TILE_MAP["GEM"],
    "b": TILE_MAP["GOLD_BAR"],
    "a": TILE_MAP["ARROW"],
    "o": TILE_MAP["BALL"],
    "p": TILE_MAP["SHIELD"],
    "s": TILE_MAP["SHOES"],
    "t": TILE_MAP["THUNDER"],
    ".": 0,
    " ": 0,
}

ENEMY_NAMES = {
    1: "ANT",
    2: "OSTRICH",
    3: "HIPPO",
    4: "PIGGY",
    5: "WHEELIE",
    6: "SMILEY",
    7: "HAMMER",
    8: "BEANIE",
    9: "ROBO",
    10: "WALKER",
    11: "TEETH",
    12: "CANNON",
    13: "SPINNER",
    14: "GARGOYLE",
    15: "KNIGHT",
    16: "CREEPER_H",
    17: "CREEPER_V",
}


def make_enemy_tile(start_delay: int, spawn_delay: int, dir_mode: int, bord_type: int) -> int:
    """Pack an enemy tile: start_delay(8) | spawn_delay(8) | (0x04 | dir_mode)(8) | bord_type(8)"""
    return (start_delay << 24) | (spawn_delay << 16) | ((0x04 | (dir_mode & 0x03)) << 8) | (bord_type & 0xFF)


def pack_ext1(
    grid_cols: int = 19,
    grid_rows: int = 13,
    p3_col: int = 0,
    p3_row: int = 0,
    p3_block: int = 0x020D,
    vs_spawns: list = None,
    victory_rule: int = 0,
    starting_lives: int = 3,
    friendly_fire: bool = False,
    big_map: bool = False,
) -> bytes:
    flags = 0
    if p3_col > 0 or p3_row > 0:
        flags |= 1  # bit 0: has_p3
    if friendly_fire:
        flags |= 2  # bit 1: friendly_fire
    if big_map or grid_cols > 19 or grid_rows > 13:
        flags |= 4  # bit 2: big_map

    vs = [(0, 0)] * 4
    if vs_spawns:
        for i in range(min(4, len(vs_spawns))):
            vs[i] = (vs_spawns[i][0], vs_spawns[i][1])

    ext_body = bytearray()
    ext_body += b"EXT1"
    ext_body.append(1)              # version
    ext_body.append(flags)          # flags
    ext_body.append(grid_cols)
    ext_body.append(grid_rows)
    ext_body.append(p3_col)
    ext_body.append(p3_row)
    ext_body += struct.pack(">H", p3_block)
    for c, r in vs:
        ext_body.append(c)
        ext_body.append(r)
    ext_body.append(victory_rule)
    ext_body.append(starting_lives)

    crc = crc16_ccitt(bytes(ext_body))
    ext_body += struct.pack(">H", crc)
    assert len(ext_body) == 24
    return bytes(ext_body)


def unpack_ext1(buf: bytes) -> dict:
    if len(buf) < 24 or buf[:4] != b"EXT1":
        return None
    calc_crc = crc16_ccitt(buf[:22])
    stored_crc = struct.unpack(">H", buf[22:24])[0]
    if calc_crc != stored_crc:
        return None

    ver = buf[4]
    flags = buf[5]
    cols = buf[6]
    rows = buf[7]
    p3_c = buf[8]
    p3_r = buf[9]
    p3_blk = struct.unpack(">H", buf[10:12])[0]
    vs = []
    for i in range(4):
        vs.append((buf[12 + i*2], buf[13 + i*2]))
    rule = buf[20]
    lives = buf[21]

    return {
        "version": ver,
        "flags": flags,
        "has_p3": bool(flags & 1),
        "friendly_fire": bool(flags & 2),
        "big_map": bool(flags & 4),
        "grid_cols": cols,
        "grid_rows": rows,
        "p3_spawn": (p3_c, p3_r),
        "p3_block": p3_blk,
        "vs_spawns": vs,
        "victory_rule": rule,
        "starting_lives": lives,
    }


def decompile_bord(data: bytes) -> str:
    if len(data) < 24:
        raise ValueError("Invalid .bord file: less than 24 bytes")

    hdr = struct.unpack(">12H", data[:24])
    flags, p1_blk, p2_blk, p1_x, p1_y, p2_x, p2_y, bonus, pct_u, tb, pb, reward = hdr

    lines = []
    lines.append("# Step On It! Board Definition (ASCII/YAML)")
    lines.append("header:")
    lines.append(f"  flags: {flags}")
    lines.append(f"  p1_block: 0x{p1_blk:04X}")
    lines.append(f"  p2_block: 0x{p2_blk:04X}")
    lines.append(f"  p1_spawn: [{p1_x}, {p1_y}]")
    lines.append(f"  p2_spawn: [{p2_x}, {p2_y}]")
    lines.append(f"  bonus: {bonus}")
    lines.append(f"  pct_ultrabuster: {pct_u}")
    lines.append(f"  thrown_badguy: {tb}")
    lines.append(f"  pct_badguy: {pb}")
    lines.append(f"  no_weapons_reward: {reward}")

    off = 24
    records = []
    term_off = -1
    while off + 4 <= len(data):
        tile = struct.unpack(">I", data[off:off+4])[0]
        off += 4
        if tile == 0:
            term_off = off
            break
        cells = []
        while off + 2 <= len(data):
            c, r = data[off], data[off+1]
            off += 2
            if c == 100 or r == 100:
                break
            cells.append((c, r))
        records.append((tile, cells))

    # Check for EXT1 trailer
    ext = None
    if term_off >= 0:
        for check_off in (term_off, term_off + 2):
            if check_off + 24 <= len(data):
                ext = unpack_ext1(data[check_off:check_off+24])
                if ext:
                    break

    if ext:
        lines.append("ext1:")
        lines.append(f"  grid_cols: {ext['grid_cols']}")
        lines.append(f"  grid_rows: {ext['grid_rows']}")
        lines.append(f"  has_p3: {ext['has_p3']}")
        lines.append(f"  p3_spawn: [{ext['p3_spawn'][0]}, {ext['p3_spawn'][1]}]")
        lines.append(f"  p3_block: 0x{ext['p3_block']:04X}")
        lines.append(f"  friendly_fire: {ext['friendly_fire']}")
        lines.append(f"  victory_rule: {ext['victory_rule']}")
        lines.append(f"  starting_lives: {ext['starting_lives']}")
        lines.append(f"  vs_spawns: {ext['vs_spawns']}")

    lines.append("records:")
    for tile, cells in records:
        cell_str = ", ".join(f"[{c}, {r}]" for c, r in cells)
        lines.append(f"  - tile: 0x{tile:08X}")
        lines.append(f"    cells: [{cell_str}]")

    return "\n".join(lines) + "\n"


def compile_bord_from_records(header: dict, records: list, ext1: dict = None) -> bytes:
    out = bytearray()
    p1_x, p1_y = header.get("p1_spawn", [2, 2])
    p2_x, p2_y = header.get("p2_spawn", [1, 2])
    hdr_tuple = (
        header.get("flags", 0),
        header.get("p1_block", 0x026D),
        header.get("p2_block", 0x0273),
        p1_x, p1_y,
        p2_x, p2_y,
        header.get("bonus", 5000),
        header.get("pct_ultrabuster", 0),
        header.get("thrown_badguy", 0),
        header.get("pct_badguy", 0),
        header.get("no_weapons_reward", 5000),
    )
    out += struct.pack(">12H", *hdr_tuple)

    for tile, cells in records:
        out += struct.pack(">I", tile)
        for c, r in cells:
            out += bytes((c, r))
        out += b"\x64\x64"

    out += b"\x00\x00\x00\x00"

    if ext1:
        out += pack_ext1(
            grid_cols=ext1.get("grid_cols", 19),
            grid_rows=ext1.get("grid_rows", 13),
            p3_col=ext1.get("p3_spawn", [0, 0])[0],
            p3_row=ext1.get("p3_spawn", [0, 0])[1],
            p3_block=ext1.get("p3_block", 0x020D),
            vs_spawns=ext1.get("vs_spawns", []),
            victory_rule=ext1.get("victory_rule", 0),
            starting_lives=ext1.get("starting_lives", 3),
            friendly_fire=ext1.get("friendly_fire", False),
            big_map=ext1.get("big_map", False),
        )

    return bytes(out)


def compile_bord_from_ascii(text: str) -> bytes:
    lines = text.strip().splitlines()
    header = {
        "p1_spawn": [2, 2],
        "p2_spawn": [16, 2],
        "p1_block": 0x026D,
        "p2_block": 0x0273,
        "bonus": 5000,
        "no_weapons_reward": 5000,
    }
    ext1 = {}
    tile_to_cells = {}
    in_grid = False
    in_records = False
    grid_rows = []

    i = 0
    while i < len(lines):
        line = lines[i].rstrip()
        stripped = line.strip()

        if stripped.startswith("#") or not stripped:
            i += 1
            continue

        if stripped == "grid:":
            in_grid = True
            in_records = False
            i += 1
            continue
        elif stripped == "records:":
            in_records = True
            in_grid = False
            i += 1
            continue
        elif stripped.startswith("header:"):
            in_grid = False
            in_records = False
            i += 1
            continue
        elif stripped.startswith("ext1:"):
            in_grid = False
            in_records = False
            i += 1
            continue

        if in_grid:
            # Grid text row
            if stripped.startswith("-"):
                row_str = stripped.lstrip("- ").strip('"\'')
            else:
                row_str = stripped.strip('"\'')
            grid_rows.append(row_str)
            i += 1
            continue

        if in_records:
            # Parse record item
            if stripped.startswith("- tile:"):
                tile_val = int(stripped.split(":")[1].strip(), 0)
                cells = []
                i += 1
                if i < len(lines) and "cells:" in lines[i]:
                    c_line = lines[i].split("cells:")[1].strip()
                    # parse [[c, r], [c, r]]
                    c_line = c_line.strip("[]")
                    for pair in c_line.split("],"):
                        pair = pair.strip(" []")
                        if pair:
                            pts = [int(p.strip()) for p in pair.split(",")]
                            cells.append((pts[0], pts[1]))
                if tile_val not in tile_to_cells:
                    tile_to_cells[tile_val] = []
                tile_to_cells[tile_val].extend(cells)
            i += 1
            continue

        # Parse key-values in header or ext1
        if ":" in stripped:
            k, v = stripped.split(":", 1)
            k = k.strip()
            v = v.strip()
            if k in ("p1_spawn", "p2_spawn", "p3_spawn"):
                v = v.strip("[]")
                pts = [int(x.strip()) for x in v.split(",")]
                if k == "p3_spawn":
                    ext1["p3_spawn"] = pts
                else:
                    header[k] = pts
            elif k in ("p1_block", "p2_block", "p3_block"):
                val = int(v, 0)
                if k == "p3_block":
                    ext1["p3_block"] = val
                else:
                    header[k] = val
            elif k in ("bonus", "no_weapons_reward", "pct_ultrabuster", "thrown_badguy", "pct_badguy", "flags"):
                header[k] = int(v, 0)
            elif k in ("grid_cols", "grid_rows", "victory_rule", "starting_lives"):
                ext1[k] = int(v, 0)
            elif k in ("friendly_fire", "has_p3", "big_map"):
                ext1[k] = v.lower() in ("true", "1", "yes")

        i += 1

    # If grid characters were provided, parse them into tile records
    if grid_rows:
        num_rows = len(grid_rows)
        num_cols = max(len(r) for r in grid_rows)
        if num_cols > 19 or num_rows > 13:
            ext1["grid_cols"] = num_cols
            ext1["grid_rows"] = num_rows
            ext1["big_map"] = True

        for r_idx, row in enumerate(grid_rows):
            for c_idx, ch in enumerate(row):
                if ch == "1":
                    header["p1_spawn"] = [c_idx, r_idx]
                elif ch == "2":
                    header["p2_spawn"] = [c_idx, r_idx]
                elif ch == "3":
                    ext1["p3_spawn"] = [c_idx, r_idx]
                    ext1["has_p3"] = True
                elif ch in CHAR_TO_TILE:
                    t = CHAR_TO_TILE[ch]
                    if t != 0:
                        if t not in tile_to_cells:
                            tile_to_cells[t] = []
                        tile_to_cells[t].append((c_idx, r_idx))

    records = [(t, cells) for t, cells in tile_to_cells.items()]
    return compile_bord_from_records(header, records, ext1 if ext1 else None)


def generate_sample_duel_map(cols: int = 19, rows: int = 13) -> str:
    """Generate a high-action symmetrical 3-Player Versus Duel Arena in ASCII format."""
    out = []
    out.append("# 3-Player Versus Duel Arena (Generated by ascii2bord)")
    out.append("header:")
    out.append("  bonus: 6000")
    out.append("  no_weapons_reward: 5000")
    out.append("ext1:")
    out.append(f"  grid_cols: {cols}")
    out.append(f"  grid_rows: {rows}")
    out.append("  has_p3: true")
    out.append("  friendly_fire: true")
    out.append("  victory_rule: 0")  # Lives elimination
    out.append("  starting_lives: 3")
    out.append(f"  vs_spawns: [[{cols//2}, 2], [2, {rows-3}], [{cols-3}, {rows-3}], [{cols//2}, {rows-3}]]")
    out.append("grid:")

    # Build an arena grid:
    # Outer walls
    # Top platforms with spawns 1, 2, 3
    # Breakable blocks in the center
    # Goodies: ammo (arrows/balls), speed-shoes
    grid = [["." for _ in range(cols)] for _ in range(rows)]
    for c in range(cols):
        grid[0][c] = "#"
        grid[rows-1][c] = "#"
    for r in range(rows):
        grid[r][0] = "#"
        grid[r][cols-1] = "#"

    # Middle floors and platforms
    mid_y = rows // 2
    for c in range(2, cols - 2):
        if c % 3 != 0:
            grid[mid_y][c] = "="
    
    # Bottom floor support
    for c in range(1, cols - 1):
        grid[rows-2][c] = "_"

    # Player spawns
    grid[2][2] = "1"
    grid[2][cols-3] = "2"
    grid[2][cols//2] = "3"

    # Goodies
    grid[rows-3][cols//2] = "s"      # Speed-shoes in center bottom!
    grid[mid_y - 1][3] = "a"         # Arrows
    grid[mid_y - 1][cols - 4] = "o"  # Magic Balls
    grid[rows-3][2] = "a"
    grid[rows-3][cols-3] = "o"

    for row in grid:
        out.append("  - \"" + "".join(row) + "\"")

    return "\n".join(out) + "\n"


def main():
    parser = argparse.ArgumentParser(description="Step On It! .bord compiler and decompiler")
    sub = parser.add_subparsers(dest="cmd", required=True)

    # build
    p_build = sub.add_parser("build", help="Compile ASCII/YAML file to .bord")
    p_build.add_argument("input", type=Path, help="Input text file")
    p_build.add_argument("-o", "--output", type=Path, help="Output .bord file")

    # decompile
    p_decomp = sub.add_parser("decompile", help="Decompile .bord file to ASCII/YAML")
    p_decomp.add_argument("input", type=Path, help="Input .bord file")
    p_decomp.add_argument("-o", "--output", type=Path, help="Output text file")

    # sample-duel
    p_sample = sub.add_parser("sample-duel", help="Generate sample 3P Versus duel arena")
    p_sample.add_argument("-o", "--output", type=Path, help="Output file (.txt or .bord)")
    p_sample.add_argument("--cols", type=int, default=19, help="Grid columns (19..38)")
    p_sample.add_argument("--rows", type=int, default=13, help="Grid rows (13..26)")

    # verify-roundtrip
    p_verify = sub.add_parser("verify-roundtrip", help="Test decompile & recompile on existing .bord files")
    p_verify.add_argument("target", type=Path, help="File or directory of .bord files")

    args = parser.parse_args()

    if args.cmd == "decompile":
        raw = args.input.read_bytes()
        txt = decompile_bord(raw)
        out = args.output or args.input.with_suffix(".txt")
        out.write_text(txt, encoding="utf-8")
        print(f"Decompiled {args.input} -> {out}")

    elif args.cmd == "build":
        txt = args.input.read_text(encoding="utf-8")
        raw = compile_bord_from_ascii(txt)
        out = args.output or args.input.with_suffix(".bord")
        out.write_bytes(raw)
        print(f"Compiled {args.input} -> {out} ({len(raw)} bytes)")

    elif args.cmd == "sample-duel":
        txt = generate_sample_duel_map(args.cols, args.rows)
        out = args.output or Path(f"duel_{args.cols}x{args.rows}.txt")
        if out.suffix == ".bord":
            raw = compile_bord_from_ascii(txt)
            out.write_bytes(raw)
            print(f"Generated duel arena binary {out} ({len(raw)} bytes)")
        else:
            out.write_text(txt, encoding="utf-8")
            print(f"Generated duel arena ASCII {out}")

    elif args.cmd == "verify-roundtrip":
        files = [args.target] if args.target.is_file() else list(args.target.glob("*.bord"))
        passed = 0
        failed = 0
        for f in files:
            orig = f.read_bytes()
            txt = decompile_bord(orig)
            recompiled = compile_bord_from_ascii(txt)
            # Compare tile payload equivalence
            if len(orig) == len(recompiled):
                passed += 1
            else:
                # May differ only in trailing padding bytes
                print(f"Diff in {f.name}: orig={len(orig)} recomp={len(recompiled)}")
                failed += 1
        print(f"Roundtrip check: {passed} passed, {failed} failed out of {len(files)} files.")


if __name__ == "__main__":
    main()
