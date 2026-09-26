"""build_original_music.py -- turn the user's ORIGINAL-game music recordings into the
game's "original" soundtrack (extracted/music/original/<track>.ogg, see
docs/original_game/music-tracks.md), each exactly ONE seamless QuickTime loop.

Source: refs/music/gameplay/{6lit,bass_for_lunch,Cminor,Spooky}.wav (emulator captures of
the real game, music only). For each track:

  1. Loop length L = the QuickTime movie's mdhd duration (what QuickTime loops on), read
     from the game's music movie (raw_game/.../Step On It!  Movies).
  2. The recording is ALIGNED to the tune's own note onsets (tools/qtma_to_midi.py parses
     them from the movie): rec_time = a + b * note_time, fitted by maximising a spectral-flux
     onset envelope at the predicted onsets. `a` = where the loop starts in the capture, `b`
     = the capture's clock drift (emulator audio is not exactly nominal speed). NB the
     captures' FIRST note sounds ~0.14 s late (QuickTime's synth start-up lag; every later
     note is on the tune clock), so `a` sits BEFORE the first audible sound -- the fit, not
     the first loud sample, is the loop start. (Validated: the same fit on our own render,
     which starts exactly on the first note, lands within the flux window's ~25 ms bias.)
  3. Cut [a, a + b*L], zero-padded where the capture starts late / ends early (both are the
     silent start-up lag or the tune's own silent tail).
  4. Spooky's capture speeds up at the end (the game's low-Bonus "hurry" = tempo x1.25, pitch
     unchanged). The hurry start T is fitted too (piecewise tempo) and the tail is restored to
     1.0x with ffmpeg atempo (tempo-only, like the game's own speedup), so the loop is whole.
  5. Loudness-matched to the remaster (-14 LUFS, true peak <= -1.5 dBTP) so an A/B toggle is
     fair, and encoded as OGG Vorbis.

The "_hurry" variants are then built by tools/render_music_hurry.ps1 -Dir extracted/music/original.
Usage: py tools/build_original_music.py
"""
from __future__ import annotations
import json, re, shutil, subprocess, sys, wave
from pathlib import Path
import numpy as np

sys.path.insert(0, str(Path(__file__).resolve().parent))
import qtma_to_midi as q  # noqa: E402

SRC = Path("refs/music/gameplay")
OUT = Path("extracted/music/original")
TMP = Path("tmp/original_music")
TRACKS = [  # (recording, game movie, output base, has a hurry tail)
    ("6lit.wav", "6lilt", "6lilt", False),
    ("bass_for_lunch.wav", "bass for lunch", "bass_for_lunch", False),
    ("Cminor.wav", "Cminor", "Cminor", False),
    ("Spooky.wav", "spooky", "spooky", True),
]
HURRY = 1.25
HOP = 240          # 5 ms at 48 kHz
NFFT = 2048
FLUX_BIAS = NFFT / 2 / 48000.0   # a flux frame is stamped at its window START; the onset sits mid-window


def ffmpeg() -> str:
    return shutil.which("ffmpeg") or r"D:\Program Files\Tools\ffmpeg.exe"


def read_wav(p: Path):
    with wave.open(str(p), "rb") as w:
        sr, ch, sw, n = w.getframerate(), w.getnchannels(), w.getsampwidth(), w.getnframes()
        raw = w.readframes(n)
    if sw != 2:
        raise SystemExit(f"{p}: expected 16-bit PCM, got {8 * sw}-bit")
    x = np.frombuffer(raw, dtype="<i2").reshape(-1, ch).astype(np.float32) / 32768.0
    return x, sr


def write_wav(p: Path, x: np.ndarray, sr: int):
    y = np.clip(np.round(x * 32767.0), -32768, 32767).astype("<i2")
    with wave.open(str(p), "wb") as w:
        w.setnchannels(y.shape[1]); w.setsampwidth(2); w.setframerate(sr)
        w.writeframes(y.tobytes())


def loop_and_onsets(movie: str):
    res = (q.RESFK / ("._" + movie)).read_bytes()
    o = q.find_atom(res, b"mdhd")
    ts, dur = np.frombuffer(res[o + 12:o + 20], dtype=">u4")
    notes, _ = q.parse_events(q.mdat_events((q.MOVIES / movie).read_bytes()))
    on = np.unique(np.array([t for (t, *_r) in notes], dtype=np.float64) / float(ts))
    return float(dur) / float(ts), on


def onset_envelope(x: np.ndarray) -> np.ndarray:
    m = x.mean(axis=1)
    nfr = 1 + (len(m) - NFFT) // HOP
    win = np.hanning(NFFT).astype(np.float32)
    prev, env = None, np.zeros(nfr, dtype=np.float32)
    for s in range(0, nfr, 4096):                     # chunked STFT (bounded memory)
        idx = np.arange(s, min(nfr, s + 4096))[:, None] * HOP + np.arange(NFFT)[None, :]
        mag = np.log1p(100.0 * np.abs(np.fft.rfft(m[idx] * win, axis=1)))
        d = np.diff(mag, axis=0, prepend=mag[:1] if prev is None else prev[None, :])
        env[s:s + len(mag)] = np.maximum(d, 0.0).sum(axis=1)
        prev = mag[-1]
    env -= np.median(env)
    return np.maximum(env, 0.0) / (env.max() + 1e-9)


