# Remaining Work — Step On It! Remaster (RE accuracy)

_Last updated: 2026-09-22 (§F play-mode / challenge-round audit)._

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

### B1. Creeper grow-chain — ✅ DONE 2026-09-22 (faithful asm chain, see F16)
- **Where**: `core/src/soi_enemies.c` `soi_creeper_init()` / `enemy_creeper()`; safety net
  `tools/verify_creepers.c` (gate stage 4).
- History: the one-moving-block stand-in was kept at first because `tools/verify_winnable.c` is a static
  key->door check that never steps enemies, so a tile-restore bug in a solid chain could seal a route
  unseen. The user chose to match the original; the dynamic safety net below was added first.

---

## C. Cosmetic / low priority (the only remaining code work — all gameplay-neutral)
- **C1. Death-throw somersault — ✅ DONE.** `game.gd` `PLAYER_DEATH_SPIN` now ping-pongs
  (`[118..126, 125..119]`), matching the asm `FUN_10011fcc` 0x75–0x7e ping-pong.
- **C2. Jump somersault per-frame timing — ⏸ DEFERRED (cosmetic).** `game.gd` `st == 2` advances off
  `tick_count()/2`; the core `jump_t` (`soi_internal.h`) has no bridge accessor. Exact sync would need a
  `soi_player_jump_t` accessor (core + bridge + gd). **Direction + launch pose are already correct.**
- **C3. Stop/Go switch sign swap — ✅ DONE.** `game.gd` flips the group's signs through their 8-frame
  run when a switch is stepped (`_sg_toggled`/`_sg_anim`); gameplay remains a verified no-op.
- **C4. Distinct spawner sprite — ✅ DONE (F12).** Spawners draw their sheet's emblem block (the frame
  the old extractor dropped), matching refs/images/board_3.png.

_C2–C4 are cosmetic-only, gameplay-neutral, and touch shared core/bridge/render files; deferred to avoid
regressing the green gates for no gameplay benefit._

## D. Frame-matched 3D sprites (remaster art, opt-in `--3d`) — 🚧 IN PROGRESS
- Pipeline built and gated: `tools/soi3d/framematch.py` + `frames_blender.py`; the game's `--3d`
  overlay with F3 toggle; gate stage 5. Process and status are in
  [SPRITE_REMASTER_PROCESS.md §F](SPRITE_REMASTER_PROCESS.md).
- Play-testable: `.\play.ps1` starts REMASTERED with music; **F2** switches the whole presentation live
  (title menu + mid-board): ORIGINAL = SD art, 8-bit SFX, the original game's music (captures cut to
  aligned loops by `tools/build_original_music.py`) ↔ REMASTERED = 3D over HD, remastered SFX, studio
  music (same playback position). Not captured yet: `Angel_Pie` and the `_thin` (Light) arrangements
  of the original music (they fall back as documented in `docs/original_game/music-tracks.md`).
- REMASTERED renders at the monitor's rate with in-between 3D poses (`framematch.py tweens`, 28
  families). Still stepped: the WIP families (HD only), the Stop/Go sign flip (drawn with the board),
  and the 4 pairs the in-between check dropped.
- Real-time 3D (F4): 23 families render live in game from their rigs (`framematch.py live` / `livecal` /
  `livegate` -> `gate.json`). Still pre-rendered: the procedural-texture families (weapons, egg, gift
  box, M block: bake their shader textures for glTF) and the Beenie's right shot / winged shoe.
- Published (1079 frames): the Robo (80), both players' run f02-f49 (48 + 48) and f50-f117 (68 + 68), the speed indicator's winged shoe (30), board blocks (150) and the '?' tile (6), every goody (51: coins, clocks,
  mult, keys, doors, arrow and switch tiles, turtle, gift, shield, helmet, shoe, ...), the speed
  indicator's spinning shield (30), Teeth (49), the Walker (48), the
  Beenie spread shot (48, three of its four directions), Smiley (48), Stop/Go
  (40), Hippo (32), Piggy (32), Wheelie (24), cannon ball (20) and barrel (2), Spinner (16), Walker bolt
  (16), the M block collapse (15), the Gargoyle egg (15), Gargoyle pierce puff (15) and green puff (15),
  Knight's gift box (15), the transporter zap (15), the player's swirl ball (8) and arrow (2), all seven
  nasties' spawner blocks (7), and both players' cheer (9 + 9).
