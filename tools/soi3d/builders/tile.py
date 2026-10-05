"""soi3d.builders.tile -- every board BLOCK tile of block_sprites (one builder, `kind` per block type).

A tile is a rounded, bevelled square slab lit from the top left like the originals. On top of it:
  solid     nothing (white / red / green / blue / pink blocks)
  ball      a glossy sphere of `color` sitting in a white frame tile
  donut     a glossy torus of `color` in a white frame tile
  inset     a recessed square panel of `color` in a white frame tile
  texture   the top face carries an albedo image (`tex`, e.g. the camo / marble HD frame)
  porthole  a grey metal tile with a round hole through it (black inside)
  symbol    a raised red glyph (`symbol`, e.g. '?') on a `base`-coloured tile
  arrows    the goody arrow tiles: four raised white arrows on an inset `color` panel, pointing "out"
            (a '+' with heads at its ends) or "in" (heads meeting at the centre), `arrows_dir`
  switch    the goody switch tiles: a raised white plate on an inset `color` panel with four gold studs and
            a toggle (dark slot, white lever, gold U bracket, pin) at the bottom (`switch` "down") or,
            mirrored, at the top ("up")
  emblem    an enemy SPAWNER block (the last 32x32 frame of each nasty's sheet): a `base` red slab with a
            silver bas-relief of the nasty; the relief's height field is the source frame's (`mask`, a PNG)
            unsaturated "statue" pixels, blurred, so the statue keeps its exact outline
  mesh      the cross-hatch net (0x197): two layers of diagonal bars over a dark backing
Cracked frames, the four shatter quarters and the spawn squares are DERIVED from these renders by
tools/soi3d/framematch.py ("derive"), exactly as the originals derive them from the whole block.
"""
import math
import os

import bpy

from .. import common as C
from .. import register, register_frames


def _rgb(opts, key, default):
    g = float(opts.get("gain", 1.0)) * float(opts.get(key + "_gain", 1.0))
    c = opts.get(key, default)
    return tuple(max(0, min(255, int(round(v * g)))) for v in c)


def _slab(name, half, height, bevel, mat):
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
    tile = bpy.context.active_object
    tile.name = name
    tile.scale = (2 * half, 2 * half, height)
    bev = tile.modifiers.new("bev", 'BEVEL')
    bev.width = bevel
    bev.segments = 6
    tile.data.materials.append(mat)
    return tile


def _glossy(name, rgb, opts):
    return C._mat(name, C._srgb(*rgb), rough=float(opts.get("f_rough", 0.25)), spec=float(opts.get("f_spec", 0.5)),
                  coat=float(opts.get("f_coat", 0.5)))


def _textured(name, path, opts):
    mat = bpy.data.materials.new(name)
    mat.use_nodes = True
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    bsdf.inputs["Roughness"].default_value = 0.45
    si = bsdf.inputs.get("Specular IOR Level")
    if si is not None:
        si.default_value = 0.2
    tex = nt.nodes.new("ShaderNodeTexImage")
    tex.image = bpy.data.images.load(path)
    tex.extension = 'EXTEND'
    coord = nt.nodes.new("ShaderNodeTexCoord")
    mp = nt.nodes.new("ShaderNodeMapping")
    mp.inputs["Location"].default_value = (0.5, 0.5, 0.0)          # the unit cube's local xy [-0.5, 0.5] -> uv
    mp.inputs["Scale"].default_value = (1.0, 1.0, 1.0)
    nt.links.new(coord.outputs["Object"], mp.inputs["Vector"])
    nt.links.new(mp.outputs["Vector"], tex.inputs["Vector"])
    gain = nt.nodes.new("ShaderNodeMixRGB")
    gain.blend_type = 'MULTIPLY'
    gain.inputs["Fac"].default_value = 1.0
    g = float(opts.get("tex_gain", 1.0))
    gain.inputs["Color2"].default_value = (g, g, g, 1.0)
    nt.links.new(tex.outputs["Color"], gain.inputs["Color1"])
    nt.links.new(gain.outputs["Color"], bsdf.inputs["Base Color"])
    emit = float(opts.get("tex_emit", 0.0))       # the source texture already carries its own shading
    if emit > 0 and bsdf.inputs.get("Emission Color") is not None:
        nt.links.new(gain.outputs["Color"], bsdf.inputs["Emission Color"])
        bsdf.inputs["Emission Strength"].default_value = emit
    return mat


