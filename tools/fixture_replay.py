#!/usr/bin/env python3
"""fixture_replay.py — drive the C core via ctypes to record/replay fixtures.

This is the oracle *consumer* side (MASTER_PLAN §5.5/§6.4): it loads the built
`soi_core` shared library, replays a fixture's per-tick input stream, and diffs
the core's logical state against the fixture's `expected` values, reporting the
first mismatching tick. The fixture *producer* (the emulator trace) is separate
(tools/pef_patch.py + trace_parse.py); until that exists, `--record` writes a
self-fixture from the core itself so the replay path is testable today.

Usage:
    python tools/fixture_replay.py --lib soi_core.dll --bord extracted/levels/board_401.bord \\
        --record out.json --ticks 300 --seed 1
    python tools/fixture_replay.py --lib soi_core.dll --bord <board> --replay out.json
    python tools/fixture_replay.py --selftest        # record+replay, assert PASS
"""
from __future__ import annotations

import argparse
import ctypes
import json
import sys
import tempfile
from pathlib import Path

# A tiny scripted input pattern (P1 walks right, occasionally acts). Pure
# convenience for --record; a real fixture carries the ground-truth inputs.
SOI_IN_RIGHT = 1 << 3
SOI_IN_ACTION = 1 << 4


def load_core(lib_path: str) -> ctypes.CDLL:
    lib = ctypes.CDLL(str(Path(lib_path).resolve()))
    lib.soi_world_size.restype = ctypes.c_size_t
    lib.soi_world_init.argtypes = [ctypes.c_void_p, ctypes.c_uint32]
    lib.soi_set_seed.argtypes = [ctypes.c_void_p, ctypes.c_uint32]
    lib.soi_load_level.argtypes = [ctypes.c_void_p, ctypes.c_char_p, ctypes.c_size_t]
    lib.soi_load_level.restype = ctypes.c_int
    lib.soi_tick.argtypes = [ctypes.c_void_p, ctypes.c_uint8, ctypes.c_uint8]
    for fn in ("soi_player_score", "soi_player_x", "soi_player_y",
               "soi_player_lives", "soi_player_alive"):
        getattr(lib, fn).argtypes = [ctypes.c_void_p, ctypes.c_int]
        getattr(lib, fn).restype = ctypes.c_int32
    lib.soi_bonus_time.argtypes = [ctypes.c_void_p]
    lib.soi_bonus_time.restype = ctypes.c_int
    lib.soi_tick_count.argtypes = [ctypes.c_void_p]
    lib.soi_tick_count.restype = ctypes.c_uint32
    lib.soi_enemy_count.argtypes = [ctypes.c_void_p]
    lib.soi_enemy_count.restype = ctypes.c_int
    lib.soi_state_hash.argtypes = [ctypes.c_void_p]
    lib.soi_state_hash.restype = ctypes.c_uint64
    return lib


class World:
    def __init__(self, lib: ctypes.CDLL, seed: int):
        self.lib = lib
        self.buf = ctypes.create_string_buffer(lib.soi_world_size())
        self.p = ctypes.cast(self.buf, ctypes.c_void_p)
        lib.soi_world_init(self.p, seed)

    def load(self, bord: bytes) -> bool:
        return bool(self.lib.soi_load_level(self.p, bord, len(bord)))

    def tick(self, p1: int, p2: int):
        self.lib.soi_tick(self.p, p1 & 0xFF, p2 & 0xFF)

    def globals(self) -> dict:
        L = self.lib
        return {
            "ted_x": L.soi_player_x(self.p, 1), "ted_y": L.soi_player_y(self.p, 1),
            "score": L.soi_player_score(self.p, 1), "bonus": L.soi_bonus_time(self.p),
            "enemies": L.soi_enemy_count(self.p),
        }

    def hash(self) -> int:
        return int(self.lib.soi_state_hash(self.p))


def record(lib, bord: bytes, seed: int, nticks: int) -> dict:
    w = World(lib, seed)
    if bord and not w.load(bord):
        raise SystemExit("load_level failed")
    ticks = []
    for n in range(nticks):
        p1 = SOI_IN_RIGHT | (SOI_IN_ACTION if n % 13 == 0 else 0)
        w.tick(p1, 0)
        ticks.append({"n": n, "inputs": [p1, 0], "expected": {"globals": w.globals()}})
    return {"seed": seed, "final_hash": "0x%016x" % w.hash(), "ticks": ticks}


def replay(lib, bord: bytes, fx: dict) -> int:
    w = World(lib, int(fx.get("seed", 1)))
    if bord and not w.load(bord):
        raise SystemExit("load_level failed")
    mismatches = 0
    for t in fx["ticks"]:
        p1, p2 = t["inputs"]
        w.tick(p1, p2)
        exp = t.get("expected", {}).get("globals")
        if not exp:
            continue
        got = w.globals()
        diff = {k: (exp[k], got.get(k)) for k in exp if got.get(k) != exp[k]}
        if diff:
            mismatches += 1
            if mismatches <= 5:
                print("  tick %d MISMATCH: %s" % (t["n"], diff))
    fh = fx.get("final_hash")
    if fh is not None:
        ok = (int(fh, 16) == w.hash())
        print("  final hash %s (fixture %s)" % ("MATCH" if ok else "MISMATCH", fh))
        if not ok:
            mismatches += 1
    return mismatches


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--lib", default="soi_core.dll")
    ap.add_argument("--bord")
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--ticks", type=int, default=300)
    ap.add_argument("--record")
    ap.add_argument("--replay")
    ap.add_argument("--selftest", action="store_true")
    a = ap.parse_args()

    lib = load_core(a.lib)
    bord = Path(a.bord).read_bytes() if a.bord else b""

    if a.selftest:
        fx = record(lib, bord, a.seed, min(a.ticks, 300))
        m = replay(lib, bord, fx)
        print("SELFTEST: %s (%d mismatches)" % ("PASS" if m == 0 else "FAIL", m))
        sys.exit(0 if m == 0 else 1)
    if a.record:
        fx = record(lib, bord, a.seed, a.ticks)
        Path(a.record).write_text(json.dumps(fx, indent=1))
        print("recorded %d ticks -> %s (final hash %s)" % (len(fx["ticks"]), a.record, fx["final_hash"]))
    elif a.replay:
        fx = json.loads(Path(a.replay).read_text())
        m = replay(lib, bord, fx)
        print("REPLAY: %s (%d mismatches)" % ("PASS" if m == 0 else "FAIL", m))
        sys.exit(0 if m == 0 else 1)
    else:
        ap.print_help()


if __name__ == "__main__":
    main()
