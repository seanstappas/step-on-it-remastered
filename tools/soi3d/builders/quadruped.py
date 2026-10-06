"""soi3d.builders.quadruped -- four-legged walkers (hippo_sprites, piggy_sprites f02-f33).

A generic rig in SD pixel units: an ellipsoid BODY, a HEAD at the front (-X when yaw = 0, i.e. facing
left like f02), four capsule LEGS hinged at the hips (diagonal pairs swing together), plus species
details: the hippo's open black mouth with white teeth, small ears and grey hooves ("open_mouth": the gap
across the snout's front with an upper and a lower tooth each side; "tail_l": a stub at the rump; "claws":
white toenails); the piggy's upturned
trumpet snout, big white eyeballs with blue pupils and the striped cone on its back. Pose: "yaw" (0 =
facing left, 180 = facing right, 90 = facing the camera) and "phase" (walk cycle, deg). "snout_box" (a
rounded-box hippo head with the flat front f02 shows) scored worse than the ellipsoid (IoU 0.843 at f20).
"""
import math

import bpy
import mathutils

from .. import common as C
from .. import register_frames

S = 0.05   # Blender units per SD pixel (a 36 px sprite stays inside the sweep camera)


def _stripes(rgb_a, rgb_b, freq):
    """Bands of rgb_a / rgb_b along the object's local Z (the piggy's striped cone), `freq` bands per unit."""
    m = C._mat("stripes", C._srgb(*rgb_a), rough=0.35, spec=0.3)
    N, L = m.node_tree.nodes, m.node_tree.links
    tc, sep = N.new("ShaderNodeTexCoord"), N.new("ShaderNodeSeparateXYZ")
    L.new(tc.outputs["Object"], sep.inputs[0])
    mul = N.new("ShaderNodeMath")
    mul.operation = 'MULTIPLY'
    mul.inputs[1].default_value = 2 * math.pi * freq
    L.new(sep.outputs[2], mul.inputs[0])
    sn = N.new("ShaderNodeMath")
    sn.operation = 'SINE'
    L.new(mul.outputs[0], sn.inputs[0])
    mr = N.new("ShaderNodeMapRange")
    mr.clamp = True
    mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = -0.15, 0.15
    L.new(sn.outputs[0], mr.inputs["Value"])
    mix = N.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    L.new(mr.outputs["Result"], mix.inputs["Factor"])
    mix.inputs["A"].default_value = C._srgb(*rgb_a)
    mix.inputs["B"].default_value = C._srgb(*rgb_b)
    L.new(mix.outputs["Result"], N.get("Principled BSDF").inputs["Base Color"])
    return m


def _band(name, c, r, y0, h, x_max, mat):
    """A dark line on an _ell surface: the ellipsoid (c, r) grown 2% and cut to the slab |y - y0| < h over x < x_max
    (y0, h, x_max in the ellipsoid's unit coordinates). Real geometry, so the live GLB export keeps it."""
    band = _ell(name, c, tuple(v * 1.02 for v in r), mat, 48)
    lo, hi = c[1] + (y0 - h) * r[1], c[1] + (y0 + h) * r[1]
    x0, x1 = c[0] - r[0] * 1.1, c[0] + r[0] * x_max
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=((x0 + x1) / 2 * S, (lo + hi) / 2 * S, c[2] * S))
    cut = bpy.context.active_object
    cut.scale = ((x1 - x0) * S, (hi - lo) * S, r[2] * 3 * S)
    m = band.modifiers.new("slab", 'BOOLEAN')
    m.operation = 'INTERSECT'
    m.object = cut
    bpy.context.view_layer.objects.active = band
    bpy.ops.object.modifier_apply(modifier="slab")
    bpy.data.objects.remove(cut, do_unlink=True)
    return band


def _ell(name, c, r, mat, seg=32):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=seg, ring_count=seg // 2, location=tuple(v * S for v in c))
    o = bpy.context.active_object
    o.name = name
    o.scale = tuple(v * S for v in r)
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def _box(name, c, half, bevel, mat):
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


