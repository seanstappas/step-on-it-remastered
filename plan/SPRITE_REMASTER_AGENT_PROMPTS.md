# Sprite Remaster — ready-to-dispatch agent prompts

Copy‑pastable prompts for running **several agents in parallel**, each remastering a couple of related
sprite families into faithful procedural 3D. Each prompt below is **self‑contained** (all context,
file pointers, commands, deliverables, and guard‑rails).

## How to use
1. Open this file in the **Markdown preview** (each prompt is a fenced code block → hover for the **copy** button).
2. Give **one prompt per agent**; run them in parallel. Families don't overlap, so they won't collide.
3. Each agent works only inside **its own** builder module(s) + `extracted/sprites_3d/<family>/` folders.

## The golden guard‑rail (baked into every prompt)
> **Create/edit ONLY** your own `tools/soi3d/builders/<mode>.py` file(s) and everything under
> `extracted/sprites_3d/<your-family>/`. **Never edit** any shared/common file — `render3d.py`,
> `__init__.py`, `common.py`, the other `tools/soi3d/*.py` tools, another family's folder, the generated
> `manifest.json`, `godot_project/**`, or the `plan/*.md` docs. **If a shared change seems necessary, STOP
> and tell the user** what and why — don't do it yourself.

## Assignment overview
| Agent | Families | Builder mode name(s) | Notes |
|---|---|---|---|
| **1 — Spinning indicators** | `spinner_sprites`, `spin_ind_sprite_family` | `spinner`, `spin_ind` | Class A spinners; measure spin dir/speed. |
| **2 — Gem & ball props** | `master_s_objects`, `cannon_sprites`, `smiley_sprites` | `gem`, `cannon`, `smiley` | Round, self‑shaded → strong 3D. |
| **3 — Goody pickups** | `goody_sprites` | `goody_*` (one per distinct goody) | Multi‑icon sheet; enumerate first. |
| **4 — Blocks & transporter** | `bigger_mblock`, `blocks`, `transporter` | `mblock`, `blocks`, `transporter` | Tile/structure‑like; copy `block.py`. |

Reference (already **DONE**, use as worked examples): `disk_sprites` (spinner), `Stop_Go_sprite_family`
(sign flip), `block_sprites` (static tile), `weapons` (spiral). The **disk** is the gold‑standard template —
its builder is `tools/soi3d/builders/disk.py` and its published folder is `extracted/sprites_3d/disk_sprites/`.

---

## Agent 1 — Spinning indicators (`spinner_sprites`, `spin_ind_sprite_family`)

````
You are remastering 2D pixel sprites of the 1996 Mac game "Step On It!" into faithful PROCEDURAL 3D
(Blender → rendered stills, for a live-3D Godot remaster). Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these, end-to-end):
  - spinner_sprites            (14 frames, 24x26)  -> builder mode name: "spinner"
  - spin_ind_sprite_family     (58 frames, 16x12)  -> builder mode name: "spin_ind"
Both are Class A "spinning indicators". spin_ind is tiny (16x12) with many frames = a smooth rotation
cycle; FIRST confirm it is a board prop worth 3D and not a HUD glyph — if it looks like flat HUD/text,
say so and recommend keeping it 2D instead of forcing 3D.

READ FIRST — your playbook, follow it precisely:
  - plan/SPRITE_REMASTER_PROCESS.md    (the full workflow + golden rules + hard-won lessons + anti-patterns
                                        + the standard output layout in sec.5b + the runtime plan)
  - plan/SPRITE_FIDELITY_VALIDATION.md (the numeric validation method)
  - plan/3D_ANIMATED_REMASTER_PLAN.md  (how the 3D is shown LIVE in-engine + the A/B/C/D classification)

STUDY the sprites AND the reference material using PARALLEL Explore subagents (launch several at once,
each returning findings) — do NOT rely on the tiny 32² frame alone:
  - Source frames: extracted/sprites/spinner_sprites/ and extracted/sprites/spin_ind_sprite_family/ (EVERY frame),
    plus the cleaner upscales extracted/sprites_hd/<family>/ and extracted/sprites_uhd/<family>/.
  - The prop MOVING in-game: refs/videos/ (extract frames with ffmpeg if needed) — confirm spin direction/speed/tilt.
  - The prop IN CONTEXT: refs/images/ (board_1..6.png, board_completed.png, main_screen.png, help_1..3.png), media/reference/.
  - The RULES/manuals: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf,
    refs/text/"About Step On It.txt", refs/text/"Board Designer ReadMe.txt" — learn what this prop DOES.
  - Higher-detail art: extracted/cicn/, extracted/pict/ (+ pict_hd, pict_hd_v2); RE'd facts in
    docs/original_game/graphics-and-audio.md (the game font is Times Bold).
Use the montage / NEAREST-zoom / pixel-class ASCII-grid techniques in PROCESS sec.4.1 to read shape + motion
frame-by-frame; sample EXACT RGBs; MEASURE spin direction/speed by IoU cross-correlation (PROCESS sec.4.2),
never by eye.

ENVIRONMENT:
  - Blender 4.2.3: D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe  (Cycles/CPU; view_transform Standard)
  - Render:  & 'D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe' --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]   (prints RENDERED on success)
  - System `py` has Pillow+numpy; ffmpeg+ffprobe are on PATH.
  - Scratch renders go to D:\SOI-tools\3d_proto\<family>\  (only FINAL assets go in the repo).

