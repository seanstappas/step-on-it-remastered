# Remaining Work — Step On It! Remaster (RE accuracy)

_Last updated: 2026-07-11._

## Status
The port is **comprehensively faithful** and all 152 boards are winnable. Player animation, core
physics (run/jump/fall/build), audio SFX coverage, death/respawn, blocks, goodies, and the main
enemy behaviours have been audited against the decompiled asm and fixed. **Everything below is a
refinement of tested-working behaviour, a cosmetic gap, or an unverified screen** — none are known
to break gameplay or winnability. Fix in the order listed (visible -> cosmetic -> RE-confirm).

## Working setup & how to verify
- **Core (C)**: `core/src/*.c` -> compiled by zig into `soi_bridge.dll`.
  Rebuild after any core change: `& .\bridge\build_zig.ps1` (**Windows PowerShell 5.1, NOT pwsh**).
  `godot_project/scenes/*.gd` (GDScript) needs **no** rebuild.
- **Decompiled reference**: `analysis/decomp/all/FUN_<hexaddr>.c` (Ghidra). Cited per item below.
- **zig**: `D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe`  -  **Godot**: `D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe`
- **Verify a core change** (always run all three):
  - Winnability -> `& $zig cc -std=c17 -O1 -Icore/include -Icore/src (Get-ChildItem core/src/*.c).FullName tools/verify_winnable.c -o vw.exe; .\vw.exe (Get-ChildItem extracted/levels/*.bord).FullName` -> expect `152 boards: 152 winnable, 0 BROKEN`.
  - Mechanics -> compile+run `tests/test_mechanics.c` -> `ALL MECHANIC TESTS PASSED`.
  - Determinism -> compile+run `tests/harness.c` -> `determinism: PASS`.
