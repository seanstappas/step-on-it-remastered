# -*- coding: utf-8 -*-
# Ghidra headless: dump the PPC ASSEMBLY of EVERY function to
# analysis/decomp/asm_all/<name>_0x<addr>.asm  (companion to dump_all.py which
# does the C). Enables full-corpus grep for exact global writes / field stores
# that the decompiled C drops (e.g. the win-gate setter, X-interp writes).
#
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -processor "PowerPC:BE:32:default" \
#       -postScript dump_all_asm.py -scriptPath analysis/ghidra -deleteProject
import os

# @category SOI
OUT = os.path.join(os.getcwd(), "analysis", "decomp", "asm_all")


def main():
    program = getCurrentProgram()          # noqa: F821
    listing = program.getListing()
    fm = program.getFunctionManager()
    try:
        os.makedirs(OUT)
    except OSError:
        pass

    n = 0
    for fn in fm.getFunctions(True):
        if fn.isExternal():
            continue
        name = fn.getName()
        entry = fn.getEntryPoint()
        lines = []
        for ins in listing.getInstructions(fn.getBody(), True):
            a = ins.getAddress()
            hx = "".join("%02x" % (x & 0xff) for x in ins.getBytes())
            refs = ""
            rl = ins.getReferencesFrom()
            if rl:
                refs = "   ; -> " + ", ".join(str(r.getToAddress()) for r in rl)
            lines.append("%s  %-10s  %-28s%s" % (a, hx, ins.toString(), refs))
        if not lines:
            continue
        with open(os.path.join(OUT, "%s_0x%x.asm" % (name, entry.getOffset())), "w") as fh:
            fh.write("; %s @ 0x%x\n" % (name, entry.getOffset()))
            fh.write("\n".join(lines) + "\n")
        n += 1
    print("[asm_all] dumped %d functions to analysis/decomp/asm_all/" % n)


main()
