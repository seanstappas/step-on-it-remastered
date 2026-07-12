#!/usr/bin/env python3
"""4x AI-upscale the Step On It sprite sheets for an HD remaster and verify them.

The original sprites live at extracted/sprites/<sheet>/fNN_WxH.png (RGBA pixel art,
alpha baked in). This tool upscales every frame 4x with Real-ESRGAN (ncnn-vulkan,
the alpha-preserving anime model) into a PARALLEL tree extracted/sprites_hd/<sheet>/
fNN_WxH.png -- the originals are never touched, and the exact `fNN` frame number is
kept so the Godot loader (game.gd _folder_index parses int between 'f' and the first
'_') can pick up the HD set unchanged once the main session flips SPRITES_DIR.

Subcommands
-----------
  upscale   Faithfully 4x each sheet -> extracted/sprites_hd/<sheet>/ with hqx (a pixel-art
            scaler: exact proportions/detail/colour, smoothed edges, no hallucination), or
            Real-ESRGAN + refine for sheets opted into AI_SHEETS. Renames WxH to the 4x size.
  verify    Per-frame QA: RGBA, size == scale x source, alpha bounding-box scales
            consistently, downscale-back SSIM vs the source (flags < --ssim-min), and
            a per-sheet contact sheet (over grey, to expose alpha halos) for eyeballing.

Examples
--------
  py tools/upscale_sprites.py upscale
  py tools/upscale_sprites.py verify
  py tools/upscale_sprites.py upscale --folders goody_sprites BP_sprites
"""
from __future__ import annotations

import argparse
import os
import re
import subprocess
import sys
import tempfile
import types
from pathlib import Path

import numpy as np
from numpy.lib.stride_tricks import sliding_window_view
from PIL import Image, ImageFilter

# hqx (high-quality pixel-art scaler) provides faithful, hallucination-free smoothing for
# the UI/text sheet and for the few sprites the AI structurally hallucinates. hqx imports
# PIL.PyAccess at load, which Pillow >= 10 removed; shim it (it is only referenced in local
# type annotations, never called) so hqx works on the box's modern Pillow.
if "PIL.PyAccess" not in sys.modules:
    import PIL as _PIL
    _pyaccess_shim = types.ModuleType("PIL.PyAccess")
    _pyaccess_shim.PyAccess = object
    sys.modules["PIL.PyAccess"] = _pyaccess_shim
    _PIL.PyAccess = _pyaccess_shim
try:
    import hqx as _hqx
except Exception:  # hqx is optional; _hqx_rgba falls back to nearest if missing
    _hqx = None

REPO = Path(__file__).resolve().parent.parent
SRC_ROOT = REPO / "extracted" / "sprites"
HD_ROOT = REPO / "extracted" / "sprites_hd"

# Real-ESRGAN ncnn-vulkan standalone (Vulkan, preserves alpha, no Python deps).
REALESRGAN_EXE = Path(os.environ.get(
    "REALESRGAN_EXE", r"D:\SOI-tools\realesrgan\realesrgan-ncnn-vulkan.exe"))
REALESRGAN_MODELS = Path(os.environ.get(
    "REALESRGAN_MODELS", str(REALESRGAN_EXE.parent / "models")))
DEFAULT_MODEL = "realesrgan-x4plus-anime"  # clean cartoon/anime sprites

# Scaler selection. hqx -- a high-quality pixel-art scaler -- is the DEFAULT for every sheet:
# it preserves the original proportions, detail and colour exactly (no hallucination) while
# smoothing the staircase edges, which is the most faithful remaster and scales cleanly to 4K.
# List a sheet in AI_SHEETS to use the Real-ESRGAN path instead (a smoother, more "sculpted"
# look, but a reinterpretation that can invent colour/detail -- mitigated by _refine). Empty by
# default: the AI look subtly alters proportions/faces, which conflicts with strict fidelity.
AI_SHEETS: set[str] = set()

# Cell-filling block tiles: after upscaling, snap the anti-aliased alpha back to hard
# 0/255 edges so a soft fringe cannot leak the cell behind (the creeper-white bug).
HARD_ALPHA = {"block_sprites", "bigger_mblock", "blocks"}

# Iterations of edge-colour flood used to erase the white matte before upscaling.
BLEED_ITERS = 8

