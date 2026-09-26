"""soi3d.builders.gargoyle -- the Gargoyle (Gargoyle_sprites f02-f74): a stone bat-winged creature facing the camera.

In SD pixel units of the 84x75 cell (origin = between the feet, +y up, +z toward the camera): two thin LEGS with
white claws, an egg-shaped BODY, a round HEAD with long horizontal pointed EARS and dark eye sockets, and two
bat WINGS (a leading-edge spar out to the tip and a scalloped membrane) hinged at the shoulders. All stone grey.
The red striped EGG it carries on its head is egg.py's cushion (opts "egg" = master_egg's options).
Pose: "spread" (deg, both wings about the view axis: -90 = hanging down, 0 = level, + = raised), "wrap" (deg,
wings folded forward around the body: 0 = flat), "crouch" (px the upper body sits lower, the legs shortened),
"egg" (egg scale, 0 = none), "egg_y" (px the egg sits below its place above the head: it rises out of the
chest over f42-f48), "scroll" (the egg's band scroll, px).
The whole model is scaled by `model_scale` and moved by `model_dy` px to fit the sweep camera.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .egg import build as egg_build
from .quadruped import S, _ell
from .robo import _cyl, _empty
from .tile import _prism

# relative to the shoulder (5, 50); from f30's per-row half-widths: level top edge at y 52 out to 37.5 px, the
# lower edge tapering back to the body at y 28 (the membrane fills solid to the body)
WING = [(0, 3), (32.5, 3), (32.5, 0), (31.5, -2), (30.5, -4), (29.5, -6), (28, -8), (26.5, -10), (24, -12), (19, -14),
        (17, -16), (15, -18), (13.5, -20), (12, -22), (0, -22)]
EAR = [(-2, -3.5), (4, -3.5), (12, -2), (17, 0.5), (14, 2.5), (5, 5), (-2, 5.5)]   # CCW, y up; f30 rows 11-20 to +-22 px


def _wing_mat(opts, rgb, span):
    """Stone whose albedo ramps from `wing_root_gain` at the shoulder to `wing_tip_gain` at the tip (|object x|)."""
    f = lambda k, d: float(opts.get(k, d))
    mat = bpy.data.materials.new("wing_stone")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = f("rough", 0.6)
    tc, sep = nt.nodes.new("ShaderNodeTexCoord"), nt.nodes.new("ShaderNodeSeparateXYZ")
    ab, mr = nt.nodes.new("ShaderNodeMath"), nt.nodes.new("ShaderNodeMapRange")
    ab.operation = 'ABSOLUTE'
    mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = 0.0, span
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    for el, g in zip(ramp.color_ramp.elements, (f("wing_root_gain", 1.3), f("wing_tip_gain", 0.85))):
        el.color = C._srgb(*(max(0, min(255, int(round(v * g)))) for v in rgb))
    nt.links.new(tc.outputs["Object"], sep.inputs[0])
    nt.links.new(sep.outputs["X"], ab.inputs[0])
    nt.links.new(ab.outputs[0], mr.inputs["Value"])
    nt.links.new(mr.outputs["Result"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], bsdf.inputs["Base Color"])
    return mat


def build(opts):
    f = lambda k, d: float(opts.get(k, d))
    egg, scroll = egg_build(dict(opts.get("egg", {})))                  # clears the scene; the egg comes first
    stone = C._mat("stone", C._srgb(*opts.get("stone", (150, 150, 155))), rough=f("rough", 0.6), spec=f("spec", 0.2))
    gain = lambda k: tuple(max(0, min(255, int(round(v * f(k, 1.0))))) for v in opts.get("stone", (150, 150, 155)))
    body_m = C._mat("body_stone", C._srgb(*gain("body_gain")), rough=f("rough", 0.6), spec=f("spec", 0.2))
    wing_m = _wing_mat(opts, gain("wing_gain"), 32.5 * f("wing_f", 1.0) * S)
    dark = C._mat("socket", C._srgb(*opts.get("socket", (20, 20, 22))), rough=0.9, spec=0.0)
    claw = C._mat("claw", C._srgb(*opts.get("claw", (235, 235, 235))), rough=0.4, spec=0.3)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    upper = _empty("upper", (0, 0, 0), root)                           # everything above the hips (crouch moves it)
    legs = []
    hip_y = f("hip_y", 22.0)
    for sx in (-1.0, 1.0):
        hp = _empty("hip", (sx * f("leg_x", 4.0), hip_y, 0), root)
        _cyl("leg", (0, -hip_y / 2, 0), f("leg_r", 2.0), hip_y, stone, 0.4, hp)
        _rbox("claw", (0, -hip_y + 1.2, 1.0), (f("leg_r", 2.0) * 1.3, 1.2, 2.0), 0.5, claw).parent = hp
        legs.append(hp)
    by = f("body_y", 37.0)                                            # up to the shoulders: f30 has no gap between the wings
    _ell("body", (0, by, 0), (f("body_rx", 8.0), f("body_ry", 14.0), f("body_rz", 5.0)), body_m, 32).parent = upper
    hy, hr = f("head_y", 57.0), f("head_r", 5.5)
    _ell("head", (0, hy, 0), (hr, hr * 0.95, hr * 0.9), stone, 32).parent = upper
    for sx in (-1.0, 1.0):
        _ell("socket", (sx * hr * 0.4, hy + 0.5, hr * 0.75), (1.2, 1.0, 0.6), dark, 12).parent = upper
        ear = _prism("ear", [(x * S, y * S) for x, y in (EAR if sx > 0 else [(-x, y) for x, y in EAR][::-1])], -0.8 * S, 1.6 * S, stone, 0.3 * S)
        ear.parent = upper
        ear.location = (sx * hr * 0.8 * S, (hy + f("ear_dy", 0.0)) * S, 0)
        ear.rotation_euler = (0, 0, sx * math.radians(f("ear_up", 0.0)))
    wings = []
    for sx in (-1.0, 1.0):
        sh = _empty("shoulder", (sx * f("shoulder_x", 5.0), f("shoulder_y", 50.0), -1.0), upper)
        sh.rotation_mode = 'ZXY'                                     # spread in the view plane first, then wrap
        pts = [(x * f("wing_f", 1.0), y * f("wing_fy", 1.0)) for x, y in WING]
        pts = pts[::-1] if sx > 0 else [(-x, y) for x, y in pts]        # counter-clockwise on either side
        w = _prism("wing", [(x * S, y * S) for x, y in pts], -0.4 * S, 0.8 * S, wing_m, 0.2 * S)
        w.parent = sh
        wings.append((sh, sx))
    egg.parent = upper
    k = f("egg_scale", 0.6)
    egg.location = (0, (hy + hr + f("egg_dy", 5.0)) * S, 0)
    egg.scale = (k, k, k)
    m = f("model_scale", 0.5)
    root.scale = (m, m, m)
    root.location = (0, f("model_dy", -37.0) * S * m, 0)
    return root, upper, legs, wings, egg, scroll


def _frames_setup(opts):
    root, upper, legs, wings, egg, scroll = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"upper": upper, "legs": legs, "wings": wings, "egg": egg, "scroll": scroll, "hip_y": f("hip_y", 22.0),
            "egg_k": f("egg_scale", 0.6), "egg_y0": egg.location.y}


def _frames_pose(ctx, pose):
    g = lambda k, d=0.0: float(pose.get(k, d))
    c = g("crouch")
    ctx["upper"].location = (0, -c * S, 0)
    for hp in ctx["legs"]:
        hp.location.y = (ctx["hip_y"] - c) * S
        hp.scale = (1.0, max(0.05, (ctx["hip_y"] - c) / ctx["hip_y"]), 1.0)
    for sh, sx in ctx["wings"]:
        sh.rotation_euler = (0.0, -sx * math.radians(g("wrap")), sx * math.radians(g("spread")))
    e = g("egg")
    ctx["egg"].hide_render = e <= 0.02
    ctx["egg"].scale = (ctx["egg_k"] * max(e, 0.02),) * 3
    ctx["egg"].location.y = ctx["egg_y0"] - g("egg_y") * S
    ctx["scroll"].outputs[0].default_value = g("scroll")


register_frames("gargoyle", _frames_setup, _frames_pose)
