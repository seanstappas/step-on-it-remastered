# -*- coding: utf-8 -*-
# Ghidra headless discovery script (Jython 2.7) for the "Step On It!" PEF.
# Run (from repo root, after Phase-0 setup):
#   "$GHIDRA_HOME/support/analyzeHeadless" ./analysis/ghidra soi \
#       -import bin/core_pef.bin -postScript discover.py \
#       -scriptPath analysis/ghidra -deleteProject
#
# Produces analysis/shared_symbols.json (MASTER_PLAN §7.1): named CFM imports,
# functions + call graph, candidate globals. Leaves the game's own functions
# generic (FUN_xx…). It also flags the RNG plumbing (the §5.3 first deliverable).
import json
import os

# @category SOI

INTERESTING_IMPORTS = [
    "Random", "GetKeys", "Button", "TickCount", "FSWrite", "FSRead",
    "SetEntries", "MakeITable", "SndNewChannel", "CopyBits", "NewPtr", "NewHandle",
]


def addr_str(a):
    return "0x%x" % a.getOffset()


def collect(program, monitor):
    fm = program.getFunctionManager()
    st = program.getSymbolTable()

    imports = {}
    for sym in st.getExternalSymbols():
        try:
            lib = sym.getParentNamespace().getName()
        except Exception:
            lib = None
        imports[sym.getName()] = {"lib": lib}

    functions = {}
    for f in fm.getFunctions(True):  # True = forward order
        entry = addr_str(f.getEntryPoint())
        calls = []
        try:
            for c in f.getCalledFunctions(monitor):
                calls.append(c.getName())
        except Exception:
            pass
        functions[entry] = {
            "space": "pef",
            "name": f.getName(),
            "domain": None,
            "signature": str(f.getSignature()),
            "calls": sorted(set(calls)),
            "external": bool(f.isExternal()),
        }

    # Candidate globals: named, non-function data symbols.
    globals_ = {}
    for sym in st.getDefinedSymbols():
        try:
            if sym.getSymbolType().toString() == "Label" and not sym.isExternal():
                globals_[addr_str(sym.getAddress())] = {"space": "pef", "name": sym.getName()}
        except Exception:
            pass

    return imports, functions, globals_


def find_rng(imports, functions):
    """Flag the RNG plumbing — the §5.3 first Phase-1 deliverable."""
    rng = {"seed_addr": "0x08fe", "algorithm": "TODO-confirm",
           "return_slice": "consumers mask sign off: (Random()&0x7fff) ranged, (Random()&0x3f) weighted",
           "helpers": {"RandomInRange_1_n": ["0x1000c278", "0x1000cbe0"],
                       "weighted_pick": "0x1000c680"},
           "seed_source": "no clock-seed found; likely Toolbox default randSeed=1 (confirm in main)",
           "random_imported": "Random" in imports}
    # Callers of Random() are where seeding/consumption happens.
    callers = [f["name"] for f in functions.values() if "Random" in f["calls"]]
    rng["random_callers"] = sorted(set(callers))
    return rng


def scan_fp(program, monitor):
    """Scan for PPC floating-point instructions (§5.1 determinism question).

    On PowerPC every FP op mnemonic starts with 'f' (fadd/fmul/fdiv/fmadd/fcmpu/…)
    plus the FP load/stores lfs/lfd/lfsu/lfdu/stfs/stfd/stfsu/stfdu. If the count
    is ~0 the core logic is integer-only and the deterministic path is trivial.
    """
    listing = program.getListing()
    fp_prefixes = ("lfs", "lfd", "stfs", "stfd")
    total = 0
    per_mnem = {}
    fm = program.getFunctionManager()
    fp_funcs = set()
    insns = listing.getInstructions(True)
    while insns.hasNext():
        insn = insns.next()
        m = insn.getMnemonicString().lower()
        is_fp = m.startswith("f") or m.startswith(fp_prefixes)
        if not is_fp:
            continue
        total += 1
        per_mnem[m] = per_mnem.get(m, 0) + 1
        fn = fm.getFunctionContaining(insn.getAddress())
        if fn is not None:
            fp_funcs.add(fn.getName())
    return {"fp_instruction_count": total,
            "fp_mnemonics": per_mnem,
            "fp_functions": sorted(fp_funcs)}


def main():
    program = getCurrentProgram()  # noqa: F821 (Ghidra-injected)
    imports, functions, globals_ = collect(program, monitor)  # noqa: F821
    fp = scan_fp(program, monitor)  # noqa: F821

    present = sorted([k for k in INTERESTING_IMPORTS if k in imports])
    print("[discover] imports=%d functions=%d globals=%d" % (len(imports), len(functions), len(globals_)))
    print("[discover] key imports present: %s" % ", ".join(present))
    print("[discover] FP instructions: %d (in %d functions)" % (fp["fp_instruction_count"], len(fp["fp_functions"])))

    out = {
        "names": {"protagonist": "Ted"},
        "imports": imports,
        "functions": functions,
        "globals": globals_,
        "rng": find_rng(imports, functions),
        "fp_scan": fp,
        "todo": ["end-of-tick hook site", "per-Tick vs per-frame"],
    }
    dst = os.path.join(os.getcwd(), "analysis", "shared_symbols.json")
    try:
        os.makedirs(os.path.dirname(dst))
    except OSError:
        pass
    with open(dst, "w") as fh:
        json.dump(out, fh, indent=2, sort_keys=True)
    print("[discover] wrote %s" % dst)


main()
