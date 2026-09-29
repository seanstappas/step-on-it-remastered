import json

m = json.load(open("extracted/manifest.json"))
hits = []


def walk(o, path=""):
    if isinstance(o, dict):
        s = json.dumps(o)
        if any(k in s for k in ("block_sprites", "bigger_mblock", "\"blocks")) and len(s) < 600:
            hits.append((path, s[:400]))
            return
        for k, v in o.items():
            walk(v, path + "/" + str(k))
    elif isinstance(o, list):
        for i, v in enumerate(o):
            walk(v, path + "[%d]" % i)


walk(m)
for h in hits[:12]:
    print(h)
