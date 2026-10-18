# Step On It! Remastered: audit of the `plan/10_17_ready.md` implementation, and the next plan

> [!NOTE]
> **Scope.** Repo copy at `~/tmp/repos/steps`, commit `602b31a` ("fixes"). The clone is a single grafted commit, so there is no diff. Every item was compared directly against the plan.
> **Method.** Read-only static review: nothing was built or run. Five area auditors and two verifiers took part, plus two snippet auditors for the proposed code. The coordinator then re-read the code behind every P0/P1 claim.
> **Line numbers** are hints for `602b31a`. Find code by function name.
> **Copying.** To hand this to an implementing agent, copy it to `plan/10_18_ready.md`. Paths are repo-relative. The Windows root is `D:\Code\step-on-it-remastered`.

---

## 1. Verdict

- **Landed cleanly:** CORE-NEW-1/3/4/9, `soi_set_seed` + binding, NET-05 (board epoch), NET-08 (0x7F input mask), PKT_DROP_PEER 64-tick window, start_host peer cap, UI-2/3/5/10, ED-01/04, `Session.ext_path`, launcher scaffold, publish/test scripts, `build/` + `releases/` ignored.
- **One P0 remains (NET-07):** a peer can drop before any of its inputs arrive. The host then drops it at tick 0 but every client drops it at tick 1, which is a permanent desync.
- **Online play still has P1 bugs:**
  - `game.gd` calls `_net.reset()` at match start, wiping `match_active` and the drop list.
  - Detected desyncs are only printed.
  - The end-of-board confirm sends a reliable packet every frame.
  - The Challenge Round intro never counts down.
  - The end of an online campaign loops or strands clients.
- **Stage D is mostly not done:** TOOL-01..04, HYG-01/02 and the docs are untouched. There is no CI workflow.
- **The "ready" trim dropped 10_17.md items:** NET-12, NET-13, ED-02, ED-03, DOCS-01..03, the offline custom-map entry, BUILD_ID (§6.3) and the LAN/Tailscale join code (§6.5).
- **A green gate does not prove the plan landed.** Test 69.5 and the editor self-test cannot fail on the bugs they target. No net test covers NET-03, NET-07 at tick 0, NET-10 or NET-11.

## 2. Scorecard

| Stage | Done | Partial | Wrong | Missing |
|---|---|---|---|---|
| A: C core + tests | 5 | 4 | 1 | 0 |
| B: Netcode (incl. NET-12/13 from 10_17.md) | 3 | 6 | 2 | 1 |
| C: Editor, session, lobby (incl. ED-02/03) | 6 | 5 | 1 | 2 |
| D: Tooling, hygiene, docs, gate | 0 | 2 | 0 | 9 |
| E: Distribution (incl. §6.3/§6.5) | 1 | 8 | 1 | 2 |

<details>
<summary>Per-item status</summary>

| ID | Status | Note |
|---|---|---|
| CORE-NEW-1 | Done | `check_pvp_body_collisions` probes through `soi_get_cell`, which returns WALL out of bounds. |
| CORE-NEW-4 | Done | 10-step loop separates to dx >= 20 even when pinned. |
| CORE-NEW-3 | Done | `own_door`/`any_door` match `FUN_1002bc64` for P1/P2. P3 can no longer exit a locked 0x0904. |
| CORE-NEW-2 | Partial | Versus SCORE rule still ends only on `alive_count == 0 \|\| active_count <= 1`. If all players are eliminated, the winner is a draw. |
| CORE-NEW-6 | Partial | P3 spawn runs after tile decode but before switch scan and creeper init. Test 69.5 cannot fail. |
| CORE-NEW-8 | Partial | Works when the mode is set before the load. Ignored if `soi_set_play_mode(VERSUS)` runs after the load. P1/P2 and P3 use different bounds rules. |
| CORE-NEW-7 | Wrong | The plan's rule conflicts with the original co-op pool. The pool goes to -1/-2, so a 1-UP is eaten or a revival is free. |
| CORE-NEW-9 | Done | Serialize/state_hash now cover the net_hash fields. Stale "NOT serialized" comments remain. |
| NET-02 (C + bridge) | Done | `soi_set_seed` is bound as `SoiCore.set_seed`. |
| CORE-NEW-5 / D1 | Partial | 69.2/69.3/69.4/69.6 are real tests. 69.5 is vacuous. No tests for CORE-NEW-7/9. Synctest checks only `soi_net_hash`. |
| NET-01 | Partial | Meta-confirm floods. A tick/hash mismatch still advances. Input-delay ratchet. No catch-up packet while frozen. |
| NET-02 (GDScript) | Done | `set_seed` runs before `next_level`. Only a bare-core test exists. |
| NET-03 | Partial | Resim stops at end of board. The tally is not captured when the resim finds the completion. |
| NET-05 | Done | 6-bit epoch on input and meta packets. Untested on input packets. |
| NET-06 | Partial | `_start()` re-drops peers, but `_ready()` → `_net.reset()` wipes `dropped_peers`. |
| NET-07 | Wrong | Tick-0 drop: host drops at tick 0, clients at tick 1 (P0). |
| NET-08 | Done | Inputs masked with 0x7F everywhere. |
| NET-09 | Partial | Flag and stat restore are done. `reset()` never clears `last_board_was_challenge_fail`. Campaign end is broken. |
| NET-10 | Partial | `proto == 0` is accepted. No build id. `blen` is unchecked. |
| NET-11 | Wrong | Peer cap is done, but `match_active` is wiped at match start and disconnects are not gated. |
| NET-12 | Missing | `desync_detected` only prints. |
| NET-13 | Partial | Host-only `BASE_DELAY` changes are never broadcast and can never decrease. |
| UI-1 | Wrong | Enemy brushes are unchanged: 11/15 wrong, 4 missing, 4 nonexistent folders. |
| UI-2, UI-3, UI-5, UI-10 | Done | |
| UI-4 | Partial | `load_game`/`start_campaign`/menu clear state, but the `--board=` path does not. No offline custom-map entry. |
| UI-6 | Partial | `Face:L` is ignored for 0x07 brushes. |
| UI-7 | Partial | Default fixed. Keyboard device `-1` can be assigned to two players. |
| UI-8 | Partial | Reconnect clears the banner but the game stays paused (soft-lock). |
| UI-9 | Partial | `_check` added. The enemy test checks only `enemy_count() >= 1`. |
| ED-01 | Done | Toast is clipped to 76 px. |
| ED-02, ED-03 | Missing | Fixed `custom_map.bord` name. Playtest forces 2P/3P. |
| ED-04 | Done | |
| TOOL-01..04 | Missing | All four unchanged. |
| HYG-01, HYG-02 | Missing | 17 files still tracked. |
| HYG-03 | Partial | `.gitignore` now `/.github/*` + `!/.github/workflows/`, but no workflow exists. `.github/agents/*` is tracked although ignored. |
| DOCS-01..03 | Missing | README says six stages (actual 15). docs say netcode and editor are unbuilt. REMAINING_WORK is dated 2026-09-28. |
| Gate | Partial | `verify.ps1` runs 15 stages, including the net and editor tests. No packaging stage. |
| E1.1 | Partial | `ext_path` falls back per file to the dev tree. That hides missing packaged assets. |
| E1.2 | Wrong | The editor binary ships as `StepOnIt.exe`, so `has_feature("template")` is never true. |
| E1.3 | Partial | Five `res://../` paths remain. |
| E1.4 | Partial | `FileAccess` checks run before `load()`. Font MSDF settings differ. |
| E2 | Partial | The default launch works. User flags lack `--`. Console window. No timeout. |
| E3.1 | Partial | Valid preset. Needs export templates installed. |
| E3.2 | Partial | Stale `.pck` can ship. No `--token`. Hardcoded `.venv`. No checksums. |
| E4 | Partial | Never installs or updates. 1.0.0 and 1.0.1 are identical. Quits before any board. |
| §6.3 BUILD_ID | Missing | |
| §6.5 LAN/Tailscale code | Missing | Join code shows 127.0.0.1 unless UPnP succeeds. |

