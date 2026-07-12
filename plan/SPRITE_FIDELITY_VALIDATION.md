# Sprite fidelity validation — method

How we validate a **3D‑remastered sprite** against its **original pixel‑art source**, so every asset is
signed off by numbers, not by eye. Applies to *any* sheet in `extracted/sprites/` (disk, signs, coins,
character frames…). Tool: [tools/soi3d/verify_3d.py](../tools/soi3d/verify_3d.py). This is the method that got the
disk + Stop/Go signs faithful; reuse it for the rest.

## Run it
```
py tools/soi3d/verify_3d.py <source_frame.png> <render.png> [--arm red|green] [--text] [--out cmp.png]
```
Prints a metric report and writes `cmp.png` = **source | render | render‑edge‑on‑source**.
Compare against the **exact source frame** the render replaces (for spinners, the frame whose phase you
rendered). Source frames live in `extracted/sprites/<sheet>/` (or the UHD upscale for a cleaner read).

## The six dimensions
| # | Metric | What it catches | Good |
|---|---|---|---|
| 1 | **Shape** — silhouette IoU (alpha overlap, crop+resize to 256²) | wrong outline / size / crop | ≥ 0.85 |
| 2 | **Colour** — per class (red/green/blue/white/dark) mean + ΔE | washed / wrong hue / too dark‑bright | ΔE ≤ 25 |
| 3 | **Angle** — radial arm peak angles of a colour about the centroid | rotation/orientation of spinners & stars | match ±~8° (or symmetric offset) |
| 4 | **Text** — white‑text height ÷ tile | lettering too small/large | src ≈ ren |
| 5 | **Relief** — top‑left vs bottom‑right luminance | 3D lit from the wrong side / flat (no shadow) | same sign as source |
| 6 | **Edges** — render silhouette edge drawn on the source (visual) | alignment / proportion drift | eyeball the overlay |

## Workflow per sprite
1. **Sample the source first** (don't guess): pull the exact RGBs and structure from the source frame —
   a pixel‑classified ASCII grid + a big NEAREST zoom reveal the real shapes (e.g. the disk's centre is a
   dark **square**, not a dot; the sign octagon is **point‑top**; blades are **cones**).
2. **Build/adjust the 3D model** in your `tools/soi3d/builders/<family>.py` to match what you measured.
3. **Render** the frame(s) and run `verify_3d.py` against the source.
4. **Iterate on flagged metrics only** — the `<-- off` markers tell you exactly what to fix.
5. **Look at the overlay too** (edges + side‑by‑side) — numbers miss things like blade thickness or a
   pinwheel sweep; the eye + numbers together is the check.

## Hard‑won rules (apply to every sprite)
- **Saturated colour + shine, together:** light with a **strong top‑left key** (directional) on **matte**
  faces (`spec=0`) → the "shine" is a bright *in‑hue* gradient, not a white wash. For a true glossy
  highlight (the disk ball) add a **clearcoat** (`coat=1`, low coat‑roughness), *not* base specular, and
  keep `world` dim + `diffuse_bounces=0` so glossy surfaces reflect the key spot, not the white world.
- **Match exact source RGBs** — sample them; the signs are red `(198,0,0)` / green `(0,140,0)`, HUD/text
  is **Times Bold** (RE'd: `TextFont(0x14)`=font id 20).
- **Spinners are animated**, so render them **symmetric** (even arm spacing); a single source frame is a
  lopsided spin phase — don't copy its uneven angles into a static model. Match the *offset*, not the skew.
- **Residual R/B on a matte colour is edge anti‑aliasing** (colour borders), not desaturation — check the
  region interior before chasing it.
- **Relief must have a shadow**: flat renders read as stickers; keep the key‑light gradient + drop shadows.

## Per‑class checklist
- **Spinning props** (disk, coins, spinner): shape IoU, colour ΔE, `--arm` angle (symmetric), relief.
- **Signs / lettered** (Stop/Go, Board#): colour, `--text` height, ring thickness, octagon point‑top,
  bezel‑on‑top relief.
- **Characters** (2D UHD, not 3D): colour + shape IoU vs the UHD frame; no angle/relief.
