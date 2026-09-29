"""Beenie look: add lighting and colour-gain refinement (its look only tuned geometry, never the light or colours)."""
import json

p = "extracted/sprites_3d/beenie_char/frames.json"
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
o = c["opts"]
r = c["look"]["refine"]
r.update({"world": {"step": 0.03, "min": 0.0, "max": 0.4, "init": o.get("world", 0.18)},
          "key": {"step": 0.3, "min": 1.5, "max": 7.0, "init": o.get("key", 3.075)},
          "fill": {"step": 0.03, "min": 0.0, "max": 0.4, "init": o.get("fill", 0.06)},
          "gamma": {"step": 0.05, "min": 0.6, "max": 1.3, "init": o.get("gamma", 0.8625)},
          "spec": {"step": 0.1, "min": 0.0, "max": 0.6, "init": o.get("spec", 0.0)}})
for k in ("sweater", "trousers", "skin", "hair", "shoes"):
    r[k + "_gain"] = {"step": 0.05, "min": 0.6, "max": 1.5, "init": 1.0}
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("refine keys", len(r))
