/* soi_physics.c — player movement: a faithful port of the run-and-jump
 * platformer from the decompiled PowerPC (docs/original_game/decompiled-findings.md
 * §0, from analysis/decomp/asm/). Replaces the earlier (wrong) 4-direction
 * grid-mover. Constants/formulas are cited to the disassembly; a few pixel
 * offsets are marked TODO(video) where the asm was obscure.
 *
 * Coords (asm FUN_1002e6cc/f8, 1-based): col=(x-16)/32+1, row=(y-48)/32+1.
 * Player x = cell left, y = cell top. The live grid is 0-based [row][col];
 * cell1()/set_cell1() bridge the physics math to it. A cell is standable iff
 * bit 0x200 (SUPPORTIVE) is set.
 */
#include "soi_internal.h"

#define IN_AIR_DEATH_Y  0x1be   /* 446: fall past this = death (asm FUN_10011fcc) */
#define IN_AIR_TOP_Y    0x30    /* 48: top clamp */

/* ---- faithful 1-based pixel<->cell (asm FUN_1002e6cc / FUN_1002e6f8) ---- */
static int px_col1(int x) { return (x < 16) ? 0 : ((x - 16) >> 5) + 1; }
static int px_row1(int y) { return (y < 48) ? 0 : ((y - 48) >> 5) + 1; }

static uint32_t cell1(const SoiWorld *w, int col1, int row1)
{
    if (col1 >= 1 && col1 <= SOI_GRID_COLS && row1 >= 1 && row1 <= SOI_GRID_ROWS)
        return w->cell[row1 - 1][col1 - 1];
    return SOI_WALL;                                    /* OOB = solid */
}
static void set_cell1(SoiWorld *w, int col1, int row1, uint32_t v)
{
    if (col1 >= 1 && col1 <= SOI_GRID_COLS && row1 >= 1 && row1 <= SOI_GRID_ROWS)
        w->cell[row1 - 1][col1 - 1] = v;
}

/* Standing support (asm FUN_10012348): two cells under the feet (x+0x10 & x+0x0e,
 * y+0x1f); supported iff either has bit 0x200. */
static int supported(const SoiWorld *w, const SoiPlayer *p)
{
    int rowF = px_row1(p->y + 0x1f);
    int colA = px_col1(p->x + 0x10);
    int colB = px_col1(p->x + 0x0e);
    return (cell1(w, colA, rowF) & SOI_CELL_SUPPORTIVE) ||
           (cell1(w, colB, rowF) & SOI_CELL_SUPPORTIVE);
}

/* Grid-align Y after a landing. Real boards place the player one row ABOVE the
 * floor block (the player's own cell is empty; support is the row below), and
 * the asm rests the sprite at "block top + 1" (FUN_100137f8, §0b: Y=(row-1)*32
 * +49). The support probe (y+0x1f) then reads the floor one row down, so the
 * player stands stably instead of oscillating fall<->idle at the row seam. */
static void snap_to_ground(SoiPlayer *p)
{
    int rowF = px_row1(p->y + 0x1f);
    int y = (rowF - 2) * 32 + SOI_ORIGIN_Y + 1;
    p->y = (int16_t)(y < SOI_ORIGIN_Y + 1 ? SOI_ORIGIN_Y + 1 : y);
}

/* Toggle a block (asm FUN_1002d04c/cf08/d190): permanent -> no-op; occupied ->
 * destroy (reveal 0x1000 payload); empty -> create a SUPPORTIVE block and squash
 * any enemy there. col1/row1 are 1-based. */