# Force each AI frame's chroma (Cb/Cr) to the source's, keeping the AI's luma detail, so the
# model cannot invent hues -- removes the cyan/orange/yellow tints Real-ESRGAN sprinkles onto
# sprite edges while keeping its smooth shading. Faithful by construction and neutral on
# frames whose colour was already correct. (Same pass also re-injects source detail below.)
REFINE = True

# Add the source's real high-frequency luma back onto the (smoothed) AI result so detail the
# upscaler melted away returns -- the classic "too-smooth upscaler" fix, done faithfully from
# the ORIGINAL pixels (never invented). 0 = off; ~0.85 restores armour plate lines / texture /
# faces without haloing. DETAIL_BLUR is the high-pass radius in HD pixels.
DETAIL_STRENGTH = 0.85
DETAIL_BLUR = 1.5

# If an AI-upscaled frame's downscale-back SSIM falls below this, the model hallucinated the
# content (e.g. fine dither / static-noise tiles it smears into mush) -> that frame is redone
# with crisp nearest-neighbour, which always preserves structure. Set well below normal AI
# edge-softening (~0.78+) so only genuinely broken frames are replaced.
FALLBACK_SSIM = 0.6

# --- UHD (8x) set -----------------------------------------------------------------------
# A higher-resolution, smoother pass written to a SEPARATE tree so the faithful hqx sprites_hd
# set is preserved. Organic sprites use an AI supersample (Real-ESRGAN x4 twice = 16x, then
# Lanczos-downsampled to 8x for clean anti-aliased edges) followed by the faithful _refine
# (source chroma + detail). Tiny text and geometric block tiles instead use hqx (the model
# turns glyphs to noise and smears dither/geometry). All sheets share one scale so the game's
# per-sprite cell scaling stays uniform.
UHD_ROOT = REPO / "extracted" / "sprites_uhd"
UHD_SCALE = 8
# The AI supersample suits smooth 3D shapes: the big character/enemy bodies AND round objects
# (disc / spiral-ball). Everything with fine detail the model would mangle -- thin-limbed enemies
# (ant, propeller beenie, spinner), symbol / sign / face pickups (Stop/Go signals, the "?" objects,
# goodies), plain small balls (cannon), text, and geometric tiles -- stays faithful with hqx, scaled
# to 8x with NEAREST (crisp; Lanczos just blurs the low-res hqx). Chosen by side-by-side QA vs the
# source; see tools/sprite_facts.json for the per-sheet what / keep / method / why rationale.
UHD_AI_SHEETS = {
    "knight_sprites", "Gargoyle_sprites", "robo_sprites", "hammer_sprites",
    "walker_sprites", "teeth_sprites", "hippo_sprites", "ostrich_sprites",
    "piggy_sprites", "BP_sprites", "GP_sprites", "bp_30fps_all_but_jump",
    "bp_jump_30fps", "smiley_sprites",
    # smooth 3D round objects -- AI renders them glossy; hqx-then-upscale looked blurry.
    "disk_sprites", "weapons",
    # the Stop/Go flip signs: AI renders clean, legible octagon signs (the low-contrast
    # source text is barely readable and hqx just mushes it); the fleeting edge-on transition
    # frames go slivery but are only visible for a frame or two mid-flip.
    "Stop_Go_sprite_family",
}

FRAME_RE = re.compile(r"^f(\d+)_")


def frame_files(folder: Path) -> list[Path]:
    """Every decoded frame in a sheet folder, in frame-number order."""
    out = []
    for p in folder.glob("f*.png"):
        m = FRAME_RE.match(p.name)
        if m:
            out.append((int(m.group(1)), p))
    return [p for _, p in sorted(out)]


def sheet_folders(names: list[str] | None) -> list[Path]:
    if names:
        return [SRC_ROOT / n for n in names]
    return sorted(p for p in SRC_ROOT.iterdir() if p.is_dir())


# --------------------------------------------------------------------------- #
# upscale
# --------------------------------------------------------------------------- #
def _rgba(path: Path) -> np.ndarray:
    with Image.open(path) as im:
        return np.asarray(im.convert("RGBA"))


