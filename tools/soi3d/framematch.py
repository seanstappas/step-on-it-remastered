#!/usr/bin/env python3
"""framematch.py -- FRAME-MATCHED 3D sprite remaster.

Every original SD frame (extracted/sprites/<sheet>/fNN_WxH.png -- NOT the HD upscale, so no detail is
lost) gets a 3D-rendered replacement whose pose is FITTED to that frame and GATED against it. The
game draws the originals by frame index from its own logic (Wheelie +0x56, Creeper grow counter, ...),
so a per-frame replacement set keeps the original timing exactly; `--3d` loads it.

Config (the family's own file, no shared writes): extracted/sprites_3d/<family>/frames.json
  {
    "source": "disk_sprites",              # sheet folder under extracted/sprites
    "frames": {"range": [2, 25]},          # {"range": [first, last]} inclusive, or a list, or "all"
    "mode": "disk", "opts": {},            # builder with a soi3d.register_frames() interface
    "sweep": [{"param": "spin", "start": 0, "stop": 90, "step": 0.5, "period": 90}],
    "fit": "linear",                       # linear (pose = a + b*i, i = frame order) | free
    "scale": 4,                            # overlay scale (== extracted/sprites_hd)
    "samples": {"sweep": 16, "final": 256},
    "post": [{"glint": {"cx": 0.32, "cy": 0.20, "rad": 0.14, "color": [165, 250, 165]}}],
    "gate": {"iou": 0.88, "de": 10.0},     # per-frame: silhouette IoU >= iou AND blurred mean dE76 <= de
    "fps": 30                              # side-by-side video cadence
  }

Stages (default = all, in order):
  py tools/soi3d/framematch.py <family> [sweep] [fit] [look] [final] [verify]
  sweep  render a pose sweep (one Blender run, GPU when present)
  fit    fit the 2D placement (scale/offset) + each frame's pose to the SD frames ("smooth" per param:
         loop / linear / fourier:N / const / free over the frame order)
  look   optional ("look" block): coordinate-descent the builder's colour/light options against the
         SD frames at the fitted poses (work/look.json overrides "opts")
  final  render every frame at scale x its SD size with the fitted camera + pose, apply post
         steps, write the game overlay extracted/sprites_3d_frames/<sheet>/fNN_{sW}x{sH}.png
  verify downscale each overlay frame back to SD and gate it: silhouette IoU, blurred dE (discounts the
         pixel-art dithering, not a wrong shape/pose/hue) and frame IDENTITY (the 3D frame must match its
         own source frame best, +-rank_tol); writes extracted/sprites_3d/<family>/_verify/
         frames_{report.json,sheet.png,anim.mp4}; exit 1 on a fail

Env: SOI_BLENDER (blender.exe), SOI3D_WORK (scratch root, default <repo>/tmp/soi3d_work), ffmpeg on
PATH or SOI_FFMPEG.
"""
import glob
import itertools
import json
import math
import os
import shutil
import subprocess
import sys
import tempfile

import numpy as np
from PIL import Image, ImageDraw

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SD_DIR = os.path.join(ROOT, "extracted", "sprites")
HD_DIR = os.path.join(ROOT, "extracted", "sprites_hd")
FAM_DIR = os.path.join(ROOT, "extracted", "sprites_3d")
OVERLAY_DIR = os.path.join(ROOT, "extracted", "sprites_3d_frames")
BLENDER = os.environ.get("SOI_BLENDER", r"D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe")
WORK = os.environ.get("SOI3D_WORK", os.path.join(ROOT, "tmp", "soi3d_work"))
ORTHO_DEFAULT = 2.15          # common.setup_scene's camera


# ---------------------------------------------------------------------------------------- io
def load_cfg(family):
    with open(os.path.join(FAM_DIR, family, "frames.json"), "r", encoding="utf-8-sig") as fh:   # BOM-tolerant
        cfg = json.load(fh)
    cfg.setdefault("opts", {})
    cfg.setdefault("fit", "free")
    cfg.setdefault("scale", 4)
    cfg.setdefault("samples", {})
    cfg.setdefault("post", [])
    cfg.setdefault("gate", {"iou": 0.88, "de": 10.0})
    cfg.setdefault("fps", 30)
    if isinstance(cfg["sweep"], dict):
        cfg["sweep"] = [cfg["sweep"]]
    return cfg


