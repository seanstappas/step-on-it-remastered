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
        uint8_t bt = w->players[player].block_type ? w->players[player].block_type : 1;
        int victim = soi_enemy_at(w, col1 - 1, row1 - 1);   /* 0-based lookup */
        if (victim >= 0) soi_enemy_kill(w, victim, player);
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

/* Airborne horizontal steer: +/-2 px/frame toward the held run key, gated on the
 * target cell being clear (asm FUN_10013404 uses FUN_100126c8 / FUN_100127e0, the
 * 0x200 solid-bit wall tests). Same speed as a grounded run step. */
static void air_drift(SoiWorld *w, SoiPlayer *p)
{
    int dir = 0, col, row;
    uint32_t nc;
    if (p->input & SOI_IN_RIGHT)      dir = 1;
    else if (p->input & SOI_IN_LEFT)  dir = -1;
    if (dir == 0) return;
    p->facing = (int16_t)dir;
    col = px_col1(p->x + (dir > 0 ? 0x20 : -0x10));
    row = px_row1(p->y);
    nc = cell1(w, col, row);
    if (SOI_CELL_TYPE(nc) == 0 || (nc & SOI_CELL_SUPPORTIVE) == 0)
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
    p->jump_t++;
    if (p->jump_t > 17) p->jump_t = 17;          /* clamp t, then step (asm order) */
    y = p->y + JUMP_DY[p->jump_t];
    if (y >= IN_AIR_DEATH_Y) {                    /* leapt into a pit -> death */
        p->in_air = 0;
        p->alive = 0;
        if (--p->lives < 1) p->eliminated = 1;
        else p->respawn_timer = 90;
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    if (y < IN_AIR_TOP_Y) y = IN_AIR_TOP_Y;
    p->y = (int16_t)y;
    air_drift(w, p);
    if (p->jump_t > 12 && supported(w, p)) {      /* past the apex + ground -> land */
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
    }
}

/* Gravity fall (asm state 3, FUN_1001386c): a flat 4 px/frame descent until the
 * feet find ground; off the board bottom (y >= 446) is a pit death. */
static void fall_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int y = p->y + 4;
    if (y >= IN_AIR_DEATH_Y) {
        p->in_air = 0;
        p->alive = 0;
        if (--p->lives < 1) p->eliminated = 1;
        else p->respawn_timer = 90;
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    p->y = (int16_t)y;
    air_drift(w, p);
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
        if (--p->lives < 1) p->eliminated = 1;
        else p->respawn_timer = 90;
        return;
    }
    p->y = (int16_t)y;
    if ((p->jump_t % 3) == 0)
        p->x += (p->facing >= 0) ? 1 : -1;
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
 * if the cell ahead is clear -- probe X+0x14 right / X+0x0a left at row Y+1, the
 * 0x200 solid bit (FUN_100127e0 / FUN_100126c8) -- else run in place. Collect any
 * goodie on the current cell (asm FUN_1002bc64, checked every player tick). */
static void run_step(SoiWorld *w, int player, int dir)
{
    SoiPlayer *p = &w->players[player];
    int col = px_col1(p->x + (dir > 0 ? 0x14 : 0x0a));
    int row = px_row1(p->y + 1);
    p->facing = (int16_t)dir;
    p->ground_state = SOI_ST_RUN;
    if (!(cell1(w, col, row) & SOI_CELL_SUPPORTIVE))
        p->x += dir * 2;
    soi_pickup_check(w, player);
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

    if (p->in_air) { air_step(w, player); return; }

    /* gravity: fall if unsupported (asm state 3 = flat 4 px/frame; see fall_step). */
    if (!supported(w, p)) {
        p->in_air = 1;
        p->ground_state = SOI_ST_FALL;
        return;
    }

    /* mid run-step no longer exists: the run is continuous (run_step below). */

    /* idle: the 7 real actions (Configure-Keys order) */
    if (edge & SOI_IN_JUMP)       { start_jump(w, player); return; }
    if (edge & SOI_IN_BLOCK_HIGH) { do_block(w, player, 1); return; }
    if (edge & SOI_IN_BLOCK_LOW)  { do_block(w, player, 0); return; }
    if (edge & SOI_IN_ARROW)      { soi_projectile_fire(w, player); return; }
    if (edge & SOI_IN_BALL)       { soi_ball_fire(w, player); return; }
    if (in & SOI_IN_LEFT)       { run_step(w, player, -1); return; }
    if (in & SOI_IN_RIGHT)      { run_step(w, player, +1); return; }
    /* no direction held: settle to rest -- snap X to a 4 px boundary (asm idle
     * FUN_100128f8) and drop to idle. */
    if (p->ground_state == SOI_ST_RUN) {
        p->x &= ~3;
        p->ground_state = SOI_ST_IDLE;
    }
}
