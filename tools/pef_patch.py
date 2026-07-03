#!/usr/bin/env python3
"""PEF patching scaffolding for the SheepShaver tracing oracle (MASTER_PLAN §6.3).

Parses the PowerPC PEF container (sections + loader/relocations) and provides the
framework to inject an end-of-tick trampoline that logs globals via Toolbox FSWrite.
The trampoline machine code + the exact hook site come from the Phase-1 Ghidra
discovery pass; those spots are marked TODO.

Usage:
    python tools/pef_patch.py --info [bin/core_pef.bin]     # dump sections/loader
    python tools/pef_patch.py --recon                        # locate FSWrite + hook + slack
    python tools/pef_patch.py --plan <hook_addr_hex>         # print the patch plan
"""
from __future__ import annotations

import struct
import sys
from dataclasses import dataclass
from pathlib import Path

DEFAULT = Path("bin") / "core_pef.bin"
SECTION_KINDS = {0: "code", 1: "data", 2: "pidata", 3: "const", 4: "loader",
                 5: "debug", 6: "exec-in-place", 7: "exception", 8: "traceback"}


@dataclass
class Section:
    index: int
    name_off: int
    default_addr: int
    total: int
    unpacked: int
    packed: int
    cont_off: int
    kind: int

    @property
    def kind_name(self) -> str:
        return SECTION_KINDS.get(self.kind, str(self.kind))


class Pef:
    def __init__(self, data: bytes):
        if data[:8] != b"Joy!peff":
            raise ValueError("not a PEF")
        self.data = data
        self.arch = data[8:12].decode("ascii")
        self.section_count = struct.unpack_from(">H", data, 32)[0]
        self.sections = []
        for i in range(self.section_count):
            b = 40 + i * 28
            name_off, default_addr, total, unpacked, packed, cont_off = struct.unpack_from(">iIIIII", data, b)
            self.sections.append(Section(i, name_off, default_addr, total, unpacked, packed, cont_off, data[b + 24]))

    def loader(self) -> Section | None:
        return next((s for s in self.sections if s.kind == 4), None)

    def loader_header(self) -> dict:
        s = self.loader()
        if s is None:
            return {}
        L = self.data[s.cont_off:s.cont_off + s.packed]
        (main_sec, main_off, init_sec, init_off, term_sec, term_off,
         imp_lib_count, imp_sym_count, reloc_sec_count, reloc_off,
         strings_off, export_hash_off, export_hash_pow, export_count) = struct.unpack_from(">iIiIiIIIIIIIII", L, 0)
        return {
            "imported_libraries": imp_lib_count, "imported_symbols": imp_sym_count,
            "reloc_sections": reloc_sec_count, "reloc_instr_off": reloc_off,
            "strings_off": strings_off, "exports": export_count,
            "main": (main_sec, main_off), "init": (init_sec, init_off),
        }

    def _lstr(self, L: bytes, base: int, off: int) -> str:
        p = base + off
        end = L.find(b"\x00", p)
        return L[p:end if end >= 0 else len(L)].decode("mac-roman", "replace")

    def imports(self):
        """Return (libraries, symbols) with names resolved. Each symbol is
        (index, class, name) — index is the import-table index used by glue."""
        s = self.loader()
        if s is None:
            return [], []
        L = self.data[s.cont_off:s.cont_off + s.packed]
        h = self.loader_header()
        strings = h["strings_off"]
        lib_tab = 0x38                                   # loader header size
        libs = []
        for i in range(h["imported_libraries"]):
            off = lib_tab + i * 24
            name_off, _oldv, _curv, sym_count, first_sym = struct.unpack_from(">IIIII", L, off)
            libs.append({"name": self._lstr(L, strings, name_off),
                         "sym_count": sym_count, "first_sym": first_sym})
        sym_tab = lib_tab + h["imported_libraries"] * 24
        syms = []
        for i in range(h["imported_symbols"]):
            val, = struct.unpack_from(">I", L, sym_tab + i * 4)
            cls = (val >> 24) & 0xFF
            noff = val & 0xFFFFFF
            syms.append((i, cls, self._lstr(L, strings, noff)))
        return libs, syms

    def code_slack(self):
        """Trailing zero padding at the end of the code section (space we can
        reuse for a small trampoline without growing the file)."""
        code = next((s for s in self.sections if s.kind == 0), None)
        if code is None:
            return None
        blob = self.data[code.cont_off:code.cont_off + code.packed]
        n = 0
        while n < len(blob) and blob[len(blob) - 1 - n] == 0:
            n += 1
        return {"code_off": code.cont_off, "code_len": code.packed, "trailing_zero_bytes": n}


