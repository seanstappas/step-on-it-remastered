"""soi3d.builders.knight -- the Knight (knight_sprites f02-f66): a grey armoured knight facing the camera.

SD px of the 60x80 cell, measured from the standing f02 (origin = the ground under the body centre, column 29;
+y up, +z toward the camera): a HELMET y 54-62 (+-5.5, flat-topped, a keel down the face with an eye slot either
side, a pointed finial to y 65), a GORGET, flat PAULDRONS from the neck to +-13.5 (y 48.5-53.5), a round
BREASTPLATE y 37-50 (+-7.5) with a centre ridge over three FAULD lames (y 31-37.5; their lit top edges are the
bright bands), a short hip block under the lames (y 28-31.5) with a small TASSET lip over each thigh, ARMS
(rerebrace 8.5 px, couter, vambrace, a flared cuff and a long gauntlet whose fist centre is 14.5 px past the elbow)
and LEGS from hip joints at y 28 right under the fauld (cuisse 18 px, poleyn, greave, sabaton; f13-f66 show the
legs apart from SD row 51-54 -- a hip block and tassets down to y 20 put the crotch 8-11 rows too low), both posed
by two-bone IK; a SWORD (pommel, grip, cross guard, a
diamond-section blade `blade_l` px) and the gift ORB (a gold lens in front of the chest that turns and grows,
f51-f66).
Pose (px / deg): "dx" the body's shift, "crouch" the hips sitting lower, "fl"/"fr" the screen-left/-right foot's x
on the ground, "hx"/"hy"/"hz" the sword fist (the screen-right arm's, on the grip) relative to the body, "sw" the
blade's angle from straight up in the view plane (+ = toward screen right), "st" the blade tipped toward the
camera, "grip2" (0 = the screen-left arm hangs at its side, 1 = its fist on the grip too), "glow" (the orb's size:
0 = none, 1 = f58's), "turn" (the orb about the vertical: 0 = face-on), "lean" (the orb in the view plane), "drop"
(+ = a teardrop with its tip up, - = tip down: the flame f54-f57 and the bulb f61-f63), "ox"/"oy" (the orb's offset),
"yaw", "roll" / "twist" (the upper body about the waist `pivot_y`: in the view plane / about the vertical; the
swing f22-f44 turns the chest with the sword).
Opt-in surface: "env" (the world becomes blotchy noise, 1 +- env at `env_scale`, for polished steel ("metal") to
reflect: the source's armour is a mottled mirror, not a flat grey); "rough_var" (+- roughness from fine noise at
`rough_scale`: scuffed metal, not a uniform plastic gloss) and "aniso" (brushed-steel anisotropic highlights).
Opt-in helmet: "helm_point" (px: the dome rises to a point that high above the old flat top, a classic
bascinet), "keel_wedge" (the face keel becomes a sharp ridge, a box turned 45 deg, `keel_d` px proud).
Opt-in no-clip posing: "grip_clear" (px: the sword fist always sits that far in front of the breastplate),
"elbow_fwd" (the IK elbow pole's forward share: elbows out to the sides instead of back into the body) and
"tip_fwd" (a blade tipped away from the camera is mirrored toward it: the same view-plane projection, but the
blade stays in front of the body).
"""
import math

import bmesh
import bpy
from mathutils import Matrix, Vector

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .gargoyle import _lathe
from .quadruped import S, _ell
from .robo import _cyl, _empty

POSE0 = {"yaw": 0.0, "dx": 0.0, "crouch": 0.0, "fl": -4.3, "fr": 3.8, "hx": 9.5, "hy": 26.0, "hz": 2.0,
         "sw": 214.0, "st": -20.0, "grip2": 0.0, "glow": 0.0, "turn": 0.0, "lean": 0.0, "roll": 0.0, "twist": 0.0}


