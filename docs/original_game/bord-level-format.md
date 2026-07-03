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
| `0x0E` | shared player attr | CONFIRMED | Copied to both players; varies per board. **Supersedes the earlier "0x0E = bonus" guess** (that was wrong). |
| `0x10` | **percent_ultrabuster** | CONFIRMED | Clamped 0–100. |
| `0x12` | **thrown_badguy type** | CONFIRMED | Clamped 0–20 (a nasty index). |
| `0x14` | **percent_badguy** | CONFIRMED | Clamped 0–100; coupled with `0x12` (both forced to zero together). |
| `0x16` | **bonus / time** | CONFIRMED | Loader default `5000` if `0` or **`0x3A20`** (a "use default" sentinel — many boards, e.g. 401, store `0x3A20` here; CONFIRMED by `tools/extract_assets.py`). |

Body starts at `0x18`.

---

## 4. Body: sentinel-delimited records

After the header, the body is a sequence of **variable-length records**, each terminated by the
sentinel `64 64` (decimal `100,100` — out of grid range; real grid coordinates observed are `≤ ~0x14`).

Two record shapes are apparent:

### 4a. Block / tile placement — CONFIRMED (loader `FUN_1001a348`)
```
<tile_type:u32>  <(x,y) u8 pairs …>   64 64
```
The body is a sequence of these records, **terminated when `tile_type == 0`**. For each `(x,y)` pair the
loader stores `tile_type` into the grid cell; the `64 64` = `(100,100)` pair ends the current record.
**Grid = 19 × 13** (loop bounds `0x13 × 0xd`), **cell = 32 × 32 px**. At load, `FUN_1002b708` copies the
grid into a bordered live playfield and sets the border ring to tile-type **`0x300` = permanent wall**.
The `tile_type` → block-property (supportive / permanent / …) mapping beyond `0x300` is still TODO.

### 4b. Badguy (enemy) record — TODO (separate parser)
`FUN_1001a348` parses **only** the header + tile grid (it stops at `tile_type == 0`). The badguy/spawn
records (empirically led by bytes like `46 0a`, `28 0a`, `28 14`, `50 50`, followed by `(x,y)` pairs)
are parsed by a **different, not-yet-located function** — likely read at spawn time. Finding that
reader is the next BORD task; it will pin the enemy **type** (0–12), **start/spawn delays**, and
**direction** (left-up / right-down / alternate / seek) encoding.

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
- **Bonus scale** — the loader reads `0x16` as bonus (default 5000); confirm the raw→displayed scale
  against the emulator HUD.
- **Col/row orientation** — player-start values can exceed the 13-col grid width, so confirm the exact
  coordinate range/orientation against the emulator.
- The `0x00` flags word, the trailer's trailing value, and the `DATA:` block in 4 boards.

**Resolution plan:** locate the spawn-record reader, then decode a board into the canonical level JSON
(`plan/MASTER_PLAN.md` §7.3) and compare against the same board in the emulator.
