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
    p->bonus_time = 5000;                 /* realistic board-load default (BORD 0x0E). Bare-world
                                           * tests carry no captured board, so a runout respawns IN
                                           * PLACE without reseeding the clock; seed a healthy value
                                           * so a test that ticks a few frames isn't killed by the
                                           * timer (board-reload recovery is exercised by test 41). */
}

/* Mark the player's feet cell supportive so soi_tick keeps it grounded instead
 * of dropping it into a fall. Support cell == the placement cell (col,row).
 * Use a pure SUPPORTIVE (0x200) surface, not a full wall, so it does not also
 * read as PERMANENT (which would, e.g., block a fired arrow at its spawn). */
static void ground_player(SoiWorld *w, int col, int row)
{
    soi_set_cell(w, col, row, SOI_CELL_SUPPORTIVE);
}

/* Press an action key the way a player does -- held 2 ticks so an odd (logic) tick latches
 * the press -- then run the action up to its VERB: the original builds/fires on the
 * action's 5th player frame (asm FUN_1001166c), not on the press frame. */
static void act_press(SoiWorld *w, uint8_t key)
{
    int g = 0;
    soi_tick(w, key, 0); soi_tick(w, key, 0);
    while (w->players[1].pose != 0 && w->players[1].pose_t < 5 && g++ < 40) soi_tick(w, 0, 0);
}