def build_tile(opts):
    C._clear()
    kind = opts.get("kind", "solid")
    half = float(opts.get("half", 0.96))
    height = float(opts.get("height", 0.62))
    bevel = float(opts.get("bevel", 0.16))
    top = height / 2
    base = _rgb(opts, "base", (214, 214, 214))
    if kind == "texture" and opts.get("tex"):
        body_mat = _textured("tex", opts["tex"], opts)
    else:
        body_mat = C._mat("base", C._srgb(*base), rough=float(opts.get("rough", 0.4)),
                          spec=float(opts.get("base_spec", 0.25)))
    if kind == "porthole":
        tile = _slab("tile", half, height, bevel, body_mat)
        bpy.context.view_layer.objects.active = tile
        bpy.ops.object.modifier_apply(modifier="bev")
        cuts = []
        fw = float(opts.get("frame_w", 0.0))
        if fw > 0:                               # SD f140: a 3 px border frame round a recessed, darker panel
            wd = float(opts.get("well_d", 0.08))
            pg = float(opts.get("panel_gain", 1.0))
            panel = C._mat("panel", C._srgb(*(max(0, min(255, int(v * pg))) for v in base)),
                           rough=float(opts.get("rough", 0.4)), spec=float(opts.get("base_spec", 0.25)))
            cuts.append(C._box("panel_cut", (0, 0, top), (2 * (half - fw), 2 * (half - fw), 2 * wd), panel, bevel=0.0))
        if opts.get("hole_shape", "round") == "diamond":
            d = float(opts.get("hole_d", 0.9))   # half-diagonal; the tips are clipped at +-hole_clip (blunt, as in SD)
            bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0), rotation=(0, 0, math.pi / 4))
            dia = bpy.context.active_object
            dia.scale = (d * math.sqrt(2), d * math.sqrt(2), 4.0)
            clip = float(opts.get("hole_clip", d))
            bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
            box = bpy.context.active_object
            box.scale = (2 * clip, 2 * clip, 5.0)
            bi = dia.modifiers.new("clip", 'BOOLEAN')
            bi.operation, bi.object = 'INTERSECT', box
            bpy.context.view_layer.objects.active = dia
            bpy.ops.object.modifier_apply(modifier="clip")
            bpy.data.objects.remove(box, do_unlink=True)
            cuts.append(dia)
        else:
            bpy.ops.mesh.primitive_cylinder_add(vertices=64, radius=float(opts.get("hole_r", 0.62)), depth=4.0)
            cuts.append(bpy.context.active_object)
        cr = float(opts.get("corner_r", 0.0))
        if cr > 0:                               # a small round hole in each corner gusset
            cxy = float(opts.get("corner_xy", 0.57))
            for sx in (-1.0, 1.0):
                for sy in (-1.0, 1.0):
                    bpy.ops.mesh.primitive_cylinder_add(vertices=32, radius=cr, depth=4.0, location=(sx * cxy, sy * cxy, 0))
                    cuts.append(bpy.context.active_object)
        for i, cut in enumerate(cuts):
            m = tile.modifiers.new("cut%d" % i, 'BOOLEAN')
            m.operation = 'DIFFERENCE'
            m.object = cut
            if cut.data.materials:
                m.material_mode = 'TRANSFER'     # the cut's faces (the panel floor) take the cutter's material
            bpy.context.view_layer.objects.active = tile
            bpy.ops.object.modifier_apply(modifier=m.name)
            bpy.data.objects.remove(cut, do_unlink=True)
        C._box("well", (0, 0, -top - 0.05), (2 * half - 0.1, 2 * half - 0.1, 0.05),
               C._mat("dark", C._srgb(0, 0, 0), rough=1.0, spec=0.0), bevel=0.0)
        return
    if kind == "mesh":
        C._box("backing", (0, 0, -0.2), (2 * half, 2 * half, 0.1),
               C._mat("dark", C._srgb(*_rgb(opts, "back", (16, 16, 16))), rough=1.0, spec=0.0), bevel=0.0)
        grey = C._mat("bar", C._srgb(*_rgb(opts, "color", (150, 150, 150))), rough=0.35, spec=0.4)
        pitch = 2 * half / float(opts.get("cells", 2.0))
        r = float(opts.get("bar_r", 0.07))
        phase = float(opts.get("phase", 0.0))               # 0.5 = bars cross at the edge quarter points (SD 0x197)
        n = int(math.ceil(2 * half / pitch)) + 1
        for layer, sgn in enumerate((1.0, -1.0)):          # lines y = sgn*x + c, clipped to the square
            for i in range(-n, n + 1):
                c = (i + phase) * pitch
                pts = []
                for x in (-half, half):
                    y = sgn * x + c
                    if -half <= y <= half:
                        pts.append((x, y))
                for y in (-half, half):
                    x = (y - c) * sgn
                    if -half <= x <= half:
                        pts.append((x, y))
                pts = sorted(set((round(px, 6), round(py, 6)) for px, py in pts))
                if len(pts) < 2:
                    continue
                (x0, y0), (x1, y1) = pts[0], pts[-1]
                ln = math.hypot(x1 - x0, y1 - y0)
                if ln < 1e-3:
                    continue
                bpy.ops.mesh.primitive_cylinder_add(vertices=20, radius=r, depth=ln,
                                                    location=((x0 + x1) / 2, (y0 + y1) / 2, 0.06 * layer))
                bar = bpy.context.active_object
                bar.rotation_euler = (0, math.radians(90), math.atan2(y1 - y0, x1 - x0))
                bar.data.materials.append(grey)
                bpy.ops.object.shade_smooth()
        return
    tile = _slab("tile", half, height, bevel, body_mat)
    col = _rgb(opts, "color", (200, 0, 0))
    if kind == "inset" and opts.get("tube_frame"):
        _tube_frame(opts, half, top, body_mat, col)
        bpy.data.objects.remove(tile, do_unlink=True)
        return
    if kind == "emblem":
        _emblem(opts, top, half, tile)
        return
    if kind == "ball":
        r = float(opts.get("ball_r", 0.6))
        bpy.ops.mesh.primitive_uv_sphere_add(radius=r, segments=64, ring_count=32,
                                             location=(0, 0, top - r * float(opts.get("sink", 0.35))))
        ball = bpy.context.active_object
        ball.data.materials.append(_glossy("feature", col, opts))
        bpy.ops.object.shade_smooth()
        ball.visible_shadow = bool(opts.get("feature_shadow", True))   # the source ball casts none on the tile
    elif kind == "donut":
        R, t = float(opts.get("torus_R", 0.46)), float(opts.get("torus_r", 0.22))
        bpy.ops.mesh.primitive_torus_add(major_radius=R, minor_radius=t, major_segments=64, minor_segments=24,
                                         location=(0, 0, top))
        tor = bpy.context.active_object
        tor.data.materials.append(_glossy("feature", col, opts))
        bpy.ops.object.shade_smooth()
    elif kind in ("inset", "arrows", "switch") or (kind == "symbol" and opts.get("well")):
        inner = float(opts.get("inner", 0.56))
        floor_z = top - float(opts.get("depth", 0.22))
        slope = float(opts.get("well_slope", 0.0))       # > 0: sloped walls (the '?' tile's picture-frame recess)
        bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
        cut = bpy.context.active_object
        if slope > 0:
            import bmesh
            bm = bmesh.new()
            bm.from_mesh(cut.data)
            for v in bm.verts:
                s, z = (inner - slope, floor_z) if v.co.z < 0 else (inner + slope * 0.5 / (top - floor_z), top + 0.5)
                v.co.x, v.co.y, v.co.z = math.copysign(s, v.co.x), math.copysign(s, v.co.y), z
            bm.to_mesh(cut.data)
            bm.free()
        else:
            cut.location = (0, 0, floor_z + 1.0)
            cut.scale = (2 * inner, 2 * inner, 2.0)
        m = tile.modifiers.new("cut", 'BOOLEAN')
        m.operation = 'DIFFERENCE'
        m.object = cut
        bpy.context.view_layer.objects.active = tile
        bpy.ops.object.modifier_apply(modifier="bev")
        bpy.ops.object.modifier_apply(modifier="cut")
        bpy.data.objects.remove(cut, do_unlink=True)
        wb = float(opts.get("well_bevel", 0.0))
        if wb > 0:                                       # the card's block: the recess edges are rounded, not cut
            import bmesh
            bm = bmesh.new()
            bm.from_mesh(tile.data)
            lim = inner + 0.02                                    # the cutter meets the top at exactly +-inner
            in_well = lambda v: max(abs(v.co.x), abs(v.co.y)) <= lim and floor_z - 1e-3 <= v.co.z <= top + 1e-3
            edges = [e for e in bm.edges if all(in_well(v) for v in e.verts) and not e.is_boundary
                     and e.calc_face_angle(0.0) > math.radians(10)]
            bmesh.ops.bevel(bm, geom=edges, offset=wb, segments=4, profile=0.5, affect='EDGES', clamp_overlap=False)
            bm.to_mesh(tile.data)
            bm.free()
            bpy.ops.object.shade_smooth_by_angle(angle=math.radians(float(opts.get("well_smooth", 50.0))))
        pc = col if kind in ("inset", "arrows", "switch") else _rgb(opts, "well_col", tuple(int(v * 0.45) for v in base))
        fl = inner - slope
        C._box("panel", (0, 0, floor_z - 0.02), (2 * fl - 0.02, 2 * fl - 0.02, 0.1),   # top 0.03 above the floor
               C._mat("panel", C._srgb(*pc), rough=0.45, spec=0.15), bevel=0.02)
        if kind == "symbol":
            _glyph(opts, floor_z + 0.03, col)
        elif kind == "arrows":
            _arrows(opts, floor_z + 0.03, inner)
        elif kind == "switch":
            _switch(opts, floor_z + 0.03)
    elif kind == "symbol":
        _glyph(opts, top, col)


