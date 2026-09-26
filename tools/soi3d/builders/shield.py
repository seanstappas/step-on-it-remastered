"""soi3d.builders.shield -- the speed-shoes indicator's spinning crest (spin_ind_sprite_family f02-f31).

Measured on the 16 x 12 face-on f02: a silver heater-shield CREST -- two horns at the top corners, a
domed centre between two dips, full width over rows 2-5, tapering to a blunt point at rows 10-11 -- with
gold studs on the two horn roots and the tip. It spins about the vertical axis: edge-on at f09/f10 and
f24/f25, face-on at f02, f17 and f31, so the 30 frames are one turn (12 deg/frame).
"""
import math

import bpy

from .. import common as C
from .. import register_frames

S = 0.1   # Blender units per SD pixel (x 0..16, y 0..12 down; the spin axis at x = 8)

# the f02 outline in SD pixel-edge coordinates (clockwise from the left horn)
OUTLINE = [(1, 0), (3, 0), (4, 1.6), (5, 1), (6, 0), (11, 0), (11, 1), (12, 1.6), (13, 1), (14, 0), (15, 0),
           (15, 5), (14, 6), (13, 7), (12.5, 8), (11, 9.5), (10, 11), (10, 12), (6, 12), (6, 11), (5, 9.5),
           (3.5, 8), (3, 7), (2, 6), (1, 5)]
STUDS = [(2.0, 2.5), (14.0, 2.5), (8.0, 10.6)]


def _px(x, y):
    return ((x - 8.0) * S, (6.0 - y) * S)


def _cyl(name, r, zc):
    bpy.ops.mesh.primitive_cylinder_add(vertices=192, radius=r, depth=4.0, location=(0, 0, zc),
                                        rotation=(math.pi / 2, 0, 0))
    o = bpy.context.active_object
    o.name = name
    return o


def build_shield(opts):
    """A THIN plate curved about the vertical axis (a real heater shield): edge-on its curvature makes it
    ~3 px wide while the horns and dips stay visible at 60 deg. Built as the f02 outline prism intersected
    with a cylindrical shell (outer radius `curve_r` px, `thick` px)."""
    C._clear()
    silver = C._mat("silver", C._srgb(*opts.get("silver", (210, 210, 210))), rough=float(opts.get("rough", 0.3)),
                    spec=float(opts.get("spec", 0.4)))
    gold = C._mat("gold", C._srgb(*opts.get("gold", (190, 150, 40))), rough=0.35, spec=0.5)
    th = float(opts.get("thick", 0.7)) * S
    rc = float(opts.get("curve_r", 11.0)) * S
    pts = [_px(x, y) for x, y in OUTLINE]
    n = len(pts)
    depth = 0.8        # the prism keeps only the shell's FRONT arc (its back arc lies ~2 units behind)
    vs = [(x, y, depth) for x, y in pts] + [(x, y, -depth) for x, y in pts]
    faces = [tuple(range(n)), tuple(range(2 * n - 1, n - 1, -1))]
    faces += [(i, (i + 1) % n, n + (i + 1) % n, n + i) for i in range(n)]
    me = bpy.data.meshes.new("shield")
    me.from_pydata(vs, [], faces)
    me.update()
    body = bpy.data.objects.new("shield", me)
    bpy.context.collection.objects.link(body)
    bpy.context.view_layer.objects.active = body
    body.select_set(True)
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.normals_make_consistent(inside=False)
    bpy.ops.object.mode_set(mode='OBJECT')
    outer, inner = _cyl("outer", rc, -rc + th / 2), _cyl("inner", rc - th, -rc + th / 2)
    for cut, op in ((outer, 'INTERSECT'), (inner, 'DIFFERENCE')):
        m = body.modifiers.new(op, 'BOOLEAN')
        m.operation = op
        m.object = cut
        m.solver = 'EXACT'
        bpy.context.view_layer.objects.active = body
        bpy.ops.object.modifier_apply(modifier=m.name)
        bpy.data.objects.remove(cut, do_unlink=True)
    bv = body.modifiers.new("bev", 'BEVEL')
    bv.width = float(opts.get("bevel", 0.2)) * S
    bv.segments = 2
    bv.limit_method = 'ANGLE'
    body.data.materials.append(silver)
    bpy.ops.object.shade_smooth()
    parts = [body]
    sr = float(opts.get("stud_r", 0.9)) * S
    for x, y in STUDS:
        px, py = _px(x, y)
        z = -rc + th / 2 + math.sqrt(max(0.0, rc * rc - px * px))      # on the front of the curved plate
        bpy.ops.mesh.primitive_uv_sphere_add(radius=sr, segments=16, ring_count=8, location=(px, py, z))
        s = bpy.context.active_object
        s.data.materials.append(gold)
        bpy.ops.object.shade_smooth()
        parts.append(s)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for o in parts:
        o.parent = pivot
    return pivot


def _frames_setup(opts):
    pivot = build_shield(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    # pose {"spin": deg about the vertical axis}
    ctx["pivot"].rotation_euler = (0.0, math.radians(float(pose.get("spin", 0.0))), 0.0)


register_frames("shield", _frames_setup, _frames_pose)
