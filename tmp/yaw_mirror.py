"""Score a quadruped family's frames at their fitted pose vs the pose mirrored about the side view (yaw -> -yaw,
near/far legs swapped, phase + 180) -- an orthographic silhouette cannot tell the two apart, so the fit can
flip the 3/4 turn between frames (the hippo's mouth then vanishes in half its walk).

  py tmp/yaw_mirror.py <family> <nn,nn,...> [apply|force]
Prints IoU / dE / detail miss for both; "apply" writes the mirrored pose into fit.json where it scores no
worse (look score) than the current one, "force" writes it for every listed frame (then re-run optim).
Montage: tmp/yaw_mirror_<family>.png (SD | fitted | mirrored)."""
import json
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam = sys.argv[1]
want = [int(x) for x in sys.argv[2].split(",")]
apply = len(sys.argv) > 3 and sys.argv[3] in ("apply", "force")
force = len(sys.argv) > 3 and sys.argv[3] == "force"
cfg = fm.load_cfg(fam)
fp = os.path.join(fm.workdir(fam), "fit.json")
with open(fp, "r", encoding="utf-8") as fh:
    fit = json.load(fh)
base = fm._opts(fam, cfg)
lfo = fm._look_frame_opts(fam)
frames = [f for f in fm.base_frames(cfg) if f[0] in want]


def mirror(p):
    q = dict(p)
    q["yaw"] = round((360.0 - float(p.get("yaw", 0.0))) % 360.0, 3)
    q["phase"] = round(float(p.get("phase", 0.0)) + 180.0, 3)
    q["a_fn"], q["a_ff"] = p.get("a_ff", 0.0), p.get("a_fn", 0.0)
    q["a_rn"], q["a_rf"] = p.get("a_rf", 0.0), p.get("a_rn", 0.0)
    return q


trials = []
for fr in frames:
    nn = fr[0]
    p = fit["frames"][str(nn)]["pose"]
    o = dict(fm.frame_opts(cfg, nn, base=base), **lfo.get(str(nn), {}))
    trials.append(((nn, "fit"), fr, p, o))
    trials.append(((nn, "mir"), fr, mirror(p), o))
d = fm.workdir(fam, "yawmir")
s = cfg["scale"]
sc = fm._render_score(cfg, fit, trials, d, "%s_ym" % fam, s, 64)
Z = 4
W = max(f[2] for f in frames) * Z
H = max(f[3] for f in frames) * Z
sheet = Image.new("RGB", (3 * (W + 4), len(frames) * (H + 16)), (40, 40, 48))
dr = ImageDraw.Draw(sheet)
changed = 0
for i, fr in enumerate(frames):
    nn, p, w, h = fr
    sd = fm.premul(fm.rgba(p))
    res = {}
    for j, tag in enumerate(("fit", "mir")):
        k = [t[0] for t in trials].index((nn, tag))
        out = os.path.join(d, "%s_ym_%05d.png" % (fam, k))
        r = fm.box_down(fm.premul(fm.rgba(out)), s)
        iou, _ = fm.compare(sd, r)
        res[tag] = (iou, fm.compare_blur(sd, r), fm.detail_miss(sd, r)[0], sc[(nn, tag)])
        im = Image.open(out).convert("RGBA").resize((w * Z, h * Z), Image.LANCZOS)
        bg = Image.new("RGBA", im.size, (0, 0, 0, 255))
        bg.alpha_composite(im)
        sheet.paste(bg.convert("RGB"), ((j + 1) * (W + 4), i * (H + 16) + 14))
    im = Image.open(p).convert("RGBA").resize((w * Z, h * Z), Image.NEAREST)
    bg = Image.new("RGBA", im.size, (0, 0, 0, 255))
    bg.alpha_composite(im)
    sheet.paste(bg.convert("RGB"), (0, i * (H + 16) + 14))
    f_, m_ = res["fit"], res["mir"]
    dr.text((2, i * (H + 16)), "f%d fit IoU %.3f dE %.2f miss %.3f | mir IoU %.3f dE %.2f miss %.3f" % (nn, *f_[:3], *m_[:3]),
            fill=(255, 230, 120))
    print("f%02d yaw %6.1f  fit IoU %.3f dE %5.2f miss %.3f score %.2f | mir IoU %.3f dE %5.2f miss %.3f score %.2f" % (
        nn, float(fit["frames"][str(nn)]["pose"].get("yaw", 0.0)), *f_, *m_))
    if apply and (force or m_[3] <= f_[3] + 0.05):
        fit["frames"][str(nn)]["pose"] = mirror(fit["frames"][str(nn)]["pose"])
        changed += 1
sheet.save(os.path.join("tmp", "yaw_mirror_%s.png" % fam))
if apply:
    with open(fp, "w", encoding="utf-8") as fh:
        json.dump(fit, fh, indent=1)
    print("applied the mirror to %d frames" % changed)
