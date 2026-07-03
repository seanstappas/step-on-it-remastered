# -*- coding: utf-8 -*-
# Ghidra headless: decompile EVERY function to analysis/decomp/all/<name>.c and
# write an index (name, entry, size, imports-called, referenced data globals).
# One-time infrastructure so subsequent RE is fast file reads/greps.
#
#   ... -postScript dump_all.py -scriptPath analysis/ghidra -deleteProject
import os
import re

from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI
OUT = os.path.join(os.getcwd(), "analysis", "decomp", "all")
GLOB_RE = re.compile(r"(?:DAT|uRam|sRam|cRam|iRam)_?([0-9a-fA-F]{6,8})")


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

    index = []
    n = 0
    ok = 0
    for fn in fm.getFunctions(True):
        if fn.isExternal():
            continue
        n += 1
        name = fn.getName()
        entry = addr_str(fn.getEntryPoint())
        res = decomp.decompileFunction(fn, 45, monitor)
        if res is None or not res.decompileCompleted():
            index.append("%s\t%s\tDECOMP_FAIL" % (entry, name))
            continue
        c = res.getDecompiledFunction().getC()
        with open(os.path.join(OUT, "%s_%s.c" % (name, entry)), "w") as fh:
            fh.write(c)
        ok += 1
        # imports called (.glue::X) + size proxy (char count)
        imps = sorted(set(re.findall(r"\.glue::(\w+)", c)))
        globs = sorted(set("0x" + g.lower() for g in GLOB_RE.findall(c)))
        index.append("%s\t%s\t%d\timps=%s\tglobals=%s" % (
            entry, name, len(c), ",".join(imps[:12]), ",".join(globs[:20])))

    with open(os.path.join(os.getcwd(), "analysis", "decomp", "INDEX.tsv"), "w") as fh:
        fh.write("\n".join(index) + "\n")
    print("[dump] decompiled %d/%d functions to analysis/decomp/all/ + INDEX.tsv" % (ok, n))


main()
