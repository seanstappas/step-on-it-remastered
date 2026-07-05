#!/usr/bin/env python3
"""Unpack the PEF pattern-initialized data section and read the player-animation
frame-index lookup tables (addresses from the decompiled render dispatch)."""
import struct

d = open("bin/core_pef.bin", "rb").read()
sec_count = struct.unpack_from(">H", d, 32)[0]
secs = []
for i in range(sec_count):
    o = 40 + i * 28
    na, da, total, unpacked, packed, coff, kind = struct.unpack_from(">iIIIIIB", d, o)
    secs.append((kind, da, total, unpacked, packed, coff))

code = secs[0]
data = secs[1]                      # kind 2 = pattern-initialized data
packed = d[data[5]:data[5] + data[4]]


def unpack_pef(packed: bytes, unpacked_size: int) -> bytes:
    out = bytearray()
    i = 0

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
        op = b >> 5
        cnt = b & 0x1f
        if cnt == 0:
            cnt = rc()
        if op == 0:                     # zero
            out += b"\x00" * cnt
        elif op == 1:                   # block copy
            out += packed[i:i + cnt]; i += cnt
        elif op == 2:                   # repeat block
            rpt = rc()
            blk = packed[i:i + cnt]; i += cnt
            out += blk * (rpt + 1)
        elif op == 3:                   # interleave repeat common + custom
            cs = rc(); rpt = rc()
            common = packed[i:i + cnt]; i += cnt
            for _ in range(rpt):
                out += common
                out += packed[i:i + cs]; i += cs
            out += common
        elif op == 4:                   # interleave repeat zero + custom
            cs = rc(); rpt = rc()
            for _ in range(rpt):
                out += b"\x00" * cnt
                out += packed[i:i + cs]; i += cs
            out += b"\x00" * cnt
        else:
            break
    return bytes(out)


udata = unpack_pef(packed, data[3])
print("unpacked data bytes:", len(udata), "(target", hex(data[3]), ")")

# Ghidra placed code at 0x10000000 (size 0x337f0); data section base rounds up to
# 0x10034000. Try that, and auto-scan if the values look wrong.
for DBASE in (0x10034000, 0x100337f0, 0x10033800):
    def tbl(va, n):
        o = va - DBASE
        if o < 0 or o + n * 2 > len(udata):
            return None
        return [struct.unpack_from(">H", udata, o + i * 2)[0] for i in range(n)]
    t = tbl(0x100346ac, 40)
    print("\nDBASE", hex(DBASE), "@0x100346ac:", t)
    print("  snd @0x10037074:", tbl(0x10037074, 56))
    print("  snd2@0x10034a00:", tbl(0x10034a00, 4))
