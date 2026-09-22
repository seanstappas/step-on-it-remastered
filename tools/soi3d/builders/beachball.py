"""soi3d.builders.beachball -- the Cannon's shot (cannon_sprites f04-f23): a three-gore beach ball.

A sphere split into SIX equal vertical GORES (red / blue / green, twice; meridians around the vertical
Y axis) that SPINS about that vertical axis as it flies -- the source's 20 frames are one pattern period
(a half turn). Lit like the other props (top-left key): bright saturated primaries on the lit side, deep
in-hue shading to the lower right, a small soft highlight.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames

# SIX 60-deg gores, the colour cycle red, blue, green twice (cyclic order as seen left -> right on the
# source, f04 = green | red; the mirror order cannot be reached by any spin). A centred gore covers only
# ~half the ball's width on the source (sin 30 deg), which rules out three 120-deg gores; the pattern
# repeats every 180 deg, so the 20-frame cycle is a half turn (9 deg/frame).
GORES = ((255, 0, 0), (0, 0, 255), (0, 255, 0), (255, 0, 0), (0, 0, 255), (0, 255, 0))


def build_beachball(gores=GORES, rough=0.45, spec=0.25):
    C._clear()
    mats = []
    for i, rgb in enumerate(gores):
        m = C._mat("gore%d" % i, C._srgb(*rgb), rough=rough, spec=spec)
        mats.append(m)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "ball"
    for m in mats:
        ball.data.materials.append(m)
    n = len(gores)
    for poly in ball.data.polygons:
        c = poly.center
        ang = (math.atan2(c.x, c.z) + 2 * math.pi) % (2 * math.pi)   # longitude about +Y, 0 = facing camera
        poly.material_index = int(ang / (2 * math.pi / n)) % n
    bpy.ops.object.shade_smooth()
    return ball


@register("beachball")
def render(args):
    # beachball <out.png> [px] [spin_deg]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    ball = build_beachball()
    ball.rotation_euler = (0.0, math.radians(float(args[2]) if len(args) > 2 else 0.0), 0.0)
    C.setup_scene(px, world_strength=0.12, fill_energy=0.10)
    return out


def _frames_setup(opts):
    ball = build_beachball(rough=float(opts.get("rough", 0.45)), spec=float(opts.get("spec", 0.25)))
    C.setup_scene(256, world_strength=0.12, fill_energy=0.10)
    C.apply_look(opts)
    return {"ball": ball}


def _frames_pose(ctx, pose):
    # pose {"spin": deg about the vertical axis} [+ "tilt": lean of that axis toward the camera]
    ctx["ball"].rotation_mode = 'ZYX'
    ctx["ball"].rotation_euler = (math.radians(float(pose.get("tilt", 0.0))),
                                  math.radians(float(pose.get("spin", 0.0))), 0.0)


register_frames("beachball", _frames_setup, _frames_pose)
