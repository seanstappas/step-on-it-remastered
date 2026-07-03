#!/usr/bin/env python3
"""Copy the app's PowerPC PEF (the data fork) to bin/core_pef.bin for Ghidra.

Pure Python; runnable on Windows now. The PEF is the decompile target (MASTER_PLAN §2a).
"""
from __future__ import annotations

from pathlib import Path

SRC = Path("raw_game") / "Step On It\u2122" / "Step On It!\u2122"
OUT = Path("bin") / "core_pef.bin"


def main() -> None:
    data = SRC.read_bytes()
    if data[:8] != b"Joy!peff":
        raise SystemExit(f"not a PEF (magic={data[:8]!r}) at {SRC}")
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_bytes(data)
    print(f"wrote {OUT} ({len(data)} bytes, arch=ppc, magic={data[:8].decode()})")


if __name__ == "__main__":
    main()
