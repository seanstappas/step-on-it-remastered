"""soi3d.builders.gargoyle -- the Gargoyle (Gargoyle_sprites f02-f74): a stone bat-winged creature facing the camera.

In SD pixel units of the 84x75 cell (origin = between the feet, +y up, +z toward the camera): two thin LEGS with
white claws, an egg-shaped BODY, a round HEAD with long horizontal pointed EARS and dark eye sockets, and two
bat WINGS (a leading-edge spar out to the tip and a scalloped membrane) hinged at the shoulders. All stone grey.
The red striped EGG it carries on its head is egg.py's cushion (opts "egg" = master_egg's options).
Pose: "spread" (deg, both wings about the view axis: -90 = hanging down, 0 = level, + = raised), "wrap" (deg,
wings folded forward around the body: 0 = flat), "crouch" (px the upper body sits lower, the legs shortened),
"egg" (egg scale, 0 = none), "egg_y" (px the egg sits below its place above the head: it rises out of the
chest over f42-f48), "scroll" (the egg's band scroll, px).
Optional (default off): opts "arms" adds two-segment stone ARMS at the wing roots (pose "arm", deg about the
view axis: 0 = hanging, 180 = raised beside the head; "elbow", deg: + bends the raised forearm toward the head);
"horn_loops" swaps the pointed ears for two looped HORNS (tori facing the camera); "ball" swaps the striped
cushion for a red SPHERE with vertical dark stripes that spins with "scroll" ("ball_gores" > 0: that many dark
MERIDIAN gores, "ball_duty" of their period wide, instead of planar bands, which show a bullseye when spun side
on); "cloak" adds the wings wrapped
IN FRONT of the body as a curved stone shell hanging from the shoulders (pose "cloak": 0 = none, 1 = its full
"cloak_h" length); "wing_ribs" > 0 pleats the wing albedo; "wing_lo" (px) pushes the wing's lower membrane
(y < -10 px below the shoulder) outward; "burst_n" > 0 (with "ball") adds that many chunks of
the ball (`frag_f` ball radii, `frag_long` x as wide) for pose "burst" (0 = the whole ball, 1 = the chunks spread
on a horizontal ring `burst_r0` + `burst_spread` ball radii wide, shrunk by `burst_shrink`: the ball bursting as it
is thrown, f68-f74).
Opt-in anatomy (f17-f35 at 10x: a muscular humanoid, not an egg): "torso2" (chest + pecs + abdomen + pelvis instead of
the egg body), "face" (brow ridge, eye glints in the sockets, snout, a dark mouth with a row of teeth), "legs2" (thigh,
knee, shin and a clawed foot) and "wing_pleats" (N accordion folds as GEOMETRY, so the vertical light/dark bands of
the source come from the light and survive the live renderer; "pleat_amp" px).
The whole model is scaled by `model_scale` and moved by `model_dy` px to fit the sweep camera.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .egg import build as egg_build
from .quadruped import S, _ell, _stripes
from .robo import _cyl, _empty
from .tile import _prism

# relative to the shoulder (5, 50); from f30's per-row half-widths: level top edge at y 52 out to 37.5 px, the
# lower edge tapering back to the body at y 28 (the membrane fills solid to the body)
WING = [(0, 3), (32.5, 3), (32.5, 0), (31.5, -2), (30.5, -4), (29.5, -6), (28, -8), (26.5, -10), (24, -12), (19, -14),
        (17, -16), (15, -18), (13.5, -20), (12, -22), (0, -22)]
EAR = [(-2, -3.5), (4, -3.5), (12, -2), (17, 0.5), (14, 2.5), (5, 5), (-2, 5.5)]   # CCW, y up; f30 rows 11-20 to +-22 px


def _pleated_wing(name, pts, sx, n, amp, thick, mat):
    """The WING outline (top edge y = pts[0][1], lower edge = the rest) as 2n accordion strips folding +-amp in z,
    solidified; x mirrored by sx. pts are SD px (already scaled by wing_f / wing_fy)."""
    top = pts[0][1]
    span = max(x for x, _ in pts)
    low = sorted({(x, y) for x, y in pts[2:]})                         # the lower edge, by x

    def bottom(x):
        for (x0, y0), (x1, y1) in zip(low, low[1:]):
            if x0 <= x <= x1:
                return y0 + (y1 - y0) * ((x - x0) / (x1 - x0) if x1 > x0 else 0.0)
        return low[0][1] if x < low[0][0] else low[-1][1]
    verts, faces = [], []
    for i in range(2 * n + 1):
        x = span * i / (2 * n)
        z = 0.0 if i == 0 else (amp if i % 2 else -amp)
        verts += [(sx * x * S, top * S, z * S), (sx * x * S, bottom(x) * S, z * S)]
        if i:
            a, b = 2 * (i - 1), 2 * i
            faces.append((a, b, b + 1, a + 1) if sx > 0 else (a, a + 1, b + 1, b))
    me = bpy.data.meshes.new(name)
    me.from_pydata(verts, [], faces)
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    sol = o.modifiers.new("solid", 'SOLIDIFY')
    sol.thickness = thick * S
    sol.offset = 0.0
    return o


# the lean torso of f30 (per-row half-widths; y SD px, rx half-width, rz half-depth, cz depth centre)
TORSO = [(23.0, 3.0, 2.0, 0.0), (25.0, 6.0, 3.5, 0.0), (28.0, 6.5, 4.0, 0.2), (32.0, 5.8, 3.8, 0.4),
         (37.0, 7.0, 4.3, 0.5), (42.0, 8.5, 5.0, 0.5), (48.0, 9.0, 5.0, 0.3), (52.0, 8.0, 4.0, 0.0), (54.0, 4.0, 2.5, 0.0)]


def _lathe(name, rings, mat, seg=24):
    """A smooth body through elliptical rings [(y, rx, rz, cz)] (SD px, bottom to top), capped and subdivided."""
    import bmesh
    bm = bmesh.new()
    loops = [[bm.verts.new((rx * math.sin(2 * math.pi * i / seg) * S, y * S, (cz + rz * math.cos(2 * math.pi * i / seg)) * S))
              for i in range(seg)] for y, rx, rz, cz in rings]
    for a, b in zip(loops, loops[1:]):
        for i in range(seg):
            bm.faces.new((a[i], a[(i + 1) % seg], b[(i + 1) % seg], b[i]))
    bm.faces.new(loops[0][::-1])
    bm.faces.new(loops[-1])
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    for p in me.polygons:
        p.use_smooth = True
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    o.modifiers.new("sub", 'SUBSURF').levels = 2
    return o


def _torso_z(rings, x, y):
    """The lathed torso's front surface depth at (x, y)."""
    for (y0, rx0, rz0, c0), (y1, rx1, rz1, c1) in zip(rings, rings[1:]):
        if y0 <= y <= y1:
            t = (y - y0) / (y1 - y0)
            rx, rz, cz = rx0 + (rx1 - rx0) * t, rz0 + (rz1 - rz0) * t, c0 + (c1 - c0) * t
            return cz + rz * math.sqrt(max(0.0, 1.0 - min(1.0, abs(x) / rx) ** 2))
    return 0.0