static void block_toggle(SoiWorld *w, int col1, int row1, int player)
{
    uint32_t c = cell1(w, col1, row1);
    if (c & SOI_CELL_PERMANENT) return;
    if (SOI_CELL_TYPE(c) != 0) {
        set_cell1(w, col1, row1, (c & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(c) : 0u);
        soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
    } else {
        /* CREATE GATE (asm FUN_1002d04c -> FUN_100047e8 -> FUN_100033dc): the original
         * only builds where the target cell is visually UNOBSTRUCTED (it compares the
         * live screen region against the clean render buffer). A nasty overlapping the
         * cell blocks the build -- no block, no sound. So you CANNOT squash a nasty by
         * building on it (nasties are defeated by weapons or the thunderballs/shoes
         * goody, never by a built block). The port's old build-squash was a divergence:
         * the gate means create is never reached over a nasty. */
        uint8_t bt;
        if (soi_enemy_at(w, col1 - 1, row1 - 1) >= 0) return;   /* obstructed -> no build */
        bt = w->players[player].block_type ? w->players[player].block_type : 1;
        /* A block built on a hidden-payload cell (bit 0x1000 + goody in the high
         * word, low byte 0) INHERITS the payload (asm FUN_1002d04c: block_type +
         * (cell & 0xffff1000)); breaking it later reveals the goody -- this is how
         * the low-byte-0 payload cells become obtainable. */
        set_cell1(w, col1, row1,
                  ((uint32_t)bt | SOI_CELL_SUPPORTIVE) | (c & 0xFFFF1000u));
        soi_sfx_emit(w, SOI_SFX_BLOCK_CREATE);
    }
}

/* The two block keys build (or toggle) a block ONE COLUMN AHEAD in the facing
 * column: the "high" key at the player's own row (directly in front), the "low"
 * key one row down (in front and below). NEITHER builds above the head -- this
 * matches the asm (FUN_1001166c: y+0x10 front / y+0x1f front-below; col x+0x30
 * right / x-0x12 left; FUN_1002d04c/cf08/d190). */
static void do_block(SoiWorld *w, int player, int high)
{
    SoiPlayer *p = &w->players[player];
    int col1 = px_col1(p->x + (p->facing >= 0 ? 0x30 : -0x12));
    int row1 = px_row1(p->y + (high ? 0x10 : 0x1f));
    block_toggle(w, col1, row1, player);
}

/* Jump vertical-velocity LUT (asm DAT_1003474c, recovered from the compressed PEF
 * data section, tools/dump_jump_table.py). Per frame Y += JUMP_DY[t], t clamped
 * 0..17 (negative = rising since screen-Y grows down): a ~4 px/frame rise easing
 * to a ~37 px apex over ~12 frames, a brief hang, then a fall to a +4 px/frame
 * terminal. NOT a computed parabola (that shape is the death throw only). */
static const int16_t JUMP_DY[18] = {
    0, -4, -4, -4, -4, -4, -4, -4, -4, -2, -2, -1, 0, 0, 1, 2, 2, 4
};

/* Horizontal-move clearance -- the SHARED wall test the asm uses for BOTH the grounded
 * run (FUN_10012bf4) and the airborne steer (FUN_10013404), via FUN_100126c8 (left) /
 * FUN_100127e0 (right). The target COLUMN is x+0x14 heading right / x+0x0a heading left,
 * and it must be NON-solid (0x200) at TWO rows: the upper-body row (y+7 while actively
 * JUMPING with jump_t<0x11, else y+1) AND the lower-body row (y+0x1e). Clear only if both
 * pass. (The old code probed a single row and, in the air, the WRONG column x+0x20/-0x10.) */
static int move_clear(SoiWorld *w, SoiPlayer *p, int dir)
{
    int col = px_col1(p->x + (dir > 0 ? 0x14 : 0x0a));
    int r1  = (p->ground_state == SOI_ST_JUMP && p->jump_t < 0x11) ? 7 : 1;
    if (cell1(w, col, px_row1(p->y + r1))   & SOI_CELL_SUPPORTIVE) return 0;
    if (cell1(w, col, px_row1(p->y + 0x1e)) & SOI_CELL_SUPPORTIVE) return 0;
    return 1;
}

/* Airborne horizontal steer (asm FUN_10013404 air-steer, jump only): +/-2 px/frame
 * toward the held run key, gated on the target cell being clear (FUN_100126c8 /
 * FUN_100127e0, the 0x200 solid-bit wall tests). Same speed + same clearance test as
 * a grounded run step. The fall (FUN_1001386c) does NOT air-steer -- only the jump. */
/* Auto wall-rebound (asm FUN_10012554): if a solid (0x200) cell sits against the
 * player's left column (x+0x0a) at either body row (y+7 upper / y+0x1e lower) push
 * +2 px RIGHT; if it sits against the right column (x+0x14) push -2 px LEFT. Nudges
 * an airborne player away from a wall, INDEPENDENT of input. Called by the fall every
 * frame (FUN_1001386c) and by the jump only past the rise (FUN_10013404, jump_t>=8 --
 * during the rise the jump runs the headroom check instead). Same columns/rows as
 * move_clear, so a normal open-air jump/fall never triggers it. */
static void wall_rebound(SoiWorld *w, SoiPlayer *p)
{
    int orig_x = p->x;                              /* asm FUN_10012554 snapshots x at entry (iVar4)
                                                     * and uses it for BOTH side probes -- the right
                                                     * probe must NOT see a +2 already applied by the
                                                     * left probe, or a one-wall wedge drifts sideways. */
    int rowU = px_row1(p->y + 7);
    int rowL = px_row1(p->y + 0x1e);
    if ((cell1(w, px_col1(orig_x + 0x0a), rowU) & SOI_CELL_SUPPORTIVE) ||
        (cell1(w, px_col1(orig_x + 0x0a), rowL) & SOI_CELL_SUPPORTIVE))
        p->x += 2;                                  /* left side blocked -> push right */
    if ((cell1(w, px_col1(orig_x + 0x14), rowU) & SOI_CELL_SUPPORTIVE) ||
        (cell1(w, px_col1(orig_x + 0x14), rowL) & SOI_CELL_SUPPORTIVE))
        p->x -= 2;                                  /* right side blocked -> push left */
}

/* Head-clearance test (asm FUN_10012444): the two upper-body columns (x+0x10 &
 * x+0x0e) at the row two px above the head (y-2) must BOTH be clear of the 0x200
 * solid bit, and that row must sit at/below the top wall (y-2 >= 0x20; in practice
 * the row-0 border wall already floors this via the OOB=solid probe). Clear -> 1,
 * blocked -> 0. In the ASM this SAME FUN_10012444 runs both at the launch frame
 * (FUN_10013404 jump_t==0) and every rising frame (jump_t<8). The PORT instead gives
 * start_jump its own SIMPLIFIED single-column launch probe (px_col1(x+0x10) at
 * px_row1(y)-1 -- a different row than this px_row1(y-2)); that divergence is a port
 * choice, not two different asm functions, so the launch and the rise can disagree for
 * non-cell-aligned y. This function is the per-frame re-check the RISING jump runs. */
static int headroom_clear(const SoiWorld *w, const SoiPlayer *p)
{
    int yTop = p->y - 2;
    int row  = px_row1(yTop);
    if (cell1(w, px_col1(p->x + 0x10), row) & SOI_CELL_SUPPORTIVE) return 0;
    if (cell1(w, px_col1(p->x + 0x0e), row) & SOI_CELL_SUPPORTIVE) return 0;
    if (yTop < 0x20) return 0;
    return 1;
}

/* Airborne horizontal steer (jump only): move +/-2 px toward the held run key if the
 * cell ahead is clear. Called after the arc y-step in jump_step; the fall never steers. */
static void air_drift(SoiWorld *w, SoiPlayer *p)
{
    int dir = 0;
    if (p->input & SOI_IN_RIGHT)      dir = 1;
    else if (p->input & SOI_IN_LEFT)  dir = -1;
    if (dir == 0) return;
    p->facing = (int16_t)dir;
    if (move_clear(w, p, dir))
        p->x += dir * 2;
}

/* Begin a jump (asm FUN_10013404 @ t==0): if a solid block is directly overhead it
 * is a HEAD-BONK -- break that block and do NOT leap (FUN_12444 head-clear check ->
 * state 4 FUN_10014524). With clear headroom the player leaps into the table arc.
 * The launch is SILENT (the only somersault sound, event 0x21 -> 26486, is the
 * DEATH throw FUN_10012228, not the jump). */
static void start_jump(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int aCol = px_col1(p->x + 0x10);
    int aRow = px_row1(p->y) - 1;
    uint32_t a = cell1(w, aCol, aRow);
    /* A solid block directly overhead is a HEAD-BONK, not a leap (asm state 4
     * FUN_10014524 -> FUN_1002ca5c): a TWO-STAGE destroy. The first bonk CRACKS
     * the block (sets 0x4000, sfx 0x23); a second bonk BREAKS the cracked block
     * (reveals any 0x1000 payload, sfx 0x24). Permanent (0x100) and door (0x800)
     * blocks are immune -- they stop the jump but never break. */
    if (SOI_CELL_TYPE(a) != 0) {
        if (!(a & (SOI_CELL_PERMANENT | SOI_CELL_DOOR))) {
            if (!(a & SOI_CELL_CRACKED)) {
                set_cell1(w, aCol, aRow, a | SOI_CELL_CRACKED);
                soi_sfx_emit(w, SOI_SFX_BLOCK_CRACK);
            } else {
                set_cell1(w, aCol, aRow, (a & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(a) : 0u);
                soi_sfx_emit(w, SOI_SFX_BLOCK_BREAK);
            }
        }
        return;                                  /* no leap on a bonk */
    }
    p->in_air = 1;
    p->jump_t = 0;
    p->ground_state = SOI_ST_JUMP;
}

/* One JUMP frame (asm FUN_10013404, ground-state 2): the table-driven arc. */
static void jump_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int y;
    /* asm FUN_10013404 order: BEFORE the jump_t increment (line 33) and the arc y-step
     * (line 38-40), the early-rise phase (jump_t<8) re-checks headroom (FUN_10012444)
     * every frame and stalls the leap to the apex (jump_t=0xc) if a solid cell now sits
     * overhead -- e.g. a block you built while rising, or one that appeared above you.
     * From jump_t>=8 onward (the late rise + hang + fall) it instead runs the auto
     * wall-rebound (FUN_10012554 @ line 31, so on the PRE-step Y, matching the fall).
     * The two are mutually exclusive on the PRE-increment jump_t: the asm's < 8 / else. */
    if (p->jump_t < 8) {
        if (!headroom_clear(w, p)) p->jump_t = 0xc;
    } else {
        wall_rebound(w, p);
    }
    p->jump_t++;
    if (p->jump_t > 17) p->jump_t = 17;          /* clamp t, then step (asm order) */
    y = p->y + JUMP_DY[p->jump_t];
    if (y >= IN_AIR_DEATH_Y) {                    /* leapt into a pit -> death */
        p->in_air = 0;
        p->alive = 0;
        if (--p->lives < 0) p->eliminated = 1;   /* eliminate only when the killing blow takes
                                                  * lives BELOW 0: the displayed "0 lives" is still a
                                                  * playable last life (asm FUN_1000e9c8 allows -1,
                                                  * FUN_1001f4f8 games-over at lives<0, HUD clamps to 0) */
        else p->respawn_timer = 90;
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    if (y < IN_AIR_TOP_Y) y = IN_AIR_TOP_Y;
    p->y = (int16_t)y;
    air_drift(w, p);                              /* input air-steer only (wall-rebound handled above) */
    if (p->jump_t > 12 && supported(w, p)) {      /* past the apex + ground -> land */
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
    }
}

/* Gravity fall (asm state 3, FUN_1001386c): a flat 4 px/frame descent until the
 * feet find ground; off the board bottom (y >= 446) is a pit death. The fall is
 * PURELY VERTICAL -- FUN_1001386c calls ONLY the wall-rebound (FUN_10012554) for
 * any x change; it reads NO input, so you CANNOT steer a cliff-fall (unlike the
 * jump FUN_10013404, which does air-steer). Walking off a ledge drops straight
 * down (+ wall rebound if you fall against a wall), never at an angle. */
static void fall_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int y;
    wall_rebound(w, p);                           /* asm FUN_1001386c: rebound (line 9) runs on EVERY
                                                   * fall frame, on the PRE-step Y, BEFORE the y += 4 at
                                                   * line 19 (rebound-only, no steer). The asm fall has NO
                                                   * pit-death of its own, so rebound genuinely runs
                                                   * unconditionally-first here; the y>=446 pit-death below
                                                   * is a PORT addition. On a pit-death frame that nudge is
                                                   * harmless: a surviving death respawns (x reset), and an
                                                   * eliminated player is removed from play so its x is never
                                                   * read again. Mirrors the jump path (rebound before its
                                                   * own pit-death check). */
    y = p->y + 4;
    if (y >= IN_AIR_DEATH_Y) {
        p->in_air = 0;
        p->alive = 0;
        if (--p->lives < 0) p->eliminated = 1;   /* out only at lives<0 (dying at 0, asm) */
        else p->respawn_timer = 90;
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    p->y = (int16_t)y;
    if (supported(w, p)) {
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
    }
}

/* One DEATH-THROW frame (asm FUN_10011fcc, dying flag +0x28): the computed
 * parabola Y = (base*10 - 30*t + floor(t*t/2)) / 10, clamp low 48. It NEVER lands;
 * the arc carries the dying player off the bottom (y >= 446) to the life-loss +
 * respawn commit. The death cry already played at launch (soi_player_hit). */
static void death_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int t, y;
    p->jump_t++;
    t = p->jump_t;
    y = (p->launch_y * 10 - 30 * t + (t * t) / 2) / 10;
    if (y < IN_AIR_TOP_Y) y = IN_AIR_TOP_Y;
    if (y >= IN_AIR_DEATH_Y) {
        p->in_air = 0;
        p->alive = 0;
        if (--p->lives < 0) p->eliminated = 1;   /* out only at lives<0 (dying at 0, asm) */
        else p->respawn_timer = 90;
        return;
    }
    p->y = (int16_t)y;
}

/* Airborne dispatch by ground_state: table-driven jump, flat gravity fall, or the
 * death-throw parabola. */
static void air_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    if (p->ground_state == SOI_ST_JUMP) { jump_step(w, player); return; }
    if (p->ground_state == SOI_ST_DEAD) { death_step(w, player); return; }
    fall_step(w, player);                         /* SOI_ST_FALL */
}

