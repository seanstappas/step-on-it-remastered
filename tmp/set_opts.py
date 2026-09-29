"""Set opts on a family's frames.json (and its refine inits): py tmp/set_opts.py <family> '<json opts>'
Run after `framematch.py <family> bake`; delete the work look.json afterwards or it overrides these."""
import json
import sys

fam, new = sys.argv[1], json.loads(sys.argv[2])
p = "extracted/sprites_3d/%s/frames.json" % fam
with open(p, "r", encoding="utf-8-sig") as fh:
    c = json.load(fh)
c["opts"].update(new)
for k, v in new.items():
    r = c.get("look", {}).get("refine", {}).get(k)
    if r is not None and isinstance(v, (int, float)) and not isinstance(v, bool):
        r["init"] = min(max(v, r.get("min", v)), r.get("max", v))
with open(p, "w", encoding="utf-8") as fh:
    json.dump(c, fh, indent=1, ensure_ascii=False)
    fh.write("\n")
print(fam, {k: c["opts"][k] for k in new})