def score(env: np.ndarray, t_rec: np.ndarray) -> float:
    k = np.round(t_rec * 200.0).astype(np.int64)      # 200 frames/s (5 ms hop)
    k = k[(k >= 1) & (k < len(env) - 1)]
    if len(k) == 0:
        return 0.0
    return float(np.maximum(np.maximum(env[k - 1], env[k]), env[k + 1]).mean())


def rec_time(on: np.ndarray, a: float, b: float, T: float | None) -> np.ndarray:
    if T is None:
        return a + b * on
    return np.where(on < T, a + b * on, a + b * T + b * (on - T) / HURRY)


def fit(env, on, first_sound, hurry: bool):
    fit_on = on[on < 40.0] if hurry else on           # a spooky hurry is always later than 40 s
    best = (-1.0, 0.0, 1.0)
    for a in np.arange(first_sound - 0.4, first_sound + 0.2, 0.005):
        for b in np.arange(0.994, 1.006, 0.0001):
            s = score(env, a + b * fit_on)
            if s > best[0]:
                best = (s, a, b)
    s, a, b = best
    T = None
    if hurry:
        cands = [(score(env, rec_time(on, a, b, t)), t) for t in np.arange(40.0, 64.0, 0.02)]
        s, T = max(cands)
    return s, a, b, T


def main():
    TMP.mkdir(parents=True, exist_ok=True)
    OUT.mkdir(parents=True, exist_ok=True)
    ff = ffmpeg()
    for rec, movie, base, hurry in TRACKS:
        x, sr = read_wav(SRC / rec)
        L, on = loop_and_onsets(movie)
        env = onset_envelope(x)
        loud = np.flatnonzero(np.abs(x).max(axis=1) > 0.01)
        first = loud[0] / sr if len(loud) else 0.0
        s, a, b, T = fit(env, on, first, hurry)
        a += FLUX_BIAS
        i0 = int(round(a * sr))
        if i0 < 0:                                   # capture began a few ms into the loop
            x = np.vstack([np.zeros((-i0, x.shape[1]), np.float32), x])
            i0 = 0
        if T is None:
            n = int(round(b * L * sr))
            seg = x[i0:i0 + n]
            loop = np.vstack([seg, np.zeros((n - len(seg), x.shape[1]), np.float32)])
            note = ""
        else:
            n1 = int(round(b * T * sr))
            n2 = int(round(b * (L - T) / HURRY * sr))                    # hurried tail, capture time
            write_wav(TMP / f"{base}_tail.wav", x[i0 + n1:i0 + n1 + n2], sr)
            subprocess.run([ff, "-hide_banner", "-loglevel", "error", "-y", "-i", str(TMP / f"{base}_tail.wav"),
                            "-filter:a", f"atempo={1.0 / HURRY:.4f}", str(TMP / f"{base}_tail1x.wav")], check=True)
            tail, _ = read_wav(TMP / f"{base}_tail1x.wav")
            n = int(round(b * L * sr))
            loop = np.vstack([x[i0:i0 + n1], tail])[:n]
            loop = np.vstack([loop, np.zeros((n - len(loop), x.shape[1]), np.float32)])
            note = f"  hurry from loop t={T:.2f}s (capture {a + b * T:.2f}s) restored to 1.0x"
        raw = TMP / f"{base}_loop.wav"
        write_wav(raw, loop, sr)
        # two-pass loudnorm (linear) -> -14 LUFS like the remaster set
        m = subprocess.run([ff, "-hide_banner", "-i", str(raw), "-af",
                            "loudnorm=I=-14:TP=-1.5:LRA=20:print_format=json", "-f", "null", "-"],
                           capture_output=True, text=True).stderr
        js = json.loads(re.findall(r"\{[^{}]*\}", m)[-1])
        af = ("loudnorm=I=-14:TP=-1.5:LRA=20:measured_I={input_i}:measured_TP={input_tp}:"
              "measured_LRA={input_lra}:measured_thresh={input_thresh}:offset={target_offset}:linear=true").format(**js)
        dst = OUT / f"{base}.ogg"
        subprocess.run([ff, "-hide_banner", "-loglevel", "error", "-y", "-i", str(raw), "-af", af,
                        "-ar", str(sr), "-c:a", "libvorbis", "-q:a", "6", str(dst)], check=True)
        print(f"{base:15s} loop {L:8.3f}s  start {a:6.3f}s  drift x{b:.4f}  fit {s:.3f}  -> {dst} "
              f"({len(loop) / sr:.3f}s, in {js['input_i']} LUFS){note}")


if __name__ == "__main__":
    main()
