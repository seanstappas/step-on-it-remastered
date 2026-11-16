# Step On It! Remastered — Implementation Progress & Status

> **Tracking Document**: Updated after every milestone, bug fix, and phase.  
> **Reference Plan**: `plan/10_09_improvements.md`  
> **Last Updated**: 2026-11-15

---

## Overall Roadmap Status

| Phase | Description | Status | Verification Gate |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Golden Hashes, Tools & Skeletons | **COMPLETE (100%)** | `ascii2bord.py` round-trip PASS, `verify.ps1` PASS |
| **Phase 1** | Rollback C Core, 3P Expansion, Xbox Input | **COMPLETE (100%)** | `verify.ps1` PASS, C SyncTest (8-tick rollback) PASS |
| **Phase 2** | Versus Mode, Friendly Fire & Combat Bugs | **COMPLETE (100%)** | `test_mechanics.c` section 65 PASS, `verify.ps1` PASS |
| **Phase 3** | Big Maps (`38×26`), `EXT1` Loader, Map Editor | **COMPLETE (100%)** | Load/playtest 38×26 duel arena in Godot, Section 66 PASS, verify.ps1 PASS |
| **Phase 4** | ENet Star-Hub Netcode & Loopback Soak Test | **COMPLETE (100%)** | 1,200-tick loopback soak test & `test_net_progression.ps1` PASS |
| **10/14 Remediation** | Complete Gap & Bug Closure (`plan/10_14_improvements.md`) | **COMPLETE (100%)** | Stages 0–4 Verified: 152/152 Synctest, 10,000-Tick Soak, Editor, Roundtrip PASS |
| **10/15 Remediation** | Post-4555ec4 Audit & Complete Remediation (`plan/10_15.md`) | **COMPLETE (100%)** | Stages 1–4 Verified: C Core Section 68 PASS, verify.ps1 PASS, 3P Edge & Soak PASS |
| **10/16 Remediation** | Complete Closure of 10/16 Gaps & Regressions (`plan/10_16.md`) | **COMPLETE (100%)** | Stages 1–4 Verified: C Core Section 69 PASS, verify.ps1 PASS, 10k Soak & Adversarial PASS |

---

## Detailed Milestone Checklist

### Phase 0: Baseline Tools & Skeletons (COMPLETE)
- [x] **CLI Map Compiler & Decompiler**: `tools/ascii2bord.py` created & verified against `board_401.bord`.
- [x] **Player 3 Crimson Tint Shader**: `godot_project/shaders/p3_tint.gdshader` created.
- [x] **Visual Map Editor Skeleton**: `godot_project/scenes/editor.tscn` and `editor.gd` created with CLI test hook.
- [x] **Rollback Netcode Skeleton**: `godot_project/scenes/rollback_net.gd` created with local synthetic lag simulator.
- [x] **Baseline Pipeline Verification**: `tools/verify.ps1 -SkipGodot` passes with all stages green.

### Phase 1: Rollback-Ready C Core, 3P Expansion & Xbox Controllers (COMPLETE)
- [x] **soi_snapshot_save / soi_snapshot_load**: Raw `memcpy` of `SoiWorld` (~0.07 µs) in `core/src/soi_state.c` and exposed on `SoiBridge`.
- [x] **soi_net_hash**: 64-bit FNV-1a hash over all deterministic simulation fields (switches, bonus_div, input buffers).
- [x] **Bug B10 Fix**: Zero-pad `w->bord_data` tail in `soi_load_level`.
- [x] **Bug B11 Fix**: Save/restore `input_assist`, `friendly_fire`, `victory_rule` across level reload and death; decouple `F2` from `set_input_assist`.
- [x] **Bug B12 Fix**: Move `tp_freeze` into `SoiWorld`; drive switch visuals from C `w->sw_*`.
- [x] **Bug B4 & 3P Tiles**: Implement discrete P3 tiles `0x0933` (Red Key), `0x0934` (Red Lock), `0x0935` (Opened Red Door) in `core/src/soi_grid.c` and `game.gd`.
- [x] **3-Column HUD**: Split top 48px HUD into 3 panels when `num_players == 3`.
- [x] **Xbox Controller Support**: Polling with `0.50` / `0.35` hysteresis deadzones in `game.gd` and device routing in `session.gd`.
- [x] **Phase 1 Verification Gate**: `tools/verify.ps1` passes + C SyncTest (8-tick forced rollback) passes with 0 mismatches across all 152 boards.

