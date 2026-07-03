# Binary & Resource Structure (Original)

How the shipped Mac application and its data files are put together, and how we determined it.

All observations are from the files under `raw_game/Step On It™/`. Byte inspection was done with
PowerShell (`[System.IO.File]::ReadAllBytes`) and the project's own parser
[`tools/parse_bord.py`](../../tools/parse_bord.py).

---

## 1. It is a "fat" binary (PowerPC + 68k) — CONFIRMED

The application `Step On It!™` ships code for both CPU families of the era:

| Part | Where it lives | Size | Notes |
|---|---|---|---|
| **PowerPC code** | the app's **data fork** (`Step On It!™`) | 220,181 B | A **PEF** container — starts with magic `Joy!peff` (`4A 6F 79 21 70 65 66 66`). |
| **68k code** | the app's **resource fork** (`__MACOSX/._Step On It!™`) | 271,454 B | Classic `CODE` resources, plus a `cfrg` code-fragment resource. |

**How we found it:**
- Read the first 8 bytes of the data fork → `Joy!peff` → PowerPC PEF.
- Scanned the resource fork for 4-char resource-type/architecture tags and found `cfrg` (code fragment),
  `CODE` (68k segments), and `pwpc` (the PowerPC architecture tag inside the `cfrg`), alongside `PICT`,
  `snd `, `SIZE`, and `vers`.

**Decision:** decompile the **PowerPC PEF** (cleaner decompilation, and its CFM imports are named — see §3),
using the 68k `CODE` only as a cross-reference. See `plan/MASTER_PLAN.md` §2a.

**Bonus for decompilation:** the 68k `CODE` resources are **named by subsystem** — `1 Libraries`,
`2 Bad Guy Segment`, `3 Graphics Segment`, `4 Players Segment`, `5 Misc Segment`, `7 Apple Interface
Segment` — which maps almost 1:1 onto the decompiler domains (Bad Guy→enemies, Players→physics,
Graphics/Misc→grid & misc). The PPC PEF is a single fragment but implements the same subsystems.

---

## 2. Resource forks are stored as AppleDouble `._*` files — CONFIRMED

On this extracted copy (it came through a Mac→zip round-trip), the classic-Mac **resource forks are
not attached** to the plain files. Instead each file `X` has a sidecar `__MACOSX/._X` holding its
resource fork in **AppleDouble** format. The plain data-fork files for the *data* resources are empty:

| Logical file | Data fork | Resource fork (`__MACOSX/._*`) |
|---|---|---|
| `SOI Graphics` | **0 B** | 2,556,322 B — `PICT` images etc. |
| `SOI Sounds` | **0 B** | 757,089 B — `snd ` sound effects |
| `SOI Boards` | **0 B** | 53,309 B — `BORD` level data |
| `Step On It!™` (app) | 220,181 B (PEF, non-empty) | 271,454 B — 68k `CODE` |

**How we found it:** `Get-ChildItem -Recurse` sizes showed the plain data files at 0 bytes while the
`._*` siblings held all the mass. The app is the exception — its data fork is the PEF.

### AppleDouble container layout (as observed in `._SOI Boards`)

```
offset  bytes                         meaning
0x00    00 05 16 07                   AppleDouble magic
0x04    00 02 00 00                   version 2
0x08    16 bytes filler
0x18    00 02                         entry count = 2
0x1A    entry[0]: id=0x09 off=0x32 len=0x20   Finder Info (32 B)
0x26    entry[1]: id=0x02 off=0x52 len=0xCFEB Resource Fork (53,227 B)
0x32    Finder Info → type 'SsBd', creator 'SsBD'
0x52    Resource Fork begins (standard Mac resource fork)
```

The Finder type/creator `SsBd`/`SsBD` is the Board Designer's board-set signature.

**Implication for extraction:** the pipeline must read the resource fork out of the `._*` AppleDouble
(entry id `2`), **not** the empty plain file. `tools/parse_bord.py` does exactly this and is our
dependency-free fallback if `resource_dasm` cannot consume AppleDouble directly. The pristine
`raw_game/StepOnIt_1_0_1.zip` is the original source archive if a clean re-extraction is ever needed.

---

## 3. CFM imports — the full Toolbox surface — CONFIRMED

`tools/parse_pef.py` parses the PEF loader section directly. The app imports **257 symbols from 2
libraries** and exports **0** (it is an application, not a shared library):

- **`InterfaceLib` — 230 symbols:** the classic Mac Toolbox/OS (QuickDraw, Dialog/Menu/Resource/File
  Managers, Sound Manager, Memory Manager, AppleEvents).