def sd_frames(cfg):
    """[(nn, path, W, H)] of the covered source frames, in frame order."""
    found = {}
    for p in glob.glob(os.path.join(SD_DIR, cfg["source"], "f*_*x*.png")):
        b = os.path.basename(p)
        nn = int(b[1:b.index("_")])
        w, h = (int(v) for v in b[b.index("_") + 1:-4].split("x"))
        found[nn] = (nn, p, w, h)
    sel = cfg.get("frames", "all")
    if sel == "all":
        keys = sorted(found)
    elif isinstance(sel, dict) and "range" in sel:
        keys = [k for k in range(sel["range"][0], sel["range"][1] + 1) if k in found]
    else:
        keys = [k for k in sel if k in found]
    return [found[k] for k in keys]


def rgba(path):
    return np.asarray(Image.open(path).convert("RGBA")).astype(np.float64) / 255.0


def premul(a):
    out = a.copy()
    out[..., :3] *= out[..., 3:4]
    return out


def box_down(pm, s):
    """Premultiplied (H*s, W*s, 4) -> (H, W, 4) area average."""
    h, w = pm.shape[0] // s, pm.shape[1] // s
    return pm[:h * s, :w * s].reshape(h, s, w, s, 4).mean(axis=(1, 3))


# ------------------------------------------------------------------------------------ metrics
def _lab(rgb):
    c = np.where(rgb <= 0.04045, rgb / 12.92, ((rgb + 0.055) / 1.055) ** 2.4)
    m = np.array([[0.4124, 0.3576, 0.1805], [0.2126, 0.7152, 0.0722], [0.0193, 0.1192, 0.9505]])
    xyz = c @ m.T / np.array([0.95047, 1.0, 1.08883])
    f = np.where(xyz > 216 / 24389, np.cbrt(xyz), (24389 / 27 * xyz + 16) / 116)
    return np.stack([116 * f[..., 1] - 16, 500 * (f[..., 0] - f[..., 1]), 200 * (f[..., 1] - f[..., 2])], -1)


def compare(sd_pm, r_pm):
    """(iou, mean dE76 over the union, composited over the game's black) for premultiplied arrays."""
    a, b = sd_pm[..., 3] > 0.5, r_pm[..., 3] > 0.5
    uni = a | b
    iou = float((a & b).sum()) / max(1, int(uni.sum()))
    de = np.linalg.norm(_lab(np.clip(sd_pm[..., :3], 0, 1)) - _lab(np.clip(r_pm[..., :3], 0, 1)), axis=-1)
    return iou, float(de[uni].mean()) if uni.any() else 0.0


def _blur(pm, sigma=1.0):
    """Separable Gaussian on a premultiplied (H, W, 4) array (zero = transparent padding)."""
    r = int(math.ceil(2.5 * sigma))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / sigma) ** 2)
    k /= k.sum()
    h, w = pm.shape[:2]
    p = np.pad(pm, ((r, r), (r, r), (0, 0)))
    hz = sum(k[i] * p[:, i:i + w] for i in range(2 * r + 1))
    return sum(k[i] * hz[i:i + h] for i in range(2 * r + 1))


def compare_blur(sd_pm, r_pm, sigma=1.0):
    """Mean dE76 after a sigma-px Gaussian on both (over the sharp union): the 'roughly matches' score
    -- it discounts the source's dithering / sub-pixel shading texture but not a wrong shape, pose or hue."""
    uni = (sd_pm[..., 3] > 0.5) | (r_pm[..., 3] > 0.5)
    a, b = _blur(sd_pm, sigma), _blur(r_pm, sigma)
    de = np.linalg.norm(_lab(np.clip(a[..., :3], 0, 1)) - _lab(np.clip(b[..., :3], 0, 1)), axis=-1)
    return float(de[uni].mean()) if uni.any() else 0.0


# ------------------------------------------------------------------------------------ blender
def run_blender(job, tag):
    os.makedirs(WORK, exist_ok=True)
    jp = os.path.join(WORK, "%s.job.json" % tag)
    with open(jp, "w", encoding="utf-8") as fh:
        json.dump(job, fh)
    if not os.path.exists(BLENDER):
        raise SystemExit("Blender not found: set SOI_BLENDER (looked at %s)" % BLENDER)
    cmd = [BLENDER, "--background", "--factory-startup", "--python",
           os.path.join(ROOT, "tools", "soi3d", "frames_blender.py"), "--", jp]
    res = subprocess.run(cmd, capture_output=True, text=True)
    tail = [ln for ln in res.stdout.splitlines() if ln.startswith(("frames_blender", "FRAMES_DONE"))]
    print("\n".join(tail))
    if "FRAMES_DONE" not in res.stdout:
        print(res.stdout[-3000:], res.stderr[-3000:])
        raise SystemExit("blender job %s failed" % tag)


