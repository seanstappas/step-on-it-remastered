"""soi3d.ref_compare -- compare published 3D frames with the HD reference art of the original game.

References (all in the repo): the Step On It reference card (refs/text/StepOnItRefCard.pdf, greyscale renders of
Ted, a block, the goodies, weapons and nasties -- extracted with PyMuPDF), the Fun Bundle 2 box art
(refs/text/FunBundle2Package.pdf pages 3-4) and the title pictures (extracted/pict/300, 320, 1010, 1030).
For each family with a reference, writes extracted/sprites_3d/<family>/_verify/ref_compare.png: one row per
reference = HD reference | SD source frame | our 3D frame | our 3D frame in greyscale (the card is greyscale).
The frame is the family's best silhouette match to the reference (mirror allowed) unless the table names one.

  py tools/soi3d/ref_compare.py [family ...]      (default: every family in REFS)
"""
import io
import os
import sys

import numpy as np
from PIL import Image, ImageDraw, ImageOps

sys.path.insert(0, os.path.dirname(__file__))
import framematch as fm  # noqa: E402

ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
CARD = os.path.join(ROOT, "refs", "text", "StepOnItRefCard.pdf")
BOX = os.path.join(ROOT, "refs", "text", "FunBundle2Package.pdf")
PICT = os.path.join(ROOT, "extracted", "pict")

# family -> [(label, source, frame or None[, zoom[, mirror]])]; source = ("card", image index) | ("box", page, crop) |
# ("pict", file, crop box or None); zoom = (x0, y0, x1, y1) fractions of our frame's bounding box (a close-up);
# mirror = True / False overrides the shading-based mirror choice
REFS = {
    "BP_run": [("ref card: Ted running", ("card", 6), None),
               ("box art (colour): Ted running with a coin", ("box", 3, (318, 222, 412, 350)), 30),
               ("box art (greyscale): Ted running with a coin", ("box", 4, (350, 250, 452, 395)), 30)],
    "GP_run": [("ref card: Ted running", ("card", 6), None)],
    "BP_cheer": [("1010 blue player (front)", ("pict", "1010_blue_player.png", None), 122),
                 ("1030 blue wins (face)", ("pict", "1030_blue_wins.png", (60, 0, 160, 110)), 122, (0.3, 0.0, 0.7, 0.45))],
    "BP_sprites": [("320 congratulations (Ted kneeling, profile)", ("pict", "320_Congratulations.png", (190, 180, 330, 360)), 61)],
    "block_sprites": [("ref card: block", ("card", 7), 110)],
    "goody_shoe": [("ref card: magic shoe", ("card", 9), None)],
    "goody_gear": [("ref card: thunder helmet", ("card", 10), 50), ("ref card: shield", ("card", 15), 49)],
    "goody_coin": [("ref card: coin", ("card", 11), None)],
    "goody_coin_silver": [("ref card: coin", ("card", 11), None)],
    "goody_goldbar": [("ref card: gold bar", ("card", 12), None)],
    "goody_props": [("ref card: door", ("card", 13), 5), ("ref card: key", ("card", 14), None)],
    "ant_sprites": [("ref card: ant", ("card", 16), None)],
    "ostrich_sprites": [("ref card: ostrich", ("card", 17), None, None, False)],
    "hippo_sprites": [("ref card: hippo", ("card", 18), None)],
    "piggy_sprites": [("ref card: piggy", ("card", 19), None),
                      ("box art (colour): piggy", ("box", 3, (240, 290, 335, 392)), 19),
                      ("box art (greyscale): piggy", ("box", 4, (238, 318, 372, 446)), 19)],
    "smiley_sprites": [("ref card: labelled 'Wheelie' -- the face is the game's Smiley (sssf 1011)", ("card", 20), None)],
    "weapons_arrow": [("ref card: arrow", ("card", 21), None)],
    "weapons": [("ref card: magic ball", ("card", 23), None, None, True)],
    "beenie_char": [("ref card: beenie, three-quarter view", ("card", 24), 77)],
    "knight_sprites": [("300 challenge title", ("pict", "300_Challenge_Title.png", (410, 78, 548, 358)), 2),
                       ("320 congratulations (in shadow)", ("pict", "320_Congratulations.png", (300, 140, 470, 380)), 2)],
    "Gargoyle_sprites": [("300 challenge title", ("pict", "300_Challenge_Title.png", (50, 120, 312, 358)), 20)],
}
T = 240                                                     # tile size (px)
_pdf_cache = {}


