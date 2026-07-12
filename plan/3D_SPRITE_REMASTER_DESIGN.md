# Design Doc — AI‑Generated 3D Models for the *Step On It!* Sprite Remaster (v5, final)

Status: DRAFT v5 (eg‑design CREATE, post Round‑4 gate; accessibility PASSED in Round 4). Owner: main session.
Referenced files: [tools/upscale_sprites.py](../tools/upscale_sprites.py), [tools/sprite_facts.json](../tools/sprite_facts.json),
[tools/qa_assets.py](../tools/qa_assets.py), [godot_project/scenes/game.gd](../godot_project/scenes/game.gd),
[tools/dump_pose_tables.py](../tools/dump_pose_tables.py), [refs/text/StepOnItRefCard.pdf](../refs/text/StepOnItRefCard.pdf).

> **Empirical‑feasibility design.** From ~32 px an image‑to‑3D model **invents most of the geometry**, so
> "faithful enough to beat the 2D UHD set" is **[EMPIRICAL]** — the prototype answers it, and the design may
> honestly conclude *"keep 2D."* The result **can never regress below the shipping UHD art.** Items that are
> genuinely un‑resolvable in a doc are marked **[EMPIRICAL]** (prototype) or **[MAIN‑SESSION]** (game‑runtime,
> owned by game code) — deliberate scope boundaries, not hand‑waves.
>
> v5 folds the Round‑4 fixes: dropped the non‑existent `subject_count` auto‑reject (an explicit **allow‑list**
> is the mechanism); **`bigger_mblock` moved to the 2D‑excluded tiles** (it's a hard‑edge block, not a spin
> object); fallback granularity is now the **whole (character, facing)** so there is **no cross‑state pop**;
> the walk sequence is **per‑frame image‑to‑3D under the frozen camera** (and that alignment is exactly what the
> prototype measures); the **stock server port is proxy‑only** and **every stage runs under the sandboxed
> low‑priv account with hard‑coded binaries (no PATH/env)**; the a11y pass has **explicit FAIL semantics** and
> tests the **real `_redden` output**.

---

## 1. Problem & core uncertainty
32‑px pre‑rendered 2D frames (~1,723, 30 sheets). hqx = faithful/pixely; Real‑ESRGAN = smooth/reinterprets.
Reconstructing 3D from ~32×32 px **hallucinates most of the shape**; whether that beats UHD is **[EMPIRICAL]** and
must fall back to UHD where 3D doesn't clearly win.

## 2. Goals / Non‑Goals
**Goals:** (a) *empirically* test whether image‑to‑3D beats UHD for **signs/objects** and a **directional
character**; (b) if yes, a mostly‑headless pipeline writing a **complete** `extracted/sprites_3d/` tree (3D per
accepted **(character,facing)**, UHD copies elsewhere), loadable via `--3d`; (c) acceptance = automated
**reject‑filters** + **one‑time human go/no‑go per category** + **headless spot‑check of a random sample** + a
hard **never‑worse‑than‑UHD** floor.
**Non‑Goals:** full ~1,723‑frame animation (Phase 2); 3D for multi‑object/2D sheets (still a11y‑checked); final
license/distribution (prototype is **local‑only**).

## 3. Scope & facing
`tools/gen3d_config.json` is generated from the **`game.gd` pose/`ENEMY_WALK` frame ranges** (via a committed
`pose_tables.json` — the walk/spin ranges hand‑captured from `game.gd`, since `dump_pose_tables.py` only dumps
the PEF *action* tables) **plus `sprite_facts.json`** (`method`/`keep`). Multi‑object sheets are excluded by an
**explicit allow‑list** (there is no `subject_count` field in `sprite_facts.json`). **Facing comes from the
source frame.**

