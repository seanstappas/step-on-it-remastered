"""Beenie re-proportion (round 13): a small tri-colour beanie ON TOP of the hair mop and a smaller head, as in the
source (head + cap rows 0-12, the cap only on the crown); widen the look's refine ranges so it can hold them."""
import json

p = "extracted/sprites_3d/beenie_char/frames.json"
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
new = {"head_r": 4.6, "cap_f": 0.8, "cap_fy": 0.6, "cap_dy": 1.1, "fringe_x": 0.1, "hair_cut": 35}
c["opts"].update(new)
r = c["look"]["refine"]
r["head_r"] = {"step": 0.2, "min": 4.0, "max": 5.5, "init": 4.6}
r["cap_f"] = {"step": 0.05, "min": 0.6, "max": 1.0, "init": 0.8}
r["cap_fy"] = {"step": 0.05, "min": 0.45, "max": 0.8, "init": 0.6}
r["cap_dy"] = {"step": 0.05, "min": 0.9, "max": 1.3, "init": 1.1}
c["note"] = ("Round 13 (re-proportioned): the full hair mop (hair_cut 35, fringe_x .1: face in front, hair behind), a "
             "SMALL beanie on top of the hair (cap_f .8, cap_dy 1.1; it used to be a dome over half the head) and a "
             "smaller head (head_r 4.6). " + c.get("note", ""))
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("beenie set", new)
