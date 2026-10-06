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

## H. HANDOFF (2026-10-05): state, the HD-reference review loop, and what is open

**State.** All 67 families are published (frame-matched 3D, `extracted/sprites_3d_frames/`), the full gate
(`tools/verify.ps1`) passes, and rounds 31-42 (user review against the HD reference art) are uncommitted --
the user commits. The per-round detail is in §F's ROUND 31-42 paragraphs; this section is the short version.

**Keep these when committing (git-ignored today):**
- `tmp/soi3d_work/<family>/{fit.json,look.json}` hold every family's fitted poses, anchors and calibrated look.
  `look.json` opts OVERRIDE `frames.json` opts. Without them a clone cannot reproduce the published frames
  (`final` needs fit.json). Force-add them (`git add -f`) or back them up before any cleanup.
- The review tools below live in `tmp/` (ignored). Only `apply_opts.py`, `hold_pose.py`, `frame_test.py`,
  `pop_scan.py`, `opt_grid.py`, `set_opts.py` are tracked. Force-add the rest or promote them to
  `tools/soi3d/`. Per-round backups: `tmp/fb_backup/<family>/*_rNN_pre.json`.

**Review tools (`tmp/`):** `opt_probe.py` (variant probe + montage), `apply_both.py` / `apply_opts.py` (set opts),
`zoom_review.py out.png fam:nn ...` (LANCZOS close-up sheet of published frames), `gear_design.py` /
`gear_wing.py` / `shield_design.py` (outline tracing on the card grid), `hold_param.py <fam> <param> <v|median>
<tol>` + `set_tether.py` + `tether_scale.py` + `scale_anchor.py` (fit.json anchors + optim tether),
`run_smooth.py` (one smooth run cycle -> anchors), `hold_pose.py` (seed + re-optimise chosen frames),
`refit_place.py <fam> --apply --rerender` (placement-only refit), `players_opts.ps1` (opts on all 8 player
families), `pdf_imgs.py` (card images), `pose_table.py`, `pop_scan.py`, `de_map.py`, `row_bias.py`.
Inline refine of chosen frames: `py -c "import sys; sys.path.insert(0,'tools/soi3d'); import framematch as fm;
fm.stage_optim('<fam>', fm.load_cfg('<fam>'), only=[16,17])"` then `final verify ...`.

**The review loop (one user remark -> one fix):**
1. `py tools/soi3d/ref_compare.py [family ...]` -> `extracted/sprites_3d/<family>/_verify/ref_compare.png`
   (HD reference | SD | 3D | 3D grey). References: `REFS` in ref_compare.py -- the reference card
   (`refs/text/StepOnItRefCard.pdf`, image index: 6 Ted run, 7 block, 9 shoe, 10 kill-all ball, 11 coin,
   12 bar, 13 door, 14 key, 15 shield, 16 ant, 17 ostrich, 18 hippo, 19 piggy, 20 smiley ("Wheelie"), 21 arrow,
   23 magic ball, 24 Beenie), box art pages 3/4, picts 300 (Knight, Gargoyle), 320, 1010, 1030 (Ted).
2. LOOK CLOSER before modelling: crop the card and our frame side by side at 400-500 px (the 990 px sheet hides
   most faults); also the SD at 8-16x NEAREST -- the SD decides what the gate will accept.
3. Trace shapes on a grid: `tmp/gear_design.py` (wing outline vs card + SD red), `tmp/shield_design.py`
   (mirrored half outline vs card + SD silhouette, prints IoU). Outlines are `(col,row)` cell coords.
4. Add an OPT-IN builder option (default = old behaviour) in `tools/soi3d/builders/<mode>.py`.
5. Probe: `py tmp/opt_probe.py <family> <nn> '@variants.json' --zoom N` (one Blender job; prints IoU / dE /
   visIoU / miss per variant, montage `tmp/opt_probe_<family>.png`). Probe the family's TIGHTEST frames too
   (`_verify/frames_report.json` rows sorted by de).
6. Apply: `py tmp/apply_both.py <family> '@opts.json'` (frames.json + the same keys in look.json; per-frame
   options -> edit `frame_opts` with json.dumps(indent=1) + LF). Then the stages:
   goodies `final verify`; animated families `final verify optimfail final verify tweens live livecal livegate`;
   families with `frame_opts` (Gargoyle) have no live rig: `final verify optimfail final verify tweens`.
   Template for a multi-family batch: `tmp/r42_apply.ps1`.
7. Full gate (visible terminal), then delete only UNTRACKED screenshots:
   `powershell -ExecutionPolicy Bypass -File tools/verify.ps1 2>&1 | Select-String '^\[|STAGE|FAILED|FAIL \['`
   then `git ls-files --others --exclude-standard media/screenshots | ForEach-Object { Remove-Item $_ }`.

**Traps found in this pass:**
- Removing a key from frames.json does not remove it: look.json still applies it (old wing saw kept cutting new
  wings). Sync both (`apply_both.py`).
