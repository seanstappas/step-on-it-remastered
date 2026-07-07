#!/usr/bin/env python3
"""render_music.py -- render the extracted QTMA MIDI (extracted/music/*.mid) to the
REMASTER soundtrack: a numpy software synth with per-GM-instrument voices, drums,
stereo panning, chorus/detune, vibrato and a light reverb, so the faithful note
data actually sounds alive.

FIDELITY: the notes / timing / tempo / channel-program are FAITHFUL -- straight from
tools/qtma_to_midi.py's extraction of the original QuickTime Music (QTMA) tracks.
This is the REMASTER *voicing* -- a synthesized interpretation, NOT the original
Apple QTMA instrument samples. For the ORIGINAL/retro soundtrack, drop real
recordings per docs/original_game/music-tracks.md. The simple first-pass render is
archived in extracted/music/first_pass/ (its code is in git history).

Requires: numpy. Output: <out_dir>/<name>.wav (16-bit STEREO 44100). render_music.ps1
converts to .ogg via ffmpeg. Usage: py tools/render_music.py [in_dir] [out_dir]
"""
import sys, os, struct, wave
import numpy as np

SR = 44100
RNG = np.random.RandomState(12345)          # fixed seed -> reproducible drums/reverb noise

# ---------------------------------------------------------------- MIDI parsing
def read_varlen(d, p):
    v = 0
    while True:
        b = d[p]; p += 1
        v = (v << 7) | (b & 0x7f)
        if not (b & 0x80):
            return v, p


def parse_midi(path):
    with open(path, 'rb') as f:
        data = f.read()
    if data[:4] != b'MThd':
        raise ValueError("not a Standard MIDI File: " + path)
    hlen = struct.unpack('>I', data[4:8])[0]
    _fmt, ntrks, division = struct.unpack('>HHH', data[8:14])
    if division & 0x8000:
        raise ValueError("SMPTE division unsupported: " + path)
    pos = 8 + hlen
    events, tempos, seq = [], [], 0
    for _ in range(ntrks):
        if data[pos:pos+4] != b'MTrk':
            break
        tlen = struct.unpack('>I', data[pos+4:pos+8])[0]
        p, tend = pos + 8, pos + 8 + tlen
        pos = tend
        tick, running = 0, None
        while p < tend:
            dt, p = read_varlen(data, p); tick += dt
            status = data[p]
            if status & 0x80:
                running = status; p += 1
            else:
                status = running
            if status is None:
                break
            hi, ch = status & 0xf0, status & 0x0f
            if hi == 0x90:
                note, vel = data[p], data[p+1]; p += 2
                events.append((tick, seq, 'on' if vel > 0 else 'off', ch, note, vel)); seq += 1
            elif hi == 0x80:
                note = data[p]; p += 2
                events.append((tick, seq, 'off', ch, note, 0)); seq += 1
            elif hi == 0xC0:
                events.append((tick, seq, 'prog', ch, data[p], 0)); p += 1; seq += 1
            elif hi in (0xA0, 0xB0, 0xE0):
                p += 2
            elif hi == 0xD0:
                p += 1
            elif status == 0xFF:
                mt = data[p]; p += 1
                ml, p = read_varlen(data, p)
                if mt == 0x51 and ml == 3:
                    tempos.append((tick, struct.unpack('>I', b'\x00' + data[p:p+3])[0]))
                p += ml
            elif status in (0xF0, 0xF7):
                sl, p = read_varlen(data, p); p += sl
            else:
                p += 1
    return division, events, tempos


def time_mapper(division, tempos):
    tempos = sorted(tempos)
    if not tempos or tempos[0][0] > 0:
        tempos = [(0, 500000)] + tempos
    segs, sec, ptick, pusec = [], 0.0, tempos[0][0], tempos[0][1]
    segs.append((ptick, 0.0, pusec))
    for tk, usec in tempos[1:]:
        sec += (tk - ptick) * (pusec / 1e6) / division
        segs.append((tk, sec, usec)); ptick, pusec = tk, usec

    def t2s(tick):
        s = segs[0]
        for seg in segs:
            if seg[0] <= tick:
                s = seg
            else:
                break
        return s[1] + (tick - s[0]) * (s[2] / 1e6) / division
    return t2s


