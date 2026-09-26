"""soi3d.builders.arrow -- the player's straight ARROW shot (weapons f11 heading right, f10 = its mirror).

Measured on the 24x9 SD frame (f11, pixel units, y down): a grey round SHAFT (3 px thick, rows 3-5,
x 2..16: top/middle/bottom rows 132/198/82 grey = a lit cylinder) ending in a flat red triangular HEAD
(base x 16 rows 1..8, tip x 24 at mid-height) and two flat red FLETCHES, 45-deg parallelograms 3 px
tall above and below the tail (x 0..8); the shaft's shadow darkens the lower fletch's top row.
f10 is the exact horizontal mirror = the arrow turned about the vertical axis ("heading" 180).
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames

S = 0.1   # Blender units per SD pixel


def _px(x, y):
    return ((x - 12.0) * S, (4.5 - y) * S)


def _plate(name, pts, z, thick, mat):
    """An extruded flat polygon (SD pixel coords, y down) centred at depth z."""
    vs = [(*_px(x, y), z + thick * 0.5) for x, y in pts] + [(*_px(x, y), z - thick * 0.5) for x, y in pts]
    n = len(pts)
    faces = [tuple(range(n)), tuple(range(2 * n - 1, n - 1, -1))]
    faces += [(i, (i + 1) % n, n + (i + 1) % n, n + i) for i in range(n)]
    me = bpy.data.meshes.new(name)
    me.from_pydata(vs, [], faces)
    me.update()
    ob = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(ob)
    ob.data.materials.append(mat)
    return ob


def build_arrow(heading=0.0, red_rgb=(198, 0, 0), shaft_rgb=(190, 190, 190), shaft_r=1.5, head_th=0.8,
                fletch_th=0.6, rough=0.5, spec=0.3):
    C._clear()
    red = C._mat("arrow_red", C._srgb(*red_rgb), rough=rough, spec=spec)
    grey = C._mat("arrow_shaft", C._srgb(*shaft_rgb), rough=rough, spec=spec)
    parts = []
    bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=shaft_r * S, depth=15.0 * S,
                                        location=(*_px(9.5, 4.5), 0.0), rotation=(0.0, math.pi / 2, 0.0))
    shaft = bpy.context.active_object
    shaft.name = "shaft"
    shaft.data.materials.append(grey)
    bpy.ops.object.shade_smooth()
    parts.append(shaft)
    parts.append(_plate("head", [(16, 1), (24, 4.5), (16, 8)], 0.0, head_th * S, red))
    parts.append(_plate("fletch_up", [(0, 0), (5, 0), (8, 3), (3, 3)], 0.0, fletch_th * S, red))
    parts.append(_plate("fletch_dn", [(3, 6), (8, 6), (5, 9), (0, 9)], 0.0, fletch_th * S, red))
    bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for obj in parts:
        obj.parent = pivot
    pivot.rotation_euler = (0.0, math.radians(float(heading)), 0.0)
    return pivot


def _frames_setup(opts):
    pivot = build_arrow(heading=float(opts.get("heading", 0.0)),
                        red_rgb=tuple(opts.get("red", (198, 0, 0))),
                        shaft_rgb=tuple(opts.get("shaft", (190, 190, 190))),
                        shaft_r=float(opts.get("shaft_r", 1.5)), head_th=float(opts.get("head_th", 0.8)),
                        fletch_th=float(opts.get("fletch_th", 0.6)), rough=float(opts.get("rough", 0.5)),
                        spec=float(opts.get("spec", 0.3)))
    C.setup_scene(256, world_strength=0.08, fill_energy=0.10)
    C.apply_look(opts)
    return {"pivot": pivot, "heading": float(opts.get("heading", 0.0))}


def _frames_pose(ctx, pose):
    # pose {"spin": deg}: roll of the arrow about its own shaft (0 = fletches up/down, flat to camera)
    ctx["pivot"].rotation_mode = 'YXZ'
    ctx["pivot"].rotation_euler = (math.radians(float(pose.get("spin", 0.0))), math.radians(ctx["heading"]), 0.0)


@register("arrow")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_arrow(heading=float(args[2]) if len(args) > 2 else 0.0)
    C.setup_scene(px, world_strength=0.08, fill_energy=0.10)
    return out


register_frames("arrow", _frames_setup, _frames_pose)