#!/usr/bin/env python3
"""Parse a PowerPC PEF container and list its sections and CFM imports.

Usage:
    python tools/parse_pef.py [bin/core_pef.bin]
"""
from __future__ import annotations

import struct
import sys
from pathlib import Path

DEFAULT = Path("raw_game") / "Step On It\u2122" / "Step On It!\u2122"
SECTION_KINDS = {0: "code", 1: "data", 2: "pidata", 3: "const", 4: "loader",
                 5: "debug", 6: "exec-in-place", 7: "exception", 8: "traceback"}


def cstr(buf: bytes, off: int) -> str:
    end = buf.index(b"\x00", off)
    return buf[off:end].decode("mac_roman", "replace")


def main() -> None:
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT
    data = path.read_bytes()
    assert data[:8] == b"Joy!peff", "not a PEF"
    arch = data[8:12].decode("ascii")
    section_count = struct.unpack_from(">H", data, 32)[0]
    print(f"PEF {path.name}: arch={arch} sections={section_count} size={len(data)}\n")

    loader_off = loader_size = None
    hdr = 40
    for i in range(section_count):
        base = hdr + i * 28
        (name_off, default_addr, total, unpacked, packed, cont_off) = struct.unpack_from(">iIIIII", data, base)
        kind = data[base + 24]
        kname = SECTION_KINDS.get(kind, str(kind))
        print(f"  section[{i}] kind={kname:7} total={total:7} packed={packed:7} off={cont_off}")
        if kind == 4:
            loader_off, loader_size = cont_off, packed

    if loader_off is None:
        print("\nNo loader section found.")
        return

    L = data[loader_off:loader_off + loader_size]
    (main_sec, main_off, init_sec, init_off, term_sec, term_off,
     imp_lib_count, imp_sym_count, reloc_sec_count, reloc_off,
     strings_off, export_hash_off, export_hash_pow, export_count) = struct.unpack_from(">iIiIiIIIIIIIII", L, 0)

    print(f"\nLoader: importedLibraries={imp_lib_count} importedSymbols={imp_sym_count} exports={export_count}")

    lib_table = 56
    sym_table = lib_table + imp_lib_count * 24
    print("\nCFM imported libraries & symbols:")
    for i in range(imp_lib_count):
        b = lib_table + i * 24
        name_off, old_v, cur_v, sym_count, first_sym = struct.unpack_from(">IIIII", L, b)
        lib_name = cstr(L, strings_off + name_off)
        print(f"\n  [{lib_name}] ({sym_count} symbols)")
        syms = []
        for s in range(first_sym, first_sym + sym_count):
            (val,) = struct.unpack_from(">I", L, sym_table + s * 4)
            sym_name_off = val & 0x00FFFFFF
            syms.append(cstr(L, strings_off + sym_name_off))
        for chunk_start in range(0, len(syms), 6):
            print("    " + ", ".join(syms[chunk_start:chunk_start + 6]))


if __name__ == "__main__":
    main()
