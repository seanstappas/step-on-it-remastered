import json, sys
from pathlib import Path
import numpy as np
from PIL import Image

def classes(a):
    r, g, b, al = [a[..., i].astype(float) for i in range(4)]
    on = al > 128
    return {
        "sweater": on & (b > 1.4 * r + 10) & (b > 1.4 * g + 10),
        "trousers": on & (r > 1.6 * g + 10) & (r > 1.6 * b + 10) & (g < 0.45 * r),
        "skin": on & (r > g) & (g > b) & (r > 150) & (g > 0.55 * r) & (r - b > 40),
    }

def stats(pairs):
    acc = {k: [] for k in ("sweater", "trousers", "skin")}
    for p in pairs:
        a = np.asarray(Image.open(p).convert("RGBA"))
        for k, m in classes(a).items():
            if m.any():
                acc[k].append(a[..., :3][m])
    return {k: (np.median(np.concatenate(v), axis=0).astype(int).tolist(), sum(len(x) for x in v)) if v else None
            for k, v in acc.items()}

root = Path(".")
for fam in sys.argv[1:]:
    cfg = json.load(open(root / "extracted/sprites_3d" / fam / "frames.json"))
    lo, hi = cfg["frames"]["range"]
    src_dir = root / "extracted/sprites" / cfg["source"]
    src = [p for p in src_dir.glob("f*.png") if lo <= int(p.stem[1:].split("_")[0]) <= hi]
    ren = sorted((root / "tmp/soi3d_work" / fam / "final").glob("f*.png"))
    print(fam, "src", stats(src))
    print(fam, "ren", stats(ren))
