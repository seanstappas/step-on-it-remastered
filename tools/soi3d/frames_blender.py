#!/usr/bin/env python3
"""frames_blender.py -- Blender side of the FRAME-MATCHED 3D pipeline (driven by framematch.py).

  blender --background --factory-startup --python tools/soi3d/frames_blender.py -- <job.json>

The job names a builder mode that registered a frames interface (soi3d.register_frames: setup/pose),
the render size, the camera placement and a list of {"out": png, "pose": {...}} items. The model is
built ONCE, then each item is posed and rendered -- a whole pose sweep or a family's full frame
sequence in one Blender run. Cycles uses the GPU (OptiX, else CUDA) when present, else the CPU.
Prints `FRAMES_DONE <n>` on success.
"""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import bpy  # noqa: E402

import soi3d  # noqa: E402


def _use_gpu():
    prefs = bpy.context.preferences.addons["cycles"].preferences
    for kind in ("OPTIX", "CUDA"):
        try:
            prefs.compute_device_type = kind
            prefs.get_devices()
        except Exception:
            continue
        devs = [d for d in prefs.devices if d.type == kind]
        if devs:
            for d in prefs.devices:
                d.use = d.type == kind
            bpy.context.scene.cycles.device = 'GPU'
            return kind
    bpy.context.scene.cycles.device = 'CPU'
    return "CPU"


def _settings(job):
    scn = bpy.context.scene
    scn.cycles.samples = int(job.get("samples", 64))
    scn.cycles.use_denoising = bool(job.get("denoise", False))
    scn.render.resolution_x, scn.render.resolution_y = int(job["size"][0]), int(job["size"][1])
    scn.render.resolution_percentage = 100
    scn.render.film_transparent = True
    scn.render.use_persistent_data = True       # keep the BVH/kernels between the job's renders
    scn.render.image_settings.file_format = 'PNG'
    scn.render.image_settings.color_mode = 'RGBA'
    _camera(job.get("camera", {}))


def _camera(camj):
    cam = bpy.context.scene.camera
    if "ortho_scale" in camj:
        cam.data.ortho_scale = float(camj["ortho_scale"])
    cam.location.x = float(camj.get("x", cam.location.x))
    cam.location.y = float(camj.get("y", cam.location.y))


def main():
    argv = sys.argv[sys.argv.index("--") + 1:]
    with open(argv[0], "r", encoding="utf-8") as fh:
        job = json.load(fh)
    soi3d.discover()
    if job["mode"] not in soi3d.FRAMES:
        raise SystemExit("frames_blender: mode %r has no register_frames() interface" % job["mode"])
    setup, pose = soi3d.FRAMES[job["mode"]]
    cur_opts = job.get("opts", {})
    ctx = setup(cur_opts)
    dev = _use_gpu()
    _settings(job)
    scn = bpy.context.scene
    print("frames_blender: %s on %s, %d items at %dx%d" % (job["mode"], dev, len(job["items"]),
                                                           scn.render.resolution_x, scn.render.resolution_y))
    for it in job["items"]:
        if "opts" in it and it["opts"] != cur_opts:      # a look variant: rebuild the model + scene
            cur_opts = it["opts"]
            ctx = setup(cur_opts)
            _use_gpu()
            _settings(job)
        if pose(ctx, it["pose"]) is True:                 # the pose REBUILT the scene (a phase-driven
            _use_gpu()                                    # builder): re-apply the job's render/camera
            _settings(job)
        _camera(it.get("camera", job.get("camera", {})))   # a per-frame camera (sprite offset), else the job's
        scn.render.filepath = it["out"]
        bpy.ops.render.render(write_still=True)
    print("FRAMES_DONE %d" % len(job["items"]))


main()
