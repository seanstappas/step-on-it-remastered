# SheepShaver Oracle Tasks — exactly what to do

This is your **step-by-step checklist** for capturing ground-truth from the
original *Step On It!* running under SheepShaver. Everything here is something
the reimplementation currently **guesses** (marked `TODO(oracle)` in the code).
Each task says exactly what to do, what to write down, and where to save it.

You do **not** need to code anything. Most tasks are "play the game, watch, note
it down, take a screenshot." Do them in priority order — **P1 first**; each P1
unblocks a real chunk of the remaster.

---

## 0. One-time setup (5 minutes)

1. Launch SheepShaver and boot into the classic Mac OS with **Step On It!**
   installed (the `Step On It!™` app from the game folder).
2. **Screenshots — use the host, not the emulator.** The simplest reliable way
   to capture is the Windows **Snipping Tool** (Win+Shift+S) on the SheepShaver
   window. Save every capture as a PNG.
3. Create this folder on the Windows side and put **all** results there:
   ```
   D:\Code\step-on-it-remastered\plan\oracle-findings\
       screenshots\        <- all PNGs
       FINDINGS.md         <- copy the template at the bottom of this file, fill it in
   ```
4. Have the game's **Help / How To Play / Goodies** screens handy — a lot of the
   answers are printed right there in the game. Screenshot those first; they may
   answer several tasks at once.

When you've filled in `FINDINGS.md` and dropped the screenshots, tell me
"oracle findings ready" and I'll fold them into the code.

---

## P1 — Controls: which key does what  (unblocks faithful input)

**Why:** the input bit → action mapping is provisional. I need the real keys.

**Do this:**
1. Start a game. One at a time, press each key and watch what the player does.
   Figure out the key for each of: **move up / down / left / right**,
   **create a block**, **destroy a block**, **jump / break block above**,
   **fire a weapon** (needs a Magic Arrow goodie first).
2. Check the game's **Options/Controls** screen if it has one (screenshot it).
3. Note whether "create" and "destroy" are the **same** key (context-sensitive)
   or two different keys, and whether direction matters (e.g. build in the way
   you're facing).

**Write down** (in FINDINGS.md §Controls): the exact key for each action, and
whether P2 has a second key set (two-player on one keyboard?).

---

## P1 — Win condition: what ends a board and advances you  (central game rule)

**Why:** the remaster's "level complete" is a first-draft guess (collect all
treasure). I need the real rule.

**Do this:**
1. Play one **normal** board slowly. Get it to **end/advance to the next board**.
   Watch closely what you did right before it ended. Candidates to test:
   - Did it end when you **collected every coin/gem/treasure**?
   - When you **squashed/cleared all the enemies**?
   - When a **timer** ran out (and is that a win or a loss)?
   - When you reached a specific tile/exit?
2. Deliberately try to **leave one coin** and see if the board still completes.
3. Note what the **transition** looks like (a "board clear" screen? bonus tally?
   straight to next board?).
4. Do the same on a **Challenge board** (the ones with the Gargoyle throwing
   enemies — e.g. board 450-ish). Its win rule may differ from normal boards.

**Write down** (§Win): the exact condition(s) that complete a normal board, the
condition for a challenge board, and what happens on completion (screenshot the
transition).

---

## P2 — Enemy roster & behavior  (per-type AI)

**Why:** right now every enemy just walks-and-turns. I need each type's real
movement and which sprite is which.

**Do this — for each distinct enemy you encounter:**
1. **Screenshot** it clearly (save as `enemy_<name>.png`).
2. Watch it for ~10 seconds and describe its **movement**: does it
   walk-and-turn, **jump**, **chase the player (seek)**, **split into two when
   hit**, **change modes/speed**, climb, fly, shoot?
3. Note its **relative speed** (slow / medium / fast).
4. If the game names them anywhere (manual, about box), note the name.

There are ~11 types (my working names: Ant, Ostrich, Hippo, Piggy, Wheelie,
Smiley, Hammer, Beanie, Robo, Walker, Teeth). Match what you see to those or
give your own labels.