def collect_notes(events, t2s):
    # At a common tick, close note-offs BEFORE opening note-ons (so a retriggered
    # pitch pairs correctly), and apply program changes before the notes they affect.
    order = {'off': 0, 'prog': 1, 'on': 2}
    events.sort(key=lambda e: (e[0], order[e[2]], e[1]))
    prog = [0] * 16
    active, notes = {}, []
    for tick, _seq, kind, ch, a, b in events:
        if kind == 'prog':
            prog[ch] = a
        elif kind == 'on':
            active[(ch, a)] = (tick, b, prog[ch])
        elif kind == 'off':
            k = (ch, a)
            if k in active:
                st, vel, pg = active.pop(k)
                notes.append((t2s(st), t2s(tick), a, vel, ch, pg))
    return notes


# ---------------------------------------------------------------- synth voices
def voice_for(program):
    """GM-program-family -> timbre. h=harmonic amps, ADSR, det=chorus detune,
    vib=vibrato depth (fractional)."""
    p = program
    if p < 8:    return dict(h=[1, .55, .35, .2, .1],           a=.004, d=.5,  s=.25, r=.25, det=.004, vib=0)     # piano
    if p < 16:   return dict(h=[1, .4, .6, .25, .35, .15],      a=.003, d=1.4, s=.0,  r=.4,  det=.003, vib=0)     # bells/vibes
    if p < 24:   return dict(h=[1, .9, .7, .6, .5, .4, .3],     a=.01,  d=.05, s=.9,  r=.08, det=.006, vib=.02)   # organ
    if p < 32:   return dict(h=[1, .5, .3, .2, .12],            a=.005, d=.7,  s=.15, r=.2,  det=.005, vib=0)     # guitar
    if p < 40:   return dict(h=[1, .7, .35, .15],               a=.004, d=.4,  s=.55, r=.12, det=.002, vib=0)     # bass
    if p < 48:   return dict(h=[1, .6, .5, .4, .3, .24, .18],   a=.06,  d=.2,  s=.8,  r=.35, det=.008, vib=.025)  # strings
    if p < 56:   return dict(h=[1, .5, .45, .35, .28, .2],      a=.08,  d=.2,  s=.85, r=.4,  det=.010, vib=.02)   # ensemble
    if p < 64:   return dict(h=[1, .8, .65, .5, .4, .3],        a=.02,  d=.15, s=.75, r=.2,  det=.006, vib=.02)   # brass
    if p < 72:   return dict(h=[1, .6, .5, .35, .25],           a=.02,  d=.15, s=.75, r=.2,  det=.005, vib=.03)   # reed
    if p < 80:   return dict(h=[1, .25, .12, .06],              a=.03,  d=.1,  s=.8,  r=.2,  det=.004, vib=.04)   # pipe/flute
    if p < 88:   return dict(h=[1, .7, .55, .45, .38, .3, .25], a=.008, d=.1,  s=.75, r=.15, det=.010, vib=.03)   # synth lead
    if p < 96:   return dict(h=[1, .5, .4, .3, .25, .2],        a=.1,   d=.3,  s=.8,  r=.5,  det=.012, vib=.02)   # synth pad
    return dict(h=[1, .5, .3, .2],                              a=.01,  d=.4,  s=.4,  r=.2,  det=.005, vib=0)     # default


def adsr(natt, nrel, a, d, s):
    env = np.empty(natt + nrel, dtype=np.float32)
    na = min(max(int(a * SR), 1), natt)
    nd = max(int(d * SR), 1)
    env[:na] = np.linspace(0.0, 1.0, na, endpoint=False)
    de = min(na + nd, natt)
    if de > na:
        env[na:de] = np.linspace(1.0, s, de - na, endpoint=False)
    if natt > de:
        env[de:natt] = s
    if nrel > 0:
        env[natt:] = np.linspace(s, 0.0, nrel)
    return env


