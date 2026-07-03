# -*- coding: utf-8 -*-
# Ghidra headless: map the 7 input-bitmask booleans to actions by decompiling
# EVERY function and text-searching the C for the input-global addresses.
#
# PPC CFM globals are TOC-relative, so Ghidra records no cross-references to
# their absolute addresses (they appear as uRam1003aaXX in the decompiler). The
# only reliable finder is a full-program decompile + text grep.
#
# Run (from repo root):
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -processor PowerPC:BE:32:default \
#       -postScript input_map.py -scriptPath analysis/ghidra -deleteProject
import os

from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI

OUT = os.path.join(os.getcwd(), "analysis", "decomp")

# input booleans -> which key-byte bit set it (from FUN_10029ca0 unpack order)
INPUT_BOOLS = {
    "1003aa3e": "bit1(0x02)",
    "1003aa3f": "bit0(0x01)",
    "1003aa40": "bit2(0x04)",
    "1003aa41": "bit3(0x08)",
    "1003aa42": "bit4(0x10)",
    "1003aa43": "bit6(0x40)",
    "1003aa44": "bit5(0x20)",
}


def addr_str(a):
    return "0x%x" % a.getOffset()


def main():
    program = getCurrentProgram()  # noqa: F821
    monitor = ConsoleTaskMonitor()
    fm = program.getFunctionManager()

    try:
        os.makedirs(OUT)
    except OSError:
        pass

    decomp = DecompInterface()
    decomp.openProgram(program)

    readers = dict((k, []) for k in INPUT_BOOLS)
    matched_funcs = {}   # name -> set(hexaddr)
    n = 0
    for fn in fm.getFunctions(True):
        if fn.isExternal():
            continue
        res = decomp.decompileFunction(fn, 45, monitor)
        if res is None or not res.decompileCompleted():
            continue
        c = res.getDecompiledFunction().getC()
        name = fn.getName()
        hit = False
        for hexaddr in INPUT_BOOLS:
            if hexaddr in c:
                readers[hexaddr].append(name)
                matched_funcs.setdefault(name, set()).add(hexaddr)
                hit = True
        if hit:
            with open(os.path.join(OUT, "inp_%s_%s.c" % (name, addr_str(fn.getEntryPoint()))), "w") as fh:
                fh.write("/* %s @ %s */\n" % (name, addr_str(fn.getEntryPoint())))
                fh.write(c)
        n += 1

    print("[input] decompiled %d functions" % n)
    for hexaddr, tag in sorted(INPUT_BOOLS.items()):
        who = ", ".join(sorted(set(readers[hexaddr]))) or "(only writer)"
        print("[input] 0x%s %s <- %s" % (hexaddr, tag, who))
    print("[input] functions touching input globals: %s" % ", ".join(sorted(matched_funcs)))


main()