def _tube_frame(opts, half, top, mat, col):
    """The reference card's block: a rounded-square TUBE (round in section, `tube_fz` flattened) round a recessed
    flat `color` panel; outer edge at +-half, inner lip at +-inner."""
    inner = float(opts.get("inner", 0.56)) - float(opts.get("well_slope", 0.0))   # the panel's half-size
    inner = float(opts.get("tube_inner", inner))
    r = (half - inner) / 2
    ph, cr = half - r, min(half - r, float(opts.get("tube_corner", r)))      # path half-size, path corner radius
    pts = []
    for qx, qy, a0 in ((1, 1, 0), (-1, 1, 90), (-1, -1, 180), (1, -1, 270)):
        cx, cy = qx * (ph - cr), qy * (ph - cr)
        for k in range(9):
            a = math.radians(a0 + 90 * k / 8)
            pts.append((cx + cr * math.cos(a), cy + cr * math.sin(a)))
    cu = bpy.data.curves.new("tube", 'CURVE')
    cu.dimensions = '3D'
    cu.bevel_depth = r
    cu.bevel_resolution = 8
    sp = cu.splines.new('POLY')
    sp.points.add(len(pts) - 1)
    for p, (x, y) in zip(sp.points, pts):
        p.co = (x, y, 0.0, 1.0)
    sp.use_cyclic_u = True
    fz = float(opts.get("tube_fz", 0.8))
    o = bpy.data.objects.new("tube", cu)
    bpy.context.collection.objects.link(o)
    o.location = (0, 0, top - r * fz)
    o.scale = (1.0, 1.0, fz)
    o.data.materials.append(mat)
    bpy.ops.object.select_all(action='DESELECT')
    bpy.context.view_layer.objects.active = o
    o.select_set(True)
    bpy.ops.object.convert(target='MESH')
    bpy.ops.object.shade_smooth()
    floor_z = top - float(opts.get("depth", 0.22))
    pw = inner + r * 0.6                                         # the panel runs in under the tube
    C._box("panel", (0, 0, floor_z - 0.05), (2 * pw, 2 * pw, 0.1),
           C._mat("panel", C._srgb(*col), rough=0.45, spec=0.15), bevel=0.02)
    C._box("tube_base", (0, 0, top - 2 * r * fz), (2 * ph, 2 * ph, 0.05), mat, bevel=0.0)   # hidden inside the tube


