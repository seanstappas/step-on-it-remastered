#!/usr/bin/env python3
"""audit_sprite_motion.py -- quick STATIC-vs-ANIMATED audit of the sprite families.

For each extracted/sprites/<family>/ it loads the fNN frames, composites on black, resizes to a common
size, and measures how much the pixels actually change across the sequence:
  frames  = number of fNN frames
  uniq    = distinct frames (exact source-byte hash; << frames => padded/duplicated frames)
  motion% = mean per-pixel TEMPORAL std across the frames (0 = every frame identical) -- the key signal
  cons%   = mean CONSECUTIVE-frame abs difference (small vs motion% => smooth cycle)
  loop%   = first-vs-last frame difference (small => the cycle loops back)
Verdict:
  STATIC   -- 1 frame, or all frames ~identical (motion% ~0)
  ANIMATED -- frames change AND consecutive frames are much closer than the overall spread (a smooth cycle)
  MULTI?   -- frames change BUT each differs from its neighbour about as much as from any frame
              (distinct poses that are NOT a smooth cycle => a multi-variant / multi-object sheet: split it)

Usage:  py tools/audit_sprite_motion.py [--root extracted/sprites] [--size 48] [--csv out.csv]
"""
import argparse
import glob
import hashlib
import os

import numpy as np
from PIL import Image


def _frames(folder, size):
    paths = sorted(glob.glob(os.path.join(folder, "f*.png")))
    imgs, hashes = [], set()
    for p in paths:
        src = Image.open(p).convert("RGBA")
        hashes.add(hashlib.md5(src.tobytes()).hexdigest())
        a = np.asarray(src.resize((size, size), Image.BILINEAR)).astype(np.float32)
        imgs.append(a[..., :3] * (a[..., 3:4] / 255.0))   # composite on black
    return len(paths), len(hashes), imgs


def audit(folder, size, static_thresh):
    n, uniq, imgs = _frames(folder, size)
    if n == 0:
        return None
    stack = np.stack(imgs, 0)                         # [n,H,W,3], 0..255
    motion = float(stack.std(axis=0).mean())
    if n > 1:
        d = np.abs(np.diff(stack, axis=0)).mean(axis=(1, 2, 3))   # per consecutive-pair delta
        cons = float(d.mean())
        loop = float(np.abs(stack[0] - stack[-1]).mean())
        med = float(np.median(d))
        cuts = int(np.sum(d > max(med * 2.5, 3.0)))   # big jumps => segment boundaries (distinct objects/states)
        segs = cuts + 1
        loops = loop < max(med * 1.5, 2.0)            # end returns near the start => a repeating cycle
    else:
        cons = loop = 0.0
        segs = 1
        loops = False
    if n == 1 or uniq <= 1 or motion < static_thresh:
        verdict = "STATIC"
    elif segs >= 3:
        verdict = "MULTI(%d)" % segs                  # multi-object / multi-variant sheet -> SPLIT, classify each
    elif loops:
        verdict = "CYCLE"                             # smooth repeating animation (spin / idle loop)
    else:
        verdict = "ONE-SHOT"                          # non-looping animation (flip / build / transition)
    return dict(frames=n, uniq=uniq, motion=motion / 255 * 100, cons=cons / 255 * 100,
                loop=loop / 255 * 100, segs=segs, verdict=verdict)


def main():
    ap = argparse.ArgumentParser(description="Static-vs-animated audit of the sprite families.")
    ap.add_argument("--root", default="extracted/sprites")
    ap.add_argument("--size", type=int, default=48)
    ap.add_argument("--static-thresh", type=float, default=1.5, help="motion (0..255) below which = STATIC")
    ap.add_argument("--csv", default=None)
    a = ap.parse_args()
    fams = sorted(d for d in glob.glob(os.path.join(a.root, "*")) if os.path.isdir(d))
    rows = []
    hdr = "%-26s %6s %5s %8s %7s %7s %5s  %s" % ("family", "frames", "uniq", "motion%", "cons%", "loop%", "segs", "verdict")
    print(hdr)
    print("-" * len(hdr))
    for d in fams:
        r = audit(d, a.size, a.static_thresh)
        if r is None:
            continue
        name = os.path.basename(d)
        print("%-26s %6d %5d %8.2f %7.2f %7.2f %5d  %s" %
              (name, r["frames"], r["uniq"], r["motion"], r["cons"], r["loop"], r["segs"], r["verdict"]))
        rows.append((name, r))
    counts = {}
    for _, r in rows:
        counts[r["verdict"]] = counts.get(r["verdict"], 0) + 1
    print("-" * len(hdr))
    print("totals:", ", ".join("%s=%d" % (k, counts[k]) for k in sorted(counts)))
    if a.csv:
        with open(a.csv, "w", encoding="utf-8") as f:
            f.write("family,frames,uniq,motion_pct,cons_pct,loop_pct,segs,verdict\n")
            for name, r in rows:
                f.write("%s,%d,%d,%.3f,%.3f,%.3f,%d,%s\n" %
                        (name, r["frames"], r["uniq"], r["motion"], r["cons"], r["loop"], r["segs"], r["verdict"]))
        print("wrote", a.csv)


if __name__ == "__main__":
    main()
