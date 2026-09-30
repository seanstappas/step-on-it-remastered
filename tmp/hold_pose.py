"""Re-seed some frames' pose params and re-optimise just those frames with some params FROZEN and others' ranges
narrowed (e.g. a kid's head turned to face the camera / away mid-run while the original holds its profile).

  py tmp/hold_pose.py <family> '<{"nn": {param: value}}>' '<{param: {"min": a, "max": b}}>' <frozen,params|->
The seeds are written into fit.json; the narrowed ranges are applied to this run only (persist them in
frames.json yourself); frozen params keep their seeded value (optim's +-2 reseed may still copy a neighbour's)."""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam = sys.argv[1]
seeds = {int(k): v for k, v in json.loads(sys.argv[2]).items()}
ranges = json.loads(sys.argv[3])
frozen = [] if sys.argv[4] == "-" else sys.argv[4].split(",")
cfg = fm.load_cfg(fam)
fp = os.path.join(fm.workdir(fam), "fit.json")
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
for nn, kv in seeds.items():
    print("f%02d was %s" % (nn, json.dumps({k: round(float(fit["frames"][str(nn)]["pose"].get(k, 0.0)), 1) for k in kv})))
    fit["frames"][str(nn)]["pose"].update(kv)
with open(fp, "w", encoding="utf-8") as fh:
    json.dump(fit, fh, indent=1)
op = json.loads(json.dumps(cfg["optim"]))
for k, r in ranges.items():
    op["params"][k].update(r)
op["params"] = {k: v for k, v in op["params"].items() if k not in frozen}
op["probe"] = [pr for pr in ({k: v for k, v in p.items() if k not in frozen} for p in (op.get("probe") or [])) if pr]
fm.stage_optim(fam, dict(cfg, optim=op), only=sorted(seeds))
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
for nn in sorted(seeds):
    p = fit["frames"][str(nn)]["pose"]
    print("f%02d now yaw %.1f hd %.1f" % (nn, float(p.get("yaw", 0.0)), float(p.get("hd", 0.0))))
