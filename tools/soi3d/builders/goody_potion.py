"""soi3d.builders.goody_potion -- the green POTION / elixir flask pickup (goody_sprites f18).

A bulbous GREEN glass bottle (round body + short neck + cork) with a red-and-white PEPPERMINT swirl
disc on the front. Static prop. Colours sampled from source: green glass (0,41,0)..(0,181,0), body
mid (0,140,0); swirl red (200,0,0) on white; cork dark.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _swirl(z, r0=0.05, r1=0.32, turns=2.6, n=80):
    """A red Archimedean-spiral tube on a white disc -> the peppermint candy swirl on the bottle."""
    white = C._mat("pot_white", C._srgb(238, 236, 230), rough=0.5, spec=0.2, coat=0.15)
    red = C._mat("pot_red", C._srgb(200, 0, 0), rough=0.5, spec=0.2, coat=0.15)
    # white backing disc (flattened cylinder facing the camera)
    bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=r1 + 0.05, depth=0.05, location=(0, 0, z))
    disc = bpy.context.active_object
    disc.name = "swirl_disc"
    disc.data.materials.append(white)
    bpy.ops.object.shade_smooth()
    # red spiral curve
    crv = bpy.data.curves.new("swirl", 'CURVE')
    crv.dimensions = '3D'
    sp = crv.splines.new('POLY')
    sp.points.add(n - 1)
    for i in range(n):
        t = i / (n - 1)
        ang = t * turns * 2 * math.pi
        r = r0 + t * (r1 - r0)
        sp.points[i].co = (r * math.cos(ang), r * math.sin(ang), 0.0, 1.0)
    crv.bevel_depth = 0.045
    crv.bevel_resolution = 3
    obj = bpy.data.objects.new("swirl_red", crv)
    bpy.context.collection.objects.link(obj)
    obj.location = (0, 0, z + 0.05)
    obj.data.materials.append(red)
    return disc, obj


def build_potion():
    """Green glass flask with a peppermint swirl (source f18)."""
    C._clear()
    # green glass: glossy sheen but keeps a true green albedo; faint dark-green shadow emission.
    # Modest coat/spec so the silhouette edge stays SATURATED green (not a blown-out grey rim).
    glass = C._mat("pot_glass", C._srgb(0, 140, 0), rough=0.36, metal=0.0, spec=0.22, coat=0.22)
    gb = glass.node_tree.nodes.get("Principled BSDF")
    ec = gb.inputs.get("Emission Color")
    es = gb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(0, 48, 0)
    if es is not None:
        es.default_value = 0.06
    cork = C._mat("pot_cork", C._srgb(120, 78, 40), rough=0.8, spec=0.1)

    # bulbous body: WIDE + squat (source f18 is a flattened pumpkin-shaped flask, wider than tall)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.9, segments=96, ring_count=48, location=(0, -0.08, 0))
    body = bpy.context.active_object
    body.name = "pot_body"
    body.scale = (1.00, 0.86, 0.96)
    body.data.materials.append(glass)
    bpy.ops.object.shade_smooth()

    # neck: a vertical flaring frustum (wide at the shoulders, narrower at the mouth); axis along +Y
    bpy.ops.mesh.primitive_cone_add(vertices=40, radius1=0.42, radius2=0.24, depth=0.46,
                                    location=(0, 0.84, 0), rotation=(-math.pi / 2, 0, 0))
    neck = bpy.context.active_object
    neck.name = "pot_neck"
    neck.data.materials.append(glass)
    bpy.ops.object.shade_smooth()

    # cork/cap: a short WIDE lip cylinder sitting flat on the mouth (axis along +Y => flat cap)
    bpy.ops.mesh.primitive_cylinder_add(vertices=32, radius=0.28, depth=0.19,
                                        location=(0, 1.12, 0), rotation=(math.pi / 2, 0, 0))
    cap = bpy.context.active_object
    cap.name = "pot_cap"
    cb = cap.modifiers.new("bev", 'BEVEL'); cb.width = 0.04; cb.segments = 2
    cap.data.materials.append(cork)
    bpy.ops.object.shade_smooth()

    # peppermint swirl on the lower-front of the body (just proud of the curved surface)
    _swirl(z=0.86)

    bpy.ops.object.light_add(type='POINT', location=(-2.6, 3.2, 2.8))
    gl = bpy.context.active_object
    gl.name = "pot_glint"
    gl.data.energy = 360
    gl.data.shadow_soft_size = 0.4


@register("goody_potion")
def render(args):
    # goody_potion <out.png> [px]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_potion()
    C.setup_scene(px, world_strength=0.18, fill_energy=0.16)
    return out


def _frames_setup(opts):
    build_potion()
    C.setup_scene(256, world_strength=0.18, fill_energy=0.16)
    C.apply_look(opts)
    return {}


register_frames("goody_potion", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