| Category | Sheets | Modeling |
|---|---|---|
| Players | `BP_sprites`,`GP_sprites`,`bp_30fps_all_but_jump`,`bp_jump_30fps` | run/jump = RIGHT‑drawn + engine `flip_x`; model **both facings only for directional idle/stand/action** (`PLAYER_STAND_L=52`,`PLAYER_ACT_L`). `_redden` red = a 3rd render variant. |
| Directional enemies | `hippo`,`ostrich`,`piggy`,`ant`*,`robo`,`hammer`,`walker`,`knight`,`Gargoyle` | one model **per drawn facing** |
| Mirror‑at‑runtime | `beenie`*,`teeth` (`flip:true`) | single facing; engine mirrors |
| Spin/roll objects | `smiley`,`disk`,`spinner`*,`weapons`,`cannon`* | one model, rendered through its rotation. **[EMPIRICAL]** the spin motif is reconstructed from 32 px — if unfaithful, stays 2D |
| Signs | `Stop_Go_sprite_family` | **procedural** octagon+extruded text; AI compared |

`*` `ant`/`beenie`/`spinner`/`cannon` are flagged `hqx` in `sprite_facts.json` because AI melts thin detail —
they are an explicit **[EMPIRICAL] AI bet here, overriding that rubric**, made *safe* by the reject‑filter +
per‑facing UHD fallback (they revert to 2D automatically if 3D fails). **Excluded (stay 2D):** `extra_s`,
`goody_sprites`, `master_s_objects`, `spin_ind_sprite_family`, `transporter`, `block_sprites`, `blocks`,
**`bigger_mblock`** (a hard‑edge creeper tile — `hqx+hard-alpha`, not a spin subject).

## 4. Technical plan
```
 source frame (32px white-matte RGBA)
   │ ① PREP: SOURCE frame; ALPHA-only bleed (never colour-key); square-pad; hqx x4 -> Lanczos -> ~768px.
   │        Optional TRUE 2nd view = ref-card render (fitz) IFF [EMPIRICAL] it is a different angle; else single-view.
   ▼ models3d/<sheet>/_in/...
   │ ② IMAGE->3D (Hunyuan3D-2.1) via a LOCALHOST AUTH PROXY; the stock server binds a random loopback port
   │        reachable ONLY by the proxy (inbound-deny to all else). bytes in, GLB out.
   ▼ models3d/<sheet>/<subject>__<facing>.glb (+ provenance) = ARTIFACT OF RECORD
   │ ③ CAMERA - CALIBRATE ONCE PER FACING, THEN FREEZE: normalise GLB forward axis; coarse search
   │        azimuth/elevation/ortho-scale on the CANONICAL frame; human confirms; FREEZE for all frames of that
   │        facing at a FIXED world scale. Per-frame output canvas = that frame's source W*H*k (k=8); the subject
   │        is placed by its source anchor. Lighting: [EMPIRICAL] measure delit-vs-baked, then unlit or even-albedo.
   │        HARD alpha for block-type. (Signs are single-frame -> IoU is not the gate for them; see 4.1.)
   ▼ sprites_3d/<sheet>/fNN_WxH.png
   │ ④ FILTER + FALL BACK BY (CHARACTER,FACING): if ANY frame of a (character,facing) fails 4.1, the ENTIRE
   │        (character,facing) - all its states - ships UHD (=> no within- OR cross-state pop). Everything else
   │        is copied from sprites_uhd -> COMPLETE tree.
   ▼
 ⑤ HUMAN GO/NO-GO per CATEGORY (once) + SPOT-CHECK a random sample of each accepted category's headless output
   (so headless production isn't unseen); contact sheets vs source + ref card. Then production is headless.
   ▼
 ⑥ INTEGRATE  game.gd --3d block (SPRITES_DIR+PICT+content_scale, _sprite_scale=8; mutually exclusive w/ --hd/--uhd).
```

### 4.1 Acceptance = reject‑filters + human (de‑circularized; honest floor)
Filters **only fail** a frame; the **positive** decision is the one‑time human go/no‑go **plus a spot‑check of a
random headless sample** (so "never worse than UHD" means *on the measured axes, plus a sampled human check* —
stated honestly, not absolute).
- **Silhouette IoU** under the **FROZEN** camera (reject < 0.80), at the rendered anchor/scale. De‑circularized
  because the camera was fit on the *canonical* frame and measured on *other* frames. **For single‑frame subjects
  (signs), IoU is not the gate** — procedural signs are accepted on **shape‑cue (octagon/circle) + 4.5:1 contrast
  + human**, not a circular self‑IoU.
- **Regional colour ΔE** (reject any `keep`‑region > 12), source‑derived per region. *Caveat:* under animation the
  bands shift, so this is a conservative reject‑only check (may false‑reject → safe), not a proof colours can't swap.
