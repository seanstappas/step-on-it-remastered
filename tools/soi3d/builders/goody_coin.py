"""soi3d.builders.goody_coin -- the silver / gold '$' pickup coin (goody_sprites f11 silver, f24 gold).

A short METALLIC CYLINDER (flat faces toward the camera) with a raised outer RIM ring and an embossed
Times-Bold '$' on the face. In the remaster it is SPUN about the vertical (Y / screen-up) axis -- the
classic collectible-coin flip (face -> thin edge -> back) -- so it is modelled SYMMETRIC and the body /
rim / glyph are parented to a pivot rotated about Y. Matte metal + a strong top-left key + a post glint
(apply_glint.py) give an in-hue sheen without a white wash (per the process doc's material rules).
"""
import math
import os

import bpy

from .. import common as C
from .. import register, register_frames


def _rim_ring(name, r_out, r_minor, z, mat, seg=48, ring=12):
    """A raised torus rim hugging the front face -> the coin's proud border ring."""
    bpy.ops.mesh.primitive_torus_add(major_radius=r_out - r_minor, minor_radius=r_minor,
                                     major_segments=seg, minor_segments=ring,
                                     location=(0, 0, z))
    obj = bpy.context.active_object
    obj.name = name
    obj.rotation_euler = (0, 0, 0)     # torus lies in XY -> ring faces the camera
    obj.scale = (1, 1, 0.5)            # flatten so it sits low on the face, not a fat donut
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def build_coin(color=(183, 150, 0), spin=0.0, kind="gold"):
    """A `kind` ('gold'|'silver') coin, `color` = its base metal RGB (0..255). `spin` = degrees about
    the vertical Y axis for the flip animation (0 = face-on)."""
    C._clear()
    # Semi-matte metal token: dielectric base (no black metallic wash under the dim world) + a light
    # clearcoat for a controlled sheen. A faint in-hue emission keeps the shadowed half dark-METAL,
    # not black (same trick as the disk's dark-green shadow).
    metal = C._mat("coin", C._srgb(*color), rough=0.34, metal=0.0, spec=0.25, coat=0.35)
    mb = metal.node_tree.nodes.get("Principled BSDF")
    ec = mb.inputs.get("Emission Color")
    es = mb.inputs.get("Emission Strength")
    shadow = tuple(int(c * 0.45) for c in color)
    if ec is not None:
        ec.default_value = C._srgb(*shadow)
    if es is not None:
        es.default_value = 0.05
    # a slightly DARKER engraved-face metal for the '$' and rim so they read as relief
    face_dark = C._mat("coin_dk", C._srgb(*tuple(int(c * 0.72) for c in color)),
                       rough=0.42, metal=0.0, spec=0.15, coat=0.2)

    pivot = None
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"

    # coin BODY: a short cylinder, flat circular faces toward +-Z (camera looks down -Z).
    bpy.ops.mesh.primitive_cylinder_add(vertices=96, radius=0.9, depth=0.17, location=(0, 0, 0))
    body = bpy.context.active_object
    body.name = "coin_body"
    bev = body.modifiers.new("bev", 'BEVEL')
    bev.width = 0.05
    bev.segments = 4                      # rounded reeded-looking rim edge
    body.data.materials.append(metal)
    bpy.ops.object.shade_smooth()

    # raised outer RIM ring on the FRONT face (z = +half depth)
    rim = _rim_ring("coin_rim", r_out=0.86, r_minor=0.07, z=0.085, mat=face_dark)

    # embossed Times-Bold '$' on the front face
    font = C.DEFAULT_SIGN_FONT if os.path.exists(C.DEFAULT_SIGN_FONT) else None
    glyph = C._text("$", z=0.085, mat=face_dark, extrude=0.05, size=1.15, font=font)

    for o in (body, rim, glyph):
        o.parent = pivot
        o.matrix_parent_inverse.identity()
    pivot.rotation_euler = (0, math.radians(spin), 0)

    # a soft top-left CATCH light for a real highlight under the composited glint
    bpy.ops.object.light_add(type='POINT', location=(-2.6, 3.2, 3.0))
    gl = bpy.context.active_object
    gl.name = "coin_glint"
    gl.data.energy = 380
    gl.data.shadow_soft_size = 0.4


@register("goody_coin")
def render(args):
    # goody_coin <out.png> [px] [kind=gold|silver] [spin_y]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    kind = args[2] if len(args) > 2 else "gold"
    spin = float(args[3]) if len(args) > 3 else 0.0
    color = (172, 172, 172) if kind == "silver" else (185, 150, 0)
    build_coin(color=color, spin=spin, kind=kind)
    C.setup_scene(px, world_strength=0.17, fill_energy=0.18)
    return out


def _frames_setup(opts):
    kind = opts.get("kind", "gold")
    color = tuple(opts.get("color", (172, 172, 172) if kind == "silver" else (185, 150, 0)))
    build_coin(color=color, kind=kind)
    C.setup_scene(256, world_strength=0.17, fill_energy=0.18)
    C.apply_look(opts)
    return {"pivot": bpy.data.objects["pivot"]}


def _frames_pose(ctx, pose):
    # the coin is STATIC in the game (fixed goody frame); "spin" (deg about Y) exists for fitting only
    ctx["pivot"].rotation_euler = (0.0, math.radians(float(pose.get("spin", 0.0))), 0.0)


register_frames("goody_coin", _frames_setup, _frames_pose)
