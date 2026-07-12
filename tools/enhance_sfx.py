#!/usr/bin/env python3
"""Faithful SFX clean-up / upscale for Step On It.

Takes the reverse-engineered 8-bit ~11 kHz SFX in ``extracted/audio/wav`` and
renders clean 16-bit 44.1 kHz versions into a parallel ``extracted/audio/wav_hd``
folder, keeping the EXACT filenames (the Godot loader maps by ``<sndid>`` prefix).

Chain (conservative, deterministic, no hallucinated detail):
    highpass=f=50                       # remove subsonic DC / rumble
    afftdn=nr=<NR>:nf=<NF>              # gentle FFT denoise of 8-bit quant hiss
    aresample=44100:resampler=soxr      # high-quality integer upsample (4x11025)
    volume=<g>dB                        # attenuate-only gain to a -1 dBFS ceiling

Why not AI super-resolution (AudioSR / resemble-enhance)?  Every source tops out
below its ~5.5 kHz Nyquist, so there is no real high-frequency content to recover
- an SR model would *fabricate* detail that never existed.  This path is faithful,
fully reproducible, and needs no GPU / pip install.  AudioSR remains an opt-in
follow-up if a re-imagined (non-faithful) render is wanted.

HARD CONSTRAINT: ``godot_project/scenes/audio.gd`` parses the WAV at runtime and
only understands 8-bit or 16-bit PCM with a canonical header (channels@22,
rate@24, bits@34, ``data`` chunk walked from offset 12).  Output is therefore
canonical 16-bit little-endian PCM (``pcm_s16le`` + ``-bitexact -map_metadata -1``).

Usage:
    py tools/enhance_sfx.py enhance                 # render + auto-verify
    py tools/enhance_sfx.py verify                  # verify an existing render
    py tools/enhance_sfx.py spectrograms            # before/after A/B PNGs

No third-party Python packages; only ffmpeg/ffprobe are required.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path

# --- tool discovery ---------------------------------------------------------
REPO = Path(__file__).resolve().parent.parent
DEFAULT_SRC = REPO / "extracted" / "audio" / "wav"
DEFAULT_DST = REPO / "extracted" / "audio" / "wav_hd"
DEFAULT_SPECTRO = REPO / "media" / "reference" / "sfx_enhance"


def _find_tool(env_var: str, known: str, exe: str) -> str:
    """Resolve a tool path from env override, then a known box path, then PATH."""
    override = os.environ.get(env_var)
    if override and Path(override).exists():
        return override
    if Path(known).exists():
        return known
    return exe  # fall back to PATH resolution


FFMPEG = _find_tool("SOI_FFMPEG", r"D:\Program Files\Tools\ffmpeg.exe", "ffmpeg")
FFPROBE = _find_tool("SOI_FFPROBE", r"D:\Program Files\Tools\ffprobe.exe", "ffprobe")

# --- targets ----------------------------------------------------------------
TARGET_RATE = 44100        # 4 x 11025, a clean integer upsample
TARGET_BITS = 16
TARGET_CHANNELS = 1
VMAX_RE = re.compile(r"max_volume:\s*(-?\d+(?:\.\d+)?)\s*dB")


# --- small helpers ----------------------------------------------------------
def run(cmd: list[str]) -> subprocess.CompletedProcess:
    return subprocess.run(cmd, capture_output=True, text=True)


def build_filter(nr: float, nf: float, highpass: float, denoise: bool) -> str:
    parts = []
    if highpass > 0:
        parts.append(f"highpass=f={highpass:g}")
    if denoise:
        parts.append(f"afftdn=nr={nr:g}:nf={nf:g}")
    parts.append(f"aresample={TARGET_RATE}:resampler=soxr:precision=28")
    return ",".join(parts)


def measure_peak_db(path: Path) -> float:
    """Return the sample peak of *path* in dBFS (-inf-ish for silence)."""
    cp = run([FFMPEG, "-hide_banner", "-nostats", "-i", str(path),
              "-af", "volumedetect", "-f", "null", "-"])
    m = VMAX_RE.search(cp.stderr)
    return float(m.group(1)) if m else -120.0


@dataclass
class Probe:
    rate: int
    channels: int
    bits: int
    codec: str
    duration: float


def probe(path: Path) -> Probe | None:
    cp = run([FFPROBE, "-v", "quiet", "-print_format", "json",
              "-show_streams", "-show_format", str(path)])
    if cp.returncode != 0:
        return None
    try:
        j = json.loads(cp.stdout)
        st = next(s for s in j["streams"] if s.get("codec_type") == "audio")
    except (json.JSONDecodeError, KeyError, StopIteration):
        return None
    dur = 0.0
    for src in (st.get("duration"), j.get("format", {}).get("duration")):
        try:
            dur = float(src)
            break
        except (TypeError, ValueError):
            continue
    bits = st.get("bits_per_sample") or st.get("bits_per_raw_sample") or 0
    return Probe(int(st.get("sample_rate", 0)), int(st.get("channels", 0)),
                 int(bits), st.get("codec_name", "?"), dur)


def godot_header_ok(path: Path) -> tuple[bool, str]:
    """Mirror audio.gd._load_wav's parse: fixed offsets 22/24/34 + data walk."""
    b = path.read_bytes()
    if len(b) < 44 or b[0:4] != b"RIFF" or b[8:12] != b"WAVE":
        return False, "not a RIFF/WAVE file"
    if b[12:16] != b"fmt ":
        return False, "fmt chunk not at offset 12 (godot reads fixed offsets)"
    channels = struct.unpack_from("<H", b, 22)[0]
    rate = struct.unpack_from("<I", b, 24)[0]
    bits = struct.unpack_from("<H", b, 34)[0]
    if channels != TARGET_CHANNELS or rate != TARGET_RATE or bits != TARGET_BITS:
        return False, f"header ch={channels} rate={rate} bits={bits}"
    # walk chunks from o=12 exactly like the loader does
    o = 12
    while o + 8 <= len(b):
        cid = b[o:o + 4]
        csz = struct.unpack_from("<I", b, o + 4)[0]
        if cid == b"data":
            return (csz > 0), ("ok" if csz > 0 else "empty data chunk")
        o += 8 + csz + (csz & 1)
    return False, "no data chunk"