- A raised part can hide another: the coin's crescent at r 0.76 sat under the rim torus (0.69-0.86).
- Cast shadows of front parts read as offset copies (kill-all wings); the HD art's dark areas may BE shadows,
  not materials (the ball's lower half) -- try white + shadows before a dark material.
- An open mouth cut only in the jaw shows the head sphere inside it (hippo `muz_cut` hollows the head).
- Primitive muscles look stuck-on (abs as ovals/boxes); join a limb's parts and voxel-remesh + smooth
  (`gargoyle.py` `_fuse`, `fuse_vox`/`fuse_smooth`).
- A new pose key (piggy `a_tail`) needs an object pivot + `_frames_pose` support + an `optim.params` entry, then a
  full `optim`; the live export records every object's transform, so it carries over.
- `live` refuses families with `frame_opts`; a Godot "!configured" crash in livegate is transient -- re-run
  `live livecal livegate`.
- PS 5.1 strips quotes from inline JSON args: always `'@file.json'`. PowerShell's ConvertFrom-Json rejects some
  valid files (case-duplicate keys): validate JSON with Python.
- The PC crashes under sustained load (CPU degradation): run ONE Blender job at a time; after a crash check the
  work JSONs with Python and re-run the interrupted stage.
- `view_image` can return a "previously shown" placeholder with no pixels: never describe it; ~20 images per
  request -- combine views into one sheet.

**Tight frames (near the dE 16 gate; re-check after any change there):** blue door goody_props f06 (15.75),
Gargoyle f09/f73 (~15.7), piggy live f16 (15.68).

**Open items (tried and kept as is, or not started):**
- Magic shoe: the card's broad feather fan drops IoU below the gate (0.81 at `feather_w` 2.6).
- Gold bar: the card shows one framed bar, the game sprite is a stacked pile (silhouette IoU 0.40) -- no fix.
- Beenie: the card shows sunglasses, the game sprite a clown face -- kept the game's.
- Ostrich: the card's three-claw feet; Ted kneeling/front poses have no matching game frame.
- Gargoyle: arms still read beaded and the torso smoother than the title art; its frames are near the dE limit.

**Builder options added in rounds 31-42 (all opt-in):** `kid.py` face (`eye_fy`, `ears`, `smile_taper`,
`nose_skin_px`), joints (`shoulder_ball_f`, `elbow_ball_f`, `knee_ball_f`, `seg_bulge`), feet (`shoe_bevel`,
`ankle_ball_f`, `foot_lift`); `goodies.py` kill-all (`ball_r/ball_y/ball_split`, `wing_pts`, `wing_z`,
`wing_shadow`, `wing_saw`*, `wing_tree`*), shield (`sh_half`, `sh_chevron`/`chev_*`, `sh_bev_seg`, `sh_round`,
`stud_cone`, `bulge_seg`, `sh_ridge`*), door (`hinge_leaf`, `leaf_*`, `tongue_h`, `leaf_knuckle`, `keyplate`,
`kp_*`, `frame_tube`, `keyhole`*), shoe (`wing_n`, `wing_cuff`, `wing_out`); `goody_coin.py` (`rim_on`,
`rim_out`, `body_bevel`, `groove_arc`); `quadruped.py` hippo (`muzzle`, `muz_*`, `muz_cut`, `lip_h`, `jaw_h`,
`peg_*`, `ear_z`, `knee_r`, `toe_n`, `jaw_gap`*), piggy (`foot_f`, pose `a_tail`/`a_tail_y`); `gargoyle.py`
(`wing_scallop`, `strap`, `abs_*`, `abs_box`*, `bicep_f`, `delt_f`, `quad_f`, `fingers`, `toes`, `fuse_vox`,
`fuse_smooth`); `tile.py` (`tube_frame`, `well_bevel`); `knight.py` (`helm_point`, `helm_sharp`, `keel_wedge`,
`rough_var`, `aniso`, `grip_clear`, `tip_fwd`); `biped.py` (`wing_fan`, `wing_fan_keep`); `smiley.py`
(`slit_round`); `ant.py` (`foot_ball`, `knee_ball`); `beenie.py` (`gun_coil`). * = tried, superseded or off.
framematch: optim `tether` against fit.json `anchor`, per-frame `tether_scale`.

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
**F2** switches the whole presentation ORIGINAL ↔ REMASTERED (`game.gd _apply_presentation`).

**Smooth rendering (REMASTERED only, 2026-09-26).** The engine keeps the original tick (60 Hz at Medium);
the picture redraws at the monitor's rate. Every entity sprite goes through `game.gd _isprite`, which keeps
a per-tick history and draws the state `SMOOTH_DELAY` = 2 ticks back: its position lerped between the two
keyframes around that time, and its pose the rendered **in-between** of the two frames (`_tween_sprite`).
Without an in-between, a pose tied to ground travel (walk, run, roll) steps with its keyframe instead
of gliding. The board is drawn from the same delayed tick. ORIGINAL draws once per tick, as before.
In-betweens come from `framematch.py <family> tweens` (after `final`): the frame pairs the game
animates between are listed in frames.json `"tweens"` (`cycles` / `runs` / `pairs`, `n` = poses per
step). Each in-between poses both neighbours in Blender and sets every object's local transform part of
the way between them (rotations slerped), so a rig tweens joint by joint. Lerping the fitted pose
*parameters* instead fails for rigs: the run's per-frame fits trade `phase` against the joint offsets
(`phase` 0 → 200 → 0 → 304 over f38–f41), so halfway parameters swing the limbs through the body. A
pair is dropped (and stepped in game) when an in-between's silhouette is further from both neighbours
than they are from each other. Output: `sprites_3d_frames/<sheet>/tw/fLO-HI_KofN.png`, checked by
`--check`. `final` deletes a family's in-betweens, so re-run `tweens` after it. 28 families, 3 min on the
4090; 4 pairs dropped (Walker f25–27 mid-turn, Hippo f10–11, shield spin f09–10).

**Real-time 3D (REMASTERED 3D, F4; 2026-09-26).** Instead of drawing rendered frames, the game poses a
family's own 3D rig between any two frames and renders it live, per entity, at the monitor's rate — a
continuous pose instead of 4 fixed in-betweens per step. Pipeline:
`framematch.py <family> live` (`tools/soi3d/live_blender.py`) builds the fitted model in Blender, poses
every frame and exports `extracted/sprites_live/<family>/model.glb` + `live.json` (each frame's
transforms of the moving nodes, blend-shape weights, its fitted camera, the lights, world and Principled materials);
`livecal` fits the sun vs ambient balance (Godot's ambient light is not shadowed by the model the way
Cycles' world light is, so it needs ~0.35× — sun-only and ambient-only passes mixed in linear light,
grid-searched by dE → `key_scale` / `amb_scale`); `livegate` renders every frame through the game's own
renderer (`godot_project/scenes/live_check.tscn`) and scores it like `verify`, next to the Cycles
frames (`_verify/live_sheet.png` = SD | Cycles | live), and writes `gate.json`. The game draws a sheet
live only from rigs whose `gate.json` passed (`game.gd _scan_live` indexes them by sheet; a pose between
frames of two different rigs, e.g. a player's run → idle, falls back to the frames). `live3d.gd`
(`Live3D`) interpolates every node's transform (rotations slerped), blend-shape weights and the fitted canvas placement,
renders into a viewport of the family's largest frame at the window's scale (MSAA 8×, filtered sun
shadows — Godot's soft PCSS reads as a dot pattern at sprite size); a 2D pass applies the family's
`matte` / `fringe` post steps, mirrors left-facing entities and recolours P3. Robo: live IoU min 0.860,
dE 14.37 / 16.80 vs the Cycles frames' 0.861, 14.39 / 17.11. Cost: 6 live Robos at 2560×1920 run
uncapped at ~900 fps (1.1 ms/frame) vs ~1700 fps with pre-rendered frames. **F4** toggles live 3D ↔
pre-rendered frames. Live (27, 2026-09-27): both players' run / action / cheer / tumble sets, Robo, Hippo,
Piggy, the Ant, the Ostrich, Smiley, Teeth, Walker and its bolt, Spinner, Wheelie, transporter, cannon ball
and barrel, the Beenie's left/up shots, the Gargoyle's puffs, the spinning shield. Pre-rendered: the procedural-texture families
(weapons swirl, egg bands, gift box glyphs, M block — glTF carries no shader textures) and two near-misses
(Beenie right shot f34, winged shoe). Clip: `media/video/live3d_robo_remastered_20260926_165721.mp4`.
Since then also live: the Hammer walk and swings (2026-09-29/30) and, on 2026-10-01, the Beenie (cap gores as
per-face materials, `beenie.py` `gore_faces`) and the Knight's gift box (`live_blender.py` converts text/curve
objects to meshes — its glyphs had been dropped from the export). Still pre-rendered: the swirl ball and the egg
(animated shader textures), the M block (per-frame visibility and deform modifiers), the winged shoe, the static
1UP and Teeth emblem frames, the Gargoyle (per-frame model variants, `frame_opts`) and the Knight (a trial rig
passed 54/65: live rigs now carry the gift orb's teardrop shape keys, and since 2026-10-03 the orb's speckled gold
exports as its mean colour -- the Knight is live, 65/65). The live materials also carry the Principled clearcoat
(`coat` / `coat_rough` → Godot clearcoat). `livegate` scores live IoU with `live_iou`: Godot's MSAA leaves
edge pixels at exactly half coverage, which count as hits where the source has a pixel and are left out where
it has none (a fixed threshold either way flipped a near-miss: the Ant's f12 fell from 0.850 to 0.841 when
they all counted as opaque).

**Late-fringe oversize (2026-10-01).** The post `fringe` grows the alpha by 2 render px (0.5 SD px) of black.
Families whose placement was fitted before the fringe was added stood ~0.5 SD px too large all round
(3D-only ring, no SD-only pixels; the gate's blurred dE barely notices black over black). A pose-preserving
placement refit (ortho camera: a placement change is an exact 2D similarity of the render) with fringe 1 fixed
disk, both coins, compound, star, Smiley, transporter, weapons and cannon ball (e.g. Smiley IoU 0.959 -> 0.987,
silver coin 0.921 -> 0.997); goldbar and spinner took the placement alone; live rigs re-calibrated and passed.
The potion's fitted k had blown its SD-px-measured flask up 1.27x (lip clipped off the frame): back to the
native k = ORTHO / R / S, measured geometry, look, then placement (IoU 0.862 -> 0.956, dE 14.33 -> 13.41). The
gift bow is a bushy ROSETTE (`goodies.py` `bow_loops`). Live rigs now also carry blend-shape weights (Knight
orb shape matches live; its speckled-gold shader still keeps Knight pre-rendered). Rejected: egg stripe grooves.
Same-instant IN-GAME A/B (script `HOLD` + `F2` + `SHOT`, boards chosen to cover every tile kind) found what the
per-frame gate passed: the grey HOLE-BLOCK f140 (`tile.py` porthole `hole_shape` diamond + `corner_r` gusset
holes + `frame_w` border round a darker recessed `panel_gain` panel; dE 9.22 -> 6.33, its crack/quarters follow)
and the BLACK DONUT f104, whose hole the key light's cast shadow filled (shadows false: the SD hole shows the
white tile; dE 8.12 -> 7.50 -- the coloured donuts and the ball score better WITH shadows). Also: the Hippo
statue keeps its open mouth dark (`emblem3d.py` `dark_parts`), the cannon ball 0.9x light (dE 13.17 -> 12.79).
A second A/B sweep (boards 1040 429 301 417 1007 465 410 468): the hole-block's corners are SQUARE in the source
(the cage blocks join into one lattice; f140 bevel 0.02 -> IoU 1.000, dE 3.0); the cannon housing is a FLUSH lit
face round the barrel (`cannon_barrel.py` `plate_z` 0: the recessed backplate had sat in shadow, dE 12.1 -> 9.1);
the gold bar is TWO stacked long ingots, end faces lit on the left (`goody_goldbar.py` layout stack2, dE 13.0 -> 11.6);
the winged helmet's wings re-measured and set in front of the dome (`wing_pts`, `wing_z`; dE 14.4 -> 12.8).
Not bugs: smooth REMASTERED draws movers SMOOTH_DELAY (2 ticks) behind, so a frozen A/B shows a spinning ball's
earlier frame; the Smiley statue face only LOOKS smaller at nearest-neighbour zoom (bigger = dE +2.6..+14).
KNIGHT LIVE (2026-10-03): a linked (procedural) Base/Emission Color exports its unused DEFAULT -- the orb went live
as flat grey. Cycles ignores a linked input's default, so `knight.py` sets it to the speckle's mean gold (ramp
weights from the noise distribution + `orb_live_tan` rim share, `orb_live_emit`): Cycles frames unchanged, live
54/65 -> 65/65 (live dE max 34.2 -> 15.5); the Knight now draws live. Same trick for any procedural material.
Gold bar albedo [175,135,0] (dE 11.59 -> 10.92). Coloured donut holes: the source shows a fainter shadow than
ours, but no-shadow / self-shadow-only (Cycles light linking) / partial shadow all scored WORSE -- kept.
USER FEEDBACK ROUND 31 (2026-10-03): one shared human face on the players, the Hammer and the Beenie -- eyes level
with pupils centred (`eye_el` 6, `eye_az` 16, `eye_pupil_dy` 2; the old 10 deg default pupil drop looked down, and
`eye_el` up to 25 put the eyes on the fringe line = "hair behind the eyes") plus a slight skin nose
(`kid.py` `nose_skin_r` .55); `ankle_ball` (a leg-coloured ball at the ankle) keeps feet on the legs (not on the
tumbles: dE +1.3). Beenie stands like the source: walk amplitudes 0, legs and free arm held, propeller turns a
uniform 22.5 deg/frame, no red nose, shorter smile, skin hands, a ribbed gun with a barrel. Knight (`knight.py`):
ogive helmet `helm_point`, sharp `keel_wedge`, scuffed/brushed steel (`rough_var`, `aniso`), thicker blade, and
no-clip posing (`grip_clear` keeps the sword fist in front of the breastplate, `tip_fwd` mirrors a blade tipped
away from the camera toward it -- same projection, never behind the body): 65/65, dE max 15.6.
PLAYER FACE + SMOOTH RUN (round 32, 2026-10-03): the player face follows the 1030 "blue wins" title art -- a brown
hair CAP with a level hairline (`hair_cut` 60), wide-set OVAL eyes (`eye_fy` .75, big irises, looking straight),
a protruding skin nose (`nose_skin_px`), a red crescent smile (`smile_taper`) and ears (`ears`), all 8 player
families (eye/nose/smile sizes scale with `head_r`). The run (two 24-frame loops the core plays, f02-f25 / f26-f49;
the SD repeats every 12 frames) had per-frame independent fits: the walk phase jumped, ankles flipped +-90 deg,
the head snapped. `tmp/run_smooth.py` refits each loop's TOTAL joint angles as one 3-harmonic curve shared by both
sides (far limb = near limb half a cycle later, per-frame near/far relabelling, trimmed), a constant -15 deg/frame
phase, and stores it as each frame's fit.json "anchor"; the new optim `"tether": {param: tol}` keeps a refit within
tol of its anchor (smooth -> refit -> re-smooth -> refit at 3-8 deg). Residual vs a smooth cycle: legs 14-16 -> 3-4
deg, ankles 40-50 -> 7-8, head 10-14 -> 2-3; BP_run dE max 14.8, GP_run 13.9, live 48/48; tweens now cover both
loops ([[2,25],[26,49]], was [[37,48]]). Plain smoothing without the refit scored IoU .74.
HD REFERENCES (round 33, 2026-10-04): the Step On It reference card (refs/text/StepOnItRefCard.pdf) carries
greyscale HD renders of Ted, a block, every goody, the arrow, the magic ball, key, door and all six nasties
(PyMuPDF extracts them; compare greyscale renders). Adopted where the SD frames still pass: the shoe's red cuff
carries a feathered wing (`goodies.py` `wing_n`/`wing_cuff`, feathers kept inside the cuff outline -- longer ones
cost IoU .83), the shield a centre crease (`sh_ridge`), the door a round tube frame and a keyhole (`frame_tube`,
`keyhole`), the coin's '$' a bevel (`glyph_bevel`; a Georgia glyph scored +2.5 dE), the ant ball feet (`ant.py`
`foot_ball`), the hippo pupils in its white head bumps (`quadruped.py` `ear_pupils`: those bumps ARE the card's
eyeballs), the Beenie a ring-coil ray gun (`beenie.py` `gun_coil`), the ostrich a flat duck bill. The card's
Wheelie face is not in the game's sprites (a rolling star ball), and the manual's pages 54-55 are Crystal Crazy.
`py tools/soi3d/ref_compare.py [family ...]` writes `_verify/ref_compare.png` for every family with HD reference
art (HD reference | SD source | 3D | 3D greyscale; the frame is the best silhouette match unless its `REFS` entry
names one) -- 21 families: Ted (card, box art, 1010/1030/320 pictures), block, goodies, weapons, the six nasties,
Beenie, Knight (300/320) and Gargoyle (300).
TED'S JOINTS (round 33): the 1010 front-view art shows Ted beaded -- ball shoulders, elbows and knees, every limb
segment bulging mid-way. `kid.py` `shoulder_ball_f` / `elbow_ball_f` / `knee_ball_f` / `seg_bulge` (1.2 / 1.15 /
1.1 / 1.08 on all 8 player families; 1.35 / 1.25 / 1.2 / 1.15 left a run and a turn frame per family failing after
two refits). All 8 pass, live rigs too.
ROUND 34 (2026-10-04): one human face -- the Hammer (walk + both swings) takes the player face (oval eyes, skin
nose, ears, red crescent smile replacing its round mouth), all pass. The Knight's helmet rises to the 300 title's
tall crest (`helm_point` 4.5, `finial_h` 2: 65/65, dE max 15.7). Ted's shoes are rounder (`kid.py` `shoe_bevel`
1.2, `foot_ry` 1.3, the 1010 art). An ostrich feather-fan tail (`biped.py` `tail_n`, the card's) scored worse on
every frame tried -- the SD ostrich shows no tail -- so it stays off. The framed blocks (`inset`) are the card's
round TUBE frame: `tile.py` `tube_frame` sweeps a rounded square of round section (`tube_fz`, `tube_corner`) round
the recessed panel (f110 dE 9.4 -> 8.9); `well_bevel` (rounding only the old well's edges) is kept as an option.
ROUND 35 (2026-10-04, user review of the ref_compare sheets): Hippo -- white toes (`toe_n`), a muzzle bulging in
front of the head (`snout_f`) with a smaller mouth on it, bigger eye bumps (`bump_f`); Smiley -- round-ended lens
pupils (`slit_round`); Knight -- `helm_sharp` (a straight cone, no subdivision); Ostrich -- feather tips on the
wing's trailing edge (`biped.py` `wing_fan` + `wing_fan_keep`; a full fan replacing the wing cost dE 20); shoe --
wings out from both sides (`wing_out`) swept back off the red cuff, the shoe re-angled (a white ankle under
card-sized wings scored dE 22-24: the SD shoe's whole upper is red); Hammer -- the players' fringe cut so the hair
clears the eyes. Ted's head held still: the cheer's body yaw anchored at its median +-3 deg and the turn sheet's
head turn `hd` at 0 +-8 deg (`tmp/hold_param.py` writes fit.json "anchor"s, optim "tether" keeps them). The run's
"feet in the legs" were ankles flexed up to +-85 deg (the shoe in line with the shin; the SD shoes stay level):
the ankle anchors are scaled x0.35 and refit at +-8 deg; a fit.json frame's `tether_scale` widens just that frame's
tether (the run's f08/f10 needed x2.5). Rounder shoes (`shoe_bevel` 1.2) on all players.
ROUND 36 (2026-10-04): the shield's studs are raised nipples in their rings (`stud_cone`), its dome finer-meshed
(`bulge_seg` 192: the coarse boolean sphere showed as blotches). The hippo's jaw is a real gap cut through head +
snout (`quadruped.py` `jaw_gap`, `jtooth_*`; superseded by `muzzle` in round 41), its legs carry knees (`knee_r`),
and its old cheek eyes are gone (`cheek_eyes` false; the white head bumps are the eyes).
ROUND 37 (2026-10-05): the card's "kill all" goody is a ball with two red arrow wings (not a helmet): one sphere
whose underside is the dark grey (`goodies.py` `ball_r`/`ball_y`/`ball_split`, replacing dome + rim), wings a
hand-drawn arrow outline traced over the card + SD red (`tmp/gear_design.py`; one diagonal band, small inner teeth,
thin hanging spikes) in front of it (`wing_z` 10.5) casting no shadow (`wing_shadow` false -- their
shadows on the ball read as offset grey copies that broke the symmetry); dE max 12.9 -> 11.4. (Sawn edges
`wing_saw` and a generated fir-tree `wing_tree` were tried first and dropped. Dropping an option from frames.json
is not enough: the work dir's look.json carries its own copy of the opts and kept sawing the new outline.)
The ball's lower half is NOT a dark material (`ball_split` -30): the grey there is the wings' shadow, as on the
card (dE max 10.9). Gargoyle wings: a scalloped lower edge between every second fold (`gargoyle.py` `wing_scallop`
2.0, the title art's bat membrane; its ref_compare uses the emerged f20, not the cloaked f05). Piggy: a thick
donut snout (`rim_t` 1.4, `flare_l` 1.0). Hippo: a wider jaw with big square teeth (`jaw_gap` 2.6, `jtooth_h` 2.3).
Shoe: bigger feather fingers cost IoU below the gate (0.81 at `feather_w` 2.6) -- kept.
Door (card): hinges are a tall leaf narrowing into a straight tongue with a pin knuckle (`hinge_leaf`, `leaf_*`,
`tongue_h`, `leaf_knuckle`; without the knuckle the blue door f06 lost its gold mass and went dE 18.7), the lock a flat
keyhole-shaped plate under the knob (`keyplate`, `kp_*`). Coin (card): a tapered crescent groove from 1 to 8 o'clock
(`goody_coin.py` `groove_arc`); at r 0.76 the full-ring groove sat under the raised rim and never showed -- r 0.6.
ROUND 41: coins -- a thin crisp rim (`rim_minor` 0.04, `rim_out` 0.88, `body_bevel` 0.012; silver dE 8.0 -> 5.8).
Kill-all: the arrow base thinned. Shield (card): sharp corners (`sh_round` 0, `sh_bevel` 0.3) and two straight creases
from the top dips meeting in a V mid-shield (`sh_chevron` 0.35 / `chev_y`: three half-space booleans -- two roof
planes and a tab plane falling back toward the top notch) in place of the vertical `sh_ridge`. Hippo (card): a boxy
open muzzle out of the head with two peg teeth standing on the lower jaw (`quadruped.py` `muzzle`, `muz_*`, `lip_h`,
`jaw_h`, `peg_*`), eyes closer (`ear_z` 1.3). Piggy: bulb feet (`foot_f`), a smaller donut, and the tail swings per
frame like the SD (pose `a_tail` / `a_tail_y` on a `tail_pivot` empty, fitted by optim). Gargoyle: the diagonal strap
removed (the title art only has the arm's shadow there); opt-in muscle detail -- abs (`abs_n`), biceps/forearms
(`bicep_f`), clawed fingers (`fingers`), a stone foot with long white claws (`toes`) in place of the white box.
`tmp/apply_both.py` sets opts in frames.json AND overwrites the same keys in the work look.json.
ROUND 42: coins have NO raised rim ring (the card's coin is a plain disc -- `rim_on` false; the rim read as a 2nd
circle) and the crescent hugs the edge (`groove_r` 0.75, arc 75-240 deg). Shield: the outline traced from the card
(`sh_half`, a mirrored left half: higher pointed horns, a wide top tab with concave shoulders, bulged sides;
silhouette IoU vs SD 0.91 -> 0.96, `tmp/shield_design.py`), chamfered edges (`sh_bev_seg` 1), smaller studs.
Kill-all: the wing base ends in needle spikes. Hippo: the head sphere showed green inside the open mouth -- the
gap is now cut out of the head (`muz_cut`). Piggy: a pointed tail (`tail_r1` 0.15). Gargoyle: the muscle
primitives (torso + pecs + abs, upper arm + deltoid + bicep, forearm + hand, thigh + quad + knee + shin + calf) are
joined per limb and voxel-remeshed + corrective-smoothed into one skin (`fuse_vox` 0.2, `fuse_smooth` 12) so the
abs read as a blended six-pack, not stuck-on ovals; new `delt_f`, `quad_f` (quad + calf).

**Detail audit (2026-09-26).** The gate's blurred dE deliberately discounts sub-pixel texture, so a frame
can pass with an eye or a stripe gone. `tools/soi3d/detail_audit.py` (metric `framematch.detail_miss`)
compares a detail layer (Lab pre-smoothed 0.6 px, so a 1 px dither checker averages out, minus its masked
1.2 px surroundings) between each SD frame and its 3D frame with 1 px tolerance and writes
`_verify/detail_sheet.png` (worst frames: SD | 3D | SD with the misses marked); look `"detail_w"` adds
that term to the look score so a look can place such features. Fixed from it: the Robo's white face plate
with the red T and ear studs, the Hippo's open mouth, teeth, claws and tail stub, the Walker's eyes, the
Spinner's light peg under the lower bar, the Wheelie's dark hub recess with its bright axle knob, the
transporter face's forehead (hair set back), cracks across blue tiles and balls (the crack derive keyed on
luma, which barely moves on blue), and the dark keyed rim on 13 families that had no `fringe` (their 3D
silhouette edges measured 8-20 L* brighter than the source's; e.g. the Gargoyle puff's misses 18% -> 1%).
Tried and rejected by verify: T-shirt sleeves on the Hammer, a box snout on the Hippo. Goodies (2026-09-27,
looks re-run with `detail_w`): the star's relief is thicker (its dark-red lower facets; dE 15.1 -> 12.3),
the coin's rim taller, so its shadowed inner arc shows (detail misses 31 -> 12 px, dE -> 8.3), the
potion's swirl less wound (dE 14.6 -> 14.3).

**Publishing near-miss characters (2026-09-27).** The Ant (42 -> 49/49) and both players' tumbles
(8 -> 32/32 each) passed with three moves: (1) after a look that changes proportions, `bake` it and
re-run `optim` so the poses adapt to the new body, then continue the look (BP_tumble 8 -> 31); (2) seed a
failing frame with the pose of the most similar PASSING source frame by source-vs-source IoU, which can be
far away in the sheet (Ant f33 <- f42, f35 <- f43; optimfail's own reseed only tries +-2 neighbours);
(3) give the last geometric miss its own pose key (Ant `kt`, a per-frame knee height, default 0).
The green tumble is a clone of the blue one (`tmp/clone_gp.py`) and passed on its first verify.
The Ostrich (20 -> 30/32 from move 1) is published under a documented colour gate of dE 17.75 (Robo and
BP_run use 17.5): its last two frames, f28 16.6 and f32 17.7, are source twins of each other with no
passing twin, and a yaw x phase probe, a per-frame body pitch and seeding f32 from f28 all converged on
the same pose.

**Status (2026-09-25, 1079 frames published):**

| Published (gate passes) | Frames | IoU min | blurred dE mean / max |
|---|---|---|---|
| `block_sprites` (24 tile types; `tile.py`) | 150 | 0.960 | 7.0 / 13.1 |
| `robo_sprites` (the Robo f02-f81: walk, turn, punch; `robo.py` two eyes) | 80 | 0.854 | 13.7 / 15.9 |
| `BP_sprites` (the blue player f50-f117: walks, pushes, jumps; `kid.py` rig + eyes) | 68 | 0.851 | 12.2 / 15.7 |
| `GP_sprites` (the green player f50-f117: BP_sprites' fit and look with a green sweater) | 68 | 0.851 | 11.1 / 14.7 |
| `BP_run` (the blue player's run f02-f49; documented gate dE 17.5 for the stride frame f07) | 48 | 0.852 | 12.1 / 16.2 |
| `GP_run` (the green player's run; BP_run cloned) | 48 | 0.854 | 11.2 / 15.3 |
| `teeth_sprites` (the chattering Teeth f02-f50; `teeth.py`) | 49 | 0.855 | 11.3 / 15.4 |
| `walker_body` (the Walker f02-f49; `walker.py` block legs, knees to -85 deg) | 48 | 0.853 | 10.3 / 13.1 |
| `smiley_sprites` (Smiley; `smiley.py`) | 48 | 0.974 | 9.8 / 11.8 |
| `hippo_sprites` (the Hippo walk f02-f33; `quadruped.py`, thin legs `leg_r` 1.6) | 32 | 0.865 | 9.5 / 11.7 |
| `beenie_shot_l`/`_u`/`_r` (the Beenie spread shot f02-f49; `rods.py`) | 48 | 0.833 (`_r` gate 0.83) | 10.1-11.0 / 15.3 |
| `beenie_shot_d` (the down set f50-f65: the rods fan up from an apex at the bottom, thin there; `rods.py` opt-in apex taper; gate IoU 0.83 like `_r`) | 16 | 0.833 | 9.4 / 15.8 |
| `piggy_sprites` (the Piggy walk f02-f33; `quadruped.py` species piggy) | 32 | 0.859 | 11.0 / 13.9 |
| `Stop_Go_sprite_family` (flip; `sign.py` `sign_flip`) | 40 | 0.975 | 13.3 / 15.8 |
| `disk_sprites` (Wheelie) | 24 | 0.996 | 12.8 / 13.7 |
| `cannon_ball` (cannon_sprites f04-f23; `beachball.py` gores aligned to the pole axis, tilt -5.5) | 20 | 0.956 | 13.4 / 15.9 |
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
| `spin_ind_shoe` (the speed indicator's winged shoe, one near-uniform turn; `wingshoe.py`; 16x12 gate IoU 0.83) | 30 | 0.833 | 11.6 / 15.4 |
| `weapons` (the player's swirl ball f02-f09; `spiral.py`) | 8 | 0.953 | 9.2 / 9.5 |
| `block_question` (the '?' tile f146 + crack + quarters; `tile.py`) | 6 | 0.965 | 11.5 / 14.6 |
| `weapons_arrow` (the straight shot f10/f11; `arrow.py`) | 2 | 0.920 | 8.4 / 9.9 |
| `cannon_barrel` (cannon_sprites f02/f03; `cannon_barrel.py` one lathed barrel with a bell muzzle + rivets) | 2 | 0.980 | 12.1 / 12.5 |
| `emblem_hippo`/`_piggy`/`_ostrich`/`_smiley`/`_ant`/`_hammer` (each nasty's SPAWNER block, the last 32x32 frame; `emblem3d.py`: the nasty's OWN model as a silver statue on `tile.py`'s red slab, real cast shadow) | 6 | 0.998 | 6.5 - 12.2 |
| `emblem_teeth` (the Teeth's spawner f51: the teeth in a blue ball's window; `teeth.py` mode teethball) | 1 | 0.932 | 15.3 |
| `BP_cheer` (the player's front-view cheer f118-f126, 36x34; `kid.py` with cartoon eyes) | 9 | 0.860 | 13.6 / 15.7 |
| `GP_cheer` (the green player's cheer: BP_cheer's fit and look with a green sweater) | 9 | 0.861 | 12.5 / 13.5 |
| `ant_sprites` (the Ant f02-f50; `ant.py`) | 49 | 0.852 | 10.8 / 14.7 |
| `ostrich_sprites` (the Ostrich walk; `biped.py`, eyes with pupils; documented gate dE 17.75) | 32 | 0.850 | 12.8 / 17.6 |
| `BP_tumble` / `GP_tumble` (the players' four 8-frame rolls; `kid.py` pitch/bank) | 64 | 0.855 | 12.8-13.9 / 15.7 |
| `beenie_char` (the Beenie f66-f121: clown face, six-gore cap with a thick propeller band, long bill, blaster in the right hand; gores as per-face materials, live rig passes) | 56 | 0.854 | 13.7 / 15.8 |
| `hammer_walk` (the Hammer f02-f49: walk, turn through a front view; `hammer.py`) | 48 | 0.854 | 13.7 / 16.0 |
| `hammer_swing_l` / `_r` (the Hammer's two-handed jump-smash f50-f65 / f66-f81; `hammer.py` two_hand; gate dE 17.5) | 32 | 0.853 | 14.6-15.1 / 17.1 |
| `Gargoyle_sprites` (unfold f02-f18, flap cycle f18-f33, ball wind-up and burst f33-f74; `gargoyle.py` torso3/face/legs2/horn loops/pleated wings/`burst_n` chunks, per-frame `wing_lo` box-like lower wings) | 73 | 0.863 | 13.0 / 15.6 |
| `knight_sprites` (unfold f02-f18, hold f17, sword wind-up and gift orb f17-f66; `knight.py` measured armour on a two-bone IK rig, polished steel reflecting a blotchy world `env`) | 65 | 0.882 | 12.6 / 14.7 |

(2026-09-30: 67 published families, 1514 frames; nothing WIP.)

Not started: `blocks` (not drawn by the port). The Hippo and Piggy show the
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
- **A per-frame fit of a steady motion overfits on tiny sprites.** The winged shoe's spin angles fitted per
  frame stepped 0-30 deg around a true 12 deg/frame, so the turn stuttered in game. Take, per frame, the
  passing candidate closest to the uniform motion (`tmp/spin_regularize.py --smooth`), not the best score.

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
- **A documented gate for one stuck frame** (like `beenie_shot_r` 0.83): the Walker published at IoU 0.845
  because f36 stayed at 0.847 after every optimfail variant. Round 26 found two of f36's knees pinned again,
  now at the -60 deg limit; re-optimised alone with the range opened to -85 it passed at 0.857, so the Walker
  (and the cannon ball, once at dE 17) are back under the standard gate. Re-check pinned joints first.
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

**Lessons from round 13 (the user's play-test feedback: faithful details, 2026-09-28):**
- **The spawner statues are the nasty's own model.** `emblem3d.py` (mode `emblem3d`) builds the monster with
  its family's frames builder (`monster_mode`, `monster_opts` = a snapshot of that family's published opts,
  posed with `monster_pose`), casts every surface in `silver`, parents the model to a `statue` empty
  (`statue_k/x/y` in tile px, `statue_fz`, `statue_mirror`) in front of `tile.py`'s red slab and lets the key
  light throw its real shadow. `tmp/emblem3d_setup.py <emblem> <monster>` snapshots the options and picks six
  side-view candidate poses (yaw within 15 deg of a profile) by normalised-silhouette IoU against the statue.
  The mask-relief emblems scored lower dE but read as blobs; the models read as the nasties.
- **`m_<key>` overrides one monster option for the statue only.** The Ant's statue is not its walk sprite (legs
  hanging straight below a flat body, not crossing it), so its stance was measured from an ASCII map of the
  statue's shading (bright grey / dim grey / shadow) and set with `tmp/emblem_stance.py` (rounded-box segments,
  2 px legs with 3 px feet, 2 px antenna). A bright-grey-only mask under-measured the body by 2 rows.
- **Trust the art over the 1x metric for features it cannot see.** The HD source shows the kid's full hair
  mop and hands at the upper thigh; the 1x dE preferred the bald cap (+0.7-1.3 dE for any hair). `kid.py`
  `hair_cut` (`_fringe` bisects the hair ellipsoid below a tilted fringe plane) plus longer arms, then `optim`
  and `optimfail`, passed every BP/GP family again. Same for the Robo's round head (`head_bevel` 3.3).
- **Read the face pixel by pixel.** The Robo's face-on f58 is two white eyes (rows 2-3) over a GREY lower plate
  (rows 4-6) split by the red centre stripe; the fitted T-visor's red crossbar read as a smile at 4x. `robo.py`
  `face_lo_h`/`face_lo_dy`/`face_grey` add the grey plate (80/80, dE 13.73 -> 13.82).
- **Re-tune one kind, not the whole look.** The ball blocks' highlight sits at (-0.33, -0.67) r (light from the
  high top left); a global key change hurt the flat tiles, so `tmp/look_kind.py` re-ran only kind `ball`
  (`key_dir`, the new opt-in `key_angle` sun softness, `fill_spec`, `f_spec`): ball dE -1.3 to -2.0.
- **HUD text is re-typeset, not upscaled.** `tools/hud_text_remaster.py` fits Times Bold at 4x per `extra_s`
  text sprite (size, x-scale, offset; coverage error 0.03-0.13) instead of the wobbly AI upscales.
- **Hold a look to the character when the 1x metric pulls it off-model.** The turtle's look walked the new short
  neck back to a long thin one (the brontosaurus the user saw); holding `neck_x0`/`neck_y0`/`neck_r` to
  turtle-like ranges in the refine still passed (IoU 0.882, dE 9.46). The sneaker needed a new model
  (`goodies.py` shoe `sneaker`: toe box, instep, red high-top ankle, laces, a flat-ellipsoid sole with no
  plate corners) - its old capsule + block passed the gate but was not a shoe.
- **A fully opaque frame cannot fit its own zoom.** The Cannon (32x32, housing to every edge) scored IoU ~1 at any
  zoom that filled the frame, so its fit had zoomed into a flat egg and both facings rendered the same. The rebuilt
  `cannon_barrel.py` "barrel" (square housing, rounded breech, collar, muzzle) uses a hand-set placement (0.1 unit
  per source px) and a pose "face" (the pivot mirrored) instead of per-frame opts, so it still exports as ONE live
  rig (`live` refuses per-frame model variants).
- **A sheet can hold differently lit renders; light each group on its own.** The Gargoyle's unfold/flap (f02-f41)
  and its red-ball wind-up (f42-f74) were lit differently in the original, so one look fitted neither. Give one
  group a `frame_opts` "kind" (its own model opts) and fit its light in `look.per_kind`; per-frame light
  overrides go in look.json `frame_opts` (the open-wing f12-f38 take gamma 0.8 / key 3.6: dE -1 to -2 there,
  worse on the cloak frames). A look that fits every frame at once drifts to a flat mid-grey that scores well and
  loses the original's contrast, so compare the published frame beside the source at the same size.
- **Pin what the optimiser must not use (`optim.fix`).** `[{"frames": [a, b], "param": p, "value": v}]` holds a
  pose key for a frame range through seeding, reseeding, probes and hops: the Gargoyle's optimiser hid the red
  ball in its cloak on the emergence frames (egg 0 for f02-f41). Pinning too much hurts: arms held at 0 on
  f02-f10 dropped f03-f05 IoU to .83 (arm 25 passes).
- **A misfit on EVERY frame is a proportion error, not a pose: measure it per row.** The Knight stuck at IoU
  0.843 on its swing frames however the optimiser posed it; a per-row silhouette bias over the whole family
  (`tmp/row_bias.py`: source minus 3D width per SD row, averaged over the frames) showed its legs parting at
  row 61-63 against the source's 51-54 on f13-f66 -- the hip block and tassets ran 10 px too low. A short hip
  block and longer thighs (same poses, no re-fit) took IoU min 0.843 -> 0.882 and dE max 16.1 -> 14.7, and
  the Knight now passes the standard gate. Check the row bias before adding pose keys.
  The same per-row count on just the FAILING frames finds a shape fault confined to one phase: the Gargoyle's
  f09/f10 (dE 16.6-16.7) hung their wings as a box 37 px wide down to row 58 while ours tapered to 29. A
  per-frame `wing_lo` (frames.json `frame_opts`), ramped 2-5-8 into the phase and back out so the tweens do not
  pop, and left at 0 on the flap frames where it cost IoU, took every touched frame down (f09/f10 -> 15.6/15.3).
- **Rebuild a model whose score hides missing anatomy.** The Gargoyle's egg-bodied model passed 61/73 with no
  arms, face or torso; the rebuild (`gargoyle.py` torso3: one body lathed through `torso_rings` + flat pecs + a
  strap; face; legs2; horn loops; wings pleated as geometry) started at 35/73 and finished at 73/73 (70 at
  dE 16; all 73 after the per-frame `wing_lo` above). A torso built from separate ellipsoids read as a segmented caterpillar; one lathed body did not.
- **A look candidate list must contain the faithful value.** The cross-hatch mesh tile (block f152, 0x197) shipped
  at twice the original's density: its `per_kind` "cells" candidates were 2.5-4, never the SD's 2, so the look
  picked a fine lattice that averages to the right grey. `tile.py` mesh "phase" 0.5 puts the bar crossings where
  the original's are (the edge quarter points); cells 2 took dE 12.5 -> 4.6 and fixed its crack and quarter frames.
  Check the game in 3D with `--3d`: `--hd` alone shows only the AI HD art.
- **An orthographic silhouette cannot tell front from back, so check the fitted facing.** A symmetric model at yaw
  +a and -a (or 90 and 270) has the same outline, so the fit can pick the wrong one and still pass: the Walker's
  turn frame f26 showed its plain rump instead of its face (yaw 270, not 90), and the kids' run turned the head to
  the camera or away in 6 of 48 frames (`hd` -88 / +94 while the original holds its profile), a twitch every
  cycle; BP/GP_sprites f75/f97 showed the back of the head. Print the yaw / `hd` sequence per family and look for
  outliers against their neighbours. `tmp/hold_pose.py` seeds such frames between their neighbours and
  re-optimises only them with the head range narrowed (the run families now keep `hd` within +-35).
  Not every jump is a flip: the Hippo's walk views face slightly AWAY and its turn passes through the front, so
  mirroring its walk frames toward the camera failed frame identity (f05 matched f11); the Ostrich held at one yaw
  per walk fitted worse (f28/f32 failed). Both were reverted.
- **Framed tiles are picture frames, not holes.** The '?' block and the blue/green player blocks recess their panel
  with SLOPED walls (dark top/left, bright bottom/right). A box-cut well casts black shadows, so the look had
  flattened it (the '?' well was 0.04 deep: the frame was gone). `tile.py` "well_slope" cuts a frustum: '?' dE
  11.5 -> 9.0, the player blocks' missed detail 7.3 -> 4.3.
- **Details must be geometry to survive the live renderer.** Godot's live rig takes only each material's Principled
  values, so a node-painted line would vanish under F4. The Hippo's mouth line (`quadruped.py` "mouth_band": the
  head grown 2% and boolean-cut to a thin slab at the snout tip) is a dark shell, so it exports. The Beenie's
  cap gores were an azimuth shader, so its live rig drew a grey dome (live dE 17.3 vs Cycles 13.7);
  `beenie.py` `gore_faces` assigns the same split as three flat materials per face (the 48-segment sphere's
  edges fall on the 60 deg gore boundaries, so the Cycles frames did not change) and the rig passes. Text
  objects are not meshes: `live_blender.py` converts FONT/CURVE objects before the export (the gift box's glyphs).
- **Keep the model 1 px inside a frame the original fills.** The Spinner's sprite is opaque to its edges, but the
  original's bars and base END 1 px inside it with a dark outline; ours ran off the frame, where post `fringe` cannot
  add a rim. Shorter bars/base and a thinner upper bar (`bar_len` 22.2, `base_w` 22, `bar_h` 6.0) took IoU mean
  0.934 -> 0.966. `tmp/pop_scan.py` flags frame pairs that change far more than the original's (the Robo's far fist
  swinging in front of the body in 5 punch frames; now held behind it).
- **Check a prior against the source before trusting a fit.** The Beenie's prior pulled f80-f108 to yaw 0 (side
  view), but f80-f90 face the CAMERA (the clown face; the blaster's muzzle points at the viewer), so every front
  frame was fitted side-on and its face never showed. Per-frame priors (180 / turn / 90 / turn / 0 / 270), the
  blaster in the RIGHT hand (the rig's far arm: `beenie.py` "gun_hand") and a clown smile built as a red curve on
  the face surface (`kid.py` "smile", "nose_r"; the mouth disc read as a red mask) took it from 1 to 19/56
  passing, dE mean 20.2 -> 16.6. The last step was the cap: the source shows the SAME gores facing left and right,
  so the beanie has SIX gores with opposite ones alike (`beenie.py` "cap_reps" 2, order R/G/B, turn 120; found by
  a one-job grid over order x turn, `tmp/opt_grid.py`): 22 -> 53/56, published under the kid families' documented
  gate dE 17.5. Its live rig fails the live gate (the gores are a shader), so F4 keeps the baked frames.
  A zoom of the head then showed the source's propeller as a THICK red band and its bill sticking out further;
  `beenie.py` `prop_h` 0.7 (was 0.35) and `bill_l` 4.0 (was 2.4) took dE mean 14.4 -> 13.7 and the last three
  frames under 16: 56/56 at the standard gate.
  The Hammer has the same fault (f21-f28 face the camera with the mallet over the RIGHT shoulder; its fit showed the
  back of the head there). A refit with front priors and `hammer.py` "grip_hand" f alone fell to 1/48: the BASE
  carry pose (`s_f0`/`e_f0` and the optim inits) was still on the near arm, so the far hand never reached the
  handle. With the carry pose moved to the far arm: sweep fit optim final verify, then look bake optimfail -> 42/48;
  then `tmp/hold_pose.py` for f05-f09 (the optim had swung the mallet FORWARD into the free fist; held back with
  ham -185..-145) -> 47/48 at dE 16, published under the kid gate dE 17.5 (+ tweens, live rig passes).
  **When a held prop changes hands, move the whole carry pose (base keys + optim inits + refine names) with it.**
- **One placement per family: split a sheet whose art moves the character inside the frame.** The Hammer's
  jump-smash (36x41) puts the kid on the RIGHT of the frame when it swings left and on the LEFT when it swings
  right, so a single family fitted one compromise placement (IoU 0.10-0.20 for the right half). As
  `hammer_swing_l` / `_r` each half got its own placement (the fitted scale x render size matches the walk's
  within 2%, so the kid keeps its size) and passed 16/16 after two moves: the carry frames were seeded with the
  mallet up-back (`tmp/hold_pose.py` with ham -200..-100; the sweep had picked it hanging in front), and the last
  miss (f78) was seeded from its mirror twin in the other half (f62, yaw 180 - y). Both fists hold the handle:
  `hammer.py` "two_hand" makes the other arm copy the grip arm. Found by listing every sheet frame the game draws
  that had no 3D frame: the swing still showed the 2D art between 3D walk frames.

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
