# Step On It! — Remastered

A faithful remaster of the 1996 Casady & Greene Mac game **Step On It!** for modern platforms
(Windows first). The original PowerPC game logic was **decompiled** into a deterministic, headless
**C core** (`core/`), wrapped with a thin **C++ (`godot-cpp`)** GDExtension (`bridge/`), and driven by
a **Godot 4.3 / GDScript** front-end (`godot_project/`) with a retro ↔ remastered ("D2R"-style) toggle.
Personal preservation project.

> **Status: playable.** The C core, the GDExtension bridge, and the Godot front-end all build and pass
> the one-command gate ([tools/verify.ps1](tools/verify.ps1) — 6 stages). Gameplay is faithful to the
> decompiled original (movement, the full enemy roster, weapons, scoring, win/lose, and 1–3 player
> co-op / compete / alternate); the presentation is being remastered (HD/AI sprites & full-screen art,
> per-screen music, cleaned SFX, the extracted win animations). RE findings are in [docs/](docs/); the
> remaster is documented in [docs/remaster/](docs/remaster/).

## Repo layout

Directories use `snake_case`. Inputs are committed; generated artifacts are `.gitignore`d and
reproducible from the inputs via `tools/`.

```
raw_game/            # INPUT — the untouched original Mac game (source of truth; never edited)
refs/                # INPUT — human reference material (manuals, links, screenshots)
core/                # C game core — deterministic, decompiled gameplay logic
bridge/              # C++ godot-cpp GDExtension shim (the `SoiCore` node) wrapping the C core
godot_project/       # Godot 4.3 front-end — scenes/*.gd, project.godot, soi.gdextension
tests/               # C mechanic unit tests + determinism / fixture-replay harness
tools/               # Python + PowerShell: asset decode, AI upscale, music/SFX render, the gate
docs/                # RE findings (docs/original_game/) + remaster docs (docs/remaster/)
plan/                # MASTER_PLAN.md, EXECUTION_PLAN.md, REMASTER_PROMPTS.md
analysis/            # Ghidra scripts + decompiled listings used to reverse the core
media/               # tracked screenshots / videos of the remaster's progress
extracted/           # GENERATED (gitignored) — decoded assets, regenerate via tools/:
  levels/  palette/  cicn/  sprites/ (+ sprites_hd/ sprites_uhd/)  pict/ (+ pict_hd/ pict_hd_v2/)
  music/  audio/wav/ (+ wav_hd/ wav_ai/)  movies/ (+ movies_hd/)
bin/                 # GENERATED (gitignored) — core_pef.bin + build outputs
```

## Build, run & verify

