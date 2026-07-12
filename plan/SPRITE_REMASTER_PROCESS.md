# Sprite Remaster Process — generic playbook (for parallel agents)

Turn the original 2D pixel sprites in `extracted/sprites/<family>/` into faithful, higher‑fidelity
**remaster‑mode** assets: **procedural 3D** (Blender) for geometric props, **2D UHD** for flat cel
characters — validated by **numbers**, not by eye.

**Who this is for:** any agent assigned **one sprite family**. Several agents run this in parallel, one
family each. Follow it end‑to‑end, publish to *your* family's paths, and don't touch another family's files.

Companion docs: the validation method [SPRITE_FIDELITY_VALIDATION.md](SPRITE_FIDELITY_VALIDATION.md);
the runtime/classification plan [3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md); the live
claim board [SPRITE_REMASTER_STATUS.md](SPRITE_REMASTER_STATUS.md); ready‑to‑dispatch parallel prompts
[SPRITE_REMASTER_AGENT_PROMPTS.md](SPRITE_REMASTER_AGENT_PROMPTS.md).

---

## 0. Golden rules (read first)
- **Procedural 3D wins for geometric props** (disk, signs, blocks, balls, gems). **Image‑to‑3D AI fails on
  flat cel art** → keep characters as **2D UHD**. Don't try to 3D‑ify walk/run cel sprites.
- **Measure, don't guess.** Inspect the source **frame‑by‑frame** and the other reference art (HD upscales,
  gameplay video, screenshots — see §4.1) *before* modelling; sample exact RGBs. Validate *every* render with
  `verify_3d.py`. Measure spin direction/speed by cross‑correlation, angle by an IoU sweep — never by eye.
- **Numbers + the overlay together.** Numbers miss shape nuances (blade thickness, a pinwheel sweep); the
  side‑by‑side/edge overlay catches them. Use both.
- **Faithful to the source, but the user is the authority.** Match the original, but when the user asks for a
  deviation (e.g. "make the disk centre the ball's green, not the source's dark square"), their call wins.
- **Iterate on flagged metrics only.** The `<-- off` markers tell you exactly what to fix; don't churn.

---

## 1. Environment
- **Blender 4.2.3 LTS** headless: `D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe`.
  Run: `& $b --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]`; success prints `RENDERED`.
  - **Cycles / CPU** (EEVEE‑Next crashes compiling GPU shaders in `--background` on many drivers).
  - **`view_transform = 'Standard'`** in `setup_scene` — NOT Blender 4.x's default **AgX** (it crushes
    highlights and desaturates; the #1 cause of "washed" colours).
- **Python** with `Pillow` + `numpy` (system `py`). **ffmpeg + ffprobe** on PATH (for MP4).
- **Repo tools** (all under `tools/soi3d/`): [render3d.py](../tools/soi3d/render3d.py) (CLI dispatcher —
  per‑sprite builders in `soi3d/builders/`, shared code in `soi3d/common.py`), [verify_3d.py](../tools/soi3d/verify_3d.py)
  (fidelity metrics), [apply_glint.py](../tools/soi3d/apply_glint.py) (view‑locked shine), and
  [make_sprite_anim.py](../tools/soi3d/make_sprite_anim.py) (2D‑vs‑3D gif+mp4).
