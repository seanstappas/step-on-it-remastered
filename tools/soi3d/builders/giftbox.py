"""soi3d.builders.giftbox -- the Knight's gift in flight (master_s_objects f17-f31, 24x18): a red CUBE with a
blue '?' on each side face, spinning about the vertical axis (face-on it is ~18 px wide, corner-on ~24).
The '?' is a THICK RAISED glyph (~3 px proud of an 18 px face): face-on (f17) the two side faces' glyphs
stick out beyond the cube's outline as blue strips (x 0-2 and 21-23, rows 2-14, transparent above and
below) and the front glyph casts a shadow on its face. 15 frames = one 90 deg face period.
"""
import math
import os

import bpy

from .. import common as C
from .. import register, register_frames

FONTS = {"times": C.DEFAULT_SIGN_FONT, "arial": r"C:\Windows\Fonts\arialbd.ttf",
         "arialblack": r"C:\Windows\Fonts\ariblk.ttf", "verdana": r"C:\Windows\Fonts\verdanab.ttf"}


def build_giftbox(opts=None):
    opts = opts or {}
    C._clear()
    red = C._mat("red", C._srgb(*opts.get("red", (200, 0, 0))), rough=float(opts.get("rough", 0.45)),
                 spec=float(opts.get("spec", 0.2)))
    blue = C._mat("blue", C._srgb(*opts.get("blue", (0, 0, 210))), rough=float(opts.get("rough", 0.45)),
                  spec=float(opts.get("spec", 0.2)))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    h = 0.7
    box = C._box("box", (0, 0, 0), (2 * h, 2 * h, 2 * h), red, bevel=float(opts.get("bevel", 0.06)))
    parts = [box]
    fp = FONTS.get(str(opts.get("font", "times")), C.DEFAULT_SIGN_FONT)
    font = fp if os.path.exists(fp) else None
    size = float(opts.get("q_size", 1.2))
    depth = float(opts.get("q_depth", 0.2))              # how far the glyph stands proud of the face
    for k in range(4):                                  # a '?' on each vertical face
        a = k * math.pi / 2
        t = C._text("?", z=0.0, mat=blue, extrude=depth / 2 + 0.01, size=size, font=font)
        t.data.bevel_depth = float(opts.get("q_bevel", 0.015))
        t.data.bevel_resolution = 2
        t.rotation_euler = (0.0, a, 0.0)
        t.location = (math.sin(a) * (h + depth / 2 - 0.01), float(opts.get("q_y", 0.0)),
                      math.cos(a) * (h + depth / 2 - 0.01))
        parts.append(t)
    for o in parts:
        o.parent = pivot
        o.matrix_parent_inverse.identity()
    return pivot


def _frames_setup(opts):
    pivot = build_giftbox(opts)
    C.setup_scene(256)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    # pose {"spin": deg about the vertical axis, "tilt_x": lean toward the camera}
    ctx["pivot"].rotation_mode = 'ZYX'
    ctx["pivot"].rotation_euler = (math.radians(float(pose.get("tilt_x", 0.0))),
                                   math.radians(float(pose.get("spin", 0.0))), 0.0)


@register("giftbox")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_giftbox()
    C.setup_scene(px)
    return out


register_frames("giftbox", _frames_setup, _frames_pose)
