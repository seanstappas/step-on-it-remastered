# Step On It — Parallel Remaster Task Prompts

Hand-off prompts for **separate agent sessions** that run in parallel with the main
faithfulness/bug-fix work. Each section is a self-contained, copy-paste prompt with the
exact repo paths, recommended RTX-4090 tooling, output locations, constraints, and a
command-line verification method.

> **Shared context to paste at the top of every session**
> Repo: `d:\Code\step-on-it-remastered`. This is a faithful Windows/Godot 4.3 remaster of
> the 1996 Mac game *Step On It!*. Assets were reverse-engineered out of the original and
> live under `extracted/`. The Godot front-end (`godot_project/`) loads them by exact path
> and filename. **Do not rename or move existing assets** — produce upgraded assets either
> in place (same filename) or in a clearly-named parallel folder that the front-end can be
> pointed at. Gate any code change with `powershell -ExecutionPolicy Bypass -File tools/verify.ps1`
> (6 stages must PASS). Godot exe: `D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe`.
> **Hidden captures (no popup window):** screenshot (`--shot`/`--menushot`) and video
> (`--write-movie`, via `tools/record_video.ps1`) runs auto-render the game window
> **off-screen** so nothing pops up on the desktop — the render still works (unlike Godot
> `--headless`, which captures blank; do NOT minimize — a minimized window hangs `--shot`).
> Add `--position 9000,9000` to the launch to also skip the brief creation flash, force it on
> any run with `--hidden`, or keep the window on-screen with `--visible` (recorder: `-Visible`).
> Example: `& $godot --path godot_project --resolution 640x480 --position 9000,9000 -- --shot --board=board_450`.
> **Coordinate to avoid conflicts:** music work touches only `extracted/music/` +
> `tools/render_music.*` + `godot_project/scenes/audio.gd`; sprite work touches only
> `extracted/sprites/` (+ a new HD folder) + the sprite loader in `game.gd`; sound work
> touches only `extracted/audio/wav/` + `audio.gd`. Do NOT edit `core/`, `bridge/`, or the
> gameplay logic in `game.gd` (the main session owns those).

### Tooling status on THIS box (verified 2026-07-07)

| Tool | Status | Path / note |
|---|---|---|
| **Real-ESRGAN** | ✅ READY | `D:\SOI-tools\realesrgan\realesrgan-ncnn-vulkan.exe` + models `realesrgan-x4plus-anime`, `realesrgan-x4plus`, `realesr-animevideov3-x2/x3/x4`. Preserves alpha (softens edges to ~22 values). |
| **ffmpeg / ffprobe** | ✅ READY | `D:\Program Files\Tools\ffmpeg.exe` / `ffprobe.exe` |
| **Python** (`py`) | ✅ numpy 2.2.6, Pillow 12.3.0 | scipy/torch NOT installed |
| **FluidSynth** | ❌ MISSING | `winget install FluidSynth` (or scoop/choco) — needed for the SoundFont music path |
| **SoundFont (.sf2)** | ❌ NONE on box | fetch a lush GM/orchestral SF2 (Musyng Kite / Arachno / GeneralUser GS) |
| **torch / audiosr / resemble-enhance** | ❌ MISSING | heavy CUDA `pip install` — only for AI audio super-res |
| **pyiqa / scipy** | ❌ MISSING | `pip install pyiqa scipy` — only for no-reference image metrics |
| **sox / timidity** | ❌ MISSING | optional |

**Runs immediately vs. needs install:**
- **Sprites** — READY NOW (Real-ESRGAN + ffmpeg/PIL for verification).
- **Sound, faithful clean-up** — READY NOW (ffmpeg resample/denoise). **Sound, AI super-res** — needs `pip install torch audiosr`.
- **Music** — needs FluidSynth **+** a SoundFont; OR just make the EXISTING numpy synth (`tools/render_music.py`, numpy is present) more epic (no install).
- **Image QA** — SSIM + alpha checks via ffmpeg/PIL run now; `pyiqa` no-ref scores need `pip install pyiqa` (pulls torch).

Extracted SFX sample rates (ffprobe): 11025 Hz ×24, ~11127 Hz ×31, 22255 Hz ×1 — i.e. almost everything is ~11 kHz mono.

---

## 1) MUSIC REMASTER — "more epic"

**Current state**
- Source MIDIs: `extracted/music/*.mid` — 9 tracks: `6lilt`, `6lilt_thin`, `Angel_Pie`,
  `bass_for_lunch`, `bass_for_lunch_thin`, `Cminor`, `Cminor_thin`, `spooky`, `spooky_thin`.
  These are FAITHFUL note/tempo extractions from the original QuickTime Music (QTMA) data.