- Published 2026-09-27 (live rigs too): the Ant (49/49), both players' tumble (`BP_tumble`,
  `GP_tumble`, 32/32 each) and the Ostrich (32/32 under a documented gate dE 17.75: f32 17.7) --
  27 families now render live under F4.
- WIP with notes (frames passing / total, 2026-09-27): the Hammer walk (27/48; every fail is colour,
  dE 16-21, limited by the legs' positions), the Gargoyle (32/73; rebuilt with raised arms, looped horns,
  the red striped ball and the wings wrapped in front as a cloak for f02-f10 -- refit in progress), the
  Knight (0/65; refit held front-facing in progress), the Beenie character (0/56; shape now IoU 0.87, the
  head rendered as all hair -- cap, hair band and face re-laid, look in progress), the Beenie's down shot
  (0/16; three thick bars tumbling toward the camera, needs per-bar 3D angles).
- Not started:
  - The Hammer's swing: a rigged procedural model with per-limb pose keys fitted
    per frame by `optim`, as for the Hippo and Piggy (`quadruped.py`).

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

## E. Physics-divergence audit (2026-07-13) — 6 SHIPPED, 4 DEFERRED
A line-by-line re-audit of the player physics core vs the decomp surfaced 8 real divergences; a subsequent
blind precommit review (5 rounds, `eg-goldfish-reviewer`) surfaced 2 more (E9, E10). Each was verified
personally against the asm (per the method warning). The 6 low-risk, player-observable ones are **fixed with
failing-test-first coverage** (tests 31–40 in `tests/test_mechanics.c`); all gates stay green and the harness
hash is unchanged (`0xc677624ae3878b5e` — the walk-on-floor scenario exercises none of them).

**Shipped fixes:**
- **E1. Death-throw was drifting X — ✅ FIXED.** `soi_physics.c` `death_step` added a phantom `p->x += ±1`
  every 3rd frame; asm `FUN_10011fcc` writes **only Y** (the parabola) + the animation ping-pong facing,
  never X. Removed the drift — the somersault is now purely vertical. Most player-visible. (test 31)
- **E2. Transporter fired mid-straddle — ✅ FIXED.** `soi_grid.c` transporter-IN branch had no straddle
  guard; asm `FUN_1002bc64:44-49` suppresses the teleport for types 0x1a-0x22 when `col(x+0x12) != col(x+0xc)`
  (the box spans two columns). Added the guard so an IN only fires once the box is truly over one cell. (test 32)
- **E3. Wall-rebound used post-push X — ✅ FIXED.** `soi_physics.c` `wall_rebound` used the already-pushed
  `p->x` for the right-side probe; asm `FUN_10012554` snapshots `iVar4=x` at entry and uses it for **both**
  side checks. Snapshotted `orig_x` — a one-wall wedge now nets zero X instead of drifting +2. (test 33)
- **E4. Rising jump never re-checked headroom / rebounded every frame — ✅ FIXED.** `soi_physics.c` called
  `wall_rebound` unconditionally each air frame (via `air_drift`) and never re-tested headroom mid-rise. Asm
  `FUN_10013404:24-32`: during the rise (`jump_t<8`) it re-runs the headroom check (`FUN_10012444`) and stalls
  the leap to the apex (`jump_t=0xc`) if a solid cell now sits overhead — e.g. a block you built while rising;
  past the rise (`jump_t>=8`) it runs wall-rebound **instead**. Added `headroom_clear()` + the pre-increment
  branch; moved wall-rebound out of `air_drift` into the jump/fall steps. (test 34)
