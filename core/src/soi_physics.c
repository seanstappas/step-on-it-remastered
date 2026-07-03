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

/* Grid-align Y to sit one row above the support block under the feet
 * (behavioral landing; exact +1 offset TODO(video), asm FUN_100137f8). */
static void snap_to_ground(SoiPlayer *p)
{
    int rowF = px_row1(p->y + 0x1f);
    int y = (rowF - 2) * 32 + SOI_ORIGIN_Y;
    p->y = (int16_t)(y < SOI_ORIGIN_Y ? SOI_ORIGIN_Y : y);
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
        set_cell1(w, col1, row1, (uint32_t)bt | SOI_CELL_SUPPORTIVE);
        soi_sfx_emit(w, SOI_SFX_BLOCK_CREATE);
    }
}

/* Switch Block High (above head) / Low (at feet), in the facing column.
 * TODO(video): confirm exact rows (asm y+0x10 High / y+0x1f Low; col x+0x30
 * right / x-0x12 left). */
static void do_block(SoiWorld *w, int player, int high)
{
    SoiPlayer *p = &w->players[player];
    int col1 = px_col1(p->x + (p->facing >= 0 ? 0x30 : -0x12));
    int row1 = px_row1(p->y) + (high ? -1 : 1);
    block_toggle(w, col1, row1, player);
}

/* Begin a jump: break the block directly above, then enter the parabola. */
static void start_jump(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int aCol = px_col1(p->x + 0x10);
    int aRow = px_row1(p->y) - 1;
    uint32_t a = cell1(w, aCol, aRow);
    if (SOI_CELL_TYPE(a) != 0 && !(a & SOI_CELL_PERMANENT))
        set_cell1(w, aCol, aRow, (a & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(a) : 0u);
    p->in_air = 1;
    p->jump_t = 0;
    p->launch_y = (int16_t)p->y;
    p->ground_state = SOI_ST_JUMP;
    soi_sfx_emit(w, SOI_SFX_JUMP);
}

/* One parabola frame (asm FUN_10011fcc):
 *   Y = (launch_y*10 - 30*t + floor(t*t/2)) / 10, clamp [48,445], >=446 = death. */
static void air_step(SoiWorld *w, int player)
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
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    p->y = (int16_t)y;
    p->x += p->facing >= 0 ? 2 : -2;               /* drift TODO(video) */
    if (t > 30 && supported(w, p)) {
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
    }
}

/* Try to start a horizontal run one cell in dir (-1/+1). */
static void start_run(SoiWorld *w, int player, int dir)
{
    SoiPlayer *p = &w->players[player];
    int nextCol = px_col1(p->x + (dir > 0 ? 0x20 : -0x10));
    int row = px_row1(p->y);
    uint32_t nc = cell1(w, nextCol, row);
    p->facing = (int16_t)(dir > 0 ? 1 : -1);
    if (SOI_CELL_TYPE(nc) == 0 || (nc & SOI_CELL_SUPPORTIVE) == 0) {
        p->move_ctr = 1;
        p->run_dir = (int16_t)dir;
        p->run_x0 = p->x;
        p->ground_state = SOI_ST_RUN;
    }
}

void soi_player_update(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    uint8_t in = p->input;

    if (!p->active || p->eliminated || !p->alive) return;

    if (p->in_air) { air_step(w, player); return; }

    /* gravity: fall if unsupported. A fall is the jump parabola started at its
     * apex (t=30, zero vertical velocity) so it only descends: launch_y is
     * offset by +45 so Y(30) == current y. */
    if (!supported(w, p)) {
        p->in_air = 1;
        p->jump_t = 30;
        p->launch_y = (int16_t)(p->y + 45);
        p->ground_state = SOI_ST_FALL;
        return;
    }

    /* mid run-step: interpolate 32px over 7 frames (asm FUN_100147b8) */
    if (p->move_ctr > 0) {
        p->move_ctr++;
        p->x = p->run_x0 + (int)p->run_dir * 32 * p->move_ctr / SOI_MOVE_FRAMES;
        if (p->move_ctr >= SOI_MOVE_FRAMES) {
            p->x = p->run_x0 + (int)p->run_dir * 32;
            p->move_ctr = 0;
            p->run_dir = 0;
            p->ground_state = SOI_ST_IDLE;
            soi_pickup_check(w, player);
        }
        return;
    }

    /* idle: the 7 real actions (Configure-Keys order) */
    if (in & SOI_IN_JUMP)       { start_jump(w, player); return; }
    if (in & SOI_IN_BLOCK_HIGH) { do_block(w, player, 1); return; }
    if (in & SOI_IN_BLOCK_LOW)  { do_block(w, player, 0); return; }
    if (in & SOI_IN_ARROW)      { soi_projectile_fire(w, player); return; }
    if (in & SOI_IN_BALL)       { /* TODO: Magic Ball (rolls along walls) */ return; }
    if (in & SOI_IN_LEFT)       { start_run(w, player, -1); return; }
    if (in & SOI_IN_RIGHT)      { start_run(w, player, +1); return; }
}