- Current render: `tools/render_music.py` (pure-Python **numpy wavetable** synth — sine +
  harmonics, basic drums, stereo, light reverb) → `tools/render_music.ps1` wraps it +
  `ffmpeg libvorbis` → `extracted/music/*.ogg`. The notes are right; the **voicing is a
  synthetic approximation** — that is what to make "epic".
- Front-end: `godot_project/scenes/audio.gd` loads `extracted/music/<name>.ogg` via
  `AudioStreamOggVorbis.load_from_file`, `set_music_variant("remaster"|"original")`,
  default track `6lilt`, music OFF by default, −6 dB.

**Recommended tooling (RTX 4090 available, but this is mostly CPU/sample work)**
1. **FluidSynth (CLI) + a premium SoundFont** — the highest-quality, deterministic path.
   `fluidsynth -ni -F out.wav -r 48000 <soundfont>.sf2 in.mid`. For "epic", use a large
   lush GM soundfont: **Musyng Kite**, **Arachno 1.0**, or **SGM-V2.01**; or an orchestral
   SF2. Optionally **remap program numbers** in the MIDI to bigger patches (strings/brass/
   timpani/choir) before rendering for a cinematic arrangement.
2. **Master the render** with `ffmpeg`/`sox`: gentle bus compression + `loudnorm` (target
   ~ −14 LUFS), a touch of hall reverb, and a hard limiter so it is loud and full.
   `ffmpeg -i out.wav -af "loudnorm=I=-14:TP=-1.5:LRA=11, aecho=..." -c:a libvorbis -q:a 6 out.ogg`.
3. **Maximum-epic option (manual, optional):** import the MIDI into **Reaper** and drive it
   with free orchestral VSTs (**Spitfire BBC Symphony Orchestra Discover**, **Spitfire LABS**),
   then bounce to OGG. Highest quality, not scriptable.
4. AI MIDI→audio (e.g. neural synths) is **not recommended** here — immature and non-faithful;
   FluidSynth + a great SoundFont gets the epic timbre with full control.

**Output & constraints**
- Write OGG Vorbis, 44.1/48 kHz, to `extracted/music/<name>.ogg` (SAME base names) so the
  front-end picks them up with no code change. Keep a single clean loop (no fade), peak ≤ −1 dBFS.
- Keep the originals recoverable (the git working tree auto-checkpoints; or render to
  `extracted/music/epic/` first and swap once approved).

**Verify (the agent cannot hear — use objective checks + let the user A/B)**
- `ffprobe` each OGG: confirm duration ≈ the MIDI length, sample rate, channels, bitrate.
- Loudness: `ffmpeg -i x.ogg -af loudnorm=print_format=json -f null -` (report integrated LUFS/TP).
- Spectrogram before/after: `ffmpeg -i x.ogg -lavfi showspectrumpic=s=1024x512 spec.png` and
  view it (epic mix = fuller low-mids + controlled highs, no clipping).
- Loop check: confirm start/end samples are near-silent or continuous (no click).

**Copy-paste prompt**
> Improve the *Step On It* music to sound more **epic/cinematic** while keeping the exact
> notes/tempo. Render `extracted/music/*.mid` with **FluidSynth + a premium orchestral/GM
> SoundFont** (Musyng Kite / Arachno / SGM), optionally remapping instruments to bigger
> patches, then master with ffmpeg `loudnorm` + reverb + limiter to OGG Vorbis at
> `extracted/music/<name>.ogg` (same base names; the Godot front-end loads them unchanged —
> see `godot_project/scenes/audio.gd`). Do not change any code except optionally
> `tools/render_music.py/.ps1`. Verify each track with ffprobe (duration/rate) + a
> `showspectrumpic` spectrogram + a `loudnorm` LUFS report, and leave the originals
> recoverable so the user can A/B. Document the SoundFont used and the exact commands.

---

## 2) SPRITE / IMAGE AI UPSCALE & REMASTER

