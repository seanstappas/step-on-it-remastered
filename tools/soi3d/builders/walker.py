"""soi3d.builders.walker -- the Walker's body (walker_sprites f02-f49; its bolt f50-f65 is bolt.py).

A white robot dog in SD pixel units (origin = body centre, facing left (-X) at yaw 0): a rounded-box BODY, a
rounded-box HEAD on its front top with a red NOSE (and, with `eyes`, a dark eye on each side of the face), and
four LEGS of two segments each (thigh, knee, shin,
foot): capsules with knee balls, or (`leg_shape` "block") rounded boxes `leg_w` x `leg_d` px with a boxy
boot. Pose: "yaw", "pitch" (deg, the body rocking in the picture plane), "phase" (walk; diagonal pairs fn+rf / ff+rn), per-leg "a_<leg>"
(thigh, deg, + = forward) and "k_<leg>" (knee bend, deg); legs fn/ff = front near/far, rn/rf = rear near/far.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S, _capsule, _ell


def _empty(name, loc, parent):
    bpy.ops.object.empty_add(location=tuple(v * S for v in loc))
    e = bpy.context.active_object
    e.name = name
    e.parent = parent
    return e


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    white = C._mat("white", C._srgb(*opts.get("white", (235, 235, 230))), rough=f("rough", 0.4), spec=f("spec", 0.3))
    red = C._mat("red", C._srgb(*opts.get("red", (190, 0, 0))), rough=0.35, spec=0.3)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    _rbox("body", (0, 0, 0), (f("body_hx", 14.0), f("body_hy", 5.5), f("body_hz", 5.0)), f("body_bevel", 3.0), white).parent = root
    hx, hy = f("head_x", -9.5), f("head_y", 6.5)
    _rbox("head", (hx, hy, 0), (f("head_hx", 5.5), f("head_hy", 6.5), f("head_hz", 4.5)), f("head_bevel", 3.0), white).parent = root
    _ell("nose", (hx - f("head_hx", 5.5) + f("nose_in", 0.3), hy + f("nose_y", -5.0), 0),
         (f("nose_rx", 1.5), f("nose_ry", 1.2), f("nose_rz", 1.3)), red, 16).parent = root
    if opts.get("eyes", False):            # f04 row 6 / f22 rows 5-7: a dark eye each side, behind the face's front
        dark = C._mat("eye", C._srgb(*opts.get("eye_rgb", (25, 25, 25))), rough=0.4, spec=0.3)
        er = f("eye_r", 0.8)
        for sz in (1.0, -1.0):
            _ell("eye_" + ("n" if sz > 0 else "f"),
                 (hx - f("head_hx", 5.5) * f("eye_fx", 0.55), hy + f("eye_dy", 0.4), sz * (f("head_hz", 4.5) - er * 0.4)),
                 (er, er, er * 0.6), dark, 16).parent = root
    legs = []
    tl, sl, lr = f("thigh_l", 5.0), f("shin_l", 5.0), f("leg_r", 1.7)
    block = opts.get("leg_shape", "capsule") == "block"
    lw, ld = f("leg_w", 2.0), f("leg_d", 1.8)
    for key, x, sz in (("fn", f("front_x", -6.0), 1), ("ff", f("front_x", -6.0), -1),
                       ("rn", f("rear_x", 9.0), 1), ("rf", f("rear_x", 9.0), -1)):
        hp = _empty("hip_" + key, (x, -f("hip_y", 4.5), sz * f("leg_z", 3.2)), root)
        if block:                                                  # segments overlap at the knee: no gap when bent
            _rbox("thigh_" + key, (0, -tl / 2, 0), (lw, tl / 2 + lw * 0.5, ld), lw * 0.6, white).parent = hp
        else:
            _capsule("thigh_" + key, tl, lr, white).parent = hp
        kn = _empty("knee_" + key, (0, -tl, 0), hp)
        if block:
            _rbox("shin_" + key, (0, -sl / 2, 0), (lw * f("shin_f", 0.9), sl / 2 + lw * 0.3, ld * 0.95), lw * 0.5, white).parent = kn
        else:
            _ell("kneeb_" + key, (0, 0, 0), (lr * 1.1,) * 3, white, 16).parent = kn
            _capsule("shin_" + key, sl, lr * f("shin_f", 0.9), white).parent = kn
        an = _empty("ankle_" + key, (0, -sl, 0), kn)
        if block:
            _rbox("foot_" + key, (-f("foot_dx", 0.6), -f("foot_ry", 0.9), 0),
                  (f("foot_rx", 2.0), f("foot_ry", 0.9), ld), 0.5, white).parent = an
        else:
            _ell("foot_" + key, (-f("foot_dx", 0.6), -f("foot_ry", 0.9) * 0.5, 0),
                 (f("foot_rx", 2.0), f("foot_ry", 0.9), f("foot_rz", 1.5)), white, 16).parent = an
        legs.append((key, hp, kn, an))
    return root, legs


def _frames_setup(opts):
    root, legs = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"root": root, "legs": legs, "tilt": math.radians(f("tilt", 0.0)), "swing": f("swing", 22.0),
            "knee_amp": f("knee_amp", 30.0)}


def _frames_pose(ctx, pose):
    g = lambda k, d=0.0: float(pose.get(k, d))
    ctx["root"].rotation_mode = 'YXZ'
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(g("yaw")), math.radians(g("pitch")))
    ph = math.radians(g("phase"))
    for key, hp, kn, an in ctx["legs"]:
        p = ph + (0.0 if key in ("fn", "rf") else math.pi)
        a = ctx["swing"] * math.sin(p) + g("a_" + key)
        k = ctx["knee_amp"] * max(0.0, math.cos(p)) + g("k_" + key)
        hp.rotation_euler = (0.0, 0.0, -math.radians(a))
        kn.rotation_euler = (0.0, 0.0, math.radians(k))
        an.rotation_euler = (0.0, 0.0, math.radians(a - k))


register_frames("walker", _frames_setup, _frames_pose)
