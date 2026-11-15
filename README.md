# Step On It! — Remastered

A faithful remaster of the 1996 Casady & Greene Mac game **Step On It!** for modern platforms
(Windows first). The original PowerPC game logic was **decompiled** into a deterministic, headless
**C core** (`core/`), wrapped with a thin **C++ (`godot-cpp`)** GDExtension (`bridge/`), and driven by
a **Godot 4.3 / GDScript** front-end (`godot_project/`) with a retro ↔ remastered ("D2R"-style) toggle.
Personal preservation project.

> **Status: playable.** The C core, the GDExtension bridge, and the Godot front-end all build and pass
> the one-command gate ([tools/verify.ps1](tools/verify.ps1) — 16 stages). Gameplay is faithful to the
> decompiled original (movement, the full enemy roster, weapons, scoring, win/lose, and 1–3 player
> co-op / compete / alternate); the presentation is being remastered (HD/AI sprites & full-screen art,
> per-screen music, cleaned SFX, the extracted win animations). RE findings are in [docs/](docs/); the
> remaster is documented in [docs/remaster/](docs/remaster/).

## Repo layout

Directories use `snake_case`. Source code, RE decompilations, and base decoded assets are tracked in git; original copyrighted disks, build outputs, and heavy multi-GB HD/3D render caches are `.gitignore`d (regenerable via `tools/`).

```
raw_game/            # LOCAL INPUT (gitignored) — untouched original Mac game (source of truth)
refs/                # LOCAL INPUT (gitignored) — manuals, reference cards, emulator captures
core/                # C game core — deterministic, decompiled gameplay logic
bridge/              # C++ godot-cpp GDExtension shim (the `SoiCore` node) wrapping the C core
godot_project/       # Godot 4.3 front-end — scenes/*.gd, project.godot, soi.gdextension
tests/               # C mechanic/synctest/launcher unit tests + fixture-replay harness
tools/               # Python + PowerShell + C launcher: asset decode, 3D/AI upscale, Velopack, gate
docs/                # RE findings (docs/original_game/) + remaster docs (docs/remaster/)
plan/                # MASTER_PLAN.md, SPRITE_REMASTER_PROCESS.md, STATUS.md, REMAINING_WORK.md
analysis/            # Ghidra scripts + tracked PowerPC decompilation (analysis/decomp/)
extracted/           # Decoded base assets (tracked: levels/, palette/, cicn/, sprites/, pict/, music/, audio/)
                     # + local HD/3D overlays (gitignored: sprites_3d_frames/, sprites_uhd/, pict_hd*/)
media/               # LOCAL OUTPUT (gitignored) — captured verification screenshots & videos
build/ releases/     # LOCAL OUTPUT (gitignored) — exported StepOnIt.pck, StepOnIt.exe & Velopack packages
```

## Build, run & verify

Portable toolchain under `D:\SOI-tools\` (paths set in the tool scripts): **Zig** (`zig cc` / `zig c++`
builds the C core **and** the GDExtension — no MSVC needed), **Godot 4.3**, Python 3.10+, and ffmpeg.

**Gate — build + test + validate in one command:**

```
powershell -ExecutionPolicy Bypass -File tools/verify.ps1
```

Sixteen stages must PASS: core mechanic unit tests, core harness + determinism, rollback synctest,
fixture-replay selftest, creeper chain simulation, ascii2bord unit tests, ascii2bord roundtrip, 3D sprite frames,
the GDExtension build, clean Godot import, rendered `--shot` screenshot, rollback soak test, 3-player
adversarial soak, net edge cases & peer drops, online progression & retry sync, and headless map editor self-test.
Pass `-TestPackaging` (or run `tools/publish_velopack.ps1 -Version X.Y.Z`) to also build and smoke-test the standalone Windows `StepOnIt-win-Setup.exe` installer and `<5 MB` Velopack delta updater.

### Release & install (private friend testing)

Windows builds are packaged with Velopack (`tools/publish_velopack.ps1`) and published to GitHub Releases on the private repo (`https://github.com/seanstappas/step-on-it-remastered`):

- **Save read-only embed token (once on dev PC):** Generate a fine-grained PAT (`Contents: Read-only` on `seanstappas/step-on-it-remastered`) and save it outside git via `powershell -ExecutionPolicy Bypass -File tools/set_release_token.ps1 -FromClipboard` (`%LocalAppData%\StepOnIt\release_embed_token.txt`).
- **Publish a release:** `powershell -ExecutionPolicy Bypass -File tools/publish_velopack.ps1 -Version X.Y.Z -UploadToGitHub` (writes token-free `update_config.json`, XOR-embeds the saved read-only token into `StepOnItLauncher.exe`, uses `$env:GITHUB_TOKEN` or falls back to `gh auth token`, and skips prior-release download on the first release).
- **Install & auto-update:** Friends just run `StepOnIt-win-Setup.exe`, which installs to `%LocalAppData%\StepOnIt\current\StepOnItLauncher.exe` (spawning `StepOnIt.exe` + `StepOnIt.pck`) with zero token setup needed. Existing installs can still override/rotate a token via `StepOnItLauncher.exe --set-update-token <token>` (or `SOI_UPDATE_TOKEN`).
- **Full guide:** See [docs/remaster/TESTING_WITH_FRIENDS.md](docs/remaster/TESTING_WITH_FRIENDS.md) for creating/saving/rotating the read-only token, installer/SmartScreen steps, and online play (UDP `7777`, Tailscale / port-forwarding, build-ID matching).

