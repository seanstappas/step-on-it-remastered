"""soi3d.common -- shared Blender (bpy) helpers for the procedural SOI 3D sprite renderers.

Materials, generic geometry primitives, GLB import, and the orthographic scene/camera/lights that
EVERY per-sprite builder (soi3d/builders/*.py) reuses. Put anything used by 2+ sprites (or a generic
primitive) here; keep sprite-SPECIFIC geometry in that sprite's builder module.

Runs only under Blender's Python (imports bpy).
"""
import math

import bpy

# Times (Bold) = the ORIGINAL game font: the RE'd decomp draws every text string with
# TextFont(0x14)=font id 20 (Times) + TextFace(1)=Bold, and the HUD 'Score'/'Bonus'/digit/
# 'GAME OVER' sprites are all rendered in that serif face. Times New Roman Bold is the faithful
# Windows match. Override per-render via a builder's [font] argument.
DEFAULT_SIGN_FONT = r"C:\Windows\Fonts\timesbd.ttf"


def _clear():
    bpy.ops.object.select_all(action='SELECT')
    bpy.ops.object.delete(use_global=False)
    for coll in (bpy.data.meshes, bpy.data.materials, bpy.data.curves):
        for b in list(coll):
            coll.remove(b)


def _mat(name, rgba, rough=0.5, metal=0.0, spec=0.5, coat=0.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    bsdf = m.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = rgba
    bsdf.inputs["Roughness"].default_value = rough
    bsdf.inputs["Metallic"].default_value = metal
    si = bsdf.inputs.get("Specular IOR Level")   # Blender 4.x; low = no white glossy wash -> true albedo
    if si is not None:
        si.default_value = spec
    if coat > 0:                                  # glossy clearcoat -> tight shine WITHOUT desaturating base
        cw = bsdf.inputs.get("Coat Weight")
        if cw is not None:
            cw.default_value = coat
        crn = bsdf.inputs.get("Coat Roughness")
        if crn is not None:
            crn.default_value = 0.07
    return m


def _srgb(r, g, b):
    """sRGB 0..255 -> linear RGBA for a faithful rendered colour under Cycles."""
    def lin(c):
        c /= 255.0
        return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4
    return (lin(r), lin(g), lin(b), 1.0)


def _text(body, z, mat, extrude=0.03, size=0.62, font=None):
    crv = bpy.data.curves.new("txt", type='FONT')
    crv.body = body
    if font:
        crv.font = bpy.data.fonts.load(font)
    crv.align_x = 'CENTER'
    crv.align_y = 'CENTER'
    crv.extrude = extrude
    crv.size = size
    obj = bpy.data.objects.new("txt", crv)
    bpy.context.collection.objects.link(obj)
    obj.location = (0, 0, z)
    obj.data.materials.append(mat)
    return obj


def _square(name, half, z, mat, bevel=0.02, depth=0.12):
    bpy.ops.mesh.primitive_cube_add(size=1, location=(0, 0, z))
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = (2 * half, 2 * half, depth)  # size-1 cube -> full width 2*half (i.e. +/-half)
    bm = obj.modifiers.new("bevel", 'BEVEL')
    bm.width = bevel
    bm.segments = 2
    obj.data.materials.append(mat)
    return obj


def _box(name, center, size, mat, bevel=0.02, seg=2):
    """An axis-aligned box at `center` with full-extent `size` (x, y, z), lightly bevelled."""
    bpy.ops.mesh.primitive_cube_add(size=1, location=center)
    obj = bpy.context.active_object
    obj.name = name
    obj.scale = size
    m = obj.modifiers.new("bevel", 'BEVEL')
    m.width = bevel
    m.segments = seg
    obj.data.materials.append(mat)
    return obj


def _clay():
    return _mat("clay", (0.72, 0.72, 0.75, 1), rough=0.6)


def load_glb(path):
    """Import a GLB, join to one mesh, center on its bbox, normalise to ~2 units, clay it."""
    import mathutils
    before = set(bpy.data.objects)
    bpy.ops.import_scene.gltf(filepath=path)
    new = [o for o in bpy.data.objects if o not in before]
    meshes = [o for o in new if o.type == 'MESH']
    bpy.ops.object.select_all(action='DESELECT')
    for o in meshes:
        o.select_set(True)
    bpy.context.view_layer.objects.active = meshes[0]
    if len(meshes) > 1:
        bpy.ops.object.join()
    obj = bpy.context.view_layer.objects.active
    bpy.ops.object.transform_apply(location=True, rotation=True, scale=True)
    bb = [obj.matrix_world @ mathutils.Vector(c) for c in obj.bound_box]
    mn = mathutils.Vector((min(v.x for v in bb), min(v.y for v in bb), min(v.z for v in bb)))
    mx = mathutils.Vector((max(v.x for v in bb), max(v.y for v in bb), max(v.z for v in bb)))
    obj.location -= (mn + mx) / 2
    bpy.ops.object.transform_apply(location=True)
    dim = max((mx - mn).x, (mx - mn).y, (mx - mn).z) or 1.0
    obj.scale = (2.0 / dim,) * 3
    bpy.ops.object.transform_apply(scale=True)
    obj.data.materials.clear()
    obj.data.materials.append(_clay())
    bpy.ops.object.shade_smooth()
    return obj


def orbit_camera(az_deg, el_deg, ortho_scale=2.4, dist=8.0):
    """Orthographic camera on a sphere around the origin, tracking it."""
    az, el = math.radians(az_deg), math.radians(el_deg)
    x = dist * math.cos(el) * math.sin(az)
    y = -dist * math.cos(el) * math.cos(az)
    z = dist * math.sin(el)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    target = bpy.context.active_object
    bpy.ops.object.camera_add(location=(x, y, z))
    cam = bpy.context.active_object
    cam.data.type = 'ORTHO'
    cam.data.ortho_scale = ortho_scale
    con = cam.constraints.new('TRACK_TO')
    con.target = target
    con.track_axis = 'TRACK_NEGATIVE_Z'
    con.up_axis = 'UP_Y'
    bpy.context.scene.camera = cam
    return cam


def setup_scene(px=256, add_cam=True, world_strength=0.11, fill_energy=0.14):
    scn = bpy.context.scene
    # Dim neutral world fill + a STRONG top-left key sun (+ soft lower-right fill) for real 3D
    # shading and shadows -> embossed relief on the signs, a lit top-left highlight on the ball.
    world = bpy.data.worlds['World'] if 'World' in bpy.data.worlds else bpy.data.worlds.new('World')
    scn.world = world
    world.use_nodes = True
    world.node_tree.nodes["Background"].inputs["Strength"].default_value = world_strength
    world.node_tree.nodes["Background"].inputs["Color"].default_value = (1, 1, 1, 1)
    bpy.ops.object.empty_add(location=(0, 0, 0))
    tgt = bpy.context.active_object
    bpy.ops.object.light_add(type='SUN', location=(-3.2, 3.2, 3.0))   # top-left-front KEY
    key = bpy.context.active_object
    key.data.energy = 3.8
    key.data.angle = math.radians(4.5)
    kc = key.constraints.new('TRACK_TO')
    kc.target = tgt
    kc.track_axis = 'TRACK_NEGATIVE_Z'
    kc.up_axis = 'UP_Y'
    bpy.ops.object.light_add(type='SUN', location=(2.6, -2.2, 2.4))   # lower-right soft FILL
    fill = bpy.context.active_object
    fill.data.energy = fill_energy
    fc = fill.constraints.new('TRACK_TO')
    fc.target = tgt
    fc.track_axis = 'TRACK_NEGATIVE_Z'
    fc.up_axis = 'UP_Y'
    if add_cam:
        # Orthographic front camera looking down -Z.
        bpy.ops.object.camera_add(location=(0, 0, 5), rotation=(0, 0, 0))
        cam = bpy.context.active_object
        cam.data.type = 'ORTHO'
        cam.data.ortho_scale = 2.15
        scn.camera = cam
    # Render: Cycles/CPU (rock-solid headless; EEVEE-Next crashes compiling GPU shaders
    # in --background on many drivers). RGBA transparent, square.
    scn.render.engine = 'CYCLES'
    scn.cycles.device = 'CPU'
    scn.cycles.samples = 160
    scn.cycles.diffuse_bounces = 0   # direct+fill+world only -> no red->green colour bleed (saturated hues)
    # Standard view transform (NOT Blender 4.x's default AgX, which crushes/desaturates highlights &
    # colours) -> bright specular glints stay bright and hues stay saturated like the source pixel art.
    scn.view_settings.view_transform = 'Standard'
    scn.view_settings.gamma = 1.0    # reset: apply_look's "gamma" must not leak into the next option group
    scn.render.film_transparent = True
    scn.render.resolution_x = px
    scn.render.resolution_y = px
    scn.render.image_settings.file_format = 'PNG'
    scn.render.image_settings.color_mode = 'RGBA'


def apply_look(opts):
    """Frame-matched look knobs shared by every builder (tools/soi3d/framematch.py "look" stage):
    "world" (ambient strength), "key" (top-left key sun energy), "fill" (lower-right fill energy),
    "key_dir" ([x, y, z] direction TO the key sun; default (-3.2, 3.2, 3.0) = 45 deg top-left; measure a
    source's with a Lambert fit on a plain sphere region), "gamma" (display gamma; < 1 = the harder
    light falloff of some originals), "shadows" (false = no cast shadows). Call AFTER setup_scene; absent
    keys keep setup_scene's values."""
    scn = bpy.context.scene
    if "world" in opts and scn.world is not None:
        scn.world.node_tree.nodes["Background"].inputs["Strength"].default_value = float(opts["world"])
    suns = sorted((o for o in bpy.data.objects if o.type == 'LIGHT' and o.data.type == 'SUN'),
                  key=lambda o: -o.data.energy)
    if suns and "key_dir" in opts:
        d = [float(v) for v in opts["key_dir"]]
        n = math.sqrt(sum(v * v for v in d)) or 1.0
        suns[0].location = tuple(v / n * 5.0 for v in d)
    if suns and "key" in opts:
        suns[0].data.energy = float(opts["key"])
    if suns and "key_angle" in opts:                          # deg: a wider sun = a softer highlight
        suns[0].data.angle = math.radians(float(opts["key_angle"]))
    if len(suns) > 1 and "fill" in opts:
        suns[-1].data.energy = float(opts["fill"])
    if len(suns) > 1 and "fill_spec" in opts:                 # 0 = the fill adds no glint of its own
        suns[-1].data.specular_factor = float(opts["fill_spec"])
    if "gamma" in opts:
        scn.view_settings.gamma = float(opts["gamma"])
    if not opts.get("shadows", True):
        # "shadows": false = no CAST shadows (shading still follows N.L). Some originals were rendered
        # without them: the ostrich's thin neck and legs stay lit under its head and body.
        for o in bpy.data.objects:
            if o.type == 'LIGHT':
                o.data.use_shadow = False
            elif o.type == 'MESH':
                o.visible_shadow = False


def render(out):
    """Point the scene at `out` and render one still (prints RENDERED, the success sentinel)."""
    bpy.context.scene.render.filepath = out
    bpy.ops.render.render(write_still=True)
    print("RENDERED", out)