def _frustum(name, y0, y1, r0, r1, mat, seg=32):
    """An elliptic frustum along y from y0 (half-axes r0 = (rx, rz)) to y1 (r1), px: smooth sides, flat caps."""
    me, bm = bpy.data.meshes.new(name), bmesh.new()
    a, b = ([bm.verts.new((rx * math.sin(2 * math.pi * i / seg) * S, y * S, rz * math.cos(2 * math.pi * i / seg) * S))
             for i in range(seg)] for y, (rx, rz) in ((y0, r0), (y1, r1)))
    side = [bm.faces.new((a[i], a[(i + 1) % seg], b[(i + 1) % seg], b[i])) for i in range(seg)]
    bm.faces.new(a[::-1])
    bm.faces.new(b)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    for fc in side:
        fc.smooth = True
    bm.to_mesh(me)
    bm.free()
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    return o


def _blade(name, length, w, t, mat):
    """A diamond-section blade along +y from 0 to `length` px, `w` wide and `t` thick, pointed (flat facets)."""
    me, bm = bpy.data.meshes.new(name), bmesh.new()
    sec = ((w / 2, 0.0), (0.0, t / 2), (-w / 2, 0.0), (0.0, -t / 2))
    base = [bm.verts.new((x * S, 0.0, z * S)) for x, z in sec]
    mid = [bm.verts.new((x * 0.8 * S, length * 0.86 * S, z * 0.8 * S)) for x, z in sec]
    tip = bm.verts.new((0.0, length * S, 0.0))
    for i in range(4):
        j = (i + 1) % 4
        bm.faces.new((base[i], base[j], mid[j], mid[i]))
        bm.faces.new((mid[i], mid[j], tip))
    bm.faces.new(base[::-1])
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    bm.to_mesh(me)
    bm.free()
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    return o


def _orb_mat(opts):
    """The gift's gold lens: gold with dark-gold and peach speckles, a tan rim at grazing angles, self-lit."""
    mat = bpy.data.materials.new("orb")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    noise = nt.nodes.new("ShaderNodeTexNoise")
    noise.inputs["Scale"].default_value = float(opts.get("orb_scale", 40.0))
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = 'CONSTANT'
    els = ramp.color_ramp.elements
    els[0].color = C._srgb(*opts.get("orb_dark", (173, 148, 0)))
    els[1].position = float(opts.get("orb_lo", 0.38))
    els[1].color = C._srgb(*opts.get("orb_gold", (210, 174, 0)))
    els.new(float(opts.get("orb_hi", 0.62))).color = C._srgb(*opts.get("orb_peach", (240, 198, 170)))
    lw = nt.nodes.new("ShaderNodeLayerWeight")
    lw.inputs["Blend"].default_value = float(opts.get("orb_rim", 0.3))
    mix = nt.nodes.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    mix.inputs["B"].default_value = C._srgb(*opts.get("orb_tan", (164, 152, 115)))
    nt.links.new(noise.outputs["Fac"], ramp.inputs["Fac"])
    nt.links.new(lw.outputs["Facing"], mix.inputs["Factor"])
    nt.links.new(ramp.outputs["Color"], mix.inputs["A"])
    nt.links.new(mix.outputs["Result"], bsdf.inputs["Base Color"])
    if bsdf.inputs.get("Emission Color") is not None:
        nt.links.new(mix.outputs["Result"], bsdf.inputs["Emission Color"])
        bsdf.inputs["Emission Strength"].default_value = float(opts.get("orb_emit", 0.5))
    # linked inputs ignore their defaults in Cycles; the live export reads them: the speckle's mean gold
    cdf = lambda x: 0.5 * (1.0 + math.erf((x - 0.5) / (0.1 * math.sqrt(2.0))))   # noise Fac ~ N(0.5, 0.1)
    lo, hi = float(opts.get("orb_lo", 0.38)), float(opts.get("orb_hi", 0.62))
    parts = ((cdf(lo), opts.get("orb_dark", (173, 148, 0))), (cdf(hi) - cdf(lo), opts.get("orb_gold", (210, 174, 0))),
             (1.0 - cdf(hi), opts.get("orb_peach", (240, 198, 170))))
    tan_w = float(opts.get("orb_live_tan", 0.35))                    # live: the grazing tan rim's share of the lens
    avg = [sum(w * c[i] for w, c in parts) * (1 - tan_w) + tan_w * opts.get("orb_tan", (164, 152, 115))[i]
           for i in range(3)]
    bsdf.inputs["Base Color"].default_value = C._srgb(*avg)
    if bsdf.inputs.get("Emission Color") is not None:
        g = float(opts.get("orb_live_emit", 0.8))
        bsdf.inputs["Emission Color"].default_value = C._srgb(*(v * g for v in avg))
    return mat