def _add(buf, i0, sig):
    if i0 < 0:
        sig = sig[-i0:]; i0 = 0
    end = i0 + len(sig)
    if end > len(buf):
        sig = sig[:len(buf) - i0]; end = len(buf)
    if len(sig):
        buf[i0:end] += sig


def render_note(L, R, start, end, note, vel, v, pan):
    freq = 440.0 * 2.0 ** ((note - 69) / 12.0)
    if freq < 20.0 or freq > 12000.0:
        return
    dur = max(end - start, 0.05)
    natt = int(dur * SR)
    nrel = int(v['r'] * SR)
    n = natt + nrel
    if n < 2:
        return
    t = np.arange(n, dtype=np.float32) / SR
    if v['vib'] > 0:
        finst = freq * (1.0 + v['vib'] * np.sin(2 * np.pi * 5.3 * t))
    else:
        finst = np.full(n, freq, dtype=np.float32)
    ph = (2 * np.pi / SR) * np.cumsum(finst)
    hs = v['h']; hsum = float(sum(hs))
    wave = np.zeros(n, dtype=np.float32)
    for i, amp in enumerate(hs):
        wave += amp * np.sin((i + 1) * ph)
    if v['det'] > 0:                                   # chorus: 2nd detuned osc
        ph2 = (2 * np.pi / SR) * np.cumsum(finst * (1.0 + v['det']))
        w2 = np.zeros(n, dtype=np.float32)
        for i, amp in enumerate(hs):
            w2 += amp * np.sin((i + 1) * ph2)
        wave = 0.6 * wave + 0.6 * w2
    wave /= hsum
    if freq < 165.0:                                   # fatten the low end with a sub-octave
        wave = 0.82 * wave + 0.38 * np.sin(0.5 * ph)
    env = adsr(natt, nrel, v['a'], v['d'], v['s'])
    amp = (vel / 127.0) ** 0.85 * 0.30
    sig = (amp * env * wave).astype(np.float32)
    i0 = int(start * SR)
    _add(L, i0, sig * np.cos(pan * np.pi / 2))
    _add(R, i0, sig * np.sin(pan * np.pi / 2))


def render_drum(L, R, start, note, vel):
    amp = (vel / 127.0) * 0.55
    if note in (35, 36):                               # kick -- punchy, with a beater click
        n = int(.20 * SR); t = np.arange(n) / SR
        f = 135 * np.exp(-t * 34) + 48
        sig = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-t * 15) * amp * 1.7
        sig[:80] += np.linspace(1, 0, 80) * amp * 0.5
    elif note in (38, 40, 37, 39):                     # snare / clap / rim -- snappy
        n = int(.18 * SR); t = np.arange(n) / SR
        body = 0.75 * RNG.uniform(-1, 1, n) + 0.25 * np.sin(2 * np.pi * 190 * t)
        sig = body * np.exp(-t * 24) * amp * 1.25
    elif note in (42, 44):                             # closed hat
        n = int(.05 * SR); t = np.arange(n) / SR
        sig = RNG.uniform(-1, 1, n) * np.exp(-t * 80) * amp * 0.5
    elif note == 46:                                   # open hat
        n = int(.30 * SR); t = np.arange(n) / SR
        sig = RNG.uniform(-1, 1, n) * np.exp(-t * 11) * amp * 0.4
    elif note in (49, 57, 55, 52):                     # cymbals
        n = int(.7 * SR); t = np.arange(n) / SR
        sig = RNG.uniform(-1, 1, n) * np.exp(-t * 6) * amp * 0.4
    elif note in (41, 43, 45, 47, 48, 50):             # toms
        base = {41: 100, 43: 120, 45: 150, 47: 180, 48: 220, 50: 260}[note]
        n = int(.25 * SR); t = np.arange(n) / SR
        f = base * np.exp(-t * 8) + base * 0.6
        sig = np.sin(2 * np.pi * np.cumsum(f) / SR) * np.exp(-t * 12) * amp
    else:
        n = int(.10 * SR); t = np.arange(n) / SR
        sig = RNG.uniform(-1, 1, n) * np.exp(-t * 30) * amp * 0.4
    sig = sig.astype(np.float32) * 0.72                # drums centred
    i0 = int(start * SR)
    _add(L, i0, sig); _add(R, i0, sig)


