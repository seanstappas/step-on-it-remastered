"""verify_3d.py -- fidelity validator for a 3D-remastered sprite vs its pixel-art source.

Purpose: stop eyeballing. Measure *every* dimension we care about numerically, so a 3D render can
be signed off (or flagged) against the original sprite frame it replaces. Works on ANY sprite pair
(disk, sign, coin, character frame, ...), so the same method applies across the whole sprite set.

Dimensions measured (see plan/SPRITE_FIDELITY_VALIDATION.md for the method):
  1. SHAPE     - silhouette IoU (alpha overlap after crop+resize)
  2. COLOUR    - per colour-class mean + deltaE (red / green / white / dark / blue, whichever present)
  3. ANGLE     - radial "arm" peak angles of a target colour (for spinners/stars) about the centroid
  4. TEXT      - white-text height as a fraction of the tile (for lettered sprites)
  5. RELIEF    - directional-shadow check: top-left vs bottom-right luminance (3D lit from top-left?)
  6. EDGES     - overlay of the render's silhouette edge on the source (visual alignment)

Both images are composited on black, cropped to content bbox, and resized to a common size first, so
lighting/scale differences don't dominate. deltaE is plain RGB Euclidean (good enough at this scale).

Usage:
  py tools/soi3d/verify_3d.py <source.png> <render.png> [--out cmp.png] [--arm red|green]
                        [--frac red|green|...] [--recess green|blue] [--text] [--angles]
  --arm     : radial arm-peak angles of a colour (spinners/stars)
  --frac    : area fraction of a colour class within the content (element size: blade/symbol/panel)
  --recess  : is the coloured centre sunken? (bottom-right vs top-left luminance; +ve => a lit-from-TL well)
  --text    : white-text height as a fraction of the tile
Always reported: shape IoU, per-class colour dE, mean saturation, grey-edge (rim) fraction, TL-BR relief.
Overlay panels: source | render | render-edge-on-source | grey-rim diagnostic (magenta = grey edge pixels).
"""
import sys
import math
import numpy as np
from PIL import Image, ImageDraw

N = 256  # common analysis resolution


# ---- load / normalise -------------------------------------------------------
def _load(path):
    a = np.asarray(Image.open(path).convert("RGBA")).astype(np.float32)
    return a[..., :3], a[..., 3] / 255.0


def _bbox(alpha, thr=0.35):
    ys, xs = np.where(alpha > thr)
    if len(xs) == 0:
        return 0, 0, alpha.shape[1], alpha.shape[0]
    return xs.min(), ys.min(), xs.max() + 1, ys.max() + 1


def _norm(path):
    """Composite on black, crop to content, resize to NxN. Returns (rgb[N,N,3], mask[N,N])."""
    rgb, alpha = _load(path)
    x0, y0, x1, y1 = _bbox(alpha)
    rgb, alpha = rgb[y0:y1, x0:x1], alpha[y0:y1, x0:x1]
    img = Image.fromarray((rgb * alpha[..., None]).astype(np.uint8)).resize((N, N), Image.LANCZOS)
    m = Image.fromarray((alpha * 255).astype(np.uint8)).resize((N, N), Image.LANCZOS)
    return np.asarray(img).astype(np.float32), np.asarray(m).astype(np.float32) / 255.0


