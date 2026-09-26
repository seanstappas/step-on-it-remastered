"""soi3d.builders.wingshoe -- the speed indicator's winged shoe (spin_ind_sprite_family f32-f61).

In SD pixel units (S = 0.1 units/px): a capsule BODY whose long axis tilts "tilt" degrees from vertical
toward the toe, white on the front half and grey on the back half (by the object's local X), a light-blue
front strip, and two red WINGS flaring from the top (heel) end on either side. It spins about the vertical
axis: pose "spin" (deg; 0 = toe pointing left like f32, 90 = toe toward the camera like f39).
"""
import math

import bpy
import mathutils

from .. import common as C
from .. import register_frames

S = 0.1


def _split_mat(front, back, blue, soft):
    """Colour by object-local X: < 0 (the toe side, the shoe's front) = front, > 0 = back; a blue strip near
    local Z = 0 on the front."""
    m = C._mat("shoe", C._srgb(*front), rough=0.4, spec=0.3)
    N, L = m.node_tree.nodes, m.node_tree.links
    tc, sep = N.new("ShaderNodeTexCoord"), N.new("ShaderNodeSeparateXYZ")
    L.new(tc.outputs["Object"], sep.inputs[0])
    mr = N.new("ShaderNodeMapRange")
    mr.clamp = True
    mr.inputs["From Min"].default_value, mr.inputs["From Max"].default_value = -soft * S, soft * S
    L.new(sep.outputs[0], mr.inputs["Value"])
    mix = N.new("ShaderNodeMix")
    mix.data_type = 'RGBA'
    L.new(mr.outputs["Result"], mix.inputs["Factor"])
    mix.inputs["A"].default_value = C._srgb(*front)
    mix.inputs["B"].default_value = C._srgb(*back)
    ab = N.new("ShaderNodeMath")
    ab.operation = 'ABSOLUTE'
    L.new(sep.outputs[2], ab.inputs[0])
    st = N.new("ShaderNodeMapRange")
    st.clamp = True
    st.inputs["From Min"].default_value, st.inputs["From Max"].default_value = 0.6 * S, 1.2 * S
    st.inputs["To Min"].default_value, st.inputs["To Max"].default_value = 1.0, 0.0
    L.new(ab.outputs[0], st.inputs["Value"])
    fr = N.new("ShaderNodeMath")
    fr.operation = 'MULTIPLY'                                         # the strip only on the front half
    L.new(st.outputs["Result"], fr.inputs[0])
    inv = N.new("ShaderNodeMath")
    inv.operation = 'SUBTRACT'
    inv.inputs[0].default_value = 1.0
    L.new(mr.outputs["Result"], inv.inputs[1])
    L.new(inv.outputs[0], fr.inputs[1])
    mix2 = N.new("ShaderNodeMix")
    mix2.data_type = 'RGBA'
    L.new(fr.outputs[0], mix2.inputs["Factor"])
    L.new(mix.outputs["Result"], mix2.inputs["A"])
    mix2.inputs["B"].default_value = C._srgb(*blue)
    L.new(mix2.outputs["Result"], N.get("Principled BSDF").inputs["Base Color"])
    return m


