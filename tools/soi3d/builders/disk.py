"""soi3d.builders.disk -- the FAITHFUL green goody disk: a matte green ball with four raised red
half-cone blades, symmetric (it is spun in the remaster) and dropped low so they sit on the sphere.

`_half_cone_blade` is the shipping blade. `_spike`, `_cone_blade` and `_star_stud` are earlier blade
experiments kept for reference (currently UNUSED, superseded by `_half_cone_blade`).
"""
import math

import bpy

from .. import common as C
from .. import register


def _spike(name, ang_deg, r_base, r_tip, half_w, base_z, apex_z, mat):
    """UNUSED (superseded by _half_cone_blade). A raised triangular RED blade pointing outward from
    `ang_deg`: its base edge sits on the central square (width 2*half_w at r_base), the tip reaches
    r_tip, and a lifted apex gives 3D relief so each blade catches light and casts a shadow."""
    import bmesh
    a = math.radians(ang_deg)
    ca, sa = math.cos(a), math.sin(a)
    px, py = -sa, ca
    b1 = (r_base * ca + half_w * px, r_base * sa + half_w * py, base_z)
    b2 = (r_base * ca - half_w * px, r_base * sa - half_w * py, base_z)
    tip = (r_tip * ca, r_tip * sa, base_z)
    mid = (r_base + r_tip) * 0.5
    apex = (mid * ca, mid * sa, apex_z)
    bm = bmesh.new()
    v1 = bm.verts.new(b1)
    v2 = bm.verts.new(b2)
    vt = bm.verts.new(tip)
    va = bm.verts.new(apex)
    bm.faces.new((va, v1, vt))
    bm.faces.new((va, vt, v2))
    bm.faces.new((va, v2, v1))
    bm.faces.new((v1, v2, vt))    # flat base
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    obj.data.materials.append(mat)
    return obj


def _cone_blade(name, ang_deg, r_inner, r_outer, base_rad, z, mat, flat=0.62):
    """UNUSED (superseded by _half_cone_blade). A smooth RED half-cone spike pointing outward at
    `ang_deg`: a cone laid radially on the ball front (apex out, base at the hub), flattened toward
    the surface (`flat`) so it reads as a rounded half-cone, not a flat prism."""
    a = math.radians(ang_deg)
    length = r_outer - r_inner
    mid = (r_inner + r_outer) * 0.5
    bpy.ops.mesh.primitive_cone_add(vertices=28, radius1=base_rad, radius2=0.0, depth=length,
                                    location=(0, 0, 0))
    obj = bpy.context.active_object
    obj.name = name
    obj.rotation_euler = (0, math.radians(90), a)      # apex -> outward radial at angle a
    obj.scale = (flat, 1.0, 1.0)                        # local X maps to world -Z -> flatten profile
    obj.location = (mid * math.cos(a), mid * math.sin(a), z)
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def _half_cone_blade(name, ang_deg, r_inner, r_outer, base_rad, mat, z=0.92, seg=24):
    """A HALF-cone (a cone sliced along its long axis: a FLAT underside + a ROUNDED top), tapering from a
    semicircular base at the inner end to a point at the tip. Laid FLAT and radial (planar, un-tilted) and
    dropped LOW (small `z`) so its inner part tucks just into the sphere front -> the rounded ridge sits
    down on the ball (base tucked in, no scoop) and casts a tight shadow."""
    import bmesh
    length = r_outer - r_inner
    bm = bmesh.new()
    apex = bm.verts.new((length, 0.0, 0.0))          # tip (outer)
    ctr = bm.verts.new((0.0, 0.0, 0.0))              # centre of the base half-disc (inner)
    arc = []
    for i in range(seg + 1):
        t = math.pi * i / seg
        arc.append(bm.verts.new((0.0, base_rad * math.cos(t), base_rad * math.sin(t))))  # base semicircle (+Z)
    for i in range(seg):
        bm.faces.new((apex, arc[i], arc[i + 1]))     # rounded top
        bm.faces.new((ctr, arc[i + 1], arc[i]))      # base half-disc cap
    bm.faces.new((apex, arc[seg], arc[0]))           # flat underside triangle (faces the sphere)
    bm.faces.new((ctr, arc[0], arc[seg]))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    for poly in me.polygons:
        poly.use_smooth = True
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    # place FLAT and radial (planar, un-tilted), dropped to a low `z` so the inner/underside tucks just
    # into the sphere front (hidden inside it) -> the ridge sits DOWN on the ball rather than floating high.
    a = math.radians(ang_deg)
    obj.rotation_euler = (0.0, 0.0, a)
    obj.location = (r_inner * math.cos(a), r_inner * math.sin(a), z)
    obj.data.materials.append(mat)
    return obj


