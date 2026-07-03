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

### 1c. `PICT` art (named examples)
`startup splash screen`, `Title background`, `About`, `Help 1`–`Help 3`, `High Scores`, `paused PICT`,
`board completed`, `Challenge Title`, `challenge rewards`, `Nothing! (challenge)`, `blue player`,
`green player`, `blue tally`, `green tally` — confirms P1 = blue, P2 = green, and a Challenge mode.

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

## 3. Music (QuickTime movies)

Music is separate from `SOI Sounds`: QuickTime MIDI movies in `Step On It!  Movies/` (see
[binary-and-resources.md](binary-and-resources.md) §5). The app imports **QuickTimeLib** (movie
playback), confirming music is played back as QuickTime movies, not from `snd ` resources.

---

## 4. Open items (TODO)

- `sssf`: pin the **exact RLE/mask codec** and the **~8-byte per-frame sub-header** against the decompiled
  blit routine (frame count + offset table + per-frame `w,h` + palette-indexing are confirmed — §1a-format).
- Locate the remaining `sssf` sets (`hammer`, `robo`) and confirm all 13 nasties + player + item sprites.
- Map `snd ` IDs to gameplay events (e.g. which is the QuickSave "Huuuh!" confirmation).
- Decide whether the remaster ships the original `clut` palettes as the "retro" color path.
