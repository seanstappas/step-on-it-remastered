# Sprite Remaster Process — generic playbook (for parallel agents)

Turn the original 2D pixel sprites in `extracted/sprites/<family>/` into faithful, higher‑fidelity
**remaster‑mode** assets: **procedural 3D** (Blender) for geometric props, **2D UHD** for flat cel
characters — validated by **numbers**, not by eye.

**Who this is for:** any agent assigned **one sprite family**. Several agents run this in parallel, one
family each. Follow it end‑to‑end, publish to *your* family's paths, and don't touch another family's files.

Companion docs: the validation method [SPRITE_FIDELITY_VALIDATION.md](SPRITE_FIDELITY_VALIDATION.md);
the runtime/classification plan [3D_ANIMATED_REMASTER_PLAN.md](3D_ANIMATED_REMASTER_PLAN.md); the live
claim board [SPRITE_REMASTER_STATUS.md](SPRITE_REMASTER_STATUS.md); ready‑to‑dispatch parallel prompts
[SPRITE_REMASTER_AGENT_PROMPTS.md](SPRITE_REMASTER_AGENT_PROMPTS.md); the **motion categories & Policy A
(faithful) handling** [SPRITE_CATEGORIES.md](SPRITE_CATEGORIES.md).

---

## F. Frame-matched 3D (2026-09-22): the current publishing path

**Principle.** Each ORIGINAL SD frame (`extracted/sprites/<sheet>/fNN_WxH.png`, never the HD upscale,
so no detail is lost) gets a 3D-rendered replacement whose pose is **fitted to that frame** and
**gated against it**. The replacements keep the original frame index, so the game's own frame logic
(Wheelie `+0x56`, Creeper grow counter, cannon-ball tick, Smiley x-roll...) drives them with the
original timing. No live 3D runtime is needed; the stills/free-spin flow below is now the look-dev stage.

**Tool:** [framematch.py](../tools/soi3d/framematch.py) (host Python) + [frames_blender.py](../tools/soi3d/frames_blender.py)
(Blender side, GPU OptiX when present). A builder opts in with
`soi3d.register_frames(mode, setup, pose)`: `setup(opts)` builds the model and scene once;
`pose(ctx, params)` moves it (return True if it rebuilt the scene). Call `C.apply_look(opts)` after
`setup_scene` so the shared look knobs (`world`, `key`, `fill`) work.

**Config** = your family's own `extracted/sprites_3d/<family>/frames.json` (schema in the framematch.py
docstring): `source` sheet, `frames` (list / `{"range": [a, b]}` / `"all"`), `mode`, `opts`,
`frame_opts` (per-frame variants, e.g. a clock's fill), `sweep` axes (`param`, `start`, `stop`, `step`,
`period` for periodic ones), `smooth` per param (`loop` / `linear` / `fourier:N` / `const` / `mode` /
`fixed:A:B` / `free`), `optim` (per-frame multi-parameter pose refinement), `shift` (`"auto"` = fit an
integer SD-px offset per frame, for sheets that move the object between frames), `place_iou_w`
(silhouette weight of the placement fit), `look` (`params` = candidate values for a coordinate-descent
colour/light calibration, `refine` = continuous ±step refinement of numeric options such as feature
sizes), `post` (e.g. the glint), `gate`, and `status` (`published` | `wip` + a `note` saying why).
Shared look knobs (`C.apply_look`): `world`, `key`, `fill`, `key_dir` (direction to the key light),
`gamma`.

**Run:** `py tools/soi3d/framematch.py <family>` (stages `sweep fit optim look final verify`, or name some).
1. **sweep** renders the pose grid once per option group.
2. **fit** fits one 2D placement (scale/offset) for the family by coordinate descent (plus per-frame
   offsets with `shift`), picks each frame's best pose, then smooths the poses over the frame order.
3. **optim** (optional) refines each frame's pose parameters together (±step descent, batched).
4. **look** calibrates colours, lights and (with `refine`) geometry against a frame subset.
5. **final** renders every frame at 4x its SD size (camera derived from the placement) and writes the
   overlay `extracted/sprites_3d_frames/<sheet>/fNN_{4W}x{4H}.png`.
6. **verify** downscales each 3D frame back to SD and writes `_verify/frames_{report.json,sheet.png,anim.mp4}`
   (the sheet shows SD | 3D per frame; the mp4 plays them side by side).

**Gate (per frame, all must hold):**
- silhouette IoU ≥ `gate.iou`;
- **blurred** mean dE76 ≤ `gate.de` (σ = 1 SD px, which discounts the source's dithering but not a
  wrong shape, pose or hue);
