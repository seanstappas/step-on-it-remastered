#!/usr/bin/env python3
"""render_music_studio.py -- STUDIO-grade render of the faithful QTMA MIDIs.

Upgrades the single-soundfont render (tools/render_music_epic.ps1) with the
scriptable "make it better" pipeline:

  1. PER-CHANNEL STEMS: the MIDI is split by channel and each instrument is
     rendered separately (FluidSynth, its own reverb OFF) so it can be mixed.
  2. HYBRID SOUNDFONTS: each stem uses the best font for its instrument family
     -- strings / choir / pads -> MuseScore_General (lush); everything else ->
     GeneralUser GS (the base voice). (Add a dedicated piano font in FONT_FOR.)
  3. GENTLE HUMANIZATION: small per-note velocity dither + micro-timing so the
     mechanical QTMA data breathes. Subtle + seeded (deterministic); --no-humanize
     disables it.
  4. REAL PER-PART MIX (ffmpeg): per-stem EQ (carve space) + level + stereo
     placement, summed, with a high-passed convolution-reverb send (synth hall
     impulse response), gentle bus saturation + widening + tone.
  5. MASTER: trim silence -> loudness-match to -14 LUFS -> limiter -> OGG Vorbis.

FIDELITY: notes / timing / tempo / instrument program are unchanged; only the
voicing + mix change (humanization is a sub-perceptual nudge, off-able). This is
the REMASTER voicing, not the original Apple QTMA samples.

Requires: mido, numpy; FluidSynth + ffmpeg/ffprobe. Usage:
  py tools/render_music_studio.py <in_dir> <out_dir> [--no-humanize]
"""
import sys, os, glob, json, math, random, struct, subprocess, tempfile, shutil
import numpy as np
import mido

# ---- tools + soundfonts (D:, off-repo) --------------------------------------
def _find(name, fallback):
    from shutil import which
    return which(name) or (fallback if os.path.exists(fallback) else None)

FS = _find("fluidsynth", r"D:\SOI-tools\fluidsynth\x64\fluidsynth-v2.5.6-win10-x64-glib\bin\fluidsynth.exe")
FF = _find("ffmpeg",  r"D:\Program Files\Tools\ffmpeg.exe")
FP = _find("ffprobe", r"D:\Program Files\Tools\ffprobe.exe")
GUGS = r"D:\SOI-tools\soundfonts\GeneralUser-GS.sf2"
MUSE = r"D:\SOI-tools\soundfonts\MuseScore_General.sf3"
SGM  = r"D:\SOI-tools\soundfonts\SGM-Pro-15.sf2"          # premium balanced GM (SC-88Pro-like)
TOH  = r"D:\SOI-tools\soundfonts\TimbresOfHeaven-4.sf2"    # richest cinematic GM (orchestral/organ)
IR_PATH = r"D:\SOI-tools\soundfonts\hall_ir.wav"
SR = 48000
# Timbres samples are ~12-15 dB hotter than the others -> render its stems quieter
# so the per-family / override gains (tuned at the GeneralUser/SGM level) still balance.
FONT_GAIN = {TOH: 0.15}
FONTSET = "premium"   # "premium" (TOH/SGM) or "legacy" (MuseScore/GeneralUser); --legacy-fonts flips it

# ---- mix plan: GM program family -> (gain dB, pan[-1..1], highpass, lowpass) --
def family(program, channel=None):
    if 32 <= program <= 39:       return dict(gain=1.0,  pan=0.0,  hp=30,  lp=6000)   # bass
    if 0  <= program <= 3:        return dict(gain=0.0,  pan=-0.12, hp=55, lp=15000)  # piano
    if 8  <= program <= 15:       return dict(gain=-1.0, pan=0.25, hp=200, lp=15000)  # vibes/bells
    if 16 <= program <= 23:       return dict(gain=-1.0, pan=0.20, hp=80,  lp=12000)  # organ
    if 24 <= program <= 31:       return dict(gain=-1.0, pan=-0.25,hp=90,  lp=12000)  # guitar
    if 40 <= program <= 47:       return dict(gain=0.0,  pan=0.08, hp=40,  lp=13000)  # orchestral strings/harp
    if 48 <= program <= 51:       return dict(gain=0.0,  pan=0.10, hp=120, lp=14000)  # strings/ensemble
    if 52 <= program <= 55:       return dict(gain=-1.0, pan=-0.10,hp=150, lp=12000)  # choir/voice
    if 56 <= program <= 63:       return dict(gain=0.0,  pan=0.05, hp=100, lp=12000)  # brass
    if 64 <= program <= 79:       return dict(gain=-1.0, pan=0.15, hp=120, lp=13000)  # reed/pipe
    if 88 <= program <= 95:       return dict(gain=-2.0, pan=0.0,  hp=120, lp=12000)  # pads
    return dict(gain=-1.0, pan=0.0, hp=100, lp=14000)

def font_for(program, channel=None):
    if FONTSET == "gugs":
        return GUGS                                   # thin/basic GM everywhere (closest to the retro QTMA synth)
    if FONTSET == "legacy":
        # reproduce the pre-premium palette (MuseScore sustained, GeneralUser else)
        if 16 <= program <= 23: return MUSE
        if 40 <= program <= 55: return MUSE
        if 56 <= program <= 63: return MUSE
        if 64 <= program <= 79: return MUSE
        if 88 <= program <= 95: return MUSE
        return GUGS
    # premium (default): cinematic families -> Timbres of Heaven 4.00, rest -> SGM Pro
    if 16 <= program <= 23: return TOH                # organ
    if 40 <= program <= 55: return TOH                # orchestral + ensemble strings, choir/voice
    if 56 <= program <= 63: return TOH                # brass
    if 64 <= program <= 79: return TOH                # reed / pipe
    if 88 <= program <= 95: return TOH                # synth pads
    return SGM                                        # piano, bass, guitars, vibes, leads (premium GM)

def sustained(program):
    """GM families that benefit from a subtle ensemble chorus: adds width + slow
    movement so a single sample stops sounding like one sterile MIDI voice."""
    return (16 <= program <= 23 or 40 <= program <= 79 or 88 <= program <= 95)