def _wing_mat(opts, rgb, span):
    """Stone whose albedo ramps from `wing_root_gain` at the shoulder to `wing_tip_gain` at the tip (|object x|)."""
    f = lambda k, d: float(opts.get(k, d))
    mat = bpy.data.materials.new("wing_stone")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = f("wing_rough", f("rough", 0.6))
    if "wing_spec" in opts and bsdf.inputs.get("Specular IOR Level") is not None:
        bsdf.inputs["Specular IOR Level"].default_value = f("wing_spec", 0.5)
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
    ribs = f("wing_ribs", 0.0)
    if ribs <= 0:
        nt.links.new(ramp.outputs["Color"], bsdf.inputs["Base Color"])
        return mat
    # vertical pleats: the albedo dips to `rib_dark` in `wing_ribs` bands across the span
    sn, mul, band = nt.nodes.new("ShaderNodeMath"), nt.nodes.new("ShaderNodeMath"), nt.nodes.new("ShaderNodeMapRange")
    mul.operation, mul.inputs[1].default_value = 'MULTIPLY', 2 * math.pi * ribs / span
    sn.operation = 'COSINE'
    band.inputs["From Min"].default_value, band.inputs["From Max"].default_value = -1.0, 1.0
    band.inputs["To Min"].default_value, band.inputs["To Max"].default_value = f("rib_dark", 0.6), 1.0
    nt.links.new(ab.outputs[0], mul.inputs[0])
    nt.links.new(mul.outputs[0], sn.inputs[0])
    nt.links.new(sn.outputs[0], band.inputs["Value"])
    mix = nt.nodes.new("ShaderNodeMix")
    mix.data_type, mix.blend_type = 'RGBA', 'MULTIPLY'
    mix.inputs["Factor"].default_value = 1.0
    nt.links.new(ramp.outputs["Color"], mix.inputs["A"])
    comb = nt.nodes.new("ShaderNodeCombineXYZ")
    for i in range(3):
        nt.links.new(band.outputs["Result"], comb.inputs[i])
    nt.links.new(comb.outputs[0], mix.inputs["B"])
    nt.links.new(mix.outputs["Result"], bsdf.inputs["Base Color"])
    return mat


