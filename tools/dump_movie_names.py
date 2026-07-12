#!/usr/bin/env python3
"""One-off: extract the QuickTime movie-name Pascal strings that the music
selector FUN_10018414 / FUN_1001913c reference at r2-relative addresses, so we
can map each music selector (1-6) to a real movie file name.

The names live in the PEF data section near 0x10034ac0..0x10034b30 (the folder
prefix is at 0x10034b24). We unpack the PEF sections and read Pascal strings.
"""
import struct

d = open("bin/core_pef.bin", "rb").read()
sec_count = struct.unpack_from(">H", d, 32)[0]
secs = []
for i in range(sec_count):
    o = 40 + i * 28
    na, da, total, unpacked, packed, coff, kind = struct.unpack_from(">iIIIIIB", d, o)
    secs.append(dict(idx=i, na=na, da=da, total=total, unpacked=unpacked,
                     packed=packed, coff=coff, kind=kind))


def unpack_pef(packed: bytes, unpacked_size: int) -> bytes:
    out = bytearray(); i = 0

    def rc():
        nonlocal i
        c = 0
        while True:
            b = packed[i]; i += 1
            c = (c << 7) | (b & 0x7f)
            if not (b & 0x80):
                break
        return c

    while len(out) < unpacked_size and i < len(packed):
        b = packed[i]; i += 1
        op = b >> 5; cnt = b & 0x1f
        if cnt == 0:
            cnt = rc()
        if op == 0:
            out += b"\x00" * cnt
        elif op == 1:
            out += packed[i:i + cnt]; i += cnt
        elif op == 2:
            rpt = rc(); blk = packed[i:i + cnt]; i += cnt
            out += blk * (rpt + 1)
        elif op == 3:
            cs = rc(); rpt = rc(); common = packed[i:i + cnt]; i += cnt
            for _ in range(rpt):
                out += common; out += packed[i:i + cs]; i += cs
            out += common
        elif op == 4:
            cs = rc(); rpt = rc()
            for _ in range(rpt):
                out += b"\x00" * cnt; out += packed[i:i + cs]; i += cs
            out += b"\x00" * cnt
        else:
            break
    return bytes(out)


# The PEF section 'default address' fields are 0 here; Ghidra imported the image
# flat with code @ 0x10000000. The pattern-initialized DATA section's true vaddr
# base is 0x100337f0 (== pef_tables.py DBASE; cross-checked: r2+0x6840=player base
# 0x1003a9b0 => r2=0x10034170, and 6lilt @ r2+0x950 = 0x10034ac0 lands correctly).
SECTION_BASE = {0: 0x10000000, 1: 0x100337f0}

# Build a flat vaddr->byte image per section. Field order in the section header:
# name(i), defaultAddr(I), totalSize(I), unpackedSize(I), packedSize(I),
# containerOffset(I), kind(B).
images = []  # (base, bytes)
for s in secs:
    packed_bytes = d[s["coff"]:s["coff"] + s["packed"]]
    if s["kind"] in (2, 3):          # pattern-initialized / loader -> unpack
        img = unpack_pef(packed_bytes, s["unpacked"] or s["total"])
    else:                             # code / const / unpacked data -> raw
        img = packed_bytes
    base = SECTION_BASE.get(s["idx"], s["da"])
    images.append((base, img, s["kind"]))
    print("sec %d kind %d base 0x%08x total 0x%x img %d" %
          (s["idx"], s["kind"], base, s["total"], len(img)))


def read_at(vaddr, n):
    for base, img, kind in images:
        if base <= vaddr < base + len(img):
            off = vaddr - base
            return img[off:off + n]
    return b""


def pstr(vaddr):
    b = read_at(vaddr, 1)
    if not b:
        return None
    ln = b[0]
    s = read_at(vaddr + 1, ln)
    return s


# The r2-relative offsets from FUN_10018414 (r2 base resolved below). We try a
# couple of TOC bases and pick the one that yields printable Pascal strings.
SEL_OFF = {
    "1_full": 0x950, "1_thin": 0x956, "2_full": 0x961, "2_thin": 0x968,
    "3_full": 0x974, "3_thin": 0x983, "4_full": 0x997, "4_thin": 0x99e,
    "6_full": 0x9aa,
}

# Scan the DATA section image for the known movie-name substrings and report the
# absolute vaddr of each Pascal string (length byte + ascii). Then derive r2 from
# the selector offsets.
DATA_BASE, DATA_IMG = None, None
for base, img, kind in images:
    if kind == 2:
        DATA_BASE, DATA_IMG = base, img

NEEDLES = [b"6lilt", b"spooky", b"Cminor", b"Angel Pie", b"bass for lunch",
           b"thin", b"blue wins", b"green wins", b"no winner", b"Movies"]
print("\n--- movie-name string hits in data section (base 0x%08x) ---" % DATA_BASE)
found = {}
for nd in NEEDLES:
    start = 0
    while True:
        j = DATA_IMG.find(nd, start)
        if j < 0:
            break
        # walk back to a plausible Pascal length byte
        vaddr = DATA_BASE + j
        # print the full pascal string if the preceding byte is a length
        lb = DATA_IMG[j - 1] if j > 0 else 0
        pre = DATA_IMG[max(0, j - 1):j + 40]
        print("  %-16s @0x%08x  ctx=%r" % (nd.decode(), vaddr, pre))
        found.setdefault(nd, []).append(vaddr)
        start = j + 1

# Derive r2: the '1_full' string is at r2+0x950. If 6lilt is the first track,
# r2 = (addr of 6lilt pascal-length byte) - 0x950.
if b"6lilt" in found:
    cand = found[b"6lilt"][0] - 1  # length byte precedes ascii
    r2 = cand - 0x950
    print("\n=== derived r2 = 0x%08x (from 6lilt @ 0x%08x) ===" % (r2, cand))
    for name, off in SEL_OFF.items():
        s = pstr(r2 + off)
        txt = s.decode("mac-roman", "replace") if s is not None else None
        print("  %-7s r2+0x%03x = 0x%08x : %r" % (name, off, r2 + off, txt))

# ---- spooky (selector 4) trigger: FUN_10017a70 sets DAT_1003ad0e=1 iff a live
# enemy's category DAT_10034a70[enemy.type] equals sRam10034a8c or sRam10034a8a.
import struct as _st


def rd_i16(vaddr):
    b = read_at(vaddr, 2)
    return _st.unpack(">h", b)[0] if len(b) == 2 else None


print("\n--- spooky trigger (FUN_10017a70) ---")
trig_a = rd_i16(0x10034a8a)
trig_c = rd_i16(0x10034a8c)
print("  sRam10034a8a =", trig_a, "   sRam10034a8c =", trig_c)
print("  DAT_10034a70 enemy-type -> category (index = enemy +0x4a type byte):")
cats = []
for t in range(0, 32):
    v = rd_i16(0x10034a70 + t * 2)
    cats.append(v)
    mark = ""
    if v == trig_a or v == trig_c:
        mark = "  <== SPOOKY TRIGGER"
    print("    type %2d -> cat %s%s" % (t, v, mark))
