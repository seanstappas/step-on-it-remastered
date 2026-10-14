# Step On It! Remastered — Implementation Progress & Status

> **Tracking Document**: Updated after every milestone, bug fix, and phase.  
> **Reference Plan**: `plan/10_09_improvements.md`  
> **Last Updated**: 2026-10-13

---

## Overall Roadmap Status

| Phase | Description | Status | Verification Gate |
| :--- | :--- | :--- | :--- |
| **Phase 0** | Golden Hashes, Tools & Skeletons | **COMPLETE (100%)** | `ascii2bord.py` round-trip PASS, `verify.ps1` PASS |
| **Phase 1** | Rollback C Core, 3P Expansion, Xbox Input | **COMPLETE (100%)** | `verify.ps1` PASS, C SyncTest (8-tick rollback) PASS |
| **Phase 2** | Versus Mode, Friendly Fire & Combat Bugs | **COMPLETE (100%)** | `test_mechanics.c` section 65 PASS, `verify.ps1` PASS |
| **Phase 3** | Big Maps (`38×26`), `EXT1` Loader, Map Editor | **COMPLETE (100%)** | Load/playtest 38×26 duel arena in Godot, Section 66 PASS, verify.ps1 PASS |
| **Phase 4** | ENet Star-Hub Netcode & Loopback Soak Test | **COMPLETE (100%)** | 1,200-tick loopback soak test & `test_net_progression.ps1` PASS |

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

---

## Remaining Roadmap Items
- [ ] **Manual playtest**: Two real windows via `tools/launch_net_duo.ps1` (host + join `127.0.0.1:7777`) and physical Xbox controller verification.
- [x] Final adversarial review round 3 + victory audit of the netcode work.