/* One continuous run step (asm FUN_10012bf4, ground-state 1): advance 2 px in dir
 * if the cell ahead is clear -- the shared dual-row wall test move_clear() (x+0x14 right /
 * x+0x0a left, the 0x200 solid bit, FUN_100127e0 / FUN_100126c8) -- else run in place.
 * (Goodie pickup is NOT done here: the asm collects on EVERY player tick, not only while
 * running -- see the soi_pickup_check call in soi_player_update below.) */
static void run_step(SoiWorld *w, int player, int dir)
{
    SoiPlayer *p = &w->players[player];
    p->facing = (int16_t)dir;
    p->ground_state = SOI_ST_RUN;
    if (move_clear(w, p, dir))
        p->x += dir * 2;
}

void soi_player_update(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    uint8_t in = p->input;
    /* Action verbs (jump, block, arrow, ball) are EDGE-triggered — one action per
     * key press, not once per frame held — so holding the block key doesn't
     * flicker-toggle it every tick. Run (left/right) stays level-triggered. */
    uint8_t edge = (uint8_t)(in & ~p->input_prev);
    p->input_prev = in;

    if (!p->active || p->eliminated || !p->alive) return;

    /* A player mid death-throw does ONLY the somersault. In the asm, TWO gates on the
     * SAME per-player death flag enforce this: FUN_1001166c line 13 gates the build/fire
     * action AND the movement state machine (the case-switch); and, separately, the caller
     * FUN_1002a308 (line 89) gates the walk-over pickup FUN_1002bc64 on that same flag.
     * When the flag is SET, the action/movement handler runs only the throw FUN_10011fcc
     * and the pickup call is skipped. The PORT folds the pickup and the action/movement
     * into this one per-player update, so a SINGLE top-level short-circuit reproduces both
     * asm gates. `alive` stays 1 for the whole arc (it clears only when the throw commits
     * the life-loss at the bottom), so key this short-circuit off SOI_ST_DEAD. This is WHY
     * neither the pickup nor the build/fire below needs its own death guard -- a dying
     * player never reaches them, regardless of its in_air state. (death_step is the port's
     * FUN_10011fcc: advance the parabola, then commit the life-loss + respawn once the arc
     * passes the death line.) */
    if (p->ground_state == SOI_ST_DEAD) {
        death_step(w, player);
        return;
    }

    /* Walk-over goodie pickup runs EVERY LIVE player tick (asm FUN_1002a308 calls
     * FUN_1002bc64 for each player, not just while running), so a coin/gem is collected
     * the instant any part of the body overlaps its cell -- standing on it, landing on
     * it, or brushing it mid-jump -- not only once you run fully onto it. A live player
     * falling off a ledge (FALL, not DEAD) still picks up, as in the asm; only the
     * death-throw (short-circuited above) collects nothing. */
    soi_pickup_check(w, player);

    if (p->in_air) {
        /* Airborne: you can still BUILD/DESTROY blocks and fire weapons -- the asm runs the action
         * animation (FUN_1001166c) EVERY frame; jump/fall never gate it, and the build/fire actually
         * fires from that animation (FUN_1002d04c / FUN_100110b4 / etc.) regardless of air state. A NEW
         * jump is not allowed while already airborne. Same edge-triggered, one-action-per-frame dispatch
         * as on the ground; do_block/fire target the front cell at the player's CURRENT (mid-air) x/y,
         * exactly as the asm does. (A dying player never reaches here -- gated at the top on SOI_ST_DEAD,
         * matching asm FUN_1001166c line 13 where a set death flag routes to the throw and nothing else.) */
        if      (edge & SOI_IN_BLOCK_HIGH) { do_block(w, player, 1); p->pose = 2; p->pose_t = 12; }
        else if (edge & SOI_IN_BLOCK_LOW)  { do_block(w, player, 0); p->pose = 2; p->pose_t = 12; }
        else if (edge & SOI_IN_ARROW)      { soi_projectile_fire(w, player); p->pose = 1; p->pose_t = 12; }
        else if (edge & SOI_IN_BALL)       { soi_ball_fire(w, player); p->pose = 1; p->pose_t = 12; }
        air_step(w, player);
        return;
    }

    /* gravity: fall if unsupported (asm state 3 = flat 4 px/frame; see fall_step). */
    if (!supported(w, p)) {
        p->in_air = 1;
        p->ground_state = SOI_ST_FALL;
        return;
    }

    /* mid run-step no longer exists: the run is continuous (run_step below). */

    /* idle: the 7 real actions (Configure-Keys order) */
    if (edge & SOI_IN_JUMP)       { start_jump(w, player); return; }
    if (edge & SOI_IN_BLOCK_HIGH) { do_block(w, player, 1); p->pose = 2; p->pose_t = 12; return; }
    if (edge & SOI_IN_BLOCK_LOW)  { do_block(w, player, 0); p->pose = 2; p->pose_t = 12; return; }
    if (edge & SOI_IN_ARROW)      { soi_projectile_fire(w, player); p->pose = 1; p->pose_t = 12; return; }
    if (edge & SOI_IN_BALL)       { soi_ball_fire(w, player); p->pose = 1; p->pose_t = 12; return; }
    /* Action swing in progress: freeze only the CONTINUOUS run/idle dispatch during the
     * ~12-frame build/fire pose (asm action active-flag FUN_1001166c +0x25). Without this,
     * holding a direction while repeatedly building slides ("glides") the player across the
     * floor under the arm-swing; freezing the run here makes him stutter to a stop until the
     * pose finishes. The edge-triggered actions ABOVE (jump/build/fire) and gravity (the fall
     * check above) deliberately stay live -- the player can still act mid-swing -- and the
     * render still shows the build/fire pose (it out-ranks run in _draw_player). */
    if (p->pose_t > 0) return;
    if (in & SOI_IN_LEFT)       { run_step(w, player, -1); return; }
    if (in & SOI_IN_RIGHT)      { run_step(w, player, +1); return; }
    /* no direction held: settle to rest -- snap X to a 4 px boundary (asm idle
     * FUN_100128f8) and drop to idle. */
    if (p->ground_state == SOI_ST_RUN) {
        p->x &= ~3;
        p->ground_state = SOI_ST_IDLE;
    }
}
