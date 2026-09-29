"""V8 (user feedback: the player looked bald at the front with short arms): give a kid family the full hair
MOP cut at a fringe (kid.py hair_cut) and longer arms, fixed so the look cannot shrink them back.
Bakes the current look first.  py tmp/player_hair.py <family> [<family> ...]"""
import json
import os
import subprocess
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..")
HAIR = {"hair_cut": 25.0, "hair_f": 1.08, "hair_dx": 0.35, "hair_dy": 0.3, "hair_fy": 1.05, "fringe_x": 0.4,
        "fringe_y": 0.1}
ARMS = {"uarm_l": (5.5, 5.0, 7.0), "farm_l": (4.6, 4.2, 6.0)}   # value, refine min, refine max
for fam in sys.argv[1:]:
    subprocess.check_call([sys.executable, os.path.join(ROOT, "tools", "soi3d", "framematch.py"), fam, "bake"])
    p = os.path.join(ROOT, "extracted", "sprites_3d", fam, "frames.json")
    with open(p, "r", encoding="utf-8-sig") as fh:
        cfg = json.load(fh)
    cfg["opts"].update(HAIR)
    ref = cfg.get("look", {}).get("refine", {})
    for k in ("hair_dx", "hair_dy", "hair_f"):
        ref.pop(k, None)
    for k, (v, lo, hi) in ARMS.items():
        cfg["opts"][k] = max(v, float(cfg["opts"].get(k, v)))
        if k in ref:
            ref[k].update({"min": lo, "max": hi, "init": cfg["opts"][k]})
    cfg["note"] = ("Round 13 (user feedback): full hair mop cut at a fringe (kid.py hair_cut) + longer arms (the "
                   "source's hands hang to the upper thigh); both held out of the look. ") + cfg.get("note", "")
    with open(p, "w", encoding="utf-8") as fh:
        json.dump(cfg, fh, indent=1, ensure_ascii=False)
        fh.write("\n")
    print("player_hair:", fam, {k: cfg["opts"][k] for k in list(HAIR) + list(ARMS)})
