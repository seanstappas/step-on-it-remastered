"""Crisp remastered HUD text (the REMASTERED banner): re-typeset the `extra_s` HUD TEXT sprites -- the
"Bonus"/"Score" labels (f02-f05), the tally digits 0-9 (f06-f15), "Board#" (f28) and the multipliers
"2x".."5x" (f29-f32) -- at 4x in Times Bold (the original Mac HUD font), each glyph run fitted to its SD
sprite (size, x-scale, offset by least squares on the coverage), on the same opaque black box in the
sprite's own colour. Replaces the AI-upscaled (soft) frames in extracted/sprites_hd/extra_s; the icons
and the bevelled GAMEOVER letters keep their HD upscales.  py tools/hud_text_remaster.py [--check]"""
import os
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SD = os.path.join(ROOT, "extracted", "sprites", "extra_s")
HD = os.path.join(ROOT, "extracted", "sprites_hd", "extra_s")
FONT = r"C:\Windows\Fonts\timesbd.ttf"
K = 4
TEXT = {2: "Bonus", 3: "Bonus", 4: "Score", 5: "Score", 28: "Board#", 29: "2x", 30: "3x", 31: "4x", 32: "5x"}
TEXT.update({6 + d: str(d) for d in range(10)})


def sd_path(nn):
    return next(os.path.join(SD, f) for f in os.listdir(SD) if f.startswith("f%02d_" % nn))


def coverage(img):
    """The text's per-pixel coverage (its colour channel over the run's peak) and that peak colour."""
    a = np.asarray(img.convert("RGB")).astype(np.float64)
    c = int(np.argmax(a.reshape(-1, 3).max(0)))
    peak = a[..., c].max()
    col = a.reshape(-1, 3)[np.argmax(a[..., c])]
    return np.clip(a[..., c] / max(peak, 1.0), 0.0, 1.0), tuple(int(round(v)) for v in col)


def render(text, w, h, size, sx, ox, oy):
    """Coverage of `text` at K x: font `size` (SD px), x-scale `sx`, baseline-left at (ox, oy) SD px."""
    font = ImageFont.truetype(FONT, int(round(size * K)))
    l, t, r, b = font.getbbox(text, anchor="ls")
    wide = int(r - l) + 8 * K
    im = Image.new("L", (wide, h * K * 2), 0)
    ImageDraw.Draw(im).text((4 * K - l, h * K), text, font=font, fill=255, anchor="ls")
    im = im.resize((max(1, int(round(wide * sx))), im.height), Image.LANCZOS)
    out = Image.new("L", (w * K, h * K), 0)
    out.paste(im, (int(round(ox * K - 4 * K * sx)), int(round(oy * K - h * K))))
    return np.asarray(out).astype(np.float64) / 255.0


def down(cov, w, h):
    return cov.reshape(h, K, w, K).mean(axis=(1, 3))


def fit(text, tgt, w, h):
    """Coarse grid, then two finer passes around the best (size SD px, x-scale, baseline x/y)."""
    ys, xs = np.nonzero(tgt > 0.35)

    def err(p):
        return float(((down(render(text, w, h, *p), w, h) - tgt) ** 2).sum())
    grid = [(size, sx, ox, oy) for size in np.arange(12.0, 26.01, 1.0) for sx in np.arange(0.66, 1.121, 0.06)
            for ox in np.arange(xs.min() - 2.0, xs.min() + 1.01, 0.5) for oy in np.arange(ys.max() - 1.0, ys.max() + 2.51, 0.5)]
    best = min(grid, key=err)
    for ds, dsx, do in ((0.5, 0.03, 0.25), (0.25, 0.015, 0.125)):
        s0, x0, ox0, oy0 = best
        grid = [(s0 + i * ds, x0 + j * dsx, ox0 + a * do, oy0 + b * do)
                for i in (-1, 0, 1) for j in (-1, 0, 1) for a in (-1, 0, 1) for b in (-1, 0, 1)]
        best = min(grid, key=err)
    return (err(best),) + tuple(best)


def main():
    check = "--check" in sys.argv
    preview = []
    for nn, text in sorted(TEXT.items()):
        img = Image.open(sd_path(nn))
        w, h = img.size
        tgt, col = coverage(img)
        e, size, sx, ox, oy = fit(text, tgt, w, h)
        cov = render(text, w, h, size, sx, ox, oy)
        rgb = (cov[..., None] * np.array(col, np.float64)[None, None, :]).round().astype(np.uint8)
        out = Image.fromarray(np.concatenate([rgb, np.full(cov.shape + (1,), 255, np.uint8)], -1), "RGBA")
        err = float(np.abs(down(cov, w, h) - tgt).mean())
        name = next((f for f in os.listdir(HD) if f.startswith("f%d_" % nn) or f.startswith("f%02d_" % nn)), None)
        print("f%02d %-7r size %.1f sx %.2f at (%.2f, %.2f) colour %s  mean |coverage err| %.3f -> %s"
              % (nn, text, size, sx, ox, oy, col, err, name))
        preview.append((img.convert("RGBA").resize((w * K, h * K), Image.NEAREST), out,
                        Image.open(os.path.join(HD, name)).convert("RGBA") if name else None))
        if not check and name:
            out.save(os.path.join(HD, name))
    if "--preview" in sys.argv:
        z = 2
        cw = max(a.width for a, _, _ in preview) * z + 8
        rh = max(a.height for a, _, _ in preview) * z + 6
        sheet = Image.new("RGB", (cw * 3, rh * len(preview)), (40, 40, 60))
        for i, row in enumerate(preview):
            for j, im in enumerate(row):
                if im is not None:
                    sheet.paste(im.resize((im.width * z, im.height * z), Image.NEAREST), (j * cw + 4, i * rh + 3))
        sheet.save(os.path.join(ROOT, "tmp", "hud_text_preview.png"))
        print("preview tmp/hud_text_preview.png (columns: SD x4 nearest | new | current HD)")


if __name__ == "__main__":
    main()
