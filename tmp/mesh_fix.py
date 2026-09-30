"""Re-render only the cross-hatch mesh tile (block_sprites f152) at the original's lattice (2 diamonds per
tile, bars crossing at the edge quarter points), then re-derive its crack / quarter frames.

The look optimiser had picked cells 4 / bar_r 0.035 (twice the SD density, off-phase) because its
candidate list never included the SD's 2 cells."""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools", "soi3d"))
import framematch as fm  # noqa: E402

FAM = "block_sprites"
MESH = {"cells": 2.0, "phase": 0.5, "bar_r": 0.09, "world": 0.3, "key": 2.5, "color_gain": 0.85}

p = os.path.join(fm.FAM_DIR, FAM, "frames.json")
with open(p, "r", encoding="utf-8-sig") as fh:
    raw = json.load(fh)
raw["frame_opts"]["152"].update(MESH)
raw["look"]["per_kind"]["mesh"] = {"bar_r": [0.08, 0.09, 0.1], "color_gain": [0.75, 0.85, 1.0]}
with open(p, "w", encoding="utf-8") as fh:
    json.dump(raw, fh, indent=1)

lp = os.path.join(fm.WORK, FAM, "look.json")
with open(lp, "r", encoding="utf-8") as fh:
    lj = json.load(fh)
lj["frame_opts"]["152"] = {"color_gain": MESH["color_gain"], "bar_r": MESH["bar_r"]}
with open(lp, "w", encoding="utf-8") as fh:
    json.dump(lj, fh, indent=1)

cfg = fm.load_cfg(FAM)
full = fm.base_frames
fm.base_frames = lambda c: [f for f in full(c) if f[0] == 152]
fm.stage_final(FAM, cfg)