def _gores(rgb_dark, rgb_red, n, duty):
    """`n` dark MERIDIAN gores (poles on the object's local Y = the spin axis), each `duty` of its period wide."""
    m = C._mat("gores", C._srgb(*rgb_red), rough=0.35, spec=0.3)
    N, L = m.node_tree.nodes, m.node_tree.links
    tc, sep = N.new("ShaderNodeTexCoord"), N.new("ShaderNodeSeparateXYZ")
    L.new(tc.outputs["Object"], sep.inputs[0])
    az, mul, cs = N.new("ShaderNodeMath"), N.new("ShaderNodeMath"), N.new("ShaderNodeMath")
    az.operation, mul.operation, cs.operation = 'ARCTAN2', 'MULTIPLY', 'COSINE'
    mul.inputs[1].default_value = n
    L.new(sep.outputs[0], az.inputs[0])
    L.new(sep.outputs[2], az.inputs[1])
    L.new(az.outputs[0], mul.inputs[0])
    L.new(mul.outputs[0], cs.inputs[0])
    mr = N.new("ShaderNodeMapRange")                                  # dark where cos(n * azimuth) > cos(pi * duty)
    mr.clamp = True
    t = math.cos(math.pi * duty)
    mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = t - 0.06, t + 0.06
    L.new(cs.outputs[0], mr.inputs["Value"])
    mix = N.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    L.new(mr.outputs["Result"], mix.inputs["Factor"])
    mix.inputs["A"].default_value = C._srgb(*rgb_red)
    mix.inputs["B"].default_value = C._srgb(*rgb_dark)
    L.new(mix.outputs["Result"], N.get("Principled BSDF").inputs["Base Color"])
    return m