def _alpha_bleed(arr: np.ndarray, iters: int = BLEED_ITERS) -> np.ndarray:
    """Flood opaque edge colour into the transparent region so the upscaler cannot
    blur the white matte into the anti-aliased edges (every source frame stores
    RGB 255,255,255 under alpha=0, which otherwise produces a white halo). Alpha is
    left untouched; only transparent RGB is overwritten with nearby opaque colour."""
    arr = arr.copy()
    rgb = arr[:, :, :3].astype(np.float32)
    filled = arr[:, :, 3] > 0
    for _ in range(iters):
        if filled.all():
            break
        acc = np.zeros_like(rgb)
        cnt = np.zeros(arr.shape[:2], np.float32)
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            acc += np.roll(np.where(filled[..., None], rgb, 0.0), (dy, dx), (0, 1))
            cnt += np.roll(filled.astype(np.float32), (dy, dx), (0, 1))
        newpx = (~filled) & (cnt > 0)
        rgb[newpx] = acc[newpx] / cnt[newpx, None]
        filled |= newpx
    arr[:, :, :3] = rgb.round().astype(np.uint8)
    return arr


def _hqx_rgba(arr: np.ndarray, scale: int) -> np.ndarray:
    """Faithful, hallucination-free smoothing with hqx (hq2x/3x/4x). RGB and alpha are
    scaled separately -- both after an alpha bleed, so edges anti-alias to the sprite's own
    colour instead of the white matte -- then recombined into a clean RGBA frame."""
    if _hqx is None or scale not in (2, 3, 4):
        return np.asarray(Image.fromarray(arr).resize(
            (arr.shape[1] * scale, arr.shape[0] * scale), Image.NEAREST))
    bled = _alpha_bleed(arr)
    rgb = _hqx.hqx_scale(Image.fromarray(bled[:, :, :3], "RGB"), scale).convert("RGB")
    a = _hqx.hqx_scale(Image.fromarray(bled[:, :, 3], "L").convert("RGB"),
                       scale).convert("RGB")
    return np.dstack([np.asarray(rgb), np.asarray(a)[:, :, 0]]).astype(np.uint8)


def _refine(src_arr: np.ndarray, ai_arr: np.ndarray,
            detail: float = DETAIL_STRENGTH) -> np.ndarray:
    """Make an AI frame faithful in one YCbCr pass:
      * luma (Y) from the AI          -> keep its smooth reconstructed structure;
      * chroma (Cb/Cr) from the source-> the model can't invent hues (kills cyan/orange/
        yellow tints);
      * add the source's real high-frequency luma back -> restore fine detail (armour
        plate lines, texture, faces) the upscaler smoothed away, scaled by `detail`.
    Source planes are LANCZOS-upscaled to the AI size; the luma carries the sharp edges so
    the soft chroma is invisible (as in JPEG/video)."""
    h, w = ai_arr.shape[:2]
    src_up = Image.fromarray(_alpha_bleed(src_arr)).convert("RGB").resize(
        (w, h), Image.LANCZOS)
    src_ycc = np.asarray(src_up.convert("YCbCr")).astype(np.float32)
    y = np.asarray(Image.fromarray(ai_arr[:, :, :3], "RGB")
                   .convert("YCbCr")).astype(np.float32)[:, :, 0]
    if detail > 0:
        src_y = src_ycc[:, :, 0]
        blur = np.asarray(Image.fromarray(src_y.astype(np.uint8))
                          .filter(ImageFilter.GaussianBlur(DETAIL_BLUR))).astype(np.float32)
        y = np.clip(y + detail * (src_y - blur), 0.0, 255.0)
    ycc = np.dstack([y, src_ycc[:, :, 1], src_ycc[:, :, 2]]).astype(np.uint8)
    rgb = np.asarray(Image.fromarray(ycc, "YCbCr").convert("RGB"))
    return np.dstack([rgb, ai_arr[:, :, 3]]).astype(np.uint8)


