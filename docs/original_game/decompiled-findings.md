# Decompilation findings — 2026-07-02 parallel Explore pass

Six Explore agents read the Ghidra decompilation (`analysis/decomp/all/`) in
parallel to resolve items previously (wrongly) deferred to the SheepShaver
oracle. **Almost everything was recoverable from the binary.** The oracle's real
job is now narrowed to: (a) *validating* these findings by observation, and
(b) the **win condition** (still ambiguous) — plus final sprite art if we don't
decode `sssf`.

Confidence tags: **CONFIRMED** = clear from code; **INFERRED** = supported but not
certain; **UNKNOWN** = not found.

> ## ⚠️ CORE MODEL CORRECTION (this is the spec of record)
> The game is a **RUN-AND-JUMP PLATFORMER**, not a 4-direction grid mover
> (confirmed by the "Configure Keys" screen + gameplay video in `refs/`). The C
> core's original movement/block/win model was **written from assumptions and is
> wrong**. The faithful model, derived from the decompilation:
>
> - **Input = 7 actions per player** (Configure Keys screen): **Run Left, Run
>   Right, Jump, Switch Block High, Switch Block Low, Weapon Arrow, Weapon Ball.**
>   NO up/down walk. (P1 keypad / P2 letters+modifiers; remappable via `keys 128`.)
> - **Run** (`FUN_1001166c`): grid-based, **7 anim frames per cell**, screen x/y
>   interpolated (`FUN_100147b8`); block verb fires at counter==5.
> - **Jump** (`FUN_100110b4` init, `FUN_10011fcc` physics): parabolic arc with
>   gravity; breaks the block directly above; horizontal drift during the arc;
>   Y clamped to **[48, 446] px**; head-bonk re-targets (no damage).
> - **Gravity / fall** (`FUN_10012348` support test): the player **falls** unless
>   the cell below the feet (`y+0x1f`) has **bit `0x200` (SUPPORTIVE)** set —
>   permanent walls `0x300` include it. Fall/jump share the same physics. **Fall
>   past y=446 = death** (`FUN_10011fcc` → death seq).
> - **NEW CELL BIT: `0x200` = SUPPORTIVE** (standable). Prior encoding only had
>   `0x100` permanent / `0x1000` payload — the support bit was missing, which is
>   exactly why a platformer can't work without it. (Walls `0x300 = 0x200|0x100`.)
> - **Win = KEY → DOOR → EXIT** (player-confirmed + video): door cells carry the
>   **`0x800`** flag (`FUN_1002bc64` door branch, ~L51-57); entering an *unlocked*
>   door drives `FUN_10017a70` → completion flag `DAT_1003ad0e` →
>   `FUN_10016c90` "Board Completed" (PICT 300, Bonus/Weapons-Reward/Score tally)
>   → load `board+1` (`FUN_10029acc`→`FUN_1002b448`). **Still fuzzy:** the exact
>   key cell id and the key→door-unlock link (`DAT_100393d0` setter not found) —
>   the ONE genuine remaining oracle/validation item.
> - **Switch Block High vs Low** (`FUN_1002d04c`/`cf08` horizontal twins,
>   `FUN_1002d190` down, `FUN_10010d30` up): High = the cell above the head, Low =
>   the cell at the feet/below; create-if-empty / destroy-if-occupied toggle;
>   dropping/creating a block on an enemy squashes it. **Exact High/Low→function
>   mapping still needs a clean read** (decompile is noisy here).
>
> Rewrite order: cell `0x200` support + BORD loader → movement (run/jump/fall) →
> input action set → block High/Low → key/door win. Validate each against the
> `refs/videos/frames/*.png` reference.

---

## 0. Movement model — FROM ASSEMBLY (2026-07-03, authoritative)

Decoded from `analysis/decomp/asm/*.asm` (the C was corrupted here). Player
struct base `0x1003a9b0`, stride `0x70`. All CONFIRMED-from-asm unless noted.

**Coordinate system (`FUN_1002e6cc` / `FUN_1002e6f8`, 1-based):**
- `col = (x < 16) ? 0 : ((x-16) >> 5) + 1`   (32px cells, origin x=16 → col 1)
- `row = (y < 48) ? 0 : ((y-48) >> 5) + 1`   (origin y=48 → row 1)
- Playfield array `DAT_1003ad68`, cell u32 at byte offset **`row*0x3c + col*4`**
  (stride `0x3c`=60=15 u32/row; 13 cols padded to 15, 19 rows). *(col/row order
  vs the two converters — verify sign of the two index terms when porting.)*

