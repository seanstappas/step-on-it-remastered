#!/usr/bin/env python3
"""Parse an oracle trace log (written by the SheepShaver PEF trampoline, §6.3)
into an analysis/fixtures/*.json fixture (MASTER_PLAN §6.4).

The trampoline writes one fixed big-endian record per logic tick (it runs on the
big-endian PPC). Record layout (v1) -- keep in sync with the trampoline:

    magic   u32   'SOI1'
    tick    u32   virtualized tick counter
    in_p1   u8    GetKeys input bitmask, player 1
    in_p2   u8    GetKeys input bitmask, player 2
    _pad    u16
    seed    i32   randSeed
    score   u32
    bonus   u16   bonus timer (counts down)
    ted_x   i16   screen px
    ted_y   i16   screen px
                        -> 24 bytes/record

Usage:
    python tools/trace_parse.py <trace.bin> [out.json] --seed N --tick0 T --level demo
"""
from __future__ import annotations

import json
import struct
import sys
from pathlib import Path

MAGIC = b"SOI1"
REC = ">4sIBBHiIHhh"          # 24 bytes
REC_SIZE = struct.calcsize(REC)


def parse(data: bytes) -> list[dict]:
    ticks = []
    for off in range(0, len(data) - REC_SIZE + 1, REC_SIZE):
        magic, tick, in_p1, in_p2, _pad, seed, score, bonus, tx, ty = struct.unpack_from(REC, data, off)
        if magic != MAGIC:
            raise ValueError("bad record magic at offset %d: %r" % (off, magic))
        ticks.append({
            "n": tick,
            "inputs": [in_p1, in_p2],
            "expected": {"globals": {
                "rand_seed": seed, "score": score, "bonus": bonus,
                "ted_x": tx, "ted_y": ty,
            }},
        })
    return ticks


def main() -> None:
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return
    src = Path(args[0])
    out = Path(args[1]) if len(args) > 1 and not args[1].startswith("-") else \
        Path("analysis") / "fixtures" / (src.stem + ".json")
    seed = int(args[args.index("--seed") + 1]) if "--seed" in args else 0
    level = args[args.index("--level") + 1] if "--level" in args else "demo"
    tick0 = int(args[args.index("--tick0") + 1]) if "--tick0" in args else 0

    ticks = parse(src.read_bytes())
    fixture = {
        # env is filled from the environment lock (MASTER_PLAN §8) before committing.
        "env": {"emulator": "SheepShaver <build>", "rom_sha256": "<FILL IN>",
                "os": "Mac OS 9.0.4", "speed": "Medium"},
        "level": level, "seed": seed, "tick0": tick0,
        "tolerance": {"default": 0},
        "units": {"ted_x": "px", "ted_y": "px"},
        "ticks": ticks,
    }
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(fixture, indent=2))
    print("parsed %d ticks -> %s" % (len(ticks), out))


if __name__ == "__main__":
    main()
