# Master Plan & Design Document: Project "Step On It!" Remaster

## 1. High-Level Requirements
* **Target Platforms:** Standalone Windows desktop (`.exe`) first; web assembly (`HTML5/WASM`) as a deferred stretch goal (gdext web export is experimental).
* **Core Engine:** A headless **Rust** backend that is a faithful, behavior-verified port of the 1996 Mac OS game logic. Developed as a `std` crate for testing (replaying emulator traces), then gated to `#![no_std]` for the final build.
* **Front-End Engine:** Godot 4, acting strictly as a high-performance visual and input puppet.
* **The "D2R" Toggle:** Instant real-time switching between native 1996 4:3 graphics (640×480 logical space) and modern 4K widescreen assets.
* **Online Multiplayer:** P2P WebRTC online co-op and competitive play (expanded to 3 players) mapped onto a deterministic engine core using **lockstep** netcode (1-byte input bitmask per player per tick). Rollback is a later option, not the baseline.
* **Extended Features:** In-engine Godot Map Editor (exporting to JSON), remastered audio (QuickTime MIDI music + `snd ` SFX re-rendered), and fragment shaders for infinite customizable player colors.

## 2. Canonical Game Elements (Baseline Dictionary)
* **Protagonist:** Ted (robotic man).
* **Objective:** Acquire the Key and exit through the Red Door.
* **Mechanics:** Ted creates White Blocks to navigate and trap enemies. Levels feature Chain Reactions and Clock/Time Panels.
* **Weapons:** Magic Arrow (straight line), Magic Ball (rolls along walls).
* **Goodies:** Magic Shoes (speed), Shield (invulnerability), Thunder Balls (kills reproducers), Coins, Gold Bars, Gems.
* **The Nasties:** Ant (50 pts), Ostrich (100 pts), Hippo (200 pts), Piggy (250 pts), Wheelie (300 pts), Beenie (750 pts).

## 2a. Verified Binary & Asset Facts (recon 2026-07-02)
These supersede earlier assumptions and drive the pipeline below.

* **The app is a FAT binary.** `Step On It!™` data fork = a **PowerPC PEF** (magic `Joy!peff`, 220,181 B). The resource fork also holds **68k `CODE`** resources + a `cfrg`. **Decompile the PowerPC PEF** (data fork) — its CFM imports are named, so Toolbox/OS calls arrive labeled and PPC pseudocode is far cleaner than 68k. Keep 68k `CODE` only as a cross-reference.
* **Resource forks live in `__MACOSX/._*` AppleDouble files** on this extracted copy; the plain data-fork files (`SOI Graphics`, `SOI Sounds`, `SOI Boards`) are **0 bytes**. Extraction MUST target the `._*` forks (or re-extract from `StepOnIt_1_0_1.zip` preserving forks):
  * `._SOI Graphics` ≈ 2.55 MB (`Lockstep PICT` etc.)
  * `._SOI Sounds` ≈ 757 KB (`snd `)
  * `._SOI Boards` ≈ 53 KB — **level data as `BORD` resources**; fields documented in the Board Designer ReadMe.
* **RNG is the Toolbox `Random()`** (imported from `InterfaceLib`) → minimal-standard LCG `seed = seed * 16807 mod (2^31 − 1)`. Fully reproducible; replicate exactly for determinism + netcode.
* **Timing/input:** `TickCount` (60 Hz fixed tick), `GetKeys`/`Button` (keyboard state → input bitmask). No `MathLib` → integer math (good for determinism).
* **Audio is QuickTime MIDI**, not trackers: music movies live in `Step On It!  Movies/` (`Cminor`, `spooky`, `green wins`, …; "thin" = Light Music variants); SFX are `snd ` resources. Uses `QuickTimeLib`.
* **Reference oracle:** the original runs in an emulator; use it to capture ground-truth memory/behavior to verify each ported function.

## 3. System Architecture (Visualized)

