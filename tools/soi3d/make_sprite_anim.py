"""make_sprite_anim.py -- build a 2D-vs-3D side-by-side comparison animation for a remastered sprite.

Given the original 2D source frames and the pre-rendered 3D spin frames (same count / same order), it
composites `OLD - 2D sprite | NEW - 3D` frames and writes BOTH:
  * a GIF with a SHARED adaptive palette + Floyd-Steinberg dither (kills the 256-colour banding that makes
    a naive GIF look worse than the PNG stills), and
  * a full-colour H.264 MP4 (via ffmpeg on PATH) -- the high-quality deliverable, no palette limit.

Render the 3D frames first (loop over spin), e.g.:
  for i in 0..N-1: blender --python tools/soi3d/render3d.py -- disk ren_i.png 400 0 0 <spin_i>; apply_glint ...
Match the 3D per-frame rotation to the MEASURED 2D spin (direction + deg/frame) so both sides spin at the
SAME speed; one clean symmetric cycle over the loop gives a seamless loop.

Usage:
  py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/disk_sprites/f*_32x30.png" \
        --ren "D:/scratch/anim/g_*.png" --out extracted/sprites_3d/disk_sprites/_verify/2d_vs_3d \
        [--fps 22] [--loops 4] [--panel 300] [--src-label "OLD - 2D sprite"] [--ren-label "NEW - 3D spin"]
Writes <out>.gif and (if ffmpeg present) <out>.mp4.
"""
import argparse
import glob
import os
import subprocess
import tempfile
import numpy as np
from PIL import Image, ImageDraw

BG = (24, 24, 28)
PANEL_BG = (16, 16, 20)


def _sortnum(paths):
    def key(p):
        b = os.path.basename(p)
        digits = "".join(c if c.isdigit() else " " for c in b).split()
        return int(digits[0]) if digits else 0
    return sorted(paths, key=key)


def _prep(path, size, nearest):
    """Composite on the panel bg, crop to content, resize to size x size (NEAREST for pixel-art 2D)."""
    im = Image.open(path).convert("RGBA")
    a = np.asarray(im)
    al = a[..., 3] > 40
    ys, xs = np.where(al)
    if len(xs):
        im = im.crop((xs.min(), ys.min(), xs.max() + 1, ys.max() + 1))
    b = Image.new("RGBA", im.size, BG + (255,))
    b.alpha_composite(im)
    return b.convert("RGB").resize((size, size), Image.NEAREST if nearest else Image.LANCZOS)


def build(src_glob, ren_glob, out, fps=22, loops=4, panel=300, pad=14, labh=26,
          src_label="OLD - 2D sprite", ren_label="NEW - 3D spin"):
    src = _sortnum(glob.glob(src_glob))
    ren = _sortnum(glob.glob(ren_glob))
    if not src or not ren:
        raise SystemExit(f"no frames: src={len(src)} ren={len(ren)} (check the globs)")
    n = len(ren)
    W, H = panel * 2 + pad * 3, panel + labh + pad
    frames = []
    for k in range(n * loops):
        i = k % n
        fr = Image.new("RGB", (W, H), PANEL_BG)
        d = ImageDraw.Draw(fr)
        fr.paste(_prep(src[i % len(src)], panel, True), (pad, labh))
        fr.paste(_prep(ren[i], panel, False), (pad * 2 + panel, labh))
        d.text((pad + panel // 2 - 52, 7), src_label, fill=(235, 235, 140))
        d.text((pad * 2 + panel + panel // 2 - 46, 7), ren_label, fill=(140, 235, 160))
        frames.append(fr)

    # GIF: one shared adaptive palette (from a montage of all frames) + per-frame dither -> smooth gradients
    thumbs = [f.resize((120, 70)) for f in frames[:n]]
    mont = Image.new("RGB", (120 * len(thumbs), 70))
    for i, t in enumerate(thumbs):
        mont.paste(t, (i * 120, 0))
    pal = mont.quantize(colors=256, method=Image.MAXCOVERAGE)
    pframes = [f.quantize(palette=pal, dither=Image.FLOYDSTEINBERG) for f in frames]
    dur = int(round(1000.0 / fps))
    pframes[0].save(out + ".gif", save_all=True, append_images=pframes[1:], duration=dur, loop=0, disposal=2)
    print("GIF ", out + ".gif", frames[0].size, "frames", len(frames))

    # MP4: full colour via ffmpeg (no palette). Frames -> temp PNGs -> libx264 yuv420p.
    if _have_ffmpeg():
        with tempfile.TemporaryDirectory() as td:
            for k, f in enumerate(frames):
                f.save(os.path.join(td, f"{k:04d}.png"))
            cmd = ["ffmpeg", "-y", "-loglevel", "error", "-framerate", str(fps),
                   "-i", os.path.join(td, "%04d.png"), "-c:v", "libx264", "-pix_fmt", "yuv420p",
                   "-crf", "18", "-movflags", "+faststart", out + ".mp4"]
            subprocess.run(cmd, check=True)
        print("MP4 ", out + ".mp4")
    else:
        print("MP4  skipped (ffmpeg not on PATH)")


def _have_ffmpeg():
    try:
        subprocess.run(["ffmpeg", "-version"], capture_output=True, check=True)
        return True
    except Exception:
        return False


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", required=True, help="glob of 2D source frames (pixel-art)")
    ap.add_argument("--ren", required=True, help="glob of 3D render frames (same count/order)")
    ap.add_argument("--out", required=True, help="output basename (writes .gif and .mp4)")
    ap.add_argument("--fps", type=int, default=22)
    ap.add_argument("--loops", type=int, default=4)
    ap.add_argument("--panel", type=int, default=300)
    ap.add_argument("--src-label", default="OLD - 2D sprite")
    ap.add_argument("--ren-label", default="NEW - 3D spin")
    a = ap.parse_args()
    build(a.src, a.ren, a.out, fps=a.fps, loops=a.loops, panel=a.panel,
          src_label=a.src_label, ren_label=a.ren_label)


if __name__ == "__main__":
    main()
