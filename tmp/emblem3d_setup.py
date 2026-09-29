"""Switch an enemy spawner emblem family to tools/soi3d/builders/emblem3d.py (the nasty's own 3D model as the
silver statue, casting its shadow on the red slab). Picks candidate poses from the monster family whose
published silhouettes best match the source statue, and derives the statue's initial scale/offset from the two
families' fitted cameras.  py tmp/emblem3d_setup.py <emblem family> <monster family>"""
import glob
import json
import os
import shutil
import sys

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

efam, mfam = sys.argv[1], sys.argv[2]
ecfg, mcfg = fm.load_cfg(efam), fm.load_cfg(mfam)
ep = os.path.join(fm.FAM_DIR, efam, "frames.json")
bk = os.path.join(os.path.dirname(__file__), "fb_backup")
os.makedirs(bk, exist_ok=True)
for src, dst in ((ep, "%s_frames.json" % efam), (os.path.join(fm.WORK, efam, "look.json"), "%s_look.json" % efam)):
    if os.path.exists(src) and not os.path.exists(os.path.join(bk, dst)):
        shutil.copyfile(src, os.path.join(bk, dst))
nn, spath, w, h = fm.sd_frames(ecfg)[0]
sd = fm.rgba(spath)
mx, mn = sd[..., :3].max(-1), sd[..., :3].min(-1)
statue = (sd[..., 3] > 0.5) & ((mx - mn) < 0.25 * np.maximum(mx, 1e-6)) & (mx > 0.35)
ys, xs = np.nonzero(statue)
tb = (xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)


def norm(mask):
    yy, xx = np.nonzero(mask)
    crop = mask[yy.min():yy.max() + 1, xx.min():xx.max() + 1].astype(np.uint8) * 255
    return np.asarray(Image.fromarray(crop).resize((32, 32), Image.BILINEAR)) > 127


tgt = norm(statue)
with open(os.path.join(fm.WORK, mfam, "fit.json"), "r", encoding="utf-8") as fh:
    mfit = json.load(fh)
od = os.path.join(fm.OVERLAY_DIR, mcfg["source"])
scores = []
for mnn, mp, mw, mh in fm.sd_frames(mcfg):
    cand = glob.glob(os.path.join(od, "f%02d_*.png" % mnn)) or glob.glob(os.path.join(fm.WORK, mfam, "final", "f%02d.png" % mnn))
    if not cand or str(mnn) not in mfit["frames"]:
        continue
    a = fm.box_down(fm.premul(fm.rgba(cand[0])), mcfg["scale"])[..., 3] > 0.5
    if not a.any():
        continue
    n = norm(a)
    for mirror in (False, True):
        m = n[:, ::-1] if mirror else n
        scores.append(((m & tgt).sum() / max(1, (m | tgt).sum()), mnn, mirror, a))
scores.sort(key=lambda t: -t[0])


def side_view(s):
    """The statues are profiles: keep poses within 15 deg of a side view when the rig has a yaw."""
    y = mfit["frames"][str(s[1])]["pose"].get("yaw")
    return y is None or min(abs((float(y) - c + 180) % 360 - 180) for c in (0.0, 180.0)) <= 15.0


best = ([s for s in scores if side_view(s)] or scores)[:6]
print("statue bbox %s; best poses %s" % (tb, [(s[1], s[2], round(float(s[0]), 3)) for s in best]))
iou, mnn, mirror, a = best[0]
ay, ax = np.nonzero(a)
mb = (ax.min(), ay.min(), ax.max() + 1, ay.max() + 1)
with open(os.path.join(fm.WORK, efam, "fit.json"), "r", encoding="utf-8") as fh:
    efit = json.load(fh)


def cam(fit, nn_):
    R, pl = fit["R"], fit["placement"]
    dx, dy = fit["frames"].get(str(nn_), {}).get("shift", (0, 0))
    return (fm.ORTHO_DEFAULT / R) / pl["k"], (pl["k"] * R / 2 + pl["ox"] + dx, pl["k"] * R / 2 + pl["oy"] + dy)


ue, pe = cam(efit, nn)
um, pm = cam(mfit, mnn)
k = float(np.mean([(tb[2] - tb[0]) / (mb[2] - mb[0]), (tb[3] - tb[1]) / (mb[3] - mb[1])])) * ue / um
mcx, mcy = ((mb[0] + mb[2]) / 2 - pm[0]) * um * k, -((mb[1] + mb[3]) / 2 - pm[1]) * um * k
if mirror:
    mcx = -mcx
