"""Scratch: would a post "fringe" (the originals' keyed dark rim) improve these families? Applies fringe px k to
copies of each published overlay frame and scores them like verify (IoU, blurred dE) plus the detail miss."""
import glob
import os
import shutil
import sys
import tempfile

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm

fams = sys.argv[1:]
tmp = tempfile.mkdtemp()
for fam in fams:
    cfg = fm.load_cfg(fam)
    s = cfg["scale"]
    od = os.path.join(fm.OVERLAY_DIR, cfg["source"])
    res = {}
    for k in (0, 1, 2, 3):
        ious, des, dms = [], [], []
        for nn, p, w, h in fm.sd_frames(cfg):
            cp = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
            if not cp:
                continue
            q = os.path.join(tmp, "f.png")
            shutil.copy(cp[0], q)
            if k:
                fm._post(q, [{"fringe": {"px": k}}])
            sd = fm.premul(fm.rgba(p))
            r = fm.box_down(fm.premul(fm.rgba(q)), s)
            ious.append(fm.compare(sd, r)[0])
            des.append(fm.compare_blur(sd, r))
            dms.append(fm.detail_miss(sd, r)[0])
        g = cfg["gate"]
        npass = sum(1 for i, d in zip(ious, des) if i >= g["iou"] and d <= g["de"])
        res[k] = (min(ious), float(np.mean(ious)), float(np.mean(des)), max(des), float(np.mean(dms)), npass, len(ious))
    print("== %s (gate IoU %.3f dE %.1f)" % (fam, cfg["gate"]["iou"], cfg["gate"]["de"]))
    for k, (imin, imean, dmean, dmax, dm, npass, n) in res.items():
        print("   fringe %d: IoU min %.3f mean %.3f  dE mean %.2f max %.2f  detail %.2f  pass %d/%d" % (k, imin, imean, dmean, dmax, dm, npass, n))
shutil.rmtree(tmp, ignore_errors=True)
