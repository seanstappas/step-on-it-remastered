"""soi3d.builders.teeth -- the Teeth nasty (teeth_sprites f02-f50, 36 x 28): wind-up chattering teeth.

Measured on f10 (closed, facing right), f26 (front view) and f02 (open): two red horseshoe GUMS (a U 24 px
wide and ~25 px long: straight arms along the facing direction + a semicircular front), each ~4.5 px tall,
carrying a row of white rounded TEETH (~5 px wide, spaced ~8 px along the U) that interlock when closed
(rows 18-22 of f10). The upper jaw is hinged at the BACK of the arms and opens up to ~43 deg (f02). The
sheet: f02-f18 face right and chatter (closed at f10), f19-f31 turn to face left through the front view
(f26), f32-f50 face left and chatter; odd/even frames hop 2 px (per-frame "shift").
"""
import math

import bmesh
import bpy

from .. import common as C
from .. import register_frames

S = 0.035  # Blender units per SD pixel (the open jaw must stay inside the sweep camera's +-1.07 units)


def _u_path(arm, r, n_arc=24, n_arm=6):
    """Points (x, z) along the U: the left arm (back -> front), the front semicircle, the right arm back."""
    pts = []
    x0, xc = -arm, arm * 0.0 + (0.0)
    for i in range(n_arm):
        pts.append((x0 + (xc - x0) * i / n_arm, r))
    for i in range(n_arc + 1):
        a = math.pi / 2 - math.pi * i / n_arc
        pts.append((xc + r * math.cos(a), r * math.sin(a)))
    for i in range(1, n_arm + 1):
        pts.append((xc + (x0 - xc) * i / n_arm, -r))
    return pts


def _gum(name, pts, y0, y1, thick, mat):
    """Sweep a rectangle (radial thickness `thick`, height y0..y1) along the open U path."""
    bm = bmesh.new()
    rings = []
    for i, (x, z) in enumerate(pts):
        if i == 0:
            tx, tz = pts[1][0] - x, pts[1][1] - z
        elif i == len(pts) - 1:
            tx, tz = x - pts[i - 1][0], z - pts[i - 1][1]
        else:
            tx, tz = pts[i + 1][0] - pts[i - 1][0], pts[i + 1][1] - pts[i - 1][1]
        ln = math.hypot(tx, tz) or 1.0
        nx, nz = tz / ln, -tx / ln                    # outward normal of the U in the xz plane
        h = thick / 2
        rings.append([bm.verts.new((x + nx * h, y0, z + nz * h)), bm.verts.new((x + nx * h, y1, z + nz * h)),
                      bm.verts.new((x - nx * h, y1, z - nz * h)), bm.verts.new((x - nx * h, y0, z - nz * h))])
    for a, b in zip(rings[:-1], rings[1:]):
        for k in range(4):
            bm.faces.new((a[k], a[(k + 1) % 4], b[(k + 1) % 4], b[k]))
    bm.faces.new(rings[0][::-1])
    bm.faces.new(rings[-1])
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    bm.to_mesh(me)
    bm.free()
    ob = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(ob)
    bv = ob.modifiers.new("bev", 'BEVEL')
    bv.width = 0.7 * S
    bv.segments = 2
    bv.limit_method = 'ANGLE'
    ob.data.materials.append(mat)
    return ob


def _teeth(prefix, pts, n, y_root, height, width, depth, up, mat, offset=0.0, fang=0.0, box=False):
    """n rounded teeth spaced evenly along the U path, rooted at y_root, pointing up (+1) or down (-1);
    fang > 0 narrows each tooth toward its tip (a rounded cone instead of an egg); box = rounded blocks."""
    seg = [math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(pts[:-1], pts[1:])]
    total = sum(seg)
    out = []
    for k in range(n):
        s = (k + 0.5 + offset) / n * total
        acc = 0.0
        for i, L in enumerate(seg):
            if acc + L >= s or i == len(seg) - 1:
                t = (s - acc) / L if L else 0.0
                x = pts[i][0] + (pts[i + 1][0] - pts[i][0]) * t
                z = pts[i][1] + (pts[i + 1][1] - pts[i][1]) * t
                ang = math.atan2(pts[i + 1][1] - pts[i][1], pts[i + 1][0] - pts[i][0])
                break
            acc += L
        if box:
            bpy.ops.mesh.primitive_cube_add(size=2.0, location=(x, y_root + up * height / 2, z))
        else:
            bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=20, ring_count=12,
                                                 location=(x, y_root + up * height / 2, z))
        tooth = bpy.context.active_object
        tooth.name = "%s%d" % (prefix, k)
        if fang > 0:
            for v in tooth.data.vertices:                 # taper x/z by the height along the tooth
                f = 1.0 - fang * max(0.0, v.co.y * up)
                v.co.x *= f
                v.co.z *= f
        tooth.scale = (width / 2, height / 2, depth / 2)
        tooth.rotation_euler = (0.0, -ang, 0.0)
        tooth.data.materials.append(mat)
        if box:
            bv = tooth.modifiers.new("bev", 'BEVEL')
            bv.width = 0.3
            bv.segments = 3
        bpy.ops.object.shade_smooth()
        out.append(tooth)
    return out


