"""soi3d.builders.ant -- the Ant (ant_sprites f02-f50): a robot ant of glossy red balls on bar legs.

In SD pixel units (origin = the thorax centre, facing left (-X) at yaw 0): a red body of three glossy
ellipsoids (head, thorax, abdomen; `body_shape` "box" = rounded boxes instead), a grey jaw bar sticking
forward under the head, a grey antenna post on the head, and six grey LEGS: straight thin bars from a KNEE just
above the body (`knee_x<i>`, + `knee_swing`) down to a FOOT on the ground (`foot_x<i>` + `swing`), so they slant
as the feet swing (the near ones cross in front of the body: the white strokes of the originals). Tripod gait:
legs L1, R2, L3 swing together, half a cycle from the other three. Pose: "yaw" (deg, 0 = facing left), "phase"
(walk cycle, deg), "l<i>"/"r<i>" (per-leg extra FOOT x offset, px).
Optional detail (default off): "hip_seg" adds each leg's UPPER segment bending from the knee down into the body
side (`hip_y`, `hip_dx`: the source's legs arch over the body), "foot_l" (px) a small FOOT at each leg's end
(pointing `foot_dir` in x), "ant_knob" (px radius) a knob on each antenna tip, "ant_wig" (deg) the antennae
wiggling forward/back with the walk phase.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S, _ell


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    red = C._mat("red", C._srgb(*opts.get("body", (230, 25, 30))), rough=f("rough", 0.35), spec=f("spec", 0.3),
                 coat=f("coat", 0.0))
    grey = C._mat("grey", C._srgb(*opts.get("leg", (205, 205, 205))), rough=f("rough", 0.35), spec=f("spec", 0.3))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    bz, bb = f("body_hz", 3.2), f("body_bevel", 1.0)
    for name, x, hx, hy in (("head", f("head_x", -8.0), f("head_hx", 2.6), f("head_hy", 2.8)),
                            ("thorax", 0.0, f("thx_hx", 4.0), f("thx_hy", 3.2)),
                            ("abdomen", f("abd_x", 7.5), f("abd_hx", 3.8), f("abd_hy", 3.4))):
        if opts.get("body_shape", "ball") == "box":
            _rbox(name, (x, f(name + "_y", 0.0), 0), (hx, hy, bz), bb, red).parent = root
        else:
            _ell(name, (x, f(name + "_y", 0.0), 0), (hx, hy, bz), red, 32).parent = root
    hx, jl = f("head_x", -8.0), f("jaw_l", 3.0)
    _rbox("jaw", (hx - f("head_hx", 2.6) - jl / 2 + 1.0, f("jaw_y", -1.8), 0),
          (jl / 2 + 1.0, f("jaw_h", 0.8), f("jaw_w", 1.2)), 0.4, grey).parent = root
    al = f("ant_l", 4.0)
    az = f("ant_z", 0.0)                 # > 0: a PAIR of antennae (face-on f26: two white posts 3 px apart)
    ants = []
    for i, zz in enumerate((az, -az) if az > 0 else (0.0,)):
        base = (hx + f("ant_dx", 0.5), f("head_y", 0.0) + f("head_hy", 2.8), zz)
        piv = bpy.data.objects.new("antpiv" if i == 0 else "antpiv_b", None)   # the antenna turns about its base
        bpy.context.collection.objects.link(piv)
        piv.location = tuple(v * S for v in base)
        piv.parent = root
        _rbox("antenna" if i == 0 else "antenna_b", (0, al / 2, 0), (f("ant_w", 0.8), al / 2, f("ant_w", 0.8)), 0.3,
              grey).parent = piv
        if f("ant_knob", 0.0) > 0:
            _ell("knob" if i == 0 else "knob_b", (0, al, 0), (f("ant_knob", 0.0),) * 3, grey, 16).parent = piv
        ants.append(piv)
    legs = []
    for side, sz in (("l", 1.0), ("r", -1.0)):
        for i in range(3):
            o = _rbox("leg_%s%d" % (side, i + 1), (0, 0, 0), (f("leg_w", 1.3), 1.0, f("leg_d", 0.8)), 0.4, grey)
            o.parent = root
            L = {"side": side, "i": i, "sz": sz, "obj": o, "x0": f("foot_x%d" % (i + 1), (-7.5, 2.5, 10.0)[i])}
            if opts.get("hip_seg"):
                L["up"] = _rbox("hip_%s%d" % (side, i + 1), (0, 0, 0), (f("leg_w", 1.3), 1.0, f("leg_d", 0.8)), 0.4, grey)
                L["up"].parent = root
            if f("foot_l", 0.0) > 0:
                fl = f("foot_l", 0.0)
                L["foot"] = _rbox("foot_%s%d" % (side, i + 1), (0, 0, 0), (fl / 2, f("foot_h", 0.6), f("leg_d", 0.8)), 0.3, grey)
                L["foot"].parent = root
            for key in ("foot_ball", "knee_ball"):                   # the card's ant: round feet / knee joints
                if f(key, 0.0) > 0:
                    L[key] = _ell(key, (0, 0, 0), (f(key, 0.0),) * 3, grey, 16)
                    L[key].parent = root
            legs.append(L)
    return root, legs, ants


def _frames_setup(opts):
    root, legs, ants = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    for L in legs:                                                    # the knee (bar top) defaults to above the foot
        L["xt"] = f("knee_x%d" % (L["i"] + 1), L["x0"])
    return {"root": root, "legs": legs, "tilt": math.radians(f("tilt", 0.0)), "amp": f("swing", 3.0), "lift": f("lift", 0.8),
            "top": f("leg_top", 3.2), "ground": f("ground", 9.0), "z": f("leg_z", 4.2), "kamp": f("knee_swing", 0.0),
            "splay": f("splay", 0.0), "ants": ants, "wig": f("ant_wig", 0.0), "hip_y": f("hip_y", 0.0),
            "hip_dx": f("hip_dx", 0.0), "hip_z": f("body_hz", 3.2) * f("hip_zf", 0.8), "foot_dir": f("foot_dir", -1.0),
            "foot_l": f("foot_l", 0.0), "fb": f("foot_ball", 0.0) * f("foot_ball_lift", 0.6)}


def _bar(o, a, b):
    """Lay the 2 px mesh bar `o` from point a to point b (px)."""
    from mathutils import Vector
    d = Vector((b[0] - a[0], b[1] - a[1], b[2] - a[2]))
    o.location = tuple((a[k] + b[k]) / 2 * S for k in range(3))
    o.rotation_mode = 'QUATERNION'
    o.rotation_quaternion = Vector((0.0, 1.0, 0.0)).rotation_difference(d.normalized())
    o.scale = (1.0, d.length / 2, 1.0)


def _frames_pose(ctx, pose):
    from mathutils import Vector
    ctx["root"].rotation_mode = 'YXZ'
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(float(pose.get("yaw", 0.0))), 0.0)
    ph = math.radians(float(pose.get("phase", 0.0)))
    top, bot = ctx["top"] + float(pose.get("kt", 0.0)), -ctx["ground"]   # pose "kt": per-frame knee height (px)
    for L in ctx["legs"]:
        tripod = (L["side"] == "l") == (L["i"] != 1)                 # L1, R2, L3 vs R1, L2, R3
        p = ph + (0.0 if tripod else math.pi)
        up = ctx["lift"] * max(0.0, math.cos(p))
        xf = L["x0"] + ctx["amp"] * math.sin(p) + float(pose.get("%s%d" % (L["side"], L["i"] + 1), 0.0))   # the foot
        xt = L["xt"] + ctx["kamp"] * math.sin(p)                     # the knee above the body
        yt, yb = top + up, bot + up
        zt, zb = L["sz"] * ctx["z"], L["sz"] * (ctx["z"] + ctx["splay"])   # the feet splay out to the side
        d = Vector((xt - xf, yt - yb, zt - zb))                       # a straight bar from the foot up to the knee
        o = L["obj"]
        o.location = ((xt + xf) / 2 * S, (yt + yb) / 2 * S, (zt + zb) / 2 * S)
        o.rotation_mode = 'QUATERNION'
        o.rotation_quaternion = Vector((0.0, 1.0, 0.0)).rotation_difference(d.normalized())
        o.scale = (1.0, d.length / 2, 1.0)                            # the mesh bar is 2 px long: scale to the leg
        if "up" in L:                                                 # the knee bends back down into the body side
            _bar(L["up"], (xt, yt, zt), (xt + ctx["hip_dx"], ctx["hip_y"], L["sz"] * ctx["hip_z"]))
        if "foot" in L:
            fl = ctx["foot_l"]
            L["foot"].location = ((xf + ctx["foot_dir"] * fl / 2) * S, (yb + 0.3) * S, zb * S)
        if "foot_ball" in L:
            L["foot_ball"].location = (xf * S, (yb + ctx["fb"]) * S, zb * S)
        if "knee_ball" in L:
            L["knee_ball"].location = (xt * S, yt * S, zt * S)
    wig = ctx["wig"] * math.sin(ph) + float(pose.get("ant_t", 0.0))    # the antennae wiggle with the walk
    for piv in ctx["ants"]:
        piv.rotation_euler = (0.0, 0.0, math.radians(wig))


register_frames("ant", _frames_setup, _frames_pose)
