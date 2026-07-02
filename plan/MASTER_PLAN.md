# Master Plan & Design Document: Project "Step On It!" Remaster

## 1. High-Level Requirements
* **Target Platforms:** Standalone Windows desktop (`.exe`) and web-ready assembly (`HTML5/WASM`).
* **Core Engine:** A headless, zero-dependency **Rust** (`no_std`) backend representing a 100% exact simulation of the 1996 Mac OS game logic.
* **Front-End Engine:** Godot 4, acting strictly as a high-performance visual and input puppet.
* **The "D2R" Toggle:** Instant real-time switching between native 1996 4:3 graphics and modern 4K widescreen assets.
* **Online Multiplayer:** P2P WebRTC online co-op and competitive play (expanded to 3 players) mapped onto a deterministic engine core using rollback netcode.
* **Extended Features:** In-engine Godot Map Editor (exporting to JSON), remastered tracker/MIDI audio, and fragment shaders for infinite customizable player colors.

## 2. Canonical Game Elements (Baseline Dictionary)
* **Protagonist:** Ted (robotic man).
* **Objective:** Acquire the Key and exit through the Red Door.
* **Mechanics:** Ted creates White Blocks to navigate and trap enemies. Levels feature Chain Reactions and Clock/Time Panels.
* **Weapons:** Magic Arrow (straight line), Magic Ball (rolls along walls).
* **Goodies:** Magic Shoes (speed), Shield (invulnerability), Thunder Balls (kills reproducers), Coins, Gold Bars, Gems.
* **The Nasties:** Ant (50 pts), Ostrich (100 pts), Hippo (200 pts), Piggy (250 pts), Wheelie (300 pts), Beenie (750 pts).

## 3. System Architecture (Visualized)

```mermaid
graph TD
    subgraph "Godot 4 (Front-End Presentation)"
        UI[Input: Local + WebRTC Netcode]
        M_AUDIO[AudioStreamPlayer: Remastered OGGs]
        M_MAP[Godot Map Editor UI]
        
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

### Phase 1: Asset Extraction & Lore Discovery

* **Host Tooling:** `resource_dasm` running natively on Windows.
* **Target:** Extract `CODE` forks to a flat binary. Rip `snd `, MIDI, and `PICT` resources.
* **Dictionary Setup:** Auto-populate `shared_symbols.json` with the canonical naming conventions.

### Phase 2: Parallel Rust Decompilation

* Using the **Shared Knowledge Base** pattern, AI subagents will operate concurrently on the flat binary, exporting pure, deterministic `no_std` Rust logic.
* **Agent_Physics:** Movement, gravity, expanded 3-Player memory allocation.
* **Agent_Grid:** Grid parsing, chain reactions, JSON level loading.
* **Agent_Bestiary:** Enemy state machines.

### Phase 3: Peripheral Engine Building (Concurrent)

* **Graphics:** Local AI upscaling creating 4K environmental assets. A grayscale Ted sprite is generated for Godot shaders.
* **Audio:** Legacy tracker/MIDI files are isolated for modern DAW rendering.
* **Godot Bridge:** `gdext` is configured to compile the Rust core into Windows `.dll` and Web `.wasm`.

### Phase 4: Multiplayer & Map Editing

* Godot handles the WebRTC handshakes. The deterministic network layer only sends a 1-byte input bitmask per player, per frame.
* The runtime Godot map editor saves tile coordinates directly to JSON, bypassing the legacy Mac OS format.
