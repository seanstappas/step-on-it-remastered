# -*- coding: utf-8 -*-
# Ghidra headless decompiler for targeted "Step On It!" routines.
# Decompiles the callers of key Toolbox imports (Random, TickCount, seed
# sources) to C so the RNG algorithm/return-slice/seed-origin (MASTER_PLAN
# §5.3) and the per-Tick-vs-per-frame cadence question can be pinned.
#
# Run (from repo root):
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -processor PowerPC:BE:32:default \
#       -postScript decompile.py -scriptPath analysis/ghidra -deleteProject
#
# Writes analysis/decomp/<name>_<addr>.c for each caller of an import in
# TARGET_IMPORTS, plus a decomp/INDEX.md summary.
import os

from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI

# Imports whose *callers* we want to read.
TARGET_IMPORTS = ["Random", "TickCount", "GetDateTime", "ReadDateTime",
                  "Microseconds", "GetKeys", "Button"]

OUT_DIR = os.path.join(os.getcwd(), "analysis", "decomp")


def addr_str(a):
    return "0x%x" % a.getOffset()


def callers_of(program, monitor, names):
    """Map import name -> set of functions that call it."""
    fm = program.getFunctionManager()
    st = program.getSymbolTable()
    ref = program.getReferenceManager()
    want = {}
    # External import symbols -> their thunk/entry addresses.
    for sym in st.getExternalSymbols():
        if sym.getName() in names:
            want.setdefault(sym.getName(), []).append(sym)

    result = {}
    for name in names:
        callers = {}
        # Find every function that references any address associated with the import.
        for sym in st.getSymbols(name):
            for r in ref.getReferencesTo(sym.getAddress()):
                fn = fm.getFunctionContaining(r.getFromAddress())
                if fn is not None:
                    callers[fn.getEntryPoint().getOffset()] = fn
        if callers:
            result[name] = callers
    return result


def main():
    program = getCurrentProgram()  # noqa: F821
    monitor = ConsoleTaskMonitor()

    decomp = DecompInterface()
    decomp.openProgram(program)

    try:
        os.makedirs(OUT_DIR)
    except OSError:
        pass

    found = callers_of(program, monitor, TARGET_IMPORTS)
    seen = {}   # entry offset -> (function, [import names])
    for name, callers in found.items():
        for off, fn in callers.items():
            seen.setdefault(off, (fn, []))[1].append(name)

    index = ["# Decompiled routines (callers of key Toolbox imports)", ""]
    for name in TARGET_IMPORTS:
        callers = found.get(name, {})
        print("[decompile] %s: %d caller(s)" % (name, len(callers)))
        index.append("- **%s**: %d caller(s)" % (name, len(callers)))

    for off in sorted(seen):
        fn, names = seen[off]
        entry = fn.getEntryPoint()
        res = decomp.decompileFunction(fn, 60, monitor)
        if res is None or not res.decompileCompleted():
            print("[decompile] FAILED %s @ %s" % (fn.getName(), addr_str(entry)))
            continue
        c = res.getDecompiledFunction().getC()
        fname = "%s_%s.c" % (fn.getName(), addr_str(entry))
        with open(os.path.join(OUT_DIR, fname), "w") as fh:
            fh.write("/* %s @ %s  calls: %s */\n" % (fn.getName(), addr_str(entry), ", ".join(sorted(names))))
            fh.write(c)
        print("[decompile] wrote decomp/%s (calls %s)" % (fname, ", ".join(sorted(names))))
        index.append("  - `%s` @ %s -> `%s` (calls %s)" % (fn.getName(), addr_str(entry), fname, ", ".join(sorted(names))))

    with open(os.path.join(OUT_DIR, "INDEX.md"), "w") as fh:
        fh.write("\n".join(index) + "\n")
    print("[decompile] wrote decomp/INDEX.md")


main()
