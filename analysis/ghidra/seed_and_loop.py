# -*- coding: utf-8 -*-
# Ghidra headless: locate low-memory-global access + the entry/main call tree.
#
# Answers two open §5.3 / §2a questions:
#   1. Does anything write randSeed (low-mem 0x08FE)?  -> RNG seed source.
#   2. Where is the CFM entry / main loop, and does it read Ticks (0x016A)?
#
# Run (from repo root):
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -processor PowerPC:BE:32:default \
#       -postScript seed_and_loop.py -scriptPath analysis/ghidra -deleteProject
#
# Writes analysis/decomp/entry_*.c (entry + callees, BFS depth 2) and prints a
# reference report for the low-mem globals.
import os

from ghidra.app.decompiler import DecompInterface  # noqa: F401
from ghidra.util.task import ConsoleTaskMonitor  # noqa: F401

# @category SOI

OUT = os.path.join(os.getcwd(), "analysis", "decomp")
LOWMEM = {0x08FE: "randSeed", 0x016A: "Ticks", 0x0900: "randSeed_hi_guess"}
BFS_DEPTH = 2


def addr_str(a):
    return "0x%x" % a.getOffset()


def refs_to_lowmem(program):
    rm = program.getReferenceManager()
    space = program.getAddressFactory().getDefaultAddressSpace()
    fm = program.getFunctionManager()
    listing = program.getListing()
    out = {}
    for off, name in LOWMEM.items():
        addr = space.getAddress(off)
        rows = []
        for r in rm.getReferencesTo(addr):
            frm = r.getFromAddress()
            fn = fm.getFunctionContaining(frm)
            insn = listing.getInstructionAt(frm)
            m = insn.getMnemonicString() if insn is not None else "?"
            rows.append((fn.getName() if fn is not None else "?", addr_str(frm), m,
                         str(r.getReferenceType())))
        out[name] = rows
    return out


def scan_scalar_lowmem(program):
    """Fallback: instructions whose operand scalar equals a low-mem address
    AND that are loads/stores (lwz/stw/lha/sth/lbz/stb) with an absolute form."""
    fm = program.getFunctionManager()
    listing = program.getListing()
    ld_st = ("lwz", "stw", "lha", "lhz", "sth", "lbz", "stb", "addi", "lis", "ori")
    rows = []
    insns = listing.getInstructions(True)
    while insns.hasNext():
        insn = insns.next()
        m = insn.getMnemonicString().lower()
        if not m.startswith(ld_st):
            continue
        for i in range(insn.getNumOperands()):
            for obj in insn.getOpObjects(i):
                v = None
                try:
                    v = obj.getValue()
                except Exception:
                    v = None
                if v in LOWMEM:
                    fn = fm.getFunctionContaining(insn.getAddress())
                    rows.append((LOWMEM[v], fn.getName() if fn is not None else "?",
                                 addr_str(insn.getAddress()), m))
    return rows


def entry_functions(program):
    fm = program.getFunctionManager()
    funcs = []
    it = program.getSymbolTable().getExternalEntryPointIterator()
    while it.hasNext():
        a = it.next()
        fn = fm.getFunctionContaining(a)
        if fn is not None:
            funcs.append(fn)
    return funcs


def main():
    program = getCurrentProgram()  # noqa: F821
    monitor = ConsoleTaskMonitor()
    fm = program.getFunctionManager()

    try:
        os.makedirs(OUT)
    except OSError:
        pass

    # --- low-mem reference report ---
    refs = refs_to_lowmem(program)
    for name, rows in refs.items():
        print("[seed] refs to %s: %d" % (name, len(rows)))
        for r in rows[:20]:
            print("        %s @ %s  %s  %s" % r)
    scal = scan_scalar_lowmem(program)
    print("[seed] scalar/absolute low-mem operand hits: %d" % len(scal))
    for r in scal[:30]:
        print("        %s in %s @ %s  %s" % r)

    # --- decompile entry + BFS callees ---
    decomp = DecompInterface()
    decomp.openProgram(program)

    roots = entry_functions(program)
    print("[loop] entry functions: %s" % ", ".join(
        "%s@%s" % (f.getName(), addr_str(f.getEntryPoint())) for f in roots))

    visited = set()
    frontier = [(f, 0) for f in roots]
    written = 0
    while frontier:
        fn, depth = frontier.pop(0)
        off = fn.getEntryPoint().getOffset()
        if off in visited:
            continue
        visited.add(off)
        res = decomp.decompileFunction(fn, 60, monitor)
        tag = "entry" if depth == 0 else "d%d" % depth
        if res is not None and res.decompileCompleted():
            c = res.getDecompiledFunction().getC()
            fname = "entry_%s_%s_%s.c" % (tag, fn.getName(), addr_str(fn.getEntryPoint()))
            with open(os.path.join(OUT, fname), "w") as fh:
                fh.write("/* %s @ %s  depth=%d */\n" % (fn.getName(), addr_str(fn.getEntryPoint()), depth))
                fh.write(c)
            written += 1
        if depth < BFS_DEPTH:
            try:
                for callee in fn.getCalledFunctions(monitor):
                    if not callee.isExternal() and callee.getEntryPoint().getOffset() not in visited:
                        frontier.append((callee, depth + 1))
            except Exception:
                pass
    print("[loop] wrote %d entry/callee decompilations to analysis/decomp/" % written)


main()
