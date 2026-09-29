"""Switch goody_shoe to goodies.py's "sneaker" model: set the opts, drop the old heel look params, refine the new
shape keys (run after `framematch.py goody_shoe bake`; delete the work look.json afterwards)."""
import json

p = "extracted/sprites_3d/goody_shoe/frames.json"
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
o = c["opts"]
o.update({"sneaker": True, "quarter_h": 3.8, "shoe_tilt": 15.0})
lk = c["look"]
lk["params"] = {}
r = lk["refine"]
for k in ("heel_f", "heel_h", "heel_dy", "stripe_w"):
    r.pop(k, None)
r.update({"shoe_w": {"step": 0.3, "min": 2.5, "max": 6.0},
          "toe_h": {"step": 0.25, "min": 1.5, "max": 3.5, "init": 2.2},
          "mid_h": {"step": 0.25, "min": 2.2, "max": 4.0, "init": 3.0},
          "quarter_h": {"step": 0.25, "min": 3.0, "max": 5.5, "init": 3.8},
          "upper_bevel": {"step": 0.05, "min": 0.5, "max": 0.95, "init": 0.8},
          "lace_w": {"step": 0.05, "min": 0.3, "max": 0.7, "init": 0.45},
          "sole_h": {"step": 0.1, "min": 0.4, "max": 1.0, "init": 0.8}})
for k, v in r.items():
    if k in o and not isinstance(o[k], (list, bool)):
        v["init"] = o[k]
c["note"] = ("Round 13 (the sneaker read as a white capsule and a red block): goodies.py kind shoe 'sneaker' = a low "
             "white toe box rising through the instep to the RED high-top ankle, a white tongue, blue lace bars across "
             "the instep, a grey sole. " + c.get("note", ""))
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("sneaker set", {k: o.get(k) for k in ("shoe_l", "shoe_w", "vamp_h", "shoe_roll", "shoe_yaw", "shoe_tilt")})