# ---- per-track voicing overrides -------------------------------------------
# Value per channel is either an int (GM program, keep family mix) or a dict
# {prog, gain, pan, hp, lp} to also override the mix. The QTMA extraction maps each
# part straight to a channel (part & 0x0F) with faithful NOTES but an approximate
# instrument; these fix clear timbre mismatches vs the composer's reference
# recordings (refs/music/). Notes/timing unchanged.
_BFL_LEAD = int(os.environ.get("SOI_BFL_LEAD", "81"))   # A/B hook for the bass_for_lunch lead
OVERRIDES = {
    # bass_for_lunch: the LOUD sustained lead moves across channels; render those as a
    # sawtooth synth lead + legato (connect sustained notes) + a velocity FLOOR (so no
    # lead note is too quiet / inaudible). ch2 = main lead; ch1 = 0:38 transition (was
    # oboe); ch11 = 1:03 high lead. ch12 = the high 80/81 DRONE -> kept quiet/background
    # (the ~0:55 part the user wants NOT loud). Onsets/pitches unchanged.
    # emphasis_window restricts sustain_emphasis ducking to the 1:04-1:28 busy "crazy run"
    # (so the sparser 0:33 + 0:43 lead phrases stay FULL); duck_before backgrounds the
    # single sustained E5 intro note on ch11 (user: intro sustain should sit back).
    "bass_for_lunch": {
        0:  {"gain": -1.0},                                                                                  # clavi (slightly back)
        1:  {"prog": _BFL_LEAD, "gain": 4.0,  "pan": -0.10, "hp": 200, "lp": 16000, "legato": True, "vel_floor": 100, "sustain_emphasis": 0.55},
        2:  {"prog": _BFL_LEAD, "gain": 4.0,  "pan": 0.0,   "hp": 160, "lp": 16000, "legato": True, "vel_floor": 100, "sustain_emphasis": 0.55, "emphasis_window": (60.0, 90.0)},
        6:  {"drum": True, "gain": 1.0, "pan": 0.0},                                                          # end percussive pulse -> real drums
        8:  {"gain": 2.0},                                                                                   # mid piano = the MIDDLE content -> up
        9:  {"gain": 2.0},
        10: {"gain": 2.0},
        11: {"prog": _BFL_LEAD, "gain": 5.0,  "pan": -0.18, "hp": 200, "lp": 16000, "legato": True, "vel_floor": 100, "duck_before": (18.0, 0.4)},   # 1:08 SUSTAIN dominant; intro E5 ducked -> background
        12: {"prog": _BFL_LEAD, "gain": -1.0, "pan": 0.18,  "hp": 300, "lp": 15000, "legato": True, "sustain_emphasis": 0.5},
        # NOTE: the 0:47 descending phrase (ch2 D5->E5->F#5->B5->A5 -> sustained B5, plus
        # ch0 E4/B4/E5 harmony) is now present in the extraction after fixing the QTMA
        # Extended-Note (top==4) parser bug in tools/qtma_to_midi.py. No inject needed.
    },
    # 6lilt: ch5 is a single repeated D2 (117 hits) the tune header labels "grand piano",
    # but ch4 already holds the low C2 pulse -> ch5 is a PERCUSSION ostinato. Render it as
    # a rattly shaker (GM Maracas 70) instead of a dull piano note (user: "rattly instrument").
    "6lilt": {
        5: {"drum": True, "drum_note": 70, "gain": 1.0},
    },
    # spooky: the tune header's real instruments are String Ensemble (ch0), Aah Choir (ch1),
    # SITAR (ch2, GM104), REVERSE CYMBAL (ch3, GM119) and AGOGO (ch4, GM113) -- "Sitar/
    # Reverse Cymbal/Agogo" weren't in qtma_to_midi's GM name table so they FELL BACK to
    # grand piano (the "wrong instruments" root cause; fixed the table + re-extracted).
    # BUT spooky has 10 note-parts and only 5 note-requests (each polyphony 1 = parts 0-4);
    # parts 5-9 have NO instrument in the QTMA data and default to piano. Half the track --
    # incl. ch9, the main 114-note low melody -- was piano. RECONSTRUCTED parts 5-9 by role
    # (the single-pitch ticks ch5/ch6/ch8 = more sitar/agogo like their siblings; the
    # melodic ch7/ch9 = strings like ch0). ch0/ch9 hp=30 keeps the deep sub the real game has.
    "spooky": {
        0: {"gain": 3.0, "hp": 30},                 # strings bed (48) -> louder background + deep sub
        1: {"gain": 3.0},                           # choir -> louder background
        2: {"gain": -1.0, "lp": 2800},              # SITAR -> DARK (lp keeps it from cutting through), present
        3: {"gain": -8.0, "lp": 2500},              # REVERSE CYMBAL (noise swell) -> well down + dark
        4: {"gain": 3.0, "lp": 4000},               # agogo -> up (the warm prominent percussive) + darken
        5: {"prog": 104, "gain": -1.0, "lp": 2800}, # part5 tick -> Sitar (dark)
        6: {"prog": 104, "gain": -1.0, "lp": 2800}, # part6 tick -> Sitar (dark)
        7: {"prog": 48, "gain": 2.0},               # part7 melody -> Strings
        8: {"prog": 113, "gain": 3.0, "lp": 4000},  # part8 -> Agogo (up + dark)
        9: {"prog": 48, "gain": 2.0, "hp": 30},     # part9 low melody -> Strings, keep deep sub
    },
    # spooky_thin: same instrument fix via re-extraction (String Ensemble + Sitar/Reverse
    # Cymbal/Agogo now correct); reconstruct the unrequested parts' melodic line as strings.
    "spooky_thin": {
        0: {"hp": 30},   # low bed -> keep the deep sub
    },
    # AMT MIDI extensions (tools/midi_extend.py) follow GM: channel 9 = drums. The QTMA
    # tracks never use ch9 as drums, so this override is scoped to the *_ext names.
    "Cminor_ext": {
        9: {"drum": True, "gain": -1.0},
    },
}