# --- enhance ----------------------------------------------------------------
def enhance_one(src: Path, dst: Path, filt: str, ceiling: float) -> tuple[bool, str]:
    dst.parent.mkdir(parents=True, exist_ok=True)
    common = ["-ac", str(TARGET_CHANNELS), "-ar", str(TARGET_RATE),
              "-c:a", "pcm_s16le", "-bitexact", "-map_metadata", "-1", "-y"]
    # stage 1: full chain -> dst
    cp = run([FFMPEG, "-hide_banner", "-nostats", "-i", str(src),
              "-af", filt, *common, str(dst)])
    if cp.returncode != 0 or not dst.exists():
        return False, f"ffmpeg chain failed: {cp.stderr.strip().splitlines()[-1:]}"
    # stage 2: attenuate-only gain so the peak sits at the ceiling
    peak = measure_peak_db(dst)
    gain = ceiling - peak
    if gain < -0.01:  # only ever reduce; never boost (keeps it faithful)
        tmp = dst.with_suffix(".tmp.wav")
        cp = run([FFMPEG, "-hide_banner", "-nostats", "-i", str(dst),
                  "-af", f"volume={gain:.3f}dB", *common, str(tmp)])
        if cp.returncode != 0 or not tmp.exists():
            tmp.unlink(missing_ok=True)
            return False, "gain pass failed"
        os.replace(tmp, dst)
        return True, f"peak {peak:+.1f}->{ceiling:+.1f} dBFS"
    return True, f"peak {peak:+.1f} dBFS (no gain)"


def cmd_enhance(a: argparse.Namespace) -> int:
    src_dir, dst_dir = Path(a.src), Path(a.dst)
    files = sorted(src_dir.glob("*.wav"))
    if not files:
        print(f"no .wav files in {src_dir}", file=sys.stderr)
        return 2
    filt = build_filter(a.nr, a.nf, a.highpass, not a.no_denoise)
    print(f"enhance: {len(files)} files  {src_dir} -> {dst_dir}")
    print(f"  filter: {filt}")
    print(f"  ceiling: {a.ceiling:+g} dBFS  ->  16-bit / {TARGET_RATE} Hz / mono\n")
    ok = 0
    for f in files:
        good, msg = enhance_one(f, dst_dir / f.name, filt, a.ceiling)
        print(f"  [{'OK ' if good else 'ERR'}] {f.name:<34} {msg}")
        ok += good
    print(f"\nenhanced {ok}/{len(files)} files")
    if ok != len(files):
        return 1
    if a.spectrograms:
        make_spectrograms(files, dst_dir, Path(a.spectro_dir))
    print()
    return cmd_verify(a)


