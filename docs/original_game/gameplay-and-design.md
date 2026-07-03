# Gameplay & Design (Original)

Rules, entities, scoring, controls, and system requirements of the 1996 game. Sourced from the shipped
documentation (`refs/text/About Step On It.txt`, `refs/text/Board Designer ReadMe.txt`), the Board
Designer's field definitions, and the **in-game Help / menu screenshots** in `refs/images/`. These are
gameplay **facts** used to drive a faithful port; each is low-risk but should still be sanity-checked in
the emulator.

Publisher: Casady & Greene (1996). Also released as "Stepping Stones."

---

## 1. Objective & core loop

- You control **Ted**, a robotic character.
- Goal per board: get the **Key**, then exit through the **open Door** (key/door are **color-coded** —
  matters in competitive mode where players have separate keys/doors).
- Ted has a special ability to **create and destroy blocks**: build blocks to climb, destroy blocks in
  the way, and **break blocks directly above his head with the jump key**. Some blocks are **permanent**
  and cannot be destroyed.
- There are **100+ boards** of increasing difficulty.
- Each board has a **Starting Bonus** that **counts down** — it is the timer, and **if the Bonus reaches
  zero, you die**. Finishing faster yields more bonus points. (Confirmed as a `BORD` field — see
  [bord-level-format.md](bord-level-format.md) §3; the HUD screenshot shows `Bonus 02968` ticking down
  from a start of 3000.)

## 1a. Play modes (confirmed from the title screen + Help)

- **One Player** — solo.
- **Alternate** — two separate single-player games taking turns.
- **Cooperate** — two players work together (shared goal).
- **Compete** — two players simultaneously, each with **separate keys and doors**.

