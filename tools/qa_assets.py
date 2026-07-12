#!/usr/bin/env python3
"""qa_assets.py -- headless QA for the Step On It HD asset remaster passes.

Two sub-commands, both compare a faithful SOURCE tree against an upscaled HD tree:

  sprites  SRC_DIR HD_DIR   per frame: RGBA?, size == k x source (uniform per sheet),
                            alpha bounding-box scaled consistently, downscale-back SSIM
                            vs the source (flag < 0.9), optional pyiqa NIQE/BRISQUE, a
                            per-sheet contact sheet PNG, and a summary table + fail list.

  audio    SRC_DIR HD_DIR   per file: sample rate == target, peak <= -1 dBFS, duration
                            within +/-1 %, and a before/after spectrogram pair PNG.

Dependency-light: needs Pillow + numpy (present on the 4090 box); SSIM is pure-numpy
(no scipy). pyiqa is OPTIONAL (only imported with --pyiqa). Audio uses ffmpeg/ffprobe.

Examples
  py tools/qa_assets.py sprites extracted/sprites extracted/sprites_hd
  py tools/qa_assets.py sprites extracted/sprites/goody_sprites extracted/sprites_hd/goody_sprites
  py tools/qa_assets.py audio   extracted/audio/wav extracted/audio/wav_hd --rate 44100

Exit code is non-zero if any asset FAILS, so it can gate a remaster session.
"""
import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

# ---- hard deps (present on the box) ----------------------------------------
try:
    import numpy as np
except ImportError:
    sys.exit("qa_assets: numpy is required (py -m pip install numpy)")
try:
    from PIL import Image, ImageDraw
except ImportError:
    sys.exit("qa_assets: Pillow is required (py -m pip install Pillow)")

FF_FALLBACK = r"D:\Program Files\Tools\ffmpeg.exe"
FP_FALLBACK = r"D:\Program Files\Tools\ffprobe.exe"


def find_tool(name, fallback):
    p = shutil.which(name)
    if p:
        return p
    return fallback if os.path.exists(fallback) else None


# ============================================================================
# pure-numpy SSIM (Wang et al. 2004, 11-tap Gaussian window, no scipy)
# ============================================================================
def _gaussian1d(sigma, radius):
    x = np.arange(-radius, radius + 1, dtype=np.float64)
    k = np.exp(-(x * x) / (2.0 * sigma * sigma))
    return k / k.sum()


def _sepfilter(img, k):
    """Separable convolution with reflect padding, 'same' output (float64)."""
    r = len(k) // 2
    if r == 0:
        return img.copy()
    h, w = img.shape
    p = np.pad(img, ((0, 0), (r, r)), mode="reflect")
    tmp = np.zeros_like(img)
    for i in range(len(k)):
        tmp += k[i] * p[:, i:i + w]
    p2 = np.pad(tmp, ((r, r), (0, 0)), mode="reflect")
    out = np.zeros_like(img)
    for i in range(len(k)):
        out += k[i] * p2[i:i + h, :]
    return out


def ssim(a, b):
    """Mean SSIM of two equal-shape 2-D luma arrays in [0, 255]."""
    a = a.astype(np.float64)
    b = b.astype(np.float64)
    h, w = a.shape
    c1 = (0.01 * 255) ** 2
    c2 = (0.03 * 255) ** 2
    r = min(5, min(h, w) - 1)
    if r < 1:  # image too small for a window -> global SSIM
        mu_a, mu_b = a.mean(), b.mean()
        va, vb = a.var(), b.var()
        vab = ((a - mu_a) * (b - mu_b)).mean()
        return float(((2 * mu_a * mu_b + c1) * (2 * vab + c2)) /
                     ((mu_a ** 2 + mu_b ** 2 + c1) * (va + vb + c2)))
    k = _gaussian1d(1.5, r)
    mu_a = _sepfilter(a, k)
    mu_b = _sepfilter(b, k)
    mu_a2, mu_b2, mu_ab = mu_a * mu_a, mu_b * mu_b, mu_a * mu_b
    va = _sepfilter(a * a, k) - mu_a2
    vb = _sepfilter(b * b, k) - mu_b2
    vab = _sepfilter(a * b, k) - mu_ab
    num = (2 * mu_ab + c1) * (2 * vab + c2)
    den = (mu_a2 + mu_b2 + c1) * (va + vb + c2)
    return float((num / den).mean())


