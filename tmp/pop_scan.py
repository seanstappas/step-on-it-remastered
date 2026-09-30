"""Animation pop scan: where does the published 3D change much more between consecutive frames than the SD does?
(A facing flip, a head twitch or a colour pop passes the per-frame gate but shows every animation cycle.)

  py tmp/pop_scan.py [family ...]          (default: every published family)
Per consecutive frame pair of the same size (both composited on black, the 3D box-downscaled to SD):
d = mean |a - b| over RGB. Prints pairs with d3d > 1.6 x dsd + 3 (worst ratio first)."""
import glob
import json
import os
import sys

import numpy as np
from PIL import Image

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402


def load(path, size=None):
    im = Image.open(path).convert("RGBA")
    if size is not None and im.size != size:
        im = im.resize(size, Image.BOX)
    bg = Image.new("RGBA", im.size, (0, 0, 0, 255))
    bg.alpha_composite(im)
    return np.asarray(bg.convert("RGB")).astype(np.float64)


fams = sys.argv[1:] or sorted(os.path.basename(os.path.dirname(p)) for p in glob.glob(os.path.join(fm.FAM_DIR, "*", "frames.json")))
rows = []
for fam in fams:
    try:
        cfg = fm.load_cfg(fam)
    except SystemExit:
        continue
    if cfg.get("status") != "published":
        continue
    od = os.path.join(fm.OVERLAY_DIR, cfg["source"])
    fr = {f[0]: f for f in fm.base_frames(cfg)}
    for nn in sorted(fr):
        if nn + 1 not in fr:
            continue
        a, b = fr[nn], fr[nn + 1]
        if (a[2], a[3]) != (b[2], b[3]):
            continue
        ra = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        rb = glob.glob(os.path.join(od, "f%02d_*.png" % (nn + 1)))
        if not ra or not rb:
            continue
        size = (a[2], a[3])
        dsd = float(np.abs(load(a[1]) - load(b[1])).mean())
        d3d = float(np.abs(load(ra[0], size) - load(rb[0], size)).mean())
        if d3d > 1.6 * dsd + 3.0:
            rows.append(((d3d + 1.0) / (dsd + 1.0), fam, nn, dsd, d3d))
rows.sort(reverse=True)
print("%-22s %-9s %7s %7s %6s" % ("family", "pair", "d_sd", "d_3d", "ratio"))
for r, fam, nn, dsd, d3d in rows[:60]:
    print("%-22s f%02d-f%02d %7.2f %7.2f %6.2f" % (fam, nn, nn + 1, dsd, d3d, r))
print("%d flagged pairs" % len(rows))
