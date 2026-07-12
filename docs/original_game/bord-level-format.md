# `BORD` Level Format (Original) — Reverse Engineering

Status: **header + tile grid CONFIRMED** from the decompiled loader (2026-07-02). The badguy/spawn
records and a few field scales are still **TODO**.

Parser / extractor: [`tools/parse_bord.py`](../../tools/parse_bord.py). Loader: `FUN_1002b448`
(selects the resource) → `FUN_1001a348` (parses header + tile grid); grid→pixel helpers
`FUN_1002e6ac`/`FUN_1002e6bc`; playfield border setup `FUN_1002b708`.

---

## 1. Where levels live

Levels are `BORD` resources inside `SOI Boards` (resource fork of the AppleDouble `._SOI Boards`).
There are **152** of them:

- **301** — a `demo`-named board in the level set. *(NOT the oracle trace: the attract-mode demo is the app's own `BORD 300` + `DEMO 128` + `DMKY 1000` — see [binary-and-resources.md](binary-and-resources.md) §6 and plan §6.2.)*
- **401–501** — 101 resources: the 100 tiered game levels (401–500, five difficulty tiers of 20) plus 501.
- **1001–1050** — a second set of levels.

Running `py tools/parse_bord.py` extracts each to `extracted/levels/board_<id>.bord` and prints an
analysis of the `demo` board and the smallest board.

---

## 2. How it was reversed

1. **Get the bytes.** Parse the AppleDouble sidecar to pull the resource fork (entry id `2`), then walk
   the standard Mac resource map to list types and extract every `BORD` resource. (Both steps are in
   `parse_bord.py`.)
2. **Diff two boards.** Hex-dump the `demo` board (id 301, 400 B) and the smallest board
   (`SS Board`, id 410, 96 B). The shared prefix reveals a fixed header; the differences reveal the
   per-board fields.
3. **Sample many boards.** Read the first 16 bytes of a dozen boards to see which fields are constant
   (→ magic) and which vary in a meaningful pattern (→ real data). The "bonus" field jumped out because
   its values are round decimals (3000/6000/8000/30000).
4. **Find the record framing.** Splitting the body on the recurring pair `64 64` produced clean,
   self-consistent records — `64 64` is `(100, 100)`, an impossible grid coordinate, i.e. a sentinel.

---

## 3. Header (26 bytes, big-endian u16) — CONFIRMED from the loader `FUN_1001a348`

`FUN_1001a348` copies the first 26 bytes 1:1 into the level struct, then parses the tile body. Field
roles are read directly from the loader; the `0x10`/`0x12`/`0x14` roles are additionally confirmed by
board 450 (`50` / `19` / `25` — all within the loader's clamps).

| Offset | Field | Confidence | Notes |
|---|---|---|---|
| `0x00` | u16 flags / board-type | HYPOTHESIS | Unused by the loader. |
| `0x02` | P1 attribute | CONFIRMED | Constant `0x006D` across boards. |
| `0x04` | P2 attribute | CONFIRMED | Constant `0x0073` across boards. |
| `0x06` | **P1 start col** | CONFIRMED | → x `= (col-1)*32 + 16`. |
| `0x08` | **P1 start row** | CONFIRMED | → y `= (row-1)*32 + 48`. |
| `0x0A` | **P2 start col** | CONFIRMED | |
| `0x0C` | **P2 start row** | CONFIRMED | |
| `0x0E` | **Bonus / time** | CONFIRMED | Per-player starting Bonus, copied to both players (asm `FUN_1002b448` → `+0x1003a9f0`). Loader default `5000` if `<= 0`. VERIFIED vs the original video + refs/images (board_1 `0x0E`=3000 → HUD "02968"; board_2=6000 → "05995"). **Corrects the earlier swap that put bonus at `0x16`.** |
| `0x10` | **percent_ultrabuster** | CONFIRMED | Clamped 0–100 (out-of-range → 0). |
| `0x12` | **thrown_badguy type** | CONFIRMED | Clamped 0–20 (a nasty index); linked to `0x14`. |
| `0x14` | **percent_badguy** | CONFIRMED | Clamped 0–100; coupled with `0x12` (both forced to zero together). |
| `0x16` | **No-Weapons Reward** | CONFIRMED | Added to score at completion UNLESS the player fires a weapon (asm `FUN_1002b448` init / `FUN_10015714` award). Default `5000` if `< 1` or the **`0x3A20`** sentinel (scan: 57 boards store `0x3A20`, 95 store `0`, none custom → every board = 5000). VERIFIED vs the original video tally ("No Weapons Reward 5000"). |

Body starts at `0x18`.

---

## 4. Body: sentinel-delimited records

After the header, the body is a sequence of **variable-length records**, each terminated by the
sentinel `64 64` (decimal `100,100` — out of grid range; real grid coordinates observed are `≤ ~0x14`).

Two record shapes are apparent:

### 4a. Block / tile placement — CONFIRMED (loader `FUN_1001a348`)
```
<cell:u32>  <(col,row) u8 pairs …>   64 64
```
The body is a sequence of these records, **terminated when `cell == 0`**. For each `(col,row)` pair
(**first byte = column 0-18, second = row 0-12**) the loader stores the `cell` `u32` **verbatim** into
the grid; the `64 64` = `(100,100)` pair ends the current record.
**Grid = 19 × 13** (landscape; loop bounds `0x13 × 0xd`), **cell = 32 × 32 px**. At load, `FUN_1002b708`
copies the grid into a bordered live playfield and sets the border ring to **`0x300` = permanent wall**.

**Cell `u32` encoding — CONFIRMED (`tools/dump_board_grid.py`):** the flag bits are **already in the
BORD data** (not synthesized at load). High bits: `0x100` permanent · `0x200` SUPPORTIVE (standable) ·
`0x800` goodie/door · `0x1000` payload. `0x2xx` = destructible block, `0x3xx` = permanent block,
`0x8xx/0x9xx` = coin/goody/door, `0x197` = background/air. **Low byte = sprite/block type**, and the
rendered sprite frame = `low_byte + 1` into `block_sprites`/`goody_sprites` (see
[graphics-and-audio.md](graphics-and-audio.md) §1a-SHEETS). Door = `0x800` with low type `≤ 3`.

**Hidden-payload cells (`0x1000`) — CONFIRMED used (`tools/scan_payload.ps1`, 2026-07-03):** **326**
cells across the real boards set bit `0x1000` and stash a **full goody `u32` in the high 16 bits**
(`goody = cell >> 16`, itself a `0x09xx`-class goodie/coin value). Two flavours:
- **Supportive payload block** (`cell & 0xFF00 == 0x1200`, 105 cells, e.g. `0x09121291` = block type
  `0x91` hiding shield `0x0912`): a normal destructible block that, when **smashed**, becomes the
  concealed goody (`FUN_100279c4` / block-toggle emits `cell >> 16`); the revealed goody is then a
  walk-over pickup. **PORTED + tested** — `block_toggle`/arrow already reveal `SOI_CELL_PAYLOAD`.
- **Type-0 payload cell** (`cell & 0xFF00 == 0x1000`, 218 cells, e.g. `0x090A1000` = hidden silver coin
  `0x090A`): low byte `0`, so the walk-over pickup **skips it** (`FUN_1002bc64` gates on `low != 0`) and
  the static renderer skips it too (`FUN_1002cc10` gates on `low != 0`) — a genuinely **hidden** goody,
  revealed only by a special trigger (colored-key sweep / type-`0xFF` reveal in `FUN_1002bc64`). Our
  port loads it verbatim and correctly leaves it inert on walk-over; the colored-key reveal is **TODO**.

**Key / lock / door — the real win system (CONFIRMED `tools/scan_keydoor.ps1` + asm `FUN_1002bc64`, 2026-07-03):**
Real boards ship **no plain `0x0B` key and no pre-open `0x80x` door**. Each board pairs a **colored key**
(`0x0907` low 7 = universal · `0x0908` low 8 = P1 · `0x0909` low 9 = P2; flag `0x09` = `0x800|0x100`)
with matching **lock** cells (`0x0904`/`0x0905`/`0x0906`, low = key − 3). Collecting key `K` sweeps the
grid and rewrites every cell with `(low + 3 == K) && 0x800` to `low + 0x8fd` → an **opened door**
`0x901`/`0x902`/`0x903` (low 1/2/3 + `0x800`). Stepping on an opened door sets the player's
level-complete flag (`+0x1003a9d9`, `FUN_10018a18`). `0x0B` is **not** a key — it is a sound-only goody.
**PORTED + tested** (`soi_pickup_check` colored-key sweep → the low-≤3 `0x800` door branch completes;
the synthetic `0x0B`/`0x801` path is retained only for the showcase/tests).

### 4b. Badguy (enemy) spawn-block record — CONFIRMED (2026-07-03)
Spawn blocks are **inline** in the same record stream (same `[u32][ (col,row) pairs ][64 64]` framing);
`FUN_1001a348` stores them into the grid verbatim like any cell. A cell is a **spawn block** iff
**bit `0x400` is set** — the scanner **`FUN_1002d980`** (run once at level load) walks the grid, and for
every `0x400` cell it spawns **one** enemy and then **clears the cell**. The `u32` is:

| byte | field | notes |
|---|---|---|
| b0 (bits 24-31) | **Start Delay** | Board Designer term; actually a MOVE/ANIM SPEED param (used `*6`/`<<3` in the behaviour fns), **not** a spawn timer |
| b1 (bits 16-23) | **Spawn Delay** | Board Designer term; also a SPEED param, not a respawn cadence |
| b2 (bits 8-15) | **dir tag** `0x05/0x06/0x07` | the `0x04` = the `0x400` marker; low 2 bits set cell bits `0x100`/`0x200` → **1 = left, 2 = right, 3 = alternate** (`0x2000` = seek). The block scan is **one-shot** (cell cleared after it places the entity), but a placed **spawner** entity (‡ types) then **emits children forever** — see the spawner note below. |
| b3 (bits 0-7) | **badguy type** `1-19` | see below |

Example (board_401 = **level 1**): `14 0a 05 0f` then `(9,1)` → dir 1 (left), **type 15 = Robo** at
col 9 row 1 (it starts moving left toward the centre player, then falls off the ledge).

**Type → enemy** (placed per-frame dispatcher `FUN_1000503c`, switch on the low byte). Several indices
are **stationary spawners** that emit a base nasty (child struct type = `index + 0x64`):

| type | enemy | type | enemy | type | enemy | type | enemy |
|---|---|---|---|---|---|---|---|
| 1 | Cannon* | 6 | Hammer‡ | 11 | Smiley‡ | 16 | Gargoyle* |
| 2 | Wheelie | 7 | Beanie | 12 | Ant‡ | 17 | Knight* |
| 3 | Wheelie | 8 | Beanie(child) | 13 | Cannon* | 18 | Ostrich‡ |
| 4 | Walker | 9 | Spinner | 14 | Hammer | 19 | Piggy‡ |
| 5 | Hippo‡ | 10 | Teeth‡ | 15 | **Robo** | | |

CONFIRMED: 2, 4, 7, 8, 15 (behaviour fns). ‡ = spawner→emitted-nasty (HIGH). \* = shooter (Cannon fires
`0x65`/`0x71`; Gargoyle/Knight fire at anim frame `0xf`) — MEDIUM. *(This is a SEPARATE index space from
the Gargoyle-thrown badguy: header `0x12`, dispatched by `FUN_1000b7dc` as `selector-5`, struct type =
`selector+0x64`.)* Port: `soi_bord_badguy_type()` + the `tile & 0x400` branch in `soi_load_level`.

**Spawner behaviour — CONFIRMED + PORTED (2026-07-04):** each ‡ type is a **stationary** entity that
emits a child (`type = placement + 0x64`) **every `StartDelay(b0)×6` frames** (`FUN_100076a8` &c,
structurally identical to the Cannon `FUN_100071a0`); the child spawns at the spawner's cell, takes the
spawner's facing, and is **transient** (asm lifespan `+0x74 = b0<<3`). Ported via `soi_bord_is_spawner()`
+ `SoiEnemy.spawn_child`/`life` + `enemy_spawner_emit()`; children are lifespanned so the field can't
fill up. Rendered as a stationary instance of the base nasty (the distinct spawner sprite is a TODO).

### 4c. Trailer — HYPOTHESIS
Boards end with `00 00 00 00 <u16?>` (e.g. `... 00 00 00 00 43 FF` / `... 00 00 00 00 00 03`) — an
end marker with a trailing value of unknown purpose (count? checksum?).

---

## 5. The `DATA:` sub-block — HYPOTHESIS

Exactly **4** of the 152 boards (including `demo`) contain the ASCII marker `DATA: ` at offset 18,
where ordinary boards instead have their bonus value and zero padding.

Note: the **recorded demo input** is separately confirmed to live in **`DMKY` ("demo keys")** resources
(see [binary-and-resources.md](binary-and-resources.md) §6), not inside the board itself — so this
`DATA:` block is more likely board-authoring metadata (e.g. a Board Designer tag) than the input
stream. Both the `DATA:` block and the `DMKY` format are still TODO.

---

## 6. Open questions (TODO)

- **Badguy/spawn records** — find the separate parser (not `FUN_1001a348`); pin enemy **type** (0–12),
  **start/spawn delays**, and **direction** (left-up / right-down / alternate / seek) encoding.
- **Block-property mapping** — which `tile_type` values are Supportive / Permanent / both / neither
  (`0x300` = permanent wall is known).
- ~~**Bonus scale**~~ **RESOLVED (2026-07-08):** the per-board Bonus is at `0x0E` (not `0x16`); `0x16`
  is the **No-Weapons Reward**. Both verified vs the original gameplay video (HUD Bonus + tally reward)
  and the decompiled `FUN_1002b448`/`FUN_10015714`.
- **Col/row orientation** — player-start values can exceed the 13-col grid width, so confirm the exact
  coordinate range/orientation against the emulator.
- The `0x00` flags word and the trailer's trailing value. (The `DATA:` bytes in boards 301/428/446/498
  land in `0x10`-`0x15` = the challenge params; the loader clamps them to 0 — asm `FUN_1002b448`.)

**Resolution plan:** locate the spawn-record reader, then decode a board into the canonical level JSON
(`plan/MASTER_PLAN.md` §7.3) and compare against the same board in the emulator.
