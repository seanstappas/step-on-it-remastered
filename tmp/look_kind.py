"""Re-run a family's per-kind look for ONE kind only, starting from its published look.json choices, and merge
the result back into look.json frame_opts (other kinds untouched).
py tmp/look_kind.py <family> <kind> '<json {opt: [candidates]}>'"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, kind, params = sys.argv[1], sys.argv[2], json.loads(sys.argv[3])
cfg = fm.load_cfg(fam)
lp = os.path.join(fm.WORK, fam, "look.json")
with open(lp, "r", encoding="utf-8") as fh:
    look = json.load(fh)
with open(os.path.join(fm.WORK, fam, "fit.json"), "r", encoding="utf-8") as fh:
    fit = json.load(fh)
best = fm._opts(fam, cfg)
fo = {k: dict(v, **look.get("frame_opts", {}).get(k, {})) for k, v in cfg.get("frame_opts", {}).items()}
frames = [f for f in fm.base_frames(cfg) if fo.get(str(f[0]), {}).get("kind") == kind]
print("kind %s: %d frames %s" % (kind, len(frames), [f[0] for f in frames]))
cfg2 = dict(cfg, frame_opts=fo, look=dict(cfg["look"], per_kind={kind: params}))
res = fm._look_per_kind(fam, cfg2, fit, best, frames, fm.workdir(fam, "look"))
for nn, over in res.items():
    look.setdefault("frame_opts", {}).setdefault(nn, {}).update(over)
with open(lp, "w", encoding="utf-8") as fh:
    json.dump(look, fh, indent=1)
print("merged into", lp)
