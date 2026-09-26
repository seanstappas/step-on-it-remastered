"""soi3d.builders.knight -- the Knight (knight_sprites f02-f66): a grey armoured knight facing the camera.

In SD pixel units of the 60x80 cell (origin = the skirt's lower edge, row 57 of the standing f02; +y up, +z toward
the camera at yaw 0), measured from f02's per-row extents: crest y 40-42, helmet y 31.5-40.5 (11 px wide), the
shoulder line y 31 with pauldrons to +-13 px, arms hanging at +-10 px to the gauntlets' lower edge at y 4 (24 px
below the shoulder), the skirt y -1..7 and legs to the sabatons at y -22.
A rounded cylinder HELMET with a dark visor slit and a small crest, two PAULDRONS (flattened balls) on a wide
BREASTPLATE, a flared SKIRT (tassets), two ARMS (upper arm, elbow cop, forearm, gauntlet) hanging from the
pauldrons, two LEGS (thigh, knee cop, shin, sabaton) and a SWORD in the right (near-x) gauntlet: blade, cross
guard and grip. All steel grey (`steel`), the sword brighter (`blade`).
Pose (deg unless noted): "yaw" (0 = facing the camera), "s_r"/"s_l" shoulder raise forward (+ = up in front),
"a_r"/"a_l" shoulder spread sideways (+ = out), "e_r"/"e_l" elbow bend, "sw" sword angle in the hand about the
hand's side axis (0 = the blade continues the forearm), "stance" (the right leg swung forward and the left back
by that angle), "l_r"/"l_l" extra per-leg swing (+ = forward), "glow" radius (px) of the gold/red gift orb held
in front of the chest (f51-f65; 0 = none). The whole model is scaled by `model_scale` and moved by `model_dy` px
so the knight with a raised sword fits the sweep camera.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S, _ell
from .robo import _cyl, _empty


def _orb_mat(opts):
    """A dithered gold/red emissive orb (the gift's glow): a fine noise picks gold or red per cell."""
    mat = bpy.data.materials.new("orb")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    noise = nt.nodes.new("ShaderNodeTexNoise")
    noise.inputs["Scale"].default_value = float(opts.get("orb_scale", 60.0))
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = 'CONSTANT'
    ramp.color_ramp.elements[0].color = C._srgb(*opts.get("orb_red", (220, 30, 20)))
    ramp.color_ramp.elements[1].position = 0.5
    ramp.color_ramp.elements[1].color = C._srgb(*opts.get("orb_gold", (250, 210, 40)))
    nt.links.new(noise.outputs["Fac"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], bsdf.inputs["Base Color"])
    if bsdf.inputs.get("Emission Color") is not None:
        nt.links.new(ramp.outputs["Color"], bsdf.inputs["Emission Color"])
        bsdf.inputs["Emission Strength"].default_value = float(opts.get("orb_emit", 0.6))
    return mat


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    steel = C._mat("steel", C._srgb(*opts.get("steel", (190, 190, 195))), rough=f("rough", 0.35), spec=f("spec", 0.5),
                   metal=f("metal", 0.0))
    dark = C._mat("slit", C._srgb(*opts.get("slit", (25, 25, 28))), rough=0.8, spec=0.1)
    blade = C._mat("blade", C._srgb(*opts.get("blade", (235, 235, 240))), rough=0.25, spec=0.7)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    tz = f("torso_hz", 6.0)
    _rbox("skirt", (0, f("skirt_y", 3.0), 0), (f("skirt_hw", 13.0), f("skirt_hh", 4.0), tz * 0.9), f("skirt_bevel", 2.0), steel).parent = root
    ty, thh = f("torso_y", 19.0), f("torso_hh", 12.0)
    _rbox("torso", (0, ty, 0), (f("torso_hw", 9.0), thh, tz), f("torso_bevel", 3.0), steel).parent = root
    hy, hr, hh = f("helmet_y", 36.0), f("helmet_r", 5.5), f("helmet_h", 9.0)
    _cyl("helmet", (0, hy, 0), hr, hh, steel, f("helmet_bevel", 2.5), root)
    _rbox("slit", (0, hy + f("slit_dy", 0.5), hr - 0.3), (hr * 0.75, f("slit_h", 0.7), 0.5), 0.2, dark).parent = root
    _rbox("crest", (0, hy + hh / 2 + f("crest_h", 2.0) / 2, 0), (f("crest_w", 1.2), f("crest_h", 2.0), hr * 0.8), 0.5, steel).parent = root
    arms = {}
    ua, fa, ar = f("uarm_l", 11.0), f("farm_l", 10.0), f("arm_r", 2.0)
    for side, sx in (("r", -1.0), ("l", 1.0)):                        # the knight's right arm is on screen left
        sh = _empty("shoulder_" + side, (sx * f("shoulder_x", 10.0), f("shoulder_y", 28.0), 0), root)
        sh.rotation_mode = 'YXZ'
        pr = f("pauldron_r", 3.8)                                       # f02: flat plates centred 2.5 px inside the arms
        _ell("pauldron_" + side, (-sx * f("pauldron_in", 2.5), 0.8, 0), (pr * 1.2, pr * 0.65, pr * 1.05), steel, 24).parent = sh
        _cyl("uarm_" + side, (0, -ua / 2, 0), ar, ua, steel, 0.5, sh)
        el = _empty("elbow_" + side, (0, -ua, 0), sh)
        _ell("cop_" + side, (0, 0, 0), (ar * 1.25,) * 3, steel, 16).parent = el
        _cyl("farm_" + side, (0, -fa / 2, 0), ar * 0.95, fa, steel, 0.5, el)
        hand = _empty("hand_" + side, (0, -fa, 0), el)
        _rbox("gauntlet_" + side, (0, -1.2, 0), (ar * 1.1, 1.8, ar * 1.1), 0.8, steel).parent = hand
        arms[side] = (sh, el, hand)
    grip = _empty("grip", (0, -1.5, 0), arms["r"][2])                 # the sword along the hand's -y (the forearm on)
    gl, bl = f("grip_l", 4.0), f("blade_l", 22.0)
    _cyl("grip_bar", (0, 0, 0), 0.8, gl, steel, 0.2, grip)
    _rbox("guard", (0, -gl / 2 - 0.5, 0), (f("guard_w", 4.0), 0.6, 0.8), 0.3, steel).parent = grip
    _rbox("blade", (0, -gl / 2 - 1.0 - bl / 2, 0), (f("blade_w", 0.9), bl / 2, 0.35), 0.3, blade).parent = grip
    legs = {}
    for side, sx in (("r", -1.0), ("l", 1.0)):
        hp = _empty("hipj_" + side, (sx * f("hip_x", 3.6), -f("hip_dy", 1.0), 0), root)
        tl, sl, lr = f("thigh_l", 10.0), f("shin_l", 9.0), f("leg_r", 3.0)
        _cyl("thigh_" + side, (0, -tl / 2, 0), lr, tl, steel, 0.6, hp)
        kn = _empty("knee_" + side, (0, -tl, 0), hp)
        _ell("kcop_" + side, (0, 0, 0.5), (lr * 1.15, lr * 0.9, lr * 1.1), steel, 16).parent = kn
        _cyl("shin_" + side, (0, -sl / 2, 0), lr * 0.95, sl, steel, 0.6, kn)
        _rbox("sabaton_" + side, (0, -sl - 1.2, 1.2), (lr * 1.05, 1.4, lr * 1.5), 0.8, steel).parent = kn
        legs[side] = hp
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S, segments=32, ring_count=16,
                                         location=(0, f("orb_y", 18.0) * S, f("orb_z", 8.0) * S))
    orb = bpy.context.active_object
    orb.name = "orb"
    orb.data.materials.append(_orb_mat(opts))
    orb.parent = root
    k = f("model_scale", 0.32)                                        # sword raised: shrink into the +-1.07 sweep camera
    root.scale = (k, k, k)
    root.location = (0, f("model_dy", -12.0) * S * k, 0)
    return root, arms, grip, orb, legs


