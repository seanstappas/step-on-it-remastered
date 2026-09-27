"""Scratch: per-colour-cluster breakdown of where a family's frames differ from the SD (which part is off).
  py tmp/fm_colours.py <family> [k]"""
import glob
import os
import sys

import numpy as np

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm

fam = sys.argv[1]
k = int(sys.argv[2]) if len(sys.argv) > 2 else 7
only = {int(v) for v in sys.argv[3].split(",")} if len(sys.argv) > 3 else None
cfg = fm.load_cfg(fam)
s = cfg["scale"]
od = os.path.join(fm.OVERLAY_DIR, cfg["source"])
S, R, M = [], [], []
for nn, p, w, h in fm.sd_frames(cfg):
    if only and nn not in only:
        continue
    cp = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
    if not cp:
        cp = glob.glob(os.path.join(fm.workdir(fam, "final"), "f%02d.png" % nn))
    if not cp:
        continue
    sd = fm.premul(fm.rgba(p))
    r = fm.box_down(fm.premul(fm.rgba(cp[0])), s)
    if r.shape != sd.shape:
        continue
    m = sd[..., 3] > 0.5
    S.append(sd[m][:, :3])
    R.append(r[m][:, :3])
    M.append(r[m][:, 3] > 0.5)
S, R, M = np.concatenate(S), np.concatenate(R), np.concatenate(M)
L = fm._lab(np.clip(S, 0, 1))
rng = np.random.default_rng(0)
cent = L[rng.choice(len(L), k, replace=False)]
for _ in range(30):
    lab = np.argmin(((L[:, None, :] - cent[None]) ** 2).sum(-1), 1)
    cent = np.array([L[lab == i].mean(0) if (lab == i).any() else cent[i] for i in range(k)])
de = np.linalg.norm(L - fm._lab(np.clip(R, 0, 1)), axis=-1)
tot = de.sum()
print("%s: %d px, mean dE %.1f (unblurred)" % (fam, len(L), de.mean()))
for i in np.argsort([-de[lab == i].sum() for i in range(k)]):
    sel = lab == i
    if not sel.any():
        continue
    print("  SD %-15s -> 3D %-15s  %5d px  dE %5.1f  share %4.1f%%  (3D transparent there %4.1f%%)" % (
        tuple(int(v) for v in S[sel].mean(0) * 255), tuple(int(v) for v in R[sel].mean(0) * 255), sel.sum(),
        de[sel].mean(), 100 * de[sel].sum() / tot, 100 * (~M[sel]).mean()))