def _pan_for(ch):
    return 0.5 + 0.42 * float(np.sin(ch * 1.7))        # wide stereo spread across the field


def reverb(sig, seconds=0.5, decay=6.0, seed=1):
    r = np.random.RandomState(seed)
    m = int(seconds * SR); t = np.arange(m) / SR
    ir = (r.uniform(-1, 1, m) * np.exp(-t * decay)).astype(np.float32)
    N = 1 << int(np.ceil(np.log2(len(sig) + m)))
    wet = np.fft.irfft(np.fft.rfft(sig, N) * np.fft.rfft(ir, N), N)[:len(sig)]
    return wet.astype(np.float32)


def trim_tail(L, R, margin_s=0.08):
    mag = np.maximum(np.abs(L), np.abs(R))
    idx = np.nonzero(mag > 1e-4)[0]
    if len(idx) == 0:
        return L, R
    keep = min(len(L), int(idx[-1]) + 1 + int(margin_s * SR))
    return L[:keep], R[:keep]


def render(notes):
    if not notes:
        return np.zeros(SR, np.float32), np.zeros(SR, np.float32)
    total = max(e for _s, e, *_ in notes) + 0.6
    n = int(total * SR) + 1
    L = np.zeros(n, dtype=np.float32); R = np.zeros(n, dtype=np.float32)
    for start, end, note, vel, ch, prog in notes:
        if ch == 9:
            render_drum(L, R, start, note, vel)
        else:
            render_note(L, R, start, end, note, vel, voice_for(prog), _pan_for(ch))
    L, R = trim_tail(L, R)
    L = 0.80 * L + 0.24 * reverb(L, seconds=0.75, decay=4.5, seed=1)   # lush stereo reverb
    R = 0.80 * R + 0.24 * reverb(R, seconds=0.75, decay=4.5, seed=2)
    # normalise into the drive so saturation is consistent, then soft-saturate for
    # warmth + loudness glue (a gentle master "drive" that makes it feel bigger).
    peak0 = float(max(np.max(np.abs(L)), np.max(np.abs(R)), 1e-9))
    d = 1.5 / peak0
    L = np.tanh(L * d); R = np.tanh(R * d)
    peak = float(max(np.max(np.abs(L)), np.max(np.abs(R)), 1e-9))
    g = 0.92 / peak
    return (L * g).astype(np.float32), (R * g).astype(np.float32)


def write_wav(path, L, R):
    inter = np.empty(len(L) * 2, dtype=np.int16)
    inter[0::2] = (np.clip(L, -1, 1) * 32767).astype(np.int16)
    inter[1::2] = (np.clip(R, -1, 1) * 32767).astype(np.int16)
    with wave.open(path, 'wb') as w:
        w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
        w.writeframes(inter.tobytes())
    return len(L) / SR


def main():
    in_dir = sys.argv[1] if len(sys.argv) > 1 else "extracted/music"
    out_dir = sys.argv[2] if len(sys.argv) > 2 else "extracted/music"
    os.makedirs(out_dir, exist_ok=True)
    mids = sorted(f for f in os.listdir(in_dir) if f.lower().endswith(".mid"))
    if not mids:
        print("no .mid files in", in_dir); return 1
    for fn in mids:
        division, events, tempos = parse_midi(os.path.join(in_dir, fn))
        notes = collect_notes(events, time_mapper(division, tempos))
        L, R = render(notes)
        out = os.path.join(out_dir, os.path.splitext(fn)[0] + ".wav")
        dur = write_wav(out, L, R)
        print("%-24s notes=%-5d dur=%5.1fs -> %s" % (fn, len(notes), dur, os.path.basename(out)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
