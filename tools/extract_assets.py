#!/usr/bin/env python3
"""extract_assets.py — one-command importer: original game folder -> port assets.

Turns the original "Step On It!" resources into the remaster's asset set:
  - levels:   BORD  -> extracted/levels/board_<id>.bord (raw) + .json (canonical)
  - palette:  clut  -> extracted/palette/palette.json (+ preview via decode_assets)
  - sprites:  sssf  -> extracted/sprites/ (frames that decode; via decode_assets)
  - sounds:   snd   -> inventory (WAV conversion needs resource_dasm, noted)
  - manifest: extracted/manifest.json  (MASTER_PLAN §7.2)

Point it at the game folder (default raw_game/Step On It™/) and it writes under
--out (default extracted/). Reuses tools/rezfork.py + the confirmed BORD format
(docs/original_game/bord-level-format.md) — so the BORD->JSON here also
cross-checks the C core's loader (core/src/soi_state.c).

Usage:
    python tools/extract_assets.py [--src "raw_game/Step On It\u2122"] [--out extracted]
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402
from snd_to_wav import snd_to_wav  # noqa: E402

# Bestiary index -> name (thrown_badguy is a nasty index; docs §gameplay).
BESTIARY = ["none", "Ant", "Ostrich", "Hippo", "Piggy", "Wheelie", "Smiley",
            "Hammer", "Beanie", "Robo", "Walker", "Teeth"]

GRID_COLS, GRID_ROWS = 19, 13


def be16(b: bytes, o: int) -> int:
    return (b[o] << 8) | b[o + 1]


def bord_to_json(board_id: int, d: bytes) -> dict:
    """Convert a raw BORD resource to the canonical level JSON (MASTER_PLAN §7.3)
    using the CONFIRMED header + tile format (docs BORD §3/§4a)."""
    if len(d) < 0x1A:
        return {"name": "Board %d" % board_id, "error": "too short"}

    bonus = be16(d, 0x16)
    if bonus == 0 or bonus == 0x3A20:
        bonus = 5000
    thrown = be16(d, 0x12)
    thrown_name = BESTIARY[thrown] if 0 <= thrown < len(BESTIARY) else str(thrown)

    # grid: fill from tile records (type stored per cell). row-major [row][col].
    cells = [[0] * GRID_COLS for _ in range(GRID_ROWS)]
    off = 0x18
    while off + 4 <= len(d):
        tile = struct.unpack_from(">I", d, off)[0]
        off += 4
        if tile == 0:
            break
        while off + 2 <= len(d):
            a, b = d[off], d[off + 1]
            off += 2
            if a == 100 or b == 100:       # (100,100) sentinel
                break
            if 0 <= b < GRID_ROWS and 0 <= a < GRID_COLS:  # a=col (X), b=row (Y)
                cells[b][a] = tile

    def prop(t: int) -> str:
        if t == 0:
            return "none"
        if (t & 0x100) or t == 0x300:
            return "permanent"
        return "supportive"

    grid_cells = [{"type": cells[r][c], "block": prop(cells[r][c])}
                  for r in range(GRID_ROWS) for c in range(GRID_COLS)]

    return {
        "name": "Board %d" % board_id,
        "bonus_time": bonus,
        "grid": {"w": GRID_COLS, "h": GRID_ROWS, "cells": grid_cells},
        "player_starts": [
            {"player": 1, "x": be16(d, 0x06), "y": be16(d, 0x08)},
            {"player": 2, "x": be16(d, 0x0A), "y": be16(d, 0x0C)},
        ],
        "challenge": {
            "percent_ultrabuster": be16(d, 0x10),
            "thrown_badguy": thrown_name,
            "percent_badguy": be16(d, 0x14),
        },
        # spawns are procedural in the original (no explicit records) — the core
        # generates them from `challenge` + RNG. (docs runtime-structures §4.)
        "spawns": [],
    }


def find_fork(src: Path, name: str) -> Path | None:
    """Locate a data file's resource fork (AppleDouble ._* sidecar)."""
    cand = [src / "__MACOSX" / ("._" + name), src / ("._" + name), src / name]
    for c in cand:
        if c.exists() and c.stat().st_size > 0:
            return c
    return None


