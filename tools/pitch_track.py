#!/usr/bin/env python3
"""pitch_track.py -- dominant-melody pitch tracker (Harmonic Product Spectrum) for a
mono/stereo WAV. Prints the melody note contour over time so we can transcribe what
an audio reference actually plays (e.g. to match a section of a remaster to the
original recording). Usage: py tools/pitch_track.py <wav> [f_lo Hz] [f_hi Hz] [t_off s]
"""
import sys, wave
import numpy as np

path = sys.argv[1]
f_lo = float(sys.argv[2]) if len(sys.argv) > 2 else 250.0
f_hi = float(sys.argv[3]) if len(sys.argv) > 3 else 1400.0
t_off = float(sys.argv[4]) if len(sys.argv) > 4 else 0.0

w = wave.open(path, "rb")
sr, nch = w.getframerate(), w.getnchannels()
x = np.frombuffer(w.readframes(w.getnframes()), dtype=np.int16).astype(np.float32)
if nch == 2:
    x = x.reshape(-1, 2).mean(1)
x /= (np.abs(x).max() + 1e-9)

win = int(0.05 * sr)
hop = int(0.0125 * sr)
window = np.hanning(win)
freqs = np.fft.rfftfreq(win, 1 / sr)
lo, hi = np.searchsorted(freqs, f_lo), np.searchsorted(freqs, f_hi)
NAMES = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]


def notename(midi):
    m = int(round(midi))
    return "%s%d" % (NAMES[m % 12], m // 12 - 1)


track = []  # (t, midi, energy)
for i in range(0, len(x) - win, hop):
    seg = x[i:i + win] * window
    mag = np.abs(np.fft.rfft(seg))
    e = mag.max()
    if e < 5e-3:
        track.append((i / sr, None, 0.0)); continue
    h = mag.copy()
    for d in (2, 3, 4):
        dec = mag[::d]
        h[:len(dec)] *= dec
    k = lo + int(np.argmax(h[lo:hi]))
    f = freqs[k]
    midi = 69 + 12 * np.log2(f / 440.0) if f > 20 else None
    track.append((i / sr, midi, e))

# median-smooth the pitch, then collapse to note segments
mids = [m for _, m, _ in track]
sm = []
for j in range(len(mids)):
    w2 = [mids[k] for k in range(max(0, j - 2), min(len(mids), j + 3)) if mids[k] is not None]
    sm.append(np.median(w2) if w2 else None)

print("start(s)  note  midi   (transcribed dominant melody; t_off=%.1f)" % t_off)
cur, cstart = None, 0.0
for (t, _, e), m in zip(track, sm):
    n = None if m is None else int(round(m))
    if n != cur:
        if cur is not None and (t - cstart) >= 0.05:
            print("  %6.2f   %-4s  %d" % (cstart + t_off, notename(cur), cur))
        cur, cstart = n, t