# ============================================================================
# image helpers
# ============================================================================
def load_rgba(path):
    return Image.open(path).convert("RGBA")


def luma_over_black(img):
    """Composite RGBA over black -> luma float64 HxW (folds alpha into structure)."""
    arr = np.asarray(img, dtype=np.float64)
    rgb = arr[:, :, :3]
    alpha = arr[:, :, 3:4] / 255.0
    comp = rgb * alpha  # over black background
    return 0.299 * comp[:, :, 0] + 0.587 * comp[:, :, 1] + 0.114 * comp[:, :, 2]


def alpha_bbox(img, thr=16):
    """Bounding box (x0, y0, x1, y1) of pixels with alpha > thr, or None if empty."""
    a = np.asarray(img)[:, :, 3]
    ys, xs = np.where(a > thr)
    if xs.size == 0:
        return None
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


FRAME_RE = re.compile(r"^f(\d+)", re.IGNORECASE)


def frame_index(name):
    m = FRAME_RE.match(Path(name).name)
    return int(m.group(1)) if m else None


def frame_map(folder):
    """{frame_index: Path} for f*.png in a sheet folder (WxH suffix ignored)."""
    out = {}
    for p in sorted(Path(folder).glob("f*.png")):
        idx = frame_index(p.name)
        if idx is not None:
            out[idx] = p
    return out


def iter_sheets(root):
    """Yield (sheet_name, folder). A dir holding f*.png directly is one sheet;
    otherwise each immediate sub-folder is a sheet."""
    root = Path(root)
    if list(root.glob("f*.png")):
        yield root.name, root
        return
    for sub in sorted(p for p in root.iterdir() if p.is_dir()):
        if list(sub.glob("f*.png")):
            yield sub.name, sub


