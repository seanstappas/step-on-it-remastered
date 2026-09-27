"""Beenie head fix: fold the fitted look, then start the cap above the hair, the hair as a band behind the face,
dark eyes and a red mouth (the source's head rows: cap 4-6, hair 6-10, face 8-13 in front)."""
import json
import os
import subprocess
import sys

root = os.path.join(os.path.dirname(__file__), "..")
subprocess.check_call([sys.executable, os.path.join(root, "tmp", "fold_look.py"), "beenie_char"])
cp = os.path.join(root, "extracted", "sprites_3d", "beenie_char", "frames.json")
with open(cp, "r", encoding="utf-8") as fh:
    cfg = json.load(fh)
o, look = cfg["opts"], cfg["look"]
ref = look["refine"]
new = {"cap_f": 1.0, "cap_dy": 0.3, "cap_fy": 0.85, "hair_dx": 1.3, "hair_dy": 0.0, "hair_f": 1.03, "hair_fy": 0.88,
       "mouth_el": -30.0, "mouth_az": 12.0, "mouth_r": 1.2}
o.update(new)
o.update({"mouth": True, "lips": [200, 20, 20], "eye_white": [30, 30, 36], "eye_pupil": [5, 5, 5]})
ref.setdefault("hair_fy", {"step": 0.05, "min": 0.7, "max": 1.1})
ref.setdefault("mouth_el", {"step": 5, "min": -50, "max": -5})
ref.setdefault("mouth_az", {"step": 5, "min": 0, "max": 40})
ref.setdefault("mouth_r", {"step": 0.15, "min": 0.5, "max": 2.2})
for k, v in new.items():
    if k in ref:
        ref[k]["init"] = min(max(v, ref[k]["min"]), ref[k]["max"])
look["detail_w"] = 0.5
with open(cp, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("beenie head fix applied")
