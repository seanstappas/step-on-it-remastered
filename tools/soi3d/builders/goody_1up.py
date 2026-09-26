"""soi3d.builders.goody_1up -- the extra-life '1UP' pickup (goody_sprites f17).

A raised SILVER bevelled frame (four proud border bars) around a recessed RED field carrying gold
Times-Bold '1UP'. Static prop. Colours sampled from source: silver border (~178 grey); red field
(156,0,0); gold text (173,140,0).
"""
import os

import bpy

from .. import common as C
from .. import register, register_frames

FONTS = {"times": C.DEFAULT_SIGN_FONT, "arial": r"C:\Windows\Fonts\arialbd.ttf",
         "arialblack": r"C:\Windows\Fonts\ariblk.ttf", "verdana": r"C:\Windows\Fonts\verdanab.ttf",
         "georgia": r"C:\Windows\Fonts\georgiab.ttf"}


def build_1up(opts=None):
    """A silver-framed red plaque with gold '1UP' (source f17)."""
    opts = opts or {}
    C._clear()
    silver = C._mat("up_silver", C._srgb(*opts.get("silver", (182, 182, 188))), rough=0.34, metal=0.0, spec=0.32, coat=0.25)
    red = C._mat("up_red", C._srgb(*opts.get("red", (156, 0, 0))), rough=0.6, spec=0.1, coat=0.0)
    rb = red.node_tree.nodes.get("Principled BSDF")
    ec = rb.inputs.get("Emission Color")
    es = rb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(58, 0, 0)
    if es is not None:
        es.default_value = 0.05
    gold = C._mat("up_gold", C._srgb(*opts.get("gold", (173, 140, 0))), rough=0.34, metal=0.0, spec=0.3, coat=0.3)

    # full bevelled SILVER plate = the frame; a proud RED panel in the centre leaves a silver border
    C._box("plate", (0, 0, 0.0), (1.84, 1.84, 0.34), silver, bevel=0.06, seg=3)
    fw = float(opts.get("field", 1.28))
    C._box("field", (0, 0, 0.11), (fw, fw, 0.14), red, bevel=0.03)

    # big gold '1UP' nearly filling the red field like the source (thick, little bare red left)
    fp = FONTS.get(str(opts.get("font", "times")), C.DEFAULT_SIGN_FONT)
    font = fp if os.path.exists(fp) else None
    glyph = C._text("1UP", z=0.20, mat=gold, extrude=float(opts.get("text_depth", 0.05)),
                    size=float(opts.get("text_size", 1.04)), font=font)
    glyph.name = "up_text"
    glyph.location.x, glyph.location.y = float(opts.get("text_x", 0.0)), float(opts.get("text_y", 0.0))
    glyph.scale = (float(opts.get("text_sx", 1.0)), float(opts.get("text_sy", 1.0)), 1.0)

    bpy.ops.object.light_add(type='POINT', location=(-2.7, 3.3, 2.8))
    gl = bpy.context.active_object
    gl.name = "up_glint"
    gl.data.energy = 300
    gl.data.shadow_soft_size = 0.5


@register("goody_1up")
def render(args):
    # goody_1up <out.png> [px]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_1up()
    C.setup_scene(px, world_strength=0.19, fill_energy=0.17)
    return out


def _frames_setup(opts):
    build_1up(opts)
    C.setup_scene(256, world_strength=0.19, fill_energy=0.17)
    C.apply_look(opts)
    return {}


register_frames("goody_1up", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
