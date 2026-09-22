# Step On It! — Remaster

Documentation for the **remaster** (the running port), as opposed to the reverse-engineering
findings about the original game in [`../original_game/`](../original_game/). This is a living
doc that tracks the current state of the code + assets.

> Personal preservation project. The faithful SD assets and the original game files are never
> modified; every remaster asset is either a same-named upgrade or a parallel `_hd` folder the
> front-end can be pointed at, and everything under `extracted/` is regenerable from `raw_game/`
> via `tools/`.

## Architecture

Three layers, decoupled so the gameplay stays deterministic and testable on its own:

| Layer | Path | What it is |
|---|---|---|
| **Core** | `core/` | A freestanding, integer-only **C** reimplementation of the decompiled PowerPC game logic — movement/physics, the enemy roster + AI, weapons, goodies/scoring, the BORD level loader, win/lose, 1–3 players. No rendering, no OS calls; deterministic (serializes to a stable FNV-1a-64 state hash). |
| **Bridge** | `bridge/` | A thin **C++ `godot-cpp`** GDExtension exposing the C core as a `SoiCore` node (init / `tick` / accessors / serialize). Glue only — no game logic. |
| **Front-end** | `godot_project/` | The **Godot 4.3 / GDScript** presentation: `game.gd` (render + input + HUD), `main_menu.gd` / `menu.gd` (title + board picker), `audio.gd` (SFX + music autoload), `session.gd` (mode/board/high-scores). Draws from the C core's read accessors and the decoded assets. |

**Build:** portable **Zig** (`zig cc` / `zig c++`) compiles both the C core and the GDExtension —
no MSVC required. **Determinism** is enforced by `tests/` (mechanic unit tests, a two-run
reproducibility check, and a fixture-replay selftest against `board_401`).

## Build, run & verify

```
powershell -ExecutionPolicy Bypass -File tools/verify.ps1      # the gate: 6 stages must PASS
```

Stages: core mechanic tests → core harness + determinism → fixture-replay selftest → GDExtension
build → clean Godot import → rendered `--shot` screenshot. Run it after any core / bridge / GDScript
change. To play, open `godot_project/` in Godot 4.3 and press F5 (or `"<Godot>" --path godot_project`).

**Controls** — P1: arrows + Z (block-high) / X (block-low) / C (arrow) / V (ball); P2: WASD + F/G/H/J.
**M** toggles Retro ↔ Remastered display; **Tab** or **P** pauses; **Esc** → menu; **Enter** advances a
cleared board / retries after game over; **Ctrl-S** quick-saves.

### Front-end flags (after `--`)

`"<Godot>" --path godot_project --resolution 640x480 -- <flags>`