def cmd_recon(pef: Pef) -> None:
    """De-risk the trampoline patch: locate FSWrite + related I/O imports, the
    once-per-frame hook candidate, and injectable code slack."""
    libs, syms = pef.imports()
    print("Imported libraries:")
    for lb in libs:
        print("  %-14s syms=%d first=%d" % (lb["name"], lb["sym_count"], lb["first_sym"]))
    want = ("FSWrite", "FSRead", "FSpCreate", "FSpOpenDF", "SetFPos", "FSClose", "Create")
    print("I/O imports for the trace log:")
    for idx, cls, name in syms:
        if name in want:
            print("  [%3d] class=%d  %s" % (idx, cls, name))
    slack = pef.code_slack()
    print("Code slack (reuse for trampoline): %s" % slack)
    print("Suggested end-of-frame hook (from RE, docs runtime-structures §1):")
    print("  FUN_100193c8 @ 0x100193c8 — re-arms the Time-Manager frame timer,")
    print("  called exactly ONCE PER FRAME right after the frame-sync wait. Ideal")
    print("  single per-tick logging point. (Alt: the game-loop body FUN_10029264 /")
    print("  FUN_1002a308.)  Addresses are PEF-relative to load base 0x10000000.")


def cmd_info(pef: Pef) -> None:
    print("PEF arch=%s sections=%d size=%d" % (pef.arch, pef.section_count, len(pef.data)))
    for s in pef.sections:
        print("  [%d] %-8s default=%#010x total=%7d packed=%7d off=%d"
              % (s.index, s.kind_name, s.default_addr, s.total, s.packed, s.cont_off))
    print("loader:", pef.loader_header())


def cmd_plan(pef: Pef, hook_addr: int) -> None:
    code = next((s for s in pef.sections if s.kind == 0), None)
    print("Patch plan for end-of-tick hook @ %#x:" % hook_addr)
    print("  1. Reserve space for the trampoline:")
    print("     - append a new code region, OR reuse padding at the end of the code section")
    print("       (code section: default=%#x size=%d)" % (code.default_addr if code else 0,
                                                          code.total if code else 0))
    print("  2. Assemble a PPC trampoline that: saves regs -> pushes the minimal-global")
    print("     addresses (randSeed, tick, score, bonus, ted_x/y) -> calls FSWrite to the")
    print("     trace file -> restores regs -> executes the overwritten instruction -> returns.")
    print("  3. Overwrite the instruction at the hook site with a branch to the trampoline.")
    print("  4. Fix affected loader RELOCATIONS so the moved/added code relocates correctly")
    print("     (loader: %s)." % pef.loader_header())
    print("  5. Re-emit the PEF; run under SheepShaver on the seed-patched demo; parse the log")
    print("     with tools/trace_parse.py into an analysis/fixtures/*.json fixture (§6.4).")
    print("\n  TODO (from Ghidra): the trampoline machine code, the exact hook instruction to")
    print("  overwrite, and the global addresses to log.")


def main() -> None:
    args = sys.argv[1:]
    path = DEFAULT
    pef = Pef(path.read_bytes())
    if "--info" in args:
        cmd_info(pef)
    elif "--recon" in args:
        cmd_recon(pef)
    elif "--plan" in args:
        cmd_plan(pef, int(args[args.index("--plan") + 1], 16))
    else:
        print(__doc__)


if __name__ == "__main__":
    main()
