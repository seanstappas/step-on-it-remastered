# -*- coding: utf-8 -*-
# Ghidra headless: decompile a list of functions given by entry address, passed
# as -postScript args (hex, with or without 0x). Writes analysis/decomp/at_*.c.
#   ... -postScript decomp_at.py 1001a348 1002b708 -scriptPath analysis/ghidra ...
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
    space = program.getAddressFactory().getDefaultAddressSpace()
    try:
        os.makedirs(OUT)
    except OSError:
        pass
    decomp = DecompInterface()
    decomp.openProgram(program)
    for a in getScriptArgs():  # noqa: F821
        off = int(a, 16)
        fn = fm.getFunctionContaining(space.getAddress(off))
        if fn is None:
            print("[at] no function at 0x%x" % off)
            continue
        res = decomp.decompileFunction(fn, 60, monitor)
        if res is None or not res.decompileCompleted():
            print("[at] decompile failed for %s" % fn.getName())
            continue
        c = res.getDecompiledFunction().getC()
        with open(os.path.join(OUT, "at_%s_%s.c" % (fn.getName(), addr_str(fn.getEntryPoint()))), "w") as fh:
            fh.write("/* %s @ %s */\n" % (fn.getName(), addr_str(fn.getEntryPoint())))
            fh.write(c)
        print("[at] wrote %s (%d chars)" % (fn.getName(), len(c)))


main()