**Current state**
- `extracted/sprites/<sheet>/fNN_WxH.png` — **30 sheet folders, ~1,723 frames**, pixel art
  with RGBA transparency (palette baked in). Sheets incl.: `BP_sprites`/`GP_sprites` (player,
  155 ea), `block_sprites` (154), `goody_sprites` (49), `walker_sprites` (62),
  `ant_sprites`/`ostrich_sprites`/`hippo_sprites`/`piggy_sprites`/`teeth_sprites`,
  `robo_sprites` (78), `Gargoyle_sprites` (71), `knight_sprites` (63), `beenie_sprites` (118),
  `hammer_sprites` (79), `bigger_mblock` (creeper), `Stop_Go_sprite_family`, `weapons`, etc.
- Filenames encode the frame index: `fNN_WxH.png` (e.g. `f30_36x16.png`). The loader
  (`godot_project/scenes/game.gd`: `_folder_index`, `_sprite`, `_blit`, `_load_sheet`,
  `_redden`) **parses the frame number `NN`** from the name (`f<NN>_...`). The `WxH` part is
  documentation and is NOT parsed. Sprites are drawn centered/bottom-aligned in a 32×32 cell.

**Recommended tooling (RTX 4090)**
1. **Real-ESRGAN** — the workhorse upscaler. Use the standalone `realesrgan-ncnn-vulkan.exe`
   (Vulkan, no Python) with the **`realesrgan-x4plus-anime`** model (great for clean cartoon
   sprites), or the PyTorch build for custom models. `realesrgan-ncnn-vulkan -i in -o out -n
   realesrgan-x4plus-anime -s 4`. **It preserves the alpha channel.**
2. **chaiNNer** (node-based, batch, explicit alpha handling) to build a repeatable pipeline
   and chain a **pixel-art / anime model from OpenModelDB** (e.g. `4x_foolhardy_Remacri`,
   `4x-UltraSharp`, or a dedicated pixel-art ESRGAN). Best for consistency across 30 folders.
3. **Deterministic pixel-clean option:** `xBRZ` / `hqx` scalers keep the crisp pixel-art look
   without hallucination — good if the AI upscale looks too "smeared".
4. **Full re-imagining (optional, flag faithfulness risk):** Stable-Diffusion tile upscale
   (**SUPIR** or ControlNet-Tile) for a stylized HD remaster — changes the art, so only if the
   user explicitly wants a re-drawn look, not 1:1.

**Output & constraints (critical)**
- Output to a **parallel folder** `extracted/sprites_hd/<sheet>/fNN_WxH.png`, keeping the
  **exact `fNN` frame number** (the loader parses it) and RGBA transparency. The main session
  will add a `SPRITES_DIR` toggle so the game can load HD sprites without breaking the SD set.
- Upscale by an integer factor (4×) consistently across a sheet; update the `WxH` in the name
  to the new size (optional but tidy). **Never drop the alpha channel** (transparent corners/
  edges matter — e.g. rounded blocks, or the white will leak). Keep per-sheet scale uniform.
- **Alpha edges (verified on this box):** Real-ESRGAN softens the alpha into a gradient (~22 edge
  values). Soft edges are fine for CHARACTERS, but for cell-filling BLOCK sheets (`block_sprites`,
  `bigger_mblock`) a soft fringe leaks the cell behind (this is exactly the creeper-white bug the
  main session hit). For those sheets, THRESHOLD the alpha back to hard edges after upscaling
  (`alpha = 0 if a < 128 else 255`). Confirmed-working command:
  `& 'D:\SOI-tools\realesrgan\realesrgan-ncnn-vulkan.exe' -i <in.png> -o <out.png> -n realesrgan-x4plus-anime -s 4 -m 'D:\SOI-tools\realesrgan\models' -f png` (output is RGBA, 4× size).

