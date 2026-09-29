"""soi3d.builders.robo -- the Robo (robo_sprites f02-f81): a red robot of cylinders with white joint rings.

In SD pixel units (origin = the hip joint, facing left (-X) at yaw 0): a red cylinder HEAD with a white visor
on its front ("visor_split": two eyes at +-"eye_z" instead; "face_plate": the original's face -- a white
plate over the front of the helmet with a red T, a centre stripe from the crown and a crossbar -- plus a white
ear stud on each side), a white NECK, a red cylinder TORSO with a white collar, white HIPS, two LEGS (red thigh, white
knee ring, red shin, white foot) and two ARMS (white shoulder ball, red upper arm, white elbow ring, red
forearm, white FIST).
Arm "n" is the near arm (+Z at yaw 0), "f" the far one. Pose (deg unless noted): "yaw", "phase" (walk),
"s_n"/"s_f" shoulder swing (+ = forward), "e_n"/"e_f" elbow (+ = forearm up), "t_n"/"t_f" thigh
(+ = forward), "k_n"/"k_f" knee (+ = shin back), "a_n"/"a_f" ankle (0 = foot level), "fist_n"/"fist_f" fist
scale (1 = rest; the punch grows it).
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S, _ell


def _empty(name, loc, parent):
    bpy.ops.object.empty_add(location=tuple(v * S for v in loc))
    e = bpy.context.active_object
    e.name = name
    e.parent = parent
    return e


def _cyl(name, c, r, h, mat, bevel=0.5, parent=None):
    """A vertical (Y) cylinder centred at c (px): radius r, height h, rounded rims."""
    bpy.ops.mesh.primitive_cylinder_add(vertices=24, radius=r * S, depth=h * S, rotation=(math.pi / 2, 0, 0))
    o = bpy.context.active_object
    bpy.ops.object.transform_apply(location=False, rotation=True, scale=False)
    o.location = tuple(v * S for v in c)
    o.name = name
    if bevel > 0:
        m = o.modifiers.new("bevel", 'BEVEL')
        m.width = min(bevel, r * 0.9, h * 0.45) * S
        m.segments = 3
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    if parent is not None:
        o.parent = parent
    return o


def _arc(name, c, r, h, deg, mat, parent, thick=0.25, seg=16):
    """A curved panel on a vertical cylinder of radius r (px) centred at c: +-deg around the front (-X),
    height h, `thick` px thick outward."""
    import bmesh
    me = bpy.data.meshes.new(name)
    bm = bmesh.new()
    a = math.radians(deg)
    ring = []
    for i in range(seg + 1):
        t = -a + 2 * a * i / seg
        x, z = -math.cos(t) * r * S, math.sin(t) * r * S
        ring.append((bm.verts.new((x, -h / 2 * S, z)), bm.verts.new((x, h / 2 * S, z))))
    for i in range(seg):
        bm.faces.new((ring[i][0], ring[i + 1][0], ring[i + 1][1], ring[i][1]))   # normal outward (-X side)
    bm.to_mesh(me)
    bm.free()
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.location = tuple(v * S for v in c)
    sol = o.modifiers.new("solid", 'SOLIDIFY')
    sol.thickness = thick * S
    sol.offset = 1.0
    bev = o.modifiers.new("bevel", 'BEVEL')
    bev.width = thick * 0.45 * S
    bev.segments = 2
    for p in me.polygons:
        p.use_smooth = True
    o.data.materials.append(mat)
    o.parent = parent
    return o


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    red = C._mat("red", C._srgb(*opts.get("red", (185, 0, 0))), rough=f("rough", 0.35), spec=f("spec", 0.35),
                 coat=f("coat", 0.0))                     # the original is glossy plastic with white highlights
    white = C._mat("white", C._srgb(*opts.get("white", (235, 235, 230))), rough=f("rough", 0.35), spec=f("spec", 0.35),
                   coat=f("coat", 0.0))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    hz = f("hip_z", 1.6)
    _cyl("hips", (0, 0, 0), f("hip_r", 3.2), f("hip_h", 2.6), white, 0.8, root)
    ty, th, tr = f("torso_y", 6.0), f("torso_h", 7.5), f("torso_r", 4.0)
    _cyl("torso", (0, ty, 0), tr, th, red, 0.8, root)
    if f("collar_h", 1.2) > 0:
        _cyl("collar", (0, ty + th / 2 - f("collar_h", 1.2) / 2, 0), tr * 1.04, f("collar_h", 1.2), white, 0.3, root)
    _cyl("neck", (0, f("neck_y", 11.0), 0), f("neck_r", 2.0), 1.6, red if opts.get("neck_red", False) else white, 0.3, root)
    hy, hh, hr = f("head_y", 15.5), f("head_h", 7.0), f("head_r", 3.8)
    _cyl("head", (0, hy, 0), hr, hh, red, f("head_bevel", 1.5), root)
    if opts.get("face_plate", False):       # face-on f58: white | red stripe | white over rows 2-3, red bar row 4-5
        fy = hy + f("face_dy", -0.3)
        _arc("face", (0, fy, 0), hr, f("face_h", 5.0), f("face_deg", 60.0), white, root, f("face_t", 0.25))
        ro = hr + f("face_t", 0.25)
        if f("face_lo_h", 0.0) > 0:         # the source's lower face (f58 rows 4-6) is a GREY plate under white eyes
            grey = C._mat("face_grey", C._srgb(*opts.get("face_grey", (150, 150, 155))), rough=f("rough", 0.35),
                          spec=f("spec", 0.35), coat=f("coat", 0.0))
            _arc("face_lo", (0, hy + f("face_lo_dy", -1.5), 0), hr, f("face_lo_h", 3.0), f("face_deg", 60.0), grey,
                 root, f("face_t", 0.25))
        _arc("face_stripe", (0, fy + f("stripe_dy", 1.5), 0), ro, f("stripe_h", 3.0), f("stripe_deg", 8.0), red, root, 0.15, 4)
        _arc("face_bar", (0, fy + f("bar_dy", -0.5), 0), ro, f("bar_h", 1.5), f("bar_deg", 30.0), red, root, 0.15, 8)
        for sz in (1.0, -1.0):              # side views f02/f20: a white stud mid-head
            bpy.ops.mesh.primitive_cylinder_add(vertices=16, radius=f("ear_r", 0.9) * S, depth=f("ear_len", 0.8) * S)
            e = bpy.context.active_object
            e.name = "ear_" + ("n" if sz > 0 else "f")
            e.location = (0, (hy + f("ear_dy", -0.3)) * S, sz * (hr + f("ear_len", 0.8) * 0.3) * S)
            e.data.materials.append(white)
            bpy.ops.object.shade_smooth()
            e.parent = root
    elif opts.get("visor_split", False):    # two white eyes with a red gap (face-on f58: white at x 14 and x 17)
        ez = f("eye_z", 1.5)
        ex = -math.sqrt(max(hr * hr - ez * ez, 0.0)) * f("eye_fx", 1.0)   # centred on the head's surface
        for sz in (1.0, -1.0):
            _rbox("visor_" + ("n" if sz > 0 else "f"), (ex, hy + f("eye_dy", 1.6), sz * ez),
                  (f("eye_rx", 0.5), f("eye_ry", 1.0), f("eye_rz", 0.55)), 0.3, white).parent = root
    else:
        _rbox("visor", (-hr * f("visor_fx", 0.85), hy + f("visor_dy", 0.3), 0),
              (f("visor_rx", 0.8), f("visor_ry", 1.6), f("visor_rz", 2.4)), 0.4, white).parent = root
    arms, legs = {}, {}
    ua, fa, ar = f("uarm_l", 3.6), f("farm_l", 3.4), f("arm_r", 1.5)
    rh = f("ring_h", 1.3)
    for side, sz in (("n", 1.0), ("f", -1.0)):
        sh = _empty("shoulder_" + side, (0, f("shoulder_y", 9.5), sz * f("shoulder_z", 5.0)), root)
        _ell("shoulder_ball_" + side, (0, 0, 0), (ar * f("shoulder_f", 1.35),) * 3, white).parent = sh
        _cyl("uarm_" + side, (0, -ua / 2, 0), ar, ua, red, 0.3, sh)
        el = _empty("elbow_" + side, (0, -ua, 0), sh)
        _cyl("elbow_ring_" + side, (0, 0, 0), ar * 1.2, rh, white, 0.3, el)
        _cyl("farm_" + side, (0, -fa / 2, 0), ar, fa, red, 0.3, el)
        fp = _empty("fist_" + side, (0, -fa, 0), el)
        fr = f("fist_r", 1.9)
        _ell("fist_ball_" + side, (0, 0, 0), (fr, fr, fr), white, 24).parent = fp
        arms[side] = (sh, el, fp)
        hp = _empty("hipj_" + side, (0, -f("hip_h", 2.6) * 0.3, sz * hz), root)
        tl, sl, lr = f("thigh_l", 4.6), f("shin_l", 4.2), f("leg_r", 1.8)
        _cyl("thigh_" + side, (0, -tl / 2, 0), lr, tl, red, 0.3, hp)
        kn = _empty("knee_" + side, (0, -tl, 0), hp)
        _cyl("knee_ring_" + side, (0, 0, 0), lr * 1.18, rh, white, 0.3, kn)
        _cyl("shin_" + side, (0, -sl / 2, 0), lr, sl, red, 0.3, kn)
        an = _empty("ankle_" + side, (0, -sl, 0), kn)
        _rbox("foot_" + side, (-f("foot_dx", 0.8), -f("foot_ry", 1.2), 0),
              (f("foot_rx", 2.6), f("foot_ry", 1.2), f("foot_rz", 1.9)), 0.5, white).parent = an
        legs[side] = (hp, kn, an)
    return root, arms, legs


def _frames_setup(opts):
    root, arms, legs = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"root": root, "arms": arms, "legs": legs, "tilt": math.radians(f("tilt", 0.0)),
            "swing": f("swing", 25.0), "knee_amp": f("knee_amp", 35.0), "arm_swing": f("arm_swing", 20.0),
            "elbow0": f("elbow0", 15.0)}


def _frames_pose(ctx, pose):
    g = lambda k, d=0.0: float(pose.get(k, d))
    ctx["root"].rotation_mode = 'YXZ'
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(g("yaw")), 0.0)
    ph = math.radians(g("phase"))
    walk = 1.0 if "phase" in pose else 0.0
    for side, sgn in (("n", 1.0), ("f", -1.0)):
        sh, el, fp = ctx["arms"][side]
        s = walk * -sgn * ctx["arm_swing"] * math.sin(ph) + g("s_" + side)
        sh.rotation_euler = (-sgn * math.radians(g("b_" + side)), 0.0, -math.radians(s))   # "b": raised sideways
        el.rotation_euler = (0.0, 0.0, -math.radians(ctx["elbow0"] + g("e_" + side)))
        k = g("fist_" + side, 1.0)
        fp.scale = (k, k, k)
        hp, kn, an = ctx["legs"][side]
        t = walk * sgn * ctx["swing"] * math.sin(ph) + g("t_" + side)
        kk = walk * ctx["knee_amp"] * max(0.0, math.sin(ph + (0 if sgn > 0 else math.pi) - math.pi / 2)) + g("k_" + side)
        hp.rotation_euler = (-sgn * math.radians(g("h_" + side)), 0.0, -math.radians(t))   # "h": spread sideways
        kn.rotation_euler = (0.0, 0.0, math.radians(kk))
        an.rotation_euler = (0.0, 0.0, math.radians(t - kk + g("a_" + side)))   # level foot + optional ankle


register_frames("robo", _frames_setup, _frames_pose)
