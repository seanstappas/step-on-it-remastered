# 3D‑Animated Remaster — quick plan

**Idea (user):** in *remaster mode* (`--3d`), sprites under `extracted/sprites/` that **move/spin in place**
should be rendered as **live 3D objects animated in‑game**, not flat 2D frames. Many sprites already
animate by cycling frames (the **disk spins**, the **Stop/Go octagon spins/flips inside its frame**,
spinners rotate); a real 3D model that spins looks cleaner than any single baked frame and never goes
lopsided. This complements the gated design doc [3D_SPRITE_REMASTER_DESIGN.md](3D_SPRITE_REMASTER_DESIGN.md)
(§12: **procedural 3D wins for props; 2D UHD stays for flat cel characters**).

## 1. Classify every `sprites/` sheet
| Class | Sheets | Remaster treatment |
|---|---|---|
| **A. Spinning props** (rotate in place) | `disk_sprites`, `Stop_Go_sprite_family` (inner octagon), `spinner_sprites`, `spin_ind_sprite_family`, coins/goodies in `goody_sprites` that spin | **3D model + live spin** (SubViewport). Highest value. |
| **B. Static / simple props** | `block_sprites`, `blocks`, `bigger_mblock`, `weapons`, `cannon_sprites`, sign frame, `transporter` | **3D model, static or simple bob/pulse**; or procedural (signs done). |
| **C. HUD / text** | `extra_s` (Score/Bonus/digits/GAME OVER) | **Keep 2D bitmap** (pixel‑exact) OR re‑render in **Times Bold** (the game font, id 20). Not spun. |
| **D. Flat cel characters** (walk/run, directional) | players (`BP/GP/bp_*`), `knight`, `Gargoyle`, `robo`, `hammer`, `walker`, `teeth`, `hippo`, `ostrich`, `piggy`, `ant`, `beenie`, `smiley` | **Keep 2D UHD** (empirical: image‑to‑3D fails on flat cel). Optional Phase‑2 hand‑rigged models. |

Only **Class A/B** get 3D in Phase 1. Class C/D fall back to the shipped 2D UHD set (so `--3d` is never worse).

## 2. Runtime architecture (Godot 4.3) — one animated object
```
SubViewport (own World3D, transparent bg, e.g. 128×128)
 └─ pivot: Node3D          # spun in _process(delta): pivot.rotate_z(delta * speed)
     └─ MeshInstance3D     # imported <sheet>.glb (disk, sign octagon, coin…)
 ├─ Camera3D (ORTHOGRAPHIC, looks down −Z, ortho_scale ≈ 2.15)   # matches soi3d setup_scene
 └─ 2× DirectionalLight3D  # top‑left key + soft lower‑right fill  # matches soi3d setup_scene
Sprite2D on the board  → texture = SubViewport.get_texture()
```
- **Spin** = rotate the `pivot` node each frame → smooth at any FPS, always symmetric.
- **Tilt** the pivot to the board's viewing angle once (the reason the *source* frames look skewed).
- Lights/camera mirror [tools/soi3d/common.py](../tools/soi3d/common.py) `setup_scene()` so 3D matches the stills
  — see **§2a** for the full per‑sprite tonemap/lights/glint mapping.
- Cost: a handful of tiny viewports; pool/scale them. Respect **reduce‑motion** (freeze spin) per §5 a11y.

### 2a. Re‑establishing the Cycles look per sprite (tonemap · lights · glint)
A GLB carries **geometry + PBR materials**, but **not** the Cycles render look — the `Standard` view transform,
`diffuse_bounces=0`, the `setup_scene` lights, and the post‑composited glint (`apply_glint.py`) are all
**renderer‑level**, not in the mesh. Godot re‑establishes them, and because **each spun sprite is its own
`SubViewport` with its own `World3D`**, every one is **independently controllable per sprite** — nothing leaks
between props:

| Blender (`tools/soi3d/…`) | Godot per‑sprite equivalent | Where (inside that sprite's SubViewport) |
|---|---|---|
| `view_transform='Standard'` | `Environment.tonemap_mode = LINEAR` (≈ Standard, no filmic curve) | a `WorldEnvironment` node |
| `diffuse_bounces=0` | **no GI** (no SDFGI/VoxelGI) + a small constant `Environment.ambient_light` = `world_strength` | same `Environment` |
| key + fill SUN (`setup_scene`) | 2× `DirectionalLight3D` (top‑left key, lower‑right fill); sun `angle` → light `angular_distance` | child nodes |
| disk's extra POINT catch light | an `OmniLight3D` in that viewport only | per‑sprite |
| material emission (disk green) | `emission` on that mesh's material | per‑sprite (GLB / `material_override`) |
| `apply_glint.py` (post) | a **screen‑locked** glint overlay (below) | per‑sprite, opt‑in |

**Pattern — shared baseline + per‑sprite override.** `setup_scene()` is *identical* for every sprite, so the
reusable `Spun3DSprite.tscn` configures that look **once** as the default; per‑sprite you override only what
differs. It's not hypothetical — the **disk already differs** (lifted ambient `world_strength=0.19`,
`fill_energy=0.16`, an extra catch light, material emission, **and** a glint), while **signs/blocks** take the
plain defaults with no glint.