- **Scratch:** render raw frames to a per‑agent dir (`D:\SOI-tools\3d_proto\<family>\`); only finals land in the repo.

---

## 2. Parallelization — claim a family, avoid conflicts
- **Work unit = one family** (`extracted/sprites/<family>/`). See the classification table (§3 / the plan doc).
- **Claim it** in [SPRITE_REMASTER_STATUS.md](SPRITE_REMASTER_STATUS.md) (agent id + family + status) before
  starting. One family per agent; don't pick a `CLAIMED`/`DONE` row.
- **Non‑conflicting outputs:** you only ever create files **inside your own family folder**
  `extracted/sprites_3d/<family>/` — its `meta.json`, stills, model, its own `_verify/`. The aggregate
  `extracted/sprites_3d/manifest.json` is **generated** from every family's `meta.json`
  (`py tools/soi3d/build_sprite_manifest.py`); you **never write it directly**. Never touch another family's folder.
  See the standard layout (§5b).
- **No shared render code either.** Each family is its OWN module `tools/soi3d/builders/<family>.py`
  (a `build_<family>()` + an `@register("<family>")` render fn); it's **auto‑discovered**, so you add a sprite
  by **dropping a new file** — nothing shared to edit. Reuse `tools/soi3d/common.py` for shared helpers; only
  *add* to `common.py` (small, serial) if a helper is genuinely reusable.
- **Never edit `game.gd` in parallel** — the `--3d` runtime wiring (P1+) is a single, serialized step.

---

## 3. Classify your sheet → treatment
| Class | Examples | Treatment |
|---|---|---|
| **A. Spinning props** | `disk_sprites`, `Stop_Go` inner octagon, `spinner_sprites`, spinning `goody_sprites` | **3D model + live spin** (highest value). Render stills + a spin animation. |
| **B. Static / simple props** | `block_sprites`, `weapons` (spiral), `cannon_sprites`, `master_s_objects` gem, `transporter` | **3D model**, static or simple bob/pulse. |
| **C. HUD / text** | `extra_s` (Score/Bonus/digits/GAME OVER) | **Keep 2D bitmap** (pixel‑exact) or re‑render in **Times Bold**. Not 3D. |
| **D. Flat cel characters** | players, `knight`, `Gargoyle`, `robo`, `hammer`, `hippo`, `smiley`, … | **Keep 2D UHD.** Image‑to‑3D fails here. |
Only **A/B** get 3D. A/B done so far: disk, Stop/Go signs, blocks (white/blue/green/?), weapons spiral.

---

## 4. The per‑family workflow

### 4.1 Survey the source — look at EVERY frame, and the other reference art
Read the shape and the motion off the pixels **and** the reference material — never guess either.

**A. Frame‑by‑frame inspection (shape + movement)**
- **Montage ALL frames** of the family (upscaled NEAREST, labelled with frame numbers) to see the whole
  animation cycle at once and read the motion — in‑plane **spin** vs 3D **tumble** vs **flip** vs walk cycle.
  Reuse [tools/montage_sprites.ps1](../tools/montage_sprites.ps1) (`-Folder <dir> -Out sheet.png -Scale 8`)
  or [tools/sprite_sheet.py](../tools/sprite_sheet.py). Known so far: the **disk tumbles**, **Stop/Go flips** —
  know this before modelling.
- **Zoom a single frame / region** at 12–34× NEAREST to read fine structure the 32² hides (the disk centre is
  a dark **square**; the sign octagon is **point‑top**; the block centre is **recessed**).
- **Pixel‑class ASCII grid + per‑channel (R/G/B) grids** of the centre/region to read the EXACT layout and
  RGBs — which pixels are a distinct hub vs just a shadow; R‑vs‑G distinguishes olive from pure green.
- **Track motion numerically** frame‑to‑frame (§4.2) — don't eyeball direction or speed.

**B. Cross‑reference the OTHER assets — don't rely on the tiny 32² frame alone**
| Reference | Path | Read it for |
|---|---|---|
| **HD / UHD upscales** | `extracted/sprites_hd/<family>/`, `sprites_uhd/…` | a cleaner (antialiased, larger) read of the SAME shape — best first look. |
| **Gameplay video** | `refs/videos/*.mp4` / `*.mkv` (+ `frames/`, `montage.png`) | the sprite ACTUALLY MOVING in the real game — confirms spin direction/speed, tilt, cadence. Extract frames with ffmpeg if needed. |
| **In‑game screenshots** | `refs/images/board_*.png`, `main_screen.png`; `media/reference/real_board*.png` | the sprite IN CONTEXT — real scale, board tilt/perspective, neighbouring colours. |
| **cicn colour icons** | `extracted/cicn/` | higher‑detail icon versions of some props. |
| **PICT art** | `extracted/pict/`, `pict_hd/`, `pict_hd_v2/` | title/UI art — palette + styling cues. |
| **RE'd game docs** | `docs/original_game/graphics-and-audio.md` (+ siblings) | verified facts: font = **Times Bold** (id 20), palette, sheet layouts. |
| **Preview / spritesheets** | `extracted/preview/`, `media/reference/spritesheets/` | family overview sheets. |

- **Sample exact colours** (the mean *and* the lit/brightest values — light brightens your base), cross‑checked
  against the HD upscale so you're not fooled by a single 32² pixel.

### 4.2 Measure motion (spinners) — robustly
- **Direction + speed:** per consecutive frame, find the best‑fit rotation by **PIL‑rotating the colour mask
  and maximising IoU** with the next frame. Consistent sign = direction; median magnitude = deg/frame.
  (Arm‑peak/angle‑histogram detection is *too noisy* on 32‑px frames — don't rely on it.)
- **Static angle to match one frame:** **IoU sweep** — render the model at a range of spins, pick the spin
  with max colour‑mask IoU vs the source frame. This beats trying to read the arm angles.

### 4.3 Build procedurally — add `tools/soi3d/builders/<family>.py`
- Create **your own module** `tools/soi3d/builders/<family>.py` with a `build_<family>()` and an
  `@register("<family>")` render fn (parses argv after the mode, `args[0]`=out, calls `C.setup_scene`,
  returns out). It's **auto‑discovered** — no shared file to touch. Copy an existing builder (e.g.
  `builders/disk.py`) as a template.
- Reuse shared helpers from `tools/soi3d/common.py` as `C.`: `C._mat(name, rgba, rough, metal, spec, coat)`,
  `C._srgb(r,g,b)`, `C._box`, `C._text(font=)`, `C.setup_scene`, `C.DEFAULT_SIGN_FONT`, … Keep geometry that's
  unique to your sprite **in your module** (like `disk._half_cone_blade`, `sign._octagon`). Only add to
  `common.py` if a helper is genuinely shared (small, serial edit).
- **Match the exact source RGBs** you sampled. Use the **game font = Times Bold** for any lettering
  (`C.DEFAULT_SIGN_FONT`; reverse‑engineered: `TextFont(0x14)`=font id 20=Times + `TextFace(1)`=Bold).
- **Spinners are animated → model them SYMMETRIC** (even arm spacing). A single source frame is a lopsided
  spin phase; don't bake its uneven angles into a static model — match the *offset*, not the skew.
- Run it via the CLI: `… --python tools/soi3d/render3d.py -- <family> <out.png> [px] [args…]`.

### 4.4 Render + validate
```
& $b --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]   # -> RENDERED
py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--arm red] [--frac red] [--recess green] [--text] --out cmp.png
```
Iterate on the `<-- off` metrics **and** the overlay until IoU ≥ 0.85, colour ΔE ≤ 25, relief sign matches,
no `grey rim!`. Validate against the **exact** source frame the render replaces (for spinners, the phase you rendered).

### 4.5 (Spinners) build the 2D‑vs‑3D animation
1. Render N spin frames in a loop (`for i: … disk ren_i.png 400 0 0 <spin_i>`), applying `apply_glint.py`
   per frame if the sprite has a view‑locked shine.
2. **Same speed both sides:** set the 3D per‑frame rotation to the **measured 2D** rate + direction. Make the
   loop **one clean symmetric cycle** (e.g. 90° for a 4‑fold star) so it loops **seamlessly**.
3. Build the deliverables into your family's `_verify/` (standard layout, §5b):
   `py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/<family>/f*.png" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/<family>/_verify/2d_vs_3d`
   → a **dithered GIF** (no banding) + a **full‑colour MP4** (the high‑quality one).

### 4.6 Publish + record (standard layout — §5b)
- Publish into **your family folder** `extracted/sprites_3d/<family>/`:
  `<variant>.png` still(s), `<family>.glb` (the model the engine spins — P1), and
  `_verify/{cmp.png, positioning.png, 2d_vs_3d.gif, 2d_vs_3d.mp4}`.
  Also `_verify/vs_video.png` **if the prop is visible in `refs/videos/`** (extract frames with ffmpeg and
  montage beside the 3D — a motion/scale/colour check against the REAL game, not just the 32² sheet).
- **Write your family's own `extracted/sprites_3d/<family>/meta.json`** (class, **mode** [= your builder/CLI
  name], motion, stills, model, spin params, source, and **baseline** [source frame + still + verify flags];
  asset paths are **bare filenames**). This is *your* file only — no shared‑file contention. Then rebuild the
  aggregate: `py tools/soi3d/build_sprite_manifest.py` (it discovers every `meta.json`; never hand‑edit
  `manifest.json`).
- **Verify completeness:** run `py tools/soi3d/check_sprite_assets.py <family>` until it reports **COMPLETE**
  — it checks every required asset is present (meta, still, model, builder, `cmp`/`positioning`/`2d_vs_3d.gif`/`.mp4`)
  and re‑runs `verify_3d` against your `baseline`. Fix anything it lists `[MISS]`.
- Set your row in [SPRITE_REMASTER_STATUS.md](SPRITE_REMASTER_STATUS.md) to `DONE`.

---

## 5. Runtime & output layout (how the 3D actually reaches the screen)

### 5a. The engine renders the 3D LIVE from a 2D viewpoint — it does NOT bake sprite frames
We ship **one 3D model per prop** (`<family>.glb`), not a stack of pre‑rendered sprite files like the
original. At runtime (Godot, the `--3d` path, P1) the engine spins that model **live** and renders it through
an **orthographic** camera into a 2D texture — so from the player's flat top‑down view it reads exactly like a
spinning sprite, but it's a real 3D object (smooth at any framerate, never a lopsided single frame):
```
SubViewport  (own World3D, transparent, e.g. 128×128)
 └─ pivot : Node3D              # _process(delta): pivot.rotate_z(delta * spin_rad)   [tilt_deg applied once]
     └─ MeshInstance3D          #   loads <family>.glb
 ├─ Camera3D  ORTHOGRAPHIC, looking down −Z, ortho_scale ≈ 2.15    # == render3d.py setup_scene()
 └─ 2× DirectionalLight3D       # top‑left key + lower‑right fill   # == setup_scene() lights
Sprite2D on the board  ←  texture = SubViewport.get_texture()
```
This is the reusable **`Spun3DSprite.tscn`** described in
[3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md) §2–4. Match the camera/lights to `setup_scene`
so the live view matches your validated stills.
- **Motion params** (`spin_dps`, `spin_dir`, `tilt_deg`, `px`) come from `manifest.json`; set `spin_dps` to the
  cadence you **measured** off the 2D frames (§4.2), not a guess.
- **Static props** (Class B, no spin) are the same scene with the spin disabled — or just the still PNG if a
  live view buys nothing.
- **Fallback only if perf‑bound:** bake a spin sheet from the same model and play it as frames. Default is live.
- **Instant 2D↔3D toggle (the “D2R” button).** Because the viewport spins **continuously and independently**,
  switching between the 2D sprite and the 3D prop is just choosing which texture to blit that frame — so the
  live **M**‑key / `_mode` toggle (MASTER_PLAN's D2R toggle) flips 2D↔3D **instantly**, no reload. Keep the 3D
  viewports alive/pooled while in Retro so the flip stays instant.
- Honour **reduce‑motion** (freeze the spin) and **pool** the SubViewports.

### 5b. Standard output layout — one folder per source family (no shared‑file writes)
Everything published lives under `extracted/sprites_3d/`, keyed by the **source family folder name**. Each
family folder is **self‑describing** via its own `meta.json`, so parallel agents never write the same file:
```
extracted/sprites_3d/
  manifest.json                    # GENERATED aggregate the runtime reads (built from every meta.json) — DO NOT hand‑edit
  <family>/                        # disk_sprites/  Stop_Go_sprite_family/  block_sprites/  weapons/  …
    meta.json                      #   YOUR fragment: {class, motion, source, stills[], model, spin_dps/dir, tilt_deg, px} — asset paths are BARE names
    <variant>.png                  #   published still(s): disk.png ; or white/blue/green/question.png
    <family>.glb                   #   the model the engine spins live (P1)
    <extra>.png                    #   any baked asset the model needs, e.g. spiral_texture.png
    _verify/                       #   validation + preview only — NEVER shipped to the runtime
      cmp.png                      #     verify_3d overlay (source | render | edge | grey‑rim)
      positioning.png              #     angle / alignment guide (spinners)
      2d_vs_3d.gif  2d_vs_3d.mp4   #     comparison animation vs the 2D SHEET (GIF preview + MP4 quality)
      vs_video.png                 #     (optional) 3D vs REAL gameplay footage from refs/videos — motion/scale/colour sanity
  _verify/                         # CROSS‑family only: gallery.png, research_*.png, source_vs_render_*.png
```
- **You only ever create files inside your own `<family>/`.** The aggregate `manifest.json` is **built from all
  the `meta.json` fragments** by [tools/soi3d/build_sprite_manifest.py](../tools/soi3d/build_sprite_manifest.py) — run it
  after publishing (or in CI with `--check`). **Never hand‑edit `manifest.json`.**
- In `meta.json`, asset paths are **bare filenames** (`disk.png`, `disk.glb`); the builder prefixes them with
  `<family>/` so the aggregate is engine‑ready.
- The **runtime reads `manifest.json`** → `<family>/<family>.glb` + params. Stills and all `_verify/**` are
  reference/QA and are never loaded by the game.

---

## 6. Tool reference
| Tool | Purpose | Example |
|---|---|---|
| `render3d.py` | Thin CLI **dispatcher**; auto‑discovers the per‑sprite builders in `tools/soi3d/builders/*.py` (shared code in `tools/soi3d/common.py`). Modes: `mesh`, `disk`, `block`, `spiral`, `sign` + any you add. | `blender … -- disk out.png 512 0 0 -46` |
| `verify_3d.py` | Fidelity metrics + `source\|render\|edge\|grey‑rim` overlay. Flags: `--arm <col>` (arm angles), `--frac <col>` (element size), `--recess <col>` (sunken‑centre check), `--text`. | `py tools/soi3d/verify_3d.py src.png ren.png --arm red --out cmp.png` |
| `apply_glint.py` | Screen‑blend a soft, **view‑locked** highlight (correct because a real highlight stays put as the object spins). | `py tools/soi3d/apply_glint.py raw.png out.png` |
| `make_sprite_anim.py` | 2D‑vs‑3D side‑by‑side **GIF (dithered) + MP4 (full colour)**. | see §4.5 |
| `build_sprite_manifest.py` | **Assemble `manifest.json` from every `<family>/meta.json`** so parallel agents never share a file. `--check` = CI staleness gate. | `py tools/soi3d/build_sprite_manifest.py` |
| `check_sprite_assets.py` | **Completeness gate** for a family: checks meta/still/model/builder + `_verify/{cmp,positioning,2d_vs_3d.gif,2d_vs_3d.mp4}` present (motion‑aware) and re‑runs `verify_3d` vs the meta `baseline`. `--all` / `--strict`. | `py tools/soi3d/check_sprite_assets.py disk_sprites` |

---

## 7. Hard‑won rules & materials
- **Saturated colour with an in‑hue "shine":** matte faces (`spec=0`) + a **strong top‑left key SUN** →
  the shine is a bright *in‑hue* diffuse gradient, not a white wash. White specular / clearcoat / a bright
  world **desaturate** colours (esp. greens). Keep `world` dim and **`diffuse_bounces=0`** (kills red→green
  colour bleed and keeps hues pure).
- **Distinct specular glints don't render reliably** small — **composite them in POST** (`apply_glint.py`),
  view‑locked (top‑left), so they stay put as the object spins.
- **Relief needs a shadow.** A flat render reads as a sticker. Keep the top‑left key gradient + cast shadows.
- **A raised element ringing a lower centre will SHADOW that centre into a dark shape** (and ambient‑occlude
  it) — the recurring "dark square/hole" in the middle. To fix: make the centre **coplanar** with the ring,
  or fill/raise it, or accept a dark‑*green* (not black) shadow by lifting `world`/`fill` ambient. To stop a
  piece darkening an enclosed region entirely, disable its shadow ray: `obj.visible_shadow = False`.
- **Match the region's own material for "same colour as X."** When the user says the centre should be the
  ball's green, reuse the **ball material verbatim** — don't invent a tuned olive/emissive green (those read
  as "weird colour"). Shadows falling on it are fine; a different *hue* is not.
- **Sit props ON the sphere by lowering z** (planar) so the base tucks just into the surface — a flat plane
  can't perfectly hug a round ball (it either floats or "scoops"); conforming/curving it usually looks wrong.
- **GIF looks worse than the PNG** because GIF = 256‑colour palette → gradient **banding**. Fix with a shared
  adaptive palette + **Floyd‑Steinberg dither**, and ship an **MP4** as the quality version (both via
  `make_sprite_anim.py`).
- **Residual R/B on a matte colour** is edge anti‑aliasing (colour borders), not desaturation — check the
  region interior before chasing it.
- **Blocks:** the framed tiles are **raised frame + RECESSED colour centre** (carve a well; frame HIGH,
  centre LOW), not a raised inset. Solid tiles (white, `?`) are simple beveled cubes.

---

## 8. Anti‑patterns / traps (learned the hard way)
- Leaving **AgX** on → washed/desaturated everything. (Set `Standard`.)
- Trusting **arm‑peak angle detection** on 32‑px frames → wrong rotation. (Use an **IoU sweep**.)
- Spinning the 3D the **wrong way / too fast** → measure the 2D direction+rate (IoU cross‑corr), match it,
  and make the loop one seamless symmetric cycle.
- A **separate centre tile** on a ball → its flat edges catch light as a "bright square outline." Prefer the
  sphere itself (one object) unless the source truly has a distinct hub.
- **Baking a source frame's lopsided angles** into a static spinner. (Symmetric model + matched offset.)
- Chasing metric perfection past the point the **overlay** looks right — ship when numbers *and* eye agree.
