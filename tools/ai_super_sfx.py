#!/usr/bin/env python3
r"""AI super-resolution of the Step On It SFX (AudioSR) -> dithered 16-bit / 48 kHz.

Runs under the ISOLATED venv (torch+cu121, audiosr 0.0.7):
    D:\SOI-tools\audiosr-venv\Scripts\python.exe tools/ai_super_sfx.py [opts]

For each faithful 8-bit ~11 kHz source WAV it runs AudioSR (diffusion audio
super-resolution to 48 kHz, which SYNTHESIZES plausible high-frequency detail),
trims the result back to the original length, peak-normalizes to -1 dBFS, and
writes a *dithered 16-bit* 48 kHz WAV with the SAME filename to
extracted/audio/wav_ai/ (the Godot loader maps by the "<sndid>_" prefix).

Why 16-bit and not 32-bit float: Godot's AudioStreamWAV has no float format and
mixes 16-bit regardless, so 16-bit PCM is the fidelity ceiling -- the AI win is the
super-resolution (added bandwidth), not the storage bit depth. ffmpeg performs the
float->16-bit reduction with triangular dithering and writes a canonical header, so
these load through audio.gd's existing 16-bit path (no reliance on the float branch).

This is the "ai" SFX variant (extracted/audio/wav_ai); the "light" faithful clean-up
(extracted/audio/wav_hd) and the original 8-bit set are left untouched for A/B.

IMPORTANT -- this is the RAW render. AudioSR can over-synthesize high frequencies
(an audible "static" wash above the source's real Nyquist), so tame it to a faithful
budget as a second step (fast, no GPU) and verify objectively:
    py tools/enhance_sfx.py tame --src extracted/audio/wav --in <raw_dir> \
        --dst extracted/audio/wav_ai --max-invent 2.0
    py tools/enhance_sfx.py faithfulness --target extracted/audio/wav_ai --max-invent 2.0
"""
import os
import sys

# Redirect every model cache + temp dir to D: BEFORE importing torch/audiosr:
# C: is nearly full and HuggingFace/torch otherwise cache under C:\Users\...\.cache.
_D = r"D:\SOI-tools"
os.environ.setdefault("HF_HOME", _D + r"\hf_cache")
os.environ.setdefault("HF_HUB_CACHE", _D + r"\hf_cache\hub")
os.environ.setdefault("TRANSFORMERS_CACHE", _D + r"\hf_cache\transformers")
os.environ.setdefault("TORCH_HOME", _D + r"\torch_cache")
os.environ.setdefault("TMP", _D + r"\tmp")
os.environ.setdefault("TEMP", _D + r"\tmp")
os.environ.setdefault("HF_HUB_DISABLE_SYMLINKS_WARNING", "1")
for _p in (os.environ["HF_HOME"], os.environ["HF_HUB_CACHE"],
           os.environ["TRANSFORMERS_CACHE"], os.environ["TORCH_HOME"], os.environ["TMP"]):
    os.makedirs(_p, exist_ok=True)

import argparse
import subprocess
from pathlib import Path

import numpy as np
import soundfile as sf

REPO = Path(__file__).resolve().parent.parent
SRC = REPO / "extracted" / "audio" / "wav"
DST = REPO / "extracted" / "audio" / "wav_ai"
FFMPEG = os.environ.get("SOI_FFMPEG", r"D:\Program Files\Tools\ffmpeg.exe")
OUT_RATE = 48000
CEILING_DB = -1.0


def to_mono_1d(wav) -> np.ndarray:
    """AudioSR returns (batch, 1, N); squeeze to a 1-D mono float32 signal."""
    a = np.squeeze(np.asarray(wav, dtype=np.float32))
    if a.ndim > 1:
        a = a[0] if a.shape[0] <= a.shape[-1] else a[:, 0]
    return np.ascontiguousarray(a, dtype=np.float32)


def super_res_retry(super_resolution, model, src, seed, guidance, ddim, work_dir):
    """Run AudioSR; on its off-by-one latent-frame error ("sizes of tensors must
    match") for certain input lengths, retry once on a silence-padded copy. The
    padded tail is trimmed back off by the caller, so length is unaffected."""
    try:
        return super_resolution(model, src, seed=seed, guidance_scale=guidance, ddim_steps=ddim)
    except RuntimeError as e:
        if "match" not in str(e).lower() and "size" not in str(e).lower():
            raise
        y0, sr0 = sf.read(src)
        y0 = np.asarray(y0)
        pad = np.zeros((int(0.25 * sr0),) + y0.shape[1:], dtype=y0.dtype)
        pad_tmp = Path(work_dir) / (Path(src).stem + ".pad.wav")
        sf.write(str(pad_tmp), np.concatenate([y0, pad], axis=0), sr0)
        try:
            return super_resolution(model, str(pad_tmp), seed=seed,
                                    guidance_scale=guidance, ddim_steps=ddim)
        finally:
            pad_tmp.unlink(missing_ok=True)