# ---- 70s PROG-ROCK re-orchestration (opt-in via --prog; NOT the faithful render) -----
# Re-voices each song into an "epic prog" arrangement -- rock/Hammond organ, Mellotron
# strings + choir, Moog saw lead, sustained overdrive guitar, rock bass, and the
# single-note percussion parts turned into a drum groove. Notes/timing/tempo unchanged;
# only the instrument (program) per channel + a few gains differ. Style: Genesis / Yes /
# Pink Floyd / Wakeman. Channel roles came from inspecting each MIDI (lead/bass/pad).
PROG_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 18, "vel_floor": 80},                 # busy vibraphone body -> Rock Organ (loud start, no fade)
        1:  {"prog": 48, "gain": 2.0, "vel_floor": 64},    # new-age pad -> Mellotron strings (lift the soft intro)
        2:  {"prog": 52, "gain": 2.0, "vel_floor": 64},    # low choir -> Mellotron choir (drama)
    },
    "6lilt": {
        0:  {"prog": 18, "boost_after": (170.0, 1.25)},                  # piano chords -> Rock Organ (swell to finish)
        1:  {"prog": 81, "gain": 1.0, "boost_after": (170.0, 1.35)},     # high slap-bass lead -> Moog saw lead (epic end)
        2:  {"prog": 29, "boost_after": (170.0, 1.25)},                  # counter-line -> Overdriven Guitar (sustained)
        3:  {"prog": 48, "gain": 1.0, "boost_after": (170.0, 1.35)},     # high poly pad -> Mellotron strings (big end swell)
        4:  {"prog": 33},                    # low reed-organ line -> Finger Bass
        5:  {"drum": True, "drum_note": 54}, # single-D2 ostinato -> Tambourine
    },
    "bass_for_lunch": {
        0:  {"prog": 4, "boost_after": (85.0, 1.40)},       # clavi -> Rhodes E.piano (joins the crescendo)
        1:  {"prog": 73, "boost_after": (85.0, 1.40)},      # oboe lead -> Mellotron flute
        2:  {"prog": 29, "legato": True, "gain": 1.0, "boost_after": (85.0, 1.55)},   # main lead -> sustained Overdrive Guitar (Hackett)
        3:  {"prog": 33, "boost_after": (85.0, 1.40)},      # slap bass -> Finger Bass (drives the climax)
        4:  {"drum": True, "drum_note": 42, "boost_after": (85.0, 1.45)}, # single-D2 -> closed hi-hat (harder at end)
        5:  {"drum": True, "drum_note": 42, "boost_after": (85.0, 1.45)},
        6:  {"drum": True, "drum_note": 38, "boost_after": (85.0, 1.45)}, # -> snare (harder at end)
        7:  {"prog": 16, "boost_after": (85.0, 1.40)},      # low pulse -> organ pedal
        8:  {"prog": 18, "boost_after": (85.0, 1.40)},      # mid -> Rock Organ (full at end)
        9:  {"prog": 18, "boost_after": (85.0, 1.40)},
        10: {"prog": 4, "boost_after": (85.0, 1.40)},       # mid -> Rhodes
        11: {"prog": 29, "legato": True, "gain": 3.0, "boost_after": (85.0, 1.60)},  # high lead / ~1:40 climax -> soaring Overdrive Guitar, epic
        12: {"prog": 48, "gain": 2.5, "boost_after": (85.0, 1.60)},   # high sustained -> Mellotron strings (huge swell)
    },
}

# ---- PROG-ROCK v2 = MORE EPIC (--prog2): bigger convolution reverb + louder leads/pads
# + longer, earlier crescendos so the whole back half swells. Same instrument palette.
PROG2_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 18, "vel_floor": 88, "boost_after": (55.0, 1.35)},                 # rock organ, big second-half swell
        1:  {"prog": 48, "gain": 3.5, "vel_floor": 74, "boost_after": (55.0, 1.45)},    # Mellotron strings, huge
        2:  {"prog": 52, "gain": 3.5, "vel_floor": 74, "boost_after": (55.0, 1.45)},    # Mellotron choir, huge
    },
    "6lilt": {
        0:  {"prog": 18, "vel_floor": 84, "boost_after": (120.0, 1.40)},
        1:  {"prog": 81, "gain": 2.5, "boost_after": (120.0, 1.50)},                    # Moog lead, big
        2:  {"prog": 29, "gain": 1.5, "boost_after": (120.0, 1.40)},                    # overdrive guitar
        3:  {"prog": 48, "gain": 2.5, "boost_after": (120.0, 1.50)},                    # Mellotron strings, huge end swell
        4:  {"prog": 33, "boost_after": (120.0, 1.35)},                                 # bass
        5:  {"drum": True, "drum_note": 54},                                            # tambourine
    },
    "bass_for_lunch": {
        0:  {"prog": 4, "boost_after": (70.0, 1.45)},
        1:  {"prog": 73, "boost_after": (70.0, 1.45)},
        2:  {"prog": 29, "legato": True, "gain": 1.5, "boost_after": (70.0, 1.65)},     # guitar lead
        3:  {"prog": 33, "boost_after": (70.0, 1.45)},
        4:  {"drum": True, "drum_note": 42, "boost_after": (70.0, 1.50)},
        5:  {"drum": True, "drum_note": 42, "boost_after": (70.0, 1.50)},
        6:  {"drum": True, "drum_note": 38, "boost_after": (70.0, 1.50)},
        7:  {"prog": 16, "boost_after": (70.0, 1.45)},
        8:  {"prog": 18, "boost_after": (70.0, 1.45)},
        9:  {"prog": 18, "boost_after": (70.0, 1.45)},
        10: {"prog": 4, "boost_after": (70.0, 1.45)},
        11: {"prog": 29, "legato": True, "gain": 3.5, "boost_after": (70.0, 1.75)},    # soaring guitar climax
        12: {"prog": 48, "gain": 3.0, "boost_after": (70.0, 1.75)},                     # Mellotron strings, massive
    },
}