def sweep_poses(cfg):
    axes = []
    for ax in cfg["sweep"]:
        n = int(round((ax["stop"] - ax["start"]) / ax["step"]))
        vals = [ax["start"] + i * ax["step"] for i in range(n + (0 if ax.get("period") else 1))]
        axes.append([(ax["param"], v) for v in vals])
    return [dict(c) for c in itertools.product(*axes)]


def workdir(family, *parts):
    d = os.path.join(WORK, family, *parts)
    os.makedirs(d, exist_ok=True)
    return d


def frame_opts(cfg, nn, base=None):
    """Effective builder options of frame nn: base (default cfg opts) + cfg["frame_opts"][nn] (a variant
    such as a clock's fill or a multiplier's digit that the same builder renders per frame)."""
    o = dict(cfg["opts"] if base is None else base)
    o.update(cfg.get("frame_opts", {}).get(str(nn), {}))
    return o


def opt_groups(cfg, frames, base=None):
    """[(opts, [nn...])] -- the covered frames grouped by their effective options, in frame order."""
    out, idx = [], {}
    for nn, _, _, _ in frames:
        o = frame_opts(cfg, nn, base)
        key = json.dumps(o, sort_keys=True)
        if key not in idx:
            idx[key] = len(out)
            out.append((o, []))
        out[idx[key]][1].append(nn)
    return out


# ------------------------------------------------------------------------------------- stages
def stage_sweep(family, cfg):
    frames = sd_frames(cfg)
    R = cfg["scale"] * max(max(w, h) for _, _, w, h in frames)
    poses = sweep_poses(cfg)
    d = workdir(family, "sweep")
    for f in glob.glob(os.path.join(d, "*.png")):
        os.remove(f)
    groups = opt_groups(cfg, frames)
    items = [{"out": os.path.join(d, "s_g%02d_%05d.png" % (gi, i)), "pose": p, "opts": g[0]}
             for gi, g in enumerate(groups) for i, p in enumerate(poses)]
    run_blender({"mode": cfg["mode"], "opts": groups[0][0], "size": [R, R], "samples":
                 cfg["samples"].get("sweep", 16), "items": items}, family + "_sweep")
    with open(os.path.join(d, "poses.json"), "w", encoding="utf-8") as fh:
        json.dump({"R": R, "poses": poses, "groups": [g[1] for g in groups]}, fh)
    print("sweep: %d poses x %d option group(s) at %dx%d" % (len(poses), len(groups), R, R))


def _bbox(alpha):
    ys, xs = np.where(alpha > 0.5)
    if not len(xs):
        return None
    return xs.min(), ys.min(), xs.max() + 1, ys.max() + 1


def _to_sd(img_rgba_pil, k, ox, oy, w, h, ss=4):
    """Map a sweep render into a (w, h) SD canvas: SD px = k * render px + (ox, oy). Premultiplied."""
    a, c = 1.0 / (k * ss), -ox / k
    e, f = 1.0 / (k * ss), -oy / k
    t = img_rgba_pil.transform((w * ss, h * ss), Image.AFFINE, (a, 0, c, 0, e, f), resample=Image.BICUBIC)
    return box_down(np.asarray(t).astype(np.float64) / 255.0, ss)


