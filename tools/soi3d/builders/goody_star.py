"""soi3d.builders.goody_star -- the red-medallion STAR bonus pickup (goody_sprites f12).

A round RED ball (matte sphere, dark-red shaded rim like the source) carrying an embossed GOLD
five-point star, point-up, proud of the face so it catches the top-left key and casts a small relief
shadow. Static prop (the original is a single frame). Colours sampled from the source: red ball
(206,0,0) -> shadow (~49,0,0); gold star (210,174,0) / shaded (189,156,0).
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _star_poly(name, r_out, r_in, points, z, thick, mat, rot_deg=90.0):
    """A raised N-point star: alternating outer/inner rim verts fanned from a central apex (slightly
    proud) down to a flat back, so it reads as a convex embossed star with clean facets."""
    import bmesh
    bm = bmesh.new()
    apex = bm.verts.new((0.0, 0.0, z + thick))          # slightly raised centre -> convex relief
    rim = []
    n = points * 2
    for i in range(n):
        ang = math.radians(rot_deg) + math.pi * i / points
        r = r_out if i % 2 == 0 else r_in
        rim.append(bm.verts.new((r * math.cos(ang), r * math.sin(ang), z)))
    back = bm.verts.new((0.0, 0.0, z - thick * 0.5))    # shallow back cone -> solid body
    for i in range(n):
        bm.faces.new((apex, rim[i], rim[(i + 1) % n]))  # top facets
        bm.faces.new((back, rim[(i + 1) % n], rim[i]))  # bottom facets
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    mo = obj.modifiers.new("bev", 'BEVEL')
    mo.width = 0.015
    mo.segments = 2
    obj.data.materials.append(mat)
    return obj


def build_star(opts=None):
    """A red ball medallion with a proud gold 5-point star, point-up (source f12). opts "r_out", "r_in"
    (star tip / valley radius, ball = 1), "thick" (relief height) and "star_z" (rim height) shape the star."""
    opts = opts or {}
    f = lambda k, d: float(opts.get(k, d))
    C._clear()
    # matte red 'playdough' ball; faint dark-red emission keeps the shadowed lower-right dark RED
    red = C._mat("star_red", C._srgb(206, 0, 0), rough=0.62, spec=0.12, coat=0.0)
    rb = red.node_tree.nodes.get("Principled BSDF")
    ec = rb.inputs.get("Emission Color")
    es = rb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(74, 0, 0)
    if es is not None:
        es.default_value = 0.06
    # gold star: warm metal, light clearcoat for an in-hue sheen (no white wash)
    gold = C._mat("star_gold", C._srgb(210, 174, 0), rough=0.36, metal=0.0, spec=0.3, coat=0.3)

    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "star_ball"
    ball.data.materials.append(red)
    bpy.ops.object.shade_smooth()

    _star_poly("star", r_out=f("r_out", 0.72), r_in=f("r_in", 0.30), points=5, z=f("star_z", 0.92),
               thick=f("thick", 0.10), mat=gold, rot_deg=90.0)

    # soft top-left catch light for a real highlight under the composited glint
    bpy.ops.object.light_add(type='POINT', location=(-2.7, 3.3, 2.6))
    gl = bpy.context.active_object
    gl.name = "star_glint"
    gl.data.energy = 400
    gl.data.shadow_soft_size = 0.4


@register("goody_star")
def render(args):
    # goody_star <out.png> [px]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_star()
    C.setup_scene(px, world_strength=0.18, fill_energy=0.16)
    return out


def _frames_setup(opts):
    build_star(opts)
    C.setup_scene(256, world_strength=0.18, fill_energy=0.16)
    C.apply_look(opts)
    return {}


register_frames("goody_star", _frames_setup, lambda ctx, pose: None)   # static goody (fixed frame)
