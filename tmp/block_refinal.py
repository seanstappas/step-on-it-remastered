"""Re-render only the named block_sprites frames (their derived crack / quarter frames follow), after their
options were changed -- every other published block frame stays byte-identical.

  py tmp/block_refinal.py 110,116"""
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

FAM = "block_sprites"
want = {int(x) for x in sys.argv[1].split(",")}
cfg = fm.load_cfg(FAM)
full = fm.base_frames
fm.base_frames = lambda c: [f for f in full(c) if f[0] in want]
fm.stage_final(FAM, cfg)
