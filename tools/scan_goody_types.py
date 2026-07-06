"""One-shot audit: which goody/special TYPES actually appear on boards, and are
they handled by soi_pickup_check? Cross-references board data against the pickup
switch to find missing-feature gaps. Not part of the gate."""
import struct, glob, os
from collections import defaultdict


def parse(path):
    b = open(path, 'rb').read()
    cells = []
    off = 0x18
    while off + 4 <= len(b):
        t = struct.unpack_from('>I', b, off)[0]
        off += 4
        if t == 0:
            break
        while off + 2 <= len(b):
            a, c = b[off], b[off + 1]
            off += 2
            if a == 100 or c == 100:
                break
            cells.append(t)
    return cells


goody = defaultdict(set)
special = defaultdict(set)
for p in sorted(glob.glob('extracted/levels/board_*.bord')):
    nm = os.path.basename(p)
    for t in parse(p):
        if (t & 0xF00) == 0x900:        # 0x9xx goody/door/key class
            goody[t & 0xFF].add(nm)
        if t & 0x1000:                  # SPECIAL: hidden payload in bits 16+
            special[(t >> 16) & 0xFF].add(nm)

handled = ({0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B,
            0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19}
           | set(range(0x1A, 0x24)) | set(range(0x24, 0x2E))
           | {0x2E, 0x2F, 0x30, 0x31, 0x32})


def show(title, d):
    print('=== ' + title + ' ===')
    for k in sorted(d):
        tag = 'HANDLED' if k in handled else '*** UNHANDLED ***'
        sample = '' if k in handled else '   e.g. ' + ', '.join(sorted(d[k])[:4])
        print('  0x%02X: %3d boards   %s%s' % (k, len(d[k]), tag, sample))


show('0x9xx goody-class low bytes', goody)
show('SPECIAL hidden-payload low bytes', special)
