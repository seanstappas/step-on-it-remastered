"""Give cannon_barrel's look colour candidates and lighting/depth refinement for the barrel-in-housing model."""
import json

p = "extracted/sprites_3d/cannon_barrel/frames.json"
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
c["look"] = {"frames": 2, "passes": 2, "samples": 64,
             "params": {"barrel_rgb": [[90, 90, 90], [115, 115, 115], [140, 140, 140]],
                        "housing_rgb": [[198, 198, 198], [220, 220, 220], [240, 240, 240]]},
             "refine": {"world": {"step": 0.03, "min": 0.0, "max": 0.35, "init": 0.12},
                        "key": {"step": 0.4, "min": 1.5, "max": 7.0, "init": 4.6},
                        "fill": {"step": 0.04, "min": 0.0, "max": 0.4, "init": 0.16},
                        "gamma": {"step": 0.05, "min": 0.6, "max": 1.3, "init": 1.0},
                        "barrel_z": {"step": 0.05, "min": 0.0, "max": 0.5, "init": 0.2}},
             "refine_rounds": 6, "iou_w": 200, "iou_margin": 0.03, "detail_w": 0.5}
c["note"] = ("Round 13 (lost detail: the barrel read as a flat egg and f02 = f03): cannon_barrel.py 'barrel' = a barrel "
             "lying in a light square housing (backplate, top/bottom rims, end wall), a rounded breech, a raised collar "
             "and the muzzle out of one side; frame_opts face +1 (f02 muzzle right) / -1 (f03 left). Placement set by "
             "hand (0.1 unit per source px): the frame is fully opaque, so IoU cannot fit the zoom. " + c.get("note", ""))
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print("look set")
