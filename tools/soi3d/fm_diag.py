"""Why does a framematch frame fail?  Per-source-colour share of the blurred dE, missing/extra silhouette rows,
and (--map) an ASCII class map of the source next to its final render.
usage: py tools/soi3d/fm_diag.py <family> <frame> [<frame> ...] [--map]"""
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import framematch as fm


def _cls(px):
    r, g, b, a = (v * 255 for v in px)
    if a < 128:
        return "."
    if b > 1.4 * r + 10 and b > 1.4 * g + 10:
        return "B" if b > 110 else "b"
    if 0.299 * r + 0.587 * g + 0.114 * b < 30:
        return "K"
    if r > 1.6 * g + 10 and r > 1.6 * b + 10 and g < 0.45 * r:
        return "R" if r > 90 else "r"
    if g > 1.3 * r + 10 and g > 1.3 * b + 10:
        return "G" if g > 110 else "g"
    if r > g > b and r > 150 and g > 0.55 * r:
        return "S"
    if r > g > b and r > 60:
        return "H"
    if min(r, g, b) > 170:
        return "W"
    return "?"


def _unpremul(x):
    y = x.copy()
    y[..., :3] = np.where(x[..., 3:4] > 0, x[..., :3] / np.maximum(x[..., 3:4], 1e-6), 0)
    return y


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    fam, want = args[0], [int(a) for a in args[1:]]
    cfg = fm.load_cfg(fam)
    s = cfg["scale"]
    paths = {nn: p for nn, p, _, _ in fm.sd_frames(cfg)}
    for nn in want:
        sd = fm.premul(fm.rgba(paths[nn]))
        r = fm.box_down(fm.premul(fm.rgba(os.path.join(fm.workdir(fam, "final"), "f%02d.png" % nn))), s)
        a, b = sd[..., 3] > 0.5, r[..., 3] > 0.5
        uni = a | b
        bs, br = fm._blur(sd), fm._blur(r)
        de = np.linalg.norm(fm._lab(np.clip(bs[..., :3], 0, 1)) - fm._lab(np.clip(br[..., :3], 0, 1)), axis=-1)
        tot = de[uni].sum()
        print("f%02d  iou %.3f  dE %.2f  union %d  missing %d  extra %d" % (
            nn, (a & b).sum() / uni.sum(), de[uni].mean(), uni.sum(), (a & ~b).sum(), (b & ~a).sum()))
        for tag, m in (("missing", a & ~b), ("extra  ", b & ~a)):
            if m.any():
                print("   %s rows %s" % (tag, sorted(set(np.nonzero(m)[0].tolist()))))
        q = (np.clip(sd[..., :3], 0, 1) * 255 / 32).astype(int)
        key = q[..., 0] * 64 + q[..., 1] * 8 + q[..., 2]
        rows = []
        for k in np.unique(key[a]):
            m = a & (key == k)
            rows.append((de[m].sum() / tot, m.sum(), (sd[..., :3][m].mean(0) * 255).astype(int).tolist(),
                         (r[..., :3][m].mean(0) * 255).astype(int).tolist(), de[m].mean()))
        m = b & ~a
        if m.any():
            rows.append((de[m].sum() / tot, m.sum(), "EXTRA", (r[..., :3][m].mean(0) * 255).astype(int).tolist(),
                         de[m].mean()))
        for share, n, sc, rc, d in sorted(rows, key=lambda t: -t[0])[:7]:
            print("   %4.0f%% of dE  n=%3d  src %-16s ren %-16s dE %.1f" % (share * 100, n, sc, rc, d))
        if "--map" in sys.argv:
            us, ur = _unpremul(sd), _unpremul(r)
            for y in range(us.shape[0]):
                print("   %2d %s   %s" % (y, "".join(_cls(us[y, x]) for x in range(us.shape[1])),
                                          "".join(_cls(ur[y, x]) for x in range(ur.shape[1]))))


if __name__ == "__main__":
    main()
