"""soi3d.builders.gem -- the high-value GEM pickup (master_s_objects frames f02-f16, worth 2000 pts):
a spinning faceted DIAMOND. The source sheet `master_s_objects` actually holds FOUR distinct props
(this red/blue faceted gem, a "?" mystery block, a green sphere cluster, and the red/white 5000-pt gold
bar); only the gem is modelled here.

Geometry: a SQUARE BIPYRAMID / octahedron (`_faceted_gem`) -- a sharp 4-point diamond silhouette with a
thin GIRDLE band at the waist, its faces split into four vertical wedges coloured RED, BLUE, RED, BLUE
around the axis. In the remaster the gem is spun about the VERTICAL (image-up = world Y) axis: the top &
bottom points stay fixed while the red/blue wedges orbit -- matching the source, where the silhouette is
4-fold static but the facet colours churn frame to frame (measured: NOT an in-plane spin; ~180 deg visual
period over the 15 source frames, red<->blue swapping at 90 deg).

Faces are kept FLAT (un-smoothed) so every facet catches the top-left key light at its own angle -> a
gem-like sparkle; a light CLEARCOAT adds a glossy highlight without washing out the saturated hues, and a
faint in-hue emission keeps shadowed facets a dark RED/BLUE (like the source) rather than black. The
distinct view-locked glint is composited in POST (apply_glint.py).
"""
import math

import bpy

from .. import common as C
from .. import register


def _faceted_gem(name, mats, r_eq=1.02, h_top=1.16, h_bot=1.16, girdle=0.13, n=4, offset=0.0,
                 scheme="caps"):
    """A square (n=4) BIPYRAMID with a short vertical girdle band, built with bmesh.

    Verts: a top apex (+Y) and bottom apex (-Y), plus an upper and a lower equatorial ring of `n`
    verts at radius `r_eq` in the world XZ plane (so the apex-to-apex axis is world Y -- the vertical
    spin axis). Faces: `n` top triangles, `n` girdle quads, `n` bottom triangles. `scheme` picks the
    two-tone colouring (mats[0]=red, mats[1]=blue):
      * "caps"    -> top+bottom pyramid triangles = red, girdle band = blue (a red crown/culet + blue
                     waist; reads as a solid RED top point + BLUE middle + dark-RED bottom, like source).
      * "checker" -> top tri and bottom tri of each column take OPPOSITE parity (a two-tone octahedron);
                     corner-on this is an alternating red/blue X of quadrants.
      * "wedge"   -> each vertical column one colour (R/B/R/B stripes).
    Flat-shaded so every facet catches the top-left key light on its own -> gem sparkle.
    """
    import bmesh
    bm = bmesh.new()
    top = bm.verts.new((0.0, h_top + girdle * 0.5, 0.0))
    bot = bm.verts.new((0.0, -(h_bot + girdle * 0.5), 0.0))
    upper, lower = [], []
    for k in range(n):
        a = math.radians(offset + 360.0 * k / n)
        x, z = r_eq * math.sin(a), r_eq * math.cos(a)
        upper.append(bm.verts.new((x, girdle * 0.5, z)))
        lower.append(bm.verts.new((x, -girdle * 0.5, z)))

    def _ci(kind, k):                           # kind in {"top","girdle","bot"} -> material index
        if scheme == "caps":
            return 1 if kind == "girdle" else 0                 # red caps, blue girdle
        if scheme == "checker":
            base = k % 2
            return base if kind == "top" else (base + 1) % 2    # top/bottom opposite -> quadrant X
        return k % len(mats)                                    # "wedge": per-column stripes

    faces = []                                  # (face, material_index)
    for k in range(n):
        k2 = (k + 1) % n
        faces.append((bm.faces.new((top, upper[k], upper[k2])), _ci("top", k)))
        faces.append((bm.faces.new((upper[k], lower[k], lower[k2], upper[k2])), _ci("girdle", k)))
        faces.append((bm.faces.new((bot, lower[k2], lower[k])), _ci("bot", k)))
    bmesh.ops.recalc_face_normals(bm, faces=bm.faces[:])
    me = bpy.data.meshes.new(name)
    # record the per-face material slot before writing to the mesh
    for f, ci in faces:
        f.material_index = ci
    bm.to_mesh(me)
    bm.free()
    obj = bpy.data.objects.new(name, me)
    bpy.context.collection.objects.link(obj)
    for m in mats:
        obj.data.materials.append(m)
    for poly in obj.data.polygons:
        poly.use_smooth = False                 # FLAT facets -> each catches the key light on its own
    return obj