def build(opts):
    f = lambda k, d: float(opts.get(k, d))
    egg, scroll = egg_build(dict(opts.get("egg", {})))                  # clears the scene; the egg comes first
    if opts.get("ball"):
        bpy.data.objects.remove(egg, do_unlink=True)
        br = f("ball_r", 11.0)
        if f("ball_gores", 0) > 0:                                      # meridian gores: they slide, never face on
            ball_m = _gores(opts.get("ball_dark", (90, 0, 0)), opts.get("ball_red", (255, 20, 20)),
                            int(f("ball_gores", 0)), f("ball_duty", 0.3))
        else:
            ball_m = _stripes(opts.get("ball_dark", (90, 0, 0)), opts.get("ball_red", (255, 20, 20)),
                              f("ball_freq", 3.0))
        egg = _ell("ball", (0, 0, 0), (br, br, br), ball_m, 32)
        bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)   # the pose scales it by "egg"
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
        if opts.get("legs2"):                                           # thigh, knee, shin, clawed foot
            lr, kn = f("leg_r", 2.0), hip_y * f("knee_f", 0.5)
            _cyl("thigh", (0, -kn / 2, 0), lr * f("thigh_f", 1.35), kn, stone, 0.6, hp)
            _ell("knee", (0, -kn, 0.3), (lr * 1.15, lr * 1.0, lr * 1.2), stone, 16).parent = hp
            _cyl("shin", (0, -(kn + hip_y) / 2, 0), lr * f("shin_f", 0.95), hip_y - kn, stone, 0.5, hp)
            fh = f("foot_h", 1.1)
            _rbox("claw", (0, -hip_y + fh - 0.1, 1.2), (lr * f("foot_w", 1.4), fh, 2.6), 0.5, claw).parent = hp
            legs.append(hp)
            continue
        _cyl("leg", (0, -hip_y / 2, 0), f("leg_r", 2.0), hip_y, stone, 0.4, hp)
        _rbox("claw", (0, -hip_y + 1.2, 1.0), (f("leg_r", 2.0) * 1.3, 1.2, 2.0), 0.5, claw).parent = hp
        legs.append(hp)
    by = f("body_y", 37.0)                                            # up to the shoulders: f30 has no gap between the wings
    if opts.get("torso3"):                                            # one smooth lean torso + flat pecs (+ strap)
        k = f("torso_k", 1.0)
        rings = [(y, rx * k, rz, cz) for y, rx, rz, cz in (tuple(r) for r in opts.get("torso_rings", TORSO))]
        _lathe("torso", rings, body_m).parent = upper
        py = f("pec_y", 46.0)
        for sx in (-1.0, 1.0):
            px = sx * f("pec_x", 4.2)
            _ell("pec", (px, py, _torso_z(rings, px, py) - 0.4), (f("pec_rx", 3.8), f("pec_ry", 2.6), f("pec_rz", 1.0)),
                 body_m, 24).parent = upper
        if opts.get("strap"):
            (x0, y0), (x1, y1) = opts.get("strap_from", (6.5, 50.0)), opts.get("strap_to", (-5.5, 29.0))
            cu = bpy.data.curves.new("strap", 'CURVE')
            cu.dimensions = '3D'
            cu.bevel_depth = f("strap_t", 0.6) * S
            sp = cu.splines.new('POLY')
            sp.points.add(11)
            for i, p in enumerate(sp.points):
                t = i / 11.0
                x, y = x0 + (x1 - x0) * t, y0 + (y1 - y0) * t
                p.co = (x * S, y * S, (_torso_z(rings, x, y) + 0.2) * S, 1.0)
            o = bpy.data.objects.new("strap", cu)
            bpy.context.collection.objects.link(o)
            o.data.materials.append(C._mat("strap", C._srgb(*gain("strap_gain")), rough=f("rough", 0.6), spec=f("spec", 0.2)))
            o.parent = upper
    elif opts.get("torso2"):                                          # chest + pecs over an abdomen and pelvis
        cy = f("chest_y", 43.0)
        _ell("chest", (0, cy, 0.5), (f("chest_rx", 9.5), f("chest_ry", 7.5), f("chest_rz", 5.0)), body_m, 32).parent = upper
        for sx in (-1.0, 1.0):
            _ell("pec", (sx * f("pec_x", 4.2), cy + f("pec_dy", 1.2), f("pec_z", 4.2)),
                 (f("pec_rx", 4.0), f("pec_ry", 3.2), 1.8), body_m, 24).parent = upper
        _ell("abdomen", (0, f("abd_y", 34.0), 0.3), (f("abd_rx", 6.8), f("abd_ry", 6.5), 4.3), body_m, 24).parent = upper
        _ell("pelvis", (0, f("pelvis_y", 27.5), 0), (f("pelvis_rx", 6.5), 4.0, 4.0), body_m, 24).parent = upper
    else:
        _ell("body", (0, by, 0), (f("body_rx", 8.0), f("body_ry", 14.0), f("body_rz", 5.0)), body_m, 32).parent = upper
    hy, hr = f("head_y", 57.0), f("head_r", 5.5)
    _ell("head", (0, hy, 0), (hr, hr * 0.95, hr * 0.9), stone, 32).parent = upper
    if opts.get("face"):                                              # brow ridge, glints, snout, mouth + teeth
        glint = C._mat("glint", C._srgb(*opts.get("glint", (200, 200, 205))), rough=0.3, spec=0.4)
        _ell("brow", (0, hy + f("brow_dy", 1.4), hr * 0.72), (hr * 0.8, 0.9, 1.2), stone, 16).parent = upper
        _ell("snout", (0, hy - 0.9, hr * 0.9), (1.1, 1.3, 1.0), stone, 12).parent = upper
        _ell("mouth", (0, hy + f("mouth_dy", -2.7), hr * 0.8), (hr * f("mouth_w", 0.55), 0.85, 0.7), dark, 16).parent = upper
        _rbox("teeth", (0, hy + f("mouth_dy", -2.7) + 0.2, hr * 0.84), (hr * f("mouth_w", 0.55) * 0.8, 0.35, 0.3), 0.1,
              claw).parent = upper
        for sx in (-1.0, 1.0):
            _ell("glint", (sx * hr * 0.4, hy + 0.4, hr * 0.86), (0.45, 0.45, 0.3), glint, 8).parent = upper
    for sx in (-1.0, 1.0):
        _ell("socket", (sx * hr * 0.4, hy + 0.5, hr * 0.75), (1.2, 1.0, 0.6), dark, 12).parent = upper
        if opts.get("horn_loops"):
            bpy.ops.mesh.primitive_torus_add(major_radius=f("horn_R", 5.0) * S, minor_radius=f("horn_r", 1.4) * S,
                                             major_segments=32, minor_segments=12)
            horn = bpy.context.active_object
            horn.name = "horn"
            horn.data.materials.append(stone)
            bpy.ops.object.shade_smooth()
            horn.parent = upper
            horn.location = (sx * f("horn_x", 11.0) * S, (hy + f("horn_dy", 2.0)) * S, 0)
            horn.rotation_euler = (0, 0, sx * math.radians(f("horn_tilt", 0.0)))
            horn.scale = (f("horn_sx", 1.0), f("horn_sy", 1.0), 1.0)
            continue
        ear = _prism("ear", [(x * S, y * S) for x, y in (EAR if sx > 0 else [(-x, y) for x, y in EAR][::-1])], -0.8 * S, 1.6 * S, stone, 0.3 * S)
        ear.parent = upper
        ear.location = (sx * hr * 0.8 * S, (hy + f("ear_dy", 0.0)) * S, 0)
        ear.rotation_euler = (0, 0, sx * math.radians(f("ear_up", 0.0)))
    wings = []
    for sx in (-1.0, 1.0):
        sh = _empty("shoulder", (sx * f("shoulder_x", 5.0), f("shoulder_y", 50.0), -1.0), upper)
        sh.rotation_mode = 'ZXY'                                     # spread in the view plane first, then wrap
        lo = f("wing_lo", 0.0)                                         # px outward at the wing's lower edge
        pts = [(x * f("wing_f", 1.0) + (lo * min(1.0, max(0.0, (-10.0 - y) / 6.0)) if x > 0 else 0.0),
                y * f("wing_fy", 1.0)) for x, y in WING]
        if f("wing_pleats", 0.0) > 0:
            w = _pleated_wing("wing", pts, sx, int(f("wing_pleats", 0.0)), f("pleat_amp", 1.2), 0.8, wing_m)
            w.parent = sh
            wings.append((sh, sx))
            continue
        pts = pts[::-1] if sx > 0 else [(-x, y) for x, y in pts]        # counter-clockwise on either side
        w = _prism("wing", [(x * S, y * S) for x, y in pts], -0.4 * S, 0.8 * S, wing_m, 0.2 * S)
        w.parent = sh
        wings.append((sh, sx))
    arms = []
    if opts.get("arms"):
        ar, ua, fa = f("arm_r", 1.3), f("uarm_l", 10.0), f("farm_l", 9.0)
        for sx in (-1.0, 1.0):
            sh = _empty("arm", (sx * f("arm_x", 6.0), f("arm_y", 48.0), 1.0), upper)
            _cyl("uarm", (0, -ua / 2, 0), ar, ua, stone, 0.4, sh)
            el = _empty("elbow", (0, -ua, 0), sh)
            _cyl("farm", (0, -fa / 2, 0), ar * 0.9, fa, stone, 0.4, el)
            _ell("hand", (0, -fa, 0), (ar * 1.4,) * 3, stone, 12).parent = el
            arms.append((sh, el, sx))
    cloak = None
    if opts.get("cloak"):
        import bmesh
        me, bm = bpy.data.meshes.new("cloak"), bmesh.new()
        cr, deg, ch = f("cloak_r", 13.0), f("cloak_deg", 70.0), f("cloak_h", 26.0)
        ring = []
        for i in range(17):
            t = math.radians(-deg + 2 * deg * i / 16)
            x, z = math.sin(t) * cr * S, (math.cos(t) - f("cloak_back", 0.5)) * cr * S   # front clears body_rz
            ring.append((bm.verts.new((x, -ch * S, z)), bm.verts.new((x, 0.0, z))))
        for i in range(16):
            bm.faces.new((ring[i][0], ring[i + 1][0], ring[i + 1][1], ring[i][1]))
        bm.to_mesh(me)
        bm.free()
        cloak = bpy.data.objects.new("cloak", me)
        bpy.context.collection.objects.link(cloak)
        sol = cloak.modifiers.new("solid", 'SOLIDIFY')
        sol.thickness = 0.8 * S
        cloak.data.materials.append(wing_m)
        for p in me.polygons:
            p.use_smooth = True
        cloak.parent = upper
        cloak.location = (0, f("cloak_y", 50.0) * S, 0)
    egg.parent = upper
    k = f("egg_scale", 0.6)
    egg.location = (0, (hy + hr + f("egg_dy", 5.0)) * S, 0)
    egg.scale = (k, k, k)
    frags = []
    if opts.get("ball") and f("burst_n", 0) > 0:
        fr = f("ball_r", 11.0) * f("frag_f", 0.35)
        frag_m = C._mat("frag", C._srgb(*opts.get("ball_red", (255, 20, 20))), rough=0.35, spec=0.3)
        for i in range(int(f("burst_n", 0))):
            o = _ell("frag", (0, 0, 0), (fr * f("frag_long", 1.0), fr, fr * 0.8), frag_m, 16)
            bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
            o.parent = upper
            o.hide_render = True
            frags.append(o)
    m = f("model_scale", 0.5)
    root.scale = (m, m, m)
    root.location = (0, f("model_dy", -37.0) * S * m, 0)
    return root, upper, legs, wings, egg, scroll, arms, cloak, frags


