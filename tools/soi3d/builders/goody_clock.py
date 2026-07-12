"""soi3d.builders.goody_clock -- the blue TIME-BONUS pie timer (goody_sprites f20-f23).

A flat BLUE disc ringed by white pearl STUDS (a 12-bead bezel), with a RED pie wedge that grows
CLOCKWISE from 12 o'clock across four fill stills: f20=1/4, f21=1/2, f22=3/4, f23=full. Colours
sampled from source: blue disc (0,0,189) dark (0,0,57); white studs (~230); red pie (198,0,0).
Static prop (one still per fill fraction).
"""
import math

import bpy
import bmesh

from .. import common as C
from .. import register


def _pie_sector(name, fill, radius, z, mat, n=96, dome=0.11):
    """A RED pie sector as a triangle fan from the centre, starting at 12 o'clock (+Y) and sweeping
    CLOCKWISE by ``fill`` turns (0..1). fill>=1 => a full closed disc. ``dome`` lifts the centre so the
    wedge reads as a shallow raised dome (matches the glossy red bulge in the source)."""
    fill = max(0.0, min(1.0, fill))
    start = math.pi / 2.0                 # 12 o'clock = +Y
    total = fill * 2.0 * math.pi
    steps = max(2, int(round(n * fill)))
    bm = bmesh.new()
    ctr = bm.verts.new((0.0, 0.0, dome * radius))     # raised centre => shallow dome
    arc = []
    for i in range(steps + 1):
        a = start - total * (i / steps)   # clockwise => angle decreases
        arc.append(bm.verts.new((radius * math.cos(a), radius * math.sin(a), 0.0)))
    for i in range(steps):
        bm.faces.new((ctr, arc[i], arc[i + 1]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    obj.location = (0, 0, z)
    obj.data.materials.append(mat)
    bpy.context.view_layer.objects.active = obj
    obj.select_set(True)
    bpy.ops.object.shade_smooth()
    obj.select_set(False)
    return obj


def build_clock(fill=0.25):
    """Blue pie-timer disc with a red wedge of fraction ``fill`` and a white pearl-stud bezel."""
    C._clear()
    blue = C._mat("clk_blue", C._srgb(0, 0, 189), rough=0.42, spec=0.3, coat=0.2)
    # faint dark-blue emission keeps the disc from going black in shadow (matches (0,0,57) darks)
    bb = blue.node_tree.nodes.get("Principled BSDF")
    ec = bb.inputs.get("Emission Color"); es = bb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(0, 0, 60)
    if es is not None:
        es.default_value = 0.05
    red = C._mat("clk_red", C._srgb(183, 4, 6), rough=0.46, spec=0.22, coat=0.12)
    pearl = C._mat("clk_pearl", C._srgb(212, 212, 218), rough=0.3, spec=0.45, coat=0.35)

    # blue base disc (flat cylinder facing the camera; default cyl axis = +Z = toward cam), beveled rim
    bpy.ops.mesh.primitive_cylinder_add(vertices=96, radius=0.98, depth=0.20, location=(0, 0, 0))
    disc = bpy.context.active_object
    disc.name = "clk_disc"
    db = disc.modifiers.new("bev", 'BEVEL'); db.width = 0.05; db.segments = 3
    disc.data.materials.append(blue)
    bpy.ops.object.shade_smooth()

    # red pie wedge, laid just in front of the blue face (disc front face is at z = +0.10)
    _pie_sector("clk_pie", fill, radius=0.80, z=0.12, mat=red)

    # 12 white pearl studs around the rim, proud of the front face (frontmost layer)
    n_studs = 12
    ring_r = 0.85
    for i in range(n_studs):
        a = math.pi / 2.0 - (i / n_studs) * 2.0 * math.pi
        bpy.ops.mesh.primitive_uv_sphere_add(radius=0.10, segments=24, ring_count=16,
                                             location=(ring_r * math.cos(a), ring_r * math.sin(a), 0.15))
        st = bpy.context.active_object
        st.name = f"clk_stud_{i}"
        st.data.materials.append(pearl)
        bpy.ops.object.shade_smooth()

    # key glint on the upper-left of the disc
    bpy.ops.object.light_add(type='POINT', location=(-2.6, 3.0, 3.0))
    gl = bpy.context.active_object
    gl.name = "clk_glint"
    gl.data.energy = 320
    gl.data.shadow_soft_size = 0.5


@register("goody_clock")
def render(args):
    # goody_clock <out.png> [fill] [px]
    out = args[0]
    fill = float(args[1]) if len(args) > 1 else 0.25
    px = int(args[2]) if len(args) > 2 else 256
    build_clock(fill)
    C.setup_scene(px, world_strength=0.18, fill_energy=0.16)
    return out
