# Sprite Remaster — status / claim board

Coordination for **parallel** sprite remastering. Follow [SPRITE_REMASTER_PROCESS.md](SPRITE_REMASTER_PROCESS.md).
Ready‑to‑dispatch per‑agent prompts: [SPRITE_REMASTER_AGENT_PROMPTS.md](SPRITE_REMASTER_AGENT_PROMPTS.md).
**Claim a family** (edit its row: set `Status` → `CLAIMED (<agent-id>)`) **before** starting; set `DONE` when
published. Never pick a `CLAIMED`/`DONE` row. One family per agent.

Class: **A** spinning prop · **B** static/simple prop · **C** HUD/text · **D** flat cel character.
Only **A/B** get 3D; **C/D** stay 2D (UHD / Times‑Bold). See the classification rationale in
[3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md).

| Family (`extracted/sprites/…`) | Class | Status | Deliverables (`extracted/sprites_3d/…`) |
|---|---|---|---|
| `disk_sprites` | A | **DONE** | `disk_sprites/disk.png`, `disk_sprites/_verify/2d_vs_3d.{mp4,gif}` |
| `Stop_Go_sprite_family` | A | **DONE** | `Stop_Go_sprite_family/{stop,go}.png` |
| `block_sprites` | B | **DONE** | `block_sprites/{white,blue,green,question}.png` |
| `weapons` | B | **DONE** | `weapons/spiral.png` (+ `spiral_texture.png`) |
| `spinner_sprites` | A | OPEN | — |
| `spin_ind_sprite_family` | A | OPEN | — |
| `goody_sprites` | A/B | OPEN | — (multi‑object sheet: split per goody) |
| `master_s_objects` | B | OPEN | — (red/blue diamond gem) |
| `cannon_sprites` | B | OPEN | — (striped ball) |
| `transporter` | B | OPEN | — |
| `bigger_mblock` | B | OPEN | — (large block variant; reuse `build_block`) |
| `blocks` | B | OPEN | — (verify vs `block_sprites`; may reuse builder) |
| `smiley_sprites` | B? | OPEN | — (red ball + face — 3D candidate; else keep 2D) |
| `extra_s` | C | keep 2D | HUD bitmap / Times‑Bold (not 3D) |
| `BP_sprites`, `GP_sprites`, `bp_30fps_all_but_jump`, `bp_jump_30fps` | D | keep 2D UHD | players — image‑to‑3D fails |
| `ant_sprites`, `ant_stride_test`, `beenie_sprites`, `Gargoyle_sprites`, `hammer_sprites`, `hippo_sprites`, `knight_sprites`, `ostrich_sprites`, `piggy_sprites`, `robo_sprites`, `teeth_sprites`, `walker_sprites` | D | keep 2D UHD | flat cel characters |

## Shared‑file etiquette
- `tools/soi3d/builders/<family>.py`: your OWN module (auto‑discovered) — no shared render file to edit.
  Shared helpers live in `tools/soi3d/common.py`; only *add* to it (small, serial) if genuinely reusable.
- Outputs: only inside your family's folder `extracted/sprites_3d/<family>/` — write your own `meta.json`
  (never the shared `manifest.json`; it's GENERATED via `py tools/soi3d/build_sprite_manifest.py`). Process doc §5b.
- `game.gd` runtime wiring (`--3d`, P1+) is a **single serialized step** — don't edit in parallel.

## Pending pipeline (not yet built)
- **P1:** GLB export from `tools/soi3d/` (a `glb` mode/builder) + a reusable Godot `Spun3DSprite.tscn` (SubViewport + ortho
  Camera3D + top‑left key/fill lights mirroring `setup_scene`, pivot spun in `_process`), gated behind `--3d`.
  See [3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md) §2–4.