def stage_fit(family, cfg):
    frames = sd_frames(cfg)
    d = workdir(family, "sweep")
    with open(os.path.join(d, "poses.json"), "r", encoding="utf-8") as fh:
        sw = json.load(fh)
    R, poses = sw["R"], sw["poses"]
    grp_frames = sw.get("groups") or [[nn for nn, _, _, _ in frames]]
    gof = {nn: gi for gi, g in enumerate(grp_frames) for nn in g}
    rends = [[Image.open(os.path.join(d, "s_g%02d_%05d.png" % (gi, i))).convert("RGBa")
              for i in range(len(poses))] for gi in range(len(grp_frames))]
    sds = [(nn, premul(rgba(p)), w, h) for nn, p, w, h in frames]
    # 1. placement from bounding boxes (median over frames / renders)
    sb = [_bbox(s[..., 3]) for _, s, _, _ in sds]
    rb = [_bbox(np.asarray(r)[..., 3] / 255.0) for rend in rends for r in rend]
    sb = [b for b in sb if b]
    rb = [b for b in rb if b]
    sw_ = np.median([b[2] - b[0] for b in sb]); sh_ = np.median([b[3] - b[1] for b in sb])
    rw_ = np.median([b[2] - b[0] for b in rb]); rh_ = np.median([b[3] - b[1] for b in rb])
    k = float(np.mean([sw_ / rw_, sh_ / rh_]))
    scx = np.median([(b[0] + b[2]) / 2 for b in sb]); scy = np.median([(b[1] + b[3]) / 2 for b in sb])
    rcx = np.median([(b[0] + b[2]) / 2 for b in rb]); rcy = np.median([(b[1] + b[3]) / 2 for b in rb])
    ox, oy = float(scx - k * rcx), float(scy - k * rcy)

    def match(k, ox, oy):
        cache = {}
        best = {}
        for nn, s, w, h in sds:
            g = gof[nn]
            if (g, w, h) not in cache:
                cache[(g, w, h)] = [_to_sd(r, k, ox, oy, w, h) for r in rends[g]]
            scores = [compare(s, m) for m in cache[(g, w, h)]]
            order = sorted(range(len(scores)), key=lambda i: scores[i][1] + 40.0 * (1 - scores[i][0]))
            best[nn] = (order[0], scores)
        return best

    def placement_cost(k, ox, oy, picks):
        tot = 0.0
        for (nn, s, w, h) in sds:
            m = _to_sd(rends[gof[nn]][picks[nn]], k, ox, oy, w, h)
            iou, de = compare(s, m)
            tot += de + 40.0 * (1 - iou)
        return tot / len(sds)

    best = match(k, ox, oy)
    for rnd in range(2):                       # coordinate descent: placement <-> poses
        picks = {nn: b[0] for nn, b in best.items()}
        cur = placement_cost(k, ox, oy, picks)
        for step_k, step_o in ((0.02, 0.5), (0.01, 0.25), (0.005, 0.125)):
            improved = True
            while improved:
                improved = False
                for dk, dx, dy in ((step_k, 0, 0), (-step_k, 0, 0), (0, step_o, 0), (0, -step_o, 0),
                                   (0, 0, step_o), (0, 0, -step_o)):
                    kk = k * (1 + dk)
                    c = placement_cost(kk, ox + dx, oy + dy, picks)
                    if c < cur - 1e-6:
                        k, ox, oy, cur, improved = kk, ox + dx, oy + dy, c, True
        best = match(k, ox, oy)
        print("fit: round %d placement k=%.4f ox=%.3f oy=%.3f cost=%.3f" % (rnd, k, ox, oy, cur))
    fitted = {nn: dict(poses[b[0]]) for nn, b in best.items()}
    model = None
    smooth = cfg.get("smooth", {})
    if smooth:
        model = [_smooth(fitted, [nn for nn in g if nn in fitted], cfg, smooth) for g in grp_frames]
    elif cfg["fit"] == "linear" and len(cfg["sweep"]) == 1 and cfg["sweep"][0].get("period"):
        # pose_i = a + b*i (mod period), i = frame order: slope from the median wrapped step, offset from
        # the circular mean -- robust to a few mis-picked frames (which it then corrects)
        ax = cfg["sweep"][0]
        per, pname = float(ax["period"]), ax["param"]
        order = [nn for nn, _, _, _ in frames]
        raw = np.array([fitted[nn][pname] for nn in order], dtype=float)

        def wrap(v):
            return (v + per / 2) % per - per / 2
        b = float(np.median(wrap(np.diff(raw)))) if len(raw) > 1 else 0.0
        ang = (raw - b * np.arange(len(raw))) * (2 * math.pi / per)
        a = float(math.atan2(np.sin(ang).mean(), np.cos(ang).mean()) * per / (2 * math.pi)) % per
        x = np.arange(len(raw), dtype=float)
        un = a + b * x + wrap(raw - (a + b * x))       # unwrap about the robust model, then least squares
        if len(raw) > 2:
            b, a = (float(v) for v in np.polyfit(x, un, 1))
        if cfg.get("loop") and len(raw) > 1:           # a looping cycle covers whole periods exactly
            step = per / len(raw)
            b = round(b / step) * step
            ang = (raw - b * x) * (2 * math.pi / per)
            a = float(math.atan2(np.sin(ang).mean(), np.cos(ang).mean()) * per / (2 * math.pi))
        a %= per
        res = wrap(raw - (a + b * np.arange(len(raw))))
        rms = float(np.sqrt((res ** 2).mean()))
        model = {"param": pname, "a": a, "b": b, "rms": rms, "period": per}
        for i, nn in enumerate(order):
            fitted[nn][pname] = float((a + b * i) % per)
        print("fit: linear %s = %.3f + %.4f*i (mod %g), residual rms %.3f" % (pname, a, b, per, rms))
    report = {}
    for nn, b in best.items():
        iou, de = b[1][b[0]]
        report[nn] = {"pose": fitted[nn], "sweep_pick": poses[b[0]], "iou": round(iou, 4), "de": round(de, 3)}
    out = {"R": R, "placement": {"k": k, "ox": ox, "oy": oy}, "model": model, "frames": report}
    with open(os.path.join(workdir(family), "fit.json"), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=1)
    ious = [v["iou"] for v in report.values()]
    des = [v["de"] for v in report.values()]
    print("fit: %d frames, sweep-match IoU min %.3f mean %.3f, dE mean %.2f max %.2f" %
          (len(report), min(ious), np.mean(ious), np.mean(des), max(des)))