# --- verify -----------------------------------------------------------------
def cmd_verify(a: argparse.Namespace) -> int:
    src_dir, dst_dir = Path(a.src), Path(a.dst)
    files = sorted(src_dir.glob("*.wav"))
    print(f"verify: {dst_dir} against {src_dir}")
    hdr = f"  {'file':<34} {'rate':>6} {'bit':>3} {'ch':>2} {'peak dB':>8} " \
          f"{'dur s':>7} {'d%':>6}  hdr"
    print(hdr)
    print("  " + "-" * (len(hdr) - 2))
    fails: list[str] = []
    for f in files:
        out = dst_dir / f.name
        if not out.exists():
            fails.append(f"{f.name}: missing output")
            print(f"  {f.name:<34} MISSING")
            continue
        p = probe(out)
        sp = probe(f)
        if p is None or sp is None:
            fails.append(f"{f.name}: probe failed")
            continue
        peak = measure_peak_db(out)
        ddelta = (abs(p.duration - sp.duration) / sp.duration * 100.0
                  if sp.duration else 0.0)
        hok, hmsg = godot_header_ok(out)
        probs = []
        if p.rate != TARGET_RATE:
            probs.append(f"rate={p.rate}")
        if p.bits != TARGET_BITS:
            probs.append(f"bits={p.bits}")
        if p.channels != TARGET_CHANNELS:
            probs.append(f"ch={p.channels}")
        if peak > a.ceiling + 0.1:
            probs.append(f"peak={peak:+.1f}")
        if ddelta > max(1.0, 100.0 * 0.02 / max(sp.duration, 0.001)):
            probs.append(f"dur{ddelta:+.1f}%")
        if not hok:
            probs.append(f"hdr:{hmsg}")
        flag = "OK" if not probs else "FAIL"
        print(f"  {f.name:<34} {p.rate:>6} {p.bits:>3} {p.channels:>2} "
              f"{peak:>+8.1f} {p.duration:>7.2f} {ddelta:>+5.1f}%  {flag}")
        if probs:
            fails.append(f"{f.name}: {', '.join(probs)}")
    print()
    if fails:
        print(f"FAIL - {len(fails)} issue(s):")
        for x in fails:
            print(f"  - {x}")
        return 1
    print(f"PASS - all {len(files)} outputs are 16-bit/{TARGET_RATE}Hz/mono, "
          f"peak <= {a.ceiling:+g} dBFS, duration preserved, godot-loadable.")
    return 0