### Phase 2: Versus Mode, Friendly Fire & Combat Bug Fixes (COMPLETE)
- [x] **Mode & Rules**: `SOI_MODE_VERSUS` enum, decoupled `w->friendly_fire`, and 3 victory rules (Lives, Score, Door).
- [x] **Bug B1 Fix**: Individual in-place respawns in Compete/Co-op without board reload after 90 ticks when other players are alive.
- [x] **Bug B2 Fix**: Reset `bonus_time` (fallback 5000), zero movement/physics buffers, and grant 90-tick invulnerability on in-place respawn.
- [x] **Bug B3 Fix**: Guard PvP projectile hits with `ground_state != SOI_ST_DEAD`; despawn rolling balls on hit; corpse immunity verified.
- [x] **Bug B6 Fix**: Widen `soi_set_play_mode` to `SOI_MODE_VERSUS`; isolate keys in Compete/Versus; disable `w->challenge` death bypass in Versus.
- [x] **Bug B8 Fix**: Split firing lock by weapon kind; cap rolling ball life to 180 ticks; reserve player projectile slots.
- [x] **Bug B9 Fix**: Prevent `block_toggle` over living players (`soi_player_at`); shatter trap blocks at respawn points in Versus.
- [x] **Combat Features**: Speed-Shoe lethal body check; 120-tick `last_attacker` block-drop frag attribution; dry-board ammo regen.
- [x] **Bridge Bindings**: Exposed `set_friendly_fire`, `friendly_fire`, `set_victory_rule`, `victory_rule`, `player_kills`, `versus_winner` on `SoiBridge`/`SoiCore`.
- [x] **Phase 2 Verification Gate**: C unit tests in Section 65 of `tests/test_mechanics.c` pass covering all rules, PvP collisions, and bug fixes.

### Phase 3: Big Maps (`38×26`), `EXT1` Loader & Map Editor (COMPLETE)
- [x] **Grid Constants**: Raised `SOI_MAX_GRID_COLS = 38`, `SOI_MAX_GRID_ROWS = 26`, `SOI_BORD_MAX = 8192`.
- [x] **Bug B5 Fix**: Pre-scan `EXT1` trailer in `soi_load_level` before tile records loop with CRC-16-CCITT validation and P3 auto-spawn.
- [x] **Dynamic Death Y**: Implemented `soi_pit_death_y(w) = (rows - 1) * 32 + 62` in `soi_physics.c` (446px on 13 rows, 862px on 26 rows).
- [x] **Zoom-to-Fit Viewport**: Scale playfield in `game.gd` below fixed 48px HUD with dynamic `cols`/`rows`, projectile/particle/debris culling, and memory playtest hooks.
- [x] **In-Game Editor**: Completed `editor.gd` & `editor.tscn` supporting canvas switching (19x13, 28x19, 38x26), strict big-endian serialization/deserialization, palette brushes, save/load to `user://custom_maps/`, and main menu buttons.
- [x] **Phase 3 Verification Gate**: C unit tests in Section 66 of `tests/test_mechanics.c` PASS; `editor.gd` round-trip CLI self-test PASS; live Godot screenshot rendering verified; `verify.ps1 -SkipGodot` PASS.

