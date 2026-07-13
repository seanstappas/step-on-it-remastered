#!/usr/bin/env python3
"""Prove the *_hurry.ogg variants are TEMPO-ONLY (pitch preserved), i.e. faithful to the
original QTMA SetMovieRate(1.25x) behaviour and NOT a pitch-shifting resample.

For each normal/hurry pair:
  * duration ratio  hurry/normal  -> expect ~0.80  (= 1/1.25, tempo +25%)
  * long-term average magnitude spectrum: spectral centroid ratio + matched dominant-peak
    frequency ratio -> expect ~1.00 (pitch UNCHANGED). A resample shifts every peak ~1.25x:
    the centroid ratio rises to ~1.25 while the matched-peak ratio collapses to nan (no peak
    lands within the 6% match window).
Decodes OGG via ffmpeg to mono 22050 Hz PCM, then FFTs in numpy.
"""
import os, sys, subprocess, shutil
import numpy as np

SR = 22050
# Prefer an explicit override, then ffmpeg on PATH; the hardcoded path is only a last-resort
# fallback so the tool still runs out-of-the-box in this repo's known dev environment.
FF = os.environ.get("FFMPEG") or shutil.which("ffmpeg") or r"D:\Program Files\Tools\ffmpeg.exe"


def _sibling(exe, name):
    """Resolve a tool that ships beside `exe` (e.g. ffprobe next to ffmpeg), so a path like
    C:\\ffmpeg\\bin\\ffmpeg.exe maps to C:\\ffmpeg\\bin\\ffprobe.exe -- NOT a naive
    str.replace('ffmpeg','ffprobe') that would also rewrite the parent directory."""
    d = os.path.dirname(exe)
    base = name + (".exe" if exe.lower().endswith(".exe") else "")
    return os.path.join(d, base) if d else name


FFPROBE = os.environ.get("FFPROBE") or _sibling(FF, "ffprobe")
MUSIC = os.path.join("extracted", "music")
TUNES = ["6lilt", "Cminor", "bass_for_lunch", "spooky",
         "6lilt_thin", "Cminor_thin", "bass_for_lunch_thin", "spooky_thin"]


def _require_tools():
    """Fail with a clear message (not a raw traceback) if ffmpeg/ffprobe are unavailable."""
    for exe, label in ((FF, "ffmpeg"), (FFPROBE, "ffprobe")):
        if not (os.path.exists(exe) or shutil.which(exe)):
            sys.exit("ERROR: %s not found (%r). Set FFMPEG/FFPROBE or add it to PATH." % (label, exe))


def decode(path):
    """OGG -> float32 mono @ SR via ffmpeg (s16le)."""
    raw = subprocess.run(
        [FF, "-v", "error", "-i", path, "-ac", "1", "-ar", str(SR), "-f", "s16le", "-"],
        stdout=subprocess.PIPE, check=True).stdout
    x = np.frombuffer(raw, dtype="<i2").astype(np.float32) / 32768.0
    return x


def avg_spectrum(x, nfft=8192, hop=4096):
    """Welch-style average magnitude spectrum over the whole signal."""
    if len(x) < nfft:
        x = np.pad(x, (0, nfft - len(x)))
    win = np.hanning(nfft).astype(np.float32)
    acc = np.zeros(nfft // 2 + 1, dtype=np.float64)
    n = 0
    for i in range(0, len(x) - nfft + 1, hop):
        acc += np.abs(np.fft.rfft(x[i:i + nfft] * win))
        n += 1
    acc /= max(n, 1)
    freqs = np.fft.rfftfreq(nfft, 1.0 / SR)
    return freqs, acc


def centroid(freqs, mag, fmin=50.0, fmax=8000.0):
    m = (freqs >= fmin) & (freqs <= fmax)
    f, a = freqs[m], mag[m]
    return float(np.sum(f * a) / max(np.sum(a), 1e-12))


def top_peaks(freqs, mag, k=12, fmin=80.0, fmax=5000.0):
    m = (freqs >= fmin) & (freqs <= fmax)
    f, a = freqs[m], mag[m]
    # local maxima
    idx = [i for i in range(1, len(a) - 1) if a[i] > a[i - 1] and a[i] >= a[i + 1]]
    idx.sort(key=lambda i: a[i], reverse=True)
    return sorted(f[i] for i in idx[:k])


def matched_peak_ratio(fn, fh):
    """Median (hurry_peak / nearest_normal_peak) across the normal track's dominant peaks."""
    if not fn or not fh:                          # no detectable peaks -> undefined ratio
        return float("nan")
    ratios = []
    for p in fn:
        j = min(range(len(fh)), key=lambda i: abs(fh[i] - p))
        if abs(fh[j] - p) < 0.06 * p:            # within 6% (a semitone is ~5.9%)
            ratios.append(fh[j] / p)
    return float(np.median(ratios)) if ratios else float("nan")


def dur(path):
    out = subprocess.run([FFPROBE, "-v", "error",
                          "-show_entries", "format=duration", "-of",
                          "default=nk=1:nw=1", path],
                         stdout=subprocess.PIPE, check=True).stdout
    try:
        return float(out.strip())
    except ValueError:
        return 0.0


def main():
    _require_tools()
    print("%-18s %8s %10s %10s %10s" %
          ("track", "dur.ratio", "centroid_n", "centroid_h", "pitch.ratio"))
    print("-" * 62)
    ok = True
    for t in TUNES:
        n = os.path.join(MUSIC, t + ".ogg")
        h = os.path.join(MUSIC, t + "_hurry.ogg")
        if not (os.path.exists(n) and os.path.exists(h)):
            print("%-18s  (missing)" % t); ok = False; continue
        try:
            dr = dur(h) / max(dur(n), 1e-9)
            xn, xh = decode(n), decode(h)
            frn, mgn = avg_spectrum(xn)
            frh, mgh = avg_spectrum(xh)
            cn, ch = centroid(frn, mgn), centroid(frh, mgh)
            pr = matched_peak_ratio(top_peaks(frn, mgn), top_peaks(frh, mgh))
        except (subprocess.CalledProcessError, ValueError) as e:
            print("%-18s  (decode failed: %s)" % (t, e)); ok = False; continue
        print("%-18s %8.4f %10.1f %10.1f %10.4f" % (t, dr, cn, ch, pr))
        # PRIMARY pitch proof = matched dominant-peak ratio ~1.00 (a semitone would be 1.059).
        # tempo proof = dur.ratio ~0.80. The spectral centroid may dip a few % (WSOLA time-
        # stretch mildly softens HF transients -- a brightness/timbre effect, NOT a pitch
        # shift); a loose 0.90-1.10 band just rules out a gross 1.25x resample.
        cratio = (ch / cn) if cn > 1e-9 else 0.0     # cn~0 => silent/broken track => fail the band
        if not (0.78 <= dr <= 0.82 and 0.98 <= pr <= 1.02 and 0.90 <= cratio <= 1.10):
            ok = False
    print("-" * 62)
    print("EXPECT: dur.ratio ~0.80 (tempo +25%),  centroid & pitch.ratio ~1.00 (pitch UNCHANGED)")
    print("A pitch-shifting resample would instead push the centroid ratio to ~1.25 and drop")
    print("pitch.ratio to nan (every peak moves ~1.25x, out of the 6% match window).")
    print("VERDICT: %s -- tempo-only speedup, pitch preserved (faithful QTMA 1.25x rate)"
          % ("PASS" if ok else "FAIL"))
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
