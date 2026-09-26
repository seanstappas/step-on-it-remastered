"""soi3d.builders.hammer -- the Hammer (hammer_sprites f02-f81): a kid swinging a stone mallet.

The players' rig (kid.py, itself robo.py's joints) in a green T-shirt and green shorts: the thighs stay in the
shorts, the knees and shins are bare skin, white shoes. The MALLET hangs on a "grip" empty at the near fist:
a white handle and a grey stone drum across its far end. "ham" (deg) is the handle's angle in the body's side
plane whatever the forearm does: 0 = forward (-X at yaw 0), -90 = up, +-180 = back, 90 = down; "ham_y" (deg)
twists it about the forearm (for the front/back views); opts "ham0"/"ham_y0" are their defaults.
Opts "s_n0"/"e_n0"/... (kid.py) give the base arm pose, e.g. the over-the-shoulder carry of the walk.
The source (f11/f20 viewed at 12x): green shorts over the upper thighs, bare knees, brown-grey socks (~64,54,48) on
the lower shins, white shoes; the front fist (~184,177,162) at chest height; the handle hidden behind the body with
only the dark stone head (~44,42,40) showing behind the head. Opts "bare_thighs"/"dark_socks" colour whole segments
(dE 18.5 -> 20.9) and "split_legs" adds shorts/sock sleeves ("shorts_f"/"socks_f" of the segment; dE 19.5): both
scored worse than plain green legs, so the legs' positions, not their colours, limit this family.
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .kid import build as kid_build
from .kid import _frames_pose as kid_pose
from .kid import base_pose
from .robo import _cyl, _empty


def build(opts):
    root, arms, legs = kid_build(opts)
    f = lambda k, d: float(opts.get(k, d))
    rgb = lambda name, dflt: tuple(max(0, min(255, int(round(v * f(name + "_gain", 1.0))))) for v in opts.get(name, dflt))
    skin = bpy.data.objects["head"].data.materials[0]
    socks = C._mat("socks", C._srgb(*rgb("socks", (64, 56, 52))), rough=f("rough", 0.45), spec=f("spec", 0.25))
    parts = {"knee_ball_": skin, "shin_": socks if opts.get("dark_socks", False) else skin}
    if opts.get("bare_thighs", False):                             # the green shorts are only the pelvis
        parts["thigh_"] = skin
    for side in ("n", "f"):
        for part, mat in parts.items():
            ob = bpy.data.objects.get(part + side)
            if ob is not None:
                ob.data.materials[0] = mat
    if opts.get("split_legs", False):                              # shorts over the upper thigh, socks on the lower shin
        shorts = bpy.data.objects["pelvis"].data.materials[0]
        tl, sl, lr = f("thigh_l", 5.4), f("shin_l", 5.0), f("leg_r", 1.6)
        for side in ("n", "f"):
            hp, kn, _ = legs[side]
            for part in ("thigh_", "knee_ball_", "shin_"):
                bpy.data.objects[part + side].data.materials[0] = skin
            hl = tl * f("shorts_f", 0.5)
            _cyl("shorts_" + side, (0, -hl / 2, 0), lr * f("shorts_r", 1.12), hl, shorts, 0.3, hp)
            ql = sl * f("socks_f", 0.65)
            _cyl("sock_" + side, (0, -sl + ql / 2, 0), lr * 0.95 * f("socks_r", 1.1), ql, socks, 0.3, kn)
    grip = _empty("grip", (0, -f("hand_r", 1.1) * 0.6, 0), arms["n"][2])
    grip.rotation_mode = 'ZXY'
    handle = C._mat("handle", C._srgb(*rgb("handle", (235, 235, 230))), rough=f("rough", 0.45), spec=f("spec", 0.25))
    stone = C._mat("stone", C._srgb(*rgb("stone", (70, 70, 70))), rough=f("stone_rough", 0.8), spec=0.1)
    hl, go = f("handle_l", 12.0), f("grip_off", 1.5)
    _cyl("handle", (0, hl / 2 - go, 0), f("handle_r", 0.9), hl, handle, 0.3, grip)
    drum = _cyl("mallet", (0, hl - go, 0), f("mallet_r", 2.6), f("mallet_l", 6.5), stone, f("mallet_bevel", 1.0), grip)
    drum.rotation_euler = (0.0, 0.0, math.pi / 2)                  # its axis across the handle, in the side plane
    return root, arms, legs, grip


def _frames_setup(opts):
    root, arms, legs, grip = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    f = lambda k, d: float(opts.get(k, d))
    return {"root": root, "arms": arms, "legs": legs, "grip": grip, "tilt": math.radians(f("tilt", 0.0)),
            "swing": f("swing", 30.0), "knee_amp": f("knee_amp", 45.0), "arm_swing": f("arm_swing", 30.0),
            "elbow0": f("elbow0", 25.0), "base": base_pose(opts), "ham0": f("ham0", 0.0), "ham_y0": f("ham_y0", 0.0)}


def _frames_pose(ctx, pose):
    kid_pose(ctx, pose)                                            # merges the opts base pose
    sh, el, fp = ctx["arms"]["n"]
    fa = sh.rotation_euler[2] + el.rotation_euler[2]              # undo the forearm: "ham" is relative to the body
    ctx["grip"].rotation_euler = (0.0, math.radians(float(pose.get("ham_y", ctx["ham_y0"]))),
                                  -fa + math.radians(90.0 + float(pose.get("ham", ctx["ham0"]))))


register_frames("hammer", _frames_setup, _frames_pose)
