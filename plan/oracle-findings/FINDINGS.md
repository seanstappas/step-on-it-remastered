# Step On It! — Oracle Findings

> Fill this in from SheepShaver. See `plan/SHEEPSHAVER_ORACLE_TASKS.md` for
> exactly what to do. Put screenshots in `plan/oracle-findings/screenshots/`.

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
|          |                                |          |       |

## Goodies / power-ups
| goodie | effect | duration | screenshot |
|--------|--------|----------|-----------|
| Shoes  |        |          |           |
|        |        |          |           |

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

## Co-op shared lives pool at 0 (Decomp audit FUN_1002a308 & FUN_1002b174)
- Death at 0 while partner lives: Dying player eliminated (`cRam1003aad8 = 0`), pool lives stays at 0 (`sRam1003aa66` not decremented below 0).
- Board clear without 1-UP: Partner remains eliminated on next board (`eliminated = 1`, `alive = 0`), pool stays at 0.
- Board clear with 1-UP: Partner revived on next board (`*(char*)(...) = 1`), pool decrements from 1 to 0 (`sRam1003aa66--`).
- Death at 0 with no teammate alive: Game over (`pool->lives = -1`).

## Co-op doors (Decomp audit FUN_1002bc64)
- Door check in `FUN_1002bc64` L54: `((int)(short)uVar10 == sVar14 + 1 || (uVar10 == 1))`
- Player 1 (`sVar14 = 1`) can exit: Blue Door (low byte 2) or Universal Door (low byte 1). Cannot exit Green Door (low byte 3).
- Player 2 (`sVar14 = 2`) can exit: Green Door (low byte 3) or Universal Door (low byte 1). Cannot exit Blue Door (low byte 2).
- Neither mode check nor held-key check on door exit. Universal door allows either player.

## Anything surprising
-