- **E9. Wall-rebound ran on the POST-step Y — ✅ FIXED.** After E4 moved wall-rebound into the jump/fall steps,
  both the jump's rebound (past the rise, `jump_t>=8`) and the gravity fall's rebound still ran **after** the
  y-step, probing rows ~4 px too low. Asm runs each on the **PRE-step** Y: `FUN_10013404` line 31 (before the
  line 38 arc-step) and `FUN_1001386c` line 9 (before the line 19 `y+=4`). Reordered both so rebound reads the
  pre-step Y; `fall_step` now runs rebound unconditionally-first (the asm fall has no pit-death of its own — the
  port's `y>=446` death is a port addition). (tests 35, 36; tests 37/38/33b further pin the headroom two-column
  probe and the rise-skips-rebound split.)
- **E10. A dead player could still build/fire mid-air — ✅ FIXED.** The port gated the walk-over pickup on the
  death state but NOT the airborne build/fire dispatch, so a player mid death-throw could still drop blocks /
  fire. Asm `FUN_1001166c` line 13 gates the **entire** per-player update — the build/fire action **and** the
  movement state machine — on the death flag; the caller `FUN_1002a308` line 89 gates the pickup `FUN_1002bc64`
  on that **same** flag. Restructured `soi_player_update` to a single top-level `SOI_ST_DEAD` short-circuit
  (`death_step; return;`) that reproduces both asm gates and no longer relies on the `DEAD ⇒ in_air` invariant.
  (tests 39, 40)

**Deferred (higher-risk or determinism-sensitive — documented, not changed):**
- **E5. Door exit has an extra `has_key==1` gate — ✅ FIXED 2026-09-22 (see F3).**
- **E6. Door exit missing row-alignment — ✅ FIXED 2026-09-22 (see F3).**
- **E7. Bonus-timer death fires one tick early — ⏸ DEFERRED.** `soi_state.c:384` triggers death at
  `bonus_time==0`; asm `FUN_1000f500:17-27` decrements, clamps to 0, then dies when it goes **<0** (survives the
  0 tick). BUT existing asm-cited test #27 encodes death-at-0 **and** respawn doesn't reset `bonus_time`, so
  flipping to `<0` risks a respawn death-loop. Needs the respawn-reset interaction resolved first (not derivable
  from `FUN_1000f500` alone).
- **E8. Speed-shoes input latch — ✅ FIXED 2026-09-22 (see F6).**

---

## F. Play-mode / session-flow audit (2026-09-22) — 6 SHIPPED
The per-board mechanics were already audited; this pass checked the **session layer** (mode setup,
board sets, challenge rounds) against the decomp. `r2 = 0x10034170` resolves the `local_XX + 0x69fc`
style globals: `+0x69fc` = `DAT_1003ab6c` (Compete), `+0x69fe` = `DAT_1003ab6e` (two players at once),
`+0x759e` = `_DAT_1003b70e` (player count), `+0x5260` = `DAT_100393d0` (saved game being resumed).
- **F1. New-game stats — ✅ FIXED.** `FUN_1002b060`: every player starts with **2 lives / 1 arrow /
  1 ball**; only Cooperate's shared pool gets 4 / 2 / 2. The port started a solo game on 4 / 2 / 2
  (two free lives). `refs/images/board_1.png` + `board_3.png` HUD read `02 / 01 / 01`. New core
  `soi_new_game(w, mode)`; `soi_world_init` defaults are now the One-Player values. (test 47)
- **F2. Cooperate = one shared pool — ✅ FIXED.** Mode 3 (`DAT_100370e4 == 0`) redirects every
  score / lives / ammo / multiplier / time-bonus / No-Weapons credit to player 1's slot
  (`FUN_1002bc64`, `FUN_1000e9c8`, `FUN_10010d30`, `FUN_100110b4`, `FUN_10011428`, ...), ticks ONE
  Bonus whose runout kills every player (`FUN_1000f500`), and tallies once. Core `soi_pool()`.
  P2's coins used to land in an invisible P2 score. (test 48)
