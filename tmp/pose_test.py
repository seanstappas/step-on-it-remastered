"""Render a family's fitted poses for a few frames with the CURRENT frames.json opts (+ look.json unless
--nolook) through the final camera, and montage them under the SD frames. Usage:
py tmp/pose_test.py <family> <nn,nn,...> [--nolook]"""
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, want = sys.argv[1], [int(x) for x in sys.argv[2].split(",")]
cfg = fm.load_cfg(fam)
base = dict(cfg["opts"]) if "--nolook" in sys.argv else fm._opts(fam, cfg)
fit = fm.load_fit(fam) if hasattr(fm, "load_fit") else None
if fit is None:
    import json
    with open(os.path.join(fm.WORK, fam, "fit.json"), "r", encoding="utf-8") as fh:
        fit = json.load(fh)
d = os.path.join(os.path.dirname(__file__), "pose_test")
os.makedirs(d, exist_ok=True)
s = cfg["scale"]
frames = [f for f in fm.sd_frames(cfg) if f[0] in want]
items = [{"out": os.path.join(d, "%s_f%02d.png" % (fam, nn)), "pose": fit["frames"][str(nn)]["pose"],
          "opts": fm.frame_opts(cfg, nn, base=base), "camera": fm._final_cam(fit, w, h, nn)} for nn, _, w, h in frames]
w0, h0 = frames[0][2], frames[0][3]
fm.run_blender({"mode": cfg["mode"], "opts": items[0]["opts"], "size": [w0 * s, h0 * s],
                "camera": fm._final_cam(fit, w0, h0), "samples": 32, "items": items}, fam + "_posetest")
Z = 6
tiles = []
for (nn, p, w, h), it in zip(frames, items):
    fm._post(it["out"], cfg["post"])
    sd = Image.open(p).convert("RGBA")
    bg = Image.new("RGBA", sd.size, (30, 30, 36, 255))
    bg.alpha_composite(sd)
    r = Image.open(it["out"]).convert("RGBA").resize((w * Z, h * Z), Image.LANCZOS)
    rb = Image.new("RGBA", r.size, (30, 30, 36, 255))
    rb.alpha_composite(r)
    tiles.append((nn, bg.resize((w * Z, h * Z), Image.NEAREST), rb))
W, H = max(t[1].width for t in tiles), max(t[1].height for t in tiles)
out = Image.new("RGB", (len(tiles) * (W + 6), 2 * (H + 6) + 14), (50, 50, 60))
dr = ImageDraw.Draw(out)
for i, (nn, a, b) in enumerate(tiles):
    out.paste(a, (i * (W + 6), 14))
    out.paste(b, (i * (W + 6), 20 + H))
    dr.text((i * (W + 6) + 2, 1), "f%d" % nn, fill=(255, 230, 120))
mp = os.path.join(d, "%s_montage.png" % fam)
out.save(mp)
print("montage", mp, out.size)
