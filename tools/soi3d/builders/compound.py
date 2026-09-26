"""soi3d.builders.compound -- the Gargoyle's pierce puff (master_s_objects f02-f16): a cube/octahedron
dual COMPOUND -- a red octahedron whose six points pierce the face centres of a blue cube, the cube's
corners poking out between the red faces. It spins about the vertical axis; the compound maps onto
itself every 90 deg (the source's 15-frame cycle). Flat-shaded facets under the top-left key.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _poly(name, verts, faces, mat):
    me = bpy.data.meshes.new(name)
    me.from_pydata(verts, [], faces)
    me.update()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    obj.data.materials.append(mat)
    return obj


def build_compound(opts=None):
    opts = opts or {}
    C._clear()
    red = C._mat("red", C._srgb(*opts.get("red", (230, 0, 0))), rough=float(opts.get("rough", 0.45)),
                 spec=float(opts.get("spec", 0.2)))
    blue = C._mat("blue", C._srgb(*opts.get("blue", (0, 0, 200))), rough=float(opts.get("rough", 0.45)),
                  spec=float(opts.get("spec", 0.2)))
    R = 1.0
    c = R * float(opts.get("cube", 0.5))
    oct_v = [(R, 0, 0), (-R, 0, 0), (0, R, 0), (0, -R, 0), (0, 0, R), (0, 0, -R)]
    oct_f = [(0, 2, 4), (4, 2, 1), (1, 2, 5), (5, 2, 0), (0, 4, 3), (4, 1, 3), (1, 5, 3), (5, 0, 3)]
    cube_v = [(x, y, z) for x in (-c, c) for y in (-c, c) for z in (-c, c)]
    cube_f = [(0, 1, 3, 2), (4, 6, 7, 5), (0, 4, 5, 1), (2, 3, 7, 6), (0, 2, 6, 4), (1, 5, 7, 3)]
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for o in (_poly("oct", oct_v, oct_f, red), _poly("cube", cube_v, cube_f, blue)):
        o.parent = pivot
        o.matrix_parent_inverse.identity()
    return pivot


def _frames_setup(opts):
    pivot = build_compound(opts)
    C.setup_scene(256, world_strength=0.07, fill_energy=0.09)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    # pose {"spin": deg about the vertical axis, "tilt_x": lean of that axis toward the camera}
    ctx["pivot"].rotation_mode = 'ZYX'
    ctx["pivot"].rotation_euler = (math.radians(float(pose.get("tilt_x", 0.0))),
                                   math.radians(float(pose.get("spin", 0.0))), 0.0)


@register("compound")
def render(args):
    # compound <out.png> [px] [spin]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    pivot = build_compound()
    pivot.rotation_euler = (0.0, math.radians(float(args[2]) if len(args) > 2 else 0.0), 0.0)
    C.setup_scene(px, world_strength=0.07, fill_energy=0.09)
    return out


register_frames("compound", _frames_setup, _frames_pose)
