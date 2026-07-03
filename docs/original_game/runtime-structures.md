# Runtime Data Structures & Gameplay Logic (Original) — Reverse Engineering

Status: **in progress** (2026-07-02). Reversing the in-memory game state and per-frame logic from the
decompiled PEF, to the depth needed to write the fresh C core (`core/src/*.c`). Addresses are
PEF-relative (load base `0x10000000`); low-memory globals are noted separately.

Method: all 721 functions are decompiled to `analysis/decomp/all/` with `analysis/decomp/INDEX.tsv`
(name, size, imports, referenced data globals) via `analysis/ghidra/dump_all.py`. Struct layouts are
read from the field offsets in the decompiled accessors.

---

## 1. Per-frame pipeline

There are **two near-identical round loops** (same structure: frame-sync wait, input every 2 frames, per-player update, draw):
* `FUN_10029264` — the **demo / attract** loop (loads `DEMO 128`, plays `DMKY`).
* `FUN_1002a308` — the **live 2-player** round loop (updates players 1 **and** 2).

Each loop, per frame (Speed=Medium ≈ 14 ms), calls **per-player**:
1. **Input** (every 2 frames): `FUN_1002d440` (live `GetKeys`) or `FUN_10029ca0` (demo) → the player's input latch; `FUN_1002a15c` records it (demo).
2. **`FUN_1001166c(player)`** — reads the input latch, sets the player's **movement direction** + animation state, and calls the **mover `FUN_10014700(player)`**.
3. **`FUN_100115c0(player)`** — the rest of the per-player update (physics/collision/draw — being mapped).
4. **Enemy update:** `FUN_1000c544` et al. advance each enemy entity.

---

## 2. Player array — base `0x1003a9b0`, stride `0x70` (112 bytes), indices 0–2 — CONFIRMED

A 3-slot array (matches `MAX_PLAYERS = 3`): **index 0 @ `0x1003a9b0` is reserved/template**, **P1 = index 1 @ `0x1003aa20`**, **P2 = index 2 @ `0x1003aa90`**. Accessors use `player_index * 0x70 + <field addr of slot 0>`. Fields (offset from a slot base):

| Field off | Addr (P1, index 1) | Meaning | Confidence |
|---|---|---|---|
| `+0x06` | `0x1003aa26` | current sprite/graphic handle (from `DAT_1003ad34` table) | HYPOTHESIS |
| `+0x1e..0x24` | `0x1003aa3e..44` | **input latch** (7 bools, §7.5) — a *field of the player struct* | CONFIRMED |
| `+0x25` | `0x1003aa45` | "moved this frame" flag | HYPOTHESIS |
| `+0x28` | `0x1003aa48` | dead / inactive flag (checked first each update) | HYPOTHESIS |
| `+0x2c` | `0x1003aa4c` | move sub-step counter | HYPOTHESIS |
| `+0x2e` | `0x1003aa4e` | **movement direction** (1/2/3/4) | HYPOTHESIS |
| `+0x30` | `0x1003aa50` | animation/sprite state (1..4) | HYPOTHESIS |
| `+0x34` | `0x1003aa54` | facing (==1 branch) | HYPOTHESIS |
| `+0x3c` | `0x1003aa5c` (P1) | **score** (`int`) — see §7 | CONFIRMED |
| `+0x46` | `0x1003aa66` | **lives** (decremented on death) | HYPOTHESIS (corroborated) |
| `+0x48` | `0x1003aa68` | **eliminated flag** (set when lives < 1) | HYPOTHESIS (corroborated) |
| `+0x70` (in a **parallel** 0x1003aa20 block) | `0x1003aa20/24` | screen **x / y** (px) | CONFIRMED (loader) |
| — | `0x1003aa62` | **bonus / time** (default 5000) | CONFIRMED (loader) |

**Note:** the input latch being at `player + 0x1e` is why a literal address grep only found the 3 marshaller functions — movement code reads it as `*(char*)(base + 0x1e..)`, not the absolute address. `FUN_1001166c`'s nested `if` chain tests latch bytes `+0x21/+0x22/+0x23/+0x24` (the four direction bits) and sets the direction field — so the **bit→direction mapping** can now be read from there (in progress). The mover is **`FUN_10014700`**.

---

## 3. Enemy entity struct — base `0x10037e48`, stride `0x46` (70 bytes) — CONFIRMED (size/stride)

An array of enemy entities. Managed by `FUN_10005948` (allocate a slot), `FUN_10005ac8`,
`FUN_10005c64`, `FUN_100058ac`; the per-frame mover/animator is `FUN_1000c544`. Fields seen so far
(offsets from `0x10037e48`):