def _scuff(mat, rough, var, scale, aniso):
    """Scuffed / brushed steel: roughness rough +- var from fine noise, and an anisotropic highlight."""
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if aniso > 0 and bsdf.inputs.get("Anisotropic") is not None:
        bsdf.inputs["Anisotropic"].default_value = aniso
    if var <= 0:
        return
    nt = mat.node_tree
    nz, mr = nt.nodes.new("ShaderNodeTexNoise"), nt.nodes.new("ShaderNodeMapRange")
    nz.inputs["Scale"].default_value = scale
    nz.inputs["Detail"].default_value = 6.0
    mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = 0.3, 0.7
    mr.inputs["To Min"].default_value, mr.inputs["To Max"].default_value = max(0.02, rough - var), rough + var
    nt.links.new(nz.outputs["Fac"], mr.inputs["Value"])
    nt.links.new(mr.outputs["Result"], bsdf.inputs["Roughness"])


def _joint(name, parent):
    e = _empty(name, (0, 0, 0), parent)
    e.rotation_mode = 'QUATERNION'
    return e


def _aim(e, p, q):
    """Put joint empty `e` at p (px) with its -Y axis pointing at q."""
    e.location = tuple(v * S for v in p)
    d = Vector(q) - Vector(p)
    if d.length > 1e-6:
        e.rotation_quaternion = Vector((0.0, -1.0, 0.0)).rotation_difference(d.normalized())