def upscale(folders: list[Path], scale: int, model: str,
            ai_model: str | None = None, hd_root: Path = HD_ROOT) -> int:
    """hqx-faithful 4x each sheet -> hd_root/<sheet>/. Sheets in AI_SHEETS -- or EVERY
    given sheet when `ai_model` is set -- instead take the Real-ESRGAN + faithful _refine
    path with that model. `ai_model` lets an experiment force e.g. the general
    realesrgan-x4plus model (the one the PICT remaster uses) onto sprites, writing to a
    scratch `hd_root` so the shipped hqx set is left intact."""
    need_ai = ai_model is not None or any(f.name in AI_SHEETS for f in folders)
    if need_ai and not REALESRGAN_EXE.exists():
        sys.exit(f"Real-ESRGAN not found at {REALESRGAN_EXE} (set REALESRGAN_EXE); "
                 f"needed for the AI path (--ai-model or AI_SHEETS).")
    total = 0
    for src in folders:
        frames = frame_files(src)
        if not frames:
            print(f"  skip {src.name}: no frames")
            continue
        dst = hd_root / src.name
        dst.mkdir(parents=True, exist_ok=True)
        # Idempotency: clear any prior output so re-runs never leave stale/renamed dups.
        for old in dst.glob("*.png"):
            old.unlink()
        hard = src.name in HARD_ALPHA
        use_ai = ai_model is not None or src.name in AI_SHEETS
        eff_model = ai_model or model

        # Default path: hqx faithful pixel-art scaling (exact proportions/detail/colour,
        # smoothed edges, zero hallucination) + hard 0/255 alpha for cell-filling tiles.
        if not use_ai:
            for sp in frames:
                fn = int(FRAME_RE.match(sp.name).group(1))
                arr = _hqx_rgba(_rgba(sp), scale)
                if hard:
                    arr = arr.copy()
                    arr[:, :, 3] = np.where(arr[:, :, 3] < 128, 0, 255).astype(np.uint8)
                h, w = arr.shape[:2]
                Image.fromarray(arr).save(dst / f"f{fn}_{w}x{h}.png")
            print(f"  {src.name}: {len(frames)} frames -> {dst} "
                  f"(hqx x{scale}{', hard alpha' if hard else ''})")
            total += len(frames)
            continue

        # Opt-in AI path: Real-ESRGAN, then a faithful _refine pass (source chroma + detail
        # re-injection). alpha-bleed each frame into a temp dir first, then run the model.
        with tempfile.TemporaryDirectory() as td:
            tdp = Path(td)
            for sp in frames:
                Image.fromarray(_alpha_bleed(_rgba(sp))).save(tdp / sp.name)
            print(f"  {src.name}: {len(frames)} frames -> {dst} "
                  f"(Real-ESRGAN {eff_model}{', hard alpha' if hard else ''})")
            cmd = [str(REALESRGAN_EXE), "-i", str(tdp), "-o", str(dst),
                   "-n", eff_model, "-s", str(scale), "-m", str(REALESRGAN_MODELS),
                   "-f", "png"]
            r = subprocess.run(cmd, capture_output=True, text=True)
            if r.returncode != 0:
                print(r.stdout[-2000:])
                print(r.stderr[-2000:])
                sys.exit(f"Real-ESRGAN failed on {src.name}")

        # Post-process each AI frame: force source chroma (kill invented hues), snap block
        # alpha hard, guard against hallucinated frames (redo with nearest), then rename
        # fNN_OLDWxOLDH.png -> fNN_<newW>x<newH>.png (loader ignores WxH, but keep it true).
        src_by_fn = {int(FRAME_RE.match(p.name).group(1)): p for p in frames}
        n = 0
        for out in list(dst.glob("f*.png")):
            m = FRAME_RE.match(out.name)
            if not m:
                out.unlink()
                continue
            fn = int(m.group(1))
            sp = src_by_fn.get(fn)
            arr = _rgba(out)
            dirty = False
            if REFINE and sp is not None:
                arr = _refine(_rgba(sp), arr)
                dirty = True
            if src.name in HARD_ALPHA:
                arr = arr.copy()
                arr[:, :, 3] = np.where(arr[:, :, 3] < 128, 0, 255).astype(np.uint8)
                dirty = True
            if dirty:
                Image.fromarray(arr).save(out)
            # Fidelity guard: if the model wrecked this frame, redo it with nearest.
            if sp is not None and _frame_ssim(sp, out) < FALLBACK_SSIM:
                s_arr = _rgba(sp)
                sh, sw = s_arr.shape[:2]
                Image.fromarray(s_arr).resize(
                    (sw * scale, sh * scale), Image.NEAREST).save(out)
            with Image.open(out) as im:
                w, h = im.size
            want = f"f{fn}_{w}x{h}.png"
            if out.name != want:
                target = dst / want
                if target.exists():
                    target.unlink()
                out.rename(target)
            n += 1
        total += n
    print(f"upscaled {total} frames across {len(folders)} folders -> {hd_root}")
    return total