def _smooth(fitted, order, cfg, smooth):
    """Per-parameter smoothing of the raw per-frame sweep picks over the frame order (in place).
    smooth = {param: "linear" | "loop" | "fourier:N" | "const" | "free"}; "loop" = linear with the slope
    snapped so the N frames cover whole periods (seamless cycle); "fourier:N" = N harmonics periodic over
    the N frames (a seamless wobble); "const" = one value for every frame (circular mean if periodic)."""
    axes = {ax["param"]: ax for ax in cfg["sweep"]}
    x = np.arange(len(order), dtype=float)
    model = {}
    for pname, how in smooth.items():
        per = float(axes[pname].get("period") or 0)
        raw = np.array([fitted[nn][pname] for nn in order], dtype=float)

        def wrap(v):
            return (v + per / 2) % per - per / 2 if per else v
        if how in ("linear", "loop"):
            b = float(np.median(wrap(np.diff(raw)))) if len(raw) > 1 else 0.0
            if per:
                ang = (raw - b * x) * (2 * math.pi / per)
                a = float(math.atan2(np.sin(ang).mean(), np.cos(ang).mean()) * per / (2 * math.pi))
            else:
                a = float(np.median(raw - b * x))
            un = a + b * x + wrap(raw - (a + b * x))
            if len(raw) > 2:
                b, a = (float(v) for v in np.polyfit(x, un, 1))
            if how == "loop" and per and len(raw) > 1:
                step = per / len(raw)
                b = round(b / step) * step
                ang = (raw - b * x) * (2 * math.pi / per)
                a = float(math.atan2(np.sin(ang).mean(), np.cos(ang).mean()) * per / (2 * math.pi))
            val = a + b * x
            model[pname] = {"how": how, "a": a, "b": b}
        elif how.startswith("fourier"):
            nh = int(how.split(":")[1]) if ":" in how else 1
            cols = [np.ones_like(x)]
            for n in range(1, nh + 1):
                cols += [np.cos(2 * math.pi * n * x / len(x)), np.sin(2 * math.pi * n * x / len(x))]
            A = np.stack(cols, 1)
            coef, *_ = np.linalg.lstsq(A, raw, rcond=None)
            val = A @ coef
            model[pname] = {"how": how, "coef": [float(c) for c in coef]}
        elif how == "const":
            if per:
                ang = raw * (2 * math.pi / per)
                c = math.atan2(np.sin(ang).mean(), np.cos(ang).mean()) * per / (2 * math.pi)
            else:
                c = float(np.median(raw))
            val = np.full_like(raw, c)
            model[pname] = {"how": how, "value": float(c)}
        else:
            continue
        res = wrap(raw - val)
        model[pname]["rms"] = float(np.sqrt((res ** 2).mean()))
        for i, nn in enumerate(order):
            fitted[nn][pname] = float(val[i] % per) if per else float(val[i])
        print("fit: smooth %s (%s) residual rms %.3f" % (pname, how, model[pname]["rms"]))
    return model


def _post(path, steps):
    for st in steps:
        if "glint" in st:
            sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
            from apply_glint import add_glint
            g = st["glint"]
            add_glint(path, path, cx=g.get("cx", 0.32), cy=g.get("cy", 0.20), rad=g.get("rad", 0.14),
                      color=tuple(g.get("color", (165, 250, 165))), core=g.get("core", 0.55))