# ---- PROG-ROCK v3 = EPIC + LOUD, big END CRESCENDO (--prog3): everything ramps up into
# a huge finish (crescendo = velocity x1 -> xN across the last stretch), bigger reverb,
# and a hotter -11.5 LUFS master. Same palette as v2, cranked, climaxing at the end.
PROG3_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 18, "vel_floor": 90, "crescendo": (100.0, 1.8)},                  # rock organ builds to the end
        1:  {"prog": 48, "gain": 4.0, "vel_floor": 78, "crescendo": (100.0, 1.9)},     # Mellotron strings, massive climax
        2:  {"prog": 52, "gain": 4.0, "vel_floor": 78, "crescendo": (100.0, 1.9)},     # Mellotron choir, massive climax
    },
    "6lilt": {
        0:  {"prog": 18, "vel_floor": 88, "crescendo": (150.0, 1.7)},
        1:  {"prog": 81, "gain": 3.0, "crescendo": (150.0, 1.9)},                       # Moog lead soars into the finish
        2:  {"prog": 29, "gain": 2.0, "crescendo": (150.0, 1.8)},                       # overdrive guitar
        3:  {"prog": 48, "gain": 3.0, "crescendo": (150.0, 1.9)},                       # Mellotron strings, huge end
        4:  {"prog": 33, "crescendo": (150.0, 1.6)},                                    # bass
        5:  {"drum": True, "drum_note": 54},                                            # tambourine
    },
    "bass_for_lunch": {
        0:  {"prog": 4, "crescendo": (88.0, 1.7)},
        1:  {"prog": 73, "crescendo": (88.0, 1.7)},
        2:  {"prog": 29, "legato": True, "gain": 2.0, "crescendo": (88.0, 1.9)},        # guitar lead
        3:  {"prog": 33, "crescendo": (88.0, 1.7)},
        4:  {"drum": True, "drum_note": 42, "crescendo": (88.0, 1.8)},
        5:  {"drum": True, "drum_note": 42, "crescendo": (88.0, 1.8)},
        6:  {"drum": True, "drum_note": 38, "crescendo": (88.0, 1.8)},
        7:  {"prog": 16, "crescendo": (88.0, 1.7)},
        8:  {"prog": 18, "crescendo": (88.0, 1.7)},
        9:  {"prog": 18, "crescendo": (88.0, 1.7)},
        10: {"prog": 4, "crescendo": (88.0, 1.7)},
        11: {"prog": 29, "legato": True, "gain": 4.0, "crescendo": (88.0, 2.0)},        # soaring guitar, huge climax
        12: {"prog": 48, "gain": 3.5, "crescendo": (88.0, 2.0)},                        # Mellotron strings, massive
    },
}
# ---- ORGAN variant (--organ): organ-LED re-orchestration. Cminor becomes a
# Hans Zimmer-style wall of epic pipe/church organ (two layers) + choir; the two
# organs are panned apart so the busy arps and the sustained chord bed don't mud.
# bass_for_lunch is rebuilt around rock + church organ instead of Rhodes / guitar.
# Church Organ (19) + the drawbar organs route to the lusher MuseScore font and
# get the ensemble chorus (sustained()), and the mix uses the biggest convolution
# reverb (0.55) for cathedral depth. Same faithful notes / timing / tempo.
PROG_ORGAN_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 19, "pan": 0.14,  "vel_floor": 92, "crescendo": (95.0, 1.85)},                # running arps -> Church (pipe) Organ, the epic lead
        1:  {"prog": 19, "pan": -0.16, "gain": 1.5, "vel_floor": 82, "crescendo": (95.0, 1.9)},    # pad chords -> huge sustained Church Organ bed (Zimmer wall)
        2:  {"prog": 52, "gain": 3.0, "vel_floor": 80, "crescendo": (95.0, 1.9)},                  # low choir -> massive choral drama over the organ
    },
    "6lilt": {
        0:  {"prog": 19, "vel_floor": 88, "crescendo": (150.0, 1.7)},                              # piano chords -> Church Organ
        1:  {"prog": 18, "gain": 1.5, "crescendo": (150.0, 1.9)},                                  # lead -> Rock Organ (drawbar bite)
        2:  {"prog": 19, "crescendo": (150.0, 1.8)},                                               # counter-line -> Church Organ
        3:  {"prog": 48, "gain": 2.5, "crescendo": (150.0, 1.9)},                                  # pad -> Mellotron strings (support)
        4:  {"prog": 33, "crescendo": (150.0, 1.6)},                                               # bass
        5:  {"drum": True, "drum_note": 54},                                                       # tambourine
    },
    "bass_for_lunch": {
        0:  {"prog": 18, "crescendo": (88.0, 1.7)},                                                # clavi -> Rock Organ
        1:  {"prog": 19, "crescendo": (88.0, 1.7)},                                                # oboe -> Church Organ line
        2:  {"prog": 18, "legato": True, "gain": 1.5, "crescendo": (88.0, 1.9)},                   # main lead -> Rock Organ (drawbar lead)
        3:  {"prog": 33, "crescendo": (88.0, 1.7)},                                                # slap bass stays -> Finger Bass (drives it)
        4:  {"drum": True, "drum_note": 42, "crescendo": (88.0, 1.8)},                             # hats
        5:  {"drum": True, "drum_note": 42, "crescendo": (88.0, 1.8)},
        6:  {"drum": True, "drum_note": 38, "crescendo": (88.0, 1.8)},                             # snare
        7:  {"prog": 16, "crescendo": (88.0, 1.7)},                                                # low pulse -> organ pedal (drawbar)
        8:  {"prog": 18, "crescendo": (88.0, 1.7)},                                                # mid -> Rock Organ
        9:  {"prog": 19, "crescendo": (88.0, 1.7)},                                                # mid -> Church Organ layer
        10: {"prog": 18, "crescendo": (88.0, 1.7)},                                                # mid -> Rock Organ (was Rhodes)
        11: {"prog": 18, "legato": True, "gain": 3.0, "crescendo": (88.0, 2.0)},                   # high lead / climax -> soaring Rock Organ
        12: {"prog": 19, "gain": 2.5, "crescendo": (88.0, 2.0)},                                   # high sustained -> Church Organ (huge)
    },
}

# ---- CATHEDRAL organ (--organ2): the organ variant taken to 11. Adds a SUB-OCTAVE
# organ pedal (octave [-12]) for the deep Zimmer rumble, an upper-octave shimmer on
# the arps, a basso-profundo choir, the biggest reverb (0.62) and the hottest master
# (-11 LUFS), with the crescendo starting earlier + ramping harder (x2.0).
PROG_ORGAN2_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 19, "pan": 0.12,  "vel_floor": 96, "crescendo": (90.0, 2.0), "octave": [12]},                # arps + upper-octave shimmer
        1:  {"prog": 19, "pan": -0.14, "gain": 2.0, "vel_floor": 88, "crescendo": (90.0, 2.0), "octave": [-12]},  # sustained bed + SUB-octave pedal (rumble)
        2:  {"prog": 52, "gain": 3.5, "vel_floor": 86, "crescendo": (90.0, 2.0), "octave": [-12]},                # choir + basso profundo
    },
    "6lilt": {
        0:  {"prog": 19, "vel_floor": 90, "crescendo": (140.0, 1.9), "octave": [-12]},                            # church organ + sub
        1:  {"prog": 18, "gain": 2.0, "crescendo": (140.0, 2.0)},                                                 # rock organ lead
        2:  {"prog": 19, "crescendo": (140.0, 1.9)},                                                              # church organ counter
        3:  {"prog": 48, "gain": 3.0, "crescendo": (140.0, 2.0), "octave": [12]},                                 # strings + octave
        4:  {"prog": 32, "crescendo": (140.0, 1.7), "octave": [-12]},                                             # bass + sub
        5:  {"drum": True, "drum_note": 54},                                                                      # tambourine
    },
    "bass_for_lunch": {
        0:  {"prog": 18, "crescendo": (85.0, 1.8)},                                                               # rock organ
        1:  {"prog": 19, "crescendo": (85.0, 1.8)},                                                               # church organ
        2:  {"prog": 18, "legato": True, "gain": 1.8, "crescendo": (85.0, 2.0)},                                  # rock organ lead
        3:  {"prog": 33, "crescendo": (85.0, 1.8), "octave": [-12]},                                              # finger bass + sub
        4:  {"drum": True, "drum_note": 42, "crescendo": (85.0, 1.9)},                                            # hats
        5:  {"drum": True, "drum_note": 42, "crescendo": (85.0, 1.9)},
        6:  {"drum": True, "drum_note": 35, "crescendo": (85.0, 1.9)},                                            # deep kick
        7:  {"prog": 16, "crescendo": (85.0, 1.8), "octave": [-12]},                                              # organ pedal + sub
        8:  {"prog": 18, "crescendo": (85.0, 1.8)},                                                               # rock organ
        9:  {"prog": 19, "crescendo": (85.0, 1.8), "octave": [12]},                                               # church organ + shimmer
        10: {"prog": 18, "crescendo": (85.0, 1.8)},                                                               # rock organ
        11: {"prog": 18, "legato": True, "gain": 3.2, "crescendo": (85.0, 2.1)},                                  # soaring rock organ climax
        12: {"prog": 19, "gain": 2.8, "crescendo": (85.0, 2.1), "octave": [12]},                                 # church organ high + shimmer
    },
}

