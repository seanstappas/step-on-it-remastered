"""Move cannon_barrel's facing from frame_opts into the fitted poses (f02 face +1, f03 face -1)."""
import json

p = "extracted/sprites_3d/cannon_barrel/frames.json"
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
c.pop("frame_opts", None)
c["note"] = c["note"].replace("frame_opts face +1 (f02 muzzle right) / -1 (f03 left)",
                              "pose face +1 (f02 muzzle right) / -1 (f03 left: the pivot mirrored)")
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
fp = "tmp/soi3d_work/cannon_barrel/fit.json"
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
fit["frames"]["2"]["pose"]["face"] = 1.0
fit["frames"]["3"]["pose"]["face"] = -1.0
with open(fp, "w", encoding="utf-8") as fh:
    json.dump(fit, fh, indent=1)
print({k: v["pose"] for k, v in fit["frames"].items()}, "frame_opts" in c)