def _frames_setup(opts):
    root, arms, grip, orb, legs = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "arms": arms, "grip": grip, "orb": orb, "legs": legs, "elbow0": float(opts.get("elbow0", 10.0)),
            "base": {k: float(opts[k + "0"]) for k in ("s_r", "s_l", "a_r", "a_l", "e_r", "e_l", "sw", "stance")
                     if k + "0" in opts}}


def _frames_pose(ctx, pose):
    p = dict(ctx["base"])
    p.update(pose)
    g = lambda k, d=0.0: float(p.get(k, d))
    ctx["root"].rotation_euler = (0.0, math.radians(g("yaw")), 0.0)
    for side, sx in (("r", -1.0), ("l", 1.0)):
        sh, el, hand = ctx["arms"][side]
        sh.rotation_euler = (math.radians(-g("s_" + side)), 0.0, math.radians(sx * g("a_" + side)))   # raise, spread
        el.rotation_euler = (math.radians(-(ctx["elbow0"] + g("e_" + side))), 0.0, 0.0)
    ctx["grip"].rotation_euler = (math.radians(g("sw")), 0.0, 0.0)
    for side, sg in (("r", 1.0), ("l", -1.0)):                         # + = forward (toward the camera at yaw 0)
        ctx["legs"][side].rotation_euler = (-math.radians(sg * g("stance") + g("l_" + side)), 0.0, 0.0)
    r = g("glow")
    ctx["orb"].hide_render = r <= 0.05
    ctx["orb"].scale = (max(r, 0.05),) * 3


register_frames("knight", _frames_setup, _frames_pose)