BUILD — one NEW module per family (nothing shared):
  - Create tools/soi3d/builders/spinner.py and tools/soi3d/builders/spin_ind.py. COPY tools/soi3d/builders/disk.py
    as a template: define build_<mode>() + an @register("<mode>") render fn (parses argv after the mode,
    args[0]=out, calls C.setup_scene(...), returns out). Reuse shared helpers via `from .. import common as C`
    (C._mat / C._srgb / C._box / C._text / C.setup_scene / C.DEFAULT_SIGN_FONT). Keep geometry unique to your
    sprite INSIDE your module. Model spinners SYMMETRIC (even spacing) — a single source frame is a lopsided
    spin phase; match the OFFSET, not the skew (PROCESS sec.4.3).

VALIDATE + ANIMATE:
  - py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--arm red|--frac red|--recess green|--text] --out cmp.png
    Iterate on the "<-- off" metrics AND the overlay until IoU>=0.85, colour dE<=25, relief sign matches, no grey rim.
  - Render a spin loop; apply tools/soi3d/apply_glint.py per frame if the prop has a view-locked shine; then:
    py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/<family>/f*.png" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/<family>/_verify/2d_vs_3d

PUBLISH — create assets ONLY inside extracted/sprites_3d/<family>/ (standard layout, PROCESS sec.5b). For EACH family produce:
  - meta.json          (JSON) — copy extracted/sprites_3d/disk_sprites/meta.json; set class, mode, motion, source,
                        stills[] (BARE filenames), model ("<mode>.glb") + model_status "pending-P1", spin_dps,
                        spin_dir, tilt_deg, px, and baseline:{source:"extracted/sprites/<family>/<frame>.png", still:"<still>.png", flags:[...]}
  - <name>.png         (IMAGE) — the published still(s)
  - _verify/cmp.png    (IMAGE) — the verify_3d overlay
  - _verify/positioning.png (IMAGE) — an angle/alignment guide
  - _verify/2d_vs_3d.gif (GIF) and _verify/2d_vs_3d.mp4 (VIDEO) — the 2D-vs-3D comparison
  - _verify/vs_video.png (IMAGE, optional) — only if the prop appears in refs/videos
  - the 3D MODEL (<mode>.glb): GLB export is not built yet (P1), so leave model_status "pending-P1" and SKIP the .glb
    for now — the checker treats a pending model as OK. (If a `glb` mode exists by the time you run, export it.)

CHECK — run until it reports COMPLETE:
  py tools/soi3d/check_sprite_assets.py <family>
  It verifies every required asset is present and re-runs verify_3d against your baseline. Fix everything it lists [MISS].

