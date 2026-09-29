"""soi3d.builders.cannon_barrel -- the gray Cannon enemy body (cannon_sprites f02-f03)."""

import bpy

from .. import common as C
from .. import register, register_frames


def build_cannon_barrel(opts=None):
    opts = opts or {}
    f = lambda k, d: float(opts.get(k, d))
    C._clear()
    light = C._mat("cannon_light", C._srgb(*opts.get("housing_rgb", (198, 198, 198))), rough=0.72, spec=0.04)
    mid = C._mat("cannon_mid", C._srgb(*opts.get("barrel_rgb", (115, 115, 115))), rough=0.78, spec=0.03)
    dark = C._mat("cannon_dark", C._srgb(40, 40, 40), rough=0.85, spec=0.02)
    parts = []
    if opts.get("barrel", False):     # the source: a barrel lying in a square housing, its muzzle collar out of one side
        s = f("face", 1.0)            # +1 = muzzle right (f02); the pose's "face" -1 mirrors it (f03). 0.1 unit = 1 px
        r, xa, xb, z = f("barrel_r", 0.8), f("breech_x", -0.55), f("collar_x", 0.8), f("barrel_z", 0.2)
        bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=r, depth=xb - xa, location=(s * (xa + xb) / 2, 0.0, z),
                                            rotation=(0.0, 1.5708, 0.0))
        parts.append(bpy.context.active_object)
        bpy.ops.mesh.primitive_uv_sphere_add(segments=48, ring_count=24, radius=r, location=(s * xa, 0.0, z))
        parts.append(bpy.context.active_object)              # the rounded breech
        for name, x0, x1, rr in (("collar", xb, xb + f("collar_l", 0.4), f("collar_r", 1.1)),
                                 ("muzzle", xb + f("collar_l", 0.4), 1.6, f("muzzle_r", 0.9))):
            bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=rr, depth=x1 - x0, location=(s * (x0 + x1) / 2, 0.0, z),
                                                rotation=(0.0, 1.5708, 0.0))
            parts.append(bpy.context.active_object)
        for o in parts:
            o.data.materials.append(mid)
            bpy.ops.object.select_all(action='DESELECT')
            o.select_set(True)
            bpy.context.view_layer.objects.active = o
            bpy.ops.object.shade_smooth()
        by = f("bottom_y", -1.1)                                 # C._box takes FULL extents
        parts.append(C._box("end_wall", (-s * 1.48, 0.15, 0.0), (0.24, 2.5, 0.4), light, bevel=0.05, seg=2))
        parts.append(C._box("backplate", (0.0, 0.15, -0.3), (3.2, 2.9, 0.3), light, bevel=f("plate_bevel", 0.05), seg=3))
        parts.append(C._box("upper_flange", (0.0, f("top_y", 1.4), 0.0), (3.2, 0.4, 0.4), light, bevel=0.05, seg=3))
        parts.append(C._box("lower_flange", (0.0, by, 0.0), (3.2, 0.4, 0.4), light, bevel=0.05, seg=3))
        parts.append(C._box("dark_foot", (0.0, by - 0.35, -0.1), (2.6, 0.3, 0.32), dark, bevel=0.05, seg=2))
        bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
        pivot = bpy.context.active_object
        pivot.name = "pivot"
        for obj in parts:
            obj.parent = pivot
            obj.matrix_parent_inverse.identity()
        return pivot
    bpy.ops.mesh.primitive_uv_sphere_add(segments=64, ring_count=32, location=(0.0, 0.0, 0.06))
    middle = bpy.context.active_object
    middle.name = "rounded_body"
    middle.scale = (0.86, 0.52, 0.34)
    middle.data.materials.append(mid)
    bpy.ops.object.shade_smooth()
    parts.append(middle)
    upper = C._box("upper_flange", (0.0, 0.52, 0.10), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    base = C._box("lower_flange", (0.0, -0.52, 0.00), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    foot = C._box("dark_foot", (0.0, -0.72, -0.10), (1.20, 0.20, 0.16), dark, bevel=0.05, seg=2)
    bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for obj in parts + [upper, base, foot]:
        obj.parent = pivot
        obj.matrix_parent_inverse.identity()
    return pivot


def _frames_setup(opts):
    pivot = build_cannon_barrel(opts)
    C.setup_scene(256, world_strength=0.08, fill_energy=0.10)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    ctx["pivot"].rotation_euler[2] = 0.0
    ctx["pivot"].scale[0] = float(pose.get("face", 1.0))      # -1 mirrors the barrel: muzzle left (f03)


@register("cannon_barrel")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_cannon_barrel()
    C.setup_scene(px, world_strength=0.08, fill_energy=0.10)
    return out


register_frames("cannon_barrel", _frames_setup, _frames_pose)