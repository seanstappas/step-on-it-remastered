#!/usr/bin/env python3
"""Remaster the Compete victory animations by AI-upscaling every frame with
Real-ESRGAN, then re-encoding to a higher-resolution Ogg Theora .ogv.

Mirrors the sprite HD pipeline: the SD clips in extracted/movies/ are left intact;
the upscaled clips go to a parallel extracted/movies_hd/ that the Godot front-end
prefers when present (game.gd _win_clip_path). Frames are taken from the LOSSLESS
reassembled QuickTime movie (Apple-Animation 'rle ', not the already-Theora .ogv)
so codec artifacts aren't amplified before the upscale.

Default model: realesr-animevideov3-x4 -- Real-ESRGAN's ANIME VIDEO model, tuned for
temporal consistency (less frame-to-frame flicker than the still-image models). The
clips are 220x164 -> 4x = 880x656, 20 fps, ~4 s, silent.

Usage:  py tools/upscale_win_movies.py [--model NAME] [--scale N] [--qv Q] [--names ...]
Requires: D:\\SOI-tools\\realesrgan\\realesrgan-ncnn-vulkan.exe + ffmpeg.
Output: extracted/movies_hd/<name>.ogv  (+ a before/after preview under media/reference/)
"""
from __future__ import annotations
import argparse, subprocess, sys, tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from extract_win_movies import reassemble, NAMES, ffmpeg  # reuse the split-fork reassembly

REALESRGAN = Path(r"D:\SOI-tools\realesrgan\realesrgan-ncnn-vulkan.exe")
MODELS = Path(r"D:\SOI-tools\realesrgan\models")
OUT = Path("extracted") / "movies_hd"
PREVIEW = Path("media") / "reference" / "win_movies"
FPS = 20


def run(cmd: list[str]) -> None:
    subprocess.run(cmd, check=True)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--model", default="realesr-animevideov3-x4",
                    help="Real-ESRGAN model name (default: the anime-video model)")
    ap.add_argument("--scale", type=int, default=4)
    ap.add_argument("--qv", type=int, default=9, help="libtheora quality 0-10 (default 9)")
    ap.add_argument("--names", nargs="*", default=NAMES, help="which movies to process")
    args = ap.parse_args()
    if not REALESRGAN.exists():
        sys.exit(f"Real-ESRGAN not found: {REALESRGAN}")
    ff = ffmpeg()
    OUT.mkdir(parents=True, exist_ok=True)
    PREVIEW.mkdir(parents=True, exist_ok=True)
    for name in args.names:
        stem = name.replace(" ", "_")
        with tempfile.TemporaryDirectory() as tds:
            td = Path(tds)
            mov = td / "src.mov"
            mov.write_bytes(reassemble(name))
            fin = td / "in"; fin.mkdir()
            fout = td / "out"; fout.mkdir()
            # 1) extract every frame from the lossless source
            run([ff, "-hide_banner", "-loglevel", "error", "-y", "-i", str(mov),
                 "-start_number", "0", str(fin / "f%04d.png")])
            n = len(list(fin.glob("*.png")))
            # 2) AI-upscale the whole frame directory in one pass
            run([str(REALESRGAN), "-i", str(fin), "-o", str(fout),
                 "-n", args.model, "-s", str(args.scale), "-m", str(MODELS), "-f", "png"])
            # 3) re-encode the upscaled frames to a higher-res .ogv
            ogv = OUT / (stem + ".ogv")
            run([ff, "-hide_banner", "-loglevel", "error", "-y", "-framerate", str(FPS),
                 "-start_number", "0", "-i", str(fout / "f%04d.png"),
                 "-c:v", "libtheora", "-q:v", str(args.qv), "-r", str(FPS), "-an", str(ogv)])
            # 4) a before/after preview (mid frame, SD nearest-scaled next to the HD frame)
            mid = max(0, n // 2)
            prev = PREVIEW / (stem + "_hd_compare.png")
            run([ff, "-hide_banner", "-loglevel", "error", "-y",
                 "-i", str(fin / f"f{mid:04d}.png"), "-i", str(fout / f"f{mid:04d}.png"),
                 "-filter_complex",
                 f"[0:v]scale={220*args.scale}:{164*args.scale}:flags=neighbor[a];[a][1:v]hstack",
                 "-frames:v", "1", str(prev)])
            print(f"  {name:12} {n} frames -> {ogv.as_posix()} "
                  f"({ogv.stat().st_size/1024:.0f} KB, {220*args.scale}x{164*args.scale})")
    print(f"done ({args.model} x{args.scale}). game.gd prefers extracted/movies_hd/ when present.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
