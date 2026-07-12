"""soi3d.builders.transporter -- the teleport ZAP effect (source family `transporter`, 13 frames, 40x31).

This is NOT a flat floor pad: the sprite is the *being-teleported* VFX -- a player's HEAD (skin face, brown
hair, two bright blue eyes, a dark smile) wrapped by RED energy rings that ORBIT around it. The 13 source
frames are one full ring-orbit cycle:
  * f02/f03  the two rings are edge-on and cross into a thick red "X" over a shadowed head (sprite_facts:
             "red X over a face/portal -- keep the crisp red X, face behind").
  * f06-f10  the rings have rotated open into a thick red swirling orbit around a now-lit face (f08 hero).
  * f13/f14  the rings close back toward the edge-on X.

IN vs OUT: the whole source sheet is RED -- there is NO second colour variant in the art. The decompile
(`docs/original_game/decompiled-findings.md`) distinguishes IN/OUT by CELL PARITY (IN=even, OUT=odd, 5
pairs), not colour; "are pairs coloured?" was left an open oracle question. So IN and OUT share this one
red zap; the only honest IN/OUT distinction is animation DIRECTION -- OUT = rings open outward (forward),
IN = rings close inward (reverse). We model the red zap and drive it from a single `phase`.

Geometry kept local to this module: `_head()` (skin sphere + hair cap + 2 blue eyes + smile) and two fat
red emissive tori that we tilt/spin from a crossed X (phase 0) through the open orbit (phase 0.5) back to
the X (phase 1). A soft emission gives the glow; a view-locked POST glint (apply_glint.py) adds the shine.
"""
import math

import bpy

from .. import common as C
from .. import register

SKIN = (233, 226, 215)
SKIN_SHADOW = (150, 120, 96)
HAIR = (110, 74, 46)
EYE = (100, 98, 212)
MOUTH = (74, 20, 12)
RING = (240, 0, 0)          # bright PURE red ring body; low spec keeps green/blue out of the red class

HEAD_R = 0.58
RING_MAJOR = 0.78
RING_MINOR = 0.21


def _emit(mat, rgb, strength):
    """Set the Principled BSDF emission on `mat` (glow that keeps a colour bright under shadow)."""
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    if bsdf is None:
        return mat
    ec = bsdf.inputs.get("Emission Color")
    if ec is not None:
        ec.default_value = C._srgb(*rgb)
    es = bsdf.inputs.get("Emission Strength")
    if es is not None:
        es.default_value = strength
    return mat


def _sphere(name, loc, r, mat, squash=(1, 1, 1)):
    bpy.ops.mesh.primitive_uv_sphere_add(segments=40, ring_count=24, radius=r, location=loc)
    o = bpy.context.active_object
    o.name = name
    o.scale = squash
    bpy.ops.object.shade_smooth()
    o.data.materials.append(mat)
    return o


def _head():
    """A player head facing the camera (+Z): skin sphere + brown hair cap + 2 blue eyes + a dark smile."""
    # emission-dominated skin: a dim diffuse base for a hint of form, the bright SKIN emitted uniformly so
    # the small face reads as the flat, bright pixel-art beige (230,224,213) rather than a shaded sphere.
    skin = _emit(C._mat("tp_skin", C._srgb(150, 143, 133), rough=0.55, spec=0.15), SKIN, 0.92)
    _sphere("head", (0, 0, 0), HEAD_R, skin, squash=(1.0, 0.98, 0.80))
    # brown hair: a squashed dome sitting on the top-back of the skull
    hair = C._mat("tp_hair", C._srgb(*HAIR), rough=0.7, spec=0.15)
    _sphere("hair", (0, 0.20, -0.06), HEAD_R * 0.98, hair, squash=(1.0, 0.72, 0.98))
    # two bright blue eyes on the front (+Z) of the face (a little emission so they stay a vivid blue)
    eye = _emit(C._mat("tp_eye", C._srgb(*EYE), rough=0.3, spec=0.5), EYE, 0.22)
    ez = HEAD_R * 0.80
    for sx in (-1, 1):
        _sphere("eye%d" % sx, (0.17 * sx, 0.07, ez), 0.105, eye, squash=(1, 1, 0.7))
    # a dark grin: a wide, shallow dark ellipse low on the face (reads as a smiling mouth at 40x31)
    mouth = C._mat("tp_mouth", C._srgb(*MOUTH), rough=0.6, spec=0.1)
    _sphere("mouth", (0, -0.20, HEAD_R * 0.80), 0.16, mouth, squash=(1.05, 0.42, 0.30))


def _ring(name, tilt_deg, roll_deg, emit):
    """One fat red torus encircling the head, tilted `tilt_deg` about X then rolled `roll_deg` about Z."""
    bpy.ops.mesh.primitive_torus_add(major_radius=RING_MAJOR, minor_radius=RING_MINOR,
                                     major_segments=64, minor_segments=20, location=(0, 0, 0))
    o = bpy.context.active_object
    o.name = name
    o.rotation_euler = (math.radians(tilt_deg), 0, math.radians(roll_deg))
    o.scale = (1.15, 1.0, 1.0)          # a touch wider than tall -> the 40x31 orbit
    bpy.ops.object.shade_smooth()
    o.visible_shadow = False            # glowing energy: don't cast hard shadows onto the face
    o.data.materials.append(emit)
    return o


def build_transporter(phase=None):
    """Build the red teleport zap. phase None => the open-orbit hero still (f08); else drive the cycle."""
    C._clear()

    # `open_frac` 0 -> edge-on crossed X ; 1 -> fully open orbit. phase 0..1 goes X->open->X.
    if phase is None:
        open_frac = 1.0
    else:
        phase = max(0.0, min(1.0, phase))
        open_frac = math.sin(math.pi * phase)          # 0 -> 1 -> 0 over the cycle

    # the head stays a bright beige throughout (in the X phase it is heavily OCCLUDED by the bars, not
    # dimmed -- source f02 face is still ~228,219,201); the rings do the animating.
    _head()
    # a soft-emissive red so the rings glow but the top-left key still carves the tube gradient
    emit = _emit(C._mat("tp_ring", C._srgb(*RING), rough=0.35, spec=0.08), RING, 0.10)

    # edge-on (open 0): both tori stand vertical, rolled +/-45 -> a crossed X.
    # open (open 1):    both tori tilt forward toward the camera -> thick crossed ellipses (the orbit).
    tilt = 90.0 - 50.0 * open_frac                     # 90 (edge-on) -> 40 (open, fat overlapping band)
    _ring("ringA", tilt, 45, emit)
    _ring("ringB", tilt, -45, emit)


@register("transporter")
def render(args):
    # transporter <out.png> [px] [phase|-]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    phase = None if (len(args) <= 2 or args[2] == "-") else float(args[2])
    build_transporter(phase=phase)
    C.setup_scene(px)
    return out