SYM_FONTS = {"arial": r"C:\Windows\Fonts\arialbd.ttf", "arialblack": r"C:\Windows\Fonts\ariblk.ttf",
             "verdana": r"C:\Windows\Fonts\verdanab.ttf", "georgia": r"C:\Windows\Fonts\georgiab.ttf"}


def _glyph(opts, z, col):
    """The raised symbol; optional sym_font / sym_x / sym_y / sym_sx / sym_sy (defaults = Times Bold, centred)."""
    fp = SYM_FONTS.get(str(opts.get("sym_font", "")), C.DEFAULT_SIGN_FONT)
    font = fp if os.path.exists(fp) else None
    t = C._text(opts.get("symbol", "?"), z=z, mat=C._mat("sym", C._srgb(*col), rough=0.5, spec=0.2),
                extrude=float(opts.get("sym_extrude", 0.06)), size=float(opts.get("sym_size", 1.5)), font=font)
    t.location.x, t.location.y = float(opts.get("sym_x", 0.0)), float(opts.get("sym_y", 0.0))
    t.scale = (float(opts.get("sym_sx", 1.0)), float(opts.get("sym_sy", 1.0)), 1.0)


def _blur(m, s):
    """Separable gaussian blur (sigma `s` px, zero padded) of a 2D numpy array."""
    import numpy as np
    r = int(math.ceil(2.5 * s))
    k = np.exp(-0.5 * (np.arange(-r, r + 1) / s) ** 2)
    k /= k.sum()
    h, w = m.shape
    pad = np.pad(m, ((0, 0), (r, r)))
    m = sum(k[i] * pad[:, i:i + w] for i in range(2 * r + 1))
    pad = np.pad(m, ((r, r), (0, 0)))
    return sum(k[i] * pad[i:i + h] for i in range(2 * r + 1))


