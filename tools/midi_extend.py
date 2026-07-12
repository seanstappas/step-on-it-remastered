#!/usr/bin/env python3
"""Extend a song's MIDI with the Anticipatory Music Transformer (local, GPU). Two modes:
  end    -- append a continuation (a longer outro)
  middle -- insert a new section partway through (expand the song from within)
The song's own instruments are kept; at most `max_extra` NEW melodic instruments are
allowed (drums dropped by default) so it stays close to the original. Render the result
through the faithful studio pipeline to match the studio8 sound. Open weights, no key.

  python tools/midi_extend.py <in.mid> <out.mid> [extend_s] [mode] [max_extra] [model]
  env: AMT_TOPP (default 0.95, lower=more conservative), AMT_DRUMS=1 (keep drums)
"""
import os, sys
os.environ.setdefault("HF_HOME", r"D:\SOI-tools\hf-cache")
import torch
from collections import Counter
from transformers import AutoModelForCausalLM
from anticipation.sample import generate
from anticipation.convert import midi_to_events, events_to_midi
from anticipation import ops

midi_in   = sys.argv[1]
midi_out  = sys.argv[2]
extend_s  = float(sys.argv[3]) if len(sys.argv) > 3 else 30.0
mode      = sys.argv[4] if len(sys.argv) > 4 else "end"          # end | middle
max_extra = int(sys.argv[5]) if len(sys.argv) > 5 else 2
model_id  = sys.argv[6] if len(sys.argv) > 6 else "stanford-crfm/music-large-800k"
win       = 55.0                                                 # AMT context window (<=100s)
top_p     = float(os.environ.get("AMT_TOPP", "0.95"))
keep_drums = os.environ.get("AMT_DRUMS", "0") == "1"
DRUM_CH = 9

print(f"[amt] loading {model_id} (first run downloads to D:) ...", flush=True)
try:
    model = AutoModelForCausalLM.from_pretrained(model_id)
except ValueError:
    # transformers blocks torch.load of legacy .bin on torch<2.6; load weights ourselves
    # (weights_only=True is safe on torch 2.5). The AMT checkpoint is a BARE gpt2 (no
    # "transformer." prefix); its head "token_out_embeddings" is None (tied to wte) ->
    # keep tying, skip it, prefix the rest.
    from transformers import AutoConfig
    from huggingface_hub import hf_hub_download
    cfg = AutoConfig.from_pretrained(model_id)
    model = AutoModelForCausalLM.from_config(cfg)
    raw = torch.load(hf_hub_download(model_id, "pytorch_model.bin"), map_location="cpu", weights_only=True)
    sd = {"transformer." + k: v for k, v in raw.items() if k != "token_out_embeddings" and v is not None}
    miss, unexp = model.load_state_dict(sd, strict=False)
    print(f"[amt] remapped load: {len(miss)} missing / {len(unexp)} unexpected keys", flush=True)
model = model.cuda().eval()

events = midi_to_events(midi_in)
song_end = ops.max_time(events, seconds=True)

# anchor = where the song grows: its end (append) or ~55% in (insert a new middle section)
anchor = song_end if mode == "end" else round(0.55 * song_end, 2)
window_start = max(0.0, anchor - win)
seg = ops.translate(ops.clip(events, window_start, anchor, seconds=True), -window_start, seconds=True)
prompt_end = anchor - window_start
gen_end = min(prompt_end + extend_s, 99.0)
added = gen_end - prompt_end
print(f"[amt] {mode} extend: song {song_end:.1f}s, anchor {anchor:.1f}s, generate {prompt_end:.1f}->{gen_end:.1f}s (+{added:.1f}s, top_p={top_p})", flush=True)

proposal = generate(model, prompt_end, gen_end, inputs=seg, top_p=top_p)
# the new section alone, re-based to start at t=0
cont_local = ops.translate(ops.clip(proposal, prompt_end + 0.01, gen_end, seconds=True), -prompt_end, seconds=True)
cont_mid = events_to_midi(cont_local)

# --- PROPER SPLICE: keep the ORIGINAL midi bit-exact and insert ONLY the new section,
# with its notes mapped onto the song's own channels (by GM program) so the render keeps
# the exact studio8 instruments. Drums dropped unless AMT_DRUMS=1; <= max_extra new insts.
import mido

def read_notes(mf):
    ppq = mf.ticks_per_beat
    tempo = next((m.tempo for tr in mf.tracks for m in tr if m.type == "set_tempo"), 500000)
    tps = ppq * 1e6 / tempo
    prog, notes, stack, tk = {}, [], {}, 0
    for m in mido.merge_tracks(mf.tracks):
        tk += m.time
        if m.type == "program_change":
            prog.setdefault(m.channel, m.program)
        elif m.type == "note_on" and m.velocity > 0:
            stack.setdefault((m.channel, m.note), []).append((tk, m.velocity))
        elif m.type == "note_off" or (m.type == "note_on" and m.velocity == 0):
            s = stack.get((m.channel, m.note))
            if s:
                on, v = s.pop(0); notes.append((on / tps, tk / tps, m.channel, m.note, v))
    return ppq, tempo, tps, prog, notes

ppq, tempo, tps, oprog, onotes = read_notes(mido.MidiFile(midi_in))
_, _, _, cprog, cnotes = read_notes(cont_mid)

prog_to_ch = {}
for ch, p in sorted(oprog.items()):
    prog_to_ch.setdefault(p, ch)
spare = [c for c in range(16) if c != DRUM_CH and c not in oprog]
cmap, extra_prog, nextra = {}, {}, 0
for cch in sorted({n[2] for n in cnotes}):
    p = cprog.get(cch, 0)
    if cch == DRUM_CH and not keep_drums:
        cmap[cch] = None
    elif p in prog_to_ch:
        cmap[cch] = prog_to_ch[p]
    elif nextra < max_extra and spare:
        cmap[cch] = spare[nextra]; extra_prog[spare[nextra]] = p; nextra += 1
    else:
        cmap[cch] = None

final = []
for on, off, ch, pit, v in onotes:
    dt = added if on >= anchor else 0.0        # shift the post-anchor tail later
    final.append((on + dt, off + dt, ch, pit, v))
for on, off, cch, pit, v in cnotes:
    ch = cmap.get(cch)
    if ch is not None:
        final.append((anchor + on, anchor + off, ch, pit, v))

ev = []
for ch, p in {**oprog, **extra_prog}.items():
    ev.append((0, -1, mido.Message("program_change", channel=ch, program=p, time=0)))
for on, off, ch, pit, v in final:
    a = int(round(on * tps)); b = max(int(round(off * tps)), a + 1)
    ev.append((a, 1, mido.Message("note_on", channel=ch, note=pit, velocity=v)))
    ev.append((b, 0, mido.Message("note_off", channel=ch, note=pit, velocity=0)))
ev.sort(key=lambda e: (e[0], e[1]))
out = mido.MidiFile(ticks_per_beat=ppq)
tr = mido.MidiTrack(); out.tracks.append(tr)
tr.append(mido.MetaMessage("set_tempo", tempo=tempo, time=0))
last = 0
for t, _o, m in ev:
    m.time = int(t - last); last = t; tr.append(m)
tr.append(mido.MetaMessage("end_of_track", time=0))
out.save(midi_out)
newlen = max(b for _, b, *_ in final)
print(f"[amt] wrote {midi_out}: {newlen:.1f}s (was {song_end:.1f}s, +{added:.1f}s @ {anchor:.0f}s), "
      f"orig ch {sorted(oprog)}, extras {extra_prog or '{}'}", flush=True)
