"""soi3d.builders.cannon_barrel -- the gray Cannon enemy body (cannon_sprites f02-f03)."""

import bpy

from .. import common as C
from .. import register, register_frames


def build_cannon_barrel():
    C._clear()
    light = C._mat("cannon_light", C._srgb(198, 198, 198), rough=0.72, spec=0.04)
    mid = C._mat("cannon_mid", C._srgb(115, 115, 115), rough=0.78, spec=0.03)
    dark = C._mat("cannon_dark", C._srgb(40, 40, 40), rough=0.85, spec=0.02)
    bpy.ops.mesh.primitive_uv_sphere_add(segments=64, ring_count=32, location=(0.0, 0.0, 0.06))
    middle = bpy.context.active_object
    middle.name = "rounded_body"
    middle.scale = (0.86, 0.52, 0.34)
    middle.data.materials.append(mid)
    bpy.ops.object.shade_smooth()
    upper = C._box("upper_flange", (0.0, 0.52, 0.10), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    base = C._box("lower_flange", (0.0, -0.52, 0.00), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    foot = C._box("dark_foot", (0.0, -0.72, -0.10), (1.20, 0.20, 0.16), dark, bevel=0.05, seg=2)
    bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for obj in (upper, middle, base, foot):
        obj.parent = pivot
        obj.matrix_parent_inverse.identity()
    return pivot


def _frames_setup(opts):
    pivot = build_cannon_barrel()
    C.setup_scene(256, world_strength=0.08, fill_energy=0.10)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    ctx["pivot"].rotation_euler[2] = 0.0


@register("cannon_barrel")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_cannon_barrel()
    C.setup_scene(px, world_strength=0.08, fill_energy=0.10)
    return out


register_frames("cannon_barrel", _frames_setup, _frames_pose)