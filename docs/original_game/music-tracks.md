# Step On It! — Music Tracks Guide

This project has **two** soundtracks, both driven by the same 9 extracted tunes:

| Soundtrack | What it is | Where it lives | Who makes it |
|---|---|---|---|
| **Remaster** | A studio render of the faithful note data through **FluidSynth + premium SoundFonts** (per-channel stems, real instruments, pitch-bend, stereo, convolution reverb, mastered to -14 LUFS). | `extracted/music/*.ogg` | `tools/render_music_studio.py` (current set **studio8**) |
| **Original** | Your real recordings captured from the actual game. | `extracted/music/original/*.ogg` | **You** — built from your captures in `refs/music/gameplay/` by `tools/build_original_music.py` (see below) |
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

### Built from the gameplay captures (current set)

`py tools/build_original_music.py` turns the emulator captures in `refs/music/gameplay/`
(`6lit.wav`, `bass_for_lunch.wav`, `Cminor.wav`, `Spooky.wav`) into `6lilt`, `bass_for_lunch`,
`Cminor` and `spooky` here, each **exactly one QuickTime loop** (the movie's `mdhd` duration):

- the capture is aligned to the tune's own note onsets (parsed from the movie), which pins the loop
  start to ~5 ms and the capture's clock drift — the first note of every capture sounds ~0.14 s late
  (QuickTime synth start-up), so the loop starts on the tune clock, *before* the first audible sound;
- Spooky's capture speeds up near the end (the low-Bonus hurry, 1.25× tempo): the fitted hurry
  point (tune time ~60.6 s) is restored to 1.0× with `atempo`, so the loop is whole;
- loudness-matched to the remaster (−14 LUFS) so an A/B switch is fair.

Then `powershell -ExecutionPolicy Bypass -File tools/render_music_hurry.ps1 -Dir extracted/music/original`
builds their `_hurry` variants. `Angel_Pie` and the `_thin` (Light) arrangements were not captured:
Light falls back to the original **full** arrangement, `Angel_Pie` to the remaster.

### Using them in-game

**F2** (title menu or in game) switches the whole presentation ORIGINAL ↔ REMASTERED, which swaps
the soundtrack live at the **same playback position** (both are one loop of the same tune clock).
From script, select the original soundtrack with the Audio autoload:

```gdscript
Audio.set_music_variant("original")   # "remaster" (default) | "original"
```

`set_music_variant` loads from `extracted/music/original/` when set to `"original"`
(falling back to the remaster for any track you didn't supply), and from
`extracted/music/` for `"remaster"`. `Session.set_remastered` (the F2 switch) calls it.

> Which tune plays on which screen is now **pinned from the original binary** (no
> longer a guess) — see **Per-screen mapping** below. The port implements it in
> `audio.gd` (`play_menu_music` / `play_level_music` / `play_ending_music`).

---

## Per-screen mapping (CONFIRMED from RE)

The original loads a background-music QuickTime movie via `FUN_10018414(selector)`
(selector 1–6); the movie names were read straight out of the PEF data section
(`tools/dump_movie_names.py`). The **Sound → Music: Full / Light / No** setting
(`DAT_10039154`) swaps the sparser `_thin` arrangement for selectors 1–4.

| selector | Full movie | Light (`_thin`) | plays on |
|---|---|---|---|
| 1 | `6lilt` | `6lilt thin` | in-game, level % 3 == 0 |
| 2 | `Cminor` | `Cminor thin` | in-game, level % 3 == 1 |
| 3 | `bass for lunch` | `bass for lunch thin` | in-game, level % 3 == 2 |
| 4 | `spooky` | `spooky thin` | in-game, board has a **Knight or Gargoyle** |
| 5 | `6lilt` | *(always Full)* | **title / menu / attract** |
| 6 | `Angel Pie` | *(none)* | **ending** (whole campaign beaten) |

- **In-game** (`FUN_10018c88`): the tune is `(level % 3) + 1` — the three tunes
  Cminor → bass for lunch → 6lilt rotate every board (`level` = the 1-based board
  number, i.e. `board_id − 400` for the 401–500 campaign). So level 1 = Cminor,
  level 2 = bass for lunch, level 3 = 6lilt, level 4 = Cminor, …
- **Spooky override** (`DAT_1003ad0e`, set by `FUN_10017a70`): if the board holds a
  **Knight** (dispatcher type 13) or **Gargoyle** (type 14) the rotation is replaced
  by `spooky` (selector 4). It is *content-aware*, not tied to the board number.
- **Ending** (`FUN_1001768c`): beating the final board plays `Angel Pie`.
- The two-player **Compete** results screen plays a one-shot **victory animation**
  (`blue wins` / `green wins` / `no winner`, `FUN_10014d70` → `FUN_10018e88`). These
  are **silent Apple-Animation video clips** (220×164, 20 fps, ~4 s), *not* music —
  they carry no sound track. `tools/extract_win_movies.py` decodes them to
  `extracted/movies/*.ogv`, and the port plays them on the Compete win screen via a
  `VideoStreamPlayer` (`game.gd` `_update_win_video`). P3 (red) has no original clip.
- **HD remaster:** `tools/upscale_win_movies.py` AI-upscales every frame 4× with
  Real-ESRGAN (`realesr-animevideov3-x4`, the anime-video model) and re-encodes to
  `extracted/movies_hd/*.ogv` (880×656). The SD clips stay intact; `_win_clip_path`
  **prefers `movies_hd/`** when present (same parallel-folder pattern as the sprite HD set).
- Switching tunes across boards **does not restart** a movie that is already playing
  (the original's `_DAT_1003904e == param_1` early-out), so same-tune boards loop
  seamlessly. `spooky`/`Angel Pie` do the same.

---

## Low-bonus "hurry up" speedup (CONFIRMED from RE)

When a player's **Bonus timer ticks past 1000**, the original does **two** things at once
(`FUN_10018b24`, reached from the bonus countdown `FUN_1000f500`):

```c
void FUN_10018b24(void) {              /* the "hurry up" trigger */
  FUN_1002b020(0x2d, 100);             /* (1) play the "hurry up" sound  (evt 0x2d -> snd 1007) */
  if (music_on && movie_valid)
    SetMovieRate(_DAT_10039054, 0x14000);  /* (2) speed the looping music movie */
}
```

QuickTime movie rate is **16.16 fixed-point**, so `0x14000 / 0x10000 = `**`1.25×`**. It drops
back to normal (`SetMovieRate(movie, 0x10000)` = 1.0×) via `FUN_10018ac4`, called from
`FUN_1000f3f0` when a **time award lifts the last "hurrying" player back above 1000** (its
`bonus < 0x3e9` guard), and every **new board restarts the movie at 1.0×** (`FUN_1001882c`).

Because QTMA is **note-sequenced** (§ Source format), rate 1.25× speeds the **tempo only —
every note's pitch is unchanged** (the sequencer clock runs faster; the sampler still plays
each note at its own pitch). It is *not* a resample.

### How the port implements it

The port pre-renders a **tempo-only 1.25× variant of each in-play tune** rather than
resampling at runtime (which would also raise pitch):

| Piece | Where | What |
|---|---|---|
| Variants | `extracted/music/<track>_hurry.ogg` | `ffmpeg atempo=1.25` (WSOLA time-stretch: faster, **pitch preserved**) of each in-play `<track>.ogg` (selectors 1–4 + their `_thin`). Built by **`tools/render_music_hurry.ps1`**. Stretching the *shipped* OGG (not a re-synth) makes the hurry timbre identical to the normal track, so the swap is seamless. |
| Swap | `audio.gd` `set_music_hurry(on)` | Swaps the looping stream to `<track>_hurry` (carrying the playback position across, `pos ÷ 1.25`) and back. Falls back to `pitch_scale` only if a variant is missing, so the cue is never silent. A track change resets to 1.0× in `play_music` (mirrors `FUN_1001882c`); the board-clear tally, pause, and game-over also release to 1.0× via the per-tick recompute. |
| Trigger | `game.gd` tick loop | Recomputed **every tick** from the core predicate `_core.music_hurry()` — 1.25× while ANY in-play player's Bonus is in `(0, 1000]`, 1.0× otherwise (the original re-rates one shared movie, so any player in the zone speeds it). `set_music_hurry` is idempotent, so it only swaps on an actual state change. A **transporter slide keeps 1.25×** — the movie rate only resets on an above-1000 time award or a new board, never for the slide, so the frozen sub-1000 Bonus stays hurried (no dip, no reseat). The `SOI_SFX_HURRY` event (evt id 39) is drained in the same loop but only plays the warning **cue** — it does not drive the tempo. |

Neither the ending (`Angel_Pie`) nor the menu ever runs a Bonus countdown, so neither ever
triggers the speedup. `Angel_Pie` has no `_hurry` variant at all; the menu reuses `6lilt`
(in-play selector 1), so a `6lilt_hurry` file does exist but the menu never plays it. The
`_hurry` files are **auto-generated** — you don't supply them for the
*Original* soundtrack; re-run `tools/render_music_hurry.ps1` after dropping new tracks in.

**Proof (`tools/verify_music_hurry.py`):** each of the eight in-play hurry variants (the four
tunes × Full/Light) measures **duration ratio 0.80**
(tempo +25%) with a **matched dominant-peak frequency ratio of 1.0000** (pitch unchanged; a
semitone would be 1.059, a resample ≈1.25) — objective confirmation of the faithful
tempo-only speedup.

---

## Source format — QuickTime Music (QTMA)  (from RE)

The tunes are **not** baked audio. Each is a **QuickTime Music Architecture (QTMA)**
sequence — a stream of note/rest/controller *events* plus a General-MIDI instrument
list — played through classic QuickTime's built-in sampler. Because the movie stores
**notes + instruments** (not a waveform), the whole soundtrack is re-voiceable, which
is what makes the remaster possible. `tools/qtma_to_midi.py` decodes each movie to a
Standard MIDI File in `extracted/music/*.mid`.

### Where the originals live (split-fork Mac files)

| Fork | Path | Holds |
|---|---|---|
| Data fork | `raw_game/Step On It™/Step On It!  Movies/<name>` | the `mdat` atom = the QTMA **event stream** |
| Resource fork | `raw_game/Step On It™/__MACOSX/Step On It!  Movies/._<name>` | the `moov` / tune header = **instrument names + media timescale** |

Twelve movies exist: the five tunes (`6lilt`, `Cminor`, `bass for lunch`, `spooky`,
`Angel Pie`) plus four `thin` variants = **nine songs**, and `blue wins` / `green
wins` / `no winner`, which are **silent victory *videos*, not music** (a different,
non-tune layout the music extractor ignores — they carry a timescale of 20, the tunes 600).

### Event stream (big-endian `uint32` events; type = top 3 bits)

| Top 3 bits | Event | Fields |
|---|---|---|
| `000` | **Rest** | advance the clock by `e & 0x1FFFFFFF` (timescale units) |
| `001` | **Note** (short) | `part=(e>>24)&0x1F`, `pitch=((e>>18)&0x3F)+32`, `vel=(e>>11)&0x7F`, `dur=e&0x7FF` |
| `010` | **Control** | `part=(e>>24)&0x1F`, `controller=(e>>16)&0xFF`, `value=e&0xFFFF` |
| `100` | **Extended Note** (2 longs) | L1 `part=(e>>16)&0x1F`, `pitch=e&0xFF`; L2 `vel=(e2>>16)&0x7F`, `dur=e2&0xFFFF` |
| `011` / `110` / `111` | **General / marker** | `e & 0xFFFF` = count of trailing longs; consumed, not emitted |

- **Timing** — the media **timescale is 600** (from the resource fork's `mdhd`); the
  MIDI is written with division = timescale and tempo = 1,000,000 µs/quarter-note, so
  **1 event tick = 1/600 s** and timing/tempo are preserved exactly.
- **Pitch** is a MIDI-ish key (`field + 32`); **part → MIDI channel** = `part & 0x0F`.
- **Extended Notes** carry the long/sustained and high notes the 11-bit short-note
  duration can't (e.g. `bass_for_lunch`'s sustained lead at 0:47).
- **Controller `0x20` (32) = pitch bend**, value = **signed 8.8 fixed-point semitones**
  (`raw / 256`). The only controller any shipped tune uses: a **2-semitone slide** on
  `bass_for_lunch`'s sustain lead at ~1:00 and ~1:43 (355 events), emitted as a MIDI
  pitch-bend (GM default ±2-semitone range).

### Extraction bugs found & fixed (2026-07)

The decoder had been silently dropping real music; all three are fixed, so the notes
now come straight from the game data (no by-ear reconstruction):

1. **Extended-Note events (`100`) were skipped** → ~30–40 notes/track lost, including
   `bass_for_lunch`'s **sustained 0:47 lead (B5) + harmony**.
2. **A mis-attached branch on `011`** read a 1-long marker as a 2-long note → emitted
   garbage pitch-0 notes **and swallowed the following event** (often a real note).
3. **Control events were dropped** → the pitch-bend **slide** on the sustain lead was
   missing; now parsed.

### What is / isn't preserved

- **1:1:** every note, onset, duration, velocity, the tempo, the per-part GM
  instrument assignments, and (now) the pitch-bend automation.
- **Not preserved:** the exact **Apple QuickTime instrument voices** — the remaster
  substitutes SoundFonts / synth leads (a *voicing* choice, not lost data). No other
  QTMA controllers (volume/pan/modulation) appear in these tunes, so nothing else is lost.

### How the format was decoded (status)

Reverse-engineered **empirically from the raw byte stream**: dumping every event
(including the ones the old parser skipped), histogramming the 3-bit type field,
hypothesis-testing each bit field, range-checking the results, and cross-checking
timestamps against the composer's reference recordings (`tools/pitch_track.py`,
spectrograms, isolated-stem renders). The **bit layouts and the pitch-bend value curve
(0 → 2.00 → 0 semitones) are proven from the file.** The controller *labels* ("pitch
bend", "8.8 semitones") are inferred from QTMA convention + the data shape + audible
confirmation, and are **not yet checked against a primary Apple spec** (*Inside
Macintosh: QuickTime Components*).

---

## Improving the REMASTER further

The live remaster is already a real-sampler render — `tools/render_music_studio.py`
splits each MIDI into per-channel stems, renders them in **FluidSynth** with a hybrid
SoundFont (GeneralUser GS + MuseScore), then EQs/pans/reverbs and masters to -14 LUFS
(current set **studio8**; all A/B sets + the exact re-render recipe are in
`extracted/music/renders/README.md`). To try a different sampler/soundfont on the same
faithful MIDIs:

```
# example — needs fluidsynth + a General-MIDI soundfont (e.g. FluidR3_GM.sf2)
fluidsynth -ni <soundfont>.sf2 extracted/music/<name>.mid -F <name>.wav -r 44100
ffmpeg -i <name>.wav -c:a libvorbis -q:a 5 extracted/music/<name>.ogg
```

Drop the resulting `.ogg` files into `extracted/music/` (same names) and the game
picks them up with **zero code changes** — the pipeline and wiring are built to make
the render engine swappable.

To re-extract the MIDIs from the QTMA movies (the safe first step; the full studio
re-render recipe, including which MIDIs to stage, is in `extracted/music/renders/README.md`):

```
py tools/qtma_to_midi.py     # QTMA movies -> extracted/music/*.mid
```