**Write down** (§Enemies): a row per enemy — name, movement pattern, speed,
screenshot filename.

---

## P2 — Goodies / power-ups: what each one actually does

**Why:** coin/gem **scores are confirmed**, but every power-up effect is a guess.

**Do this — collect each goodie and observe the effect + duration:**
- **Magic Shoes** — speed boost? how much, how long?
- **Turtles** — do they slow the enemies? how long?
- **Thunderballs** — kill all enemies on screen? or something else?
- **Shield** — temporary invulnerability? how long? does it block one hit or a timer?
- **Clock** — adds how much time?
- **2× Multiplier** — doubles score for how long? screenshot its icon.
- **Magnifying glass** — reveals hidden goodies?
- **Stop / Go switch** — what exactly toggles (enemies freeze? a gate opens?).
- **IN/OUT transporters** — step on IN, where do you come out? are pairs colored?
- **1UP** — extra life (confirm).
- **Magic Arrow vs Magic Ball** — Arrow goes straight; does the Ball really roll
  along walls? how do you aim/fire them?

**Write down** (§Goodies): a row per goodie — name, exact effect, duration,
screenshot of its on-board icon (save as `goodie_<name>.png`).

---

## P2 — Sprite reference capture  (for redraw / AI-upscale)

**Why:** the `sssf` sprite codec can't be decoded reliably from the binary. The
plan is to **redraw / AI-upscale** the sprites, and for that I need clean
reference images of every graphic.

**Do this:** screenshot, as clearly as possible (pause if you can), one good
image of each:
- Each **enemy** (covered above — reuse those).
- Each **block type** (the different colored/patterned blocks you can build).
- Each **goodie/item** icon (covered above).
- The **player character** (Ted) — ideally facing each direction, and mid-jump.
- The **title screen**, **HUD/score bar**, and a **full gameplay screen**.

Save into `screenshots\` with descriptive names. More is better — these become
the art reference set.

---

## P3 — Sound → event mapping

**Why:** I've converted all **56 sounds to WAV**, but I'm guessing which sound
plays for which event. You can pin them by ear.

**Do this:** trigger each event and note the sound it makes:
- create a block, destroy a block, collect a coin, squash an enemy, player dies,
  jump, fire an arrow, collect a power-up, use a transporter, thunderballs,
  timer running low, board clear, game over.

You don't need the sound's internal name — just describe it (e.g. "coin = short
high 'ding'", "death = falling 'wah-wah'"). I'll match your descriptions to the
named WAVs (Cow bell, Honk, MeepMeep, Bell, Bugle, Zap, Gong, Chirp, Ahh, …).

**Write down** (§Sounds): event → your description of the sound.

---

## P3 — Bonus timer details

**Do this:** at board start, note the **starting Bonus number** and watch how
fast it counts down (roughly: does it drop ~1 per second, or faster?). Note what
happens **when it hits 0** (do you lose a life? die instantly? board resets?).
Collect a **Clock** and note how much the Bonus jumps up.

**Write down** (§Timer): start value, countdown feel, what 0 does, clock amount.

---

## P3 — Precise mechanic measurements  (pin down specific code approximations)

**Why:** a few mechanics are *implemented* but with approximated geometry/timing (marked
`TODO(oracle)` in the C core). Each needs just **one careful observation** to confirm or
correct. Go slowly — a screen recording or burst screenshots help a lot.

**Do this — one observation each:**

1. **Player <-> enemy contact: how much overlap kills you?**
   Walk Ted slowly toward a *non-shooting* nasty (e.g. an Ant) on flat ground and note the
   exact instant he dies: when their sprites *first touch at the edges*, when they
   *substantially overlap* (about half a body), or only when *centered* on each other? Try
   it both ways (Ted walking in, and the nasty walking into a standing Ted).
   *(The port only registers a hit when both occupy the same 32px grid cell, so a partial
   overlap straddling a cell boundary is currently missed — I need the real touch tolerance.)*

2. **Wheelie: how does it navigate?**
   Watch one Wheelie ~15s in an open area with a few blocks. Does it (a) **follow walls**
   (hug the perimeter / go around obstacles), (b) **bounce off diagonally** like a DVD logo,
   or (c) **home in on Ted**? At a corner does it consistently turn the same way
   (always clockwise / counter-clockwise)? Note roughly how fast it moves.

3. **Hammer: the rise/smash cycle timing.**
   Watch a Hammer nasty and time (roughly, in seconds) how long it **rises**, how long it
   **hangs at the top**, and how long the **smash-down** takes before it repeats.

4. **Creeper (the moving block-layer): step cadence.**
   Watch a Creeper. How often does it **advance one cell / lay a block** — about once a
   second, faster, slower? Does horizontal vs vertical differ?

5. **(confirm) Build on a nasty.** Try to **create a block on a cell a nasty is standing on.**
   Does the block *refuse to appear* (nothing happens), or does it build (and does the nasty
   die)? *(I just changed the port to refuse the build; this confirms it.)*

**Write down** (§Precise): a short line per item — rough seconds / overlap are fine;
approximate is far better than nothing.

---

## P4 — (Optional, advanced) thrown-badguy mapping on Challenge boards

On a Challenge board the Gargoyle throws enemies. The board data has a
"thrown badguy type" number (0–20) that's **larger than the 11-enemy roster**,
so it probably indexes a bigger table (maybe including power-ups/UltraBusters).
If you're curious: on a challenge board, note **which enemies/objects actually
get thrown**, and roughly in what mix. Screenshot the Gargoyle in action.

---

## P5 — (Optional, expert) Deterministic state trace

This is the gold-standard oracle but needs tooling. **Skip unless you want to go
deep.** The idea: capture the game's RAM (player x/y, score, enemy positions)
frame-by-frame for a fixed input sequence, so I can prove my C core reproduces
the original **bit-for-bit**. If you ever want this, tell me and I'll write a
capture recipe for your SheepShaver setup (Cmd-key macros + memory dumps). For
now, the behavioral observations above are enough.

---

## FINDINGS.md template — copy this into plan\oracle-findings\FINDINGS.md

```markdown
# Step On It! — Oracle Findings