**Verify (CLI + the agent's own vision)**
- Sanity: for each frame confirm output is RGBA, size == 4× input, and the alpha bounding box
  scales consistently (`python -c` with Pillow).
- Fidelity: **downscale the HD frame back to original size and SSIM-compare** to the source
  (`ImageMagick: compare -metric SSIM a.png b.png null:` or `ffmpeg ssim`) — high SSIM ⇒ the
  upscale preserved structure, low ⇒ hallucination/artifacts.
- No-reference quality: **`pyiqa`** (`pip install pyiqa`, runs on the 4090) — NIQE / BRISQUE /
  MUSIQ / CLIP-IQA scores per frame; flag outliers.
- Visual spot-check: build a **contact sheet** per sheet (`py tools/sprite_sheet.py <folder>
  <cols> <cell>`), open it, and eyeball for artifacts/alpha halos. (A vision-capable agent can
  view the sheet directly.)

**Copy-paste prompt**
> AI-upscale the *Step On It* sprite sheets (`extracted/sprites/<sheet>/fNN_WxH.png`, ~1,723
> RGBA pixel-art frames, 30 folders) 4× for an HD remaster, using **Real-ESRGAN**
> (`realesrgan-x4plus-anime`) or **chaiNNer** with a pixel-art model on my RTX 4090.
> **Preserve the alpha channel and the exact `fNN` frame number in each filename.** Write
> results to a NEW parallel tree `extracted/sprites_hd/<sheet>/fNN_WxH.png` (do not overwrite
> the originals; the game loader parses `f<NN>_` — see `game.gd` `_folder_index`/`_sprite`).
> Keep per-sheet scale uniform. Verify each frame is RGBA at 4× size, do a downscale-back SSIM
> vs the source (flag anything below ~0.9), run `pyiqa` no-reference scores, and build a
> contact sheet per folder for a visual artifact check. Report the model + commands used.

---

## 3) SOUND / SFX ENHANCEMENT & UPSCALE

**Current state**
- `extracted/audio/wav/*.wav` — **56 SFX**, mostly **11,025 Hz** (a few 44.1 kHz), named
  `<sndid>_<name>.wav` (e.g. `26486_moon_blast_11khz.wav`). Loaded by
  `godot_project/scenes/audio.gd` (`_load_all` scans the folder → `_by_snd` map;
  `SFX_ID` maps game events → original `snd ` resource ids; `play`/`play_snd`).

**Recommended tooling (RTX 4090)**
1. **AudioSR** ("Versatile Audio Super-Resolution", `pip install audiosr`) — diffusion-based
   audio super-resolution to 48 kHz that **synthesizes plausible high-frequency detail**;
   ideal for old 11 kHz effects. Runs on the 4090.
2. **resemble-enhance** (`pip install resemble-enhance`) — denoise + enhance (great for hiss/
   aliasing cleanup).
3. **Faithful/deterministic option:** `sox`/`ffmpeg` high-quality resample to 44.1 kHz +
   gentle de-noise + a soft high-shelf — no hallucinated detail, just a clean modern render.
   `ffmpeg -i in.wav -ar 44100 -af "afftdn, highshelf=g=2:f=6000" out.wav`.

**Output & constraints**
- Keep the **same filenames** (the loader maps by `<sndid>`), write 44.1 kHz WAV (or OGG) to
  `extracted/audio/wav/` (or a parallel `extracted/audio/wav_hd/` for A/B). Don't change the
  event→snd mapping in `audio.gd`.

**Verify (CLI; user judges timbre)**
- `ffprobe` sample rate/channels before & after; confirm no clipping (peak ≤ −1 dBFS).
- Spectrogram compare: `ffmpeg -i x.wav -lavfi showspectrumpic=s=1024x400 sp.png` (before/after)
  — SR/enhance should extend usable bandwidth without harsh artifacts.
- Length unchanged (a SFX must not get longer/shorter).

**Copy-paste prompt**
> Enhance/upscale the *Step On It* SFX in `extracted/audio/wav/*.wav` (56 files, mostly
> 11,025 Hz, named `<sndid>_<name>.wav`) to clean 44.1/48 kHz on my RTX 4090, using **AudioSR**
> for super-resolution (or `resemble-enhance` / a faithful `ffmpeg afftdn+resample` for a
> conservative clean-up). Keep the **exact filenames** (the Godot loader maps by `<sndid>` —
> see `audio.gd`) and write to `extracted/audio/wav/` (or `extracted/audio/wav_hd/` for A/B).
> Verify each file's sample rate/peak with ffprobe, compare before/after spectrograms via
> `showspectrumpic`, and confirm durations are unchanged. Do not edit the event→snd map.

---

## 4) UPSCALE / ASSET QA TOOLING (support task)

**Status: BUILT** — `tools/qa_assets.py` (Python + Pillow + numpy; pure-numpy SSIM, no scipy;
`pyiqa` optional). Dependency-light, CLI-driven, headless; exits non-zero if any asset FAILS so
it can gate a session. Usage:

```
py tools/qa_assets.py sprites extracted/sprites extracted/sprites_hd
py tools/qa_assets.py sprites extracted/sprites/goody_sprites extracted/sprites_hd/goody_sprites
py tools/qa_assets.py audio   extracted/audio/wav extracted/audio/wav_hd --rate 44100
```

- `sprites`: for a source dir + HD dir (a sheet tree OR one sheet folder), per frame assert RGBA,
  size == k× source (integer, uniform per sheet — auto-detected or `--scale N`), alpha-bbox scaled
  consistently; downscale-back SSIM vs source (flag `< --ssim-min`, default 0.9); optional pyiqa
  NIQE/BRISQUE (`--pyiqa`, needs torch); write a per-sheet contact sheet PNG (checkerboard bg to
  reveal alpha halos) under `--out` (default `qa_out/`); print a summary table + a pass/fail list.
  Frames are matched by the `fNN` index (the `WxH` suffix may differ), mirroring the game loader.
- `audio`: for a source dir + HD dir, per file assert sample-rate target (`--rate`, default 44100),
  peak ≤ −1 dBFS (`--peak`), duration within ±1 %, and render a before/after spectrogram pair PNG
  (src over hd, labelled) under `--out`. Files matched by stem (`<sndid>_<name>`). Uses ffmpeg/
  ffprobe (auto-found on PATH, else `D:\Program Files\Tools\`).

Keep it dependency-light and CLI-driven so it can run headless on the 4090 box.


---

## 5) OTHER PARALLEL IDEAS (independent, non-conflicting)

These are gameplay/presentation items the main session has flagged as TODO; each is
self-contained and can be a separate agent session (they touch `core/`, `bridge/`, or
`game.gd`, so coordinate with the main session before starting):

- **Animated bonus tally count-up** (`FUN_10015714`) — **DONE.** `game.gd` counts the remaining
  bonus into the score over the tally window with the ascending "ding" scale (`_tally_dings`,
  snd 1100–1106) and the `xN` multiplier; drawn by `_draw_complete_tally`. Gated green.
- **High-score name-entry UI** — **DONE.** `game.gd` `_hs_input`/`_draw_hs_entry`: on a qualifying
  game-over it shows "NEW HIGH SCORE!" and takes up to 3 initials (A–Z/0–9, Backspace, Enter →
  `Session.add_score`, default "AAA"); the core/`session.gd` high-score table is already wired. Gated green.
- **Full 8-direction Wheelie wall-follow** (`FUN_10009e98`) — **the last open main-session item.**
  The port already does a cardinal wall-follower (dirs L/U/R/D + slot-parity handedness); the asm is a
  ~300-line intricate CORNER-SENSING version (16 `FUN_1000554c` probes + 2 modes). It is a refinement,
  and its only real safety net is VISUAL (the winnability solver routes around enemies), so a faithful
  port is high-effort / moderate-risk. `core/src/soi_enemies.c` `enemy_fly_bounce`.
- **Stop/Go sign flip animation** (`FUN_10016544`/`FUN_10016784`) — **DONE (2026-07-07).** A
  gameplay-neutral front-end overlay in `game.gd`: stepping on a switch (low 0x24–0x2D) flips its
  paired block group's sign over an ~8-frame rotation + a click (snd 1006), via `_update_stopgo`
  (edge-detected) + the `_draw_cell` Stop/Go branch. Gated green.
- **Music per-screen mapping** — **DONE (RE-confirmed).** Pinned the original's per-screen
  music from the PEF/asm (movie selector `FUN_10018414`, names via `tools/dump_movie_names.py`):
  **menu/title = 6lilt**; **in-game rotates Cminor → bass for lunch → 6lilt by `(level % 3)+1`**
  (`FUN_10018c88`); **spooky** overrides on any board holding a **Knight/Gargoyle** (`FUN_10017a70`
  → `DAT_1003ad0e`); **ending = Angel Pie** (`FUN_1001768c`). Full/Light picks the `_thin`
  arrangement. Wired in `audio.gd` (`play_menu_music`/`play_level_music`/`play_ending_music`) +
  `game.gd` + a 3-way Sound→Music (Full/Light/Off) menu; music still OFF by default. Mapping table
  in `docs/original_game/music-tracks.md`. (The Compete win screens play the three original
  **victory animations** blue/green/no-winner — silent Apple-Animation video, not audio —
  extracted by `tools/extract_win_movies.py` to `extracted/movies/*.ogv` and wired into `game.gd`.)
  Gated green.
- **QTMA→higher-fidelity music**: re-extract with the original Apple QTMA instrument voices
  (vs the current GM approximation) if an emulator capture becomes available.

---

## Coordination checklist
- One session per asset class; keep to the file boundaries listed in the shared context.
- Always leave the SD assets intact (parallel HD folders) until the user approves a swap.
- Run `tools/verify.ps1` before finishing any session that touched code; keep `media/video/`
  deliverables. Note the exact tools, models, and commands used in your final summary so the
  work is reproducible.
