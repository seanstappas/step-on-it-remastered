"""soi3d.builders.sign -- procedural Stop/Go octagon sign (faithful enhancement of Stop_Go_sprite_family).

Source is a red octagon with low-contrast text; we render a crisp red octagon + white extruded
"Stop"/"Go". Height order (high->low): red bezel > white ring > text > coloured face > black well,
so every layer casts a shadow inward/downward.
"""
import math
import os

import bpy

from .. import common as C
from .. import register


def _octagon(name, radius, depth, z, mat, bevel=0.03, rot=math.pi / 8):
    # A cylinder with 8 sides = octagonal prism; flat faces point +/-Z (toward camera).
    # rot=pi/8 -> flat-top octagon; rot=0 -> POINT-TOP (a vertex at top/bottom), per the source.
    bpy.ops.mesh.primitive_cylinder_add(vertices=8, radius=radius, depth=depth,
                                        location=(0, 0, z), rotation=(0, 0, rot))
    obj = bpy.context.active_object
    obj.name = name
    bm = obj.modifiers.new("bevel", 'BEVEL')
    bm.width = bevel
    bm.segments = 3
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def _oct_ring(name, r_out, r_in, depth, z, mat, rot=0.0, bevel=0.015):
    """An octagonal RING (annulus) prism -> a raised WHITE rim that stands PROUD of the recessed
    coloured face (the source's white octagon outline sits HIGHER than the middle section)."""
    import bmesh
    bm = bmesh.new()
    n = 8
    top = z + depth / 2.0
    bot = z - depth / 2.0
    ot, ob, it, ib = [], [], [], []
    for i in range(n):
        a = rot + 2 * math.pi * i / n
        co, so = math.cos(a), math.sin(a)
        ot.append(bm.verts.new((r_out * co, r_out * so, top)))
        ob.append(bm.verts.new((r_out * co, r_out * so, bot)))
        it.append(bm.verts.new((r_in * co, r_in * so, top)))
        ib.append(bm.verts.new((r_in * co, r_in * so, bot)))
    for i in range(n):
        j = (i + 1) % n
        bm.faces.new((ot[i], ot[j], it[j], it[i]))   # top annulus (the visible raised white rim)
        bm.faces.new((ob[j], ob[i], ib[i], ib[j]))   # bottom
        bm.faces.new((ob[i], ob[j], ot[j], ot[i]))   # outer wall
        bm.faces.new((ib[j], ib[i], it[i], it[j]))   # inner wall
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    if bevel > 0:
        mm = obj.modifiers.new("bevel", 'BEVEL')
        mm.width = bevel
        mm.segments = 2
    obj.data.materials.append(mat)
    return obj


def _border(name, half, thick, z0, ztop, mat, bevel=0.03):
    """Raised red bezel: SQUARE cube CORNERS + CYLINDRICAL (rounded) straight RAILS between them,
    like the original's rounded molding with square corner blocks. Sits on top of the recessed
    sign and casts a shadow inward. half=outer half-size, thick=bar width."""
    io = half - thick          # corner inner edge / rail half-length
    c = half - thick / 2.0     # corner + rail centre offset
    rad = thick / 2.0          # rail radius = half the border width
    h = ztop - z0
    cz = (z0 + ztop) / 2.0
    zc = ztop - rad            # rail centre so its rounded top sits at ztop
    L = 2 * io + 0.04          # rail length (slightly overlaps into the corner cubes)
    # SQUARE cube corners
    for sx in (-1, 1):
        for sy in (-1, 1):
            C._box(name + "_c%d%d" % (sx, sy), (sx * c, sy * c, cz), (thick, thick, h), mat, bevel)
    # CYLINDRICAL rounded rails between the corners (round profile faces the camera)
    def _rail(nm, loc, along):
        bpy.ops.mesh.primitive_cylinder_add(vertices=28, radius=rad, depth=L, location=loc)
        o = bpy.context.active_object
        o.name = nm
        o.rotation_euler = (0, math.radians(90), 0) if along == 'X' else (math.radians(90), 0, 0)
        o.data.materials.append(mat)
        bpy.ops.object.shade_smooth()
    _rail(name + "_t", (0, c, zc), 'X')
    _rail(name + "_b", (0, -c, zc), 'X')
    _rail(name + "_l", (-c, 0, zc), 'Y')
    _rail(name + "_r", (c, 0, zc), 'Y')


def build_sign(kind="STOP", accent=(198, 0, 0), font=None):
    """FAITHFUL Step-On-It sign tile (matches source f02/f09): a THICK raised RED bezel (both
    signs) with sharp square corners, sitting ON TOP of a recessed black well; inside, a POINT-TOP
    octagon whose bright WHITE ring stands PROUD (higher) around a RECESSED coloured face (red
    198,0,0 STOP / green 0,140,0 GO) with raised WHITE text. Height order (high->low): red bezel >
    white ring > text > coloured face > black well -> every layer casts a shadow inward/downward."""
    C._clear()
    red = C._srgb(198, 0, 0)
    frame = C._mat("frame", red, rough=0.5, spec=0.05)                  # RED bezel (BOTH signs), matte
    black = C._mat("black", C._srgb(0, 0, 0), rough=1.0, spec=0.0)      # recessed black well
    white = C._mat("white", C._srgb(255, 255, 255), rough=0.3, metal=0.0, spec=0.35)  # bright WHITE thin ring
    face = C._mat("face", C._srgb(*accent), rough=0.45, spec=0.0)       # octagon face (matte -> saturated)
    textcol = C._mat("textcol", C._srgb(255, 255, 255), rough=0.4, spec=0.2)  # raised WHITE text
    if font is None and os.path.exists(C.DEFAULT_SIGN_FONT):
        font = C.DEFAULT_SIGN_FONT
    C._box("field", (0, 0, 0.0), (1.72, 1.72, 0.36), mat=black, bevel=0.02)   # top ~0.18
    # coloured face octagon RECESSED (lower) in the middle...
    _octagon("face", radius=0.66, depth=0.30, z=0.24, mat=face, bevel=0.04, rot=0.0)   # POINT-TOP, top ~0.39
    # ...with a THIN raised WHITE octagon ring around it (source's proud, thin white outline)
    _oct_ring("ring", r_out=0.70, r_in=0.62, depth=0.44, z=0.29, mat=white, rot=0.0)   # THIN rim, top ~0.51 > face
    C._text("Stop" if kind == "STOP" else "Go", z=0.44, mat=textcol, extrude=0.04,
            size=0.63 if kind == "STOP" else 0.90, font=font)
    # THICK raised red bezel highest (top 0.58) -> casts shadow inward onto the ring + face
    _border("bezel", half=1.10, thick=0.32, z0=0.0, ztop=0.58, mat=frame, bevel=0.03)


@register("sign")
def render(args):
    # sign <out.png> [kind=STOP|GO] [px] [font]
    out = args[0] if args else "//sign.png"
    kind = args[1] if len(args) > 1 else "STOP"
    px = int(args[2]) if len(args) > 2 else 256
    font = args[3] if len(args) > 3 else None
    accent = (198, 0, 0) if kind == "STOP" else (0, 165, 0)  # red / green (GO green lifted for the recess)
    build_sign(kind, accent, font)
    C.setup_scene(px)
    return out
