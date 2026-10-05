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
    "place_iou_w": 40,                     # silhouette weight of the placement fit (cost = dE + w*(1-IoU))
    "place_frames": [21, 33],              # optional: fit the shared placement on these frames only
    "shift": "auto",                       # optional per-frame integer SD-px sprite offsets: "auto" (fitted,
                                           # +-"shift_range" px) or {"NN": [dx, dy]}; applied via the camera
    "prior": [{"frames": [2, 17], "param": "yaw", "value": 0, "tol": 25, "period": 360}],
                                           # optional soft pull of a frame range's sweep pick toward a known
                                           # pose (+ w*(dist/tol)^2, w default 20) -- e.g. a walk drawn side-on
    "scale": 4,                            # overlay scale (== extracted/sprites_hd)
    "samples": {"sweep": 16, "final": 256},
    "post": [{"glint": {"cx": 0.32, "cy": 0.20, "rad": 0.14, "color": [165, 250, 165]}}],
    "gate": {"iou": 0.88, "de": 10.0},     # per-frame: silhouette IoU >= iou AND blurred mean dE76 <= de
    "fps": 30,                             # side-by-side video cadence
    "tweens": {"n": 4, "cycles": [[2, 25]]} # optional: in-between poses for REMASTERED's smooth rendering
  }

