"""soi3d.builders.beenie -- the Beenie (beenie_sprites f66-f121): a kid in a propeller beanie with a green blaster.

The players' rig (kid.py) in blue (sweater and trousers), white socks, red shoes and dark hair, with:
  a BEANIE: a dome over the head in three colour gores (`gores`, red / blue / green around the vertical axis;
            "gore_faces" = per-face materials instead of the shader, so the live rig carries them),
            a red BILL at the front and a PROPELLER on top (a red blade on a post; pose key "prop", deg)
  a BLASTER in the near fist: a green rounded body with a barrel pointing forward (-X at yaw 0) and a grip;
            pose key "gun" (deg) turns it in the fist's side plane (0 = level forward).
Opts "s_n0"/"e_n0"/... (kid.py) give the base arm pose, e.g. the blaster held at the chest.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .kid import build as kid_build
from .kid import _frames_pose as kid_pose
from .kid import base_pose
from .quadruped import S
from .robo import _cyl, _empty


def _gore_mat(opts):
    """Three equal colour gores around the object's vertical (local z of a UV sphere)."""
    mat = bpy.data.materials.new("gores")
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = float(opts.get("cap_rough", 0.4))
    tc = nt.nodes.new("ShaderNodeTexCoord")
    sep = nt.nodes.new("ShaderNodeSeparateXYZ")
    nt.links.new(tc.outputs["Object"], sep.inputs["Vector"])
    ang = nt.nodes.new("ShaderNodeMath")
    ang.operation = 'ARCTAN2'
    nt.links.new(sep.outputs["Y"], ang.inputs[0])
    nt.links.new(sep.outputs["X"], ang.inputs[1])
    u = nt.nodes.new("ShaderNodeMapRange")                             # angle -> [0, 1) turned by cap_turn
    u.inputs["From Min"].default_value = -math.pi
    u.inputs["From Max"].default_value = math.pi
    u.inputs["To Max"].default_value = float(opts.get("cap_reps", 1))   # 2: six gores, opposite ones alike (SD f66 = f98)
    nt.links.new(ang.outputs["Value"], u.inputs["Value"])
    turn = nt.nodes.new("ShaderNodeMath")
    turn.operation = 'ADD'
    turn.inputs[1].default_value = float(opts.get("cap_turn", 0.0)) / 360.0
    nt.links.new(u.outputs["Result"], turn.inputs[0])
    wrap = nt.nodes.new("ShaderNodeMath")
    wrap.operation = 'FRACT'
    nt.links.new(turn.outputs["Value"], wrap.inputs[0])
    ramp = nt.nodes.new("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = 'CONSTANT'
    cols = opts.get("gores", [[210, 0, 0], [0, 0, 210], [0, 160, 0]])
    els = ramp.color_ramp.elements
    els[0].position, els[0].color = 0.0, C._srgb(*cols[0])
    els[1].position, els[1].color = 1.0 / 3.0, C._srgb(*cols[1])
    e3 = els.new(2.0 / 3.0)
    e3.color = C._srgb(*cols[2])
    nt.links.new(wrap.outputs["Value"], ramp.inputs["Fac"])
    nt.links.new(ramp.outputs["Color"], bsdf.inputs["Base Color"])
    return mat


def _gore_faces(cap, opts):
    """The same gores as flat materials assigned per face by azimuth: the live renderer keeps only Principled values."""
    cols = opts.get("gores", [[210, 0, 0], [0, 0, 210], [0, 160, 0]])
    for i, c in enumerate(cols):
        cap.data.materials.append(C._mat("gore%d" % i, C._srgb(*c), rough=float(opts.get("cap_rough", 0.4))))
    reps, turn = float(opts.get("cap_reps", 1)), float(opts.get("cap_turn", 0.0)) / 360.0
    for p in cap.data.polygons:
        u = ((math.atan2(p.center.y, p.center.x) + math.pi) / (2 * math.pi) * reps + turn) % 1.0
        p.material_index = min(len(cols) - 1, int(u * len(cols)))


def build(opts):
    root, arms, legs = kid_build(opts)
    f = lambda k, d: float(opts.get(k, d))
    white = C._mat("sock", C._srgb(*opts.get("socks", (240, 240, 240))), rough=f("rough", 0.45), spec=f("spec", 0.25))
    for side in ("n", "f"):                                            # white socks: the shin's lower half
        kn = legs[side][1]
        _cyl("sock_" + side, (0, -f("shin_l", 5.0) * 0.78, 0), f("leg_r", 1.6) * 1.02, f("shin_l", 5.0) * 0.44, white, 0.3, kn)
    hy, hr = f("head_y", 14.0), f("head_r", 3.3)
    cy = hy + hr * f("cap_dy", 0.3)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=S, segments=48, ring_count=24, location=(0, cy * S, 0), rotation=(math.pi / 2, 0, 0))
    cap = bpy.context.active_object                                    # local z = world up (the gores turn about it)
    cap.name = "cap"
    cr = hr * f("cap_f", 1.08)
    cap.scale = (cr, cr, cr * f("cap_fy", 0.75))
    if opts.get("gore_faces"):
        _gore_faces(cap, opts)
    else:
        cap.data.materials.append(_gore_mat(opts))
    bpy.ops.object.shade_smooth()
    cap.parent = root
    red = C._mat("bill", C._srgb(*opts.get("bill", (210, 0, 0))), rough=0.4, spec=0.3)
    _rbox("bill", (-cr - f("bill_l", 2.4) / 2 + 1.0, cy - 0.2, 0), (f("bill_l", 2.4) / 2 + 1.0, f("bill_h", 0.4), cr * 0.7), 0.3,
          red).parent = root
    top = cy + cr * f("cap_fy", 0.75)
    post = _empty("prop_post", (0, top, 0), root)
    _cyl("post", (0, 0.6, 0), 0.35, 1.2, red, 0.1, post)
    blade = _rbox("blade", (0, 1.3, 0), (f("prop_l", 7.0), f("prop_h", 0.35), f("prop_w", 0.9)), 0.3, red)
    blade.parent = post
    green = C._mat("gun", C._srgb(*opts.get("gun_col", (0, 170, 0))), rough=0.35, spec=0.35)
    gun = _empty("gun", (0, -f("hand_r", 1.1) * 0.6, 0), arms[opts.get("gun_hand", "n")][2])
    gun.rotation_mode = 'XYZ'
    gl = f("gun_l", 9.0)
    _rbox("gun_body", (-gl * 0.35, 0.6, 0), (gl / 2, f("gun_h", 2.2), f("gun_w", 1.8)), 1.0, green).parent = gun
    _rbox("gun_grip", (0.4, -1.8, 0), (0.9, 1.6, 1.2), 0.5, green).parent = gun
    if opts.get("gun_detail", False):                                  # SD: a ribbed blaster, dark muzzle, top sight
        dark = C._mat("gun_dark", C._srgb(*opts.get("gun_dark", (0, 60, 0))), rough=0.5, spec=0.2)
        gh, gw, x0 = f("gun_h", 2.2), f("gun_w", 1.8), -gl * 0.35
        for i in range(int(f("gun_ribs", 3))):
            rx = x0 - gl * 0.3 + i * gl * 0.25
            _rbox("gun_rib%d" % i, (rx, 0.6 - gh * 0.95, 0), (0.35, 0.45, gw * 0.9), 0.15, dark).parent = gun
        bl, br = f("barrel_l", 2.5), f("barrel_r", 0.9)
        b = _cyl("gun_barrel", (0, 0, 0), br, bl, green, 0.2, gun)
        b.rotation_euler = (0.0, 0.0, math.pi / 2)
        b.location = ((x0 - gl * 0.5 - bl * 0.4) * S, 0.6 * S, 0.0)
        m = _cyl("gun_muzzle", (0, 0, 0), br * 0.6, 0.6, dark, 0.05, gun)
        m.rotation_euler = (0.0, 0.0, math.pi / 2)
        m.location = ((x0 - gl * 0.5 - bl * 0.9) * S, 0.6 * S, 0.0)
        _rbox("gun_sight", (x0 + gl * 0.15, 0.6 + gh * 0.95, 0), (1.2, 0.45, 0.5), 0.15, green).parent = gun
    if opts.get("hand_skin"):                                          # the clown face is white; the hands are skin
        hs = C._mat("hand_skin", C._srgb(*opts["hand_skin"]), rough=f("rough", 0.45), spec=f("spec", 0.25))
        for side in ("n", "f"):
            h = bpy.data.objects.get("hand_" + side)
            if h is not None:
                h.data.materials[0] = hs
    return root, arms, legs, post, gun


def _frames_setup(opts):
    root, arms, legs, post, gun = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"root": root, "arms": arms, "legs": legs, "post": post, "gun": gun, "tilt": math.radians(f("tilt", 0.0)),
            "swing": f("swing", 30.0), "knee_amp": f("knee_amp", 45.0), "arm_swing": f("arm_swing", 30.0),
            "elbow0": f("elbow0", 25.0), "base": base_pose(opts), "gun0": f("gun0", 0.0),
            "gun_hand": opts.get("gun_hand", "n")}


def _frames_pose(ctx, pose):
    kid_pose(ctx, pose)
    ctx["post"].rotation_euler = (0.0, math.radians(float(pose.get("prop", 0.0))), 0.0)
    # the fist frame's -y runs along the forearm: turn the blaster so its barrel (-x) points forward when level
    sh, el, fp = ctx["arms"][ctx["gun_hand"]]
    fa = sh.rotation_euler[2] + el.rotation_euler[2]                  # the forearm's world angle in the side plane
    ctx["gun"].rotation_euler = (0.0, 0.0, -fa + math.radians(float(pose.get("gun", ctx["gun0"]))))


register_frames("beenie", _frames_setup, _frames_pose)