def _frames_setup(opts):
    root, upper, legs, wings, egg, scroll, arms, cloak, frags = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"upper": upper, "legs": legs, "wings": wings, "egg": egg, "scroll": scroll, "hip_y": f("hip_y", 22.0),
            "egg_k": f("egg_scale", 0.6), "egg_y0": egg.location.y, "arms": arms, "ball": bool(opts.get("ball")),
            "spin": f("ball_spin", 12.0), "cloak": cloak, "frags": frags, "br": f("ball_r", 11.0) * S,
            "burst": (f("burst_r0", 0.6), f("burst_spread", 2.2), f("burst_shrink", 0.7))}


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
    if ctx["ball"]:                                                  # stripes along local Z -> world X, spun about Y
        ctx["egg"].rotation_euler = (0, math.pi / 2 + math.radians(g("scroll") * ctx["spin"]), 0)
    t = g("burst")
    if ctx["frags"]:
        r0, spread, shrink = ctx["burst"]
        k = ctx["egg_k"] * max(e, 0.02)
        if t > 0.001:
            ctx["egg"].hide_render = True
        n, (ex, ey, ez) = len(ctx["frags"]), ctx["egg"].location
        for i, o in enumerate(ctx["frags"]):
            a = 2 * math.pi * i / n + math.radians(g("scroll") * ctx["spin"])
            rr = ctx["br"] * k * (r0 + t * spread)
            o.location = (ex + rr * math.cos(a), ey + ctx["br"] * k * 0.35 * (1 - t) * math.sin(3 * a), ez + rr * math.sin(a))
            o.scale = (k * max(0.02, 1 - t * shrink),) * 3
            o.hide_render = t <= 0.001 or e <= 0.02
    for sh, el, sx in ctx["arms"]:
        sh.rotation_euler = (0, 0, sx * math.radians(g("arm")))
        el.rotation_euler = (0, 0, sx * math.radians(g("elbow")))
    if ctx["cloak"] is not None:
        k = g("cloak")
        ctx["cloak"].hide_render = k <= 0.02
        ctx["cloak"].scale = (1.0, max(k, 0.02), 1.0)


register_frames("gargoyle", _frames_setup, _frames_pose)