- **Shape‑cue** (reject if lost).
- **Never‑worse floor:** any failing frame → its whole (character,facing) keeps the UHD copy.
- SSIM is informational only.

### 4.2 Concrete metric definitions (deterministic, so `verify` can compute every reported column)
- **keep‑region (regional ΔE):** the source frame's alpha bounding box split into a fixed **3×2 grid**
  (top/mid/bottom × left/right); mean CIEDE2000 ΔE is computed **per cell over the intersection of the source
  and render alpha masks** (cells with <5 % coverage are skipped). No prose parsing of `sprite_facts` is needed.
- **shape‑cue:** trace the outer alpha contour and compute **circularity** `C = 4π·area / perimeter²` and a
  polygon‑approximation vertex count. **Sign classes:** octagon (Stop) = 6–10 near‑equal edges & `C≈0.90`;
  circle (Go) = `C≥0.95`; reject if the source's class isn't reproduced. **Creature feature‑present:** count
  bright/keep‑colour alpha sub‑blobs (e.g. white teeth/joints, the disk's red‑star region) via connected
  components on the thresholded keep‑colour mask; reject if the render's blob count/positions deviate from the
  source by > tolerance.
- **CVD co‑occurrence set:** conservative and enumerable from the sprite set (not level data) — **every player
  (incl. the `_redden` red output) + every enemy + the block/board tiles**, since any can share a board. For the
  prototype the tested pairs are the three subjects vs the red cast (`ant`, `robo`, `smiley`, red `cannon`/`weapons`
  balls, `_redden` player‑3).

## 5. Accessibility (Round‑4: PASSED; gate semantics explicit)
`qa_assets.py a11y <src> <set>` over **both** 2D and 3D sets, with explicit exit‑code semantics:
- **FAIL (non‑zero, blocks the set):** a **new 3D asset** below the **UHD baseline** on contrast or CVD; or
  **procedural Stop/Go below 4.5:1**. Assets with **no 2D predecessor** (procedural signs; the `_redden` red
  player variant) have no UHD baseline, so they are held to **absolute WCAG** (FAIL if below), and the red
  variant clears the same contrast+CVD FAIL gate on its own.
- **FLAG (report, non‑blocking):** any asset failing absolute WCAG but **≥ the UHD baseline** (a pre‑existing
  game issue, surfaced to the main session — never forced below UHD).
- **Contrast:** WCAG 4.5:1 / 3:1‑large vs **worst‑case actual backgrounds** (block/board tiles).
- **CVD:** protan/deutan/tritan; require CVD‑space ΔE ≥ 15 between co‑occurring sprites, with a **separate** shape
  distance; **the CVD test applies the real `_redden` channel‑swap to the render** (not a native‑red proxy) so
  player‑3‑vs‑red‑cast collisions are measured as shipped; collisions reported with a suggested remedy.
- **Aggregate flash (WCAG 2.3.1)** and the **reduce‑motion toggle (2.3.3)** are **[MAIN‑SESSION]** runtime
  composites (fps/board/concurrency) — named, owned dependencies with a per‑frame luminance‑swing screen kept here.

## 6. Pose / Animation
Prototype/Phase 1: canonical frames per facing **plus a short sequence** via **per‑frame image‑to‑3D** (each walk
frame → its own mesh, rendered under the facing's frozen camera) — deliberately exposing whether independently
generated meshes stay aligned (temporal consistency) and whether spin phase matches. Phase 2: **(A)** per‑frame or
**(B)** one rigged model (**UniRig**, MIT) posed to match — chosen from prototype evidence.

## 7. Security (HARD gate; Windows)
- **One install path:** WinPortable pack pinned by **whole‑archive SHA‑256**, frozen (no interchangeable pip
  path). Blender pinned+**publisher‑signature‑verified**; the pack and `realesrgan-ncnn-vulkan.exe` are unsigned →
  **trust‑on‑first‑use SHA‑256 is acknowledged as the residual**, mitigated by fetching over TLS from the official
  release and recording the hash.
- **Weights:** HF `revision` pin; **safetensors‑only, hard‑fail on any pickle** (incl. sub‑modules). Binaries
  **hard‑coded** in `gen3d.py`/config; **no PATH lookup, no env** (the `qa_assets.py` `shutil.which` pattern is
  replaced by a hard‑coded ffmpeg path when run in‑pipeline).
- **Everything runs as one dedicated low‑priv Windows account** behind a **default‑deny outbound Windows Firewall
  rule**; egress only in a **monitored, host‑allow‑listed fetch window** closed **before** build/inference. **All
  stages (gen3d, render3d, qa_assets) run under that account** (no stage on the developer account).
- **Local API:** stock server on a **random loopback port reachable only by the auth proxy** (inbound‑deny
  otherwise); proxy binds 127.0.0.1, **CSPRNG token in an `Authorization` header** (not body), **owner‑only NTFS
  ACL via `icacls`**, **constant‑time compare**, rotated/never‑logged, `Origin`/`Host` checks, **bytes‑only**
  image, rate/size caps, **shutdown after `mesh`**; the proxy **verifies the real server contract at install**.
- **Untrusted mesh:** cap file size + primitive/vertex counts + **image dimensions before decode**; node‑type
  allow‑list; run the render in a **disposable VM by default** (Job Object/restricted‑token is the minimum),
  since a GPU‑driver exploit escapes a Job Object.
- **Provenance:** SHA‑256 of model + each `_in/*.png` + each `.glb`, HF revision, pack version, gen params — to an
  **append‑only, off‑account/off‑box sink** (owner can't rewrite).
- **License/IP:** review the Hunyuan/SF3D license text **before** the prototype (terms can reach non‑distribution
  use); default to **MIT TRELLIS / procedural** for anything distributable; game IP is a **separate unresolved**
  question; prototype is **local‑only**.

## 8. Detailed Implementation (files)
Install (`D:\`, single pinned path): `D:\SOI-tools\blender\` (pinned+signed), `D:\SOI-tools\hunyuan3d\` (archive‑SHA
pack, HF‑revision safetensors, server proxy‑only + auth proxy). Disk ≈ 20–30 GB + a few GB assets.
1. `tools/gen3d.py` — `prep` / `mesh` (POST bytes+`Authorization` to the proxy) / `verify` (§4.1 + §5) / `fill`
   (per‑(character,facing) UHD completion). Reads `pose_tables.json`. Hard‑coded binary paths.
2. `tools/soi3d/render3d.py` — Blender bpy: load GLB / procedural mesh; normalise forward axis; **frozen per‑facing
   camera** (coarse search on canonical, then fixed at a fixed world scale); deterministic render; unlit/even per
   the lighting test; RGBA at `source×k` at source anchor; hard‑alpha where required. **Procedural Stop/Go:** regular
   octagon (flat‑to‑flat=width), bevel 8 %, extruded OFL sans‑serif "STOP"/"GO", 4 colour variants from source
   dominant colours, white text ≥ 4.5:1.
3. `tools/gen3d_config.json` — generated (pose tables + `sprite_facts` method/keep) + an **explicit 3D allow‑list**;
   per sheet: `method`, `facings` (drawn facing→frames, e.g. `hippo` R=[21..32] canonical 21, L=[2..13] canonical 2),
   `view` start angle (**one‑time manual authoring**, seeds the ③ search), `k=8`, `iou_min=0.80`, `dE_max=12`,
   `cvd_dE=15`, `hard_alpha`, `keep_shape`, `redden`.
4. `tools/qa_assets.py a11y <src> <set>` — §5 contrast/CVD (real `_redden`)/flash‑screen with the FAIL/FLAG
   semantics above; hard‑coded ffmpeg path.
**Changed (main session, noted):** `game.gd` `--3d` block; the **reduce‑motion toggle** + **aggregate‑flash**
accounting **[MAIN‑SESSION]**; `_redden` validated on the 3D render.

## 9. Prototype (the empirical test; built after this gate)
Stages ①–⑤ on: (1) **Stop/Go f2** — procedural **and** AI (octagon cue + 4.5:1); (2) **disk f9 + ~3 spin frames**
(does the red star reconstruct? spin‑phase?); (3) **hippo R=f21 & L=f2 + ~3 right‑walk frames** via per‑frame
image‑to‑3D under the frozen camera (both facings + temporal alignment + delit‑vs‑baked measurement).
**Reported per frame:** silhouette IoU, regional ΔE, shape‑cue, a11y flags, and a **4‑way side‑by‑side contact
sheet: source | UHD (incumbent) | 3D | ref‑card** — so the go/no‑go directly compares 3D against the art it would
replace. **Honest outcomes:** signs/objects win & characters don't → 3D those, keep 2D characters; nothing beats
UHD → **keep 2D** (fill keeps `--3d` UHD‑equivalent). No sunk‑cost.

## 10. Risks (summary)
32 px→hallucination **[EMPIRICAL, central]** → optional ref‑card view, frozen near‑canonical camera, reject‑filters +
human go/no‑go + spot‑check, per‑(character,facing) UHD fallback. Circularity → camera frozen on canonical, measured
elsewhere; signs judged on shape/contrast/human. Spin motif, lighting delit‑vs‑baked **[EMPIRICAL]**. Style‑pop →
per‑(character,facing) fallback. Registration → fixed world scale + per‑frame source‑anchored canvas. Security → §7.
Reproducibility → GLB is the record; Blender config deterministic (diffusion is not bit‑reproducible). A11y → §5
(passed) + [MAIN‑SESSION] runtime deps. Disk → budgeted.

## 11. Open Questions (defaults set; resolved on the prototype)
Thresholds (0.80/12/15) + flash/contrast floors — calibrate. Delit‑vs‑baked, spin‑motif fidelity, ref‑card‑angle —
**[EMPIRICAL]**. Distributable license — user call before any distribution.

## 12. Prototype results — EMPIRICAL findings (RESOLVED)
Built the prototype (Blender 4.2.3 headless Cycles/CPU + Hunyuan3D‑2.1 shape). Rendered outputs now live under
the standardized layout `extracted/sprites_3d/<family>/` (finals + per‑family `_verify/`), with the AI‑mesh
research comparisons in `extracted/sprites_3d/_verify/research_*` (see SPRITE_REMASTER_PROCESS.md §5b);
`tools/soi3d/verify_3d.py` quantifies structural match (silhouette IoU, arm angles, octagon
point‑vs‑flat, ring brightness, region ΔE). The central **[EMPIRICAL]** question is now **answered**:

**① Image‑to‑3D from raw 32 px → FAILS.** disk f9 → flat slab; hippo f21/f2 → blobby featureless lump.
Confirms the §10 central hallucination risk.

**② Image‑to‑3D from the clean UHD 8× upscale → SPLIT by subject type:**
- **Rounded / self‑shaded PROPS (disk):** reconstructs a **real 3D sphere** — the AI infers depth from the
  upscale's glossy shading cues. But the mesh is **noisy and colourless and loses the red star**. So AI‑3D is
  *viable but inferior* here.
- **Flat cel CHARACTERS (hippo, and by extension players/enemies):** **still a flat slab even at UHD.** A flat
  side‑view silhouette carries **no depth cue**, so no input resolution rescues it. **Characters cannot be
  reconstructed by image‑to‑3D.**

**③ PROCEDURAL 3D → WINS for geometric subjects.** Stop/Go signs (`build_sign`) and the goody disk
(`build_disk`: dark glossy green ball + connected 3D red 4‑point star at the source arm angles + round green
gem) render **crisp, faithful, fully controllable** — clearly beating both the AI orb and the 2D UHD frame.
The signs are a raised red bezel (sharp square corners, on top) around a recessed point‑top octagon with a
white ring and embossed white text. See `_verify/` overlays.

**Resolved recommendation (supersedes the "AI for all objects" bet in §3/§10):**
1. **Procedural 3D** for signs and geometric/manufactured props (signs ✅, disk ✅; coins, bombs, blocks are
   next) — the faithful, artifact‑free "remaster" path, no model weights shipped, no IP/license question.
2. **2D UHD** (already shipped) for **all flat cel characters** — AI‑3D cannot reconstruct them.
3. **AI‑3D (UHD input)** kept only as an *optional* middle path for shaded props not worth modelling by hand;
   noisier than procedural, so not default.
The per‑(character,facing) UHD fallback still guarantees `--3d` is **never worse than UHD**.