def _pdf_images(path, page):
    """The embedded images of a PDF page, in get_images order, as RGBA PIL images (soft masks applied)."""
    key = (path, page)
    if key not in _pdf_cache:
        import fitz
        doc = fitz.open(path)
        out = []
        for im in doc[page - 1].get_images(full=True):
            pix = fitz.Pixmap(doc, im[0])
            if im[1]:
                pix = fitz.Pixmap(pix, fitz.Pixmap(doc, im[1]))
            if pix.n - pix.alpha >= 4:
                pix = fitz.Pixmap(fitz.csRGB, pix)
            out.append(Image.open(io.BytesIO(pix.tobytes("png"))).convert("RGBA"))
        _pdf_cache[key] = out
    return _pdf_cache[key]


def load_ref(src):
    if src[0] == "card":
        return _pdf_images(CARD, 1)[src[1]]
    if src[0] == "box":
        im = _pdf_images(BOX, src[1])[0]
        return im.crop(src[2]) if len(src) > 2 else im
    im = Image.open(os.path.join(PICT, src[1])).convert("RGBA")
    return im.crop(src[2]) if src[2] else im


def _mask(im):
    a = np.asarray(im)
    if (a[..., 3] < 250).any():
        return a[..., 3] > 127
    rgb = a[..., :3].astype(int)
    bg = rgb[0, 0]                                          # an opaque card image: separate from its corner colour
    return np.abs(rgb - bg).sum(-1) > 40