# ---- SYMPHONIC epic (--prog4): a full FILM-ORCHESTRA re-orchestration -- string
# ostinati, French horns + brass section, choir, church organ pad, contrabass/celli
# with a sub-octave, and TIMPANI / gran-cassa on the percussion channels. Big reverb
# (0.58), -11.5 LUFS, everything crescendos into the finish. Faithful notes/timing.
PROG4_OVERRIDES = {
    "Cminor": {
        0:  {"prog": 48, "pan": 0.10,  "gain": 1.0, "vel_floor": 88, "crescendo": (90.0, 2.0), "octave": [12]},  # running string ostinato (+ octave = Zimmer runs)
        1:  {"prog": 19, "pan": -0.12, "gain": 1.5, "vel_floor": 80, "crescendo": (90.0, 2.0), "octave": [-12]}, # church organ bed + sub
        2:  {"prog": 52, "gain": 3.5, "vel_floor": 82, "crescendo": (90.0, 2.0)},                                # choir
    },
    "6lilt": {
        0:  {"prog": 48, "gain": 1.5, "crescendo": (140.0, 2.0), "octave": [12]},                                # strings
        1:  {"prog": 61, "gain": 1.5, "crescendo": (140.0, 2.0)},                                                # brass section lead
        2:  {"prog": 60, "crescendo": (140.0, 1.9)},                                                             # French horn counter
        3:  {"prog": 52, "gain": 2.5, "crescendo": (140.0, 2.0)},                                                # choir pad
        4:  {"prog": 42, "crescendo": (140.0, 1.7), "octave": [-12]},                                            # celli + sub
        5:  {"drum": True, "drum_note": 47},                                                                     # timpani
    },
    "bass_for_lunch": {
        0:  {"prog": 48, "crescendo": (85.0, 1.9)},                                                              # strings
        1:  {"prog": 60, "crescendo": (85.0, 1.9)},                                                              # French horn
        2:  {"prog": 61, "legato": True, "gain": 1.8, "crescendo": (85.0, 2.1)},                                 # brass lead
        3:  {"prog": 43, "crescendo": (85.0, 1.9), "octave": [-12]},                                             # contrabass + sub
        4:  {"drum": True, "drum_note": 47, "crescendo": (85.0, 2.0)},                                           # timpani
        5:  {"drum": True, "drum_note": 47, "crescendo": (85.0, 2.0)},
        6:  {"drum": True, "drum_note": 35, "crescendo": (85.0, 2.0)},                                           # gran cassa (deep kick)
        7:  {"prog": 42, "crescendo": (85.0, 1.9), "octave": [-12]},                                             # celli + sub
        8:  {"prog": 48, "crescendo": (85.0, 1.9)},                                                              # strings
        9:  {"prog": 19, "crescendo": (85.0, 1.9)},                                                              # church organ
        10: {"prog": 48, "crescendo": (85.0, 1.9)},                                                             # strings
        11: {"prog": 61, "legato": True, "gain": 3.0, "crescendo": (85.0, 2.2)},                                 # brass climax
        12: {"prog": 52, "gain": 2.8, "crescendo": (85.0, 2.2), "octave": [12]},                                # choir + octave
    },
}
# ---- synth stereo hall impulse response (cached) ----------------------------
def make_hall_ir(path):
    if os.path.exists(path):
        return path
    os.makedirs(os.path.dirname(path), exist_ok=True)
    rng = np.random.RandomState(7)
    n = int(1.8 * SR)
    t = np.arange(n) / SR
    def one(seed):
        r = np.random.RandomState(seed)
        tail = r.uniform(-1, 1, n) * np.exp(-t * 3.6)           # ~1.6s RT60 diffuse tail
        # early reflections: a few discrete taps in the first 70 ms
        er = np.zeros(n)
        for _ in range(12):
            d = int(r.uniform(0.005, 0.07) * SR)
            er[d] += r.uniform(0.3, 0.9) * (1 - d / (0.07 * SR))
        sig = 0.6 * er + tail
        # smooth (air absorption: gentle low-pass via moving average)
        k = 8
        sig = np.convolve(sig, np.ones(k) / k, mode="same")
        return sig.astype(np.float32)
    L, R = one(11), one(23)                                     # decorrelated L/R
    ir = np.stack([L, R], axis=1)
    ir /= np.max(np.abs(ir)) + 1e-9
    ir *= 0.9
    _write_wav(path, ir)
    return path

def _write_wav(path, stereo_float):
    x = np.clip(stereo_float, -1, 1)
    inter = (x * 32767).astype("<i2").tobytes()
    with open(path, "wb") as f:
        data = inter
        f.write(b"RIFF"); f.write(struct.pack("<I", 36 + len(data))); f.write(b"WAVE")
        f.write(b"fmt "); f.write(struct.pack("<IHHIIHH", 16, 1, 2, SR, SR * 4, 4, 16))
        f.write(b"data"); f.write(struct.pack("<I", len(data))); f.write(data)

# ---- MIDI split + humanize ---------------------------------------------------
def channel_programs(mid):
    prog, first = {}, {}
    t = 0
    for msg in mido.merge_tracks(mid.tracks):
        t += msg.time
        if msg.type == "program_change":
            first.setdefault(msg.channel, msg.program)
    return first