def build(opts):
    C._clear()
    f = lambda k, d: float(opts.get(k, d))
    bpy.ops.object.empty_add(location=(0, 0, 0))
    root = bpy.context.active_object
    root.name = "root"
    t = math.radians(f("tilt", 40.0))
    d = mathutils.Vector((-math.sin(t), -math.cos(t), 0.0))          # heel (top) -> toe (bottom, forward = -X)
    ln, r = f("length", 8.0), f("radius", 2.2)
    mat = _split_mat(tuple(opts.get("white", (230, 230, 230))), tuple(opts.get("grey", (90, 90, 90))),
                     tuple(opts.get("blue", (150, 150, 255))), f("soft", 0.8))
    if opts.get("body_box", False):
        # a boxy boot: half-sizes r (front-back) x ln/2 (along the axis) x r*depth (side), rounded edges
        bpy.ops.mesh.primitive_cube_add(size=2.0)
        body = bpy.context.active_object
        body.scale = (r * S, ln / 2 * S, r * f("depth", 1.0) * S)
        bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
        bv = body.modifiers.new("bevel", 'BEVEL')
        bv.width = min(f("bevel", 0.8), r * 0.95) * S
        bv.segments = 4
    else:
        bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=32, ring_count=16)
        body = bpy.context.active_object
        body.scale = (r * S, ln / 2 * S, r * f("depth", 1.0) * S)      # an ellipsoid along its local Y
        bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    body.name = "body"
    if f("taper", 0.0):                                               # narrower toward the toe (local -Y)
        tp = body.modifiers.new("taper", 'SIMPLE_DEFORM')
        tp.deform_method = 'TAPER'
        tp.deform_axis = 'Y'
        tp.factor = f("taper", 0.0) / (ln / 2 * S)
    body.rotation_mode = 'QUATERNION'
    body.rotation_quaternion = mathutils.Vector((0, -1, 0)).rotation_difference(d)
    body.location = mathutils.Vector((f("body_x", 0.0), f("body_y", -1.0), 0)) * S
    body.data.materials.append(mat)
    bpy.ops.object.shade_smooth()
    body.parent = root
    red = C._mat("red", C._srgb(*opts.get("red", (200, 0, 0))), rough=0.35, spec=0.3)
    top = mathutils.Vector((f("body_x", 0.0), f("body_y", -1.0), 0)) - d * (ln / 2 * f("wing_at", 0.8))
    for sz in (-1.0, 1.0):
        if opts.get("wing_plate", False):
            # a flat feather fan: n thin plates (each wing_l wide, wing_h tall) fanned by wing_fan deg
            nf = int(opts.get("feathers", 3))
            for i in range(nf):
                a = (i - (nf - 1) / 2) * math.radians(f("wing_fan", 20.0))
                bpy.ops.mesh.primitive_cube_add(size=2.0)
                w = bpy.context.active_object
                w.name = "feather"
                w.scale = (f("wing_l", 2.6) / nf * S, f("wing_h", 1.8) * S, f("wing_t", 0.6) * S)
                bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
                # pivot at the plate's bottom edge so the fan opens from the root
                w.data.transform(mathutils.Matrix.Translation((0, f("wing_h", 1.8) * S, 0)))
                w.rotation_euler = (math.radians(sz * f("wing_out", 25.0)), 0.0, math.radians(-f("wing_up", 35.0)) + a)
                w.location = (top + mathutils.Vector((f("wing_dx", 1.0) + (i - (nf - 1) / 2) * f("wing_l", 2.6) / nf,
                                                      f("wing_dy", 1.0), sz * f("wing_z", 2.2)))) * S
                w.data.materials.append(red)
                w.parent = root
            continue
        bpy.ops.mesh.primitive_uv_sphere_add(radius=1.0, segments=20, ring_count=10)
        w = bpy.context.active_object
        w.name = "wing"
        w.scale = (f("wing_l", 2.6) * S, f("wing_h", 1.8) * S, f("wing_t", 0.6) * S)
        w.rotation_euler = (math.radians(sz * f("wing_out", 25.0)), 0.0, math.radians(-f("wing_up", 35.0)))
        w.location = (top + mathutils.Vector((f("wing_dx", 1.0), f("wing_dy", 1.0), sz * f("wing_z", 2.2)))) * S
        w.data.materials.append(red)
        bpy.ops.object.shade_smooth()
        w.parent = root
    return root


def _frames_setup(opts):
    root = build(opts)
    C.setup_scene(256, world_strength=0.1, fill_energy=0.1)
    C.apply_look(opts)
    return {"root": root}


def _frames_pose(ctx, pose):
    ctx["root"].rotation_euler = (0.0, math.radians(float(pose.get("spin", 0.0))), 0.0)


register_frames("wingshoe", _frames_setup, _frames_pose)