def _ik(s, t, a, b, pole):
    """Two-bone IK: the middle joint of a chain s -a- m -b- t bending toward the `pole` direction; t is pulled in
    to the chain's reach. Returns (m, t')."""
    s, t, pole = Vector(s), Vector(t), Vector(pole)
    d = t - s
    u = d.normalized() if d.length > 1e-6 else Vector((0.0, -1.0, 0.0))
    ln = max(abs(a - b) + 1e-3, min(a + b - 1e-3, d.length))
    p = pole - u * pole.dot(u)
    if p.length < 1e-6:
        p = Vector((0.0, 0.0, 1.0)) - u * u.z
    p.normalize()
    ca = (a * a + ln * ln - b * b) / (2 * a * ln)
    return s + a * (ca * u + math.sqrt(max(0.0, 1.0 - ca * ca)) * p), s + u * ln


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    steel = C._mat("steel", C._srgb(*opts.get("steel", (175, 175, 180))), rough=f("rough", 0.35), spec=f("spec", 0.6),
                   metal=f("metal", 0.0))
    _scuff(steel, f("rough", 0.35), f("rough_var", 0.0), f("rough_scale", 60.0), f("aniso", 0.0))
    dark = C._mat("slit", C._srgb(*opts.get("slit", (20, 20, 22))), rough=0.9, spec=0.0)
    blade_m = C._mat("blade", C._srgb(*opts.get("blade", (220, 220, 228))), rough=f("blade_rough", 0.25), spec=0.8)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    upper = _empty("upper", (0, 0, 0), root)                          # everything the hips carry (dx, crouch)
    _rbox("hips", (0, f("hip_cy", 29.75), 0), (f("hip_hw", 7.0), f("hip_hh", 1.5), f("hip_hz", 4.0)), 2.0, steel).parent = upper
    for sx in (-1.0, 1.0):                                            # a small tasset lip over each thigh
        t = _rbox("tasset", (sx * f("tasset_x", 4.3), f("tasset_y", 27.5), f("tasset_z", 3.6)),
                  (f("tasset_hw", 2.5), f("tasset_hh", 1.5), 0.9), 0.8, steel)
        t.rotation_euler = (math.radians(-f("tasset_flare", 8.0)), sx * math.radians(f("tasset_out", 12.0)), 0.0)
        t.parent = upper
    y0, rx, rz = f("fauld_y", 31.0), f("fauld_rx", 7.3), f("fauld_rz", 4.4)
    for i in range(int(f("lames", 3))):                               # overlapping lames, each narrower at its top
        y = y0 + i * f("lame_step", 2.1)
        _frustum("lame", y, y + f("lame_h", 2.3), (rx + 0.5, rz + 0.4), (rx - 0.3, rz - 0.3), steel).parent = upper
    k = f("torso_k", 1.0)
    rings = [(y, r * k, d, c) for y, r, d, c in (tuple(v) for v in opts.get("torso_rings", (
        (37.0, 7.0, 4.2, 0.0), (39.5, 7.4, 4.6, 0.2), (43.0, 7.7, 5.0, 0.4), (46.5, 7.6, 4.9, 0.3), (49.0, 6.8, 4.2, 0.0),
        (50.5, 4.5, 3.0, 0.0))))]
    _lathe("breastplate", rings, steel).parent = upper
    _ell("ridge", (0, f("ridge_y", 43.5), f("ridge_z", 4.9)), (f("ridge_w", 0.8), f("ridge_h", 5.5), 0.9), steel, 16).parent = upper
    _frustum("gorget", 49.0, 54.0, (3.4, 3.0), (3.0, 2.7), steel).parent = upper
    for sx in (-1.0, 1.0):
        p = _rbox("pauldron", (sx * f("pauldron_x", 8.0), f("pauldron_y", 51.0), f("pauldron_z", 0.3)),
                  (f("pauldron_hw", 5.6), f("pauldron_hh", 2.5), f("pauldron_hz", 4.6)), f("pauldron_bevel", 1.6), steel)
        p.rotation_euler = (0.0, 0.0, -sx * math.radians(f("pauldron_droop", 0.0)))
        p.parent = upper
    hy, hr = f("helmet_y", 0.0), f("helmet_r", 5.4)
    hp = f("helm_point", 0.0)
    prof = ((54.0, 3.6, 3.4), (55.2, 4.9, 4.5), (56.5, 5.4, 5.0), (61.5, 5.4, 5.0), (62.2, 5.0, 4.6), (62.6, 3.0, 2.8))
    if hp > 0:                                                       # an ogive: the dome narrows to a point
        prof = ((54.0, 3.6, 3.4), (55.2, 4.9, 4.5), (56.5, 5.4, 5.0), (60.0, 5.4, 5.0), (61.5, 5.0, 4.6),
                (62.2 + hp * 0.3, 3.9, 3.6), (62.2 + hp * 0.65, 2.2, 2.0), (62.2 + hp * 0.9, 0.7, 0.65),
                (62.2 + hp, 0.05, 0.05))
    if hp > 0 and opts.get("helm_sharp"):                            # the 300 title: a straight cone, a crisp rim
        prof = ((54.0, 3.6, 3.4), (54.6, 5.2, 4.8), (56.5, 5.5, 5.1), (59.0, 5.5, 5.1), (59.4, 5.0, 4.6),
                (62.2 + hp, 0.05, 0.05))
    helm = _lathe("helmet", [(hy + y, r * hr / 5.4, d * hr / 5.4, 0.0) for y, r, d in prof], steel)
    helm.parent = upper
    if opts.get("helm_sharp") and helm.modifiers.get("sub"):
        helm.modifiers.remove(helm.modifiers["sub"])                  # keep the cone's point and the rim's edge
        for p in helm.data.polygons:
            p.use_smooth = True
    if hp > 0:
        bpy.ops.mesh.primitive_cone_add(vertices=12, radius1=0.9 * S, radius2=0.0, depth=f("finial_h", 3.0) * S,
                                        location=(0, (hy + 62.2 + hp - 0.6 + f("finial_h", 3.0) / 2) * S, 0),
                                        rotation=(-math.pi / 2, 0, 0))
    else:
        bpy.ops.mesh.primitive_cone_add(vertices=24, radius1=f("finial_r", 2.4) * S, radius2=0.0, depth=f("finial_h", 3.0) * S,
                                    location=(0, (hy + 62.2 + f("finial_h", 3.0) / 2) * S, 0), rotation=(-math.pi / 2, 0, 0))
    fin = bpy.context.active_object
    fin.name = "finial"
    fin.data.materials.append(steel)
    bpy.ops.object.shade_smooth()
    fin.parent = upper
    if opts.get("keel_wedge"):                                        # a sharp ridge down the face
        kd = f("keel_d", 0.9)
        kl = _rbox("keel", (0, hy + 58.0, hr * 0.92 - kd * 0.3), (kd, f("keel_h", 3.6), kd), 0.05, steel)
        kl.rotation_euler = (0.0, math.pi / 4, 0.0)
        kl.parent = upper
    else:
        _rbox("keel", (0, hy + 58.3, hr * 0.92), (0.5, 3.2, 0.6), 0.4, steel).parent = upper
    for sx in (-1.0, 1.0):
        _rbox("slot", (sx * 2.4, hy + f("slot_y", 59.3), hr * 0.86), (1.5, f("slot_h", 0.45), 0.5), 0.2, dark).parent = upper
    arms = {}
    ua, fa, ar, fd = f("uarm_l", 8.5), f("farm_l", 9.0), f("arm_r", 1.9), f("fist_d", 14.5)   # fd: elbow -> fist centre
    for side in ("l", "r"):                                          # screen left / right
        up = _joint("ua_" + side, root)
        _cyl("rerebrace", (0, -ua / 2, 0), ar, ua, steel, 0.5, up)
        lo = _joint("fa_" + side, root)
        _ell("couter", (0, 0, -0.3), (ar * 1.3,) * 3, steel, 16).parent = lo
        _cyl("vambrace", (0, -fa / 2, 0), ar * 0.92, fa, steel, 0.4, lo)
        _frustum("cuff", -(fa + 2.6), -(fa - 0.6), (ar * 1.4, ar * 1.4), (ar, ar), steel).parent = lo
        _rbox("fist", (0, -fd, 0.2), (f("fist_hw", 1.95), f("fist_hh", 3.8), f("fist_hz", 2.1)), 1.2, steel).parent = lo
        arms[side] = (up, lo)
    legs = {}
    lr, tl, sl = f("leg_r", 3.0), f("thigh_l", 18.0), f("shin_l", 5.0)
    for side in ("l", "r"):
        th = _joint("th_" + side, root)
        _frustum("cuisse", -tl - 0.5, 0.5, (lr, lr * 0.95), (lr + 0.5, lr + 0.3), steel).parent = th
        sh = _joint("sh_" + side, root)
        _cyl("greave", (0, -sl / 2 - 0.5, 0), lr * 0.95, sl + 1.5, steel, 0.5, sh)
        kn = _empty("knee_" + side, (0, 0, 0), root)
        _ell("poleyn", (0, 0, f("poleyn_z", 0.9)), (f("poleyn_rx", 3.5), f("poleyn_ry", 1.9), f("poleyn_rz", 3.3)), steel, 20).parent = kn
        ft = _empty("foot_" + side, (0, 0, 0), root)
        _rbox("sabaton", (0, 2.6, f("sabaton_z", 1.2)), (f("sabaton_hw", 3.3), 2.6, f("sabaton_hz", 4.2)), 1.6, steel).parent = ft
        legs[side] = (th, sh, kn, ft)
    sword = _empty("sword", (0, 0, 0), root)
    sword.rotation_mode = 'XYZ'                                       # tip toward the camera (x), then in the view plane (z)
    _cyl("grip", (0, -0.3, 0), 0.75, 5.0, steel, 0.2, sword)
    _ell("pommel", (0, -3.5, 0), (1.2, 1.2, 1.2), steel, 16).parent = sword
    _rbox("guard", (0, 2.8, 0), (f("guard_w", 4.2), 0.6, 0.75), 0.4, steel).parent = sword
    bl = _blade("blade", f("blade_l", 28.0), f("blade_w", 1.8), f("blade_t", 0.9), blade_m)
    bl.location = (0, 3.4 * S, 0)
    bl.parent = sword
    orb = _empty("orb", (f("orb_x", 0.8), f("orb_y", 46.5), f("orb_z", 7.0)), upper)
    orb.rotation_mode = 'YXZ'                                         # turn about y first, then lean in the view plane
    lens = _ell("lens", (0, 0, 0), (f("orb_rx", 10.5), f("orb_ry", 15.5), f("orb_rz", 3.0)), _orb_mat(opts), 32)
    lens.parent = orb
    lens.shape_key_add(name="basis")
    for key, sy in (("drop_up", 1.0), ("drop_dn", -1.0)):            # a teardrop: the half toward sy tapers to a point
        kb = lens.shape_key_add(name=key, from_mix=False)
        for v in kb.data:
            t = max(0.0, v.co.y * sy)
            v.co = (v.co.x * (1 - 0.85 * t), v.co.y * (1 + 0.2 * t), v.co.z * (1 - 0.85 * t))
    m = f("model_scale", 0.45)
    root.scale = (m, m, m)
    root.location = (f("model_dx", -3.5) * S * m, f("model_dy", -40.0) * S * m, 0)
    return {"root": root, "upper": upper, "arms": arms, "legs": legs, "sword": sword, "orb": orb, "lens": lens,
            "orb0": tuple(orb.location)}


