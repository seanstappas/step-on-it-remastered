# Sprite Remaster — categories & handling (POLICY A: faithful)

**Decision: Policy A (faithful).** Static props stay **static** — no invented spin/bob/idle motion. Only sprites
that actually move in the **original** get motion, and only the motion they really have.

**Motion source of truth** (in this order):
1. **`godot_project/scenes/game.gd`** — how the port draws it. A frame chosen by `tick_count()` (or an event
   timer) = **animated**; a **fixed** frame = **static**. (e.g. `_draw_cell` blits goodies at a fixed frame → static.)
2. **The source frames** `extracted/sprites/<family>/` — montage every frame and read the actual motion.
3. `tools/audit_sprite_motion.py` — a numeric cross‑check only (frame count ≠ in‑game animation).

**Parallel‑safe.** Every family/prop is an independent work unit. Create/edit **only** your own
`tools/soi3d/builders/<mode>.py` + `extracted/sprites_3d/<family>/` (3D) **or** `extracted/sprites_hd|uhd/<fam>/`
(2D). **Never** edit a shared file (`render3d.py`, `common.py`, the other `tools/soi3d/*.py`, another family's
folder, the generated `manifest.json`, `game.gd`, or any `plan/*.md`) — if one seems necessary, **stop and tell
the user**. Full guard‑rails + per‑agent prompts: [SPRITE_REMASTER_AGENT_PROMPTS.md](SPRITE_REMASTER_AGENT_PROMPTS.md).
Playbook: [SPRITE_REMASTER_PROCESS.md](SPRITE_REMASTER_PROCESS.md). Metrics: [SPRITE_FIDELITY_VALIDATION.md](SPRITE_FIDELITY_VALIDATION.md).

`$b = 'D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe'` in the commands below.

## Categories at a glance
| # | Category | Track | In‑game motion | Handling |
|---|---|---|---|---|
| **1** | **STATIC** | 3D | none (fixed frame) | one still + a **non‑spinning** GLB |
| **2** | **SPIN** | 3D | continuous rotation | 3D model spun **live** |
| **3** | **SEQUENCED** | 3D | a defined sequence (flip / build‑break / collapse / ring‑orbit / charge) | render the whole sequence; **loop** or **trigger** it |
| **4** | **2D‑CYCLE** | 2D UHD | walk / roll / charge cycles | keep 2D; **QA the upscales** (no Blender) |
| **5** | **2D‑HUD** | 2D | static glyphs | keep 2D; QA or re‑render in Times Bold |

## Master table — all 30 families
| Family | Cat | In‑game motion | Status |
|---|---|---|---|
| `disk_sprites` | 2 SPIN | Wheelie orb + rotating star (`ENEMY_SPIN 5`) | **DONE** ✓ |
| `spinner_sprites` | 2 SPIN | spinner trap spins (`ENEMY_SPIN 13`) | open |
| `spin_ind_sprite_family` | 2 SPIN? | rotating indicator — **confirm 3D vs 2D** (tiny 16×12) | open |
| `weapons` | 1 STATIC **+** 2 SPIN | Magic **Ball** = fixed frame (static); Magic **Arrow** = swirl **spins** | DONE (static ball still) |
| `cannon_sprites` | 1 STATIC **+** 2 SPIN | turret body (static) + **spinning** beach‑ball projectile | in progress |
| `Stop_Go_sprite_family` | **3 SEQUENCED** (flip) | **Y‑axis flip** Stop↔Go (edge‑on), on a switch step | stills done — **flip TODO** |
| `block_sprites` | 1 STATIC | fixed tile per type | **DONE** ✓ |
| `blocks` | 3 SEQUENCED (build/break) | spawn sparkle → solid → cracks | in progress |
| `bigger_mblock` | 3 SEQUENCED (collapse) — **reconcile** | agent: collapse into balls; `game.gd`: "creeper, pulsing block walks" | in progress |
| `goody_sprites` → `goody_*` | 1 STATIC | fixed icon per goody (atlas → split) | in progress (**fix `goody_coin`**) |
| `master_s_objects` | 1 STATIC | board treasures (confirm static) | open |
| `transporter` | 3 SEQUENCED (ring‑orbit, loops) | red energy rings orbit | in progress |
| `smiley_sprites` | 4 2D‑CYCLE (roll) | red face‑ball rolls (`ENEMY_ROLL 6`) — borderline 3D ball | open |
| `BP_sprites` `GP_sprites` `bp_30fps_all_but_jump` `bp_jump_30fps` | 4 2D‑CYCLE | player walk/run/jump/death | open |
| `ant_sprites` `ant_stride_test` `ostrich_sprites` `hippo_sprites` `piggy_sprites` | 4 2D‑CYCLE | walk cycles | open |
| `hammer_sprites` `beenie_sprites` `robo_sprites` `walker_sprites` `teeth_sprites` | 4 2D‑CYCLE | walk / action | open |
| `Gargoyle_sprites` `knight_sprites` | 4 2D‑CYCLE | shooter idle → charge | open |
| `extra_s` | 5 2D‑HUD | static glyphs (Score/Bonus/digits/GAME OVER) | open |

