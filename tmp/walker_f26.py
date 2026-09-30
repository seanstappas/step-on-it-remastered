"""Walker f26 (mid-turn, facing the camera in the original) was fitted from BEHIND (yaw 270: a plain grey rump,
no face). Seed it between its neighbours f25 / f27 (yaw ~90, facing the camera) and re-optimise it alone."""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

FAM = "walker_body"
fp = os.path.join(fm.workdir(FAM), "fit.json")
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
a, b = fit["frames"]["25"]["pose"], fit["frames"]["27"]["pose"]
seed = {k: round((float(a.get(k, 0.0)) + float(b.get(k, 0.0))) / 2, 3) for k in set(a) | set(b)}
print("f26 was", json.dumps(fit["frames"]["26"]["pose"]))
fit["frames"]["26"]["pose"] = seed
print("f26 seed", json.dumps(seed))
with open(fp, "w", encoding="utf-8") as fh:
    json.dump(fit, fh, indent=1)
fm.stage_optim(FAM, fm.load_cfg(FAM), only=[26])
with open(fp, "r", encoding="utf-8") as fh:
    print("f26 now", json.dumps(json.load(fh)["frames"]["26"]["pose"]))
