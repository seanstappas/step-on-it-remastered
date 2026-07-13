/* test_mechanics.c — white-box unit tests for the newer core verbs (arrow fire,
 * shield absorb, jump-break-above). Includes the INTERNAL header so it can set
 * up entity state directly (arrows, shields, enemies) that the public ABI does
 * not expose. Compiled together with the core sources. Exit 0 = all pass.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "soi_internal.h"

static int failures = 0;
#define CHECK(cond, msg) do { \
    if (!(cond)) { printf("FAIL: %s\n", (msg)); failures++; } \
    else         { printf("ok:   %s\n", (msg)); } \
} while (0)

/* Put a player on the field at (col,row) with a clear world. */
static void reset_player(SoiWorld *w, int idx, int col, int row)
{
    SoiPlayer *p = &w->players[idx];
    memset(p, 0, sizeof(*p));
    p->active = 1; p->alive = 1;
    p->x = soi_cell_x(col); p->y = soi_cell_y(row);
    p->facing = 1;                 /* +1 = right */
    p->lives = 3; p->block_type = 0x19;   /* blue built block (ref-confirmed) */
    p->spawn_x = (int16_t)p->x; p->spawn_y = (int16_t)p->y;
    p->mult = 1;                          /* default score multiplier (matches soi_world_init) */
}

/* Mark the player's feet cell supportive so soi_tick keeps it grounded instead
 * of dropping it into a fall. Support cell == the placement cell (col,row).
 * Use a pure SUPPORTIVE (0x200) surface, not a full wall, so it does not also
 * read as PERMANENT (which would, e.g., block a fired arrow at its spawn). */
static void ground_player(SoiWorld *w, int col, int row)
{
    soi_set_cell(w, col, row, SOI_CELL_SUPPORTIVE);
}

