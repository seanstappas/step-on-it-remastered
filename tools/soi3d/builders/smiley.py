"""soi3d.builders.smiley -- the Smiley nasty (smiley_sprites f02-f49): a rolling red ball with a face.

A glossy RED sphere carrying a raised WHITE face, measured on the 32x30 f02 (ball radius R = 15 px,
face centre x ~17): two eyeballs (10 x 8 px, centres (+-8.5, +6) px = (+-0.57, 0.40) R) each with a
short black horizontal slit (~60% of the eye width), a NOSE RIDGE pointing UP between them (3 px wide at
the top, row 7, flaring to 9 px at its base, row 15: lit left flank, shaded right flank, grey underside)
and a huge thick TORUS mouth (22 x 12 px outside, a 6 x 3 px hole, centred 9 px below the centre) that
reaches the bottom of the silhouette. The face ROLLS in the view plane as the Smiley travels (the game
picks the frame from its x position, FUN_1000d130), so the whole face is parented to a pivot rotated
about the view axis (+ an optional small tilt).
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _surface_z(x, y, r=1.0):
    return math.sqrt(max(0.0, r * r - x * x - y * y))


def _nose(name, base_w, base_y, top_w, top_y, height, mat):
    """A raised nose RIDGE on the sphere front: a trapezoid footprint (base_w wide at base_y, top_w at
    top_y) whose centre line is lifted by `height` at the base (less at the top), so it has a lit left
    flank, a shaded right flank and a downward-facing base end."""
    import bmesh
    bm = bmesh.new()

    def v(x, y, lift=0.0):
        return bm.verts.new((x, y, _surface_z(x, y) - 0.02 + lift))
    bl, br = v(-base_w / 2, base_y), v(base_w / 2, base_y)
    tl, tr = v(-top_w / 2, top_y), v(top_w / 2, top_y)
    rb, rt = v(0.0, base_y, height), v(0.0, top_y, height * 0.35)
    for f in ((tl, bl, rb, rt), (rt, rb, br, tr), (bl, br, rb), (tr, tl, rt), (tl, tr, br, bl)):
        bm.faces.new(f)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    bev = obj.modifiers.new("bev", 'BEVEL')
    bev.width = 0.02
    bev.segments = 2
    obj.data.materials.append(mat)
    return obj


def _face_mats(opts):
    red = C._mat("red", C._srgb(*opts.get("red", (245, 0, 0))), rough=float(opts.get("rough", 0.35)),
                 spec=float(opts.get("spec", 0.4)), coat=float(opts.get("coat", 0.2)))
    white = C._mat("white", C._srgb(*opts.get("white", (235, 235, 235))),
                   rough=float(opts.get("white_rough", 0.3)),
                   spec=float(opts.get("white_spec", 0.5)), coat=float(opts.get("white_coat", 0.3)))
    black = C._mat("black", C._srgb(*opts.get("black", (8, 8, 8))),
                   rough=float(opts.get("black_rough", 0.6)), spec=float(opts.get("black_spec", 0.1)))
    return red, white, black


def build_smiley(opts=None):
    opts = opts or {}
    C._clear()
    red, white, black = _face_mats(opts)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "ball"
    ball.data.materials.append(red)
    bpy.ops.object.shade_smooth()
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    parts = []
    fx = float(opts.get("face_x", 0.03))
    ex, ey = float(opts.get("eye_x", 0.57)), float(opts.get("eye_y", 0.40))
    er = float(opts.get("eye_r", 0.30))
    for sx in (-1, 1):
        x, y = fx + sx * ex, ey
        z = _surface_z(x, y)
        bpy.ops.mesh.primitive_uv_sphere_add(radius=er, segments=40, ring_count=20, location=(x, y, z))
        eye = bpy.context.active_object
        eye.name = "eye%d" % sx
        eye.scale = (float(opts.get("eye_sx", 1.1)), float(opts.get("eye_sy", 0.9)), float(opts.get("eye_sz", 0.6)))
        eye.data.materials.append(white)
        bpy.ops.object.shade_smooth()
        parts.append(eye)
        # a short black horizontal slit across the eyeball's front (a screw-head pupil)
        sl = float(opts.get("slit_len", 0.65)) * 2 * er * float(opts.get("eye_sx", 1.1))
        st = float(opts.get("slit_t", 0.07))
        top = z + er * float(opts.get("eye_sz", 0.6))
        slit = C._box("slit%d" % sx, (x, y + float(opts.get("slit_y", 0.0)), top - st * 0.4), (sl, st, st),
                      black, bevel=0.005)
        parts.append(slit)
    # nose: a white RIDGE pointing UP between the eyes, flaring down to its base above the mouth
    nose = _nose("nose", float(opts.get("nose_w", 0.6)), float(opts.get("nose_base", -0.1)),
                 float(opts.get("nose_top_w", 0.2)), float(opts.get("nose_top", 0.5)),
                 float(opts.get("nose_h", 0.14)), white)
    nose.location.x = fx
    parts.append(nose)
    # mouth: a huge THICK white torus low on the sphere, its axis along the surface normal
    my = -float(opts.get("mouth_y", 0.6))
    mz = _surface_z(fx, my)
    bpy.ops.mesh.primitive_torus_add(major_radius=float(opts.get("mouth_r", 0.46)),
                                     minor_radius=float(opts.get("mouth_t", 0.24)),
                                     major_segments=48, minor_segments=16, location=(fx, my, mz))
    mouth = bpy.context.active_object
    mouth.name = "mouth"
    mouth.rotation_euler = (math.asin(-my) * float(opts.get("mouth_tilt", 1.0)), 0.0, 0.0)
    mouth.scale = (float(opts.get("mouth_sx", 1.0)), float(opts.get("mouth_sy", 0.8)), 0.8)
    mouth.data.materials.append(white)
    bpy.ops.object.shade_smooth()
    parts.append(mouth)
    for o in parts:
        o.parent = pivot
        o.matrix_parent_inverse.identity()
    return pivot


@register("smiley")
def render(args):
    # smiley <out.png> [px] [roll_deg]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    pivot = build_smiley()
    pivot.rotation_euler = (0.0, 0.0, math.radians(float(args[2]) if len(args) > 2 else 0.0))
    C.setup_scene(px, world_strength=0.1, fill_energy=0.1)
    return out


def _frames_setup(opts):
    pivot = build_smiley(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    # pose {"roll": deg about the view axis (the face turning as the ball rolls), "tilt_x"/"tilt_y"}
    ctx["pivot"].rotation_mode = 'ZYX'
    ctx["pivot"].rotation_euler = (math.radians(float(pose.get("tilt_x", 0.0))),
                                   math.radians(float(pose.get("tilt_y", 0.0))),
                                   math.radians(float(pose.get("roll", 0.0))))


register_frames("smiley", _frames_setup, _frames_pose)