### Phase 4: ENet Star-Hub Netcode & Loopback Soak Test (COMPLETE)
- [x] **Integration**: Connect `rollback_net.gd` with `game.gd` tick loop (D = 2, repeat prediction, 64-frame C snapshot ring buffer `_core.snapshot_save()` / `load()`, resimulation loop).
- [x] **Audio Gate**: Zero-lag audio gate suppressing `Audio.play()` and particles during resimulation (`is_resimulating`).
- [x] **Latency Handling**: Clock-Rift Equalization, Rift Stall pause (W = 16 ticks) with visual banner, and ack-anchored inputs.
- [x] **Lobby UI**: "Online Multiplayer" button on title screen, Host dialog (Join Code `SOI-XXXX-XXXX`, direct IP:7777, background UPnP thread), Join dialog, reliable Channel 0 `MATCH_INIT` handshake syncing board ID, seed, speed, and player slot assignments.
- [x] **Star-Hub Transport**: Star-Hub packet forwarding via Player 1 (`P2 <-> P1 <-> P3`) allowing peer-to-peer relay through host.
- [x] **Phase 4 Verification Gate**: Automated loopback soak test `tools/test_net_soak.ps1` (1,200 ticks, 120ms lag, 30ms jitter, 0 desyncs), side-by-side desktop dual-window launcher `tools/launch_net_duo.ps1`, integrated into `tools/verify.ps1`.

---