def build_teeth(opts):
    C._clear()
    red = C._mat("gum", C._srgb(*opts.get("red", (220, 0, 0))), rough=float(opts.get("rough", 0.35)),
                 spec=float(opts.get("spec", 0.3)))
    white = C._mat("tooth", C._srgb(*opts.get("white", (235, 235, 235))), rough=float(opts.get("t_rough", 0.3)),
                   spec=float(opts.get("t_spec", 0.4)))
    arm, r = float(opts.get("arm", 13.0)) * S, float(opts.get("half_w", 11.0)) * S
    pts = _u_path(arm, r)
    gh, gt = float(opts.get("gum_h", 4.5)) * S, float(opts.get("gum_t", 3.5)) * S
    th, tw, n = float(opts.get("tooth_h", 4.5)) * S, float(opts.get("tooth_w", 5.0)) * S, int(opts.get("n_teeth", 8))
    lo_top = -float(opts.get("gap", 2.5)) * S
    up_bot = float(opts.get("gap", 2.5)) * S
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    bpy.ops.object.empty_add(location=(float(opts.get("pivot_x", 0.0)) * S, 0, 0))
    off = bpy.context.active_object
    off.name = "offset"                  # the yaw axis sits pivot_x px behind the U centre
    off.parent = root
    lower = [_gum("gum_lo", pts, lo_top - gh, lo_top, gt, red)]
    lower += _teeth("tl", pts, n, lo_top, th, tw, gt * float(opts.get("tooth_d", 0.9)), 1, white,
                    fang=float(opts.get("fang", 0.0)), box=opts.get("tooth_shape") == "box")
    for o in lower:
        o.parent = off
    bpy.ops.object.empty_add(location=(-arm, up_bot, 0.0))            # the hinge: back of the arms
    hinge = bpy.context.active_object
    hinge.name = "hinge"
    hinge.parent = off
    upper = [_gum("gum_up", pts, up_bot, up_bot + gh, gt, red)]
    upper += _teeth("tu", pts, n, up_bot, th, tw, gt * float(opts.get("tooth_d", 0.9)), -1, white, offset=0.5,
                    fang=float(opts.get("fang", 0.0)), box=opts.get("tooth_shape") == "box")
    for o in upper:
        o.parent = hinge
        o.matrix_parent_inverse = hinge.matrix_basis.inverted()     # built in the offset frame, like the lower jaw
    root.rotation_mode = 'YXZ'
    return root, hinge


def _frames_setup(opts):
    root, hinge = build_teeth(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "hinge": hinge, "tilt": math.radians(float(opts.get("tilt", 0.0)))}


def _frames_pose(ctx, pose):
    # pose {"yaw": deg (0 = facing right, 180 = facing left), "jaw": deg the upper jaw is open}
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(float(pose.get("yaw", 0.0))), 0.0)
    ctx["hinge"].rotation_euler = (0.0, 0.0, math.radians(float(pose.get("jaw", 0.0))))


register_frames("teeth", _frames_setup, _frames_pose)


def _ball_setup(opts):
    """The Teeth's SPAWNER (teeth_sprites f51, 32 x 32): the teeth facing the camera, mounted in the flat front
    window of a glossy blue ball (a sphere of `ball_r` px whose front cap is cut off `win_d` px in front of its
    centre, so the blue window face shows between the teeth and a blue rim rings them)."""
    root, hinge = build_teeth(opts)
    f = lambda k, d: float(opts.get(k, d))
    ts = f("teeth_scale", 0.78)                                        # the teeth sit well inside the ball's rim
    root.scale = (ts, ts, ts)
    bc = tuple(max(0, min(255, int(round(v * f("ball_gain", 1.0))))) for v in opts.get("ball", (20, 30, 200)))
    blue = C._mat("ball", C._srgb(*bc), rough=f("ball_rough", 0.25), spec=f("ball_spec", 0.5), coat=f("ball_coat", 0.3))
    br, bz = f("ball_r", 15.5) * S, -f("teeth_z", 2.0) * S
    bpy.ops.mesh.primitive_uv_sphere_add(radius=br, segments=64, ring_count=32, location=(0, f("ball_y", 0.0) * S, bz))
    ball = bpy.context.active_object
    ball.name = "ballsphere"
    bpy.ops.object.shade_smooth()
    bpy.ops.mesh.primitive_cylinder_add(vertices=64, radius=br * 1.5, depth=br * 2,
                                        location=(0, 0, bz + f("win_d", 9.0) * S + br))
    cut = bpy.context.active_object
    m = ball.modifiers.new("win", 'BOOLEAN')
    m.operation = 'DIFFERENCE'
    m.object = cut
    bpy.context.view_layer.objects.active = ball
    bpy.ops.object.modifier_apply(modifier="win")
    bpy.data.objects.remove(cut, do_unlink=True)
    ball.data.materials.append(blue)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root, "hinge": hinge, "tilt": math.radians(f("tilt", 0.0))}


def _ball_pose(ctx, pose):
    # the teeth face the camera (+z): yaw -90 turns their front (+x) to +z; "jaw" opens the upper jaw
    ctx["root"].rotation_euler = (ctx["tilt"], math.radians(-90.0 + float(pose.get("yaw", 0.0))), 0.0)
    ctx["hinge"].rotation_euler = (0.0, 0.0, math.radians(float(pose.get("jaw", 0.0))))


register_frames("teethball", _ball_setup, _ball_pose)
