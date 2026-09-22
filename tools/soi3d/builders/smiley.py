"""soi3d.builders.smiley -- the Smiley nasty (smiley_sprites f02-f49): a rolling red ball with a face.

A glossy RED sphere carrying a raised WHITE face: two oval eye-balls with a black horizontal slit,
a small downward white nose wedge between them, and a big white TORUS mouth below. The face ROLLS in
the view plane as the Smiley travels (the game picks the frame from its x position, FUN_1000d130),
so the whole face is parented to a pivot rotated about the view axis (+ an optional small tilt).
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _surface_z(x, y, r=1.0):
    return math.sqrt(max(0.0, r * r - x * x - y * y))


def _wedge(name, top_w, top_y, apex_y, thick, mat):
    """A raised flat TRIANGLE (the nose): top edge top_w wide at top_y, apex down at apex_y, laid on the
    sphere front (each vertex lifted to the surface) with `thick` relief."""
    import bmesh
    pts = [(-top_w / 2, top_y), (top_w / 2, top_y), (0.0, apex_y)]
    bm = bmesh.new()
    lo = [bm.verts.new((x, y, _surface_z(x, y) - 0.02)) for x, y in pts]
    hi = [bm.verts.new((x, y, _surface_z(x, y) + thick)) for x, y in pts]
    bm.faces.new(hi)
    bm.faces.new(list(reversed(lo)))
    for i in range(3):
        j = (i + 1) % 3
        bm.faces.new((lo[i], lo[j], hi[j], hi[i]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    bev = obj.modifiers.new("bev", 'BEVEL')
    bev.width = 0.04
    bev.segments = 3
    obj.data.materials.append(mat)
    return obj


def _face_mats(opts):
    red = C._mat("red", C._srgb(*opts.get("red", (245, 0, 0))), rough=float(opts.get("rough", 0.35)),
                 spec=float(opts.get("spec", 0.4)), coat=float(opts.get("coat", 0.2)))
    white = C._mat("white", C._srgb(*opts.get("white", (235, 235, 235))), rough=0.3, spec=0.5, coat=0.3)
    black = C._mat("black", C._srgb(8, 8, 8), rough=0.6, spec=0.1)
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
    ex, ey = float(opts.get("eye_x", 0.46)), float(opts.get("eye_y", 0.42))
    er = float(opts.get("eye_r", 0.28))
    for sx in (-1, 1):
        x, y = sx * ex, ey
        z = _surface_z(x, y)
        bpy.ops.mesh.primitive_uv_sphere_add(radius=er, segments=40, ring_count=20, location=(x, y, z))
        eye = bpy.context.active_object
        eye.name = "eye%d" % sx
        eye.scale = (float(opts.get("eye_sx", 1.35)), 0.78, 0.6)   # a wide oval, flattened onto the ball
        eye.data.materials.append(white)
        bpy.ops.object.shade_smooth()
        parts.append(eye)
        # black horizontal slit across the eye's front (a screw-head pupil)
        slit = C._box("slit%d" % sx, (x, y, z + er * 0.5), (er * 2.2, er * 0.3, er * 0.5), black, bevel=0.01)
        parts.append(slit)
    # nose: a BIG flat white wedge pointing DOWN from between the eyes toward the mouth
    nose = _wedge("nose", float(opts.get("nose_w", 0.46)), float(opts.get("nose_top", 0.36)),
                  float(opts.get("nose_apex", -0.08)), 0.07, white)
    parts.append(nose)
    # mouth: a big THICK white torus on the sphere below the nose, its axis along the surface normal
    my = -float(opts.get("mouth_y", 0.47))
    mz = _surface_z(0.0, my)
    bpy.ops.mesh.primitive_torus_add(major_radius=float(opts.get("mouth_r", 0.36)),
                                     minor_radius=float(opts.get("mouth_t", 0.16)),
                                     major_segments=48, minor_segments=16, location=(0.0, my, mz))
    mouth = bpy.context.active_object
    mouth.name = "mouth"
    mouth.rotation_euler = (math.asin(-my), 0.0, 0.0)
    mouth.scale = (float(opts.get("mouth_sx", 1.15)), 1.0, 0.8)
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