def _final_cam(fit, w, h):
    """Ortho camera that puts the fitted placement on a (w, h)-SD-px canvas (any output scale)."""
    R, pl = fit["R"], fit["placement"]
    k, ox, oy = pl["k"], pl["ox"], pl["oy"]
    u_sd = (ORTHO_DEFAULT / R) / k                   # world units per SD pixel
    p0x, p0y = k * R / 2 + ox, k * R / 2 + oy         # SD px where the world origin lands
    return {"ortho_scale": max(w, h) * u_sd, "x": (w / 2 - p0x) * u_sd, "y": -(h / 2 - p0y) * u_sd}


def _opts(family, cfg):
    """The builder options: frames.json "opts" overlaid with the fitted look (work/look.json)."""
    o = dict(cfg["opts"])
    lp = os.path.join(WORK, family, "look.json")
    if os.path.exists(lp):
        with open(lp, "r", encoding="utf-8") as fh:
            o.update(json.load(fh)["opts"])
    return o


def stage_look(family, cfg):
    """Calibrate the builder's LOOK options (colours / lights) to the SD frames at the fitted poses:
    coordinate descent over cfg["look"]["params"] = {opt: [candidates...]} scoring the mean blurred dE
    of a frame subset (post steps applied). Only a real improvement moves an option off its start."""
    look = cfg.get("look")
    if not look:
        print("look: no \"look\" block, skipping")
        return
    frames = sd_frames(cfg)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    s = cfg["scale"]
    nsub = int(look.get("frames", 6))
    sub = [frames[int(i * len(frames) / nsub)] for i in range(min(nsub, len(frames)))]
    d = workdir(family, "look")
    best = dict(cfg["opts"])

    def score_many(variants):
        items, keys = [], []
        for vi, opts in enumerate(variants):
            for nn, _, w, h in sub:
                out = os.path.join(d, "v%03d_f%02d.png" % (vi, nn))
                items.append({"out": out, "pose": fit["frames"][str(nn)]["pose"],
                              "opts": frame_opts(cfg, nn, base=opts)})
                keys.append((vi, nn, out))
        groups = {}
        for it, key in zip(items, keys):
            nn = key[1]
            w, h = next((fw, fh_) for fn, _, fw, fh_ in sub if fn == nn)
            groups.setdefault((w, h), []).append(it)
        for (w, h), its in groups.items():
            run_blender({"mode": cfg["mode"], "opts": its[0]["opts"], "size": [w * s, h * s],
                         "camera": _final_cam(fit, w, h), "samples": look.get("samples", 64), "items": its},
                        "%s_look" % family)
        tot = [0.0] * len(variants)
        for vi, nn, out in keys:
            _post(out, cfg["post"])
            p = next(pp for fn, pp, _, _ in sub if fn == nn)
            tot[vi] += compare_blur(premul(rgba(p)), box_down(premul(rgba(out)), s)) / len(sub)
        return tot

    cur = score_many([best])[0]
    start = cur
    print("look: start dE %.3f" % cur)
    for _ in range(int(look.get("passes", 2))):
        moved = False
        for pname, cands in look["params"].items():
            variants = []
            for c in cands:
                if best.get(pname) != c:
                    o = dict(best)
                    o[pname] = c
                    variants.append(o)
            if not variants:
                continue
            sc = score_many(variants)
            i = int(np.argmin(sc))
            if sc[i] < cur - 0.05:
                best, cur, moved = variants[i], sc[i], True
                print("look: %s -> %s  dE %.3f" % (pname, json.dumps(best[pname]), cur))
        if not moved:
            break
    with open(os.path.join(workdir(family), "look.json"), "w", encoding="utf-8") as fh:
        json.dump({"opts": best, "de_start": start, "de": cur}, fh, indent=1)
    print("look: dE %.3f -> %.3f with %s" % (start, cur, json.dumps(best)))


def stage_final(family, cfg):
    frames = sd_frames(cfg)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    s = cfg["scale"]
    d = workdir(family, "final")
    base = _opts(family, cfg)
    groups = {}
    for nn, _, w, h in frames:
        groups.setdefault((w, h), []).append(nn)
    for (w, h), nns in groups.items():
        items = [{"out": os.path.join(d, "f%02d.png" % nn), "pose": fit["frames"][str(nn)]["pose"],
                  "opts": frame_opts(cfg, nn, base=base)} for nn in nns]
        run_blender({"mode": cfg["mode"], "opts": items[0]["opts"], "size": [w * s, h * s],
                     "camera": _final_cam(fit, w, h), "samples": cfg["samples"].get("final", 256),
                     "items": items}, "%s_final_%dx%d" % (family, w, h))
    od = os.path.join(OVERLAY_DIR, cfg["source"])
    os.makedirs(od, exist_ok=True)
    for nn, _, w, h in frames:
        src = os.path.join(d, "f%02d.png" % nn)
        _post(src, cfg["post"])
        for old in glob.glob(os.path.join(od, "f%02d_*.png" % nn)):
            os.remove(old)
        shutil.copyfile(src, os.path.join(od, "f%02d_%dx%d.png" % (nn, w * s, h * s)))
    print("final: %d frames -> %s" % (len(frames), os.path.relpath(od, ROOT)))