## Log of Completed Work
- **2026-10-10**: Phase 0 baseline completed. `tools/ascii2bord.py`, `editor.gd`, `rollback_net.gd`, and `p3_tint.gdshader` created.
- **2026-10-11**: Phase 1 completed & verified. C snapshots (`soi_snapshot_save`/`load`), 64-bit state hashing (`soi_net_hash`), bugs B10/B11/B12, discrete P3 tiles B4 (`0x0933..0x0935`), GDExtension bridge bindings, Xbox controller support with hysteresis deadzones, and automated 8-tick C SyncTest passed across all 152 boards.
- **2026-10-11**: Phase 1 QA & adversarial review completed. Fixed switch block Go sign rendering in passable state, enabled Co-op P1/P2 exit through opened P3 door 0x0935, fixed P2 green key HUD icon frame, guarded joypad stick array bounds, added NULL checks to snapshot and hash APIs, fixed 3-column HUD Board# glyph collision and panel border overflow, visually verified 3P HUD rendering in running Godot 4.3 engine with live screenshot capture, and added comprehensive C unit test section 63 in `test_mechanics.c`.
- **2026-10-11**: Phase 1 adversarial review round 3 completed. Diagnosed and fixed 3-player Co-op HUD shared pool display bug where P2 and P3 panels permanently rendered 00 lives and 00 ammo despite active team pool inventory; aligned Co-op HUD panels to read team pool `src_p = p if _mode_compete else 1`; verified visual layout across both Co-op and Compete 3P game modes via live headless and windowed Godot screenshot captures.
- **2026-10-12**: Phase 4 Online Multiplayer & Rollback Netcode + Bugs B1 & B2 completed & verified. Implemented in-place respawns with 90-tick timer, bonus reset, and 90-tick invulnerability in `core/src/soi_state.c` (B1 & B2) with section 64 C unit tests in `tests/test_mechanics.c`. Integrated `RollbackNet` into `game.gd` with 2-tick input delay, repeat prediction, 64-frame snapshot ring buffer, misprediction rollback and resimulation, zero-lag audio gate, Rift Stall pause with visual banner, online title lobby in `main_menu.gd` with Join Codes (`SOI-XXXX-XXXX`) and direct IP, UPnP background discovery, reliable Channel 0 `MATCH_INIT` handshake, and Star-Hub packet forwarding. Created and verified automated loopback soak test `tools/test_net_soak.ps1` (1,200 ticks, 120ms lag, 30ms jitter, 0 desyncs across 700+ rollbacks) and dual-window visual desktop launcher `tools/launch_net_duo.ps1`.
- **2026-10-12**: Phase 4 adversarial review & QA completed. Stress-tested 3-player Star-Hub packet forwarding and severe packet loss (>10%) under asymmetric network conditions with automated test suite `tools/test_net_adversarial.ps1` (1,500 ticks, 0 desyncs across 2,000+ rollbacks). Fixed peer slot lookup in `send_match_init` to reference `peer_instances` mapping instead of assuming array order. Added immediate `enet.flush()` and `STATE_CONNECTED` guards to packet dispatch and host Star-Hub relay to prevent 1-frame (14 ms) delivery latency. Implemented online local input routing in `game.gd` so online clients (P2/P3) can seamlessly use Arrow keys, WASD, and gamepads. Added ring buffer history clamp during deep lag spikes to prevent loading overwritten snapshots.
- **2026-10-12**: Phase 4 review round 2: added `tools/test_net_edge_cases.ps1` (Join Code parsing, 3P mid-match P3 drop with Star-Hub-forwarded `PKT_DROP_PEER`, 2P/host disconnect unblocking). Fixed dropped-peer input divergence. (Teamwork run halted afterwards on API quota before review round 3 / victory audit.)
- **2026-10-14**: Online campaign progression completed & verified. Implemented reliable Channel 0 `PKT_BOARD_LOAD` (`0x02`), host-driven level progression (`Session.advance()`) and retry sync, non-blocking network polling in `_physics_process`, online Leave confirmation overlay (`ESC` -> `Y`/`N`), speed sync in `session.gd`, and automated headless dual-instance progression test `tools/test_net_progression.ps1`.
- **2026-10-14**: Phase 2 Versus / PvP Mode & Combat Mechanics completed & verified. Implemented `SOI_MODE_VERSUS`, 3 victory rules (`SOI_WIN_LIVES`, `SOI_WIN_SCORE`, `SOI_WIN_DOOR`), decoupled friendly fire, projectile PvP hits, corpse immunity (Bug B3), per-kind firing lock and 180-tick rolling ball lifetime cap (Bug B8), hostile projectile slot reservation, dry-board ammo regen, anti-burial block check (`soi_player_at`, Bug B9), 120-tick indirect block-drop frag attribution, Speed-Shoe lethal body check, safe farthest-point in-place respawn, GDExtension bridge bindings, and Section 65 unit test suite in `tests/test_mechanics.c`. All `verify.ps1` stages pass green.
- **2026-10-14**: Phase 3 Big Maps ($38\times26$), EXT1 Trailer Pre-scan (Bug B5), and In-Game Map Editor completed & verified. Raised max dimensions to $38\times26$ and BORD cap to 8192. Added pre-scan EXT1 trailer loader with CRC-16-CCITT and P3 auto-spawn. Added dynamic pit death line `soi_pit_death_y(w)`. Built zoom-to-fit playfield scaling in `game.gd` under the fixed 48px HUD. Completed visual Map Editor (`editor.gd`/`editor.tscn`) supporting 3 canvas sizes, strict big-endian `.bord`+`EXT1` serialization/deserialization, save/load to `user://custom_maps/`, and memory playtesting via Tab/Esc. Verified with C unit tests in Section 66 of `test_mechanics.c`, `editor.gd` CLI roundtrip test, `tools/verify.ps1`, and live Godot screenshot rendering of a $38\times26$ duel arena.
- **2026-10-14**: Netcode adversarial review round 3 & Versus victory audit completed. Connected Versus Mode (`SOI_MODE_VERSUS` = 5) to main menu and online lobby dialogs. Wired victory rules (Elimination, Score, Door Race) and friendly fire flags across ENet Channel 0 `MATCH_INIT` handshake and `Session` singleton. Integrated versus winner resolution into `game.gd` `_winner()` and `_draw_win_screen()` with rematching on custom boards. Enhanced Xbox controller navigation with `JOY_BUTTON_START` (pause), `JOY_BUTTON_A` (result screen advance / leave confirm), `JOY_BUTTON_B` (cancel leave), and `JOY_BUTTON_BACK` (Select / Esc). All 13 stages of `verify.ps1` pass 100% green.
- **2026-10-15**: Complete Gap & Bug Closure Remediation (`plan/10_14_improvements.md` Stages 0–4) completed & verified:
  - **Stage 0 (Repository & Git Sync)**: Synchronized local branches `lite` and `main` with `origin/main` (`ca05b1b`).
  - **Stage 1 (C Core State & Snapshot/Hash)**: Fixed EXT1 attribute clobbering, implemented Manhattan outward spiral fallback in `soi_spawn_player3` with 2-tile clearance and solid floor checks, added `soi_drop_player`, `soi_set_p3_any_key`, `soi_p3_any_key`, `p3_any_key`, and `ext_starting_lives` to `SoiWorld`, extended `soi_net_hash` with all EXT1 fields and spawn points, and upgraded `test_synctest.c` to 1,000 divergent rollback ticks across all 152 boards (152/152 pass, 0 desyncs).
  - **Stage 2 (C Core PvP Combat, Grid & Persistence)**: Fixed projectile double-kill attribution (`attacker_ttl = 0` on direct impact), fixed Bug B6 key leak in Versus mode, guarded Bug B12 teleporter freeze in competitive modes, minimized active enemy + P3 spawn distance for in-place respawns, added dual Speed-Shoe pushback separation with block break SFX, and preserved `kills` and `p3_any_key` across `soi_next_level` and `reload_board_on_death` (67/67 Section 67 tests passing).
  - **Stage 3 (Rollback Netcode, Wire Protocol, Latency Escalation & Relay)**: Unfroze rollback processing on game over, removed snapshot clamp, pruned render history (`_debris` and `_death_pops`) by tick, implemented big-endian wire protocol helpers, 10-char Crockford Base32 join code parser/generator with Crockford aliases, dual-packet D16 retransmission on rift stall, bundled headless relay (`--relay`), and upgraded 10,000-tick 3-peer soak test (`tools/test_net_soak.ps1` with 808 rift stalls healed and 0 desyncs).
  - **Stage 4 (Frontend UI, Map Editor, Xbox Inputs & Shaders)**: Applied luminance-preserving Crimson Red tint formula for P3 sprite/shadows and Red door, HUD `"K%d"` versus kills, `ascii2bord.py` `vs_spawns` regex parsing and legacy 2-byte Mac footer tolerance (152/152 roundtrip pass), complete categorized palette and in-memory playtest state persistence in `editor.gd` (`--test-editor` PASS), default 71 Hz speed, disconnect banner overlay, stick hysteresis deadzones, and Xbox / Space slot claiming in online lobby.

