"""soi3d.builders.goodies -- static goody props of goody_sprites (keys, doors, the magic arrow).

In SD pixel units of the 32x32 cell (S = 0.05 units/px, shared with _rbox; +x right, +y up, +z toward the
camera, origin = cell centre, so pixel column c / row r sit at x = c - 15.5, y = 15.5 - r), seen face-on and
lit from the top left like the board tiles. `kind`:
  key       a torus bow (tilted back by `bow_tilt`) with a dark centre, a square shaft and `teeth`
            ([y, half height, length] each, sticking out to the right), all in `color`
  arrow     the Magic Arrow pointing up: a `color` cone head, a white shaft and two swept `color` fins
  door      a white frame (top + jambs) around a `color` panel: "closed" = the panel with two gold hinges
            (plate + knuckle) and a gold lock (plate, knob, lower plate); "open" = the panel swung open,
            seen edge-on at the hinge side, a black doorway behind it and the hinge plate on the jamb
  frame     a gold picture frame (22 x 30 px, f25) around a recessed `color` panel
  turtle    the green turtle (f47, facing right): a low domed shell, a head ball on a neck, four stubby legs,
            a small tail
  gift      the gift box (f52): a `color` cube turned by `gift_yaw` and tipped toward the camera by
            `gift_tilt`, two `ribbon` bands around it and a bow (two loops + a knot) on top
  shield    the silver shield (f49): the crest outline (horned top corners, a bump between, a point below)
            extruded and bulged into a spherical cap, gold studs on the horn tips and the point
  helmet    the winged helmet (f50): a white dome, a dark grey rim below it, jagged red wings each side
  shoe      the sneaker (f51): a white vamp, a `color` heel and collar, a blue side stripe and a sole, built toe
            along -x and turned (`shoe_yaw`), tipped (`shoe_tilt`) and rolled (`shoe_roll`) toe-down-left
"""
import math

import bpy

from .. import common as C
from .. import register_frames
from .biped import _rbox
from .quadruped import S
from .tile import _prism


def _mat(opts, key, dflt, rough=0.35, spec=0.35):
    g = float(opts.get(key + "_gain", 1.0)) * float(opts.get("gain", 1.0))
    rgb = tuple(max(0, min(255, int(round(v * g)))) for v in opts.get(key, dflt))
    return C._mat(key, C._srgb(*rgb), rough=float(opts.get(key + "_rough", opts.get("rough", rough))),
                  spec=float(opts.get("spec", spec)))


def _cyl(name, c, r, h, mat, rot=(0.0, 0.0, 0.0), verts=32):
    bpy.ops.mesh.primitive_cylinder_add(vertices=verts, radius=r * S, depth=h * S, location=tuple(v * S for v in c),
                                        rotation=rot)
    o = bpy.context.active_object
    o.name = name
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def _key(opts, f, col):
    kx, by, R, r, fy = f("key_x", 0.0), f("bow_y", 9.5), f("bow_R", 5.25), f("bow_r", 2.75), f("bow_fy", 0.69)
    bpy.ops.mesh.primitive_torus_add(major_radius=R * S, minor_radius=r * S, major_segments=48, minor_segments=16,
                                     location=(kx * S, by * S, 0))
    bow = bpy.context.active_object                                   # a donut seen face-on, oval (16 x 11 px)
    bow.scale = (1.0, fy, 1.0)
    bow.data.materials.append(col)
    bpy.ops.object.shade_smooth()
    hole = _cyl("hole", (kx, by, -r * 0.3), R - r * 0.5, 0.6, _mat(opts, "dark", (18, 12, 12), 0.8, 0.1))
    hole.scale = (1.0, fy, 1.0)
    sw, sd = f("shaft_w", 2.0), f("shaft_d", 1.5)
    top, bot = by - (R + r * 0.5) * fy, f("shaft_bot", -14.8)
    _rbox("shaft", (kx, (top + bot) / 2, 0), (sw, (top - bot) / 2, sd), 0.6, col)
    for i, (ty, th, tl) in enumerate(opts.get("teeth", [[1.5, 1.5, 3.0], [-2.5, 1.5, 2.0], [-6.5, 1.5, 5.0], [-11.5, 1.5, 3.0]])):
        _rbox("tooth%d" % i, (kx + sw + tl / 2 - 0.5, ty, 0), (tl / 2 + 0.5, th, sd * 0.9), 0.5, col)


