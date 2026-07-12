"""soi3d.builders.block -- a rounded game TILE: raised frame + optional recessed colour centre / glyph.

The blue / green / '?' tiles are the SAME shape (raised frame + recessed centre), only the colours
differ; solid tiles (white, '?') are simple beveled cubes.
"""
import os

import bpy

from .. import common as C
from .. import register


def build_block(base=(205, 205, 205), center=None, symbol=None):
    """A rounded, beveled game TILE. `base` is the RAISED FRAME colour. When `center` is given a
    square WELL is carved out of the middle and a RECESSED colour panel sits on its floor -> the
    frame stands PROUD around a SUNKEN centre (matches the source: white/blue frame HIGH, coloured
    inner LOW). `symbol` (e.g. '?') is a big raised red glyph down in the well."""
    C._clear()
    bmat = C._mat("block", C._srgb(*base), rough=0.4, spec=0.25)
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
    tile = bpy.context.active_object
    tile.name = "block"
    tile.scale = (1.92, 1.92, 0.62)       # ~+/-0.96 wide, top surface ~ +0.31
    bev = tile.modifiers.new("bev", 'BEVEL')
    bev.width = 0.16
    bev.segments = 6                      # rounded/beveled outer edges catch the light
    tile.data.materials.append(bmat)
    if center is not None:
        inner = 0.60                      # half-size of the recessed well (tile half = 0.96)
        floor_z = 0.06                    # well floor height -> recess ~0.25 below the frame top
        # cutter box removes the top-centre, leaving a square well with its floor at floor_z
        bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, floor_z + 1.0))
        cut = bpy.context.active_object
        cut.name = "cutter"
        cut.scale = (2 * inner, 2 * inner, 2.0)   # tall; its BOTTOM sits exactly at floor_z
        bmod = tile.modifiers.new("cut", 'BOOLEAN')
        bmod.operation = 'DIFFERENCE'
        bmod.object = cut
        bpy.context.view_layer.objects.active = tile
        bpy.ops.object.modifier_apply(modifier="bev")
        bpy.ops.object.modifier_apply(modifier="cut")
        bpy.data.objects.remove(cut, do_unlink=True)
        # RECESSED colour panel resting on the well floor (top well below the raised frame)
        cmat = C._mat("center", C._srgb(*center), rough=0.5, spec=0.12)
        C._box("panel", (0, 0, floor_z - 0.03), (2 * inner - 0.03, 2 * inner - 0.03, 0.20),
               mat=cmat, bevel=0.01)
    if symbol:
        red = C._mat("sym", C._srgb(206, 12, 12), rough=0.55, spec=0.15)
        C._text(symbol, z=(0.15 if center is not None else 0.34), mat=red, extrude=0.05, size=1.5,
                font=C.DEFAULT_SIGN_FONT if os.path.exists(C.DEFAULT_SIGN_FONT) else None)


@register("block")
def render(args):
    # block <out.png> [px] [base_rgb] [center_rgb|-] [symbol|-]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    base = tuple(int(x) for x in args[2].split(",")) if len(args) > 2 else (198, 198, 198)
    center = tuple(int(x) for x in args[3].split(",")) if len(args) > 3 and args[3] != "-" else None
    sym = args[4] if len(args) > 4 and args[4] != "-" else None
    build_block(base, center, sym)
    C.setup_scene(px)
    return out
