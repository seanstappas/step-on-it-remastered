"""soi3d.builders.spiral -- the player's rolling SWIRL shot (weapons f02-f09): a peppermint ball.

A shaded sphere painted with FOUR red and four white spiral arms of equal width (a peppermint
candy), seen face-on and turning about the view axis: the 8 source frames are one symmetry period
(90 deg, 11.25 deg per frame, clockwise on screen). The arm centre angle, measured on the SD frames
(4-fold phase per 1 px ring, de-rotated and averaged over all 8 frames), follows
    alpha(psi) = -(a + b * psi^2)       psi = polar angle of the surface point from the view axis
with a = -19.2 deg, b = 82 deg/rad^2 (fits every ring to ~3 deg): the arms wind tighter towards the
rim, partly the sphere's own foreshortening. The pattern is a shader on Object coordinates, so it
stays attached to the ball as it spins.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _swirl_mat(red_rgb, white_rgb, arms, a_deg, b_deg, edge, rough, spec):
    m = C._mat("swirl", C._srgb(*white_rgb), rough=rough, spec=spec)
    nt = m.node_tree
    N, L = nt.nodes, nt.links

    def op(kind, a, b=None, c=None):
        n = N.new("ShaderNodeMath")
        n.operation = kind
        for i, v in enumerate((a, b, c)):
            if v is None:
                continue
            if isinstance(v, (int, float)):
                n.inputs[i].default_value = float(v)
            else:
                L.new(v, n.inputs[i])
        return n.outputs[0]

    tc = N.new("ShaderNodeTexCoord")
    sep = N.new("ShaderNodeSeparateXYZ")
    L.new(tc.outputs["Object"], sep.inputs[0])
    x, y, z = sep.outputs[0], sep.outputs[1], sep.outputs[2]
    theta = op('ARCTAN2', y, x)
    zc = op('MINIMUM', op('MAXIMUM', z, -1.0), 1.0)
    psi = op('ARCCOSINE', zc)
    phase = op('MULTIPLY_ADD', op('MULTIPLY', psi, psi), math.radians(b_deg), math.radians(a_deg))
    wave = op('COSINE', op('MULTIPLY', op('ADD', theta, phase), float(arms)))
    mr = N.new("ShaderNodeMapRange")
    mr.clamp = True
    L.new(wave, mr.inputs["Value"])
    mr.inputs["From Min"].default_value = -edge
    mr.inputs["From Max"].default_value = edge
    mix = N.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    L.new(mr.outputs["Result"], mix.inputs["Factor"])
    mix.inputs["A"].default_value = C._srgb(*white_rgb)
    mix.inputs["B"].default_value = C._srgb(*red_rgb)
    L.new(mix.outputs["Result"], N.get("Principled BSDF").inputs["Base Color"])
    return m


def build_spiral(red_rgb=(210, 0, 0), white_rgb=(235, 235, 235), arms=4, a_deg=-19.2, b_deg=82.0,
                 edge=0.08, rough=0.45, spec=0.3):
    C._clear()
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "spiral"
    ball.data.materials.append(_swirl_mat(red_rgb, white_rgb, arms, a_deg, b_deg, edge, rough, spec))
    bpy.ops.object.shade_smooth()
    return ball


@register("spiral")
def render(args):
    # spiral <out.png> [px] [spin]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    ball = build_spiral()
    ball.rotation_euler = (0, 0, math.radians(float(args[2]) if len(args) > 2 else 0.0))
    C.setup_scene(px)
    return out


def _frames_setup(opts):
    build_spiral(red_rgb=tuple(opts.get("red", (210, 0, 0))),
                 white_rgb=tuple(opts.get("white", (235, 235, 235))),
                 arms=int(opts.get("arms", 4)), a_deg=float(opts.get("a", -19.2)),
                 b_deg=float(opts.get("b", 82.0)), edge=float(opts.get("edge", 0.08)),
                 rough=float(opts.get("rough", 0.45)), spec=float(opts.get("spec", 0.3)))
    C.setup_scene(256, world_strength=0.08, fill_energy=0.10)
    C.apply_look(opts)
    return {"ball": bpy.data.objects["spiral"]}


def _frames_pose(ctx, pose):
    # pose {"spin": deg}: the swirl turns in place about the view axis
    ctx["ball"].rotation_euler = (0.0, 0.0, math.radians(float(pose.get("spin", 0.0))))


register_frames("spiral", _frames_setup, _frames_pose)