# ---- colour classes ---------------------------------------------------------
def _cls(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    mx, mn = rgb.max(-1), rgb.min(-1)
    return {
        "red":   (r > 90) & (r > g + 45) & (r > b + 45),
        "green": (g > 60) & (g > r + 30) & (g > b + 25),
        "blue":  (b > 80) & (b > r + 30) & (b > g + 20),
        "white": (mx > 150) & (mx - mn < 45),
        "dark":  (mx < 70) & (mx > 6),
    }


def _mean(rgb, mask):
    return tuple(int(rgb[mask][:, i].mean()) for i in range(3)) if mask.sum() >= 8 else None


def _de(a, b):
    return round(math.sqrt(sum((a[i] - b[i]) ** 2 for i in range(3))), 1)


# ---- metrics ----------------------------------------------------------------
def _iou(ma, mb, thr=0.4):
    a, b = ma > thr, mb > thr
    u = (a | b).sum()
    return round(float((a & b).sum() / u), 3) if u else 0.0


def _arm_angles(rgb, mask, nbins=180, min_frac=0.4):
    ys, xs = np.where(mask)
    if len(xs) < 20:
        return []
    cy, cx = ys.mean(), xs.mean()
    ang = np.degrees(np.arctan2(-(ys - cy), (xs - cx))) % 360.0
    w = (np.hypot(xs - cx, ys - cy) > 0.18 * N).astype(float)   # ignore the hub
    h, _ = np.histogram(ang, bins=nbins, range=(0, 360), weights=w)
    k = 5
    h = np.convolve(np.concatenate([h[-k:], h, h[:k]]), np.ones(2 * k + 1) / (2 * k + 1), "same")[k:-k]
    thr = h.max() * min_frac
    return [round(i * 360.0 / nbins) for i in range(nbins)
            if h[i] >= thr and h[i] >= h[(i - 1) % nbins] and h[i] > h[(i + 1) % nbins]]


def _text_frac(rgb):
    """White-text height / tile height, sampling only the central 50% (excludes the ring)."""
    wm = _cls(rgb)["white"]
    H, W = rgb.shape[:2]
    sub = wm[int(H * .25):int(H * .75), int(W * .25):int(W * .75)]
    ys = np.where(sub.any(1))[0]
    return round((ys.max() - ys.min() + 1) / H, 2) if len(ys) else 0.0


def _relief(rgb, mask):
    """Mean luminance of the top-left vs bottom-right half within the content -> +ve => lit top-left."""
    lum = 0.299 * rgb[..., 0] + 0.587 * rgb[..., 1] + 0.114 * rgb[..., 2]
    H, W = lum.shape
    yy, xx = np.mgrid[0:H, 0:W]
    tl = mask.astype(bool) & ((xx - yy) < 0)     # upper-left triangle
    br = mask.astype(bool) & ((xx - yy) > 0)     # lower-right triangle
    if tl.sum() < 8 or br.sum() < 8:
        return 0.0
    return round(float(lum[tl].mean() - lum[br].mean()), 1)


def _edge(mask, thr=0.4):
    m = (mask > thr).astype(np.float32)
    return (np.abs(np.diff(m, axis=1, prepend=0)) + np.abs(np.diff(m, axis=0, prepend=0))) > 0


def _sat_map(rgb):
    """Per-pixel HSV saturation (0 grey .. 1 vivid)."""
    mx, mn = rgb.max(-1), rgb.min(-1)
    return np.where(mx > 0, (mx - mn) / np.clip(mx, 1e-6, None), 0.0)


def _sat(rgb, mask):
    """Mean saturation of the content -> how vivid/saturated the colour is (source vs render)."""
    m = mask > 0.5
    return round(float(_sat_map(rgb)[m].mean()), 3) if m.sum() else 0.0


def _rim_grey(rgb, mask):
    """Fraction of silhouette-EDGE pixels that are near-grey (sat < 0.2) -> a GREY outline/rim.
    Lower is better; a coloured object should keep a coloured edge, not a neutral grey fringe."""
    e = _edge(mask)
    return round(float((_sat_map(rgb)[e] < 0.2).mean()), 3) if e.sum() else 0.0


def _color_frac(rgb, mask, cls_name):
    """Area fraction of a colour class within the content -> element SIZE (blade / symbol / panel)."""
    m = mask > 0.5
    return round(float((_cls(rgb)[cls_name] & m).sum() / max(1, m.sum())), 3)


def _recess(rgb, mask, cls_name):
    """Recess check for framed tiles: within the coloured centre, is the TOP-LEFT inner edge darker
    than the BOTTOM-RIGHT (i.e. the centre sits in a well lit from top-left)? +ve => recessed."""
    m = _cls(rgb)[cls_name] & (mask > 0.5)
    ys, xs = np.where(m)
    if len(xs) < 40:
        return 0.0
    lum = 0.299 * rgb[..., 0] + 0.587 * rgb[..., 1] + 0.114 * rgb[..., 2]
    cy, cx = ys.mean(), xs.mean()
    yy, xx = np.mgrid[0:rgb.shape[0], 0:rgb.shape[1]]
    tl = m & ((xx - cx) + (yy - cy) < 0)     # upper-left half of the centre panel
    br = m & ~tl                             # lower-right half
    if tl.sum() < 8 or br.sum() < 8:
        return 0.0
    return round(float(lum[br].mean() - lum[tl].mean()), 1)



# ---- report -----------------------------------------------------------------
def fidelity(src_path, ren_path, out_path="cmp.png", arm=None, want_text=False, want_angles=False,
             frac=None, recess=None):
    s_rgb, s_m = _norm(src_path)
    r_rgb, r_m = _norm(ren_path)
    print(f"=== {src_path}  vs  {ren_path} ===")
    print(f"[shape ] silhouette IoU      : {_iou(s_m, r_m)}   (>=0.85 good)")

    print("[colour] per class  source -> render (dE):")
    sc, rc = _cls(s_rgb), _cls(r_rgb)
    for k in ("red", "green", "blue", "white", "dark"):
        sm, rm = _mean(s_rgb, sc[k]), _mean(r_rgb, rc[k])
        if sm and rm:
            flag = "" if _de(sm, rm) <= 25 else "  <-- off"
            print(f"         {k:6} {str(sm):>16} -> {str(rm):<16} dE={_de(sm, rm):<5}{flag}")

    ss, rs = _sat(s_rgb, s_m), _sat(r_rgb, r_m)
    sflag = "" if rs >= ss - 0.08 else "  <-- render less saturated"
    print(f"[satur.] mean saturation      : src {ss} / ren {rs}{sflag}")

    sg, rg = _rim_grey(s_rgb, s_m), _rim_grey(r_rgb, r_m)
    gflag = "  <-- grey rim!" if rg > 0.35 and rg > sg + 0.15 else ""
    print(f"[rim   ] grey edge fraction    : src {sg} / ren {rg}   (lower=coloured edge){gflag}")

    print(f"[relief] TL-BR luminance      : src {_relief(s_rgb, s_m):+} / ren {_relief(r_rgb, r_m):+}"
          f"   (same sign => both lit top-left)")

    if recess:
        sr, rr = _recess(s_rgb, s_m, recess), _recess(r_rgb, r_m, recess)
        rflag = "" if (sr > 0) == (rr > 0) else "  <-- recess direction differs"
        print(f"[recess] {recess} centre BR-TL lum  : src {sr:+} / ren {rr:+}   (+ve => sunken well){rflag}")

    if frac:
        sf, rf = _color_frac(s_rgb, s_m, frac), _color_frac(r_rgb, r_m, frac)
        fflag = "" if abs(sf - rf) <= 0.06 else ("  <-- render smaller" if rf < sf else "  <-- render larger")
        print(f"[size  ] {frac} area fraction   : src {sf} / ren {rf}{fflag}")

    if want_text:
        print(f"[text  ] white-text ht/tile   : src {_text_frac(s_rgb)} / ren {_text_frac(r_rgb)}")

    if want_angles or arm:
        col = arm or "red"
        sa = _arm_angles(s_rgb, sc[col])
        ra = _arm_angles(r_rgb, rc[col])
        da = "" if not (sa and ra) else f"   phase src {min(a % 90 for a in sa)} / ren {min(a % 90 for a in ra)}"
        print(f"[angle ] {col} arm peaks       : src {sa}")
        print(f"                                ren {ra}{da}")

    # overlay: source | render | render-edge-on-source | grey-rim diagnostic (magenta = grey edge)
    ov = Image.new("RGB", (N * 4 + 30, N + 24), (18, 18, 20))
    d = ImageDraw.Draw(ov)
    ov.paste(Image.fromarray(s_rgb.astype(np.uint8)), (0, 24))
    ov.paste(Image.fromarray(r_rgb.astype(np.uint8)), (N + 10, 24))
    comp = s_rgb.copy()
    comp[_edge(r_m)] = [255, 255, 0]
    ov.paste(Image.fromarray(comp.astype(np.uint8)), (2 * N + 20, 24))
    diag = r_rgb.copy()
    greypx = _edge(r_m) & (_sat_map(r_rgb) < 0.2)
    diag[greypx] = [255, 0, 255]                      # magenta marks any GREY rim on the render
    ov.paste(Image.fromarray(diag.astype(np.uint8)), (3 * N + 30, 24))
    for i, t in enumerate(["SOURCE", "RENDER", "RENDER edge on SRC", "grey-rim (magenta)"]):
        d.text((i * (N + 10) + 4, 6), t, fill=(230, 230, 120))
    ov.save(out_path)
    print(f"[overlay] {out_path}")


def main():
    a = list(sys.argv[1:])
    if a and a[0] in ("disk", "sign", "block", "spiral", "auto"):   # tolerate a leading kind token
        a = a[1:]
    src, ren = a[0], a[1]
    out = a[a.index("--out") + 1] if "--out" in a else "cmp.png"
    arm = a[a.index("--arm") + 1] if "--arm" in a else None
    frac = a[a.index("--frac") + 1] if "--frac" in a else None
    recess = a[a.index("--recess") + 1] if "--recess" in a else None
    fidelity(src, ren, out, arm=arm, want_text="--text" in a, want_angles="--angles" in a,
             frac=frac, recess=recess)


if __name__ == "__main__":
    main()
