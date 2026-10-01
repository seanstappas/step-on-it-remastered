"""Build board_sounds.bord: a test board holding every sound-making element.

    py tools/verify_scripts/mk_sound_board.py [out.bord]

Four lanes, walked top to bottom (P1 starts top-left):
  A (row 2)  jump twice under the block overhead (crack/break), plain key, coins, gem, bars,
             2x, 1UP, ammo, shoes, magnifier -> drop through the gap at the right end
  B (row 5)  turtles, Stop/Go switch, coloured key, Robo punching a block -> drop at the left end
  C (row 8)  time bonus, ammo, Walker (shoots), Beanie (buds), Cannon firing along row 7,
             transporter at the right end
  D (row 11) potion, one spawner per small nasty, a slow Wheelie, ammo, time bonus,
             thunderballs, then the door (opened by the lane-B key)
Bonus starts at 1600, so the hurry-up plays after a while.
"""
import struct
import sys
from pathlib import Path

WALL = 0x0307       # permanent white block
BREAK = 0x0207      # breakable block

recs = []


def rec(tile, *cells):
    recs.append((tile, cells))


def enemy(start_delay, spawn_delay, dir_bits, bord_type):
    # dir_bits: 1 = left, 2 = right, 3 = alternate (byte 2 also carries the 0x04 spawn marker)
    return (start_delay << 24) | (spawn_delay << 16) | ((0x04 | dir_bits) << 8) | bord_type


rec(WALL, *[(c, r) for c in (0, 18) for r in range(13)])
rec(WALL, *[(c, 3) for c in range(1, 16)])      # lane A floor, gap at 16-17
rec(WALL, *[(c, 6) for c in range(3, 18)])      # lane B floor, gap at 1-2
rec(WALL, *[(c, 9) for c in range(1, 18)])      # lane C floor
rec(WALL, *[(c, 12) for c in range(1, 18)])     # lane D floor
rec(BREAK, (2, 1), (5, 5), (4, 7))              # head-bonk block, Robo's block, Cannon's target

# lane A
for tile, col in [(0x090B, 3), (0x090A, 4), (0x0917, 5), (0x0918, 6), (0x0919, 7), (0x090C, 8),
                  (0x0910, 9), (0x0911, 10), (0x0911, 11), (0x0912, 12), (0x0912, 13),
                  (0x0932, 14), (0x092F, 15)]:
    rec(tile, (col, 2))

# lane B
rec(0x092E, (15, 5))                            # turtles
rec(0x0924, (13, 5))                            # Stop/Go switch (pair 0)
rec(0x039D, (13, 4))                            # its Stop block
rec(0x0907, (11, 5))                            # universal coloured key
rec(0x0912, (4, 5), (3, 5))
rec(enemy(20, 10, 1, 15), (8, 5))               # Robo, heading left at the block

# lane C
rec(0x0913, (3, 8))                             # time +2500
rec(0x0911, (4, 8))
rec(0x0912, (5, 8))
rec(enemy(20, 10, 1, 4), (10, 8))               # Walker
rec(enemy(20, 10, 2, 7), (12, 7))               # Beanie
rec(enemy(40, 10, 1, 1), (17, 7))               # Cannon, firing left along row 7
rec(0x091A, (17, 8))                            # transporter IN -> OUT in lane D

# lane D
rec(0x091B, (1, 11))                            # transporter OUT
rec(0x0930, (2, 11))                            # potion (shield)
for i, (col, t) in enumerate([(3, 12), (5, 18), (7, 5), (9, 19), (11, 11), (13, 10), (15, 6)]):
    rec(enemy(120, 5 + 10 * i, 3, t), (col, 11))   # ant, ostrich, hippo, piggy, smiley, teeth, hammer
rec(enemy(20, 10, 2, 3), (9, 10))               # slow Wheelie
rec(0x0914, (4, 11))                            # time +5000
rec(0x0912, (6, 11), (10, 11))
rec(0x0911, (8, 11), (12, 11))
rec(0x0931, (16, 11))                           # thunderballs
rec(0x0904, (17, 11))                           # lock -> door once the key is taken

out = bytearray(struct.pack(">12H", 0, 0x026D, 0x0273, 2, 2, 1, 2, 1600, 0, 0, 0, 0))
for tile, cells in recs:
    out += struct.pack(">I", tile)
    for c, r in cells:
        out += bytes((c, r))
    out += b"\x64\x64"
out += b"\0\0\0\0"

path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("board_sounds.bord")
path.write_bytes(out)
print(f"wrote {path} ({len(out)} bytes)")
