#!/usr/bin/env python3
"""AI-upscale the decoded PICT full-screen art (extracted/pict/*.png) with
Real-ESRGAN into a parallel HD folder that the Godot front-end uses in --hd mode
(game.gd _pict_dir / _pict_scale; main_menu.gd). Mirrors the sprite HD pipeline.

DEFAULT = ONE MODEL FOR ALL: realesrgan-x4plus (the GENERAL model). It renders the
game's crisp serif BODY text cleanly (no cyan fringing / "melted" edges) AND handles
the flat-shaded 3D "squishy" headings + rendered characters well. The anime model
(realesrgan-x4plus-anime) is marginally smoother on pure-3D art but MELTS regular
text, and name-based text/art classification kept mis-tagging text panels (e.g. the
green/blue tally + player score panels) as art -- so one general model is the robust
choice. Pass --split to opt back into the per-page text/art model split, or --model
NAME to force a specific model for everything.

Alpha is preserved (Real-ESRGAN ncnn-vulkan handles RGBA); 0-byte / empty PICTs
are skipped.

Usage:  py tools/upscale_picts.py [--out DIR] [--model NAME] [--split] [--scale N] [--only SUBSTR ...]
Requires: D:\\SOI-tools\\realesrgan\\realesrgan-ncnn-vulkan.exe
Output: <out>/<name>.png   (default out: extracted/pict_hd)
"""
from __future__ import annotations
import argparse, subprocess, sys, shutil, tempfile
from pathlib import Path

REALESRGAN = Path(r"D:\SOI-tools\realesrgan\realesrgan-ncnn-vulkan.exe")
MODELS = Path(r"D:\SOI-tools\realesrgan\models")
SRC = Path("extracted") / "pict"
OUT = Path("extracted") / "pict_hd"

ART_MODEL = "realesrgan-x4plus-anime"   # flat-shaded 3D art + stylised headings (--split only)
TEXT_MODEL = "realesrgan-x4plus"        # general model -> clean regular/body text
DEFAULT_MODEL = "realesrgan-x4plus"     # one-model-for-all default (robust on text AND 3D art)

# PICTs whose legibility depends on crisp REGULAR body text (not just a 3D heading):
# the tip screens 128-143, the About/Help pages, and the two mixed panels that carry
# a real text line (Challenge intro, Winner labels). Matched as a filename prefix.
TEXT_PICTS = tuple([f"{n}_" for n in range(128, 144)] + [
    "300_Challenge_Title", "350_The_Winner", "600_About",
    "700_Help", "701_Help", "702_Help",
])


def is_text_pict(name: str) -> bool:
    return name.startswith(TEXT_PICTS)


def upscale(picts: list[Path], model: str, scale: int, out: Path) -> None:
    """Batch a temp dir of the given files through Real-ESRGAN into `out`."""
    if not picts:
        return
    with tempfile.TemporaryDirectory() as tds:
        tin = Path(tds)
        for p in picts:
            shutil.copy2(p, tin / p.name)
        subprocess.run([str(REALESRGAN), "-i", str(tin), "-o", str(out),
                        "-n", model, "-s", str(scale), "-m", str(MODELS),
                        "-f", "png"], check=True)
    print(f"  {len(picts):2d} PICTs x{scale} ({model})")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default=str(OUT),
                    help="output folder (default: extracted/pict_hd)")
    ap.add_argument("--model", default=None,
                    help="force this ONE model for all PICTs")
    ap.add_argument("--split", action="store_true",
                    help="use the per-page text/art model split instead of one general model")
    ap.add_argument("--scale", type=int, default=4)
    ap.add_argument("--only", nargs="*", default=None,
                    help="only picts whose filename contains one of these substrings")
    args = ap.parse_args()
    if not REALESRGAN.exists():
        sys.exit(f"Real-ESRGAN not found: {REALESRGAN}")
    out = Path(args.out)
    out.mkdir(parents=True, exist_ok=True)
    picts = [p for p in sorted(SRC.glob("*.png")) if p.stat().st_size > 0]
    if args.only:
        picts = [p for p in picts if any(s in p.name for s in args.only)]
    if not picts:
        sys.exit("no PICTs to upscale")
    if args.split and not args.model:    # opt-in per-page text/art split
        text = [p for p in picts if is_text_pict(p.name)]
        art = [p for p in picts if not is_text_pict(p.name)]
        upscale(art, ART_MODEL, args.scale, out)
        upscale(text, TEXT_MODEL, args.scale, out)
    else:                                # default (or --model): one model for everything
        upscale(picts, args.model or DEFAULT_MODEL, args.scale, out)
    n = len(list(out.glob("*.png")))
    print(f"upscaled {len(picts)} PICTs -> {out.as_posix()} ({n} files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
