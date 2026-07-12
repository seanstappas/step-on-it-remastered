"""soi3d.builders.blocks -- the WARM-PALETTE breakable game blocks (source family `blocks`, 51 frames).

This is the COLOUR-SHIFTED (clut) cousin of the finished `block_sprites`: the SAME raised-frame +
recessed-centre tile geometry, but a warm CREAM frame around RED/crimson/brown centres (block_sprites
is a cool GREY frame around blue/green centres), and -- unlike the static block_sprites -- it carries
the BUILD and BREAK animation frames:

  * f02-f06  = the spawn "sparkle": a cream 4-point star swelling from a dot to nearly the whole tile
               as the block materialises.
  * then per-colour variant groups, each = [solid 32x32] + [cracked 32x32 (break)] + [4x small 16x16]:
               crimson (f19/f20), brown (f49/f50), red-frame/green-centre (f43), ? , etc.

We model the tile once (raised cream frame + a square WELL carved out for a recessed colour panel, the
same well trick as block.py) and drive its whole life from a single `phase`:
  phase 0.00-0.45  BUILD  -- an emissive cream 4-point star grows; the block fades/rises in behind it.
  phase 0.45-0.55  SET    -- full solid block, the star gone.
  phase 0.55-1.00  BREAK  -- dark crack grooves open across the top and the recessed centre darkens.
`variant` picks the centre colour (and, for red-frame, the frame colour too).
"""
import math

import bpy

from .. import common as C
from .. import register

# warm cream raised frame (measured off f19/f49 outer edge 248,216,192; kept saturated enough that the
# silhouette rim reads coloured, not grey). A neutral grey inner bevel ring is added around the well.
FRAME = (250, 218, 190)
BEVEL_RING = (242, 240, 238)   # the neutral light-grey bevel ring just inside the cream frame

# variant -> (centre_rgb, frame_rgb_or_None). None frame => the default cream FRAME.
VARIANTS = {
    "crimson":  ((210, 58, 102), None),          # f19: cream frame, crimson recessed centre
    "brown":    ((120, 62, 6),   None),          # f49: cream frame, brown recessed centre
    "redgreen": ((0, 120, 0),    (234, 26, 26)),  # f43: RED frame, green recessed centre
}

INNER = 0.60          # half-size of the recessed well (tile half = 0.96)
FLOOR_Z = 0.06        # well floor height -> centre sits ~0.25 below the raised frame top


def _tile(frame_rgb):
    """The raised, beveled cream tile with a square well carved out of the top-centre (block.py trick)."""
    bmat = C._mat("blk_frame", C._srgb(*frame_rgb), rough=0.42, spec=0.22)
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, 0))
    tile = bpy.context.active_object
    tile.name = "blk"
    tile.scale = (1.92, 1.92, 0.62)
    bev = tile.modifiers.new("bev", 'BEVEL')
    bev.width = 0.16
    bev.segments = 6
    tile.data.materials.append(bmat)
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, FLOOR_Z + 1.0))
    cut = bpy.context.active_object
    cut.name = "cutter"
    cut.scale = (2 * INNER, 2 * INNER, 2.0)
    bmod = tile.modifiers.new("cut", 'BOOLEAN')
    bmod.operation = 'DIFFERENCE'
    bmod.object = cut
    bpy.context.view_layer.objects.active = tile
    bpy.ops.object.modifier_apply(modifier="bev")
    bpy.ops.object.modifier_apply(modifier="cut")
    bpy.data.objects.remove(cut, do_unlink=True)
    return tile


def _ring(inner_half, outer_half, z, height, mat, bevel=0.03):
    """A flush square bevel-RING (outer box minus inner box) sitting on the frame top around the well."""
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, z))
    ring = bpy.context.active_object
    ring.name = "bevelring"
    ring.scale = (2 * outer_half, 2 * outer_half, height)
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, z))
    hole = bpy.context.active_object
    hole.scale = (2 * inner_half, 2 * inner_half, height * 3)
    bm = ring.modifiers.new("cut", 'BOOLEAN')
    bm.operation = 'DIFFERENCE'
    bm.object = hole
    bpy.context.view_layer.objects.active = ring
    bpy.ops.object.modifier_apply(modifier="cut")
    bpy.data.objects.remove(hole, do_unlink=True)
    bevm = ring.modifiers.new("bev", 'BEVEL')
    bevm.width = bevel
    bevm.segments = 3
    bpy.ops.object.modifier_apply(modifier="bev")
    ring.data.materials.append(mat)
    return ring


