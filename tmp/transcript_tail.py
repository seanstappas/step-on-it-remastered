"""Dump the tail of the session transcript (one truncated line per entry) to tmp/transcript_tail.txt."""
import json
import sys

src, start = sys.argv[1], int(sys.argv[2])
out = []
with open(src, "r", encoding="utf-8") as fh:
    for i, line in enumerate(fh, 1):
        if i < start:
            continue
        try:
            d = json.loads(line)
        except ValueError:
            out.append("[%d] (bad json)" % i)
            continue
        s = json.dumps(d, ensure_ascii=True)
        out.append("[%d] %s" % (i, s[:900] + (" ..." if len(s) > 900 else "")))
with open("tmp/transcript_tail.txt", "w", encoding="utf-8") as fh:
    fh.write("\n".join(out))
print(len(out))