**Cell bits:** `0x100` permanent · **`0x200` SUPPORTIVE (standable)** · `0x800`
door · `0x1000` payload · walls `0x300` = `0x200|0x100`. Low byte = block type.

**Support / stand (`FUN_10012348`):** tests **two cells under the feet** —
`(col from x+0x10, row from y+0x1f)` and `(col from x+0x0e, row from y+0x1f)`;
`supported = (cellA & 0x200) || (cellB & 0x200)`. No support ⇒ fall.

**Jump / fall physics (`FUN_10011fcc`, EXACT):** each air frame while in-air flag
`+0x28 != 0`:
```
t = ++field[+0x32]
Y = (field[+0x34]*10  -  30*t  +  floor(t*t / 2)) / 10   // +0x34 = launch-Y, constant
if Y < 0x30 (48):  Y = 48
if Y >= 0x1be (446): DEATH (+0x3a=1; FUN_10028958/FUN_10004cb0/FUN_100289c0)
else field[+0x04] = Y
```
Parabola: apex at t≈30 → ~45px (~1.4 cells) above launch, symmetric.

**Jump init (`FUN_100110b4`):** breaks the block directly above; sets horizontal
target `+0x4e` (facing right `+0x14`, left `-0xe`); copies launch-Y from `+0x34`
to `+0x52`; SFX `FUN_1002b020(1,7)`.

**Block verbs — all three are the SAME toggle, differ only by target cell
(`FUN_1002d04c/cf08/d190`):** if cell permanent (`0x100`) → no-op; if occupied →
**destroy** (SFX `0x03`, `FUN_100279c4`, reveal `0x1000` payload); if empty →
**create** (SFX `0x04`) + **squash any enemy** there (`FUN_1002754c`, awards pts).
Target cell:
- `FUN_1002d04c`: `col=x+0x30` (right), `row=y+0x10` → **above head** = "Switch Block HIGH" (facing right)
- `FUN_1002cf08`: `col=x-0x12` (left), `row=y+0x10` → **above head** = HIGH (facing left)
- `FUN_1002d190`: `row=y+0x1f` → **below feet** = "Switch Block LOW" (col = x+0x30 or x-0x12 by facing)

**Ground state machine (`FUN_1001166c`):** if in-air (`+0x28`) → `FUN_10011fcc`;
else if a move is animating (`+0x25`/`+0x26` moved-flag) advance a **7-frame**
counter (`+0x2c`, 0→6) and fire the action verb at **counter==5**; else read the
input latch and start an action. `+0x30` (e0) encodes direction+facing
(1=left,3=right,2/4=down-left/right). Move = **one cell per press over 7 frames**.

**RESIDUAL GAPS (asm obscure — mark in code, validate vs video/oracle):**
1. **Landing:** no store to `+0x28` (in-air clear) was found — the exact
   land-and-snap point is unresolved. Implement behaviorally (descending +
   support-cell `0x200` ⇒ land, snap Y to block top, clear in-air).
2. **Run interpolation:** `FUN_100147b8` uses fields `+0x5c/+0x5e/+0x62/+0x64/+0x6e`
   with a modulo formula; it does **not** write `+0x00/+0x04` directly — the exact
   per-frame pixel cadence is unresolved (approximate as linear 32px/7frames).
3. **Input latch → the 7 named actions:** dispatch checks `+0x21/+0x22/+0x24/+0x23`;
   reconciling these to Run L/R vs Block High/Low vs Jump vs Arrow/Ball still has
   one ambiguity (does `+0x21` = run or block-high?). Confirm against video.

### 0b. Round-2 assembly findings (2026-07-03) — resolves most of the above

- **Ground state machine is ~11 states** (`+0x1c` selector, dispatched in
  `FUN_1001166c`): 0 idle-ground (`FUN_100128f8`), 1 run (`FUN_10012bf4`),
  2 jump-ascent (`FUN_10013404`), 3 landing/falling (`FUN_1001386c`),
  4 falling (`FUN_10014524`), 5 post-run (`FUN_10013980`), **9 climb-ladder-up
  (`FUN_10013ddc`)**, **10 climb-ladder-down (`FUN_10013f68`)**, 0xb anim
  (`FUN_10013c18`), 0xc/0xd death (`FUN_100140f4`/`FUN_1001431c`). **LADDERS exist**
  — the player climbs (states 9/10 set facing `+0x34` = ±1, run a ~90-frame climb).
- **Fall start:** state 0 (idle) calls support `FUN_10012348` each frame; if
  unsupported → set state `+0x1c = 3` (fall). Separately `FUN_10012228` sets the
  parabola in-air flag `+0x28 = 1` (SFX 0x21) for launched jumps.