def _arrow(opts, f, col, white):
    hy, hl, hr = f("head_y", 10.0), f("head_l", 9.0), f("head_r", 5.5)
    bpy.ops.mesh.primitive_cone_add(vertices=40, radius1=hr * S, radius2=0.0, depth=hl * S,
                                    location=(0, hy * S, 0), rotation=(-math.pi / 2, 0, 0))   # local +z (tip) -> +y
    head = bpy.context.active_object
    head.data.materials.append(col)
    bpy.ops.object.shade_smooth()
    sy0, sy1 = hy - hl / 2 + 0.5, f("tail_y", -10.5)
    _cyl("shaft", (0, (sy0 + sy1) / 2, 0), f("shaft_r", 1.6), sy0 - sy1, white, (math.pi / 2, 0, 0), 24)
    fd = f("fin_d", 1.2)
    left = [(-f("fin_root", 1.2), -f("fin_top", 5.0)), (-f("fin_out", 5.8), -f("fin_sh", 8.5)),       # counter-clockwise
            (-f("fin_out", 5.8), -f("fin_bot", 15.0)), (-f("fin_in", 4.3), -f("fin_bot", 15.0)), (-f("fin_root", 1.2), -f("fin_ie", 11.0))]
    for pts in (left, [(-x, y) for x, y in left][::-1]):                  # the right fin = the mirror, re-wound
        _prism("fin", [(x * S, y * S) for x, y in pts], -fd / 2 * S, fd * S, col, 0.35 * S)


def _door(opts, f, col, white):
    wf, fd = f("frame_w", 2.5), f("frame_d", 2.0)
    _rbox("frame_top", (0, 13.75, 0), (16.0, 2.0, fd), 0.7, white)
    for sx in (-1.0, 1.0):
        _rbox("jamb", (sx * (16.0 - wf), -2.0, 0), (wf, 14.0, fd), 0.7, white)
    gold = _mat(opts, "gold", (215, 175, 10), 0.3, 0.6)
    inner = 16.0 - 2 * wf
    pd = f("panel_d", 1.0)
    if opts.get("state", "closed") == "closed":
        _rbox("panel", (0, -2.0, -fd + pd), (inner + 0.5, 14.0, pd), 0.4, col)
        pz = -fd + 2 * pd
        sx0 = -inner + 2.0                                           # the knuckle strap (f05 cols 6-7)
        tl = f("hinge_l", 6.5)
        for py, ph, ky, kh in ((3.5, 1.6, 3.0, 4.5), (-9.5, 1.6, -9.0, 4.0)):   # f05 tongues rows 11-13, 24-26
            tongue = [(sx0, py - ph), (sx0 + tl - 1.5, py - ph * 0.8), (sx0 + tl, py), (sx0 + tl - 1.5, py + ph * 0.8), (sx0, py + ph)]
            _prism("hinge", [(x * S, y * S) for x, y in tongue], pz * S, 0.8 * S, gold, 0.3 * S)
            _cyl("knuckle", (sx0, ky, pz), 1.0, 2 * kh, gold, (math.pi / 2, 0, 0), 16)
        lx = inner - f("lock_x", 4.5)
        _rbox("lock2", (lx, f("lock2_y", -9.0), pz), (f("lock2_w", 1.5), f("lock2_h", 4.0), 0.5), 0.4, gold)   # keyhole plate
        kr = f("knob_r", 2.6)                                        # the knob (its shadow falls down-right)
        bpy.ops.mesh.primitive_uv_sphere_add(radius=kr * S, location=(lx * S, f("knob_y", 1.0) * S, (pz + kr * 0.8) * S))
        knob = bpy.context.active_object
        knob.scale = (1.0, 1.0, f("knob_fz", 1.0))
        knob.data.materials.append(gold)
        bpy.ops.object.shade_smooth()
    else:
        _rbox("doorway", (0, -2.0, -fd - 0.2), (inner + 0.5, 14.0, 0.3), 0.0, _mat(opts, "dark", (4, 4, 4), 0.9, 0.0))
        pw = f("open_w", 2.6)                                             # the panel seen edge-on at the hinge side
        _rbox("panel", (-inner + pw, -2.0, 0.2), (pw, 14.0, f("open_d", 1.5)), 0.4, col)
        _rbox("hinge", (-16.0 + wf, f("ohinge_y", 0.0), fd + 0.3), (wf - 0.3, f("ohinge_h", 3.0), 0.4), 0.3, gold)   # f02 rows 13-18