- **2026-10-16**: Complete Post-`4555ec4` Audit Remediation (`plan/10_15.md` Stages 1–4) completed & verified:
  - **Stage 1 (C Core Fixes)**: Fixed P0-3 Red Lock `0x0934` walk-over unlock writing non-solid `0x0935u` (without `SOI_CELL_SUPPORTIVE`) and door victory; fixed P0-4 dual Speed-Shoe push typo in `check_pvp_body_collisions` (`p2->x -= push`); fixed P1-1 teleporter freeze in Versus mode; fixed P1-2 `keep[]` preservation and `soi_load_level` return check (`r <= 0`) across `soi_next_level` and `reload_board_on_death`; fixed P1-3 2P Versus match completion in `soi_level_complete` when a player drops.
  - **Stage 2 (Rollback Netcode & game.gd)**: Restored high-score initials entry `_hs_input` (P0-1); decoupled local input assist from simulation core; added deterministic `_core.drop_player` at `peer_drop_tick` across resimulation and live tick loops; moved unfreeze checks after resimulation loop; moved `_net.current_tick += 1` after particle/debris loops; fixed host board load deadlock and client board transitions; enforced strictly monotonic input scheduling (`target_tick = maxi(current_tick + BASE_DELAY, prev_scheduled + 1)`) preventing duplicate tick collisions on adaptive delay changes; synchronized `_handle_drop_peer` and host disconnect input zeroing/confirmation.
  - **Stage 3 (Live3D, Editor & Lobby Fixes)**: Restored missing `vec3 rgb = a > 0.001 ? c.rgb / a : vec3(0.0);` in `live3d.gd` (P0-2); rewrote `editor.gd` sprite loader to scan `res://../extracted/sprites/` via regex; corrected brush tile IDs (Stop/Go `0x0824`/`0x039D`/`0x01A3`, Blue Key/Lock/Door `0x0908`/`0x0905`/`0x0902`, Green Key/Lock/Door `0x0909`/`0x0906`/`0x0903`, enemy sprite folder mappings); added top toolbar controls (Mode, Rule, FF, Lives, Facing toggle `[F]`); cleared custom board in `Session.start_campaign()`; hooked `RollbackNet.join_code_to_port()`; implemented cyclic joypad slot claiming in local and online menus.
  - **Stage 4 (CLI Tooling & Test Hardening)**: Enforced byte-exact roundtrip check and `default_mode` serialization in `tools/ascii2bord.py` (152/152 passed); activated P3 in `test_net_edge_cases.gd` and `test_net_adversarial.gd`; added Section 68 unit tests in `tests/test_mechanics.c` (all 68 sections passing); verified full suite via `tools/verify.ps1 -SkipGodot` (all 6 stages green), 10,000-tick loopback soak test (`net_soak_test.tscn`), 3-player adversarial soak test (`test_net_adversarial.tscn`), and edge cases test (`test_net_edge_cases.tscn`).

