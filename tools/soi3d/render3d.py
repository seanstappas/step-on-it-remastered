#!/usr/bin/env python3
"""render3d.py -- entry point / CLI dispatcher for the SOI procedural 3D sprite renderers.

Run under Blender's Python (the CLI is unchanged apart from the path):
  blender --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]
On success it prints `RENDERED <out>`.

The per-sprite builders now live in tools/soi3d/builders/<mode>.py (auto-discovered and
self-registering via @register); shared bpy geometry/material/scene code is in tools/soi3d/common.py.
Add a NEW sprite by dropping a new tools/soi3d/builders/<x>.py with an @register("<x>") function --
there is NO shared file to edit, so parallel agents never collide. Modes today: mesh, disk, block,
spiral, sign.
"""
import os
import sys

# Blender runs this file by path; put the PARENT folder (tools/) on sys.path so `import soi3d`
# resolves to this package (tools/soi3d/).
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import soi3d  # noqa: E402  (import must follow the sys.path shim above)

soi3d.run_cli()
