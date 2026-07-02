Initialize a master automated workspace orchestration pipeline for the "Step On It!" classic Mac game remaster. You have full workspace read/write access and local terminal execution rights.

Read the architectural specifications in `MASTER_PLAN.md` and parse the individual agent instructions within `PROMPTS_REPOSITORY.md`. 

Execute the project initialization using this parallel sequence:

1. Setup Workspace Layout: Create the required directory tree:
   - `/workspace/raw_assets/`
   - `/workspace/core_engine/src/`
   - `/workspace/bridge/src/`
   - `/workspace/godot_project/`

2. Phase 1 - Extraction, Discovery & Lore: 
   - Deploy `Agent_Lore_Researcher` to create and seed `shared_symbols.json` with the canonical naming conventions.
   - Deploy `Agent_Asset_Extractor` to extract assets from the `__MACOSX/._*` resource forks (the plain data forks are empty): `PICT`->PNG, `snd `->WAV, the QuickTime music movies, and the `BORD` level resources from `SOI Boards`.
   - Once extraction is complete, deploy `Agent_Discovery_Mapper` to load the **PowerPC PEF** (`Step On It!™` data fork, magic `Joy!peff`) into Ghidra headlessly (native PEF loader), apply Mac Toolbox types, and export decompiled C + named CFM imports + the call graph into `shared_symbols.json`.

3. Phase 2 - Rust Decompilation (behavior-verified): Once `shared_symbols.json` is populated, run the decompiler subagents. Note: VS Code subagents run synchronously and return one report each — sequence them (or fan out read-only work), do not assume true background parallelism. Each writes its OWN symbol file to avoid write races; the Manager merges them:
   - `Agent_Decompiler_Physics` (-> `symbols.physics.json`)
   - `Agent_Decompiler_Grid` (-> `symbols.grid.json`)
   - `Agent_Decompiler_Bestiary` (-> `symbols.enemies.json`)
   Each porter MUST verify every function against the emulator oracle (capture inputs/outputs, diff) and preserve the Toolbox `Random()` LCG exactly. Develop the core as a `std` crate for testing, gate to `#![no_std]` for release.

4. Phase 3 - Peripheral Pipelines: While the decompilation agents are running, concurrently spawn:
   - `Agent_Graphics_Remaster` to upscale the sprites and generate the grayscale shader base.
   - `Agent_Godot_Bridge` to write the Cargo.toml and gdext boilerplate.
   - `Agent_Map_Editor` to begin constructing the Godot UI runtime editor.

Act as the Manager Agent. Report the completion of Phase 1 to me here before spinning up the Phase 2 parallel subagents. Do not proceed to Phase 2 until I approve the initial JSON symbol map.
