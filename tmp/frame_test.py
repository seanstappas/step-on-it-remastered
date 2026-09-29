"""Render some frames of a published family with its full look (cfg opts + look.json opts + look.json per-frame
opts) plus JSON overrides, into tmp/frame_test (never the overlay), score them like verify and montage
SD | published | test.  py tmp/frame_test.py <family> <nn,nn,...> [<json overrides for every frame>]"""
import glob
import json
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam, want = sys.argv[1], [int(x) for x in sys.argv[2].split(",")]
over = json.loads(sys.argv[3]) if len(sys.argv) > 3 else {}
cfg = fm.load_cfg(fam)
with open(os.path.join(fm.WORK, fam, "fit.json"), "r", encoding="utf-8") as fh:
    fit = json.load(fh)
base, lfo, s = fm._opts(fam, cfg), fm._look_frame_opts(fam), cfg["scale"]
d = os.path.join(os.path.dirname(__file__), "frame_test")
os.makedirs(d, exist_ok=True)
frames = [f for f in fm.sd_frames(cfg) if f[0] in want]
items = [{"out": os.path.join(d, "%s_f%02d.png" % (fam, nn)), "pose": fit["frames"][str(nn)]["pose"],
          "opts": {**fm.frame_opts(cfg, nn, base=base), **lfo.get(str(nn), {}), **over},
          "camera": fm._final_cam(fit, w, h, nn)} for nn, _, w, h in frames]
w0, h0 = frames[0][2], frames[0][3]
fm.run_blender({"mode": cfg["mode"], "opts": items[0]["opts"], "size": [w0 * s, h0 * s],
                "camera": fm._final_cam(fit, w0, h0), "samples": cfg["samples"].get("final", 256), "items": items},
               fam + "_frametest")
od = os.path.join(fm.OVERLAY_DIR, cfg["source"])
Z, tiles = 6, []
for (nn, p, w, h), it in zip(frames, items):
    fm._post(it["out"], cfg.get("post") or [])
    sd = fm.premul(fm.rgba(p))
    row = []
    for tag, path in (("pub", (glob.glob(os.path.join(od, "f%02d_*.png" % nn)) or [None])[0]), ("test", it["out"])):
        if path is None:
            row.append((tag, None, None))
            continue
        r = fm.box_down(fm.premul(fm.rgba(path)), s)
        row.append((tag, (fm.compare(sd, r)[0], fm.compare_blur(sd, r), fm.detail_miss(sd, r)[0]), path))
    print("f%02d " % nn + "  ".join("%s IoU %.3f dE %.2f miss %.2f" % ((t,) + v) if v else "%s -" % t for t, v, _ in row))
    ims = [Image.open(p).convert("RGBA").resize((w * Z, h * Z), Image.NEAREST)] + \
          [Image.open(pp).convert("RGBA").resize((w * Z, h * Z), Image.LANCZOS) for _, _, pp in row if pp]
    tiles.append((nn, ims))
W, H = frames[0][2] * Z, frames[0][3] * Z
n = max(len(t[1]) for t in tiles)
out = Image.new("RGB", (len(tiles) * (W + 6), n * (H + 6) + 14), (40, 40, 48))
dr = ImageDraw.Draw(out)
for i, (nn, ims) in enumerate(tiles):
    for j, im in enumerate(ims):
        bg = Image.new("RGBA", im.size, (60, 60, 70, 255))
        bg.alpha_composite(im)
        out.paste(bg, (i * (W + 6), 14 + j * (H + 6)))
    dr.text((i * (W + 6) + 2, 1), "f%d" % nn, fill=(255, 230, 120))
mp = os.path.join(d, "%s_montage.png" % fam)
out.save(mp)
print("montage", mp, "(rows: SD, published, test)")