def _star4(scale, z, emit_rgb, strength, pinch=0.44):
    """A flat emissive 4-point star -- points to the CORNERS (diagonals), sides pinched concave at the
    axis midpoints, matching the source spawn sparkle (f02-f06). `pinch` (inner/outer radius) controls the
    concavity: small => sharp star (early spawn), near 1 => a filled square (late spawn)."""
    ro, ri = 1.0 * scale, pinch * scale
    verts, faces = [(0.0, 0.0, 0.0)], []
    for k in range(8):
        ang = math.radians(45 * k)                 # 0,45,90,...,315
        r = ro if (k % 2 == 1) else ri             # outer point on the diagonals (corners), pinch on axes
        verts.append((r * math.cos(ang), r * math.sin(ang), 0.0))
    for k in range(8):
        faces.append((0, 1 + k, 1 + (k + 1) % 8))
    mesh = bpy.data.meshes.new("spark")
    mesh.from_pydata(verts, [], faces)
    mesh.update()
    obj = bpy.data.objects.new("spark", mesh)
    bpy.context.collection.objects.link(obj)
    obj.location = (0, 0, z)
    m = C._mat("spark", C._srgb(*emit_rgb), rough=0.6, spec=0.0)
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    ec = bsdf.inputs.get("Emission Color")
    if ec is not None:
        ec.default_value = C._srgb(*emit_rgb)
    es = bsdf.inputs.get("Emission Strength")
    if es is not None:
        es.default_value = strength
    obj.data.materials.append(m)
    return obj


def _studs(z):
    """The row of alternating RED/GREEN decorative studs along the TOP inner edge of the well (f19)."""
    red = C._mat("stud_r", C._srgb(239, 0, 0), rough=0.5, spec=0.15)
    grn = C._mat("stud_g", C._srgb(0, 132, 0), rough=0.5, spec=0.15)
    n = 7
    x0, x1 = -INNER + 0.14, INNER - 0.14
    for i in range(n):
        x = x0 + (x1 - x0) * i / (n - 1)
        C._box("stud%d" % i, (x, INNER - 0.10, z), (0.13, 0.13, 0.10),
               mat=(red if i % 2 == 0 else grn), bevel=0.01)


def _cracks(z, col=(18, 10, 8)):
    """A few thin dark grooves radiating from the centre across the top surface -> a cracked read."""
    cmat = C._mat("crack", C._srgb(*col), rough=0.9, spec=0.0)
    for ang, length in ((22, 1.7), (105, 1.5), (160, 1.8), (250, 1.6), (300, 1.4)):
        bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, z))
        cr = bpy.context.active_object
        cr.scale = (length, 0.05, 0.05)
        cr.rotation_euler = (0, 0, math.radians(ang))
        cr.location = (0.5 * length * math.cos(math.radians(ang)) * 0.4,
                       0.5 * length * math.sin(math.radians(ang)) * 0.4, z)
        cr.data.materials.append(cmat)


def build_blocks(variant="crimson", phase=None):
    """Build a warm breakable block. `phase` None => static solid block; else drive build->break."""
    C._clear()
    center_rgb, frame_rgb = VARIANTS.get(variant, VARIANTS["crimson"])
    frame_rgb = frame_rgb or FRAME

    if phase is None:
        build = 1.0
        broke = 0.0
    else:
        phase = max(0.0, min(1.0, phase))
        build = min(1.0, phase / 0.45)                       # 0..1 over the build window
        broke = max(0.0, (phase - 0.55) / 0.45)              # 0..1 over the break window

    # the tile (only once it has begun materialising)
    if build > 0.02:
        tile = _tile(frame_rgb)
        # neutral grey bevel ring just inside the cream frame (source frame is two-tone: cream edge +
        # grey inner bevel). Only for the default cream frame; the red-frame variant stays single-tone.
        if frame_rgb is FRAME:
            rmat = C._mat("blk_ring", C._srgb(*BEVEL_RING), rough=0.45, spec=0.2)
            _ring(INNER, 0.80, 0.28, 0.12, rmat)
        # recessed colour panel on the well floor
        darken = 1.0 - 0.35 * broke                          # centre darkens as it breaks
        cc = tuple(int(v * darken) for v in center_rgb)
        cmat = C._mat("blk_center", C._srgb(*cc), rough=0.5, spec=0.12)
        C._box("panel", (0, 0, FLOOR_Z - 0.03), (2 * INNER - 0.03, 2 * INNER - 0.03, 0.20),
               mat=cmat, bevel=0.01)
        # the settled solid block carries the red/green stud row on the well's top inner edge
        if build >= 1.0 and broke < 0.25 and frame_rgb is FRAME:
            _studs(FLOOR_Z + 0.06)
        # during the build the whole tile scales up from the tile centre
        if build < 1.0:
            for o in bpy.data.objects:
                if o.type == 'MESH' and o.name.startswith(("blk", "panel", "bevelring")):
                    o.scale = tuple(s * (0.3 + 0.7 * build) for s in o.scale)
        if broke > 0.25:
            _cracks(0.33)

    # the spawn sparkle: a sharp cream star early that swells AND fills toward a square as the block forms
    if phase is not None and build < 1.0:
        s = 0.30 + 1.10 * build                              # star swells as the block builds
        pinch = 0.36 + 0.52 * build                          # sharp star -> nearly-filled square while filling
        _star4(s, 0.5, (250, 232, 208), strength=1.3 * (1.0 - build) + 0.35, pinch=pinch)


@register("blocks")
def render(args):
    # blocks <out.png> [px] [variant] [phase|-]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    variant = args[2] if len(args) > 2 else "crimson"
    phase = None if (len(args) <= 3 or args[3] == "-") else float(args[3])
    build_blocks(variant=variant, phase=phase)
    C.setup_scene(px)
    return out