- **F3. Keys are shared outside Compete; the door has no held-key test — ✅ FIXED (was E5/E6).**
  `FUN_1002bc64` sets both players' key flag unless `DAT_1003ab6c`; the exit checks door bit + type +
  player + `row(y) == row(y+0x10)`, never a held key (no board ships a pre-opened door, verified by
  scan). Co-op partners can now leave through a door the other opened. (tests 48b, 48c)
- **F4. Compete plays boards 1001-1050 — ✅ FIXED.** `FUN_1002b448` loads `BORD N+1000` when the
  Compete flag is set; those boards carry the per-player keys 8/9. The port called them "Challenge"
  boards and played 401-500 in Compete. `Session.start_campaign()` + level-select now stay in-set.
  Compete HUD draws both players' rows (`FUN_1000fb18` y=0 / y=0x10).
- **F5. Challenge Round = a board with a Knight or Gargoyle — ✅ FIXED.** `FUN_10017a70` sets
  `DAT_1003ad0e` from the live enemies (boards 410, 420 ... 500). `FUN_10016c90` snapshots
  score/lives/ammo + shows PICT 300; on exit `FUN_10016f80(0)` pays Bonus x mult (no No-Weapons
  Reward, no PICT 1000 tally, the warp still plays); on death `FUN_10016f80(1)` restores the snapshot
  (no life lost) and the board is skipped anyway. Core `soi_challenge_round/failed`. (test 50)
- **F6. Shield/shoes share one power-up slot; shoes sample input every frame — ✅ FIXED (was E8).**
  `FUN_10014c28`/`FUN_10014ccc` write the same `+0x5c` mode / `+0x6e` timer; `FUN_10028a0c` drops the
  input divider to 1 while `+0x5c == 1`. (tests 49, 49b)
- Alternate: 3 attempts per player (2 reserve lives), ammo carried per player between turns.
- **F7. Gargoyle throw — ✅ FIXED.** `FUN_1000adc4` rolls Random(100) vs `pct_badguy` on every throw:
  at/below it `FUN_1000bf54` lobs a harmless type-200 EGG (not an UltraBuster, as older notes said)
  to a random empty cell in the top 3 rows, which `FUN_1000b6a0`/`FUN_1000b7dc` hatch into the
  `thrown_badguy` nasty (5 Hippo, 6 Hammer, 10 Teeth, 11 Smiley, 12 Ant, 19 Piggy, else Ostrich;
  life 400). Otherwise `FUN_1000b44c` fires the aimed puff (pierces at `pct_ultrabuster` odds). The
  port instead spawned `thrown_badguy` (mis-mapped: 10 -> Walker) at the top of the board every 120
  ticks -- removed. The puff (`FUN_1000b0a4`) had a made-up 28-frame range and died on the Gargoyle's
  own cage: the cage blocks are permanent low **0x8b**, which the puff passes through, so on boards
  410-500 the Gargoyle never reached the player. Now: no range limit, cage pass-through, 3-probe
  collision, enemy-box player hit. Puff/egg drawn with their `master's objects` (sssf 134) frames:
  piercing puff f02-16 (red/blue), normal f32-46 (green), egg f47-59. (tests 24, 51; videos
  `verify_gargoyle_puff_*`, `verify_gargoyle_egg_*`)
- **F8. Turrets / hurtboxes / stamps — ✅ FIXED.** Gargoyle phase lengths `64*max(1,b*6/80)+171/268`,
  Knight `4*max(1,b*6/5)+199/300` (fire period / initial), Cannon keeps `b0*6`/`b1*6`
  (FUN_100071a0). Cannon cell stamped `0x300` wall, spawner cells `0x100`; neither has a touch
  hurtbox (box top parked at 1000). Per-type hurtboxes: Spinner (5,0x12,0x1b,0x20), Wheelie
  (4,6,0x1a,0x1c), others the Robo box (9,6,0x19,0x1e). Knight gift 4 px/frame, frames f17-31. (test 52)
