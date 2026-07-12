#!/usr/bin/env python3
"""Re-render the fixed-text PICT panels (the board / challenge TALLY LABEL panels)
crisply with the real serif font, instead of AI-upscaling their tiny bitmap text
(which stays soft no matter the model).

Each panel is plain serif LABELS on black + a bevel bar (e.g. 1020/1021 board tally
"Board# / Bonus / No Weapons Reward / Score"; 303/304 the challenge tally). The
label STRINGS are fixed + known; the text COLOUR, the per-row Y positions and the
bar geometry are AUTO-MEASURED from the SD source, so the blue/green variants just
work. Output overwrites the soft AI-upscaled versions in the chosen HD folder.

NOTE: the port draws the in-game tally with a LIVE font already (game.gd
_draw_complete_tally), so these panels are not shown in-game -- this is extracted-
asset polish (a crisp reference / potential future faithful use).

Usage:  py tools/render_text_picts.py [--out DIR] [--scale N] [--only STEM ...]
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw, ImageFont

SRC = Path("extracted") / "pict"
FONT = r"C:\Windows\Fonts\timesbd.ttf"     # Times New Roman Bold = the game's text font

# panel stem -> the label strings, top to bottom (one per coloured text row)
PANELS = {
    "1020_blue_tally":  ["Board#", "Bonus", "No Weapons Reward", "Score"],
    "1021_green_tally": ["Board#", "Bonus", "No Weapons Reward", "Score"],
    "303_blue_challenge_tally":  ["Bonus", "Score"],
    "304_green_challenge_tally": ["Bonus", "Score"],
}


def bands(mask_rows: np.ndarray, gap: int = 3) -> list[tuple[int, int]]:
    ys = np.where(mask_rows)[0]
    out: list[tuple[int, int]] = []
    if len(ys) == 0:
        return out
    s = p = ys[0]
    for y in ys[1:]:
        if y - p > gap:
            out.append((s, p)); s = y
        p = y
    out.append((s, p))
    return out


def measure(sd: np.ndarray):
    r, g, b = sd[:, :, 0].astype(int), sd[:, :, 1].astype(int), sd[:, :, 2].astype(int)
    chroma = np.maximum.reduce([r, g, b]) - np.minimum.reduce([r, g, b])
    text = (chroma > 40) & (np.maximum.reduce([r, g, b]) > 60)   # coloured ink (not black/grey/white)
    white = (r > 150) & (g > 150) & (b > 150)
    rows = []
    for (y0, y1) in bands(text.any(axis=1)):
        xs = np.where(text[y0:y1 + 1].any(axis=0))[0]
        rows.append((y0, y1, int(xs.min()), int(xs.max())))
    txt_rgb = tuple(int(v) for v in sd[text].mean(axis=0).round()) if text.any() else (0, 200, 0)
    barlist = []
    for (y0, y1) in bands(white.any(axis=1), gap=6):   # gap=6 keeps a beveled bar as ONE band
        xs = np.where(white[y0:y1 + 1].any(axis=0))[0]
        if len(xs) and xs.max() - xs.min() > sd.shape[1] * 0.4:   # a real bar spans most of the width
            barlist.append((y0, y1, int(xs.min()), int(xs.max())))
    return txt_rgb, rows, barlist


def fit_size(draw: ImageDraw.ImageDraw, labels, rows, scale: int) -> int:
    iw = int(np.argmax([r[3] - r[2] for r in rows]))          # widest row == longest label
    target = (rows[iw][3] - rows[iw][2] + 1) * scale
    lo, hi = 8, 200
    while lo < hi:
        mid = (lo + hi + 1) // 2
        if draw.textlength(labels[iw], font=ImageFont.truetype(FONT, mid)) <= target:
            lo = mid
        else:
            hi = mid - 1
    return lo


def render(stem: str, labels: list[str], scale: int, out: Path) -> None:
    sd = np.array(Image.open(SRC / (stem + ".png")).convert("RGB"))
    h, w, _ = sd.shape
    txt_rgb, rows, barlist = measure(sd)
    if len(rows) != len(labels):
        print(f"  ! {stem}: measured {len(rows)} text rows but have {len(labels)} labels -- skipped")
        return
    img = Image.new("RGB", (w * scale, h * scale), (0, 0, 0))
    d = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT, fit_size(d, labels, rows, scale))
    for (y0, _y1, x0, _x1), text in zip(rows, labels):
        bb = d.textbbox((0, 0), text, font=font)
        d.text((x0 * scale - bb[0], y0 * scale - bb[1]), text, font=font, fill=txt_rgb)
    for (r0, r1, rx0, rx1) in barlist:
        by0, by1, bx0, bx1 = r0 * scale, r1 * scale, rx0 * scale, rx1 * scale
        d.rectangle([bx0, by0, bx1, by1], fill=(214, 214, 214))
        d.line([(bx0, by0), (bx1, by0)], fill=(242, 242, 242))   # top highlight
        d.line([(bx0, by1), (bx1, by1)], fill=(150, 150, 150))   # bottom shadow bevel
    out.mkdir(parents=True, exist_ok=True)
    img.save(out / (stem + ".png"))
    print(f"  {stem}: {len(labels)} labels, colour {txt_rgb}, {len(barlist)} bar(s) -> {img.width}x{img.height}")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="extracted/pict_hd_v2")
    ap.add_argument("--scale", type=int, default=4)
    ap.add_argument("--only", nargs="*", default=None)
    args = ap.parse_args()
    if not Path(FONT).exists():
        raise SystemExit(f"font not found: {FONT}")
    out = Path(args.out)
    stems = args.only or list(PANELS)
    for stem in stems:
        if stem not in PANELS:
            print(f"  ! unknown panel {stem}"); continue
        render(stem, PANELS[stem], args.scale, out)
    print(f"done -> {out.as_posix()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
