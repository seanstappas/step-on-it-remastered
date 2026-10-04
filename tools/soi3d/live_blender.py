#!/usr/bin/env python3
"""live_blender.py -- Blender side of framematch.py `live`: export a family's model for REAL-TIME 3D.

  blender --background --factory-startup --python tools/soi3d/live_blender.py -- <job.json>

Builds the model once (the builder's frames interface, the family's fitted look options), poses it at
every frame's fitted pose and records each node's parent-relative transform, then exports the model
(modifiers applied, Blender axes kept: X right, Y up, Z toward the camera -- Godot's own convention)
as <out>/model.glb plus <out>/live.json: per-frame node transforms and cameras, the lights, the world
ambient and the materials, so the game can pose and light it between any two frames.
Prints `LIVE_DONE <frames>` on success.
"""
import json
import math
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import bpy  # noqa: E402
import mathutils  # noqa: E402

import soi3d  # noqa: E402


def _flat(m):
    return [round(float(m[r][c]), 6) for r in range(4) for c in range(4)]


def _material(m):
    b = m.node_tree.nodes.get("Principled BSDF") if m.use_nodes else None
    if b is None:
        return {"color": [0.8, 0.8, 0.8, 1.0], "rough": 0.5, "metal": 0.0, "spec": 0.5}
    g = lambda k, d: b.inputs[k].default_value if k in b.inputs else d
    return {"color": [round(float(v), 6) for v in g("Base Color", (0.8, 0.8, 0.8, 1.0))],
            "rough": float(g("Roughness", 0.5)), "metal": float(g("Metallic", 0.0)),
            "spec": float(g("Specular IOR Level", 0.5)), "coat": float(g("Coat Weight", 0.0)),
            "coat_rough": float(g("Coat Roughness", 0.03)),
            "emit": float(g("Emission Strength", 0.0)),
            "emit_color": [round(float(v), 6) for v in g("Emission Color", (0, 0, 0, 1))][:3],
            "procedural": any(n.type not in ("BSDF_PRINCIPLED", "OUTPUT_MATERIAL") for n in m.node_tree.nodes)}


def main():
    argv = sys.argv[sys.argv.index("--") + 1:]
    with open(argv[0], "r", encoding="utf-8") as fh:
        job = json.load(fh)
    soi3d.discover()
    setup, pose = soi3d.FRAMES[job["mode"]]
    ctx = setup(job["opts"])
    curves = [o for o in bpy.data.objects if o.type in ("FONT", "CURVE")]     # text/curves export only as meshes
    if curves:
        bpy.ops.object.select_all(action="DESELECT")
        for o in curves:
            o.select_set(True)
        bpy.context.view_layer.objects.active = curves[0]
        bpy.ops.object.convert(target="MESH")
    model = [o for o in bpy.data.objects if o.type in ("MESH", "EMPTY")]
    blend_shapes = [(o, k) for o in model if o.type == "MESH" and o.data.shape_keys
                    for k in o.data.shape_keys.key_blocks[1:]]
    order = sorted(job["frames"], key=int)
    per = {}
    weights = {}
    for nn in order:
        if pose(ctx, job["frames"][nn]["pose"]) is True:
            raise SystemExit("live: builder %r rebuilds its scene per pose -- no fixed rig to export" % job["mode"])
        bpy.context.view_layer.update()
        per[nn] = {o.name: _flat(o.matrix_local) for o in model}
        weights[nn] = [round(float(k.value), 6) for _, k in blend_shapes]
    moving = sorted(n for n in per[order[0]] if any(per[nn][n] != per[order[0]][n] for nn in order))
    lights = []
    for o in bpy.data.objects:
        if o.type == "LIGHT":
            d = (o.matrix_world.to_3x3() @ mathutils.Vector((0.0, 0.0, -1.0))).normalized()
            lights.append({"type": o.data.type, "energy": float(o.data.energy), "color": list(o.data.color),
                           "dir": [round(v, 6) for v in d], "shadow": bool(o.data.use_shadow),
                           "angle_deg": math.degrees(float(getattr(o.data, "angle", 0.0)))})
    scn = bpy.context.scene
    world = scn.world.node_tree.nodes["Background"].inputs["Strength"].default_value if scn.world else 0.0
    mats = {m.name: _material(m) for m in bpy.data.materials if m.users}
    pose(ctx, job["frames"][order[0]]["pose"])
    bpy.context.view_layer.update()
    os.makedirs(job["out"], exist_ok=True)
    bpy.ops.object.select_all(action="DESELECT")
    for o in model:
        o.select_set(True)
    bpy.ops.export_scene.gltf(filepath=os.path.join(job["out"], "model.glb"), export_format="GLB",
                              use_selection=True, export_yup=False, export_apply=True, export_animations=False,
                              export_cameras=False, export_lights=False)
    out = {"sheet": job["sheet"], "family": job["family"], "scale": job["scale"], "world": float(world),
           "gamma": float(scn.view_settings.gamma), "lights": lights, "materials": mats, "nodes": moving,
            "blend_shapes": [{"node": o.name, "shape": k.name} for o, k in blend_shapes],
           "post": job.get("post", []),
           "frames": {nn: {"w": job["frames"][nn]["w"], "h": job["frames"][nn]["h"],
                      "cam": job["frames"][nn]["cam"], "xf": [per[nn][n] for n in moving],
                      "bs": weights[nn]} for nn in order}}
    with open(os.path.join(job["out"], "live.json"), "w", encoding="utf-8") as fh:
        json.dump(out, fh)
    print("LIVE_DONE %d" % len(order))


main()