def build_gem(spin=0.0, tilt_x=0.0, tilt_y=0.0, n=4, offset=0.0, scheme="caps", h_cap=1.0, girdle=0.5):
    """FAITHFUL Step-On-It gem: a faceted RED/BLUE diamond (octahedron / square bipyramid) spun about
    the vertical axis. `spin` rotates the wedges about world Y (the remaster spin); a tiny `tilt_x` may
    be passed to reproduce a specific source phase. Symmetric top/bottom (it is animated), so pass only
    offsets.

    `n` = wedges (4 = octahedron). `offset=0` puts an equatorial VERTEX at +Z (pointing at the camera)
    -> the gem is seen CORNER-ON: a near pole in the image centre with red ridges radiating to the four
    silhouette points and blue quadrant faces between them, matching source f02. Spinning this about the
    vertical world-Y axis keeps the top/bottom points fixed (static diamond silhouette) while the facet
    colours churn -- exactly the measured source motion."""
    C._clear()

    def _gem_mat(nm, rgb, emit):
        # MATTE facets (spec=0, no coat): the source is flat, PURE pixel-art colour -- a glossy coat
        # adds a white highlight that pollutes the hue (measured: red drifts to (170,38,38), sat 0.74
        # vs source 0.98). Matte + the top-left key sun gives saturated in-hue shading; the sparkle
        # glint is composited in POST. A faint in-hue emission keeps shadowed facets a dark RED/BLUE.
        m = C._mat(nm, C._srgb(*rgb), rough=0.5, spec=0.0, coat=0.0)
        b = m.node_tree.nodes.get("Principled BSDF")
        ec, es = b.inputs.get("Emission Color"), b.inputs.get("Emission Strength")
        if ec is not None:
            ec.default_value = C._srgb(*emit)
        if es is not None:
            es.default_value = 0.16                                     # keep shadowed facets in-hue
        return m

    red = _gem_mat("gem_red", (214, 0, 4), (150, 0, 4))
    blue = _gem_mat("gem_blue", (0, 2, 162), (0, 2, 104))

    pivot = bpy.data.objects.new("pivot", None)                         # empty at gem centre
    bpy.context.collection.objects.link(pivot)
    gem = _faceted_gem("gem", [red, blue], h_top=h_cap, h_bot=h_cap, girdle=girdle,
                       n=n, offset=offset, scheme=scheme)
    gem.parent = pivot
    gem.matrix_parent_inverse.identity()
    # spin about world Y (vertical in the image); optional tiny tilt to hit a source phase
    pivot.rotation_euler = (math.radians(tilt_x), math.radians(spin), math.radians(tilt_y))


@register("gem")
def render(args):
    # gem <out.png> [px] [spin] [tilt_x] [tilt_y] [n] [offset] [scheme] [h_cap] [girdle]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    sp = float(args[2]) if len(args) > 2 else 0.0
    tx = float(args[3]) if len(args) > 3 else 0.0
    ty = float(args[4]) if len(args) > 4 else 0.0
    n = int(args[5]) if len(args) > 5 else 4
    off = float(args[6]) if len(args) > 6 else 0.0
    scheme = args[7] if len(args) > 7 else "caps"
    hc = float(args[8]) if len(args) > 8 else 1.0
    gd = float(args[9]) if len(args) > 9 else 0.5
    build_gem(spin=sp, tilt_x=tx, tilt_y=ty, n=n, offset=off, scheme=scheme, h_cap=hc, girdle=gd)
    # LOW white world+fill so the faceted hues stay PURE/saturated (source sat 0.98); shadowed facets
    # are kept in-hue by the materials' own emission, not by white fill. Standard view transform.
    C.setup_scene(px, world_strength=0.07, fill_energy=0.09)
    return out