- **F9. Enemy walking pace — ✅ FIXED.** The asm AI runs every frame but only STEPS when the
  per-enemy `+0x6c` counter expires: most nasties step every 2 frames x 2 px (1 px/frame, falls
  4 px/step), the Walker every 3 frames x 1 px, the bord-3 Wheelie 1 px / 2 frames; turrets and
  the Creeper every frame. The port stepped every frame (2x too fast; Walker ~6x). Now `period`/
  `stepc` on `SoiEnemy`; lifespans (+0x74), claim-kill and AI are per step; firing and contact per
  frame. Walker fire gate is in steps (`b0*18` frames initial, `b0*12` reload) and it also fires
  at a breakable block in the 4 cells ahead (FUN_1000e5c8/e7c8), aimed along its pre-turn heading.
  Reference video check: Robo ~52 px/s at ~52 fps = 1 px/frame; in-game recording
  `media/video/enemy_pace_retro_*.mp4` shows the board-1 Robo cover 60 px in 60 ticks. (test 53)
- **F10. Turn-arounds, block responses, Beanie, hurtboxes — ✅ FIXED.** From the per-type AIs:
  - Ant/Ostrich/Hippo/Piggy/Teeth/Walker/Beanie stand for **16 steps** playing a turn animation
    (+0x4c states 5/6) when they turn; the Robo for 15. Only the Smiley flips instantly. The
    Walker's left-to-right turn ends with x -= 3; it runs no line-of-fire test while turning.
  - Hippo/Piggy CHOMP a breakable block and TURN (they never plowed through); the Teeth chomps
    and walks on; Ostrich/Teeth turn to face the nearest player on landing (FUN_100054a4).
  - Beanie (FUN_10006378): at a breakable block it stops and shoots a bud (child 0x6b,
    FUN_10006d44) that grows 16 steps, smashes the block, retracts; at a permanent one it turns.
    It never spawns Beanies (the old "bud a walking child" was invented). Bord 8 is a VERTICAL
    Beanie (FUN_10006840): floats up/down 2 px/step, buds downward/upward (0x6c, FUN_10006f6c).
  - Per-type wall probes (x+0x24/x, Robo x+0x1c/x+4, Walker x+0x22/x+2, Smiley x+0x20/x) and
    per-type hurtboxes offset by each nasty's rest height (it falls 4 px/step until its support
    probe reaches the floor: Ant/Hippo +16, Piggy +8, Walker +6, others +4); Gargoyle/Knight
    boxes follow their -0x18,-0x2b / -0x10,-0x30 sprite shift; a Beanie's bud is a second box.
  - Robo punch smashes on the 7th of 16 steps at col(x+0x20)/col(x); art f18-33 / f02-17.
  - Renderer: exact asm walk tables (frame = TABLE[x & 31] + 1, PEF data DBASE 0x100337f0),
    turn frames and bud art. `tools/sssf_decode.py` dropped the LAST TWO frames of every sheet
    (the header count excludes the two blank leading slots) — recovered into extracted/sprites.
  - Proof: tests 8e, 23, 23c, 54; `media/video/verify_beanie_bud_*` (crafted
    `tools/verify_scripts/board_9420.bord`), `beanie411_*`, `vbeanie408_*`, `robo_turn401_*`.
