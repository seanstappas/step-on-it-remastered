import io
import sys
from pathlib import Path

# Add repo root to sys.path
sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from tools.ascii2bord import (
    pack_ext1,
    unpack_ext1,
    ENEMY_NAMES,
    decompile_bord,
    compile_bord_from_ascii,
)

def test_has_p3_tristate():
    # Explicit False with coordinates must NOT set bit 0
    raw_false = pack_ext1(has_p3=False, p3_col=5, p3_row=5)
    unpacked_false = unpack_ext1(raw_false)
    assert not unpacked_false["has_p3"], "has_p3=False should clear bit 0 even with coordinates"

    # None with coordinates must infer and set bit 0
    raw_none = pack_ext1(has_p3=None, p3_col=5, p3_row=5)
    unpacked_none = unpack_ext1(raw_none)
    assert unpacked_none["has_p3"], "has_p3=None with coordinates should infer True"

    # None without coordinates must be False
    raw_none_no_coords = pack_ext1(has_p3=None, p3_col=0, p3_row=0)
    unpacked_none_no_coords = unpack_ext1(raw_none_no_coords)
    assert not unpacked_none_no_coords["has_p3"], "has_p3=None without coords should be False"

def test_enemy_names():
    expected = {
        1: "CANNON",
        2: "WHEELIE",
        3: "WHEELIE_SLOW",
        4: "WALKER",
        5: "HIPPO",
        6: "HAMMER",
        7: "BEANIE_H",
        8: "BEANIE_V",
        9: "SPINNER",
        10: "TEETH",
        11: "SMILEY",
        12: "ANT",
        13: "KNIGHT",
        14: "GARGOYLE",
        15: "ROBO",
        16: "CREEPER_H",
        17: "CREEPER_V",
        18: "OSTRICH",
        19: "PIGGY",
    }
    for k, v in expected.items():
        assert ENEMY_NAMES.get(k) == v, f"ENEMY_NAMES[{k}] expected {v}, got {ENEMY_NAMES.get(k)}"

def test_padded_ext1_roundtrip():
    # Build a minimal valid bord with an EXT1 trailer and 2 bytes of padding before EXT1
    # 24-byte header
    hdr = bytes(24)
    # record: tile (4 bytes) + c,r (2 bytes) + 100,100 (2 bytes)
    rec = b"\x00\x00\x02\x01\x02\x02\x64\x64"
    term = b"\x00\x00\x00\x00"
    pad = b"\x00\x00"
    ext1_bytes = pack_ext1(grid_cols=19, grid_rows=13)

    synth_bord = hdr + rec + term + pad + ext1_bytes

    # Run decompile and recompile
    txt = decompile_bord(synth_bord)
    recompiled = compile_bord_from_ascii(txt)

    # Simulate TOOL-02 logic
    orig = synth_bord
    orig_clean = orig
    if len(orig) == len(recompiled) + 2 and orig[-24:-20] == b"EXT1" and orig[-26:-24] == b"\x00\x00":
        orig_clean = orig[:-26] + orig[-24:]
    elif len(orig) == len(recompiled) + 2 and orig[-6:-2] == b"\x00\x00\x00\x00":
        orig_clean = orig[:-2]

    assert orig_clean == recompiled, "Synthetic padded EXT1 board must match recompiled data"

if __name__ == "__main__":
    test_has_p3_tristate()
    test_enemy_names()
    test_padded_ext1_roundtrip()
    print("test_ascii2bord: ALL ASSERTS PASSED")
