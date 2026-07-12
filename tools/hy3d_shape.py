"""Hunyuan3D-2.1 shape (white-model) generation for the SOI 3D-sprite prototype.

Run with the WinPortable pack's bundled Python, from the Hunyuan3D-2.1 folder, so
the relative ./hy3dshape import and the on-demand model download resolve. The
caller sets HF_HUB_CACHE / HY3DGEN_MODELS (see the pack's RUN.bat).

Usage (from D:\\HY3D2\\Hunyuan3D2_WinPortable\\Hunyuan3D-2.1):
  python.exe soi_hy3d_shape.py <out_dir> <in1.png> [in2.png ...]
"""
import os
import sys
import time

# Must run with cwd = the Hunyuan3D-2.1 folder. Put it (and its sub-pkgs) on the
# path so `hy3dshape`, `hy3dpaint` and `torchvision_fix` import regardless of how
# python was launched (`-s` sets sys.path[0] to this script's dir, not cwd).
sys.path.insert(0, ".")
sys.path.insert(0, "./hy3dshape")
sys.path.insert(0, "./hy3dpaint")

from PIL import Image  # noqa: E402

try:
    from torchvision_fix import apply_fix
    apply_fix()
except Exception as e:  # pragma: no cover - best-effort compat shim
    print(f"[warn] torchvision_fix not applied: {e}")

from hy3dshape.rembg import BackgroundRemover  # noqa: E402
from hy3dshape.pipelines import Hunyuan3DDiTFlowMatchingPipeline  # noqa: E402


def main() -> int:
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    out_dir = sys.argv[1]
    inputs = sys.argv[2:]
    os.makedirs(out_dir, exist_ok=True)

    print("Loading Hunyuan3D-2.1 shape pipeline (first run downloads weights)...")
    t0 = time.time()
    pipe = Hunyuan3DDiTFlowMatchingPipeline.from_pretrained("tencent/Hunyuan3D-2.1")
    print(f"pipeline ready in {time.time() - t0:.0f}s")
    rembg = None

    for path in inputs:
        name = os.path.splitext(os.path.basename(path))[0]
        img = Image.open(path).convert("RGBA")
        # only fall back to rembg for a fully-opaque input (downloads u2net on
        # first use); alpha sprites already carry their own foreground mask.
        if img.getextrema()[3][0] == 255:
            if rembg is None:
                rembg = BackgroundRemover()
            print(f"[{name}] opaque input -> running rembg")
            img = rembg(img.convert("RGB"))
        t1 = time.time()
        mesh = pipe(image=img)[0]
        out = os.path.join(out_dir, name + ".glb")
        mesh.export(out)
        try:
            nv = len(mesh.vertices)
            nf = len(mesh.faces)
        except Exception:
            nv = nf = -1
        print(f"[{name}] mesh {nv}v/{nf}f in {time.time() - t1:.0f}s -> {out}")
    print("ALL_DONE")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
