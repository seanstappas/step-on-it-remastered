"""soi3d.builders.spinner -- the enemy-13 "spinning block" board hazard.

A STATIC rounded GREEN base carries a short white vertical POST; on top sits a 2-tier turnstile of
RED bars each tipped with a BLUE ball, and that apparatus SPINS about the vertical post axis (viewed
from a slight top-down 3/4 angle). The two bars sit at two heights and point 180 deg apart, so the
apparatus is 2-fold (point) SYMMETRIC / balanced -- a single source frame is just ONE lopsided spin
phase (match the OFFSET, not the skew): pass an explicit `spin` to reproduce a specific frame.

Only the apparatus (bars + balls, parented to `pivot`) rotates; the base + post are static. The whole
prop is parented to `root` and tilted a few degrees about X for the top-down read.
"""
import math

import bpy

from .. import common as C
from .. import register, register_frames


def _parent_keep_local(obj, parent):
    """Parent `obj` to `parent` but treat obj.location as LOCAL to the parent (clear the parent
    inverse). Both `root` and `pivot` sit at the origin, so a child's world coords == its local
    coords and the parent's rotation (tilt / spin) then applies cleanly on top."""
    obj.parent = parent
    obj.matrix_parent_inverse.identity()


def _dome(name, center, scale, mat):
    """A squashed UV-sphere -> the soft rounded GREEN cushion/base (dome top, flat-ish read)."""
    bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=64, ring_count=32, location=center)
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = scale
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def _post(name, x, y0, y1, radius, mat):
    """A vertical cylinder (the white spindle) from world y0..y1 at x, centred on Z=0."""
    bpy.ops.mesh.primitive_cylinder_add(vertices=28, radius=radius, depth=(y1 - y0),
                                         location=(x, (y0 + y1) * 0.5, 0.0))
    obj = bpy.context.active_object
    obj.name = name
    obj.rotation_euler = (math.radians(90), 0, 0)   # cylinder default +Z -> stand it up along +Y
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def _ball(name, center, radius, mat):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=radius, segments=48, ring_count=24, location=center)
    obj = bpy.context.active_object
    obj.name = name
    obj.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return obj


def build_spinner(spin=0.0, tilt=10.0):
    """Build the spinning-block hazard. `spin` = degrees of apparatus rotation about the vertical
    post axis (Y); `tilt` = degrees the whole prop leans toward the camera (top-down 3/4 read)."""
    C._clear()

    # MATTE 'playdough' materials: high roughness + zero/low specular so hues stay saturated like the
    # source pixel art (no glossy white rim). A faint in-hue emission keeps the deepest shadow a dark
    # GREEN / RED rather than neutral black (matches the source shading, no dead grey core).
    green = C._mat("green", C._srgb(0, 140, 0), rough=0.62, spec=0.08)
    gb = green.node_tree.nodes.get("Principled BSDF")
    if gb.inputs.get("Emission Color") is not None:
        gb.inputs["Emission Color"].default_value = C._srgb(0, 96, 0)
        gb.inputs["Emission Strength"].default_value = 0.06
    red = C._mat("red", C._srgb(204, 8, 8), rough=0.9, spec=0.0)
    rb = red.node_tree.nodes.get("Principled BSDF")
    if rb.inputs.get("Emission Color") is not None:
        rb.inputs["Emission Color"].default_value = C._srgb(120, 3, 3)
        rb.inputs["Emission Strength"].default_value = 0.05
    # blue balls: DEEP saturated blue with only a faint specular catch (no clearcoat -- the coat
    # washed the hue toward grey/desaturated). A faint blue emission keeps the shadow side blue.
    blue = C._mat("blue", C._srgb(4, 2, 210), rough=0.5, spec=0.05)
    blb = blue.node_tree.nodes.get("Principled BSDF")
    if blb.inputs.get("Emission Color") is not None:
        blb.inputs["Emission Color"].default_value = C._srgb(0, 0, 74)
        blb.inputs["Emission Strength"].default_value = 0.04
    white = C._mat("white", C._srgb(180, 176, 174), rough=0.5, spec=0.1)

    # root: whole prop, tilted a few degrees toward the camera for the top-down 3/4 view
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    root.rotation_euler = (math.radians(tilt), 0, 0)

    # static GREEN base cushion + white POST spindle (do NOT spin). Wide + flat -> a rounded pad.
    base = _dome("base", (0.0, -0.72, 0.0), (0.82, 0.24, 0.58), green)
    _parent_keep_local(base, root)
    post = _post("post", 0.0, -0.44, 0.42, 0.085, white)
    _parent_keep_local(post, root)

    # pivot: the spinning apparatus (rotates about the vertical Y axis through the origin)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    pivot = bpy.context.active_object
    pivot.name = "pivot"
    pivot.rotation_euler = (0, math.radians(spin), 0)
    _parent_keep_local(pivot, root)

    # 2-tier apparatus: upper bar+ball at +0.60 with the ball on +X, lower bar+ball at 0.00 with the
    # ball on -X (180 deg apart). Each bar runs through the post (red on both sides); one blue ball per
    # tier. The bars are CHUNKY (fill the frame width, small inter-tier gap) to match the source.
    bar_len, bar_h, bar_d = 1.56, 0.30, 0.17      # full extents (X through the post, Y height, Z depth)
    ball_r = 0.21
    ball_x = bar_len * 0.5 + 0.02                  # ball centre just past the bar end
    tiers = (("up", 0.54, +1), ("lo", 0.02, -1))
    for tag, y, side in tiers:
        bar = C._box("bar_%s" % tag, (0.0, y, 0.0), (bar_len, bar_h, bar_d), red, bevel=0.03)
        _parent_keep_local(bar, pivot)
        ball = _ball("ball_%s" % tag, (side * ball_x, y, 0.0), ball_r, blue)
        _parent_keep_local(ball, pivot)

    return root