- **2026-10-16 / 2026-10-17**: Complete Closure of 10/16 Gaps and Regressions (`plan/10_16.md` Stages 1–4) completed & verified:
  - **Stage 1 (C Core Invariants & Victory Audit)**: Restored `soi_next_level` return contract (1 on success, 0 on failure); zeroed inactive/eliminated player state (`alive = 0`, `ground_state = SOI_ST_IDLE`); prevented Campaign Game Over screen from hijacking Versus matches (`soi_game_over` returns 0 in Versus); added `active_count` tracking in `soi_level_complete` handling drops in `SOI_WIN_SCORE` and `SOI_WIN_DOOR`; added last-survivor fallback in `soi_versus_winner` for Door Race when opponents drop/are eliminated; implemented wall-safe 2px aligned push with `soi_px_col`/`row` and `SOI_SFX_BLOCK_BREAK` in `check_pvp_body_collisions`; gated competitive door exit on `p->has_key == 1 && (own_door || (p3_any && any_door))` in `soi_pickup_check` so keyless players cannot steal door wins when P3 opens doors under `p3_any_key`; added Section 69 C unit tests (69.1..69.4, 100% PASS).
  - **Stage 2 (Netcode & Flow Synchronization)**: Preserved `dropped_peers` across board transitions in `reset_for_new_board()` and zeroed `peer_drop_tick`; removed premature `board_loaded.emit` on Host in `send_board_load()`; triggered unconditional rollbacks and history replay on peer drop (`drop_t < current_tick`); enforced strictly monotonic input scheduling (`target_tick = maxi(current_tick + BASE_DELAY, prev_scheduled + 1)`) and confirmed fill ticks in `send_local_input()` preventing duplicate tick collisions on adaptive RTT delay reductions; removed wiping of `consecutive_rift_frames` on rift recovery; stripped port suffix in `join_code_to_ip()`; removed redundant `spawn_player3()` in `game.gd:_next_board()`; re-dropped disconnected peers on new boards; moved live-tick `peer_drop_tick` drop checks before `snapshot_save()`; synchronized multi-tick window in `_poll_online_meta_confirm()`; preserved `_board_start_stats` across board loads; declared missing `_online_meta_confirmed` member variable; gated `JOY_BUTTON_A` on `_hs_state != "entry"`.
  - **Stage 3 (Live3D, Editor, Lobby & Session)**: Restored missing closing `}` in `live3d.gd:POST_SHADER`; cleared `custom_board_bytes` and `editor_return` meta in `Session.start_campaign()`; assigned first unassigned negative controller slot before cycling in `main_menu.gd:_claim_controller_slot()`; preserved `chosen_map = Session.custom_map_path` in `start_match_btn()`; called `Session.start_campaign()` on client upon `match_started`; corrected Blue/Green key brush frames (9 and 10) in `editor.gd`; assigned authentic BORD placement IDs for all enemy brushes; encoded facing toggle bits 8..15 (`0x0500`/`0x0600`/`0x0700`); guarded `KEY_C`, `KEY_G`, `KEY_F` with `not event.ctrl_pressed`; expanded `--test-editor` self-test assertions.
  - **Stage 4 (Tooling, Tests & Verification)**: Passed `has_p3` in `ascii2bord.py:pack_ext1` and added `sys.exit(1)` on verification failure (152/152 byte-exact PASS); added network polling in `test_net_edge_cases.gd` Board 2 loop; verified all headless suites: `editor.tscn -- --test-editor` (PASS), `test_net_edge_cases.tscn` (PASS), `test_net_adversarial.tscn` (1,500 ticks PASS), `net_soak_test.tscn` (10,000 ticks PASS, 0 desyncs), `test_net_progression.tscn` (PASS); verified end-to-end `tools/verify.ps1` (all 13 stages green).

