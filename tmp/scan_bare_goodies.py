"""Scan every board for cell records whose low byte is a goody type but lack the 0x800 collectible bit
(and are not supportive blocks) -- the original never collects those (FUN_1002bc64 tests cell & 0x800)."""
import collections
import glob
import os
import struct

GOODY = set(range(0x0A, 0x1A)) | set(range(0x2E, 0x33))
hits = collections.Counter()
for p in sorted(glob.glob('extracted/levels/*.bord')):
    b = open(p, 'rb').read()
    i = 24
    while i + 4 <= len(b):
        t = struct.unpack_from('>I', b, i)[0]
        i += 4
        n = 0
        while i + 2 <= len(b) and not (b[i] == 0x64 and b[i + 1] == 0x64):
            n += 1
            i += 2
        i += 2
        if t == 0:
            break
        lo = t & 0xFF
        if lo in GOODY and not (t & 0x800) and not (t & 0x200) and not (t & 0x400):
            hits[(os.path.basename(p), hex(t))] += n
for k, v in sorted(hits.items()):
    print(k, v)
print('total', sum(hits.values()))