def _frames_setup(opts):
    ctx = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    if f("env", 0.0) > 0:                                            # a blotchy sky for polished steel to reflect
        nt = bpy.context.scene.world.node_tree
        tc, nz = nt.nodes.new("ShaderNodeTexCoord"), nt.nodes.new("ShaderNodeTexNoise")
        nz.inputs["Scale"].default_value = f("env_scale", 3.0)
        nz.inputs["Detail"].default_value = f("env_detail", 2.0)
        mr = nt.nodes.new("ShaderNodeMapRange")
        mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = 0.35, 0.65
        mr.inputs["To Min"].default_value, mr.inputs["To Max"].default_value = 1.0 - f("env", 0.0), 1.0 + f("env", 0.0)
        nt.links.new(tc.outputs["Generated"], nz.inputs["Vector"])
        nt.links.new(nz.outputs["Fac"], mr.inputs["Value"])
        nt.links.new(mr.outputs["Result"], nt.nodes["Background"].inputs["Color"])
    ctx.update({"hip": (f("hip_x", 3.9), f("hip_y", 28.0)), "ankle": f("ankle_y", 5.0), "thigh": f("thigh_l", 18.0),
                "shin": f("shin_l", 5.0), "shoulder": (f("shoulder_x", 10.8), f("shoulder_y", 48.5), f("shoulder_z", 0.0)),
                "ua": f("uarm_l", 8.5), "fd": f("fist_d", 14.5), "gap": f("grip_gap", 3.6), "pivot": f("pivot_y", 31.0),
                "clear": opts.get("grip_clear"), "efwd": f("elbow_fwd", -0.5), "tip_fwd": bool(opts.get("tip_fwd")),
                "rings": [(y, r * f("torso_k", 1.0), d, c) for y, r, d, c in (tuple(v) for v in opts.get("torso_rings", (
                    (37.0, 7.0, 4.2, 0.0), (39.5, 7.4, 4.6, 0.2), (43.0, 7.7, 5.0, 0.4), (46.5, 7.6, 4.9, 0.3),
                    (49.0, 6.8, 4.2, 0.0), (50.5, 4.5, 3.0, 0.0))))]})
    return ctx


