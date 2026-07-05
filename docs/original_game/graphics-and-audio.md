# Graphics & Audio Assets (Original)

Inventory of `SOI Graphics` and `SOI Sounds`, enumerated with
[`tools/rezfork.py`](../../tools/rezfork.py). Resource **names** below are the authors' own labels
stored in the resource fork (facts, useful for mapping assets to gameplay). Counts and IDs are
CONFIRMED; interpretations are marked.

---

## 1. `SOI Graphics` (resource fork ≈ 2.55 MB)

| Type | Count | What it is |
|---|---|---|
| `sssf` | 30 | **Custom sprite-sheet format** (the actual animated sprites). CONFIRMED custom type; byte layout TODO. |
| `cicn` | 61 | Color icons — the UI buttons. |
| `PICT` | 40 | Full-screen art and HUD pictures. |
| `clut` | 9 | Color lookup tables (palettes), including color-shift palettes. |
| icon family | 1 each | The file's Finder icon (id −16455). |

### 1a. `sssf` sprites — the real sprite data
Sprites are **not** stored as `PICT`; they are in a custom `sssf` resource type. Observed names map
directly onto game entities:

- **Player (Ted):** `bp jump 30fps`, `bp 30fps all but jump` — "bp" = **blue player**; note the **30 fps**
  animation rate (distinct from the game's ~60 Hz logic tick — see the timestep TODO).
- **Tiles/items:** `blocks`, `weapons`, `extra's`.
- **Enemies:** `ant sprites` (+ `ant stride test`), `ostrich sprites`, `hippo sprites`, `piggy sprites`,
  `beenie sprites`, `spinner sprites`, `walker sprites`, `smiley sprites`, `teeth sprites`,
  `cannon sprites`.

**Enemy name mapping (now CONFIRMED via the in-game Help, `refs/images/help_3.png`):** the full roster
is **13** — Cannon, Spinner, Ant, Ostrich, Hippo, Piggy, Wheelie, Smiley, Hammer, Beanie, Robo, Walker,
Teeth. The `sssf` names map 1:1: `spinner` is its **own** enemy (**not** Wheelie), and `walker`,
`smiley`, `teeth`, `cannon` are all distinct nasties. The `hammer` and `robo` sprite sets should be among
the remaining `sssf` ids we haven't named yet. Point values are in
[gameplay-and-design.md](gameplay-and-design.md) §5.

**Remaster impact:** the graphics step must **decode the `sssf` format** (below), not just convert PICTs.

### 1a-format. `sssf` byte layout (validated by rendering; `tools/analyze_formats.py` + `tools/decode_assets.py`)
Big-endian throughout:
* `0x00` **u32 = frame count** N (e.g. `blocks`=53, `ant sprites`=50, `hippo sprites`=33, `weapons`=10).
* Then a **u32 offset table** of N entries (**absolute** offsets from the resource start; leading blank
  frames read `0`). CONFIRMED: each nonzero offset lands exactly on a frame's `w,h`.
* Each **frame record**: **`w:u16, h:u16`** (CONFIRMED plausible — `weapons` 24×24, `blocks` 32×32,
  `ant` 36×16), then an **~8-byte per-frame sub-header** (fields TBD), then the pixel data.
* **Pixels are palette indices** into the game `clut` (§1b), **run-length compressed**. Two experiments
  (`tools/decode_assets.py`):
  * *Raw:* per-frame byte counts are *fewer* than `w×h` (weapons 528/576, blocks 128/1024), so it is not
    raw — yet a *near-uncompressed* frame decoded raw still comes out recognizable (the `weapons` frame is
    the red **Magic Ball**), proving the bytes are **direct palette references**.
  * *RLE:* decoding as `(run_length, index)` pairs lands the pixel total almost exactly on `w×h`
    (**blocks `1024/1024` exact**, weapons `578/576`) — strong evidence the codec is **run-length based** —
    but the reconstructed images are not yet clean, so the exact opcode order and any skip/transparency
    opcodes remain unresolved.
* **Validation renders:** `py tools/decode_assets.py` → `extracted/preview/*.png`.
* **Codec — SOURCE-VERIFIED (2026-07-02) from the decompiled decode chain.** The earlier
  `(run_length, index)` byte-staring failed because the real codec is a **two-stream alternating decoder**,
  not single-stream RLE. Pipeline:
  * **`FUN_10000004`** — `GetResource('sssf', id)`; word0 = **frame count N**; **offset table at `+0x0C`**
    (`N × u32`, each an offset from the resource base to that frame's data). Per frame, word0 of the frame =
    packed **`w:u16<<16 | h:u16`**; when a **border** variant is requested it adds `0x40000` (**w += 4**).
    Then dispatches **`FUN_10000358`** (per-frame stream setup) → **`FUN_100004d8`** (row loop, `param_2` =
    height) → **`FUN_10000884`** (packs 4 pixels/`u32` + a companion **mask**: mask byte `0xFF` when the
    pixel byte is `0` = *transparent*, else `0x00`) → inner producer **`FUN_10000944`**.
  * **`FUN_10000944` = the pixel byte producer** and the heart of the format. It walks **two separate byte
    streams** with a small state machine: a **control stream** of run lengths and a **data stream** of
    literal palette indices. It **alternates runs**: an *opaque run* of R pixels emits R literal bytes from
    the data stream (a literal `0` is forced to `1` so it stays opaque), then a *transparent run* of M
    pixels emits M zeros (no data consumed), and so on — run lengths R, M, … pulled from the control stream.
    A per-row **leading-skip counter** emits transparent pixels before the row content starts. So opaque
    spans are stored **literally** (explaining the "near-uncompressed" byte counts) while only transparent
    spans are run-length compressed, and the companion mask drives the `CopyMask`-style blit.
  * **Final blit `FUN_1000195c`** consumes the `(value, mask)` u32 pairs: `dest = (dest & mask) | value`
    (transparent pixels keep the background; opaque pixels get the palette index).
  * **Remaining to ship a decoder:** the exact per-frame stream *origins* (where the control vs data
    pointers start within a frame, and the leading-skip/width fields) live in `FUN_10000358` +
    the rest of `FUN_100004d8` — the last unread piece. With the Godot render + `--shot` screenshot loop now
    in place, a Python reimplementation in `tools/decode_assets.py` can be iterated **visually**
    (decode → preview PNG → inspect). Still presentational (the remaster AI-upscales/redraws sprites; clean
    frames + placeholders remain the fallback), so this is a bounded, now-tractable follow-up rather than a
    blocker.

### 1a-DECODED. Codec fully cracked (2026-07-03) — `tools/sssf_decode.py`
The producer (`FUN_10000944`) + the stream setup were finished by resolving the caller-frame stack
aliasing in `FUN_100004d8`/`FUN_10000358`. **Confirmed frame layout** (big-endian, offsets from the
frame start given by the resource's `N × u32` offset table at `+0x04`):
```
@0x00 u16 W        @0x02 u16 H        (@0x04,@0x06 u16 x,y — usually 0)
@0x08 u32 dataOff  (data/literal stream starts at frame+dataOff)
@0x0c u8  initRun  (initial run length; the run machine STARTS in the transparent phase)
@0x0d ..  control stream (alternating run lengths: transparent, opaque, transparent, …)
frame+dataOff ..   data stream (literal palette indices for opaque pixels; a literal 0 → 1)
```
Per row: emit `leading_skip` transparent pixels, then `W` content pixels; palette index `0` = transparent.
- **All 30 `sssf` resources decode cleanly → 1723 frames.** `py tools/sssf_decode.py all` writes
  `extracted/sprites/<name>/fNN_WxH.png`; `tools/sprite_sheet.py` builds contact sheets.
- **Sprite→game mapping (CONFIRMED): both block and goody frame = `tile_low_byte + 1`.**
  `block_sprites`: 0x07→f8 white square, 0x0D→f14 red, 0x2B→f44 red ball (white/red/green/blue/pink
  squares + balls + 6-frame shatter anims per type). `goody_sprites`: 0x0A→f11 silver `$` coin,
  0x17→f24 gold, 0x19→f26 gold bars, doors 0x01-03→f2-f4, keys, potions, 1UP, transporter rings.
  `BP_sprites`/`GP_sprites` = the blue/green player (Ted); per-enemy sheets (`ant sprites`, …).
- The Godot **retro mode** (`game.gd`) now renders these real sprites (runtime `Image.load_from_file`
  from `extracted/sprites`), with procedural shapes only as a fallback.

### 1a-SHEETS. Decoded sprite-sheet gallery (reference)
Contact sheets for every `sssf` resource are saved under
[`media/reference/spritesheets/`](../../media/reference/spritesheets) (regenerate with
`py tools/sprite_sheet.py extracted/sprites/<name> 16 40`). Key sheets:

| Sheet | Frames | Contents |
|---|---|---|
| [block_sprites](../../media/reference/spritesheets/block_sprites.png) | 156 | The tile blocks: white/red/green/blue/pink **squares** + **balls** + textured/`?` blocks, each with a 6-frame shatter animation (`solid, solid2, shatter×4`). Grouped in 6s: block type `G` → solid frame `G*6+2`. |
| [goody_sprites](../../media/reference/spritesheets/goody_sprites.png) | 51 | doors (f2-f4), red/blue/green **keys** (f5-f10), silver **`$`** (f11), star (f12), 2×/3×/4×/5× (f13-16), 1UP (f17), potion (f18), arrow (f19), transporter rings (f20-23), gold **`$`** (f24), gold bars (f26), Stop/Go + directional markers. |
| [BP_sprites](../../media/reference/spritesheets/BP_sprites.png) / [GP_sprites](../../media/reference/spritesheets/GP_sprites.png) | 157 | Blue / green player "Ted": stand, turn, run cycle, jump, land, hit. |
| [weapons](../../media/reference/spritesheets/weapons.png) | 10 | Magic Ball / candy sphere. |
| enemy sheets | — | [ant](../../media/reference/spritesheets/ant_sprites.png), [ostrich](../../media/reference/spritesheets/ostrich_sprites.png), [hippo](../../media/reference/spritesheets/hippo_sprites.png), [piggy](../../media/reference/spritesheets/piggy_sprites.png), [disk](../../media/reference/spritesheets/disk_sprites.png), [smiley](../../media/reference/spritesheets/smiley_sprites.png), [hammer](../../media/reference/spritesheets/hammer_sprites.png), [beenie](../../media/reference/spritesheets/beenie_sprites.png), [robo](../../media/reference/spritesheets/robo_sprites.png), [walker](../../media/reference/spritesheets/walker_sprites.png), [teeth](../../media/reference/spritesheets/teeth_sprites.png), [cannon](../../media/reference/spritesheets/cannon_sprites.png), [spinner](../../media/reference/spritesheets/spinner_sprites.png), [Gargoyle](../../media/reference/spritesheets/Gargoyle_sprites.png), [knight](../../media/reference/spritesheets/knight_sprites.png). |

**Enemy type → sprite folder** (core `SoiEnemyType` in [soi_core.h](../../core/include/soi_core.h) → decoded sheet):

| type | enum | folder | | type | enum | folder |
|---|---|---|---|---|---|---|
| 1 | ANT | `ant_sprites` | | 7 | HAMMER | `hammer_sprites` |
| 2 | OSTRICH | `ostrich_sprites` | | 8 | BEANIE | `beenie_sprites` |
| 3 | HIPPO | `hippo_sprites` | | 9 | ROBO | `robo_sprites` |
| 4 | PIGGY | `piggy_sprites` | | 10 | WALKER | `walker_sprites` |
| 5 | WHEELIE | `disk_sprites` *(hypothesis)* | | 11 | TEETH | `teeth_sprites` |
| 6 | SMILEY | `smiley_sprites` | | | | |

`cannon`/`spinner`/`Gargoyle`/`knight` sheets exist but aren't in the current 11-entry core enum
(Cannon & Spinner are in the Help bestiary; Gargoyle/knight are likely Challenge-mode / boss art).

**Player animation frames** (into `BP_sprites`/`GP_sprites`, CONFIRMED anchors from the disassembly;
`game.gd` selects by the core's `ground_state`): idle **f61**, landing **f26**, jump **f133** (+ a
rising counter in the original), run cycle ≈ **f52-f58** (one per `move_ctr` 0..6). Left-facing is a
horizontal flip in the port; the original stores separate left/right frames (idle 61 right / 52 left).


### 1b. `clut` palettes — original already did color-shifting
Named palettes include `Old Rainbow`, `New Rainbow`, `Tunnel Clut`, `About CLUT`, `ss Super Palette v2`,
and crucially **`color shift clut (primaries)`**, **`color shift clut (rainbow)`**, and
`color shift clut (primaries, boarders)`. Combined with the `SetEntries`/`MakeITable` imports (see
[binary-and-resources.md](binary-and-resources.md) §3), this shows the **original produced its
player/effect colors by shifting palette entries** — the direct ancestor of the remaster's
per-player fragment shader. `ss Super Palette v2` is the master 256-color game palette.

**Decoded (`tools/analyze_formats.py`):** the full palettes (`ss Super Palette v2`, Old/New Rainbow,
Tunnel, About) are standard Mac `clut`s with **256 entries** (id 1000 `ss Super Palette v2`, flags
`0x4000`); the three **`color shift clut`** variants have only **62 entries** each — i.e. a 62-colour
sub-ramp that the game cycles/shifts to recolour players and effects. Each entry is `value:u16` +
`r,g,b` (u16 channels; high byte = 8-bit). `ss Super Palette v2` is directly exportable as the retro
256-colour palette.

### 1c. `PICT` art — DECODED (2026-07-03) — `tools/pict_decode.py`
All **40 `PICT`** resources are QuickDraw **v2** pictures using a single `PackBitsRect` (`0x0098`)
opcode: an 8-bit indexed `PixMap` with an **embedded 256-entry colour table**, PackBits-compressed
per row (each row prefixed by a `u16`/`u8` byte-count; opcodes resume on an even boundary). Layout:
`@0 u16 picSize, @2 Rect picFrame`, then `0x0011` Version · `0x0C00` HeaderOp(24B) · `0x0001` Clip ·
`0x0098` PackBitsRect · `0x00FF` End. `py tools/pict_decode.py` → `extracted/pict/<id>_<name>.png`
(saved for reference under [`media/reference/pict/`](../../media/reference/pict)).

These are **full-screen art / dialogs**, not the in-game playfield chrome — the grey rounded playfield
**bezel is drawn procedurally** by the original (QuickDraw `FrameRoundRect`), which the port matches
with a procedural frame. Decoded screens (by id): `400/401` Title(+background), `402` High Scores,
`600` About, `700-702` Help 1-3, `800` startup splash, `200` paused, `300-304` Challenge, `320`
Congratulations, `350` "The Winner is…", `1000` **Board Completed** (red text + block border around a
tally area), `1010/1011` blue/green player, `1020/1021` blue/green tally, `1030-1032` blue/green/no
winner. Ids `128-143` are unnamed UI panels. Confirms **P1 = blue, P2 = green** and a Challenge mode.

### 1d. HUD / text font — CONFIRMED (2026-07-03)
The in-game **HUD is drawn from pre-rendered SPRITES**, not live text: the `extra's` `sssf` sheet holds
the blue **`Score`** (`f04`, P1) / **`Bonus`** (`f02`) labels (green `f05`/`f03` = P2), the red **digits
0-9** (`f06`-`f15`, 8×15), the **smiley face** (`f16` = lives), **rocket** (`f17` = magic arrows),
**potion** (`f18` = shield), **`Board#`** (`f28`), plus `2x`-`5x`, `GAME OVER` letters, etc. The port
blits these for a pixel-exact HUD ([game.gd](../../godot_project/scenes/game.gd) `_draw_hud`).

**Dialog / menu text** (high scores, game over, About, etc.) IS drawn live: every such routine
(`FUN_10022dfc`, `FUN_10023050`, `FUN_100258e0`, `FUN_1002401c`, …) calls **`TextFont(0x14)` = font id
20 = Times**, **`TextFace(1)` = Bold**, at `TextSize` 12/14/18/24 pt. *(font id 20 is Times, not New
York — New York is id 2.)* The UI buttons are `cicn` colour icons (61 of them; `tools/cicn_decode.py`).

---

## 2. `SOI Sounds` (resource fork ≈ 757 KB)

- **56 `snd ` resources** (standard Mac Sound Manager format), each with a descriptive name, e.g.
  `Cow bell`, `Honk`, `MeepMeep`, `Bell`, `Metal` / `Metal II`, `Brass fanfare 1`, `Chirp`, `Ahh`,
  `Announce`, `transport`, `DumDaDumDum`, `Psiou`, `Gabing`, `Moof`, `Lore`.
- **Remaster impact:** `snd ` decodes cleanly to WAV (and then OGG). No custom format here, unlike the
  sprites. **DONE (2026-07-02):** `tools/snd_to_wav.py` + `extract_assets.py` convert **all 56** resources
  to standard WAV in `extracted/audio/wav/` (pure Python, no `resource_dasm`). Observed: mono 8-bit
  11025 Hz `stdSH` sampled sounds (e.g. `zap` 2.12 s, `snap` 0.21 s), validated non-silent via the `wave`
  module. Handles `stdSH` (8-bit unsigned) + `extSH` (8/16-bit, byte-swapped); `cmpSH`/MACE returns None.

### 2a. SFX → event mapping (2026-07-03)
The port's `SoiSfx` enum (11 events) is mapped to original `snd ` ids in
[godot_project/scenes/audio.gd](../../godot_project/scenes/audio.gd) (`SFX_ID`): block-create→`1006`
(snap), block-destroy→`1002` (zap), coin→`1000` (chime1), enemy-kill→`29940` (Smack), player-hit→`2280`
(Ahh), jump→`24336` (Slide Whistle), fire→`26486` (moon blast), teleport→`19339` (transport),
powerup→`1001` (bugle), thunder→`30612` (metal crash). These are best-guess from the descriptive resource
names; the exact per-event id table lives in the PEF (`DAT_10037074` u16[53] + `DAT_10034a00` u16[2]).

## 3. Music — QuickTime Music Architecture (QTMA), CONFIRMED (2026-07-03)

Music lives in **`Step On It!  Movies/`** (12 movies: `6lilt`, `Angel Pie`, `bass for lunch`, `Cminor`,
`spooky`, the `… thin` variants, and win/lose stings `blue wins`, `green wins`, `no winner`). Each is a
**QuickTime movie** whose **`moov` is in the resource fork** (`__MACOSX/…/._<name>`) and whose sample
data is an **`mdat` in the data fork**. The media handler is **`musi` = QuickTime Music** (not audio,
not a Standard MIDI File — no `MThd`): the `mdat` holds **QTMA note events** and the `stsd` tune header
references the **"Best Synthesizer"** with **General-MIDI instruments** (e.g. **"Slap Bass 1"**).

**Extracted (2026-07-03) — `tools/qtma_to_midi.py`:** the QTMA note-event stream (`mdat`) + tune header
(`stsd`, per-part GM instrument names) convert to **Standard MIDI** in `extracted/music/*.mid` (9 tracks:
6lilt, Angel Pie, bass for lunch, Cminor, spooky + `thin` variants). Confirmed instruments are plain
**General MIDI** (Slap Bass 1, Fretless Bass, Distortion Guitar, Vibraphone, Grand Piano, Aah Choir,
String Ensemble, …) — i.e. the music is **notes + GM programs, NOT baked audio**, so it is fully editable
(swap instruments, soundfont, tempo). The 3 win/lose stings (`blue/green wins`, `no winner`) are a
different (flattened) structure — no `musi` track parsed yet. **To play in-engine:** render the MIDI to
OGG with a GM soundfont (no synth bundled yet).

**To use them** we need a **QTMA→MIDI converter**: parse the `moov`/`stsd` (instrument→GM map) + the
`mdat` note-event stream → emit a Standard MIDI File, then render to OGG with a GM soundfont for Godot.
This is a bounded follow-up (the instruments are plain GM). Status: **not yet extracted** (format pinned).

---

## 4. Open items (TODO)

- **Music:** build the QTMA→MIDI(+OGG) converter (`tools/qtma_to_midi.py`) per §3.
- Pin the exact per-event `snd ` id table from the PEF (`DAT_10037074`) to replace the best-guess `SFX_ID`.
- HUD icons (face/arrow/potion) are the `cicn` colour-icon resources (61 of them) — decode for 1:1 icons.

