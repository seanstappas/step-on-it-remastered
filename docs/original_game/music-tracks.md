# Step On It! — Music Tracks Guide

This project has **two** soundtracks, both driven by the same 9 extracted tunes:

| Soundtrack | What it is | Where it lives | Who makes it |
|---|---|---|---|
| **Remaster** | A numpy software-synth render of the faithful note data (per-instrument voices, drums, stereo, reverb). | `extracted/music/*.ogg` | `tools/render_music.py` + `tools/render_music.ps1` |
| **Original** | Your real recordings captured from the actual game. | `extracted/music/original/*.ogg` | **You** (see below) |
| _First pass_ | The initial "dead"-sounding mono synth, kept for historical tracking. | `extracted/music/first_pass/*.ogg` | archived; code in git history |

The faithful source MIDI is `extracted/music/*.mid` (from `tools/qtma_to_midi.py`).
**Notes / timing / tempo / instrument program are faithful** in every render; only
the *voicing* differs. Music is **OFF by default** in-game (as in the original) —
enable it via the title screen **Sound → Music** checkbox.

---

## Dropping in your ORIGINAL recordings

Put your captured recordings here (create the folder if it doesn't exist):

```
extracted/music/original/
```

### File names — must match exactly (used as the load key)

The player loads a track by base name. Use these **exact** names (they are
case-sensitive on Linux/macOS):

```
6lilt.ogg
6lilt_thin.ogg
Angel_Pie.ogg
bass_for_lunch.ogg
bass_for_lunch_thin.ogg
Cminor.ogg
Cminor_thin.ogg
spooky.ogg
spooky_thin.ogg
```

You don't need all nine — any you provide will be used; the rest fall back to the
remaster. The `_thin` files are the original's sparser/alternate arrangements of
the same tunes; include them only if you captured them.

### Format

| Property | Requirement |
|---|---|
| Container / codec | **OGG Vorbis** (`.ogg`). Godot loads it via `AudioStreamOggVorbis`. |
| Sample rate | 44100 Hz (48000 also fine). |
| Channels | Stereo or mono both work. |
| Bit depth | N/A for OGG (it's lossy); encode at quality ~q4–q6 (≈128–160 kbps). |
| Peak level | Normalize to about **−1 to −3 dBFS**. In-game music plays at −6 dB so it sits under the SFX. |

> WAV is not loaded for music (only OGG). If you only have WAV, convert it:
> `ffmpeg -i in.wav -c:a libvorbis -q:a 5 extracted/music/original/<name>.ogg`

### Looping / padding — IMPORTANT

The game **loops each track seamlessly from start to end** (`loop = true`,
`loop_offset = 0` — it repeats the *whole file*). So each file must be **exactly one
clean loop iteration**:

- **Trim leading and trailing silence.** Dead air at the end becomes an audible gap
  on every loop; silence at the start becomes a stutter. (The remaster renderer does
  this automatically via `trim_tail`.)
- **No long fade-out.** A fade would re-trigger on every loop. If your capture fades,
  cut it at a natural musical boundary instead.
- **Make the seam musical.** Ideally the last bar leads back into the first bar. If
  the original tune has an obvious loop segment, trim to exactly that segment.
- Don't worry about matching the remaster's exact length — just make your own file a
  clean single loop.

### Using them in-game

Once your files are in `extracted/music/original/`, select the original soundtrack
with the Audio autoload:

```gdscript
Audio.set_music_variant("original")   # "remaster" (default) | "original"
```

`set_music_variant` loads from `extracted/music/original/` when set to `"original"`
(falling back to the remaster for any track you didn't supply), and from
`extracted/music/` for `"remaster"`. A user-facing **Original / Remaster** music
toggle in the Sound menu is a natural follow-up (it can call this).

> Which tune plays on which screen/board is **presentational** and not yet pinned
> from the original (that needs an emulator/oracle capture). Today the game loops a
> single default track (`6lilt`); `Audio.play_music("<name>")` selects another.

---

## Improving the REMASTER further

The current remaster is a from-scratch synth. For higher fidelity you can re-render
the same faithful MIDIs through a real sampler:

```
# example — needs fluidsynth + a General-MIDI soundfont (e.g. FluidR3_GM.sf2)
fluidsynth -ni <soundfont>.sf2 extracted/music/<name>.mid -F <name>.wav -r 44100
ffmpeg -i <name>.wav -c:a libvorbis -q:a 5 extracted/music/<name>.ogg
```

Drop the resulting `.ogg` files into `extracted/music/` (same names) and the game
picks them up with **zero code changes** — the pipeline and wiring are built to make
the render engine swappable.

To re-run the built-in remaster synth:

```
powershell -ExecutionPolicy Bypass -File tools/render_music.ps1
```