- **Record a visual**: `& .\tools\record_video.ps1 -Label <name> -Mode retro` -> writes `media/video/<name>_retro_<ts>.mp4`.
  To showcase a specific action, temporarily edit the `DEMO` const (`game.gd` ~line 25) using
  `IN_LEFT/IN_RIGHT/IN_JUMP/IN_BLOCK_HIGH/IN_BLOCK_LOW/IN_ARROW/IN_BALL` + hold-frame counts, record, then restore it.
  **BACK UP `game.gd` first** (`Copy-Item ... D:\SOI-tools\soi-backups\`) — a concurrent agent edits this repo.
- **Method warning**: exploration subagents proved unreliable on asm accuracy this project — **verify
  every claimed discrepancy against the asm + current code yourself** before changing anything.

---

## A. Gameplay-visible refinements (do first)

### A1. Cannon / spawner reload from the per-block SpawnDelay byte
- **Where**: `core/src/soi_enemies.c:14` (`#define SOI_CANNON_RELOAD 120`) + the spawner `fire_period` plumbing.
- **Current**: fixed 120-frame cadence for cannon shots; spawners use a stand-in interval.
- **Asm**: `FUN_100071a0` reloads to **SpawnDelay x 6** (the per-cell delay byte in the board data, ~20->~120).
- **Task**: capture the spawn-block delay byte during level load (`soi_state.c` load path / BORD parse) and
  feed it into the cannon reload and spawner `fire_period` instead of the constant.
- **Verify**: cannon/spawner fire interval matches the original per board; re-run winnable + mechanics.

### A2. Wheelie exact 8-direction wall-follow
- **Where**: `core/src/soi_enemies.c` -> `enemy_fly_bounce()` (~line 245).
- **Current**: gravity-free wall-follower that turns 90deg at a blocked cell, 2 px/frame, re-steers only when
  cell-aligned. Player-INDEPENDENT (verified: the asm never reads the player pos — it does **not** home).
- **Asm**: `FUN_10009e98` — an intricate 8-direction collision state machine (~30 `FUN_1000554c` probes),
  turn handedness at `+0x6e`.
- **Task**: port the exact 8-dir steering. Keep it player-independent + winnable.
- **Verify**: wheelie path matches the original on boards 2/3 (record + eyeball); winnable stays 152/152.

### A3. Hammer rise/hold/smash/drop choreography
- **Where**: `core/src/soi_enemies.c` -> `enemy_hammer_hop()` (~line 291).
- **Current**: walks flat 2 px/frame (correct), falls off ledges (correct), jump-smashes a **breakable** wall
  ahead + hops, turns at a **permanent** wall (all correct). The vertical hop is a short approximation.
- **Asm**: `FUN_10007998` (+ `FUN_10027aec` smash at X+0x1a,Y+0xa, sound event 0x11). Exact rise (`+0x12 -= 0xb`),
  hold, smash, drop timing.
- **Task**: match the exact vertical choreography timing. Behaviour is right; only the arc shape is approximate.

---

## B. Deferred / higher-risk

### B1. Creeper grow-chain (RISKY — winnability)
- **Where**: `core/src/soi_enemies.c` -> `enemy_creeper()` (~line 340). Cadence note at line 345.
- **Current**: modelled as **ONE** moving solid block that restores the cell it covers (winnability-safe).
  Step cadence approximated as a single timer (asm multi-counter at `+0x24/+0x26`).
- **Asm**: `FUN_10008618` (horizontal) / `FUN_10008b18` (vertical) — the real creeper **spawns a chain of
  child creepers** (`FUN_10005948`, x+0x20 ahead) that grow/shrink (`+0x56`, cap 0xf) up to the 32-enemy cap.
- **Task**: implement the grow-chain **with a winnability guard**. A growing solid chain can seal the key/door
  route — this is why it was deferred.
- **Verify**: re-run winnable on ALL 152 boards after (this is the main risk); mechanics + determinism.

---

## C. Cosmetic / low priority
- **C1. Death-throw somersault** — `game.gd` `PLAYER_DEATH_SPIN` (f118-125 forward loop). Asm `FUN_10011fcc`
  ping-pongs 0x75-0x7e. Render-verified acceptable; only the ping-pong wobble differs.
- **C2. Jump somersault per-frame timing** — `game.gd` `st == 2` branch advances off `tick_count()/2`. The
  core `jump_t` (`soi_internal.h`) is not exposed via a bridge accessor. Optional: add a `soi_player_jump_t`
  accessor for exact sync. **Direction + launch pose are already correct** (fixed 2026-07-09).
- **C3. Stop/Go switch sprite swap** — `core/src/soi_grid.c:136`. Gameplay is a verified no-op; only the
  animated sign swap is missing (cosmetic).
- **C4. Distinct spawner sprite** — `core/src/soi_state.c:247`. Currently renders the red nest cell + the
  child nasty standing on it (matches ref board_3); the original's dedicated spawner sprite is cosmetic.

---

## D. Needs RE investigation / confirmation
- **D1. Special-screen jingles 1500 / 1501 / 1502 (UNWIRED)** — `extracted/audio/wav/1500_challenge_round.wav`,
  `1501_HiScore.wav`, `1502_competition_winner.wav` exist and the port HAS the screens (challenge-round intro
  PICT 300, high-score name entry), but a grep of `godot_project/scenes/*.gd` shows **none of these snd ids
  are played**. In the snd event->snd table (`0x10037074`) they sit at game events **0x35/0x36/0x37**.
  **Task**: find the exact trigger in the asm, then play them via `Audio.play_snd(1500/1501/1502)` at the right
  screen (challenge-round entry / new-high-score / competition winner). Confirm the screen actually fires first.
- **D2. RNG stream** — `core/src/soi_rng.c:13`. Confirm the Mac Toolbox `Random()` (`0x100321b0`) IS the
  minimal-standard (Park-Miller) stream the port implements, not a different PRNG. Affects random-spawn parity.
- **D3. Goody point values** — `core/src/soi_grid.c:27`. Coin/gem values CONFIRMED; the **other goody point/
  score values are first-draft**. Confirm vs rezfork / asm `FUN_1002bc64`.
- **D4. Beanie-child cleanup + death chain reactions** — `core/src/soi_enemies.c:173`. Verify the Beanie
  parent<->child bookkeeping on death and any chain reactions match the asm.

---

## Reference: fixes already shipped (do NOT redo)
Run-flip (PLAYER_RUN 25->37 head-forward), idle directional (f52 native left), auto wall-rebound (core, asm
FUN_10012554), build/fire pose priority + directional, straight-down cliff-fall (core, fall has no input-steer),
left-jump somersault (native **f127-133** tumble, launch-synced — f126 is the 36x34 DEATH arm-flap and is
EXCLUDED from the jump), death-throw arm-flap ping-pong f118-126 (non-mirror), HURRY sound mapping
(audio event 39 -> snd 1007). See `media/video/latest_fixes_v2_retro_20260711_*.mp4` for the animation fixes.
The recurring bug class was **directional sprite blocks wrongly mirrored by facing** — the original never
mirrors by facing (pre-drawn L/R blocks), so any `flip = not right` over a rotation/tumble is suspect.
NB on the player sheet: **f118-126 = 36x34 DEATH arm-flap** (arms up/down), **f127-141 = 32x31 JUMP tumble**
(curled rotation) — do not mix them; the arms-up f126 is death-only.
