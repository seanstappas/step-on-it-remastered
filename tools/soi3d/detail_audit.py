"""Detail audit: find small features of the SD originals (eyes, pupils, highlights, stripes, outlines, marks)
that a published 3D family's frames lose. The gate's blurred dE deliberately discounts sub-pixel texture, so
a frame can pass while an eye or a stripe is gone; this looks for exactly that.

Per frame, at SD resolution (the 3D frame box-downscaled), both composited over the game's black, with
framematch.detail_miss: detail layer D = Lab pre-smoothed (0.6 px: a 1 px dither checker averages out) minus
a masked Gaussian blur (1.2 SD px, opaque pixels only) -- what makes a pixel stand out from its surroundings,
independent of the overall tone; a source pixel with |D_sd| >= 15 is a feature; it is MISSED when no render
pixel within 1 px reproduces it: min_q |D_sd(p) - D_r(q)| >= KEEP * |D_sd(p)|.
Missed pixels are grouped into 8-connected blobs; blobs of >= 2 px (1 px on sprites under 20 px) count.

  py tools/soi3d/detail_audit.py [family ...]     (default: every published family)
Writes extracted/sprites_3d/<family>/_verify/detail_sheet.png (worst frames: SD | 3D | SD with the misses
marked, 8x) and extracted/sprites_3d/_verify/detail_audit.json; prints the families by miss rate.
"""
import glob
import json
import os
import sys

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import framematch as fm

KEEP = 0.6             # missed when the best nearby render detail is off by >= KEEP * |D_sd|
ZOOM = 8


def _blobs(mask):
    """8-connected components of a small boolean array -> [[(y, x), ...], ...]."""
    seen = np.zeros_like(mask, bool)
    out = []
    h, w = mask.shape
    for y0, x0 in zip(*np.nonzero(mask)):
        if seen[y0, x0]:
            continue
        stack, comp = [(y0, x0)], []
        seen[y0, x0] = True
        while stack:
            y, x = stack.pop()
            comp.append((y, x))
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    yy, xx = y + dy, x + dx
                    if 0 <= yy < h and 0 <= xx < w and mask[yy, xx] and not seen[yy, xx]:
                        seen[yy, xx] = True
                        stack.append((yy, xx))
        out.append(comp)
    return out


def audit_frame(sd_pm, r_pm):
    sa = sd_pm[..., 3] > 0.5
    _, feat, best, mag = fm.detail_miss(sd_pm, r_pm)
    h, w = sa.shape
    miss = feat & (best >= KEEP * mag)
    min_px = 1 if min(h, w) < 20 else 2
    blobs = [b for b in _blobs(miss) if len(b) >= min_px]
    keep = np.zeros_like(miss)
    for b in blobs:
        for y, x in b:
            keep[y, x] = True
    info = []
    for b in blobs:
        ys, xs = zip(*b)
        idx = (np.array(ys), np.array(xs))
        info.append({"px": len(b), "x": int(min(xs)), "y": int(min(ys)), "w": int(max(xs) - min(xs) + 1),
                     "h": int(max(ys) - min(ys) + 1),
                     "sd_rgb": [int(v) for v in (sd_pm[idx][:, :3].mean(0) * 255)],
                     "r_rgb": [int(v) for v in (r_pm[idx][:, :3].mean(0) * 255)],
                     "size": round(float(mag[idx].mean()), 1)})
    return {"feat": int(feat.sum()), "miss": int(keep.sum()), "area": int(sa.sum()), "blobs": info}, keep


def _tile(pm, zoom, mark=None):
    rgb = (np.clip(pm[..., :3], 0, 1) * 255).astype(np.uint8)
    im = Image.fromarray(rgb, "RGB").resize((pm.shape[1] * zoom, pm.shape[0] * zoom), Image.NEAREST)
    if mark is not None:
        d = ImageDraw.Draw(im)
        for y, x in zip(*np.nonzero(mark)):
            d.rectangle([x * zoom, y * zoom, x * zoom + zoom - 1, y * zoom + zoom - 1], outline=(255, 0, 255))
    return im