- **F11. Weapon hits, launch point, support feet, spin frames — ✅ FIXED.**
  - Weapons hit the first entity whose asm hurtbox overlaps their rect (FUN_100030ac/30d4), not
    the centre cell: wall-follower (x+1,y+1)-(x+0x17,y+0x17), tested before its step; the port's
    "Magic Ball" (the game's straight arrow, see F12) (x,y+1)-(x+0xf,y+5) — so a low Ant/Hippo
    ducks under it. Spawners and the Cannon have
    no box and can no longer be shot (the old cell test killed spawners). A hazard or a Beanie's
    bud absorbs a Magic Ball without dying.
  - Magic Ball mover exactly FUN_1000fd5c type 1: roll 4 px while (x+0x18|x, y+3) is clear, else
    erased in place. Both weapons launch at row-top+8 (FUN_100110b4/10d30 +0x50; the ball used to
    roll at the player's y) and snap back to a cell edge when the launch spot is inside a block.
  - Per-type support feet (each AI's FUN_10005750 x offsets: Ant/Piggy 4/0x20, Hippo/Teeth
    6/0x1e, Ostrich 8/0x1e, Smiley 2/0x1e, Walker 8/0x20, Spinner 8/0x18, Robo 6/0x1a).
  - Wheelie/Spinner spin frames follow the asm +0x56 counter (Wheelie ±step 1..24 by mode,
    Spinner 1..16 per step); Smiley roll frame tied to x (−1 per 2 px, 48 frames).
  - Proof: tests 15/15a, 55, 8g; `tools/verify_scripts/weapons.txt` ->
    `media/screenshots/verify_weapons_*`, `media/video/verify_weapons_*`.
- **F12. Hammer, spawner art, turret frames, weapon art — ✅ FIXED.**
  - Hammer (FUN_10007998): wall probes x+0x1a / x+4, feet x+4 / x+0x1a, 16-step turn at a
    permanent wall; the left jump-smash shifts x by -12 for the swing and back (+12) after it.
    Art: walk tables 0x10034370/0330, turn 0x11-0x20, smash 0x31-40 / 0x41-50 drawn at the
    lifted asm position (tests 8i, 54; `tools/verify_scripts/board_9430.bord`,
    `media/video/verify_hammer_smash_*`).
  - Spawners draw their sheet's emblem block (FUN_10004108 frame 0x21/0x31/0x32/0x51: a red block
    with a silver nasty) — these were among the frames the extractor had dropped. Matches
    refs/images/board_3.png (`media/screenshots/verify_spawner_board3_ref_vs_port.png`).
  - Gargoyle/Knight frames follow their asm phase machine (unfold 1-0x11 per 6 frames; Gargoyle
    flap 0x11-0x20 and wind-up 0x20-0x49, Knight hold 0x10 and wind-up 0x10-0x41, per 4 frames),
    derived in the core from the throw countdown (`soi_enemy_anim`).
  - Weapon art: the straight shot (asm type 1, ammo goody 0x12 = a red arrow) is the ARROW
    (weapons f11 right / f10 left); the terrain-follower (types 2/3, goody 0x11 = bottled swirl)
    is the swirl BALL, spinning 1 frame per tick, backward when fired left. The port's
    arrow/ball *names* are swapped vs the art, but keys, ammo and sounds follow the asm latches.
    Action priority now matches FUN_1001166c (latch +0x24 before +0x23).
  - Stop/Go group 4 uses its full 8-frame flip run (Go = f41).
- **F13. Cannon ball / Walker bolt — ✅ FIXED.** Spawn points per FUN_100071a0 (x+0x1c | x-0xc,
  y+8) and FUN_1000dd4c (x+0x1e, y+8 | x-8, y+4 off the Walker's +6 asm y). Movers FUN_1000744c /
  FUN_1000e3c0: 4 px/frame (the cannon ball waits 2 frames first), die on the first solid cell at
  (x+0x10 | x-1, y+8) and smash it if breakable. They hit a player by box (ball x+2..0xe, bolt
  x+4..0x10, y+2..0xe) via FUN_100299b4 and KEEP FLYING — the old port used a same-cell test and
  removed the shot (also the Gargoyle puff now keeps flying). Cannon art: asm frame 1 (f02) when
  firing right, 2 (f03) left (was reversed); ball f04-23 and bolt f50-65 spin one frame per tick.
  (test 56; `media/screenshots/verify_cannon_board043.png`)
- **F14. Wheelie offset, HD frames — ✅ FIXED.** The Wheelie spawns 2 px low like the asm (FUN_10009e98
  init +0x5a += 2), so its wall-follow probes and box (4,4)-(0x1a,0x1a) use the real asm y; drawn at
  that position. The 60 frames the old extractor dropped were upscaled (hqx, `tools/upscale_sprites.py`
  into a scratch dir) and only the missing ones copied into `extracted/sprites_hd`, so `--hd` shows the
  spawner emblems, arrow art, turret wind-ups etc. too.
- **F15. Weapon keys, spawner child heights — ✅ FIXED.**
  - The Arrow key fired the rolling ball and the Ball key the straight shot. FUN_1002d440 reads the
    key table slot 5 into latch +0x24 and slot 6 into +0x23, the key dialog labels those slots
    "Arrow" / "Ball", and FUN_1001166c fires +0x24 -> FUN_100110b4 (straight, arrow art, red-arrow
    ammo goody 0x12, 68k name ShootArrow/DecArrows) and +0x23 -> FUN_10010d30 (rolling swirl ball,
    ShootBall/DecBalls) — matching the manual ("Arrow travels straight, Ball rolls along walls").
    SOI_IN_ARROW now fires the straight shot (checked first, as the asm tests +0x24 first) and
    SOI_IN_BALL the roller. The core's `arrows`/`balls` field names stay swapped (documented).
  - Spawner/egg children appear at their standing height (Ant +16, Hippo +14, Piggy +5, Teeth +4,
    others +2 — FUN_100076a8 &c, FUN_1000b7dc) and a right-heading Piggy 4 px left; hurtboxes use
    those heights. Spawner "seek" and hatch facing compare pixel x (FUN_100054a4).
- **F16. Creeper = the real grow/shrink chain — ✅ FIXED.** (FUN_10008618 horizontal / FUN_10008b18
  vertical.) Each segment turns its cell into a wall (tile | 0x300, the covered low word kept like
  +0x70) and steps every 3rd frame (+0x6c = 2). It grows in (+0x56 0xf -> 1) while +0x6e =
  StartDelay*3 runs down, then spawns the next segment one cell ahead. The target cell must be
  non-solid, free of any sprite (FUN_10004650 screen-vs-background test, done here as a rect test
  against players, nasties and shots) and an enterable tile (FUN_10009030: 0, 0x197, or a non-0x200
  tile with low byte in 0x9d..0xd3). The parent then shrinks back to 0xf and dies, restoring the
  tile (FUN_10005630). When blocked it reverses and retries next step.
  - The enemy pool went from 32 to 64 (the original holds 59; board 496 has 12 Creepers).
  - Renderer: `bigger_mblock` f02-f16 from +0x56.
  - Tests 16/16b cover the timeline, reversal and restore.
  - `tools/verify_creepers.c` (gate stage 4) runs all 15 Creeper boards for 20k ticks, idle and with
    random input. Every tick it asserts that every wall not present at load is a live segment, that
    no two segments share a cell, and that the chain never dies out. A mutation with the restore
    removed fails 12/15 boards.
  - The other 3 boards (447, 474, 1029) have a Creeper as a pedestal under a Knight: blocked above
    by the turret, below by a wall/block. This is faithful.
  - In-game: `media/video/creeper_chain_496_retro_*.mp4`.
- **In-game proof**: scripted runs `tools/verify_scripts/*.txt` (`--script=FILE`, via
  `tools/record_video.ps1 -Script ... -Board ...`) -> `media/video/verify_*_retro_*.mp4` +
  `media/screenshots/verify_*.png`: solo lives 02->01->00->game over; co-op P2 coin/arrow hit the pool,
  runout costs 2 pool lives; Alternate hand-off; Compete two-row HUD on board 1001; challenge fail on
  board 470 ("Nothing!", stats restored, Board#071 next); challenge success on the crafted
  `tools/verify_scripts/board_9410.bord` (warp -> rewards, score 500 + 2932 x 3 = 9296, no reward).

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