Portable toolchain under `D:\SOI-tools\` (paths set in the tool scripts): **Zig** (`zig cc` / `zig c++`
builds the C core **and** the GDExtension — no MSVC needed), **Godot 4.3**, Python 3.10+, and ffmpeg.

**Gate — build + test + validate in one command:**

```
powershell -ExecutionPolicy Bypass -File tools/verify.ps1
```

Six stages must PASS: core mechanic unit tests, core harness + determinism, fixture-replay selftest,
the GDExtension build, a clean Godot import, and a rendered `--shot` screenshot.

**Play:** `.\play.ps1` (starts REMASTERED with music on, window sized to your monitor), or open
`godot_project/` in Godot 4.3 and press F5, or `"<Godot>" --path godot_project`.
Controls — P1: arrows + Z/X/C/V, P2: WASD + F/G/H/J. **F2** switches the whole presentation live —
**ORIGINAL** (1996 art, 8-bit SFX, the original game's music) ↔ **REMASTERED** (frame-matched 3D
sprites, remastered SFX, studio music remaster) — on the title menu and mid-board. **F3** toggles 3D ↔
HD sprites within REMASTERED, **M** toggles the Retro ↔ Remastered display effects; **Tab** pauses.

### Front-end flags

Pass after `--`, e.g. `"<Godot>" --path godot_project -- --3d --music`:

| Flag | Effect |
|---|---|
| `--3d` | Start in the **REMASTERED** presentation: the **frame-matched 3D sprites** (`extracted/sprites_3d_frames`, each frame fitted to and gated against its SD original) over the AI-upscaled HD sheets (frames without a 3D render stay HD), the HD full-screen art, remastered SFX + music; the 640×480 canvas renders at the window's resolution. **F2** switches ORIGINAL ↔ REMASTERED, **F3** 3D ↔ HD. |
| `--hd` | As `--3d` but starting on the HD sheets only (no 3D overlay until **F3**). |
| `--music` | Start with Sound → Music on (the original defaults it off). |
| `--mode=retro` \| `--mode=remastered` | Start in the flat retro or the remastered look (also **M** in game). |
| `--players=3` | Enable the remaster's 3rd co-op player. |
| `--board=board_NNN` | Load a specific board (capture runs). |
| `--shot` \| `--shotat=N` | Screenshot after N frames → `media/screenshots/`, then quit. |
| `--menushot=N` | Screenshot the main menu after N frames. |
| `--demo` \| `--play=N` | Scripted play for movie capture (see `tools/record_video.ps1`). |
| `--hidden` \| `--visible` | Render **off-screen** (no window pops up — for agents/CI) / force on-screen. |
| `--sfx-variant=light\|ai\|original` | The SFX set REMASTERED uses (default `ai` = AudioSR super-res `wav_ai`; `light` = cleaned 16-bit `wav_hd`). ORIGINAL always plays the faithful 8-bit `wav`. |

> **Headless-style capture.** Godot's own `--headless` renders **blank**, so screenshot / movie runs
> instead render **off-screen**: the window sits at `(9000, 9000)`, off the visible desktop, but still
> presents so the capture works. Capture flags auto-enable this; add `--position 9000,9000` to also skip
> the brief creation flash. `tools/verify.ps1` and `tools/record_video.ps1` do this for you.

## Remaster assets

Assets are decoded out of the original into `extracted/`, and optionally AI-upscaled into parallel
`_hd` folders that the front-end prefers in `--hd` mode — the faithful SD originals always stay intact.

| Asset | Faithful (SD) | Remaster (HD) | Tool |
|---|---|---|---|
| Sprites | `extracted/sprites/` | `sprites_hd` (4×) · `sprites_uhd` (8×) — Real-ESRGAN anime / hqx per sheet | `tools/upscale_sprites.py` |
| 3D sprites | `extracted/sprites/` (the per-frame reference) | `sprites_3d_frames` (4×, same `fNN` per frame) — procedural Blender models, pose fitted per frame | `tools/soi3d/framematch.py` |
| Full-screen art | `extracted/pict/` | `pict_hd` · `pict_hd_v2` (text panels re-rendered crisp) | `tools/upscale_picts.py`, `render_text_picts.py` |
| Music | `extracted/music/original/*.ogg` — the original game's music (emulator captures cut to one aligned loop) | `*.ogg` studio render of the extracted notes (per-screen mapping) | `tools/build_original_music.py`; `render_music*.py`, `qtma_to_midi.py` |
| SFX | `extracted/audio/wav/` | `wav_hd` (deterministic clean-up) · `wav_ai` (AudioSR super-res) | `tools/enhance_sfx.py`, `ai_super_sfx.py` |
| Win animations | `extracted/movies/*.ogv` | `movies_hd` (Real-ESRGAN 4×) | `tools/extract_win_movies.py`, `upscale_win_movies.py` |

## Analysis tools

The reverse-engineering + extraction tools are pure Python 3.10+ (`py tools/<name>.py`): e.g.
`parse_bord.py`, `rezfork.py`, `parse_pef.py`, `extract_assets.py`, `sssf_decode.py`, `pict_decode.py`,
`qtma_to_midi.py`, `pef_patch.py`. The headless Ghidra discovery pass lives in `analysis/ghidra/`.

## Documentation

- **[docs/remaster/](docs/remaster/)** — the remaster: architecture, running, the front-end flags, and
  the asset pipeline (current state).
- **[docs/](docs/)** — verified reverse-engineering findings about the original game (binary, resources,
  level format, graphics/audio, gameplay). Each claim is tagged CONFIRMED / HYPOTHESIS / TODO.
- **[plan/MASTER_PLAN.md](plan/MASTER_PLAN.md)** — architecture, determinism contract, oracle, schemas, scope.
- **[plan/EXECUTION_PLAN.md](plan/EXECUTION_PLAN.md)** — the phased execution plan.


