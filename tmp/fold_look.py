"""Fold a family's fitted look (work/look.json opts) into its frames.json opts and refine inits, so the next
`look` stage continues from it instead of restarting from the old opts. Usage: py tmp/fold_look.py <family>"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam = sys.argv[1]
cp = os.path.join(fm.FAM_DIR, fam, "frames.json")
with open(cp, "r", encoding="utf-8-sig") as fh:
    cfg = json.load(fh)
with open(os.path.join(fm.WORK, fam, "look.json"), "r", encoding="utf-8") as fh:
    look = json.load(fh)["opts"]
ref = cfg.get("look", {}).get("refine", {})
for k, v in look.items():
    cfg["opts"][k] = v
    if k in ref and isinstance(v, (int, float)):
        ref[k]["init"] = min(max(v, ref[k]["min"]), ref[k]["max"])
with open(cp, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("folded %d look opts into %s" % (len(look), os.path.relpath(cp)))