- **Landing + Y snap:** state 3 (`FUN_1001386c`) calls support each frame; when a
  cell has `0x200`, it calls `FUN_100137f8` → **Y = (row-1)*32 + 49** (block top +1)
  and sets state `+0x1c = 0`.
- **Grid index — CONFIRMED:** cell u32 at `DAT_1003ad68[col*0x3c + row*4]`
  (col stride `0x3c`=60, row stride 4; from `FUN_1002d04c` asm `mulli r3,col,0x3c;
  rlwinm r4,row,2; add`). *(Verify dims when porting.)*
- **Block create SETS the support bit:** the create path (via `FUN_1002754c`) writes
  `0x200` (supportive) — or `0x300` (permanent+supportive) — into the new cell, and
  **squashes any enemy there** (awards `enemy+0x42` points to `player+0x3c`). Destroy
  (`FUN_100279c4`): skips permanent, clears the cell or reveals the `0x1000` payload
  (payload in the upper 16 bits) as the new cell.
- **Level-load → support pipeline — CONFIRMED (2026-07-03), CORRECTED (2026-07-03):**
  The extracted BORD files **already carry the flag bits** in each tile's `u32`
  (verified with `tools/dump_board_grid.py`): `0x2xx` = supportive/destructible block,
  `0x3xx` = permanent+supportive, `0x8xx`/`0x9xx` = goodies/coins (bit `0x800`, **not**
  supportive), `0x197` = background/air. **Low byte = sprite/block type.** Stages:
  1. `FUN_1001a348` parses the BORD body and stores each tile `u32` **verbatim** into a
     temp grid (base `+0x7134`, stride `0x34`).
  2. `FUN_1002b708` copies the temp grid **verbatim** into the live physics grid
     (base `+0x6bf8`, stride `0x3c`), then sets the **border ring to `0x300`**.
  3. `FUN_1002754c` (set-cell/draw) `ori`s `0x200`/`0x300` **only when the *player*
     stamps/creates a block** — loaded tiles keep their authored flags.
  ⇒ **The port loader stores the BORD `u32` as-is** (earlier belief that it must OR
  `0x200` onto every tile was WRONG — that turned coins and background into floors).
  Coin/door disambiguation: door = bit `0x800` with low type `≤ 3`; coins/goodies =
  `0x800` with higher low bytes (silver `0x0A`, gold `0x17`, gold-bars `0x19`).
  **Rendering: block/goody sprite frame = `tile_low_byte + 1`** (see
  [graphics-and-audio.md](graphics-and-audio.md) §1a-SHEETS).
- **Grid orientation — CONFIRMED LANDSCAPE 19 wide × 13 tall.** The `0x3c`-stride
  live-grid dimension (`col`, from X) spans **19**; Y (`row`) spans **13**
  (`FUN_1002b708`/`FUN_10012348`). BORD record coords are **(col, row)**: first byte =
  column 0-18, second = row 0-12. Playfield 608×416 px fits the 640×480 screen under a
  48-px HUD. (The port was initially transposed to 13×19; fixed 2026-07-03.)
- **WIN = door entry (`FUN_1002bc64`):** door cells have bit **`0x800`** and low type
  **0-3**; entering one matching the player (`type == player_id+1 || type == 1`) sets
  `player+0x129 = 1` + SFX `0x27`, which drives completion (`DAT_1003ad0e` via
  `FUN_10017a70` → `FUN_10016c90` "Board Completed" PICT 300 → board+1). The **KEY is
  cell type `0x0B`** (INFERRED: the only goodie with no effect but a pickup SFX 0x16 —
  collecting it presumably flips the door-unlock flag). The exact `DAT_100393d0`
  gate-setter and key→unlock link are **not directly in C or asm** (indirect) — but
  your ground truth ("get key, open door, exit door") + the door-entry code are enough
  to implement faithfully: `has_key = collect 0x0B`; door entry with `has_key` ⇒ complete.
