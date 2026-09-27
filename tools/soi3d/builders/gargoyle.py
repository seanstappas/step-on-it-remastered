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
cushion for a red SPHERE with vertical dark stripes that spins with "scroll"; "cloak" adds the wings wrapped
IN FRONT of the body as a curved stone shell hanging from the shoulders (pose "cloak": 0 = none, 1 = its full
"cloak_h" length); "wing_ribs" > 0 pleats the wing albedo.
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


def build(opts):
    f = lambda k, d: float(opts.get(k, d))
    egg, scroll = egg_build(dict(opts.get("egg", {})))                  # clears the scene; the egg comes first
    if opts.get("ball"):
        bpy.data.objects.remove(egg, do_unlink=True)
        br = f("ball_r", 11.0)
        egg = _ell("ball", (0, 0, 0), (br, br, br), _stripes(opts.get("ball_dark", (90, 0, 0)),
                   opts.get("ball_red", (255, 20, 20)), f("ball_freq", 3.0)), 32)
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
        _cyl("leg", (0, -hip_y / 2, 0), f("leg_r", 2.0), hip_y, stone, 0.4, hp)
        _rbox("claw", (0, -hip_y + 1.2, 1.0), (f("leg_r", 2.0) * 1.3, 1.2, 2.0), 0.5, claw).parent = hp
        legs.append(hp)
    by = f("body_y", 37.0)                                            # up to the shoulders: f30 has no gap between the wings
    _ell("body", (0, by, 0), (f("body_rx", 8.0), f("body_ry", 14.0), f("body_rz", 5.0)), body_m, 32).parent = upper
    hy, hr = f("head_y", 57.0), f("head_r", 5.5)
    _ell("head", (0, hy, 0), (hr, hr * 0.95, hr * 0.9), stone, 32).parent = upper
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
        pts = [(x * f("wing_f", 1.0), y * f("wing_fy", 1.0)) for x, y in WING]
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
    m = f("model_scale", 0.5)
    root.scale = (m, m, m)
    root.location = (0, f("model_dy", -37.0) * S * m, 0)
    return root, upper, legs, wings, egg, scroll, arms, cloak


def _frames_setup(opts):
    root, upper, legs, wings, egg, scroll, arms, cloak = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"upper": upper, "legs": legs, "wings": wings, "egg": egg, "scroll": scroll, "hip_y": f("hip_y", 22.0),
            "egg_k": f("egg_scale", 0.6), "egg_y0": egg.location.y, "arms": arms, "ball": bool(opts.get("ball")),
            "spin": f("ball_spin", 12.0), "cloak": cloak}


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
    for sh, el, sx in ctx["arms"]:
        sh.rotation_euler = (0, 0, sx * math.radians(g("arm")))
        el.rotation_euler = (0, 0, sx * math.radians(g("elbow")))
    if ctx["cloak"] is not None:
        k = g("cloak")
        ctx["cloak"].hide_render = k <= 0.02
        ctx["cloak"].scale = (1.0, max(k, 0.02), 1.0)


register_frames("gargoyle", _frames_setup, _frames_pose)
