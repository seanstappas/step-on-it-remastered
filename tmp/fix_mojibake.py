"""Find (and with --fix, repair) UTF-8 text that was double-encoded through cp1252 (e.g. an em dash stored as
the three characters a-circumflex, euro sign, right double quote)."""
import re
import subprocess
import sys

C1 = {ord(c): c for c in (chr(b) for b in range(0x80, 0xA0))}


def to_cp1252(run):
    out = bytearray()
    for ch in run:
        if 0x80 <= ord(ch) < 0xA0:
            out.append(ord(ch))
        else:
            out += ch.encode("cp1252")
    return bytes(out)


RUN = re.compile(r"[^\x00-\x7f]+")


def repair(text):
    n = 0

    def sub(m):
        nonlocal n
        run = m.group(0)
        try:
            fixed = to_cp1252(run).decode("utf-8")
        except (UnicodeEncodeError, UnicodeDecodeError):
            return run
        if fixed != run:
            n += 1
        return fixed

    prev = None
    while prev != text:                     # a file corrupted twice needs two passes
        prev = text
        text = RUN.sub(sub, text)
    return text, n


files = subprocess.run(["git", "ls-files", "-m", "-o", "--exclude-standard"], capture_output=True, text=True).stdout.split()
for f in files:
    if not f.endswith((".md", ".py", ".gd", ".ps1", ".txt", ".cfg", ".json")) or f.startswith(("extracted/", "tmp/")):
        continue
    try:
        raw = open(f, "rb").read()
        text = raw.decode("utf-8")
    except (OSError, UnicodeDecodeError):
        continue
    fixed, n = repair(text)
    if n:
        print("%-60s %d runs" % (f, n))
        if "--fix" in sys.argv:
            open(f, "wb").write(fixed.encode("utf-8"))
