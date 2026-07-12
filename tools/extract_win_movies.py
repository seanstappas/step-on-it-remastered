#!/usr/bin/env python3
"""Extract the three Compete-mode VICTORY ANIMATIONS from the original game.

`blue wins`, `green wins`, `no winner` (raw_game/Step On It!/Step On It!  Movies/)
are QuickTime movies played to completion on the 2-player results screen (asm
FUN_10014d70 -> FUN_10018e88 -> the transient movie slot _DAT_10039050). Unlike the
9 background tunes they carry NO `musi` music track and NO sound at all -- each is a
single Apple-Animation (`rle `) VIDEO track (220x164, 20fps, ~4s): the winning boy
poses while the loser tumbles into the pit (or a "No One!" sign for a tie).

Classic-Mac movies split their storage: the `mdat` sample data lives in the file's
DATA fork, the `moov` (structure) in the resource fork's AppleDouble (`._<name>`).
We stitch them back into a self-contained .mov (mdat first, its size patched to the
real length so the appended moov is found), then transcode to Ogg Theora .ogv --
which Godot 4.3 plays natively via VideoStreamPlayer.

Usage:  py tools/extract_win_movies.py
Output: extracted/movies/<name>.ogv  (+ a montage preview under media/reference/)
"""
from __future__ import annotations
import struct, subprocess, sys, shutil, tempfile
from pathlib import Path

MOVIES = Path("raw_game") / "Step On It\u2122" / "Step On It!  Movies"
RESFK = Path("raw_game") / "Step On It\u2122" / "__MACOSX" / "Step On It!  Movies"
OUT = Path("extracted") / "movies"
PREVIEW = Path("media") / "reference" / "win_movies"
NAMES = ["blue wins", "green wins", "no winner"]


def ffmpeg() -> str:
    for c in ("ffmpeg", r"D:\Program Files\Tools\ffmpeg.exe"):
        if shutil.which(c) or Path(c).exists():
            return c
    sys.exit("ffmpeg not found")


def reassemble(name: str) -> bytes:
    """Stitch the split-fork QuickTime movie into a self-contained .mov."""
    data = bytearray((MOVIES / name).read_bytes())
    res = (RESFK / ("._" + name)).read_bytes()
    if data[4:8] != b"mdat":
        raise ValueError(f"{name}: data fork does not start with an mdat atom")
    # The stored mdat size is 0 ("to EOF"); set it to the real length so a reader
    # knows where mdat ends and the appended moov begins. stco offsets are absolute
    # from the data-fork start (first chunk @ 8, right after the mdat header), so the
    # mdat MUST stay at file offset 0.
    struct.pack_into(">I", data, 0, len(data))
    mo = res.find(b"moov") - 4
    if mo < 0:
        raise ValueError(f"{name}: no moov atom in the resource fork")
    moov = res[mo:mo + struct.unpack_from(">I", res, mo)[0]]
    return bytes(data) + moov


def main() -> int:
    ff = ffmpeg()
    OUT.mkdir(parents=True, exist_ok=True)
    PREVIEW.mkdir(parents=True, exist_ok=True)
    for name in NAMES:
        stem = name.replace(" ", "_")
        mov = reassemble(name)
        with tempfile.NamedTemporaryFile(suffix=".mov", delete=False) as tf:
            tf.write(mov)
            tmp = tf.name
        ogv = OUT / (stem + ".ogv")
        subprocess.run([ff, "-hide_banner", "-loglevel", "error", "-y", "-i", tmp,
                        "-c:v", "libtheora", "-q:v", "8", "-an", str(ogv)], check=True)
        # a filmstrip preview (every 10th frame) for the repo record
        strip = PREVIEW / (stem + "_strip.png")
        subprocess.run([ff, "-hide_banner", "-loglevel", "error", "-y", "-i", tmp,
                        "-vf", "select='not(mod(n,10))',scale=220:164:flags=neighbor,tile=9x1",
                        "-frames:v", "1", str(strip)], check=True)
        Path(tmp).unlink(missing_ok=True)
        kb = ogv.stat().st_size / 1024
        print(f"  {name:12} -> {ogv.as_posix()} ({kb:.0f} KB)  preview {strip.as_posix()}")
    print("done:", ", ".join(n.replace(' ', '_') + '.ogv' for n in NAMES))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
