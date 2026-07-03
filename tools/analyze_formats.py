#!/usr/bin/env python3
"""Reverse-engineering recon for the open Step On It! resource formats.

Analyzes DMKY (demo key streams), clut (palette), and sssf (sprite sheets) by
pulling the raw resource bytes and printing structural hex/decodes.

Usage:  python tools/analyze_formats.py
"""
from __future__ import annotations

import os
import struct
import sys
from pathlib import Path

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from rezfork import read_resource_fork, parse_resource_fork  # noqa: E402

RAW = Path("raw_game") / "Step On It\u2122"
APP = RAW / "__MACOSX" / "._Step On It!\u2122"
GFX = RAW / "__MACOSX" / "._SOI Graphics"


def load(path: Path) -> dict:
    return parse_resource_fork(read_resource_fork(path))


def hexdump(data: bytes, start: int = 0, length: int = 128) -> None:
    end = min(len(data), start + length)
    for off in range(start, end, 16):
        chunk = data[off:off + 16]
        hexs = " ".join(f"{b:02X}" for b in chunk)
        text = "".join(chr(b) if 32 <= b < 127 else "." for b in chunk)
        print(f"    {off:04X}  {hexs:<47}  {text}")


def by_id(entries: list[dict], rid: int) -> dict | None:
    return next((e for e in entries if e["id"] == rid), None)


def analyze_dmky() -> None:
    print("\n" + "=" * 70 + "\n### DMKY (demo key streams) — from the app resource fork\n")
    res = load(APP)
    for e in res.get("DMKY", []):
        d = e["data"]
        print(f"DMKY id={e['id']} name={e['name']!r} len={len(d)}")
        hexdump(d, 0, 96)
        # Hypotheses: try (u16 count, then records) and byte-pair framing.
        if len(d) >= 4:
            print(f"    first u16s: {struct.unpack_from('>HHHH', d, 0)}")
        # Distribution of byte values (are they small key masks?).
        uniq = sorted(set(d))
        print(f"    distinct byte values: {len(uniq)}  min={uniq[0]} max={uniq[-1]}")
        print()


def analyze_clut() -> None:
    print("\n" + "=" * 70 + "\n### clut (palette) — 'ss Super Palette v2' from SOI Graphics\n")
    res = load(GFX)
    cluts = res.get("clut", [])
    for e in cluts:
        d = e["data"]
        if len(d) < 8:
            continue
        seed, flags, size = struct.unpack_from(">IHH", d, 0)
        n = size + 1
        print(f"clut id={e['id']} name={e['name']!r} len={len(d)} entries={n} flags={flags:#06x}")
        if e["name"].strip().startswith("ss Super Palette"):
            # Decode all ColorSpec entries: value(u16) + r,g,b (u16 each, hi byte = 8-bit).
            print("    first 8 colors (index -> #RRGGBB, from 16-bit channels):")
            for i in range(min(n, 8)):
                base = 8 + i * 8
                value, r, g, b = struct.unpack_from(">HHHH", d, base)
                print(f"      [{value:3}] #{r>>8:02X}{g>>8:02X}{b>>8:02X}")
            print(f"    ... {n} total entries (this is the master 256-color game palette)")
    print()


def analyze_sssf() -> None:
    print("\n" + "=" * 70 + "\n### sssf (custom sprite sheets) — from SOI Graphics\n")
    res = load(GFX)
    sssf = res.get("sssf", [])
    print(f"{len(sssf)} sssf resources. Header recon on a few named ones:\n")
    for want in ("blocks", "ant sprites", "weapons", "hippo sprites"):
        e = next((x for x in sssf if x["name"] == want), None)
        if not e:
            continue
        d = e["data"]
        print(f"sssf id={e['id']} name={e['name']!r} len={len(d)}")
        hexdump(d, 0, 64)
        # Candidate header words.
        if len(d) >= 12:
            print(f"    first u16s: {struct.unpack_from('>HHHHHH', d, 0)}")
        print()


if __name__ == "__main__":
    analyze_dmky()
    analyze_clut()
    analyze_sssf()