def _sfs_height(m, lum):
    """Shape from shading for a statue lit from the top left: a bright pixel faces the light, so the height
    RISES toward the lower right there. Integrates (luminance - the statue's mean) along every down-right
    diagonal, each run of statue pixels starting and ending at the base (its drift spread linearly).
    Returns the height in px per unit of luminance (2D numpy array, 0 outside the statue)."""
    import numpy as np
    h, w = m.shape
    s = (lum - float(lum[m > 0].mean())) * math.sqrt(2.0) if m.any() else lum * 0
    out = np.zeros_like(lum)
    for k in range(-(h - 1), w):
        ys = np.arange(max(0, -k), min(h, w - k))
        run = []
        for yy in list(ys) + [None]:
            if yy is not None and m[yy, yy + k] > 0:
                run.append((yy, yy + k))
                continue
            if run:
                v = np.cumsum([s[p] for p in run])
                n = len(run)
                for i, p in enumerate(run):
                    out[p] = v[i] - v[-1] * (i + 1) / n
                run = []
    return out


def _shadow_paint(tile, px, shadow, opts):
    """Paint the source's dark SHADOW pixels (the statue's shadow on the red slab, `shadow` mask) onto the
    slab: its base colour becomes the source's own colour there (x `shadow_gain`, softened by
    `shadow_soft` SD px), the red elsewhere."""
    import numpy as np
    h, w = shadow.shape
    k = 8
    soft = _blur(np.kron(shadow.astype(np.float32), np.ones((k, k), np.float32)), max(0.05, float(opts.get("shadow_soft", 0.5))) * k)
    col = np.kron(px[..., :3], np.ones((k, k, 1), np.float32)) * float(opts.get("shadow_gain", 0.6))
    rgba = np.concatenate([np.clip(col, 0.0, 1.0), np.clip(soft, 0.0, 1.0)[..., None]], -1)[::-1]   # bottom row first
    img = bpy.data.images.new("emblem_shadow", w * k, h * k, alpha=True)
    img.pixels = rgba.astype(np.float32).ravel().tolist()
    mat = tile.data.materials[0]
    nt = mat.node_tree
    bsdf = nt.nodes.get("Principled BSDF")
    base = tuple(bsdf.inputs["Base Color"].default_value)
    tex = nt.nodes.new("ShaderNodeTexImage")
    tex.image = img
    tex.extension = 'EXTEND'
    tex.interpolation = 'Linear'
    coord = nt.nodes.new("ShaderNodeTexCoord")
    mp = nt.nodes.new("ShaderNodeMapping")
    mp.inputs["Location"].default_value = (0.5, 0.5, 0.0)          # the unit cube's local xy [-0.5, 0.5] -> uv
    nt.links.new(coord.outputs["Object"], mp.inputs["Vector"])
    nt.links.new(mp.outputs["Vector"], tex.inputs["Vector"])
    mix = nt.nodes.new("ShaderNodeMixRGB")
    mix.inputs["Color1"].default_value = base
    nt.links.new(tex.outputs["Alpha"], mix.inputs["Fac"])
    nt.links.new(tex.outputs["Color"], mix.inputs["Color2"])
    nt.links.new(mix.outputs["Color"], bsdf.inputs["Base Color"])


