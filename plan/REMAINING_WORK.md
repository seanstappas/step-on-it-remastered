# Remaining Work — Step On It! Remaster (RE accuracy)

_Last updated: 2026-07-12._

## Status
The port is **comprehensively faithful** and all 152 boards are winnable. Player animation, core
physics (run/jump/fall/build), audio SFX coverage, death/respawn, blocks, goodies, and the enemy
behaviours have been audited against the decompiled asm and fixed. **All A/B gameplay items are now
shipped** (enemy fall-death, cannon/spawner reload, wheelie wall-follow, hammer choreography, creeper);
what remains (§C, §D2) is **cosmetic polish or an external emulator confirmation** — none affect
gameplay or winnability. All three gates are green (mechanics / 152-winnable / determinism
`0xc677624ae3878b5e`).

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

## A. Gameplay-visible refinements — ALL SHIPPED

### A0. Edge-turner fall-death (bug #3) — ✅ SHIPPED (2026-07-12)
- **Where**: `core/src/soi_enemies.c` `enemy_step()` gravity branch (~line 531) + `enemy_dies_on_fall()` (~485) + `nearest_player()` (~493).
- **Behaviour**: pulling the block out from under a patrolling **Robo/Walker** (the two edge-TURNER AIs)
  drops it **straight down** (x fixed, `y += 4`/frame) and it **DIES** on landing — kill sound (ding) +
  score to the nearest player + death flag. Edge-WALKERS (Ant/Ostrich/Hippo/Piggy/Smiley/Teeth) fall
  harmlessly and resettle (they walk off ledges by design).
- **Asm-verified (2026-07-12)**: Robo `FUN_1000a780` / Walker `FUN_1000dd4c` are the ONLY two AIs that
  call the credit selector `FUN_1000581c`; their fall branch, on landing (`FUN_10005750` two-foot ground
  probe returns 0 = supported), plays sound event 10, adds points to the credit player (`+0x1003a9ec`,
  stride 0x70), sets the death flag (`+0x68=1`) and spawns a death effect. No other AI has this path.
- **Proof**: `tests/test_mechanics.c` blocks `8g3b` (Robo dies) + `8g3c` (Ant survives), and
  `media/video/bug3_robo_falldeath_retro_*.mp4` (Robo visibly falls straight down and dies).

### A1. Cannon / spawner reload from the per-block SpawnDelay byte — ✅ SHIPPED
- **Where**: loader `core/src/soi_state.c` (~241/250/265/273) sets `e->fire_period = SpawnDelay*6`; every
  shooter/spawner in `soi_enemies.c` uses `fire_period` when > 0. `SOI_CANNON_RELOAD 120` is now only a
  fallback for enemies spawned without a board delay byte (procedural/test spawns).
- **Asm**: `FUN_100071a0` reloads to **SpawnDelay×6** — matched.

### A2. Wheelie exact 8-direction wall-follow — ✅ SHIPPED
- **Where**: `core/src/soi_enemies.c` `enemy_fly_bounce()` (~line 283) + `wheelie_solid()` (~262).
- **Behaviour**: full two-handedness (mode 1/2, locked to spawn heading), 4-heading (L/U/R/D) wall-follow
  with pixel-level solid probes at the exact asm offsets — rounds obstacle perimeters, player-INDEPENDENT
  (no homing), 2 px/step. Matches `FUN_10009e98`.

### A3. Hammer rise/hold/smash/drop choreography — ✅ SHIPPED
- **Where**: `core/src/soi_enemies.c` `enemy_hammer_hop()` (~line 363).
- **Behaviour**: walks flat (2 px/frame), falls off ledges, turns at a permanent wall; at a breakable wall
  it does the FIXED-LIFT jump-smash — rise 11 px, hold, **smash on the 11th held step** (`SOI_SFX_ROBO_PUNCH`,
  asm sound 0x11), drop 11 px, walk on. Matches `FUN_10007998` (+0x6e counter, +0x5a lift).

---

## B. Deferred / higher-risk