## Controls
- Up / Down / Left / Right: <keys>
- Create block: <key>     Destroy block: <key or "same as create">
- Jump / break above: <key>
- Fire weapon: <key>
- Two-player keys (if any): <keys>
- Notes:

## Win (board complete)
- Normal board completes when: <condition>
- Leaving one coin -> still completes? Y/N
- Challenge board completes when: <condition>
- Transition on complete: <what happens>  (screenshot: <file>)

## Enemies
| my label | what it looks like (screenshot) | movement | speed |
|----------|--------------------------------|----------|-------|
| Ant      | enemy_ant.png                  |          |       |
| ...      |                                |          |       |

## Goodies / power-ups
| goodie | effect | duration | screenshot |
|--------|--------|----------|-----------|
| Shoes  |        |          |           |
| ...    |        |          |           |

## Sounds (event -> what it sounds like)
- create block:
- destroy block:
- coin:
- squash enemy:
- player death:
- jump:
- fire:
- power-up:
- transporter:
- thunderballs:
- board clear:
- game over:

## Timer
- Start Bonus value:
- Countdown feel (per second?):
- At 0:
- Clock adds:

## Precise mechanic measurements
- Contact overlap that kills Ted: <edge-touch / ~half-overlap / centered>
- Wheelie navigation: <wall-follow / diagonal-bounce / seek>; corner turn: <cw / ccw>; speed: <slow/med/fast>
- Hammer cycle: rise <~s>, hang <~s>, smash <~s>
- Creeper step cadence: <~s per cell>; horizontal vs vertical differ? <>
- Build a block on a nasty: <refuses / builds (+ nasty dies?)>

## Anything surprising
-
```

---

*When this is filled in, ping me and I'll turn each answer into confirmed code
(controls, win condition, enemy AI, power-up effects, sound mapping) and mark the
`TODO(oracle)` items as CONFIRMED.*
