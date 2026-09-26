"""soi3d.builders.goody_goldbar -- the stacked GOLD BARS treasure pickup (goody_sprites f26).

A low, wide pile of shiny gold INGOTS (3 on the bottom, 2 nestled on top) rotated to a 3/4 view so the
tops and front ends both catch light -> the classic gold-bar treasure read. Colours sampled from source:
gold base (173,140,0), highlight (210,174,0), dark (107,57,0). Static prop.
"""
import math

import bpy
from mathutils import Euler, Vector

from .. import common as C
from .. import register, register_frames


def build_goldbar(opts=None):
    """A 3-2 pyramid of gold ingots, group-rotated to a 3/4 treasure view (source f26)."""
    opts = opts or {}
    C._clear()
    # semi-metallic gold: warm albedo + strong spec so facet edges flash like the source highlights.
    # Lower metalness => diffuse (directional) shading dominates => strong top-left->bottom-right relief.
    gold = C._mat("gb_gold", C._srgb(*opts.get("gold", (184, 149, 12))), rough=0.34,
                  metal=float(opts.get("metal", 0.45)), spec=0.55, coat=0.08)
    gd = gold.node_tree.nodes.get("Principled BSDF")
    ec = gd.inputs.get("Emission Color"); es = gd.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(70, 45, 0)     # keeps deep grooves from crushing to black
    if es is not None:
        es.default_value = 0.05

    size = (0.70, float(opts.get("bar_h", 0.28)), float(opts.get("bar_len", 1.16)))   # ingot: WIDE, LONG in Z
    # 3-2 pyramid across X; bars OVERLAP so the mass is SOLID (no background gaps -> better silhouette).
    bars = [
        ("gb_b0", (-0.60, -0.25, 0.0)),
        ("gb_b1", (0.00, -0.25, 0.0)),
        ("gb_b2", (0.60, -0.25, 0.0)),
        ("gb_t0", (-0.31, 0.03, 0.0)),
        ("gb_t1", (0.31, 0.03, 0.0)),
    ]
    grot = Euler((math.radians(float(opts.get("tilt", 14))), math.radians(float(opts.get("turn", -17))), 0.0), 'XYZ')
    for name, (x, y, z) in bars:
        p = Vector((x, y, z)); p.rotate(grot)
        b = C._box(name, (p.x, p.y, p.z), size, gold, bevel=0.04, seg=2)
        b.rotation_euler = grot

    # warm key glint on the upper-left bar tops (strong => deep TL->BR relief like the source)
    bpy.ops.object.light_add(type='POINT', location=(-3.0, 3.4, 3.2))
    gl = bpy.context.active_object
    gl.name = "gb_glint"
    gl.data.energy = float(opts.get("glint_energy", 520))
    gl.data.shadow_soft_size = 0.4


@register("goody_goldbar")
def render(args):
    # goody_goldbar <out.png> [px]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_goldbar()
    C.setup_scene(px, world_strength=0.15, fill_energy=0.10)
    return out


def _frames_setup(opts):
    build_goldbar(opts)
    C.setup_scene(256, world_strength=0.15, fill_energy=0.10)
    C.apply_look(opts)
    return {}


register_frames("goody_goldbar", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