@register("spinner")
def render(args):
    # spinner <out.png> [px] [spin_deg] [tilt_deg]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    spin = float(args[2]) if len(args) > 2 else 0.0
    tilt = float(args[3]) if len(args) > 3 else 10.0
    build_spinner(spin=spin, tilt=tilt)
    # ambient lifted a touch so the shadowed undersides stay dark GREEN/RED, not black
    C.setup_scene(px, world_strength=0.18, fill_energy=0.16)
    return out


def _frames_setup(opts):
    pivots = build_spinner_front(opts)
    C.setup_scene(256, world_strength=0.18, fill_energy=0.16)
    C.apply_look(opts)
    return {"pivots": pivots, "root": bpy.data.objects["root"]}


def _bicone(name, r, length, mat):
    """Two cones base to base along local X (the blue spindle on a bar end)."""
    parts = []
    for sgn in (1, -1):
        bpy.ops.mesh.primitive_cone_add(vertices=32, radius1=r, radius2=0.0, depth=length / 2,
                                        location=(sgn * length / 4, 0, 0))
        c = bpy.context.active_object
        c.rotation_euler = (0, math.radians(90) * sgn, 0)
        c.data.materials.append(mat)
        bpy.ops.object.shade_smooth()
        parts.append(c)
    for p in parts[1:]:
        p.select_set(True)
    parts[0].select_set(True)
    bpy.context.view_layer.objects.active = parts[0]
    bpy.ops.object.join()
    parts[0].name = name
    return parts[0]


S = 0.1   # Blender units per SD pixel (frames_setup model; the sprite is 24 x 26 px, post axis at x = 12)


def _px(x, y):
    return ((x - 12.0) * S, (13.0 - y) * S)


def _cone(name, r, length, mat):
    """A cone along local +Z with its BASE at the origin and its tip at z = length."""
    bpy.ops.mesh.primitive_cone_add(vertices=40, radius1=r, radius2=0.0, depth=length, location=(0, 0, length / 2))
    c = bpy.context.active_object
    c.name = name
    c.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    bpy.ops.object.transform_apply(location=True, rotation=False, scale=False)
    return c