**Glint** is screen‑locked (stays top‑left as the mesh spins → a 2D pass, not 3D lighting): either an
additive/`screen`‑blend `TextureRect` pinned over the `Sprite2D`, or a `canvas_item` shader on the `Sprite2D`
adding the highlight at a fixed UV. Same intent as `apply_glint.py`.

**Contract — carry the look knobs in `meta.json`** so the *same numbers* drive the Blender validation render and
the Godot runtime (then “validate live vs stills” is just confirming they match). Recommended optional block
(the disk's values):
```json
"look": {
  "tonemap": "linear",
  "ambient": 0.19,
  "fill": 0.16,
  "catch_light": { "type": "omni", "pos": [-2.9, 3.4, 2.3], "energy": 450, "size": 0.35 },
  "emission": [0, 92, 0],
  "glint": { "on": true, "cx": 0.32, "cy": 0.20, "rad": 0.14, "color": [165, 250, 165], "core": 0.55 }
}
```
`ambient` == `setup_scene` `world_strength`; `fill` == `fill_energy`; `catch_light` = the disk's extra Omni;
`emission` = faint sRGB green (keeps the shadow dark‑GREEN, not black); `glint` = the `apply_glint.py` params.
Static/plain props omit `look` (take defaults) or set `glint.on = false`. **The GLB guarantees the *shape*; the
`look` block guarantees the *look*.**

## 3. Asset pipeline
1. **Build models procedurally** in Blender (add a `tools/soi3d/builders/<family>.py`): `disk`, `sign` builders
   exist; add `coin`, `spinner`, etc. Procedural = crisp, controllable, no ML weights (design §12).
2. **Export GLB** — add a `glb <out.glb> <kind>` mode under `tools/soi3d/` (`bpy.ops.export_scene.gltf`).
   Emit `godot_project/assets/models/<kind>.glb` (+ SHA256 recorded).
3. **Godot import** — one reusable scene `Spun3DSprite.tscn` (the §2 rig) with export vars:
   `model: PackedScene`, `spin_deg_per_s`, `tilt_deg`, `px`, plus the **look** overrides read from `meta.json`
   (§2a: `ambient`, `fill`, `catch_light`, `emission`, `glint`) — each defaulting to the shared `setup_scene` value.
4. **Stills fallback** — the same models render the static `extracted/sprites_3d/*.png` (already produced)
   for tooling / non‑runtime use.

## 4. Integration with `game.gd`
- Existing flags: `--hd` → `sprites_hd`, `--uhd` → `sprites_uhd` (repoint `_sprites_dir`, set `_sprite_scale`).
- Add **`--3d`** (remaster): for **Class A/B** indices, instantiate `Spun3DSprite` instead of a 2D `Sprite2D`;
  for **Class C/D** indices, use the `sprites_uhd` frame (no holes → no loader regression, per design §fill).
- A per‑sheet table (`kind → {class, glb, spin_dps, tilt}`) drives the choice; reuse `_folder_index` parsing.
- **Honours the live D2R toggle (MASTER_PLAN).** 3D is bound to the runtime display `_mode` (the **M** key /
  `--mode=`), NOT baked in at launch: the `Spun3DSprite` viewports stay **alive + pooled** and keep spinning;
  the sprite‑draw path just picks **which texture to blit per frame** — the 2D sheet frame when `_mode==0`
  (Retro), the SubViewport texture when `_mode==1` (Remastered). So pressing **M** flips 2D↔3D **instantly**
  (O(1) per prop, no reload; the sim is untouched — the visual layer is decoupled from the lockstep gameplay).
  `--3d` just sets the initial/default mode + enables the 3D path.
- Keep the HUD (`_draw_hud`) on the 2D `extra_s` blit (pixel‑exact) — or a Times‑Bold variant.

## 5. Phased rollout
- **P0 (done):** procedural disk + Stop/Go signs; stills in `extracted/sprites_3d/`; `verify_3d.py` metrics.
- **P1:** GLB export + `Spun3DSprite.tscn` + wire the **disk** as a live spinning 3D goody behind `--3d`.
- **P2:** extend to the other **Class A** spinners (sign octagon flip, spinner, coins); tune tilt/speed to
  match the original cadence (frame count → deg/frame).
- **P3:** Class B static props; evaluate Phase‑2 rigged 3D **characters** (UniRig) — big effort, optional.

## 6. Open questions
- **Spin cadence** per sheet: derive `deg/frame` from the source frame count × game tick (measure per sheet).
- **Sign flip (RESOLVED):** the inner octagon is a **Y‑axis flip** — it rotates **edge‑on** (the montage shows the
  thin vertical sliver mid‑flip at f04–f06) from the Stop face to the Go face; the 38‑frame sheet is that ~8‑frame
  flip × **5 colour groups**. In‑game the flip plays on a **switch‑step event** (`game.gd` `_sg_anim` interpolates
  the run), not free‑running — model it as a flipping octagon (the two published stills are just the endpoints).
- **Viewport budget**: how many spinners on screen at once → pool size / shared viewport atlas.
- **Look match**: confirm Godot `tonemap = LINEAR` + the §2a ambient/lights/emission reproduce the Cycles stills
  (validate the *live* SubViewport output against each family's `_verify` stills; tune the per‑sprite `look` block).
- **Distribution/licensing**: procedural models ship freely; keep any ML‑derived meshes out of the build (§7).
