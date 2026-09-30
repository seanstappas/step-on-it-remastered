"""Map sssf resource ids to extracted sprite sheet names (manifest.json)."""
import json
import sys

m = json.load(open('extracted/manifest.json', encoding='utf-8'))
sp = m['sprites']
items = sp if isinstance(sp, list) else [dict(v, _key=k) for k, v in sp.items()]
print(type(sp).__name__, len(items))
print(json.dumps(items[0])[:400])
want = {int(a) for a in sys.argv[1:]} or {130, 134}
for it in items:
    ids = [v for k, v in it.items() if k in ('id', 'res_id', 'rid', 'resource_id') and isinstance(v, int)]
    if any(i in want for i in ids):
        print(json.dumps(it)[:300])
