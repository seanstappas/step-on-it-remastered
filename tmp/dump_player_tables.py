"""Scratch: dump the player bonk / turn / stop / reverse frame tables from the PEF data section."""
import runpy
import struct

ns = runpy.run_path("tools/dump_pose_tables.py", run_name="dump_pose_tables_lib")
tbl_u = ns["tbl_u"]
print("bonk RIGHT u16[0x10034724 + i*2] i=0..9:", tbl_u(0x10034724, 10))
print("bonk LEFT  u16[0x10034738 + i*2] i=0..9:", tbl_u(0x10034738, 10))
print("low-block RIGHT (mode 4) u16[0x10034708 + i*2]:", tbl_u(0x10034708, 7))
print("low-block LEFT  (mode 2) u16[0x10034716 + i*2]:", tbl_u(0x10034716, 7))
print("stop target u16[0x10034840 + f*2] f=0..0x40:", tbl_u(0x10034840, 0x41))
print("reverse u16[0x1003477c + f*2] f=0..0x40:", tbl_u(0x1003477c, 0x41))
raw = tbl_u(0x1003477e - 0x30 * 0 + 0, 1)
print("reverse-save u16[0x1003477e + (f+0x30)*2]? f=0..0x40:", tbl_u(0x1003477e + 0x30 * 2, 0x41))