tcx, tcy = ((tb[0] + tb[2]) / 2 - pe[0]) * ue, -((tb[1] + tb[3]) / 2 - pe[1]) * ue
eo = fm._opts(efam, ecfg)
half = float(eo.get("half", 0.96))
pxu = half / 16.0
mo = fm.frame_opts(mcfg, mnn, base=fm._opts(mfam, mcfg))
mo.update(fm._look_frame_opts(mfam).get(str(mnn), {}))
poses = [mfit["frames"][str(s[1])]["pose"] for s in best]
base = ecfg.get("frame_opts", {}).get(str(nn), {}).get("base", [214, 0, 0])
opts = {"monster_mode": mcfg["mode"], "monster_opts": mo, "monster_pose": poses[0], "statue_mirror": bool(mirror),
        "statue_k": round(k, 4), "statue_x": round((tcx - mcx) / pxu, 3), "statue_y": round((tcy - mcy) / pxu, 3),
        "statue_dz": 0.25, "statue_fz": 1.0, "base": base, "silver": [205, 205, 210]}
for key in ("half", "height", "bevel", "base_gain", "gamma", "key", "world", "fill", "key_dir"):
    if key in eo:
        opts[key] = eo[key]
ref = {"statue_k": {"step": round(k * 0.04, 4), "min": round(k * 0.7, 4), "max": round(k * 1.3, 4), "init": round(k, 4)},
       "statue_x": {"step": 0.5, "min": opts["statue_x"] - 6, "max": opts["statue_x"] + 6, "init": opts["statue_x"]},
       "statue_y": {"step": 0.5, "min": opts["statue_y"] - 6, "max": opts["statue_y"] + 6, "init": opts["statue_y"]},
       "statue_dz": {"step": 0.05, "min": 0.02, "max": 0.8, "init": 0.25},
       "statue_fz": {"step": 0.1, "min": 0.3, "max": 1.5, "init": 1.0},
       "silver_gain": {"step": 0.05, "min": 0.6, "max": 1.3, "init": 1.0},
       "base_gain": {"step": 0.05, "min": 0.7, "max": 1.4, "init": float(opts.get("base_gain", 1.0))},
       "gamma": {"step": 0.1, "min": 0.6, "max": 1.3, "init": float(opts.get("gamma", 1.0))},
       "key": {"step": 0.4, "min": 1.5, "max": 7.0, "init": float(opts.get("key", 3.8))},
       "world": {"step": 0.04, "min": 0.0, "max": 0.4, "init": float(opts.get("world", 0.11))}}
cfg = {"status": ecfg.get("status", "wip"), "source": ecfg["source"], "frames": ecfg["frames"], "mode": "emblem3d",
       "note": ("The %s SPAWNER emblem f%02d: emblem3d.py -- the nasty's own 3D model (%s, %s pose of f%02d%s) cast "
                "in silver in front of the red slab, its real shadow on the red. Setup: tmp/emblem3d_setup.py; "
                "reproduce: look final verify." % (mfam.split("_")[0], nn, mfam, mcfg["mode"], mnn,
                                                     ", mirrored" if mirror else "")),
       "opts": opts,
       "sweep": ecfg["sweep"], "scale": ecfg["scale"], "samples": ecfg["samples"],
       "look": {"frames": 1, "passes": 2, "samples": 64, "group_frames": 1,
                "params": {"monster_pose": poses, "statue_mirror": [bool(mirror), not mirror]},
                "refine": ref, "refine_rounds": 8, "iou_w": 200, "iou_margin": 0.03, "detail_w": 0.5},
       "gate": ecfg["gate"], "fps": ecfg.get("fps", 30)}
if ecfg.get("post"):
    cfg["post"] = ecfg["post"]
with open(ep, "w", encoding="utf-8") as fh:
    json.dump(cfg, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
lp = os.path.join(fm.WORK, efam, "look.json")
if os.path.exists(lp):
    os.remove(lp)
print("%s -> emblem3d: pose f%02d%s k %.3f x %.2f y %.2f" % (efam, mnn, " mirrored" if mirror else "", k,
                                                             opts["statue_x"], opts["statue_y"]))
