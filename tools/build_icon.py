#!/usr/bin/env python3
"""Generate authentic Step On It! Remastered application icons.

Composes a 256x256 RGBA PNG (godot_project/icon.png) and a multi-resolution
Windows ICO (tools/launcher/app_icon.ico with 16, 32, 48, 64, 128, 256 px)
from the authentic Blue Player protagonist and beveled block art.
"""

from __future__ import annotations

import struct
from pathlib import Path
from typing import Iterable

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ICON_SIZES = [16, 32, 48, 64, 128, 256]
SUPERSAMPLE_SIZE = 512


def _first_existing(root: Path, candidates: Iterable[str]) -> tuple[Path, bool]:
    for rel in candidates:
        p = root / rel
        if p.is_file():
            is_sd = "/sprites/" in rel.replace("\\", "/")
            return p, is_sd
    raise FileNotFoundError(f"None of the candidate sprite paths exist: {list(candidates)}")


def _make_rounded_mask(size: int, margin: int, radius: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle(
        [margin, margin, size - margin - 1, size - margin - 1],
        radius=radius,
        fill=255,
    )
    return mask


def _make_gradient_bg(size: int) -> Image.Image:
    bg = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = bg.load()
    cx, cy = size * 0.5, size * 0.40
    max_d = size * 0.55
    for y in range(size):
        ty = y / max(1, size - 1)
        base_r = int(14 + ty * 14)
        base_g = int(22 + ty * 22)
        base_b = int(46 + ty * 44)
        for x in range(size):
            dx = x - cx
            dy = y - cy
            d = (dx * dx + dy * dy) ** 0.5
            glow = max(0.0, 1.0 - d / max_d) ** 2.0
            r = min(255, int(base_r + glow * 42))
            g = min(255, int(base_g + glow * 64))
            b = min(255, int(base_b + glow * 105))
            px[x, y] = (r, g, b, 255)
    return bg


def _load_trimmed_sprite(path: Path, is_sd: bool, target_height: int) -> Image.Image:
    img = Image.open(path).convert("RGBA")
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
    w, h = img.size
    scale = target_height / max(1, h)
    new_w = max(1, int(round(w * scale)))
    new_h = max(1, int(round(h * scale)))
    resample = Image.Resampling.NEAREST if is_sd else Image.Resampling.LANCZOS
    return img.resize((new_w, new_h), resample=resample)


def _compose_master_icon(root: Path) -> Image.Image:
    s = SUPERSAMPLE_SIZE
    margin = 18
    radius = 92

    hero_path, hero_sd = _first_existing(
        root,
        [
            "extracted/sprites_3d_frames/BP_sprites/f26_128x124.png",
            "extracted/sprites_hd/BP_sprites/f26_128x124.png",
            "extracted/sprites/BP_sprites/f26_32x31.png",
        ],
    )
    white_blk_path, white_sd = _first_existing(
        root,
        [
            "extracted/sprites_3d_frames/block_sprites/f08_128x128.png",
            "extracted/sprites_hd/block_sprites/f8_128x128.png",
            "extracted/sprites/block_sprites/f08_32x32.png",
        ],
    )
    red_blk_path, red_sd = _first_existing(
        root,
        [
            "extracted/sprites_3d_frames/block_sprites/f14_128x128.png",
            "extracted/sprites_hd/block_sprites/f14_128x128.png",
            "extracted/sprites/block_sprites/f14_32x32.png",
        ],
    )

    badge_mask = _make_rounded_mask(s, margin, radius)

    # Outer soft shadow behind badge
    canvas = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    shadow_alpha = badge_mask.filter(ImageFilter.GaussianBlur(radius=10))
    shadow_layer = Image.new("RGBA", (s, s), (0, 0, 0, 145))
    shadow_layer.putalpha(
        ImageChops.multiply(shadow_alpha, Image.new("L", (s, s), 160))
    )
    canvas.alpha_composite(shadow_layer, (0, 6))

    # Clipped inner badge composition
    badge = _make_gradient_bg(s)

    # Place a classic stepped row of blocks at the bottom of the badge
    block_size = 160
    white_blk = _load_trimmed_sprite(white_blk_path, white_sd, block_size)
    red_blk = _load_trimmed_sprite(red_blk_path, red_sd, block_size)

    block_y = s - margin - int(block_size * 0.80)
    center_x = s // 2
    # Three blocks across the bottom: red on left, white in center, red on right
    gap = 4
    badge.alpha_composite(red_blk, (center_x - block_size // 2 - block_size - gap, block_y + 18))
    badge.alpha_composite(white_blk, (center_x - block_size // 2, block_y))
    badge.alpha_composite(red_blk, (center_x + block_size // 2 + gap, block_y + 18))

    # Protagonist stepping onto the center white block
    hero = _load_trimmed_sprite(hero_path, hero_sd, target_height=316)
    hero_x = (s - hero.width) // 2 + 4
    hero_y = block_y - hero.height + 24

    # Grounded contact shadow on top of the center white block
    contact_shadow = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    cs_draw = ImageDraw.Draw(contact_shadow)
    cs_draw.ellipse(
        [center_x - 74, block_y - 6, center_x + 74, block_y + 24],
        fill=(0, 0, 0, 115),
    )
    contact_shadow = contact_shadow.filter(ImageFilter.GaussianBlur(radius=7))
    badge.alpha_composite(contact_shadow)

    # Soft drop shadow behind protagonist for readability at small icon sizes
    hero_alpha = hero.getchannel("A")
    hero_shadow = Image.new("RGBA", hero.size, (0, 0, 0, 140))
    hero_shadow.putalpha(
        ImageChops.multiply(hero_alpha, Image.new("L", hero.size, 150))
    )
    hero_shadow = hero_shadow.filter(ImageFilter.GaussianBlur(radius=6))
    badge.alpha_composite(hero_shadow, (hero_x + 4, hero_y + 8))
    badge.alpha_composite(hero, (hero_x, hero_y))

    # Crisp inner border highlight
    border_layer = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(border_layer)
    b_draw.rounded_rectangle(
        [margin + 2, margin + 2, s - margin - 3, s - margin - 3],
        radius=radius - 2,
        outline=(120, 165, 240, 155),
        width=5,
    )
    badge.alpha_composite(border_layer)

    # Mask badge to rounded rectangle and composite over outer drop shadow
    badge_masked = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    badge_masked.paste(badge, (0, 0), badge_mask)
    canvas.alpha_composite(badge_masked)
    return canvas


def _save_multi_size_ico(master: Image.Image, out_ico: Path, sizes: list[int]) -> None:
    # Build individual resized RGBA frames from the 512x512 master so every
    # resolution (including 16x16 and 32x32) gets a crisp direct LANCZOS pass.
    resized = [
        master.resize((sz, sz), Image.Resampling.LANCZOS) for sz in sizes
    ]
    resized[-1].save(
        out_ico,
        format="ICO",
        sizes=[(sz, sz) for sz in sizes],
        append_images=resized[:-1],
    )


def _verify_ico_sizes(ico_path: Path, expected_sizes: list[int]) -> list[int]:
    data = ico_path.read_bytes()
    reserved, img_type, count = struct.unpack_from("<HHH", data, 0)
    if reserved != 0 or img_type != 1:
        raise ValueError(f"Invalid ICO header in {ico_path}")
    found: list[int] = []
    for i in range(count):
        w, h, *_ = struct.unpack_from("<BBBBHHII", data, 6 + i * 16)
        found.append(256 if w == 0 else w)
        if w != h:
            raise ValueError(f"Non-square ICO entry {w}x{h}")
    if sorted(found) != sorted(expected_sizes):
        raise ValueError(f"ICO sizes mismatch: got {found}, expected {expected_sizes}")
    return found


def main() -> None:
    root = Path(__file__).resolve().parent.parent
    png_out = root / "godot_project" / "icon.png"
    ico_out = root / "tools" / "launcher" / "app_icon.ico"

    master = _compose_master_icon(root)
    icon_256 = master.resize((256, 256), Image.Resampling.LANCZOS)
    png_out.parent.mkdir(parents=True, exist_ok=True)
    icon_256.save(png_out, format="PNG")

    ico_out.parent.mkdir(parents=True, exist_ok=True)
    _save_multi_size_ico(master, ico_out, ICON_SIZES)
    found_sizes = _verify_ico_sizes(ico_out, ICON_SIZES)

    print(f"Wrote {png_out} ({icon_256.size[0]}x{icon_256.size[1]} {icon_256.mode})")
    print(f"Wrote {ico_out} (sizes={found_sizes}, {ico_out.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
