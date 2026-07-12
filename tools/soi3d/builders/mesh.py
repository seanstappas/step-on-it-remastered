"""soi3d.builders.mesh -- import a GLB and orbit-render it (the AI-mesh research path, design sec.12).

Not a shipping sprite: this loads an external mesh, normalises it and renders it under a clay material
from an orbiting orthographic camera, for comparing AI-generated meshes against the procedural builds.
"""
from .. import common as C
from .. import register


@register("mesh")
def render(args):
    # mesh <out.png> <glb> <azimuth_deg> <elevation_deg> [px]
    out = args[0]
    glb = args[1]
    az = float(args[2]) if len(args) > 2 else 0.0
    el = float(args[3]) if len(args) > 3 else 12.0
    px = int(args[4]) if len(args) > 4 else 256
    C._clear()
    C.load_glb(glb)
    C.setup_scene(px, add_cam=False)
    C.orbit_camera(az, el)
    return out
