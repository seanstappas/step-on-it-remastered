"""soi3d.builders.cluster -- the Gargoyle's plain puff (master_s_objects f32-f46): a tumbling cluster of
green balls around a small red core. `layout` picks the ball arrangement (0 octahedron = 6 balls,
1 cube = 8, 2 tetrahedron = 4, 3 icosahedron = 12).

Measured (frames interface): an OCTAHEDRON of six green balls (radius ~3.75 SD px at ~9.5 px from the
centre) round a red core, pre-tilted 45 deg about X so the vertical axis is one of its 2-fold (edge)
axes, spinning about that vertical axis: f32 (spin 0) shows a '+' with the core visible (the two
short arms are front/back ball pairs), f40 (~90 deg) an 'X' of four balls plus one in front; the
15 frames are one 180 deg period (12 deg/frame). The side balls of f32 are clipped by the canvas.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames

_PHI = (1 + 5 ** 0.5) / 2
LAYOUTS = {
    0: [(1, 0, 0), (-1, 0, 0), (0, 1, 0), (0, -1, 0), (0, 0, 1), (0, 0, -1)],
    1: [(x, y, z) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)],
    2: [(1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1)],
    3: [(0, s1, s2 * _PHI) for s1 in (-1, 1) for s2 in (-1, 1)] +
       [(s1, s2 * _PHI, 0) for s1 in (-1, 1) for s2 in (-1, 1)] +
       [(s2 * _PHI, 0, s1) for s1 in (-1, 1) for s2 in (-1, 1)],
}


def build_cluster(opts, layout=0):
    C._clear()
    green = C._mat("green", C._srgb(*opts.get("green", (0, 170, 0))), rough=float(opts.get("rough", 0.35)),
                   spec=float(opts.get("spec", 0.35)), coat=float(opts.get("coat", 0.2)))
    red = C._mat("red", C._srgb(*opts.get("red", (220, 0, 0))), rough=float(opts.get("rough", 0.4)),
                 spec=float(opts.get("spec", 0.3)))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    pivot.parent = root
    pts = LAYOUTS[int(layout)]
    norm = max(math.sqrt(x * x + y * y + z * z) for x, y, z in pts)
    dist = float(opts.get("spread", 0.62))
    br = float(opts.get("ball_r", 0.36))
    objs = []
    for i, (x, y, z) in enumerate(pts):
        bpy.ops.mesh.primitive_uv_sphere_add(radius=br, segments=32, ring_count=16,
                                             location=(x / norm * dist, y / norm * dist, z / norm * dist))
        b = bpy.context.active_object
        b.data.materials.append(green)
        bpy.ops.object.shade_smooth()
        objs.append(b)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=float(opts.get("core_r", 0.3)), segments=32, ring_count=16)
    core = bpy.context.active_object
    core.data.materials.append(red)
    bpy.ops.object.shade_smooth()
    objs.append(core)
    for o in objs:
        o.parent = pivot
        o.matrix_parent_inverse.identity()
    root.rotation_euler = (math.radians(float(opts.get("tilt", 0.0))), 0.0, 0.0)
    return pivot


def _setup(ctx, layout):
    ctx["pivot"] = build_cluster(ctx["opts"], layout)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(ctx["opts"])
    ctx["layout"] = layout


def _frames_setup(opts):
    ctx = {"opts": opts}
    _setup(ctx, int(opts.get("layout", 0)))
    return ctx


def _frames_pose(ctx, pose):
    # pose {"spin": deg about the vertical axis}; opts "pre_tilt" = the body's fixed tilt about X first
    # (45 = an octahedron edge axis vertical), "tilt" = the camera elevation (root)
    rebuilt = False
    lay = int(round(float(pose.get("layout", ctx["layout"]))))
    if lay != ctx["layout"]:
        _setup(ctx, lay)
        rebuilt = True
    ctx["pivot"].rotation_mode = 'XYZ'
    ctx["pivot"].rotation_euler = (math.radians(float(pose.get("pre_tilt", ctx["opts"].get("pre_tilt", 0.0)))),
                                   math.radians(float(pose.get("spin", 0.0))),
                                   math.radians(float(pose.get("roll", 0.0))))
    return rebuilt


@register("cluster")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_cluster({}, int(args[2]) if len(args) > 2 else 0)
    C.setup_scene(px, world_strength=0.1, fill_energy=0.1)
    return out


register_frames("cluster", _frames_setup, _frames_pose)