- **2026-10-18**: Release Packaging & CI Validation (`plan/10_18_ready.md`) completed & verified:
  - Added Velopack distribution packaging pipeline (`tools/publish_velopack.ps1`, `tools/test_velopack_local.ps1`).
  - Added packaged path resolution in `Session.ext_path` and `StepOnIt.exe` launcher routing (`tools/launcher/launcher.c`).
  - Verified 16-stage gate in `tools/verify.ps1` and `.github/workflows/verify.yml`.

- **2026-10-20 / 2026-10-21**: Map Editor Overhaul & Visual Remaster completed & verified:
  - **Authentic Tile Catalog (`scenes/tile_catalog.gd`)**: Grounded in decompiled core and 152 campaign boards. Cataloged all 25 authentic block families ($0\text{x}07 + 6k$), 4 behavior variants (Wall, Breakable, Background, Hidden), 10 Transporters, 15 Stop/Go switches, 12 Doors & Keys (including discrete P3 Crimson Key/Door), 21 authentic Goodies, and 19 Enemies and Spawns.
  - **Tile Art & 3D Remastered Rendering (`scenes/tile_art.gd`)**: Built unified cell resolver and sprite loader integrating 4× HD sprites and procedural 3D frame overlays (`extracted/sprites_3d_frames/`). Caches linear-filtered mipmapped textures and computes non-stretched 1:1 logical footprint.
  - **Mathematical 1:1 Square Grid & Bezel (`scenes/editor.gd`)**: Eliminated rectangular stretching by implementing uniform zoom math $\min(W_{\text{avail}} / (C \cdot 32), H_{\text{avail}} / (R \cdot 32))$ across all 3 grid sizes ($19\times13$, $28\times19$, $38\times26$), framed within a classic 3D metallic bezel.
  - **StarCraft/Warcraft-Style Collapsible Palette**: Built left-hand tree hierarchy with tile count badges (`▼ Blocks 25`, `▼ Transporters 10`, etc.), quick `[X] Eraser`, variant toggle chips (`[Wall | Brk | Bkg | Hid]`), and a 5×5 block family icon grid.
  - **System 7 Classic Mac Menu Bar**: Rendered high-res Apple logo and crisp canvas-rendered dropdown menus (`File · Edit · Map · View` + `[▶ Play [Tab]]`).
  - **Map Properties Modal**: Consolidated top-right clutter into a clean dialog with clear explanations for Game Mode, Victory Rules, Starting Lives, Friendly Fire, and Bonus Timer.
  - **Bug Fix**: Identified `0x0387` as an animation break fragment (frame 136) causing the "ice floor" glitch; resolved by migrating to authentic block families and documenting legacy alias in `tools/ascii2bord.py`.
  - **Verification**: MapEditor CLI self-test (`editor.tscn -- --test-editor`) PASS; all 16 stages of `tools/verify.ps1` PASS; off-screen screenshot visual verification (`--editorshot`) PASS.
  - **Documentation**: Created `AGENTS.md` and updated `README.md` to ensure seamless handover to other agents.

- **2026-10-28**: Teamwork Full-System Audit & Defect Remediation (`/teamwork`) completed & verified:
  - **Single-Player Controller Claiming (`scenes/main_menu.gd`)**: Enabled solo players to claim Player 1 with gamepad Button A; eliminated an invalid `e.echo` property access on `InputEventJoypadButton` caught by adversarial testing.
  - **Map Editor Versus Spawn Clamping (`scenes/editor.gd`)**: Added coordinate clamping for `vs_spawns` on grid downsizing (38x26 -> 28x19 -> 19x13).
  - **EXT1 Trailer Parity Scan (`scenes/editor.gd`)**: Changed trailer search step from `-2` to `-1` to ensure robust `EXT1` header detection regardless of trailing byte alignment.
  - **Hidden Goody Prefixes (`scenes/editor.gd`)**: Enforced `0x0900` tile ID prefix retention on hidden treasure block brushes for valid goody unpacking.
  - **Virtualenv Precedence (`tools/verify.ps1`)**: Prioritized `.venv\Scripts\python.exe` before looking at global `py` or `python`.
  - **Launcher Boolean Flag Forwarding (`tools/launcher/launcher.c`)**: Added non-value flag filtering so boolean engine flags (`--headless`, `--verbose`, etc.) do not consume subsequent scene arguments.
  - **Adversarial & Gate Verification**: Independent Post-Victory Audit confirmed clean results across all suites: `tools/verify.ps1` (16/16 stages PASS), `test_adversarial_m1.tscn` (348/348 PASS), `test_launcher_cli.c` (18/18 PASS), and headless editor self-test (PASS).

