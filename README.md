# Step On It! — Remastered

A faithful remaster of the 1996 Casady & Greene Mac game **Step On It!** for modern platforms
(Windows first). The approach: **decompile** the original PowerPC game logic into a deterministic
headless **C core**, wrap it with a thin **C++ (`godot-cpp`)** GDExtension, and build the presentation
(retro + 4K "D2R" toggle, audio, online 2-player, and an in-engine map editor) in **Godot 4** /
**GDScript**. Personal preservation project.

> **Status:** reverse-engineering & planning phase (no game code written yet). The original binary and
> assets have been analyzed with the `tools/` scripts; findings are in `docs/`, the design/spec is in
> `plan/`.

## Repo layout

Directories use `snake_case`. Inputs are committed; generated artifacts are `.gitignore`d and
reproducible from the inputs via `tools/`.

```
raw_game/            # INPUT — the untouched original Mac game (source of truth; never edited)
refs/                # INPUT — human reference material
  text/              #   manuals, links, serials
  images/            #   in-game screenshots
tools/               # Python analysis/extraction scripts (pure stdlib)
docs/                # authored reverse-engineering findings (see docs/README.md)
plan/                # MASTER_PLAN.md (architecture/spec) + EXECUTION_PLAN.md (steps)
extracted/           # GENERATED — decoded levels/sprites/audio (gitignored; regenerate via tools/)
bin/                 # GENERATED — core_pef.bin + build outputs (gitignored)

# added as the build starts (see plan/EXECUTION_PLAN.md):
core/                # C game core (decompiled)
bridge/              # C++ godot-cpp GDExtension shim
godot_project/       # Godot 4 project (UI, netcode, map editor) + shipped assets
tests/               # verification harness + fixtures
```

## Getting started (analysis tools)

All tools are pure Python 3.10+ (no dependencies). From the repo root:

```
py tools/parse_bord.py        # extract + analyze the BORD level resources
py tools/rezfork.py <._file>  # enumerate a Mac resource fork
py tools/parse_pef.py         # list PEF sections + CFM imports
py tools/analyze_formats.py   # DMKY / clut / sssf format recon
py tools/decode_assets.py     # render palette + sample sprites to PNG (validation)
py tools/extract_pef.py       # copy the PEF to bin/core_pef.bin (for Ghidra)
py tools/pef_patch.py --info  # inspect PEF sections/loader (oracle patch scaffolding)
```

**Phase 0 (environment):** `tools/setup_phase0.sh` installs Ghidra/JDK/resource_dasm under WSL
Ubuntu; `analysis/ghidra/discover.py` is the headless Ghidra discovery pass. See
[plan/EXECUTION_PLAN.md](plan/EXECUTION_PLAN.md).

## Documentation

- **[docs/](docs/)** — verified findings about the original game (binary, resources, level format,
  graphics/audio, gameplay). Each claim is tagged CONFIRMED / HYPOTHESIS / TODO.
- **[plan/MASTER_PLAN.md](plan/MASTER_PLAN.md)** — architecture, determinism contract, oracle,
  schemas, toolchain, scope.
- **[plan/EXECUTION_PLAN.md](plan/EXECUTION_PLAN.md)** — the phased, single-chat execution plan.