def _star_stud(name, angles, r_out, r_valley, z_base, z_apex, mat, bevel=0.03):
    """UNUSED (superseded by _half_cone_blade). A raised, convex 4-point star STUD: a central APEX
    with faces sloping down to outer points (r_out at `angles`) and inner valleys (r_valley). Being
    convex there is no central pit and no converging blade-shadow, so the centre never reads dark."""
    import bmesh
    ring = []
    for a in angles:
        ring.append((a % 360.0, r_out))
        ring.append(((a + 45.0) % 360.0, r_valley))
    ring.sort()
    bm = bmesh.new()
    apex = bm.verts.new((0.0, 0.0, z_apex))
    base = []
    for ang, r in ring:
        rad = math.radians(ang)
        base.append(bm.verts.new((r * math.cos(rad), r * math.sin(rad), z_base)))
    n = len(base)
    for i in range(n):
        bm.faces.new((apex, base[i], base[(i + 1) % n]))
    bm.faces.new(list(reversed(base)))   # bottom cap
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    if bevel > 0:
        mo = obj.modifiers.new("bev", 'BEVEL')
        mo.width = bevel
        mo.segments = 2
    obj.data.materials.append(mat)
    return obj


def build_disk(blade_angles=(45, 135, 225, 315), tilt_x=0.0, tilt_y=0.0, spin=0.0):
    """FAITHFUL Step-On-It goody disk: a GREEN ball with FOUR raised RED half-cone blades. The blades
    are SYMMETRIC (even 90 deg) because in the remaster this disk is ANIMATED: the blades are parented
    to a pivot at the ball centre and SPUN (rotation about the pivot Z). Pass explicit blade_angles /
    tilt only to reproduce one specific source spin frame. The centre is just the sphere (dark green
    shadow), not a distinct hub; the composited glint (apply_glint.py) adds the view-locked shine."""
    C._clear()
    # MATTE 'playdough' green ball: soft diffuse form so the top-left reads bright and the
    # bottom-right falls into a DARK, shadowy green (like the source) -> no glossy halo/rim. A faint
    # flat green emission keeps the deepest shadow a dark GREEN rather than a neutral grey/black.
    green = C._mat("green", C._srgb(0, 104, 0), rough=0.6, spec=0.1, coat=0.0)
    gb = green.node_tree.nodes.get("Principled BSDF")
    ec = gb.inputs.get("Emission Color")
    es = gb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(0, 92, 0)
    if es is not None:
        es.default_value = 0.06
    # MATTE 'playdough' red blades: high roughness + zero specular -> soft clay, not glossy plastic.
    red = C._mat("red", C._srgb(206, 16, 16), rough=0.95, spec=0.0)
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=96, ring_count=48)
    ball = bpy.context.active_object
    ball.name = "ball"
    ball.data.materials.append(green)
    bpy.ops.object.shade_smooth()
    # soft CATCH light (disk-only) -> a gentle real highlight top-left under the composited glint
    bpy.ops.object.light_add(type='POINT', location=(-2.9, 3.4, 2.3))   # higher + further top-left
    glint = bpy.context.active_object
    glint.name = "glint"
    glint.data.energy = 450
    glint.data.shadow_soft_size = 0.35
    # pivot empty at the ball centre; the blade assembly tilts+spins about it as one rigid body
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    # FOUR red HALF-CONE blades laid FLAT-SIDE-DOWN directly on the sphere surface, so each casts a
    # TIGHT ridge shadow (not a floating full-cone shadow). Separate, with GREEN GAPS at the diagonals.
    for ang in blade_angles:
        bl = _half_cone_blade("blade%d" % int(ang), ang, r_inner=0.30, r_outer=0.88, base_rad=0.28,
                              mat=red)
        bl.parent = pivot
        bl.matrix_parent_inverse.identity()
    pivot.rotation_euler = (math.radians(tilt_x), math.radians(tilt_y), math.radians(spin))


@register("disk")
def render(args):
    # disk <out.png> [px] [tilt_x] [tilt_y] [spin]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    tx = float(args[2]) if len(args) > 2 else 0.0
    ty = float(args[3]) if len(args) > 3 else 0.0
    sp = float(args[4]) if len(args) > 4 else 0.0
    build_disk(tilt_x=tx, tilt_y=ty, spin=sp)
    # ambient lifted so the shadowed centre stays dark GREEN, not black
    C.setup_scene(px, world_strength=0.19, fill_energy=0.16)
    return out