def split_stems(mid, humanize, prog_ovr, legato_set=frozenset(), vel_floor_map=None,
                emphasis_map=None, drum_set=frozenset(), seed=1234,
                emphasis_window_map=None, duck_map=None, drum_note_map=None, boost_map=None,
                crescendo_map=None, octave_map=None):
    """Split into single-channel stems, each rendered melodically on MIDI channel 0 with
    ONE forced program_change (effective program = override or the channel's own program)
    -- so nothing is forced onto the GM drum bank (the QTMA extraction maps parts to
    channels blindly, incl. ch9, which is NOT drums here). Channels in legato_set get
    each SUSTAINED note's OFF extended to the next onset (fills gaps -> continuous), but
    short/fast notes and the final note are left alone. vel_floor_map raises a channel's
    note velocities to a floor (uniformly loud lead). Onsets and pitches are unchanged.
    Returns (stems{orig_ch: MidiFile}, eff_prog{orig_ch: program})."""
    import bisect
    vel_floor_map = vel_floor_map or {}
    emphasis_map = emphasis_map or {}
    emphasis_window_map = emphasis_window_map or {}
    duck_map = duck_map or {}
    drum_note_map = drum_note_map or {}
    boost_map = boost_map or {}
    crescendo_map = crescendo_map or {}
    octave_map = octave_map or {}
    tps = mid.ticks_per_beat * 1e6 / _first_tempo(mid)   # ticks/sec, for time-scoped velocity
    merged = mido.merge_tracks(mid.tracks)
    abs_ev, t = [], 0
    for msg in merged:
        t += msg.time
        abs_ev.append((t, msg))
    ppq = mid.ticks_per_beat
    song_end_s = max((at for (at, m) in abs_ev if m.type == "note_on" and m.velocity > 0), default=0) / tps
    jit = max(1, int(round(ppq / 500.0 * 1.5)))          # ~1.5 ms in ticks (@120bpm ref)
    cap = ppq * 2                                        # max legato extension = 2 beats
    firstprog = {}
    for (_at, m) in abs_ev:
        if m.type == "program_change":
            firstprog.setdefault(m.channel, m.program)
    meta = [(at, m) for (at, m) in abs_ev if m.is_meta and m.type != "end_of_track"]
    chans = sorted({m.channel for _, m in abs_ev if hasattr(m, "channel")})
    stems, effp = {}, {}
    for ch in chans:
        eff = prog_ovr.get(ch, firstprog.get(ch, 0))
        effp[ch] = eff
        floor = vel_floor_map.get(ch, 0)
        emph = emphasis_map.get(ch)           # if set: short/fast notes get quieter (loud = sustain)
        ewin = emphasis_window_map.get(ch)    # (t0,t1) sec: restrict emphasis ducking to this window
        duck = duck_map.get(ch)               # (t,f) sec: notes before t scaled by f (intro -> background)
        boost = boost_map.get(ch)             # (t,f) sec: notes AT/after t scaled by f (climax swell)
        cres = crescendo_map.get(ch)          # (t,f) sec: velocity RAMPS x1->xf from t to song end (climax)
        min_sus = int(ppq * 0.4)
        rng = random.Random(seed + ch * 101)
        # pair note_on/note_off for this channel -> [on, off, pitch, vel]
        active, notes = {}, []
        for (at, m) in abs_ev:
            if getattr(m, "channel", None) != ch:
                continue
            if m.type == "note_on" and m.velocity > 0:
                v, a = m.velocity, at
                if humanize:
                    v = max(1, min(127, int(round(v * (1.0 + rng.uniform(-0.06, 0.06))))))
                    a = max(0, at + rng.randint(-jit, jit))
                active.setdefault(m.note, []).append([a, None, v])
            elif m.type == "note_off" or (m.type == "note_on" and m.velocity == 0):
                for nt in active.get(m.note, []):
                    if nt[1] is None:
                        nt[1] = at
                        break
        for pitch, lst in active.items():
            for on, off, v in lst:
                off = max((on + ppq) if off is None else off, on + 1)
                onset_s = on / tps
                v = max(v, floor)
                if emph is not None and (off - on) < min_sus and (ewin is None or ewin[0] <= onset_s < ewin[1]):
                    v = max(1, int(round(v * emph)))     # fast/short note (in window) -> quieter
                if duck is not None and onset_s < duck[0]:
                    v = max(1, int(round(v * duck[1])))  # intro / early section -> background
                if boost is not None and onset_s >= boost[0]:
                    v = min(127, int(round(v * boost[1])))  # end-section climax swell (louder)
                if cres is not None and onset_s >= cres[0]:
                    frac = min(1.0, (onset_s - cres[0]) / max(0.5, song_end_s - cres[0]))
                    v = min(127, int(round(v * (1.0 + (cres[1] - 1.0) * frac))))  # progressive climax to the end
                notes.append([on, off, pitch, v])
        notes.sort(key=lambda n: n[0])
        if ch in legato_set and notes:
            onsets = sorted({n[0] for n in notes})
            for n in notes:
                if (n[1] - n[0]) < min_sus:
                    continue
                i = bisect.bisect_right(onsets, n[0])
                if i >= len(onsets):          # last onset -> keep natural end (no trailing sustain)
                    continue
                n[1] = max(n[1], min(onsets[i], n[0] + cap))
        # emit (note_off before note_on at the same tick for clean retrigger). Drum
        # channels render on GM channel 9 (percussion bank); everything else on ch0.
        out_ch = 9 if ch in drum_set else 0
        dnote = drum_note_map.get(ch)     # remap every hit to one GM percussion note (e.g. shaker)
        octs = octave_map.get(ch, [])     # add octave copies (epic fatten: [-12]=sub, [12]=shimmer)
        ev = [(at, 0, m.copy()) for (at, m) in meta]
        for on, off, pitch, v in notes:
            pout = dnote if dnote is not None else pitch
            ev.append((on, 1, mido.Message("note_on", channel=out_ch, note=pout, velocity=v)))
            ev.append((off, 0, mido.Message("note_off", channel=out_ch, note=pout, velocity=0)))
            if dnote is None:
                for off_semi in octs:
                    p2 = pout + off_semi
                    if 0 <= p2 <= 127:
                        v2 = max(1, int(round(v * 0.82)))    # doubles a touch softer than the root
                        ev.append((on, 1, mido.Message("note_on", channel=out_ch, note=p2, velocity=v2)))
                        ev.append((off, 0, mido.Message("note_off", channel=out_ch, note=p2, velocity=0)))
        # carry pitch-bend automation (QTMA controller 32) onto the stem channel so the
        # slide/vibrato on the sustain lead comes through (bends aren't humanized/jittered)
        for (at, m) in abs_ev:
            if getattr(m, "channel", None) == ch and m.type == "pitchwheel":
                ev.append((at, 1, mido.Message("pitchwheel", channel=out_ch, pitch=m.pitch)))
        ev.sort(key=lambda x: (x[0], x[1]))
        out = mido.MidiFile(ticks_per_beat=ppq)
        tr = mido.MidiTrack(); out.tracks.append(tr)
        tr.append(mido.Message("program_change", channel=out_ch, program=eff, time=0))
        last = 0
        for (at, _o, m2) in ev:
            m2.time = int(at - last); last = at; tr.append(m2)
        tr.append(mido.MetaMessage("end_of_track", time=0))
        stems[ch] = out
    return stems, effp

# ---- render + mix ------------------------------------------------------------
def run(cmd):
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    return p.stdout.decode("utf-8", "replace")

def render_stem(mid_path, font, wav_path, chorus=False):
    # per-stem: FluidSynth reverb OFF (reverb is added on the mix bus). An optional
    # subtle chorus gives sustained voices (organ / strings / choir / pads) an
    # ensemble width + slow movement, so they read as real players not one MIDI note.
    cx = (["-C", "1", "-o", "synth.chorus.nr=3", "-o", "synth.chorus.level=0.8",
           "-o", "synth.chorus.speed=0.22", "-o", "synth.chorus.depth=6.5"]
          if chorus else ["-C", "0"])
    run([FS, "-ni", "-F", wav_path, "-r", str(SR), "-O", "float", "-g", str(FONT_GAIN.get(font, 0.6)),
         "-o", "synth.polyphony=256", "-R", "0", *cx, font, mid_path])
    return os.path.exists(wav_path) and os.path.getsize(wav_path) > 1024