def _capsule(name, length, r, mat):
    """A capsule hanging straight down from its origin (the hip) by `length` px."""
    bpy.ops.mesh.primitive_cylinder_add(vertices=24, radius=r * S, depth=length * S,
                                        location=(0, -length * S / 2, 0), rotation=(math.pi / 2, 0, 0))
    cyl = bpy.context.active_object
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=False)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r * S, segments=24, ring_count=12, location=(0, -length * S, 0))
    cap = bpy.context.active_object
    bpy.ops.object.transform_apply(location=True, rotation=False, scale=False)
    bpy.ops.object.select_all(action='DESELECT')
    for o in (cyl, cap):
        o.select_set(True)
    bpy.context.view_layer.objects.active = cyl
    bpy.ops.object.join()
    cyl.name = name
    cyl.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return cyl


def build(opts):
    C._clear()
    sp = opts.get("species", "hippo")
    body_rgb = tuple(opts.get("body", (0, 150, 0) if sp == "hippo" else (230, 30, 110)))
    skin = C._mat("skin", C._srgb(*body_rgb), rough=float(opts.get("rough", 0.4)), spec=float(opts.get("spec", 0.25)))
    dark = C._mat("dark", C._srgb(*opts.get("dark", (10, 10, 10))), rough=0.6, spec=0.1)
    white = C._mat("white", C._srgb(*opts.get("white", (230, 230, 230))), rough=0.3, spec=0.4)
    grey = C._mat("grey", C._srgb(*opts.get("hoof", (150, 150, 150))), rough=0.4, spec=0.3)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    parts = []
    bl, bh, bd = float(opts.get("body_rx", 11.5)), float(opts.get("body_ry", 4.8)), float(opts.get("body_rz", 6.0))
    bx = float(opts.get("body_x", 3.0))
    parts.append(_ell("body", (bx, 0, 0), (bl, bh, bd), skin))
    hx, hy = float(opts.get("head_x", -8.0)), float(opts.get("head_y", 0.3))
    hr = (float(opts.get("head_rx", 5.0)), float(opts.get("head_ry", 4.0)), float(opts.get("head_rz", 4.6)))
    if sp == "hippo":
        if opts.get("snout_box", False):   # f02 rows 2-8: the snout's front is flat at x = 4, the mouth gap on it
            parts.append(_box("head", (hx, hy, 0), hr, float(opts.get("snout_bevel", 2.0)), skin))
        else:
            parts.append(_ell("head", (hx, hy, 0), hr, skin))
        sf = float(opts.get("snout_f", 0.0))
        if sf > 0:                           # the card's hippo: a wide muzzle bulging out in front of the head
            parts.append(_ell("snout", (hx - hr[0] * float(opts.get("snout_fx", 0.6)), hy + float(opts.get("snout_dy", -0.6)), 0),
                              (hr[0] * 0.5 * sf, hr[1] * 0.75 * sf, hr[2] * 1.05 * sf), skin))
        if opts.get("mouth_band", False):    # f02 row 5, x 4-7: a 1 px dark line from the snout tip back
            parts.append(_band("mouth_line", (hx, hy, 0), hr, float(opts.get("band_y", 0.0)),
                               float(opts.get("band_h", 0.15)), float(opts.get("band_x", -0.3)), dark))
        mw = float(opts.get("mouth_h", 1.6))
        jg = float(opts.get("jaw_gap", 0.0))
        mu = float(opts.get("muzzle", 0.0))
        if mu > 0:                           # the card's hippo: a boxy open muzzle out of the head, 2 peg teeth below
            g = lambda k, d: float(opts.get(k, d))
            jy, gap = hy + g("muz_y", -0.8), g("muz_gap", 2.2)
            xb, xf = hx - hr[0] * g("muz_back", 0.3), hx - hr[0] - mu      # back (inside the head) and front faces
            mx, ml, mz = (xb + xf) / 2, (xb - xf) / 2, hr[2] * g("muz_w", 0.85)
            uh, lh = g("lip_h", 1.8), g("jaw_h", 0.9)
            if opts.get("muz_cut", False):         # hollow the head out of the gap: no head sphere inside the mouth
                bpy.ops.mesh.primitive_cube_add(size=2.0, location=((xf + xb) / 2 * S, jy * S, 0))
                cut = bpy.context.active_object
                cut.scale = ((xb - xf) / 2 * S, gap / 2 * S, mz * 0.95 * S)
                for o in parts:
                    if o.name.startswith("head"):
                        m = o.modifiers.new("mouth", 'BOOLEAN')
                        m.operation, m.object = 'DIFFERENCE', cut
                        bpy.context.view_layer.objects.active = o
                        bpy.ops.object.modifier_apply(modifier="mouth")
                bpy.data.objects.remove(cut, do_unlink=True)
            parts.append(_box("snout_up", (mx, jy + gap / 2 + uh / 2, 0), (ml, uh / 2, mz), min(uh / 2, 1.0), skin))
            parts.append(_box("snout_lo", (mx + g("jaw_back", 0.4), jy - gap / 2 - lh / 2, 0),
                              (ml - g("jaw_back", 0.4), lh / 2, mz * 0.95), min(lh / 2, 0.6), skin))
            parts.append(_box("mouth_inside", (mx + 0.6, jy, 0), (ml - 0.6, gap / 2 + 0.1, mz * 0.9), 0.2, dark))
            pr, ph = g("peg_r", 0.55), gap * g("peg_h", 0.75)
            for zz in (-1.0, 1.0):
                bpy.ops.mesh.primitive_cylinder_add(vertices=16, radius=pr * S, depth=ph * S,
                                                    location=((xf + pr + g("peg_in", 0.5)) * S, (jy - gap / 2 + ph / 2) * S,
                                                              zz * mz * g("peg_z", 0.55) * S),
                                                    rotation=(math.pi / 2, 0, 0))
                peg = bpy.context.active_object
                peg.name = "tooth_lo"
                peg.data.materials.append(white)
                bpy.ops.object.shade_smooth()
                parts.append(peg)
        elif jg > 0:                         # the card's hippo: a real open jaw -- a wedge cut out of head + snout
            jy = hy + float(opts.get("jaw_y", -0.8))
            x0 = hx - hr[0] * float(opts.get("jaw_depth", 0.35))           # how far back the gap runs
            bpy.ops.mesh.primitive_cube_add(size=2.0, location=((x0 - 20.0) * S, jy * S, 0))
            cut = bpy.context.active_object
            cut.scale = (20.0 * S, jg / 2 * S, 20.0 * S)
            for o in parts:
                if o.name.startswith(("head", "snout")):
                    m = o.modifiers.new("jaw", 'BOOLEAN')
                    m.operation, m.object = 'DIFFERENCE', cut
                    bpy.context.view_layer.objects.active = o
                    bpy.ops.object.modifier_apply(modifier="jaw")
            bpy.data.objects.remove(cut, do_unlink=True)
            parts.append(_ell("mouth_inside", (x0 + 0.3, jy, 0), (1.2, jg * 0.6, hr[2] * 0.75), dark, 16))   # the cavity
            tw, th = float(opts.get("jtooth_w", 0.9)), float(opts.get("jtooth_h", 1.4))
            tx = hx - hr[0] * float(opts.get("jtooth_fx", 0.85))
            for zz in (-1.0, 1.0):                    # two square teeth hanging from the upper jaw
                parts.append(_box("tooth_up", (tx, jy + jg / 2 - th / 2 + 0.2, zz * float(opts.get("tooth_z", 1.4))),
                                  (tw / 2, th / 2, tw / 2), 0.15, white))
        elif opts.get("open_mouth", False):
            # f02 rows 5-8: a black gap across the snout's front, one white tooth hanging from the upper lip and
            # one rising from the lower jaw on each side, the green lower jaw below
            mx = hx - hr[0] * float(opts.get("mouth_fx", 0.8))
            my = hy + float(opts.get("mouth_dy", -1.0))
            mz = hr[2] * float(opts.get("mouth_rz", 0.8))      # > the head's local half-width: the gap shows on the sides
            parts.append(_ell("mouth", (mx, my, 0), (hr[0] * float(opts.get("mouth_rx", 0.45)), mw, mz), dark, 24))
            tx = hx - hr[0] * float(opts.get("tooth_fx", 0.92))
            tz, trr = float(opts.get("tooth_z", 1.4)), float(opts.get("tooth_r", 0.55))
            for zz in (-tz, tz):
                parts.append(_ell("tooth_up", (tx, my + mw * 0.45, zz), (trr, trr * 1.6, trr), white, 12))
                parts.append(_ell("tooth_lo", (tx + 0.3, my - mw * 0.55, zz), (trr, trr * 1.4, trr), white, 12))
        else:
            parts.append(_ell("mouth", (hx - hr[0] * 0.75, hy - 0.8, 0), (hr[0] * 0.45, mw, hr[2] * 0.75), dark, 24))
            for zz in (-1.8, 1.8):
                parts.append(_ell("tooth", (hx - hr[0] * 0.9, hy - 0.2, zz), (0.7, 0.9, 0.7), white, 12))
        gr = float(opts.get("googly_r", 0.0))                        # the card's hippo: bulging eyes on top
        ez = float(opts.get("ear_z", 2.2))
        for zz in (-ez, ez):
            bf = float(opts.get("bump_f", 1.0))
            parts.append(_ell("ear", (hx + 1.0, hy + hr[1] + 0.3 * bf, zz), (0.9 * bf, 1.1 * bf, 0.7 * bf), white, 12))
            if opts.get("ear_pupils"):                              # the card: the white bumps are eyeballs
                pp = float(opts.get("pupil_r", 0.4))
                parts.append(_ell("pupil", (hx + 1.0 - 0.9 * bf + 0.15, hy + hr[1] + 0.3 * bf + float(opts.get("pupil_dy", 0.1)), zz),
                                  (pp * 0.5, pp * 1.2, pp), dark, 12))
            if gr > 0:
                gx = hx + float(opts.get("googly_dx", -0.5))
                gy = hy + hr[1] * float(opts.get("googly_fy", 0.8))
                gz = zz * float(opts.get("googly_fz", 0.75))
                parts.append(_ell("eye", (gx, gy, gz), (gr, gr, gr), white, 16))
                pr = gr * float(opts.get("pupil_f", 0.5))
                parts.append(_ell("pupil", (gx - gr * 0.75, gy + gr * 0.1, gz + math.copysign(gr * 0.35, zz)),
                                  (pr * 0.6, pr, pr), dark, 12))
            else:
                if opts.get("cheek_eyes", True):            # off when the white bumps carry the pupils
                    parts.append(_ell("eye", (hx - 1.0, hy + hr[1] * 0.55, zz * 1.2), (0.7, 0.7, 0.7), dark, 12))
        if float(opts.get("tail_l", 0.0)) > 0:   # f02 rows 8-10: a stub at the rump, pointing back and down
            tl = float(opts["tail_l"])
            parts.append(_ell("tail", (bx + bl + tl * 0.3, float(opts.get("tail_y", -1.0)), 0),
                              (tl * 0.6, float(opts.get("tail_r", 1.1)), float(opts.get("tail_r", 1.1))), skin, 16))
    else:
        # The piggy has no separate head: the eyeballs sit on the front of the body's top, the trumpet snout
        # (thin neck, flared end, rim) leaves the body's front-top going up-forward, the striped tail rises
        # from the back.
        def tube(name, base, direction, length, r0, r1, mat):
            bpy.ops.mesh.primitive_cone_add(vertices=24, radius1=r0 * S, radius2=r1 * S, depth=length * S)
            o = bpy.context.active_object
            o.name = name
            o.rotation_mode = 'QUATERNION'
            o.rotation_quaternion = mathutils.Vector((0, 0, 1)).rotation_difference(direction)
            o.location = base + direction * (length * S / 2)
            o.data.materials.append(mat)
            bpy.ops.object.shade_smooth()
            parts.append(o)
            return o

        t = math.radians(float(opts.get("snout_tilt", 45.0)))           # above the forward (-X) horizontal
        sdir = mathutils.Vector((-math.cos(t), math.sin(t), 0.0))
        sl, sr, nr = float(opts.get("snout_l", 9.0)), float(opts.get("snout_r", 2.2)), float(opts.get("neck_r", 1.1))
        fl = float(opts.get("flare_l", 2.5))
        base = mathutils.Vector(((bx - bl * float(opts.get("snout_fx", 0.8))) * S, bh * float(opts.get("snout_fy", 0.5)) * S, 0))
        tube("snout", base, sdir, sl - fl, nr, nr, skin)
        tube("flare", base + sdir * ((sl - fl) * S), sdir, fl, nr, sr, skin)
        bpy.ops.mesh.primitive_torus_add(major_radius=sr * S, minor_radius=float(opts.get("rim_t", 0.6)) * S,
                                         major_segments=24, minor_segments=8)
        rim = bpy.context.active_object
        rim.name = "snout_rim"
        rim.rotation_mode = 'QUATERNION'
        rim.rotation_quaternion = mathutils.Vector((0, 0, 1)).rotation_difference(sdir)
        rim.location = base + sdir * (sl * S)
        rim.data.materials.append(skin)
        bpy.ops.object.shade_smooth()
        parts.append(rim)
        er = float(opts.get("eye_r", 3.0))
        ex, ey, ez = bx - bl * float(opts.get("eye_fx", 0.6)), bh * float(opts.get("eye_fy", 0.75)), float(opts.get("eye_z", 3.5))
        blue = C._mat("blue", C._srgb(*opts.get("pupil", (10, 10, 170))), rough=0.3, spec=0.4)
        pr = float(opts.get("pupil_r", 1.3))
        for zz in (-ez, ez):
            parts.append(_ell("eyeball", (ex, ey, zz), (er, er, er), white, 24))
            d = mathutils.Vector((-1.0, 0.1, zz / max(ez, 1e-3) * float(opts.get("pupil_out", 0.35)))).normalized()
            pc = mathutils.Vector((ex, ey, zz)) + d * (er - pr * 0.35)
            parts.append(_ell("pupil", tuple(pc), (pr, pr, pr), blue, 16))
        tt = math.radians(float(opts.get("tail_tilt", 70.0)))           # above the backward (+X) horizontal
        tdir = mathutils.Vector((math.cos(tt), math.sin(tt), 0.0))
        tl = float(opts.get("tail_l", 6.0))
        tbase = mathutils.Vector(((bx + bl * float(opts.get("tail_fx", 0.7))) * S, bh * float(opts.get("tail_fy", 0.6)) * S, 0))
        tail = tube("tail", tbase, tdir, tl, float(opts.get("tail_r", 2.0)), float(opts.get("tail_r1", 1.4)),
                    _stripes(body_rgb, tuple(opts.get("white", (230, 230, 230))),
                             float(opts.get("tail_bands", 2.5)) / (tl * S)))
        tail.name = "tail"
    for o in parts:
        o.parent = root
    tail_pivot = None
    if sp != "hippo":                         # the tail swings about its base (pose "a_tail", "a_tail_y")
        bpy.ops.object.empty_add(location=tuple(tbase))
        tail_pivot = bpy.context.active_object
        tail_pivot.name = "tail_pivot"
        tail_pivot.parent = root
        tail.location = tail.location - tbase
        tail.parent = tail_pivot
    legs = []
    ll, lr = float(opts.get("leg_l", 6.5)), float(opts.get("leg_r", 2.0))
    fx, rx = float(opts.get("front_x", -2.5)), float(opts.get("rear_x", 9.5))
    hip_y = -float(opts.get("hip_y", 2.5))
    lz = float(opts.get("leg_z", 3.4))
    for key, x, z in (("fn", fx, lz), ("ff", fx, -lz), ("rn", rx, lz), ("rf", rx, -lz)):
        bpy.ops.object.empty_add(location=(x * S, hip_y * S, z * S))
        hip = bpy.context.active_object
        hip.name = "hip_" + key
        hip.parent = root
        leg = _capsule("leg_" + key, ll, lr, skin)
        leg.parent = hip
        kr = float(opts.get("knee_r", 0.0))
        if kr > 0:                            # the card's hippo: a round knee joint part-way down each leg
            _ell("knee_" + key, (-lr * float(opts.get("knee_fx", 0.25)), -ll * float(opts.get("knee_y", 0.45)), 0),
                 (lr * kr, lr * kr * 0.9, lr * kr), skin, 20).parent = hip
        ff = float(opts.get("foot_f", 0.0))
        if ff > 0 and sp != "hippo":         # the card's piggy: legs end in round bulbs
            _ell("foot_" + key, (0, -ll * float(opts.get("foot_y", 1.0)), 0), (lr * ff, lr * ff * 0.85, lr * ff), skin, 20).parent = hip
        if sp == "hippo":
            hoof = _ell("hoof_" + key, (0, -ll - 0.4, 0), (lr * 1.05, 0.9, lr * 1.05), grey, 16)
            hoof.parent = hip
            if opts.get("claws", False):      # f02 rows 15-16: white toenails at the front of each foot
                cl = _ell("claw_" + key, (-lr * float(opts.get("claw_fx", 0.8)), -ll - 0.3, 0),
                          (float(opts.get("claw_r", 0.7)), 0.8, lr * 0.9), white, 12)
                cl.parent = hip
            nt = int(opts.get("toe_n", 0))
            for t in range(nt):                 # the card's hippo: little white toes round the foot's front
                a = math.radians(-50 + 100 * t / max(nt - 1, 1))
                tr = float(opts.get("toe_r", 0.6))
                _ell("toe_%s%d" % (key, t), (-lr * math.cos(a) * 0.95, -ll - 0.5, lr * math.sin(a) * 0.95),
                     (tr, tr * 0.8, tr), white, 12).parent = hip
        legs.append((key, hip))
    return root, legs, tail_pivot