def _ffmpeg():
    return shutil.which("ffmpeg") or os.environ.get("SOI_FFMPEG") or r"D:\Program Files\Tools\ffmpeg.exe"


def stage_verify(family, cfg, write=True):
    frames = sd_frames(cfg)
    s = cfg["scale"]
    gate = cfg["gate"]
    od = os.path.join(OVERLAY_DIR, cfg["source"])
    vd = os.path.join(FAM_DIR, family, "_verify")
    os.makedirs(vd, exist_ok=True)
    rows, fails = [], []
    downs = {}
    for nn, p, w, h in frames:
        cand = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        if cand:
            r = premul(rgba(cand[0]))
            if r.shape[0] == h * s and r.shape[1] == w * s:
                downs[nn] = box_down(r, s)
    sds = {nn: premul(rgba(p)) for nn, p, _, _ in frames}
    order = [nn for nn, _, _, _ in frames]
    tol = int(gate.get("rank_tol", 1))
    for nn, p, w, h in frames:
        sd = sds[nn]
        cand = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        if not cand:
            fails.append(nn)
            rows.append({"frame": nn, "missing": True})
            continue
        r = premul(rgba(cand[0]))
        if r.shape[0] != h * s or r.shape[1] != w * s:
            fails.append(nn)
            rows.append({"frame": nn, "bad_size": list(r.shape[:2])})
            continue
        iou, de = compare(sd, box_down(r, s))
        deb = compare_blur(sd, box_down(r, s))
        # frame identity: the 3D frame must match ITS source frame best (cyclic +-tol for slow motion)
        same = [m for m in order if sds[m].shape == sd.shape]
        scores = {m: (deb if m == nn else compare_blur(sds[m], downs[nn])) for m in same}
        bestm = min(scores, key=scores.get)
        dist = abs(same.index(bestm) - same.index(nn))
        dist = min(dist, len(same) - dist)
        hd = glob.glob(os.path.join(HD_DIR, cfg["source"], "f%02d_*.png" % nn))
        hd_m = None
        if hd:
            hr = premul(rgba(hd[0]))
            if hr.shape[0] == h * s and hr.shape[1] == w * s:
                hd_m = [round(v, 4) for v in compare(sd, box_down(hr, s))]
        ok = iou >= gate["iou"] and deb <= gate["de"] and dist <= tol
        if not ok:
            fails.append(nn)
        rows.append({"frame": nn, "iou": round(iou, 4), "de": round(deb, 3), "de_raw": round(de, 3),
                     "best_src": bestm, "rank_dist": dist, "pass": ok, "hd_iou_de": hd_m})
    good = [r for r in rows if "iou" in r]
    summ = {"family": family, "source": cfg["source"], "frames": len(frames), "gate": gate,
            "failed": fails, "iou_min": min([r["iou"] for r in good], default=0),
            "iou_mean": round(float(np.mean([r["iou"] for r in good])) if good else 0, 4),
            "de_mean": round(float(np.mean([r["de"] for r in good])) if good else 0, 3),
            "de_max": max([r["de"] for r in good], default=0), "rows": rows}
    if write:
        with open(os.path.join(vd, "frames_report.json"), "w", encoding="utf-8") as fh:
            json.dump(summ, fh, indent=1)
        _sheet(frames, od, s, rows, os.path.join(vd, "frames_sheet.png"))
        _anim(frames, od, s, cfg["fps"], os.path.join(vd, "frames_anim.mp4"))
    print("verify %s: %d frames, IoU min %.3f mean %.3f, dE mean %.2f max %.2f -> %s" %
          (family, len(frames), summ["iou_min"], summ["iou_mean"], summ["de_mean"], summ["de_max"],
           "PASS" if not fails else "FAIL %s" % fails))
    return not fails


def _on_black(path, scale_to=None, nearest=True):
    im = Image.open(path).convert("RGBA")
    if scale_to:
        im = im.resize(scale_to, Image.NEAREST if nearest else Image.LANCZOS)
    bg = Image.new("RGBA", im.size, (0, 0, 0, 255))
    bg.alpha_composite(im)
    return bg.convert("RGB")