def mix_and_master(stems_info, ir, out_ogg, tmp, reverb=0.26, lufs=-14.0, refmatch=False):
    """stems_info: list of (wav_path, family_dict). Build ffmpeg mix + master."""
    premix = os.path.join(tmp, "premix.wav")
    inputs, filt, labels = [], [], []
    for i, (wav, fam) in enumerate(stems_info):
        inputs += ["-i", wav]
        gl = 1.0 + min(fam["pan"], 0.0)          # linear balance (no level boost)
        gr = 1.0 - max(fam["pan"], 0.0)
        chain = []
        if fam["hp"] > 0: chain.append(f"highpass=f={fam['hp']}")
        chain.append(f"lowpass=f={fam['lp']}")
        chain.append(f"volume={fam['gain']}dB")
        chain.append(f"pan=stereo|c0={gl:.3f}*c0|c1={gr:.3f}*c1")
        filt.append(f"[{i}:a]" + ",".join(chain) + f"[s{i}]")
        labels.append(f"[s{i}]")
    n = len(stems_info)
    inputs += ["-i", ir]; ir_idx = n
    if n > 1:
        filt.append("".join(labels) + f"amix=inputs={n}:normalize=0[dry]")
    else:
        filt.append(f"{labels[0]}anull[dry]")
    # high-passed convolution-reverb send (keeps bass/kick out of the hall -> no mud)
    filt.append("[dry]asplit=2[dryA][dryB]")
    filt.append("[dryB]highpass=f=250[revsrc]")
    filt.append(f"[revsrc][{ir_idx}:a]afir=dry=0:wet=1:maxir=2:gtype=gn[wet]")
    filt.append(f"[dryA][wet]amix=inputs=2:weights=1 {reverb}:normalize=0[bus]")
    # bus polish: gentle tone tilt, subtle tanh saturation, mild widen, trim silence,
    # then dynaudnorm loudness-levelling so quiet passages come up to a consistent,
    # loud level (matches the composer's heavily-compressed originals).
    trim = ("silenceremove=start_periods=1:start_threshold=-50dB:start_silence=0.05,"
            "areverse,silenceremove=start_periods=1:start_threshold=-50dB:start_silence=0.05,areverse")
    # --refmatch: EQ measured from the real-game gameplay recording (LTAS ref-vs-our) --
    # the original QTMA "Best Synthesizer" is BRIGHTER (presence 2-8kHz), less muddy
    # (low-mids ~400Hz) and has MORE low-end weight than our warmer soundfont voices;
    # this closes that tonal gap (re-derived 2026-07-12 from the corrected full refs).
    refeq = ("bass=g=2.5:f=65,"
             "equalizer=f=400:width_type=q:w=1.0:g=-2.5,"
             "equalizer=f=3000:width_type=q:w=1.2:g=2.0,"
             "equalizer=f=5500:width_type=q:w=1.2:g=3.5,") if refmatch else ""
    filt.append("[bus]bass=g=1.5:f=90,treble=g=1.5:f=10000,"
                f"{refeq}"
                "volume=1.5dB,asoftclip=type=tanh,volume=-1.5dB,"
                f"extrastereo=m=1.08,{trim}[pol]")
    # dynaudnorm's gaussian window ramps its gain over the first ~3s (an audible fade-in);
    # warm it up with a reversed-head pre-roll, then trim the pre-roll off so the track
    # starts at full, steady level.
    filt.append("[pol]asplit=2[pol1][pol2]")
    filt.append("[pol2]atrim=0:4,areverse,asetpts=N/SR/TB[pre]")
    filt.append("[pre][pol1]concat=n=2:v=0:a=1[warm]")
    filt.append("[warm]dynaudnorm=f=250:g=13:m=6:p=0.9,atrim=start=4,asetpts=N/SR/TB[out]")
    fc = ";".join(filt)
    run([FF, "-hide_banner", "-loglevel", "error", "-y", *inputs,
         "-filter_complex", fc, "-map", "[out]", premix])
    if not (os.path.exists(premix) and os.path.getsize(premix) > 1024):
        raise RuntimeError("mix failed")
    # loudness-match to -14 LUFS + hard limiter (ceiling leaves room for OGG overshoot)
    meas = run([FF, "-hide_banner", "-i", premix, "-af",
                f"loudnorm=I={lufs}:TP=-1.5:print_format=json", "-f", "null", "NUL"])
    a, b = meas.rfind("{"), meas.rfind("}")
    j = json.loads(meas[a:b + 1])
    gain = round(lufs - float(j["input_i"]), 2)
    run([FF, "-hide_banner", "-loglevel", "error", "-y", "-i", premix, "-af",
         f"volume={gain}dB,alimiter=limit=0.75:level=false", "-c:a", "libvorbis", "-q:a", "6", out_ogg])
    return os.path.exists(out_ogg) and os.path.getsize(out_ogg) > 1024


def _first_tempo(mid):
    for tr in mid.tracks:
        for m in tr:
            if m.type == "set_tempo":
                return m.tempo
    return 500000

