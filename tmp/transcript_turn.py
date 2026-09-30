"""Locate user messages in the session transcript and dump the entries after the Nth-from-last one.

  py tmp/transcript_turn.py <transcript.jsonl> [k=1]   -> tmp/transcript_turn.txt (entries after the k-th last user msg)"""
import json
import sys

src = sys.argv[1]
k = int(sys.argv[2]) if len(sys.argv) > 2 else 1
rows = []
with open(src, "r", encoding="utf-8") as fh:
    for i, line in enumerate(fh, 1):
        try:
            rows.append((i, json.loads(line)))
        except ValueError:
            rows.append((i, {}))
users = [i for i, d in rows if d.get("type") == "user.message"]
print("entries", len(rows), "user messages at", users[-4:])
start = users[-k]
out = []
for i, d in rows:
    if i < start:
        continue
    data = d.get("data", {})
    t = d.get("type")
    if t == "assistant.message":
        for tr in data.get("toolRequests", []):
            out.append("[%d] CALL %s %s" % (i, tr.get("name"), str(tr.get("arguments"))[:700]))
        if data.get("content"):
            out.append("[%d] SAY %s" % (i, data["content"][:700]))
        if data.get("reasoningText"):
            out.append("[%d] THINK %s" % (i, data["reasoningText"][:500]))
    elif t == "user.message":
        out.append("[%d] USER %s" % (i, str(data.get("content"))[:300]))
with open("tmp/transcript_turn.txt", "w", encoding="utf-8") as fh:
    fh.write("\n".join(out))
print("wrote", len(out), "lines from entry", start)