def extract_levels(src: Path, out: Path, manifest: dict) -> None:
    fork = find_fork(src, "SOI Boards")
    if not fork:
        print("  ! SOI Boards fork not found; skipping levels")
        return
    res = parse_resource_fork(read_resource_fork(fork))
    boards = res.get("BORD", [])
    (out / "levels").mkdir(parents=True, exist_ok=True)
    n = 0
    for e in boards:
        bid, data = e["id"], e["data"]
        (out / "levels" / ("board_%d.bord" % bid)).write_bytes(data)
        js = bord_to_json(bid, data)
        (out / "levels" / ("board_%d.json" % bid)).write_text(json.dumps(js, indent=1))
        n += 1
    print("  levels: %d BORD -> .bord + canonical .json" % n)
    manifest["levels"] = {"count": n, "dir": "levels/"}


def extract_graphics(src: Path, out: Path, manifest: dict) -> None:
    fork = find_fork(src, "SOI Graphics")
    if not fork:
        print("  ! SOI Graphics fork not found; skipping palette/sprites")
        return
    res = parse_resource_fork(read_resource_fork(fork))
    cluts = res.get("clut", [])
    sssf = res.get("sssf", [])
    (out / "palette").mkdir(parents=True, exist_ok=True)
    # master palette = 'ss Super Palette v2' (id 1000) if present, else the first.
    master = next((e for e in cluts if e["id"] == 1000), cluts[0] if cluts else None)
    if master:
        pal = parse_clut(master["data"])
        (out / "palette" / "palette.json").write_text(json.dumps(pal))
        print("  palette: %d colours -> palette/palette.json" % len(pal))
        manifest["palette"] = {"colours": len(pal), "source_clut_id": master["id"]}
    manifest["sprites"] = {"sssf_count": len(sssf),
                           "note": "pixel RLE decode is partial (docs §sssf); use decode_assets.py for previews"}
    print("  sprites: %d sssf sheets catalogued (full RLE decode = TODO)" % len(sssf))


def parse_clut(d: bytes) -> list:
    """Standard Mac clut -> list of [r,g,b] (0-255)."""
    if len(d) < 8:
        return []
    count = struct.unpack_from(">H", d, 6)[0] + 1
    out = []
    off = 8
    for _ in range(count):
        if off + 8 > len(d):
            break
        _idx, r, g, b = struct.unpack_from(">HHHH", d, off)
        out.append([r >> 8, g >> 8, b >> 8])
        off += 8
    return out


def extract_sounds(src: Path, out: Path, manifest: dict) -> None:
    fork = find_fork(src, "SOI Sounds")
    if not fork:
        print("  ! SOI Sounds fork not found; skipping sounds")
        return
    res = parse_resource_fork(read_resource_fork(fork))
    snds = res.get("snd ", [])
    (out / "audio" / "wav").mkdir(parents=True, exist_ok=True)
    inv = []
    converted = 0
    for e in snds:
        rec = {"id": e["id"], "name": e.get("name", ""), "bytes": len(e["data"])}
        wav = snd_to_wav(e["data"])
        if wav:
            safe = "".join(c if (c.isalnum() or c in " _-") else "_" for c in e.get("name", "")).strip()
            fname = ("%d_%s.wav" % (e["id"], safe)).replace(" ", "_") if safe else ("%d.wav" % e["id"])
            (out / "audio" / "wav" / fname).write_bytes(wav)
            rec["wav"] = "wav/" + fname
            converted += 1
        inv.append(rec)
    (out / "audio").mkdir(parents=True, exist_ok=True)
    (out / "audio" / "snd_inventory.json").write_text(json.dumps(inv, indent=1))
    print("  sounds: %d snd resources catalogued, %d converted -> audio/wav/*.wav" % (len(inv), converted))
    manifest["sounds"] = {"count": len(snds), "converted": converted, "wav_dir": "audio/wav"}


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default="raw_game/Step On It\u2122")
    ap.add_argument("--out", default="extracted")
    a = ap.parse_args()
    src, out = Path(a.src), Path(a.out)
    if not src.exists():
        raise SystemExit("source folder not found: %s" % src)
    out.mkdir(parents=True, exist_ok=True)

    print("Importing from %s -> %s" % (src, out))
    manifest = {"source": str(src), "generated_at": datetime.now(timezone.utc).isoformat()}
    extract_levels(src, out, manifest)
    extract_graphics(src, out, manifest)
    extract_sounds(src, out, manifest)
    (out / "manifest.json").write_text(json.dumps(manifest, indent=1))
    print("manifest -> %s" % (out / "manifest.json"))


if __name__ == "__main__":
    main()
