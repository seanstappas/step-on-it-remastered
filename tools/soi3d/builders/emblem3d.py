"""soi3d.builders.emblem3d -- an enemy SPAWNER block made from the nasty's OWN 3D model (the last 32x32 frame of
each nasty sheet: a red block with a silver statue of the nasty and the statue's shadow on the red).

The monster is built by its family's frames builder (`monster_mode`, `monster_opts` = that family's published
options, posed with `monster_pose`), every surface is cast in `silver`, and the whole model -- a "statue" --
stands `statue_dz` in front of the face of tile.py's red slab, so the key light throws its real shadow on the
red. Statue placement in tile px (1 px = 1/16 of the tile half): `statue_k` (scale), `statue_x`/`statue_y`
(offset of the model origin from the tile centre), `statue_fz` (depth squash), `statue_mirror` (face right).
An option "m_<key>" overrides the monster's own option <key> (the statue's stance, e.g. the ant's legs hanging
below its body instead of crossing it as in its walk frames). "dark_parts" (object-name prefixes, e.g. ["mouth"])
stay a dark `dark` colour instead of silver: the original statues keep an open mouth as a black gap. "cut_parts"
(prefixes) are carved out of the monster's "head" instead (a real opening, e.g. the hippo's open mouth).
"""
import math

import bpy

from .. import FRAMES, register_frames
from .. import common as C
from .tile import _rgb, _slab


def _frames_setup(opts):
    f = lambda k, d: float(opts.get(k, d))
    msetup, mpose = FRAMES[opts["monster_mode"]]
    mo = dict(opts.get("monster_opts", {}))
    mo.update({k[2:]: v for k, v in opts.items() if k.startswith("m_")})
    mctx = msetup(mo)                                             # clears the scene: the monster + its scene
    mpose(mctx, dict(opts.get("monster_pose", {})))
    bpy.context.view_layer.update()
    cut_parts = tuple(opts.get("cut_parts", ()))
    head = bpy.data.objects.get("head")
    if cut_parts and head is not None:
        for o in [o for o in bpy.data.objects if o.type == 'MESH' and o.name.startswith(cut_parts)]:
            m = head.modifiers.new("cut_" + o.name, 'BOOLEAN')
            m.operation, m.object = 'DIFFERENCE', o
            bpy.context.view_layer.objects.active = head
            bpy.ops.object.modifier_apply(modifier=m.name)
            bpy.data.objects.remove(o, do_unlink=True)
    silver = C._mat("silver", C._srgb(*_rgb(opts, "silver", (205, 205, 210))), rough=f("silver_rough", 0.35),
                    spec=f("silver_spec", 0.4))
    dark = C._mat("dark", C._srgb(*_rgb(opts, "dark", (20, 20, 22))), rough=0.6, spec=0.1)
    dark_parts = tuple(opts.get("dark_parts", ()))
    for o in bpy.data.objects:
        if o.type in ('MESH', 'CURVE', 'FONT', 'SURFACE', 'META'):
            m = dark if dark_parts and o.name.startswith(dark_parts) else silver
            if not o.material_slots:
                o.data.materials.append(m)
            for sl in o.material_slots:
                sl.material = m
            o.visible_shadow = True
    for o in bpy.data.objects:
        if o.type == 'LIGHT':
            o.data.use_shadow = True
    aim = {c.target for o in bpy.data.objects if o.type == 'LIGHT' for c in o.constraints if getattr(c, "target", None)}
    tops = [o for o in bpy.data.objects if o.parent is None and o.type not in ('LIGHT', 'CAMERA') and o not in aim]
    bpy.ops.object.empty_add(location=(0, 0, 0))
    statue = bpy.context.active_object
    statue.name = "statue"
    for o in tops:
        o.parent = statue
        o.matrix_parent_inverse.identity()
    half, height = f("half", 0.96), f("height", 0.62)
    px = half / 16.0
    k = f("statue_k", 1.0)
    statue.scale = (-k if opts.get("statue_mirror") else k, k, k * f("statue_fz", 1.0))
    statue.location = (f("statue_x", 0.0) * px, f("statue_y", 0.0) * px, height / 2 + f("statue_dz", 0.25))
    body = C._mat("base", C._srgb(*_rgb(opts, "base", (214, 0, 0))), rough=f("rough", 0.4),
                  spec=f("base_spec", 0.25))
    _slab("tile", half, height, f("bevel", 0.16), body)
    C.apply_look(opts)
    return {}


register_frames("emblem3d", _frames_setup, lambda ctx, pose: None)   # a static block