(The remaster's online 2P maps onto Cooperate/Compete; a 3rd player is a post-parity extension.)

## 2. Blocks

Block behavior (from the Board Designer's property definitions):

| Property | Ted can stand on it? | Ted can remove it? |
|---|---|---|
| Supportive | yes | yes |
| Permanent | no | yes |
| Supportive & Permanent | yes | no |
| Neither (background) | no | no |

## 3. Weapons

- **Magic Arrow** — travels in a straight line.
- **Magic Ball** — rolls along walls.

## 4. Goodies (from the in-game "Goodies" Help screen)

| Goodie | Effect / value |
|---|---|
| Silver coin / Gold coin | 500 / 1000 points |
| Gem / Gold bars | 2000 / 5000 points |
| Magic Ball / Arrow | extra weapons (Ball rolls along walls; Arrow travels straight) |
| Clock | adds bonus points |
| 2× Multiplier | score multiplier |
| Magnifying glass | reveals hidden goodies |
| Stop/Go switch | changes a Stop block to a Go block |
| 1UP | extra life |
| IN/OUT transporters | an IN transporter ZAPs you to an OUT transporter |
| Shoes | speed boost |
| Turtles | slow the nasties |
| Shield | protects you (temporary invulnerability) |
| Thunderballs | kill the nasties |

(The manual's shorter list — Magic Shoes, Shield, Thunder Balls, Coins, Gold Bars, Gems — is a subset.)

## 5. The Nasties (enemies) & scoring — full list from the in-game Help

The manual lists only six; the in-game "nasties and their values" Help screen (`refs/images/help_3.png`)
shows the **full roster of 13**:

| Enemy | Points | Notes |
|---|---|---|
| Cannon | — | hazard; fires projectiles (a colored ball) |
| Spinner | — | hazard; a spinning block (its OWN entity — not Wheelie) |
| Ant | 50 | |
| Ostrich | 100 | |
| Hippo | 200 | |
| Piggy | 250 | |
| Wheelie | 300 | round green enemy with a star/X |
| Smiley | 400 | red masked face |
| Hammer | 500 | |
| Beanie | 750 | (manual spells it "Beenie") |
| Robo | 1000 | robot |
| Walker | 1250 | |
| Teeth | 1500 | chomping teeth |

These map onto the `sssf` sprite sets in [graphics-and-audio.md](graphics-and-audio.md) §1a.

Badguy behavior parameters (per the Board Designer), which appear in the `BORD` badguy records:

- **Start Delay** — time before the first badguy emerges from a spawn block.
- **Spawn Delay** — time between spawns (also affects a badguy's lifespan).
- **Starting Direction** — `left/up`, `right/down`, `Alternate` (spawns flip direction), or
  `Seek Player` (listed as *not available* in the original).

## 6. Challenge Boards & the Gargoyle

Some boards are "Challenge Boards" featuring a **Gargoyle** that throws projectiles. Board parameters:

- **Percent UltraBuster** — fraction of the Gargoyle's projectiles that are **UltraBusters** (Green or
  Red/Blue weapons that destroy Ted's blocks).
- **Percent Badguy** — fraction that are badguys.
- **thrown badguy** — which badguy type the Gargoyle throws.

## 7. Players & the Board Designer

- Multiplayer is **2 players** in the original: **Player 1 = blue Ted**, **Player 2 = green Ted**
  (placed separately in the Board Designer). The remaster reserves capacity for a 3rd player but P3 is
  a post-parity extended feature (`plan/MASTER_PLAN.md` §10).
- Board sets are files with Finder type `SsBd` / creator `SsBD` (e.g. `SOI Boards`, `MyBoardSet`).
- The Board Designer edits one board at a time and saves back into the board-set file.

## 8. Controls, saving & options (About doc + menu screenshots)

- **Pause:** Tab. **QuickSave:** Command-S (plays a "Huuuh!" confirmation sound).
- **Saving:** a saved game resumes only at the **start of the board** where it was saved — you can't
  save mid-board progress. `File` menu: New Game, Resume Game, Open Saved Game, Save / Save As, Load
  Board Set, Set Starting Board, Quit.
- **Keyboards:** the game auto-detects the keyboard and picks key combos that avoid ghosting in
  2-player mode; keys are re-mappable via **Set Keys**.
- **Speed setting** (`Options → Speed`): **Really Fast / Fast / Medium / Slow** (Medium is default). This
  is a user-adjustable simulation speed — **important for the port:** it means the logic rate is not a
  single fixed value in the original. The remaster must pick a **canonical speed** (likely Medium) as the
  deterministic tick rate; this also bears on the per-Tick-vs-per-frame question (see
  [binary-and-resources.md](binary-and-resources.md) §3 and plan §2a).
- Other options: "Allow Background Tasks", "Accurate Graphics (slower)" (when off, overlapping objects may
  draw imprecisely), and `Sound → Music`: **Full Music / Light Music / No Music** (+ Effects/Music
  Volume). `High Scores` menu: Show / Clear.

### Difficulty tiers (Set Starting Board)
Boards are grouped into five tiers of 20: **1 Beginner, 21 Novice, 41 Intermediate, 61 Advanced,
81 Expert** (→ the 100 tiered boards map to `BORD` ids 401–500; 401–501 = 101 resources).

### HUD layout (gameplay screenshot)
Top bar: `Score` (10 digits) · `Bonus` (5-digit countdown timer) · lives (Ted-face icon + count) · a
key/weapon count · a potion/weapon count · `Board#NNN`. In play, **white blocks** are the
creatable/standable ground and **red blocks** are the permanent/structure mass; the color-coded Door and
Key sit at opposite ends of the board.

## 9. System requirements (original)

- ~3.5 MB free RAM (4.5 MB recommended).
- 256 colors; a monitor supporting 640×480 (→ the remaster's fixed **640×480 logical space**).
- QuickTime 2.1+ and QuickTime Musical Instruments for music (music is **off by default**).

## 10. Implications for the remaster

- **640×480** is the canonical logical resolution for the D2R (retro/4K) toggle.
- **Music-off-by-default** supports treating audio as purely presentational and the core as
  audio-independent.
- The **2-player, color-per-player** design maps directly onto the planned per-player fragment shader
  (blue/green today, arbitrary RGB in the remaster).
- Pick a **canonical Speed** (Medium) as the fixed deterministic tick rate; expose the other speeds only
  as a non-networked local option.
- The **full 13-enemy bestiary** and **expanded goodies** (transporters, multiplier, Stop/Go switch,
  magnifying glass, turtles, 1UP) must all be modeled — the manual's short lists are incomplete.
