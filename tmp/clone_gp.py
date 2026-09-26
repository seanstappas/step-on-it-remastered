"""Clone a blue-player framematch family into its green twin (GP_sprites = BP_sprites recoloured).
usage: py tmp/clone_gp.py <BP family> <GP family>"""
import collections
import json
import os
import shutil
import sys

bp, gp = sys.argv[1], sys.argv[2]
src = os.path.join("extracted", "sprites_3d", bp, "frames.json")
c = json.loads(open(src, encoding="utf-8").read(), object_pairs_hook=collections.OrderedDict)
c["status"] = "wip"
c["source"] = "GP_sprites"
c["note"] = ("The GREEN player's copy of %s: GP_sprites is BP_sprites with the sweater recoloured blue -> green, "
             "so this reuses %s's fit.json poses and placement and its baked look; only the sweater is re-tuned "
             "and optimfail fixes the frames whose outline pixels differ." % (bp, bp))
c["opts"]["sweater"] = [0, 120, 0]
c["opts"].pop("sweater_gain", None)
c["look"] = collections.OrderedDict([
    ("frames", 12), ("passes", 1), ("samples", 32),
    ("params", {"sweater": [[0, 100, 0], [0, 120, 0], [0, 140, 0], [15, 150, 15]]}),
    ("refine", {"sweater_gain": {"step": 0.05, "min": 0.7, "max": 1.4, "init": 1.0}}),
    ("refine_rounds", 6), ("iou_w", 200), ("iou_margin", 0.03)])
os.makedirs(os.path.join("extracted", "sprites_3d", gp), exist_ok=True)
open(os.path.join("extracted", "sprites_3d", gp, "frames.json"), "w", encoding="utf-8", newline="\n").write(
    json.dumps(c, indent=1) + "\n")
wd = os.path.join("tmp", "soi3d_work", gp)
os.makedirs(wd, exist_ok=True)
shutil.copyfile(os.path.join("tmp", "soi3d_work", bp, "fit.json"), os.path.join(wd, "fit.json"))
print("cloned", bp, "->", gp, c["frames"])