def _emblem(opts, z0, half, tile=None):
    """The silver relief: a fine grid over the tile top whose outline is the source's statue mask (`mask`,
    blurred by `relief_sigmas`[0], cut at `relief_thr`). Its height = `relief_h` x the mask blurred at every
    `relief_sigmas` (an inflated, rounded bas-relief) + `sfs_gain` x a shape-from-shading height (_sfs_height)
    of the statue's own shading, so the relief lit from the top left reproduces the original's light pattern.
    `shadow_paint`: the source's DARK pixels (grey below `shadow_v`, or red below `shadow_r`) are the white
    statue's shadow on the slab, not part of the statue -- they stay out of the relief and are painted on
    the slab (_shadow_paint), so the icon keeps its separate shadow like the original."""
    import bmesh
    import numpy as np
    img = bpy.data.images.load(opts["mask"])
    w, h = img.size
    px = np.array(img.pixels[:], dtype=np.float32).reshape(h, w, 4)[::-1]      # row 0 = top
    sat = px[..., :3].max(-1) - px[..., :3].min(-1)
    statue = (sat < float(opts.get("statue_sat", 0.25))) & (px[..., 3] > 0.5)
    if opts.get("shadow_paint"):
        red = (px[..., 0] - px[..., 1:3].max(-1)) > 0.2
        shadow = (px[..., 3] > 0.5) & ((statue & (px[..., :3].max(-1) < float(opts.get("shadow_v", 0.4))))
                                       | (red & (px[..., 0] < float(opts.get("shadow_r", 0.48)))))
        statue &= ~shadow
        if tile is not None:
            _shadow_paint(tile, px, shadow, opts)
    m = statue.astype(np.float32)
    sig = [float(s) for s in opts.get("relief_sigmas", [0.7, 1.5, 3.0])]
    cut = _blur(m, sig[0])
    hf = sum(_blur(m, s) for s in sig) / len(sig)
    hf /= max(float(hf.max()), 1e-3)
    unit = 2 * half / max(w, h)                                                  # scene units per SD px
    sfs = _blur(_sfs_height(m, px[..., :3].mean(-1)), float(opts.get("sfs_blur", 0.6))) * unit
    n = int(opts.get("relief_res", 4)) * max(w, h)
    bpy.ops.mesh.primitive_grid_add(x_subdivisions=n, y_subdivisions=n, size=2 * half, location=(0, 0, z0))
    g = bpy.context.active_object
    g.name = "relief"
    hgt, thr, h0 = (float(opts.get("relief_h", 0.22)), float(opts.get("relief_thr", 0.4)),
                    float(opts.get("relief_base", 0.15)))
    sg = float(opts.get("sfs_gain", 2.0))

    def at(a, u, t):
        i, j = min(max(int(math.floor(t)), 0), h - 2), min(max(int(math.floor(u)), 0), w - 2)
        fy, fx = min(max(t - i, 0.0), 1.0), min(max(u - j, 0.0), 1.0)
        return (a[i, j] * (1 - fx) * (1 - fy) + a[i, j + 1] * fx * (1 - fy) + a[i + 1, j] * (1 - fx) * fy
                + a[i + 1, j + 1] * fx * fy)

    bm = bmesh.new()
    bm.from_mesh(g.data)
    drop = []
    for v in bm.verts:
        u, t = (v.co.x / (2 * half) + 0.5) * w - 0.5, (0.5 - v.co.y / (2 * half)) * h - 0.5   # pixel centres
        if at(cut, u, t) < thr:
            drop.append(v)
        v.co.z = max(0.0, hgt * (h0 + (1 - h0) * at(hf, u, t)) + sg * at(sfs, u, t))
    bmesh.ops.delete(bm, geom=drop, context='VERTS')
    bm.to_mesh(g.data)
    bm.free()
    g.data.materials.append(C._mat("silver", C._srgb(*_rgb(opts, "silver", (225, 225, 230))),
                                   rough=float(opts.get("silver_rough", 0.3)), spec=float(opts.get("silver_spec", 0.6))))
    bpy.ops.object.shade_smooth()