def _sheet(frames, od, s, rows, out, cols=6):
    """Contact sheet: per frame [SD nearest-upscaled | 3D overlay] + its IoU/dE, on the game's black."""
    cw = max(w for _, _, w, _ in frames) * s
    ch = max(h for _, _, _, h in frames) * s
    tile_w, tile_h = cw * 2 + 12, ch + 16
    n = len(frames)
    cols = min(cols, n)
    sheet = Image.new("RGB", (cols * tile_w, ((n + cols - 1) // cols) * tile_h), (40, 40, 48))
    dr = ImageDraw.Draw(sheet)
    byf = {r["frame"]: r for r in rows}
    for i, (nn, p, w, h) in enumerate(frames):
        x0, y0 = (i % cols) * tile_w, (i // cols) * tile_h
        sheet.paste(_on_black(p, (w * s, h * s)), (x0 + 2, y0 + 14))
        cand = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        if cand:
            sheet.paste(_on_black(cand[0]), (x0 + 6 + cw, y0 + 14))
        r = byf.get(nn, {})
        txt = "f%02d  IoU %.2f  dE %.1f" % (nn, r.get("iou", 0), r.get("de", 0))
        dr.text((x0 + 3, y0 + 1), txt, fill=(120, 230, 120) if r.get("pass") else (240, 110, 110))
    sheet.save(out)


def _anim(frames, od, s, fps, out, loops=4):
    ff = _ffmpeg()
    if not os.path.exists(ff) and not shutil.which(ff):
        print("verify: ffmpeg not found, skipping the animation")
        return
    cw = max(w for _, _, w, _ in frames) * s
    ch = max(h for _, _, _, h in frames) * s
    z = max(1, 256 // max(cw, ch))
    with tempfile.TemporaryDirectory() as td:
        k = 0
        for _ in range(loops):
            for nn, p, w, h in frames:
                fr = Image.new("RGB", ((cw * 2 + 24) * z, (ch + 16) * z), (20, 20, 24))
                fr.paste(_on_black(p, (w * s * z, h * s * z)), (8 * z, 8 * z))
                cand = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
                if cand:
                    fr.paste(_on_black(cand[0], (w * s * z, h * s * z), nearest=False), ((cw + 16) * z, 8 * z))
                fr = fr.resize((fr.width // 2 * 2, fr.height // 2 * 2))
                fr.save(os.path.join(td, "%05d.png" % k))
                k += 1
        subprocess.run([ff, "-y", "-loglevel", "error", "-framerate", str(fps), "-i",
                        os.path.join(td, "%05d.png"), "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "16",
                        out], check=True)


def check_all():
    """Read-only gate: every "published" family re-verifies (no files written), and the overlay tree
    holds no frame that a published family does not own (e.g. a stale work-in-progress render)."""
    ok, owned = True, set()
    for cp in sorted(glob.glob(os.path.join(FAM_DIR, "*", "frames.json"))):
        fam = os.path.basename(os.path.dirname(cp))
        cfg = load_cfg(fam)
        if cfg.get("status") != "published":
            print("check: %-24s %s (skipped)" % (fam, cfg.get("status", "no status")))
            continue
        ok = stage_verify(fam, cfg, write=False) and ok
        owned |= {(cfg["source"], nn) for nn, _, _, _ in sd_frames(cfg)}
    for p in glob.glob(os.path.join(OVERLAY_DIR, "*", "f*_*.png")):
        sheet, b = os.path.basename(os.path.dirname(p)), os.path.basename(p)
        if (sheet, int(b[1:b.index("_")])) not in owned:
            print("check: STRAY overlay frame %s/%s (no published family owns it)" % (sheet, b))
            ok = False
    print("check: %s" % ("PASS" if ok else "FAIL"))
    return ok


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    if sys.argv[1] == "--check":
        return 0 if check_all() else 1
    family = sys.argv[1]
    stages = sys.argv[2:] or ["sweep", "fit", "look", "final", "verify"]
    cfg = load_cfg(family)
    ok = True
    for st in stages:
        if st == "sweep":
            stage_sweep(family, cfg)
        elif st == "fit":
            stage_fit(family, cfg)
        elif st == "look":
            stage_look(family, cfg)
        elif st == "final":
            stage_final(family, cfg)
        elif st == "verify":
            ok = stage_verify(family, cfg) and ok
        else:
            raise SystemExit("unknown stage %r" % st)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