- **2026-11-10**: Cold-Start Handoff Audit, Packaged Editor Path Fix & `/learn` Customizations:
  - **Packaged Editor Asset Resolution (`scenes/tile_art.gd`, `scenes/editor.gd`)**: Routed Map Maker sprite folder indexing (`TileArt._ext_dir`) and campaign board import (`_open_original_board_dialog`) through `Session.ext_path(...)` instead of raw `res://../extracted/...` so packaged Velopack builds load all sprites and campaign levels cleanly; restored `OS.has_feature("editor")` screenshot fallback in `_take_editorshot()` and added self-test #9.
  - **Handoff Documentation & Customizations**: Expanded `AGENTS.md` across all 5 architectural layers (fixing the standalone Zig runbook path/glob and documenting `Session.ext_path()`, Velopack packaging, `0x0900` hidden prefixes, and `EXT1` parity), synced `README.md` and `docs/remaster/README.md` with actual git tracking state, added `.agents/skills/soi3d-sprite-review/SKILL.md`, and persisted Godot/PowerShell guardrails in global `GEMINI.md`.

- **2026-11-15**: C Core Warning/Bounds Hardening, Bridge PDB Fix & 19-Stage Gate Expansion:
  - **C Core Hardening (`core/src/*`)**: Eliminated all `-std=c17 -Wall -Wextra -Wshadow -Wconversion -Werror` warnings across `core/src/*.c`, unified `grid_cols`/`grid_rows`/`sw_count` clamping helpers in `soi_internal.h` (including `soi_blockanims_update`, `soi_switch_*`, `soi_spawn_player3`, Speed-Shoes pushback, and Knight gift flight), clamped `BORD` spawns and transient `sfx`/`death`/`fx` queues, added `NULL` world guards across entrypoints, and upgraded `soi_parse_ext1` to scan backward step `-1` with strict CRC verification while preserving `sizeof(SoiWorld) == 17060` and replay determinism. Added **Section 70** unit tests in `tests/test_mechanics.c`.
  - **GDExtension Bridge & PDB Export Fix (`bridge/build_zig.ps1`, `bridge/src/soi_bridge.cpp`)**: Switched `bridge/build_zig.ps1` to `-O2` with strict `-Werror` on `core/` and `bridge/src/`, staged intermediate build artifacts in `$env:TEMP`, and deployed `soi_bridge.pdb` plus both `template_debug` and `template_release` `.pdb` files alongside `.dll`s in `godot_project/bin/` to resolve all missing-PDB export errors. Hardened `SoiCore` bindings with exact `snapshot_load` byte-size equality, buffer null/min-length checks, and `int64_t` range validation before `int` narrowing.
  - **Verification Gate (`tools/verify.ps1`, `AGENTS.md`)**: Expanded `tools/verify.ps1` from 16 to 19 stages (adding `verify_winnable.c`, `test_launcher_cli.c`, `smoke_test.tscn` in Stage 12, and `test_adversarial_m1.tscn` with `--quit-after` hang guards), enforced `-Werror` on Stages 3 & 5, staged all temporary test binaries/DLLs in `$env:TEMP` with `finally` cleanup, and updated `AGENTS.md` to match.

---

## Remaining Roadmap Items
- [ ] **Manual playtest**: Two real windows via `tools/launch_net_duo.ps1` (host + join `127.0.0.1:7777`) and physical Xbox controller verification.
- [x] Final adversarial review round 3 + victory audit of the netcode work.



