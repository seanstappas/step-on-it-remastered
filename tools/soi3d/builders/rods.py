"""soi3d.builders.rods -- the Beenie's spread shot (beenie_sprites f02-f65): three rods fanning from a point.

In SD pixel units: red, blue and green rods (cylinders of radius "rod_r") start at the apex (the origin) and
lie on a cone of half-angle "half" around the axis, 120 deg apart in roll. "dir" turns the axis in the image
plane (0 = the cone opens to the right, 90 = up, 180 = left, 270 = down). Pose: "roll" (deg, spin about the
axis), "length" (px; the rods grow as the shot fans out), "half" (deg, optional: the bundle opens up in flight),
"axis_tilt" (deg, optional: the axis turned toward the camera; with opts "taper" > 0 the rods thin toward
the apex, a stand-in for the perspective of a shot flying at the viewer). Opts "persp_d" > 0 (px) renders the
rods in TRUE perspective instead: each pose re-lays every rod's two end rings where a camera persp_d px in
front of the apex would project them (x, y and radius scaled by d / (d - z)).
"""
import math

import bpy
import mathutils

from .. import common as C
from .. import register_frames

S = 0.05


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    root.rotation_mode = 'YZX'                                         # tilt about the cone's own Y, then turn by dir
    root.rotation_euler = (0.0, math.radians(f("axis_tilt", 0.0)), math.radians(f("dir", 0.0)))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    spin = bpy.context.active_object
    spin.name = "spin"
    spin.parent = root
    spin.location = (-f("apex_off", 16.0) * S, 0.0, 0.0)             # the apex off-centre: long rods stay in frame
    rods = []
    half = math.radians(f("half", 33.0))
    for i, (name, rgb) in enumerate((("red", opts.get("red", (230, 20, 20))), ("blue", opts.get("blue", (20, 20, 230))),
                                     ("green", opts.get("green", (20, 200, 20))))):
        m = C._mat(name, C._srgb(*rgb), rough=f("rough", 0.35), spec=f("spec", 0.35))
        r = f("rod_r", 1.4) * f("r_" + name, 1.0) * S
        if f("persp_d", 0.0) > 0:
            o = _tube("rod_" + name, r)
        else:
            bpy.ops.mesh.primitive_cone_add(vertices=16, radius1=r * (1.0 - f("taper", 0.0)), radius2=r, depth=1.0)   # taper: thin apex
            o = bpy.context.active_object
            o.name = "rod_" + name
            o.data.transform(mathutils.Matrix.Translation((0, 0, 0.5)))   # the base at the apex, the rod along +Z
        o.data.materials.append(m)
        bpy.ops.object.shade_smooth()
        a = math.radians(120.0 * i * (-1.0 if opts.get("mirror", False) else 1.0) + f("a_" + name, 0.0))   # mirror = the depth-flipped order
        o.rotation_mode = 'QUATERNION'
        o.parent = spin
        rods.append((o, f("l_" + name, 1.0), a))
        _aim(o, half, a)
    return root, spin, rods


def _aim(o, half, a):
    d = mathutils.Vector((math.cos(half), math.sin(half) * math.cos(a), math.sin(half) * math.sin(a)))
    o.rotation_quaternion = mathutils.Vector((0, 0, 1)).rotation_difference(d)


SEG = 16


def _tube(name, r):
    """A capped tube along local +Z (0..1) whose ring vertices _persp re-lays per pose: verts [0, SEG) = the
    apex ring, [SEG, 2 SEG) = the far ring."""
    import bmesh
    me, bm = bpy.data.meshes.new(name), bmesh.new()
    rings = [[bm.verts.new((r * math.cos(2 * math.pi * k / SEG), r * math.sin(2 * math.pi * k / SEG), z))
              for k in range(SEG)] for z in (0.0, 1.0)]
    for k in range(SEG):
        j = (k + 1) % SEG
        bm.faces.new((rings[0][k], rings[0][j], rings[1][j], rings[1][k]))
    bm.faces.new(rings[0][::-1])
    bm.faces.new(rings[1])
    bm.to_mesh(me)
    bm.free()
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    bpy.context.view_layer.objects.active = o
    o.select_set(True)
    o["rod_r"] = r
    return o


def _persp(o, dist):
    """Re-lay the tube's rings as a camera `dist` (Blender units) in front of the world origin sees them."""
    mw = o.matrix_world.copy()
    a, b = mw @ mathutils.Vector((0, 0, 0)), mw @ mathutils.Vector((0, 0, 1))
    proj = lambda p: (mathutils.Vector((p.x * dist / (dist - p.z), p.y * dist / (dist - p.z), p.z)), dist / (dist - p.z))
    (pa, fa), (pb, fb) = proj(a), proj(b)
    w = (pb - pa)
    w = w.normalized() if w.length > 1e-9 else mathutils.Vector((0, 0, 1))
    up = mathutils.Vector((0, 0, 1)) if abs(w.z) < 0.9 else mathutils.Vector((1, 0, 0))
    u = w.cross(up).normalized()
    v = w.cross(u)
    inv, r = mw.inverted(), float(o["rod_r"])
    for ring, (c, fk) in enumerate(((pa, fa), (pb, fb))):
        for k in range(SEG):
            t = 2 * math.pi * k / SEG
            o.data.vertices[ring * SEG + k].co = inv @ (c + r * fk * (math.cos(t) * u + math.sin(t) * v))
    o.data.update()


def _frames_setup(opts):
    root, spin, rods = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "spin": spin, "rods": rods, "half": float(opts.get("half", 33.0)),
            "tilt": float(opts.get("axis_tilt", 0.0)), "dir": float(opts.get("dir", 0.0)),
            "persp": float(opts.get("persp_d", 0.0)) * S}


def _frames_pose(ctx, pose):
    ctx["root"].rotation_euler = (0.0, math.radians(float(pose.get("axis_tilt", ctx["tilt"]))), math.radians(ctx["dir"]))
    ctx["spin"].rotation_euler = (math.radians(float(pose.get("roll", 0.0))), 0.0, 0.0)
    ln = max(float(pose.get("length", 10.0)), 0.1) * S
    half = math.radians(float(pose.get("half", ctx["half"])))
    for o, lf, a in ctx["rods"]:
        o.scale = (1.0, 1.0, ln * lf)
        _aim(o, half, a)
    if ctx["persp"] > 0:
        bpy.context.view_layer.update()
        for o, _, _ in ctx["rods"]:
            _persp(o, ctx["persp"])


register_frames("rods", _frames_setup, _frames_pose)