int main(void)
{
    SoiWorld *w = (SoiWorld *)malloc(soi_world_size());
    if (!w) return 2;

    /* ---- 1. Magic Arrow kills an enemy in its straight-line path ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1;
    w->pct_badguy = 0;                 /* disable procedural spawns during test */
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 2;
    w->players[1].facing = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* two cells to the right */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    CHECK(soi_enemy_count(w) == 1, "arrow: enemy present before firing");
    CHECK(soi_enemy_active(w, 0) == 1 && soi_enemy_type(w, 0) == SOI_ENEMY_ANT,
          "accessor: enemy slot 0 active + type readable");
    CHECK(soi_enemy_x(w, 0) == soi_cell_x(5) && soi_enemy_y(w, 0) == soi_cell_y(9),
          "accessor: enemy pixel position readable");

    soi_tick(w, SOI_IN_ARROW, 0);              /* fire once */
    CHECK(w->players[1].arrows == 1, "arrow: firing consumed one arrow");
    CHECK(soi_projectile_count(w) == 1, "arrow: a projectile is in flight");

    {
        int t;
        for (t = 0; t < 28 && soi_enemy_count(w) > 0; t++)
            soi_tick(w, 0, 0);                 /* idle while the arrow travels (2 px/frame) */
    }
    CHECK(soi_enemy_count(w) == 0, "arrow: enemy killed by the arrow");
    CHECK(soi_player_score(w, 1) == 50, "arrow: ant score (50) awarded to firer");

    /* ---- 1b. ONE projectile per player at a time. The asm arrow/ball fire
     * handlers (FUN_10010d30 / FUN_100110b4) both gate on the SINGLE per-player
     * slot (player +0x4e == 0), which the arrow and ball SHARE. There is no frame
     * cooldown -- you simply cannot fire until your live shot is gone. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1;
    w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 3;
    w->players[1].balls  = 3;
    w->players[1].facing = 1;
    soi_tick(w, SOI_IN_ARROW, 0);              /* fire an arrow */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].arrows == 2,
          "one-shot: first arrow fires (1 in flight, ammo 3->2)");
    soi_tick(w, SOI_IN_ARROW, 0);              /* try to fire again while it flies */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].arrows == 2,
          "one-shot: a 2nd arrow is BLOCKED while the 1st is live (no timer needed)");
    soi_tick(w, SOI_IN_BALL, 0);               /* a ball SHARES the slot -> also blocked */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].balls == 3,
          "one-shot: a ball is BLOCKED too (arrow+ball share the one slot)");
    {
        int t;                                 /* let the live arrow fizzle (age 500) */
        for (t = 0; t < 560 && soi_projectile_count(w) > 0; t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_projectile_count(w) == 0, "one-shot: the live arrow eventually despawns");
    soi_tick(w, SOI_IN_ARROW, 0);
    CHECK(soi_projectile_count(w) == 1 && w->players[1].arrows == 1,
          "one-shot: once the slot is free, firing works again (ammo 2->1)");

    /* ---- 2. An unprotected enemy contact is FATAL -- the original has NO shield-count
     * hit-absorber (asm FUN_10012228 launches the death/respawn directly). Only TIMED
     * invuln (the 0x30 potion + ~90f respawn grace) blocks a hit. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* enemy on the player's cell */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    soi_tick(w, 0, 0);
    CHECK(w->players[1].ground_state == SOI_ST_DEAD,
          "hit: an unprotected enemy contact is fatal (no shield buffer)");
    /* timed invuln (0x30 potion / respawn grace) BLOCKS the hit */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].invuln = 60;                  /* i-frames active */
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
    soi_tick(w, 0, 0);
    CHECK(w->players[1].ground_state != SOI_ST_DEAD && soi_player_alive(w, 1),
          "hit: timed invuln blocks the hit (no death)");

    /* ---- 3. Head-bonk is a TWO-STAGE destroy: the first jump CRACKS the block
     * above (it stays, marked 0x4000), a second jump BREAKS it (asm FUN_1002ca5c). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                     /* stand so the jump can launch */
    soi_set_cell(w, 6, 8, 1);                  /* breakable block above head */
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) != SOI_CELL_EMPTY &&
          (soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED),
          "bonk: the first jump cracks the block above (still there)");
    /* Input latches every 2 frames (soi_tick samples on odd ticks), so a second
     * edge needs the key released and re-pressed across a couple of frames each. */
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);       /* release the jump key */
    soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, SOI_IN_JUMP, 0);  /* bonk again */
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
          "bonk: a second jump breaks the cracked block");

    /* a permanent block above must survive a jump */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);
    soi_set_cell(w, 6, 8, SOI_WALL);
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(soi_get_cell(w, 6, 8) == SOI_WALL, "jump: permanent block is untouched");

    /* ---- 3b. A clear-headroom jump leaps the table-driven arc (~37px peak, asm
     * FUN_10013404 + DAT_1003474c) and lands back on the ground, breaking nothing. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                      /* clear headroom at (6,8) */
    {
        int start_y = w->players[1].y;
        int min_y = start_y, t;
        soi_tick(w, SOI_IN_JUMP, 0);             /* edge-trigger the leap */
        CHECK(w->players[1].in_air == 1 && w->players[1].ground_state == SOI_ST_JUMP,
              "jump: clear headroom -> the player leaps (airborne)");
        for (t = 0; t < 40 && w->players[1].in_air; t++) {
            if (w->players[1].y < min_y) min_y = w->players[1].y;
            soi_tick(w, 0, 0);
        }
        CHECK(start_y - min_y >= 30 && start_y - min_y <= 40,
              "jump: the arc peaks ~37px up (recovered table DAT_1003474c)");
        CHECK(w->players[1].in_air == 0 && w->players[1].ground_state == SOI_ST_IDLE &&
              w->players[1].alive == 1,
              "jump: lands cleanly back on the ground");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
              "jump: a clear-headroom leap breaks no block");
    }


    /* ---- 3b. Block create/destroy TOGGLE: two block-high presses at the same
     * front cell build then remove the block (the core build/dig mechanic; an
     * earlier demo looked out of sync, so this pins the behaviour down). ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    /* ---- 3b. Block create/destroy TOGGLE: two block-high presses at the same
     * front cell build then remove the block (the core build/dig mechanic; an
     * earlier demo looked out of sync, so this pins the behaviour down). Input is
     * latched every 2 frames (odd ticks), so each press/release is held 2 ticks. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].facing = 1;                   /* face right -> block-high targets the front cell */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);          /* press: build a block in front */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) &&
          SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
          "block-high: first press builds a block in front");
    soi_tick(w, 0, 0);                          /* release (must latch a 0 on an odd tick) */
    soi_tick(w, 0, 0);
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);          /* press again: remove the same block */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == SOI_CELL_EMPTY,
          "block-high: a second press at the same cell removes it");

    /* ---- 3c. BUILD GATE (asm FUN_1002d04c -> FUN_100047e8): the original only builds
     * where the target cell is visually UNOBSTRUCTED, so a block-press over a nasty does
     * NOTHING -- no block is built and the nasty is NOT squashed (nasties are defeated by
     * weapons or the thunderballs/shoes goody, not by a built block). */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1;                   /* block-high targets the front cell (6,9) */
    int gate_ei = soi_enemy_spawn(w, SOI_ENEMY_ANT, 6, 9);   /* nasty on the front build cell */
    CHECK(gate_ei >= 0, "build-gate: test nasty spawned on the front cell");
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == SOI_CELL_EMPTY,
          "build-gate: no block is built on a nasty-occupied cell");
    CHECK(gate_ei >= 0 && w->enemies[gate_ei].active,
          "build-gate: the nasty is NOT squashed by the build (weapons/goody defeat it)");

    /* action poses are a DISPLAY hint (asm FUN_1001166c busy-state); ours sets pose on
     * fire/build with NO input lock, so behavior is unchanged (soi_player_pose>0 only
     * for the brief pose window). */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1;
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0); soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK(soi_player_pose(w, 1) == 2, "pose: building sets the BUILD pose (display)");
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1; w->players[1].balls = 3;
    soi_tick(w, SOI_IN_BALL, 0); soi_tick(w, SOI_IN_BALL, 0);
    CHECK(soi_player_pose(w, 1) == 1, "pose: firing a ball sets the FIRE pose (display)");

    /* ---- 3d. A cliff-fall is PURELY VERTICAL (asm FUN_1001386c calls ONLY the
     * wall-rebound FUN_10012554, never an input-steer -- unlike the jump FUN_10013404).
     * Holding a direction while falling off a ledge must NOT drift the player sideways:
     * only y changes. Regression for the fall wrongly sharing the jump's air_drift(),
     * which read the input and added a +/-2px x-steer -> a diagonal "angled" fall. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);                    /* open space, no walls -> no rebound either */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    {
        int fx0 = w->players[1].x, fy0 = w->players[1].y, t;
        for (t = 0; t < 8; t++) soi_tick(w, SOI_IN_RIGHT, 0);   /* HOLD right the whole fall */
        CHECK(w->players[1].x == fx0, "fall: holding a direction does NOT steer a cliff-fall (x stays fixed)");
        CHECK(w->players[1].y > fy0, "fall: the player still descends straight down (y increases)");
    }

    /* ---- 3e. AIRBORNE build/destroy: you can build or dig a block while jumping or falling.
     * The asm runs the action animation (FUN_1001166c) EVERY frame gated ONLY by the death flag
     * +0x28 -- not by air state -- and the build/fire fires from that animation. The port used to
     * `return` on in_air BEFORE the block actions, so mid-air building did nothing; the airborne
     * branch now handles block/arrow/ball (but not a new jump) before the air physics. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    w->players[1].facing = 1;                         /* face right -> block-high targets (6,9) */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_JUMP;   /* mid-jump */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
          "airborne: can BUILD a block in front while jumping (mid-air)");
    CHECK(w->players[1].in_air == 1, "airborne: building mid-air does NOT cancel the jump");

    /* ---- 4. Thunderballs (goody 0x31, asm FUN_1000543c) defeats every nasty: it
     * CLAIMS each one for the collecting player, and a claimed nasty is cleared on
     * its next update. (0x2F is the MAGNIFYING GLASS, not thunderballs.) ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 1, 2);
    soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 8, 5);
    soi_enemy_spawn(w, SOI_ENEMY_TEETH, 11, 12);
    CHECK(soi_enemy_count(w) == 3, "thunderballs: three nasties before pickup");
    soi_set_cell(w, 4, 9, 0x31);               /* thunderballs on the player cell */
    soi_pickup_check(w, 1);
    soi_tick(w, 0, 0);                          /* claimed nasties clear on their next update */
    CHECK(soi_enemy_count(w) == 0, "thunderballs: all nasties cleared");
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 4, 9)) == SOI_CELL_EMPTY,
          "thunderballs: pickup cell consumed");

    /* ---- 4b. HAZARD turrets are UNKILLABLE. In the asm a weapon (FUN_1000fd5c) or a
     * thunderball claim (FUN_1000543c) only MARKS a victim's +0x40 (killer); the nasty's
     * own update reads +0x40 and self-destructs. Cannon/Spinner/Knight/Gargoyle/Creeper
     * NEVER read +0x40, so neither weapons nor thunderballs defeat them -- they are
     * permanent (the Help roster lists Cannon/Spinner as "-", not scorable nasties). ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_enemy_spawn(w, SOI_ENEMY_CANNON, 1, 2);
    soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 8, 5);
    soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 11, 12);
    CHECK(soi_enemy_count(w) == 3, "hazards: three turrets before thunderballs");
    soi_set_cell(w, 4, 9, 0x31);               /* thunderballs on the player cell */
    soi_pickup_check(w, 1);
    soi_tick(w, 0, 0);
    CHECK(soi_enemy_count(w) == 3, "hazards: turrets SURVIVE thunderballs (unkillable)");
    CHECK(soi_enemy_points(SOI_ENEMY_CANNON) == 0 && soi_enemy_points(SOI_ENEMY_GARGOYLE) == 0 &&
          soi_enemy_points(SOI_ENEMY_KNIGHT) == 0 && soi_enemy_points(SOI_ENEMY_SPINNER) == 0,
          "hazards: turrets award no points (Help lists them as non-scorable)");

    /* ---- 5. Time-bonus goodies 0x13-0x16 add 2500/5000/7500/10000 (CONFIRMED
     * FUN_1000f3f0). (The Clock 0x2E is a SLOW-enemies power-up, not a time bonus
     * -- see test 8g4.) ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    /* time-bonus goodies 0x13-0x16 add 2500/5000/7500/10000 (CONFIRMED) */
    w->players[1].bonus_time = 1000;
    soi_set_cell(w, 4, 9, 0x15);
    soi_pickup_check(w, 1);
    CHECK(w->players[1].bonus_time == 8500, "time bonus 0x15 (x3) adds 7500 to that player's bonus");

    /* ---- 5a. Loader reads the per-board Bonus from header 0x0E (NOT 0x16). Regression for the
     * 0x16->0x0E fix: 0x16 is a 0/0x3A20 flag, so before, EVERY board wrongly defaulted to 5000.
     * VERIFIED vs refs/images: board_1 0x0E=3000 (HUD 02968), board_2 0x0E=6000 (05995). ---- */
    {
        uint8_t bord[0x1C];
        memset(bord, 0, sizeof(bord));
        bord[0x0E] = 0x17; bord[0x0F] = 0x70;   /* 0x1770 = 6000 = the real per-board Bonus @0x0E */
        bord[0x16] = 0x3A; bord[0x17] = 0x20;   /* 0x3A20 = the OLD-offset flag -> must be IGNORED */
        /* body @0x18: a 0 tile terminates the section immediately (empty board) */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(w->players[1].bonus_time == 6000,
              "loader: per-board Bonus comes from header 0x0E, not the 0x16 flag");
        CHECK(w->players[1].no_weapons_reward == 5000,
              "loader: No-Weapons Reward (0x16 sentinel 0x3A20) defaults to 5000");
    }

    /* ---- 5c. Header validation (asm FUN_1002b448): pct_ultrabuster (0x10), thrown_badguy (0x12),
     * pct_badguy (0x14) are clamped -- any out-of-range value -> 0. Guards the 5 garbage boards
     * (301/428/446/498 hold ASCII "DATA" in these bytes; board_440 has thrown=25). Without this the
     * port read pct_ultrabuster=8224 raw and made EVERY Gargoyle shot an UltraBuster (always-pierce). */
    {
        uint8_t bord[0x1C];
        memset(bord, 0, sizeof(bord));
        bord[0x10] = 0x20; bord[0x11] = 0x20;   /* 0x2020 = 8224 (the "DATA" boards' 0x10) -> 0 */
        bord[0x12] = 0x44; bord[0x13] = 0x41;   /* 0x4441 = 17473 (> 20)  -> 0 */
        bord[0x14] = 0x54; bord[0x15] = 0x41;   /* 0x5441 = 21569 (> 100) -> 0 */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(w->pct_ultrabuster == 0, "loader: garbage pct_ultrabuster (0x10 > 100) clamps to 0");
        CHECK(w->thrown_badguy == 0 && w->pct_badguy == 0,
              "loader: garbage thrown/pct (0x12/0x14 out of range) clamp to 0");
    }

    /* ---- 5d. Header validation cross-constraint (asm FUN_1002b448): thrown_badguy and pct_badguy
     * are LINKED -- if either is 0 the other is zeroed too. A valid pct_ultrabuster is kept. ---- */
    {
        uint8_t bord[0x1C];
        memset(bord, 0, sizeof(bord));
        bord[0x11] = 0x32;                       /* pct_ultrabuster = 50 (valid) -> kept */
        bord[0x15] = 0x32;                       /* pct_badguy = 50 (valid) but thrown = 0 -> both 0 */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(w->pct_ultrabuster == 50, "loader: a valid pct_ultrabuster (0..100) is kept");
        CHECK(w->thrown_badguy == 0 && w->pct_badguy == 0,
              "loader: pct_badguy zeroed when thrown_badguy is 0 (the fields are linked)");
    }

    /* ---- 5b. Goody 0x10 is a 1UP: +1 LIFE (asm FUN_1002bc64 -> FUN_1000e9c8(p,+1); +0x46 =
     * lives, confirmed by the bonus-expiry FUN_1000e9c8(p,-1)). It grants a LIFE, NOT a
     * shield -- the shield count is untouched. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    w->players[1].lives = 3; w->players[1].shield = 2;
    soi_set_cell(w, 4, 9, 0x10);
    soi_pickup_check(w, 1);
    CHECK(w->players[1].lives == 4, "1up: goody 0x10 grants +1 life");
    CHECK(w->players[1].shield == 2, "1up: goody 0x10 does NOT touch the shield count");
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 4, 9)) == 0, "1up: the 0x10 cell is consumed");

    /* ---- 6. Transporter zaps the player from an IN to the paired OUT ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 2, 2);
    soi_set_cell(w, 2, 2, 0x1A);               /* IN marker (pair 0) on player */
    soi_set_cell(w, 10, 10, 0x1B);             /* paired OUT marker elsewhere */
    soi_pickup_check(w, 1);
    CHECK(w->players[1].x == soi_cell_x(10) && w->players[1].y == soi_cell_y(10),
          "transporter: player zapped to the paired OUT cell");
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 2, 2)) == 0x1A,
          "transporter: IN marker persists (not consumed)");
    /* standing on an OUT marker must NOT teleport back */
    soi_pickup_check(w, 1);
    CHECK(w->players[1].x == soi_cell_x(10) && w->players[1].y == soi_cell_y(10),
          "transporter: OUT marker does not re-teleport");

    /* ---- 7. Stop/Go switch (0x24-0x2D): CONFIRMED (asm FUN_10016544/16784 + a full
     * board scan) to be COSMETIC-ONLY -- the paired block group (0x9d-0xd3) is a solid
     * wall in BOTH toggle states and no collision code special-cases it, so a switch
     * has NO gameplay effect. The port treats it as a no-op; enemies are NOT frozen. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 3, 9);
    soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    {
        int ex0;
        soi_set_cell(w, 6, 9, 0x24);           /* Stop/Go switch on the player cell */
        soi_pickup_check(w, 1);                /* stepping it must NOT freeze anything */
        CHECK(w->enemies_frozen == 0, "stopgo: switch does NOT freeze nasties (vestigial field stays 0)");
        ex0 = soi_enemy_x(w, 0);
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_x(w, 0) != ex0, "stopgo: nasties keep moving after a switch is stepped");
    }

    /* ---- 8. The Wheelie (bord 2/3, asm FUN_10009e98) is a wall-FOLLOWING FLYER that
     * does NOT home on the player -- FUN_10009e98 never reads the player position, so its
     * motion is player-INDEPENDENT. Same spawn + heading, two different player positions
     * -> IDENTICAL Wheelie movement. ---- */
    {
        int xa, ya, xb, yb;
        /* (a) player far LEFT/high */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 5);
        soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 8, 8);
        w->enemies[0].dir = 2; w->enemies[0].vx = 2; w->enemies[0].vy = 0;
        soi_tick(w, 0, 0);
        xa = w->enemies[0].x; ya = w->enemies[0].y;
        /* (b) player far RIGHT/low -- same spawn + heading */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 16, 11);
        soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 8, 8);
        w->enemies[0].dir = 2; w->enemies[0].vx = 2; w->enemies[0].vy = 0;
        soi_tick(w, 0, 0);
        xb = w->enemies[0].x; yb = w->enemies[0].y;
        CHECK(xa == xb && ya == yb, "wheelie: flight is player-INDEPENDENT (does not home)");
        CHECK(xa != soi_cell_x(8) || ya != soi_cell_y(8), "wheelie: actually flies (it moved)");
    }

    /* ---- 8b. The Wheelie FLIES with NO gravity (unsupported it does not fall) and
     * ROLLS AROUND obstacles: at a wall AHEAD it TURNS 90 deg to hug the wall (asm
     * FUN_10009e98 wall-follower) -- it does not bounce back or pass through. ---- */
    {
        int ey0;
        /* no-gravity: heading up (dir 8), no floor -> it moves UP, not down */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 9, 8);   /* NO floor under it */
        w->enemies[0].dir = 8; w->enemies[0].vx = 2; w->enemies[0].vy = 0;
        ey0 = w->enemies[0].y;
        soi_enemies_update(w);
        CHECK(w->enemies[0].y < ey0, "wheelie: flies UP with no gravity (does not fall)");
        /* roll-around: a wall directly LEFT -> it TURNS (dir no longer left) and does NOT
         * move into the wall cell (rolls ALONG it instead of passing through / bouncing). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 5, 6);
        soi_set_cell(w, 4, 6, SOI_CELL_SUPPORTIVE);    /* wall directly to the left */
        w->enemies[0].dir = 1;                          /* heading into the wall */
        soi_enemies_update(w);
        CHECK(w->enemies[0].dir != 1 && w->enemies[0].x >= soi_cell_x(5),
              "wheelie: rolls around a wall (turns 90 deg, does not pass through)");
    }

    /* ---- 8c. Persistent SPAWNER (placement 5/6/10/11/12/18/19): a stationary
     * emitter that produces its base nasty (child = placement+0x64) every
     * StartDelay*6 frames; emitted children are TRANSIENT (lifespanned) so the
     * playfield does not fill up (FUN_100076a8 &c). */
    {
        int si, ci = -1, e;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        CHECK(soi_bord_is_spawner(6) && soi_bord_is_spawner(12) && !soi_bord_is_spawner(4),
              "spawner: placement 6/12 are spawners, 4 (Walker) is a direct nasty");
        si = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the spawner stands */
        w->enemies[si].spawn_child = (uint8_t)SOI_ENEMY_HAMMER;
        w->enemies[si].vx = 0;                          /* stationary spawner */
        w->enemies[si].fire_period = 1000;              /* emit once within the window */
        w->enemies[si].fire_cd = 0;                     /* emit on the next update */
        soi_enemies_update(w);
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (e != si && w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_HAMMER) { ci = e; break; }
        CHECK(ci >= 0, "spawner: a persistent spawner emits a child nasty");
        CHECK(ci >= 0 && w->enemies[ci].life > 0, "spawner: the emitted child is transient (lifespan set)");
        if (ci >= 0) w->enemies[ci].life = 2;           /* force it to the brink of expiry */
        soi_enemies_update(w); soi_enemies_update(w);
        CHECK(ci >= 0 && !w->enemies[ci].active, "spawner: a child despawns when its lifespan expires");
    }

    /* ---- 8c2. Spawner emit DIRECTION modes (asm FUN_100076a8 switch on +0x4c):
     * ALTERNATE (both dir bits 0x100|0x200) flips right<->left each emit; SEEK
     * (0x2000) aims the child at the nearest live player. Fixed left/right keep the
     * loaded dir. We carry the mode in the emitter's `state` (3=alt, 4=seek). ---- */
    {
        int si, c1 = -1, c2 = -1, e;
        /* ALTERNATE: first emit RIGHT, second LEFT (asm starts +0x7c==0 -> right). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);                        /* park the player away */
        si = soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 8, 5);
        soi_set_cell(w, 8, 6, SOI_CELL_SUPPORTIVE);      /* floor under the spawner */
        w->enemies[si].spawn_child = (uint8_t)SOI_ENEMY_HIPPO;
        w->enemies[si].vx = 0; w->enemies[si].state = 3; /* alternate mode */
        w->enemies[si].fire_period = 1000; w->enemies[si].fire_cd = 0;
        soi_enemies_update(w);
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (e != si && w->enemies[e].active && w->enemies[e].spawn_child == 0) { c1 = e; break; }
        CHECK(c1 >= 0 && w->enemies[c1].dir == 2, "spawner alt: first child emits RIGHT");
        w->enemies[si].fire_cd = 0;                      /* emit again */
        soi_enemies_update(w);
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (e != si && e != c1 && w->enemies[e].active && w->enemies[e].spawn_child == 0) { c2 = e; break; }
        CHECK(c2 >= 0 && w->enemies[c2].dir == 1, "spawner alt: second child emits LEFT (toggled)");

        /* SEEK: a live player to the LEFT (col 2 < spawner col 8) -> child aims LEFT. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 5);
        si = soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 8, 5);
        soi_set_cell(w, 8, 6, SOI_CELL_SUPPORTIVE);
        w->enemies[si].spawn_child = (uint8_t)SOI_ENEMY_HIPPO;
        w->enemies[si].vx = 0; w->enemies[si].state = 4; /* seek mode */
        w->enemies[si].fire_period = 1000; w->enemies[si].fire_cd = 0;
        soi_enemies_update(w);
        c1 = -1;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (e != si && w->enemies[e].active && w->enemies[e].spawn_child == 0) { c1 = e; break; }
        CHECK(c1 >= 0 && w->enemies[c1].dir == 1, "spawner seek: child aims LEFT toward the player");
    }

    /* ---- 8d. The Robo does NOT climb (asm FUN_1000a780: its wall response is an
     * in-place punch/break animation or a turn -- it never steps up). Penned by a
     * wall on each side, it reverses off the walls and stays on its row. */
    {
        int ri, t, y0, turned = 0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;     /* heading right */
        w->enemies[ri].y = soi_cell_y(9);
        y0 = w->enemies[ri].y;
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);       /* floor (cols 4,5) */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE);        /* wall ahead (right) */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 3, 9, SOI_CELL_SUPPORTIVE);        /* wall behind (left) */
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);
        for (t = 0; t < 30; t++) {
            soi_enemies_update(w);
            if (w->enemies[ri].dir == 1) turned = 1;       /* reversed at the right wall */
        }
        CHECK(turned, "robo: turns back at a wall (does not climb over)");
        CHECK(w->enemies[ri].y == y0, "robo: stays on its row at a wall (no climb up)");
    }

    /* ---- 8d2. The Robo PUNCHES through a breakable block ahead (asm +0x6e ->
     * FUN_10027d84 clears the cell) and keeps its heading, rather than turning --
     * it only turns at a PERMANENT wall or a ledge. */
    {
        int ri, t, c;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 4, 9);
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;         /* heading right */
        w->enemies[ri].y = soi_cell_y(9);
        for (c = 3; c <= 11; c++) soi_set_cell(w, c, 10, SOI_CELL_SUPPORTIVE);  /* long floor */
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 0x07);     /* a breakable block ahead */
        for (t = 0; t < 50; t++) soi_enemies_update(w);
        CHECK(!(soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE), "robo: punches through a breakable block");
        CHECK(w->enemies[ri].dir == 2, "robo: keeps its heading after punching (no turn)");
    }

    /* ---- 8e. A Beanie BUDS a child when a wall blocks it (FUN_10006378), at most
     * one living bud at a time; buds are transient and do not themselves bud. */
    {
        int pi, n, e, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        pi = soi_enemy_spawn(w, SOI_ENEMY_BEANIE, 5, 9);
        w->enemies[pi].dir = 2; w->enemies[pi].vx = 2;     /* walking right into a wall */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);       /* floor */
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE);        /* wall ahead */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_enemies_update(w);                             /* hits the wall -> buds + reverses */
        n = 0;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_BEANIE) n++;
        CHECK(n == 2, "beanie: buds one child at a wall");
        CHECK(w->enemies[pi].child != 0, "beanie: parent records its one living bud");
        for (t = 0; t < 6; t++) soi_enemies_update(w);     /* must not bud a second while it lives */
        n = 0;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_BEANIE) n++;
        CHECK(n == 2, "beanie: at most one living bud at a time");
    }

    /* ---- 8f. The Gargoyle (bord 14, asm FUN_1000adc4) and Knight (bord 13, asm
     * FUN_1000c2e8) shooters. The Gargoyle AIMS its puff (FUN_1000b44c, normalized
     * velocity) STRAIGHT at the nearest player -- diagonally if need be -- while the
     * Knight DROPS a gift (non-hostile). We reproduce the aim with the dominant axis at
     * 4 px/frame + a proportional minor axis. */
    {
        int gi, ki, i, gh = -1, kh = -1;
        /* Gargoyle: player to the RIGHT (same row) -> a pure rightward shot (vy == 0). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 9);
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 3, 9);
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);    /* floor so it stands */
        w->enemies[gi].fire_cd = 0;
        soi_enemies_update(w);
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].hostile) { gh = i; break; }
        CHECK(gh >= 0 && w->projectiles[gh].vx > 0 && w->projectiles[gh].vy == 0,
              "gargoyle: aims a hostile shot toward the player (rightward)");
        /* Gargoyle DIAGONAL aim: player UP-RIGHT -> the shot tracks diagonally
         * (vx > 0, vy < 0), not axis-locked (asm FUN_1000b44c normalized velocity). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 5);
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 3, 9);
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[gi].fire_cd = 0;
        soi_enemies_update(w);
        gh = -1;
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].hostile) { gh = i; break; }
        CHECK(gh >= 0 && w->projectiles[gh].vx > 0 && w->projectiles[gh].vy < 0,
              "gargoyle: aims DIAGONALLY at an up-right player (vx>0, vy<0)");
        /* Knight: instead of shooting, it DROPS a gift -- a kind-2, NON-hostile projectile
         * that flies to a target cell. It never fires a hostile bolt (asm FUN_1000c2e8). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 3);
        ki = soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 8, 9);
        soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[ki].fire_cd = 0;
        soi_enemies_update(w);
        kh = -1;
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].kind == 2) { kh = i; break; }
        CHECK(kh >= 0 && !w->projectiles[kh].hostile,
              "knight: drops a gift (a kind-2, non-hostile projectile), not a bolt");
        {
            int hostile_seen = 0, j;
            for (j = 0; j < SOI_MAX_PROJECTILES; j++)
                if (w->projectiles[j].active && w->projectiles[j].hostile) hostile_seen = 1;
            CHECK(!hostile_seen, "knight: fires no hostile shot (it drops gifts)");
        }
    }

    /* ---- 8g. Enemies fall off a ledge only when BOTH feet clear it (the asm
     * probes two footprint cells, FUN_10005750): an enemy straddling a one-cell
     * gap stays up; one fully over the gap falls. */
    {
        int ai, y0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ai = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        w->enemies[ai].vx = 0;                          /* isolate gravity from the walk */
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* floor left of the gap */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* floor right; (5,10) is a one-cell GAP */
        w->enemies[ai].x = soi_cell_x(4) + 20;          /* straddle: left foot col 4, right foot col 5 */
        y0 = w->enemies[ai].y;
        soi_enemies_update(w);
        CHECK(w->enemies[ai].y == y0, "ledge: an enemy straddling a one-cell gap stays up");
        w->enemies[ai].x = soi_cell_x(5);               /* now fully over the gap */
        soi_enemies_update(w);
        CHECK(w->enemies[ai].y > y0, "ledge: an enemy fully over the gap falls");
    }

    /* ---- 8g2. The WALKER (asm FUN_1000dd4c) PATROLS: it turns at a LEDGE (a
     * foot-level ground probe ahead), unlike the simple walkers, so it stays on
     * its platform and walks back and forth instead of walking off. */
    {
        int wi, y0, minc = 99, maxc = -1, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_WALKER, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* 3-cell platform cols 4,5,6 */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* gaps at cols 3 and 7 */
        w->enemies[wi].dir = 2;
        w->enemies[wi].y = soi_cell_y(9);
        y0 = w->enemies[wi].y;
        for (t = 0; t < 200; t++) {
            int c;
            soi_enemies_update(w);
            c = (w->enemies[wi].x - SOI_ORIGIN_X) / SOI_CELL_PX;
            if (c < minc) minc = c;
            if (c > maxc) maxc = c;
        }
        CHECK(w->enemies[wi].y == y0, "walker: patrols without falling off the platform");
        CHECK(minc < maxc, "walker: walks back and forth (patrols, not stuck)");
        /* Reaches BOTH platform edges: heading left the leading foot (asm x+2) walks
         * to col 4's edge, so the left-edge column dips to 3 (a few-px sprite overhang)
         * while the foot stays supported -- the old col-1 probe turned a cell early. */
        CHECK(minc >= 3 && maxc <= 6, "walker: turns at the platform edges (foot patrols cols 4-6)");
    }

    /* ---- 8g3. The ROBO (asm FUN_1000a780, the enemy on the real Board#1) also
     * PATROLS: it reverses at a ledge (a foot probe ahead) like the Walker, so it
     * stays on its platform instead of walking off the edge and falling. */
    {
        int ri, y0, minc = 99, maxc = -1, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* 3-cell platform cols 4,5,6 */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* gaps at cols 3 and 7 */
        w->enemies[ri].dir = 2;
        w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        y0 = w->enemies[ri].y;
        for (t = 0; t < 200; t++) {
            int c;
            soi_enemies_update(w);
            c = (w->enemies[ri].x - SOI_ORIGIN_X) / SOI_CELL_PX;
            if (c < minc) minc = c;
            if (c > maxc) maxc = c;
        }
        CHECK(w->enemies[ri].y == y0, "robo: patrols without falling off the platform");
        CHECK(minc < maxc, "robo: walks back and forth (patrols, not stuck)");
        /* Reaches BOTH platform edges (see the walker note): the left-edge column dips
         * to 3 as the leading foot reaches col 4's edge, while the foot stays supported. */
        CHECK(minc >= 3 && maxc <= 6, "robo: turns at the platform edges (foot patrols cols 4-6)");
    }

    /* ---- 8g3b. BUG #3 (fall-death): pulling the block DIRECTLY UNDER a patrolling
     * edge-turner (Robo/Walker) drops it STRAIGHT DOWN and KILLS it the instant it
     * lands on the next block -- the asm fall branch (FUN_1000a780 / FUN_1000dd4c)
     * awards the kill (per-enemy "ding" + score) to the nearest player. This is the
     * reported regression: the Robo used to survive the drop and keep walking. */
    {
        int ri, t, y0, score0, killed, fell, has_ding, k, yb;
        soi_world_init(w, 2);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 8);                        /* a player to credit the fall-kill */
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 8);
        w->enemies[ri].vx = 0;                           /* isolate the vertical drop */
        w->enemies[ri].dir = 2;
        w->enemies[ri].y = soi_cell_y(8);
        soi_set_cell(w, 5, 9, SOI_CELL_SUPPORTIVE);      /* the block DIRECTLY UNDER the robo */
        soi_set_cell(w, 5, 12, SOI_CELL_SUPPORTIVE);     /* the "next block under" it will land on */
        y0 = w->enemies[ri].y;
        soi_enemies_update(w);                           /* one frame while still supported */
        CHECK(w->enemies[ri].active && w->enemies[ri].y == y0,
              "bug3: robo rests on its support block (not falling yet)");
        score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0);                        /* pull the block out from under it */
        fell = killed = 0;
        for (t = 0; t < 80; t++) {
            yb = w->enemies[ri].y;
            soi_enemies_update(w);
            if (w->enemies[ri].y > yb) fell = 1;
            if (!w->enemies[ri].active) { killed = 1; break; }
        }
        CHECK(fell, "bug3: robo FALLS when its support is destroyed");
        CHECK(w->enemies[ri].x == soi_cell_x(5),
              "bug3: the fall is STRAIGHT DOWN (x unchanged -- no drift)");
        CHECK(killed, "bug3: robo DIES on landing (edge-turner fall-death; was: survived)");
        CHECK(w->players[1].score > score0,
              "bug3: the fall-kill awards the robo's points to the nearest player");
        has_ding = 0;
        for (k = 0; k < soi_sfx_count(w); k++)
            if (soi_sfx_get(w, k) == SOI_SFX_KILL_ROBO) has_ding = 1;
        CHECK(has_ding, "bug3: the fall-kill plays the robo kill 'ding' (SOI_SFX_KILL_ROBO)");
        /* The kill also enqueues one cosmetic death "pop" (asm FUN_10028014 flying
         * death sprite) for the renderer -- position/type/facing snapshot, transient
         * (not serialized, so it never perturbs the determinism hash). */
        CHECK(soi_death_count(w) == 1,
              "bug3: the fall-kill enqueues one death-pop effect (asm FUN_10028014)");
        CHECK(soi_death_type(w, 0) == SOI_ENEMY_ROBO,
              "bug3: the queued death-pop is the ROBO (type snapshot for the renderer)");
        CHECK(soi_death_x(w, 0) == soi_cell_x(5),
              "bug3: the death-pop x matches the robo's column (no drift at spawn)");
    }

    /* ---- 8g3c. CONTRAST (answers the user's "verify this"): an edge-WALKER that
     * walks off ledges BY DESIGN (Ant/Ostrich/Hippo/Piggy/Smiley/Teeth) does NOT die
     * from a drop -- only the two edge-TURNERS (Robo/Walker) do. Pull the block out
     * from under an Ant and it falls, then simply resettles on the block below,
     * still alive (asm: only the Robo/Walker fall branches carry the kill). */
    {
        int ai, t, killed;
        soi_world_init(w, 2);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 8);
        ai = soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 8);
        w->enemies[ai].vx = 0;
        w->enemies[ai].y = soi_cell_y(8);
        soi_set_cell(w, 5, 9, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 5, 12, SOI_CELL_SUPPORTIVE);
        soi_enemies_update(w);
        soi_set_cell(w, 5, 9, 0);                        /* same drop as the robo above */
        killed = 0;
        for (t = 0; t < 80; t++) {
            soi_enemies_update(w);
            if (!w->enemies[ai].active) { killed = 1; break; }
        }
        CHECK(!killed && w->enemies[ai].active,
              "bug3-contrast: an edge-WALKER (Ant) SURVIVES the same drop (resettles, no kill)");
    }

    /* ---- 8g4. The Clock goody (0x2E, asm FUN_1002bc64 -> _DAT_1003b294 = 600)
     * SLOWS every nasty to half speed for ~10s: the enemy dispatcher runs every
     * OTHER frame while the counter is up, so a nasty travels ~half as far. */
    {
        int wi, start, x_fast, x_slow, t;

        /* collecting the 0x2E goody arms the counter */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x2Eu);
        soi_pickup_check(w, 1);
        CHECK(w->enemy_slow == 600, "clock: collecting the 0x2E goody arms the slow-enemies counter");
        CHECK(soi_sfx_count(w) == 1 && soi_sfx_get(w, 0) == SOI_SFX_CLOCK,
              "clock: pickup plays the 'slow' sound (evt 0x2B -> 1005)");

        /* baseline: a nasty's travel over 40 frames at full rate */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        for (t = 3; t <= 15; t++) soi_set_cell(w, t, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 2; w->enemies[wi].y = soi_cell_y(9);
        start = w->enemies[wi].x;
        for (t = 0; t < 40; t++) soi_tick(w, 0, 0);
        x_fast = w->enemies[wi].x - start;

        /* same run, but slowed by a Clock */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        for (t = 3; t <= 15; t++) soi_set_cell(w, t, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 2; w->enemies[wi].y = soi_cell_y(9);
        w->enemy_slow = 600;
        for (t = 0; t < 40; t++) soi_tick(w, 0, 0);
        x_slow = w->enemies[wi].x - start;

        CHECK(w->enemy_slow == 560, "clock: the slow counter ticks down (600 -> 560 over 40 frames)");
        CHECK(x_fast > 0 && x_slow > 0, "clock: the nasty still moves while slowed");
        CHECK(2 * x_slow >= x_fast - 8 && 2 * x_slow <= x_fast + 8, "clock: slowed nasty travels ~half as far");
    }

    /* ---- 8g4b. Magnifying glass (goody 0x2F, asm FUN_10016b28): arms the hidden-treasure
     * reveal timer and does NOT defeat nasties (that is the 0x31 thunderballs goody). ---- */
    {
        int wi2;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        wi2 = soi_enemy_spawn(w, SOI_ENEMY_ANT, 8, 9);
        soi_set_cell(w, 5, 5, 0x2Fu);
        soi_pickup_check(w, 1);
        CHECK(soi_reveal_timer(w) == 300, "magnify: 0x2F arms the ~5s hidden-treasure reveal timer");
        CHECK(w->enemies[wi2].active && !w->enemies[wi2].claimed,
              "magnify: 0x2F does NOT defeat nasties (thunderballs is 0x31)");
        soi_tick(w, 0, 0);
        CHECK(soi_reveal_timer(w) == 299, "magnify: the reveal timer counts down");
    }

    /* ---- 8g4c. Gargoyle UltraBuster (pct_ultrabuster roll, asm FUN_1000b44c/FUN_1000b0a4):
     * a PIERCE shot passes THROUGH a destructible block and destroys the next; a BREAK
     * shot dies on the first block. Both are set on the projectile's +pierce flag. ---- */
    {
        SoiProjectile *pr;
        int t;
        /* BREAK (pierce=0): stops at the first block */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_set_cell(w, 5, 9, 0x207u); soi_set_cell(w, 6, 9, 0x207u);
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 1; pr->kind = 0; pr->src_type = (uint8_t)SOI_ENEMY_GARGOYLE;
        pr->x = soi_cell_x(4); pr->y = soi_cell_y(9); pr->vx = 8; pr->vy = 0; pr->age = 0; pr->pierce = 0;
        for (t = 0; t < 12; t++) soi_tick(w, 0, 0);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) == 0, "gargoyle-break: destroys the first block");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0, "gargoyle-break: stops at the first (second intact)");

        /* PIERCE (pierce=1): passes through to the second block */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_set_cell(w, 5, 9, 0x207u); soi_set_cell(w, 6, 9, 0x207u);
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 1; pr->kind = 0; pr->src_type = (uint8_t)SOI_ENEMY_GARGOYLE;
        pr->x = soi_cell_x(4); pr->y = soi_cell_y(9); pr->vx = 8; pr->vy = 0; pr->age = 0; pr->pierce = 1;
        for (t = 0; t < 12; t++) soi_tick(w, 0, 0);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0, "gargoyle-pierce: UltraBuster destroys the second block too");
    }

    /* ---- 8g4d. Knight gift (bord 13, asm FUN_1000c2e8 -> FUN_1000c680): a kind-2 gift
     * projectile flies to its target cell and drops a goody -- a collectible on an EMPTY
     * cell, or a gift-BLOCK (hidden payload) if the player blocked the cell mid-flight. ---- */
    {
        SoiProjectile *pr; int t;
        /* empty target -> collectible goody */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 0; pr->kind = 2; pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT;
        pr->gtype = 0x0A; pr->tcol = 7; pr->trow = 8;
        pr->x = soi_cell_x(3); pr->y = soi_cell_y(3); pr->vx = 0; pr->vy = 0; pr->age = 0;
        for (t = 0; t < 200 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        CHECK(!w->projectiles[0].active, "knight-gift: the gift lands and despawns");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 7, 8)) == 0x0A && (soi_get_cell(w, 7, 8) & 0x900u) == 0x900u,
              "knight-gift: an empty target becomes a collectible goody (0x90A silver coin)");

        /* target BLOCKED before arrival -> gift-block with the goody as a hidden payload */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_set_cell(w, 7, 8, 0x07u);   /* a player block already occupies the target */
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 0; pr->kind = 2; pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT;
        pr->gtype = 0x17; pr->tcol = 7; pr->trow = 8;
        pr->x = soi_cell_x(3); pr->y = soi_cell_y(3); pr->vx = 0; pr->vy = 0; pr->age = 0;
        for (t = 0; t < 200 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        CHECK((soi_get_cell(w, 7, 8) & SOI_CELL_SPECIAL) &&
              SOI_CELL_PAYLOAD(soi_get_cell(w, 7, 8)) == (0x900u | 0x17u),
              "knight-gift: a blocked target becomes a gift-block (gold coin hidden as its payload)");
    }

    /* ---- 8g4e. 3rd co-op player (remaster extension, SOI_MAX_PLAYERS==4 -> slot 3):
     * soi_spawn_player3 activates P3, and soi_tick3 drives a THIRD input channel while
     * the 2-arg soi_tick stays 2-player (P3 gets no input). ---- */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        w->players[1].spawn_x = (int16_t)soi_cell_x(5);
        w->players[1].spawn_y = (int16_t)soi_cell_y(9);
        soi_spawn_player3(w);
        CHECK(w->players[3].active && soi_player_alive(w, 3),
              "p3: soi_spawn_player3 activates the 3rd co-op player (slot 3)");
        w->tick = 0;                       /* next tick is odd -> input latches */
        soi_tick3(w, 0, 0, 0x55);
        CHECK(w->players[3].input == 0x55, "p3: soi_tick3 latches the 3rd player's input channel");
        w->tick = 0;
        soi_tick(w, 0x11, 0x22);
        CHECK(w->players[1].input == 0x11 && w->players[2].input == 0x22 && w->players[3].input == 0,
              "p3: the 2-arg soi_tick drives P1/P2 and leaves P3 with no input (backward compat)");
    }

    /* ---- 8g5. Each goody plays its OWN pickup sound (asm FUN_1002bc64 events,
     * channel 10), not one generic chime. */
    {
        struct { unsigned type; int sfx; const char *msg; } g[] = {
            { 0x10, SOI_SFX_PICKUP_SHIELD, "goody: shield pickup plays its own sound (evt 0x18)" },
            { 0x11, SOI_SFX_PICKUP_ARROW,  "goody: arrow ammo plays its own sound (evt 0x19)"   },
            { 0x12, SOI_SFX_PICKUP_BALL,   "goody: ball ammo plays its own sound (evt 0x1a)"    },
            { 0x14, SOI_SFX_PICKUP_TIME,   "goody: time bonus plays its own sound (evt 0x1b)"   },
            { 0x30, SOI_SFX_SHIELD_ON,     "goody: shield activate plays its own sound (evt 0x29)" },
            { 0x31, SOI_SFX_WHISTLE,       "goody: enemy-claim plays its own sound (evt 0x2a)"  },
            { 0x32, SOI_SFX_SHOES,         "goody: speed shoes play their own sound (evt 0x28)" },
        };
        int k;
        for (k = 0; k < 7; k++) {
            soi_world_init(w, 1);
            w->players[1].active = 1; w->players[1].alive = 1;
            w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
            soi_set_cell(w, 5, 5, g[k].type);
            soi_pickup_check(w, 1);
            CHECK(soi_sfx_count(w) >= 1 && soi_sfx_get(w, 0) == g[k].sfx, g[k].msg);
        }

        /* a colored key (door bit 0x800 + low type 7) plays its own "Announce"
         * sound (evt 0x14), not the generic door/powerup chime */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x807u);
        soi_pickup_check(w, 1);
        CHECK(soi_sfx_count(w) >= 1 && soi_sfx_get(w, 0) == SOI_SFX_KEY,
              "goody: colored key plays its own sound (evt 0x14 -> 17661)");

        /* the ammo/life goody EFFECTS (asm FUN_1000e9c8/eb34/ec50 -> player +0x46/
         * +0x4c/+0x4a): 0x10 -> LIFE (1UP, +0x46 = lives), 0x11 -> arrows, 0x12 -> balls
         * (ball-fire reads +0x4a, arrow-fire reads +0x4c). */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        w->players[1].balls = 0; w->players[1].shield = 0; w->players[1].lives = 3;
        soi_set_cell(w, 5, 5, 0x10u); soi_pickup_check(w, 1);
        CHECK(w->players[1].lives == 4 && w->players[1].shield == 0 && w->players[1].balls == 0,
              "goody: 0x10 grants a LIFE/1UP (not a shield or ball)");
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        w->players[1].balls = 0; w->players[1].shield = 0;   /* isolate from new-game ammo/shield */
        soi_set_cell(w, 5, 5, 0x12u); soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == 1 && w->players[1].shield == 0, "goody: 0x12 grants a ball (not a shield)");

        /* the speed-shoes goody 0x32 (asm FUN_10014ccc) arms 2x fast-mode for ~20s;
         * it is NOT a 1UP -- the 1UP is goody 0x10 (FUN_1000e9c8 -> +0x46 lives, above). */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        {
            int lv0 = w->players[1].lives;
            soi_set_cell(w, 5, 5, 0x32u); soi_pickup_check(w, 1);
            CHECK(w->players[1].fast == 1200 && w->players[1].lives == lv0,
                  "goody: 0x32 arms fast-mode speed shoes, not a life");
            CHECK(soi_player_fast(w, 1) == 1200, "accessor: player_fast reflects speed-shoes");
        }

        /* fast-mode runs the player at 60Hz: a shoed faller drops ~2x as far as a
         * normal one over the same ticks (even-tick physics; edges already consumed). */
        {
            int y_norm, y_fast, t, y0;
            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            reset_player(w, 1, 5, 3);
            w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
            y0 = w->players[1].y;
            for (t = 0; t < 10; t++) soi_tick(w, 0, 0);
            y_norm = w->players[1].y - y0;

            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            reset_player(w, 1, 5, 3);
            w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
            w->players[1].fast = 1200;
            y0 = w->players[1].y;
            for (t = 0; t < 10; t++) soi_tick(w, 0, 0);
            y_fast = w->players[1].y - y0;

            CHECK(y_norm > 0 && y_fast > y_norm + y_norm / 2,
                  "goody: 0x32 fast-mode ~doubles the fall rate (60Hz physics)");
        }
    }

    /* ---- 8h. The Hammer (FUN_10007998) WALKS flat -- it does NOT hop continuously
     * (the old ballistic-hopper port was wrong). On open floor it stays grounded and
     * steps horizontally. ---- */
    {
        int hi, y0, x0, t, wentAirborne = 0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);    /* flat floor to walk along */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 7, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[hi].dir = 2; w->enemies[hi].vx = 2;
        y0 = w->enemies[hi].y; x0 = w->enemies[hi].x;
        for (t = 0; t < 12; t++) {
            soi_enemies_update(w);
            if (w->enemies[hi].y != y0) wentAirborne = 1;   /* any vertical move = a hop */
        }
        CHECK(!wentAirborne, "hammer: walks FLAT on open floor (no continuous hop)");
        CHECK(w->enemies[hi].x != x0, "hammer: walks forward");
    }

    /* ---- 8i. The Hammer JUMP-SMASHES a breakable wall AHEAD (asm FUN_10027aec at
     * X+0x1a,Y+0xa + sound 0x11): it shatters the wall and hops. A PERMANENT wall ahead
     * makes it TURN instead (wall intact). ---- */
    {
        int hi;
        /* (a) breakable wall ahead -> the hammer RISES a fixed 11px, HOLDS that height
         * for 16 update-steps, SMASHES the wall mid-swing (asm strike frame 0x4b), then
         * DROPS the 11px back to the floor. This is the asm FUN_10007998 fixed-lift
         * choreography, not the old instant-smash + ballistic hop. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);    /* floor */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, 0x207u);                  /* breakable wall directly ahead */
        w->enemies[hi].dir = 2; w->enemies[hi].vx = 2;
        {
            int y0 = w->enemies[hi].y, minY, t, smashed = 0;
            soi_enemies_update(w);                      /* step 1: begin the jump-smash (rise) */
            minY = w->enemies[hi].y;
            CHECK(w->enemies[hi].y == y0 - 11, "hammer: rises a fixed 11px as it begins the smash");
            for (t = 0; t < 20 && w->enemies[hi].fire_cd != 0; t++) {
                soi_enemies_update(w);
                if (w->enemies[hi].y < minY) minY = w->enemies[hi].y;
                if (SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0) smashed = 1;
            }
            CHECK(smashed, "hammer: jump-smashes the breakable wall ahead (mid-swing)");
            CHECK(y0 - minY == 11, "hammer: holds a fixed 11px lift through the swing");
            CHECK(w->enemies[hi].y == y0, "hammer: drops back to the floor after the smash");
        }
        /* (b) permanent wall ahead -> the hammer turns, the wall survives */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | SOI_CELL_PERMANENT | 0x01u);  /* permanent wall ahead */
        w->enemies[hi].dir = 2; w->enemies[hi].vx = 2;
        soi_enemies_update(w);
        CHECK(w->enemies[hi].dir == 1, "hammer: turns at a permanent wall ahead");
        CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE), "hammer: the permanent wall survives");
    }

    /* ---- 9. Sound events are queued for the front-end + reset each tick ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_set_cell(w, 4, 9, 0x17);               /* gold coin under the player */
    soi_pickup_check(w, 1);
    CHECK(soi_sfx_count(w) == 1 && soi_sfx_get(w, 0) == SOI_SFX_COIN_GOLD,
          "sfx: gold coin queues its own SOI_SFX_COIN_GOLD");
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 6, 9);
    soi_enemy_kill(w, 0, 1);
    CHECK(soi_sfx_get(w, 1) == SOI_SFX_KILL_ANT,
          "sfx: killing an Ant queues its own kill sound (per-enemy, not the generic squash)");
    soi_tick(w, 0, 0);
    CHECK(soi_sfx_count(w) == 0, "sfx: queue is cleared at the start of each tick");

    /* 9b. Each coin tier plays a DISTINCT sound (asm FUN_1002bc64 events silver
     * 0x15, gold 0x1c, gem 0x1d, bars 0x1e) instead of one generic coin blip. */
    {
        unsigned tiles[4] = { 0x0A, 0x17, 0x18, 0x19 };
        int want[4] = { SOI_SFX_COIN, SOI_SFX_COIN_GOLD, SOI_SFX_COIN_GEM, SOI_SFX_COIN_BARS };
        const char *msg[4] = {
            "sfx: silver coin -> SOI_SFX_COIN", "sfx: gold coin -> SOI_SFX_COIN_GOLD",
            "sfx: gem -> SOI_SFX_COIN_GEM",     "sfx: gold bars -> SOI_SFX_COIN_BARS" };
        int k;
        for (k = 0; k < 4; k++) {
            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            reset_player(w, 1, 4, 9);
            soi_set_cell(w, 4, 9, tiles[k]);
            soi_pickup_check(w, 1);
            CHECK(soi_sfx_get(w, 0) == want[k], msg[k]);
        }
    }

    /* ---- 10. Death → respawn at spawn cell while lives remain; else game over ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    w->players[1].lives = 2;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* enemy on the player -> a hit */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    soi_tick(w, 0, 0);   /* the ant contacts the player -> death-throw launches */
    CHECK(soi_player_alive(w, 1) == 1 && w->players[1].ground_state == SOI_ST_DEAD,
          "death: a hit launches the somersault death-throw (still 'alive' mid-arc)");
    {   /* the arc carries the player off the bottom, then commits the life-loss */
        int t;
        for (t = 0; t < 200 && soi_player_alive(w, 1); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_player_alive(w, 1) == 0 && w->players[1].lives == 1,
          "death: the throw ends off-screen and costs a life");
    CHECK(soi_game_over(w) == 0, "respawn: not game over while a life remains");
    {
        int t;
        for (t = 0; t < 120 && !soi_player_alive(w, 1); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_player_alive(w, 1) == 1 &&
          w->players[1].x == soi_cell_x(5) && w->players[1].y == soi_cell_y(9),
          "respawn: player revives at the spawn cell");
    /* Burn the last life. FAITHFUL count (asm FUN_1000e9c8 allows lives=-1; FUN_1001f4f8 games
     * over at lives<0; the HUD clamps <0 to display 0): the killing blow eliminates ONLY when it
     * drops the count BELOW 0, so the displayed "0 lives" is still a PLAYABLE last life -- dying
     * at lives=1 respawns at 0, and only the death AT 0 lives is game over. */
    {
        int e, t;
        for (e = 0; e < SOI_MAX_ENEMIES; e++) w->enemies[e].active = 0;   /* clear the arena */
        w->players[1].lives = 1; w->players[1].invuln = 0;
        soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
        for (t = 0; t < 200 && soi_player_alive(w, 1); t++) soi_tick(w, 0, 0);
        CHECK(soi_game_over(w) == 0 && w->players[1].lives == 0,
              "gameover: dying at lives=1 drops to a PLAYABLE 0 -- NOT game over (asm: out at lives<0)");
        for (t = 0; t < 120 && !soi_player_alive(w, 1); t++) soi_tick(w, 0, 0);   /* respawn */
        for (e = 0; e < SOI_MAX_ENEMIES; e++) w->enemies[e].active = 0;
        w->players[1].invuln = 0;
        soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
        for (t = 0; t < 200 && !soi_game_over(w); t++) soi_tick(w, 0, 0);
    }
    CHECK(soi_game_over(w) == 1, "gameover: the death AT 0 lives (-> -1) finally eliminates all players");

    /* ---- 11. Level complete = collect the KEY then exit through the DOOR ---- */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);            /* key on the player cell */
        CHECK(soi_level_complete(w) == 0, "levelclear: not complete before the key");
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "levelclear: key collected");
        CHECK(soi_level_complete(w) == 0, "levelclear: key alone is not the exit");
        /* walk to and enter the door */
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        w->players[1].bonus_time = 2000;                /* this player's remaining bonus */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "levelclear: exited through the door");
        CHECK(soi_level_complete(w) == 1, "levelclear: key + door exit -> complete");
        CHECK(w->players[1].score == 2000 && w->players[1].bonus_time == 0,
              "levelclear: remaining bonus added to score on exit");
        /* Treasure is SCORING, not the objective: the CONFIRMED win condition is
         * key + door (docs gameplay-and-design.md 1), NOT "collect all treasure".
         * Completion must still fire with treasure uncollected -- this guards the
         * old all-treasure placeholder (decompiled-findings.md 5) from returning. */
        w->goodies_total = 3; w->goodies_left = 2;
        CHECK(soi_level_complete(w) == 1,
              "levelclear: key+door completes even with treasure left (treasure = score, not objective)");
    }

    /* ---- 11b. Colored key/lock/door = the REAL boards' win system. Collecting a
     * colored key (low 7/8/9 + 0x800) sweeps the grid and turns every matching
     * LOCK (low = key-3, i.e. 4/5/6) into an OPENED DOOR (low + 0x8fd => 0x901/2/3
     * = low 1/2/3 + 0x800); stepping on an opened door completes the level. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        soi_set_cell(w, 8, 9, 0x0904u);                 /* colored lock (opened by key 7) */
        soi_set_cell(w, 4, 9, 0x0907u);                 /* colored key 7 on the player cell */
        CHECK(soi_level_complete(w) == 0, "colorkey: not complete before the key");
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "colorkey: colored key collected");
        CHECK(soi_get_cell(w, 4, 9) == SOI_CELL_EMPTY, "colorkey: key cell consumed");
        CHECK(soi_get_cell(w, 8, 9) == 0x0901u, "colorkey: matching lock opened into a door");
        CHECK(soi_level_complete(w) == 0, "colorkey: collecting the key is not yet the exit");
        w->players[1].x = soi_cell_x(8); w->players[1].y = soi_cell_y(9);
        w->players[1].bonus_time = 1500;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "colorkey: exited through the opened door");
        CHECK(soi_level_complete(w) == 1, "colorkey: key + opened-door exit -> complete");
        CHECK(w->players[1].score == 1500 && w->players[1].bonus_time == 0,
              "colorkey: remaining bonus added to score on exit");
    }

    /* ---- 11c. Score multiplier goody (0x0C-0x0F = 2x/3x/4x/5x, asm FUN_10011428):
     * SETS the player's multiplier (default 1), which multiplies the end-of-level
     * BONUS awarded at the door (mult x bonus_timer; FUN_10029264 tallies +0x44 * +0x40).
     * Coins are NOT multiplied. Multipliers appear on 20+ boards (e.g. board_1001). */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        CHECK(w->players[1].mult == 1, "mult: default multiplier is 1");
        soi_set_cell(w, 4, 9, 0x090Du);                 /* 3x multiplier goody on the player cell */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].mult == 3, "mult: 0x0D goody sets the 3x multiplier");
        CHECK(soi_get_cell(w, 4, 9) == SOI_CELL_EMPTY, "mult: multiplier goody is consumed");
        /* win: key + door with a remaining bonus -> bonus x 3 into score */
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "mult: key collected");
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        w->players[1].score = 0;
        w->players[1].bonus_time = 1000;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "mult: exited the door");
        CHECK(w->players[1].score == 3000 && w->players[1].bonus_time == 0,
              "mult: end-of-level bonus is multiplied (1000 x 3 = 3000)");
    }

    /* ---- 11d. PER-PLAYER bonus award: at board completion EVERY active player is
     * awarded their OWN remaining bonus x mult -- not just the door-exiter. The original
     * runs the per-player tally FUN_10015714 for each player (FUN_100153d0), each on their
     * own @0x1003a9f0 x @f4. This guards the old shared-timer/exiter-only model. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        reset_player(w, 2, 6, 9);
        w->players[1].bonus_time = 1000; w->players[1].mult = 2;
        w->players[2].bonus_time = 700;  w->players[2].mult = 1;
        /* P1 grabs the key, then exits the door -> board complete for everyone */
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "perplayer: P1 collected the key");
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        soi_pickup_check(w, 1);
        CHECK(soi_level_complete(w) == 1, "perplayer: P1 exit completes the board");
        CHECK(w->players[1].score == 2000, "perplayer: exiter P1 awarded 1000 x 2 = 2000");
        CHECK(w->players[2].score == 700,  "perplayer: NON-exiter P2 still awarded 700 x 1 = 700");
        CHECK(w->players[1].bonus_time == 0 && w->players[2].bonus_time == 0,
              "perplayer: both players' bonuses zeroed at completion");
    }

    /* ---- 11e. Board->board persistence (soi_next_level): score / lives / ammo / shield
     * CARRY across boards (new-game-only reset, FUN_1002b060), while mult + has_key + the
     * board state RESET for the incoming board (per-level reset FUN_1002b174 + loader). */
    {
        uint8_t bord[64];
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 3; bord[0x09] = 9;                 /* P1 col 3 row 9 */
        bord[0x0B] = 9; bord[0x0D] = 9;                 /* P2 */
        bord[0x0E] = 0x13; bord[0x0F] = 0x88;           /* Bonus (BORD 0x0E) = 5000 */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        /* simulate a played board: banked score, a spent life, used ammo, mult + key held */
        w->players[1].score = 12345; w->players[1].lives = 2;
        w->players[1].arrows = 5; w->players[1].balls = 3; w->players[1].shield = 4;
        w->players[1].mult = 4; w->players[1].has_key = 2;
        soi_next_level(w, bord, sizeof(bord));          /* advance to the next board */
        CHECK(w->players[1].score == 12345, "nextlevel: SCORE persists across boards");
        CHECK(w->players[1].lives == 2, "nextlevel: LIVES persist across boards");
        CHECK(w->players[1].arrows == 5 && w->players[1].balls == 3 && w->players[1].shield == 4,
              "nextlevel: ammo + shield persist across boards");
        CHECK(w->players[1].mult == 1, "nextlevel: multiplier RESETS each board (FUN_1002b174)");
        CHECK(w->players[1].has_key == 0, "nextlevel: has_key RESETS (board not instantly complete)");
        CHECK(soi_level_complete(w) == 0, "nextlevel: the incoming board is not already complete");
        CHECK(w->players[1].bonus_time == 5000, "nextlevel: bonus reseeded from the new board");
    }

    /* ---- 11f. NO-WEAPONS REWARD (BORD 0x16 -> asm FUN_1002b448 init / FUN_10010d30 +
     * FUN_100110b4 zero-on-fire / FUN_10015714 award): each board grants a 5000 reward,
     * added ONCE to the score at completion UNLESS the player fired a ball/arrow this
     * board. VERIFIED vs the original gameplay video (the tally reads "No Weapons Reward
     * 5000" every board; the port's score was too low by 5000/board before this fix). ---- */
    {
        /* (a) completing WITHOUT firing adds the reward on top of the bonus */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        w->players[1].no_weapons_reward = 5000;         /* as the loader seeds it */
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);
        soi_pickup_check(w, 1);
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        w->players[1].score = 0; w->players[1].bonus_time = 1000; w->players[1].mult = 1;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].score == 6000,
              "noweap: no fire -> bonus (1000) + No-Weapons Reward (5000) = 6000");

        /* (b) firing a weapon this board forfeits the reward */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        w->players[1].no_weapons_reward = 5000;
        w->players[1].arrows = 1; w->players[1].fire_cd = 0; w->players[1].facing = 1;
        soi_projectile_fire(w, 1);
        CHECK(w->players[1].no_weapons_reward == 0,
              "noweap: firing an arrow zeroes the No-Weapons Reward");
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);
        soi_pickup_check(w, 1);
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        w->players[1].score = 0; w->players[1].bonus_time = 1000; w->players[1].mult = 1;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].score == 1000,
              "noweap: after firing, completion awards only the bonus (no 5000 reward)");
    }

    /* ---- 12. The player's Magic Arrow RICOCHETS off a solid block (asm     * FUN_1000fd5c +0x54==2/3): it turns 90 deg and keeps flying rather than
     * smashing the block. Contrast the Ball (stops) and hostile shots (smash). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x201);                       /* destructible block directly ahead */
    soi_tick(w, SOI_IN_ARROW, 0);                       /* fire -> travels right */
    {
        int t;
        for (t = 0; t < 20; t++) soi_tick(w, 0, 0);     /* it reaches + deflects off the block */
    }
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) != SOI_CELL_EMPTY,
          "arrow: ricochets off a block WITHOUT smashing it");
    CHECK(soi_projectile_count(w) == 1,
          "arrow: keeps flying after the deflect (does not despawn on the block)");

    /* 12d. A ricochet arrow that reaches a wall at FLOOR level must climb (turn
     * up), not get trapped in the corner. Regression: the deflect probe must test
     * the ADJACENT cell, not a bare +/-2px that stays in the arrow's own row and
     * wrongly reads "down" (into the floor) as clear. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 11);
    ground_player(w, 6, 11);                                             /* player stands (own row) */
    { int c; for (c = 1; c <= 9; c++) soi_set_cell(w, c, 12, 0x300u); }  /* solid floor below the arrow */
    soi_set_cell(w, 3, 11, 0x300u); soi_set_cell(w, 3, 10, 0x300u);      /* wall to the left */
    w->players[1].arrows = 1; w->players[1].facing = -1;                 /* face left */
    soi_tick(w, SOI_IN_ARROW, 0);                                        /* fire left */
    {
        int y0 = w->projectiles[0].y, t;
        for (t = 0; t < 60 && soi_projectile_count(w) == 1; t++) soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) == 1, "arrow: survives the floor-corner deflect (not trapped)");
        CHECK(w->projectiles[0].y < y0, "arrow: climbs up the wall at a floor corner");
    }

    /* ---- 12b. A destructible block that hides a PAYLOAD goody (BORD stores the
     * concealed goody in the high 16 bits with bit 0x1000; 326 such cells exist
     * across the real boards) reveals that goody when smashed, and the revealed
     * goody is then collectible. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x09121291u);                 /* supportive block hiding a Magic Ball goody 0x0912 */
    /* The player Arrow now ricochets (no smash); the smash+reveal path is driven
     * by a HOSTILE shot (Cannon/UltraBuster), which DOES smash the player's blocks. */
    w->projectiles[0].active = 1; w->projectiles[0].hostile = 1; w->projectiles[0].kind = 0;
    w->projectiles[0].owner = 0; w->projectiles[0].age = 0;
    w->projectiles[0].x = soi_cell_x(4); w->projectiles[0].y = soi_cell_y(9);
    w->projectiles[0].vx = 8; w->projectiles[0].vy = 0;
    {
        int t;
        for (t = 0; t < 12 && (soi_get_cell(w, 5, 9) & SOI_CELL_SUPPORTIVE); t++)
            soi_projectiles_update(w);
    }
    CHECK(soi_get_cell(w, 5, 9) == 0x0912u,
          "payload: smashing a special block reveals its concealed goody");
    {
        int b0 = w->players[1].balls;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(9);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == b0 + 1, "payload: the revealed goody is collectible");
    }
    /* A type-0 payload cell (0x1000, e.g. 0x090A1000) is a hidden goody that the
     * original does NOT collect on walk-over (pickup gates on low-byte != 0);
     * it stays put until a reveal trigger. Confirm we faithfully leave it alone. */
    reset_player(w, 1, 7, 9);
    soi_set_cell(w, 7, 9, 0x090A1000u);
    {
        int sc0 = w->players[1].score;
        soi_pickup_check(w, 1);
        CHECK(soi_get_cell(w, 7, 9) == 0x090A1000u && w->players[1].score == sc0,
              "payload: a hidden type-0 payload cell is not collected on walk-over");
    }

    /* ---- 12c. Building a block on a type-0 hidden-payload cell makes the new
     * block INHERIT the payload (asm FUN_1002d04c); breaking it then reveals the
     * goody (12b), so the 218 low-byte-0 payload cells become obtainable. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].facing = 1;                       /* face right */
    w->players[1].block_type = 0x19;
    { /* blanket the front / front-below cells with hidden coins; the block-low
       * verb builds on one and that block must inherit the payload. */
        int c, r, found = 0;
        for (c = 6; c <= 7; c++) for (r = 8; r <= 12; r++) soi_set_cell(w, c, r, 0x090A1000u);
        soi_tick(w, SOI_IN_BLOCK_LOW, 0);           /* build a block in front-below */
        for (c = 6; c <= 7; c++) for (r = 8; r <= 12; r++)
            if (soi_get_cell(w, c, r) == 0x090A1219u) found = 1;   /* built block = blue 0x19 + payload */
        CHECK(found, "payload: a block built on a hidden-payload cell inherits the goody");
    }

    /* ---- 13. Shoes/Turtles goody (0x31) tames every real nasty: each is
     * defeated for the collecting player on the next enemies update, awarding
     * its points (FUN_1000543c marks enemy +0x88; the nasty self-destructs). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 8, 9);            /* Ant = 50 pts */
    {
        int score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0x31);                    /* shoes/turtles on the player cell */
        soi_pickup_check(w, 1);
        CHECK(w->enemies[0].claimed == 1, "shoes: every nasty is claimed by the collector");
        CHECK(soi_get_cell(w, 5, 9) == SOI_CELL_EMPTY, "shoes: the goody is consumed");
        soi_enemies_update(w);
        CHECK(soi_enemy_active(w, 0) == 0, "shoes: a claimed nasty is defeated next update");
        CHECK(w->players[1].score == score0 + 50, "shoes: its points go to the collector");
    }

    /* ---- 14. A Cannon periodically fires a hostile projectile that flies in its
     * facing, and the shot hits the player on contact (asm FUN_100071a0 spawns a
     * flying 0x65). Friendly arrows kill nasties; hostile shots damage players. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 9);                          /* player to the cannon's right */
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CANNON, 3, 9);
        int lives0, fired = 0, hit = 0, t;
        CHECK(ci >= 0, "cannon: spawned");
        w->enemies[ci].dir = 2;                        /* face right, toward the player */
        w->enemies[ci].fire_cd = 0;                    /* fire on the next update */
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);   /* floor so the cannon stands */
        soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE);   /* floor under the player */
        lives0 = w->players[1].lives;
        for (t = 0; t < 40; t++) {
            soi_enemies_update(w);
            soi_projectiles_update(w);
            if (soi_projectile_count(w) > 0) fired = 1;
            if (w->players[1].lives < lives0 || !soi_player_alive(w, 1) ||
                w->players[1].ground_state == SOI_ST_DEAD) { hit = 1; break; }
        }
        CHECK(fired, "cannon: fired a hostile projectile");
        CHECK(hit, "cannon: the shot hits the player");
    }

    /* ---- 14b. The Cannon's fire cadence is read from the spawn-block delay bytes
     * (b0 StartDelay -> reload*6, b1 SpawnDelay -> initial*6; FUN_1002d980). A
     * synthetic BORD with a cannon block (b0=40,b1=20) yields reload 240 / init 120. */
    {
        uint8_t bord[64];
        int e, found = -1;
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 5; bord[0x09] = 9;                 /* p1 start (col,row), be16 low bytes */
        bord[0x18] = 0x28; bord[0x19] = 0x14;           /* b0=40 (StartDelay), b1=20 (SpawnDelay) */
        bord[0x1A] = 0x05; bord[0x1B] = 0x01;           /* dir-tag 0x05 (spawn+left), type 1 = Cannon */
        bord[0x1C] = 8; bord[0x1D] = 9;                 /* place the cannon at (8,9) */
        bord[0x1E] = 100; bord[0x1F] = 100;             /* record sentinel */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_CANNON) { found = e; break; }
        CHECK(found >= 0, "cannon-cadence: a cannon spawned from the BORD block");
        CHECK(found >= 0 && w->enemies[found].fire_period == 240,
              "cannon-cadence: reload = StartDelay(40) * 6 = 240");
        CHECK(found >= 0 && w->enemies[found].fire_cd == 120,
              "cannon-cadence: initial = SpawnDelay(20) * 6 = 120");
    }

    /* ---- 14c. Gargoyle (16) and Knight (17) are STATIONARY turrets, not walkers
     * (verified: FUN_10008618/FUN_10008b18 never write their own +0x58/+0x5a).
     * Our port previously gave them walking speed; they must hold their ground. */
    {
        int gi, ki, gx0, kx0, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 5, 9);
        ki = soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 10, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);    /* floor so the turrets stand */
        soi_set_cell(w, 10, 10, SOI_CELL_SUPPORTIVE);
        gx0 = soi_enemy_x(w, gi); kx0 = soi_enemy_x(w, ki);
        for (t = 0; t < 20; t++) soi_enemies_update(w);
        CHECK(soi_enemy_x(w, gi) == gx0, "turret: the Gargoyle holds its ground (stationary)");
        CHECK(soi_enemy_x(w, ki) == kx0, "turret: the Knight holds its ground (stationary)");
    }

    /* ---- 15. Magic Ball: a distinct weapon (asm fire FUN_100110b4, mover
     * FUN_1000fd5c +0x54==1). It rolls horizontally at a fixed height, kills any
     * nasty it rolls over, and STOPS DEAD at a solid block WITHOUT smashing it
     * (unlike the Arrow). Separate ball ammo (+0x4a, the 0x10 pickup). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 2;
    w->players[1].arrows = 0;
    w->players[1].facing = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);            /* two cells to the right */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);        /* floor so the nasty stands */
    soi_tick(w, SOI_IN_BALL, 0);                        /* fire the ball */
    CHECK(w->players[1].balls == 1, "ball: firing consumed one ball");
    CHECK(soi_projectile_count(w) == 1, "ball: a ball is in flight");
    CHECK(soi_projectile_active(w, 0) == 1 && soi_projectile_kind(w, 0) == 1,
          "ball: the projectile reports kind = Magic Ball");
    {
        int t;
        for (t = 0; t < 24 && soi_enemy_count(w) > 0; t++)
            soi_tick(w, 0, 0);                          /* the ball rolls right */
    }
    CHECK(soi_enemy_count(w) == 0, "ball: the rolling ball killed the nasty");

    /* 15b. The ball stops at a solid block and does NOT smash it (contrast the
     * Arrow, which clears the block in test 12). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x201);                       /* destructible block ahead */
    soi_tick(w, SOI_IN_BALL, 0);
    {
        int t;
        for (t = 0; t < 24 && soi_projectile_count(w) > 0; t++)
            soi_tick(w, 0, 0);
    }
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) != SOI_CELL_EMPTY,
          "ball: a solid block in the path is NOT smashed");
    CHECK(soi_projectile_count(w) == 0, "ball: the ball despawns when it hits the block");

    /* 15c. The 0x12 pickup is Magic Ball ammo (not a life): collecting it bumps
     * the ball count (CONFIRMED FUN_1002bc64 -> FUN_1000ec50 adds +0x4a). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    {
        int b0 = w->players[1].balls;
        soi_set_cell(w, 3, 9, 0x12);                    /* magic-ball goody on the player's cell */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == b0 + 1, "ball: the 0x12 pickup grants ball ammo");
    }

    /* ---- 16. Creeper (bord 16/17) is a self-propelled block-layer, NOT a shooter.
     * Corrects the earlier map that mislabelled 16/17 as Gargoyle/Knight; the real
     * Gargoyle/Knight are bord 14/13 (sssf 1014/1013). Creeper = sssf 1016. ---- */
    CHECK(soi_bord_badguy_type(13) == SOI_ENEMY_KNIGHT,   "map: bord 13 -> Knight");
    CHECK(soi_bord_badguy_type(14) == SOI_ENEMY_GARGOYLE, "map: bord 14 -> Gargoyle");
    CHECK(soi_bord_badguy_type(16) == SOI_ENEMY_CREEPER,  "map: bord 16 -> Creeper (horizontal)");
    CHECK(soi_bord_badguy_type(17) == SOI_ENEMY_CREEPER,  "map: bord 17 -> Creeper (vertical)");

    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CREEPER, 4, 6);   /* mid-board, open cells */
        CHECK(ci >= 0, "creeper: spawned");
        w->enemies[ci].state = 0;          /* 0 = horizontal axis */
        w->enemies[ci].dir   = 2;          /* stepping right */
        w->enemies[ci].fire_period = 1;    /* short step interval for the test */
        w->enemies[ci].fire_cd = 1;
        soi_set_cell(w, 6, 6, 0x197);      /* a background tile in its path (passable, not solid) */
        {
            int t;
            for (t = 0; t < 8; t++) soi_tick(w, 0, 0);
            CHECK(soi_enemy_x(w, ci) >= soi_cell_x(7),
                  "creeper: traverses a background (0x197) tile instead of getting stuck");
            CHECK(soi_projectile_count(w) == 0, "creeper: never fires a projectile");
            /* Moving SOLID block: its cell is solid; the cells it covered are restored
             * -- including the 0x197 background (asm captures +0x70), so nothing erases. */
            CHECK(soi_get_cell(w, 8, 6) & SOI_CELL_SUPPORTIVE,
                  "creeper: temp-solidifies the cell it occupies");
            CHECK(soi_get_cell(w, 6, 6) == 0x197,
                  "creeper: restores the background tile it covered (capture/restore)");
            CHECK((soi_get_cell(w, 4, 6) & SOI_CELL_SUPPORTIVE) == 0,
                  "creeper: restores the cell it left (temporary trail)");
        }
    }

    /* ---- 17. A hostile shot's src_type is LOGICAL state -- a Gargoyle shot
     * despawns at age 14 (soi_enemies.c) -- so the canonical serialize / state
     * hash must include it (else a cross-play desync would slip through). ---- */
    {
        static uint8_t sbuf1[8192], sbuf2[8192];
        size_t n1, n2;
        soi_world_init(w, 1);
        w->projectiles[0].active = 1;
        w->projectiles[0].src_type = SOI_ENEMY_CANNON;
        n1 = soi_serialize(w, sbuf1, sizeof sbuf1);
        w->projectiles[0].src_type = SOI_ENEMY_GARGOYLE;
        n2 = soi_serialize(w, sbuf2, sizeof sbuf2);
        CHECK(n1 == n2 && n1 > 0 && memcmp(sbuf1, sbuf2, n1) != 0,
              "serialize: projectile src_type is part of the state hash");
    }

    /* ---- 18. The level-objective treasure count keys off the GOODIE nibble
     * (0x9xx) / hidden payload, NOT the raw low byte: a BLUE block is type 0x19,
     * colliding with gold-bars, so counting by low byte miscounts a board's blue
     * blocks as treasure (real bug on board_422's maze etc.). ---- */
    {
        soi_world_init(w, 1);
        soi_set_cell(w, 3, 3, 0x90Au);        /* visible silver-coin goodie (treasure) */
        soi_set_cell(w, 4, 3, 0x319u);        /* BLUE block (type 0x19) -- NOT treasure */
        soi_set_cell(w, 5, 3, 0x219u);        /* BLUE block again */
        soi_set_cell(w, 6, 3, 0x090A1207u);   /* white SPECIAL block hiding a silver coin */
        CHECK(soi_count_treasure(w) == 2,
              "objective: counts goodie + hidden treasure, not blue blocks");
    }

    /* ---- 19. Transporter OUT-seeking must skip a solid block that shares the OUT's
     * low byte: a PINK block is type 0x1F, colliding with the 0x1e/0x1f pair -- the
     * scan must land on the walk-on OUT marker, not the (earlier-scanned) block. ---- */
    {
        soi_world_init(w, 1);
        reset_player(w, 1, 5, 5);
        soi_set_cell(w, 2, 2, 0x31Fu);   /* PINK block (0x1F, supportive) -- scanned FIRST */
        soi_set_cell(w, 8, 8, 0x11Fu);   /* the real transporter OUT (0x1F, walk-on) */
        soi_set_cell(w, 5, 5, 0x11Eu);   /* transporter IN (0x1E) under the player */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].x == soi_cell_x(8) && w->players[1].y == soi_cell_y(8),
              "transporter: OUT scan lands on the marker, not a same-low-byte pink block");
    }

    /* ---- 20. soi_set_player_stats (used by Resume + challenge-forfeit) overwrites the
     * persistent stats (score/lives/arrows/balls/shield) but must LEAVE the per-board score
     * multiplier untouched -- Resume restores a board's entry stats and forfeit reverts the
     * score, neither should reset a mult the player is holding. Also bounds-guarded (idx 1.._). ---- */
    {
        soi_world_init(w, 1);
        reset_player(w, 1, 5, 5);
        w->players[1].mult = 4;                    /* a live 4x multiplier that must survive */
        w->players[1].score = 111; w->players[1].lives = 1;
        soi_set_player_stats(w, 1, 12345, 2, 7, 3, 5);
        CHECK(soi_player_score(w, 1) == 12345, "set_stats: score overwritten");
        CHECK(w->players[1].lives  == 2, "set_stats: lives overwritten");
        CHECK(w->players[1].arrows == 7, "set_stats: arrows overwritten");
        CHECK(w->players[1].balls  == 3, "set_stats: balls overwritten");
        CHECK(w->players[1].shield == 5, "set_stats: shield overwritten");
        CHECK(w->players[1].mult   == 4, "set_stats: score multiplier is PRESERVED (not reset)");
        /* bounds guard: idx 0 (unused slot) and idx >= SOI_MAX_PLAYERS are no-ops. */
        w->players[0].score = 0;
        soi_set_player_stats(w, 0, 999, 9, 9, 9, 9);                 /* idx 0 -> ignored */
        soi_set_player_stats(w, SOI_MAX_PLAYERS, 999, 9, 9, 9, 9);   /* idx OOB-high -> ignored */
        CHECK(w->players[0].score == 0, "set_stats: idx 0 is a guarded no-op");
        CHECK(soi_player_score(w, 1) == 12345, "set_stats: OOB-high idx leaves valid players intact");
    }

    /* ---- 21. RNG: validate the Park-Miller minimal-standard LCG (the Mac Toolbox Random()
     * core) against its canonical published checkpoint -- from seed 1, the 10000th iterate is
     * 1043618065 (Park & Miller, CACM 1988; re-verified with an independent 64-bit direct
     * multiply). This proves our overflow-safe Schrage's-method LCG reproduces the authoritative
     * stream exactly -- a regression guard on the generator behind every spawn/dispatch draw. ---- */
    {
        int k;
        soi_rng_seed(w, 1);
        CHECK(w->rng_seed == 1u, "rng: seeds to 1 (Toolbox default)");
        for (k = 0; k < 10000; k++) soi_rng_next(w);
        CHECK(w->rng_seed == 1043618065u, "rng: Park-Miller 10000th-iterate checkpoint (1043618065)");
    }

    /* ---- 22. Walker (bord 4) FIRES a horizontal bolt when a live player shares its
     * ROW -- asm FUN_1000dd4c via FUN_1000e5c8/e7c8 (player Y within 0x20 of the
     * Walker's Y). Off-row -> no shot. This is the Walker's confirmed SEEK+SHOOT that
     * the port was missing (it used to only patrol). ---- */
    {
        int wi, k, before, hostile;
        /* (a) player on the Walker's row -> a hostile bolt spawns */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 3, 6);
        for (k = 0; k < SOI_GRID_COLS; k++) soi_set_cell(w, k, 7, SOI_CELL_SUPPORTIVE);
        wi = soi_enemy_spawn(w, SOI_ENEMY_WALKER, 10, 6);
        CHECK(wi >= 0, "walker: spawned");
        w->enemies[wi].dir = 1; w->enemies[wi].vx = -3; w->enemies[wi].fire_cd = 0;
        before = soi_projectile_count(w);
        soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) > before, "walker: fires a bolt when a player shares its row");
        hostile = 0;
        for (k = 0; k < SOI_MAX_PROJECTILES; k++)
            if (w->projectiles[k].active && w->projectiles[k].hostile) hostile = 1;
        CHECK(hostile, "walker: the fired bolt is hostile");
        /* the bolt travels 4 px/frame (asm 0x68 mover FUN_1000e3c0: +0x10 +/- 4), not 8.
         * Player is LEFT of the walker, so the bolt flies left at -4 px/tick. */
        {
            int bi = -1, x1, x2;
            for (k = 0; k < SOI_MAX_PROJECTILES; k++)
                if (w->projectiles[k].active && w->projectiles[k].hostile) { bi = k; break; }
            CHECK(bi >= 0, "walker: bolt slot found");
            x1 = w->projectiles[bi].x;
            soi_tick(w, 0, 0);
            x2 = w->projectiles[bi].x;
            CHECK(x2 - x1 == -4, "walker: the bolt travels 4 px/frame, not 8");
        }
        /* (b) player on a DIFFERENT row -> no shot */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 3, 2);
        for (k = 0; k < SOI_GRID_COLS; k++) soi_set_cell(w, k, 7, SOI_CELL_SUPPORTIVE);
        wi = soi_enemy_spawn(w, SOI_ENEMY_WALKER, 10, 6);
        w->enemies[wi].dir = 1; w->enemies[wi].vx = -3; w->enemies[wi].fire_cd = 0;
        before = soi_projectile_count(w);
        soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) == before, "walker: does NOT fire when no player shares its row");
    }

    /* ---- 23. Hippo/Piggy/Smiley/Teeth PLOW THROUGH breakable blocks (asm FUN_100279c4
     * in FUN_100081f8/9a78/d130/d8c4): they clear a destructible block ahead and walk
     * on, while a plain Ant TURNS at the same wall. ---- */
    {
        int wi, k;
        /* (a) Hippo clears a breakable block ahead and keeps its direction */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        for (k = 0; k < SOI_GRID_COLS; k++) soi_set_cell(w, k, 7, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 6, 0x207u);                    /* breakable block (type 7 + SUPPORTIVE) */
        wi = soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 4, 6);
        CHECK(wi >= 0, "hippo: spawned");
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 3;    /* moving right toward the block */
        for (k = 0; k < 40; k++) soi_tick(w, 0, 0);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 6)) == 0, "hippo: destroys the breakable block in its path");
        CHECK(w->enemies[wi].dir == 2, "hippo: keeps walking through (did not turn at the block)");
        /* (b) an Ant TURNS at the same breakable block (does not destroy it) */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        for (k = 0; k < SOI_GRID_COLS; k++) soi_set_cell(w, k, 7, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 6, 0x207u);
        wi = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 6);
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 2;
        for (k = 0; k < 40; k++) soi_tick(w, 0, 0);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 6)) != 0, "ant: leaves the breakable block intact");
        CHECK(w->enemies[wi].dir == 1, "ant: turns around at the breakable block");
    }

    /* ---- 24. Procedural badguy throw GATES on valid params. The 4 "DATA:" boards
     * (301/428/446/498) carry the ASCII marker "DATA: " in header bytes 0x10-0x14 ->
     * pct_badguy=21569 / thrown_badguy=17473 = GARBAGE, which used to spawn a spurious
     * ANT (fallback) every 120 frames. A percentage is <=100 and the type must be a
     * real nasty, else nothing is thrown (no ANT fallback). ---- */
    {
        int k, found = -1;
        soi_world_init(w, 1);
        w->level_loaded = 1;
        w->pct_badguy = 21569; w->thrown_badguy = 17473;   /* the "DATA:" garbage */
        w->tick = 119;                                     /* next tick lands on %120==0 */
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_count(w) == 0, "procspawn: garbage params (pct>100 / bad type) throw nothing");
        soi_world_init(w, 1);
        w->level_loaded = 1;
        w->pct_badguy = 100; w->thrown_badguy = (int16_t)SOI_ENEMY_TEETH;   /* valid: always passes */
        w->tick = 119;
        soi_tick(w, 0, 0);
        for (k = 0; k < SOI_MAX_ENEMIES; k++) if (w->enemies[k].active) { found = k; break; }
        CHECK(soi_enemy_count(w) == 1 && found >= 0 && w->enemies[found].type == SOI_ENEMY_TEETH,
              "procspawn: valid params throw the configured badguy (no ANT fallback)");
    }

    /* ---- 25. Enemy touch is an AABB HURTBOX overlap, not coarse grid-cell equality
     * (asm FUN_100299b4 player box [x+0xd,x+0x12]x[y+4,y+0x1d] vs enemy box
     * [x+9,x+0x19]x[y+6,y+0x1e], FUN_100030d4 overlap). The old code killed the player
     * whenever an enemy merely shared his grid CELL -- so a Robo FALLING through the
     * player's column briefly "occupied" his cell (bottom-of-cell) and killed him even
     * though the sprites never touched (the user's "he killed me while falling even
     * though I was on another block"). A falling enemy in the SAME cell but a row-lower
     * hurtbox must now pass by harmlessly. ---- */
    {
        int ei;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        ground_player(w, 5, 9);
        ei = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        /* Drop the Robo's hurtbox to the bottom of the shared cell. It starts at
         * cell_y(9)+24, but enemy_step's fall (+4 px/frame -- there is no floor at row 10)
         * runs BEFORE the contact check, so at the check its box top is cell_y(9)+34: a 5px
         * gap BELOW the player box bottom (cell_y(9)+0x1d = +29), widening every tick as it
         * sinks. Its top-left still reads grid row 9 (a coarse cell-equality test WOULD fire),
         * yet the two inset AABBs never overlap -- so the pass-by is safe across the tick. */
        w->enemies[ei].y = soi_cell_y(9) + 24;
        soi_tick(w, 0, 0);
        CHECK(w->players[1].ground_state != SOI_ST_DEAD && soi_player_alive(w, 1),
              "collision: a falling enemy sharing the player's grid CELL but not his "
              "hurtbox does NOT kill (asm AABB, not cell-equality)");
    }

    /* ---- 25b. The Robo's fall check uses INSET feet (asm FUN_10005750 probes x+6 and
     * x+0x1a -- a ~20px stance inside the 32px tile), not the full-cell edges (x+0/x+31).
     * With the old wide probe a Robo hanging over a gap still "caught" the next block with
     * a corner pixel, so you had to shove it almost fully off the ledge before it dropped
     * (the user's "has to be right on the opposite edge"). Inset feet drop it as soon as
     * its stance clears the block -- more lenient. Here the Robo's inset feet are over a
     * GAP while its far corner (x+31) still overlaps the next floor block: the old wide
     * probe would hold it up, the inset probe drops it. ---- */
    {
        int ri, t, fell = 0, y0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 9);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);      /* floor only under the NEXT cell */
        soi_set_cell(w, 5, 12, SOI_CELL_SUPPORTIVE);      /* a lower catch floor to land on (in-bounds: rows 0..12) */
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        w->enemies[ri].vx = 0;
        w->enemies[ri].x = soi_cell_x(5) + 2;             /* inset feet (x+6..x+26) over the col-5
                                                           * gap; far corner (x+31) catches col-6 */
        y0 = w->enemies[ri].y;
        for (t = 0; t < 40 && !fell; t++) {
            soi_enemies_update(w);
            if (w->enemies[ri].y > y0) fell = 1;
        }
        CHECK(fell,
              "breakunder: a Robo whose INSET feet clear the block drops even while a far "
              "corner still overlaps the next block (lenient inset-foot probe, asm FUN_10005750)");
    }

    /* ---- 25c. Walk-over pickup runs EVERY player tick (asm FUN_1002a308 calls the goody
     * check for each live player unconditionally), so a coin is grabbed the instant the
     * body overlaps its cell -- even standing still. The old port only ran the check inside
     * run_step, so an IDLE player parked on a coin never took it (the user's "have to be
     * right on top of coin"). Pickup runs at the TOP of the player update (before the fall
     * branch), so a stationary player collects on a plain no-input tick. ---- */
    {
        int score0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        /* GROUND the player for real: a supportive floor one row BELOW plus a small
         * pixel drop so the support probe (y+0x1f) reads the floor at row 10 while the
         * pickup probe (y+0x10) still reads the coin at row 9. (A grid-aligned player
         * shares one cell for both probes, and a SUPPORTIVE cell can't also hold a
         * collectible, so the two must be separated -- otherwise the player just falls.) */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);      /* the floor the player stands ON */
        w->players[1].y = soi_cell_y(9) + 4;   /* support probe -> row 10, pickup probe -> row 9 (x,y are int32_t) */
        score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0x0A);                      /* silver coin on the body cell (non-supportive) */
        soi_tick(w, 0, 0);                                /* NO input -> the player stands idle */
        CHECK(w->players[1].ground_state == SOI_ST_IDLE,
              "coinpickup: the player stands idle on the pickup tick (grounded, no direction)");
        CHECK(w->players[1].score > score0,
              "coinpickup: an IDLE grounded player standing on a coin collects it (pickup every tick, asm FUN_1002a308)");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) == 0,
              "coinpickup: the collected coin cell is cleared");
    }

    /* ---- 26. The build/fire arm-swing FREEZES horizontal movement. The asm gates the
     * whole run/idle dispatch on the action-active flag (FUN_1001166c +0x25), so run is
     * frozen for the ~12-frame pose. Holding a direction while repeatedly firing used to
     * slide ("glide") the player across the floor; he must now stutter to a stop until
     * the swing ends, then run again. (Fire, not build, so no block walls the run.) ---- */
    {
        int x0, t, moved_during_pose = 0, ran_during_pose = 0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        ground_player(w, 5, 9);
        w->players[1].facing = 1; w->players[1].arrows = 5;
        soi_tick(w, SOI_IN_ARROW, 0);               /* fire -> action pose starts (pose_t=12) */
        CHECK(w->players[1].pose_t > 0, "glide: firing a weapon starts the action pose");
        x0 = w->players[1].x;
        for (t = 0; t < 5; t++) {                   /* hold RIGHT while the pose still swings */
            soi_tick(w, SOI_IN_RIGHT, 0);
            if (w->players[1].x != x0) moved_during_pose = 1;
            if (w->players[1].ground_state == SOI_ST_RUN) ran_during_pose = 1;
        }
        CHECK(!moved_during_pose,
              "glide: holding a direction during the action pose does NOT advance x (no glide)");
        CHECK(!ran_during_pose,
              "glide: the run DISPATCH is frozen during the pose (stutter-stop, not just x-clamped)");
        for (t = 0; t < 12; t++) soi_tick(w, 0, 0); /* let the pose fully drain */
        CHECK(w->players[1].pose_t == 0, "glide: the action pose drains after ~12 frames");
        soi_tick(w, SOI_IN_RIGHT, 0);
        CHECK(w->players[1].ground_state == SOI_ST_RUN,
              "glide: once the pose ends, holding a direction runs the player again");
    }

    /* ---- 27. A Bonus-timer runout kills with the SAME death as an enemy hit: the
     * airborne death-throw (SOI_ST_DEAD) + the hit cry (asm FUN_1000f500 routes a
     * timed-out player through FUN_10012228 == soi_player_hit). The old code silently
     * set alive=0 -- no animation, no sound, a mute "RESPAWNING" pop. ---- */
    {
        int k, cried = 0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        ground_player(w, 5, 9);
        w->players[1].invuln = 0;
        w->players[1].bonus_time = 1;               /* one decrement from expiry */
        w->bonus_div = 1;                           /* force the ~20Hz bonus tick next frame */
        soi_tick(w, 0, 0);                          /* bonus 1 -> 0 -> fatal */
        CHECK(w->players[1].ground_state == SOI_ST_DEAD,
              "timerdeath: a bonus runout plays the death-throw (SOI_ST_DEAD), not a silent alive=0");
        for (k = 0; k < soi_sfx_count(w); k++)
            if (soi_sfx_get(w, k) == SOI_SFX_PLAYER_HIT) cried = 1;
        CHECK(cried, "timerdeath: a bonus runout plays the player hit cry (SOI_SFX_PLAYER_HIT)");
    }

    /* ---- 28. A Knight gift flies STRAIGHT to its drop cell (asm FUN_1000c544 adds a
     * sqrt-normalized velocity each frame). The port holds the flight on the exact
     * launch->target line, interpolating the minor axis from the launch point it stashed in
     * pr->vx/pr->vy. Uses a SHALLOW 528:32 delta -- the exact case the earlier "step both axes
     * by d*6/amax" mover broke: the minor step 32*6/528 truncated to 0, so the gift ran flat
     * and bowed ~19px (> half a tile) off the launch line before snapping at the very end.
     * Asserts the perpendicular deviation stays <= 4px (1/8 tile) for EVERY frame, via an
     * integer cross-product (no float). ---- */
    {
        int tcol = 17, trow = 6;
        int tx = soi_cell_x(tcol), ty = soi_cell_y(trow);
        int X0 = tx - 528, Y0 = ty - 32;            /* shallow 528:32 launch delta (minor axis truncates) */
        long long vx = (long long)(tx - X0), vy = (long long)(ty - Y0);
        long long L2 = vx * vx + vy * vy;           /* squared line length */
        long long worst2 = 0;                       /* max (cross)^2 seen in flight */
        SoiProjectile *pr;
        int k;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        pr = &w->projectiles[0];
        memset(pr, 0, sizeof(*pr));
        pr->active = 1; pr->kind = 2; pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT;
        pr->tcol = (int16_t)tcol; pr->trow = (int16_t)trow;
        pr->gtype = 0x0A; pr->x = X0; pr->y = Y0;
        pr->vx = (int16_t)X0; pr->vy = (int16_t)Y0;   /* the gift remembers its launch point */
        for (k = 1; k <= 150 && pr->active; k++) {
            long long cross;
            soi_projectiles_update(w);
            /* perpendicular distance to the launch->target line = |cross| / |v|;
             * compare squared so it stays exact integer math: dist <= 4  <=>  cross^2 <= 16*L2 */
            cross = vx * (long long)(pr->y - Y0) - vy * (long long)(pr->x - X0);
            if (cross * cross > worst2) worst2 = cross * cross;
        }
        CHECK(pr->active == 0, "gift: the gift reaches its drop cell and lands");
        CHECK(worst2 <= 16 * L2,
              "gift: a Knight gift holds a straight heading on a SHALLOW shot -- stays within "
              "1/8 tile of the launch->target line every frame (no mid-flight bow; asm FUN_1000c544)");
    }

    /* ---- 29. A player in the DEATH-THROW collects NOTHING. The asm gates the goody
     * check FUN_1002bc64 on the dying flag (+0x1003a9d8 == 0, i.e. NOT mid-death), so a
     * somersaulting dead player whose pickup point sweeps over coins/keys grabs none of
     * them (and cannot door-win while dead). soi_pickup_check runs at the TOP of the
     * player update, so it must be skipped while ground_state == SOI_ST_DEAD -- note
     * `alive` stays 1 for the whole throw (it clears only when the arc commits the life
     * loss), so the guard has to key off SOI_ST_DEAD, not alive. ---- */
    {
        int score0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        soi_player_hit(w, 1);                             /* enter the death-throw: DEAD, in_air, alive still 1 */
        score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0x0A);                      /* a silver coin under the (launch) pickup cell */
        soi_player_update(w, 1);                          /* one dying-animation frame */
        CHECK(w->players[1].ground_state == SOI_ST_DEAD,
              "deathpickup: the player is still mid death-throw on this tick");
        CHECK(w->players[1].score == score0,
              "deathpickup: a dying player collects NO coins (asm gates pickup on the dying flag)");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) == 0x0A,
              "deathpickup: the coin under a dying player is left in place");
    }

    /* ---- 29b. Walk-over pickup fires while AIRBORNE too. The asm goody check runs on
     * every LIVE player tick regardless of motion state (only the dying flag gates it),
     * so a player whose body sweeps a coin mid-JUMP grabs it -- not just while grounded.
     * The pickup runs at the TOP of the update, before the in_air branch, so a jumping
     * player over a coin cell collects on the same frame. (Guards the move-to-top pickup
     * change: it must reach airborne players, but NOT dead ones -- see 29.) ---- */
    {
        int score0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        w->players[1].in_air = 1;
        w->players[1].ground_state = SOI_ST_JUMP;         /* mid-jump, not grounded */
        score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0x0A);                      /* silver coin on the body cell */
        soi_player_update(w, 1);                          /* one airborne frame */
        CHECK(w->players[1].score > score0,
              "airpickup: a JUMPING player sweeping a coin collects it (pickup every tick, not ground-only)");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) == 0,
              "airpickup: the collected coin cell is cleared");
    }

    /* ---- 30. A bonus-timeout death is NOT dodgeable with i-frames. Enemy contact is
     * gated by invuln (spawn grace / potion), but the timer is not: asm FUN_1000f500
     * calls the death launcher FUN_10012228 directly, with NO invuln check. So a player
     * who lets the clock hit 0 while still invulnerable STILL dies -- you cannot cheese
     * the timer by timing the runout to land inside your grace window. Routing the
     * timeout through soi_player_hit must therefore clear invuln first. ---- */
    {
        int k, cried = 0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        ground_player(w, 5, 9);
        w->players[1].invuln = 90;                        /* fresh spawn grace / potion i-frames */
        w->players[1].bonus_time = 1;                     /* one decrement from expiry */
        w->bonus_div = 1;                                 /* force the bonus tick next frame */
        soi_tick(w, 0, 0);                                /* bonus 1 -> 0 while invulnerable */
        CHECK(w->players[1].ground_state == SOI_ST_DEAD,
              "timerdeath-iframes: a bonus runout kills even an INVULNERABLE player (asm FUN_10012228, no invuln gate)");
        for (k = 0; k < soi_sfx_count(w); k++)
            if (soi_sfx_get(w, k) == SOI_SFX_PLAYER_HIT) cried = 1;
        CHECK(cried, "timerdeath-iframes: the death cry still plays");
    }

    /* ---- 30b. The shared "hurry up" music tempo (soi_music_hurry). The original speeds the
     * ONE background QuickTime-Music movie to 1.25x while ANY player's Bonus is in the low
     * (0,1000] zone and restores 1.0x otherwise (asm FUN_10018b24 / FUN_10018ac4). We mirror
     * that as a read-only predicate. This locks the multiplayer regression the blind review
     * flagged: a P1-only reset (`bonus_time() > 1000`) cancelled a hurry that a P2/P3 timer
     * had triggered, because bonus_time() reports P1 only. ---- */
    {
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        reset_player(w, 2, 6, 9);
        w->players[1].bonus_time = 3000; w->players[2].bonus_time = 3000;
        CHECK(soi_music_hurry(w) == 0, "hurry-music: OFF when every player's Bonus is above 1000");
        w->players[1].bonus_time = 1000;
        CHECK(soi_music_hurry(w) == 1, "hurry-music: ON the moment a Bonus reaches 1000 (zone is 0 < t <= 1000)");
        w->players[1].bonus_time = 1;
        CHECK(soi_music_hurry(w) == 1, "hurry-music: stays ON as the Bonus drains toward 0");
        w->players[1].bonus_time = 0;
        CHECK(soi_music_hurry(w) == 0, "hurry-music: a fully-drained (dead) player does not count (>0 guard)");
        /* The regression itself: ONLY the non-P1 player is hurrying. */
        w->players[1].bonus_time = 3000; w->players[2].bonus_time = 800;
        CHECK(soi_music_hurry(w) == 1, "hurry-music: ON when ONLY a non-P1 player is in the zone (per-player timers, shared movie)");
        w->players[2].eliminated = 1;
        CHECK(soi_music_hurry(w) == 0, "hurry-music: an eliminated player in the zone does NOT hold it ON");
    }

    /* ---- 31. A Gargoyle's puff spawns in its OWN tile, not one cell toward the aim.
     * The caged board_410 Gargoyle sits with a wall directly in its aim direction; the
     * old "e->x + sx*0x20" muzzle launched the puff straight into that wall, where the
     * projectile wall-check killed it on tick 1 and it never appeared ("Gargoyle doesn't
     * shoot out the dangerous projectile"). Spawning at the Gargoyle's own cell (asm
     * FUN_1000adc4 muzzle inside the tile) keeps the puff visible; regressing the muzzle
     * back one cell would move the spawn cell onto the wall. ---- */
    {
        int gi, i, gh = -1;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 9);                         /* player to the right -> aims rightward */
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 3, 9);
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);      /* floor so it stands */
        soi_set_cell(w, 4, 9, SOI_CELL_PERMANENT | SOI_CELL_SUPPORTIVE);  /* a SOLID cage wall one cell toward the aim */
        w->enemies[gi].fire_cd = 0;
        soi_enemies_update(w);
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].hostile) { gh = i; break; }
        CHECK(gh >= 0 && (w->projectiles[gh].x - SOI_ORIGIN_X) / SOI_CELL_PX == 3,
              "gargoyle-muzzle: the puff spawns in the Gargoyle's OWN cell (col 3), not the wall cell (col 4)");
        soi_projectiles_update(w);                        /* advance one frame past the wall boundary */
        CHECK(gh >= 0 && w->projectiles[gh].active,
              "gargoyle-muzzle: the puff SURVIVES that frame -- it did not spawn INSIDE the solid "
              "wall (the old e->x+sx*0x20 muzzle died on tick 1; asm FUN_1000adc4)");
    }

    /* ---- 32. soi_gift_cell_ok keeps Knight gifts out of the shooters' cages. A cell is a
     * legal gift target only if it is in bounds, empty, and NOT inside the 3x3 halo of a
     * KNIGHT or GARGOYLE. bug-6 ("knight shot goody into his own area") was the old code
     * testing SPINNER instead of KNIGHT, so nothing guarded the caged shooters and goodies
     * piled up inside the cage. Only Knight/Gargoyle exclude -- other enemies do not. ---- */
    {
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 5, 5);
        soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 10, 5);
        soi_enemy_spawn(w, SOI_ENEMY_ROBO, 2, 8);
        CHECK(soi_gift_cell_ok(w, 5, 5) == 0, "gift-exclusion: a Knight's own cell is not a gift target");
        CHECK(soi_gift_cell_ok(w, 6, 6) == 0, "gift-exclusion: a cell diagonally adjacent to a Knight is excluded");
        CHECK(soi_gift_cell_ok(w, 11, 5) == 0, "gift-exclusion: a cell adjacent to a Gargoyle is excluded");
        CHECK(soi_gift_cell_ok(w, 2, 8) == 1, "gift-exclusion: a Robo does NOT block a gift (only Knight/Gargoyle do)");
        CHECK(soi_gift_cell_ok(w, 8, 3) == 1, "gift-exclusion: a far empty cell IS a legal gift target");
        soi_set_cell(w, 9, 3, SOI_CELL_SUPPORTIVE);
        CHECK(soi_gift_cell_ok(w, 9, 3) == 0, "gift-exclusion: a non-empty cell is never a gift target");
    }

    free(w);
    if (failures) { printf("\n%d CHECK(S) FAILED\n", failures); return 1; }
    printf("\nALL MECHANIC TESTS PASSED\n");
    return 0;
}
