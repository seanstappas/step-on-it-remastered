"""Montage the statue emblems: SD | committed (HEAD) overlay | current overlay, one row per family, with the
verify-style scores of each version.  py tmp/emblem_cmp.py <fam,fam,...> -> tmp/emblem_cmp.png"""
import glob
import io
import os
import subprocess
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
Z, rows = 6, []
for fam in sys.argv[1].split(","):
    cfg = fm.load_cfg(fam)
    nn, p, w, h = list(fm.sd_frames(cfg))[0]
    cur = glob.glob(os.path.join(fm.OVERLAY_DIR, cfg["source"], "f%02d_*.png" % nn))[0]
    rel = os.path.relpath(cur, ROOT).replace("\\", "/")
    head = subprocess.run(["git", "show", "HEAD:" + rel], cwd=ROOT, capture_output=True).stdout
    sd = fm.premul(fm.rgba(p))
    ims, txt = [Image.open(p).convert("RGBA").resize((w * Z, h * Z), Image.NEAREST)], []
    for tag, src in (("head", io.BytesIO(head) if head else None), ("now", cur)):
        if src is None:
            continue
        im = Image.open(src).convert("RGBA")
        tp = os.path.join(os.path.dirname(__file__), "_emblem_cmp_tmp.png")
        im.save(tp)
        r = fm.box_down(fm.premul(fm.rgba(tp)), cfg["scale"])
        txt.append("%s dE %.2f miss %.2f" % (tag, fm.compare_blur(sd, r), fm.detail_miss(sd, r)[0]))
        ims.append(im.resize((w * Z, h * Z), Image.LANCZOS))
    print(fam, " | ".join(txt))
    rows.append((fam + "  " + " | ".join(txt), ims, w * Z, h * Z))
W, H = rows[0][2], rows[0][3]
out = Image.new("RGB", (3 * (W + 6), len(rows) * (H + 20)), (40, 40, 48))
dr = ImageDraw.Draw(out)
for i, (label, ims, _, _) in enumerate(rows):
    dr.text((2, i * (H + 20) + 3), label, fill=(255, 230, 120))
    for j, im in enumerate(ims):
        bg = Image.new("RGBA", im.size, (60, 60, 70, 255))
        bg.alpha_composite(im)
        out.paste(bg, (j * (W + 6), i * (H + 20) + 16))
out.save(os.path.join(os.path.dirname(__file__), "emblem_cmp.png"))
print("montage tmp/emblem_cmp.png (cols: SD, HEAD, now)")
