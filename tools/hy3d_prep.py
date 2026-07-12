"""Prepare a tiny game sprite as a clean image-to-3D input for Hunyuan3D.

Steps: crop to the alpha bounding box, bleed opaque edge colour into the
transparent region (kills white/dark halos on resize), upscale the subject with a
mild smooth filter, then centre it on a square transparent canvas. The alpha
channel is preserved so Hunyuan uses it as the foreground mask (no rembg needed).

Usage:  py tools/hy3d_prep.py <in.png> <out.png> [canvas=768] [fill=0.82]
"""
import sys
import numpy as np
from PIL import Image


def alpha_bleed(arr: np.ndarray, iters: int = 32) -> np.ndarray:
    arr = arr.copy()
    rgb = arr[:, :, :3].astype(np.float32)
    filled = arr[:, :, 3] > 0
    for _ in range(iters):
        if filled.all():
            break
        acc = np.zeros_like(rgb)
        cnt = np.zeros(arr.shape[:2], np.float32)
        for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            acc += np.roll(np.where(filled[..., None], rgb, 0.0), (dy, dx), (0, 1))
            cnt += np.roll(filled.astype(np.float32), (dy, dx), (0, 1))
        newpx = (~filled) & (cnt > 0)
        rgb[newpx] = acc[newpx] / cnt[newpx, None]
        filled |= newpx
    arr[:, :, :3] = rgb.round().astype(np.uint8)
    return arr


def crop_to_alpha(arr: np.ndarray, pad: int = 1) -> np.ndarray:
    ys, xs = np.where(arr[:, :, 3] > 0)
    if len(ys) == 0:
        return arr
    y0, y1 = max(0, ys.min() - pad), min(arr.shape[0], ys.max() + 1 + pad)
    x0, x1 = max(0, xs.min() - pad), min(arr.shape[1], xs.max() + 1 + pad)
    return arr[y0:y1, x0:x1]


def prep(in_path: str, out_path: str, canvas: int = 768, fill: float = 0.82) -> None:
    src = np.asarray(Image.open(in_path).convert("RGBA"))
    src = crop_to_alpha(src)
    src = alpha_bleed(src)
    h, w = src.shape[:2]
    # target longest side, then a crisp NEAREST pre-magnify followed by a mild
    # LANCZOS pass -> keeps the pixel-art shape but softens the stair-steps a touch.
    target = int(canvas * fill)
    scale = max(1, target // max(h, w))
    big = Image.fromarray(src).resize((w * scale, h * scale), Image.NEAREST)
    longest = max(big.size)
    ratio = target / longest
    big = big.resize((max(1, round(big.width * ratio)), max(1, round(big.height * ratio))),
                     Image.LANCZOS)
    out = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
    out.alpha_composite(big, ((canvas - big.width) // 2, (canvas - big.height) // 2))
    out.save(out_path)
    print(f"prepped {in_path} -> {out_path}  ({big.width}x{big.height} on {canvas})")


if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) < 2:
        print(__doc__)
        sys.exit(1)
    prep(a[0], a[1], int(a[2]) if len(a) > 2 else 768,
         float(a[3]) if len(a) > 3 else 0.82)
