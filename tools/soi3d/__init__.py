"""soi3d -- procedural 3D sprite renderers for Step On It (runs under Blender's Python).

The entry point tools/soi3d/render3d.py calls run_cli(). Per-sprite builders live in
soi3d/builders/<mode>.py and self-register with @register("<mode>"); shared bpy code is in
soi3d.common. Add a NEW sprite by dropping a new builders/<x>.py -- there is nothing shared to edit,
so parallel agents never collide on a file.
"""

BUILDERS = {}
FRAMES = {}
_discovered = False


def register(mode):
    """Decorator: register a builder under a CLI mode name. The wrapped function receives the argv
    AFTER the mode (so args[0] is the output path) and returns the output path to render."""
    def deco(fn):
        BUILDERS[mode] = fn
        return fn
    return deco


def register_frames(mode, setup, pose):
    """Register the FRAME-MATCHED interface of a builder (tools/soi3d/frames_blender.py):
    `setup(opts) -> ctx` builds the model + scene ONCE; `pose(ctx, params)` moves it to one pose
    (e.g. {"spin": 37.5}) without rebuilding, so a whole sweep/sequence renders in one Blender run.
    A phase-driven builder may rebuild inside `pose` -- it must then return True so the job's render
    size / camera / samples are re-applied to the fresh scene."""
    FRAMES[mode] = (setup, pose)


def discover():
    """Import every module under soi3d/builders/ so their @register decorators run. Idempotent."""
    global _discovered
    if _discovered:
        return
    import importlib
    import pkgutil
    from . import builders
    for mi in pkgutil.iter_modules(builders.__path__):
        importlib.import_module("%s.builders.%s" % (__name__, mi.name))
    _discovered = True


def run_cli(argv=None):
    """Parse Blender's `-- <mode> <out.png> [args]`, dispatch to the builder, and render.

    An unknown or omitted mode falls back to `sign` (the historical default)."""
    import sys
    if argv is None:
        argv = sys.argv[sys.argv.index("--") + 1:] if "--" in sys.argv else []
    discover()
    mode = argv[0] if argv else "sign"
    args = argv[1:]                                  # args[0] = output path
    fn = BUILDERS.get(mode)
    if fn is None:
        print("soi3d: unknown mode %r; falling back to 'sign'" % mode)
        fn = BUILDERS["sign"]
    out = fn(args)
    from . import common
    common.render(out)
