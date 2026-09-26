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


def build_potion(opts=None):
    """Green glass flask with a peppermint swirl (source f18)."""
    opts = opts or {}
    C._clear()
    # green glass: glossy sheen but keeps a true green albedo; faint dark-green shadow emission.
    # Modest coat/spec so the silhouette edge stays SATURATED green (not a blown-out grey rim).
    glass = C._mat("pot_glass", C._srgb(*opts.get("glass", (0, 140, 0))), rough=0.36, metal=0.0, spec=0.22, coat=0.22)
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
    body.scale = (float(opts.get("body_sx", 1.00)), float(opts.get("body_sy", 0.86)), 0.96)
    body.data.materials.append(glass)
    bpy.ops.object.shade_smooth()

    # neck: a vertical flaring frustum (wide at the shoulders, narrower at the mouth); axis along +Y
    bpy.ops.mesh.primitive_cone_add(vertices=40, radius1=float(opts.get("neck_r", 0.42)),
                                    radius2=float(opts.get("neck_r", 0.42)) * 0.57, depth=0.46,
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
    build_potion_px(opts)
    C.setup_scene(256, world_strength=0.18, fill_energy=0.16)
    C.apply_look(opts)
    return {}


S = 0.1   # Blender units per SD pixel (the 32 x 32 f18 frame, flask axis at x = 16)


def _px(x, y):
    return ((x - 16.0) * S, (16.0 - y) * S)


def _decal_glass(opts):
    """Green glass whose front carries a painted red/white PEPPERMINT swirl decal (a shader on the body's
    local coordinates: centre (dx, dy), radius r, `arms` arms winding by `wind` over the radius)."""
    glass = C._mat("pot_glass", C._srgb(*opts.get("glass", (0, 140, 0))), rough=float(opts.get("rough", 0.36)),
                   spec=float(opts.get("spec", 0.22)), coat=float(opts.get("coat", 0.0)))
    nt = glass.node_tree
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
    x = op('SUBTRACT', sep.outputs[0], float(opts.get("sw_x", -0.17)))
    y = op('SUBTRACT', sep.outputs[1], float(opts.get("sw_y", 0.37)))
    rad = float(opts.get("sw_r", 0.58))
    rho = op('DIVIDE', op('SQRT', op('ADD', op('MULTIPLY', x, x), op('MULTIPLY', y, y))), rad)
    theta = op('ARCTAN2', y, x)
    wave = op('COSINE', op('MULTIPLY', op('ADD', theta, op('MULTIPLY', rho, float(opts.get("wind", 3.0)))),
                           float(opts.get("arms", 3))))
    arm = N.new("ShaderNodeMapRange")
    arm.clamp = True
    L.new(wave, arm.inputs["Value"])
    arm.inputs["From Min"].default_value, arm.inputs["From Max"].default_value = -0.1, 0.1
    inside = op('MULTIPLY', op('LESS_THAN', rho, 1.0), op('GREATER_THAN', sep.outputs[2], 0.0))
    sw = N.new("ShaderNodeMix")
    sw.data_type = 'RGBA'
    L.new(arm.outputs["Result"], sw.inputs["Factor"])
    sw.inputs["A"].default_value = C._srgb(*opts.get("white", (238, 236, 230)))
    sw.inputs["B"].default_value = C._srgb(*opts.get("red", (200, 0, 0)))
    mix = N.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    L.new(inside, mix.inputs["Factor"])
    mix.inputs["A"].default_value = C._srgb(*opts.get("glass", (0, 140, 0)))
    L.new(sw.outputs["Result"], mix.inputs["B"])
    L.new(mix.outputs["Result"], N.get("Principled BSDF").inputs["Base Color"])
    return glass


def build_potion_px(opts):
    """The flask measured on f18 (SD px, y down): a round BODY rows 10-30 (x 4-27, centre (16, 20.3)), a
    straight NECK ~7 px wide (x 13-19, rows 5-9) and a wider green LIP at the mouth (x 11-20, rows 1-4,
    dark underside); a red/white peppermint swirl decal on the upper-left front of the body (rows 12-21)."""
    C._clear()
    glass = _decal_glass(opts)
    plain = C._mat("pot_green", C._srgb(*opts.get("glass", (0, 140, 0))), rough=float(opts.get("rough", 0.36)),
                   spec=float(opts.get("spec", 0.22)), coat=float(opts.get("coat", 0.0)))
    cy = float(opts.get("body_cy", 20.3))
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48, location=(*_px(16, cy), 0))
    body = bpy.context.active_object
    body.name = "pot_body"
    body.scale = (float(opts.get("body_rx", 12.0)) * S, float(opts.get("body_ry", 10.3)) * S,
                  float(opts.get("body_rz", 10.0)) * S)
    body.data.materials.append(glass)
    bpy.ops.object.shade_smooth()
    nr = float(opts.get("neck_r", 3.3)) * S
    top, bot = float(opts.get("neck_top", 4.5)), cy - 5.0
    bpy.ops.mesh.primitive_cylinder_add(vertices=40, radius=nr, depth=(bot - top) * S,
                                        location=(*_px(16, (top + bot) / 2), 0), rotation=(math.pi / 2, 0, 0))
    neck = bpy.context.active_object
    neck.data.materials.append(plain)
    bpy.ops.object.shade_smooth()
    lr = nr + max(0.5, float(opts.get("lip_extra", 1.7))) * S      # the lip always overhangs the neck
    l0, l1 = float(opts.get("lip_top", 1.0)), float(opts.get("lip_bot", 4.6))
    bpy.ops.mesh.primitive_cylinder_add(vertices=40, radius=lr, depth=(l1 - l0) * S,
                                        location=(*_px(16, (l0 + l1) / 2), 0), rotation=(math.pi / 2, 0, 0))
    lip = bpy.context.active_object
    bv = lip.modifiers.new("bev", 'BEVEL')
    bv.width = float(opts.get("lip_bevel", 1.0)) * S
    bv.segments = 3
    lip.data.materials.append(plain)
    bpy.ops.object.shade_smooth()


register_frames("goody_potion", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