# --------------------------------------------------------------------------- #
# uhd (8x, supersampled)
# --------------------------------------------------------------------------- #
def _ai_run(in_dir: Path, out_dir: Path, model: str, scale: int) -> None:
    """Run Real-ESRGAN over a whole directory (fast batch mode); clears out_dir first."""
    out_dir.mkdir(parents=True, exist_ok=True)
    for old in out_dir.glob("*.png"):
        old.unlink()
    cmd = [str(REALESRGAN_EXE), "-i", str(in_dir), "-o", str(out_dir),
           "-n", model, "-s", str(scale), "-m", str(REALESRGAN_MODELS), "-f", "png"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout[-2000:])
        print(r.stderr[-2000:])
        sys.exit(f"Real-ESRGAN failed ({model} x{scale})")


def upscale_uhd(folders: list[Path], scale: int = UHD_SCALE,
                model: str = DEFAULT_MODEL) -> int:
    """Build the UHD set (default 8x) in extracted/sprites_uhd/. Organic sprites: AI
    supersample (Real-ESRGAN x4 twice = 16x, Lanczos-downsampled to `scale`x for clean
    anti-aliased edges) + faithful _refine (source chroma + detail). Text / geometric block
    sheets: hqx x4 -> Lanczos. The originals and the hqx sprites_hd set are left untouched."""
    if not REALESRGAN_EXE.exists():
        sys.exit(f"Real-ESRGAN not found at {REALESRGAN_EXE} (set REALESRGAN_EXE).")
    total = 0
    for src in folders:
        frames = frame_files(src)
        if not frames:
            print(f"  skip {src.name}: no frames")
            continue
        dst = UHD_ROOT / src.name
        dst.mkdir(parents=True, exist_ok=True)
        for old in dst.glob("*.png"):
            old.unlink()
        hard = src.name in HARD_ALPHA
        src_by_fn = {int(FRAME_RE.match(p.name).group(1)): p for p in frames}

        # Default (faithful): hqx x4 -> NEAREST to `scale`x (crisp; Lanczos here just blurs the
        # low-res hqx into a soft-yet-pixely mess). Only big smooth 3D sheets take the AI path;
        # detailed / thin / symbolic art would be mangled by the model, so it stays crisp here.
        if src.name not in UHD_AI_SHEETS:
            for sp in frames:
                fn = int(FRAME_RE.match(sp.name).group(1))
                s = _rgba(sp)
                hq = _hqx_rgba(s, 4)
                arr = np.asarray(Image.fromarray(hq).resize(
                    (s.shape[1] * scale, s.shape[0] * scale), Image.NEAREST))
                if hard:
                    arr = arr.copy()
                    arr[:, :, 3] = np.where(arr[:, :, 3] < 128, 0, 255).astype(np.uint8)
                h, w = arr.shape[:2]
                Image.fromarray(arr).save(dst / f"f{fn}_{w}x{h}.png")
            print(f"  {src.name}: {len(frames)} frames -> {dst} "
                  f"(hqx->x{scale}{', hard alpha' if hard else ''})")
            total += len(frames)
            continue

        # Big smooth characters: AI supersample. bleed -> AI x4 -> bleed -> AI x4 (16x) ->
        # Lanczos down to scale for clean anti-aliased edges, then faithful _refine.
        with tempfile.TemporaryDirectory() as td:
            t = Path(td)
            a, c = t / "a", t / "c"
            a.mkdir()
            c.mkdir()
            for sp in frames:
                Image.fromarray(_alpha_bleed(_rgba(sp))).save(a / sp.name)
            print(f"  {src.name}: {len(frames)} frames -> {dst} "
                  f"(AI supersample 16x->{scale}x)")
            _ai_run(a, t / "b", model, 4)
            for p in (t / "b").glob("f*.png"):
                Image.fromarray(_alpha_bleed(_rgba(p))).save(c / p.name)
            _ai_run(c, t / "d", model, 4)
            n = 0
            for big in (t / "d").glob("f*.png"):
                m = FRAME_RE.match(big.name)
                if not m:
                    continue
                fn = int(m.group(1))
                sp = src_by_fn.get(fn)
                if sp is None:
                    continue
                s = _rgba(sp)
                a8 = np.asarray(Image.fromarray(_rgba(big)).resize(
                    (s.shape[1] * scale, s.shape[0] * scale), Image.LANCZOS))
                arr = _refine(s, a8)
                if hard:
                    arr = arr.copy()
                    arr[:, :, 3] = np.where(arr[:, :, 3] < 128, 0, 255).astype(np.uint8)
                h, w = arr.shape[:2]
                Image.fromarray(arr).save(dst / f"f{fn}_{w}x{h}.png")
                n += 1
            total += n
    print(f"UHD upscaled {total} frames across {len(folders)} folders -> {UHD_ROOT}")
    return total