def _frame(opts, f, col):
    gold = _mat(opts, "gold", (215, 175, 10), 0.3, 0.6)
    hw, hh, fd = f("fr_hw", 11.0), f("fr_hh", 15.0), f("fr_d", 1.6)
    t, b, s = f("fr_top", 3.0), f("fr_bot", 4.0), f("fr_side", 3.5)   # bar widths
    _rbox("top", (0, hh - t / 2, 0), (hw, t / 2, fd), 0.8, gold)
    _rbox("bot", (0, -hh + b / 2, 0), (hw, b / 2, fd), 0.8, gold)
    for sx in (-1.0, 1.0):
        _rbox("side", (sx * (hw - s / 2), 0, 0), (s / 2, hh, fd), 0.8, gold)
    _rbox("panel", (0, (t - b) / 2, -fd * 0.4), (hw - s + 0.3, hh - (t + b) / 2 + 0.3, fd * 0.5), 0.3, col)


def _turtle(opts, f, col):
    from .quadruped import _ell
    sx, sy, shw, shh, shz = f("shell_x", -2.0), f("shell_y", -3.5), f("shell_hw", 10.0), f("shell_h", 6.0), f("shell_hz", 7.0)
    smat = _mat(opts, "shell", opts.get("color", (0, 150, 0)), 0.4, 0.3)
    if f("shell_check", 0.0) > 0:                                  # the source shell's light/dark scute checker
        nt = smat.node_tree
        chk = nt.nodes.new("ShaderNodeTexChecker")
        chk.inputs["Scale"].default_value = f("shell_check", 0.0)
        base = smat.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value
        dk = f("check_dark", 0.45)
        chk.inputs["Color1"].default_value = tuple(base)
        chk.inputs["Color2"].default_value = (base[0] * dk, base[1] * dk, base[2] * dk, 1.0)
        nt.links.new(chk.outputs["Color"], nt.nodes["Principled BSDF"].inputs["Base Color"])
    shell = _ell("shell", (sx, sy, 0), (shw, shh, shz), smat)
    bpy.ops.mesh.primitive_cube_add(size=2.0, location=(sx * S, (sy - shh) * S, 0))   # keep the dome above the rim
    cut = bpy.context.active_object
    cut.scale = ((shw + 1) * S, shh * S, (shz + 1) * S)
    m = shell.modifiers.new("rim", 'BOOLEAN')
    m.operation = 'DIFFERENCE'
    m.object = cut
    bpy.context.view_layer.objects.active = shell
    bpy.ops.object.modifier_apply(modifier="rim")
    bpy.data.objects.remove(cut, do_unlink=True)
    _ell("belly", (sx, sy, 0), (shw * 0.92, f("belly_h", 1.2), shz * 0.92), col)
    hx, hy = f("head_x", 10.5), f("head_y", 5.5)
    _ell("head", (hx, hy, 0), (f("head_rx", 4.3), f("head_ry", 3.2), f("head_rz", 3.0)), col)
    nx0, ny0 = sx + shw * f("neck_x0", 0.7), sy + f("neck_y0", 1.5)   # the neck runs from the shell front to the head
    L = math.hypot(hx - nx0, hy - ny0)
    _cyl("neck", ((hx + nx0) / 2, (hy + ny0) / 2, 0), f("neck_r", 2.0), L, col, (-math.pi / 2, 0, -math.atan2(hx - nx0, hy - ny0)), 16)
    lh, lr = f("leg_h", 5.0), f("leg_r", 2.3)
    for lx in (f("leg_rx", -7.5), f("leg_fx", 2.5)):
        for lz in (-1.0, 1.0):
            _ell("leg", (lx, sy - lh / 2, lz * shz * 0.6), (lr, lh / 2 + 0.5, lr), col, 16)
    bpy.ops.mesh.primitive_cone_add(vertices=12, radius1=f("tail_r", 1.0) * S, radius2=0.0, depth=f("tail_l", 3.5) * S,
                                    location=((sx - shw - f("tail_l", 3.5) / 2 + 1.0) * S, (sy + 1.0) * S, 0), rotation=(0, -math.pi / 2, 0))
    bpy.context.active_object.data.materials.append(col)


