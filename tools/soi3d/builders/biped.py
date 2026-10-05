"""soi3d.builders.biped -- two-legged walkers (ostrich_sprites f02-f33).

The ostrich in SD pixel units (origin = body centre, facing left (-X) at yaw 0): a pink BODY ellipsoid with
green WINGS on its sides, a thin green NECK rising from the body's front-top to a pink HEAD with a long flat
green BEAK and two white EYES on top, and two green LEGS -- thigh + shin with a backward-bending knee --
ending in flat pink FEET that stay level. Pose: "yaw" (deg, 0 = facing left, 90 = facing the camera),
"phase" (walk cycle, deg; the legs are half a cycle apart), per-leg overrides "a_l"/"a_r" (thigh, deg,
+ = backward) and "k_l"/"k_r" (knee, deg), and "neck" (deg, head bob about the neck base).
"""
import math

import bpy
import mathutils

from .. import common as C
from .. import register_frames
from .quadruped import S, _capsule, _ell


def _tube(name, p0, p1, r, mat):
    """A cylinder of radius r (px) from p0 to p1 (px, parent-local)."""
    a, b = mathutils.Vector(p0) * S, mathutils.Vector(p1) * S
    d = b - a
    bpy.ops.mesh.primitive_cylinder_add(vertices=20, radius=r * S, depth=d.length)
    o = bpy.context.active_object
    o.name = name
    o.rotation_mode = 'QUATERNION'
    o.rotation_quaternion = mathutils.Vector((0, 0, 1)).rotation_difference(d)
    o.location = (a + b) / 2
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def _empty(name, loc, parent):
    bpy.ops.object.empty_add(location=tuple(v * S for v in loc))
    e = bpy.context.active_object
    e.name = name
    e.parent = parent
    return e