# --------------------------------------------------------------------------- #
# verify
# --------------------------------------------------------------------------- #
def _luma_over_black(arr: np.ndarray) -> np.ndarray:
    """Alpha-composite RGBA over black -> luma (so transparency is respected)."""
    a = arr[:, :, 3:4].astype(np.float64) / 255.0
    rgb = arr[:, :, :3].astype(np.float64) * a
    return 0.299 * rgb[:, :, 0] + 0.587 * rgb[:, :, 1] + 0.114 * rgb[:, :, 2]


def _frame_ssim(src_path: Path, hd_path: Path) -> float:
    """Downscale-back SSIM of an HD frame vs its source (the fidelity guard signal)."""
    s = _rgba(src_path)
    sh, sw = s.shape[:2]
    with Image.open(hd_path) as him:
        back = him.convert("RGBA").resize((sw, sh), Image.LANCZOS)
    return ssim(_luma_over_black(s), _luma_over_black(np.asarray(back)))


def _boxmean(x: np.ndarray, w: int) -> np.ndarray:
    r = w // 2
    xp = np.pad(x, r, mode="edge")
    return sliding_window_view(xp, (w, w)).mean(axis=(-1, -2))


def ssim(a: np.ndarray, b: np.ndarray, win: int = 7) -> float:
    """Mean windowed SSIM on two equal-shape luma images (0..255)."""
    a = a.astype(np.float64)
    b = b.astype(np.float64)
    w = min(win, a.shape[0], a.shape[1])
    if w < 2:
        return 1.0  # 1px strip: nothing structural to compare
    if w % 2 == 0:
        w -= 1
    if w < 2:
        w = min(a.shape[0], a.shape[1])
    mu_a, mu_b = _boxmean(a, w), _boxmean(b, w)
    mu_a2, mu_b2, mu_ab = mu_a * mu_a, mu_b * mu_b, mu_a * mu_b
    va = _boxmean(a * a, w) - mu_a2
    vb = _boxmean(b * b, w) - mu_b2
    vab = _boxmean(a * b, w) - mu_ab
    c1, c2 = (0.01 * 255) ** 2, (0.03 * 255) ** 2
    s = ((2 * mu_ab + c1) * (2 * vab + c2)) / ((mu_a2 + mu_b2 + c1) * (va + vb + c2))
    return float(np.clip(s, -1.0, 1.0).mean())


