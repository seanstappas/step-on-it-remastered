"""soi3d.builders.bolt -- the Walker's bolt (walker_sprites f50-f65, 20 x 19): a red capsule on an orbit.

Measured: a red capsule (~19.5 px long, ~5.5 px thick) whose centre circles the canvas centre about the
horizontal image axis (radius ~5.5 px: seen edge-on, it rises and falls) while the rod is tilted ~36 deg
toward the camera out of that orbit plane -- so it lies flat at the top (f50) and bottom (f58), leans
'\\' on the way down and '/' on the way up. 15 steps of 24 deg per turn; f65 repeats f50.
"""
import math

import bpy

from .. import common as C
from .. import register_frames

S = 0.1   # Blender units per SD pixel


def build_bolt(opts):
    C._clear()
    red = C._mat("red", C._srgb(*opts.get("red", (240, 0, 0))), rough=float(opts.get("rough", 0.35)),
                 spec=float(opts.get("spec", 0.3)))
    L, r = float(opts.get("length", 14.0)) * S, float(opts.get("radius", 2.75)) * S
    bpy.ops.object.empty_add(location=(0, 0, 0))
    persp = bpy.context.active_object
    persp.name = "persp"
    bpy.ops.object.empty_add(location=(0, 0, 0))
    axis = bpy.context.active_object
    axis.name = "axis"
    axis.parent = persp
    axis.rotation_euler = (0.0, math.radians(float(opts.get("axis_yaw", 0.0))), math.radians(float(opts.get("axis_roll", 0.0))))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    orbit = bpy.context.active_object
    orbit.name = "orbit"
    orbit.parent = axis
    bpy.ops.object.empty_add(location=(0, 0, 0))
    rod = bpy.context.active_object
    rod.name = "rod"
    rod.parent = orbit
    rod.location = (0.0, float(opts.get("orbit_r", 5.5)) * S, 0.0)
    rod.rotation_euler = (0.0, -math.radians(float(opts.get("tilt", 36.0))), 0.0)
    bpy.ops.mesh.primitive_cylinder_add(vertices=40, radius=r, depth=L, location=(0, 0, 0), rotation=(0, math.pi / 2, 0))
    parts = [bpy.context.active_object]
    for sx in (-1, 1):
        bpy.ops.mesh.primitive_uv_sphere_add(radius=r, segments=40, ring_count=20, location=(sx * L / 2, 0, 0))
        parts.append(bpy.context.active_object)
    for o in parts:
        o.data.materials.append(red)
        bpy.context.view_layer.objects.active = o
        o.select_set(True)
        bpy.ops.object.shade_smooth()
        o.parent = rod
    return orbit, persp


def _frames_setup(opts):
    orbit, persp = build_bolt(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"orbit": orbit, "persp": persp, "rho": float(opts.get("orbit_r", 5.5)),
            "dist": float(opts.get("persp_d", 0.0))}


def _frames_pose(ctx, pose):
    # pose {"phi": deg of the orbit about the horizontal axis (0 = the rod at the top)}; the source was a
    # PERSPECTIVE render (the rod is ~17% bigger on the near half of its orbit): with persp_d (camera
    # distance, SD px) the whole prop is scaled by d / (d - z) of the rod centre's depth z
    phi = math.radians(float(pose.get("phi", 0.0)))
    ctx["orbit"].rotation_euler = (phi, 0.0, 0.0)
    d = ctx["dist"]
    f = d / (d - ctx["rho"] * math.sin(phi)) if d > ctx["rho"] else 1.0
    ctx["persp"].scale = (f, f, f)


register_frames("bolt", _frames_setup, _frames_pose)