| Flag | Effect |
|---|---|
| `--hd` | Prefer the AI-upscaled `sprites_hd`/`sprites_uhd` + `pict_hd_v2`/`pict_hd`, and render the 640×480 canvas at the window's resolution (via `content_scale`) so the extra detail shows. SD default is byte-for-byte unchanged. |
| `--3d` | `--hd` plus the frame-matched 3D sprite overlay `extracted/sprites_3d_frames/<sheet>/fNN_WxH.png` (4×, same frame index as the original, so the game's own frame logic drives it). A frame with no 3D render falls back to HD. **F3** toggles HD ↔ 3D live. See `plan/SPRITE_REMASTER_PROCESS.md` §F. |
| `--mode=retro` / `--mode=remastered` | Start in the flat retro or the remastered look (also **M** in game). |
| `--players=3` | Enable the remaster's 3rd (red) co-op player. |
| `--board=board_NNN` | Load a specific board (harness / capture). |
| `--shot` / `--shotat=N` | Render, then screenshot after `N` frames (default 130) → `media/screenshots/`, then quit. |
| `--menushot=N` | Screenshot the main menu after `N` frames. |
| `--demo` | Play a scripted showcase (for movie capture), then quit. |
| `--play=N` | Play the loaded real board for `N` frames (movie capture), then quit. |
| `--hidden` / `--visible` | Force off-screen (hidden) / on-screen rendering. |
| `--sfx-variant=original` / `light` / `ai` | Pick the SFX set: faithful 8-bit (`wav`), cleaned 16-bit (`wav_hd`), or AudioSR super-res (`wav_ai`); env `SOI_SFX_VARIANT` also works. |

### Hidden / headless-style capture

Godot's own `--headless` uses the dummy renderer, so screenshots and movies come out **blank**.
Instead, capture runs render **off-screen**: `main_menu.gd` `_apply_window_mode()` moves the window
to `(9000, 9000)` — off the visible desktop (verified not clamped by Windows) but still **presenting**,
so `--shot` (which awaits `RenderingServer.frame_post_draw`) and `--write-movie` keep working.

- Auto-enabled by the capture flags (`--shot` / `--menushot` / `--demo` / `--play`); force with
  `--hidden`, keep the window on-screen with `--visible` (`record_video.ps1 -Visible`).
- Add `--position 9000,9000` to the launch to also skip the brief on-screen flash while the window is
  created (before `_ready` runs). `tools/verify.ps1` and `tools/record_video.ps1` already do this.
- **Do not minimize** to hide it: a minimized window never presents, so `--shot` hangs forever
  (movies still work minimized, screenshots don't).

## Assets & the remaster pipeline

Decoded assets live under `extracted/` (gitignored, regenerable). Each upgradeable class has a parallel
`_hd` folder; the front-end loads SD by default and the `_hd` set only in `--hd` mode.

| Class | SD (faithful) | Remaster (HD) | Tools |
|---|---|---|---|
| **Sprites** | `sprites/<sheet>/fNN_WxH.png` | `sprites_hd` (hqx pixel-clean) · `sprites_uhd` (Real-ESRGAN 8×) | `tools/upscale_sprites.py`, `tools/sssf_decode.py` |
| **3D sprites** | `sprites/<sheet>/fNN_WxH.png` = the per-frame reference | `sprites_3d_frames/<sheet>/fNN_{4W}x{4H}.png` (procedural Blender model, pose fitted + gated per frame; `--3d`) | `tools/soi3d/framematch.py` |
| **Full-screen art (PICT)** | `pict/*.png` | `pict_hd` → `pict_hd_v2` (general model; text panels **re-rendered** with the real font) | `tools/upscale_picts.py`, `tools/render_text_picts.py`, `tools/pict_decode.py` |
| **Music** | `music/*.mid` (QTMA extraction) | `music/*.ogg` (synth render, per-screen mapping) | `tools/qtma_to_midi.py`, `tools/render_music*.py` |
| **SFX** | `audio/wav/<sndid>_<name>.wav` | `wav_hd` (deterministic clean-up) · `wav_ai` (AudioSR super-res) | `tools/enhance_sfx.py`, `tools/ai_super_sfx.py`; loaded by `audio.gd` |
| **Win animations** | `movies/*.ogv` (decoded QuickTime video) | `movies_hd` (Real-ESRGAN 4×) | `tools/extract_win_movies.py`, `tools/upscale_win_movies.py` |
| **Levels** | `levels/board_*.bord` (+ `.json`) | — | `tools/extract_assets.py`, `tools/parse_bord.py` |

Notes:
- **HD PICT model split (lesson).** The anime model (`realesrgan-x4plus-anime`) is great on the 3D
  "squishy" headings but *melts* crisp serif body text (cyan fringing). `pict_hd_v2` uses the general
  `realesrgan-x4plus` for everything, and the fixed-text tally panels (1020/1021/303/304) are
  **re-rendered** with Times Bold (`render_text_picts.py`) instead of upscaled. Delete
  `extracted/pict_hd_v2/` to fall back to `pict_hd`.
- **Sprite loader.** `game.gd` parses the frame index from `f<NN>_...`; HD frames must keep the same
  `fNN` and RGBA alpha. Block/creeper sheets need hard alpha (soft fringes leak the cell behind).

## Music — per-screen mapping (RE-confirmed)

The original selects a QuickTime-music movie via `FUN_10018414(selector)`; the mapping was pinned from
the binary and ported into `audio.gd`. Full table + method in
[`../original_game/music-tracks.md`](../original_game/music-tracks.md). In brief:

- **Menu / title** → `6lilt`. **In-game** rotates `Cminor → bass_for_lunch → 6lilt` by `(level % 3)+1`,
  overridden by **`spooky`** on any board holding a **Knight or Gargoyle**. **Ending** (campaign beaten)
  → `Angel Pie`. The Sound → Music **Full / Light** setting picks the sparser `_thin` arrangement.
  Music is **off by default**, as in the original.
- The two-player **Compete** results screen plays the extracted **victory animations**
  (`blue wins` / `green wins` / `no winner`) — silent Apple-Animation video, wired via a
  `VideoStreamPlayer` in `game.gd`.

## Status

Playable and faithful to the decompiled original: movement/physics, the full 11-type enemy roster +
turrets, Magic Arrow/Ball, goodies + scoring + the bonus tally, colored key/door win, death/respawn/
game-over, and 1–3 player Cooperate / Compete / Alternate modes — all gated. Presentation work
(HD/AI sprites & art, music, SFX, win animations, hidden capture) is ongoing.

**Not yet built** (in scope per `plan/`, currently unrealized): online 2-player **netcode** (WebRTC
lockstep) and the in-engine **map editor**. The port is local-only today, with deterministic replay
(the `serialize` / `state_hash` ABI is the netcode/verification foundation). See
[`../../plan/REMASTER_PROMPTS.md`](../../plan/REMASTER_PROMPTS.md) for the parallel remaster tasks and
[`../../plan/MASTER_PLAN.md`](../../plan/MASTER_PLAN.md) for the architecture/determinism contract.
