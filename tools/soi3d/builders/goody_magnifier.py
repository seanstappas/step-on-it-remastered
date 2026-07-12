"""soi3d.builders.goody_magnifier -- the MAGNIFYING GLASS pickup (goody_sprites f48).

A dark glossy round LENS ringed by a brass RIM (torus), with a brass/wood HANDLE angled down to the
lower-right. Colours sampled from source: dark lens (30,34,33) with a bright glassy catch-light; brass
rim (138,111,0); handle browns (90,49,0)/(74,57,49). Static prop.
"""
import math

import bpy

from .. import common as C
from .. import register


def build_magnifier():
    """Dark lens + brass rim + angled handle (source f48)."""
    C._clear()
    glass = C._mat("mag_glass", C._srgb(30, 34, 40), rough=0.16, metal=0.0, spec=0.4, coat=0.4)
    # faint cool emission so the dark lens keeps a hint of blue depth instead of crushing to black
    gb = glass.node_tree.nodes.get("Principled BSDF")
    ec = gb.inputs.get("Emission Color"); es = gb.inputs.get("Emission Strength")
    if ec is not None:
        ec.default_value = C._srgb(12, 16, 26)
    if es is not None:
        es.default_value = 0.05
    brass = C._mat("mag_brass", C._srgb(150, 120, 8), rough=0.3, metal=0.7, spec=0.6, coat=0.1)
    wood = C._mat("mag_wood", C._srgb(104, 66, 8), rough=0.5, metal=0.2, spec=0.3)

    LENS_CX, LENS_CY, LENS_R = -0.10, 0.44, 0.48

    # dark glass lens: a flattened sphere (lens) facing the camera
    bpy.ops.mesh.primitive_uv_sphere_add(radius=LENS_R, segments=72, ring_count=40,
                                         location=(LENS_CX, LENS_CY, 0.0))
    lens = bpy.context.active_object
    lens.name = "mag_lens"
    lens.scale = (1.0, 1.0, 0.42)
    lens.data.materials.append(glass)
    bpy.ops.object.shade_smooth()

    # brass rim: a torus hugging the lens edge, in the camera plane (torus axis = +Z = toward cam)
    bpy.ops.mesh.primitive_torus_add(location=(LENS_CX, LENS_CY, 0.02),
                                     major_radius=LENS_R + 0.02, minor_radius=0.09,
                                     major_segments=64, minor_segments=20)
    rim = bpy.context.active_object
    rim.name = "mag_rim"
    rim.data.materials.append(brass)
    bpy.ops.object.shade_smooth()

    # handle: a thick brass rod dropping STEEPLY down-right (source f48 is tall: aspect ~0.73)
    ang = math.radians(-62)                                   # steep => more vertical extent
    L = 1.2
    start_r = LENS_R + 0.04
    sx = LENS_CX + start_r * math.cos(ang)
    sy = LENS_CY + start_r * math.sin(ang)
    mx = sx + 0.5 * L * math.cos(ang)
    my = sy + 0.5 * L * math.sin(ang)
    bpy.ops.mesh.primitive_cylinder_add(vertices=28, radius=0.13, depth=L, location=(mx, my, 0.0),
                                        rotation=(0, math.radians(90), ang))
    handle = bpy.context.active_object
    handle.name = "mag_handle"
    hb = handle.modifiers.new("bev", 'BEVEL'); hb.width = 0.03; hb.segments = 2
    handle.data.materials.append(wood)
    bpy.ops.object.shade_smooth()

    # a brass collar where the handle joins the rim
    bpy.ops.mesh.primitive_cylinder_add(vertices=24, radius=0.15, depth=0.20, location=(sx, sy, 0.0),
                                        rotation=(0, math.radians(90), ang))
    collar = bpy.context.active_object
    collar.name = "mag_collar"
    collar.data.materials.append(brass)
    bpy.ops.object.shade_smooth()

    # key glint -> the soft catch-light on the upper-left of the dark lens
    bpy.ops.object.light_add(type='POINT', location=(-2.4, 3.2, 3.0))
    gl = bpy.context.active_object
    gl.name = "mag_glint"
    gl.data.energy = 170
    gl.data.shadow_soft_size = 0.5


@register("goody_magnifier")
def render(args):
    # goody_magnifier <out.png> [px]
    out = args[0]
    px = int(args[1]) if len(args) > 1 else 256
    build_magnifier()
    C.setup_scene(px, world_strength=0.18, fill_energy=0.14)
    return out
