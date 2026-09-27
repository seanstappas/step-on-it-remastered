"""Render a few Gargoyle test poses with the current frames.json opts and montage them beside SD frames."""
import os
import sys

from PIL import Image, ImageDraw

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

fam = "Gargoyle_sprites"
cfg = fm.load_cfg(fam)
d = os.path.join(os.path.dirname(__file__), "garg_test")
os.makedirs(d, exist_ok=True)
tests = [  # (sd frame, pose)
    (2, {"spread": -90, "wrap": 80, "crouch": 30, "arm": 0, "cloak": 0.77}),
    (10, {"spread": -60, "wrap": 60, "crouch": 10, "arm": 0, "cloak": 0.8}),
    (20, {"spread": 0, "wrap": 0, "crouch": 0, "arm": 160, "elbow": 40}),
    (60, {"spread": 0, "wrap": 0, "crouch": 0, "arm": 160, "elbow": 40, "egg": 1, "scroll": 5}),
]
frames = {nn: (p, w, h) for nn, p, w, h in fm.sd_frames(cfg)}
R = cfg["scale"] * max(max(w, h) for _, w, h in frames.values())
items = [{"out": os.path.join(d, "t%d.png" % i), "pose": pose, "opts": cfg["opts"]} for i, (_, pose) in enumerate(tests)]
fm.run_blender({"mode": cfg["mode"], "opts": cfg["opts"], "size": [R, R], "samples": 16, "items": items}, "garg_test")
Z = 4
tiles = []
for i, (nn, pose) in enumerate(tests):
    p, w, h = frames[nn]
    sd = Image.open(p).convert("RGBA")
    bg = Image.new("RGBA", sd.size, (30, 30, 36, 255))
    bg.alpha_composite(sd)
    r = Image.open(items[i]["out"]).convert("RGBA")
    rb = Image.new("RGBA", r.size, (30, 30, 36, 255))
    rb.alpha_composite(r)
    tiles.append((nn, bg.resize((w * Z, h * Z), Image.NEAREST), rb.resize((w * Z, w * Z), Image.LANCZOS)))
W = max(max(a.width, b.width) for _, a, b in tiles)
H1 = max(a.height for _, a, _ in tiles)
H2 = max(b.height for _, _, b in tiles)
out = Image.new("RGB", (len(tiles) * (W + 6), H1 + H2 + 26), (50, 50, 60))
dr = ImageDraw.Draw(out)
for i, (nn, a, b) in enumerate(tiles):
    out.paste(a, (i * (W + 6), 14))
    out.paste(b, (i * (W + 6), 20 + H1))
    dr.text((i * (W + 6) + 2, 1), "f%d" % nn, fill=(255, 230, 120))
out.save(os.path.join(d, "montage.png"))
print("montage", out.size)