| Field off | Meaning | Confidence |
|---|---|---|
| `+0x02` | type / sprite id | HYPOTHESIS |
| `+0x0c` | animation frame counter (cycles `0x10`→`0x1e`) | CONFIRMED |
| `+0x0e/0x10` | cell x / cell y (`= pos >> 5`) | CONFIRMED |
| `+0x28/0x2a` | **x / y velocity** (added to pos each frame) | CONFIRMED |
| `+0x2c/0x2e` | **x / y position** (fixed-point; `>>5` → cell) | CONFIRMED |
| `+0x42` | **point value** (score awarded on kill) | CONFIRMED |

Velocity-based movement on the 32-px grid (`>>5` = ÷32 matches the confirmed cell size).

**Per-enemy behaviour functions** (each is the type's per-frame **update + kill/score** routine, not just
setup: it advances the entity, and on kill awards its point value to the killer). All 11 scoring types
confirmed (point value written to enemy `+0x42`, score awarded to player `+0x3c`):

| Enemy | Points | Function |
|---|---|---|
| Ant | 50 (`0x32`) | `FUN_1000602c` |
| Ostrich | 100 (`0x64`) | `FUN_100093a0` |
| Hippo | 200 (`0xc8`) | `FUN_100081f8` |
| Piggy | 250 (`0xfa`) | `FUN_10009a78` |
| Wheelie | 300 (`0x12c`) | `FUN_10009e98` (HYPOTHESIS: seeks player) |
| Smiley | 400 (`0x190`) | `FUN_1000d130` |
| Hammer | 500 (`0x1f4`) | `FUN_10007998` |
| Beanie | 750 (`0x2ee`) | `FUN_10006378` / `FUN_10006840` (HYPOTHESIS: self-replicates) |
| Robo | 1000 (`0x3e8`) | `FUN_1000a780` |
| Walker | 1250 (`0x4e2`) | `FUN_1000dd4c` |
| Teeth | 1500 (`0x5dc`) | `FUN_1000d8c4` |

Hazards **Cannon** and **Spinner** (no points) have no scoring function — spawned/handled differently (TODO).
More enemy struct fields (base `0x10037e48`, from the update functions): `+0x1e` render flag, `+0x1f`
active/pending flag, `+0x20` **dead/kill flag**, `+0x24` anim/move delay counter, `+0x2c` a countdown
(lifetime/steps). AI-state and velocity sub-fields (from an Explore pass, **HYPOTHESIS**): `+0x26` ai_state,
`+0x28/0x2a` vel, `+0x2c/0x2e` pos accumulator, `+0x40` owner player index (for scoring).

---

## 4. Enemy spawning is PROCEDURAL (not from BORD records) — CONFIRMED

There are **no explicit spawn records** in the `BORD` body — the tile section ends at a `u32 0` and the
loader stops. Enemies are spawned at runtime from the **header parameters** (§7.4):
- `_DAT_1003b28e` = **thrown_badguy type** → `switch` dispatch in `FUN_1000b7dc` sets up the entity
  (sprite, position) per type.
- `_DAT_1003b290` = **percent_ultrabuster** → probability check in `FUN_1000b44c`.
- `_DAT_1003b28c` = **percent_badguy** → paired with the type.
- `FUN_1000c680` (RNG-weighted `Random()&0x3F` table pick) chooses tile/nasty variants;
  `FUN_1000c544` calls it at target cells.

So the earlier guess that the `BORD` body held badguy records (`46 0a` leads) is **superseded** — those
trailing bytes are either more tile data or unused; enemies come from the header + RNG at play time.

---

## 5. Function inventory (from `INDEX.tsv`, by subsystem)

- **Player / physics:** `FUN_1002a308` (main updater), `FUN_1002a15c` (input record), `FUN_1002d440`
  (live input), `FUN_10029ca0` (demo input).
- **Enemies:** `FUN_10005948`/`FUN_10005ac8`/`FUN_10005c64`/`FUN_100058ac` (slot mgmt),
  `FUN_1000c544` (update/move), `FUN_1000b7dc` (spawn dispatch), `FUN_1000b44c` (ultrabuster prob),
  `FUN_1000c680`/`FUN_1000c278`/`FUN_1000cbe0` (RNG helpers).
- **Level load:** `FUN_1002b448` (loader), `FUN_1001a348` (header+tile parse), `FUN_1002b708` (border),
  `FUN_1002e6ac`/`FUN_1002e6bc` (cell→px).
- **Loop / timing:** `FUN_10029264` (in-round loop), `FUN_10019428`/`FUN_100193c8` (frame timer),
  `FUN_1001c398` (Speed menu → period).

---

## 6. Live playfield grid & the block create/destroy verb — CONFIRMED

The **live grid** (populated by `FUN_1002b708` from the parsed `BORD` tiles) is an array of **u32 cells**
at base **`0x1003ad68`**, indexed `base + row*0x3c + col*4` (row stride `0x3c` = 15 cells, col stride 4).