def _norm(m, n=96):
    ys, xs = np.nonzero(m)
    if len(xs) == 0:
        return np.zeros((n, n), bool)
    c = m[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    s = (n - 4) / max(c.shape)
    im = Image.fromarray((c * 255).astype(np.uint8)).resize((max(1, round(c.shape[1] * s)), max(1, round(c.shape[0] * s))))
    a = np.asarray(im) > 127
    out = np.zeros((n, n), bool)
    oy, ox = (n - a.shape[0]) // 2, (n - a.shape[1]) // 2
    out[oy:oy + a.shape[0], ox:ox + a.shape[1]] = a
    return out


def _frames(family):
    cfg = fm.load_cfg(family)
    sheet = cfg.get("source", family)
    od = os.path.join(fm.OVERLAY_DIR, sheet)
    out = {}
    for nn, sd, _, _ in fm.base_frames(cfg):
        hits = [f for f in os.listdir(od) if f.startswith("f%02d_" % nn)] if os.path.isdir(od) else []
        if hits:
            out[nn] = (sd, os.path.join(od, hits[0]))
    return out


def _best(ref, frames):
    rm = _norm(_mask(ref))
    best = (-1.0, None, False)
    for nn, (_, p) in frames.items():
        a = np.asarray(Image.open(p).convert("RGBA"))[..., 3] > 127
        for mir in (False, True):
            m = _norm(a[:, ::-1] if mir else a)
            iou = (m & rm).sum() / max(1, (m | rm).sum())
            if iou > best[0]:
                best = (iou, nn, mir)
    return best


def _grey_vec(im, mask, n=48):
    """Mean-centred greyscale of the masked object, bbox-normalised to n x n (for mirror decisions)."""
    ys, xs = np.nonzero(mask)
    if len(xs) == 0:
        return np.zeros(n * n)
    g = ImageOps.grayscale(im.convert("RGB")).crop((xs.min(), ys.min(), xs.max() + 1, ys.max() + 1)).resize((n, n))
    m = Image.fromarray((mask[ys.min():ys.max() + 1, xs.min():xs.max() + 1] * 255).astype(np.uint8)).resize((n, n))
    v = np.asarray(g, float) * (np.asarray(m) > 127)
    v = v.ravel() - v.mean()
    return v / (np.linalg.norm(v) + 1e-9)


def _mirror_by_shading(ref, ours):
    """True when the mirrored frame correlates better with the reference's greyscale (glyphs, faces, lighting)."""
    rv = _grey_vec(ref, _mask(ref))
    a = np.asarray(ours.convert("RGBA"))[..., 3] > 127
    plain = float(rv @ _grey_vec(ours, a))
    mir = ImageOps.mirror(ours)
    flip = float(rv @ _grey_vec(mir, a[:, ::-1]))
    return flip > plain


def _ref_crop(im, pad=6):
    """Crop a reference to its object (+ pad px)."""
    ys, xs = np.nonzero(_mask(im))
    if len(xs) == 0:
        return im
    return im.crop((max(0, xs.min() - pad), max(0, ys.min() - pad), min(im.width, xs.max() + 1 + pad),
                    min(im.height, ys.max() + 1 + pad)))


def _tile(im, bg=(48, 48, 56), nearest=False):
    im = im.convert("RGBA")
    bb = im.getbbox()
    if bb and im.getchannel("A").getextrema()[0] < 250:
        im = im.crop(bb)
    k = (T - 8) / max(im.size)
    im = im.resize((max(1, round(im.width * k)), max(1, round(im.height * k))), Image.NEAREST if nearest else Image.LANCZOS)
    out = Image.new("RGBA", (T, T), bg + (255,))
    out.alpha_composite(im, ((T - im.width) // 2, (T - im.height) // 2))
    return out.convert("RGB")


def _grey(im):
    g = ImageOps.grayscale(im.convert("RGB")).convert("RGBA")
    g.putalpha(im.convert("RGBA").getchannel("A"))
    return g


def _zoom(im, z):
    """Crop `im` to the fractional box z of its opaque bounding box."""
    im = im.convert("RGBA")
    x0, y0, x1, y1 = im.getbbox() or (0, 0, im.width, im.height)
    w, h = x1 - x0, y1 - y0
    return im.crop((x0 + round(z[0] * w), y0 + round(z[1] * h), x0 + round(z[2] * w), y0 + round(z[3] * h)))


def family_sheet(family):
    frames = _frames(family)
    if not frames:
        print("ref_compare: %s has no published frames, skipped" % family)
        return None
    rows = []
    for label, src, nn, *extra in REFS[family]:
        zoom = extra[0] if extra else None
        force = extra[1] if len(extra) > 1 else None
        ref = load_ref(src)
        if src[0] == "card":
            ref = _ref_crop(ref)
        if nn is None:
            iou, nn, _ = _best(ref, frames)
            label += "  (best match f%02d, silhouette IoU %.2f)" % (nn, iou)
        else:
            label += "  (f%02d)" % nn
        sd, ours = frames[nn]
        sd_im, ours_im = Image.open(sd), Image.open(ours)
        mir = force if force is not None else (src[0] == "card" and _mirror_by_shading(ref, ours_im))
        if mir:
            sd_im, ours_im = ImageOps.mirror(sd_im), ImageOps.mirror(ours_im)
            label += " mirrored"
        if zoom:
            sd_im, ours_im = _zoom(sd_im, zoom), _zoom(ours_im, zoom)
            label += "  zoomed"
        rows.append((label, [_tile(ref), _tile(sd_im, nearest=True), _tile(ours_im), _tile(_grey(ours_im))]))
    heads = ("HD reference", "SD source", "3D (ours)", "3D greyscale")
    W = 4 * (T + 6) + 6
    out = Image.new("RGB", (W, 22 + len(rows) * (T + 24)), (20, 20, 24))
    d = ImageDraw.Draw(out)
    for j, h in enumerate(heads):
        d.text((6 + j * (T + 6) + 4, 5), h, fill=(255, 220, 0))
    for i, (label, tiles) in enumerate(rows):
        y = 22 + i * (T + 24)
        d.text((8, y + 4), label, fill=(230, 230, 230))
        for j, t in enumerate(tiles):
            out.paste(t, (6 + j * (T + 6), y + 20))
    vd = os.path.join(fm.FAM_DIR, family, "_verify")
    os.makedirs(vd, exist_ok=True)
    path = os.path.join(vd, "ref_compare.png")
    out.save(path)
    print("ref_compare: %s -> %s (%d refs)" % (family, os.path.relpath(path, ROOT), len(rows)))
    return path


def main(argv):
    fams = argv or list(REFS)
    for f in fams:
        if f not in REFS:
            print("ref_compare: no reference for %s" % f)
            continue
        family_sheet(f)


if __name__ == "__main__":
    main(sys.argv[1:])