**Play:** `.\play.ps1` (starts REMASTERED with music on, window sized to your monitor), or open
`godot_project/` in Godot 4.3 and press F5, or `"<Godot>" --path godot_project`.
Controls — P1: arrows + Z/X/C/V, P2: WASD + F/G/H/J. **F2** switches the whole presentation live —
**ORIGINAL** (1996 art, 8-bit SFX, the original game's music) ↔ **REMASTERED** (frame-matched 3D
sprites, remastered SFX, studio music remaster) — on the title menu and mid-board. **F3** toggles 3D ↔
HD sprites within REMASTERED, **F4** toggles real-time 3D (the players, most enemies and projectiles are
posed and rendered live every frame from their 3D rigs) ↔ pre-rendered 3D frames, **M** toggles the Retro ↔ Remastered display effects; **Tab** pauses.
REMASTERED draws at the monitor's refresh rate: the engine keeps the original tick, and each sprite is
drawn between its engine states with rendered in-between 3D poses (shown 2 ticks, ~33 ms, behind the
engine). ORIGINAL draws once per tick, as in 1996.

**Map Editor** — Click **Map Maker** on the main menu (or run `res://scenes/editor.tscn` directly). Features a classic System 7 Mac interface, 25 authentic 3D block families, StarCraft/Warcraft-style collapsible palette with tile count badges, variant chips (`[Wall | Brk | Bkg | Hid]`), 1:1 mathematically square grid layout with metallic bezel, Map Properties modal dialog, EXT1 trailer roundtrip serialization, and instant in-memory playtesting.
- **Controls in Editor**: Left Click = Paint brush; Right Click = Sample tile (Eyedropper); **[F]** = Toggle enemy facing left/right; **[R]** = Toggle remastered 3D graphics on board; **[Tab]** = Instant playtest board; **[Esc]** = Return to editor from playtest (or exit editor).

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
| `--test-editor` | Run headless Map Editor self-test (grid sizing, round-trip serialization, catalog asset audit). |
| `--editorshot` | Render off-screen Map Editor screenshot with sample tiles → `media/screenshots/editor_palette_verified.png`. |
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
| 3D sprites | `extracted/sprites/` (the per-frame reference) | `sprites_3d_frames` (4×, same `fNN` per frame) — procedural Blender models, pose fitted per frame; `tw/` = in-between poses for the smooth REMASTERED rendering; `sprites_live/<family>` = a rig for real-time 3D (Robo) | `tools/soi3d/framematch.py` (`tweens`, `live` stages) |
| Full-screen art | `extracted/pict/` | `pict_hd` · `pict_hd_v2` (text panels re-rendered crisp) | `tools/upscale_picts.py`, `render_text_picts.py` |
| Music | `extracted/music/original/*.ogg` — the original game's music (emulator captures cut to one aligned loop) | `*.ogg` studio render of the extracted notes (per-screen mapping) | `tools/build_original_music.py`; `render_music*.py`, `qtma_to_midi.py` |
| SFX | `extracted/audio/wav/` | `wav_hd` (deterministic clean-up) · `wav_ai` (AudioSR super-res) | `tools/enhance_sfx.py`, `ai_super_sfx.py` |
| Win animations | `extracted/movies/*.ogv` | `movies_hd` (Real-ESRGAN 4×) | `tools/extract_win_movies.py`, `upscale_win_movies.py` |

## Analysis tools

The reverse-engineering + extraction tools are pure Python 3.10+ (`py tools/<name>.py`): e.g.
`parse_bord.py`, `rezfork.py`, `parse_pef.py`, `extract_assets.py`, `sssf_decode.py`, `pict_decode.py`,
`qtma_to_midi.py`, `pef_patch.py`. The headless Ghidra discovery pass lives in `analysis/ghidra/`.

## Documentation

- **[AGENTS.md](AGENTS.md)** — **Agent Handover & Contributor Guide**: technical architecture, critical invariants, gate execution, and system rules for AI agents and developers.
- **[docs/remaster/](docs/remaster/)** — the remaster: architecture, running, the front-end flags, and
  the asset pipeline (current state).
- **[docs/remaster/TESTING_WITH_FRIENDS.md](docs/remaster/TESTING_WITH_FRIENDS.md)** — private GitHub Releases packaging, embedded read-only update token setup/rotation, installer/SmartScreen steps, and online play (UDP `7777` / Tailscale / port-forwarding).
- **[docs/](docs/)** — verified reverse-engineering findings about the original game (binary, resources,
  level format, graphics/audio, gameplay). Each claim is tagged CONFIRMED / HYPOTHESIS / TODO.
- **[plan/MASTER_PLAN.md](plan/MASTER_PLAN.md)** — architecture, determinism contract, oracle, schemas, scope.
- **[plan/EXECUTION_PLAN.md](plan/EXECUTION_PLAN.md)** — the phased execution plan.