def _prism(name, pts, z0, h, mat, bevel):
    """A flat polygon (xy points, counter-clockwise) extruded from z0 by h, with rounded edges."""
    n = len(pts)
    verts = [(x, y, z0) for x, y in pts] + [(x, y, z0 + h) for x, y in pts]
    faces = [tuple(range(n - 1, -1, -1)), tuple(range(n, 2 * n))] + [(i, (i + 1) % n, n + (i + 1) % n, n + i) for i in range(n)]
    me = bpy.data.meshes.new(name)
    me.from_pydata(verts, [], faces)
    o = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(o)
    o.data.materials.append(mat)
    if bevel > 0:
        m = o.modifiers.new("bev", 'BEVEL')
        m.width = bevel
        m.segments = 3
        m.limit_method = 'ANGLE'
    return o


def _arrows(opts, z0, inner):
    """Four raised arrows along +-x / +-y: "out" = shafts from the centre, heads at the panel edge;
    "in" = shafts from the edge, heads meeting near the centre."""
    f = lambda k, d: float(opts.get(k, d))
    mat = C._mat("arrow", C._srgb(*_rgb(opts, "arrow_col", (235, 235, 235))), rough=f("arrow_rough", 0.35), spec=0.35)
    sw, hw, hl, h = f("shaft_w", 0.18), f("head_w", 0.44), f("head_l", 0.3), f("arrow_h", 0.08)
    reach, gap = inner * f("arrow_reach", 0.92), f("arrow_gap", 0.1)
    out = opts.get("arrows_dir", "out") == "out"
    for ang in (0.0, 90.0, 180.0, 270.0):
        a = math.radians(ang)
        ux, uy, vx, vy = math.cos(a), math.sin(a), -math.sin(a), math.cos(a)
        tip, back = (reach, 0.0) if out else (gap, reach)
        neck = tip - hl if out else tip + hl                      # where the head meets the shaft
        p = lambda r, s: (r * ux + s * vx, r * uy + s * vy)
        r0, r1 = min(back, neck), max(back, neck)
        _prism("shaft", [p(r0, -sw / 2), p(r1, -sw / 2), p(r1, sw / 2), p(r0, sw / 2)], z0, h, mat, h * 0.35)
        head = [p(tip, 0.0), p(neck, hw / 2), p(neck, -hw / 2)] if out else [p(tip, 0.0), p(neck, -hw / 2), p(neck, hw / 2)]
        _prism("head", head, z0, h, mat, h * 0.35)


P = 0.06                                                   # units per SD pixel of a 32 px tile (half 0.96 = 16 px)