def _notes_to_midi(notes, ppq, tps, prog):
    """Build a single-track MIDI from (start_s, dur_s, pitch, vel) tuples -- used to
    RECONSTRUCT a phrase the QTMA extraction is MISSING vs the composer's reference
    audio (transcribed by ear/analysis, not from the game's note data)."""
    out = mido.MidiFile(ticks_per_beat=ppq); tr = mido.MidiTrack(); out.tracks.append(tr)
    tr.append(mido.Message("program_change", channel=0, program=prog, time=0))
    ev = []
    for (st, dur, pit, vel) in notes:
        on = int(st * tps); off = int((st + dur) * tps)
        ev.append((on, 1, mido.Message("note_on", channel=0, note=pit, velocity=vel)))
        ev.append((off, 0, mido.Message("note_off", channel=0, note=pit, velocity=0)))
    ev.sort(key=lambda x: (x[0], x[1])); last = 0
    for (at, _o, m) in ev:
        m.time = int(at - last); last = at; tr.append(m)
    tr.append(mido.MetaMessage("end_of_track", time=0))
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    humanize = "--humanize" in sys.argv          # OFF by default (keep exact timings/notes)
    prog_mode = "--prog" in sys.argv             # 70s prog-rock re-orchestration (PROG_OVERRIDES)
    prog2_mode = "--prog2" in sys.argv           # epic v2: PROG2_OVERRIDES + bigger reverb
    prog3_mode = "--prog3" in sys.argv           # epic v3: PROG3 + end crescendo + hotter/louder master
    organ_mode = "--organ" in sys.argv           # organ-led variant (PROG_ORGAN_OVERRIDES, Zimmer church organ)
    organ2_mode = "--organ2" in sys.argv         # CATHEDRAL: organ + sub-octave pedal, biggest reverb, hottest
    prog4_mode = "--prog4" in sys.argv           # SYMPHONIC epic: full orchestra (strings/brass/choir/organ/timpani)
    refmatch_mode = "--refmatch" in sys.argv     # tonal-match the real-game QTMA reference (brighter, less muddy)
    if "--legacy-fonts" in sys.argv:
        globals()["FONTSET"] = "legacy"          # reproduce the pre-premium MuseScore/GeneralUser palette
    if "--gugs" in sys.argv:
        globals()["FONTSET"] = "gugs"            # thin/basic GM everywhere (retro-synth test, e.g. spooky)
    _solo_env = os.environ.get("SOI_SOLO")        # e.g. SOI_SOLO="2,5,6" -> render only those channels (mute rest)
    _SOLO = set(int(x) for x in _solo_env.split(",")) if _solo_env else None
    ov_source = (PROG_ORGAN2_OVERRIDES if organ2_mode else PROG4_OVERRIDES if prog4_mode
                 else PROG_ORGAN_OVERRIDES if organ_mode else PROG3_OVERRIDES if prog3_mode
                 else PROG2_OVERRIDES if prog2_mode else PROG_OVERRIDES if prog_mode else OVERRIDES)
    reverb_wet = (0.62 if organ2_mode else 0.58 if prog4_mode else 0.55 if organ_mode
                  else 0.48 if prog3_mode else 0.40 if prog2_mode else 0.30)
    lufs_target = (-11.0 if organ2_mode else -11.5 if prog4_mode else -12.0 if organ_mode
                   else -11.5 if prog3_mode else -14.0)
    in_dir  = args[0] if args else "extracted/music"
    out_dir = args[1] if len(args) > 1 else "extracted/music/renders/studio"
    for name, exe in (("fluidsynth", FS), ("ffmpeg", FF), ("ffprobe", FP)):
        if not exe:
            print("missing", name); return 1
    os.makedirs(out_dir, exist_ok=True)
    ir = make_hall_ir(IR_PATH)
    mids = sorted(glob.glob(os.path.join(in_dir, "*.mid")))
    if not mids:
        print("no .mid in", in_dir); return 1
    label = ('CATHEDRAL organ' if organ2_mode else 'SYMPHONIC epic' if prog4_mode else 'ORGAN (Zimmer)' if organ_mode
             else 'PROG3 epic' if prog3_mode else 'PROG2 epic' if prog2_mode else 'PROG re-orch' if prog_mode else 'studio')
    print(f"{label}{' [legacy fonts]' if FONTSET == 'legacy' else ''} render: {len(mids)} tracks -> {out_dir}  (humanize={humanize})")
    failed = []
    for mp in mids:
        base = os.path.splitext(os.path.basename(mp))[0]
        tmp = tempfile.mkdtemp(prefix="soi_studio_", dir=r"D:\SOI-tools" if os.path.isdir(r"D:\SOI-tools") else None)
        try:
            mid = mido.MidiFile(mp)
            ov_track = ov_source.get(base, {})
            chan_ov = {ch: v for ch, v in ov_track.items() if isinstance(ch, int)}
            prog_ovr = {}
            for ch, v in chan_ov.items():
                if isinstance(v, dict):
                    if "prog" in v:
                        prog_ovr[ch] = v["prog"]
                else:
                    prog_ovr[ch] = v
            legato_set = {ch for ch, v in chan_ov.items() if isinstance(v, dict) and v.get("legato")}
            vel_floor_map = {ch: v["vel_floor"] for ch, v in chan_ov.items() if isinstance(v, dict) and "vel_floor" in v}
            emphasis_map = {ch: v["sustain_emphasis"] for ch, v in chan_ov.items() if isinstance(v, dict) and "sustain_emphasis" in v}
            emphasis_window_map = {ch: tuple(v["emphasis_window"]) for ch, v in chan_ov.items() if isinstance(v, dict) and "emphasis_window" in v}
            duck_map = {ch: tuple(v["duck_before"]) for ch, v in chan_ov.items() if isinstance(v, dict) and "duck_before" in v}
            drum_set = {ch for ch, v in chan_ov.items() if isinstance(v, dict) and v.get("drum")}
            drum_note_map = {ch: v["drum_note"] for ch, v in chan_ov.items() if isinstance(v, dict) and "drum_note" in v}
            boost_map = {ch: tuple(v["boost_after"]) for ch, v in chan_ov.items() if isinstance(v, dict) and "boost_after" in v}
            crescendo_map = {ch: tuple(v["crescendo"]) for ch, v in chan_ov.items() if isinstance(v, dict) and "crescendo" in v}
            octave_map = {ch: list(v["octave"]) for ch, v in chan_ov.items() if isinstance(v, dict) and "octave" in v}
            stems, effp = split_stems(mid, humanize, prog_ovr, legato_set, vel_floor_map, emphasis_map, drum_set,
                                      emphasis_window_map=emphasis_window_map, duck_map=duck_map, drum_note_map=drum_note_map, boost_map=boost_map, crescendo_map=crescendo_map, octave_map=octave_map)
            info = []
            for ch, smid in stems.items():
                prog = effp[ch]
                is_drum = ch in drum_set
                fam = dict(gain=0.0, pan=0.0, hp=0, lp=16000) if is_drum else family(prog)
                v = ov_track.get(ch)
                if isinstance(v, dict):
                    for k in ("gain", "pan", "hp", "lp"):
                        if k in v:
                            fam[k] = v[k]
                if _SOLO is not None and ch not in _SOLO:
                    fam["gain"] = -80.0          # SOI_SOLO: mute all but the soloed channels
                smp = os.path.join(tmp, f"ch{ch}.mid"); smid.save(smp)
                swav = os.path.join(tmp, f"ch{ch}.wav")
                if render_stem(smp, GUGS if is_drum else font_for(prog), swav,
                               chorus=(not is_drum and sustained(prog))):
                    info.append((swav, fam))
            inj = ov_track.get("_inject")
            if inj:
                tps = mid.ticks_per_beat * 1e6 / _first_tempo(mid)
                ismp = os.path.join(tmp, "inject.mid"); _notes_to_midi(inj, mid.ticks_per_beat, tps, _BFL_LEAD).save(ismp)
                iswav = os.path.join(tmp, "inject.wav")
                if render_stem(ismp, font_for(_BFL_LEAD), iswav, chorus=sustained(_BFL_LEAD)):
                    info.append((iswav, dict(gain=4.0, pan=0.0, hp=160, lp=16000)))
            if not info:
                raise RuntimeError("no stems")
            out_ogg = os.path.join(out_dir, base + ".ogg")
            mix_and_master(info, ir, out_ogg, tmp, reverb=reverb_wet, lufs=lufs_target, refmatch=refmatch_mode)
            dur = subprocess.run([FP, "-v", "error", "-show_entries", "format=duration",
                                  "-of", "csv=p=0", out_ogg], stdout=subprocess.PIPE).stdout.decode().strip()
            print(f"  {base:24s} stems={len(info):2d} -> {float(dur):6.1f}s")
        except Exception as e:
            print("  FAIL", base, e); failed.append(base)
        finally:
            shutil.rmtree(tmp, ignore_errors=True)
    if failed:
        print("FAILED:", ", ".join(failed)); return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
