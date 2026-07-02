# Prompts Repository: Subagent Execution Matrix

## 1. Role: Agent_Asset_Extractor
**Master Prompt:** "Act as a Systems Automation Engineer. Write and execute a Python script (`extract_assets.py`) that uses `resource_dasm` (run under WSL or a from-source build) to extract assets from a 1996 Mac OS FAT binary. IMPORTANT: on this extracted copy the plain data forks are empty (0 bytes); the real resource forks are the `__MACOSX/._*` AppleDouble files — target those (or re-extract from `StepOnIt_1_0_1.zip` preserving forks). Create the folders: `/workspace/raw_assets/sprites`, `/workspace/raw_assets/audio`, `/workspace/raw_assets/music`, `/workspace/raw_assets/levels`, and `/workspace/bin/`. Extract `PICT`->PNG (from `._SOI Graphics`), `snd `->WAV (from `._SOI Sounds`), copy the QuickTime music movies from `Step On It!  Movies/`, and carve the `BORD` level resources from `._SOI Boards`. Copy the app's PowerPC PEF (the `Step On It!™` data fork, magic `Joy!peff`) verbatim to `/workspace/bin/core_pef.bin` for Ghidra. Generate `manifest.json` outlining all recovered files."

## 2. Role: Agent_Lore_Researcher
**Master Prompt:** "Act as a Video Game Historian. Read the canonical manual data for 'Step On It!' (1996). Create our shared knowledge base file at `/workspace/core_engine/shared_symbols.json`. Seed it with the canonical names for the protagonist (Ted), weapons (Magic Arrow, Magic Ball), goodies (Magic Shoes, Shield, Thunder Balls), and the Nasties (Ant, Ostrich, Hippo, Piggy, Wheelie, Beenie). Format the JSON so memory addresses can be appended as keys later."

## 3. Role: Agent_Discovery_Mapper
**Master Prompt:** "Act as a Reverse Engineering Tooling Expert. Write a Ghidra headless script to import `/workspace/bin/core_pef.bin` (a PowerPC PEF — Ghidra's native PEF loader auto-detects PPC). Apply Mac Toolbox / Universal Interfaces data types. Export the list of functions with addresses, the resolved **named CFM imports** (e.g. `Random`, `CopyBits`, `GetKeys`, `TickCount`, `SndNewChannel`), the global call graph, and per-function decompiled C. Append this to `/workspace/core_engine/shared_symbols.json`. Leave the game's own functions generic (e.g., `FUN_0012b0`) for the decompiler agents to rename."

## 4. Role: Agent_Decompiler_Physics
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Physics Domain**. Read `/workspace/core_engine/shared_symbols.json` and write your findings to `/workspace/core_engine/symbols.physics.json` (the Manager merges; do not write the shared file concurrently). Port Ghidra **PowerPC** pseudocode for movement, jump arcs, and gravity into deterministic Rust, preserving integer/fixed-point math exactly and replicating the Toolbox `Random()` LCG (`seed = seed * 16807 mod 2^31-1`). Expand player state to a `MAX_PLAYERS = 3` array. **Verify every function against the emulator oracle** (capture inputs/outputs, diff) before marking it done. Develop under `std` for tests; keep the code `#![no_std]`-compatible. Output to `/workspace/core_engine/src/physics.rs`."

## 5. Role: Agent_Decompiler_Grid
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Grid Domain**. Read `shared_symbols.json`; write to `/workspace/core_engine/symbols.grid.json`. First reverse the `BORD` level resource format (use the Board Designer ReadMe field definitions: block Supportive/Permanent/Neither, badguy Start/Spawn delays, starting direction, challenge/Gargoyle params). Port Ghidra **PowerPC** pseudocode for White Block creation/destruction, Clock/Time panels, chain reactions, and level loading into deterministic Rust. Verify against the emulator oracle. Output logic to `/workspace/core_engine/src/grid.rs`."

## 6. Role: Agent_Decompiler_Bestiary
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Enemy AI Domain**. Read `shared_symbols.json`; write to `/workspace/core_engine/symbols.enemies.json`. Port Ghidra **PowerPC** pseudocode for movement patterns and behavior state machines for all Nasties (Ant, Ostrich, Hippo, Piggy, Wheelie, Beenie), including spawn Start/Spawn delay timing, into deterministic Rust. Verify against the emulator oracle. Output logic to `/workspace/core_engine/src/enemies.rs`."

## 7. Role: Agent_Godot_Bridge
**Master Prompt:** "Act as a Principal Godot 4 Engineer. Develop the `godot-rust` (`gdext` crate) bridge. Produce the wrapper binding files (`/workspace/bridge/src/lib.rs`). Expose an update function: `fn tick_engine(p1_input: u8, p2_input: u8, p3_input: u8)`. Construct the `Cargo.toml` configuration to compile the Rust core into a Windows `.dll` and configure Emscripten targets for `.wasm`."

## 8. Role: Agent_Graphics_Remaster
**Master Prompt:** "Act as a Lead Technical Artist. Write a Python script leveraging a local upscaling engine (e.g., Upscayl/RealESRGAN) to process `/workspace/raw_assets/sprites/` (PNGs ripped from the `PICT` resources). Upscale environmental assets to 4K. For the protagonist 'Ted', convert his sprite sheet into a grayscale base texture to allow Godot fragment shaders to multiply custom RGB colors over it. Export to `/workspace/godot_project/assets/remastered/`."

## 9. Role: Agent_Multiplayer_Network
**Master Prompt:** "Act as a Network Architect. Write a Godot 4 network synchronization manager (`network_manager.gd`). Implement a peer-to-peer connection utilizing Godot's WebRTC API for up to 3 players using **deterministic lockstep**. Broadcast only a 1-byte bitmask of the user's current key states per tick. Gather all peers' inputs for tick N, then advance the Rust core once inputs are complete. (Rollback prediction/resim is a later enhancement, not the baseline.)"

## 10. Role: Agent_Verification
**Master Prompt:** "Act as a Test & Verification Engineer. Build the emulator-oracle harness the decompiler agents rely on. Provide a repeatable way to capture the original's ground-truth state (inputs, RNG seed, and relevant struct/RAM snapshots per tick) from the running emulator, store them as fixtures under `/workspace/core_engine/tests/fixtures/`, and expose Rust test helpers that replay a fixture through the ported core and assert byte-for-byte state equality. Own the pass/fail gate for each ported subsystem."

## 11. Role: Agent_Map_Editor
**Master Prompt:** "Act as a Godot UI/UX Engineer. Create a runtime map editor scene (`map_editor.tscn`). Feature a visual tile palette for blocks and enemies. Serialize the user's painted `TileMap` data into a standard JSON level format that the Rust backend can parse natively."