DO NOT EDIT COMMON / SHARED FILES (this is what lets agents run in parallel):
  - You may ONLY create/edit: tools/soi3d/builders/spinner.py, tools/soi3d/builders/spin_ind.py,
    and everything under extracted/sprites_3d/spinner_sprites/ and extracted/sprites_3d/spin_ind_sprite_family/.
  - NEVER touch: tools/soi3d/render3d.py, __init__.py, common.py, verify_3d.py, apply_glint.py,
    make_sprite_anim.py, build_sprite_manifest.py, check_sprite_assets.py, any OTHER family's builder/folder,
    extracted/sprites_3d/manifest.json (GENERATED), godot_project/**, or any plan/*.md doc.
  - Do NOT edit the status board or the manifest — the user regenerates the manifest.
  - IF you think a shared change is needed (a new helper in common.py, a render3d.py or doc change), STOP and
    tell the user exactly what and why. Don't do it yourself.

DELIVER: per family, the list of files you created, the `check_sprite_assets.py` result (should be COMPLETE
apart from the pending-P1 GLB), your measured spin_dps/spin_dir/tilt, and any shared change you recommend.
````

---

## Agent 2 — Gem & ball props (`master_s_objects`, `cannon_sprites`, `smiley_sprites`)

````
You are remastering 2D pixel sprites of the 1996 Mac game "Step On It!" into faithful PROCEDURAL 3D
(Blender → rendered stills, for a live-3D Godot remaster). Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these, end-to-end):
  - master_s_objects   (58 frames, 24x24)         -> builder mode name: "gem"
      The high-value pickup GEM / gold bar (worth 2000/5000). 58 frames = a spinning faceted gem
      (red/blue). Model a real faceted diamond/gem that catches light; measure its spin.
  - cannon_sprites     (20 frames, 32x32 & 16x16) -> builder mode name: "cannon"
      A cannon that fires a striped ball. TWO sub-parts: the cannon body (32x32) and the striped ball
      ammo (the 16x16 frames). Decide whether to ship one model or two stills; explain your choice.
  - smiley_sprites     (47 frames, 32x30)         -> builder mode name: "smiley"
      A red ball with a face. FIRST classify it: if it's a rounded self-shaded prop -> 3D (red sphere +
      face). If it's really a flat cel character (walk/expression cycle), it belongs in 2D UHD — say so
      and recommend keeping it 2D instead of forcing 3D.

READ FIRST — your playbook, follow it precisely:
  - plan/SPRITE_REMASTER_PROCESS.md    (workflow + golden rules + hard-won lessons + anti-patterns + output layout sec.5b + runtime plan)
  - plan/SPRITE_FIDELITY_VALIDATION.md (the numeric validation method)
  - plan/3D_ANIMATED_REMASTER_PLAN.md  (how the 3D is shown LIVE in-engine + the A/B/C/D classification)

STUDY the sprites AND the references using PARALLEL Explore subagents (launch several at once):
  - Source frames: extracted/sprites/<family>/ (EVERY frame) + upscales extracted/sprites_hd/<family>/ and _uhd/<family>/.
  - The prop MOVING: refs/videos/ (ffmpeg-extract frames if needed) — confirm spin/tilt/cadence, and how the cannon fires.
  - The prop IN CONTEXT: refs/images/ (board_1..6.png, main_screen.png, help_1..3.png), media/reference/.
  - The RULES/manuals: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf,
    refs/text/"About Step On It.txt" — learn what each prop DOES (gem value, cannon behaviour, smiley role).
  - Higher-detail art: extracted/cicn/, extracted/pict/ (+ hd/v2); docs/original_game/graphics-and-audio.md (font = Times Bold).
    Also see the master-objects overview sheet extracted/sprites/_sheet_master_s_objects.png.
Use the montage / NEAREST-zoom / ASCII-grid methods in PROCESS sec.4.1; sample EXACT RGBs; MEASURE spin by IoU
cross-correlation (PROCESS sec.4.2). For the gem, get the facet pattern + the two colour variants right.

ENVIRONMENT:
  - Blender 4.2.3: D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe  (Cycles/CPU; view_transform Standard)
  - Render:  & 'D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe' --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]   (prints RENDERED)
  - System `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch renders: D:\SOI-tools\3d_proto\<family>\ (finals only go in the repo).

BUILD — one NEW module per family (nothing shared):
  - Create tools/soi3d/builders/gem.py, cannon.py, smiley.py. COPY tools/soi3d/builders/disk.py as a template:
    build_<mode>() + @register("<mode>") render fn (argv after mode, args[0]=out, calls C.setup_scene, returns out).
    Reuse `from .. import common as C` (C._mat/_srgb/_box/_text/setup_scene/DEFAULT_SIGN_FONT). Keep unique geometry
    IN your module (e.g. a bmesh faceted gem for `gem`). Spinners must be SYMMETRIC (match offset, not skew).
    Matte faces (spec=0) + the top-left key sun give saturated in-hue shine; for a glossy gem you MAY use a
    clearcoat — see PROCESS sec.7. Distinct glints go in POST via apply_glint.py.

VALIDATE + ANIMATE:
  - py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--arm|--frac|--recess|--text col] --out cmp.png
    Iterate on "<-- off" metrics AND the overlay until IoU>=0.85, dE<=25, relief sign matches, no grey rim.
  - (spinners) render a spin loop, apply apply_glint.py per frame if there's a view-locked shine, then:
    py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/<family>/f*.png" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/<family>/_verify/2d_vs_3d

PUBLISH — ONLY inside extracted/sprites_3d/<family>/ (PROCESS sec.5b). For EACH family create:
  meta.json (JSON; copy disk_sprites/meta.json: class, mode, motion, source, stills[] bare names, model "<mode>.glb"
  + model_status "pending-P1", spin_dps, spin_dir, tilt_deg, px, baseline:{source,still,flags}); the still PNG(s)
  (IMAGE); _verify/cmp.png (IMAGE); _verify/positioning.png (IMAGE); _verify/2d_vs_3d.gif (GIF) + .mp4 (VIDEO);
  _verify/vs_video.png (IMAGE, optional). The <mode>.glb (3D model) is P1 — leave model_status "pending-P1" and
  SKIP the .glb for now (the checker treats a pending model as OK).

CHECK — run until COMPLETE:  py tools/soi3d/check_sprite_assets.py <family>
  (verifies all required assets + re-runs verify_3d against your baseline; fix everything it lists [MISS]).

DO NOT EDIT COMMON / SHARED FILES:
  - ONLY create/edit: tools/soi3d/builders/{gem,cannon,smiley}.py and extracted/sprites_3d/{master_s_objects,cannon_sprites,smiley_sprites}/.
  - NEVER touch render3d.py / __init__.py / common.py / the other tools/soi3d/*.py / another family's folder /
    manifest.json (GENERATED) / godot_project/** / any plan/*.md. Don't edit the status board or manifest.
  - IF a shared change seems necessary (new common.py helper, render3d change, doc fix), STOP and tell the user what+why.

DELIVER: per family, files created, the check result (COMPLETE apart from pending-P1 GLB), the classification calls
(smiley 3D-vs-2D, cannon one-model-vs-two), measured spin params, and any shared change you recommend.
````

---

## Agent 3 — Goody pickups (`goody_sprites`)

````
You are remastering 2D pixel sprites of the 1996 Mac game "Step On It!" into faithful PROCEDURAL 3D
(Blender → rendered stills, for a live-3D Godot remaster). Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY this family, end-to-end):
  - goody_sprites   (49 frames, 32x32)
This is a MULTI-ICON sheet: the pickups. From the manual the goodies are: Shoes (speed), Turtles (slow
nasties), Shield (invulnerability), Thunderballs (kill nasties), Silver/Gold coins (500/1000), Gem/Gold
bars (2000/5000), Clock (bonus), 2x Multiplier, Magnifying glass, Stop/Go switch, 1UP, IN/OUT transporters.

STEP 0 (do this FIRST and report before mass-building): SURVEY + ENUMERATE. Using PARALLEL Explore subagents,
map which frames belong to which distinct goody, and CLASSIFY each:
  - Geometric / rounded (3D-worthy): coins (cylinders), gem/gold bars (faceted), shield, clock, thunderball,
    magnifying glass, 1UP, shoes/turtle if rounded, etc.
  - Flat icon / text (keep 2D UHD): anything that is essentially a flat symbol reads better as a crisp 2D upscale.
  - SKIP duplicates already owned elsewhere: the Stop/Go switch (done: Stop_Go_sprite_family) and IN/OUT
    transporters (Agent 4 owns `transporter`). Note them but don't rebuild.
Deliver a short plan (frame ranges -> goody -> 3D or 2D + proposed mode name) and proceed on the 3D ones.

Use ONE builder module PER distinct 3D goody, named "goody_<thing>" (e.g. goody_coin, goody_clock, goody_gembar,
goody_shield, goody_thunderball). Publish EACH as its own family folder extracted/sprites_3d/goody_<thing>/
(so each is independently checkable). Record every mode/folder you create in your final report.

READ FIRST — your playbook, follow it precisely:
  - plan/SPRITE_REMASTER_PROCESS.md    (workflow + golden rules + lessons + anti-patterns + output layout sec.5b + runtime plan)
  - plan/SPRITE_FIDELITY_VALIDATION.md (the numeric validation method)
  - plan/3D_ANIMATED_REMASTER_PLAN.md  (live in-engine 3D + A/B/C/D classification)

STUDY with PARALLEL Explore subagents:
  - Source: extracted/sprites/goody_sprites/ (EVERY frame) + upscales extracted/sprites_hd/goody_sprites/ and _uhd/.
  - Moving in-game + values: refs/videos/, and the manuals refs/text/FunBundle2Manual.pdf +
    refs/text/StepOnItRefCard.pdf + refs/text/"About Step On It.txt" (what each goody does + its score).
  - In context: refs/images/ (board_1..6.png, main_screen.png, help_1..3.png), media/reference/.
  - Higher-detail: extracted/cicn/ (icon versions of goodies!), extracted/pict/ (+ hd/v2);
    docs/original_game/graphics-and-audio.md (font = Times Bold, palette, sheet layout).
Use montage / NEAREST-zoom / ASCII-grid (PROCESS sec.4.1); sample EXACT RGBs; measure any spin by IoU (sec.4.2).

ENVIRONMENT:
  - Blender 4.2.3: D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe  (Cycles/CPU; view_transform Standard)
  - Render:  & 'D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe' --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]   (prints RENDERED)
  - `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch: D:\SOI-tools\3d_proto\goody_<thing>\ (finals only in the repo).

BUILD — one NEW module per 3D goody (COPY tools/soi3d/builders/disk.py as a template):
  build_<mode>() + @register("<mode>") render fn; reuse `from .. import common as C`
  (C._mat/_srgb/_box/_text/setup_scene/DEFAULT_SIGN_FONT). Keep each goody's geometry in ITS module. Match exact
  source RGBs; use Times Bold for any lettering; spinners SYMMETRIC (match offset not skew). Glints in POST (apply_glint.py).

VALIDATE + ANIMATE (per goody):
  - py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--frac col|--text|...] --out cmp.png  (iterate to IoU>=0.85, dE<=25, relief ok, no grey rim)
  - if it animates: render a loop, apply_glint per frame if needed, then
    py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/goody_sprites/<frames-for-this-goody>" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/goody_<thing>/_verify/2d_vs_3d

PUBLISH — per goody, ONLY inside extracted/sprites_3d/goody_<thing>/ (PROCESS sec.5b):
  meta.json (JSON; copy disk_sprites/meta.json; set class, mode "goody_<thing>", motion, source
  "extracted/sprites/goody_sprites", stills[] bare names, model "goody_<thing>.glb" + model_status "pending-P1",
  spin params, px, baseline:{source,still,flags}); still PNG(s) (IMAGE); _verify/cmp.png (IMAGE);
  _verify/positioning.png if it spins (IMAGE); _verify/2d_vs_3d.gif (GIF) + .mp4 (VIDEO) if it animates;
  _verify/vs_video.png (optional). The .glb is P1 — leave "pending-P1" and skip it for now.

CHECK — for EACH goody folder, run until COMPLETE:  py tools/soi3d/check_sprite_assets.py goody_<thing>

DO NOT EDIT COMMON / SHARED FILES:
  - ONLY create/edit: tools/soi3d/builders/goody_*.py (your new files) and extracted/sprites_3d/goody_*/ (your new folders).
  - NEVER touch render3d.py / __init__.py / common.py / the other tools/soi3d/*.py / another agent's family /
    manifest.json (GENERATED) / godot_project/** / any plan/*.md. Don't edit the status board or manifest.
  - IF a shared change seems necessary, STOP and tell the user what + why.

DELIVER: the enumeration table (frames -> goody -> 3D/2D + mode), the folders/modes you created, and each
goody's check_sprite_assets.py result (COMPLETE apart from pending-P1 GLB), plus any shared change you recommend.
````

---

## Agent 4 — Blocks & transporter (`bigger_mblock`, `blocks`, `transporter`)

````
You are remastering 2D pixel sprites of the 1996 Mac game "Step On It!" into faithful PROCEDURAL 3D
(Blender → rendered stills, for a live-3D Godot remaster). Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these, end-to-end):
  - bigger_mblock  (13 frames, 32x32)  -> builder mode name: "mblock"
      A LARGER moving/breakable block. Reuse the tile look of the finished block_sprites (raised bevelled
      frame; recessed centre where applicable) but at the bigger size — COPY tools/soi3d/builders/block.py.
  - blocks         (51 frames, 32x32)  -> builder mode name: "blocks"
      A block set / animation (likely create/destroy or variants). Study whether the 51 frames are an
      ANIMATION (e.g. build/break) or colour VARIANTS; compare against the finished block_sprites to avoid
      duplicating it. Report which it is before building.
  - transporter    (13 frames, 40x31)  -> builder mode name: "transporter"
      The IN/OUT transporter pad/portal. 13 frames = a pulse/glow cycle. Model the pad/ring; the glow can be
      a soft emission + a POST glint (apply_glint.py). Get the IN vs OUT colour variants right.

READ FIRST — your playbook, follow it precisely:
  - plan/SPRITE_REMASTER_PROCESS.md    (workflow + golden rules + lessons + anti-patterns + output layout sec.5b + runtime plan)
  - plan/SPRITE_FIDELITY_VALIDATION.md (the numeric validation method)
  - plan/3D_ANIMATED_REMASTER_PLAN.md  (live in-engine 3D + the A/B/C/D classification)
Worked example to copy: the finished tile builder tools/soi3d/builders/block.py and its folder
extracted/sprites_3d/block_sprites/ (blocks are raised FRAME + RECESSED colour centre; see PROCESS sec.7/8).

STUDY with PARALLEL Explore subagents:
  - Source: extracted/sprites/{bigger_mblock,blocks,transporter}/ (EVERY frame) + upscales in sprites_hd/ and sprites_uhd/.
  - Moving in-game: refs/videos/ (ffmpeg-extract if needed) — confirm the block build/break animation + the transporter pulse.
  - In context: refs/images/ (board_1..6.png, board_completed.png, main_screen.png, help_1..3.png), media/reference/.
  - Rules/manuals: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf, refs/text/"About Step On It.txt",
    refs/text/"Board Designer ReadMe.txt" — how blocks and transporters behave.
  - Higher-detail: extracted/cicn/, extracted/pict/ (+ hd/v2); docs/original_game/graphics-and-audio.md (font = Times Bold).
Use montage / NEAREST-zoom / ASCII-grid (PROCESS sec.4.1); sample EXACT RGBs; measure any animation by IoU (sec.4.2).

ENVIRONMENT:
  - Blender 4.2.3: D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe  (Cycles/CPU; view_transform Standard)
  - Render:  & 'D:\SOI-tools\blender\blender-4.2.3-windows-x64\blender.exe' --background --factory-startup --python tools/soi3d/render3d.py -- <mode> <out.png> [args]   (prints RENDERED)
  - `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch: D:\SOI-tools\3d_proto\<family>\ (finals only in the repo).

BUILD — one NEW module per family (COPY tools/soi3d/builders/block.py as a template):
  build_<mode>() + @register("<mode>") render fn (argv after mode, args[0]=out, calls C.setup_scene, returns out);
  reuse `from .. import common as C` (C._mat/_srgb/_box/_text/setup_scene/DEFAULT_SIGN_FONT). Keep unique geometry
  IN your module. Blocks = raised bevelled frame + (if present) a RECESSED colour centre carved as a well
  (PROCESS sec.7). Match exact source RGBs.

VALIDATE + ANIMATE:
  - py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--recess <col>|--frac <col>|--text] --out cmp.png
    Iterate on "<-- off" metrics AND the overlay until IoU>=0.85, dE<=25, relief sign matches, no grey rim.
    (For recessed centres use --recess to confirm the sunken direction.)
  - If it animates (block build/break, transporter pulse): render the loop, apply_glint per frame if it has a
    view-locked shine, then:
    py tools/soi3d/make_sprite_anim.py --src "extracted/sprites/<family>/f*.png" --ren "<scratch>/g_*.png" --out extracted/sprites_3d/<family>/_verify/2d_vs_3d

PUBLISH — ONLY inside extracted/sprites_3d/<family>/ (PROCESS sec.5b). For EACH family create:
  meta.json (JSON; copy disk_sprites/meta.json: class, mode, motion, source, stills[] bare names, model "<mode>.glb"
  + model_status "pending-P1", spin/anim params, tilt_deg, px, baseline:{source,still,flags}); still PNG(s) (IMAGE);
  _verify/cmp.png (IMAGE); _verify/positioning.png if it animates (IMAGE); _verify/2d_vs_3d.gif (GIF) + .mp4 (VIDEO)
  if it animates; _verify/vs_video.png (optional). The <mode>.glb is P1 — leave "pending-P1" and skip it for now.

CHECK — run until COMPLETE:  py tools/soi3d/check_sprite_assets.py <family>

DO NOT EDIT COMMON / SHARED FILES:
  - ONLY create/edit: tools/soi3d/builders/{mblock,blocks,transporter}.py and extracted/sprites_3d/{bigger_mblock,blocks,transporter}/.
  - NEVER touch render3d.py / __init__.py / common.py / the other tools/soi3d/*.py / another family's folder /
    manifest.json (GENERATED) / godot_project/** / any plan/*.md. Don't edit the status board or manifest.
  - IF a shared change seems necessary (e.g. a genuinely reusable block helper belongs in common.py), STOP and
    tell the user what + why — don't do it yourself.

DELIVER: per family, files created, the check_sprite_assets.py result (COMPLETE apart from pending-P1 GLB),
what `blocks` turned out to be (animation vs variants), and any shared change you recommend.
````

---

## After the agents finish (user runs this)
Regenerate the aggregate manifest and re‑check everything:
```
py tools/soi3d/build_sprite_manifest.py
py tools/soi3d/check_sprite_assets.py --all
```
`build_sprite_manifest.py` discovers every new `<family>/meta.json`; `check_sprite_assets.py --all` confirms each
family is COMPLETE (pending‑P1 GLBs are expected until the `glb` export mode ships).

---

# Part 2 — the rest of the sprites: the 2D UHD / HUD track (Class C/D, NOT 3D)

Added so **every** sprite family is accounted for — the **players**, the **enemies/characters**, and the **HUD**.
Part 1 (Agents 1–4) is **unchanged**; these are **new** agents that don't touch anything Part 1 owns.

## Coverage — all 30 sprite families
| Family | Class | Track | Owner |
|---|---|---|---|
| `disk_sprites` | A | 3D | **DONE** |
| `Stop_Go_sprite_family` | A | 3D | **DONE** |
| `block_sprites` | B | 3D | **DONE** |
| `weapons` | B | 3D | **DONE** |
| `spinner_sprites` | A | 3D | Agent 1 |
| `spin_ind_sprite_family` | A | 3D | Agent 1 |
| `master_s_objects` | B | 3D | Agent 2 |
| `cannon_sprites` | B | 3D | Agent 2 |
| `smiley_sprites` | B? | 3D | Agent 2 |
| `goody_sprites` | A/B | 3D | Agent 3 |
| `bigger_mblock` | B | 3D | Agent 4 |
| `blocks` | B | 3D | Agent 4 |
| `transporter` | B | 3D | Agent 4 |
| `BP_sprites` | D | 2D UHD | **Agent 5** |
| `GP_sprites` | D | 2D UHD | **Agent 5** |
| `bp_30fps_all_but_jump` | D | 2D UHD | **Agent 5** |
| `bp_jump_30fps` | D | 2D UHD | **Agent 5** |
| `ant_sprites` | D | 2D UHD | **Agent 6** |
| `ant_stride_test` | D | 2D UHD | **Agent 6** |
| `beenie_sprites` | D | 2D UHD | **Agent 6** |
| `Gargoyle_sprites` | D | 2D UHD | **Agent 6** |
| `hammer_sprites` | D | 2D UHD | **Agent 6** |
| `hippo_sprites` | D | 2D UHD | **Agent 6** |
| `knight_sprites` | D | 2D UHD | **Agent 7** |
| `ostrich_sprites` | D | 2D UHD | **Agent 7** |
| `piggy_sprites` | D | 2D UHD | **Agent 7** |
| `robo_sprites` | D | 2D UHD | **Agent 7** |
| `teeth_sprites` | D | 2D UHD | **Agent 7** |
| `walker_sprites` | D | 2D UHD | **Agent 7** |
| `extra_s` | C | 2D bitmap / Times Bold | **Agent 8** |

**Why these stay 2D:** image‑to‑3D fails on flat cel art (design §12, empirical), so players/enemies/HUD keep
their crisp **2D** form — but at HD/UHD, QA'd frame‑by‑frame. The upscales **already exist**
(`extracted/sprites_hd/<fam>/`, `extracted/sprites_uhd/<fam>/`); the Part‑2 job is to **validate + finalize**
them (re‑upscaling any bad frames), **not** to build 3D. No Blender, no `tools/soi3d/`, no `sprites_3d/`.

**Shared tools (you RUN them; never edit them):**
- QA a family: `py tools/qa_assets.py sprites extracted/sprites/<fam> extracted/sprites_hd/<fam>`
  (per frame: RGBA, size == k×source, alpha‑bbox scales, downscale‑back SSIM vs source; writes a contact sheet;
  non‑zero exit on any FAIL) — and `py tools/upscale_sprites.py verify --folders <fam>`.
- (Re)upscale a family: `py tools/upscale_sprites.py upscale --folders <fam>` (faithful hqx pixel‑scaler, or
  Real‑ESRGAN for the AI‑opted sheets).

---

## Agent 5 — Player characters (Ted + co‑op variants)

````
You are FINALIZING the 2D HD/UHD sprites of the 1996 game "Step On It!" (these stay 2D — image-to-3D fails on
flat cel art). NOT a 3D task, no Blender. Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these): the PLAYER character (Ted) sheets --
  - BP_sprites             (155 frames)   - a co-op player
  - GP_sprites             (155 frames)   - the other co-op player
  - bp_30fps_all_but_jump  (109 frames)   - 30fps player animation (all states except jump)
  - bp_jump_30fps          (14 frames)    - 30fps player jump
These are the MAIN character. NOTE: the remaster's 3rd co-op RED player is a RUNTIME recolour in game.gd
(62-entry colour-shift clut) -- do NOT create red sheets.

READ FIRST:
  - plan/SPRITE_REMASTER_PROCESS.md      (sec.3 classification; sec.4.1 survey techniques)
  - plan/3D_ANIMATED_REMASTER_PLAN.md    (sec.1: players are Class D -> keep 2D UHD)
  - plan/3D_SPRITE_REMASTER_DESIGN.md    (the 2D-UHD method + registration/fill + why cel art stays 2D)
  - plan/SPRITE_FIDELITY_VALIDATION.md   (fidelity ideas)

STUDY with PARALLEL Explore subagents (launch several at once):
  - Source frames extracted/sprites/<fam>/ (EVERY frame) + the existing upscales extracted/sprites_hd/<fam>/
    and extracted/sprites_uhd/<fam>/.
  - The player MOVING: refs/videos/ (extract frames with ffmpeg) -- confirm walk/run/jump/climb cycles + facings.
  - In context + scale: refs/images/ (board_1..6.png, main_screen.png, help_1..3.png, configure_keys.png), media/reference/.
  - Rules/manual: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf, refs/text/"About Step On It.txt".
  - Palette + recolour: docs/original_game/graphics-and-audio.md (master clut + the 62-entry player color-shift cluts).

THE JOB (the HD/UHD upscales ALREADY EXIST -- VALIDATE + FINALIZE, don't rebuild):
  1. QA every frame:  py tools/qa_assets.py sprites extracted/sprites/<fam> extracted/sprites_hd/<fam>
     (RGBA? size == k x source? alpha bbox scales? downscale-back SSIM vs source? -> contact sheet; non-zero exit on FAIL)
     also:  py tools/upscale_sprites.py verify --folders <fam>
  2. Open the contact sheet; hunt for AI artifacts (smearing, alpha halos, wrong palette, broken/duplicated
     frames), animation-cycle glitches, and registration/anchor drift across the walk/run/jump cycle + facings.
  3. FIX flagged frames:  py tools/upscale_sprites.py upscale --folders <fam>   (faithful hqx, or Real-ESRGAN for AI sheets).
     Re-QA until qa_assets.py passes (SSIM ok) and the contact sheet reads clean.
ENVIRONMENT: system `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch QA output: D:\SOI-tools\2d_qa\<fam>\.

DELIVERABLES (per family): the confirmed/fixed frames in extracted/sprites_hd/<fam>/ (and extracted/sprites_uhd/<fam>/),
the qa_assets contact sheet + PASS/FAIL summary, and a note listing any frame needing manual attention.

DO NOT EDIT COMMON / SHARED FILES (so agents don't collide):
  - Create/edit ONLY inside YOUR families' subfolders: extracted/sprites_hd/{BP_sprites,GP_sprites,bp_30fps_all_but_jump,bp_jump_30fps}/
    and the matching extracted/sprites_uhd/<fam>/. (These per-family subfolders don't overlap other agents.)
  - NEVER touch: extracted/sprites/<fam>/ (the faithful SOURCE - read-only), tools/** (you RUN upscale_sprites.py /
    qa_assets.py, never edit them), tools/soi3d/**, extracted/sprites_3d/**, godot_project/**, any plan/*.md,
    or another agent's family. Do NOT create red player sheets (runtime recolour).
  - IF a shared change is needed (a tool fix, a re-upscale setting, a doc change), STOP and tell the user what + why.

REPORT: per family, the QA result (PASS/FAIL + SSIM), which frames you re-upscaled, any frames needing manual
attention, and any shared change you recommend.
````

---

## Agent 6 — Nasties & characters (A)

````
You are FINALIZING the 2D HD/UHD sprites of the 1996 game "Step On It!" (these stay 2D -- image-to-3D fails on
flat cel art). NOT a 3D task, no Blender. Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these enemy/character sheets):
  - ant_sprites       (48 frames)
  - ant_stride_test   (48 frames)   -- possibly a DEV/test variant of ant_sprites; verify it is actually used
                                       in-game and not a throwaway. If it looks like a dev artifact, flag it to the user.
  - beenie_sprites    (118 frames)
  - Gargoyle_sprites  (71 frames)
  - hammer_sprites    (79 frames)
  - hippo_sprites     (31 frames)

READ FIRST:
  - plan/SPRITE_REMASTER_PROCESS.md      (sec.3 classification; sec.4.1 survey techniques)
  - plan/3D_ANIMATED_REMASTER_PLAN.md    (sec.1: these are Class D -> keep 2D UHD)
  - plan/3D_SPRITE_REMASTER_DESIGN.md    (the 2D-UHD method + registration + why cel art stays 2D)
  - plan/SPRITE_FIDELITY_VALIDATION.md   (fidelity ideas)

STUDY with PARALLEL Explore subagents (launch several at once):
  - Source frames extracted/sprites/<fam>/ (EVERY frame) + upscales extracted/sprites_hd/<fam>/ and extracted/sprites_uhd/<fam>/.
  - The character MOVING: refs/videos/ (ffmpeg-extract) -- confirm its animation cycle + facings.
  - In context + scale: refs/images/ (board_1..6.png, main_screen.png, help_1..3.png), media/reference/.
  - Rules/manual: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf, refs/text/"About Step On It.txt" (what each nasty does).
  - Palette: docs/original_game/graphics-and-audio.md.

THE JOB (the HD/UHD upscales ALREADY EXIST -- VALIDATE + FINALIZE, don't rebuild):
  1. QA every frame:  py tools/qa_assets.py sprites extracted/sprites/<fam> extracted/sprites_hd/<fam>
     also:  py tools/upscale_sprites.py verify --folders <fam>
  2. Open the contact sheet; hunt for AI artifacts (smearing, alpha halos, wrong palette, broken/duplicated
     frames), animation-cycle glitches, registration/anchor drift.
  3. FIX flagged frames:  py tools/upscale_sprites.py upscale --folders <fam>   -- re-QA until qa_assets.py passes + the sheet is clean.
ENVIRONMENT: `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch QA: D:\SOI-tools\2d_qa\<fam>\.

DELIVERABLES (per family): confirmed/fixed frames in extracted/sprites_hd/<fam>/ (+ _uhd), the qa_assets contact
sheet + PASS/FAIL summary, the ant_stride_test verdict (used vs throwaway), and any frames needing manual attention.

DO NOT EDIT COMMON / SHARED FILES:
  - Create/edit ONLY inside YOUR families' subfolders under extracted/sprites_hd/ and extracted/sprites_uhd/.
  - NEVER touch: extracted/sprites/<fam>/ (SOURCE - read-only), tools/** (RUN upscale_sprites.py / qa_assets.py,
    never edit), tools/soi3d/**, extracted/sprites_3d/**, godot_project/**, any plan/*.md, or another agent's family.
  - IF a shared change is needed, STOP and tell the user what + why.

REPORT: per family, QA result (PASS/FAIL + SSIM), frames re-upscaled, frames needing manual attention, and any
shared change you recommend.
````

---

## Agent 7 — Nasties & characters (B)

````
You are FINALIZING the 2D HD/UHD sprites of the 1996 game "Step On It!" (these stay 2D -- image-to-3D fails on
flat cel art). NOT a 3D task, no Blender. Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY these enemy/character sheets):
  - knight_sprites   (63 frames)
  - ostrich_sprites  (31 frames)
  - piggy_sprites    (31 frames)
  - robo_sprites     (78 frames)
  - teeth_sprites    (48 frames)
  - walker_sprites   (62 frames)

READ FIRST:
  - plan/SPRITE_REMASTER_PROCESS.md      (sec.3 classification; sec.4.1 survey techniques)
  - plan/3D_ANIMATED_REMASTER_PLAN.md    (sec.1: these are Class D -> keep 2D UHD)
  - plan/3D_SPRITE_REMASTER_DESIGN.md    (the 2D-UHD method + registration + why cel art stays 2D)
  - plan/SPRITE_FIDELITY_VALIDATION.md   (fidelity ideas)

STUDY with PARALLEL Explore subagents (launch several at once):
  - Source frames extracted/sprites/<fam>/ (EVERY frame) + upscales extracted/sprites_hd/<fam>/ and extracted/sprites_uhd/<fam>/.
  - The character MOVING: refs/videos/ (ffmpeg-extract) -- confirm its animation cycle + facings.
  - In context + scale: refs/images/ (board_1..6.png, main_screen.png, help_1..3.png), media/reference/.
  - Rules/manual: refs/text/FunBundle2Manual.pdf, refs/text/StepOnItRefCard.pdf, refs/text/"About Step On It.txt".
  - Palette: docs/original_game/graphics-and-audio.md.

THE JOB (the HD/UHD upscales ALREADY EXIST -- VALIDATE + FINALIZE, don't rebuild):
  1. QA every frame:  py tools/qa_assets.py sprites extracted/sprites/<fam> extracted/sprites_hd/<fam>
     also:  py tools/upscale_sprites.py verify --folders <fam>
  2. Open the contact sheet; hunt for AI artifacts (smearing, alpha halos, wrong palette, broken/duplicated
     frames), animation-cycle glitches, registration/anchor drift.
  3. FIX flagged frames:  py tools/upscale_sprites.py upscale --folders <fam>   -- re-QA until qa_assets.py passes + the sheet is clean.
ENVIRONMENT: `py` has Pillow+numpy; ffmpeg+ffprobe on PATH. Scratch QA: D:\SOI-tools\2d_qa\<fam>\.

DELIVERABLES (per family): confirmed/fixed frames in extracted/sprites_hd/<fam>/ (+ _uhd), the qa_assets contact
sheet + PASS/FAIL summary, and any frames needing manual attention.

DO NOT EDIT COMMON / SHARED FILES:
  - Create/edit ONLY inside YOUR families' subfolders under extracted/sprites_hd/ and extracted/sprites_uhd/.
  - NEVER touch: extracted/sprites/<fam>/ (SOURCE - read-only), tools/** (RUN, never edit), tools/soi3d/**,
    extracted/sprites_3d/**, godot_project/**, any plan/*.md, or another agent's family.
  - IF a shared change is needed, STOP and tell the user what + why.

REPORT: per family, QA result (PASS/FAIL + SSIM), frames re-upscaled, frames needing manual attention, and any
shared change you recommend.
````

---

## Agent 8 — HUD / text (`extra_s`)

````
You are FINALIZING the 2D HUD/text sprites of the 1996 game "Step On It!" (Class C -- kept 2D, pixel-exact or
re-rendered in the game font). NOT a 3D task, no Blender. Workspace root: d:\Code\step-on-it-remastered.

YOUR ASSIGNMENT (do ONLY this):
  - extra_s   (37 frames)   -- the HUD text/number set: Score / Bonus / digits / "GAME OVER", etc. The game font
                               is Times Bold (font id 20). game.gd draws the HUD from the 2D extra_s blit.

READ FIRST:
  - plan/SPRITE_REMASTER_PROCESS.md      (sec.3 classification: Class C = keep 2D bitmap OR re-render in Times Bold)
  - plan/3D_ANIMATED_REMASTER_PLAN.md    (sec.1: extra_s is HUD/text -> not spun)
  - docs/original_game/graphics-and-audio.md  (the RE'd fact: text is TextFont(0x14)=id 20=Times + TextFace(1)=Bold)

STUDY with PARALLEL Explore subagents:
  - Source frames extracted/sprites/extra_s/ (EVERY frame) + upscales extracted/sprites_hd/extra_s/ and _uhd/,
    plus the overview sheet extracted/sprites/_sheet_extra_s.png.
  - HUD in context: refs/images/main_screen.png, main_screen_high_score.png, board_*.png; media/reference/.
  - Manual/refcard: refs/text/StepOnItRefCard.pdf, refs/text/"About Step On It.txt".

THE JOB -- pick ONE and confirm with the user before a big visual change:
  A) FAITHFUL: QA the existing HD upscale, pixel-accurate.
       py tools/qa_assets.py sprites extracted/sprites/extra_s extracted/sprites_hd/extra_s
       py tools/upscale_sprites.py verify --folders extra_s
     Fix flagged glyphs:  py tools/upscale_sprites.py upscale --folders extra_s   (re-QA until clean).
  B) CRISP RE-RENDER (optional, nicer): re-render the text/digits sharply in Times Bold. There is a text-render
     tool at tools/render_text_picts.py -- study it; propose using it. Because this CHANGES the look, describe
     your plan and get the user's OK BEFORE committing re-rendered glyphs.
ENVIRONMENT: `py` has Pillow+numpy; ffmpeg on PATH; C:\Windows\Fonts\timesbd.ttf = Times Bold. Scratch: D:\SOI-tools\2d_qa\extra_s\.

DELIVERABLES: the confirmed/fixed extracted/sprites_hd/extra_s/ (+ _uhd) glyphs, the qa_assets contact sheet +
PASS/FAIL summary, and -- if you propose option B -- a small before/after sample for the user to approve.

DO NOT EDIT COMMON / SHARED FILES:
  - Create/edit ONLY inside extracted/sprites_hd/extra_s/ and extracted/sprites_uhd/extra_s/.
  - NEVER touch: extracted/sprites/extra_s/ (SOURCE - read-only), tools/** (RUN, never edit), tools/soi3d/**,
    extracted/sprites_3d/**, godot_project/** (incl. game.gd's HUD code), or any plan/*.md.
  - IF a shared change is needed (e.g. game.gd must point at re-rendered glyphs), STOP and tell the user what + why.

REPORT: the QA result (PASS/FAIL + SSIM), any glyphs fixed, and -- if proposing the Times-Bold re-render -- the
before/after sample and a clear ask for approval.
````