### B1. Creeper grow-chain — ✅ RESOLVED (winnability-safe model kept by decision)
- **Where**: `core/src/soi_enemies.c` `enemy_creeper()` (~line 434); full rationale in the comment above it (~411).
- **Decision**: keep the **ONE-moving-block** model (restores the cell it covers → cannot permanently seal
  a route). The real asm (`FUN_10008618`/`FUN_10008b18`) spawns a transient forward-creeping **chain** of
  child creepers (`FUN_10005948`, +0x20 ahead; grow/shrink `+0x56` cap 0xf). It is **not** ported because
  (1) `tools/verify_winnable.c` is a STATIC key→door topology check that never steps enemies, so the gate
  **cannot validate any creeper motion**, and (2) a tile-restore bug in a growing solid chain could create
  an **undetectable permanent-seal** unwinnability. Shipping it would keep the gate green with zero assurance.

---

## C. Cosmetic / low priority (the only remaining code work — all gameplay-neutral)
- **C1. Death-throw somersault — ✅ DONE.** `game.gd` `PLAYER_DEATH_SPIN` now ping-pongs
  (`[118..126, 125..119]`), matching the asm `FUN_10011fcc` 0x75–0x7e ping-pong.
- **C2. Jump somersault per-frame timing — ⏸ DEFERRED (cosmetic).** `game.gd` `st == 2` advances off
  `tick_count()/2`; the core `jump_t` (`soi_internal.h`) has no bridge accessor. Exact sync would need a
  `soi_player_jump_t` accessor (core + bridge + gd). **Direction + launch pose are already correct.**
- **C3. Stop/Go switch sign swap — ⏸ DEFERRED (cosmetic).** `core/src/soi_grid.c:136`. Gameplay is a
  verified no-op; only the animated sign-sprite swap is missing.
- **C4. Distinct spawner sprite — ⏸ DEFERRED (cosmetic).** `core/src/soi_state.c:247`. Currently renders
  the red nest cell + the child nasty standing on it (matches ref board_3); a dedicated spawner sprite is polish.

_C2–C4 are cosmetic-only, gameplay-neutral, and touch shared core/bridge/render files; deferred to avoid
regressing the green gates for no gameplay benefit._

---

## D. RE investigation / confirmation
- **D1. Special-screen jingles 1500 / 1501 / 1502 — ✅ SHIPPED.** Wired in `game.gd`: `play_snd(1500)` on the
  Challenge-Round intro (event 0x35, ~line 905), `play_snd(1501)` on new-high-score entry (0x36, ~1067),
  `play_snd(1502)` on the competition-winner screen (0x37, ~644).
- **D2. RNG stream — ⚠ IMPLEMENTATION COMPLETE, external confirm pending.** `core/src/soi_rng.c` implements the
  minimal-standard **Park-Miller** stream and determinism is locked (`0xc677624ae3878b5e`). Confirming it is
  byte-identical to the Mac Toolbox `Random()` (`0x100321b0`) would require running the original in an
  **emulator** (not available here). No gameplay/winnability impact; random-spawn parity is the only risk.
- **D3. Goody point values — ✅ CONFIRMED.** `core/src/soi_grid.c` values checked vs the in-game roster / asm.
- **D4. Beanie-child cleanup + chain reactions — ✅ VERIFIED.** `core/src/soi_enemies.c` parent↔child bookkeeping
  on death audited against the asm.

---

## Reference: fixes already shipped (do NOT redo)
Run-flip (PLAYER_RUN 25->37 head-forward), idle directional (f52 native left), auto wall-rebound (core, asm
FUN_10012554), build/fire pose priority + directional, straight-down cliff-fall (core, fall has no input-steer),
left-jump somersault (native **f127-133** tumble, launch-synced — f126 is the 36x34 DEATH arm-flap and is
EXCLUDED from the jump), death-throw arm-flap ping-pong f118-126 (non-mirror), HURRY sound mapping
(audio event 39 -> snd 1007). See `media/video/latest_fixes_v2_retro_20260711_*.mp4` for the animation fixes.
Player-reported (level 1): **bug #1** build/destroy is now allowed **mid-air** (while jumping/falling);
**bug #2** build/destroy pose is the correct directional frame (no longer wrong/flipped);
**bug #3** edge-turner (Robo/Walker) fall-death — see §A0.
The recurring bug class was **directional sprite blocks wrongly mirrored by facing** — the original never
mirrors by facing (pre-drawn L/R blocks), so any `flip = not right` over a rotation/tumble is suspect.
NB on the player sheet: **f118-126 = 36x34 DEATH arm-flap** (arms up/down), **f127-141 = 32x31 JUMP tumble**
(curled rotation) — do not mix them; the arms-up f126 is death-only.