def _gift(opts, f, col):
    from .quadruped import _ell
    h, rw = f("box_h", 8.9), f("ribbon_w", 1.6)
    ribbon = _mat(opts, "ribbon", (20, 40, 215), 0.35, 0.4)
    bpy.ops.object.empty_add(location=(f("gift_x", 0.5) * S, f("gift_y", -4.0) * S, 0))
    root = bpy.context.active_object
    root.rotation_mode = 'YXZ'                                     # turn about the vertical, then tip the top forward
    root.rotation_euler = (math.radians(f("gift_tilt", 18.0)), math.radians(f("gift_yaw", 27.0)), 0.0)
    _rbox("box", (0, 0, 0), (h, h, h), f("box_bevel", 0.8), col).parent = root
    _rbox("band_x", (0, 0, 0), (h + 0.25, h + 0.25, rw), 0.3, ribbon).parent = root
    _rbox("band_z", (0, 0, 0), (rw, h + 0.25, h + 0.25), 0.3, ribbon).parent = root
    ew = f("edge_w", 0.6)                                          # the ribbon's red borders (just under it, wider)
    if ew > 0:
        edge = _mat(opts, "edge", (200, 20, 40), 0.5, 0.2)
        _rbox("edge_x", (0, 0, 0), (h + 0.15, h + 0.15, rw + ew), 0.3, edge).parent = root
        _rbox("edge_z", (0, 0, 0), (rw + ew, h + 0.15, h + 0.15), 0.3, edge).parent = root
    R, r, tilt = f("loop_R", 3.2), f("loop_r", 1.3), math.radians(f("loop_tilt", 35.0))
    for sx in (-1.0, 1.0):
        bpy.ops.mesh.primitive_torus_add(major_radius=R * S, minor_radius=r * S, major_segments=32, minor_segments=12,
                                         location=(sx * R * 0.8 * S, (h + R * 0.7) * S, 0), rotation=(0, 0, -sx * tilt))
        loop = bpy.context.active_object
        loop.data.materials.append(ribbon)
        bpy.ops.object.shade_smooth()
        loop.parent = root
    knot = _mat(opts, "knot", (200, 20, 40), 0.5, 0.2) if "knot" in opts else ribbon   # the source's knot is red
    _ell("knot", (0, h + 0.8, 0), (f("knot_r", 1.8),) * 3, knot, 16).parent = root


def _px(pts):
    """(column, row) outline points of the 32 px cell -> centred px (x right, y up)."""
    return [(c - 15.5, 15.5 - r) for c, r in pts]


SHIELD = [(1, 4.5), (4, 4), (6.5, 6.5), (8.5, 8), (10.5, 5), (12, 3), (19, 3), (21, 5), (23.5, 8), (25.5, 6.5), (28, 4),
          (30.5, 4.5), (30.5, 9.5), (29.5, 12), (27.5, 16), (25.5, 19.5), (23, 22.5), (20.5, 25.5), (17.5, 28), (16, 28.5),
          (14.5, 28), (11.5, 25.5), (9, 22.5), (6.5, 19.5), (4.5, 16), (2.5, 12), (1.5, 9.5)]          # clockwise on screen
