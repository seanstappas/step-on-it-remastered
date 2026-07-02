Initialize a master automated workspace orchestration pipeline for the "Step On It!" classic Mac game remaster. You have full workspace read/write access and local terminal execution rights.

Read the architectural specifications in `MASTER_PLAN.md` and parse the individual agent instructions within `PROMPTS_REPOSITORY.md`. 

Execute the project initialization using this parallel sequence:

1. Setup Workspace Layout: Create the required directory tree:
   - `/workspace/raw_assets/`
   - `/workspace/core_engine/src/`
   - `/workspace/bridge/src/`
   - `/workspace/godot_project/`

2. Phase 1 - Extraction & Lore Discovery: 
   - Deploy `Agent_Lore_Researcher` to create and seed `shared_symbols.json` with the canonical naming conventions.
   - Deploy `Agent_Asset_Extractor` to extract the binary, PICT, and sound/MIDI assets.
   - Once extraction is complete, deploy `Agent_Discovery_Mapper` to run Ghidra headlessly against the binary, extracting the call graph and appending memory addresses to `shared_symbols.json`.

3. Phase 2 - Parallel Rust Decompilation: Once `shared_symbols.json` is fully populated, spawn three concurrent subagents to begin decompilation into #![no_std] Rust simultaneously. Instruct them to read and update `shared_symbols.json` to prevent naming collisions:
   - `Agent_Decompiler_Physics`
   - `Agent_Decompiler_Grid`
   - `Agent_Decompiler_Bestiary`

4. Phase 3 - Peripheral Pipelines: While the decompilation agents are running, concurrently spawn:
   - `Agent_Graphics_Remaster` to upscale the sprites and generate the grayscale shader base.
   - `Agent_Godot_Bridge` to write the Cargo.toml and gdext boilerplate.
   - `Agent_Map_Editor` to begin constructing the Godot UI runtime editor.

Act as the Manager Agent. Report the completion of Phase 1 to me here before spinning up the Phase 2 parallel subagents. Do not proceed to Phase 2 until I approve the initial JSON symbol map.