def _pbox(name, c, half, bevel, mat):
    """A rounded box centred at c with half-sizes `half` and edge radius `bevel`, all in SD pixels."""
    bpy.ops.mesh.primitive_cube_add(size=2.0, location=tuple(v * P for v in c))
    o = bpy.context.active_object
    o.name = name
    o.scale = tuple(v * P for v in half)
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    m = o.modifiers.new("bevel", 'BEVEL')
    m.width = min(bevel, *half) * P * 0.98
    m.segments = 3
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def _stud(name, c, r, fz, mat):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=r * P, segments=24, ring_count=12, location=tuple(v * P for v in c))
    o = bpy.context.active_object
    o.name = name
    o.scale = (1.0, 1.0, fz)
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o


def _switch(opts, z0):
    """The switch plate and toggle, in SD pixels (x = column - 15.5, y = 15.5 - row). s = -1 puts the toggle
    at the bottom ("down", e.g. f37), +1 mirrors it to the top ("up", f38); the studs mirror with it."""
    f = lambda k, d: float(opts.get(k, d))
    white = C._mat("plate", C._srgb(*_rgb(opts, "plate_col", (235, 235, 235))), rough=0.35, spec=0.35)
    dark = C._mat("slot", C._srgb(*_rgb(opts, "slot_col", (22, 22, 22))), rough=0.7, spec=0.1)
    gold = C._mat("gold", C._srgb(*_rgb(opts, "gold", (215, 175, 10))), rough=0.3, spec=0.6)
    s = -1.0 if opts.get("switch", "down") == "down" else 1.0
    z = z0 / P                                             # the panel top, in px
    ph = f("plate_h", 2.0)
    px, pw, phh = f("plate_x", 0.5), f("plate_hw", 8.3), f("plate_hh", 11.6)
    _pbox("plate", (px, 0.0, z + ph / 2), (pw, phh, ph / 2), f("plate_bevel", 1.0), white)
    top = z + ph
    sx, sy, shw, shh = f("slot_x", 1.5), s * f("slot_y", 7.0), f("slot_hw", 5.0), f("slot_hh", 5.5)
    _pbox("slot", (sx, sy, top + 0.02), (shw, shh, 0.05), 0.0, dark)
    _pbox("lever", (f("lever_x", 1.0), s * f("lever_y", 3.5), top + 0.6), (f("lever_hw", 2.7), f("lever_hh", 2.0), 0.6), 0.5, white)
    bx0, bx1, by0, by1, br = f("br_x0", -4.5), f("br_x1", 5.5), f("br_y0", 1.5), f("br_y1", 6.5), f("br_r", 0.6)
    for bx in (bx0, bx1):
        _pbox("bracket", (bx, s * (by0 + by1) / 2, top + br), (br, (by1 - by0) / 2 + br, br), br, gold)
    _pbox("bracket", ((bx0 + bx1) / 2, s * by1, top + br), ((bx1 - bx0) / 2 + br, br, br), br, gold)
    _stud("pin", ((bx0 + bx1) / 2, s * f("pin_y", 8.0), top + 0.3), f("pin_r", 1.0), 0.6, gold)
    sr = f("stud_r", 1.4)
    for bx in (bx0, bx1):
        for yy in (0.0, -s * f("stud_y", 6.0)):
            _stud("stud", (bx, yy, top + 0.2), sr, 0.55, gold)


def _frames_setup(opts):
    build_tile(opts)
    C.setup_scene(256)
    C.apply_look(opts)
    return {}


@register("tile")
def render(args):
    # tile <out.png> [px] [kind] [base r,g,b] [color r,g,b]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    o = {"kind": args[2] if len(args) > 2 else "solid"}
    if len(args) > 3:
        o["base"] = [int(v) for v in args[3].split(",")]
    if len(args) > 4:
        o["color"] = [int(v) for v in args[4].split(",")]
    build_tile(o)
    C.setup_scene(px)
    return out


register_frames("tile", _frames_setup, lambda ctx, pose: None)   # tiles are static (fixed frames)
