"""Score option variants of a family on some frames in ONE Blender job (poses from fit.json).

  py tmp/opt_grid.py <family> <nn,nn,...> '<[{variant opts}, ...]>' [scale] [samples]
Prints each variant's mean look score / IoU / blurred dE, best first."""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, nns, variants = sys.argv[1], [int(x) for x in sys.argv[2].split(",")], json.loads(sys.argv[3])
scale = int(sys.argv[4]) if len(sys.argv) > 4 else 2
samples = int(sys.argv[5]) if len(sys.argv) > 5 else 32
cfg = fm.load_cfg(fam)
with open(os.path.join(fm.workdir(fam), "fit.json"), "r", encoding="utf-8") as fh:
    fit = json.load(fh)
base = fm._opts(fam, cfg)
lfo = fm._look_frame_opts(fam)
frames = [f for f in fm.base_frames(cfg) if f[0] in nns]
trials = []
for vi, v in enumerate(variants):
    for fr in frames:
        o = dict(fm.frame_opts(cfg, fr[0], base=base), **lfo.get(str(fr[0]), {}))
        o.update(v)
        trials.append(((vi, fr[0]), fr, fit["frames"][str(fr[0])]["pose"], o))
d = fm.workdir(fam, "optgrid")
sc = fm._render_score(cfg, fit, trials, d, "%s_og" % fam, scale, samples)
rows = []
for vi, v in enumerate(variants):
    ious, des, tot = [], [], []
    for k, (tid, fr, pose, o) in enumerate(trials):
        if tid[0] != vi:
            continue
        out = os.path.join(d, "%s_og_%05d.png" % (fam, k))
        sd = fm.premul(fm.rgba(fr[1]))
        r = fm.box_down(fm.premul(fm.rgba(out)), scale)
        ious.append(fm.compare(sd, r)[0])
        des.append(fm.compare_blur(sd, r))
        tot.append(sc[tid])
    rows.append((sum(tot) / len(tot), sum(ious) / len(ious), sum(des) / len(des), v))
for s, i, e, v in sorted(rows, key=lambda r: r[0]):
    print("score %.2f  IoU %.3f  dE %.2f  %s" % (s, i, e, json.dumps(v)))
