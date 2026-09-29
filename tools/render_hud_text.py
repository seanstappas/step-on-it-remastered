#!/usr/bin/env python3
"""Re-build the in-game HUD text sprites CRISPLY for the REMASTERED presentation.

The top HUD bar is blitted from the `extra's` sprite sheet (game.gd _draw_hud): the "Score" /
"Bonus" / "Board#" labels, the red digits 0-9 and the 2x-5x multipliers are tiny anti-aliased
glyphs (a tall condensed serif) on an opaque black box. The previous 4x HD sheet was an AI
upscale, so the text came out soft with wavy edges.

No installed font matches the original face, so instead of re-typesetting, the SD bitmap is
treated as what it is -- a coverage map of the glyphs (each pixel's brightness / the text colour
= how much of that pixel the glyph covers) -- and a 4x glyph image is solved for whose 4x4 block
averages reproduce that coverage while its outline is smooth and sharp (alternating a smooth +
binarize step with a projection back onto the per-pixel coverage). That recovers the ORIGINAL
glyph outlines and stroke weights, drawn with a crisp edge in the original colour.

  py tools/render_hud_text.py
Writes extracted/sprites_hd/extra_s/f<N>_<4W>x<4H>.png for the text frames (backs the previous
files up to tmp/hud_hd_backup/ once).
"""
from __future__ import annotations

import glob
import shutil
from pathlib import Path

import numpy as np
from PIL import Image

SD = Path("extracted/sprites/extra_s")
HD = Path("extracted/sprites_hd/extra_s")
BACKUP = Path("tmp/hud_hd_backup")
K = 4
# f02/f03 Bonus (P1 blue / P2 green), f04/f05 Score, f06-f15 digits 0-9, f28 Board#, f29-f32 2x-5x
FRAMES = [2, 3, 4, 5] + list(range(6, 16)) + [28, 29, 30, 31, 32]
ITERS = 80     # smooth/binarize <-> coverage-projection rounds
SIGMA = 1.2    # outline smoothing per round, in HD px
SLOPE = 9.0    # binarize steepness (the final edge is ~1 HD px wide)
EDGE = 0.6     # final edge level: slightly inside the 50% outline -- on the Mac's gamma-1.8
               # display a half-covered edge pixel looked darker than half, so the glyphs read
               # a touch thinner than their linear coverage (a gamma-corrected rebuild instead
               # breaks the 1-px hairlines apart)


def hd_paths(n: int) -> list[str]:
    return sorted(set(glob.glob(str(HD / ("f%d_*.png" % n))) + glob.glob(str(HD / ("f%02d_*.png" % n)))))


def blur(u: np.ndarray, sigma: float) -> np.ndarray:
    r = int(np.ceil(3 * sigma))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / sigma) ** 2)
    k /= k.sum()
    p = np.pad(u, r, mode="edge")
    p = sum(k[i] * p[:, i:i + u.shape[1]] for i in range(2 * r + 1))
    return sum(k[i] * p[i:i + u.shape[0], :] for i in range(2 * r + 1))


def block_mean(u: np.ndarray) -> np.ndarray:
    h, w = u.shape[0] // K, u.shape[1] // K
    return u.reshape(h, K, w, K).mean(axis=(1, 3))


def superres(cov: np.ndarray) -> np.ndarray:
    up = lambda m: np.kron(m, np.ones((K, K)))
    u = blur(up(cov), K / 2)
    for _ in range(ITERS):
        u = 1.0 / (1.0 + np.exp(-SLOPE * (blur(u, SIGMA) - 0.5)))
        for _ in range(3):                                         # back onto the coverage
            u = np.clip(u + up(cov - block_mean(u)), 0.0, 1.0)
    return 1.0 / (1.0 + np.exp(-SLOPE * (blur(u, SIGMA * 0.6) - EDGE)))


def rebuild(n: int) -> Image.Image:
    src = Image.open(glob.glob(str(SD / ("f%02d_*.png" % n)))[0]).convert("RGB")
    a = np.asarray(src).astype(np.float64)
    lum = a.max(axis=2)
    rgb = a.reshape(-1, 3)[lum.reshape(-1).argmax()]              # the text colour
    c = superres(np.clip(lum / lum.max(), 0.0, 1.0))
    c = np.clip(c / c.max(), 0.0, 1.0)
    out = (c[..., None] * rgb[None, None, :]).round().clip(0, 255).astype(np.uint8)
    return Image.fromarray(out, "RGB").convert("RGBA")


def main() -> int:
    if not BACKUP.exists():
        BACKUP.mkdir(parents=True)
        for n in FRAMES:
            for p in hd_paths(n):
                shutil.copy2(p, BACKUP / Path(p).name)
    for n in FRAMES:
        im = rebuild(n)
        for p in hd_paths(n):
            Path(p).unlink()
        im.save(HD / ("f%d_%dx%d.png" % (n, im.width, im.height)))
        print("f%02d -> %dx%d" % (n, im.width, im.height))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
