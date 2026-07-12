"""soi3d.builders.spiral -- a glossy ball carrying the red/white peppermint swirl (the 'weapons' spiral).

The texture is projected front-on via OBJECT coordinates, so rotating the ball about Z spins the
spiral in place (the in-game animation).
"""
import math

import bpy

from .. import common as C
from .. import register


def build_spiral(tex_path, spin=0.0):
    """A glossy BALL carrying a red/white spiral texture. The texture is projected front-on via
    OBJECT coordinates, so rotating the ball about Z spins the spiral in place."""
    C._clear()
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "spiral"
    bpy.ops.object.shade_smooth()
    mat = bpy.data.materials.new("spiralmat")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = 0.22
    si = bsdf.inputs.get("Specular IOR Level")
    if si is not None:
        si.default_value = 0.5
    img = bpy.data.images.load(tex_path)
    tex = nt.nodes.new("ShaderNodeTexImage")
    tex.image = img
    tex.extension = 'EXTEND'
    coord = nt.nodes.new("ShaderNodeTexCoord")
    mp = nt.nodes.new("ShaderNodeMapping")
    mp.inputs["Location"].default_value = (0.5, 0.5, 0.0)   # object [-1,1] -> uv [0,1]
    mp.inputs["Scale"].default_value = (0.5, 0.5, 0.5)
    nt.links.new(coord.outputs["Object"], mp.inputs["Vector"])
    nt.links.new(mp.outputs["Vector"], tex.inputs["Vector"])
    nt.links.new(tex.outputs["Color"], bsdf.inputs["Base Color"])
    ball.data.materials.append(mat)
    ball.rotation_euler = (0, 0, math.radians(spin))


@register("spiral")
def render(args):
    # spiral <out.png> <tex.png> [px] [spin]
    out = args[0]
    tex = args[1]
    px = int(args[2]) if len(args) > 2 else 256
    sp = float(args[3]) if len(args) > 3 else 0.0
    build_spiral(tex, sp)
    C.setup_scene(px)
    return out
