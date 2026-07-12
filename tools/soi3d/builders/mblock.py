"""soi3d.builders.mblock -- the CREEPER ("bigger mblock", sssf 1016, enemy #16): a block-laying
nasty whose body is a stack of full-width horizontal ROUNDED BARS in alternating red / blue.

The source sheet (bigger_mblock f02-f14, 32x32) is the body's build/collapse cycle: f02 = a full
stack of SIX bars (top->bottom R,B,R,B,R,B); across the cycle the bars roll away bottom-up into
little balls until only the top red bar is left (f14). We model the six bars as horizontal
capsules/cylinders lying in the tile plane (seen top-down) and drive the collapse with `phase`
(0 = full stack .. 1 = a single top bar), spawning a rolling ball for each just-detached segment.
"""
import math

import bpy

from .. import common as C
from .. import register

NBARS = 6                                    # a full creeper body = 6 stacked bars
HALF = 1.0                                   # stack fills the full tile height (source f02 = full bleed)
BAR_LEN = 2.06                               # bars bleed to the tile edges (ends cropped ~square by frame)
BAR_RAD = 0.152                              # bar radius -> ~0.30 tall, thin dark gap between bars

# top->bottom: RED, BLUE, RED, BLUE, RED, BLUE  (bright pure primaries, measured off f02)
RED = (216, 0, 0)
BLUE = (0, 0, 216)
BAR_COLS = [RED, BLUE, RED, BLUE, RED, BLUE]


def _bar_y(i):
    """Centre Y of bar i (0 = top). Six bars evenly fill the tile height, top(+) -> bottom(-)."""
    step = (2 * HALF) / NBARS
    return HALF - step * (i + 0.5)


def _capsule(name, length, rad, mat, seg=40):
    """A horizontal capsule (cylinder + two rounded caps) lying along X, centred at the origin."""
    bpy.ops.mesh.primitive_cylinder_add(vertices=seg, radius=rad, depth=length, location=(0, 0, 0))
    cyl = bpy.context.active_object
    cyl.name = name
    cyl.rotation_euler = (0, math.radians(90), 0)        # lay the cylinder along X
    for cap_x in (length / 2.0, -length / 2.0):
        bpy.ops.mesh.primitive_uv_sphere_add(radius=rad, segments=seg, ring_count=seg // 2,
                                             location=(cap_x, 0, 0))
        cap = bpy.context.active_object
        cap.select_set(True)
        cyl.select_set(True)
        bpy.context.view_layer.objects.active = cyl
        bpy.ops.object.join()
    cyl.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return cyl


def _ball(name, loc, rad, mat, seg=40):
    bpy.ops.mesh.primitive_uv_sphere_add(radius=rad, segments=seg, ring_count=seg // 2, location=loc)
    b = bpy.context.active_object
    b.name = name
    b.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return b


def build_mblock(phase=0.0):
    """Build the creeper body. `phase` 0 -> full 6-bar stack (f02); increasing -> bars peel off the
    bottom and roll away as little balls until a single top red bar remains (f14)."""
    C._clear()
    mats = {
        "R": C._mat("cr_red", C._srgb(*RED), rough=0.5, spec=0.12),
        "B": C._mat("cr_blue", C._srgb(*BLUE), rough=0.5, spec=0.12),
    }
    phase = max(0.0, min(1.0, phase))
    # how many top bars are still fully settled (>=1). The next one down is mid-roll.
    settled = max(1, int(round(NBARS - phase * (NBARS - 1))))
    rolling_frac = (NBARS - 1) * phase - (NBARS - settled)      # 0..1 progress of the peeling bar

    for i in range(settled):
        col = BAR_COLS[i]
        mat = mats["R" if col == RED else "B"]
        bar = _capsule("bar%d" % i, BAR_LEN, BAR_RAD, mat)
        bar.location = (0, _bar_y(i), 0)

    # the bar currently peeling off -> a ball rolling down-and-out, plus already-gone segments as
    # smaller balls tumbling further away (bottom of the tile), giving the "collapse into balls" read.
    if settled < NBARS and rolling_frac > 0.02:
        idx = settled
        col = BAR_COLS[idx]
        mat = mats["R" if col == RED else "B"]
        y0 = _bar_y(idx)
        bx = -HALF * 0.35 - rolling_frac * 0.5                  # roll toward the lower-left
        by = y0 - rolling_frac * 0.30
        _ball("roll%d" % idx, (bx, by, 0.02), BAR_RAD * 1.05, mat)
    # a couple of trailing balls from earlier-detached bars, sinking to the tile floor
    for k in range(1, 3):
        idx = settled + k
        if idx < NBARS and rolling_frac > 0.2:
            col = BAR_COLS[idx]
            mat = mats["R" if col == RED else "B"]
            bx = -HALF * 0.15 + (0.5 - (k * 0.37)) * 0.9
            by = -HALF + BAR_RAD - (k * 0.05)
            _ball("fall%d" % idx, (bx, by, 0.0), BAR_RAD * 0.92, mat)


@register("mblock")
def render(args):
    # mblock <out.png> [px] [phase]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    phase = float(args[2]) if len(args) > 2 else 0.0
    build_mblock(phase=phase)
    C.setup_scene(px, world_strength=0.15, fill_energy=0.16)
    return out
