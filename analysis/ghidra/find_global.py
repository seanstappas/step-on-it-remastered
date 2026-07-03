# -*- coding: utf-8 -*-
# Ghidra headless: full-program decompile + text-grep for one or more literal
# hex substrings (a global address like 1003b286, or a constant like 424f5244
# = 'BORD'). Functions whose decompiled C contains a target are saved to
# analysis/decomp/find_<name>.c and reported.
#
# Targets come from -postScript args; default = the frame-period global.
#   ... -postScript find_global.py 424f5244 -scriptPath analysis/ghidra ...
import os
from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI
OUT = os.path.join(os.getcwd(), "analysis", "decomp")


def addr_str(a):
    return "0x%x" % a.getOffset()


def main():
    program = getCurrentProgram()  # noqa: F821
    monitor = ConsoleTaskMonitor()
    fm = program.getFunctionManager()

    args = getScriptArgs()  # noqa: F821
    targets = [a.lower() for a in args] if args else ["1003b286"]

    try:
        os.makedirs(OUT)
    except OSError:
        pass
    decomp = DecompInterface()
    decomp.openProgram(program)
    hits = dict((t, []) for t in targets)
    n = 0
    for fn in fm.getFunctions(True):
        if fn.isExternal():
            continue
        res = decomp.decompileFunction(fn, 45, monitor)
        if res is None or not res.decompileCompleted():
            continue
        c = res.getDecompiledFunction().getC()
        cl = c.lower()
        for t in targets:
            if t in cl:
                hits[t].append(fn.getName())
                with open(os.path.join(OUT, "find_%s_%s.c" % (fn.getName(), addr_str(fn.getEntryPoint()))), "w") as fh:
                    fh.write("/* %s @ %s */\n" % (fn.getName(), addr_str(fn.getEntryPoint())))
                    fh.write(c)
        n += 1
    print("[find] decompiled %d functions" % n)
    for t in targets:
        print("[find] %s <- %s" % (t, ", ".join(sorted(set(hits[t]))) or "(none)"))


main()