- **Input latch (residual):** `+0x21`→run/block-high (context: the verb toggles the
  cell above the head if a block is there, else it's the run step), `+0x22`→block-low,
  `+0x24`→jump, `+0x23`→weapon (Arrow if `+0x34==1` else Ball). Run direction lives in
  `+0x1e/+0x1f/+0x20` (exact byte per direction still to confirm vs `keys 128`/video).
- **Run X interpolation (residual):** still not pinned to a direct `+0x00` write —
  `FUN_100147b8` computes an interp phase in `+0x5e`. Approximate as linear 32px over
  the 7 frames; validate cadence against `refs/videos`.


---

## 1. Controls / input  (CONFIRMED architecture)

- Input handler **`FUN_1002d440`** reads the keyboard (GetKeys → 16-byte KeyMap),
  tested one key at a time by **`FUN_1002d388`**. It writes a **7-byte input
  latch per player** at `player+0x1e .. +0x24`.
- Default bindings live in a **`keys 128` resource** (remappable) → so the exact
  default keys should be read from that resource, not hard-coded. **TODO: extract
  `keys 128`.**
- Movement/action dispatch is **`FUN_1001166c`** (the player state machine): at
  animation counter==5 it calls the directional verbs
  `FUN_1002d04c`/`FUN_1002cf08` (create/destroy horizontal),
  `FUN_1002d190` (down), `FUN_10010d30`/`FUN_100110b4` (up / jump-break-above).
- Bit/latch order is CONFIRMED via the demo recorder **`FUN_1002a15c`** (packs
  the latch into a `DMKY` bitmask) and its unpacker `FUN_10029ca0`.
- **Two players**: P1 on desktop keys, P2 on the numeric keypad (separate latch,
  same 7-slot layout).

**Net:** input is a remappable 7-action latch per player; our provisional
`SOI_IN_*` bit labels should be reconciled to the latch slot order, and the real
default keys read from `keys 128`.

---

## 2. Power-up / goodie effects  (mostly CONFIRMED — corrects our code)

Handler **`FUN_1002bc64(player)`**; effects dispatched to per-type helpers.

| id (hex) | goodie | effect | status |
|---|---|---|---|
| `0x0A/0x17/0x18/0x19` | silver/gold coin, gem, gold bars | +500 / +1000 / +2000 / +5000 score | CONFIRMED |
| `0x10` | magic ball | +1 to `player+0x46` (lives-ish counter) — `FUN_1000e9c8` | CONFIRMED (name unsure) |
| `0x11` | arrow | +1 arrows (`player+0x4c`) — `FUN_1000eb34` | CONFIRMED |
| `0x12` | shield pickup | +1 shield (`player+0x4a`) — `FUN_1000ec50` | CONFIRMED |
| **`0x13–0x16`** | **time bonuses ×1–×4** | **+2500 / +5000 / +7500 / +10000** bonus time, **cap 30000** — `FUN_1000f3f0` | **CONFIRMED (was TODO)** |
| `0x1A–0x23` | transporters (5 IN/OUT pairs) | teleport to paired OUT; **IN = even, OUT = odd** — `FUN_1002b9bc` | CONFIRMED (matches our impl) |
| `0x24–0x2D` | stop/go switches (5 pairs) | toggle paired gate type — `FUN_10016544` | CONFIRMED (exact gameplay effect INFERRED) |
| `0x2E` | clock | round timer `+= 600` | CONFIRMED |
| `0x2F` | thunderballs | **kill ALL enemies** (grid loop `FUN_10016b28`) | CONFIRMED |
| `0x30` | shield activate | timed invuln ~600 frames — `FUN_10014c28` | CONFIRMED |
| `0x31` | shoes/turtles | slow enemies (loops enemy array `FUN_1000543c`) | INFERRED |
| `0x32` | 1UP | extra life + init — `FUN_10014ccc` | CONFIRMED |
| 2× multiplier / magnifying glass | — | **not found in this build** | UNKNOWN |

---

## 3. Enemy AI — per type  (CONFIRMED behaviors; dispatcher `FUN_1000503c`)

Each type has a dedicated per-frame update function; spawn dispatch is
`FUN_1000b7dc` (switch on thrown type). Enemy struct fields: type `+0x4a`, state
`+0x4c` (1=left, 2=right, 5/6=turn, 8/9=diag, 0x41=Hammer-jump), anim `+0x56`,
cell x/y `+0x58/+0x5a`, point value `+0x8a`, killer-player `+0x88`.

| type | pts | update fn | behavior |
|---|---|---|---|
| Ant | 50 | `FUN_1000602c` | walk-and-turn |
| Ostrich | 100 | `FUN_100093a0` | walk-and-turn (tall) |
| Hippo | 200 | `FUN_100081f8` | walk-and-turn + destroys blocks in path (`FUN_100279c4`) |
| Piggy | 250 | `FUN_10009a78` | walk-and-turn + block destroy |
| **Wheelie** | 300 | `FUN_10009e98` | **SEEK** — updated 2×/frame, 8-dir, moves toward nearest player |
| Smiley | 400 | `FUN_1000d130` | walk-and-turn + aggressive block destroy |
| **Hammer** | 500 | `FUN_10007998` | walk-and-turn + **JUMP** on obstacle (state 0x41, row −11) |
| **Beanie** | 750 | `FUN_10006378` (child `FUN_10006840`) | walk-and-turn + **SPLIT** (spawns child on collision) |
| **Robo** | 1000 | `FUN_1000a780` | **multi-state CLIMBER** + seek (state field `+0x6e`) |
| **Walker** | 1250 | `FUN_1000dd4c` | **SEEK + SHOOT** projectile (2-frame cycle; seek `FUN_1000e5c8/e7c8`) |
| Teeth | 1500 | `FUN_1000d8c4` | walk-and-turn (large) |

Seek helpers `FUN_1000e5c8` (right) / `FUN_1000e7c8` (left) compare enemy vs
nearest-player cell. Our current core does seek only for Wheelie/Walker (correct
set) but as first-draft; Hammer-jump, Beanie-split, Robo-climb are still to
implement.

---

## 4. Sound → event mapping  (CONFIRMED architecture; ids need a table dump)

- Play fn **`FUN_1002b020(index, channel)`**: `index` 0–0x37 into a **56-entry
  handle cache** `DAT_1003abec`; `channel` 7=normal / 10=soft / 100=loud.
- The cache is filled at boot (`FUN_1002af74`) from **two u16 resource-id tables**:
  **primary at `0x10037074` (53×u16)** + **secondary at `0x10034a00` (2×u16)**.
  Extract those 55 big-endian u16 `snd ` ids and cross-ref
  `extracted/audio/snd_inventory.json` to get event→sound name. **TODO: dump the
  tables from the PEF (via `tools/pef_patch.py` address→offset).**
- Event → index (CONFIRMED call sites): jump `0x01`, block destroy `0x03`, block
  create `0x04`, per-enemy `0x05–0x0F`, coin `0x15`, magic ball `0x18`, arrow
  `0x19`, shield `0x1A`, gold `0x1C`, gem `0x1D`, gold bars `0x1E`, teleport
  `0x25`, thunderballs `0x26`, clock `0x2B`, player death `0x21`, level-complete
  `0x2E`, bonus tally `0x2F`, high score `0x36`, fanfare `0x37`.

---

## 5. Win / board-advance condition  (STILL AMBIGUOUS — the real oracle item)

- Board loader `FUN_1002b448`; advance = load `board+1` via `FUN_10029acc`
  (outer loop `FUN_1001f4f8`). Round loop `FUN_1002a308` acts on a
  **level-complete flag `DAT_1003ad0e`**.
- The flag is set in **`FUN_10017a70`**, which builds a per-row enemy-occupancy
  map and sets complete when specific **goal-row indices** (`sRam10034a8c`,
  `sRam10034a8a`) are non-zero — **the logic reads inverted and the trigger
  (`DAT_100393d0`) setter was not found**.
- **Explicitly REJECTED:** "collect all treasure", "clear all enemies", "timer
  expiry", "reach a tile" — none matched the real check. **⇒ our current
  `soi_level_complete` (all-treasure) is very likely WRONG** and is only a
  placeholder.
- Game-over CONFIRMED: both players eliminated (lives<1) or bonus timer to 0
  (that path is death). Board set = BORD ids 401–500 + 1001–1050.

**This is the one genuine oracle task left:** play a board to completion and watch
what sets `DAT_1003ad0e` (door? key? region cleared?).

---

## 6. `sssf` sprite codec  (testable model — run the experiment)

Chain: `FUN_10000004` (load, frame count @0, offset table @`0x0C`) →
`FUN_10000358` (per-frame setup) → `FUN_100004d8` (row loop; **decompile
unreliable — lost registers**) → `FUN_10000884` (4px/u32 + mask) →
`FUN_10000944` (pixel producer).

Agent hypothesis (needs empirical check): per-frame header **`w:u16@0, h:u16@2,
skip:u32@4, data_offset:u32@8`**; encoded data at `frame_base+data_offset`; the
control (run-length) and literal (palette-index) bytes are **interleaved in one
stream**, alternating opaque-literal runs and transparent runs, literal `0`
forced to `1`, `skip` = per-row left margin (reset each row), phase starts opaque.

**Next action:** implement this in `tools/decode_assets.py`, decode a `weapons`
frame, render against the `clut`, and check (a) pixel count == w×h and (b) the
image is recognizable. That empirically confirms or refutes the single-stream
model. (Note: `FUN_10000944` uses *two* pointers `ctrl_ptr`/`data_ptr`, which
argues for two regions, not one interleaved stream — the experiment decides it.)
