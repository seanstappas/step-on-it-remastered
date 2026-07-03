# -*- coding: utf-8 -*-
# Ghidra headless: dump the exact PPC ASSEMBLY listing for the movement/physics/
# block functions. The decompiled C for these is unreliable (aliased register/
# field tracking), so the assembly is the authoritative source for a 1:1 port.
# Writes analysis/decomp/asm/<name>_0x<addr>.asm (address, bytes, mnemonic+ops,
# operand references, EOL comments).
#
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -processor "PowerPC:BE:32:default" \
#       -postScript dump_asm.py -scriptPath analysis/ghidra -deleteProject
import os

# @category SOI
OUT = os.path.join(os.getcwd(), "analysis", "decomp", "asm")

# movement / physics / block-verb / coordinate-conversion functions
TARGETS = [
    0x1001166c,  # player ground state machine (run/jump dispatch)
    0x10011fcc,  # jump/fall parabolic physics
    0x100110b4,  # jump init / break-block-above
    0x10010d30,  # block verb (up/other)
    0x10012348,  # support check (stand on bit 0x200)
    0x100128f8,  # idle/fall-transition state
    0x100147b8,  # screen x/y interpolation
    0x10014700,  # set moved-flag / cache sprite
    0x1002d04c,  # block create/destroy (right)
    0x1002cf08,  # block create/destroy (left)
    0x1002d190,  # block create/destroy (down)
    0x1002e6cc,  # pixel x -> col
    0x1002e6f8,  # pixel y -> row
    0x1002e6ac,  # cell -> pixel (align)
    # ground-state-switch cases (landing / climb / death animation candidates)
    0x10012bf4, 0x10013404, 0x1001386c, 0x10014524, 0x10013980,
    0x10013ddc, 0x10013f68, 0x10013c18, 0x100140f4, 0x1001431c,
    # input handler + demo pack (7-action latch)
    0x1002d440, 0x1002d388, 0x1002a15c,
    # win / board-advance (key -> door -> exit)
    0x10017a70, 0x10017b68, 0x1002bc64, 0x1002a308, 0x10016c90,
    # block primitives used by the verbs
    0x100279c4, 0x100047e8, 0x1002754c,
]


def main():
    program = getCurrentProgram()          # noqa: F821
    listing = program.getListing()
    try:
        os.makedirs(OUT)
    except OSError:
        pass

    for t in TARGETS:
        addr = toAddr(t)                   # noqa: F821
        fn = getFunctionAt(addr)           # noqa: F821
        if fn is None:
            print("[asm] no function at 0x%x" % t)
            continue
        name = fn.getName()
        body = fn.getBody()
        lines = []
        for ins in listing.getInstructions(body, True):
            a = ins.getAddress()
            hx = "".join("%02x" % (x & 0xff) for x in ins.getBytes())
            refs = ""
            rl = ins.getReferencesFrom()
            if rl:
                refs = "   ; -> " + ", ".join(str(r.getToAddress()) for r in rl)
            cmt = listing.getComment(0, a)  # EOL_COMMENT
            c = ("   ; " + cmt) if cmt else ""
            lines.append("%s  %-10s  %-28s%s%s" % (a, hx, ins.toString(), refs, c))
        path = os.path.join(OUT, "%s_0x%x.asm" % (name, t))
        with open(path, "w") as fh:
            fh.write("; %s @ 0x%x  (%d instructions)\n" % (name, t, len(lines)))
            fh.write("\n".join(lines) + "\n")
        print("[asm] dumped %s (%d instrs)" % (name, len(lines)))


main()
