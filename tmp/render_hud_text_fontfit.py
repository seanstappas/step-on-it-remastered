#!/usr/bin/env python3
"""Re-render the in-game HUD text sprites CRISPLY for the REMASTERED presentation.

The top HUD bar is blitted from the `extra's` sprite sheet (game.gd _draw_hud): the "Score" /
"Bonus" / "Board#" labels, the red digits 0-9 and the 2x-5x multipliers are tiny anti-aliased
Times Bold renders on an opaque black box. The 4x HD sheet upscaled those bitmaps, so the text
stays soft. Here each text frame is rendered again from the real font (Times New Roman Bold) at
4x -- same string, same colour, same box -- with the size and position FITTED to the original
bitmap (the 4x render box-filtered back down to 1x is matched against the SD frame), so the
glyphs land exactly where the original's do, only sharp.

  py tools/render_hud_text.py [--check]
Writes extracted/sprites_hd/extra_s/f<N>_<4W>x<4H>.png (backs the previous files up to
tmp/hud_hd_backup/ once). --check only prints the fit per frame.
"""
from __future__ import annotations

import glob
import shutil
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw, ImageFont

FONT = r"C:\Windows\Fonts\timesbd.ttf"   # Times New Roman Bold = the game's text font
SD = Path("extracted/sprites/extra_s")
HD = Path("extracted/sprites_hd/extra_s")
BACKUP = Path("tmp/hud_hd_backup")
K = 4
# frame -> string (f02/f03 Bonus blue/green, f04/f05 Score blue/green, f06-f15 digits,
# f28 Board#, f29-f32 the 2x-5x multipliers)
TEXT = {2: "Bonus", 3: "Bonus", 4: "Score", 5: "Score", 28: "Board#",
        29: "2x", 30: "3x", 31: "4x", 32: "5x"}
TEXT.update({6 + d: str(d) for d in range(10)})


def sd_frame(n: int) -> np.ndarray:
    g = glob.glob(str(SD / ("f%02d_*.png" % n)))
    return np.asarray(Image.open(g[0]).convert("RGB")).astype(np.float64)


def render(text: str, size: float, dx: float, dy: float, w: int, h: int, rgb) -> Image.Image:
    font = ImageFont.truetype(FONT, size * K)
    im = Image.new("RGB", (w * K, h * K), (0, 0, 0))
    d = ImageDraw.Draw(im)
    d.text((dx * K, dy * K), text, font=font, fill=tuple(int(v) for v in rgb), anchor="ls")
    return im


def score(im: Image.Image, target: np.ndarray) -> float:
    small = np.asarray(im.resize((target.shape[1], target.shape[0]), Image.BOX)).astype(np.float64)
    return float(((small.max(axis=2) - target.max(axis=2)) ** 2).sum())


def fit(n: int, text: str):
    sd = sd_frame(n)
    h, w = sd.shape[:2]
    lum = sd.max(axis=2)
    rgb = sd.reshape(-1, 3)[lum.reshape(-1).argmax()]          # the text colour = its brightest pixel
    best = None
    for size in np.arange(11.0, 19.01, 0.25):
        for base in np.arange(h - 5.0, h + 0.01, 0.25):        # baseline row
            for dx in np.arange(-1.5, 1.51, 0.25):
                s = score(render(text, size, dx, base, w, h, rgb), sd)
                if best is None or s < best[0]:
                    best = (s, size, dx, base)
    return best, rgb, w, h


def main() -> int:
    check = "--check" in sys.argv
    if not Path(FONT).exists():
        raise SystemExit("font not found: " + FONT)
    if not check and not BACKUP.exists():
        BACKUP.mkdir(parents=True)
        for n in TEXT:
            for p in glob.glob(str(HD / ("f%d_*.png" % n))) + glob.glob(str(HD / ("f%02d_*.png" % n))):
                shutil.copy2(p, BACKUP / Path(p).name)
    for n, text in sorted(TEXT.items()):
        (s, size, dx, base), rgb, w, h = fit(n, text)
        print("f%02d %-6s size %.2f dx %+.2f baseline %.2f  rms %.1f" % (n, text, size, dx, base, (s / (w * h)) ** 0.5))
        if check:
            continue
        for p in glob.glob(str(HD / ("f%d_*.png" % n))) + glob.glob(str(HD / ("f%02d_*.png" % n))):
            Path(p).unlink()
        render(text, size, dx, base, w, h, rgb).save(HD / ("f%d_%dx%d.png" % (n, w * K, h * K)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
