#!/usr/bin/env python3
"""Recover the player JUMP vertical-velocity table DAT_1003474c (asm FUN_10013404:
Y += DAT_1003474c[t], t=0..17) from the compressed PEF data section, plus the
neighbouring fall/gravity constants. Reuses the unpacker from pef_tables.py."""
import struct

d = open("bin/core_pef.bin", "rb").read()
sec_count = struct.unpack_from(">H", d, 32)[0]
secs = []
for i in range(sec_count):
    o = 40 + i * 28
    na, da, total, unpacked, packed, coff, kind = struct.unpack_from(">iIIIIIB", d, o)
    secs.append((kind, da, total, unpacked, packed, coff))
data = secs[1]
packed = d[data[5]:data[5] + data[4]]


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
            rpt = rc(); blk = packed[i:i + cnt]; i += cnt; out += blk * (rpt + 1)
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


udata = unpack_pef(packed, data[3])
print("unpacked data bytes:", len(udata), "(target", hex(data[3]), ")")

DBASE = 0x100337f0   # verified: makes snd@0x10037074 = [0,4397,28670,7840,8345,...]


def tbl_s(va, n):
    o = va - DBASE
    return [struct.unpack_from(">h", udata, o + i * 2)[0] for i in range(n)]


def tbl_u(va, n):
    o = va - DBASE
    return [struct.unpack_from(">H", udata, o + i * 2)[0] for i in range(n)]


# Validate DBASE against the known sound table (evt1..4 = 4397,28670,7840,8345).
print("snd @0x10037074[1..4]:", tbl_u(0x10037074, 5)[1:5], "(expect 4397,28670,7840,8345)")
# The jump velocity LUT: 18 signed shorts at 0x1003474c.
jt = tbl_s(0x1003474c, 18)
print("\nJUMP vel table DAT_1003474c[0..17] (signed):")
print(jt)
print("cumulative dY (screen-space, +down):")
cum = 0
rows = []
for t, v in enumerate(jt):
    cum += v
    rows.append((t, v, cum))
for t, v, c in rows:
    print(f"  t={t:2d}  dv={v:4d}  Y_offset={c:5d}")
print("peak rise (min Y_offset):", min(c for _, _, c in rows))
# A few neighbours in case the table is offset or has a companion (fall step, etc.)
print("\ncontext 0x10034740..0x10034780 (signed shorts):")
print(tbl_s(0x10034740, 32))