```mermaid
graph TD
    subgraph "Godot 4 (Front-End Presentation)"
        UI[Input: Local + WebRTC Netcode]
        M_AUDIO[AudioStreamPlayer: Remastered OGGs]
        M_MAP[Godot Map Editor UI]from PowerPC PEF
        
        subgraph "Visual Layers (The D2R Toggle)"
            V_RETRO[CanvasLayer: 1996 Original Assets]
            V_MODERN[CanvasLayer: 4K Remastered Assets]
            V_SHADER[Fragment Shader: Ted's Custom Color]
        end
    end

    subgraph "The Bridge"
        GDEXT[godot-rust / gdext]
    end

    subgraph "Headless Rust Core (Decompiled Engine)"
        R_STATE[(shared_symbols.json)]
        R_PHYSICS[Physics Solver & 3-Player State]
        R_GRID[Grid, Blocks & Chain Reactions]
        R_AI[Enemy Bestiary AI]
    end

    UI --> |Input Bitmasks| GDEXT
    M_MAP --> |Level JSON| GDEXT
    GDEXT --> |Tick()| R_PHYSICS
    GDEXT --> |Tick()| R_GRID
    GDEXT --> |Tick()| R_AI
    
    R_PHYSICS --> |X/Y Transforms| GDEXT
    R_GRID --> |Block States| GDEXT
    
    GDEXT --> |Transforms| V_RETRO
    GDEXT --> |Transforms| V_MODERN
    GDEXT --> |Play SFX/Music| M_AUDIO
    V_MODERN --> V_SHADER

```

## 4. Project Lifecycle & Parallel Execution

### Phase 1: Asset Extraction, Discovery & Lore

* **Host Tooling:** `resource_dasm` (macOS/Linux tool → run via WSL or a from-source build) + **Ghidra** (JDK required) for decompilation.
* **Extraction target:** the `__MACOSX/._*` resource forks (data forks are empty). Rip `PICT`→PNG, `snd `→WAV, isolate the QuickTime music movies, and carve the `BORD` level resources from `SOI Boards`.
* **Discovery:** load the **PowerPC PEF** (`Step On It!™` data fork) into Ghidra (native PEF loader auto-detects PPC), apply Mac Toolbox / Universal Interfaces data types, and export decompiled C + named CFM imports + the call graph into the shared knowledge base.
* **Dictionary Setup:** Auto-populate `shared_symbols.json` with canonical naming conventions.

### Phase 2: Rust Decompilation (behavior-verified, per subsystem)

* Port function-by-function from Ghidra's **PPC pseudocode** into Rust, preserving integer/fixed-point math and the `Random()` LCG exactly. Reverse the core structs (player, enemy, grid cell) and the `BORD` format first.
* **Verification loop (required):** for each function, capture inputs/outputs from the emulator (breakpoint + memory snapshot), run the Rust port on the same inputs, and diff until they match. This replaces "byte-matching" with provable behavioral equivalence.
* To avoid concurrent-write races, each domain writes its **own** symbol file (`symbols.physics.json`, `symbols.grid.json`, `symbols.enemies.json`); the Manager merges into `shared_symbols.json`.
* **Agent_Physics:** Movement, jump arcs, gravity, expanded 3-Player state array.
* **Agent_Grid:** Grid/`BORD` parsing, White Block create/destroy, chain reactions, Clock/Time panels, JSON level loading.
* **Agent_Bestiary:** Enemy state machines (Ant, Ostrich, Hippo, Piggy, Wheelie, Beenie) incl. spawn Start/Spawn delays.

### Phase 3: Peripheral Engine Building (Concurrent)

* **Graphics:** Local AI upscaling creating 4K environmental assets. A grayscale Ted sprite is generated for Godot shaders.
* **Audio:** QuickTime MIDI music movies and `snd ` SFX are isolated for modern DAW re-rendering.
* **Godot Bridge:** `gdext` compiles the Rust core into a Windows `.dll` first; Web `.wasm` is a deferred stretch goal (experimental gdext web export).

### Phase 4: Multiplayer & Map Editing

* Godot handles the WebRTC handshakes. The **lockstep** network layer sends only a 1-byte input bitmask per player, per tick; all peers advance the deterministic core in step. (Rollback with prediction/resim can be layered on later.)
* The runtime Godot map editor saves tile coordinates directly to JSON (mirroring the reversed `BORD` struct), bypassing the legacy Mac OS format.