def main(argv) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", default=str(SRC))
    ap.add_argument("--dst", default=str(DST))
    ap.add_argument("--ddim-steps", type=int, default=50, help="diffusion steps (more=slower/finer)")
    ap.add_argument("--guidance", type=float, default=3.5, help="classifier-free guidance scale")
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--limit", type=int, default=0, help="process only the first N files")
    ap.add_argument("--only", nargs="*", default=None, help="process only these filenames/stems")
    ap.add_argument("--device", default="auto", choices=["auto", "cuda", "cpu"])
    a = ap.parse_args(argv)

    src_dir, dst_dir = Path(a.src), Path(a.dst)
    dst_dir.mkdir(parents=True, exist_ok=True)
    files = sorted(src_dir.glob("*.wav"))
    if a.only:
        want = {n.lower() for n in a.only}
        files = [f for f in files if f.name.lower() in want or f.stem.lower() in want]
    if a.limit > 0:
        files = files[:a.limit]
    if not files:
        print("no input files", file=sys.stderr)
        return 2

    print(f"AudioSR: {len(files)} file(s) -> {dst_dir}")
    print(f"  ddim_steps={a.ddim_steps} guidance={a.guidance} seed={a.seed}  out=16-bit/{OUT_RATE}Hz dithered")

    import torch
    from audiosr import build_model, super_resolution

    dev = a.device
    if dev == "auto":
        dev = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"  device={dev}; building model (first run downloads the checkpoint to {os.environ['HF_HOME']}) ...")
    model = build_model(model_name="basic", device=dev)

    tgt = 10.0 ** (CEILING_DB / 20.0)
    ok = 0
    for i, f in enumerate(files, 1):
        try:
            src_y, src_sr = sf.read(str(f))
            src_y = np.asarray(src_y, dtype=np.float64)
            dur = src_y.shape[0] / float(src_sr)
            src_peak = float(np.max(np.abs(src_y))) if src_y.size else 0.0
            wav = super_res_retry(super_resolution, model, str(f),
                                  a.seed, a.guidance, a.ddim_steps, dst_dir)
            y = to_mono_1d(wav)
            n = int(round(dur * OUT_RATE))
            if 0 < n <= y.size:                 # trim padded tail back to original length
                y = y[:n]
            # Level-match to the SOURCE peak, capped at the -1 dBFS ceiling, so the AI set
            # sits at the same loudness as the original/light sets. (AudioSR otherwise
            # normalizes everything to ~-6 dBFS, which biases A/B and unbalances in-game.)
            target = min(tgt, src_peak) if src_peak > 0 else tgt
            ai_peak = float(np.max(np.abs(y))) if y.size else 0.0
            if ai_peak > 0 and target > 0:
                y = y * (target / ai_peak)
            tmp = dst_dir / (f.stem + ".tmp.f32.wav")
            sf.write(str(tmp), y, OUT_RATE, subtype="FLOAT")
            out = dst_dir / f.name
            cmd = [FFMPEG, "-hide_banner", "-nostats", "-y", "-i", str(tmp),
                   "-ac", "1", "-ar", str(OUT_RATE), "-c:a", "pcm_s16le",
                   "-dither_method", "triangular", "-bitexact", "-map_metadata", "-1", str(out)]
            r = subprocess.run(cmd, capture_output=True, text=True)
            tmp.unlink(missing_ok=True)
            if r.returncode != 0 or not out.exists():
                tail = r.stderr.strip().splitlines()[-1:] if r.stderr else ""
                print(f"  [ERR] {f.name}: ffmpeg {tail}")
                continue
            ok += 1
            tdb = 20.0 * np.log10(max(target, 1e-9))
            print(f"  [{i}/{len(files)}] OK  {f.name:<34} {dur:5.2f}s  -> peak {tdb:+5.1f} dBFS")
        except Exception as e:  # noqa: BLE001 - one bad file shouldn't kill the batch (fallback covers it)
            print(f"  [ERR] {f.name}: {e}")
    print(f"\ndone: {ok}/{len(files)} written to {dst_dir}")
    print("NOTE: this is the RAW AI render. Tame the HF wash to a faithful budget with:")
    print("  py tools/enhance_sfx.py tame --src extracted/audio/wav --in <raw_dir> "
          "--dst extracted/audio/wav_ai --max-invent 2.0")
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