- **`QuickTimeLib` — 27 symbols:** movie playback (`NewMovieFromFile`, `StartMovie`, `MoviesTask`, …) —
  i.e. the music.

Imports that shape the port:

| Import(s) | Meaning for the port |
|---|---|
| `Random` | Toolbox RNG — **provisionally** a Park–Miller/`16807` LCG (**unconfirmed**; pin the exact recurrence from the disassembly, plan §5.3), **signed 16-bit** return; reproducible with a pinned seed. Decompiled consumers mask the sign off — see §3a. |
| `GetKeys`, `Button` | Whole-keyboard bitmap read → our per-tick input bitmask. |
| `TickCount` | Classic Mac tick = 1/60 s. Per-Tick vs per-frame stepping is still **TODO** (19 call sites; those inspected are fade/frame-pacing busy-waits). |
| `FSWrite`, `FSRead`, `FSpCreate`, `FSpOpenDF` | File I/O — **confirms the tracing-build oracle** (plan §6.3) can log per-tick state via `FSWrite`. |
| `CopyBits`, `DrawPicture`, `PlotCIcon`, `GetCIcon` | QuickDraw blitting / icon draw — rendering, not simulation. |
| `SetEntries`, `MakeITable`, `DisposeCTable` | Palette (CLUT) manipulation — the original's color-shift mechanism. |
| `SndNewChannel`, `SndDoImmediate`, `SndPlayDoubleBuffer` | Sound Manager for `snd ` SFX. |
| `Gestalt`, `SysEnvirons` | Environment / capability checks at startup. |
| `NewPtr`, `NewHandle`, `BlockMoveData` | Memory allocation / copy (→ our `alloc`). |

No `MathLib` (or other FP library) is imported.

---

## 3a. Decompiler findings (Ghidra 11.3.2 headless) — CONFIRMED

`analysis/ghidra/discover.py` + `decompile.py` load the PEF as **`PowerPC:BE:32:default`** (base
`0x10000000`; the auto-suggested `…:64:VLE` variant is wrong and must be overridden with
`-processor PowerPC:BE:32:default`). Inventory: **721 functions, 257 imports, 517 globals**.

**Floating point: none.** A scan of every instruction found **0 floating-point ops** (no `f*`, no
`lfs/lfd/stfs/stfd`) across all 721 functions. Combined with the missing `MathLib`, this confirms the
**game logic is integer-only** — the deterministic integer path is the actual design, not a
fallback, and there is no float-in-hash risk.

**RNG consumption (pins the §5.3 return-slice).** The `Random()` sign is always discarded by masking:

- `RandomInRange(1, n)` — `FUN_1000c278` and its duplicate `FUN_1000cbe0`:
  `result = ((Random() & 0x7FFF) * n) / 0x7FFF + 1`, clamped to `n` → uses the low **15 bits**.
- Weighted spawn pick — `FUN_1000c680`: `Random() & 0x3F` (low **6 bits**, 0–63) indexes a hardcoded
  distribution of tile/nasty IDs.

**Seed source — CONFIRMED.** A whole-program scan (`analysis/ghidra/seed_and_loop.py`) finds **no write
to `randSeed` (low-mem `0x08FE`) anywhere in the code**, and the `entry`→`main` (`FUN_1001a4b8`) init path
does not seed it either. So the RNG runs on the **Toolbox default `randSeed = 1`** (set by `InitGraf`) and
is **deterministic from launch** — the only thing that shifts the stream is how many attract/menu
`Random()` draws occur before gameplay. There is no clock-seeding to defeat; the oracle still pins the
seed at gameplay start for safety.

**Entry & main.** `entry` (`0x10030e18`) runs CFM/Toolbox init, then calls **`main` = `FUN_1001a4b8`**
(an init sequence). The game uses a **custom polling loop** (no Toolbox `WaitNextEvent`); `FUN_10029ca0`
is the **per-frame demo-playback / input routine** that decodes `DMKY` (§6).

**Game loop & cadence (`FUN_10029264`) — CONFIRMED.** The in-round loop **busy-waits on a frame-sync flag**
(`FUN_100193a8` returns `0x1003b28a == 1`) each iteration, runs **one logic/physics step per frame**, and
**samples input every 2 frames**. `TickCount` itself is only used for a startup sync + an idle-time metric
— never gameplay — so it is **pacing-only**. The real frame timer is a **Time Manager** task (`FUN_10019428`
installs via `InsXTime`/`PrimeTime`; `FUN_100193c8` re-arms it each frame) whose interval (global
`0x1003b286`) is **Speed-selected by `FUN_1001c398` (ms):** Really Fast **9**, Fast **11**, **Medium 14**,
Slow **18** → Medium ≈ **71 Hz** physics, input ≈ **35.7 Hz**. So the canonical rate is a Time-Manager
millisecond timer, **not** the 60 Hz `TickCount`.

