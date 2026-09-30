"""List boards containing given badguy types (bord low byte with the 0x400 entity bit).

  py tmp/find_badguys.py 13 14      -> boards with Knights (13) / Gargoyles (14)
"""
import glob
import os
import struct
import sys

want = {int(a) for a in sys.argv[1:]} or {13}
for p in sorted(glob.glob('extracted/levels/*.bord')):
    b = open(p, 'rb').read()
    i = 24
    found = {}
    while i + 4 <= len(b):
        t = struct.unpack_from('>I', b, i)[0]
        i += 4
        cells = []
        while i + 2 <= len(b) and not (b[i] == 0x64 and b[i + 1] == 0x64):
            cells.append((b[i], b[i + 1]))
            i += 2
        i += 2
        if (t & 0x400) and (t & 0xFF) in want:
            found.setdefault(t & 0xFF, []).extend(cells)
        if t == 0:
            break
    if found:
        print(os.path.basename(p), {k: v[:4] for k, v in found.items()})