/* Let the running action end and every block grow/shrink animation finish. */
static void act_done(SoiWorld *w)
{
    int g = 0, i, busy = 1;
    while (busy && g++ < 60) {
        busy = (w->players[1].pose != 0);
        for (i = 0; i < SOI_BLOCKANIM_MAX; i++) if (w->banim[i].active) busy = 1;
        if (busy) soi_tick(w, 0, 0);
    }
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
    w->enemies[0].turn = 200;                  /* ...and holds still through the throw's wind-up */
    CHECK(soi_enemy_count(w) == 1, "arrow: enemy present before firing");
    CHECK(soi_enemy_active(w, 0) == 1 && soi_enemy_type(w, 0) == SOI_ENEMY_ANT,
          "accessor: enemy slot 0 active + type readable");
    CHECK(soi_enemy_x(w, 0) == soi_cell_x(5) && soi_enemy_y(w, 0) == soi_cell_y(9),
          "accessor: enemy pixel position readable");

    act_press(w, SOI_IN_BALL);                 /* fire once (the throw lands on the action's 5th frame) */
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
    act_press(w, SOI_IN_BALL);                 /* fire the rolling ball */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].arrows == 2,
          "one-shot: first arrow fires (1 in flight, ammo 3->2)");
    act_done(w);
    act_press(w, SOI_IN_BALL);                 /* try to fire again while it flies */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].arrows == 2,
          "one-shot: a 2nd arrow is BLOCKED while the 1st is live (no timer needed)");
    act_done(w);
    act_press(w, SOI_IN_ARROW);                /* the other weapon SHARES the slot -> also blocked */
    CHECK(soi_projectile_count(w) == 1 && w->players[1].balls == 3,
          "one-shot: a ball is BLOCKED too (arrow+ball share the one slot)");
    act_done(w);
    {
        int t;                                 /* let the live arrow fizzle (age 500) */
        for (t = 0; t < 560 && soi_projectile_count(w) > 0; t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_projectile_count(w) == 0, "one-shot: the live arrow eventually despawns");
    act_press(w, SOI_IN_BALL);
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

    /* ---- 3. Head-bonk is a FROZEN 10-frame recoil that destroys at the MIDPOINT,
     * NOT an instant break (asm ground-state 4, FUN_10014524). Jumping into a solid
     * block directly overhead enters a distinct BONK state; the player is frozen for
     * ~10 logic frames (no run/build/jump); the block is CRACKED at frame ~5 (asm
     * counter==5) and he returns to IDLE at frame 10. A SECOND bonk BREAKS the cracked
     * block (asm FUN_1002ca5c two-stage destroy). Regression: the old port cracked the
     * block INSTANTLY on the press frame and left ground_state IDLE, so the player
     * could act immediately -- no animation, no freeze, wrong timing. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                     /* stand so the jump can launch */
    soi_set_cell(w, 6, 8, SOI_CELL_SUPPORTIVE | 1);  /* breakable block above head (real block: has 0x200) */
    {
        int bonk_x0 = w->players[1].x;
        int crack_f = -1, idle_f = -1, f, frozen = 1;
        soi_tick(w, SOI_IN_JUMP, 0);                 /* press jump into the block (odd tick: logic runs) */
        CHECK(w->players[1].ground_state == SOI_ST_JUMP && w->players[1].y == soi_cell_y(9),
              "bonk: the press frame only readies the jump (asm idle -> state 2, counter 0)");
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);        /* the next player frame is the launch check */
        CHECK(w->players[1].ground_state == SOI_ST_BONK,
              "bonk: jumping into a solid block overhead enters the frozen bonk state (no leap)");
        CHECK(!(soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED),
              "bonk: the block is NOT cracked on the press frame (destroy deferred to the midpoint)");
        /* Drive RIGHT throughout to PROVE the freeze: a bonking player must not run. */
        for (f = 1; f <= 14 && idle_f < 0; f++) {
            soi_tick(w, SOI_IN_RIGHT, 0);            /* even tick: no logic */
            soi_tick(w, SOI_IN_RIGHT, 0);            /* odd tick: one 30Hz logic frame */
            if (crack_f < 0 && (soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED)) crack_f = f;
            if (w->players[1].ground_state == SOI_ST_IDLE) idle_f = f;
            else if (w->players[1].ground_state != SOI_ST_BONK) frozen = 0;  /* must stay BONK until idle */
            if (idle_f < 0 && w->players[1].x != bonk_x0) frozen = 0;        /* x pinned while bonking */
        }
        CHECK(frozen, "bonk: the player stays frozen in BONK (RIGHT does nothing) until the recoil ends");
        CHECK(w->players[1].x == bonk_x0,
              "bonk: the recoil is stationary -- x never slides during the animation");
        CHECK(crack_f >= 4 && crack_f <= 6,
              "bonk: the block cracks at the animation MIDPOINT (~frame 5), not on the press frame");
        CHECK(idle_f >= crack_f + 4 && idle_f <= crack_f + 6,
              "bonk: the player returns to IDLE ~5 frames after the crack (a 10-frame animation)");
        CHECK((soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED) &&
              SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) != SOI_CELL_EMPTY,
              "bonk: after one bonk the block is cracked but still present");
    }
    /* A SECOND bonk BREAKS the cracked block. The player is IDLE now; release the keys
     * (clear the edge), then re-press JUMP for 2 ticks (spans an odd logic tick). */
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);            /* release inputs */
    soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, SOI_IN_JUMP, 0);  /* re-press -> bonk #2 */
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);            /* (the launch check runs a frame after the press) */
    CHECK(w->players[1].ground_state == SOI_ST_BONK,
          "bonk2: re-pressing jump into the cracked block bonks again");
    {
        int f;
        for (f = 0; f < 14 && SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) != SOI_CELL_EMPTY; f++) {
            soi_tick(w, 0, 0); soi_tick(w, 0, 0);
        }
    }
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
          "bonk2: the second bonk BREAKS the cracked block at its midpoint");

    /* A PERMANENT block overhead still HEAD-BONKS (enters the frozen recoil -- asm
     * FUN_10012444 tests only the 0x200 solid bit, which SOI_WALL=0x300 carries) but
     * the block is IMMUNE: the midpoint destroy no-ops on 0x100, so it survives. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);
    soi_set_cell(w, 6, 8, SOI_WALL);
    soi_tick(w, SOI_IN_JUMP, 0);
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);
    CHECK(w->players[1].ground_state == SOI_ST_BONK,
          "bonkperm: jumping into a permanent block overhead still enters the bonk recoil");
    {
        int f;
        for (f = 0; f < 14; f++) { soi_tick(w, 0, 0); soi_tick(w, 0, 0); }
    }
    CHECK(soi_get_cell(w, 6, 8) == SOI_WALL,
          "bonkperm: the permanent block is untouched by the head-bonk (immune)");
    CHECK(w->players[1].ground_state == SOI_ST_IDLE,
          "bonkperm: the player returns to IDLE after the recoil");

    /* ---- 3 (boundary straddle). A player whose head spans a column boundary bonks off
     * the TRAILING upper-body column too: the asm head-clear (FUN_10012444) probes TWO
     * columns (x+0x10 AND x+0x0e), so start_jump must use the same two-column headroom_clear
     * -- a single-column (x+0x10 only) probe would MISS a block above the trailing column
     * and wrongly leap. At x = cell_x(6)+16 the head straddles cols; a solid block sits
     * above the LEFT (trailing) column only. The midpoint destroy targets the FACING column
     * (do_head_break: x+0x12 -> the empty RIGHT one, asm FUN_10014524), so this is a
     * faithful bonk-WITHOUT-break: the player freezes and recoils, the trailing block is
     * never cracked, and he returns to IDLE. Both the two-column detect AND the faithful
     * facing-column destroy are pinned here (mutation-proof for either regressing). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    w->players[1].x += 16;                          /* straddle: head spans cols (x+0x0e left, x+0x10 right) */
    w->players[1].spawn_x = (int16_t)w->players[1].x;
    ground_player(w, 6, 9);                         /* the left (trailing) column still supports the feet */
    soi_set_cell(w, 6, 8, SOI_CELL_SUPPORTIVE | 1); /* block above the TRAILING (left) head column only */
    CHECK(!(soi_get_cell(w, 7, 8) & SOI_CELL_SUPPORTIVE),
          "bonk-straddle: the FACING (right) head column is clear (only the trailing one has a block)");
    soi_tick(w, SOI_IN_JUMP, 0);
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);
    CHECK(w->players[1].ground_state == SOI_ST_BONK,
          "bonk-straddle: the two-column head-clear bonks off the trailing column (a single-column probe would leap)");
    {
        int f;
        for (f = 0; f < 14; f++) { soi_tick(w, 0, 0); soi_tick(w, 0, 0); }
    }
    CHECK((soi_get_cell(w, 6, 8) & SOI_CELL_SUPPORTIVE) &&
          !(soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED),
          "bonk-straddle: faithful bonk-WITHOUT-break -- the facing-column destroy misses the trailing block");
    CHECK(w->players[1].ground_state == SOI_ST_IDLE,
          "bonk-straddle: the player returns to IDLE after the boundary recoil");

    /* ---- 3a. A clear-headroom jump leaps the table-driven arc (~37px peak, asm
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

    /* ---- 3b. A GOODIE directly overhead is NOT a head-bonk: the player leaps up
     * INTO it (and can then collect it), instead of being stopped dead. Headroom is
     * blocked only by the SUPPORTIVE bit (asm FUN_10012444 tests (cell & 0x200)),
     * and treasure goodies (0x9xx, e.g. a 3x-multiplier / coin) carry no 0x200. The
     * old `SOI_CELL_TYPE(a) != 0` test wrongly treated any non-empty overhead cell
     * (including a coin) as a bonk ("cannot jump into coins/3x above"). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);
    soi_set_cell(w, 6, 8, 0x90A);                 /* a silver-coin goodie directly overhead (no 0x200) */
    soi_tick(w, SOI_IN_JUMP, 0);                  /* edge-trigger the jump */
    CHECK(w->players[1].in_air == 1 && w->players[1].ground_state == SOI_ST_JUMP,
          "jumpgoody: a goodie overhead does NOT block the leap (player goes airborne)");
    CHECK(soi_get_cell(w, 6, 8) == 0x90A,
          "jumpgoody: leaping up does not crack/break the goodie (it is not a solid block)");


    /* ---- 3c. Block create/destroy TOGGLE: two block-high presses at the same
     * front cell build then remove the block (the core build/dig mechanic; an
     * earlier demo looked out of sync, so this pins the behaviour down). Input is
     * latched every 2 frames (odd ticks), so each press/release is held 2 ticks. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].facing = 1;                   /* face right -> block-high targets the front cell */
    act_press(w, SOI_IN_BLOCK_HIGH);            /* press: build a block in front */
    act_done(w);                                /* ...it grows in over ~6 frames */
    CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) &&
          SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
          "block-high: first press builds a block in front");
    act_press(w, SOI_IN_BLOCK_HIGH);            /* press again: remove the same block */
    act_done(w);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == SOI_CELL_EMPTY,
          "block-high: a second press at the same cell removes it");

    /* ---- 3d. BUILD GATE (asm FUN_1002d04c -> FUN_100047e8): the original only builds
     * where the target cell is visually UNOBSTRUCTED, so a block-press over a nasty does
     * NOTHING -- no block is built and the nasty is NOT squashed (nasties are defeated by
     * weapons or the thunderballs/shoes goody, not by a built block). */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1;                   /* block-high targets the front cell (6,9) */
    int gate_ei = soi_enemy_spawn(w, SOI_ENEMY_ANT, 6, 9);   /* nasty on the front build cell */
    CHECK(gate_ei >= 0, "build-gate: test nasty spawned on the front cell");
    w->enemies[gate_ei].vx = 0; w->enemies[gate_ei].turn = 200;   /* hold it on the cell */
    soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);                    /* ...standing, not falling */
    act_press(w, SOI_IN_BLOCK_HIGH);
    act_done(w);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == SOI_CELL_EMPTY,
          "build-gate: no block is built on a nasty-occupied cell");
    CHECK(gate_ei >= 0 && w->enemies[gate_ei].active,
          "build-gate: the nasty is NOT squashed by the build (weapons/goody defeat it)");

    /* ---- 3c2. The build/fire ACTION (asm FUN_1001166c): a press starts it and picks the
     * pose table by its anim mode (3/4 facing right, 1/2 left; 4/2 = the LOW block); the
     * VERB happens on the action's 5th player frame, and on the 7th the action ends. ---- */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1;
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0); soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK(soi_player_pose(w, 1) == 3 && soi_player_pose_t(w, 1) == 0,
          "action: a high-block press facing right starts anim mode 3 at frame 0");
    CHECK(!(soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE),
          "action: nothing is built on the press frame");
    {
        int f, built_at = -1, end_at = -1;
        for (f = 1; f <= 10 && end_at < 0; f++) {
            soi_tick(w, 0, 0); soi_tick(w, 0, 0);          /* one player frame */
            if (built_at < 0 && (soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE)) built_at = f;
            if (soi_player_pose(w, 1) == 0) end_at = f;
        }
        CHECK(built_at == 5, "action: the block is built on the action's 5th frame");
        CHECK(end_at == 7, "action: the action ends on its 7th frame");
    }
    CHECK(soi_get_cell(w, 6, 9) == (0x19u | SOI_CELL_SUPPORTIVE),
          "action: the grown block is the player's block type");
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = -1;
    soi_tick(w, SOI_IN_BLOCK_LOW, 0); soi_tick(w, SOI_IN_BLOCK_LOW, 0);
    CHECK(soi_player_pose(w, 1) == 2, "action: a low-block press facing left is anim mode 2");
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1; w->players[1].balls = 3;
    soi_tick(w, SOI_IN_ARROW, 0); soi_tick(w, SOI_IN_ARROW, 0);
    CHECK(soi_player_pose(w, 1) == 3 && soi_projectile_count(w) == 0,
          "action: firing uses anim mode 3 and nothing flies yet on the press frame");

    /* ---- 3c3. MASHING a block key in mid-air does NOT hover. Each action freezes the fall
     * for its 7 frames, but the frame it ends runs the fall step and a new action can only
     * start on the frame after -- so the player still sinks 4 px every 8 frames (the old
     * port let a press right on the release frame start the next action with no fall step,
     * so a masher floated forever). Here the key is pressed on every other player frame. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 2);
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    w->players[1].facing = 1;
    {
        int y0 = w->players[1].y, t;
        for (t = 0; t < 64; t++)
            soi_tick(w, ((t >> 1) & 1) ? 0 : SOI_IN_BLOCK_HIGH, 0);
        CHECK(w->players[1].y - y0 == 16,
              "mash: mid-air block mashing still sinks 4 px per 8 frames (no hover)");
    }

    /* ---- 3e. A cliff-fall is PURELY VERTICAL (asm FUN_1001386c calls ONLY the
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

    /* ---- 3f. MID-AIR BUILD FREEZE: a build/fire mid-air must FREEZE the player for the
     * pose (asm FUN_1001166c line 160 gates the whole movement switch -- the jump arc
     * (case 2) AND the fall (case 3) -- on the action-active flag, so the descent halts
     * while the build/fire animation plays and only resumes when it finishes). Regression
     * for the port sliding/falling through its own mid-air build. ---- */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);                    /* open space, no walls -> no rebound */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    w->players[1].facing = 1;
    {
        int y0, ypose, guard;
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);    /* fall a frame first */
        CHECK(w->players[1].in_air == 1 && w->players[1].ground_state == SOI_ST_FALL,
              "midair-freeze: the player is airborne (falling) before the build");
        y0 = w->players[1].y;
        soi_tick(w, SOI_IN_BLOCK_HIGH, 0); soi_tick(w, SOI_IN_BLOCK_HIGH, 0);   /* build while falling */
        CHECK(w->players[1].pose != 0, "midair-freeze: the build action is running");
        CHECK(w->players[1].y == y0, "midair-freeze: the fall is frozen while the build pose plays");
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].y == y0, "midair-freeze: still frozen partway through the pose");
        guard = 0;
        while (w->players[1].pose != 0 && guard++ < 40) soi_tick(w, 0, 0);      /* run the action out */
        ypose = w->players[1].y;
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].y > ypose, "midair-freeze: the descent resumes once the pose ends");
    }

    /* ---- 3g. BUILD BEATS A SAME-FRAME JUMP, and a jump pressed DURING the build pose is
     * DROPPED (never an "airborne but frozen at ground height" state): the asm evaluates the
     * action phase (build/fire, FUN_1001166c lines 14-68) BEFORE the movement switch and then
     * FREEZES that switch on the action-active flag (the line-160 gate), so the idle/run handler
     * that STARTS a jump cannot run until the pose clears -- the player stays GROUNDED through the
     * pose, then a still-pressed jump leaps and actually arcs upward. Regressions for (a) the jump
     * swallowing a same-tick build and (b) a mid-pose jump popping the player airborne-but-frozen. ---- */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9); ground_player(w, 5, 9);
    w->players[1].facing = 1;
    soi_tick(w, (uint8_t)(SOI_IN_BLOCK_HIGH | SOI_IN_JUMP), 0);
    soi_tick(w, (uint8_t)(SOI_IN_BLOCK_HIGH | SOI_IN_JUMP), 0);
    CHECK(w->players[1].pose == 3 && w->players[1].act_verb == SOI_ACT_BLOCK,
          "jump-build: a same-frame build+jump starts the BUILD action");
    CHECK(w->players[1].in_air == 0,
          "jump-build: the same-frame jump does NOT swallow the build (player stays grounded)");
    /* release, then a jump pressed WHILE the action is still running -> dropped, stays grounded */
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);
    CHECK(w->players[1].pose != 0, "jump-build: the build action is still running");
    soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(w->players[1].in_air == 0 && w->players[1].pose != 0,
          "jump-build: a jump pressed DURING the pose is dropped (no airborne-frozen state)");
    /* let the action (and its block's grow) finish, THEN a jump leaps AND arcs upward */
    {
        int yj;
        act_done(w);
        CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
              "jump-build: the same-frame build+jump performed the BUILD (block created)");
        CHECK(w->players[1].in_air == 0,
              "jump-build: player is still grounded after the pose drains");
        yj = w->players[1].y;
        soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, SOI_IN_JUMP, 0);
        CHECK(w->players[1].in_air == 1,
              "jump-build: a jump pressed after the pose still leaps");
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].y < yj,
              "jump-build: the leap actually arcs upward (y decreases), not airborne-frozen");
    }

    /* ---- 3h. AIRBORNE build/destroy: you can build or dig a block while jumping or falling.
     * The asm runs the action animation (FUN_1001166c) EVERY frame gated ONLY by the death flag
     * +0x28 -- not by air state -- and the build/fire fires from that animation. The port used to
     * `return` on in_air BEFORE the block actions, so mid-air building did nothing; the airborne
     * branch now handles block/arrow/ball (but not a new jump) before the air physics. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    w->players[1].facing = 1;                         /* face right -> block-high targets (6,9) */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_JUMP;   /* mid-jump */
    act_press(w, SOI_IN_BLOCK_HIGH);
    CHECK(w->players[1].in_air == 1, "airborne: building mid-air does NOT cancel the jump");
    act_done(w);
    CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
          "airborne: can BUILD a block in front while jumping (mid-air)");

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
        if (ci >= 0) w->enemies[ci].life = 2;           /* force it to the brink of expiry (2 steps) */
        { int k; for (k = 0; k < 4; k++) soi_enemies_update(w); }   /* 2 steps x 2 frames */
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
        for (t = 0; t < 80; t++) soi_enemies_update(w);
        CHECK(!(soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE), "robo: punches through a breakable block");
        CHECK(w->enemies[ri].dir == 2, "robo: keeps its heading after punching (no turn)");
    }

    /* ---- 8e. A Beanie (FUN_10006378) meeting a BREAKABLE block stops and shoots out a bud
     * (child 0x6b, FUN_10006d44) that grows, smashes the block, retracts and vanishes; the
     * Beanie waits for it and then walks on. At a PERMANENT block it turns around. It never
     * spawns another Beanie. */
    {
        int pi, n, e, t, x0, broke_at = -1;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        pi = soi_enemy_spawn(w, SOI_ENEMY_BEANIE, 5, 9);
        w->enemies[pi].dir = 2; w->enemies[pi].vx = 2;
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 0x07);  /* breakable block ahead */
        x0 = w->enemies[pi].x;
        soi_enemies_update(w); soi_blockanims_update(w);
        CHECK(w->enemies[pi].bud > 0 && w->enemies[pi].x == x0, "beanie: stops and shoots a bud at a breakable block");
        for (t = 0; t < 80 && w->enemies[pi].bud; t++) {
            soi_enemies_update(w); soi_blockanims_update(w);
            if (broke_at < 0 && SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0) broke_at = w->enemies[pi].bud;
        }
        CHECK(broke_at == 17, "beanie: the bud smashes the block when fully out (16 steps)");
        CHECK(w->enemies[pi].x == x0 && w->enemies[pi].dir == 2, "beanie: waits for its bud, keeps its heading");
        n = 0;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_BEANIE) n++;
        CHECK(n == 1, "beanie: never spawns another Beanie");
        for (t = 0; t < 4; t++) { soi_enemies_update(w); soi_blockanims_update(w); }
        CHECK(w->enemies[pi].x > x0, "beanie: walks on through the cleared cell");
        soi_set_cell(w, 8, 9, SOI_WALL);                      /* permanent block further on */
        for (t = 0; t < 200 && w->enemies[pi].dir == 2; t++) { soi_enemies_update(w); soi_blockanims_update(w); }
        CHECK(w->enemies[pi].dir == 1 && w->enemies[pi].turn == 16, "beanie: turns around (16 steps) at a permanent block");
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
        w->enemies[ai].x = soi_cell_x(5) - 2;           /* now fully over the gap (Ant feet x+4, x+0x20) */
        soi_enemies_update(w); soi_enemies_update(w);   /* one AI step = 2 frames (asm +0x6c) */
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
        for (t = 0; t < 600; t++) {                     /* 1 px per 3 frames + 16-step turns */
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
     * projectile flies to its target cell and drops a goody -- a wrapped GIFT BOX on an EMPTY
     * cell (low 0xFF, the goody in the high word, revealed only when collected), or a '?'
     * block (type 0x91) burying the goody if the player blocked the cell mid-flight. ---- */
    {
        SoiProjectile *pr; int t, s0;
        /* empty target -> gift box */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 0; pr->kind = 2; pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT;
        pr->gtype = 0x0A; pr->tcol = 7; pr->trow = 8;
        pr->x = soi_cell_x(3); pr->y = soi_cell_y(3); pr->vx = 0; pr->vy = 0; pr->age = 0;
        for (t = 0; t < 200 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        CHECK(!w->projectiles[0].active, "knight-gift: the gift lands and despawns");
        CHECK(soi_get_cell(w, 7, 8) == ((0x0Au << 16) | 0x9FFu),
              "knight-gift: an empty target becomes a wrapped gift box (0x9FF, silver coin in the high word)");
        /* collecting the box pays out the hidden goody (asm FUN_1002bc64 uVar10 == 0xff) */
        w->players[1].x = (int16_t)soi_cell_x(7); w->players[1].y = (int16_t)soi_cell_y(8);
        s0 = w->players[1].score;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].score == s0 + 500 && soi_get_cell(w, 7, 8) == 0,
              "knight-gift: collecting the gift box pays its goody (+500 silver coin) and clears the cell");

        /* target BLOCKED before arrival -> '?' block with the goody as a hidden payload */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_set_cell(w, 7, 8, 0x07u);   /* a player block already occupies the target */
        pr = &w->projectiles[0];
        pr->active = 1; pr->hostile = 0; pr->kind = 2; pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT;
        pr->gtype = 0x17; pr->tcol = 7; pr->trow = 8;
        pr->x = soi_cell_x(3); pr->y = soi_cell_y(3); pr->vx = 0; pr->vy = 0; pr->age = 0;
        for (t = 0; t < 200 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 7, 8)) == 0x91u && (soi_get_cell(w, 7, 8) & SOI_CELL_SPECIAL) &&
              (soi_get_cell(w, 7, 8) & SOI_CELL_SUPPORTIVE) &&
              SOI_CELL_PAYLOAD(soi_get_cell(w, 7, 8)) == (0x900u | 0x17u),
              "knight-gift: a blocked target becomes a '?' block (0x1291) burying the gold coin");
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
            { 0x0D, SOI_SFX_MULT,          "goody: a score multiplier plays its own sound (evt 0x17), not the door bugle" },
        };
        int k;
        for (k = 0; k < 8; k++) {
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
        w->enemies[hi].x += 6;                          /* probe x+0x1a now in col 6 */
        {
            int y0 = w->enemies[hi].y, minY, t, smashed = 0;
            soi_enemies_update(w);                      /* step 1: begin the jump-smash (rise) */
            minY = w->enemies[hi].y;
            CHECK(w->enemies[hi].y == y0 - 11, "hammer: rises a fixed 11px as it begins the smash");
            for (t = 0; t < 60 && w->enemies[hi].fire_cd != 0; t++) {   /* 16 steps x 2 frames */
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
        w->enemies[hi].x += 6;
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
    act_press(w, SOI_IN_BALL);                          /* fire -> travels right */
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
     * wrongly reads "down" (into the floor) as clear. The player stands ON TOP of
     * the row-12 floor (support probes one row below), so the arrow spawns in the
     * EMPTY row-11 cell -- projectile solidity is (cell & 0x200) with no type guard
     * (asm FUN_1000554c), so a support cell co-located on the arrow's own row would
     * (correctly) read solid and wrongly deflect it at spawn. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 11);                                           /* stands on the row-12 floor below */
    w->players[1].y = (int16_t)(soi_cell_y(11) + 1);                     /* rest at block-top+1: feet reach row 12, body cell (row 11) is EMPTY */
    { int c; for (c = 1; c <= 9; c++) soi_set_cell(w, c, 12, 0x300u); }  /* solid floor below the arrow */
    soi_set_cell(w, 3, 11, 0x300u); soi_set_cell(w, 3, 10, 0x300u);      /* wall to the left */
    w->players[1].arrows = 1; w->players[1].facing = -1;                 /* face left */
    act_press(w, SOI_IN_BALL);                                           /* fire left */
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
        act_press(w, SOI_IN_BLOCK_LOW);             /* build a block in front-below */
        act_done(w);
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

    /* ---- 14d. Stationary shooters DO NOT fall: the Cannon (asm FUN_100071a0), Gargoyle
     * (FUN_1000adc4) and Knight (FUN_1000c2e8) never call the gravity predicate
     * FUN_10005750 -- they are mounted turrets that hold their spawn Y over open air (a
     * Cannon on bord 44 hangs in mid-board, it does not drop onto -- and kill -- the
     * player below; flying shooters keep their placed vertical spread instead of all
     * falling and stacking on the floor). The SPINNER (FUN_1000d490) is the ONE hazard
     * that DOES call FUN_10005750, so it must still fall -- guards against an over-broad
     * exemption. NO floor is placed under any of them. ---- */
    {
        int ci, gi, ki, si, cy0, gy0, ky0, sy0, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ci = soi_enemy_spawn(w, SOI_ENEMY_CANNON,   3, 5);   /* open air, no floor below */
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 6, 5);
        ki = soi_enemy_spawn(w, SOI_ENEMY_KNIGHT,   9, 5);
        si = soi_enemy_spawn(w, SOI_ENEMY_SPINNER, 12, 5);
        cy0 = soi_enemy_y(w, ci); gy0 = soi_enemy_y(w, gi);
        ky0 = soi_enemy_y(w, ki); sy0 = soi_enemy_y(w, si);
        for (t = 0; t < 10; t++) soi_enemies_update(w);
        CHECK(soi_enemy_y(w, ci) == cy0, "turret: the Cannon does NOT fall over open air (static, mid-board)");
        CHECK(soi_enemy_y(w, gi) == gy0, "turret: the Gargoyle does NOT fall over open air");
        CHECK(soi_enemy_y(w, ki) == ky0, "turret: the Knight does NOT fall over open air");
        CHECK(soi_enemy_y(w, si) >  sy0, "spinner: DOES fall over open air (still obeys gravity)");
    }

    /* ---- 14e. PLOW-GROUP block-break is SILENT, and the SMILEY (faceball) REVERSES.
     * The asm plow-clear FUN_100279c4 -> FUN_1002754c emits NO sound; each plow nasty's
     * only FUN_1002b020 call is its DEATH cry, gated on the +0x88 "claimed" field
     * (FUN_100081f8/9a78/d130/d8c4). So a Piggy breaking a block is silent (bord 67).
     * The Smiley (bord 36, asm FUN_1000d130) does NOT plow: at a breakable block it
     * breaks it, then REVERSES immediately (+0x4c := opposite). The Teeth (FUN_1000d8c4)
     * is the one true plow-through: it breaks and KEEPS its heading. ---- */
    {
        int pi, sdir, mi, tdir, k, piggy_sound;
        /* (a) Piggy breaks a breakable block WITHOUT the block-destroy sound. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        pi = soi_enemy_spawn(w, SOI_ENEMY_PIGGY, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);          /* floor */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 1);       /* breakable block ahead */
        w->enemies[pi].dir = 2; w->enemies[pi].vx = 2;
        w->sfx_count = 0;
        soi_enemies_update(w);
        piggy_sound = 0;
        for (k = 0; k < soi_sfx_count(w); k++)
            if (soi_sfx_get(w, k) == SOI_SFX_BLOCK_DESTROY) piggy_sound = 1;
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0, "plow-silent: the Piggy broke the block ahead");
        CHECK(!piggy_sound, "plow-silent: breaking the block emits NO block-destroy sound (asm FUN_100279c4)");

        /* (b) Smiley breaks a breakable block, then REVERSES (does not plow through). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        mi = soi_enemy_spawn(w, SOI_ENEMY_SMILEY, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 1);       /* breakable block ahead */
        w->enemies[mi].dir = 2; w->enemies[mi].vx = 2;
        soi_enemies_update(w);
        sdir = w->enemies[mi].dir;
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0, "faceball: the Smiley broke the block ahead");
        CHECK(sdir == 1, "faceball: the Smiley REVERSES after breaking (dir 2 -> 1), does not plow through");

        /* (c) Teeth is the true plow: it breaks a block and KEEPS its heading. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        mi = soi_enemy_spawn(w, SOI_ENEMY_TEETH, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 1);
        w->enemies[mi].dir = 2; w->enemies[mi].vx = 2;
        soi_enemies_update(w);
        tdir = w->enemies[mi].dir;
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0, "teeth-plow: the Teeth broke the block ahead");
        CHECK(tdir == 2, "teeth-plow: the Teeth KEEPS its heading (plows through, does not reverse)");
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
    soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);           /* two cells to the right */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);        /* floor so the nasty stands */
    act_press(w, SOI_IN_ARROW);                         /* fire the straight shot */
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

    /* 15a. Its hit strip is (x,y+1)-(x+0xf,y+5) at row-top+8 (FUN_1000fd5c): it rolls
     * straight over a low Ant (box row-top+16..+32) and spends itself on the wall. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 1;
    w->players[1].facing = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
    w->enemies[0].vx = 0; w->enemies[0].turn = 200;
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
    act_press(w, SOI_IN_ARROW);
    {
        int t;
        for (t = 0; t < 120 && soi_projectile_count(w) > 0; t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_enemy_count(w) == 1, "ball: a low Ant ducks under the Magic Ball");

    /* 15b. The ball stops at a solid block and does NOT smash it (contrast the
     * Arrow, which clears the block in test 12). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x201);                       /* destructible block ahead */
    act_press(w, SOI_IN_ARROW);
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
    reset_player(w, 1, 1, 1);
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CREEPER, 4, 6);   /* mid-board, open cells */
        int t, k, maxseg = 0, leak = 0, head = 0;
        CHECK(ci >= 0, "creeper: spawned");
        w->enemies[ci].state = 0;          /* 0 = horizontal axis */
        w->enemies[ci].dir   = 2;          /* growing to the right */
        w->enemies[ci].fire_period = 1;    /* StartDelay 1 -> grow timer 3 steps */
        soi_creeper_init(w, ci);
        CHECK(soi_get_cell(w, 4, 6) & SOI_CELL_SUPPORTIVE, "creeper: solidifies the cell it occupies");
        soi_set_cell(w, 6, 6, 0x197);      /* a background tile in its path (enterable, not solid) */
        for (t = 0; t < 200; t++) {
            int nseg = 0, c;
            soi_tick(w, 0, 0);
            for (k = 0; k < SOI_MAX_ENEMIES; k++)
                if (w->enemies[k].active && w->enemies[k].type == SOI_ENEMY_CREEPER) {
                    nseg++;
                    c = (w->enemies[k].x - SOI_ORIGIN_X) / SOI_CELL_PX;
                    if (c > head) head = c;
                }
            if (nseg > maxseg) maxseg = nseg;
            for (c = 1; c < 17; c++) {     /* every solid cell on row 6 is a live segment */
                int seg = 0;
                if (!(soi_get_cell(w, c, 6) & SOI_CELL_SUPPORTIVE)) continue;
                for (k = 0; k < SOI_MAX_ENEMIES; k++)
                    if (w->enemies[k].active && w->enemies[k].type == SOI_ENEMY_CREEPER &&
                        (w->enemies[k].x - SOI_ORIGIN_X) / SOI_CELL_PX == c) seg = 1;
                if (!seg) leak = 1;
            }
        }
        CHECK(head >= 7, "creeper: the chain crosses a background (0x197) tile");
        CHECK(maxseg >= 2, "creeper: a new segment grows before the old one shrinks away (a chain)");
        CHECK(!leak, "creeper: every solid cell it leaves behind is restored (no leaked wall)");
        CHECK(soi_get_cell(w, 6, 6) == 0x197 || (soi_get_cell(w, 6, 6) & SOI_CELL_SUPPORTIVE),
              "creeper: the covered background tile comes back when the segment leaves");
        CHECK(soi_projectile_count(w) == 0, "creeper: never fires a projectile");
    }
    /* 16b. Creeper timeline (asm FUN_10008618): a step every 3rd frame; +0x6e = StartDelay*3
     * counts down while the segment grows (+0x56 0xf -> 1), at 0 it spawns the next segment
     * one cell ahead, then shrinks back to 0xf and dies, restoring the covered tile. Blocked
     * -> it reverses and retries the other way on the next step. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 1, 1);
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CREEPER, 8, 6), t, k, n20 = 0, n21 = 0, n38 = 0, n39 = 0;
        int child = -1;
        w->enemies[ci].state = 0; w->enemies[ci].dir = 2; w->enemies[ci].fire_period = 2;
        soi_creeper_init(w, ci);
        for (t = 1; t <= 39; t++) {
            int n = 0;
            soi_tick(w, 0, 0);
            for (k = 0; k < SOI_MAX_ENEMIES; k++)
                if (w->enemies[k].active && w->enemies[k].type == SOI_ENEMY_CREEPER) {
                    n++;
                    if (k != ci && child < 0) child = k;
                }
            if (t == 20) n20 = n;
            if (t == 21) n21 = n;
            if (t == 38) n38 = n;
            if (t == 39) n39 = n;
            if (t == 18) CHECK(w->enemies[ci].anim == 9, "creeper: grows one frame per step (0xf -> 9 in 6 steps)");
        }
        CHECK(n20 == 1 && n21 == 2, "creeper: spawns the next segment on step StartDelay*3 + 1");
        CHECK(child >= 0 && soi_enemy_x(w, child) == soi_cell_x(9), "creeper: the new segment is one cell ahead");
        CHECK(n38 == 2 && n39 == 1 && !w->enemies[ci].active, "creeper: the parent shrinks back and dies");
        CHECK((soi_get_cell(w, 8, 6) & SOI_CELL_SUPPORTIVE) == 0, "creeper: the parent's cell is restored");
    }
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 1, 1);
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CREEPER, 8, 6), t;
        w->enemies[ci].state = 0; w->enemies[ci].dir = 2; w->enemies[ci].fire_period = 1;
        soi_creeper_init(w, ci);
        soi_set_cell(w, 9, 6, SOI_WALL);   /* blocked ahead */
        for (t = 0; t < 12; t++) soi_tick(w, 0, 0);    /* step 4 = the spawn attempt */
        CHECK(w->enemies[ci].active && w->enemies[ci].dir == 1 && w->enemies[ci].fire_cd == 0,
              "creeper: blocked -> reverses and waits (no shrink)");
        for (t = 0; t < 3; t++) soi_tick(w, 0, 0);
        CHECK((soi_get_cell(w, 7, 6) & SOI_WALL) == SOI_WALL, "creeper: then grows the other way");
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
        CHECK(w->enemies[wi].dir == 1, "hippo: chomps the block then turns back (FUN_100081f8 state 5)");
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

    /* ---- 23c. ENEMY CHECK-BEFORE-MOVE (speed-near-obstacle). The asm walkers/robos
     * (FUN_1000dd4c / FUN_1000a780) PROBE the cell ahead from their CURRENT position
     * and only advance x when it is clear AND has ground; a wall/ledge/breakable
     * enters a turn/punch state with NO x change that frame. The port used to move
     * FIRST (e->x += e->vx) and only THEN probe the moved position, so on every
     * collision frame the nasty OVERSHOT one vx step and reversed the next frame ->
     * a visible "speed-up"/jitter next to an obstacle (worst in the degenerate
     * one-block case, where it vibrated +-vx forever). A faithful nasty must NOT
     * step into a wall or over a ledge on the turn frame. ---- */
    {
        int ri, x0, k;
        /* (a) DISCRIMINATOR -- a permanent wall directly ahead: turn WITHOUT stepping
         * into it. Old (move-first) code lands x0+vx before reversing -> x != x0. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);          /* ground under the robo   */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);          /* ground ahead (isolate WALL, not a ledge) */
        soi_set_cell(w, 6, 9, SOI_WALL);                      /* permanent wall directly ahead -> turn */
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        w->enemies[ri].x += 4;                                /* leading probe x+0x1c now in col 6 */
        x0 = w->enemies[ri].x;
        soi_enemies_update(w);                                /* one logic frame */
        CHECK(w->enemies[ri].x == x0,
              "speed-obstacle: an enemy does NOT step into a wall on the turn frame");
        CHECK(w->enemies[ri].dir == 1 && w->enemies[ri].turn == 15, "speed-obstacle: it reverses at the wall (15-step turn)");
        for (k = 0; k < 30; k++) soi_enemies_update(w);       /* 15 steps x 2 frames */
        CHECK(w->enemies[ri].x == x0 && w->enemies[ri].turn == 0, "speed-obstacle: it stands still through the turn");
        for (k = 0; k < 2; k++) soi_enemies_update(w);
        CHECK(w->enemies[ri].x == x0 - 2, "speed-obstacle: then walks back");

        /* (b) CONTROL -- a clear path: the enemy still advances a FULL vx step (the
         * fix must not freeze normal patrol). Passes on old and new. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        for (k = 3; k <= 9; k++) soi_set_cell(w, k, 10, SOI_CELL_SUPPORTIVE);  /* long platform */
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        x0 = w->enemies[ri].x;
        soi_enemies_update(w);
        CHECK(w->enemies[ri].x == x0 + 2,
              "speed-obstacle: with a clear path the enemy still advances a full step");
        CHECK(w->enemies[ri].dir == 2, "speed-obstacle: it keeps heading with a clear path");

        /* (c) DISCRIMINATOR -- a LEDGE ahead (no ground in the next-and-below cell):
         * turn WITHOUT stepping over it. Old code steps out then reverses -> x != x0. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);          /* ground under the robo only; col 6 is a gap */
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        w->enemies[ri].x += 4;
        x0 = w->enemies[ri].x;
        soi_enemies_update(w);
        CHECK(w->enemies[ri].x == x0,
              "speed-obstacle: an enemy does NOT step over a ledge on the turn frame");
        CHECK(w->enemies[ri].dir == 1, "speed-obstacle: it reverses at the ledge");

        /* (d) a Hippo (FUN_100081f8) chomps a breakable block ahead AND turns back on
         * that same step (16-step turn), without stepping forward. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 5, 9);
        for (k = 3; k <= 9; k++) soi_set_cell(w, k, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, 0x207u);                        /* breakable block ahead (type 7 + SUPPORTIVE) */
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        x0 = w->enemies[ri].x;
        soi_enemies_update(w);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == 0,
              "speed-obstacle: a Hippo chomps the breakable block ahead");
        CHECK(w->enemies[ri].x == x0,
              "speed-obstacle: the Hippo does not step on the chomp step");
        CHECK(w->enemies[ri].dir == 1 && w->enemies[ri].turn == 16, "speed-obstacle: the Hippo turns back after chomping");
    }

    /* ---- 24. thrown_badguy / pct_badguy drive ONLY the Gargoyle's EGG throw (asm FUN_1000adc4
     * rolls Random(100) vs pct_badguy -> FUN_1000bf54 egg -> FUN_1000b6a0 flight -> FUN_1000b7dc
     * hatch). There is no global top-of-board spawn: a board without a Gargoyle never throws, and
     * the selector maps through FUN_1000b7dc's switch (10 -> Teeth, 11 -> Smiley, 19 -> Piggy,
     * anything else -> Ostrich), hatching a 400-frame nasty. pct_badguy 0 -> always the puff. ---- */
    {
        int k, t, gi, found = -1;
        soi_world_init(w, 1);
        w->level_loaded = 1;
        w->pct_badguy = 100; w->thrown_badguy = 11;
        w->tick = 119;
        for (t = 0; t < 400; t++) soi_tick(w, 0, 0);
        CHECK(soi_enemy_count(w) == 0, "egg: no Gargoyle -> nothing is ever thrown (no global spawn)");

        soi_world_init(w, 1);
        w->level_loaded = 1;
        reset_player(w, 1, 3, 11);
        ground_player(w, 3, 11);
        for (t = 0; t < SOI_GRID_COLS; t++) soi_set_cell(w, t, 12, SOI_CELL_SUPPORTIVE);
        w->pct_badguy = 100; w->thrown_badguy = 11;
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 15, 8);
        soi_set_cell(w, 15, 9, SOI_WALL);
        w->enemies[gi].fire_cd = 0; w->enemies[gi].fire_period = 999;
        soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) == 1 && w->projectiles[0].kind == 3 && !w->projectiles[0].hostile,
              "egg: pct_badguy 100 -> the Gargoyle lobs a harmless egg, not a puff");
        CHECK(w->projectiles[0].trow <= 2, "egg: aimed at a cell in the top three rows");
        for (t = 0; t < 300 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        for (k = 0; k < SOI_MAX_ENEMIES; k++)
            if (w->enemies[k].active && w->enemies[k].type == SOI_ENEMY_SMILEY) { found = k; break; }
        CHECK(found >= 0 && w->enemies[found].life > 0 && w->enemies[found].life <= 400,
              "egg: hatches the mapped badguy (selector 11 -> Smiley) with a 400-frame life");

        soi_world_init(w, 1);
        w->level_loaded = 1;
        reset_player(w, 1, 3, 11);
        w->pct_badguy = 0; w->thrown_badguy = 0;
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 15, 8);
        w->enemies[gi].fire_cd = 0;
        soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) == 1 && w->projectiles[0].hostile,
              "egg: pct_badguy 0 -> always the aimed puff");
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
        soi_tick(w, SOI_IN_BALL, 0);                /* press fire -> the action starts */
        CHECK(w->players[1].pose != 0, "glide: firing a weapon starts the action pose");
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
        for (t = 0; t < 12; t++) soi_tick(w, 0, 0); /* let the action run out (7 player frames) */
        CHECK(w->players[1].pose == 0, "glide: the action pose ends after 7 player frames");
        soi_tick(w, SOI_IN_RIGHT, 0);
        CHECK(w->players[1].ground_state == SOI_ST_RUN,
              "glide: once the pose ends, holding a direction runs the player again");
    }

    /* ---- 27. A Bonus-timer runout kills with the SAME death as an enemy hit: the
     * airborne death-throw (SOI_ST_DEAD) + the hit cry (asm FUN_1000f500 routes a
     * timed-out player through FUN_10012228 == soi_player_hit). The asm decrements the
     * counter, SURVIVES the tick it first reads 0, and dies only when the NEXT decrement
     * would take it negative (FUN_1000f500 line 43 `< 0`), CLAMPING it back to 0 (line 45).
     * The old port dropped a tick early (died at ==0) and originally set alive=0 silently. ---- */
    {
        int k, cried = 0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        ground_player(w, 5, 9);
        w->players[1].invuln = 0;
        w->players[1].bonus_time = 1;               /* one decrement to reach 0 */
        w->bonus_div = 1;                           /* force the ~20Hz bonus tick */
        soi_tick(w, 0, 0);                          /* bonus 1 -> 0: NOT fatal (asm survives 0) */
        CHECK(w->players[1].bonus_time == 0,
              "timerdeath: the bonus reaches 0");
        CHECK(w->players[1].ground_state != SOI_ST_DEAD,
              "timerdeath: the player SURVIVES the 0 tick (asm dies at <0, not ==0)");
        w->bonus_div = 1;                           /* force the next bonus tick */
        soi_tick(w, 0, 0);                          /* bonus 0 -> -1 (<0): fatal, clamped to 0 */
        CHECK(w->players[1].ground_state == SOI_ST_DEAD,
              "timerdeath: the runout plays the death-throw (SOI_ST_DEAD) when the bonus would go negative");
        CHECK(w->players[1].bonus_time == 0,
              "timerdeath: the bonus is clamped back to 0 on the fatal tick (asm FUN_1000f500)");
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
        w->players[1].bonus_time = 1;                     /* one decrement to reach 0 */
        w->bonus_div = 1;                                 /* force the bonus tick */
        soi_tick(w, 0, 0);                                /* bonus 1 -> 0: survives, still invulnerable */
        CHECK(w->players[1].ground_state != SOI_ST_DEAD,
              "timerdeath-iframes: the player survives the 0 tick even while invulnerable");
        w->bonus_div = 1;                                 /* force the next bonus tick */
        soi_tick(w, 0, 0);                                /* bonus 0 -> -1 (<0): fatal despite i-frames */
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

    /* ---- 31. The DEATH-THROW somersault is PURELY VERTICAL (asm FUN_10011fcc writes
     * only Y (the parabola) + the ping-pong animation facing; it NEVER writes x). The
     * port used to nudge x by +/-1 every 3rd frame KEYED OFF p->facing -- a phantom
     * sideways drift with no asm basis. The player faces right, so that old drift would
     * push x +1; asserting x never moves (movedX==0) catches it directly. We also assert
     * the arc DOES advance in Y (proving death_step actually runs, not a no-op). Holding
     * a direction is belt-and-suspenders -- death_step reads no input, so this also rules
     * out any future input-steer creeping into the throw. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);                     /* open space (reset_player faces right) */
    soi_player_hit(w, 1);                          /* launch the somersault */
    CHECK(w->players[1].ground_state == SOI_ST_DEAD,
          "deaththrow: soi_player_hit starts the airborne somersault");
    {
        int dx0 = w->players[1].x, dy0 = w->players[1].y, movedX = 0, movedY = 0, t;
        for (t = 0; t < 60 && w->players[1].ground_state == SOI_ST_DEAD; t++) {
            soi_tick(w, SOI_IN_RIGHT, 0);          /* HOLD right: the death arc must ignore it */
            if (w->players[1].x != dx0) movedX = 1;
            if (w->players[1].y != dy0) movedY = 1;
        }
        CHECK(!movedX && movedY,
              "deaththrow: the somersault advances in Y but never drifts x (asm FUN_10011fcc = Y-only)");
    }

    /* ---- 32. Transporter STRADDLE guard (asm FUN_1002bc64): a transporter IN fires
     * only when the collision box sits in ONE column. If the box straddles two columns
     * (col(x+0xc) != col(x+0x12)) the teleport is SUPPRESSED. The cell-aligned player
     * (test 6 above) still teleports; a half-cell-straddling player must not. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 2, 2);
    w->players[1].x = (int16_t)(soi_cell_x(2) + 16);   /* straddle cols 2/3: col(x+0xc)=2, col(x+0x12)=3 */
    soi_set_cell(w, 2, 2, 0x1A);                        /* IN marker at the box-centre cell (2,2) */
    soi_set_cell(w, 10, 10, 0x1B);                      /* paired OUT */
    {
        int sx = w->players[1].x, sy = w->players[1].y;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].x == sx && w->players[1].y == sy,
              "transporter: a player straddling two columns is NOT teleported (asm straddle guard)");
    }
    /* The zap moves the player by the IN->OUT cell delta (asm FUN_1002bc64: x += dcol*32,
     * y += drow*32), so a player stepping onto the pad off-centre keeps that offset at the OUT. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 2, 2);
    w->players[1].x = (int16_t)(soi_cell_x(2) - 10);   /* col(x+0xc) = col(x+0x12) = 2: on the pad */
    soi_set_cell(w, 2, 2, 0x1A);
    soi_set_cell(w, 10, 10, 0x1B);
    soi_pickup_check(w, 1);
    CHECK(w->players[1].x == soi_cell_x(10) - 10 && w->players[1].y == soi_cell_y(10),
          "transporter: the zap keeps the player's offset within the cell (x += dcol*32)");

    /* ---- 33. Auto wall-rebound reads the PRE-push x for BOTH side checks (asm
     * FUN_10012554 snapshots iVar4=x at entry and uses it for the left (+2) AND right
     * (-2) probes). The port used the already-pushed x for the right probe, so a player
     * wedged against a single wall column drifted +2 instead of jittering in place. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = (int16_t)(soi_cell_x(5) + 11);   /* box occupies 1-based col6; x+0x14=207 is col6's right-edge px, so both rebound probes read col6 */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    soi_set_cell(w, 5, 5, SOI_CELL_SUPPORTIVE);        /* wall at 0-based (5,5) = 1-based (col6,row6): the player's own column, seen by both probes */
    {
        int wx0 = w->players[1].x;
        soi_tick(w, 0, 0);                              /* one fall frame -> wall_rebound */
        CHECK(w->players[1].x == wx0,
              "wall-rebound: a wedged player nets zero x (orig-x used for both probes, asm FUN_10012554)");
    }

    /* ---- 33b. Asymmetric variant closes the net-zero blind spot above: a hypothetical
     * NO-OP wall_rebound would ALSO pass the x==wx0 check. Here a wall sits in ONLY the
     * RIGHT probe column (disjoint from the left), so the right probe must fire ALONE and
     * net -2 -- a no-op rebound would leave x unchanged and FAIL. At x=36 the left probe
     * px_col1(x+0x0a)=col1 while the right probe px_col1(x+0x14)=col2; the wall is only in
     * col2, so the left probe stays clear. (Tests 35/36 already prove the LEFT probe fires
     * +2; this pins the RIGHT probe firing -2.) */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = 36; w->players[1].y = 104;       /* left probe col(x+0x0a)=1, right col(x+0x14)=2 */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    soi_set_cell(w, 1, 1, SOI_CELL_SUPPORTIVE);        /* wall at 0-based (1,1) = 1-based (col2,row2): ONLY the right probe column */
    {
        int wx0 = w->players[1].x;
        soi_tick(w, 0, 0);                              /* one fall frame -> right probe fires -2 */
        CHECK(w->players[1].x == wx0 - 2,
              "wall-rebound: a wall in ONLY the right column pushes -2 (right probe fires, closes the no-op blind spot)");
    }

    /* ---- 34. Building a block over a RISING jumper caps the leap at the apex (asm
     * FUN_10013404: while jump_t < 8 the headroom check FUN_10012444 is re-run every
     * frame; a solid cell overhead snaps jump_t to 0xc). The auto wall-rebound
     * (FUN_10012554) runs ONLY past the rise (jump_t >= 8), never during it. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                        /* clear headroom -> the leap launches */
    soi_tick(w, SOI_IN_JUMP, 0);                   /* edge-trigger the jump */
    CHECK(w->players[1].ground_state == SOI_ST_JUMP && w->players[1].in_air == 1,
          "jumpstall: the leap launches with clear headroom");
    soi_tick(w, 0, 0); soi_tick(w, 0, 0); soi_tick(w, 0, 0);   /* rise: player logic is 30Hz (odd tick only), so exactly ONE of these advances the arc -> jump_t reaches 1 (still <8) */
    CHECK(w->players[1].ground_state == SOI_ST_JUMP && w->players[1].jump_t < 8,
          "jumpstall: still in the rising phase (jump_t < 8)");
    {
        int px = w->players[1].x, py = w->players[1].y;
        int hc  = (px + 0x10 - SOI_ORIGIN_X) >> 5;     /* 0-based headroom probe columns */
        int hc2 = (px + 0x0e - SOI_ORIGIN_X) >> 5;
        int hr  = (py - 2 - SOI_ORIGIN_Y) >> 5;        /* 0-based headroom probe row */
        soi_set_cell(w, hc, hr, SOI_CELL_SUPPORTIVE);
        if (hc2 != hc) soi_set_cell(w, hc2, hr, SOI_CELL_SUPPORTIVE);
        soi_tick(w, 0, 0);                             /* next frame re-checks headroom -> stall */
        CHECK(w->players[1].jump_t == 0xd,
              "jumpstall: a block built overhead mid-rise snaps the jump to the apex (asm sets 0xc, then the unconditional ++ persists 0xd)");
    }

    /* ---- 35. The jump's auto wall-rebound else-branch (asm FUN_10013404: jump_t >= 8
     * runs FUN_10012554, NOT the headroom stall) fires on the PRE-step Y -- the rebound
     * is at asm line 31, BEFORE the jump_t increment (line 33) and the arc y-step (line
     * 38-40). At jump_t = 16 the next step is JUMP_DY[17] = +4, so the pre-step upper
     * probe (row2 at y=104) reaches the wall while the post-step probe (y=108) drops to
     * row3 and misses. The rebound fires (+2) iff the order is pre-step -- the old
     * post-step ordering (rebound inside air_drift, after p->y) would leave x unmoved.
     * This also covers the jump_t >= 8 branch that test 34 (jump_t < 8 stall) does not. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = 160; w->players[1].y = 104;      /* left probe col(x+0x0a)=5, right col(x+0x14)=6 */
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_JUMP; w->players[1].jump_t = 16;
    soi_set_cell(w, 4, 1, SOI_CELL_SUPPORTIVE);        /* wall at 1-based (col5,row2): only the pre-step probe */
    {
        int jx0 = w->players[1].x;
        soi_tick(w, 0, 0);                              /* jump frame, jump_t>=8 -> pre-step wall_rebound else-branch */
        CHECK(w->players[1].x == jx0 + 2,
              "jump-rebound: a jumper (jump_t>=8) rebounds on the PRE-step Y (asm FUN_10013404 line 31 before line 38)");
    }

    /* ---- 36. The gravity FALL runs its auto wall-rebound on the PRE-step Y (asm
     * FUN_1001386c calls FUN_10012554 at line 9, BEFORE the y+=4 at line 19). The port
     * used to rebound AFTER applying p->y (post-step Y), probing rows 4px too low. With
     * a wall placed so ONLY the pre-step upper probe (row2 at y=104) reaches it -- the
     * post-step probes (y=108) fall to row3 and miss -- the rebound fires iff the order
     * is correct. Same wall layout as test 35 but in the FALL state. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = 160; w->players[1].y = 104;
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_FALL;
    soi_set_cell(w, 4, 1, SOI_CELL_SUPPORTIVE);        /* wall at 1-based (col5,row2) */
    {
        int fx0 = w->players[1].x;
        soi_tick(w, 0, 0);                              /* one fall frame -> pre-step wall_rebound */
        CHECK(w->players[1].x == fx0 + 2,
              "fall-rebound: the fall rebounds on the PRE-step Y (asm FUN_1001386c line 9 before line 19)");
    }

    /* ---- 37. headroom_clear probes BOTH upper-body columns (asm FUN_10012444: x+0x10
     * AND x+0x0e). At a non-cell-aligned x the two land in different columns; a wall in
     * ONLY the x+0x0e column must still stall the rise. Guards against dropping the
     * second probe (with only x+0x10 checked, the empty x+0x10 column would read as
     * clear and the leap would not cap). x=32 -> x+0x0e=46=col1, x+0x10=48=col2. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = 32; w->players[1].y = 104;
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_JUMP; w->players[1].jump_t = 3;
    soi_set_cell(w, 0, 1, SOI_CELL_SUPPORTIVE);        /* wall at 1-based (col1,row2): ONLY the x+0x0e probe */
    soi_tick(w, 0, 0);                                  /* rising frame (jump_t<8) -> headroom re-check */
    CHECK(w->players[1].jump_t == 0xd,
          "headroom-2col: a wall in ONLY the x+0x0e column stalls the rise (both columns probed, asm FUN_10012444)");

    /* ---- 38. The RISE (jump_t<8) runs headroom, NOT wall_rebound -- the two are
     * mutually exclusive (asm FUN_10013404: if jump_t<8 headroom else rebound). A side
     * wall placed ONLY in the rebound-LEFT column (which WOULD push +2 if rebound ran)
     * must be ignored while rising. The x is chosen so that column is DISJOINT from both
     * headroom columns, so the wall cannot merely stall the rise instead: at x=162 the
     * rebound-LEFT probe px_col1(x+0x0a)=col5, while BOTH headroom probes px_col1(x+0x10)
     * and px_col1(x+0x0e)=col6 -- the wall in col5 is invisible to headroom. Correct code
     * therefore skips rebound AND finds headroom clear, so the rise advances (jump_t 3->4)
     * with x unchanged. (At x=160 the rebound-LEFT and x+0x0e headroom columns COLLIDE in
     * col5, so the wall would stall the rise and the test would pass for the wrong reason.)
     * If rebound wrongly ran during the rise, x would jump +2 to 164. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 5);
    w->players[1].x = 162; w->players[1].y = 104;
    w->players[1].in_air = 1; w->players[1].ground_state = SOI_ST_JUMP; w->players[1].jump_t = 3;
    soi_set_cell(w, 4, 1, SOI_CELL_SUPPORTIVE);        /* wall at 1-based (col5,row2): ONLY the rebound-LEFT probe */
    {
        int rx0 = w->players[1].x;
        soi_tick(w, 0, 0);                              /* rising frame -> rebound must NOT fire, headroom clear */
        CHECK(w->players[1].x == rx0,
              "rise-no-rebound: a rising jumper (jump_t<8) ignores the side wall (asm FUN_10013404 if/else)");
        CHECK(w->players[1].jump_t == 4,
              "rise-no-rebound: the rise still advances (headroom clear, no stall) -- proves the wall did not cap it");
    }

    /* ---- 39. A player mid DEATH-THROW cannot BUILD or FIRE. asm FUN_1001166c line 13
     * gates the ENTIRE per-player update -- the build (FUN_1002d04c/cf08/d190), the
     * projectile/ball (FUN_100110b4 / FUN_10010d30), AND the movement state machine
     * (the case switch) -- on the death flag +0x28 == 0; when that flag is SET, ONLY
     * the death throw FUN_10011fcc runs. The port already gates the walk-over pickup the
     * same way (test 29); this proves the airborne build/fire dispatch is gated too. A
     * dying player pressing BLOCK must drop NOTHING, yet the death arc must still run. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);                          /* open space, facing right */
    soi_player_hit(w, 1);                              /* launch the somersault (ground_state=DEAD, in_air) */
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 9, 3)) == SOI_CELL_EMPTY,
          "deadbuild: the front build cell (col10,row4) starts empty");
    w->players[1].input = SOI_IN_BLOCK_HIGH;           /* press the high-block key while dying */
    w->players[1].input_prev = 0;                      /* rising edge -> would fire the action */
    {
        int jt0 = w->players[1].jump_t;
        soi_player_update(w, 1);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 9, 3)) == SOI_CELL_EMPTY,
              "deadbuild: a dying player's BLOCK press builds NOTHING (asm FUN_1001166c death-flag gate)");
        CHECK(w->players[1].jump_t != jt0,
              "deadbuild: the death throw still advances while build is gated (death_step ran)");
    }

    /* ---- 40. A DEAD player runs ONLY the death throw, even if in_air is somehow 0.
     * The top-level SOI_ST_DEAD short-circuit in soi_player_update (asm FUN_1001166c
     * line 13) runs death_step and returns BEFORE the grounded !supported->FALL branch
     * and before any build/fire -- so a death-throw can never be converted into a FALL
     * or fire an action, independent of the in_air flag (the port does not lean on the
     * DEAD=>in_air invariant). Force in_air=0 (an off-nominal state) and confirm: the
     * state stays DEAD, the parabola advances (death_step ran), the player did NOT switch
     * to SOI_ST_FALL, and a pressed BLOCK builds nothing. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);
    soi_player_hit(w, 1);                              /* ground_state=DEAD, in_air=1 */
    w->players[1].in_air = 0;                          /* force the off-nominal DEAD && !in_air */
    w->players[1].input = SOI_IN_BLOCK_HIGH;
    w->players[1].input_prev = 0;                      /* rising edge -> would build if not gated */
    {
        int jt0 = w->players[1].jump_t;
        soi_player_update(w, 1);
        CHECK(w->players[1].ground_state == SOI_ST_DEAD,
              "dead-not-fall: a DEAD player with in_air=0 stays in the death throw (top-level DEAD gate)");
        CHECK(w->players[1].jump_t != jt0,
              "dead-not-fall: death_step still ran (parabola advanced), not the FALL/idle path");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 9, 3)) == SOI_CELL_EMPTY,
              "dead-not-fall: the pressed BLOCK built nothing (gated at the top before build)");
    }

    /* ---- 41. FAITHFUL death recovery: reload the whole board. asm FUN_1001f4f8 ->
     * FUN_10029acc -> FUN_1002b448 reloads the board after EVERY death, so the grid,
     * enemies, positions and the per-player Bonus timer all reset while score / lives /
     * ammo / shield persist and the RNG stream continues. Concretely: (A) a Bonus runout
     * costs exactly ONE life and the player respawns with a FRESH clock (not stuck at 0,
     * which used to infinite-kill); (B) a block destroyed before death is REBUILT after it
     * (dying resets the board); (C) the fresh clock means the respawn does not instantly
     * re-die (no infinite cascade); and (D) timing out on the LAST life ends the game
     * (eliminated, never an infinite loop). These need a captured board, so they load a
     * crafted BORD via soi_load_level (P1 (5,9), P2 (9,9), Bonus 200, supportive floor at
     * (5,10)/(9,10)). ---- */
    {
        uint8_t bord[64];
        int guard, lb;

        #define MK_BORD() do { \
            memset(bord, 0, sizeof(bord)); \
            bord[0x07] = 5;  bord[0x09] = 9;    /* P1 col,row */ \
            bord[0x0B] = 9;  bord[0x0D] = 9;    /* P2 col,row */ \
            bord[0x0E] = 0;  bord[0x0F] = 200;  /* Bonus = 200 */ \
            bord[0x1A] = 0x02; bord[0x1B] = 0x07;   /* tile_type 0x0207 (supportive) */ \
            bord[0x1C] = 5;  bord[0x1D] = 10;   /* floor under P1 */ \
            bord[0x1E] = 9;  bord[0x1F] = 10;   /* floor under P2 */ \
            bord[0x20] = 12; bord[0x21] = 10;   /* a lone block, NOT under any player */ \
            bord[0x22] = 100; bord[0x23] = 100; /* sentinel; 0x24.. = 0 -> end of tiles */ \
        } while (0)

        /* (A) one Bonus runout -> exactly one life lost, respawn with a RESET clock. */
        soi_world_init(w, 1);
        MK_BORD();
        CHECK(soi_load_level(w, bord, sizeof(bord)) == 1, "reload41: crafted board loads");
        soi_limit_players(w, 1);                    /* single-player: P2 disabled */
        w->players[1].lives = 3;
        w->players[1].bonus_time = 1;               /* about to time out */
        for (guard = 0; guard < 400 && w->players[1].lives == 3; guard++)
            soi_tick(w, 0, 0);                       /* run the death arc */
        CHECK(w->players[1].lives == 2, "reload41(A): a Bonus runout costs exactly one life");
        for (guard = 0; guard < 200 && !w->players[1].alive; guard++)
            soi_tick(w, 0, 0);                       /* wait out respawn_timer -> board reload */
        CHECK(w->players[1].alive, "reload41(A): the player respawns after the runout");
        CHECK(w->players[1].bonus_time >= 190,
              "reload41(A): the reload RESETS the Bonus clock to ~200 (no infinite kill)");
        CHECK(!w->players[1].eliminated, "reload41(A): still in the game (2 lives left)");
        CHECK(w->players[2].active == 0,
              "reload41(A): the reload keeps a disabled player disabled (single-player P2)");
        CHECK(w->tick > 100,
              "reload41(A): the reload keeps the tick counter monotonic (no reset -> no spurious throw / RNG desync)");

        /* (B) a block destroyed BEFORE death is rebuilt AFTER it (dying resets the board).
         * Smash the LONE block at (12,10) -- the player stays supported on (5,10) -- then
         * force a clean Bonus runout so the death (and reload) fire deterministically. */
        lb = w->players[1].lives;
        soi_set_cell(w, 12, 10, SOI_CELL_EMPTY);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 12, 10)) == SOI_CELL_EMPTY,
              "reload41(B): lone block destroyed pre-death");
        w->players[1].bonus_time = 1;                /* deterministic runout */
        for (guard = 0; guard < 400 && !(w->players[1].alive && w->players[1].lives < lb); guard++)
            soi_tick(w, 0, 0);                        /* die -> reload */
        CHECK(w->players[1].alive && w->players[1].lives == lb - 1,
              "reload41(B): the player died once and respawned");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 12, 10)) != SOI_CELL_EMPTY,
              "reload41(B): the death reload REBUILDS the destroyed block");

        /* (C) the reset clock means the respawn does NOT instantly re-die (no cascade). */
        lb = w->players[1].lives;
        for (guard = 0; guard < 30; guard++) soi_tick(w, 0, 0);
        CHECK(w->players[1].alive && w->players[1].lives == lb,
              "reload41(C): the fresh clock survives many ticks (no infinite cascade)");

        /* (D) timing out on the LAST life ends the game (eliminated), never loops forever. */
        soi_world_init(w, 1);
        MK_BORD();
        soi_load_level(w, bord, sizeof(bord));
        soi_limit_players(w, 1);
        w->players[1].lives = 0;                     /* last life */
        w->players[1].bonus_time = 1;
        for (guard = 0; guard < 400 && !w->players[1].eliminated; guard++)
            soi_tick(w, 0, 0);
        CHECK(w->players[1].eliminated,
              "reload41(D): timing out on the last life ends the game (no infinite loop)");
        #undef MK_BORD
    }

    /* ---- 42. A Magic Ball rolls THROUGH a goodie and stops only on a real wall. The
     * original's projectile solidity predicate is FUN_1000554c -> (cell & 0x200) != 0:
     * it tests ONLY the SUPPORTIVE bit, never PERMANENT (0x100). Treasure goodies live in
     * the 0x9xx range (silver coin 0x90A = 0x900|0x0A), which ALIASES 0x100 but has NO
     * 0x200, so the ball must roll straight over the coin and come to rest flush against
     * the first real 0x200 block. The old `(cell & PERMANENT)` test wrongly stopped the
     * ball dead at any 0x9xx goodie ("b39: balls are blocked by goodies"). ---- */
    {
        int restcol, k;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        w->players[1].facing = 1;                       /* fire rightward */
        w->players[1].balls  = 1;
        soi_set_cell(w, 7, 9, 0x90A);                   /* a real silver-coin goodie (has 0x100, NOT 0x200) in the path */
        soi_set_cell(w, 10, 9, SOI_WALL);               /* a real solid wall further along (has 0x200) */
        soi_ball_fire(w, 1);
        for (k = 0; k < 120 && w->projectiles[0].active; k++)
            soi_projectiles_update(w);
        CHECK(!w->projectiles[0].active, "ballgoody: the ball comes to rest (does not fly forever)");
        restcol = (w->projectiles[0].x + SOI_CELL_PX / 2 - SOI_ORIGIN_X) / SOI_CELL_PX;
        CHECK(restcol == 9,
              "ballgoody: the ball rolls THROUGH the 0x9xx goodie (col 7) and stops flush on the "
              "0x200 wall (col 10) -- solidity is (cell & 0x200), never PERMANENT (asm FUN_1000554c)");
        CHECK(soi_get_cell(w, 7, 9) == 0x90A,
              "ballgoody: the passing ball does NOT consume the goodie it rolls over");
    }

    /* ---- 43. STOP/GO SWITCH (b41): stepping onto a switch TILE (low 0x24-0x2d) toggles
     * its paired block GROUP between SOLID and PASSABLE. asm chain: FUN_1002bc64:593 fires
     * the toggle when the player ENTERS a new cell whose low byte is 0x24-0x2d ->
     * FUN_10016544 -> FUN_100166b8 (state flip) -> per-frame FUN_10016784 (open/close
     * animator: an OPENING block stays SOLID until the ~9-frame anim completes, THEN turns
     * passable; a CLOSING block turns solid immediately). Group g: tile low (0x24+2g),
     * block low SOLID (0x9d+12g) / PASSABLE (0xa3+12g). The switch BLOCKS are registered by
     * a post-load grid scan (FUN_1002de00 reads cell & 0xff). The port previously no-op'd
     * this ("cosmetic"); it is a REAL path-gate. ("b41: falling into switch doesn't change
     * the switch animation") ---- */
    {
        uint8_t bord[96];
        int guard, off;
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 3;  bord[0x09] = 9;     /* P1 col,row = (3,9) */
        bord[0x0B] = 9;  bord[0x0D] = 9;     /* P2 (disabled below) */
        bord[0x0E] = 0;  bord[0x0F] = 200;   /* Bonus 200 */
        off = 0x18;
        /* floor 0x0207 (supportive) across row 10, cols 3..6 (the walkway) */
        bord[off]=0;bord[off+1]=0;bord[off+2]=0x02;bord[off+3]=0x07; off+=4;
        bord[off++]=3; bord[off++]=10;
        bord[off++]=4; bord[off++]=10;
        bord[off++]=5; bord[off++]=10;
        bord[off++]=6; bord[off++]=10;
        bord[off++]=100; bord[off++]=100;
        /* switch TILE group 0 (0x0924, low 0x24) at (4,9) -- walk-on */
        bord[off]=0;bord[off+1]=0;bord[off+2]=0x09;bord[off+3]=0x24; off+=4;
        bord[off++]=4; bord[off++]=9;
        bord[off++]=100; bord[off++]=100;
        /* switch BLOCK group 0 SOLID (0x039d, low 0x9d) at (6,9) */
        bord[off]=0;bord[off+1]=0;bord[off+2]=0x03;bord[off+3]=0x9d; off+=4;
        bord[off++]=6; bord[off++]=9;
        bord[off++]=100; bord[off++]=100;
        /* type==0 terminator already present (zeroed tail) */

        soi_world_init(w, 1);
        CHECK(soi_load_level(w, bord, sizeof(bord)) == 1, "switch: crafted board loads");
        soi_limit_players(w, 1);
        CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) != 0,
              "switch: the group-0 block loads SOLID (0x200 set)");
        /* walk RIGHT from (3,9): the player's centre enters the switch tile at (4,9),
         * toggling the group; the block then OPENS (solid through the anim, then passable). */
        for (guard = 0; guard < 60 && (soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE); guard++)
            soi_tick(w, SOI_IN_RIGHT, 0);
        CHECK(!(soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE),
              "switch: stepping the switch tile OPENS the paired block (now PASSABLE, 0x200 clear)");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 4, 9)) == 0x25u,
              "switch: the stepped tile flips its Stop/Go sign (low 0x24 -> 0x25)");

        /* (B) the entry emits the switch sound UNCONDITIONALLY (asm FUN_1002bc64 plays
         * evt 0x2c right after the toggle, not gated on a block flipping). */
        {
            int heard = 0, k;
            soi_world_init(w, 1);
            soi_load_level(w, bord, sizeof(bord));
            soi_limit_players(w, 1);
            for (guard = 0; guard < 60 && !heard; guard++) {
                soi_tick(w, SOI_IN_RIGHT, 0);
                for (k = 0; k < soi_sfx_count(w); k++)
                    if (soi_sfx_get(w, k) == SOI_SFX_SWITCH) heard = 1;
            }
            CHECK(heard, "switch: stepping the tile plays the switch sound (asm evt 0x2c)");
        }
        /* (C) a PASSABLE-variant block (low 0xa3, rem 6) loads PASSABLE (asm case 0xa3 ->
         * state 1, cell = passcode|0x100: PERMANENT but NOT supportive). */
        {
            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            soi_set_cell(w, 5, 9, 0x300u | 0xa3u);   /* BORD ships it flagged; the scan normalises */
            soi_switch_load_scan(w);
            CHECK(!(soi_get_cell(w, 5, 9) & SOI_CELL_SUPPORTIVE),
                  "switch: a rem-6 block (low 0xa3) loads PASSABLE (state 1, no 0x200)");
            CHECK((soi_get_cell(w, 5, 9) & SOI_CELL_PERMANENT) != 0,
                  "switch: a passable switch block is still PERMANENT (0x100)");
            /* a low in 0x9d..0xd3 that is NOT a real switch code (rem != 0,6) is ignored */
            soi_set_cell(w, 8, 9, 0x300u | 0xa0u);   /* rem 3: not a switch block */
            soi_switch_load_scan(w);
            CHECK(soi_get_cell(w, 8, 9) == (0x300u | 0xa0u),
                  "switch: a non-switch low in 0x9d..0xd3 (rem 3) is left untouched");
        }
        /* (D) the open/close state machine end-to-end (asm FUN_100166b8/FUN_10016784),
         * driving the toggle+animate directly to reach the CLOSE path the walk cannot. */
        {
            int k;
            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            soi_set_cell(w, 7, 9, 0x300u | 0x9du);   /* group-0 SOLID variant */
            soi_switch_load_scan(w);
            CHECK((soi_get_cell(w, 7, 9) & SOI_CELL_SUPPORTIVE) != 0, "switch: (D) loads SOLID");
            soi_switch_toggle(w, 0x24);              /* open group 0 (state 2 -> 3) */
            soi_switch_animate(w);
            CHECK((soi_get_cell(w, 7, 9) & SOI_CELL_SUPPORTIVE) != 0,
                  "switch: (D) a block is SOLID during the opening swing");
            for (k = 0; k < 12; k++) soi_switch_animate(w);
            CHECK(!(soi_get_cell(w, 7, 9) & SOI_CELL_SUPPORTIVE),
                  "switch: (D) the block is PASSABLE once the open completes");
            soi_switch_toggle(w, 0x24);              /* close group 0 (state 1 -> 4) */
            soi_switch_animate(w);
            CHECK((soi_get_cell(w, 7, 9) & SOI_CELL_SUPPORTIVE) != 0,
                  "switch: (D) closing turns the block SOLID immediately");
            for (k = 0; k < 12; k++) soi_switch_animate(w);
            CHECK((soi_get_cell(w, 7, 9) & SOI_CELL_SUPPORTIVE) != 0,
                  "switch: (D) the block stays SOLID after the close settles");
        }
    }

    /* ---- 44. Persistent SPAWNERS are STATIONARY. The asm spawner dispatchers
     * (e.g. FUN_100076a8) never write their own X/Y and never call the gravity
     * predicate FUN_10005750 -- they hold their placed cell and emit children on a
     * timer (enemy_spawner_emit, dispatched separately after enemy_step). A spawner
     * placed with OPEN AIR beneath it (as on Board 44, a Piggy at c0,r9 with an
     * empty column below) must NOT fall straight down onto -- and kill -- the player
     * beneath it. The emitted CHILD nasty IS a normal walker and still falls
     * (positive control below), so the gravity path stays intact. ---- */
    {
        int ei, wc, t, sx0, sy0, wy0, before, after, k;
        int hi, hx0, hy0;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 16, 11);                          /* player parked far from the spawner */
        ground_player(w, 16, 12);
        ei = soi_enemy_spawn(w, SOI_ENEMY_PIGGY, 5, 5);      /* mid-air: no floor in the column below */
        CHECK(ei >= 0, "spawner-static: piggy spawner placed");
        w->enemies[ei].spawn_child = (uint8_t)SOI_ENEMY_PIGGY;   /* loader marks a spawner this way */
        w->enemies[ei].vx = 0;                               /* loader zeroes vx for a spawner (soi_state.c) */
        w->enemies[ei].fire_period = 9000;                   /* 9000 = keep it from emitting during THIS window */
        w->enemies[ei].fire_cd     = 9000;                   /*        so we isolate the "does it fall?" check */
        sx0 = w->enemies[ei].x;
        sy0 = w->enemies[ei].y;
        for (t = 0; t < 8; t++) soi_enemies_update(w);
        CHECK(w->enemies[ei].active,
              "spawner-static: a mid-air spawner is NOT killed/deactivated");
        CHECK(w->enemies[ei].y == sy0,
              "spawner-static: a mid-air spawner holds its placed ROW (does NOT fall)");
        CHECK(w->enemies[ei].x == sx0,
              "spawner-static: a mid-air spawner holds its placed COLUMN (does NOT drift)");

        /* the early return must NOT suppress EMISSION (dispatched after enemy_step):
         * arm a short fuse and confirm a child nasty appears within a few frames. */
        before = 0;
        for (k = 0; k < SOI_MAX_ENEMIES; k++) if (w->enemies[k].active) before++;
        w->enemies[ei].fire_period = 6;
        w->enemies[ei].fire_cd     = 1;
        for (t = 0; t < 3; t++) soi_enemies_update(w);
        after = 0;
        for (k = 0; k < SOI_MAX_ENEMIES; k++) if (w->enemies[k].active) after++;
        CHECK(after > before,
              "spawner-static: a stationary spawner STILL emits children (emit survives the early return)");

        /* HAMMER is the ONE spawner type gated by an EARLIER early-return
         * (enemy_hammer_hop, line ~530, guarded by `&& spawn_child == 0`). A HAMMER
         * SPAWNER must skip BOTH the hop and the fall -- it holds its exact cell.
         * This case fails if that spawn_child==0 guard is ever dropped: a mis-routed
         * hammer would hop (move in x) and/or fall off the mid-air ledge. Fresh world
         * so the PIGGY spawner's emitted children above don't perturb it. */
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 16, 11);
        ground_player(w, 16, 12);
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 8, 5);     /* mid-air: open column below */
        CHECK(hi >= 0, "spawner-static: hammer spawner placed");
        w->enemies[hi].spawn_child = (uint8_t)SOI_ENEMY_HAMMER;
        w->enemies[hi].vx = 0;
        w->enemies[hi].fire_period = 9000;
        w->enemies[hi].fire_cd     = 9000;
        hx0 = w->enemies[hi].x;
        hy0 = w->enemies[hi].y;
        for (t = 0; t < 8; t++) soi_enemies_update(w);
        CHECK(w->enemies[hi].y == hy0,
              "spawner-static: a HAMMER spawner does NOT fall (skips both hammer-hop and gravity)");
        CHECK(w->enemies[hi].x == hx0,
              "spawner-static: a HAMMER spawner does NOT hop/drift (line-530 spawn_child guard holds)");

        /* positive control: the SAME type as the SUT (PIGGY) but WITHOUT the spawner
         * flag (spawn_child == 0, zero-inited by soi_enemy_spawn) DOES fall -- so
         * spawn_child is the only variable and the fall path is genuinely reachable
         * for a PIGGY (not vacuously exempt like a Beanie). */
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 16, 11);
        ground_player(w, 16, 12);
        wc = soi_enemy_spawn(w, SOI_ENEMY_PIGGY, 5, 5);      /* SAME cell + SAME type as the SUT */
        CHECK(wc >= 0, "spawner-static: control piggy placed");
        wy0 = w->enemies[wc].y;
        for (t = 0; t < 8; t++) soi_enemies_update(w);
        CHECK(w->enemies[wc].y > wy0,
              "spawner-static: a PIGGY with spawn_child==0 still falls (gravity path reachable for this type)");
    }

    /* ---- 45. WALL-FOLLOWER BALL (asm FUN_1000fd5c, +0x54==2 fired-right /
     * +0x54==3 fired-left): the player's spinning ball is a 4-state TERRAIN
     * FOLLOWER (dir +0x52: 1=L/2=U/3=R/4=D), NOT the bare straight roller the port
     * had. Rolling RIGHT along a floor that ENDS mid-field (a cliff), the asm
     * state-3 handler sees the floor drop from under its leading edge -- S(0,+0x19)
     * and S(+0x19,+0x19) clear while S(-2,+0x19) (floor just behind) is still solid
     * -- and turns DOWN (+0x52=4, orig FUN_1000fd5c lines 285-312) to hug the cliff
     * face. The old port probed only the single cell dead ahead, so at a ledge it
     * flew straight off into open air (and out of the field). Regression guard for
     * the user's "ball goes straight off a cliff / out of bounds" report. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 7);
    w->players[1].y = (int16_t)(soi_cell_y(7) + 1);     /* stand on the row-8 floor; body row 7 stays empty */
    w->players[1].arrows = 1;
    w->players[1].facing = 1;                           /* fire RIGHT */
    { int c; for (c = 1; c <= 7; c++) soi_set_cell(w, c, 8, 0x300u); }   /* floor cols 1..7, row 8; then a cliff (cols 8+ open) */
    act_press(w, SOI_IN_BALL);                          /* fire the wall-follower ball */
    CHECK(soi_projectile_count(w) == 1 && soi_projectile_kind(w, 0) == 0,
          "wall-ball: a kind-0 follower is in flight after firing right");
    {
        int by0   = soi_projectile_y(w, 0);
        int brow0 = (by0 + 0xc - SOI_ORIGIN_Y) / SOI_CELL_PX;    /* the ball's body row at spawn */
        int t, brow1;
        for (t = 0; t < 160 && soi_projectile_count(w) == 1; t++)
            soi_projectiles_update(w);                  /* advance ONLY the ball (isolate from player physics) */
        brow1 = (soi_projectile_y(w, 0) + 0xc - SOI_ORIGIN_Y) / SOI_CELL_PX;
        CHECK(soi_projectile_count(w) == 1,
              "wall-ball: still in flight after reaching the cliff (did not fly off-field and fizzle)");
        CHECK(brow1 > brow0,
              "wall-ball: TURNS DOWN to follow the cliff edge (row increases), never straight off the ledge");
    }

    /* ---- 46. IDLE X-SNAP (asm idle handler FUN_100128f8 line 21: an idle player's
     * physics x is snapped to a 4 px boundary EVERY idle frame, BEFORE the support
     * check at line 37). The port previously snapped x ONLY on a RUN->IDLE release
     * (soi_physics.c settle branch, gated on ground_state==RUN), so a player who
     * LANDS from the air at a 2-off-grid x (air-steer / wall-rebound / an off-grid
     * spawn) kept that odd x while idle -- and if a block then broke under him he
     * fell from an x that was NOT aligned to the block column (the user's "doesn't
     * fall quite straight DOWN the column"). This drives the realistic path: fall,
     * land 2 px off the 4 px grid, then settle -> x must snap to the grid. ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 3);
    soi_set_cell(w, 7, 6, SOI_CELL_SUPPORTIVE);
    soi_set_cell(w, 8, 6, SOI_CELL_SUPPORTIVE);
    soi_set_cell(w, 9, 6, SOI_CELL_SUPPORTIVE);       /* floor strip at row 6 to land on */
    w->players[1].x = (int16_t)(soi_cell_x(8) + 2);   /* 274: 2 px off the 4 px grid (274 & 3 == 2) */
    w->players[1].y = 180;                            /* above the row-6 floor */
    w->players[1].in_air = 1;
    w->players[1].ground_state = SOI_ST_FALL;
    CHECK((w->players[1].x & 3) == 2, "idle-snap: player starts 2 px off the 4 px grid");
    {
        int t, landed = 0;
        for (t = 0; t < 60; t++) {
            soi_tick(w, 0, 0);                        /* NO input: pure fall -> land -> settle */
            if (!w->players[1].in_air) { landed++; if (landed >= 4) break; }
        }
        CHECK(w->players[1].in_air == 0 && w->players[1].ground_state == SOI_ST_IDLE,
              "idle-snap: player fell and settled to IDLE on the floor");
        CHECK((w->players[1].x & 3) == 0,
              "idle-snap: an idle (just-landed) player's x is snapped to the 4 px grid (asm FUN_100128f8)");
    }

    /* ---- 46b. CONTROL for the IDLE gate on the x-snap. The snap above is gated
     * `ground_state == SOI_ST_IDLE`; drop that gate (snap on EVERY grounded frame) and a
     * player holding a direction gets rounded back DOWN 2 px on every frame his x lands
     * 2 off the grid -- the +2 run sub-step is undone the next frame and he stalls. So a
     * long hold must carry him a full run's worth of pixels, proving the running 2 px
     * sub-steps survive (asm FUN_10012bf4 moves x in raw 2 px steps while a direction is
     * held; it does not 4 px-align it). Without the gate this CHECK fails (x barely moves).
     * Geometry: floor one row BELOW the body (row 10) so the support probe holds him while
     * the body row (9) stays CLEAR -- a same-row floor also reads as a wall and stalls the
     * run in place (verified empirically; cf. the switch/coinpickup tests). */
    {
        int t, x0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        for (t = 1; t <= 20; t++) soi_set_cell(w, t, 10, SOI_CELL_SUPPORTIVE);  /* floor one row below */
        for (t = 0; t < 4; t++) soi_tick(w, 0, 0);   /* settle onto the floor (idle) */
        x0 = w->players[1].x;
        for (t = 0; t < 40; t++) soi_tick(w, SOI_IN_RIGHT, 0);                 /* HOLD right */
        CHECK(w->players[1].ground_state == SOI_ST_RUN,
              "idle-snap control: a player holding a direction is RUN, not IDLE (the snap gate is off)");
        CHECK(w->players[1].x - x0 >= 20,
              "idle-snap control: a RUNNING player advances a full run (2 px sub-steps not snap-stalled) -- proves the IDLE gate");
    }

    /* ---- 47. NEW-GAME stats per play mode (asm FUN_1002b060). Every player starts with
     * 2 lives / 1 arrow / 1 ball (refs/images board_1+3 solo HUD read 02 / 01 / 01); only
     * COOPERATE's shared pool in player 1 gets 4 / 2 / 2. The port used to start a solo game
     * on 4 lives + 2 + 2 -- two free lives the original never gives. */
    {
        soi_world_init(w, 1);
        CHECK(w->players[1].lives == 2 && w->players[1].arrows == 1 && w->players[1].balls == 1,
              "newgame: world_init defaults = the One-Player new game (2 lives, 1 arrow, 1 ball)");
        CHECK(soi_play_mode(w) == SOI_MODE_ONE, "newgame: world_init resets to One Player");
        w->players[1].score = 99;
        soi_new_game(w, SOI_MODE_ONE);
        CHECK(w->players[1].lives == 2 && w->players[1].arrows == 1 && w->players[1].balls == 1 &&
              w->players[1].score == 0, "newgame: One Player = 2 / 1 / 1, score 0");
        soi_new_game(w, SOI_MODE_COMPETE);
        CHECK(w->players[1].lives == 2 && w->players[2].lives == 2 && w->players[2].arrows == 1,
              "newgame: Compete = each player 2 / 1 / 1");
        soi_new_game(w, SOI_MODE_COOPERATE);
        CHECK(w->players[1].lives == 4 && w->players[1].arrows == 2 && w->players[1].balls == 2,
              "newgame: Cooperate = shared pool 4 / 2 / 2 in player 1");
    }

    /* ---- 48. COOPERATE shared pool: every credit lands in player 1's slot (asm
     * `if (!DAT_100370e4) player = 1` in FUN_1002bc64 / FUN_1000e9c8 / FUN_10010d30 /
     * FUN_10011428 ...), so P2's coins, ammo and deaths all hit the one team pool. */
    {
        int t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 9);
        reset_player(w, 2, 6, 9);
        soi_new_game(w, SOI_MODE_COOPERATE);
        soi_set_cell(w, 6, 9, 0x090Au);                  /* silver coin under P2 */
        soi_pickup_check(w, 2);
        CHECK(w->players[1].score == 500 && w->players[2].score == 0,
              "coop: P2's coin is credited to the team pool (player 1)");
        soi_set_cell(w, 6, 9, 0x0911u);                  /* arrow ammo under P2 */
        soi_pickup_check(w, 2);
        CHECK(w->players[1].arrows == 3, "coop: P2's ammo pickup fills the pool");
        soi_set_cell(w, 6, 9, 0x090Du);                  /* 3x multiplier under P2 */
        soi_pickup_check(w, 2);
        CHECK(w->players[1].mult == 3, "coop: P2's multiplier sets the pool multiplier");
        soi_projectile_fire(w, 2);
        CHECK(w->players[1].arrows == 2 && soi_projectile_count(w) == 1,
              "coop: P2 fires from the pool's arrows");
        CHECK(w->players[1].no_weapons_reward == 0, "coop: P2 firing forfeits the team No-Weapons Reward");
        /* P2 is hit -> its death-throw ends in the pool losing the life (P1 stands on a floor) */
        ground_player(w, 2, 9);
        w->players[2].pose_t = 0; w->players[2].invuln = 0;
        soi_player_hit(w, 2);
        for (t = 0; t < 200 && w->players[2].alive; t++) soi_tick(w, 0, 0);
        CHECK(w->players[1].lives == 3 && !w->players[2].eliminated,
              "coop: P2's death debits the shared pool (4 -> 3)");
    }

    /* ---- 48b. COOPERATE key + door: the key is shared (asm DAT_1003ab6c == 0 sets both
     * players' key flag) and the door-exit has NO held-key test, so the partner of the
     * collector can leave; the team pool is tallied once. COMPETE keeps the key private. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 9);
        reset_player(w, 2, 6, 9);
        soi_new_game(w, SOI_MODE_COOPERATE);
        w->players[1].bonus_time = 1000; w->players[1].mult = 2;
        soi_set_cell(w, 12, 9, 0x0904u);                 /* lock for key 7 */
        soi_set_cell(w, 2, 9, 0x0907u);                  /* key 7 under P1 */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1 && w->players[2].has_key == 1,
              "coop: the collected key is shared by both players");
        w->players[2].x = soi_cell_x(12);
        soi_pickup_check(w, 2);
        CHECK(soi_level_complete(w) == 1 && w->players[2].has_key == 2,
              "coop: P2 exits through the door P1's key opened");
        CHECK(w->players[1].score == 2000 && w->players[2].score == 0,
              "coop: the team pool bonus (1000 x 2) is tallied once, into player 1");

        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 2, 9);
        reset_player(w, 2, 6, 9);
        soi_new_game(w, SOI_MODE_COMPETE);
        soi_set_cell(w, 2, 9, 0x0908u);                  /* P1's own key 8 */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1 && w->players[2].has_key == 0,
              "compete: the key stays with its collector");
    }

    /* ---- 48c. Door exit requires the box NOT to straddle two rows (asm FUN_1002bc64:
     * row(y) == row(y+0x10)), and no longer needs a held key. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 10, 9);
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].y = soi_cell_y(9) - 12;            /* box top in row 8, pickup centre in row 9 */
        soi_pickup_check(w, 1);
        CHECK(soi_level_complete(w) == 0, "door: a row-straddling box does not exit");
        w->players[1].y = soi_cell_y(9) + 1;             /* standing in the door row */
        soi_pickup_check(w, 1);
        CHECK(soi_level_complete(w) == 1, "door: an aligned box exits (no held-key test in the asm)");
    }

    /* ---- 49. Shield potion (0x30) and speed shoes (0x32) share ONE power-up slot (asm
     * FUN_10014c28 / FUN_10014ccc write the same mode +0x5c and timer +0x6e), so picking
     * one up cancels the other instead of stacking. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        soi_set_cell(w, 4, 9, 0x0930u);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].invuln == 600 && w->players[1].fast == 0, "powerup: shield on");
        soi_set_cell(w, 4, 9, 0x0932u);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].fast == 1200 && w->players[1].invuln == 0, "powerup: shoes replace the shield");
        soi_set_cell(w, 4, 9, 0x0930u);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].invuln == 600 && w->players[1].fast == 0, "powerup: shield replaces the shoes");
    }

    /* ---- 49b. A speed-shoes player samples input EVERY frame (asm FUN_10028a0c drops the
     * divider to 1 while +0x5c == 1); a normal player keeps the 2-frame latch. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        reset_player(w, 2, 8, 9);
        w->players[1].fast = 1200;
        soi_tick(w, 0, 0);                                /* tick 1 (odd): latch 0 */
        soi_tick(w, SOI_IN_RIGHT, SOI_IN_RIGHT);          /* tick 2 (even) */
        CHECK(w->players[1].input == SOI_IN_RIGHT, "shoes latch: the fast player reads input on the even frame");
        CHECK(w->players[2].input == 0, "shoes latch: a normal player still holds the odd-frame latch");
    }

    /* ---- 50. CHALLENGE ROUND = a board holding a Knight or Gargoyle (asm FUN_10017a70 ->
     * DAT_1003ad0e; every 10th campaign board 410..500). A death there spends NO life and does
     * not reload: the round fails (FUN_10016f80 restores the board-start stats, the board is
     * skipped). An exit pays Bonus x mult but NOT the No-Weapons Reward (no FUN_100153d0 tally). */
    {
        int t;
        uint8_t bord[0x28];
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 3; bord[0x09] = 9;          /* P1 spawn (3,9) */
        bord[0x18] = 0x28; bord[0x19] = 0x14; bord[0x1A] = 0x05; bord[0x1B] = 0x0E;   /* Gargoyle spawn block */
        bord[0x1C] = 12; bord[0x1D] = 3;         /* at (12,3) */
        bord[0x1E] = 0x64; bord[0x1F] = 0x64;    /* record end; a 0 tile then ends the body */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(soi_challenge_round(w) == 1, "challenge: a Gargoyle on the board makes it a Challenge Round");
        soi_limit_players(w, 1);
        w->pct_badguy = 0;
        ground_player(w, 3, 10);
        w->players[1].lives = 0;                 /* even the LAST life is safe in a challenge */
        soi_player_hit(w, 1);
        for (t = 0; t < 300 && w->players[1].alive; t++) soi_tick(w, 0, 0);
        CHECK(w->players[1].lives == 0 && !w->players[1].eliminated && w->players[1].respawn_timer == 0,
              "challenge: a death spends no life and schedules no reload");
        CHECK(soi_challenge_failed(w) == 1 && soi_game_over(w) == 0,
              "challenge: the round FAILS (not game over)");

        memset(bord, 0, sizeof(bord));
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(soi_challenge_round(w) == 0 && soi_challenge_failed(w) == 0,
              "challenge: an ordinary board is not a Challenge Round");

        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0; w->challenge = 1;
        reset_player(w, 1, 10, 9);
        w->players[1].bonus_time = 1000; w->players[1].mult = 2; w->players[1].no_weapons_reward = 5000;
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        soi_pickup_check(w, 1);
        CHECK(soi_level_complete(w) == 1 && w->players[1].score == 2000,
              "challenge: the exit pays Bonus x mult only (no No-Weapons Reward)");
    }

    /* ---- 51. The Gargoyle PUFF (asm FUN_1000b0a4) passes through its CAGE blocks (permanent,
     * low 0x8b) and has no range limit; any other permanent block stops it. ---- */
    {
        int t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        memset(&w->projectiles[0], 0, sizeof(w->projectiles[0]));
        w->projectiles[0].active = 1; w->projectiles[0].hostile = 1;
        w->projectiles[0].src_type = SOI_ENEMY_GARGOYLE;
        w->projectiles[0].x = soi_cell_x(16); w->projectiles[0].y = soi_cell_y(5);
        w->projectiles[0].vx = -4;
        soi_set_cell(w, 15, 5, 0x38Bu);                  /* cage block */
        soi_set_cell(w, 2, 5, 0x307u);                   /* ordinary permanent wall */
        for (t = 0; t < 200 && w->projectiles[0].active; t++) soi_tick(w, 0, 0);
        CHECK(!w->projectiles[0].active && w->projectiles[0].x < soi_cell_x(4) &&
              soi_get_cell(w, 15, 5) == 0x38Bu,
              "puff: flies through the 0x8b cage and on across the board until a real wall");
    }

    /* ---- 52. The Cannon and the persistent spawners have NO touch hurtbox (asm box top parked
     * at 1000 in FUN_100071a0 / FUN_100076a8 &c); instead the Cannon's cell becomes a solid 0x300
     * wall and a spawner's a permanent 0x100 marker (their init stamps). ---- */
    {
        uint8_t bord[0x28];
        int ci = -1, si = -1, k, t;
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 3; bord[0x09] = 9;
        bord[0x18] = 0x28; bord[0x19] = 0x14; bord[0x1A] = 0x06; bord[0x1B] = 0x01;   /* Cannon */
        bord[0x1C] = 10; bord[0x1D] = 5; bord[0x1E] = 0x64; bord[0x1F] = 0x64;
        bord[0x20] = 0x28; bord[0x21] = 0x14; bord[0x22] = 0x06; bord[0x23] = 0x13;   /* Piggy spawner */
        bord[0x24] = 14; bord[0x25] = 5; bord[0x26] = 0x64; bord[0x27] = 0x64;
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        for (k = 0; k < SOI_MAX_ENEMIES; k++) {
            if (!w->enemies[k].active) continue;
            if (w->enemies[k].type == SOI_ENEMY_CANNON) ci = k;
            else if (w->enemies[k].spawn_child) si = k;
        }
        CHECK(ci >= 0 && si >= 0 && soi_get_cell(w, 10, 5) == SOI_WALL && soi_get_cell(w, 14, 5) == SOI_CELL_PERMANENT,
              "stamps: the Cannon cell is a 0x300 wall, the spawner cell a 0x100 marker");
        soi_limit_players(w, 1);
        w->players[1].x = w->enemies[si].x; w->players[1].y = w->enemies[si].y;
        w->players[1].in_air = 0; w->players[1].ground_state = SOI_ST_IDLE;
        soi_set_cell(w, 14, 6, SOI_WALL);
        w->players[1].invuln = 0;
        for (t = 0; t < 4; t++) soi_tick(w, 0, 0);
        CHECK(w->players[1].ground_state != SOI_ST_DEAD, "stamps: standing in a spawner's cell does not hurt");
    }

    /* ---- 53. Enemy walking pace matches the asm step counters (+0x6c): a Robo steps every
     * 2 frames x 2 px = 1 px/frame (the refs video: ~52 px/s at ~52 fps); the Walker steps
     * every 3 frames x 1 px. ---- */
    {
        int ri, wi, c, t, rx0, wx0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        for (c = 0; c < 18; c++) { soi_set_cell(w, c, 10, SOI_WALL); soi_set_cell(w, c, 13, SOI_WALL); }
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 2, 9);
        wi = soi_enemy_spawn(w, SOI_ENEMY_WALKER, 2, 12);
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 1;
        w->enemies[wi].fire_cd = 10000;
        rx0 = w->enemies[ri].x; wx0 = w->enemies[wi].x;
        for (t = 0; t < 60; t++) soi_enemies_update(w);
        CHECK(w->enemies[ri].x - rx0 == 60, "pace: the Robo walks 1 px/frame (60 px in 60 frames)");
        CHECK(w->enemies[wi].x - wx0 == 20, "pace: the Walker walks 1 px per 3 frames (20 px in 60)");
    }

    /* ---- 54. Turn-arounds, the vertical Beanie and per-type hurtboxes (asm +0x4c 5/6,
     * FUN_10006840, +0x7e..0x84). ---- */
    {
        int ai, vi, t, y0, x0, k;
        /* Ant: stands for 16 steps after the step it meets a wall on (FUN_1000602c). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        for (k = 0; k < 18; k++) soi_set_cell(w, k, 10, SOI_WALL);
        ai = soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
        soi_set_cell(w, 6, 9, SOI_WALL);
        w->enemies[ai].x += 0x20 - 0x24 + 1;          /* x+0x24 just inside col 6 */
        soi_enemies_update(w);
        CHECK(w->enemies[ai].dir == 1 && w->enemies[ai].turn == 16, "turn: an Ant starts a 16-step turn at a wall");
        x0 = w->enemies[ai].x;
        for (t = 0; t < 32; t++) soi_enemies_update(w);
        CHECK(w->enemies[ai].x == x0 && w->enemies[ai].turn == 0, "turn: it stands still through the turn");
        soi_enemies_update(w); soi_enemies_update(w);
        CHECK(w->enemies[ai].x == x0 - 2, "turn: then walks the other way");

        /* Vertical Beanie (bord 8): moves DOWN 2 px a step, buds into a breakable block below. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        vi = soi_enemy_spawn(w, SOI_ENEMY_BEANIE, 8, 4);
        w->enemies[vi].state = 8; w->enemies[vi].dir = 2;
        soi_set_cell(w, 8, 7, SOI_CELL_SUPPORTIVE | 0x07);
        y0 = w->enemies[vi].y;
        for (t = 0; t < 10; t++) soi_enemies_update(w);
        CHECK(w->enemies[vi].y == y0 + 10 && w->enemies[vi].x == soi_cell_x(8), "vbeanie: floats straight down 2 px per step");
        for (t = 0; t < 200 && !w->enemies[vi].bud; t++) soi_enemies_update(w);
        CHECK(w->enemies[vi].bud > 0 && w->enemies[vi].y + 2 + 0x1e >= soi_cell_y(7), "vbeanie: buds at the breakable block below");
        for (t = 0; t < 80 && w->enemies[vi].bud; t++) soi_enemies_update(w);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 8, 7)) == 0, "vbeanie: its bud smashes the block below");

        /* Hurtbox: the Ant is a low 16 px nasty (box y+0x10..y+0x20 in its cell), so a player
         * whose box sits entirely above that band is not hit. */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 5, 9);
        for (k = 0; k < 18; k++) soi_set_cell(w, k, 10, SOI_WALL);
        ai = soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
        w->enemies[ai].vx = 0; w->enemies[ai].turn = 200;
        w->players[1].invuln = 0;
        w->players[1].y = soi_cell_y(9) - 0x0e;       /* player box bottom (y+0x1d) at cell y+0x0f */
        soi_enemies_update(w);
        CHECK(w->players[1].ground_state != SOI_ST_DEAD, "hurtbox: the Ant's low box misses a player above it");
        w->players[1].y = soi_cell_y(9) + 1;
        soi_enemies_update(w);
        CHECK(w->players[1].ground_state == SOI_ST_DEAD, "hurtbox: the Ant hits a player standing on its row");

        /* Hammer heading LEFT into a breakable block: the swing art is placed 12 px left
         * (FUN_10007998 x -= 0xc / += 0xc) and the smash lands on col(x+4). */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 15, 1);
        for (k = 0; k < 18; k++) soi_set_cell(w, k, 10, SOI_WALL);
        vi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 6, 9);
        w->enemies[vi].dir = 1; w->enemies[vi].vx = -2;
        w->enemies[vi].x -= 6;                         /* x+4 inside col 5 */
        soi_set_cell(w, 5, 9, 0x207u);
        x0 = w->enemies[vi].x;
        soi_enemies_update(w);
        CHECK(w->enemies[vi].x == x0 - 12 && w->enemies[vi].fire_cd == 1, "hammer: the left swing starts 12 px left");
        for (t = 0; t < 40 && w->enemies[vi].fire_cd; t++) soi_enemies_update(w);
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) == 0 && w->enemies[vi].x == x0, "hammer: smashes the block and steps back");
    }

    /* ---- 55. Weapons hit by box (FUN_100030d4): a persistent spawner has no box, so the
     * wall-follower passes through its cell and it keeps emitting. ---- */
    {
        int si, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 3, 9);
        ground_player(w, 3, 9);
        w->players[1].arrows = 1; w->players[1].facing = 1;
        for (t = 0; t < 18; t++) soi_set_cell(w, t, 10, SOI_WALL);
        si = soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 6, 9);
        w->enemies[si].spawn_child = (uint8_t)SOI_ENEMY_HIPPO;
        w->enemies[si].vx = 0; w->enemies[si].fire_period = 30000; w->enemies[si].fire_cd = 30000;
        soi_tick(w, SOI_IN_BALL, 0);
        for (t = 0; t < 120; t++) soi_tick(w, 0, 0);
        CHECK(w->enemies[si].active, "weapon: a spawner cannot be shot (no hurtbox)");
    }

    /* ---- 56. Cannon ball (FUN_100071a0 spawn x+0x1c,y+8; mover FUN_1000744c): waits 2 frames,
     * then flies 4 px/frame, smashes the first breakable block and dies there. ---- */
    {
        int ci, pi = -1, t, x0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 1, 1);
        ci = soi_enemy_spawn(w, SOI_ENEMY_CANNON, 3, 9);
        w->enemies[ci].dir = 2; w->enemies[ci].fire_cd = 0; w->enemies[ci].fire_period = 30000;
        soi_set_cell(w, 8, 9, SOI_CELL_SUPPORTIVE | 0x07);
        soi_enemies_update(w);
        for (t = 0; t < SOI_MAX_PROJECTILES; t++) if (w->projectiles[t].active) pi = t;
        CHECK(pi >= 0 && w->projectiles[pi].x == soi_cell_x(3) + 0x1c && w->projectiles[pi].y == soi_cell_y(9) + 8,
              "cannon: the ball appears at x+0x1c, y+8");
        x0 = (pi >= 0) ? w->projectiles[pi].x : 0;
        soi_projectiles_update(w); soi_projectiles_update(w);
        CHECK(pi >= 0 && w->projectiles[pi].x == x0, "cannon: the ball waits 2 frames");
        soi_projectiles_update(w);
        CHECK(pi >= 0 && w->projectiles[pi].x == x0 + 4, "cannon: then flies 4 px a frame");
        for (t = 0; t < 100 && pi >= 0 && w->projectiles[pi].active; t++) soi_projectiles_update(w);
        CHECK(pi >= 0 && !w->projectiles[pi].active && SOI_CELL_TYPE(soi_get_cell(w, 8, 9)) == 0,
              "cannon: the ball smashes the breakable block and is spent");
        CHECK(w->fx_count == 4 && w->fx_frame[0] == 0x07 + 2 && w->fx_vx[0] == 40 && w->fx_vy[0] == -40 &&
              !w->fx_grav[0] && w->fx_x[1] == soi_cell_x(8) + 16,
              "cannon: the smashed block flies apart right in 4 quarters (FUN_10027d84)");
    }

    /* ---- 57. Block build/remove ANIMATIONS (asm FUN_1002754c / FUN_100283a0). A build locks the
     * cell solid (|0x300, type still 0) while it grows through frames 1..5 and becomes the block on
     * the 6th frame; a removal clears the block at once but keeps the cell standable (0x200) while
     * it shrinks 5..1, then empties it. ---- */
    {
        int t, grow_ok = 1, shrink_ok = 1, anim;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        soi_blockanim_start(w, 6, 9, +1, 0x6D, 0x026Du);
        for (t = 1; t <= 5; t++) {
            soi_blockanims_update(w);
            anim = soi_blockanim(w, 0);
            if (soi_get_cell(w, 6, 9) != SOI_WALL || anim != (6 | 9 << 8 | t << 16 | 1 << 24)) grow_ok = 0;
        }
        CHECK(grow_ok, "blockanim: a build is solid+locked (0x300) while it grows through frames 1..5");
        soi_blockanims_update(w);
        CHECK(soi_get_cell(w, 6, 9) == 0x026Du && soi_blockanim(w, 0) == -1,
              "blockanim: ...and becomes the built block on the 6th frame");
        soi_set_cell(w, 7, 9, 0x09121291u);                    /* a block hiding a goody */
        soi_block_remove(w, 7, 9);
        for (t = 5; t >= 1; t--) {
            soi_blockanims_update(w);
            anim = soi_blockanim(w, 0);
            if (soi_get_cell(w, 7, 9) != (0x0912u | SOI_CELL_SUPPORTIVE) || anim != (7 | 9 << 8 | t << 16)) shrink_ok = 0;
        }
        CHECK(shrink_ok, "blockanim: a removal shows the payload but stays standable while it shrinks 5..1");
        soi_blockanims_update(w);
        CHECK(soi_get_cell(w, 7, 9) == 0x0912u, "blockanim: ...then the revealed goody is left");
    }

    /* ---- 58. A head-bonk BREAK shatters the block: its 4 quarters burst up and fall away
     * (FUN_1002ca5c -> FUN_100278bc x4 with gravity), and a collected goody POPS up (FUN_1002bc64). */
    {
        int f;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 6, 9);
        ground_player(w, 6, 9);
        soi_set_cell(w, 6, 8, SOI_CELL_SUPPORTIVE | SOI_CELL_CRACKED | 0x07);   /* cracked: next bonk breaks */
        soi_tick(w, SOI_IN_JUMP, 0);
        for (f = 0; f < 14 && SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) != 0; f++) { soi_tick(w, 0, 0); soi_tick(w, 0, 0); }
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == 0, "shatter: the second bonk breaks the block");
        CHECK(w->fx_count == 4 && w->fx_sheet[0] == SOI_FX_SHEET_BLOCK && w->fx_frame[3] == 0x07 + 5 &&
              w->fx_vx[0] == -40 && w->fx_vy[0] == -80 && w->fx_grav[0] &&
              w->fx_x[2] == soi_cell_x(6) + 16 && w->fx_y[2] == soi_cell_y(8) + 16,
              "shatter: the bonked block bursts into its 4 quarter frames (FUN_1002ca5c)");
        soi_set_cell(w, 6, 8, 0x90Au);                         /* a silver coin overhead */
        w->players[1].y = soi_cell_y(8);
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);                 /* (even, odd): the pickup runs on the odd tick */
        CHECK(w->fx_count == 1 && w->fx_sheet[0] == SOI_FX_SHEET_GOODY && w->fx_frame[0] == 0x0A &&
              w->fx_vx[0] == 0 && w->fx_vy[0] == -80 && w->fx_grav[0],
              "pop: a collected goody pops up and falls away (FUN_1002bc64)");
    }

    /* ---- 59. Each player builds its OWN colour (asm FUN_1002b448: P1 +0x36 = BORD 0x02, P2 = 0x04;
     * every board holds 0x026D / 0x0273 = the blue / green blocks). ---- */
    {
        uint8_t bord[0x1C];
        memset(bord, 0, sizeof(bord));
        bord[0x02] = 0x02; bord[0x03] = 0x6D;
        bord[0x04] = 0x02; bord[0x05] = 0x73;
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        CHECK(w->players[1].block_type == 0x6D && w->players[2].block_type == 0x73,
              "loader: P1 builds the blue block (0x6D), P2 the green one (0x73)");
    }

    /* ---- 60. The original's RUN FEEL (asm FUN_100128f8 / FUN_10012bf4 / FUN_10013ddc /
     * FUN_10013f68 / FUN_10013c18 / FUN_100140f4 / FUN_1001431c): turning round from a stand
     * takes 3 frames on the spot, reversing mid-run 4, and letting go finishes the stride then
     * STOPS and SETTLES (no key is read meanwhile) before the stand. Frames are the asm's own. */
    {
        int t, x0, moved, jumped;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 9);
        { int c; for (c = 1; c <= 17; c++) soi_set_cell(w, c, 9, SOI_CELL_SUPPORTIVE); }
        w->players[1].y = soi_cell_y(8) + 1;      /* rest on the row-9 floor */
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].ground_state == SOI_ST_IDLE && w->players[1].frame == 0x3d,
              "feel: standing facing right shows frame 0x3d");
        x0 = w->players[1].x; moved = 0;
        for (t = 0; t < 4; t++) {                 /* hold LEFT: the stand hands over to 3 turning frames */
            soi_tick(w, SOI_IN_LEFT, 0); soi_tick(w, SOI_IN_LEFT, 0);
            if (w->players[1].x != x0) moved = 1;
        }
        CHECK(!moved && w->players[1].ground_state == SOI_ST_TURN_L && w->players[1].frame == 0x60,
              "feel: turning to face left plays frames 0x5e..0x60 without moving");
        soi_tick(w, SOI_IN_LEFT, 0); soi_tick(w, SOI_IN_LEFT, 0);
        CHECK(w->players[1].ground_state == SOI_ST_RUN && w->players[1].facing == -1 && w->players[1].frame == 2,
              "feel: ...then runs left from frame 2");
        for (t = 0; t < 8; t++) { soi_tick(w, SOI_IN_LEFT, 0); soi_tick(w, SOI_IN_LEFT, 0); }
        CHECK(w->players[1].x == x0 - 16 && w->players[1].frame >= 1 && w->players[1].frame <= 0x18,
              "feel: the left run strides 2 px a frame on its own leg frames (1..0x18)");
        x0 = w->players[1].x; moved = 0;
        for (t = 0; t < 5; t++) {                 /* reverse: the stride hands over to a 4-frame turn */
            soi_tick(w, SOI_IN_RIGHT, 0); soi_tick(w, SOI_IN_RIGHT, 0);
            if (w->players[1].x != x0) moved = 1;
        }
        CHECK(!moved && w->players[1].ground_state == SOI_ST_RUN && w->players[1].facing == 1 &&
              w->players[1].frame >= 0x19 && w->players[1].frame <= 0x30,
              "feel: reversing mid-run turns on the spot for 4 frames, then runs right");
        soi_tick(w, SOI_IN_RIGHT, 0); soi_tick(w, SOI_IN_RIGHT, 0);   /* one 2-px stride: half a step */
        CHECK(w->players[1].x & 2, "feel: (mid-stride, x is 2 px off the 4-px grid)");
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);     /* let go: the stride is finished first */
        CHECK((w->players[1].x & 3) == 0 && w->players[1].ground_state == SOI_ST_RUN,
              "feel: letting go mid-stride finishes the stride (x ends 4-px aligned)");
        soi_tick(w, 0, 0); soi_tick(w, 0, 0);     /* aligned with no key: the stop begins */
        CHECK(w->players[1].ground_state == SOI_ST_STOP, "feel: ...then the player stops");
        x0 = w->players[1].x; jumped = 0;
        for (t = 0; t < 8 && w->players[1].ground_state != SOI_ST_IDLE; t++) {
            soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, 0, 0);   /* mash jump while stopping */
            if (w->players[1].ground_state == SOI_ST_JUMP) jumped = 1;
        }
        CHECK(!jumped && w->players[1].x == x0 && w->players[1].ground_state == SOI_ST_IDLE,
              "feel: the stop + settle ignore the keys, then the player stands");
        CHECK(t >= 4, "feel: stopping takes a few frames (the legs come together, the feet plant)");
    }

    /* ---- 61. The jump keeps its launch facing while steered (FUN_10013404 never writes +0x34),
     * tumbling through the asm's right-hand frames 0x86..0x8d (+0x10 at odd 2-px x). ---- */
    {
        int t, okf = 1;
        soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 9);
        { int c; for (c = 1; c <= 17; c++) soi_set_cell(w, c, 9, SOI_CELL_SUPPORTIVE); }
        w->players[1].y = soi_cell_y(8) + 1;
        soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, 0, 0);
        for (t = 0; t < 10; t++) {
            int f;
            soi_tick(w, SOI_IN_LEFT, 0); soi_tick(w, SOI_IN_LEFT, 0);
            f = w->players[1].frame - ((w->players[1].x & 2) ? 0x10 : 0);
            if (w->players[1].ground_state == SOI_ST_JUMP && (f < 0x86 || f > 0x8d)) okf = 0;
        }
        CHECK(w->players[1].facing == 1, "jumpfeel: steering left in the air keeps the right facing");
        CHECK(okf, "jumpfeel: the right tumble cycles frames 0x86..0x8d");
    }

    /* ---- 62. Remaster input assist (soi_set_input_assist): tap capture, verb buffering,
     * cancel stop/settle on jump, and simultaneous action+jump preservation. ---- */
    {
        int t;
        soi_world_init(w, 1); w->level_loaded = 1;
        soi_set_input_assist(w, 1);
        reset_player(w, 1, 8, 9);
        { int c; for (c = 1; c <= 17; c++) soi_set_cell(w, c, 9, SOI_CELL_SUPPORTIVE); }
        w->players[1].y = soi_cell_y(8) + 1;

        /* (a) Tap capture: a key pressed ONLY on an even (unsampled) tick is captured by in_pend */
        w->tick = 0; /* tick 1 will be odd (sample), tick 0 is even */
        soi_tick(w, 0, 0); /* tick 1: sampled, in = 0 */
        soi_tick(w, SOI_IN_RIGHT, 0); /* tick 2: even, but in_pend accumulates SOI_IN_RIGHT */
        soi_tick(w, 0, 0); /* tick 3: odd, in_pend applied -> starts running right */
        CHECK(w->players[1].ground_state == SOI_ST_RUN, "assist: tap on unsampled tick is captured");

        /* (b) Jump cancels STOP: start stopping, then press jump with assist on -> immediate leap */
        soi_tick(w, 0, 0); soi_tick(w, 0, 0); /* finish stride */
        soi_tick(w, 0, 0); soi_tick(w, 0, 0); /* enters STOP */
        CHECK(w->players[1].ground_state == SOI_ST_STOP, "assist: player entered stop");
        soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].ground_state == SOI_ST_JUMP, "assist: jump cancels stop state immediately");

        /* (c) Action spamming & simultaneous jump+block:
         * Land the player, then press BLOCK and JUMP together. The block action starts,
         * and the jump is held in buf, leaping as soon as the block action completes. */
        for (t = 0; t < 60 && w->players[1].in_air; t++) soi_tick(w, 0, 0);
        CHECK(w->players[1].ground_state == SOI_ST_IDLE, "assist: player landed into idle");
        soi_tick(w, SOI_IN_BLOCK_HIGH | SOI_IN_JUMP, 0); soi_tick(w, 0, 0);
        CHECK(w->players[1].pose != 0, "assist: block action started");
        /* Press block again on frame 3 of the action to test spam buffer */
        soi_tick(w, SOI_IN_BLOCK_HIGH, 0); soi_tick(w, 0, 0);
        /* Advance through the rest of the 7-frame block action */
        for (t = 0; t < 20 && w->players[1].pose != 0; t++) soi_tick(w, 0, 0);
        CHECK(w->players[1].pose == 0, "assist: first block action ended");
        /* Buffered jump leaps right after block finishes */
        CHECK(w->players[1].ground_state == SOI_ST_JUMP, "assist: buffered jump fired after block action completed");
    }

    free(w);
    if (failures) { printf("\n%d CHECK(S) FAILED\n", failures); return 1; }
    printf("\nALL MECHANIC TESTS PASSED\n");
    return 0;
}