def _front_z(rings, x, y):
    """The breastplate's front depth at (x, y) px (0 outside its height or width)."""
    for (y0, rx0, rz0, c0), (y1, rx1, rz1, c1) in zip(rings, rings[1:]):
        if y0 <= y <= y1:
            t = (y - y0) / (y1 - y0)
            rx, rz, cz = rx0 + (rx1 - rx0) * t, rz0 + (rz1 - rz0) * t, c0 + (c1 - c0) * t
            return cz + rz * math.sqrt(max(0.0, 1.0 - min(1.0, abs(x) / rx) ** 2))
    return 0.0


def _frames_pose(ctx, pose):
    p = dict(POSE0)
    p.update(pose)
    g = lambda k: float(p.get(k, 0.0))
    dx, cr = g("dx"), g("crouch")
    ctx["root"].rotation_euler = (0.0, math.radians(g("yaw")), 0.0)
    rot = (Matrix.Rotation(math.radians(g("roll")), 3, 'Z') @ Matrix.Rotation(math.radians(g("twist")), 3, 'Y'))
    pv = Vector((dx, ctx["pivot"] - cr, 0.0))                        # the upper body turns about the waist
    turn = lambda q: rot @ (Vector(q) - pv) + pv
    ctx["upper"].rotation_euler = rot.to_euler('XYZ')
    ctx["upper"].location = tuple(c * S for c in turn((dx, -cr, 0.0)))
    hx, hy = ctx["hip"]
    for side, sx in (("l", -1.0), ("r", 1.0)):                        # legs: hip -> planted foot, knees forward
        th, sh, kn, ft = ctx["legs"][side]
        hip = (dx + sx * hx, hy - cr, 0.0)
        knee, ank = _ik(hip, (g("f" + side), ctx["ankle"], 0.0), ctx["thigh"], ctx["shin"], (sx * 0.15, 0.0, 1.0))
        _aim(th, hip, knee)
        _aim(sh, knee, ank)
        kn.location = tuple(v * S for v in knee)
        ft.location = (g("f" + side) * S, 0.0, 0.0)
    sw, st = math.radians(g("sw")), math.radians(g("st"))
    if ctx["tip_fwd"]:
        st = abs(st)                                                 # same projection, tip toward the camera
    v = Vector((math.sin(sw) * math.cos(st), math.cos(sw) * math.cos(st), math.sin(st)))
    hz = g("hz")
    if ctx["clear"] is not None:                                     # the fist stays in front of the breastplate
        hz = max(hz, _front_z(ctx["rings"], g("hx"), g("hy") - cr) + float(ctx["clear"]))
    grip = Vector((dx + g("hx"), g("hy") - cr, hz))
    ctx["sword"].location = tuple(c * S for c in grip)
    ctx["sword"].rotation_euler = (st, 0.0, -sw)
    sxo, syo, szo = ctx["shoulder"]
    for side, sx in (("l", -1.0), ("r", 1.0)):                        # arms: shoulder -> fist, elbows out and down
        up, lo = ctx["arms"][side]
        s = turn((dx + sx * sxo, syo - cr, szo))
        if side == "r":
            t = grip
        else:
            rest = s + Vector((-0.8, 0.2 - ctx["ua"] - ctx["fd"], 0.5))
            t = rest.lerp(grip - v * ctx["gap"], min(1.0, max(0.0, g("grip2"))))
        elbow, _ = _ik(s, t, ctx["ua"], ctx["fd"], (sx * 0.5, -1.0, ctx["efwd"]))
        _aim(up, s, elbow)
        _aim(lo, elbow, t)
    r = g("glow")
    ctx["lens"].hide_render = r <= 0.02
    ctx["orb"].scale = (max(r, 0.02),) * 3
    ctx["orb"].rotation_euler = (0.0, math.radians(g("turn")), math.radians(g("lean")))
    x0, y0, z0 = ctx["orb0"]
    ctx["orb"].location = (x0 + g("ox") * S, y0 + g("oy") * S, z0)
    kb = ctx["lens"].data.shape_keys.key_blocks
    kb["drop_up"].value = min(1.0, max(0.0, g("drop")))
    kb["drop_dn"].value = min(1.0, max(0.0, -g("drop")))


register_frames("knight", _frames_setup, _frames_pose)