</details>

## 3. Issues to fix first

| # | Sev | Issue | Where | What breaks |
|---|---|---|---|---|
| 1 | P0 | NET-07 tick-0 drop | [rollback_net.gd EVENT_DISCONNECT](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/rollback_net.gd#L445-L472), [`_handle_drop_peer`](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/rollback_net.gd#L505-L533) | Host: `drop_t = maxi(0, -1 + 1) = 0`, but it sends `maxi(0, last_t) = 0`. Clients compute `drop_t = 0 + 1 = 1`. The player drops at different ticks, so the desync is permanent. |
| 2 | P1 | Match-start reset (NET-11/NET-06) | [game.gd `_ready()`](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/game.gd#L1196-L1212), [EVENT_CONNECT](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/rollback_net.gd#L416-L440) | `reset()` sets `match_active = false` and clears drops. After a mid-match drop, a stray client is accepted into the dropped slot and `dropped_peers.erase()` un-drops it, so the match stalls. Lobby disconnects are not gated. |
| 3 | P1 | Desyncs are ignored (NET-12 + NET-01) | [`all_meta_confirmed`](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/rollback_net.gd#L349-L358), game.gd `desync_detected` handler | A mismatch prints a line and the next board starts with diverged scores and lives. |
| 4 | P1 | Meta-confirm flood (NET-01) | [`_poll_online_meta_confirm`](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/game.gd#L2099-L2107) | Every frame on the tally screen sends one reliable packet, and the host re-broadcasts each. |
| 5 | P1 | Challenge intro never counts down | [game.gd L1517](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/game.gd#L1517) vs [L1743](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/game.gd#L1743-L1744) | The early return runs before the decrement. Offline needs a key press. Online, each peer starts when its own player presses a key, so the others stall. |
| 6 | P1 | Online campaign end (NET-09) | [game.gd L2112-L2145](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/game.gd#L2112-L2145) | Versus/Compete final board: `send_board_load(retry) + _start()` loops with wiped scores. Co-op final board: the host closes without telling clients. Multi-board Versus carries eliminations, so board 2 is already complete. |
| 7 | P1 | Join code is 127.0.0.1 (§6.5) | [main_menu.gd L882-L895](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/main_menu.gd#L882-L895) | Friends on LAN or Tailscale get a useless code when UPnP fails. |
| 8 | P1 | Editor enemy palette (UI-1 + UI-9) | [editor.gd L75-L91](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/editor.gd#L75-L91), [self-test L399-L411](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/editor.gd#L399-L411) | "Hippo" places a Wheelie, "Blob/Fire/Dino/Guard" use missing folders, and the self-test still passes. |
| 9 | P1 | Co-op shared pool (CORE-NEW-7) | [`soi_next_level`](file:///usr/local/google/home/seanstappas/tmp/repos/steps/core/src/soi_state.c#L255-L312), `commit_death` in `soi_physics.c` | Pool goes negative per eliminated partner. The next 1-UP is eaten, or a revival at 0 lives is free. Differs from `FUN_1002a308`/`FUN_1002b174`. |
| 10 | P1 | Versus SCORE rule (CORE-NEW-2) | `soi_level_complete`, `soi_versus_winner` | The sole survivor cannot finish when no goodies remain. If everyone is eliminated, the result is a draw regardless of score. |
| 11 | P1 | Test 69.5 is vacuous | [test_mechanics.c L4649-L4698](file:///usr/local/google/home/seanstappas/tmp/repos/steps/tests/test_mechanics.c#L4649-L4698) | No floor tiles, so P3 lands on the empty-grid fallback (3,2) before and after the fix. |
| 12 | P1 | Editor binary shipped (E1.2) | [publish_velopack.ps1 L44](file:///usr/local/google/home/seanstappas/tmp/repos/steps/tools/publish_velopack.ps1#L38-L49) | `template` is never true. Debug feature tags load the `template_debug` DLL. About 60-70 MB larger. `StepOnIt.exe -e` opens the editor. |
| 13 | P1 | Packaging can ship stale or untested builds | publish L45-49, [test_velopack_local.ps1](file:///usr/local/google/home/seanstappas/tmp/repos/steps/tools/test_velopack_local.ps1) | Export failures are masked by an old `.pck`. The test never installs, never updates, and packs identical payloads. |
| 14 | P1 | Controller reconnect soft-lock (UI-8) | game.gd `_on_joy_connection_changed` | The banner clears but `_paused` stays true, and SPACE no longer works. |
| 15 | P1 | `ext_path` hides packaging gaps (E1.1) | [session.gd L25-L40](file:///usr/local/google/home/seanstappas/tmp/repos/steps/godot_project/scenes/session.gd#L25-L40) | A file missing under `<exe>/extracted` silently loads from the dev tree on the build PC. |

P2 items are in the phase steps below.

## 4. Errors in the plan itself

1. **C1 (UI-1) folder names:** the enemy table names three folders that do not exist. Use `beenie_sprites` (not `beanie_sprites`), `Gargoyle_sprites` (capital G) and `bigger_mblock` (not `creeper_sprites`), as in `game.gd` `ENEMY_FOLDER`.
2. **A5 (CORE-NEW-7):** `10_17.md` said "confirm the original co-op shared-lives behavior in `analysis/decomp/` first". The ready copy replaced that with a fixed rule (`keep[1].lives >= 0`), and the decomp contradicts that rule.
3. **E3 step 2** copies `Godot_v4.3-stable_win64.exe` (the editor) as `StepOnIt.exe`, while E1.2 relies on `OS.has_feature("template")`. `template` is true only in export templates ([feature tags](https://docs.godotengine.org/en/4.3/tutorials/export/feature_tags.html)). `--export-pack` already needs the templates installed, so ship the template exe.
4. **§4 gate:** `verify.ps1` passing does not cover the packaging test, which is a separate command 12.
5. **The ready trim** dropped items without a ledger: NET-12, NET-13, ED-02, ED-03, DOCS-01..03, the C2 offline custom-map entry, §6.3 and §6.5.

---

## 5. Implementation plan

Rules for the implementing agent:

- **Test first.** Write the regression test, then run it on current code and confirm it fails. Fix, and confirm it passes. Note "fails before / passes after" in the commit message.
- **One commit per step.** Rebuild the DLL (`bridge/build_zig.ps1`) after any `core/` or `bridge/` change.
- **Original behavior is the target.**
  - In original modes (1P, 2P Co-op, 2P Compete), change behavior only to restore what the 1996 game does, and only after the decomp and a SheepShaver trace confirm it.
  - Remaster-only rules (Versus, 3P, friendly fire) stay behind their mode or flag.
  - Fixture replays (`tools/fixture_replay.py`) must not change unless an oracle trace justifies it.
- **Wire changes.** Any change to a packet's meaning bumps `PROTOCOL_VERSION`. Steps 1.1, 1.3 and 1.10 share one bump to 3.

Decisions (10/18):

| Topic | Decision |
|---|---|
| Desync policy (1.3) | End the match with a banner. Snapshot resync is out of scope for this round. |
| Co-op shared lives (2.5) and Co-op doors (2.8) | Audit first (decomp plus SheepShaver trace). Match the original exactly. If the port already matches, change nothing and add a test that locks it in. |
| Multi-board Versus (2.9) | Rounds. Each new board brings back every connected player with fresh lives. Score, kills and ammo carry over, as in Compete. |

| Phase | Depends on | Why this order |
|---|---|---|
| 0. Hygiene and tools | none | No behavior change. Clears noise. |
| 1. Netcode | 0 | Online play blockers. |
| 2. Core rules and tests | 0 | Independent of Phase 1. Can run in parallel. |
| 3. Editor and local UI | 2.6 (`parse_ext1`) | Uses the shared EXT1 parser. |
| 4. Distribution | 1.10 (build id) | Packaging plus join code. |
| 5. Gate, CI, docs | all | Locks the result in. |

### Phase 0: Hygiene and tools

**0.1 HYG-01/02.** Remove the 17 files:

```powershell
git rm -f _mkb44.py _mkdiff.py _swcount.py tests/_ball_dump.c tests/_ball_render.py tests/_ball_traj.c tests/_ball_traj2.c tests/_fall_probe.c tests/_probe_fall.c tests/_proofgen.c tests/_rundbg.c
git rm -f cmp.png mech_out.txt soi_enemies_before.c soi_shotlog.txt test_arena_38x26.bord verify_out.txt
```

Done when `git ls-files` lists none of them.

**0.2 HYG-03.** Keep `/.github/*` and `!/.github/workflows/`. Add `!/.github/agents/`, or untrack those files if they should stay local. The CI workflow itself is step 5.2.

**0.3 TOOL-01** (`tools/ascii2bord.py` `pack_ext1`):

- Make `has_p3` tri-state: `has_p3: Optional[bool] = None`.
- `None` keeps today's inference (`p3_col > 0 or p3_row > 0`). An explicit `False` clears bit 0.
- Pass `ext1.get("has_p3")` (no default) from `compile_bord_from_records`.
- Reason: hand-written ASCII with `p3_spawn:` and no `has_p3:` key relies on inference.

**0.4 TOOL-02** (`verify-roundtrip`):

- If `len(orig) == len(recompiled) + 2` and `orig[-24:-20] == b"EXT1"` and `orig[-26:-24] == b"\0\0"`, compare `orig[:-26] + orig[-24:]`.
- Otherwise keep the classic end-of-file pad check.

**0.5 TOOL-03.** Key `ENEMY_NAMES` by BORD id:

```text
1 CANNON, 2 WHEELIE, 3 WHEELIE_SLOW, 4 WALKER, 5 HIPPO, 6 HAMMER, 7 BEANIE_H, 8 BEANIE_V,
9 SPINNER, 10 TEETH, 11 SMILEY, 12 ANT, 13 KNIGHT, 14 GARGOYLE, 15 ROBO,
16 CREEPER_H, 17 CREEPER_V, 18 OSTRICH, 19 PIGGY
```

This matches `soi_bord_badguy_type`.

**0.6 TOOL-04** (`bridge/CMakeLists.txt`):

- Windows: `OUTPUT_NAME soi_bridge.windows.template_$<IF:$<CONFIG:Release>,release,debug>.x86_64`. Keep copying to the other config's name, as `build_zig.ps1` does.
- Linux: `PREFIX "lib"` and the `linux` name from `soi.gdextension`.
- macOS needs a real `.framework` bundle (`FRAMEWORK TRUE`). Leave it out of scope unless needed.

**Test first:** add `tools/test_ascii2bord.py` with plain asserts, covering:

- `pack_ext1(has_p3=False, p3_col=5, p3_row=5)` clears bit 0. `None` with coordinates sets it.
- `ENEMY_NAMES[2] == "WHEELIE"`, `[16] == "CREEPER_H"`.
- A synthetic padded EXT1 board passes the roundtrip check.

Run it with `py tools/test_ascii2bord.py`.

### Phase 1: Netcode

**1.1 NET-07: send `drop_t` on the wire (P0).** Change only these lines, and bump `PROTOCOL_VERSION` to 3.

```gdscript
# rollback_net.gd, poll_network(), EVENT_DISCONNECT, host branch
encode_be32(drop_pkt, 2, drop_t)                   # was: maxi(0, last_t)
for k in range(RING_BUFFER_SIZE):
	var tk: int = drop_t - 1 - k                   # equals last_t - k whenever last_t >= 0
	drop_pkt[6 + k] = (int(input_history[slot].get(tk, 0)) & 0x7F) if tk >= 0 else 0

# rollback_net.gd, _handle_drop_peer()
var drop_t := maxi(0, decode_be32(pkt, 2))         # was: last_t := decode_be32(...); drop_t := maxi(0, last_t + 1)
var last_t := drop_t - 1
peer_drop_tick[slot] = drop_t
```

Keep everything else in both functions:

- the misprediction check and the `earliest_mispredicted_tick` update;
- the zero-fill from `drop_t` to `current_tick + BASE_DELAY`;
- `dropped_peers[slot] = true`, `_update_last_confirmed_tick()` and `peer_disconnected.emit(slot)`.

**Test first:** new suite in `test_net_edge_cases.gd`.

1. Host plus two clients. P3 disconnects (`peer_disconnect_now(0)`) before it sends any input.
2. Assert host and P2 both have `peer_drop_tick[2] == 0`.
3. Tick both cores 120 ticks with the same inputs and assert equal `net_hash()`.

Before the fix, P2 has 1.

**1.2 NET-11 + NET-06: keep match state across the scene change.** Land all three parts together. Fixing `_ready()` alone would expose lobby-disconnect drops that today's reset hides by accident.

```gdscript
# rollback_net.gd (new)
func reset_for_match_start() -> void:
	var was_active := match_active
	var drops := dropped_peers.duplicate()
	reset()
	match_active = was_active
	dropped_peers = drops
	for d in dropped_peers.keys():
		peer_drop_tick[int(d)] = 0
```

1. `game.gd _ready()`: call `_net.reset_for_match_start()` instead of `_net.reset()`. Do not use `reset_for_new_board()`: it takes no arguments and bumps `board_epoch`.
2. EVENT_DISCONNECT: run the drop bookkeeping (drop tick, zero-fill, PKT_DROP_PEER) only when `match_active`. Always emit `peer_disconnected(slot)` so lobby labels still update.
3. `send_match_init()`: clear `dropped_peers` and `peer_drop_tick` before setting `match_active = true`.

**Test first:**

- (a) A lobby connect plus disconnect leaves `dropped_peers` empty at match start.
- (b) After MATCH_INIT and a mid-match drop in 3P, a new client is refused and the slot stays dropped.
- (c) Existing suites that simulate drops without MATCH_INIT set `match_active = true` first.

**1.3 Act on desyncs (NET-12 minimum, plus the NET-01 mismatch).**

- `all_meta_confirmed()` also requires every non-dropped entry to share the same `tick` and `hash`. Skip `hash == 0`, as `_handle_meta_confirm` does.
- Replace the print-only `desync_detected` handler in `game.gd` (about L1199):
  - stop ticking (new `_net_halted` flag checked next to `_paused`);
  - show "Desync at tick N. Match ended. Esc: menu";
  - host broadcasts `PKT_MATCH_END` (new `0x06`, reason byte 1).
- Use the same path when `lag_frames >= RING_BUFFER_SIZE` (about L1527).
- Land both halves together. If `all_meta_confirmed()` returns false with no handler, the tally screen hangs.
- **Test first:** two `RollbackNet` instances with confirms `(200, 0x1111)` and `(200, 0x2222)`. `all_meta_confirmed()` is false and `desync_detected` fires once.
- Decision (10/18): the banner and match end are enough. Snapshot resync stays out of scope for this round (section 7, item 1).

**1.4 One-shot meta confirm, plus a shared ack helper.**

```gdscript
# game.gd, _poll_online_meta_confirm()
if _online_meta_confirmed and not _net.meta_confirmed_peers.has(_net.local_slot) \
		and _net.are_all_peers_confirmed_through(_net.current_tick - 1):
	_net.send_meta_confirm(_net.current_tick, int(_core.net_hash() & 0xFFFFFFFF))
```

- Move the "primary window plus catch-up" send into `rollback_net.gd` `func send_ack_windows(anchor: int)`.
- Call it from `send_local_input`, `check_rift_stall` and `_poll_online_meta_confirm`. The frozen path then also sends the catch-up packet.
- **Test first:** a counter on `_broadcast_packet` for `PKT_META_CONFIRM` stays at 1 over 100 frozen frames.

**1.5 Startup tick-0 catch-up.**

- In `send_ack_windows`, anchor the catch-up at `min_peer_ack + 15` and use the threshold `> 15`. Today it is `+ 16` / `> 16`.
- Why: `last_confirmed_tick` starts at 0, so a peer that received nothing still acks 0. The current window `[1..16]` never resends tick 0.
- **Test first:** add a test-only hook that drops the first K outgoing input packets from one peer, with K large enough that `target_tick > 16`. Tick 0 must still confirm and no permanent rift stall may occur.

**1.6 Input-delay ratchet** (`send_local_input`):

```gdscript
var desired: int = current_tick + BASE_DELAY
var target_tick: int = desired
if prev_scheduled >= desired:
	target_tick = prev_scheduled                   # already scheduled ahead: add nothing this frame
elif prev_scheduled >= 0:
	target_tick = maxi(desired, prev_scheduled + 1)
```

- Keep the existing fill loop. It becomes empty when nothing new is scheduled.
- **Test first:** set `last_confirmed_per_peer[local_slot] = current_tick + 10` and call `send_local_input` for 12 frames. The lead returns to `BASE_DELAY`.

**1.7 Challenge intro** (`game.gd _physics_process`):

```gdscript
if _script_hold or _paused or (_alt and _alt_state != "play"):
	return
if _challenge_intro > 0:
	_challenge_intro -= 1
	queue_redraw()
	return
```

- Delete the dead decrement (about L1743).
- In `_input` (about L1939) and `_press_enter` (about L2068), let a key skip the intro only when `not Session.is_online`. Keep Esc working online.
- **Test first:** headless offline run on a challenge board without `_harness_run`. After 200 physics frames, `_core.tick() > 0`.

**1.8 NET-03 tally after resim** (display only, P2):

- Move the body of `if _core.level_complete() and not _tally_captured:` (about L1682-1712) verbatim into `_capture_level_complete_tally(play_audio: bool)`. Keep `_tally_award_max`, `_tally_mult`, `_warp_vp`, `Audio.play_snd(16969)` and `Audio.play_ending_music()`.
- Call it from the live path. Also call it right after the resim loop when `_core.level_complete()`, passing `play_audio = not _tally_captured` so a moved completion tick recomputes without replaying sounds.

**1.9 Campaign end (NET-09):**

- Add `PKT_MATCH_END` with a reason byte: 0 complete, 1 desync, 2 version.
- Co-op final board: the host sends it before `_net.close()`. Clients show the ending, then return to the menu.
- Versus/Compete final board: show results and end the match. Replace the `send_board_load(retry) + _start()` loop.
- Multi-board Versus plays as rounds: see step 2.9. After the last board, show the result and return to the menu (online: send `PKT_MATCH_END` first).
- `reset()`: add `last_board_was_challenge_fail = false`.
- `game.gd` L2121 and L2163: call `Session.advance()` instead of `Session.board_index += 1`. `_board_number()` reads `Session.board_path`, which only `advance()` updates.

**1.10 NET-10 + §6.3: strict version and build id** (part of the protocol-3 bump):

- `_handle_match_init`: reject `proto != PROTOCOL_VERSION`, including 0.
- Append a 4-byte build id after the board bytes. Use `SoiCore.build_id()`: a compile-time `-DSOI_BUILD_ID=0x<git short sha>` passed by `build_zig.ps1`, defaulting to 0 for dev builds.
- Clients refuse a mismatch with "Version mismatch: restart to update" (reason 2).
- Check `pkt.size() >= 0x10 + blen + 4`. `blen` is BE16 at `0x0A` and the seed is BE32 at `0x0C`.
- Also bound `_handle_board_load`: BE16 `blen` at 2, payload at 8.

**1.11 NET-13.** Freeze `BASE_DELAY` per board, so the host does not change it mid-board. Send the next value in PKT_BOARD_LOAD (spare bits of byte 1) and apply it on both sides at board start.

**1.12 Net test coverage.** Each of these must fail on current code:

- tick-0 drop (1.1);
- lobby and match-active gating (1.2);
- hash-mismatch abort (1.3);
- one-shot confirm (1.4);
- tick-0 catch-up (1.5);
- delay ratchet (1.6);
- stale-epoch PKT_INPUT_TICK and 63→0 wrap (NET-05);
- `_start()` keeps a dropped player dropped (NET-06);
- version 0 and version 99 rejected (1.10).

Also fix `net_soak_test.gd`: it prints `Ticks Simulated` after `close()` has zeroed `current_tick`.

### Phase 2: Core rules and tests

**2.1 Make test 69.5 real.**

- Byte layout: shift the EXT1 trailer 6 bytes so the tile record holds `(9,1),(9,2),(8,2),(3,3)` at 28..35, `(100,100)` at 36..37, the terminator at 38..41 and `EXT1` at 42..65.
- Copy every EXT1 field (`p3_block` 0x020D, `vs_spawns` (5,5)/(12,5), lives 3). Grow the buffer to at least 66 bytes, compute the CRC over `p3_bord + 42`, and pass `len = 66`. 69.6 reuses this buffer.
- Assert P3 sits on a valid cell (empty, supportive cell below) that is not the empty-grid fallback `(p1_col + 1, p1_row) = (3,2)`. Pin the exact cell after one run.

**2.2 P3 spawn after the grid is final.** In `soi_load_level` (about L669), move only the `if (ext_has_p3) soi_spawn_player3(w);` block below `soi_switch_load_scan` and the creeper-init loop. Keep `w->level_loaded = 1;` where it is.

**2.3 vs_spawns call order and bounds.**

- Add a static helper above `soi_spawn_player3`: `has_valid_vs_spawn(w, idx)` means not (0,0), and both coordinates inside `grid_cols`/`grid_rows`.
- Use it in `soi_load_level` (P1/P2), `soi_spawn_player3` (P3) and `respawn_player_in_place`.
- `soi_set_play_mode(VERSUS)` with `level_loaded && tick == 0` re-places P1/P2 the same way `place_player` does. For an active P3 it calls `soi_spawn_player3(w)`, so Co-op-only P3 stats (`lives = -1`) are reset.
- `reload_board_on_death`: set `w->play_mode = mode` before `soi_load_level`, as `soi_next_level` already does.
- **Test first:** `load_level` then `set_play_mode(VERSUS)` gives the same positions as the reverse order.

**2.4 CORE-NEW-2:**

- `soi_level_complete`: SCORE ends on `participants >= 2 && alive_count <= 1`, or when all goodies are collected. Remove the now-unused `active_count`.
- `soi_versus_winner` SCORE: skip eliminated players while any player is uneliminated. If all are eliminated, take the highest score among active players.
- `soi_versus_winner` DOOR: keep the existing "two or more survivors means no winner" guard.
- **Test first:** P2 eliminated with goodies left gives complete with winner P1. All eliminated gives the higher score.

**2.5 CORE-NEW-7, the Co-op shared pool (audit first).** The target is the 1996 behavior. The port already differs from the decomp in two ways:

- When P2 dies with 0 lives left, the port's shared counter goes to -1. The decomp keeps it at 0.
- On the next board, the decomp revives P2 only if the counter is above 0, and spends one life. The port (since `602b31a`) revives without spending.

Audit:

- Read `FUN_1002a308` L143-148 (P1 death) and L182-188 (P2 death), plus `FUN_1002b174` L30-36.
- Add the "Co-op lives at 0" task below to `plan/SHEEPSHAVER_ORACLE_TASKS.md` and record the answers in `plan/oracle-findings/FINDINGS.md`.
- Write the expected result for each step of that task. Change the code only where the port differs.

> **Oracle task: Co-op lives at 0.**
> 1. Start a 2-player Co-op game and play until the shared lives counter shows 0. Screenshot the counter.
> 2. Let P2 die. Note whether P2 is gone for the rest of the board, and what the counter shows.
> 3. Have P1 finish the board without a 1-UP. On the next board, note whether P2 is back and what the counter shows.
> 4. Repeat, but have P1 collect a 1-UP before finishing. Note whether P2 is back and whether the counter went down by one.
> 5. Let P1 die at 0 while P2 is alive. Note whether the game ends or P2 keeps playing.

Expected change, if the trace agrees with the decomp:

- `commit_death` tail (`soi_physics.c`, about L362-365):
  - In Co-op at `pool->lives <= 0`, eliminate the dying player and set the pool to -1 only when no active, uneliminated teammate remains.
  - Otherwise decrement and respawn, as today.
- `soi_next_level` in Co-op:
  - clamp the pool to `>= 0`;
  - revive an eliminated active player only while the pool is above 0, and decrement once per revival;
  - leave anyone still eliminated with `alive = 0`.
- Section 48 (`test_mechanics.c` about L3296, "4 → 3") must still pass.
- Re-record the Co-op fixture only if the trace confirms the change.
- **Test first:** 69.7 mirrors the trace: death at 0 while the partner lives, then board clear with and without a 1-UP.

**2.6 Tests for CORE-NEW-9, plus one EXT1 parser.**

- 69.8: flip each newly serialized field and assert that both `soi_state_hash` and `soi_net_hash` change.
- `test_synctest.c`: also compare `soi_state_hash`.
- Factor the C EXT1 parse into `soi_parse_ext1(const uint8_t*, size_t, SoiExt1Info*)` and bind it as `SoiCore.parse_ext1(bytes) -> Dictionary`. `editor.gd` and the menu (step 3.5) then use one parser instead of today's three plus a proposed fourth.

**2.7 Cleanups:**

- Fix the stale "NOT serialized" comments (`soi_internal.h` L120, L216, L263).
- Remove the duplicated door comment (`soi_grid.c` L293-308).
- Add `if (!w) return;` to `soi_set_seed`.

**2.8 Co-op door rule (audit first).** The port lets any Co-op player exit any unlocked door (`any_door` in `soi_pickup_check`). `FUN_1002bc64` allows only the player's own door or the universal door, with no mode check.

> **Oracle task: Co-op doors.** On a 2-player Co-op board with separate blue (P1) and green (P2) doors, unlock the doors. Walk P1 into the green door and note whether the board ends. Repeat with P2 into the blue door, and with each player into the universal door.

- If the original is stricter, restore its rule for 2P Co-op.
- For 3P (remaster-only), extend the same rule: P3 exits its own door (0x0935) or the universal door.
- If the trace shows any-door exits, keep today's code and add a test that locks it in.

**2.9 Versus rounds (decided 10/18).** Versus starts through `Session.start_campaign()`, so it plays boards 401 onward unless a custom map is picked. Today `soi_next_level` keeps each player's `eliminated` flag and lives. The board-1 loser therefore starts board 2 eliminated, and board 2 ends on its first tick. That repeats on every board, offline and online.

Fix: in `soi_next_level`'s restore loop, change only the Versus case.

```c
if (mode != SOI_MODE_VERSUS)
    w->players[i].lives = keep[i].lives;   /* Versus keeps the fresh lives: 2, or EXT1 starting_lives */
...
if (mode == SOI_MODE_COOPERATE && /* existing co-op rule, see step 2.5 */)
    w->players[i].eliminated = 0;
else if (mode == SOI_MODE_VERSUS)
    w->players[i].eliminated = 0;          /* new round: every connected player plays */
else
    w->players[i].eliminated = keep[i].elim;
```

- The existing `if (!keep[i].active || eliminated)` line still keeps dropped players out.
- `soi_world_init` already sets lives to 2. `soi_load_level` applies EXT1 `starting_lives` outside Co-op.
- Score, kills and ammo still carry over. Original modes are untouched.
- **Test first (69.9):** 2P Versus with P2 eliminated (lives -1) and P1 score 500. After `soi_next_level`, check:
  - P2 has `eliminated == 0`, `alive == 1` and lives 2;
  - P1's score is still 500;
  - `soi_level_complete(w) == 0`;
  - a dropped player stays inactive.
- Before the fix, P2 stays eliminated and the board is complete at once.

### Phase 3: Editor and local UI

**3.1 UI-1 + UI-9: enemy palette and a self-test that can fail.**

- Replace the enemy rows. `etype` is the `SoiEnemyType` value and must match `ENEMY_FOLDER`:

| Name | Tile | Folder | etype |
|---|---|---|---|
| Turret/Cannon | 0x1E140601 | cannon_sprites | 12 |
| Wheelie | 0x0602 | disk_sprites | 5 |
| Wheelie (slow) | 0x0603 | disk_sprites | 5 |
| Walker | 0x14000604 | walker_sprites | 10 |
| Hippo | 0x1E140705 | hippo_sprites | 3 |
| Hammer | 0x1E140706 | hammer_sprites | 7 |
| Beanie H / V | 0x0607 / 0x0608 | beenie_sprites | 8 |
| Spinner | 0x0609 | spinner_sprites | 13 |
| Teeth | 0x1E14070A | teeth_sprites | 11 |
| Smiley | 0x1E14070B | smiley_sprites | 6 |
| Ant | 0x1E14070C | ant_sprites | 1 |
| Knight | 0x1E14060D | knight_sprites | 15 |
| Gargoyle | 0x1E14060E | Gargoyle_sprites | 14 |
| Robo | 0x060F | robo_sprites | 9 |
| Creeper H / V | 0x14000610 / 0x14000611 | bigger_mblock | 16 |
| Ostrich | 0x1E140712 | ostrich_sprites | 2 |
| Piggy | 0x1E140713 | piggy_sprites | 4 |

- `_run_self_test()` must check, for every brush:
  - `_get_sprite(folder, frame) != null`;
  - `test_core.enemy_type(0) == etype`, for both default and 0x0500 facing. For spawners, confirm on the first run whether `enemy_type(0)` reports the spawner or its child;
  - the `_draw` lookup resolves the same folder.
- Restore editor state afterwards (`_init_grid`, `_set_brush`, `status_msg`).

**3.2 One enemy table.** Move `ENEMY_FOLDER` into a shared script. Let the editor derive the folder from `etype`, so folder names cannot drift again.

**3.3 UI-6** (`_paint_at`): when `enemy_facing_left`, set direction 0x05 for any enemy brush. Otherwise keep 0x07 brushes and set 0x06 for the rest.

**3.4 UI-7 + UI-8.**

- Move slot claiming and pad fallback into `Session` helpers. Never assign a keyboard id already in use.
- Add `_paused_by_disconnect`. A reconnect unpauses only if the disconnect paused the game and no assigned pad is still missing.
- Test the `Session` helpers directly in the self-test.

**3.5 UI-4.**

- The `menu.gd --board=` path clears `custom_map_path`, `custom_board_bytes` and the editor metas.
- Add an offline File > "Play Custom Map..." entry. It lists `user://custom_maps/*.bord` (call `list_dir_end()` and free the popup on hide). It applies EXT1 defaults through `SoiCore.parse_ext1`: mode, players, friendly fire, victory rule, lives.
- If the map has no EXT1, set `Session.victory_rule = -1` and `Session.friendly_fire = -1` so `_start()` does not overwrite the map.

**3.6 ED-02 + ED-03.**

- Save As (name, `validate_filename()`) and an Open list in `save_to_default_file`/`load_from_default_file`.
- `playtest_in_memory()`: add `playtest_players`, default 2 (today's behavior) with 1P allowed and 3 when `has_p3`. Persist it in `_save_editor_state`.
- The self-test removes any file it writes.

**3.7** Draw the status toast as a playfield overlay (not the 76 px slot). `_validate_map()` only feeds the warning banner in `_draw()` (about L732). Also ask for confirmation on save or playtest when it returns warnings.

### Phase 4: Distribution

**4.1 Ship the release template.**

- In `export_presets.cfg`, set `custom_template/release` to the 4.3 `windows_release_x86_64.exe` and keep `binary_format/embed_pck=false`.
- Replace "copy editor exe + `--export-pack`" with `--export-release "Windows Desktop" build/win/StepOnIt.exe`.
- Then `template` and `release` are true and `template_release.dll` loads.
- Templates are already required by `--export-pack` ([exporting](https://docs.godotengine.org/en/4.3/tutorials/export/exporting_projects.html)).

**4.2 `Session.ext_path`.** Keep the signature and the prefix stripping. Pick the base once:

- `<exe_dir>/extracted` if it exists;
- otherwise the dev tree, but only when `OS.has_feature("editor")`;
- otherwise still `<exe_dir>/extracted`, so errors point at the packaged location.

Return the base with no trailing slash when `rel` is empty. In exported builds, `globalize_path("res://...")` is not a usable OS path ([`globalize_path`](https://docs.godotengine.org/en/4.3/classes/class_projectsettings.html#class-projectsettings-method-globalize-path)).

**4.3 The five remaining `res://../` paths.**

- `audio.gd` `CUSTOM_SFX_DIR`: use `<exe_dir>/custom_sfx` when packaged.
- Screenshots (`game.gd` L1778, L1867 and `main_menu.gd` L136): use `user://screenshots` when packaged.
- Script path (`game.gd` L1795): resolve relative to the exe dir.

**4.4 Fonts and icons.** Try `ResourceLoader.exists()` / `load()` first. Make the `Chicago.ttf.import` MSDF setting match the runtime setting.

**4.5 Launcher** (`tools/launcher/launcher.c`):

- **Routing.** Drop `--veloapp-*` and legacy `--squirrel*` arguments.
- Put known Godot engine flags before `--`: `--headless`, `--quit`, `--quit-after`, `--verbose`, `--resolution`, `--position`, `--fullscreen`, `--windowed`, driver flags and `res://` paths. Put everything else after `--`.
- Godot silently ignores unknown flags placed before `--`, so `--original` does nothing today ([`get_cmdline_user_args`](https://docs.godotengine.org/en/4.3/classes/class_os.html#class-os-method-get-cmdline-user-args)).
- Add `--3d` unless `--original`, `--hd` or `--3d` is present. Add `--music` unless `--music` or `--no-music` is present.
- **Safety.** Use a bounded append helper with no `size_t` underflow.
- Build as a GUI-subsystem exe, so no console flashes. zig uses the GNU target, so use `-Wl,--subsystem,windows` (or `-mwindows`) and check it with zig 0.13.
- Log to `%LOCALAPPDATA%\StepOnIt\launcher.log`.
- **Robustness.** Run the update check on a worker thread with a timeout of about 5 s. On timeout, launch now and update next time.
- Hold a named mutex so a running game never blocks an update.
- `FreeLibrary` the Velopack DLL.
- Velopack signals first run with `VELOPACK_FIRSTRUN` and only uses `--veloapp-*` hook arguments, which `vpkc_app_run` consumes ([hooks](https://docs.velopack.io/integrating/hooks)). Shortcut and first-run launches therefore already take the default branch.

**4.6 `publish_velopack.ps1`:**

- Delete `build/win/StepOnIt.pck` before exporting, and check `$LASTEXITCODE`.
- Fall back to `py` when `.venv` is missing.
- Pin SHA-256 hashes for the `velopack_libc` and `vpk` downloads.
- Pass `--token $env:GITHUB_TOKEN` to `vpk download github` and `vpk upload github`, and fail early if it is unset with `-UploadToGitHub`.
- Require `-RepoUrl` for distributable builds instead of writing a placeholder `update_config.json`.
- Check the launcher build's exit code.

**4.7 `test_velopack_local.ps1`, testing what users actually get.**

1. Build 1.0.0 with the asset mirror when `build/win/extracted` is missing.
2. Stamp a version file into the pck, then build 1.0.1 with `-SkipAssetMirror`. Assert the delta exists, is under 5 MB, and that the two full packages differ.
3. Install 1.0.0 silently from `StepOnIt-win-Setup.exe` into a temp dir. Check the 0.0.1053 Setup flags first (`--silent`, `--installto`).
4. Run the installed launcher with `SOI_UPDATE_URL=<releases>` and wait for the update. Assert the installed version is 1.0.1.
5. Run the installed launcher on `res://scenes/smoke_test.tscn --headless --quit-after 600`. `smoke_test.gd` never calls `quit()`, so add `get_tree().quit(0)` there or keep `--quit-after`.
6. Use `Start-Process -Wait -PassThru`: PowerShell does not wait for GUI-subsystem exes.
7. Assert exit code 0 and the smoke PASS line.
8. Restore `SOI_UPDATE_URL` in `finally`.

**4.8 §6.5 join code.**

- Pick the address from `IP.get_local_addresses()`: 100.64.0.0/10 (Tailscale) first, then RFC1918.
- Show a LAN/Tailscale code and, when UPnP works, a separate WAN code.
- Keep the UPnP `Thread` as a member and call `wait_to_finish()` in `_exit_tree()`.

### Phase 5: Gate, CI, docs

**5.1 `verify.ps1`:**

- Add `py tools/test_ascii2bord.py`.
- Add an optional `-TestPackaging` stage that runs step 4.7 and captures `2>&1`.
- Fail if any expected PASS string is missing.

**5.2 CI.** Add `.github/workflows/verify.yml` on a self-hosted Windows runner (the toolchain lives in `D:\SOI-tools`). It runs `tools/verify.ps1` on push and pull requests.

**5.3 DOCS-01..03.**

- README L10/L50 and `docs/remaster/README.md`: 15 stages.
- `docs/remaster/README.md` L131-133: netcode and editor are built.
- Refresh `plan/REMAINING_WORK.md`.
- Update the `verify.ps1` header comment.

**5.4 Plan ledger.** Every future plan keeps a table of ID, status and test name. "Ready" copies may not drop IDs silently.

## 6. Verification

Keep commands 1-12 from `10_17_ready.md` §4. Add these:

| Check | Expected |
|---|---|
| `py tools/test_ascii2bord.py` | All asserts pass |
| `test_mechanics` (new 69.5 layout, 69.7, 69.8, 69.9) | `ALL MECHANIC TESTS PASSED` |
| `test_synctest` comparing `soi_state_hash` too | `ALL SYNCTEST ROLLBACK CHECKS PASSED` |
| Editor `--test-editor` (types, sprites, facing, devices) | `MapEditor CLI self-test: PASS`. Must fail on today's `BRUSHES`. |
| `test_net_edge_cases.ps1` (tick-0 drop, gating, version) | PASS. Must fail on `602b31a`. |
| `test_net_progression.ps1` (mismatch abort, one-shot confirm, intro, Versus board 2) | PASS |
| `verify.ps1 -TestPackaging` | `ALL STAGES PASSED`, including install + update + smoke |
| Mutation check | Revert each fix locally. Its test must fail. |

## 7. Further improvements (beyond the plan)

1. Snapshot resync on desync, instead of ending the match (`snapshot_save`/`snapshot_load` already exist).
2. Generate `soi_net_hash` from the `soi_serialize` byte stream, so the two field lists cannot drift.
3. Bound `input_history`, `input_confirmed` and the hash maps to a window behind `last_confirmed_tick`.
4. Align the PvP push wall probes with `move_clear` insets (`x+10`/`x+20`, not the 32 px box).
5. Editor polish: undo/redo, a facing glyph on enemy cells, and removing the duplicate `KEY_TAB` branch.
6. Code-sign releases when a certificate is available (`vpk pack --signParams`).
7. Size the packaged window to the largest integer multiple of 640x480, as `play.ps1` does.

## 8. Review notes

**Corrected during review (do not act on these):**

- Velopack does not pass `--squirrel-firstrun`, so that launcher "P0" was reduced to "user flags lack `--`" (P2).
- The editor binary issue is P1, not P0: the launcher's default path passes `-- --3d --music`.
- The Challenge intro is P1, not P0: it causes a start skew and stall, not a desync.
- The net report's byte-layout quotes were wrong. The real layouts:
  - PKT_INPUT_TICK: 36 bytes, inputs at 20..35.
  - META_CONFIRM: 10 bytes.
  - MATCH_INIT: BE16 `blen` at 0x0A.
  - BOARD_LOAD: BE16 `blen` at 2, payload at 8.
  - Senders and receivers agree.
- `_campaign`/`_campaign_idx` do not exist. Online progression uses `Session.board_index`/`board_list`.
- Neither plan told the implementer to clamp `last_t` on the wire. NET-07 is an implementation bug.
- The ui report said `_validate_map()` has no callers. It is called from `_draw()`.

**Snippet traps found:**

- `rollback_to_tick` does not exist. The real variable is `earliest_mispredicted_tick`.
- `peer_instances` maps a peer id to a slot int, so it has no `.send`.
- `reset_for_new_board()` takes no arguments and bumps the epoch.
- Moving the P3 block must keep `w->level_loaded = 1`.
- Keep the SOI_WIN_DOOR guard that returns no winner while two or more survive.
- The test 69.5 rewrite must not overwrite the terminator or the EXT1 bytes.
- The `Session` fields are `_presentation_ready`/`remaster_sfx`, not `_presentation_inited`/`use_3d`.
- The editor functions are `save_to_default_file`/`playtest_in_memory`.

The plan above uses only identifiers that were checked against `602b31a`.



