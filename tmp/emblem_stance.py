"""Fix an emblem3d statue's stance by hand: merge JSON opts into the emblem's frames.json opts (m_<key> = the
monster's own options, monster_pose, statue_mirror, statue_k/x/y ...), drop the look's pose/mirror candidates,
narrow the placement refine around the new values (k +-8 %, x/y +-2 px) and delete the work look.json (it would
override the new opts).  py tmp/emblem_stance.py <emblem family> '<json opts>'"""
import json
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
fam, new = sys.argv[1], json.loads(sys.argv[2])
p = os.path.join(ROOT, "extracted", "sprites_3d", fam, "frames.json")
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
c["opts"].update(new)
lk = c["look"]
for k in ("monster_pose", "statue_mirror"):
    lk.setdefault("params", {}).pop(k, None)
r = lk["refine"]
o = c["opts"]
r["statue_k"] = {"step": round(o["statue_k"] * 0.02, 4), "min": round(o["statue_k"] * 0.92, 4),
                 "max": round(o["statue_k"] * 1.08, 4), "init": o["statue_k"]}
for k in ("statue_x", "statue_y"):
    r[k] = {"step": 0.25, "min": o[k] - 2.0, "max": o[k] + 2.0, "init": o[k]}
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
lp = os.path.join(ROOT, "tmp", "soi3d_work", fam, "look.json")
if os.path.exists(lp):
    os.remove(lp)
print(fam, "stance:", {k: o[k] for k in new}, "| look params", list(lk.get("params", {})))
