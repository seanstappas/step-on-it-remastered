"""soi3d.builders.egg -- the Gargoyle's egg (master_s_objects f47-f61).

The source is a near-square striped cushion that fills its 24x24 cell; diagonal '/' bands (dark red, a thin
bright red line, dithered grey, a thin white line, repeating) scroll down-right, 15 frames per loop. In SD
pixel units: a rounded box (half-sizes "half_x", "half_y", "half_z", edge radius "bevel") painted with the
bands on Object coordinates, u = x - y + "scroll" (px), period = the sum of the band widths
"w_dark", "w_red", "w_grey", "w_white". Pose: "scroll" (px of u).
"""
import bpy

from .. import common as C
from .. import register_frames

S = 0.05


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    hx, hy, hz, bev = f("half_x", 11.5), f("half_y", 11.0), f("half_z", 5.0), f("bevel", 3.0)
    bpy.ops.mesh.primitive_cube_add(size=2.0, location=(0, 0, 0))
    o = bpy.context.active_object
    o.name = "egg"
    o.scale = (hx * S, hy * S, hz * S)
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    m = o.modifiers.new("bevel", 'BEVEL')
    m.width = min(bev, hx, hy, hz) * S * 0.98
    m.segments = 6
    widths = [f("w_dark", 9.0), f("w_red", 3.0), f("w_grey", 10.0), f("w_white", 3.0)]
    cols = [opts.get("dark", (70, 0, 5)), opts.get("red", (255, 20, 20)), opts.get("grey", (95, 95, 95)),
            opts.get("white", (235, 235, 235))]
    period = sum(widths)
    mat = C._mat("bands", C._srgb(*cols[0]), rough=f("rough", 0.5), spec=f("spec", 0.2))
    N, L = mat.node_tree.nodes, mat.node_tree.links
    tc, sep = N.new("ShaderNodeTexCoord"), N.new("ShaderNodeSeparateXYZ")
    L.new(tc.outputs["Object"], sep.inputs[0])
    sub = N.new("ShaderNodeMath")
    sub.operation = 'SUBTRACT'                                        # x - y (object units)
    L.new(sep.outputs[0], sub.inputs[0])
    L.new(sep.outputs[1], sub.inputs[1])
    px = N.new("ShaderNodeMath")
    px.operation = 'DIVIDE'                                           # -> SD px
    px.inputs[1].default_value = S
    L.new(sub.outputs[0], px.inputs[0])
    scroll = N.new("ShaderNodeValue")
    scroll.name = "scroll"
    add = N.new("ShaderNodeMath")
    add.operation = 'ADD'
    L.new(px.outputs[0], add.inputs[0])
    L.new(scroll.outputs[0], add.inputs[1])
    wrap = N.new("ShaderNodeMath")
    wrap.operation = 'WRAP'
    wrap.inputs[1].default_value, wrap.inputs[2].default_value = period, 0.0
    L.new(add.outputs[0], wrap.inputs[0])
    norm = N.new("ShaderNodeMath")
    norm.operation = 'DIVIDE'
    norm.inputs[1].default_value = period
    L.new(wrap.outputs[0], norm.inputs[0])
    ramp = N.new("ShaderNodeValToRGB")
    ramp.color_ramp.interpolation = 'CONSTANT'
    els = ramp.color_ramp.elements
    pos = 0.0
    for i, (w, c) in enumerate(zip(widths, cols)):
        e = els[i] if i < len(els) else els.new(pos)
        e.position = pos
        e.color = C._srgb(*c)
        pos += w / period
    L.new(norm.outputs[0], ramp.inputs["Fac"])
    L.new(ramp.outputs["Color"], N.get("Principled BSDF").inputs["Base Color"])
    o.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    return o, scroll


def _frames_setup(opts):
    o, scroll = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"scroll": scroll}


def _frames_pose(ctx, pose):
    ctx["scroll"].outputs[0].default_value = float(pose.get("scroll", 0.0))


register_frames("egg", _frames_setup, _frames_pose)
