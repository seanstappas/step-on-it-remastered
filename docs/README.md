# Step On It! — Documentation

Living documentation for the remaster project. This folder records **verified facts** about
the original 1996 game (and, later, the remaster). Everything here is something we actually
observed from the game files or the shipped documentation — each claim notes **how** it was
found and whether it is **confirmed** or a **hypothesis** still needing confirmation.

Planning/architecture lives in [`../plan/`](../plan/). Deep findings live here.

## Contents

| Doc | What it covers |
|---|---|
| [original_game/binary-and-resources.md](original_game/binary-and-resources.md) | The fat binary (PowerPC PEF + 68k), CFM imports, the app's own resources, and how classic-Mac resource forks are stored in this copy. |
| [original_game/bord-level-format.md](original_game/bord-level-format.md) | The `BORD` level resource format (first-pass reversed) and the extraction method. |
| [original_game/graphics-and-audio.md](original_game/graphics-and-audio.md) | `SOI Graphics` / `SOI Sounds` inventory: the custom `sssf` sprite format, palettes, UI icons, and sound effects. |
| [original_game/gameplay-and-design.md](original_game/gameplay-and-design.md) | Game rules, entities, scoring, controls, and system requirements from the shipped docs. |

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

## Open questions & resolution status

The knowledge base is in a good state: the container/resource layout, the level header, the palette, the
sprite framing, and all gameplay entities are **CONFIRMED**. The remaining unknowns are clustered and
all bottom out at the **decompiled code** — they are Phase-1 Ghidra work, not further byte-staring.

| Open question | Status | Resolved by |
|---|---|---|
| `sssf` exact RLE opcodes + ~8-byte per-frame sub-header | run-length **confirmed**; opcodes TBD | the decompiled **blit** routine |
| `DMKY` precise record framing + bit→key map | per-key bitmask **confirmed**; framing TBD | the decompiled **demo-playback** routine |
| `BORD` block-property bits + badguy type/direction bytes | record framing **confirmed**; field bits TBD | the decompiled **board loader** |
| `DATA:` sub-block in 4 boards | present; purpose TBD | board loader / cross-ref |
| FP-vs-integer math; per-Tick-vs-per-frame timestep; `Random()` return slice + `randSeed` origin | listed as gates in `plan/MASTER_PLAN.md` §2a/§5–§6 | Ghidra disassembly |

Everything above has a defined resolution path in `plan/EXECUTION_PLAN.md` (Phase 1).
