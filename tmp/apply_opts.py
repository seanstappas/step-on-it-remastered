"""Apply option changes to a published family's frames.json opts (+ its look refine "init"s) and to the work
look.json opts that override them, keeping the file's formatting when it is plain json.dumps(indent=1).

  py tmp/apply_opts.py <family> '<json opts>'"""
import collections
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, new = sys.argv[1], json.loads(sys.argv[2])
p = os.path.join(fm.FAM_DIR, fam, "frames.json")
raw = open(p, encoding="utf-8-sig").read()
d = json.loads(raw, object_pairs_hook=collections.OrderedDict)
same = json.dumps(d, indent=1) == raw.rstrip("\n")
d["opts"].update(new)
for k, spec in ((d.get("look") or {}).get("refine") or {}).items():
    if k in new and isinstance(new[k], (int, float)) and not isinstance(new[k], bool):
        spec["init"] = new[k]
        spec["min"] = min(spec.get("min", new[k]), new[k])    # else the next refine clamps the value back
        spec["max"] = max(spec.get("max", new[k]), new[k])
open(p, "w", encoding="utf-8", newline="\n").write(json.dumps(d, indent=1) + ("\n" if raw.endswith("\n") else ""))
lp = os.path.join(fm.WORK, fam, "look.json")
if os.path.exists(lp):
    lj = json.load(open(lp, encoding="utf-8"))
    lj["opts"].update({k: v for k, v in new.items()})
    json.dump(lj, open(lp, "w", encoding="utf-8"), indent=1)
print("updated %s (format %s)" % (p, "kept" if same else "REFORMATTED"), new)