---

## 1. STATIC (3D) — fixed pose, NO motion
**Props:** the goodies (`goody_coin`, `goody_star`, `goody_clock`, `goody_potion`, `goody_mult`, `goody_1up`,
`goody_goldbar`, + any remaining: gem, shield, shoe, turtle, magnifier, thunderball), the block tiles
(`block_sprites` ✓, `blocks` idle tile), `master_s_objects` treasures, the `weapons` ball/pickup.

**GENERATE**
1. Model procedurally in **your own** `tools/soi3d/builders/<mode>.py` (copy `disk.py` for round shapes, `block.py`
   for tiles). Match the **exact** source RGBs (PROCESS §4.1/§4.3). Times Bold for any lettering.
2. Render **ONE** still (no spin args): `& $b --background --factory-startup --python tools/soi3d/render3d.py -- <mode> extracted/sprites_3d/<family>/<variant>.png 256`
   Apply `py tools/soi3d/apply_glint.py <raw> <out>` **only** if the source shows a fixed highlight.
3. `meta.json`: `"class":"B"`, `"mode":"<mode>"`, `"motion":"static"`, `"static":true`, `"model":"<mode>.glb"`,
   `"model_status":"pending-P1"`, `"px":256`, `"baseline":{source,still,flags}`. **No** `spin_dps`/`spin_axis`, **no** gif/mp4.

**TEST**
- `py tools/soi3d/verify_3d.py <source_frame> extracted/sprites_3d/<family>/<variant>.png [--recess col|--frac col|--text] --out extracted/sprites_3d/<family>/_verify/cmp.png` → iterate until **IoU ≥ 0.85, ΔE ≤ 25**, relief sign matches, no grey rim.
- `py tools/soi3d/check_sprite_assets.py <family>` → **COMPLETE** (static → gif/mp4/positioning are **not** required).

**DELIVER:** `meta.json`, `<variant>.png` still(s), `<mode>.glb` (P1), `_verify/cmp.png`.

---

## 2. SPIN (3D) — continuous rotation
**Props:** `disk_sprites` ✓ (template), `spinner_sprites`, `spin_ind` (confirm), the `weapons` **Arrow** swirl,
the `cannon` beach‑ball projectile.

**GENERATE**
1. Model **symmetric** (a single frame is a lopsided phase — match the *offset*, not the skew; PROCESS §4.3).
2. **Measure** spin direction + speed off the source by IoU cross‑correlation (PROCESS §4.2) — never by eye.
3. Render a spin **loop** (N frames): `... -- <mode> <ren_i>.png 400 0 0 <spin_i>`; apply `apply_glint.py` per frame
   if it has a view‑locked shine.
4. Build the comparison: `py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/<family>/f*.png" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/<family>/_verify/2d_vs_3d`
5. `meta.json`: `"class":"A"`, `"motion":"spin"`, `"spin_dps":<measured>`, `"spin_axis":"z"`, `"spin_dir":"cw|ccw"`, `"px":256`, `"baseline":…`.

**TEST**
- `verify_3d.py … --out _verify/cmp.png` (+ `_verify/positioning.png` angle guide).
- The **`2d_vs_3d.gif/.mp4`** must spin at the **same rate + direction** as the source and loop seamlessly.
- `check_sprite_assets.py <family>` → COMPLETE (animated → gif/mp4/positioning **required**).

**DELIVER:** still, `<mode>.glb`, `_verify/{cmp,positioning,2d_vs_3d.gif,2d_vs_3d.mp4}`, `meta.json`.

---

## 3. SEQUENCED (3D) — a defined animation sequence
**Props + kind:** `Stop_Go` (Y‑axis **flip**, triggered), `blocks` (**build/break**, triggered),
`bigger_mblock` (**collapse**, triggered — *reconcile, see Corrections*), `transporter` (**ring‑orbit**, loops).

**GENERATE**
1. Model the **mechanism** (e.g. a double‑faced octagon for the flip; a bar‑stack for the collapse; energy rings
   for the transporter). Match source RGBs.
2. Render the **full sequence** (N frames) reproducing the source cycle — e.g. the flip rotates about the vertical
   (**Y**) axis through **edge‑on** (0°→90° sliver→180° other face) matching the source's f02→f09 run.