- frame **identity**: the 3D frame matches its own source frame best, within ±`rank_tol` frames.

`py tools/soi3d/framematch.py --check` re-verifies every `published` family read-only and flags any
overlay frame no published family owns. It is gate stage 5 (`tools/verify.ps1`). **A failing family
is set to `wip` and its overlay frames are deleted**, so `--3d` never shows an unverified frame.

**Runtime:** `--3d` = `--hd` + the overlay (per-frame fallback to HD); **F3** toggles HD ↔ 3D live.

**Status (2026-09-25, 1079 frames published):**

| Published (gate passes) | Frames | IoU min | blurred dE mean / max |
|---|---|---|---|
| `block_sprites` (24 tile types; `tile.py`) | 150 | 0.960 | 7.0 / 13.1 |
| `robo_sprites` (the Robo f02-f81: walk, turn, punch; `robo.py` two eyes; documented gate dE 17.5 for 4 frames) | 80 | 0.861 | 14.4 / 17.1 |
| `BP_sprites` (the blue player f50-f117: walks, pushes, jumps; `kid.py` rig + eyes) | 68 | 0.851 | 12.2 / 15.7 |
| `GP_sprites` (the green player f50-f117: BP_sprites' fit and look with a green sweater) | 68 | 0.851 | 11.1 / 14.7 |
| `BP_run` (the blue player's run f02-f49; documented gate dE 17.5 for the stride frames f07/f19) | 48 | 0.850 | 12.8 / 17.1 |
| `GP_run` (the green player's run; BP_run cloned; documented gate IoU 0.845 / dE 17.5 for f24/f19) | 48 | 0.848 | 11.9 / 16.3 |
| `teeth_sprites` (the chattering Teeth f02-f50; `teeth.py`) | 49 | 0.855 | 11.3 / 15.4 |
| `walker_body` (the Walker f02-f49; `walker.py` block legs; documented gate IoU 0.845 for f36) | 48 | 0.847 | 10.3 / 12.9 |
| `smiley_sprites` (Smiley; `smiley.py`) | 48 | 0.974 | 9.8 / 11.8 |
| `hippo_sprites` (the Hippo walk f02-f33; `quadruped.py`) | 32 | 0.857 | 9.5 / 11.7 |
| `beenie_shot_l`/`_u`/`_r` (the Beenie spread shot f02-f49; `rods.py`) | 48 | 0.833 (`_r` gate 0.83) | 10.1-11.1 / 15.3 |
| `piggy_sprites` (the Piggy walk f02-f33; `quadruped.py` species piggy) | 32 | 0.859 | 11.0 / 13.9 |
| `Stop_Go_sprite_family` (flip; `sign.py` `sign_flip`) | 40 | 0.975 | 13.3 / 15.8 |
| `disk_sprites` (Wheelie) | 24 | 0.996 | 12.8 / 13.7 |
| `cannon_ball` (cannon_sprites f04-f23) | 20 | 0.929 | 13.9 / 16.6 (gate 17, 16 px source) |
| `spinner_sprites` (Spinner; `spinner.py` `build_spinner_front`) | 16 | 0.867 | 11.7 / 13.7 |
| `walker_bolt` (walker_sprites f50-f65; `bolt.py`) | 16 | 0.863 | 8.1 / 12.7 |
| `bigger_mblock` (the M block collapse; `mblock_collapse.py`) | 15 | 0.860 | 10.0 / 15.6 |
| `master_egg` (the Gargoyle egg, f47-f61; `egg.py`) | 15 | 0.898 | 14.9 / 15.6 |
| `master_compound` (Gargoyle pierce puff, f02-f16; `compound.py`) | 15 | 0.902 | 10.6 / 12.1 |
| `master_giftbox` (Knight's gift, f17-f31; `giftbox.py`) | 15 | 0.946 | 11.6 / 13.5 |
| `master_cluster` (Gargoyle puff, f32-f46; `cluster.py`) | 15 | 0.883 | 5.8 / 6.8 |
| `transporter` (the teleport zap; `transporter.py` `build_zap_px`) | 15 | 0.858 | 11.8 / 14.8 |
| goodies: mult f13-16, clock f20-23, gold bars f26, coins f11/f24, magnifier f48, star f12, 1UP f17, potion f18 | 15 | 0.866 | 7.2 – 15.6 |
| `goody_props` (doors f02-f07, keys f08-f10, Magic Arrow f19, gold frame f25; `goodies.py`) | 11 | 0.901 | 10.6 / 14.7 |
| `goody_arrows` (arrow tiles f27-f36; `tile.py` kind arrows) | 10 | 0.984 | 8.5 / 10.1 |
| `goody_switch` (switch tiles f37-f46; `tile.py` kind switch) | 10 | 0.988 | 9.4 / 11.7 |
| `goody_misc` (turtle f47) + `goody_gift` (gift box f52; `goodies.py`) | 2 | 0.889 | 9.3 / 15.2 |
| `goody_gear` (shield f49, winged helmet f50) + `goody_shoe` (sneaker f51; `goodies.py`) | 3 | 0.872 | 7.7 / 14.8 |
| `spin_ind_shield` (the speed indicator's shield, one turn in 30 frames; `goodies.py` shield spun) | 30 | 0.875 | 4.4 / 5.9 |
| `spin_ind_shoe` (the speed indicator's winged shoe, one turn; `wingshoe.py`; 16x12 gate IoU 0.83 / dE 16.5) | 30 | 0.836 | 11.6 / 16.2 |
| `weapons` (the player's swirl ball f02-f09; `spiral.py`) | 8 | 0.953 | 9.2 / 9.5 |
| `block_question` (the '?' tile f146 + crack + quarters; `tile.py`) | 6 | 0.965 | 11.5 / 14.6 |
| `weapons_arrow` (the straight shot f10/f11; `arrow.py`) | 2 | 0.920 | 8.4 / 9.9 |
| `cannon_barrel` (cannon_sprites f02/f03; `cannon_barrel.py`) | 2 | 0.973 | 14.7 / 15.7 |
| `emblem_hippo`/`_piggy`/`_ostrich`/`_smiley`/`_ant`/`_hammer` (each nasty's SPAWNER block, the last 32x32 frame; `tile.py` kind emblem) | 6 | 0.999 | 7.9 - 11.2 |
| `emblem_teeth` (the Teeth's spawner f51: the teeth in a blue ball's window; `teeth.py` mode teethball) | 1 | 0.932 | 15.3 |
| `BP_cheer` (the player's front-view cheer f118-f126, 36x34; `kid.py` with cartoon eyes) | 9 | 0.860 | 13.6 / 15.7 |
| `GP_cheer` (the green player's cheer: BP_cheer's fit and look with a green sweater) | 9 | 0.861 | 12.5 / 13.5 |

WIP (`note` in each `frames.json` says what fails; passing frames / total): `ant_sprites` (40/49, `ant.py`: the front-view turn frames render pinkish greys),
`ostrich_sprites` (19/32, `biped.py`), `Gargoyle_sprites` (22/73, `gargoyle.py`: IoU 0.861, dE 16.1; the egg rises
via `egg_y`), `hammer_walk` (`hammer.py`: dE 18.5), `BP_tumble` (0/32, IoU 0.72: four 8-frame rolls, the body
shape is wrong), `knight_sprites` (0/65, `knight.py`: IoU 0.739, no armour highlights), `beenie_char` (0/56, IoU
0.71: needs re-proportioning) and `beenie_shot_d` (the down set flies toward the camera and is masked by the Beenie).
Not started: `blocks` (not drawn by the port) and the Hammer's swing (f50-f81). The Hippo and Piggy show the
recipe: a rig in SD px units with per-limb pose keys fitted per frame by `optim`.

**Derived frames** (`derive` in frames.json): a frame the original builds from another is built the
same way from its 3D render: `crop` (the four shatter quarters are exact crops of the block),
`scale` (the spawn squares are the white block shrunk), `crack` (the source's crack lines composited
onto the 3D block). One tile render feeds six frames, and every derived frame is still gated.

**Per-kind look** (`look.per_kind` = {kind: {opt: [candidates]}}): each option group (e.g. each tile
type) calibrates its own colour gains / feature sizes, all groups batched into one Blender job per option.
The look score adds a steep penalty once the silhouette IoU nears the gate, so a colour or shape tweak
can never buy dE with a worse outline.

**Lessons from the first families:**
- **Let the fit reveal the real model.** The beach ball fit badly as three 120° gores. The residual
  pattern (picks advancing 10°/frame, then jumping 60°) and the centred band covering about half the
  width showed it has **six 60° gores** (R, B, G twice), and its 20 frames are a half turn (9°/frame).
  The Gargoyle puff "gem" was really a **cube/octahedron compound** (dE 43 as a bipyramid, 10.6 as the
  compound). A high dE with a coherent pose fit means the model is wrong, not the look.
- **Mirror-order trap.** No spin reaches a mirrored colour order, so fix the order from one frame
  (left→right on the source) before sweeping.
- **Symmetry = period.** Give a periodic axis its true symmetry period (disk 90°, spinner 180°, ball
  180°). `loop` snaps the slope so the N frames cover whole periods; the wrong period makes it snap wrong.
- **The originals were 3D renders with deep shadows.** The look stage consistently lowers ambient and
  fill: the SD shadow side is near-black in-hue, and the palette is pure primaries on the lit side.
- **Extra pose dims only when they pay.** The disk's hub tilt (a 2430-pose sweep) changed nothing, so it
  was dropped. Sweep cost is about 0.2 s per pose on the 4090; keep grids lean.
- **Object texture coordinates are the mesh's local space.** A cube scaled by its object transform
  still spans ±0.5 locally, so map `[-0.5, 0.5]` to the image, not the scaled size.
- **Stray files break frame lookups.** `extracted/sprites/master_s_objects/f02_24x24_x16.png` (and
  f05/f08) are old inspection zooms committed in July; both the game and framematch now parse names
  strictly as `fNN_WxH.png`.
- PowerShell 5 `Set-Content -Encoding utf8` writes a BOM; `load_cfg` reads `utf-8-sig`.

**Lessons from round 3 (Smiley, Spinner, swirl, arrow, gift box):**
- **Measure on character grids.** Dump the SD frame as one letter per colour class (and the render the
  same way, side by side) and read part positions, sizes and slants off it. Every model that passed was
  built in SD pixel units from such a dump (`arrow.py`, `spinner.py` use `S = 0.1` units per SD px).
- **Print every frame's bbox and centroid first.** The Smiley sheet alternates the ball 2 px left/right
  between odd and even frames; with one placement every other frame failed. `shift: "auto"` fixed it
  (IoU 0.88 → 0.97).
- **Measure the light.** A least-squares fit of linear intensity against the sphere normals of a
  plain-coloured region gives the key direction: the Smiley's light comes from the TOP (−0.26, 0.70, 0.66),
  not 45° top-left, with a harder falloff (`gamma` 0.7).
- **Trace each moving part separately.** The Spinner's two bars COUNTER-rotate: at f07 the upper cone
  points left while the lower points right, which no common rotation produces. Each bar carries its two
  cones on opposite faces at opposite ends, so the prop is 2-fold symmetric and f02..f17 is one half
  turn at exactly 12°/frame (`smooth` `fixed:0:12`; the free fit could not tell +θ from −θ).
- **Rotating patterns: k-fold ring phase.** Per 1-px ring, `angle(Σ w·e^(−ikθ))/k` gives the pattern
  phase against radius (the swirl's arms follow α = −(a + b·ψ²)) and, per frame, the rotation rate.
  Paint such patterns with a shader on Object coordinates, not per-face materials.
- **Continuous look refinement beats 3-value candidate lists** for geometry: `look.refine` took the
  Spinner from dE 15.6 to 11.3 and the gift box from 18 to 11.6. Give every refined option its builder
  default as `init` when it is not in `opts`.
- **Raised details stick out of the outline.** The gift box's '?' glyphs stand ~3 px proud, so face-on
  the side faces' glyphs show as blue strips beyond the cube's silhouette.
- **General subagents did poorly here** (4 of 5 families failed): they eyeballed instead of measuring
  and could not extend the pipeline. Working the family directly with the grids above succeeded.

**Lessons from round 4 (cluster, transporter, bolt, potion, 1UP, '?' tile):**
- **Keep the model inside the sweep camera** (±1.07 units): a model larger than that is rendered cropped
  in the sweep, so the placement fit goes wrong (the transporter at 0.1 units/px was cropped; 0.05 fixed
  it). The sweep now warns when renders touch the canvas edge.
- **Some originals were perspective renders.** The Walker bolt is ~17% bigger on the near half of its
  orbit; `bolt.py` scales the prop by d / (d − z) per pose (`persp_d`).
- **Keyed edges.** The originals were anti-aliased against black and keyed, so their outlines carry an
  opaque dark rim; post `fringe` (grow the alpha 2 render px, new pixels black) reproduces it. It fixed
  the thin bolt's IoU; `matte` (a steeper alpha ramp) did not.
- **Guard the outline in the look** when geometry is refined: `look.iou_w` / `iou_margin` raise the IoU
  penalty (the bolt's refine otherwise shrank the rod for a lower dE).
- **Read motions from the frame symmetry.** The cluster is an octahedron of six balls with a 2-fold
  (edge) axis vertical: '+' view at 0° (the short arms are front/back pairs), 'X' plus a front ball at
  90°; the transporter's rings are two tori whose normals (cos t, ±1, −sin t)/√2 give the edge-on X at
  0° and one wide ellipse at 90°. Both are 12°/frame half turns.
- **Constrain a feature the refine can trade away** (the potion's lip is now neck + an overhang ≥ 0.5 px,
  since the refine had shrunk it inside the neck). Fonts are a look candidate list; stretched glyphs
  (`text_sy`, `sym_sy`) matched the '1UP' and '?' art.
- `verify` now removes a failing non-published family's overlay frames, so `--check` never finds strays.

**Lessons from round 5 (M block collapse, Teeth, Hippo, Piggy):**
- **Walk cycles need per-limb pose keys.** One `phase` cannot reach every drawn frame; `quadruped.py`
  adds per-leg angle offsets (`a_fn`, `a_ff`, `a_rn`, `a_rf`) that `optim` fits per frame (Hippo: 13
  identity failures -> 0, dE mean 11.2 -> 9.5). Run `sweep fit look optim final verify`, bake `look.json` into `opts`, then re-run
  `sweep fit optim final verify` (and `look` again) until it passes.
- **Re-read the silhouette before refining.** The first Piggy had a hippo-like head, a straight-up
  cone and short legs (dE 16.7). The drawn Piggy has no separate head: eyeballs sit on the body's
  front-top, a trumpet snout (neck + flare + rim) goes up-forward, a striped tail rises at the back,
  and the legs are long. Rebuilt from a zoomed montage it passed (dE 11.0).
- **Look-alike frames are not identity errors.** A walk cycle repeats near-identical drawings, so the
  identity check now also passes when the best-matching source frame is within `rank_margin` (0.75) of
  the own frame's score, or when the two source frames differ by less than the render's own error.
- **Sequenced props (the M block)** get a timeline key `t` plus per-frame optimised offsets (`pre`) and
  per-band start frames in `opts` (`start0..5`), so each bar leaves on its drawn frame.
- **The Teeth depend on the stage order**: `sweep fit optim look final verify` passes; other orders
  landed in worse minima. Their explicit per-frame `shift` (even frames ±2 px) comes from printing
  each frame's bottom-row x range.
- After a failed `verify` (which deletes a WIP family's overlay frames), re-run `final` before verifying
  again.
- **Pose priors.** A walk drawn side-on can still be matched better by a 3/4 view of a slightly wrong
  model (the first Ant fit picked yaw 115-285 for side-view frames). `prior` =
  [{"frames": [a, b], "param": "yaw", "value": 0, "tol": 20, "period": 360}] adds w*(dist/tol)^2 to the
  sweep pick of those frames. (The Ostrich, in contrast, really is drawn ~40 deg toward the camera: check
  the per-yaw best score before adding a prior.)
- **Cast shadows** (`"shadows": false` in `opts`, or as a look candidate) turn off shadow casting while
  keeping N.L shading; thin parts under a body (necks, legs) otherwise go black.
- **A geometry refine makes the placement stale**: after `look` changes sizes, bake `look.json` into
  `opts` and re-run `sweep fit`; a `final` on the old fit renders the new model at the old placement.
- **The egg is not a sphere**: a zoomed look showed a near-square striped cushion. Its bands are one
  shader on Object coordinates (u = x - y + scroll, a constant ColorRamp); the fitted scroll fell
  1.8 px of u per frame, so `smooth: loop` makes the 15 frames one period.
- **Tiny sprites live on their keyed rim.** For the 16x12 winged shoe the post `fringe` moved the IoU
  mean from 0.67 (0 px) to 0.78 (1 px) and 0.85 (2 px; 3 px: 0.82), and `shift: "auto"` (range 2)
  fixed a few more frames: at that size one pixel ring is a large share of the silhouette.

**Lessons from round 7 (the Beenie spread shot, Walker body, Robo, the players):**
- **Look at the failing frames side by side before tuning.** The spread shot's last four failures
  (dE 16-24) came from one wrong assumption: the three rods are not a fixed cone, the bundle opens
  from ~10 to ~30 deg as it flies. Making the half-angle a pose key (`rods.py` "half", swept and
  optimised per frame) passed all 16 frames (dE 13.3 -> 10.1). Checks that ruled things out first: a
  depth-mirrored rod order (the spin direction is ambiguous in 2D; the mirror was far worse), an axis
  tilt toward the camera, uneven rod spacing.
- **One model, four directions.** The spread shot has left/up/right/down sets of 16 frames: one family
  per direction (`dir` 0/270/180/90) with the same baked options.
- **Mechanical characters are cylinders, not balls.** The first Robo (balls and capsules) reached IoU
  0.87 but dE 17.5; the source is stacked cylinders with white rings (`robo.py` `_cyl`).
- **Recoloured sheets share a fit.** GP_sprites has the same silhouettes as BP_sprites (alpha IoU 0.994).
- **Sub-pixel offsets.** `optim` params `_dx`/`_dy` (SD px) move a frame's sprite offset in fractions of a
  pixel and are folded into its `shift`. A 30-px first frame still sat at IoU 0.833, so `beenie_shot_r`
  documents a 0.83 IoU gate (as the 16-px cannon ball documents dE 17).
- **Reseed from neighbours.** Walk frames that match a neighbour's source best (identity 13 -> 8) are stuck
  in the wrong phase basin; `optim.reseed` = {"window": w} scores each frame with its w neighbours' poses on
  either side first and starts the descent from the best one.
- **Let the refine not paint over pose errors.** The Walker's refine thickened its thin stick legs into
  blocks (leg_r 2.15) to cover mis-posed legs; cap such sizes to what the source shows.

**Lessons from round 8 (all the goodies, the Ant, Hammer and players):**
- **Trust only images you actually saw.** The image viewer sometimes returns a "previously shown"
  placeholder with no pixels; judgements made from such results were wrong (the Ant was "rebuilt as boxes"
  and the Walker's head was "capped" on no evidence, both reverted). Back every visual claim with a char
  grid, an RGB dump or a per-row extent; they settled the Ant (glossy balls + thin slanted legs) and the
  Walker (its head really is taller than the body).
- **The dE is over the silhouette union.** A pixel covered by only one side scores against black (a red or
  white pixel vs black is dE 50+), so at IoU 0.85 the outline alone adds ~7 to the mean dE. When a family is
  stuck at dE 16-17 with IoU 0.85, fix the silhouette; colour candidates will not move it (the Robo's
  brighter, glossier and more saturated reds were all rejected).
- **Check for a thickness bias before blaming the pose.** Compare the source alpha with the render alpha
  dilated and eroded by 1 px: for the Robo, Walker and Ant both only lowered the IoU and the pixel counts
  matched, so their ~0.86 plateaus are pose/shape, not outline weight or the fringe.
- **At most four framematch jobs at once.** Each Blender/OptiX render process holds 2-3 GB of the 24 GB GPU;
  ten parallel jobs ran it out of memory and seven died mid-run.
- **Finish near misses with a full-fidelity optim.** `optim` scores poses at `scale` 2 / `samples` 8 by
  default; the noisy low-sample edges hide the one-pixel gains that thin legs need. The Walker sat at IoU
  0.867 with 11 failing frames through capsule legs, block legs, finer steps and reseeding; one pass at
  `scale` 4 / `samples` 32 took it to 0.878 with 3 fails (its start score also dropped 15.5 -> 13.1: the
  cheap renders had been over-scoring every pose). `optim` now takes an optional `"finish": {"rounds": 3,
  "scale": 4, "samples": 32, "step_f": 0.5}`: after the cheap rounds it re-scores every frame at full
  fidelity and polishes with half steps, so a family gets both in one `optim` stage.
- **A look cannot fix a prop's orientation.** The Hammer's mallet hung down (ham0 -90); the look tried
  ham0 = up but rejected it because the per-frame placements were fitted to the hanging mallet. Put such an
  angle in the SWEEP (or set it and re-sweep), then refine. A colour-coded debug render (magenta head, cyan
  handle) found where the part really was in one run.
- **Test a new static item in its own wip family.** Adding a frame to a published family re-verifies all of
  it; a failing newcomer would un-publish the rest. The goodies went in as goody_props / _arrows / _switch /
  _misc / _gift / _gear / _shoe, each published when it passed.
- **Light per item when the original did.** The gift box's big front face sits in shadow (its paper AND its
  ribbon are 0.3-0.45x the lit face): a key from above-left with little camera-side component, and matte
  (spec 0) so no white sheen desaturates the dark greens.
- **Measure outlines per row.** The shield is the crest outline taken from the source's per-row alpha
  extents, extruded and intersected with a big sphere (a convex cap); IoU 0.94 at the first render.
- **Reuse a proven static model for its animated twin.** The speed indicator's spinning shield had failed
  for weeks with its own builder (IoU 0.53 edge-on); the goody shield spun 12 deg/frame, a thinner plate
  (edge-on the source is ~3 px) and a per-frame spin/tilt/sub-pixel optim passed it (IoU 0.903, dE 4.4).

**Lessons from round 9 (Walker published, the spawner emblems):**
- **`optimfail` for the last few frames.** `py tools/soi3d/framematch.py <family> optimfail final verify` re-runs
  the optim on ONLY the frames the last verify failed (passing frames keep their poses), scored exactly as
  verify scores them (the final scale and sample count: at 32 samples the edge noise moved the Walker's f36
  IoU by 0.005 against verify's 256), with a steep IoU weight (400) so a failing outline is not traded for
  dE, neighbour-pose reseeds and four basin-hopping restarts (random +-2 steps, keep only improvements).
- **Look for joints pinned at a limit.** The Walker's f04 and f05 had knees at the -30 deg clamp; widening
  it to -60 passed f04. Print the failing frames' poses and compare every value against its min/max.
- **A documented gate for one stuck frame** (like `beenie_shot_r` 0.83 and `cannon_ball` dE 17): the Walker
  publishes at IoU 0.845 because f36 stays at 0.847 after every optimfail variant; the note says why.
- **The last 32x32 frame of each nasty's sheet is its SPAWNER block** (game.gd `_draw_enemy`: frame 0x21/0x31/
  0x32/0x51 + 1), a red block with a silver statue of the nasty, so it IS drawn. `tile.py` kind `emblem`
  builds a red slab plus a silver relief whose outline is the source statue's mask and whose height adds a
  shape-from-shading term: along each down-right diagonal (the light comes from the top left) the height
  rises where the statue is brighter than its mean, each run returning to the base. Lit from the top left
  the relief reproduces the original's highlights, dark lower-right sides and cast shadow (dE 10-16 with the
  mask pillow alone; 7.9-11.2 with shape from shading). The Teeth's f51 is a blue mouth ball, not a block.
- **Colour gains for the kid rig.** `kid.py` and `hammer.py` take `<colour>_gain` for every colour option, so
  a look can refine the skin, hair, sweater, trousers, shoes, stone and handle continuously.
- **Characters that are far off need their proportions measured first.** The Knight's first fit (IoU 0.65)
  came from arms ~40% too short (the source's hands reach row 53, 26 px below the shoulder) and a helmet 2
  rows too tall; per-row extents of the standing frame (f02) show it before any sweep.
- **Back up `fit.json` / `look.json` before a structural experiment.** Two Ant experiments failed: legs thinned
  from a 1.1 to a 0.75 px half-width raised the dE 12.5 -> 15.4 (the source's legs are white strokes WITH dark
  outlines, so the wide bars were right), and flatter body balls with vertical legs plus a re-sweep fell to
  IoU 0.73 from 0.88. Restoring the copies brought the family straight back to its best state.
- **`look` always starts from `opts`, never from the last `look.json`.** Four look passes on the Teeth's spawner
  each restarted at dE 22.6, and the fourth ended at 18.3, worse than the third's 16.8. The `bake` stage
  (`... <family> bake look final verify`) folds `look.json` into `opts` and the refine `init`s first.
- **The placement's scale steps now pivot about the model's centre.** They used to scale about the render's
  corner, so every scale step also slid the model by a pixel or more and was rejected: the Gargoyle's `k` never
  moved from its bounding-box guess in three fits while its head hit the top edge. `place_frames` [a, b] fits
  the shared placement on the frames the model already matches (the Gargoyle's spread-wing f21-f33).
- **A turn shows in the data before any fit.** The Robo's f51-f66 fitted yaws jumped 154 -> 61 -> 237 -> 56;
  per frame, the white face-plate pixels in the head rows (12 -> 31 -> 15) and the mirror symmetry (0.87 -> 0.95
  -> 0.71) peak at f58: one turn from 180 through face-on (90) to 0 deg, so a linear yaw seeds `optimfail`.
- **Probe grids for limbs the descent cannot reach.** BP_run's f07 holds its front arm straight out; from a hand
  at the hip every +-12 deg step passes through worse silhouettes, so the descent never gets there. `optim.probe`
  grids (shoulder x elbow per arm, thigh x knee per leg) inside `optimfail` moved it (IoU 0.825 -> 0.856) and
  passed f17 and f41 in one run; the family went 45 -> 7 failing frames with optim + finish + optimfail.
- **A different canvas size is a different animation.** BP_sprites' f118-f126 are 36x34 (the rest 32x31): the
  player faces the camera and cheers (arms at the sides, a T, a V). They share no placement with the rest, and
  the rig's shoulders and hips only swung in the side plane, so no pose could spread them. They are now their own
  family (`BP_cheer`), and `robo.py` has abduction keys `b_n`/`b_f` (arms raised sideways) and `h_n`/`h_f` (legs).

**Lessons from round 10 (BP_cheer published):**
- **Diagnose a failing frame per colour before tuning anything.** `py tools/soi3d/fm_diag.py <family> <frames>
  [--map]` prints each source colour's share of the blurred dE (with the render's mean colour at those pixels),
  the missing/extra silhouette rows, and an ASCII class map of the source beside the render. It found in minutes
  what several look passes had not: features the model does not have.
- **The kid has big white cartoon eyes.** In the head rows of the source: 10-12 white pixels per cheer frame
  (a 4x2 band with blue pupils under the hairline), 3-8 in the side-on run and walk (one pixel at the face's
  front edge), none in back views. `kid.py` "eyes": two thin ellipsoids flush on the head (a round eye bulged the
  profile and cost IoU in the side views) with pupils, placed by `eye_el`/`eye_az`/`eye_r` and look-tuned per
  family. BP_cheer went 4/9 -> 8/9 passing frames; its dE mean 14.5 -> 14.1.
- **A wrong 1 px shift can hide behind the pose.** BP_cheer's f125 had a fitted shift of one row up; the legs had
  gone onto tiptoe (ankles 65 / 39 deg) to reach the bottom rows, and every optim round stayed in that basin
  (dE 17.6). With the shift zeroed, the optim reached dE 13.0. `optimfail` now finishes with four shift hops
  (+-1 px in x and y, full-size steps, keep only improvements; a second pass after any gain reaches +-2 px);
  optim `"shift_hops": false` turns them off. The hops were the round's biggest single gain: the Robo went 57 ->
  74/80 in one optimfail (f16 score 20.8 -> 13.1, f38 24.7 -> 15.6), BP_sprites f82 17.0 -> 12.4, the shoe
  22 -> 24/30.
- **Probe grids only help when the pose is the problem.** The Ant's yaw x phase grid and the shoe's full-turn
  spin grid changed nothing (scores 33.61 -> 33.48 and 41.30 -> 41.29), and a uniform 12 deg/frame spin for the
  shoe failed 18 frames against the fitted spins' 8. Their fails are colour and shape.
- **A light change moves the keyed fringe.** The shoe's side views render the white toe ~95 instead of 211-241;
  a key light from the left lowered the look subset's dE 17.3 -> 16.4 but its fringe (the dark keyed rim) moved
  with the shading and the verify fell from 22 to 19 passing frames. Judge a look change by the full verify.
- **`look.add_fails`** also scores the last verify's failing frames, so the look cannot improve the easy frames
  at their expense.
- **`optimfail` caps the IoU margin at 0.01.** The look's score is dE + iou_w x max(0, gate + margin - IoU); with
  the Robo's margin 0.03 and optimfail's iou_w 400, f46 (failing on dE only) bought IoU up to 0.88 at +3 dE.
  optimfail scores at verify fidelity, so a 0.01 margin is safe and lets dE drive once the outline passes.
- **The green player is the blue player recoloured.** GP_sprites has BP_sprites' 157 frames, same names and
  sizes; per frame ~80-100 pixels differ, nearly all the sweater (blue shades -> green shades, its dark
  shadows and a few blended sweater/trouser pixels) plus 0-4 outline pixels. A published BP family clones:
  copy its `fit.json` and `frames.json` (source `GP_sprites`, a green `sweater`, a look over the sweater only),
  then `optimfail` the few frames the outline pixels move. GP_cheer passed that way (dE 12.5 vs BP's 13.6).
- **Two hypotheses the full verify rejected:** white socks on the kid's lower shins (the tall white columns in
  BP_run f07/f19 are pointed shoes) raised the dE in 47 of 48 frames, and a key light mirrored to the right
  helped f07 but raised the mean dE by 2.8. Test a model idea on the whole family before keeping it.
- **Publishing a family whose last WIP verify failed needs `final verify`, not just `verify`.** The failing WIP
  verify deleted its overlay frames, so a bare `verify` after setting `published` scored every frame 0 and
  `--check` failed until `final` re-rendered them.
- **A free head turn can face backwards.** BP_run's f24 fitted `hd` 189 deg (the back of the head where the
  source shows the face and eye); holding `hd` to +-60 for one pass fixed it, and both run families now keep
  +-90.

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
