"""soi3d.builders.mblock_collapse -- the Creeper segment's grow/shrink frames (bigger_mblock f02-f16).

Measured: six horizontal cylinder BARS (32 px long, top to bottom red/blue alternating, row bands 0-5,
6-10, 11-15, 16-20, 21-25, 26-31) that collapse from the BOTTOM up, one bar every 2 frames: a collapsing
bar shrinks symmetrically about x = 16 while it thickens a little (~5 -> 7 px), becomes a ball (~8 px)
and is gone the frame after. The per-bar widths below are read off the SD frames (bottom bar first
at f03), so the 3D bars keep the original timing exactly; pose "t" = frame index (f02 = 0).
"""
import math

import bpy

from .. import common as C
from .. import register_frames

S = 0.05  # Blender units per SD pixel (the 32 px block must fit the sweep camera)
BANDS = [(0, 6), (6, 11), (11, 16), (16, 21), (21, 26), (26, 32)]          # top .. bottom, pixel edges
WIDTHS = [[27, 19, 9, 7.5], [28, 20, 10, 7], [29, 21, 11, 8], [29, 23, 13, 8], [29, 23, 13, 8], [30, 25, 15, 8]]


def _bar_state(i, t, grow, starts=None):
    """(width, thickness, k) in SD px of bar i (0 = top) at frame t (k = frames into its collapse), or
    None once it has collapsed."""
    start = int(round(starts[i])) if starts else 1 + 2 * (5 - i)   # default: the bottom bar at f03, then every 2
    k = int(round(t)) - start + 1
    y0, y1 = BANDS[i]
    if k <= 0:
        return 32.0, float(y1 - y0), 0
    if k > 4:
        return None
    return float(WIDTHS[i][k - 1]), float(y1 - y0) + grow, k


def build(opts):
    C._clear()
    cols = [tuple(opts.get("red", (220, 0, 0))), tuple(opts.get("blue", (0, 0, 220)))]
    bars, mats = [], []
    for i in range(6):
        m = C._mat("bar%d" % i, C._srgb(*cols[i % 2]), rough=float(opts.get("rough", 0.35)),
                   spec=float(opts.get("spec", 0.3)))
        mats.append((m, cols[i % 2]))
        parts = []
        bpy.ops.mesh.primitive_cylinder_add(vertices=48, radius=1.0, depth=1.0, rotation=(0, math.pi / 2, 0))
        cyl = bpy.context.active_object
        tp = cyl.modifiers.new("taper", 'SIMPLE_DEFORM')
        tp.deform_method = 'TAPER'
        tp.deform_axis = 'Z'
        tp.factor = 0.0
        parts.append(cyl)
        for _ in (0, 1):
            bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=48, ring_count=24)
            parts.append(bpy.context.active_object)
        for o in parts:
            o.data.materials.append(m)
            bpy.context.view_layer.objects.active = o
            bpy.ops.object.shade_smooth()
        bars.append(parts)
    return bars, mats


def _frames_setup(opts):
    bars, mats = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"bars": bars, "mats": mats, "grow": float(opts.get("grow", 2.0)), "cx": float(opts.get("cx", 16.0)),
            "cap": float(opts.get("cap", 1.0)),
            "taper": [[0.0] + [float(opts.get("taper%s%d" % (c, k), opts.get("taper%d" % k, 0.0))) for k in (1, 2, 3)] + [0.0]
                      for c in ("r", "b")],
            "dim": [1.0] + [float(opts.get("dim%d" % k, d)) for k, d in ((1, 0.7), (2, 0.6), (3, 0.6), (4, 0.4))],
            "starts": [float(opts.get("start%d" % i, 1 + 2 * (5 - i))) for i in range(6)]}


def _frames_pose(ctx, pose):
    # pose {"t": frame index (f02 = 0), "pre": taper of the next bar due to collapse (0 = still straight)}
    t = float(pose.get("t", 0.0))
    pre = float(pose.get("pre", 0.0))
    for i, (cyl, c0, c1) in enumerate(ctx["bars"]):
        st = _bar_state(i, t, ctx["grow"], ctx["starts"])
        if st is None:
            for o in (cyl, c0, c1):
                o.hide_render = True
            continue
        w, th, k = st
        mat, rgb = ctx["mats"][i]
        mat.node_tree.nodes.get("Principled BSDF").inputs["Base Color"].default_value = \
            C._srgb(*(v * ctx["dim"][k] for v in rgb))                # a collapsing bar darkens
        r = th / 2 * S
        y0, y1 = BANDS[i]
        y = (16.0 - (y0 + y1) / 2) * S
        x = (ctx["cx"] - 16.0) * S
        body = max(0.0, w * S - 2 * r)
        for o in (cyl, c0, c1):
            o.hide_render = False
        cyl.hide_render = body <= 1e-4
        cyl.location = (x, y, 0.0)
        cyl.scale = (r, r, max(body, 1e-4))
        tf = ctx["taper"][i % 2][k] * (1 if i % 2 == 0 else -1) if body > 1e-4 else 0.0   # red thick right, blue thick left
        if k == 0 and int(round(ctx["starts"][i])) == int(round(t)) + 1:
            tf = pre * (1 if i % 2 == 0 else -1)
        cyl.modifiers["taper"].factor = tf                              # + = the right (+X) end thicker
        rc = r * ctx["cap"] if body > 1e-4 else w * S / 2          # a ball once the bar is no longer than it is thick
        for sgn, cap in ((-1, c0), (1, c1)):
            cap.location = (x + sgn * body / 2, y, 0.0)
            if body > 1e-4:
                s = r * (1.0 + sgn * tf / 2)
                cap.scale = (rc * (1.0 + sgn * tf / 2), s, s)
            else:
                cap.scale = (rc, rc, rc)


register_frames("mcollapse", _frames_setup, _frames_pose)