def build_spinner_front(opts):
    """The Spinner as the source shows it, measured on f02 (face-on) and f09 (end-on) in SD px: a static
    GREEN slab base (x 0-23, rows 18-25), a grey POST (4 px wide at x 10-13, axis x = 12) and two RED
    bars 24 px long, ~7.5 px tall (rows 0-7 and 9-16) and ~2.5 px deep that turn about the post. Each bar
    carries two BLUE CONES (base ~6.5 px wide, ~7 px long) standing out of OPPOSITE faces at OPPOSITE
    ends, 7 px from the axis: the upper bar's front cone at +7 (right) and back cone at -7, the lower
    bar's the other way round. So the prop is 2-fold symmetric: a 180 deg turn looks the same, the 16
    frames (f17 == f02) are one half turn (12 deg/frame); face-on a front cone is seen tip-on (a blue
    blob), end-on both cones of a bar stick out sideways (the 'bicone' look of f09/f10). The two bars
    COUNTER-ROTATE (upper by -spin, lower by +spin): at f07 the upper front cone points left at x 8-14
    while the lower one points right at x 9-15, which no common rotation produces."""
    C._clear()
    green = C._mat("green", C._srgb(*opts.get("green", (0, 140, 0))), rough=float(opts.get("rough", 0.5)),
                   spec=float(opts.get("spec", 0.15)))
    red = C._mat("red", C._srgb(*opts.get("red", (210, 0, 0))), rough=float(opts.get("rough", 0.5)),
                 spec=float(opts.get("spec", 0.15)))
    blue = C._mat("blue", C._srgb(*opts.get("blue", (10, 10, 230))), rough=float(opts.get("rough", 0.5)),
                  spec=float(opts.get("spec", 0.15)))
    grey = C._mat("grey", C._srgb(*opts.get("grey", (200, 200, 200))), rough=0.3, spec=0.4)
    pe = float(opts.get("post_emit", 0.0))
    if pe > 0:                        # the source's peg under the lower bar stays light grey, not in its shadow
        gb = grey.node_tree.nodes["Principled BSDF"]
        gb.inputs["Emission Color"].default_value = C._srgb(*opts.get("grey", (200, 200, 200)))
        gb.inputs["Emission Strength"].default_value = pe
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    bw, bt, bb = float(opts.get("base_w", 23.0)), float(opts.get("base_top", 18.0)), 26.0
    if opts.get("base_shape") == "cylinder":
        # the source's base is a plain upright DRUM: flat vertical sides lit bright left -> dark right,
        # no rounded top edge (the bevelled slab read as a squat cushion)
        bpy.ops.mesh.primitive_cylinder_add(vertices=96, radius=bw / 2 * S, depth=(bb - bt) * S,
                                            location=(*_px(bw / 2, (bt + bb) / 2), 0.0))
        base = bpy.context.active_object
        base.name = "base"
        base.rotation_euler = (math.radians(90), 0, 0)
        base.data.materials.append(green)
        bev = base.modifiers.new("bevel", "BEVEL")
        bev.width = float(opts.get("base_bevel", 0.3)) * S
        bev.segments = 3
        bpy.ops.object.shade_smooth()
    else:
        base = C._box("base", (*_px(bw / 2, (bt + bb) / 2), 0.0), (bw * S, (bb - bt) * S, float(opts.get("base_d", 12.0)) * S),
                      green, bevel=float(opts.get("base_bevel", 1.2)) * S)
    pr = float(opts.get("post_r", 2.0)) * S
    # the post runs up INTO the upper bar (post_top = its row); poking out above the bar it showed a white dot
    post = _post("post", 0.0, _px(0, bt)[1], _px(0, float(opts.get("post_top", 0.5)))[1], pr, grey)
    for o in (base, post):
        _parent_keep_local(o, root)
    pivots = []
    bl = float(opts.get("bar_len", 24.0)) * S
    bh = float(opts.get("bar_h", 7.5)) * S
    bd = float(opts.get("bar_d", 2.5)) * S
    cr, cl = float(opts.get("cone_r", 3.25)) * S, float(opts.get("cone_len", 7.0)) * S
    cx = float(opts.get("cone_x", 7.0)) * S
    for tag, yc, side in (("up", float(opts.get("up_y", 3.9)), 1), ("lo", float(opts.get("lo_y", 12.9)), -1)):
        bpy.ops.object.empty_add(location=(0, 0, 0))
        pivot = bpy.context.active_object
        pivot.name = "pivot_" + tag
        _parent_keep_local(pivot, root)
        pivots.append(pivot)
        y = _px(0, yc)[1]
        bar = C._box("bar_" + tag, (0, y, 0), (bl, bh, bd), red, bevel=float(opts.get("bar_bevel", 0.5)) * S)
        _parent_keep_local(bar, pivot)
        for face in (1, -1):                              # front cone at +side*cx, back cone at -side*cx
            c = _cone("cone_%s_%d" % (tag, face), cr, cl, blue)
            c.location = (face * side * cx, y, face * bd / 2)
            c.rotation_euler = (0.0 if face > 0 else math.pi, 0.0, 0.0)
            _parent_keep_local(c, pivot)
    root.rotation_euler = (math.radians(float(opts.get("tilt", 0.0))), 0, 0)
    return pivots


def _frames_pose(ctx, pose):
    # pose {"spin": deg}: the upper bar turns by -spin, the lower by +spin (counter-rotating)
    sp = math.radians(float(pose.get("spin", 0.0)))
    ctx["pivots"][0].rotation_euler = (0.0, -sp, 0.0)
    ctx["pivots"][1].rotation_euler = (0.0, sp, 0.0)
    if "tilt" in pose:
        ctx["root"].rotation_euler = (math.radians(float(pose["tilt"])), 0.0, 0.0)


register_frames("spinner", _frames_setup, _frames_pose)