def _rbox(name, c, half, bevel, mat):
    """A rounded box centred at c with half-sizes `half` and edge radius `bevel` (all px)."""
    bpy.ops.mesh.primitive_cube_add(size=2.0, location=tuple(v * S for v in c))
    o = bpy.context.active_object
    o.name = name
    o.scale = tuple(v * S for v in half)
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    m = o.modifiers.new("bevel", 'BEVEL')
    m.width = min(bevel, *half) * S * 0.98
    m.segments = 4
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    pink = C._mat("pink", C._srgb(*opts.get("body", (255, 45, 130))), rough=f("rough", 0.4), spec=f("spec", 0.25))
    green = C._mat("green", C._srgb(*opts.get("green", (0, 160, 0))), rough=f("rough", 0.4), spec=f("spec", 0.25))
    white = C._mat("white", C._srgb(*opts.get("white", (230, 230, 230))), rough=0.3, spec=0.4)
    dark = C._mat("dark", C._srgb(*opts.get("pupil", (40, 40, 40))), rough=0.3, spec=0.4)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    brx, bry, brz = f("body_rx", 6.5), f("body_ry", 4.0), f("body_rz", 5.0)
    _ell("body", (0, 0, 0), (brx, bry, brz), pink).parent = root
    n = int(f("tail_n", 0))
    if n > 0:                                                  # the card's ostrich: a fan of tail feathers
        tl, tw = f("tail_l", 4.0), f("tail_w", 1.6)
        a0, a1 = math.radians(f("tail_a0", 10.0)), math.radians(f("tail_a1", 70.0))
        tx, ty = brx * f("tail_fx", 0.85), bry * f("tail_fy", 0.3)
        for i in range(n):
            a = a0 + (a1 - a0) * i / max(n - 1, 1)
            fe = _ell("tail_feather", (tx + math.cos(a) * tl * 0.5, ty + math.sin(a) * tl * 0.5, 0),
                      (tl * 0.55, tw / 2, f("tail_d", 1.2)), pink)
            fe.rotation_euler = (0, 0, a)
            fe.parent = root
    wz = brz * f("wing_fz", 0.8)
    wn = int(f("wing_fan", 0))
    for zz in (-wz, wz):
        if wn > 0:                                             # the card's ostrich: fanned wing feathers, swept back
            wl, ww = f("wfeather_l", 6.0), f("wfeather_w", 1.8)
            a0, a1 = math.radians(f("wfan_a0", -20.0)), math.radians(f("wfan_a1", 50.0))
            wx, wy = f("wing_x", 2.5) - f("wfan_root", 2.0), f("wing_y", 0.5)
            for i in range(wn):
                a = a0 + (a1 - a0) * i / max(wn - 1, 1)
                ln = wl * (1.0 - 0.25 * abs(i - (wn - 1) / 2) / max((wn - 1) / 2, 1))
                fe = _ell("wing_feather", (wx + math.cos(a) * ln * 0.5, wy + math.sin(a) * ln * 0.5, zz),
                          (ln * 0.55, ww / 2, f("wing_rz", 1.6) * 0.6), green)
                fe.rotation_euler = (0, 0, a)
                fe.parent = root
            if not opts.get("wing_fan_keep"):                  # keep: the solid wing too, the fan as its feather tips
                continue
        wc, wh = (f("wing_x", 2.5), f("wing_y", 0.5), zz), (f("wing_rx", 4.5), f("wing_ry", 3.5), f("wing_rz", 1.6))
        w = _rbox("wing", wc, wh, f("wing_bevel", 1.2), green) if opts.get("wing_box", False) else _ell("wing", wc, wh, green)
        w.rotation_euler = (0, 0, math.radians(f("wing_tilt", 10.0)))
        w.parent = root
    nb = (f("neck_bx", -4.0), f("neck_by", 2.5), 0.0)
    neck = _empty("neck_pivot", nb, root)
    hx, hy = f("head_x", -8.0) - nb[0], f("head_y", 10.0) - nb[1]       # head centre, neck-pivot local
    _tube("neck", (0, 0, 0), (hx, hy - f("head_ry", 2.8) * 0.5, 0), f("neck_r", 1.4), green).parent = neck
    hrx, hry, hrz = f("head_rx", 5.0), f("head_ry", 2.8), f("head_rz", 3.5)
    _ell("head", (hx, hy, 0), (hrx, hry, hrz), pink).parent = neck
    bl = f("beak_l", 7.0)
    if opts.get("beak_cone", False):
        # a needle: a cone from the head's front (radius beak_h) to a point beak_l px ahead
        base = mathutils.Vector((hx - hrx + f("beak_in", 1.5), hy + f("beak_y", -0.3), 0.0)) * S
        bd = mathutils.Vector((-1.0, math.tan(math.radians(f("beak_tilt", 0.0))), 0.0)).normalized()
        bpy.ops.mesh.primitive_cone_add(vertices=16, radius1=f("beak_h", 0.9) * S, radius2=0.0, depth=bl * S)
        bk = bpy.context.active_object
        bk.name = "beak"
        bk.rotation_mode = 'QUATERNION'
        bk.rotation_quaternion = mathutils.Vector((0, 0, 1)).rotation_difference(bd)
        bk.location = base + bd * (bl * S / 2)
        bk.data.materials.append(green)
        bpy.ops.object.shade_smooth()
        bk.parent = neck
    else:
        _ell("beak", (hx - hrx - bl / 2 + f("beak_in", 1.5), hy + f("beak_y", -0.3), 0), (bl / 2, f("beak_h", 0.9), f("beak_w", 1.3)),
             green).parent = neck
    er, ez = f("eye_r", 1.8), f("eye_z", 1.8)
    ec = (hx + f("eye_dx", -0.5), hy + hry * f("eye_fy", 0.9), 0.0)
    pr = f("pupil_r", 0.8)
    for zz in (-ez, ez):
        _ell("eye", (ec[0], ec[1], zz), (er, er, er), white, 20).parent = neck
        if pr <= 0:
            continue
        d = mathutils.Vector((-1.0, 0.15, zz / max(ez, 1e-3) * f("pupil_out", 0.3))).normalized()
        pc = mathutils.Vector((ec[0], ec[1], zz)) + d * (er - pr * 0.35)
        _ell("pupil", tuple(pc), (pr, pr, pr), dark, 12).parent = neck
    legs = []
    tl, sl, lr = f("thigh_l", 4.5), f("shin_l", 5.5), f("leg_r", 1.2)
    for side, zz in (("l", f("leg_z", 2.0)), ("r", -f("leg_z", 2.0))):
        hip = _empty("hip_" + side, (f("hip_x", 1.0), -f("hip_y", 3.0), zz), root)
        _capsule("thigh_" + side, tl, lr, green).parent = hip
        knee = _empty("knee_" + side, (0, -tl, 0), hip)
        _capsule("shin_" + side, sl, lr, green).parent = knee
        ankle = _empty("ankle_" + side, (0, -sl, 0), knee)
        _ell("foot_" + side, (f("foot_dx", -1.5), -f("foot_ry", 1.6) * 0.4, 0), (f("foot_rx", 3.0), f("foot_ry", 1.6), f("foot_rz", 2.0)),
             pink, 20).parent = ankle
        legs.append((side, hip, knee, ankle))
    return root, neck, legs


def _frames_setup(opts):
    root, neck, legs = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "neck": neck, "legs": legs, "tilt": math.radians(float(opts.get("tilt", 0.0))),
            "thigh0": float(opts.get("thigh0", 20.0)), "amp": float(opts.get("swing", 25.0)),
            "knee0": float(opts.get("knee0", 45.0)), "kamp": float(opts.get("knee_amp", 30.0))}


def _frames_pose(ctx, pose):
    ctx["root"].rotation_mode = 'YXZ'
    tilt = ctx["tilt"] + math.radians(float(pose.get("pitch", 0.0)))   # pose "pitch": per-frame lean (deg)
    ctx["root"].rotation_euler = (tilt, math.radians(float(pose.get("yaw", 0.0))), 0.0)
    ctx["neck"].rotation_euler = (0.0, 0.0, math.radians(float(pose.get("neck", 0.0))))
    ph = math.radians(float(pose.get("phase", 0.0)))
    for side, hip, knee, ankle in ctx["legs"]:
        p = ph + (0.0 if side == "l" else math.pi)
        a = ctx["thigh0"] + ctx["amp"] * math.sin(p) + float(pose.get("a_" + side, 0.0))
        k = ctx["knee0"] + ctx["kamp"] * 0.5 * (1 + math.cos(p)) + float(pose.get("k_" + side, 0.0))
        hip.rotation_euler = (0.0, 0.0, math.radians(a))           # + = thigh swings backward (+X)
        knee.rotation_euler = (0.0, 0.0, -math.radians(k))         # the shin folds forward from the knee
        ankle.rotation_euler = (0.0, 0.0, math.radians(k - a))     # keeps the foot level


register_frames("biped", _frames_setup, _frames_pose)