def _alpha_bbox(arr: np.ndarray):
    a = arr[:, :, 3] > 0
    if not a.any():
        return None
    ys, xs = np.where(a)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def _contact_sheet(hd_frames: list[Path], dest: Path, cols: int = 16, cell: int = 48):
    rows = (len(hd_frames) + cols - 1) // cols
    W, H = cols * cell, rows * cell
    sheet = Image.new("RGBA", (W, H), (110, 110, 110, 255))  # grey exposes halos
    for k, f in enumerate(hd_frames):
        with Image.open(f) as im:
            im = im.convert("RGBA")
            im.thumbnail((cell, cell), Image.LANCZOS)
            ox = (k % cols) * cell + (cell - im.width) // 2
            oy = (k // cols) * cell + (cell - im.height) // 2
            sheet.alpha_composite(im, (ox, oy))
    sheet.save(dest)


def verify(folders: list[Path], scale: int, ssim_min: float, make_sheet: bool,
           hd_root: Path = HD_ROOT) -> int:
    print(f"{'sheet':<24}{'frames':>7}{'minSSIM':>9}{'meanSSIM':>9}"
          f"{'bboxTol':>8}  status")
    print("-" * 72)
    failures = 0
    for src in folders:
        hd = hd_root / src.name
        if not hd.is_dir():
            print(f"{src.name:<24}{'--':>7}  MISSING HD FOLDER")
            failures += 1
            continue
        frames = frame_files(src)
        ssims, bad, hd_list = [], [], []
        bbox_bad = 0
        for sp in frames:
            m = FRAME_RE.match(sp.name)
            fn = int(m.group(1))
            hp = next(iter(hd.glob(f"f{fn}_*.png")), None)
            if hp is None:
                bad.append((fn, "missing HD frame"))
                continue
            hd_list.append(hp)
            s_arr, h_arr = _rgba(sp), _rgba(hp)
            sh, sw = s_arr.shape[:2]
            hh, hw = h_arr.shape[:2]
            if (hw, hh) != (sw * scale, sh * scale):
                bad.append((fn, f"size {hw}x{hh} != {sw*scale}x{sh*scale}"))
                continue
            if h_arr.shape[2] != 4 or h_arr[:, :, 3].min() == h_arr[:, :, 3].max() == 255:
                # fully opaque where the source had transparency = dropped alpha
                if s_arr[:, :, 3].min() < 255 and h_arr[:, :, 3].min() == 255:
                    bad.append((fn, "alpha dropped"))
                    continue
            # alpha bbox consistency (HD bbox ~= scale x source bbox, +/- scale px slack)
            sb, hb = _alpha_bbox(s_arr), _alpha_bbox(h_arr)
            if sb and hb:
                exp = [sb[0] * scale, sb[1] * scale, sb[2] * scale, sb[3] * scale]
                if max(abs(hb[i] - exp[i]) for i in range(4)) > 2 * scale:
                    bbox_bad += 1
            # fidelity: downscale HD back to source size, SSIM vs source
            with Image.open(hp) as him:
                back = him.convert("RGBA").resize((sw, sh), Image.LANCZOS)
            ssims.append(ssim(_luma_over_black(s_arr),
                              _luma_over_black(np.asarray(back))))
        mn = min(ssims) if ssims else 0.0
        mean = sum(ssims) / len(ssims) if ssims else 0.0
        low = sum(1 for v in ssims if v < ssim_min)
        status = "OK"
        if bad:
            status = f"FAIL ({len(bad)}: {bad[0][1]})"
            failures += 1
        elif low:
            status = f"WARN {low} frames < {ssim_min}"
        print(f"{src.name:<24}{len(frames):>7}{mn:>9.3f}{mean:>9.3f}"
              f"{bbox_bad:>8}  {status}")
        if make_sheet and hd_list:
            qa = hd_root / "_qa"
            qa.mkdir(exist_ok=True)
            _contact_sheet(hd_list, qa / f"{src.name}.png")
    print("-" * 72)
    print("ALL SHEETS OK" if failures == 0 else f"{failures} sheet(s) FAILED")
    return failures


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    up = sub.add_parser("upscale", help="hqx (or AI opt-in) 4x -> extracted/sprites_hd/")
    up.add_argument("--folders", nargs="*", help="sheet names (default: all)")
    up.add_argument("--scale", type=int, default=4)
    up.add_argument("--model", default=DEFAULT_MODEL)
    up.add_argument("--ai-model", default=None,
                    help="force ALL --folders through the Real-ESRGAN + refine path with "
                         "this model (e.g. realesrgan-x4plus, the PICT remaster model) "
                         "instead of the faithful hqx default")
    up.add_argument("--out", default=None,
                    help="output root (default: extracted/sprites_hd); point at a scratch "
                         "dir to experiment without touching the shipped HD set")

    uh = sub.add_parser("uhd", help="AI-supersampled 8x -> extracted/sprites_uhd/")
    uh.add_argument("--folders", nargs="*", help="sheet names (default: all)")
    uh.add_argument("--scale", type=int, default=UHD_SCALE)
    uh.add_argument("--model", default=DEFAULT_MODEL)

    ve = sub.add_parser("verify", help="QA the HD sprites vs the source")
    ve.add_argument("--folders", nargs="*", help="sheet names (default: all)")
    ve.add_argument("--scale", type=int, default=4)
    ve.add_argument("--ssim-min", type=float, default=0.9)
    ve.add_argument("--no-sheet", action="store_true", help="skip contact sheets")
    ve.add_argument("--uhd", action="store_true",
                    help="verify extracted/sprites_uhd (8x) instead of sprites_hd (4x)")

    args = ap.parse_args()
    folders = sheet_folders(getattr(args, "folders", None))
    if args.cmd == "upscale":
        out_root = Path(args.out) if args.out else HD_ROOT
        upscale(folders, args.scale, args.model, args.ai_model, out_root)
    elif args.cmd == "uhd":
        upscale_uhd(folders, args.scale, args.model)
    elif args.cmd == "verify":
        root = UHD_ROOT if args.uhd else HD_ROOT
        scale = 8 if args.uhd else args.scale
        rc = verify(folders, scale, args.ssim_min, not args.no_sheet, root)
        sys.exit(1 if rc else 0)


if __name__ == "__main__":
    main()
