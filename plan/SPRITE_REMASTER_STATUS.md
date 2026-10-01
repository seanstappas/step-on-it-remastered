# Sprite Remaster — status / claim board

Coordination for **parallel** sprite remastering. Follow [SPRITE_REMASTER_PROCESS.md](SPRITE_REMASTER_PROCESS.md).
Ready‑to‑dispatch per‑agent prompts: [SPRITE_REMASTER_AGENT_PROMPTS.md](SPRITE_REMASTER_AGENT_PROMPTS.md).
**Claim a family** (edit its row: set `Status` → `CLAIMED (<agent-id>)`) **before** starting; set `DONE` when
published. Never pick a `CLAIMED`/`DONE` row. One family per agent.

Class: **A** spinning prop · **B** static/simple prop · **C** HUD/text · **D** flat cel character.
Only **A/B** get 3D; **C/D** stay 2D (UHD / Times‑Bold). See the classification rationale in
[3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md).

**Frame-matched 3D (the publishing path since 2026-09-22):** a family is DONE only when its
`frames.json` is `published` and `py tools/soi3d/framematch.py --check` passes (gate stage 5); see
[SPRITE_REMASTER_PROCESS.md §F](SPRITE_REMASTER_PROCESS.md). Published (1079 frames): `block_sprites` (150), `robo_sprites` (80), `BP_sprites` (68), `GP_sprites` (68), `BP_run` (48), `GP_run` (48), `spin_ind_shoe` (30),
`teeth_sprites` (49), `walker_body` (48), `smiley_sprites` (48), `Stop_Go_sprite_family` (40), `hippo_sprites` (32),
`piggy_sprites` (32), `beenie_shot_l`/`_u`/`_r` (48), `disk_sprites` (24), `cannon_ball` (20), `spinner_sprites` (16), `walker_bolt` (16),
`bigger_mblock` (15), `master_egg` (15), `master_compound` (15), `master_giftbox` (15), `master_cluster` (15),
`transporter` (15), every goody (51: the earlier 15 plus `goody_props` 11, `goody_arrows` 10, `goody_switch` 10,
`goody_misc` 1, `goody_gift` 1, `goody_gear` 2, `goody_shoe` 1), `spin_ind_shield` (30),
`weapons` (8), `block_question` (6), `emblem_hippo`/`_piggy`/`_ostrich`/`_smiley`/`_ant`/`_hammer`/`_teeth` (7, the spawner
blocks), `weapons_arrow` (2), `cannon_barrel` (2), `BP_cheer` (9, the player's cheer), `GP_cheer` (9, the green player's).
Published since (2026-09-27..30): `ostrich_sprites`, `ant_sprites`, `BP_tumble`/`GP_tumble`, `hammer_walk`,
`hammer_swing_l`/`_r`, `beenie_char`, `Gargoyle_sprites` -- 1433 frames in 65 families; the table in
[SPRITE_REMASTER_PROCESS.md §F](SPRITE_REMASTER_PROCESS.md) is the current list. WIP with a failing-gate note:
`knight_sprites`, `beenie_shot_d`. The stills in the table below are look-dev. Characters are no longer "keep 2D": the
Hippo and Piggy passed the frame gate with rigged procedural models (`quadruped.py`).

| Family (`extracted/sprites/…`) | Class | Status | Deliverables (`extracted/sprites_3d/…`) |
|---|---|---|---|
| `disk_sprites` | A | **DONE** | `disk_sprites/disk.png`, `disk_sprites/_verify/2d_vs_3d.{mp4,gif}` |
| `Stop_Go_sprite_family` | A | **DONE** | `Stop_Go_sprite_family/{stop,go}.png` |
| `block_sprites` | B | **DONE** | `block_sprites/{white,blue,green,question}.png` |
| `weapons` | B | **DONE** | `weapons/spiral.png` (+ `spiral_texture.png`) |
| `spinner_sprites` | A | **DONE** (frame-matched) | `spinner_sprites/frames.json` |
| `spin_ind_sprite_family` | A | OPEN | — |
| `goody_sprites` | A/B | OPEN | — (multi‑object sheet: split per goody) |
| `master_s_objects` | B | OPEN | — (red/blue diamond gem) |
| `cannon_sprites` | B | OPEN | — (striped ball) |
| `transporter` | B | **DONE** (frame-matched) | `transporter/frames.json` |
| `bigger_mblock` | B | **DONE** (frame-matched) | `bigger_mblock/frames.json` |
| `blocks` | B | OPEN | — (verify vs `block_sprites`; may reuse builder) |
| `smiley_sprites` | B | **DONE** (frame-matched) | `smiley_sprites/frames.json` |
| `extra_s` | C | keep 2D | HUD bitmap / Times‑Bold (not 3D) |
| `BP_sprites`, `GP_sprites` | D | **DONE** (frame-matched rig) | `BP_/GP_sprites`, `_run`, `_tumble`, `_cheer` (`kid.py`) |
| `bp_30fps_all_but_jump`, `bp_jump_30fps` | D | unused | not drawn by the game |
| `hippo_sprites`, `piggy_sprites`, `teeth_sprites` | D | **DONE** (frame-matched) | `<family>/frames.json` (`quadruped.py`, `teeth.py`) |
| `ant_sprites`, `beenie_sprites`, `Gargoyle_sprites`, `hammer_sprites`, `ostrich_sprites`, `robo_sprites`, `walker_sprites` | D | **DONE** (frame-matched rig) | `<family>/frames.json`; `beenie_sprites` f50-f65 (`beenie_shot_d`) still WIP |
| `knight_sprites`, `ant_stride_test` | D | OPEN (frame-matched rig) | `knight_sprites/frames.json` WIP; `ant_stride_test` unused by the game |

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