def audit_family(family, worst=4):
    cfg = fm.load_cfg(family)
    s = cfg["scale"]
    od = os.path.join(fm.OVERLAY_DIR, cfg["source"])
    rows = []
    for nn, p, w, h in fm.sd_frames(cfg):
        cp = glob.glob(os.path.join(od, "f%02d_*.png" % nn))
        if not cp:
            continue
        sd = fm.premul(fm.rgba(p))
        r = fm.box_down(fm.premul(fm.rgba(cp[0])), s)
        if r.shape[:2] != sd.shape[:2]:
            continue
        res, mark = audit_frame(sd, r)
        res["frame"] = nn
        rows.append((res, sd, r, mark))
    if not rows:
        return None
    feat = sum(r[0]["feat"] for r in rows)
    miss = sum(r[0]["miss"] for r in rows)
    area = sum(r[0]["area"] for r in rows)
    ranked = sorted(rows, key=lambda r: -r[0]["miss"])[:worst]
    ranked = [r for r in ranked if r[0]["miss"] > 0]
    if ranked:
        zoom = ZOOM if max(rows[0][1].shape[:2]) <= 48 else max(3, ZOOM // 2)
        tiles = [[_tile(sd, zoom), _tile(r, zoom), _tile(sd, zoom, mark)] for _, sd, r, mark in ranked]
        tw = max(t[0].width for t in tiles)
        th = max(t[0].height for t in tiles)
        sheet = Image.new("RGB", (3 * (tw + 6), len(tiles) * (th + 18)), (40, 40, 48))
        d = ImageDraw.Draw(sheet)
        for i, (t, (res, _, _, _)) in enumerate(zip(tiles, ranked)):
            for j, im in enumerate(t):
                sheet.paste(im, (j * (tw + 6), i * (th + 18) + 14))
            d.text((2, i * (th + 18)), "f%02d  missed %d px in %d blobs" % (res["frame"], res["miss"], len(res["blobs"])),
                   fill=(230, 230, 230))
        vd = os.path.join(fm.FAM_DIR, family, "_verify")
        os.makedirs(vd, exist_ok=True)
        sheet.save(os.path.join(vd, "detail_sheet.png"))
    return {"family": family, "source": cfg["source"], "frames": len(rows), "feature_px": feat, "missed_px": miss,
            "miss_rate": round(miss / max(1, feat), 4), "missed_per_frame": round(miss / len(rows), 2),
            "area_px": area, "worst": [r[0] for r in ranked]}


def main():
    fams = sys.argv[1:]
    if not fams:
        for p in sorted(glob.glob(os.path.join(fm.FAM_DIR, "*", "frames.json"))):
            with open(p, "r", encoding="utf-8-sig") as fh:
                if json.load(fh).get("status") == "published":
                    fams.append(os.path.basename(os.path.dirname(p)))
    out = []
    for fam in fams:
        rep = audit_family(fam)
        if rep:
            out.append(rep)
    out.sort(key=lambda r: -r["miss_rate"])
    print("%-22s %6s %8s %8s %9s  worst frame blobs (px @x,y  SD rgb -> 3D rgb)" % ("family", "frames", "features", "missed", "miss rate"))
    for r in out:
        wb = r["worst"][0]["blobs"] if r["worst"] else []
        wb = sorted(wb, key=lambda b: -b["px"])[:3]
        desc = "; ".join("%d@%d,%d %s->%s" % (b["px"], b["x"], b["y"], tuple(b["sd_rgb"]), tuple(b["r_rgb"])) for b in wb)
        print("%-22s %6d %8d %8d %8.1f%%  %s" % (r["family"], r["frames"], r["feature_px"], r["missed_px"],
                                                 100 * r["miss_rate"], ("f%02d " % r["worst"][0]["frame"] + desc) if wb else ""))
    vd = os.path.join(fm.FAM_DIR, "_verify")
    os.makedirs(vd, exist_ok=True)
    with open(os.path.join(vd, "detail_audit.json"), "w", encoding="utf-8") as fh:
        json.dump(out, fh, indent=1)


if __name__ == "__main__":
    main()