def contact_sheet(frames, out_path, cols=12, cell=64):
    """Grid of HD frames on a checkerboard (reveals alpha halos)."""
    files = [frames[i] for i in sorted(frames)]
    if not files:
        return None
    rows = (len(files) + cols - 1) // cols
    W, H = cols * cell, rows * cell
    # checkerboard background
    base = Image.new("RGBA", (W, H), (0, 0, 0, 255))
    px = base.load()
    for y in range(H):
        for x in range(W):
            px[x, y] = (58, 58, 58, 255) if ((x >> 3) + (y >> 3)) & 1 else (38, 38, 38, 255)
    for k, f in enumerate(files):
        im = load_rgba(f)
        if max(im.size) > cell:
            s = cell / max(im.size)
            im = im.resize((max(1, int(im.width * s)), max(1, int(im.height * s))), Image.LANCZOS)
        ox = (k % cols) * cell + (cell - im.width) // 2
        oy = (k // cols) * cell + (cell - im.height) // 2
        base.alpha_composite(im, (ox, oy))
    out_path.parent.mkdir(parents=True, exist_ok=True)
    base.convert("RGB").save(out_path)
    return out_path


# ============================================================================
# pyiqa (optional, no-reference quality)
# ============================================================================
class Pyiqa:
    def __init__(self):
        self.ok = False
        self.metrics = {}
        try:
            import pyiqa  # noqa: F401  (heavy: pulls torch)
            import torch
            dev = "cuda" if torch.cuda.is_available() else "cpu"
            for name in ("niqe", "brisque"):
                try:
                    self.metrics[name] = pyiqa.create_metric(name, device=dev)
                except Exception as e:  # noqa: BLE001
                    print(f"  pyiqa: metric {name} unavailable ({e})")
            self.ok = bool(self.metrics)
        except Exception as e:  # noqa: BLE001
            print(f"  pyiqa requested but not available ({e}); skipping no-ref scores")

    def score(self, path):
        out = {}
        for name, m in self.metrics.items():
            try:
                out[name] = float(m(str(path)).item())
            except Exception:  # noqa: BLE001
                out[name] = None
        return out


# ============================================================================
# sprites QA
# ============================================================================
def qa_sprites(args):
    src_root, hd_root = Path(args.src), Path(args.hd)
    if not src_root.is_dir():
        sys.exit(f"qa_assets: source dir not found: {src_root}")
    if not hd_root.is_dir():
        sys.exit(f"qa_assets: HD dir not found: {hd_root}")

    src_sheets = dict(iter_sheets(src_root))
    hd_sheets = dict(iter_sheets(hd_root))
    shared = sorted(set(src_sheets) & set(hd_sheets))
    only_src = sorted(set(src_sheets) - set(hd_sheets))
    only_hd = sorted(set(hd_sheets) - set(src_sheets))
    if not shared:
        sys.exit("qa_assets: no sheets present in BOTH trees to compare")

    iqa = Pyiqa() if args.pyiqa else None
    out_dir = Path(args.out) / "sprites"
    rows = []          # per-sheet summary dicts
    failures = []      # (sheet, frame, reasons)

    for sheet in shared:
        s_frames = frame_map(src_sheets[sheet])
        h_frames = frame_map(hd_sheets[sheet])
        idxs = sorted(set(s_frames) & set(h_frames))
        miss = sorted(set(s_frames) ^ set(h_frames))
        for i in miss:
            failures.append((sheet, i, ["missing on " + ("HD" if i in s_frames else "SRC")]))

        sheet_scale = None
        ssims, niqe_vals, brisque_vals = [], [], []
        n_rgba = n_size = n_bbox = n_ssim = 0

        for i in idxs:
            reasons = []
            src_im = load_rgba(s_frames[i])
            hd_im = load_rgba(h_frames[i])
            sw, sh = src_im.size
            hw, hh = hd_im.size

            # RGBA: HD must carry a real (non-opaque-everywhere) alpha channel
            if np.asarray(hd_im)[:, :, 3].min() == 255 and np.asarray(src_im)[:, :, 3].min() < 255:
                reasons.append("alpha dropped (fully opaque)")
                n_rgba += 1

            # integer, uniform scale
            kx = hw / sw if sw else 0
            ky = hh / sh if sh else 0
            k_ok = kx == ky and float(kx).is_integer() and kx >= 1
            k = int(kx) if k_ok else None
            if args.scale:
                if k != args.scale:
                    reasons.append(f"size {hw}x{hh} != {args.scale}x {sw}x{sh}")
                    n_size += 1
                k = args.scale
            elif not k_ok:
                reasons.append(f"non-integer/asym scale ({kx:.2f}x/{ky:.2f}x)")
                n_size += 1
            else:
                if sheet_scale is None:
                    sheet_scale = k
                elif k != sheet_scale:
                    reasons.append(f"scale {k}x != sheet {sheet_scale}x")
                    n_size += 1

            # alpha bbox consistency
            sb, hb = alpha_bbox(src_im), alpha_bbox(hd_im)
            if (sb is None) != (hb is None):
                reasons.append("alpha-bbox present on one side only")
                n_bbox += 1
            elif sb is not None and k:
                exp = [c * k for c in sb]
                dmax = max(abs(hb[j] - exp[j]) for j in range(4))
                tol = args.bbox_tol if args.bbox_tol is not None else (k + 2)
                if dmax > tol:
                    reasons.append(f"alpha-bbox off by {dmax}px (tol {tol})")
                    n_bbox += 1

            # downscale-back SSIM vs source
            back = hd_im.resize((sw, sh), Image.LANCZOS)
            sv = ssim(luma_over_black(src_im), luma_over_black(back))
            ssims.append(sv)
            if sv < args.ssim_min:
                reasons.append(f"SSIM {sv:.3f} < {args.ssim_min}")
                n_ssim += 1

            if iqa and iqa.ok:
                sc = iqa.score(h_frames[i])
                if sc.get("niqe") is not None:
                    niqe_vals.append(sc["niqe"])
                if sc.get("brisque") is not None:
                    brisque_vals.append(sc["brisque"])

            if reasons:
                failures.append((sheet, i, reasons))

        sheet_path = None
        if not args.no_sheet:
            sheet_path = contact_sheet(h_frames, out_dir / f"{sheet}.png",
                                       cols=args.cols, cell=args.cell)

        rows.append({
            "sheet": sheet,
            "n": len(idxs),
            "scale": args.scale or sheet_scale,
            "rgba_f": n_rgba, "size_f": n_size, "bbox_f": n_bbox, "ssim_f": n_ssim,
            "miss": len(miss),
            "ssim_min": min(ssims) if ssims else None,
            "ssim_mean": sum(ssims) / len(ssims) if ssims else None,
            "niqe": sum(niqe_vals) / len(niqe_vals) if niqe_vals else None,
            "brisque": sum(brisque_vals) / len(brisque_vals) if brisque_vals else None,
            "sheet_png": sheet_path,
        })

    _print_sprite_summary(rows, failures, only_src, only_hd, iqa)
    return 0 if not failures else 1


def _fmt(val, spec):
    return format(val, spec) if val is not None else "-"


def _print_sprite_summary(rows, failures, only_src, only_hd, iqa):
    print("\n=== SPRITE QA SUMMARY ===")
    hdr = f"{'sheet':<22}{'frames':>7}{'k':>4}{'rgbaF':>6}{'sizeF':>6}{'bboxF':>6}{'ssimF':>6}{'missing':>8}{'SSIMmin':>9}{'SSIMavg':>9}"
    if iqa and iqa.ok:
        hdr += f"{'NIQE':>8}{'BRISQUE':>9}"
    print(hdr)
    print("-" * len(hdr))
    for r in rows:
        smin = _fmt(r["ssim_min"], ".3f")
        smean = _fmt(r["ssim_mean"], ".3f")
        scale = str(r["scale"] or "?")
        line = (f"{r['sheet']:<22}{r['n']:>7}{scale:>4}"
                f"{r['rgba_f']:>6}{r['size_f']:>6}{r['bbox_f']:>6}{r['ssim_f']:>6}{r['miss']:>8}"
                f"{smin:>9}{smean:>9}")
        if iqa and iqa.ok:
            line += f"{_fmt(r['niqe'], '.2f'):>8}{_fmt(r['brisque'], '.2f'):>9}"
        print(line)

    if only_src:
        print(f"\nsheets only in SRC (no HD): {', '.join(only_src)}")
    if only_hd:
        print(f"sheets only in HD (no SRC): {', '.join(only_hd)}")

    if failures:
        print(f"\n--- FAIL: {len(failures)} frame(s) ---")
        for sheet, frame, reasons in failures:
            print(f"  {sheet} f{frame:02d}: {'; '.join(reasons)}")
        print("\nRESULT: FAIL")
    else:
        print("\nRESULT: PASS")


# ============================================================================
# audio QA
# ============================================================================
def ffprobe_audio(ffprobe, path):
    cmd = [ffprobe, "-v", "error", "-select_streams", "a:0",
           "-show_entries", "stream=sample_rate,channels,duration:format=duration",
           "-of", "json", str(path)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    try:
        j = json.loads(r.stdout)
    except json.JSONDecodeError:
        return None
    st = (j.get("streams") or [{}])[0]
    dur = st.get("duration") or j.get("format", {}).get("duration")
    try:
        rate = int(st.get("sample_rate")) if st.get("sample_rate") else None
    except (TypeError, ValueError):
        rate = None
    try:
        dur = float(dur) if dur not in (None, "N/A") else None
    except (TypeError, ValueError):
        dur = None
    return {"rate": rate, "channels": st.get("channels"), "dur": dur}


PEAK_RE = re.compile(r"max_volume:\s*(-?\d+(?:\.\d+)?|-inf)\s*dB")


def audio_peak_dbfs(ffmpeg, path):
    cmd = [ffmpeg, "-hide_banner", "-i", str(path), "-af", "volumedetect", "-f", "null", "-"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    m = PEAK_RE.search(r.stderr)
    if not m:
        return None
    return float("-inf") if m.group(1) == "-inf" else float(m.group(1))


def spectrogram_pair(ffmpeg, src, hd, out_path, src_info, hd_info):
    """Stack src (top) + hd (bottom) showspectrumpic into one labelled PNG."""
    import tempfile
    tmp = Path(tempfile.mkdtemp(prefix="soi_spec_"))
    try:
        pics = []
        for tag, path, info in (("SRC", src, src_info), ("HD", hd, hd_info)):
            pic = tmp / f"{tag}.png"
            cmd = [ffmpeg, "-hide_banner", "-loglevel", "error", "-y", "-i", str(path),
                   "-lavfi", "showspectrumpic=s=1024x360:legend=1", str(pic)]
            if subprocess.run(cmd, capture_output=True, text=True).returncode == 0 and pic.exists():
                pics.append((tag, Image.open(pic).convert("RGB"), info))
        if not pics:
            return None
        w = max(p[1].width for p in pics)
        strip = 20
        total_h = sum(p[1].height + strip for p in pics)
        canvas = Image.new("RGB", (w, total_h), (16, 16, 16))
        draw = ImageDraw.Draw(canvas)
        y = 0
        for tag, im, info in pics:
            rate = info.get("rate") if info else None
            draw.text((6, y + 4), f"{tag}  {rate} Hz" if rate else tag, fill=(255, 255, 255))
            canvas.paste(im, (0, y + strip))
            y += im.height + strip
        out_path.parent.mkdir(parents=True, exist_ok=True)
        canvas.save(out_path)
        return out_path
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def qa_audio(args):
    ffmpeg = find_tool("ffmpeg", FF_FALLBACK)
    ffprobe = find_tool("ffprobe", FP_FALLBACK)
    if not ffmpeg or not ffprobe:
        sys.exit("qa_assets: ffmpeg/ffprobe not found (need them for audio QA)")

    src_root, hd_root = Path(args.src), Path(args.hd)
    if not src_root.is_dir() or not hd_root.is_dir():
        sys.exit("qa_assets: source and HD dirs must both exist for audio QA")

    src_files = {p.name: p for p in sorted(src_root.glob("*.wav")) + sorted(src_root.glob("*.ogg"))}
    hd_files = {p.name: p for p in sorted(hd_root.glob("*.wav")) + sorted(hd_root.glob("*.ogg"))}
    # match by stem (HD may switch container) then by exact name
    src_by_stem = {Path(n).stem: p for n, p in src_files.items()}
    shared = [n for n in hd_files if Path(n).stem in src_by_stem]
    if not shared:
        sys.exit("qa_assets: no matching audio files in both dirs")

    out_dir = Path(args.out) / "audio"
    rows, failures = [], []
    print("\n=== AUDIO QA SUMMARY ===")
    hdr = f"{'file':<34}{'srcHz':>7}{'hdHz':>7}{'peakdB':>8}{'srcDur':>8}{'hdDur':>8}{'dur%':>7}  result"
    print(hdr)
    print("-" * len(hdr))

    for name in sorted(shared):
        hd = hd_files[name]
        src = src_by_stem[Path(name).stem]
        si = ffprobe_audio(ffprobe, src) or {}
        hi = ffprobe_audio(ffprobe, hd) or {}
        peak = audio_peak_dbfs(ffmpeg, hd)
        reasons = []

        if hi.get("rate") != args.rate:
            reasons.append(f"rate {hi.get('rate')} != {args.rate}")
        if peak is not None and peak > args.peak:
            reasons.append(f"peak {peak:.1f} > {args.peak} dBFS")
        durpct = None
        if si.get("dur") and hi.get("dur"):
            durpct = abs(hi["dur"] - si["dur"]) / si["dur"] * 100.0
            if durpct > 1.0:
                reasons.append(f"duration off {durpct:.2f}%")

        if not args.no_spectro:
            spectrogram_pair(ffmpeg, src, hd, out_dir / f"{Path(name).stem}_spectro.png", si, hi)

        res = "PASS" if not reasons else "FAIL"
        if reasons:
            failures.append((name, reasons))
        if peak is None:
            peak_s = "-"
        elif peak == float("-inf"):
            peak_s = "-inf"
        else:
            peak_s = f"{peak:.1f}"
        src_rate = str(si.get("rate") or "-")
        hd_rate = str(hi.get("rate") or "-")
        src_dur = _fmt(si.get("dur"), ".2f")
        hd_dur = _fmt(hi.get("dur"), ".2f")
        dur_s = _fmt(durpct, ".2f")
        print(f"{name:<34}{src_rate:>7}{hd_rate:>7}{peak_s:>8}"
              f"{src_dur:>8}{hd_dur:>8}{dur_s:>7}  {res}")
        rows.append(name)

    if failures:
        print(f"\n--- FAIL: {len(failures)} file(s) ---")
        for name, reasons in failures:
            print(f"  {name}: {'; '.join(reasons)}")
        print("\nRESULT: FAIL")
    else:
        print("\nRESULT: PASS")
    return 0 if not failures else 1


# ============================================================================
# CLI
# ============================================================================
def main(argv=None):
    ap = argparse.ArgumentParser(prog="qa_assets", description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    sp = sub.add_parser("sprites", help="QA an HD sprite tree vs the source tree")
    sp.add_argument("src", help="source sprite dir (sheet tree or one sheet folder)")
    sp.add_argument("hd", help="HD sprite dir (parallel layout)")
    sp.add_argument("--scale", type=int, default=None, help="force expected integer scale (else auto per sheet)")
    sp.add_argument("--ssim-min", type=float, default=0.9, help="flag frames below this SSIM (default 0.9)")
    sp.add_argument("--bbox-tol", type=int, default=None, help="alpha-bbox tolerance in HD px (default scale+2)")
    sp.add_argument("--out", default="qa_out", help="output dir for contact sheets (default qa_out)")
    sp.add_argument("--cols", type=int, default=12, help="contact-sheet columns")
    sp.add_argument("--cell", type=int, default=64, help="contact-sheet cell px")
    sp.add_argument("--pyiqa", action="store_true", help="also compute pyiqa NIQE/BRISQUE (needs torch)")
    sp.add_argument("--no-sheet", action="store_true", help="skip contact-sheet PNGs")

    au = sub.add_parser("audio", help="QA an HD audio dir vs the source dir")
    au.add_argument("src", help="source audio dir (*.wav/*.ogg)")
    au.add_argument("hd", help="HD audio dir")
    au.add_argument("--rate", type=int, default=44100, help="target sample rate (default 44100)")
    au.add_argument("--peak", type=float, default=-1.0, help="max allowed peak dBFS (default -1.0)")
    au.add_argument("--out", default="qa_out", help="output dir for spectrograms (default qa_out)")
    au.add_argument("--no-spectro", action="store_true", help="skip spectrogram PNGs")

    args = ap.parse_args(argv)
    if args.cmd == "sprites":
        return qa_sprites(args)
    return qa_audio(args)


if __name__ == "__main__":
    sys.exit(main())