WING = [(9.5, 12), (7, 8.5), (4, 6.5), (1.5, 5), (1.5, 13.5), (3, 14), (3, 18.5), (5, 19), (5, 21.5), (8, 22.5), (10.5, 20)]


def _shield(opts, f, col):
    from .quadruped import _ell
    silver = _mat(opts, "color", (235, 235, 235), 0.3, 0.45)
    gold = _mat(opts, "gold", (215, 175, 10), 0.3, 0.6)
    pts = _px(SHIELD)[::-1]                                          # counter-clockwise in +y-up space
    sh = _prism("shield", [(x * S, y * S) for x, y in pts], -f("sh_back", 4.0) * S, (f("sh_back", 4.0) + 4.0) * S, silver, 0.0)
    R = f("bulge_R", 40.0)                                          # keep only what lies inside a big sphere: a cap
    bpy.ops.mesh.primitive_uv_sphere_add(radius=R * S, segments=64, ring_count=32, location=(0, f("bulge_y", 2.0) * S, (f("sh_top", 3.0) - R) * S))
    ball = bpy.context.active_object
    m = sh.modifiers.new("cap", 'BOOLEAN')
    m.operation = 'INTERSECT'
    m.object = ball
    bpy.context.view_layer.objects.active = sh
    bpy.ops.object.modifier_apply(modifier="cap")
    bpy.data.objects.remove(ball, do_unlink=True)
    bev = sh.modifiers.new("bev", 'BEVEL')
    bev.width = f("sh_bevel", 0.8) * S
    bev.segments = 3
    bev.limit_method = 'ANGLE'
    bpy.ops.object.shade_smooth()
    sr = f("stud_r", 2.0)
    for c, r in ((3.5, 7.5), (27.5, 7.5), (15.5, 24.5)):
        x, y = c - 15.5, 15.5 - r
        _ell("stud", (x, y, f("stud_z", 1.0)), (sr, sr, sr * 0.8), gold, 16)


def _helmet(opts, f, col):
    from .quadruped import _ell
    white = _mat(opts, "white", (240, 240, 240), 0.3, 0.45)
    dark = _mat(opts, "rim", (70, 70, 72), 0.5, 0.2)
    _ell("dome", (0, f("dome_y", 3.0), 0), (f("dome_rx", 8.0), f("dome_ry", 8.0), f("dome_rz", 7.0)), white, 48)
    _ell("rim", (0, f("rim_y", -7.5), -1.0), (f("rim_rx", 10.0), f("rim_ry", 4.0), f("rim_rz", 6.0)), dark, 32)
    wd = f("wing_d", 1.2)
    left = _px(WING)                                                 # already counter-clockwise (y up)
    for pts in (left, [(-x, y) for x, y in left][::-1]):
        w = _prism("wing", [(x * S, y * S) for x, y in pts], -wd / 2 * S + f("wing_z", 1.0) * S, wd * S, col, 0.3 * S)
        w.rotation_euler = (0, math.radians(f("wing_yaw", 0.0)) * (1 if pts is left else -1), 0)