3. `py tools/soi3d/make_sprite_anim.py … --out extracted/sprites_3d/<family>/_verify/2d_vs_3d` for the sequence.
4. `meta.json`: `"class":"A"`, `"motion":"<kind>"` (e.g. `flip`/`build-break`/`collapse`/`orbit`),
   `"loop":true|false` (true = plays continuously e.g. transporter; false = plays once on the game event),
   plus kind params (`flip_axis:"y"`, …). Stills = the meaningful key poses (e.g. the flip's Stop + Go endpoints).

**TEST**
- `verify_3d.py` against the **key frames** (flip: the Stop f02 **and** Go f09 endpoints; build/break: spawn/solid/cracked).
- The `2d_vs_3d.gif/.mp4` must match the **source sequence** frame‑for‑frame in timing.
- `check_sprite_assets.py <family>` → COMPLETE.

**DELIVER:** key‑pose still(s), `<mode>.glb`, `_verify/{cmp,positioning,2d_vs_3d.gif,2d_vs_3d.mp4}`, `meta.json`.

---

## 4. 2D‑CYCLE — cel characters / enemies (keep 2D UHD, no Blender)
**Families:** players (`BP/GP/bp_30fps/bp_jump`), `ant`, `ant_stride_test`, `ostrich`, `hippo`, `piggy`, `hammer`,
`beenie`, `robo`, `walker`, `teeth`, `smiley` (roll), `Gargoyle` + `knight` (shooters), plus the `creeper`/
`bigger_mblock` walk if it turns out to be the moving‑block enemy. Image‑to‑3D fails on flat cel art → stay 2D.

**GENERATE (the HD/UHD upscales already exist — VALIDATE + FINALIZE)**
1. QA: `py tools/qa_assets.py sprites extracted/sprites/<fam> extracted/sprites_hd/<fam>` (RGBA, size = k×source,
   alpha‑bbox, downscale‑back SSIM; writes a contact sheet; non‑zero exit on FAIL) + `py tools/upscale_sprites.py verify --folders <fam>`.
2. Fix flagged frames: `py tools/upscale_sprites.py upscale --folders <fam>`; re‑QA until clean.

**TEST:** `qa_assets.py` passes (SSIM ok) and the contact sheet reads clean; the walk/roll cycle + facings are intact.
**DELIVER:** confirmed `extracted/sprites_hd/<fam>/` (+ `_uhd`), the QA contact sheet + PASS/FAIL summary.
> Players: the 3rd co‑op **red** player is a **runtime recolour** in `game.gd` — do **not** create red sheets.

---

## 5. 2D‑HUD — `extra_s` (static glyphs)
Score/Bonus/digit/"GAME OVER" glyphs (game font = **Times Bold**, id 20). Options: **A)** QA the faithful HD upscale
(`qa_assets.py`, `upscale_sprites.py verify/upscale`); **B)** crisp re‑render in Times Bold (`tools/render_text_picts.py`)
— **ask the user first** (it changes the look). Deliver the QA'd glyphs (+ a before/after sample if proposing B).

---

## Corrections — existing assets that don't match Policy A / the verified motion
1. **`goody_coin` → make STATIC (the ONLY mis‑classified goody).** It was built `class A / motion "spin" /
   spin_dps 180 / spin_axis y`. Under Policy A the coin is **static** (`game.gd` draws goodies at a fixed frame;
   the source has one frame each: `f11` silver, `f24` gold). **Fix:**
   - Edit `extracted/sprites_3d/goody_coin/meta.json`: set `"class":"B"`, `"motion":"static"`, `"static":true`;
     **remove** `spin_dps`, `spin_axis`, `spin_dir`.
   - In `tools/soi3d/builders/goody_coin.py`, render the coin as **one still per variant** (`gold.png`,
     `silver.png`) — **no** spin loop.
   - Delete `extracted/sprites_3d/goody_coin/_verify/2d_vs_3d.gif|.mp4` and `positioning.png` (not needed for static);
     keep `_verify/cmp.png`.
   - `py tools/soi3d/build_sprite_manifest.py` then `py tools/soi3d/check_sprite_assets.py goody_coin` → COMPLETE.
   (All other `goody_*` are already correct — leave them.)
2. **`Stop_Go_sprite_family` → add the FLIP (Category 3).** Currently only the two settled stills (`stop.png`,
   `go.png`) exist — those are the **endpoints**. Add the flipping‑octagon model + `_verify/2d_vs_3d.gif|.mp4`
   reproducing the source **f02→f09** Y‑axis flip (edge‑on mid‑turn), per colour group. (`meta.json` is already
   set to `motion:"flip"`.) The two stills stay as the endpoints.
3. **`bigger_mblock` → reconcile before finalizing.** The agent's frame survey reads a **collapse** (6 stacked bars
   peel into rolling balls → one top bar); `game.gd` `ENEMY_FOLDER[16]` calls etype 16 a **"creeper — a pulsing
   block that walks the grid."** These may both be true (a walk cycle **and** a death/collapse). **Confirm with the
   user** which the sheet is (and whether it's a 3D block or a 2D creeper) before committing the model.
4. **`weapons` → clarify (no rework).** The published `spiral.png` is the **static** Magic‑Ball frame (correct).
   The Magic **Arrow** reuses the *same* swirl but **cycled** (Category 2 SPIN) — note this in the family's
   `meta.json` rather than shipping a second sheet.

## After changes (user runs)
```
py tools/soi3d/build_sprite_manifest.py
py tools/soi3d/check_sprite_assets.py --all
```