# --- spectrograms -----------------------------------------------------------
def make_spectrograms(files: list[Path], dst_dir: Path, out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    print(f"\nspectrograms -> {out_dir}")
    for f in files:
        out = dst_dir / f.name
        if not out.exists():
            continue
        png = out_dir / (f.stem + "__before_after.png")
        # resample BEFORE to 44100 too so both share a 0..22050 axis (honest A/B)
        fc = (f"[0:a]aresample={TARGET_RATE},showspectrumpic=s=1200x300:legend=1[a];"
              f"[1:a]showspectrumpic=s=1200x300:legend=1[b];[a][b]vstack=inputs=2")
        cp = run([FFMPEG, "-hide_banner", "-nostats", "-y",
                  "-i", str(f), "-i", str(out),
                  "-lavfi", fc, "-frames:v", "1", str(png)])
        print(f"  [{'OK ' if cp.returncode == 0 else 'ERR'}] {png.name}")


def cmd_spectrograms(a: argparse.Namespace) -> int:
    files = sorted(Path(a.src).glob("*.wav"))
    make_spectrograms(files, Path(a.dst), Path(a.spectro_dir))
    return 0


# --- faithfulness / tame (AI super-res HF control) --------------------------
# The AI variant (AudioSR, tools/ai_super_sfx.py) can synthesize broadband high
# frequencies ABOVE the source's real Nyquist -- audible as a "static" wash.
# "Invention %" = the share of a file's spectral energy above ITS SOURCE's Nyquist
# (a faithful light render or the source itself is ~0%). `faithfulness` reports and
# gates it; `tame` low-passes + high-shelves each file just enough to bring it under
# a budget while preserving the detail below the Nyquist.

def _read_wav_mono(path: Path):
    """Read a PCM WAV (8/16/32-bit) as float32 mono in [-1,1]; return (samples, rate)."""
    import wave
    import numpy as np
    with wave.open(str(path), "rb") as w:
        sw, ch, sr, n = w.getsampwidth(), w.getnchannels(), w.getframerate(), w.getnframes()
        raw = w.readframes(n)
    if sw == 1:
        a = (np.frombuffer(raw, np.uint8).astype(np.float32) - 128.0) / 128.0
    elif sw == 2:
        a = np.frombuffer(raw, np.int16).astype(np.float32) / 32768.0
    else:
        a = np.frombuffer(raw, np.int32).astype(np.float32) / 2147483648.0
    if ch == 2:
        a = a[::2]
    return a, sr


def _invention_pct(y, sr: int, cut_hz: float) -> float:
    """Percent of spectral energy at/above cut_hz (Hann-windowed periodogram)."""
    import numpy as np
    if y.size == 0:
        return 0.0
    w = np.hanning(len(y)) if len(y) > 1 else np.ones(1, dtype=np.float32)
    p = np.abs(np.fft.rfft(y * w)) ** 2
    f = np.fft.rfftfreq(len(y), 1.0 / sr)
    tot = float(p.sum())
    return float(100.0 * p[f >= cut_hz].sum() / tot) if tot > 0 else 0.0


def _src_nyquist(src_dir: Path, name: str):
    """Source Nyquist (rate/2 Hz) for a matching filename, or None if absent."""
    import wave
    p = src_dir / name
    if not p.exists():
        return None
    with wave.open(str(p), "rb") as w:
        return w.getframerate() / 2.0


def _quiet_floor(src_path: Path, tgt_path: Path):
    """Median level (dBFS) of the TARGET in frames where the SOURCE is TRULY silent
    (< -75 dBFS). This catches an AI-added broadband hiss that fills the source's silent
    gaps -- the audible "background static". Returns None if the source has no real
    silence (a continuously-voiced effect), so soft content is never mistaken for hiss."""
    import numpy as np
    ys, srs = _read_wav_mono(src_path)
    yt, _srt = _read_wav_mono(tgt_path)
    dur = len(ys) / srs if srs else 0.0
    n = max(4, int(dur / 0.02))
    if ys.size < n or yt.size < n:
        return None

    def fdb(y):
        return np.array([20.0 * np.log10(np.sqrt(np.mean(c * c) + 1e-13) + 1e-13)
                         for c in np.array_split(y, n)])

    sdb, tdb = fdb(ys), fdb(yt)
    silent = sdb < -75.0                       # frames where the SOURCE is truly silent
    if silent.sum() < max(2, 0.03 * n):
        return None
    return float(np.median(tdb[silent]))


# Adaptive taming ladder: (low-pass cutoff as x source-Nyquist, high-shelf gain dB).
# Mild first (keeps HF detail); escalates toward/under the Nyquist for the badly
# hallucinated files (which correctly converge to the faithful band-limited render).
_TAME_LADDER = [(1.5, -6.0), (1.4, -6.0), (1.3, -9.0), (1.2, -9.0), (1.15, -12.0),
                (1.1, -15.0), (1.05, -18.0), (1.0, -24.0), (0.95, -30.0)]


def _tame_filter(nyq: float, lp_factor: float, shelf_db: float, out_rate: int) -> str:
    """4-pole low-pass (two cascaded 2-pole) + high-shelf attenuation above the Nyquist."""
    lp = min(nyq * lp_factor, out_rate * 0.49)
    return (f"lowpass=f={lp:.0f}:poles=2,lowpass=f={lp:.0f}:poles=2,"
            f"highshelf=f={nyq:.0f}:g={shelf_db:g}")


def _encode16(src: Path, dst: Path, rate: int, filt: str | None = None) -> None:
    cmd = [FFMPEG, "-hide_banner", "-nostats", "-y", "-i", str(src)]
    if filt:
        cmd += ["-af", filt]
    cmd += ["-ac", "1", "-ar", str(rate), "-c:a", "pcm_s16le",
            "-dither_method", "triangular", "-bitexact", "-map_metadata", "-1", str(dst)]
    subprocess.run(cmd, capture_output=True, text=True)


def cmd_faithfulness(a: argparse.Namespace) -> int:
    src_dir, tgt_dir = Path(a.src), Path(a.target)
    files = sorted(tgt_dir.glob("*.wav"))
    print(f"faithfulness: {tgt_dir}  vs source {src_dir}")
    print(f"  budgets: invented HF <= {a.max_invent:g}% ;  noise floor <= {a.max_floor:g} dBFS in source-quiet regions")
    print(f"  {'file':<32} {'srcNyq':>6} {'invent%':>8} {'floordB':>8}  result")
    print("  " + "-" * 66)
    fails = []
    checked = 0
    for f in files:
        nyq = _src_nyquist(src_dir, f.name)
        if nyq is None:
            continue
        checked += 1
        y, sr = _read_wav_mono(f)
        inv = _invention_pct(y, sr, nyq)
        floor = _quiet_floor(src_dir / f.name, f)
        probs = []
        if inv > a.max_invent + 1e-9:
            probs.append(f"invent {inv:.1f}%")
        if floor is not None and floor > a.max_floor + 1e-9:
            probs.append(f"floor {floor:.0f}dB")
        fs = f"{floor:.0f}" if floor is not None else "-"
        print(f"  {f.name:<32} {nyq:>6.0f} {inv:>7.2f}% {fs:>8}  {'OK' if not probs else 'FAIL'}")
        if probs:
            fails.append((f.name, ", ".join(probs)))
    print()
    if fails:
        print(f"FAIL - {len(fails)}/{checked} file(s) outside budget:")
        for n, why in fails:
            print(f"  - {n}: {why}")
        return 1
    print(f"PASS - all {checked} files within budget (invented HF <= {a.max_invent:g}%, "
          f"quiet-region floor <= {a.max_floor:g} dBFS).")
    return 0


def cmd_tame(a: argparse.Namespace) -> int:
    import math
    import numpy as np
    src_dir, in_dir, dst_dir = Path(a.src), Path(a.indir), Path(a.dst)
    dst_dir.mkdir(parents=True, exist_ok=True)
    files = sorted(in_dir.glob("*.wav"))
    if not files:
        print(f"no .wav files in {in_dir}", file=sys.stderr)
        return 2
    print(f"tame: {in_dir} -> {dst_dir}  (invented HF <= {a.max_invent:g}%, "
          f"noise floor <= {a.max_floor:g}dBFS{', denoise OFF' if a.no_denoise else ''}, "
          f"out 16-bit/{a.out_rate}Hz dithered)")
    dn_tmp = dst_dir / "_tame_dn.wav"
    tmp = dst_dir / "_tame_tmp.wav"
    ok = 0
    for f in files:
        nyq = _src_nyquist(src_dir, f.name)
        out = dst_dir / f.name
        if nyq is None:                       # no source match -> passthrough
            _encode16(f, out, a.out_rate)
            print(f"  [--] {f.name:<32} (no source match; passthrough)")
            ok += 1
            continue
        y0, sr0 = _read_wav_mono(f)
        raw_inv = _invention_pct(y0, sr0, nyq)
        in_peak = float(np.max(np.abs(y0))) if y0.size else 0.0
        # stage 1: ADAPTIVE denoise -- only when the raw AI has an elevated noise floor in
        # the source's quiet regions (the "background static"). Strength targets that
        # measured floor, so clean / continuously-loud files are left untouched (detail).
        sweep_src, dn = f, ""
        floor0 = _quiet_floor(src_dir / f.name, f)
        if not a.no_denoise and floor0 is not None and floor0 > a.max_floor:
            # A NOISE GATE (not spectral de-noise) clears the AI hiss in the source's silent
            # gaps. It attenuates the whole quiet region uniformly, so -- unlike an aggressive
            # afftdn, which strips the natural broadband bed and leaves isolated "musical-
            # noise" tones -- it never creates tonal artifacts. The threshold sits just above
            # the measured hiss; the loud content is well above it and left untouched.
            thr = 10.0 ** ((floor0 + 8.0) / 20.0)
            dn = f"agate=threshold={thr:.5f}:range=0.01:ratio=3:attack=3:release=50,"
            _encode16(f, dn_tmp, a.out_rate, dn.rstrip(","))
            sweep_src = dn_tmp
        # stage 2: escalate low-pass / shelf until invented HF (above Nyquist) <= budget
        chosen, achieved, tamed_peak = _TAME_LADDER[-1], raw_inv, in_peak
        for lpf, shg in _TAME_LADDER:
            _encode16(sweep_src, tmp, a.out_rate, _tame_filter(nyq, lpf, shg, a.out_rate))
            ty, tsr = _read_wav_mono(tmp)
            achieved = _invention_pct(ty, tsr, nyq)
            tamed_peak = float(np.max(np.abs(ty))) if ty.size else 0.0
            chosen = (lpf, shg)
            if achieved <= a.max_invent:
                break
        # stage 3: restore level (gain is ratio-invariant, so faithfulness holds) + final
        gain_db = 20.0 * math.log10(in_peak / tamed_peak) if in_peak > 0 and tamed_peak > 0 else 0.0
        filt = dn + _tame_filter(nyq, chosen[0], chosen[1], a.out_rate) + f",volume={gain_db:.3f}dB"
        _encode16(f, out, a.out_rate, filt)
        dn_note = f"  +denoise(floor {floor0:.0f}dB)" if dn else ""
        print(f"  [OK] {f.name:<30} inv {raw_inv:4.1f}->{achieved:3.1f}%  "
              f"lp x{chosen[0]:g} shelf {chosen[1]:g}dB {gain_db:+.1f}dB{dn_note}")
        ok += 1
    for t in (dn_tmp, tmp):
        if t.exists():
            t.unlink()
    print(f"\ntamed {ok}/{len(files)} -> {dst_dir}")
    return 0 if ok == len(files) else 1


# --- cli --------------------------------------------------------------------
def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", default=str(DEFAULT_SRC), help="source wav dir")
    ap.add_argument("--dst", default=str(DEFAULT_DST), help="output wav dir")
    ap.add_argument("--ceiling", type=float, default=-1.0, help="peak ceiling dBFS")
    ap.add_argument("--nr", type=float, default=12.0, help="afftdn noise reduction dB")
    ap.add_argument("--nf", type=float, default=-50.0, help="afftdn noise floor dBFS")
    ap.add_argument("--highpass", type=float, default=50.0, help="subsonic highpass Hz (0=off)")
    ap.add_argument("--no-denoise", action="store_true", help="skip afftdn stage")
    ap.add_argument("--spectrograms", action="store_true", help="also emit A/B PNGs")
    ap.add_argument("--spectro-dir", default=str(DEFAULT_SPECTRO), help="spectrogram out dir")
    # tame / faithfulness (AI super-res HF control)
    ap.add_argument("--in", dest="indir", default=str(REPO / "extracted" / "audio" / "wav_ai_raw"),
                    help="tame: input dir (raw AI renders)")
    ap.add_argument("--target", default=str(REPO / "extracted" / "audio" / "wav_ai"),
                    help="faithfulness: dir to check")
    ap.add_argument("--max-invent", type=float, default=2.0,
                    help="max %% energy above source Nyquist (tame budget / faithfulness pass)")
    ap.add_argument("--out-rate", type=int, default=48000, help="tame: output sample rate")
    ap.add_argument("--max-floor", type=float, default=-70.0,
                    help="tame/faithfulness: max noise floor dBFS in source-quiet regions "
                         "(tame denoises adaptively to hit it; --no-denoise to skip)")
    ap.add_argument("cmd", nargs="?", default="enhance",
                    choices=["enhance", "verify", "spectrograms", "tame", "faithfulness"])
    a = ap.parse_args(argv)
    if a.cmd == "verify":
        return cmd_verify(a)
    if a.cmd == "spectrograms":
        return cmd_spectrograms(a)
    if a.cmd == "faithfulness":
        return cmd_faithfulness(a)
    if a.cmd == "tame":
        return cmd_tame(a)
    return cmd_enhance(a)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