def _shoe(opts, f, col):
    white = _mat(opts, "white", (235, 235, 235), 0.35, 0.4)
    blue = _mat(opts, "stripe", (70, 80, 210), 0.35, 0.3)
    sole = _mat(opts, "sole", (175, 175, 180), 0.5, 0.2)
    bpy.ops.object.empty_add(location=(f("shoe_x", -1.0) * S, f("shoe_y", -1.0) * S, 0))
    root = bpy.context.active_object
    root.rotation_mode = 'YXZ'                                     # turn, tip, then roll the toe down-left
    root.rotation_euler = (math.radians(f("shoe_tilt", 20.0)), math.radians(f("shoe_yaw", 30.0)), math.radians(f("shoe_roll", 59.0)))
    L = f("shoe_l", 12.0)                                          # half length
    hl = f("heel_f", 0.3)                                          # the heel's share of the length
    if opts.get("sneaker", False):                                 # a sneaker profile: low toe box rising to the ankle
        vh, W = f("vamp_h", 3.4), f("shoe_w", 3.6)
        y0 = -vh                                                   # the sole's top
        tops = []
        for name, xc, hx, hh, mat in (("toe", -0.62, 0.38, f("toe_h", 2.2), white), ("mid", -0.12, 0.3, f("mid_h", 3.0), white),
                                      ("quarter", 0.52, 0.48, f("quarter_h", 4.2), col)):   # the red high-top ankle
            _rbox(name, (xc * L, y0 + hh, 0), (hx * L, hh, W), min(hh, W) * f("upper_bevel", 0.8), mat).parent = root
            tops.append((xc * L, y0 + 2 * hh))
        if f("sole_h", 0.8) > 0:                                   # a flat ellipsoid: no plate corners past the shoe
            from .quadruped import _ell
            _ell("sole", (0, y0 - 0.2, 0), (L * 1.0, f("sole_h", 0.8), W + 0.2), sole, 32).parent = root
        qx, qt = tops[2]
        _rbox("tongue", (tops[1][0] + L * 0.18, qt - 0.4, 0), (1.1, f("tongue_h", 1.4), W * 0.7), 0.8, white).parent = root
        n = int(f("laces", 4))
        for i in range(n):                                         # lace bars across the instep, toe box to tongue
            t = i / max(n - 1, 1)
            x = tops[0][0] + L * 0.1 + t * (tops[1][0] + L * 0.12 - tops[0][0] - L * 0.1)
            y = tops[0][1] + t * (tops[1][1] - tops[0][1])
            _rbox("lace", (x, y + 0.1, 0), (f("lace_w", 0.45), 0.4, W * f("lace_z", 0.75)), 0.25, blue).parent = root
        return
    _rbox("vamp", (-L * hl, 0, 0), (L * (1 - hl), f("vamp_h", 3.4), f("shoe_w", 3.6)), f("vamp_bevel", 3.0), white).parent = root
    _rbox("heel", (L * (1 - hl), f("heel_dy", 2.2), 0), (L * hl, f("heel_h", 4.5), f("shoe_w", 3.6) * 1.04), f("heel_bevel", 2.5), col).parent = root
    _rbox("sole", (-L * hl, -f("vamp_h", 3.4) - 0.6, 0), (L * (1 - hl) + 0.3, 0.9, f("shoe_w", 3.6) + 0.3), 0.8, sole).parent = root   # under the vamp
    _rbox("stripe", (-L * 0.3, f("vamp_h", 3.4) - 0.2, 0), (L * 0.45, 0.5, f("stripe_w", 1.6)), 0.3, blue).parent = root   # the laces


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    kind = opts.get("kind", "key")
    col = _mat(opts, "color", (210, 0, 0))
    white = _mat(opts, "white", (235, 235, 235))
    if kind == "key":
        _key(opts, f, col)
    elif kind == "arrow":
        _arrow(opts, f, col, white)
    elif kind == "frame":
        _frame(opts, f, col)
    elif kind == "turtle":
        _turtle(opts, f, col)
    elif kind == "gift":
        _gift(opts, f, col)
    elif kind == "shield":
        _shield(opts, f, col)
    elif kind == "helmet":
        _helmet(opts, f, col)
    elif kind == "shoe":
        _shoe(opts, f, col)
    else:
        _door(opts, f, col, white)


def _frames_setup(opts):
    build(opts)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object                                    # everything turns together (pose "spin")
    root.name = "goody_root"
    for o in list(bpy.context.scene.objects):
        if o is not root and o.parent is None and o.type in ('MESH', 'EMPTY', 'CURVE', 'FONT'):
            o.parent = root
    C.setup_scene(256)
    C.apply_look(opts)
    return {"root": root}


def _frames_pose(ctx, pose):
    ctx["root"].rotation_euler = (math.radians(float(pose.get("tilt", 0.0))), math.radians(float(pose.get("spin", 0.0))), 0.0)


register_frames("goodies", _frames_setup, _frames_pose)   # static goodies ignore the pose; "spin" turns one
