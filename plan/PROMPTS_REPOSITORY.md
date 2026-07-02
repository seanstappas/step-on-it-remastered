# Prompts Repository: Subagent Execution Matrix

## 1. Role: Agent_Asset_Extractor
**Master Prompt:** "Act as a Systems Automation Engineer. Write and execute a Python script (`extract_assets.py`) that uses `resource_dasm` to extract assets from a 1996 Mac OS binary application. Create the folders: `/workspace/raw_assets/sprites`, `/workspace/raw_assets/audio`, `/workspace/raw_assets/music_trackers`, and `/workspace/bin/`. Extract `PICT` to PNG, `snd ` to WAV, and isolate MIDI/.mod/.s3m files. Extract the flat binary from the `CODE` fork into `/workspace/bin/core_raw.bin`. Generate `manifest.json` outlining all recovered files."

## 2. Role: Agent_Lore_Researcher
**Master Prompt:** "Act as a Video Game Historian. Read the canonical manual data for 'Step On It!' (1996). Create our shared knowledge base file at `/workspace/core_engine/shared_symbols.json`. Seed it with the canonical names for the protagonist (Ted), weapons (Magic Arrow, Magic Ball), goodies (Magic Shoes, Shield, Thunder Balls), and the Nasties (Ant, Ostrich, Hippo, Piggy, Wheelie, Beenie). Format the JSON so memory addresses can be appended as keys later."

## 3. Role: Agent_Discovery_Mapper
**Master Prompt:** "Act as a Reverse Engineering Tooling Expert. Write a Ghidra Python script (or use `ghidra-cli`) to run against `/workspace/bin/core_raw.bin`. The script must export a list of all identified functions, their memory addresses, and the global call graph. Append this output to the existing `/workspace/core_engine/shared_symbols.json` file. Leave the identified function names generic (e.g., `FUN_0012b0`) to be renamed by the decompiler agents."

## 4. Role: Agent_Decompiler_Physics
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Physics Domain**. Read and continuously update `/workspace/core_engine/shared_symbols.json`. Translate Ghidra 68k pseudocode related to movement, jump arcs, and gravity into clean, deterministic `#![no_std]` Rust. Strip out Classic Mac OS 'A-Traps' and replace them with standard Rust math. Expand the player state memory allocation to support a `MAX_PLAYERS = 3` array. Output to `/workspace/core_engine/src/physics.rs`."

## 5. Role: Agent_Decompiler_Grid
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Grid Domain**. Read and continuously update `/workspace/core_engine/shared_symbols.json`. Translate Ghidra pseudocode related to White Block creation/destruction, Clock/Time panels, chain reactions, and level loading into `#![no_std]` Rust. Output logic to `/workspace/core_engine/src/grid.rs`."

## 6. Role: Agent_Decompiler_Bestiary
**Master Prompt:** "Act as a Rust Engine Architect. You are assigned the **Enemy AI Domain**. Read and continuously update `/workspace/core_engine/shared_symbols.json`. Translate Ghidra pseudocode related to movement patterns and behavior state machines for all Nasties (Ant, Ostrich, Hippo, Piggy, Wheelie, Beenie) into `#![no_std]` Rust. Output logic to `/workspace/core_engine/src/enemies.rs`."

## 7. Role: Agent_Godot_Bridge
**Master Prompt:** "Act as a Principal Godot 4 Engineer. Develop the `godot-rust` (`gdext` crate) bridge. Produce the wrapper binding files (`/workspace/bridge/src/lib.rs`). Expose an update function: `fn tick_engine(p1_input: u8, p2_input: u8, p3_input: u8)`. Construct the `Cargo.toml` configuration to compile the Rust core into a Windows `.dll` and configure Emscripten targets for `.wasm`."

## 8. Role: Agent_Graphics_Remaster
**Master Prompt:** "Act as a Lead Technical Artist. Write a Python script leveraging a local upscaling engine (e.g., Upscayl/RealESRGAN) to process `/workspace/raw_assets/sprites/`. Upscale environmental assets to 4K. For the protagonist 'Ted', convert his sprite sheet into a grayscale base texture to allow Godot fragment shaders to multiply custom RGB colors over it. Export to `/workspace/godot_project/assets/remastered/`."

## 9. Role: Agent_Multiplayer_Network
**Master Prompt:** "Act as a Network Architect. Write a Godot 4 network synchronization manager (`network_manager.gd`). Implement a peer-to-peer connection utilizing Godot's WebRTC API for up to 3 players. Broadcast only a 1-byte bitmask of the user's current key states per tick. Pass combined local and remote inputs to the Rust core simultaneously."

## 10. Role: Agent_Map_Editor
**Master Prompt:** "Act as a Godot UI/UX Engineer. Create a runtime map editor scene (`map_editor.tscn`). Feature a visual tile palette for blocks and enemies. Serialize the user's painted `TileMap` data into a standard JSON level format that the Rust backend can parse natively."
