"""soi3d.builders.cannon_barrel -- the gray Cannon enemy body (cannon_sprites f02-f03).

Opts "barrel": a barrel lying in a light square housing. With "bell" > 0 the barrel is ONE lathed body (round
breech, straight barrel of "barrel_r", then a bell muzzle flaring from "flare_x" to radius "bell" at the frame
edge, as the source draws it) instead of a cylinder with a flat collar; "rivets" adds the two light rivets.
"""
import math

import bmesh
import bpy

from .. import common as C
from .. import register, register_frames


def _lathe(name, stations, s, z, mat, segs=48):
    """A closed body of revolution about the X axis through (0, 0, z): `stations` = [(x, r), ...] left to right."""
    bm = bmesh.new()
    rings = []
    for x, r in stations:
        rings.append([bm.verts.new((s * x, r * math.cos(2 * math.pi * j / segs), z + r * math.sin(2 * math.pi * j / segs)))
                      for j in range(segs)])
    for a, b in zip(rings, rings[1:]):
        for j in range(segs):
            bm.faces.new((a[j], a[(j + 1) % segs], b[(j + 1) % segs], b[j]))
    cap = bm.verts.new((s * stations[-1][0], 0.0, z))
    for j in range(segs):
        bm.faces.new((rings[-1][j], rings[-1][(j + 1) % segs], cap))
    bmesh.ops.remove_doubles(bm, verts=bm.verts, dist=1e-5)
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces)
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    for p in me.polygons:
        p.use_smooth = True
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    return o


def _bell_barrel(opts, s, z, mat):
    f = lambda k, d: float(opts.get(k, d))
    r0, xa, xf, r1 = f("barrel_r", 0.8), f("breech_x", -0.55), f("flare_x", 0.9), f("bell", 1.25)
    xe, p = f("bell_x", 1.7), f("flare_p", 2.0)
    st = [(xa - r0 * math.cos(math.pi / 2 * k / 10), max(1e-4, r0 * math.sin(math.pi / 2 * k / 10))) for k in range(11)]
    st += [(xf + (xe - xf) * k / 12, r0 + (r1 - r0) * (k / 12) ** p) for k in range(13)]
    return _lathe("barrel", st, s, z, mat)


def build_cannon_barrel(opts=None):
    opts = opts or {}
    f = lambda k, d: float(opts.get(k, d))
    C._clear()
    light = C._mat("cannon_light", C._srgb(*opts.get("housing_rgb", (198, 198, 198))), rough=0.72, spec=0.04)
    mid = C._mat("cannon_mid", C._srgb(*opts.get("barrel_rgb", (115, 115, 115))), rough=0.78, spec=0.03)
    dark = C._mat("cannon_dark", C._srgb(40, 40, 40), rough=0.85, spec=0.02)
    parts = []
    if opts.get("barrel", False):     # the source: a barrel lying in a square housing, its muzzle collar out of one side
        s = f("face", 1.0)            # +1 = muzzle right (f02); the pose's "face" -1 mirrors it (f03). 0.1 unit = 1 px
        r, xa, xb, z = f("barrel_r", 0.8), f("breech_x", -0.55), f("collar_x", 0.8), f("barrel_z", 0.2)
        if f("bell", 0.0) > 0:
            parts.append(_bell_barrel(opts, s, z, mid))
            if opts.get("rivets", False):
                ry = f("rivet_y", 0.3)
                for rx in opts.get("rivet_x", (-0.8, 0.6)):
                    bpy.ops.mesh.primitive_uv_sphere_add(segments=16, ring_count=8, radius=f("rivet_r", 0.08),
                                                         location=(s * rx, ry, z + math.sqrt(max(0.0, r * r - ry * ry))))
                    rv = bpy.context.active_object
                    rv.data.materials.append(light)
                    parts.append(rv)
        else:
            bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=r, depth=xb - xa, location=(s * (xa + xb) / 2, 0.0, z),
                                                rotation=(0.0, 1.5708, 0.0))
            parts.append(bpy.context.active_object)
            bpy.ops.mesh.primitive_uv_sphere_add(segments=48, ring_count=24, radius=r, location=(s * xa, 0.0, z))
            parts.append(bpy.context.active_object)              # the rounded breech
            for name, x0, x1, rr in (("collar", xb, xb + f("collar_l", 0.4), f("collar_r", 1.1)),
                                     ("muzzle", xb + f("collar_l", 0.4), 1.6, f("muzzle_r", 0.9))):
                bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=rr, depth=x1 - x0,
                                                    location=(s * (x0 + x1) / 2, 0.0, z), rotation=(0.0, 1.5708, 0.0))
                parts.append(bpy.context.active_object)
            for o in parts:
                o.data.materials.append(mid)
                bpy.ops.object.select_all(action='DESELECT')
                o.select_set(True)
                bpy.context.view_layer.objects.active = o
                bpy.ops.object.shade_smooth()
        by = f("bottom_y", -1.1)                                 # C._box takes FULL extents
        parts.append(C._box("end_wall", (-s * 1.48, 0.15, 0.0), (0.24, 2.5, 0.4), light, bevel=0.05, seg=2))
        parts.append(C._box("backplate", (0.0, 0.15, -0.3), (3.2, 2.9, 0.3), light, bevel=f("plate_bevel", 0.05), seg=3))
        parts.append(C._box("upper_flange", (0.0, f("top_y", 1.4), 0.0), (3.2, 0.4, 0.4), light, bevel=0.05, seg=3))
        parts.append(C._box("lower_flange", (0.0, by, 0.0), (3.2, 0.4, 0.4), light, bevel=0.05, seg=3))
        parts.append(C._box("dark_foot", (0.0, by - 0.35, -0.1), (2.6, 0.3, 0.32), dark, bevel=0.05, seg=2))
        bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
        pivot = bpy.context.active_object
        pivot.name = "pivot"
        for obj in parts:
            obj.parent = pivot
            obj.matrix_parent_inverse.identity()
        return pivot
    bpy.ops.mesh.primitive_uv_sphere_add(segments=64, ring_count=32, location=(0.0, 0.0, 0.06))
    middle = bpy.context.active_object
    middle.name = "rounded_body"
    middle.scale = (0.86, 0.52, 0.34)
    middle.data.materials.append(mid)
    bpy.ops.object.shade_smooth()
    parts.append(middle)
    upper = C._box("upper_flange", (0.0, 0.52, 0.10), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    base = C._box("lower_flange", (0.0, -0.52, 0.00), (1.55, 0.22, 0.20), light, bevel=0.055, seg=2)
    foot = C._box("dark_foot", (0.0, -0.72, -0.10), (1.20, 0.20, 0.16), dark, bevel=0.05, seg=2)
    bpy.ops.object.empty_add(location=(0.0, 0.0, 0.0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    for obj in parts + [upper, base, foot]:
        obj.parent = pivot
        obj.matrix_parent_inverse.identity()
    return pivot


def _frames_setup(opts):
    pivot = build_cannon_barrel(opts)
    C.setup_scene(256, world_strength=0.08, fill_energy=0.10)
    C.apply_look(opts)
    return {"pivot": pivot}


def _frames_pose(ctx, pose):
    ctx["pivot"].rotation_euler[2] = 0.0
    ctx["pivot"].scale[0] = float(pose.get("face", 1.0))      # -1 mirrors the barrel: muzzle left (f03)


@register("cannon_barrel")
def render(args):
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_cannon_barrel()
    C.setup_scene(px, world_strength=0.08, fill_energy=0.10)
    return out


register_frames("cannon_barrel", _frames_setup, _frames_pose)