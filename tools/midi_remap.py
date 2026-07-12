#!/usr/bin/env python3
"""midi_remap.py -- re-orchestrate the extracted QTMA MIDIs for the CINEMATIC music
variant by remapping GM program (instrument) numbers to bigger orchestral patches.

FIDELITY NOTE: this CHANGES instrumentation, so the result is NOT 1:1 with the
original QTMA voices -- it is the deliberately "epic" re-orchestrated variant. The
notes / timing / tempo are untouched; only program-change events are rewritten. The
FAITHFUL render keeps the original programs (do not run this for that path).

Remap (family-based, tasteful): the thin electronic voices are lifted to strings and
the slap bass is warmed; piano / vibraphone / choir / real strings / oboe / guitars
are kept so the melodic + bass backbone stays recognizable. Channel 10 (drums,
0-based channel 9) is never remapped.

Usage:  py tools/midi_remap.py <in_dir> <out_dir>
Requires: mido (pip install mido).
"""
import sys, os, glob
import mido

# GM program -> GM program. (General MIDI program numbers, 0-based.)
REMAP = {
    16: 48,   # Drawbar Organ    -> String Ensemble 1
    20: 48,   # Reed Organ       -> String Ensemble 1
    30: 48,   # Distortion Guitar-> String Ensemble 1
    36: 32,   # Slap Bass 1      -> Acoustic Bass (warmer, less synthetic low end)
    88: 49,   # Pad 1 (new age)  -> Slow Strings
    90: 49,   # Pad 3 (warm/poly)-> Slow Strings
}
GM = {0: "Ac.Grand", 6: "Harpsichord", 7: "Clavi", 11: "Vibraphone", 16: "DrawbarOrgan",
      20: "ReedOrgan", 24: "NylonGtr", 30: "DistGtr", 32: "Ac.Bass", 36: "SlapBass",
      48: "Strings", 49: "SlowStrings", 52: "ChoirAahs", 68: "Oboe", 88: "NewAgePad",
      90: "WarmPad"}


def label(p):
    return GM.get(p, f"prog{p}")


def remap_file(src, dst):
    mid = mido.MidiFile(src)
    changes = {}
    for tr in mid.tracks:
        for msg in tr:
            if msg.type == "program_change" and msg.channel != 9:
                if msg.program in REMAP:
                    new = REMAP[msg.program]
                    changes[msg.program] = new
                    msg.program = new
    mid.save(dst)
    tag = ", ".join(f"{label(a)}->{label(b)}" for a, b in sorted(changes.items())) or "(no change)"
    print(f"  {os.path.basename(src):24s} {tag}")


def main():
    if len(sys.argv) < 3:
        print("usage: py tools/midi_remap.py <in_dir> <out_dir>")
        return 1
    in_dir, out_dir = sys.argv[1], sys.argv[2]
    os.makedirs(out_dir, exist_ok=True)
    mids = sorted(glob.glob(os.path.join(in_dir, "*.mid")))
    if not mids:
        print("no .mid files in", in_dir)
        return 1
    print(f"re-orchestrating {len(mids)} tracks -> {out_dir}")
    for f in mids:
        remap_file(f, os.path.join(out_dir, os.path.basename(f)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
