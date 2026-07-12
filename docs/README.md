# Step On It! — Documentation

Documentation for the remaster project, in two layers:

- **`original_game/`** — the **reverse-engineering record**: verified facts about the original
  1996 game, observed from the game files or shipped docs. Each claim notes **how** it was found
  and whether it is **CONFIRMED** or a **HYPOTHESIS**. This was the input to the port.
- **[`remaster/`](remaster/README.md)** — how the **shipped port** is built (C core → C++ bridge →
  Godot front-end), the run/capture flags, and the HD/AI asset pipeline.

The RE phase is complete and the port is **playable** — the unknowns listed below were all resolved
in the decompiled core ([`../core/`](../core/)) and cross-checked by the deterministic gate.
Planning/architecture lives in [`../plan/`](../plan/).

## Contents

| Doc | What it covers |
|---|---|
| [remaster/README.md](remaster/README.md) | **The shipped port**: architecture (core → bridge → front-end), build/run/capture flags, and the HD/AI asset pipeline. |
| [original_game/binary-and-resources.md](original_game/binary-and-resources.md) | The fat binary (PowerPC PEF + 68k), CFM imports, the app's own resources, and how classic-Mac resource forks are stored in this copy. |
| [original_game/bord-level-format.md](original_game/bord-level-format.md) | The `BORD` level resource format (reversed) and the extraction method. |
| [original_game/graphics-and-audio.md](original_game/graphics-and-audio.md) | `SOI Graphics` / `SOI Sounds` inventory: the custom `sssf` sprite format, palettes, UI icons, and sound effects. |
| [original_game/gameplay-and-design.md](original_game/gameplay-and-design.md) | Game rules, entities, scoring, controls, and system requirements from the shipped docs. |
| [original_game/decompiled-findings.md](original_game/decompiled-findings.md) | Reverse-engineered code facts: routines, constants, and tables recovered from the PEF that drive the C core. |
| [original_game/runtime-structures.md](original_game/runtime-structures.md) | In-memory runtime structures (player / enemy / board state) reconstructed from the decompilation. |
| [original_game/music-tracks.md](original_game/music-tracks.md) | QTMA music inventory and the **per-screen track mapping** (confirmed from RE), plus HD render notes. |

## Confidence legend

- **CONFIRMED** — directly observed and cross-checked (e.g. constant across all samples, or a magic number).
- **HYPOTHESIS** — a working interpretation consistent with the data, not yet proven.
- **TODO** — known unknown; how we plan to resolve it is noted inline.

## Tools

- [`../tools/parse_bord.py`](../tools/parse_bord.py) — AppleDouble + Mac resource-fork parser; extracts and analyzes `BORD` level resources.
- [`../tools/rezfork.py`](../tools/rezfork.py) — general resource-fork enumerator/decoder (types, ids, names, `vers`/`STR#`).
- [`../tools/parse_pef.py`](../tools/parse_pef.py) — PowerPC PEF section + CFM import/export lister.
- [`../tools/analyze_formats.py`](../tools/analyze_formats.py) — recon for the `DMKY`, `clut`, and `sssf` formats.
- [`../tools/decode_assets.py`](../tools/decode_assets.py) — renders the `clut` palette + sample `sssf` frames to PNG (validation).

All are pure Python (no external dependencies) and run with `py tools/<name>.py`.

## Resolution status

Everything below was an open unknown during the byte-staring phase. **All are now resolved** in the
decompiled C core ([`../core/`](../core/)) and validated by the deterministic gate
([`../tools/verify.ps1`](../tools/verify.ps1)); the details live in
[original_game/decompiled-findings.md](original_game/decompiled-findings.md) and
[original_game/runtime-structures.md](original_game/runtime-structures.md).

| Former open question | Status | Resolved by |
|---|---|---|
| `sssf` RLE opcodes + per-frame sub-header | **RESOLVED** | decompiled blit → [`../tools/sssf_decode.py`](../tools/sssf_decode.py) (30 sprite families decoded) |
| `DMKY` record framing + bit→key map | **RESOLVED** | demo-playback routine (key bitmask reproduced in the core input model) |
| `BORD` block-property bits + badguy type/direction bytes | **RESOLVED** | decompiled board loader → `soi_load_level` + [`../tools/parse_bord.py`](../tools/parse_bord.py) |
| `DATA:` sub-block in 4 boards | **RESOLVED** | board loader cross-ref (procedural badguy-throw parameters) |
| FP-vs-integer math; per-Tick vs per-frame timestep | **RESOLVED** | integer math; 30 Hz player / 60 Hz enemies ([`../core/src/soi_physics.c`](../core/src/soi_physics.c)) |
| `Random()` return slice + `randSeed` origin | **RESOLVED** | Park-Miller minimal-standard LCG, seeded at 1 ([`../core/src/soi_rng.c`](../core/src/soi_rng.c)) |

> A few section-level `TODO(oracle)` markers remain inside the `original_game/` docs and the core
> comments. These are **fine-tuning** items (exact enemy-AI cadences, ricochet nesting) still being
> matched against emulator tick-traces — not blocking unknowns.