Decompiled reference C for the `Random`/`TickCount`/`GetKeys` callers is regenerable into
`analysis/decomp/` via `decompile.py` (gitignored — derived from the copyrighted binary).

---

## 4. Resource inventory of `SOI Boards` — CONFIRMED

`tools/parse_bord.py` parsed the resource map and enumerated:

| Type | Count | IDs |
|---|---|---|
| `BORD` | 152 | 301 (`demo`), 401–501, 1001–1050 |
| `ICN#`,`icl8`,`icl4`,`ics#`,`ics8`,`ics4` | 1 each | −16455 (the file's custom Finder icon) |
| `DMKY` | 1 | 15639 (purpose unknown — TODO) |

See [bord-level-format.md](bord-level-format.md) for the `BORD` byte layout.

---

## 5. Audio assets — CONFIRMED (format), TODO (re-render)

Music is **QuickTime MIDI movies**, not tracker modules. They live in
`raw_game/Step On It™/Step On It!  Movies/`: `6lilt`, `Angel Pie`, `bass for lunch`, `Cminor`,
`spooky`, `blue wins`, `green wins`, `no winner`, and "thin" variants (the game's **Light Music**
option). Sound effects are `snd ` resources in `SOI Sounds`.

Music is **off by default** in the original (per the shipped About doc), which is strong evidence the
game logic is audio-independent — useful for the deterministic core and its verification.

---

## 6. The application's own resources — CONFIRMED

`tools/rezfork.py` on `._Step On It!™` (271 KB, the 68k side) shows how the app is built:

- **Version:** `vers` = **1.0.1** (© 1999 Casady & Greene). The title dates to 1996; this is a later build.
- **`CODE` (8 segments)** named as in §1 — the subsystem map.
- **`cfrg`** — the PowerPC code-fragment descriptor that points at the PEF data fork.
- **`SIZE`** — the Finder memory-partition resource (the ~3.5 MB requirement).
- **UI:** 11 `MENU` + `MBAR 400`, 14 `DLOG` + 23 `DITL`, 9 `ALRT`. Named dialogs confirm features:
  `Set Starting Board`, `Really load Board Set?`, `custom save game` / `Custom load game`,
  `Serial Number dialog` (4000), `keys` (5000), `Warning: not default keys` (406).
- **`keys 128`** — the default keyboard-mapping resource (source of truth for the input bit layout).
- **`DMKY`** (`current demo keys` 1000, `last` 1001) — **recorded demo key streams** (see below).
- **`BORD 300 'demo'`** + **`DEMO 128`** — the attract-mode demo board and driver.
- **`STR# 128`** — startup requirement/error strings encoding: needs a **68030+**, **System 7.0+**,
  **256 colors + 640×480**, **Sound Manager 3.0+**, and that `SOI Graphics`/`SOI Sounds`/`SOI Boards`
  must sit beside the app.
- **`hisr 400`** — high-scores storage.

### The Demo is driven by recorded keys (`DMKY`)
The attract-mode Demo pairs a board (`BORD 'demo'`) with a **recorded key stream** in `DMKY`
(`current demo keys` 846 B, `last` 920 B; `SOI Boards` also carries a `DMKY`, id 15639). Replaying the
same key stream reproduces the same inputs every run (RNG must still be seed-pinned — plan §6.2).

**Format — CONFIRMED from the decompiled demo-playback routine (`FUN_10029ca0`).** `DMKY` is a
**run-length-encoded input stream** of **`(run_length: u8, bitmask: u8)` pairs**: the routine holds a
countdown (`run_length`) and the current `bitmask`, decrementing the countdown once per frame; when it
reaches 0 it reads the next `(run_length, bitmask)` pair from the stream. Each `bitmask` is unpacked into
**7 input booleans** (`0x01`–`0x40`) — the same per-key bitmask as plan §7.5, so it fits a `uint8_t`. The
earlier RLE hypothesis is thus confirmed. **Still TODO:** the precise bit→key *meaning* (which bit is
Jump vs Fire), which needs correlating the bits with the movement code.

## 7. Tools used
- [`tools/rezfork.py`](../../tools/rezfork.py) — resource-fork enumerator/decoder (AppleDouble-aware).
- [`tools/parse_pef.py`](../../tools/parse_pef.py) — PEF section + CFM import/export lister.
- [`tools/parse_bord.py`](../../tools/parse_bord.py) — `BORD` level extractor/analyzer.
- [`tools/analyze_formats.py`](../../tools/analyze_formats.py) — `DMKY` / `clut` / `sssf` format recon.