def _frames_setup(opts):
    root, legs, tail_pivot = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "legs": legs, "tail": tail_pivot, "amp": float(opts.get("swing", 22.0)),
            "tilt": math.radians(float(opts.get("tilt", 0.0)))}


def _frames_pose(ctx, pose):
    # pose {"yaw": deg (0 = facing left), "phase": walk cycle deg}; diagonal leg pairs swing together.
    # Per-leg overrides "a_fn"/"a_ff"/"a_rn"/"a_rf" (deg; front/rear x near/far) let the optimiser fit each
    # leg of each frame on its own.
    ctx["root"].rotation_mode = 'YXZ'
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(float(pose.get("yaw", 0.0))), 0.0)
    ph = math.radians(float(pose.get("phase", 0.0)))
    amp = math.radians(float(pose.get("swing", ctx["amp"])))
    for key, hip in ctx["legs"]:
        off = 0.0 if key in ("fn", "rf") else math.pi
        a = amp * math.sin(ph + off) + math.radians(float(pose.get("a_" + key, 0.0)))
        hip.rotation_euler = (0.0, 0.0, a)
    if ctx.get("tail") is not None:
        ctx["tail"].rotation_euler = (0.0, math.radians(float(pose.get("a_tail_y", 0.0))),
                                      math.radians(float(pose.get("a_tail", 0.0))))


register_frames("quadruped", _frames_setup, _frames_pose)
