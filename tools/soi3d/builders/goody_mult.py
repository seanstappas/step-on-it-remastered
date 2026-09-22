"""soi3d.builders.goody_mult -- the score MULTIPLIER pickup (goody_sprites f13-f16: 2x/3x/4x/5x).

A MOTTLED green ball (two-tone procedural noise, like the speckled source orb) carrying raised red
Times-Bold '<n>x' lettering. Static prop; one still per multiplier. Colours sampled from source: green
sphere mottles between dark (0,16,0) and mid (0,120,0); red text (189,0,0).
"""
import bpy

from .. import common as C
from .. import register, register_frames


def _mottle_green(name):
    """A matte green ball material whose base colour is a NOISE-driven blend of a dark and a mid green,
    reproducing the speckled orb in the source (no glossy wash)."""
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    nt = m.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = 0.62
    si = bsdf.inputs.get("Specular IOR Level")
    if si is not None:
        si.default_value = 0.05
    tex = nt.nodes.new("ShaderNodeTexNoise")
    tex.inputs["Scale"].default_value = 9.0
    tex.inputs["Detail"].default_value = 4.0
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.elements[0].position = 0.35
    ramp.color_ramp.elements[0].color = C._srgb(0, 46, 0)     # dark green speckle
    ramp.color_ramp.elements[1].position = 0.70
    ramp.color_ramp.elements[1].color = C._srgb(0, 128, 0)    # mid green body
    nt.links.new(tex.outputs["Fac"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], bsdf.inputs["Base Color"])
    # faint dark-green emission so the shadowed lower-right stays green, not black
    ec = bsdf.inputs.get("Emission Color")
    es = bsdf.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(0, 44, 0)
    if es is not None:
        es.default_value = 0.05
    return m


def build_mult(n=2):
    """Green mottled ball with a raised red Times-Bold '<n>x' (source f13-f16)."""
    import os
    C._clear()
    green = _mottle_green("mult_green")
    red = C._mat("mult_red", C._srgb(182, 0, 0), rough=0.52, spec=0.06, coat=0.0)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "mult_ball"
    ball.data.materials.append(green)
    bpy.ops.object.shade_smooth()

    # BIG bold Times '<n>x' filling the orb like the source; z out at the sphere front so it sits proud
    font = C.DEFAULT_SIGN_FONT if os.path.exists(C.DEFAULT_SIGN_FONT) else None
    glyph = C._text("%dx" % n, z=0.98, mat=red, extrude=0.07, size=2.15, font=font)
    glyph.name = "mult_text"

    bpy.ops.object.light_add(type='POINT', location=(-2.7, 3.3, 2.6))
    gl = bpy.context.active_object
    gl.name = "mult_glint"
    gl.data.energy = 380
    gl.data.shadow_soft_size = 0.42


@register("goody_mult")
def render(args):
    # goody_mult <out.png> [px] [n]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    n = int(args[2]) if len(args) > 2 else 2
    build_mult(n=n)
    C.setup_scene(px, world_strength=0.18, fill_energy=0.16)
    return out


def _frames_setup(opts):
    build_mult(n=int(opts.get("n", 2)))             # per-frame option: f13 2x .. f16 5x
    C.setup_scene(256, world_strength=0.18, fill_energy=0.16)
    C.apply_look(opts)
    return {}


register_frames("goody_mult", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
