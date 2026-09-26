"""soi3d.builders.kid -- the players (BP_sprites / GP_sprites): a boy in a sweater, trousers and trainers.

The Robo's rig (robo.py: shoulders, elbows, fists, hips, knees, ankles; same pose keys) dressed as a kid in SD
pixel units: a skin HEAD with a brown HAIR cap, a SWEATER torso and sleeves, skin HANDS, TROUSER legs and
white SHOES. Extra pose keys: "pitch" and "bank" (deg) turn the whole body (the tumbles and dives), about the hips
or, with opts "pivot_x"/"pivot_y" (px), about that point (a tucked roll turns about the body's centre).
Opts "s_n0" ... "k_f0" (any limb key + "0") are the BASE pose used when a pose omits that key, so a sweep can
start from e.g. a tucked tumble (give the optim the same values as its init).
"""
import math

import bpy
import mathutils

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S, _ell
from .robo import _cyl, _empty
from .robo import _frames_pose as _robo_pose


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    # "<colour>_gain" scales a colour (the look stage's continuous colour refinement)
    rgb = lambda name, dflt: tuple(max(0, min(255, int(round(v * f(name + "_gain", 1.0))))) for v in opts.get(name, dflt))
    mat = lambda name, dflt: C._mat(name, C._srgb(*rgb(name, dflt)), rough=f("rough", 0.45), spec=f("spec", 0.25))
    skin, hair, top, legs_m, shoe = (mat("skin", (235, 190, 150)), mat("hair", (110, 50, 20)), mat("sweater", (0, 0, 170)),
                                     mat("trousers", (150, 0, 0)), mat("shoes", (240, 240, 235)))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    ty, th, tr = f("torso_y", 6.0), f("torso_h", 8.0), f("torso_r", 3.4)
    _cyl("torso", (0, ty, 0), tr, th, top, f("torso_bevel", 1.2), root).scale = (f("torso_fx", 0.85), 1.0, 1.0)
    _cyl("pelvis", (0, 0.6, 0), f("hip_r", 3.0), f("hip_h", 2.4), legs_m, 0.8, root)
    hy, hr = f("head_y", 14.0), f("head_r", 3.3)
    neckj = _empty("neckj", (0, f("neck_y", 10.4), 0), root)          # pose "hd" turns the head (looking back)
    bpy.context.view_layer.update()
    for o in (_ell("head", (0, hy, 0), (hr, hr * f("head_fy", 1.05), hr * f("head_fz", 0.95)), skin),
              _ell("hair", (f("hair_dx", 0.8), hy + f("hair_dy", 0.9), 0),
                   (hr * f("hair_f", 1.05), hr * f("hair_fy", 0.95), hr * f("hair_fz", 1.02)), hair)):
        o.parent = neckj
        o.matrix_parent_inverse = neckj.matrix_world.inverted()
    if opts.get("eyes", True):      # big white cartoon eyes with blue pupils (4x2 px on the 36x34 cheer)
        er, el0, az0 = f("eye_r", 1.0), f("eye_el", 12.0), f("eye_az", 18.0)
        et = er * f("eye_t", 0.35)                  # thin along the head normal: flush, no profile bump
        white, pupil = mat("eye_white", (240, 240, 240)), mat("eye_pupil", (70, 70, 210))
        pr = er * f("eye_pupil_f", 0.5)
        rad = (hr, hr * f("head_fy", 1.05), hr * f("head_fz", 0.95))
        for sz, tag in ((1.0, "n"), (-1.0, "f")):
            for name, el, az, r3, m, lift in (("eye_", el0, az0, (et, er, er), white, 0.0),
                                              ("pupil_", el0 - f("eye_pupil_dy", 10.0), az0,
                                               (et * 0.6, pr, pr), pupil, et * 0.5)):
                e, a = math.radians(el), math.radians(az)
                d = (-math.cos(e) * math.cos(a), math.sin(e), sz * math.cos(e) * math.sin(a))
                t = 1.0 / math.sqrt(sum((d[i] / rad[i]) ** 2 for i in range(3))) + lift
                o = _ell(name + tag, (d[0] * t, hy + d[1] * t, d[2] * t), r3, m, 16)
                o.rotation_mode = 'ZYX'
                o.rotation_euler = (0.0, sz * a, -e)
                o.parent = neckj
                o.matrix_parent_inverse = neckj.matrix_world.inverted()
    _cyl("neck", (0, f("neck_y", 10.4), 0), f("neck_r", 1.3), 1.4, skin, 0.2, root)
    arms, legs = {}, {}
    ua, fa, ar = f("uarm_l", 3.6), f("farm_l", 3.4), f("arm_r", 1.3)
    for side, sz in (("n", 1.0), ("f", -1.0)):
        sh = _empty("shoulder_" + side, (0, f("shoulder_y", 9.0), sz * f("shoulder_z", 3.9)), root)
        _ell("shoulder_ball_" + side, (0, 0, 0), (ar * 1.15,) * 3, top).parent = sh
        _cyl("uarm_" + side, (0, -ua / 2, 0), ar, ua, top, 0.3, sh)
        el = _empty("elbow_" + side, (0, -ua, 0), sh)
        _ell("elbow_ball_" + side, (0, 0, 0), (ar,) * 3, top).parent = el
        _cyl("farm_" + side, (0, -fa / 2, 0), ar * 0.95, fa, top, 0.3, el)
        fp = _empty("fist_" + side, (0, -fa, 0), el)
        _ell("hand_" + side, (0, -f("hand_r", 1.1) * 0.6, 0), (f("hand_r", 1.1),) * 3, skin, 16).parent = fp
        arms[side] = (sh, el, fp)
        hp = _empty("hipj_" + side, (0, 0.0, sz * f("hip_z", 1.5)), root)
        tl, sl, lr = f("thigh_l", 5.4), f("shin_l", 5.0), f("leg_r", 1.6)
        _cyl("thigh_" + side, (0, -tl / 2, 0), lr, tl, legs_m, 0.3, hp)
        kn = _empty("knee_" + side, (0, -tl, 0), hp)
        _ell("knee_ball_" + side, (0, 0, 0), (lr,) * 3, legs_m).parent = kn
        _cyl("shin_" + side, (0, -sl / 2, 0), lr * 0.95, sl, legs_m, 0.3, kn)
        an = _empty("ankle_" + side, (0, -sl, 0), kn)
        _rbox("shoe_" + side, (-f("foot_dx", 0.9), -f("foot_ry", 1.0), 0),
              (f("foot_rx", 2.6), f("foot_ry", 1.0), f("foot_rz", 1.5)), 0.6, shoe).parent = an
        legs[side] = (hp, kn, an)
    return root, arms, legs


