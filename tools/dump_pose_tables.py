#!/usr/bin/env python3
"""Recover the player ACTION-POSE frame tables from the PEF data section.

asm FUN_1001166c advances the fire/build pose display frame (+0x0e) from lookup
tables indexed by the action step (+0x2c, 0..6):
  * mode-3 path:  frame = u16[DAT_100346ac + (step + 0x20)]
  * mode-1 path:  frame = u16[DAT_100346fa + step]
The effect at step 5 is keyed on type +0x2e (1=block, 2=arrow, 3=ball). This dump
recovers the concrete frame numbers so the front-end pose frames can be byte-exact.
Reuses the same unpacker + DBASE as tools/dump_jump_table.py.
"""
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
DBASE = 0x100337f0   # verified via the sound table (evt1..4 = 4397,28670,7840,8345)


def tbl_u(va, n):
    o = va - DBASE
    return [struct.unpack_from(">H", udata, o + i * 2)[0] for i in range(n)]


# sanity check the base
print("snd @0x10037074[1..4]:", tbl_u(0x10037074, 5)[1:5], "(expect 4397,28670,7840,8345)")

print("\nraw u16 context 0x100346a0..0x10034720:")
base = 0x100346a0
ctx = tbl_u(base, 0x41)
for i, v in enumerate(ctx):
    va = base + i * 2
    print(f"  0x{va:08x} [+{i:2d}] = {v:5d} (0x{v:04x})")

print("\nmode-3 pose frames  u16[0x100346ac + (step+0x20)]  step 0..6:")
print(" ", tbl_u(0x100346ac + 0x20 * 2, 7))
print("mode-1 pose frames  u16[0x100346fa + step]  step 0..6:")
print(" ", tbl_u(0x100346fa, 7))