Stages (default = all, in order):
  py tools/soi3d/framematch.py <family> [sweep] [fit] [optim] [look] [final] [verify]
  sweep  render a pose sweep (one Blender run, GPU when present)
  fit    fit the 2D placement (scale/offset) + each frame's pose to the SD frames ("smooth" per param:
         loop / linear / fourier:N / const / mode / fixed:A:B / free over the frame order)
  optim  optional ("optim" block): per-frame multi-parameter refinement from the fitted pose -- the
         path for articulated models (joint angles) that no grid sweep can cover
  optimfail  the optim restricted to the frames the last verify FAILED (from _verify/frames_report.json),
         scored exactly as verify sees them (the final scale + samples; low-sample edges shift the IoU by ~0.005),
         with a steep IoU weight, neighbour-pose reseeds and basin-hopping restarts (random pose hops, then
         +-1 px shift hops, repeated once after a gain; optim "shift_hops": false to skip); passing frames keep their poses.
         optim "probe" = [{param: [values], ...}, ...] first tries every combination of each grid on each failing
         frame (a limb swung far from where the descent sits, e.g. an arm raised to horizontal)
  bake   fold work/look.json's options into frames.json "opts" (and the look refine "init"s): `look` always
         starts from "opts", so bake between look passes or each pass restarts from the old values
  look   optional ("look" block): coordinate-descent the builder's colour/light options against the
         SD frames at the fitted poses (work/look.json overrides "opts"); "params" = {opt: [candidates]},
         "refine" = {opt: {step, min, max}} continuous +-step refinement of numeric opts afterwards;
         "frames": N evenly spaced frames are scored, plus the last verify's failing ones if "add_fails"
  final  render every frame at scale x its SD size with the fitted camera + pose, apply post
         steps, write the game overlay extracted/sprites_3d_frames/<sheet>/fNN_{sW}x{sH}.png
  verify downscale each overlay frame back to SD and gate it: silhouette IoU, blurred dE (discounts the
         pixel-art dithering, not a wrong shape/pose/hue) and frame IDENTITY (the 3D frame must match its
         own source frame best, +-rank_tol); writes extracted/sprites_3d/<family>/_verify/
         frames_{report.json,sheet.png,anim.mp4}; exit 1 on a fail
  tweens (published families, run after final) the in-between poses the game draws between two engine
         ticks at the monitor's frame rate: for each frame pair it animates between ("tweens": "cycles"
         [[first, last]] wrap last->first, "runs" [[first, last]] don't, "pairs" [[a, b]]), n-1 renders
         of the fitted pose and sprite offset lerped a->b (params with a sweep "period" -- or a tweens
         "periods" entry -- go the short way round) -> extracted/sprites_3d_frames/<sheet>/tw/
         fLO-HI_KofN.png. A pair is dropped (the game then steps it) when an in-between's silhouette is
         further from both neighbours than they are from each other ("max_drop", default 0.10 IoU);
         _verify/tweens_anim.mp4 plays each sequence with its in-betweens. `final` deletes a family's
         tweens (they would no longer match), so re-run this after it
  live   export the rig for REAL-TIME 3D in the game (tools/soi3d/live_blender.py): model.glb + live.json
         (every frame's node transforms and camera, the lights, world and materials) ->
         extracted/sprites_live/<family>/; the game poses it between any two frames at the monitor's rate
  livecal  balance the live renderer's sun vs ambient light against the SD frames (Godot's ambient is not
         shadowed by the model the way Cycles' world light is): sun-only + ambient-only passes mixed in
         linear light, grid-searched by dE -> live.json key_scale / amb_scale (run after live)
  livegate  render every frame of that rig in Godot (godot_project/scenes/live_check.tscn, the game's own
         live renderer) and score it like verify, next to the Cycles frames' scores;
         _verify/live_sheet.png = SD | Cycles | live per frame; exit 1 unless every frame passes the gate

Env: SOI_BLENDER (blender.exe), SOI3D_WORK (scratch root, default <repo>/tmp/soi3d_work), ffmpeg on
PATH or SOI_FFMPEG, SOI3D_LOOK_KEYS (comma list: `look` tunes only these of its options this run).
"""
import glob
import itertools
import json
import math
import os
import re
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
LIVE_DIR = os.path.join(ROOT, "extracted", "sprites_live")
BLENDER = os.environ.get("SOI_BLENDER", r"D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe")
GODOT = os.environ.get("SOI_GODOT", r"D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe")
WORK = os.environ.get("SOI3D_WORK", os.path.join(ROOT, "tmp", "soi3d_work"))
ORTHO_DEFAULT = 2.15          # common.setup_scene's camera
LIVE_IOU_TOL = 0.008          # livegate: a live frame this close to its published frame's scores passes
LIVE_DE_TOL = 1.0


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
    for st in cfg["post"]:
        if "occlude" in st:
            st["occlude"]["_mask"] = _union_mask(family, cfg, int(st["occlude"].get("dilate", 1)))
    return cfg


def _union_mask(family, cfg, dilate):
    """The canvas region ANY source frame draws, dilated by `dilate` SD px: a static occluder in front of
    the sprite (the Beenie over its own downward shot) hides the rest in every frame."""
    from PIL import ImageFilter
    u = None
    for _, p, _, _ in sd_frames(cfg):
        a = rgba(p)[..., 3] > 0.5
        u = a if u is None else (u | a if u.shape == a.shape else u)
    m = Image.fromarray((u * 255).astype(np.uint8))
    if dilate > 0:
        m = m.filter(ImageFilter.MaxFilter(2 * dilate + 1))
    path = os.path.join(workdir(family), "occlude_mask.png")
    m.save(path)
    return path


def sd_frames(cfg):
    """[(nn, path, W, H)] of the covered source frames, in frame order (strict fNN_WxH.png names)."""
    found = {}
    for p in glob.glob(os.path.join(SD_DIR, cfg["source"], "f*_*x*.png")):
        m = re.match(r"^f(\d+)_(\d+)x(\d+)\.png$", os.path.basename(p))
        if m:
            nn, w, h = (int(v) for v in m.groups())
            found[nn] = (nn, p, w, h)
    sel = cfg.get("frames", "all")
    if sel == "all":
        keys = sorted(found)
    elif isinstance(sel, dict) and "range" in sel:
        keys = [k for k in range(sel["range"][0], sel["range"][1] + 1) if k in found]
    else:
        keys = [k for k in sel if k in found]
    return [found[k] for k in keys]


def derived(cfg):
    """{nn: spec} of the DERIVED frames: made from another frame's 3D render, the way the original
    derives them ("crop" a shatter quarter, "scale" a spawn square, "crack" = the source's crack
    lines composited onto the 3D block). They skip sweep/fit/look but are verified like the rest."""
    return {int(k): v for k, v in cfg.get("derive", {}).items()}


def base_frames(cfg):
    dv = derived(cfg)
    return [f for f in sd_frames(cfg) if f[0] not in dv]


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


def live_iou(sd_pm, r_pm):
    """IoU for a Godot render: an MSAA edge pixel at exactly half coverage is ambiguous, so it counts as a hit
    where the source has a pixel and is left out where it has none."""
    a, strict, tie = sd_pm[..., 3] > 0.5, r_pm[..., 3] > 0.5, r_pm[..., 3] > 0.5 - 1e-6
    return float((a & tie).sum()) / max(1, int((a | strict).sum()))


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


DETAIL_PRE, DETAIL_SIGMA, DETAIL_MIN = 0.6, 1.2, 15.0


def _gauss_masked(x, m, sigma):
    """Normalised separable Gaussian of x (H, W, C) over the pixels where m (H, W) is set."""
    r = int(math.ceil(2.5 * sigma))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / sigma) ** 2)
    k /= k.sum()
    h, w = m.shape

    def conv(a):
        p = np.pad(a, ((r, r), (r, r)) + ((0, 0),) * (a.ndim - 2))
        hz = sum(k[i] * p[:, i:i + w] for i in range(2 * r + 1))
        return sum(k[i] * hz[i:i + h] for i in range(2 * r + 1))
    mw = conv(m.astype(np.float64))
    return conv(x * m[..., None]) / np.maximum(mw, 1e-6)[..., None]


def detail_miss(sd_pm, r_pm):
    """The source's small features (eyes, stripes, marks, highlights) a render loses. Detail layer D = Lab
    pre-smoothed (DETAIL_PRE px: a 1 px dither checker averages out) minus its masked surroundings
    (DETAIL_SIGMA px, opaque pixels only). For each source pixel with |D_sd| >= DETAIL_MIN (a feature),
    best = the closest render detail within 1 px (a 1 px misregistration is no miss).
    Returns (mean over the features of min(best, |D_sd|) in dE units, features, best, |D_sd|)."""
    sa, ra = sd_pm[..., 3] > 0.5, r_pm[..., 3] > 0.5
    ls, lr = _lab(np.clip(sd_pm[..., :3], 0, 1)), _lab(np.clip(r_pm[..., :3], 0, 1))
    ds = np.where(sa[..., None], _gauss_masked(ls, sa, DETAIL_PRE) - _gauss_masked(ls, sa, DETAIL_SIGMA), 0.0)
    dr = np.where(ra[..., None], _gauss_masked(lr, ra, DETAIL_PRE) - _gauss_masked(lr, ra, DETAIL_SIGMA), 0.0)
    mag = np.linalg.norm(ds, axis=-1)
    h, w = sa.shape
    best = np.full((h, w), np.inf)
    pr, pa = np.pad(dr, ((1, 1), (1, 1), (0, 0))), np.pad(ra, 1)
    for dy in (0, 1, 2):
        for dx in (0, 1, 2):
            e = np.linalg.norm(ds - pr[dy:dy + h, dx:dx + w], axis=-1)
            best = np.minimum(best, np.where(pa[dy:dy + h, dx:dx + w], e, np.inf))
    feat = sa & (mag >= DETAIL_MIN)
    score = float(np.minimum(best, mag)[feat].mean()) if feat.any() else 0.0
    return score, feat, best, mag


# ------------------------------------------------------------------------------------ blender
def run_blender(job, tag, script="frames_blender.py", done="FRAMES_DONE"):
    os.makedirs(WORK, exist_ok=True)
    jp = os.path.join(WORK, "%s.job.json" % tag)
    with open(jp, "w", encoding="utf-8") as fh:
        json.dump(job, fh)
    if not os.path.exists(BLENDER):
        raise SystemExit("Blender not found: set SOI_BLENDER (looked at %s)" % BLENDER)
    cmd = [BLENDER, "--background", "--factory-startup", "--python",
           os.path.join(ROOT, "tools", "soi3d", script), "--", jp]
    for attempt in range(3):
        res = subprocess.run(cmd, capture_output=True, text=True)
        if done in res.stdout or "EXCEPTION_ACCESS_VIOLATION" not in res.stdout + res.stderr:
            break
        print("blender job %s crashed (EXCEPTION_ACCESS_VIOLATION), retry %d" % (tag, attempt + 1))  # intermittent
    tail = [ln for ln in res.stdout.splitlines() if ln.startswith(("frames_blender", done))]
    print("\n".join(tail))
    if done not in res.stdout:
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
    frames = base_frames(cfg)
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
    matte = [s for s in cfg["post"] if "matte" in s or "fringe" in s]
    if matte:                                    # the fit must see the same keyed edges as the finals
        for it in items:
            _post(it["out"], matte)
    clipped = 0
    for it in items[::max(1, len(items) // 40)]:
        a = np.asarray(Image.open(it["out"]).convert("RGBA"))[..., 3]
        clipped += int(max(a[0].max(), a[-1].max(), a[:, 0].max(), a[:, -1].max()) > 8)
    if clipped:
        print("sweep: WARNING %d sampled renders touch the canvas edge: the model exceeds the sweep camera "
              "(+-%.2f units), so the placement fit sees a cropped model -- scale the builder down" %
              (clipped, ORTHO_DEFAULT / 2))


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
    frames = base_frames(cfg)
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

    shifts = {}                                # nn -> (dx, dy) SD px: per-frame sprite offsets ("shift")
    if isinstance(cfg.get("shift"), dict):
        shifts = {int(n): (float(v[0]), float(v[1])) for n, v in cfg["shift"].items()}

    priors = cfg.get("prior", [])             # [{"frames": [a, b], "param", "value", "tol", "period"?, "w"?}]

    def prior_pen(nn, pose):
        """Soft pull of a frame range's pick toward a known pose (e.g. yaw 0 for the frames that walk left):
        w * (distance / tol)^2, circular when the prior has a period."""
        pen = 0.0
        for pr in priors:
            if pr["frames"][0] <= nn <= pr["frames"][1] and pr["param"] in pose:
                dv = float(pose[pr["param"]]) - float(pr["value"])
                if pr.get("period"):
                    dv = (dv + pr["period"] / 2) % pr["period"] - pr["period"] / 2
                pen += float(pr.get("w", 20.0)) * (dv / float(pr["tol"])) ** 2
        return pen

    def match(k, ox, oy):
        cache = {}
        best = {}
        for nn, s, w, h in sds:
            g = gof[nn]
            dx, dy = shifts.get(nn, (0, 0))
            if (g, w, h, dx, dy) not in cache:
                cache[(g, w, h, dx, dy)] = [_to_sd(r, k, ox + dx, oy + dy, w, h) for r in rends[g]]
            scores = [compare(s, m) for m in cache[(g, w, h, dx, dy)]]
            order = sorted(range(len(scores)), key=lambda i: scores[i][1] + 40.0 * (1 - scores[i][0]) +
                           prior_pen(nn, poses[i]))
            best[nn] = (order[0], scores)
        return best

    wi = float(cfg.get("place_iou_w", 40.0))  # silhouette weight of the placement (raise it when a
                                              # still-wrong face/texture would drag the model off its outline)
    pf = cfg.get("place_frames")               # [a, b]: fit the placement on the frames the model matches best
    place_sds = [x for x in sds if pf is None or pf[0] <= x[0] <= pf[1]]

    def placement_cost(k, ox, oy, picks):
        tot = 0.0
        for (nn, s, w, h) in place_sds:
            dx, dy = shifts.get(nn, (0, 0))
            m = _to_sd(rends[gof[nn]][picks[nn]], k, ox + dx, oy + dy, w, h)
            iou, de = compare(s, m)
            tot += de + wi * (1 - iou)
        return tot / len(place_sds)

    def find_shifts(k, ox, oy, picks, rng):
        """Each frame's integer SD-px offset (the sheet's own per-frame jitter, e.g. a bob or a
        2-px alternation), normalised so the most common offset is (0, 0)."""
        out = {}
        for nn, s, w, h in sds:
            r = rends[gof[nn]][picks[nn]]
            cand = []
            for dy in range(-rng, rng + 1):
                for dx in range(-rng, rng + 1):
                    iou, de = compare(s, _to_sd(r, k, ox + dx, oy + dy, w, h))
                    cand.append((de + wi * (1 - iou), dx, dy))
            _, dx, dy = min(cand)
            out[nn] = (dx, dy)
        vals, counts = np.unique(np.array(list(out.values())), axis=0, return_counts=True)
        mx, my = (float(v) for v in vals[int(np.argmax(counts))])
        return {nn: (dx - mx, dy - my) for nn, (dx, dy) in out.items()}, mx, my

    best = match(k, ox, oy)
    rounds = 3 if cfg.get("shift") == "auto" else 2
    for rnd in range(rounds):                  # coordinate descent: placement <-> poses (<-> shifts)
        picks = {nn: b[0] for nn, b in best.items()}
        if rnd > 0 and cfg.get("shift") == "auto":
            shifts, mx, my = find_shifts(k, ox, oy, picks, int(cfg.get("shift_range", 3)))
            ox, oy = ox + mx, oy + my
            print("fit: per-frame shifts %s" % json.dumps({str(n): v for n, v in shifts.items() if v != (0, 0)}))
        cur = placement_cost(k, ox, oy, picks)
        for step_k, step_o in ((0.02, 0.5), (0.01, 0.25), (0.005, 0.125)):
            improved = True
            while improved:
                improved = False
                for dk, dx, dy in ((step_k, 0, 0), (-step_k, 0, 0), (0, step_o, 0), (0, -step_o, 0),
                                   (0, 0, step_o), (0, 0, -step_o)):
                    kk = k * (1 + dk)
                    dx, dy = dx + (k - kk) * rcx, dy + (k - kk) * rcy   # scale about the model's centre, not the corner
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
        if shifts.get(nn, (0, 0)) != (0, 0):
            report[nn]["shift"] = list(shifts[nn])
    out = {"R": R, "placement": {"k": k, "ox": ox, "oy": oy}, "model": model, "frames": report}
    with open(os.path.join(workdir(family), "fit.json"), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=1)
    ious = [v["iou"] for v in report.values()]
    des = [v["de"] for v in report.values()]
    print("fit: %d frames, sweep-match IoU min %.3f mean %.3f, dE mean %.2f max %.2f" %
          (len(report), min(ious), np.mean(ious), np.mean(des), max(des)))


def _smooth(fitted, order, cfg, smooth):
    """Per-parameter smoothing of the raw per-frame sweep picks over the frame order (in place).
    smooth = {param: "linear" | "loop" | "fourier:N" | "const" | "mode" | "fixed:A:B" | "free"}; "loop" = linear
    with the slope snapped so the N frames cover whole periods (seamless cycle); "fixed:A:B" = pose A + B*i
    exactly (a motion known from the sheet's symmetry); "fourier:N" = N harmonics periodic over
    the N frames (a seamless wobble); "const" = one value for every frame (circular mean if periodic)."""
    axes = {ax["param"]: ax for ax in cfg["sweep"]}
    x = np.arange(len(order), dtype=float)
    model = {}
    for pname, how in smooth.items():
        if pname not in axes:                             # an optim-only param has no sweep pick to smooth
            continue
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
        elif how.startswith("fixed:"):                    # a KNOWN motion: pose = A + B*i (e.g. a turn whose
            _, fa, fb = how.split(":")                      # rate is fixed by the sheet's own symmetry)
            val = float(fa) + float(fb) * x
            model[pname] = {"how": how, "a": float(fa), "b": float(fb)}
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
        elif how == "mode":                                # a categorical axis (e.g. a layout code)
            vals, counts = np.unique(raw, return_counts=True)
            c = float(vals[int(np.argmax(counts))])
            val = np.full_like(raw, c)
            model[pname] = {"how": how, "value": c}
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
        if "matte" in st:
            # the originals were anti-aliased against BLACK and keyed: their edge pixels are opaque dark
            # fringe. alpha' = min(1, alpha / thresh) keeps the premultiplied (over-black) colour.
            t = float(st["matte"].get("thresh", 0.3))
            im = rgba(path)
            a = im[..., 3:4]
            a2 = np.clip(a / t, 0.0, 1.0)
            rgb = np.where(a2 > 0, im[..., :3] * a / np.maximum(a2, 1e-6), 0.0)
            out = np.concatenate([np.clip(rgb, 0, 1), a2], -1)
            Image.fromarray((out * 255 + 0.5).astype(np.uint8), "RGBA").save(path)
        if "fringe" in st:
            # ... and their keyed edge keeps a dark rim about half an SD px wide: grow the alpha by `px`
            # render px, the new pixels black (premultiplied colour unchanged)
            from PIL import ImageFilter
            k = int(st["fringe"].get("px", 2))
            im = rgba(path)
            a = im[..., 3]
            grown = np.asarray(Image.fromarray((a * 255).astype(np.uint8)).filter(
                ImageFilter.MaxFilter(2 * k + 1))).astype(np.float64) / 255.0
            a2 = np.maximum(a, grown)
            rgb = np.where(a2[..., None] > 0, im[..., :3] * a[..., None] / np.maximum(a2, 1e-6)[..., None], 0.0)
            out = np.concatenate([np.clip(rgb, 0, 1), a2[..., None]], -1)
            Image.fromarray((out * 255 + 0.5).astype(np.uint8), "RGBA").save(path)
        if "occlude" in st:
            im = rgba(path)
            m = Image.open(st["occlude"]["_mask"]).convert("L").resize((im.shape[1], im.shape[0]), Image.NEAREST)
            k = np.asarray(m).astype(np.float64)[..., None] / 255.0
            Image.fromarray((np.clip(im * k, 0, 1) * 255 + 0.5).astype(np.uint8), "RGBA").save(path)


def _final_cam(fit, w, h, nn=None, extra=(0.0, 0.0)):
    """Ortho camera that puts the fitted placement on a (w, h)-SD-px canvas (any output scale); with a
    frame number, that frame's fitted sprite offset (fit.json frames[nn].shift, SD px) is applied too."""
    R, pl = fit["R"], fit["placement"]
    k, ox, oy = pl["k"], pl["ox"], pl["oy"]
    dx, dy = fit["frames"].get(str(nn), {}).get("shift", (0, 0)) if nn is not None else (0, 0)
    dx, dy = dx + extra[0], dy + extra[1]
    u_sd = (ORTHO_DEFAULT / R) / k                   # world units per SD pixel
    p0x, p0y = k * R / 2 + ox + dx, k * R / 2 + oy + dy   # SD px where the world origin lands
    return {"ortho_scale": max(w, h) * u_sd, "x": (w / 2 - p0x) * u_sd, "y": -(h / 2 - p0y) * u_sd}


def _opts(family, cfg):
    """The builder options: frames.json "opts" overlaid with the fitted look (work/look.json)."""
    o = dict(cfg["opts"])
    lp = os.path.join(WORK, family, "look.json")
    if os.path.exists(lp):
        with open(lp, "r", encoding="utf-8") as fh:
            o.update(json.load(fh)["opts"])
    return o


def _look_frame_opts(family):
    lp = os.path.join(WORK, family, "look.json")
    if os.path.exists(lp):
        with open(lp, "r", encoding="utf-8") as fh:
            return json.load(fh).get("frame_opts", {})
    return {}


def stage_look(family, cfg):
    """Calibrate the builder's LOOK options (colours / lights) to the SD frames at the fitted poses:
    coordinate descent over cfg["look"]["params"] = {opt: [candidates...]} scoring the mean blurred dE
    of a frame subset (post steps applied). Only a real improvement moves an option off its start."""
    look = cfg.get("look")
    if not look:
        print("look: no \"look\" block, skipping")
        return
    only = os.environ.get("SOI3D_LOOK_KEYS")      # e.g. "face_h,face_dy": tune just these options this run
    if only:
        keys = set(only.split(","))
        look = dict(look, params={k: v for k, v in look.get("params", {}).items() if k in keys},
                    refine={k: v for k, v in look.get("refine", {}).items() if k in keys})
        cfg = dict(cfg, look=look)
        print("look: only %s" % sorted(keys & (set(look["params"]) | set(look["refine"]))))
    frames = base_frames(cfg)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    s = cfg["scale"]
    nsub = int(look.get("frames", 6))
    sub = [frames[int(i * len(frames) / nsub)] for i in range(min(nsub, len(frames)))]
    if look.get("add_fails"):           # also score the last verify's failing frames (weights them in)
        rp = os.path.join(FAM_DIR, family, "_verify", "frames_report.json")
        if os.path.exists(rp):
            with open(rp, "r", encoding="utf-8") as fh:
                failed = set(json.load(fh).get("failed", []))
            have = {f[0] for f in sub}
            sub += [f for f in frames if f[0] in failed and f[0] not in have]
    print("look: %d frames %s" % (len(sub), [f[0] for f in sub]))
    d = workdir(family, "look")
    best = dict(cfg["opts"])

    def score_many(variants):
        items, keys = [], []
        for vi, opts in enumerate(variants):
            for nn, _, w, h in sub:
                out = os.path.join(d, "v%03d_f%02d.png" % (vi, nn))
                items.append({"out": out, "pose": fit["frames"][str(nn)]["pose"],
                              "opts": frame_opts(cfg, nn, base=opts), "camera": _final_cam(fit, w, h, nn)})
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
            tot[vi] += _look_score(cfg, premul(rgba(p)), box_down(premul(rgba(out)), s)) / len(sub)
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
    if look.get("refine"):
        best, cur = _look_refine(family, cfg, fit, best, cur, sub, d)
    look_fo = _look_per_kind(family, cfg, fit, best, frames, d) if look.get("per_kind") else {}
    with open(os.path.join(workdir(family), "look.json"), "w", encoding="utf-8") as fh:
        json.dump({"opts": best, "de_start": start, "de": cur, "frame_opts": look_fo}, fh, indent=1)
    print("look: dE %.3f -> %.3f with %s" % (start, cur, json.dumps(best)))


def _look_refine(family, cfg, fit, best, cur, sub, d):
    """Continuous refinement of numeric look options after the candidate passes: look "refine" =
    {opt: {"step": s, "min": a, "max": b}} (+ "refine_rounds", default 8). Each round tries +-step on
    every option (one batched Blender job), applies all improving moves, keeps the combination only if
    it beats the best single move, and halves the step of an option that found nothing."""
    look = cfg["look"]
    ref = {}
    best = dict(best)
    for k, spec in look["refine"].items():
        if k not in best and "init" not in spec:
            print("look: refine %s skipped (not in opts and no \"init\": its builder default is unknown)" % k)
            continue
        best.setdefault(k, float(spec["init"]) if k not in best else best[k])
        ref[k] = spec
    steps = {k: float(v["step"]) for k, v in ref.items()}
    cur = _score_trials(cfg, fit, [(("start",), fr, frame_opts(cfg, fr[0], base=best)) for fr in sub], d,
                        "%s_ref_s" % family)[("start",)]

    def clamp(k, v):
        return max(float(ref[k].get("min", -1e9)), min(float(ref[k].get("max", 1e9)), v))

    for rnd in range(int(look.get("refine_rounds", 8))):
        trials, moves = [], {}
        for k in ref:
            if steps[k] < float(ref[k]["step"]) * 0.12:
                continue
            for sgn in (1, -1):
                v = clamp(k, float(best[k]) + sgn * steps[k])
                if v != best[k]:
                    o = dict(best, **{k: round(v, 4)})
                    trials += [((k, sgn), fr, frame_opts(cfg, fr[0], base=o)) for fr in sub]
        if not trials:
            break
        sc = _score_trials(cfg, fit, trials, d, "%s_ref%d" % (family, rnd))
        for k in ref:
            cand = [(sc[(k, sg)], sg) for sg in (1, -1) if (k, sg) in sc]
            good = [c for c in cand if c[0] < cur - 0.02]
            if good:
                v, sg = min(good)
                moves[k] = (v, round(clamp(k, float(best[k]) + sg * steps[k]), 4))
            else:
                steps[k] *= 0.5
        if moves:
            k1, (v1, x1) = min(moves.items(), key=lambda kv: kv[1][0])
            if len(moves) > 1:
                o = dict(best, **{k: m[1] for k, m in moves.items()})
                sc2 = _score_trials(cfg, fit, [(("combo",), fr, frame_opts(cfg, fr[0], base=o)) for fr in sub],
                                    d, "%s_ref%dc" % (family, rnd))[("combo",)]
                if sc2 <= v1:
                    best, cur = o, sc2
                else:
                    best, cur = dict(best, **{k1: x1}), v1
            else:
                best, cur = dict(best, **{k1: x1}), v1
        print("look: refine round %d -> dE %.3f %s" % (rnd, cur, json.dumps({k: best[k] for k in ref})))
    return best, cur


def _score_trials(cfg, fit, trials, d, tag):
    """trials = [(tid, (nn, path, w, h), opts)] -> {tid: mean blurred dE over its frames}; one Blender
    job per frame size renders every trial."""
    s = cfg["scale"]
    by_size, keys = {}, []
    for k, (tid, fr, opts) in enumerate(trials):
        nn, _, w, h = fr
        out = os.path.join(d, "%s_%04d_f%02d.png" % (tag, k, nn))
        by_size.setdefault((w, h), []).append({"out": out, "pose": fit["frames"][str(nn)]["pose"], "opts": opts,
                                               "camera": _final_cam(fit, w, h, nn)})
        keys.append((tid, fr, out))
    for (w, h), its in by_size.items():
        run_blender({"mode": cfg["mode"], "opts": its[0]["opts"], "size": [w * s, h * s],
                     "camera": _final_cam(fit, w, h), "samples": cfg["look"].get("samples", 64), "items": its},
                    "%s_%s" % (tag, "look"))
    tot, cnt = {}, {}
    for tid, (nn, p, w, h), out in keys:
        _post(out, cfg["post"])
        tot[tid] = tot.get(tid, 0.0) + _look_score(cfg, premul(rgba(p)), box_down(premul(rgba(out)), s))
        cnt[tid] = cnt.get(tid, 0) + 1
    return {t: tot[t] / cnt[t] for t in tot}


def _look_score(cfg, sd_pm, r_pm):
    """Blurred dE, plus a steep penalty once the silhouette IoU falls toward the gate (so a colour or
    shape tweak can never buy dE with a worse outline); look "iou_w" / "iou_margin" tune it. look
    "detail_w" adds that weight x detail_miss (placing features such as eyes the blur hides)."""
    iou, _ = compare(sd_pm, r_pm)
    lk = cfg.get("look") or {}
    s = compare_blur(sd_pm, r_pm) + float(lk.get("iou_w", 60.0)) * max(
        0.0, cfg["gate"]["iou"] + float(lk.get("iou_margin", 0.01)) - iou)
    if float(lk.get("detail_w", 0.0)) > 0:
        s += float(lk["detail_w"]) * detail_miss(sd_pm, r_pm)[0]
    return s


def _look_per_kind(family, cfg, fit, best, frames, d):
    """Per option-group calibration (e.g. each tile type's colour gains / feature size): look
    "per_kind" = {kind or "*": {opt: [candidates]}}, coordinate descent per group, all groups batched
    into one Blender job per option. Returns {nn: overrides} (stored in look.json "frame_opts")."""
    look = cfg["look"]
    groups = opt_groups(cfg, frames)
    pk = look["per_kind"]
    state = []
    for gi, (gopts, nns) in enumerate(groups):
        params = pk.get(gopts.get("kind", "*"), pk.get("*", {}))
        subf = [f for f in frames if f[0] in nns][:int(look.get("group_frames", 2))]
        state.append({"params": params, "frames": subf, "over": {}, "score": None})
    trials = [((gi, "cur"), fr, frame_opts(cfg, fr[0], base=best)) for gi, st in enumerate(state)
              for fr in st["frames"]]
    sc = _score_trials(cfg, fit, trials, d, family + "_pk0")
    for gi, st in enumerate(state):
        st["score"] = sc[(gi, "cur")]
    names = []
    for st in state:
        for p in st["params"]:
            if p not in names:
                names.append(p)
    for ps in range(int(look.get("passes", 2))):
        moved = False
        for pname in names:
            trials = []
            for gi, st in enumerate(state):
                for ci, c in enumerate(st["params"].get(pname, [])):
                    if st["over"].get(pname) == c:
                        continue
                    ov = dict(st["over"], **{pname: c})
                    for fr in st["frames"]:
                        eo = frame_opts(cfg, fr[0], base=best)
                        eo.update(ov)
                        trials.append(((gi, ci), fr, eo))
            if not trials:
                continue
            sc = _score_trials(cfg, fit, trials, d, "%s_pk%d_%s" % (family, ps, pname))
            for gi, st in enumerate(state):
                cand = {ci: v for (g, ci), v in sc.items() if g == gi}
                if not cand:
                    continue
                ci = min(cand, key=cand.get)
                if cand[ci] < st["score"] - 0.05:
                    st["over"][pname] = st["params"][pname][ci]
                    st["score"] = cand[ci]
                    moved = True
        if not moved:
            break
    out = {}
    for (gopts, nns), st in zip(groups, state):
        for nn in nns:
            out[str(nn)] = st["over"]
        print("look: group %s -> dE %.2f %s" % (nns[0], st["score"], json.dumps(st["over"])))
    return out


def _render_score(cfg, fit, trials, d, tag, scale, samples):
    """trials = [(tid, (nn, path, w, h), pose, opts)] rendered at `scale` x SD -> {tid: look score}."""
    by_size, keys = {}, []
    for k, (tid, fr, pose, opts) in enumerate(trials):
        nn, _, w, h = fr
        out = os.path.join(d, "%s_%05d.png" % (tag, k))
        by_size.setdefault((w, h), []).append({"out": out, "pose": pose, "opts": opts,
                                               "camera": _final_cam(fit, w, h, nn, (pose.get("_dx", 0.0), pose.get("_dy", 0.0)))})
        keys.append((tid, fr, out))
    for (w, h), its in by_size.items():
        run_blender({"mode": cfg["mode"], "opts": its[0]["opts"], "size": [w * scale, h * scale],
                     "camera": _final_cam(fit, w, h), "samples": samples, "items": its}, tag)
    sc = {}
    for tid, (nn, p, w, h), out in keys:
        _post(out, cfg["post"])
        sc[tid] = _look_score(cfg, premul(rgba(p)), box_down(premul(rgba(out)), scale))
    return sc


def stage_optim(family, cfg, only=None):
    """Per-frame MULTI-parameter pose refinement for articulated models (characters): starting from the
    fitted pose, each round tries +-step on every "optim" param for every frame (all frames batched into
    one Blender job), applies every improving move, keeps the combined pose only if it beats the best
    single move, and halves the step of a param that found nothing. Writes the poses back to fit.json.
    The pseudo-params "_dx"/"_dy" (SD px) move the frame's sprite offset (sub-pixel), folded into its shift.
    "reseed": {"window": w} first scores every frame with the poses of its w neighbours on each side and
    starts from the best (a frame stuck in the wrong walk-phase basin jumps to a neighbour's pose).
    "optim": {"params": {name: {"step": s, "min": a, "max": b, "init": v}}, "rounds": 8, "scale": 2,
              "samples": 8, "min_step": 0.1 (fraction of the start step),
              "finish": {"rounds": 3, "scale": 4, "samples": 32, "step_f": 0.5}} -- the optional finish re-scores
    every frame at full fidelity and polishes it with steps restarted at step_f x the start step.
    "fix": [{"frames": [a, b], "param": p, "value": v}] pins p to v on those frames (e.g. no red ball in the
    Gargoyle's first animation): it is never moved, and reseeds / probes / hops keep it.
    "tether": {p: tol} keeps p within tol of the frame's fit.json "anchor" pose (a smoothed run cycle stays smooth)."""
    op = cfg.get("optim")
    if not op:
        print("optim: no \"optim\" block, skipping")
        return
    frames = base_frames(cfg)
    if only is not None:
        frames = [fr for fr in frames if fr[0] in only]
        op = dict(op, scale=int(cfg["scale"]), samples=int(cfg["samples"].get("final", 256)))   # = what verify sees
        lk = cfg.get("look") or {}      # verify-fidelity scores: a steep IoU weight, and a small margin is safe
        cfg = dict(cfg, look=dict(lk, iou_w=max(400.0, float(lk.get("iou_w", 60.0))),
                                  iou_margin=min(0.01, float(lk.get("iou_margin", 0.01)))))
        if not frames:
            print("optim: no frames to refine")
            return
        print("optim: refining only frames %s" % [fr[0] for fr in frames])
    fp = os.path.join(workdir(family), "fit.json")
    with open(fp, "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    params = op["params"]
    sc_ = int(op.get("scale", 2))
    smp = int(op.get("samples", 8))
    base = _opts(family, cfg)
    lfo = _look_frame_opts(family)
    d = workdir(family, "optim")
    for f in glob.glob(os.path.join(d, "*.png")):
        os.remove(f)
    fixed = {}
    for fx in op.get("fix") or []:
        for nn in range(int(fx["frames"][0]), int(fx["frames"][1]) + 1):
            fixed.setdefault(nn, {})[fx["param"]] = float(fx["value"])
    tether = op.get("tether") or {}          # {param: tol}: stay within tol of fit.json's per-frame "anchor"
    anchors = {int(n): v["anchor"] for n, v in fit["frames"].items() if "anchor" in v}
    tscale = {int(n): float(v.get("tether_scale", 1.0)) for n, v in fit["frames"].items()}   # per-frame widening

    def tie(nn, k, v):
        a = anchors.get(nn, {}).get(k)
        if k in tether and a is not None:
            t = float(tether[k]) * tscale.get(nn, 1.0)
            v = max(a - t, min(a + t, v))
        return v

    def pin(nn, pose):
        pose.update(fixed.get(nn, {}))
        for k in tether:
            if k in pose:
                pose[k] = tie(nn, k, pose[k])
        return pose
    st = {}
    for fr in frames:
        nn = fr[0]
        pose = dict(fit["frames"][str(nn)]["pose"])
        for k, spec in params.items():
            pose.setdefault(k, float(spec.get("init", 0.0)))
        st[nn] = {"fr": fr, "pose": pin(nn, pose), "step": {k: float(v["step"]) for k, v in params.items()},
                  "score": None, "opts": dict(frame_opts(cfg, nn, base=base), **lfo.get(str(nn), {}))}

    def clamp(k, v, nn=None):
        v = max(float(params[k].get("min", -1e9)), min(float(params[k].get("max", 1e9)), v))
        return v if nn is None else tie(nn, k, v)

    if op.get("reseed") or only is not None:
        win = 2 if only is not None else int(op["reseed"].get("window", 3))
        order = [fr[0] for fr in base_frames(cfg)]          # neighbours come from the FULL frame order
        snap = {nn: dict(fit["frames"][str(nn)]["pose"]) for nn in order}
        for nn in st:
            snap[nn] = dict(st[nn]["pose"])
        trials = []
        for i, nn in enumerate(order):
            if nn not in st:
                continue
            trials.append(((nn, "base"), st[nn]["fr"], dict(snap[nn]), st[nn]["opts"]))
            for j in range(max(0, i - win), min(len(order), i + win + 1)):
                if j != i:
                    seed = dict(snap[order[j]])
                    for k, spec in params.items():
                        seed.setdefault(k, float(spec.get("init", 0.0)))
                    trials.append(((nn, "seed", order[j]), st[nn]["fr"], pin(nn, seed), st[nn]["opts"]))
        sc = _render_score(cfg, fit, trials, d, "%s_seed" % family, sc_, smp)
        moved = 0
        for nn in st:
            cands = [(v, key) for key, v in sc.items() if key[0] == nn]
            v, key = min(cands, key=lambda t: t[0])
            st[nn]["score"] = v
            if key[1] == "seed":
                st[nn]["pose"] = dict(snap[key[2]], **{k: st[nn]["pose"][k] for k in ("_dx", "_dy") if k in st[nn]["pose"]})
                for k, spec in params.items():
                    st[nn]["pose"].setdefault(k, float(spec.get("init", 0.0)))
                pin(nn, st[nn]["pose"])
                moved += 1
        print("optim: reseed moved %d of %d frames to a neighbour's pose" % (moved, len(st)))

    for pr in (op.get("probe") or []) if only is not None else []:   # coarse grids: jumps no +-step descent makes
        names = list(pr.keys())
        combos = list(itertools.product(*[pr[k] for k in names]))
        trials = []
        for nn, s in st.items():
            trials.append(((nn, "base"), s["fr"], dict(s["pose"]), s["opts"]))
            for ci, vals in enumerate(combos):
                trials.append(((nn, "probe", ci), s["fr"],
                               pin(nn, dict(s["pose"], **{k: clamp(k, v, nn) for k, v in zip(names, vals)})), s["opts"]))
        sc = _render_score(cfg, fit, trials, d, "%s_probe" % family, sc_, smp)
        for nn, s in st.items():
            v, key = min(((v, key) for key, v in sc.items() if key[0] == nn), key=lambda t: t[0])
            if key[1] == "probe":
                s["pose"].update({k: clamp(k, val, nn) for k, val in zip(names, combos[key[2]])})
                pin(nn, s["pose"])
                print("optim: probe moved f%02d to %s" % (nn, dict(zip(names, combos[key[2]]))))
            s["score"] = v

    first = None

    def run_rounds(nrounds, sc_, smp, tagp):
        nonlocal first
        for rnd in range(nrounds):
            trials = []
            for nn, s in st.items():
                if s["score"] is None:
                    trials.append(((nn, "base"), s["fr"], dict(s["pose"]), s["opts"]))
                for k in params:
                    if k in fixed.get(nn, {}) or s["step"][k] < float(params[k]["step"]) * float(op.get("min_step", 0.1)):
                        continue
                    for sgn in (1, -1):
                        v = clamp(k, s["pose"][k] + sgn * s["step"][k], nn)
                        if v != s["pose"][k]:
                            trials.append(((nn, k, sgn), s["fr"], dict(s["pose"], **{k: v}), s["opts"]))
            if not trials:
                break
            sc = _render_score(cfg, fit, trials, d, "%s_%s%d" % (family, tagp, rnd), sc_, smp)
            combos = []
            for nn, s in st.items():
                if (nn, "base") in sc:
                    s["score"] = sc[(nn, "base")]
                moves, best1 = {}, None
                for k in params:
                    cand = [(sc[(nn, k, sg)], sg) for sg in (1, -1) if (nn, k, sg) in sc]
                    good = [c for c in cand if c[0] < s["score"] - 1e-3]
                    if good:
                        v, sg = min(good)
                        moves[k] = clamp(k, s["pose"][k] + sg * s["step"][k], nn)
                        if best1 is None or v < best1[0]:
                            best1 = (v, k, moves[k])
                    else:
                        s["step"][k] *= 0.5
                s["best1"] = best1
                if len(moves) > 1:
                    combos.append(((nn, "combo"), s["fr"], dict(s["pose"], **moves), s["opts"]))
                elif best1:
                    s["pose"][best1[1]] = best1[2]
                    s["score"] = best1[0]
            if combos:
                csc = _render_score(cfg, fit, combos, d, "%s_%s%dc" % (family, tagp, rnd), sc_, smp)
                for tid, fr, pose, _ in combos:
                    nn = tid[0]
                    s = st[nn]
                    if csc[tid] <= s["best1"][0]:
                        s["pose"], s["score"] = pose, csc[tid]
                    else:
                        s["pose"][s["best1"][1]] = s["best1"][2]
                        s["score"] = s["best1"][0]
            mean = float(np.mean([s["score"] for s in st.values()]))
            first = mean if first is None else first
            print("optim: %s round %d, %d renders, mean score %.3f" % (tagp, rnd, len(trials) + len(combos), mean))

    run_rounds(int(op.get("rounds", 8)), sc_, smp, "opt")
    fin = op.get("finish")
    if fin:                                   # low-sample edges hide 1 px gains: re-score and polish at full fidelity
        for s in st.values():
            s["score"] = None
            s["step"] = {k: float(v["step"]) * float(fin.get("step_f", 0.5)) for k, v in params.items()}
        first = None
        run_rounds(int(fin.get("rounds", 3)), int(fin.get("scale", 4)), int(fin.get("samples", 32)), "fin")
    if only is not None:                      # basin hopping: a failing frame is often a local minimum
        rng = np.random.default_rng(7)
        for hop in range(int(op.get("hops", 4))):
            keep = {nn: (dict(s["pose"]), s["score"]) for nn, s in st.items()}
            for nn, s in st.items():
                for k, spec in params.items():
                    s["pose"][k] = clamp(k, s["pose"][k] + rng.uniform(-2.0, 2.0) * float(spec["step"]), nn)
                pin(nn, s["pose"])
                s["score"] = None
                s["step"] = {k: float(v["step"]) * 0.5 for k, v in params.items()}
            run_rounds(3, sc_, smp, "hop%d" % hop)
            for nn, s in st.items():
                if s["score"] >= keep[nn][1]:
                    s["pose"], s["score"] = keep[nn]
                else:
                    print("optim: hop %d improved f%02d %.3f -> %.3f" % (hop, nn, keep[nn][1], s["score"]))
        # shift hops: a fitted 1 px offset the pose then adapted to (BP_cheer f125's legs stretched on
        # tiptoe to reach a frame shifted up a row) -- move it +-1 px and let the pose re-adapt; a second
        # pass (only after a gain) reaches +-2 px
        dirs = ((0, -1), (0, 1), (-1, 0), (1, 0)) if op.get("shift_hops", True) else ()
        for sp in range(2):
            gained = False
            for hop, (ddx, ddy) in enumerate(dirs):
                keep = {nn: (dict(s["pose"]), s["score"]) for nn, s in st.items()}
                for s in st.values():
                    s["pose"]["_dx"] = s["pose"].get("_dx", 0.0) + ddx
                    s["pose"]["_dy"] = s["pose"].get("_dy", 0.0) + ddy
                    s["score"] = None
                    s["step"] = {k: float(v["step"]) for k, v in params.items()}
                run_rounds(4, sc_, smp, "shift%d%d" % (sp, hop))
                for nn, s in st.items():
                    if s["score"] >= keep[nn][1]:
                        s["pose"], s["score"] = keep[nn]
                    else:
                        gained = True
                        print("optim: shift %+d,%+d improved f%02d %.3f -> %.3f" % (ddx, ddy, nn, keep[nn][1], s["score"]))
            if not gained:
                break
    for nn, s in st.items():
        pose = dict(s["pose"])
        ex = (pose.pop("_dx", 0.0), pose.pop("_dy", 0.0))           # sub-pixel offsets fold into the frame's shift
        if ex != (0.0, 0.0):
            sh = fit["frames"][str(nn)].get("shift", [0.0, 0.0])
            fit["frames"][str(nn)]["shift"] = [sh[0] + ex[0], sh[1] + ex[1]]
        fit["frames"][str(nn)]["pose"] = pose
        fit["frames"][str(nn)]["optim_score"] = round(s["score"], 3)
    with open(fp, "w", encoding="utf-8") as fh:
        json.dump(fit, fh, indent=1)
    print("optim: mean score %.3f -> %.3f" % (first or 0, float(np.mean([s["score"] for s in st.values()]))))


def stage_bake(family, cfg):
    lp = os.path.join(WORK, family, "look.json")
    if not os.path.exists(lp):
        print("bake: no look.json, skipping")
        return
    with open(lp, "r", encoding="utf-8") as fh:
        lo = json.load(fh)["opts"]
    p = os.path.join(FAM_DIR, family, "frames.json")
    with open(p, "r", encoding="utf-8-sig") as fh:
        raw = json.load(fh)                          # the file as written, not load_cfg's expanded copy
    raw.setdefault("opts", {}).update(lo)
    for k, spec in ((raw.get("look") or {}).get("refine") or {}).items():
        if k in lo and isinstance(lo[k], (int, float)) and not isinstance(lo[k], bool):
            spec["init"] = lo[k]
    with open(p, "w", encoding="utf-8") as fh:
        json.dump(raw, fh, indent=1)
    cfg["opts"] = dict(raw["opts"])
    print("bake: %d look options -> %s opts" % (len(lo), family))


def stage_final(family, cfg):
    frames = base_frames(cfg)
    _drop_tweens(cfg)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    s = cfg["scale"]
    d = workdir(family, "final")
    base = _opts(family, cfg)
    lfo = _look_frame_opts(family)
    groups = {}
    for nn, _, w, h in frames:
        groups.setdefault((w, h), []).append(nn)
    for (w, h), nns in groups.items():
        items = [{"out": os.path.join(d, "f%02d.png" % nn), "pose": fit["frames"][str(nn)]["pose"],
                  "opts": dict(frame_opts(cfg, nn, base=base), **lfo.get(str(nn), {})),
                  "camera": _final_cam(fit, w, h, nn)} for nn in nns]
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
    _derive(cfg, d, od, s)
    print("final: %d frames (+%d derived) -> %s" % (len(frames), len(derived(cfg)), os.path.relpath(od, ROOT)))


def _derive(cfg, d, od, s):
    sd = {nn: (p, w, h) for nn, p, w, h in sd_frames(cfg)}
    for nn, spec in sorted(derived(cfg).items()):
        if nn not in sd:
            continue
        _, w, h = sd[nn]
        im = Image.open(os.path.join(d, "f%02d.png" % spec["from"])).convert("RGBA")
        op = spec["op"]
        if op == "crop":
            x0, y0, x1, y1 = spec["box"]
            out = im.crop((x0 * s, y0 * s, x1 * s, y1 * s))
        elif op == "scale":
            sw, sh = spec["size"]
            out = Image.new("RGBA", (w * s, h * s), (0, 0, 0, 0))
            small = im.resize((sw * s, sh * s), Image.LANCZOS)
            at = spec.get("at", [(w - sw) / 2, (h - sh) / 2])
            out.alpha_composite(small, (int(round(at[0] * s)), int(round(at[1] * s))))
        elif op == "crack":
            a = rgba(sd[spec["from"]][0])
            b = rgba(sd[nn][0])
            val = lambda x: x[..., :3].max(-1)       # not luma: a crack across a BLUE ball barely moves luma
            crack = (np.abs(a - b)[..., :3].max(-1) > 0.09) & (val(b) < val(a) - 0.08) & (b[..., 3] > 0)
            m = Image.fromarray((crack * 255).astype(np.uint8)).resize((w * s, h * s), Image.BILINEAR)
            mk = np.clip(np.asarray(m).astype(np.float64) / 255.0 * float(spec.get("strength", 1.6)), 0, 1)
            ccol = np.asarray(Image.fromarray((b * 255).astype(np.uint8)).resize((w * s, h * s), Image.NEAREST))
            base = np.asarray(im).astype(np.float64)
            base[..., :3] = base[..., :3] * (1 - mk[..., None]) + ccol[..., :3] * mk[..., None]
            out = Image.fromarray(np.clip(base, 0, 255).astype(np.uint8))
        else:
            raise SystemExit("derive: unknown op %r" % op)
        for old in glob.glob(os.path.join(od, "f%02d_*.png" % nn)):
            os.remove(old)
        out.save(os.path.join(od, "f%02d_%dx%d.png" % (nn, w * s, h * s)))


def _ffmpeg():
    return shutil.which("ffmpeg") or os.environ.get("SOI_FFMPEG") or r"D:\Program Files\Tools\ffmpeg.exe"


# ------------------------------------------------------------------------------------- tweens
TWEEN_RE = re.compile(r"^f(\d+)-(\d+)_(\d+)of(\d+)\.png$")


def _tween_pairs(cfg):
    """The unordered (lo, hi) frame pairs of cfg "tweens" (cycles / runs / pairs), family frames only."""
    tw = cfg.get("tweens") or {}
    out = set()
    for a, b in tw.get("cycles", []):
        seq = list(range(a, b + 1))
        out |= {tuple(sorted((seq[i], seq[(i + 1) % len(seq)]))) for i in range(len(seq))}
    for a, b in tw.get("runs", []):
        out |= {(i, i + 1) for i in range(a, b)}
    for a, b in tw.get("pairs", []):
        out.add(tuple(sorted((a, b))))
    have = {nn: (w, h) for nn, _, w, h in base_frames(cfg)}
    return sorted(p for p in out if p[0] in have and p[1] in have and have[p[0]] == have[p[1]])


def _tween_sequences(cfg):
    """Frame orders to preview: each cycle (closed) and run."""
    tw = cfg.get("tweens") or {}
    return [list(range(a, b + 1)) + [a] for a, b in tw.get("cycles", [])] + \
           [list(range(a, b + 1)) for a, b in tw.get("runs", [])]


def _lerp_pose(pa, pb, t, periods):
    out = {}
    for k in set(pa) | set(pb):
        a, b = pa.get(k, pb.get(k)), pb.get(k, pa.get(k))
        if isinstance(a, bool) or isinstance(b, bool) or not isinstance(a, (int, float)) \
                or not isinstance(b, (int, float)):
            out[k] = a if t < 0.5 else b
        elif k in periods:
            per = float(periods[k])
            out[k] = a + ((b - a + per / 2) % per - per / 2) * t
        else:
            out[k] = a + (b - a) * t
    return out


def _drop_tweens(cfg):
    """Delete the in-betweens of this family's frames (stale once its frames are re-rendered)."""
    mine = {nn for nn, _, _, _ in sd_frames(cfg)}
    n = 0
    for p in glob.glob(os.path.join(OVERLAY_DIR, cfg["source"], "tw", "f*.png")):
        m = TWEEN_RE.match(os.path.basename(p))
        if m and int(m.group(1)) in mine and int(m.group(2)) in mine:
            os.remove(p)
            n += 1
    return n


def stage_live(family, cfg):
    if cfg.get("frame_opts"):
        raise SystemExit("live: %s has per-frame model variants (frame_opts) -- not a single rig" % family)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    out = os.path.join(LIVE_DIR, family)
    frames = {str(nn): {"pose": dict(fit["frames"][str(nn)]["pose"]), "w": w, "h": h, "cam": _final_cam(fit, w, h, nn)}
              for nn, _, w, h in base_frames(cfg)}
    # unwrap periodic params so consecutive frames step the short way (the rig interpolates between them)
    periods = {s["param"]: float(s["period"]) for s in cfg["sweep"] if "period" in s}
    periods.update({k: float(v) for k, v in cfg.get("tweens", {}).get("periods", {}).items()})
    prev = {}
    for key in sorted(frames, key=int):
        pose = frames[key]["pose"]
        for k, per in periods.items():
            v = pose.get(k)
            if isinstance(v, bool) or not isinstance(v, (int, float)):
                continue
            if k in prev:
                v = prev[k] + ((v - prev[k] + per / 2) % per - per / 2)
            pose[k] = prev[k] = v
    run_blender({"mode": cfg["mode"], "opts": _opts(family, cfg), "sheet": cfg["source"], "family": family,
                 "scale": cfg["scale"], "post": cfg["post"], "out": out, "frames": frames},
                family + "_live", script="live_blender.py", done="LIVE_DONE")
    print("live: %d frames -> %s" % (len(frames), os.path.relpath(out, ROOT)))


def _godot_live(family, out, extra=()):
    os.makedirs(out, exist_ok=True)
    for f in glob.glob(os.path.join(out, "*.png")):
        os.remove(f)
    res = subprocess.run([GODOT, "--path", os.path.join(ROOT, "godot_project"), "--position", "9000,9000",
                          "res://scenes/live_check.tscn", "--", "--family=" + family, "--out=" + out] + list(extra),
                         capture_output=True, text=True)
    if "LIVE_CHECK_DONE" not in res.stdout:
        print(res.stdout[-3000:], res.stderr[-3000:])
        raise SystemExit("godot live render failed")


def stage_livegate(family, cfg):
    d = workdir(family, "live")
    _godot_live(family, d)
    s, gate = cfg["scale"], cfg["gate"]
    od = os.path.join(OVERLAY_DIR, cfg["source"])
    rows = []
    for nn, p, w, h in sd_frames(cfg):
        lp, cp = os.path.join(d, "f%02d.png" % nn), glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        if not os.path.exists(lp) or not cp:
            continue
        sd, lv, cy = premul(rgba(p)), premul(rgba(lp)), premul(rgba(cp[0]))
        if lv.shape[:2] != (h * s, w * s):
            raise SystemExit("livegate: f%02d is %s, expected %dx%d" % (nn, lv.shape[:2], w * s, h * s))
        # Godot's MSAA + a 2 px fringe leaves edge pixels at exactly 8/16 coverage (Cycles' filter: never exactly)
        rows.append((nn, live_iou(sd, box_down(lv, s)), compare_blur(sd, box_down(lv, s)),
                     compare(sd, box_down(cy, s))[0], compare_blur(sd, box_down(cy, s)),
                     compare_blur(box_down(cy, s), box_down(lv, s))))
    if not rows:
        raise SystemExit("livegate: nothing rendered")
    a = np.array([r[1:] for r in rows])
    ok = lambda i, j: int(((a[:, i] >= gate["iou"]) & (a[:, j] <= gate["de"])).sum())
    # a live frame passes the gate, or matches its published frame's scores (Godot's MSAA edge sits a few
    # thousandths of IoU from Cycles' filter)
    live_ok = ((a[:, 0] >= gate["iou"]) & (a[:, 1] <= gate["de"])) | \
        ((a[:, 0] >= a[:, 2] - LIVE_IOU_TOL) & (a[:, 1] <= a[:, 3] + LIVE_DE_TOL))
    print("livegate %s (%d frames, gate IoU >= %.3f, dE <= %.1f):" % (family, len(rows), gate["iou"], gate["de"]))
    print("  live  : IoU min %.3f mean %.3f, dE mean %.2f max %.2f, pass %d (%d as good as the published frame)" %
          (a[:, 0].min(), a[:, 0].mean(), a[:, 1].mean(), a[:, 1].max(), ok(0, 1), int(live_ok.sum())))
    print("  cycles: IoU min %.3f mean %.3f, dE mean %.2f max %.2f, pass %d" %
          (a[:, 2].min(), a[:, 2].mean(), a[:, 3].mean(), a[:, 3].max(), ok(2, 3)))
    print("  live vs cycles: dE mean %.2f max %.2f" % (a[:, 4].mean(), a[:, 4].max()))
    worst = sorted(rows, key=lambda r: -r[2])[:5]
    print("  worst live frames: " + ", ".join("f%02d (IoU %.3f dE %.1f)" % (r[0], r[1], r[2]) for r in worst))
    tiles = [(nn, p) for nn, p, _, _ in sd_frames(cfg)][::max(1, len(rows) // 12)]
    cw, ch = max(w for _, _, w, _ in sd_frames(cfg)) * s, max(h for _, _, _, h in sd_frames(cfg)) * s
    sheet = Image.new("RGB", (len(tiles) * (cw + 6), 3 * (ch + 6)), (40, 40, 48))
    for i, (nn, p) in enumerate(tiles):
        sd = Image.open(p)
        for j, src in enumerate((p, glob.glob(os.path.join(od, "f%02d_*.png" % nn))[0],
                                 os.path.join(d, "f%02d.png" % nn))):
            sheet.paste(_on_black(src, (sd.size[0] * s, sd.size[1] * s) if j == 0 else None), (i * (cw + 6), j * (ch + 6)))
    vd = os.path.join(FAM_DIR, family, "_verify")
    os.makedirs(vd, exist_ok=True)
    sheet.save(os.path.join(vd, "live_sheet.png"))
    passed = bool(live_ok.all())
    bad = ["f%02d (IoU %.3f vs %.3f, dE %.1f vs %.1f)" % (r[0], r[1], r[3], r[2], r[4])
           for r, k in zip(rows, live_ok) if not k]
    if bad:
        print("  failing live frames (live vs published): " + ", ".join(bad))
    # the game draws a sheet live only from rigs whose gate.json says they passed
    with open(os.path.join(LIVE_DIR, family, "gate.json"), "w", encoding="utf-8") as fh:
        json.dump({"sheet": cfg["source"], "family": family, "frames": [r[0] for r in rows], "pass": passed,
                   "iou_min": round(float(a[:, 0].min()), 4), "de_mean": round(float(a[:, 1].mean()), 3),
                   "de_max": round(float(a[:, 1].max()), 3), "cycles_de_mean": round(float(a[:, 3].mean()), 3)},
                  fh, indent=1)
    return passed


def _srgb_lin(c):
    return np.where(c <= 0.04045, c / 12.92, ((c + 0.055) / 1.055) ** 2.4)


def _lin_srgb(c):
    c = np.clip(c, 0.0, 1.0)
    return np.where(c <= 0.0031308, c * 12.92, 1.055 * c ** (1 / 2.4) - 0.055)


def stage_livecal(family, cfg):
    """Balance the live renderer's sun vs ambient light against the SD frames: Godot's ambient light
    reaches every surface while Cycles' world light is shadowed by the model itself, so the converted
    values light the live model too flatly. Renders a sun-only and an ambient-only pass, mixes them in
    linear light (k * sun + m * ambient), grid-searches (k, m) by livegate's dE and stores them in
    live.json as key_scale / amb_scale."""
    jp = os.path.join(LIVE_DIR, family, "live.json")
    with open(jp, "r", encoding="utf-8") as fh:
        live = json.load(fh)
    live["key_scale"], live["amb_scale"] = 1.0, 1.0      # the basis passes are rendered unscaled
    with open(jp, "w", encoding="utf-8") as fh:
        json.dump(live, fh)
    dk, da = workdir(family, "cal", "key"), workdir(family, "cal", "amb")
    _godot_live(family, dk, ["--key=1", "--amb=0"])
    _godot_live(family, da, ["--key=0", "--amb=1"])
    s = cfg["scale"]
    frames = []
    for nn, p, _, _ in sd_frames(cfg):
        K, A = rgba(os.path.join(dk, "f%02d.png" % nn)), rgba(os.path.join(da, "f%02d.png" % nn))
        frames.append((premul(rgba(p)), _srgb_lin(K[..., :3]), _srgb_lin(A[..., :3]), np.maximum(K[..., 3:], A[..., 3:])))

    def score(k, m):
        return float(np.mean([compare_blur(sd, box_down(premul(np.concatenate([_lin_srgb(k * kl + m * al), a], -1)), s))
                              for sd, kl, al, a in frames]))

    base = score(1.0, 1.0)
    best = min((score(k, m), k, m) for k in (0.8, 0.9, 1.0, 1.1, 1.2) for m in (0.0, 0.25, 0.5, 0.75, 1.0, 1.5))
    for step in (0.05, 0.025):
        de, k0, m0 = best
        best = min([best] + [(score(k0 + i * step, max(0.0, m0 + j * step * 2)), k0 + i * step, max(0.0, m0 + j * step * 2))
                             for i in (-1, 0, 1) for j in (-1, 0, 1) if i or j])
    de, k, m = best
    live["key_scale"], live["amb_scale"] = round(k, 4), round(m, 4)
    with open(jp, "w", encoding="utf-8") as fh:
        json.dump(live, fh)
    print("livecal %s: sun x%.3f, ambient x%.3f -> dE mean %.2f (unscaled %.2f) -> %s" %
          (family, k, m, de, base, os.path.relpath(jp, ROOT)))


def stage_tweens(family, cfg):
    tw = cfg.get("tweens")
    if not tw:
        print("tweens: no \"tweens\" block, skipping")
        return True
    if cfg.get("status") != "published":
        print("tweens: %s is not published, skipping" % family)
        return True
    n = int(tw.get("n", 4))
    pairs = _tween_pairs(cfg)
    with open(os.path.join(workdir(family), "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
    periods = {s["param"]: s["period"] for s in cfg["sweep"] if "period" in s}
    periods.update(tw.get("periods", {}))
    s = cfg["scale"]
    size = {nn: (w, h) for nn, _, w, h in base_frames(cfg)}
    base = _opts(family, cfg)
    lfo = _look_frame_opts(family)
    fopts = {nn: dict(frame_opts(cfg, nn, base=base), **lfo.get(str(nn), {})) for nn in size}
    d = workdir(family, "tweens")
    for f in glob.glob(os.path.join(d, "*.png")):
        os.remove(f)
    groups = {}
    for lo, hi in pairs:
        fa, fb = fit["frames"][str(lo)], fit["frames"][str(hi)]
        sa, sb = fa.get("shift", (0, 0)), fb.get("shift", (0, 0))
        pb = _lerp_pose(fa["pose"], fb["pose"], 1.0, periods)   # B's periodic params unwrapped next to A's
        w, h = size[lo]
        for k in range(1, n):
            t = k / n
            groups.setdefault((w, h), []).append({
                "out": os.path.join(d, "f%02d-%02d_%dof%d.png" % (lo, hi, k, n)),
                "pose": _lerp_pose(fa["pose"], fb["pose"], t, periods),
                "pose_a": fa["pose"], "pose_b": pb, "t": t,
                "opts": fopts[lo] if t < 0.5 else fopts[hi],
                "camera": _final_cam(fit, w, h, None, extra=(sa[0] + (sb[0] - sa[0]) * t,
                                                               sa[1] + (sb[1] - sa[1]) * t))})
    for (w, h), items in groups.items():
        items.sort(key=lambda it: json.dumps(it["opts"], sort_keys=True))   # few model rebuilds
        run_blender({"mode": cfg["mode"], "opts": items[0]["opts"], "size": [w * s, h * s],
                     "camera": _final_cam(fit, w, h), "samples": cfg["samples"].get("final", 256),
                     "items": items}, "%s_tweens_%dx%d" % (family, w, h))
    od = os.path.join(OVERLAY_DIR, cfg["source"])
    td = os.path.join(od, "tw")
    os.makedirs(td, exist_ok=True)
    _drop_tweens(cfg)
    mask = lambda p: np.asarray(Image.open(p).convert("RGBA"))[..., 3] > 127
    iou = lambda a, b: float((a & b).sum()) / max(1, int((a | b).sum()))
    kept, dropped = 0, []
    max_drop = float(tw.get("max_drop", 0.10))
    for lo, hi in pairs:
        ma = mask(glob.glob(os.path.join(od, "f%02d_*.png" % lo))[0])
        mb = mask(glob.glob(os.path.join(od, "f%02d_*.png" % hi))[0])
        ref = iou(ma, mb)
        outs = [os.path.join(d, "f%02d-%02d_%dof%d.png" % (lo, hi, k, n)) for k in range(1, n)]
        for p in outs:
            _post(p, cfg["post"])
        worst = min(max(iou(mask(p), ma), iou(mask(p), mb)) for p in outs)
        if worst < ref - max_drop:
            dropped.append("%d-%d (%.2f < %.2f)" % (lo, hi, worst, ref))
            continue
        for p in outs:
            shutil.copyfile(p, os.path.join(td, os.path.basename(p)))
        kept += 1
    print("tweens: %d/%d pairs x %d in-betweens -> %s%s" % (kept, len(pairs), n - 1, os.path.relpath(td, ROOT),
          ("; dropped " + ", ".join(dropped)) if dropped else ""))
    _tween_anim(cfg, od, n, os.path.join(FAM_DIR, family, "_verify", "tweens_anim.mp4"))
    return True


def _tween_anim(cfg, od, n, out):
    """Each tween sequence at the smooth cadence: frame, its in-betweens, next frame ... (3 loops)."""
    ff = _ffmpeg()
    seqs = _tween_sequences(cfg)
    if not seqs or (not os.path.exists(ff) and not shutil.which(ff)):
        return
    frames = {nn: glob.glob(os.path.join(od, "f%02d_*.png" % nn)) for seq in seqs for nn in seq}
    if not all(frames.values()):
        return
    cw = max(Image.open(v[0]).size[0] for v in frames.values())
    ch = max(Image.open(v[0]).size[1] for v in frames.values())
    z = max(1, 384 // max(cw, ch))
    os.makedirs(os.path.dirname(out), exist_ok=True)
    with tempfile.TemporaryDirectory() as tmp:
        k = 0
        for seq in seqs:
            for _ in range(3):
                for i, nn in enumerate(seq):
                    chain = [frames[nn][0]]
                    if i + 1 < len(seq):
                        lo, hi = sorted((nn, seq[i + 1]))
                        steps = [os.path.join(od, "tw", "f%02d-%02d_%dof%d.png" % (lo, hi, j, n)) for j in range(1, n)]
                        chain += steps if nn == lo else steps[::-1]
                    for p in chain:
                        if not os.path.exists(p):
                            continue
                        fr = Image.new("RGB", (cw * z, ch * z), (20, 20, 24))
                        im = _on_black(p, (Image.open(p).size[0] * z, Image.open(p).size[1] * z), nearest=False)
                        fr.paste(im, (0, 0))
                        fr = fr.resize((fr.width // 2 * 2, fr.height // 2 * 2))
                        fr.save(os.path.join(tmp, "%05d.png" % k))
                        k += 1
        subprocess.run([ff, "-y", "-loglevel", "error", "-framerate", str(30 * n), "-i",
                        os.path.join(tmp, "%05d.png"), "-c:v", "libx264", "-pix_fmt", "yuv420p", "-crf", "16",
                        out], check=True)


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
        if bestm != nn and compare_blur(sds[bestm], sd) < 1.0:   # the sheet repeats this very image elsewhere
            dist = 0
        if bestm != nn and scores[nn] - scores[bestm] <= float(gate.get("rank_margin", 0.75)):
            dist = 0                            # a near-tie between look-alike frames (a walk cycle), not a mix-up
        if bestm != nn and compare_blur(sds[bestm], sd) <= scores[nn]:
            dist = 0                            # the two source frames differ by less than this render's own error
        if nn in derived(cfg):                  # a crop/scale/crack of a verified frame: identity is moot
            dist = 0
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
                     "best_src": bestm, "rank_dist": dist, "rank_gap": round(scores[nn] - scores[bestm], 3),
                     "pass": ok, "hd_iou_de": hd_m})
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
    for p in glob.glob(os.path.join(OVERLAY_DIR, "*", "tw", "*.png")):
        sheet, m = os.path.basename(os.path.dirname(os.path.dirname(p))), TWEEN_RE.match(os.path.basename(p))
        if not m or (sheet, int(m.group(1))) not in owned or (sheet, int(m.group(2))) not in owned:
            print("check: STRAY in-between %s/tw/%s" % (sheet, os.path.basename(p)))
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
    stages = sys.argv[2:] or ["sweep", "fit", "optim", "look", "final", "verify"]
    cfg = load_cfg(family)
    ok = True
    for st in stages:
        if st == "sweep":
            stage_sweep(family, cfg)
        elif st == "fit":
            stage_fit(family, cfg)
        elif st == "optim":
            stage_optim(family, cfg)
        elif st == "optimfail":
            with open(os.path.join(FAM_DIR, family, "_verify", "frames_report.json"), "r", encoding="utf-8") as fh:
                rep = json.load(fh)
            stage_optim(family, cfg, only={int(r["frame"]) for r in rep["rows"] if not r["pass"]})
        elif st == "look":
            stage_look(family, cfg)
        elif st == "bake":
            stage_bake(family, cfg)
        elif st == "final":
            stage_final(family, cfg)
        elif st == "tweens":
            stage_tweens(family, cfg)
        elif st == "live":
            stage_live(family, cfg)
        elif st == "livecal":
            stage_livecal(family, cfg)
        elif st == "livegate":
            ok = stage_livegate(family, cfg) and ok
        elif st == "verify":
            passed = stage_verify(family, cfg)
            ok = passed and ok
            if not passed and cfg.get("status") != "published":
                # a failing work-in-progress family must never reach the game: drop its overlay frames
                od = os.path.join(OVERLAY_DIR, cfg["source"])
                n = _drop_tweens(cfg)
                for nn, _, _, _ in sd_frames(cfg):
                    for p in glob.glob(os.path.join(od, "f%02d_*.png" % nn)):
                        os.remove(p)
                        n += 1
                print("verify: %s is not published and failed -> removed its %d overlay frames" % (family, n))
        else:
            raise SystemExit("unknown stage %r" % st)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