def _frames_setup(opts):
    root, arms, legs = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"root": root, "arms": arms, "legs": legs, "tilt": math.radians(f("tilt", 0.0)),
            "swing": f("swing", 30.0), "knee_amp": f("knee_amp", 45.0), "arm_swing": f("arm_swing", 30.0),
            "elbow0": f("elbow0", 25.0), "base": base_pose(opts), "neck": bpy.data.objects.get("neckj"),
            "pivot": (f("pivot_x", 0.0), f("pivot_y", 0.0))}


LIMB_KEYS = ("s_n", "s_f", "e_n", "e_f", "t_n", "t_f", "k_n", "k_f", "b_n", "b_f", "h_n", "h_f", "hd")


def base_pose(opts):
    return {k: float(opts[k + "0"]) for k in LIMB_KEYS if k + "0" in opts}


def _frames_pose(ctx, pose):
    p = dict(ctx.get("base", {}))
    p.update(pose)
    _robo_pose(ctx, p)
    if ctx.get("neck") is not None:
        ctx["neck"].rotation_euler = (0.0, math.radians(float(p.get("hd", 0.0))), 0.0)
    ctx["root"].rotation_mode = 'YXZ'
    ctx["root"].rotation_euler = (ctx["tilt"] + math.radians(float(p.get("bank", 0.0))),
                                  math.radians(float(p.get("yaw", 0.0))), math.radians(float(p.get("pitch", 0.0))))
    if any(ctx.get("pivot", ())):
        pv = mathutils.Vector((ctx["pivot"][0] * S, ctx["pivot"][1] * S, 0.0))
        ctx["root"].location = pv - ctx["root"].rotation_euler.to_matrix() @ pv


register_frames("kid", _frames_setup, _frames_pose)