**Cell encoding (u32):**
- **low byte (`& 0xFF`)** = block type / presence — **`0` = empty**.
- **bit `0x100`** = **permanent** (can't be created/destroyed); border walls = **`0x300`**.
- **bit `0x1000`** = special block that carries a **payload in the upper 16 bits** (`>> 0x10` — colour / contained goodie, TBD).

**The grid-mutation primitive — `FUN_1002754c(x, y, type, …)`**: sets a cell and plays the create/destroy
animation. `type == -1` (`0xffffffff`) **destroys**; a non-negative type **creates** a block of that type.

**The core mechanic — `FUN_1002d04c(a, b, player)`** (triggered by a movement direction in the state
machine `FUN_1001166c`): a **create-or-destroy toggle** on the target cell, gated by permanence:
- if **not permanent** (`& 0x100 == 0`):
  - if **empty** (`& 0xFF == 0`) → **CREATE** via `FUN_1002754c(..., blockType, …)` using the player's
    **block type** field (`player + 0x36` = `0x1003a9e6`); SFX `FUN_1002b020(4, 7)`; also draws a preview
    (`FUN_100047e8` = a pixmap blit, **not** a logic check — corrected).
  - else (**occupied**) → **DESTROY** via `FUN_100279c4` → `FUN_1002754c(..., -1, …)`; SFX `FUN_1002b020(3, 7)`.
- `FUN_100279c4` only destroys non-permanent, occupied cells, and forwards the `0x1000` payload.

`FUN_10010d30` (dir 2) and `FUN_100110b4` (dir 3) are the sibling directional actions (same verb, other
directions). `FUN_1002b020(sound_id, channel)` is the SFX trigger.

---

## 7. Scoring & high scores — CONFIRMED

- **Player score = `player + 0x3c`** (`0x1003a9ec`, `int`), accessed as `player_index * 0x70 + 0x1003a9ec`.
- **Kill → score:** each enemy behaviour function, on kill, adds its own **point value (`enemy + 0x42`)**
  to the **killer's** score (`+0x3c`); the enemy carries the owner/killer **player index** (`enemy + 0x40`).
- **High-score table** at `0x10039882`, **`0x104` (260) bytes per entry** (name + score); `FUN_10022dfc`
  compares the player's score against the table entries (`entry < player_score`) for insertion.
- Bonus/other score adjustments go through `FUN_10015714` (writes `+0x3c` in several places).

---

## 8. Goodies / pickups — CONFIRMED (values)

Goodies are encoded as the **grid cell's low-byte type** (`grid[cell] & 0xFF`), collected when a player
walks onto the cell. Handler: **`FUN_1002bc64(player)`** (runs each frame; compares the player's current
cell to the previous to detect entry).

- **Coins / valuables → score (`+0x3c`), CONFIRMED values:** silver coin **+500**, gold coin **+1000**,
  gem **+2000**, gold bars **+5000** (`FUN_1002bc64` lines ~107–139). Per-type collected counters at
  `0x10038fe4..ea`.
- **Powerup effects:** dispatched via `FUN_1000f3f0(player, (type - 0x12) * 0x9C4)` and siblings — the
  shield/shoes/thunderballs/clock/etc. effects (exact type→effect map is HYPOTHESIS, being read).
- **Door/transporter category:** cell types `0x1A–0x22` are handled as a group (keys/doors/transporters).
- The **`0x1000` special-block payload** (upper 16 bits) supplies a goodie *revealed when a block is
  destroyed* (it becomes the cell's type), complementing the walk-over pickup.

---

## 9. Movement, death, lives & level flow

- **Movement = grid-step with a 7-frame animation** (CONFIRMED): a direction press sets the move-flag
  (`+0x25`) + direction (`+0x2e`); the sub-counter (`+0x2c`) runs 0→6 over 7 frames while `FUN_100147b8`
  interpolates screen x/y between cells; at **counter == 5** the directional **create/destroy** action
  fires. So Ted moves one cell per input, animated — not free pixel drift.
- **Directional block verbs (CONFIRMED twins):** `FUN_1002d04c` and `FUN_1002cf08` are the create/destroy
  toggle in **opposite horizontal directions**; `FUN_10010d30` / `FUN_100110b4` handle the other two
  directions (one is the **jump / break-block-above**, which checks the cell above the head and destroys
  it via the grid primitive; SFX `FUN_1002b020(1,7)`). Exact dir→function map is being finalized.
- **Player death (CONFIRMED):** on enemy contact, `FUN_10012228(player)` sets the **dead flag** (`+0x28`),
  plays death SFX `FUN_1002b020(0x21, 100)`, and switches to the death animation.
- **Lives / game over (HYPOTHESIS, corroborated):** lives at **`player + 0x46`**, eliminated flag at
  **`+0x48`** (set when lives < 1); **game over when both players are eliminated**.
- **Bonus timer:** a **round countdown `_DAT_1003b294`** decrements each frame (`FUN_1002a308`); the
  per-player starting value comes from `BORD 0x16` → `player + 0x42` (default 5000). The **clock goodie**
  adds time. Reaching 0 ends the player (decrement/zero-death site still being pinned).
- **Round-end / loop-exit:** the round loop exits when the flag at global `+0x5260` is set (→ `FUN_1002707c`).
  **Correction:** that flag is set by `FUN_1002146c`, which is a **file-load routine** (`FSpOpenDF`/`FSRead`)
  — so `+0x5260` is most likely a **QuickSave/restore-quit** flag (Cmd-S), **not** normal level completion.
  The true **level-complete/win condition** (all nasties cleared? bonus timer expired? all blocks placed?)
  is **not yet pinned from static analysis** and is a good candidate for oracle confirmation (play a board,
  observe what ends it). The board-advance path (loader `FUN_1002b448` with `board+1`) is still to be traced.

**Next (increasingly oracle-territory):** the exact input bit→action labels, the level-complete/win
condition, and per-enemy AI tuning constants — these are ambiguous from static reads alone and are best
confirmed by running the game under the emulator oracle with known inputs.

---

## 10. Goodie / powerup effect table (cell-type-id → effect)

From `FUN_1002bc64` + effect helpers (coin/gem values **CONFIRMED**; the rest **HYPOTHESIS** from an
Explore pass, spot-checked). Goodie id = grid cell low byte. Player extended fields (slot-relative):
score `+0x3c`, **bonus-time-add `+0x40`**, **lives `+0x46`**, **shield `+0x4a`**, **arrows `+0x4c`**.

| id (hex) | goodie | effect |
|---|---|---|
| `0x0A` | silver coin | **+500 score** (confirmed) |
| `0x17` | gold coin | **+1000 score** (confirmed) |
| `0x18` | gem | **+2000 score** (confirmed) |
| `0x19` | gold bars | **+5000 score** (confirmed) |
| `0x10` / `0x11` / `0x12` | magic ball / arrow / shield pickup | +1 to lives / arrows / shield counters |
| `0x13–0x16` | time bonuses | add to per-player bonus time (`+0x40`, cap 30000) via `FUN_1000f3f0` |
| `0x1A–0x23` | **transporters** (5 IN/OUT pairs) | teleport to the paired marker (`FUN_1002b9bc`) |
| `0x24–0x2D` | **Stop/Go switches** (pairs) | toggle a gate/enemy state (`FUN_10016544`) |
| `0x2E` | **clock** | round timer `_DAT_1003b294 = 600` |
| `0x2F` | **thunderballs** | clears all threat cells (`FUN_10016b28` loops the grid) |
| `0x30` | **shield (activate)** | timed shield (`FUN_10014c28`, ~600 ticks) |
| `0x31` | **shoes / turtles** | slows all non-boss enemies (`FUN_1000543c` loops the enemy array) |
| `0x32` | **1UP** | extra life + effect (`FUN_10014ccc`) |

## 11. Enemy AI behaviours (per-type)

Generic mover `FUN_1000c544`: `pos += vel` each frame, `cell = pos >> 5`. Baseline **walk-and-turn
patroller** (states 1=left / 2=right; reverse when the cell ahead is blocked) is **CONFIRMED** for the
simple enemies. Distinctive behaviours (Explore-derived; the *seek* class is **VERIFIED** via
`FUN_1000e5c8`, which compares the enemy cell to the cached player positions `_DAT_10037d50/54` and reacts
within 32 units):

| Enemy | Behaviour (HYPOTHESIS unless noted) |
|---|---|
| Ant / Ostrich / Hippo / Piggy / Smiley | horizontal walk-and-turn patrollers (CONFIRMED pattern); differ in speed + collision footprint + sprite table |
| **Hammer** | jumper — sets a jump field (`0x6e`) on hitting a wall, arcs up then lands |
| **Beanie** | splitter — spawns a child Beanie (same 750 value) on collision (`FUN_10006840` = child cleanup) |
| **Robo** | multi-state machine (left / right / idle / climb) with vertical movement |
| **Wheelie / Walker** | **player-seeking** (VERIFIED via `FUN_1000e5c8`/`FUN_1000e7c8` proximity checks) + can fire/spawn |
| Cannon / Spinner | static hazards (no points; separate handling — TBD) |

**Next (oracle-territory):** input bit→action labels, level-complete/win condition, and the precise
per-enemy tuning constants (velocities, exact collision offsets, state transitions).