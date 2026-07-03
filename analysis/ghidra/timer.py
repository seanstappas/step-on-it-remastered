# -*- coding: utf-8 -*-
# Ghidra headless: decompile the frame-timer cluster to pin the frame period
# (PrimeTime interval) and the Speed -> interval mapping.
import os
from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI
OUT = os.path.join(os.getcwd(), "analysis", "decomp")
ADDRS = [0x100193c8, 0x10019428, 0x100194dc, 0x100192f8, 0x1001977c]


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
    for off in ADDRS:
        fn = fm.getFunctionContaining(space.getAddress(off))
        if fn is None:
            print("[timer] no function at 0x%x" % off)
            continue
        res = decomp.decompileFunction(fn, 60, monitor)
        if res is None or not res.decompileCompleted():
            print("[timer] decompile failed %s" % fn.getName())
            continue
        c = res.getDecompiledFunction().getC()
        with open(os.path.join(OUT, "timer_%s_%s.c" % (fn.getName(), addr_str(fn.getEntryPoint()))), "w") as fh:
            fh.write("/* %s @ %s */\n" % (fn.getName(), addr_str(fn.getEntryPoint())))
            fh.write(c)
        print("[timer] wrote %s (%d chars)" % (fn.getName(), len(c)))


main()
