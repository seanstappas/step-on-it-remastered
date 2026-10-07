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

/* ---- player sprite frames (asm numbering; the extracted BP/GP_sprites PNG is f(frame+1)) ---- */
#define FR_STAND_R 0x3d         /* idle / fall facing right (FUN_100128f8, FUN_1001386c) */
#define FR_STAND_L 0x34         /* ... facing left */
/* head-bonk recoil by counter 1..9 (DAT_10034724 right / DAT_10034738 left) */
static const int16_t BONK_R[10] = { 0, 112, 113, 114, 115, 116, 115, 114, 113, 112 };
static const int16_t BONK_L[10] = { 0, 107, 108, 109, 110, 111, 110, 109, 108, 107 };
/* build/fire pose by anim mode and counter 1..6 (FUN_1001166c: mode 1 DAT_100346fa, mode 2
 * DAT_10034716, mode 3 DAT_100346ec, mode 4 DAT_10034708) */
static const int16_t ACT_FRAMES[5][7] = {
    { 0, 0, 0, 0, 0, 0, 0 },
    { 0,  97,  99, 101, 101,  99,  97 },    /* 1: left, high block / fire */
    { 0,  97,  98,  99,  99,  98,  97 },    /* 2: left, low block */
    { 0, 102, 104, 106, 106, 104, 102 },    /* 3: right, high block / fire */
    { 0, 102, 103, 104, 104, 103, 102 },    /* 4: right, low block */
};
/* Indexed by the RUN frame (left cycle 1..0x18, right cycle 0x19..0x30), three contiguous
 * PEF tables: the first frame of a mid-run turn (0x1003477c), the run frame the turn resumes
 * on in the new direction (0x100347de), and the leg frame a stop settles to (0x10034840). */
static const uint8_t TURN_FROM[49] = {
    0, 67, 67, 67, 82, 82, 82, 82, 82, 82, 73, 73, 73, 73, 73, 73, 88, 88, 88, 88, 88, 88,
    67, 67, 67, 79, 79, 79, 70, 70, 70, 70, 70, 70, 85, 85, 85, 85, 85, 85, 76, 76, 76, 76,
    76, 76, 79, 79, 79 };
static const uint8_t TURN_TO[49] = {
    0, 31, 31, 31, 37, 37, 37, 37, 37, 37, 43, 43, 43, 43, 43, 43, 25, 25, 25, 25, 25, 25,
    31, 31, 31,  6,  6,  6, 12, 12, 12, 12, 12, 12, 18, 18, 18, 18, 18, 18, 24, 24, 24, 24,
    24, 24,  6,  6,  6 };
static const uint8_t STOP_TO[49] = {
    0,  2,  2,  4,  4,  4,  4, 14, 14, 14, 14, 14, 14, 14, 14, 14, 16, 16, 16, 26, 26, 26,
    26, 26, 26, 25, 25, 27, 27, 27, 27, 37, 37, 37, 37, 37, 37, 37, 37, 39, 39, 39, 39, 49,
    49, 49, 49, 49, 49 };

static int16_t stand_frame(const SoiPlayer *p) { return (p->facing == 1) ? FR_STAND_R : FR_STAND_L; }
static int run_index(int frame) { return (frame >= 0 && frame <= 48) ? frame : 0; }

/* asm FUN_10014744: the first movement frame after a build/fire action restores the frame
 * the action interrupted (so a run resumes its stride). */
static void restore_frame(SoiPlayer *p)
{
    if (p->act_dirty) { p->act_dirty = 0; p->frame = p->frame_save; }
}

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
 * remove it (FUN_100279c4: the shrink animation, then any 0x1000 payload shows);
 * empty -> build the player's block (FUN_1002754c: the grow animation). col1/row1
 * are 1-based. A block that is still growing is locked (0x300), so it cannot be
 * toggled again until it has finished. */
static void block_toggle(SoiWorld *w, int col1, int row1, int player)
{
    uint32_t c = cell1(w, col1, row1);
    if (c & SOI_CELL_PERMANENT) return;
    if (SOI_CELL_TYPE(c) != 0) {
        soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
        soi_block_remove(w, col1 - 1, row1 - 1);
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
        soi_sfx_emit(w, SOI_SFX_BLOCK_CREATE);
        soi_blockanim_start(w, col1 - 1, row1 - 1, +1, bt,
                            ((uint32_t)bt | SOI_CELL_SUPPORTIVE) | (c & 0xFFFF1000u));
    }
}

/* The two block keys build (or toggle) a block ONE COLUMN AHEAD: the "high" key at
 * the player's own row (directly in front), the "low" key one row down (in front and
 * below). NEITHER builds above the head -- this matches the asm (FUN_1001166c: y+0x10
 * front / y+0x1f front-below; col x+0x30 right / x-0x12 left; FUN_1002d04c/cf08/d190).
 * `right` is the side the action was started facing (its anim mode 3/4 vs 1/2). */
static void do_block(SoiWorld *w, int player, int high, int right)
{
    SoiPlayer *p = &w->players[player];
    int col1 = px_col1(p->x + (right ? 0x30 : -0x12));
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
 * (FUN_10013404 jump_t==0, via start_jump) and every rising frame (jump_t<8, via
 * jump_step). BOTH port callers use THIS function, so the launch bonk-detection and the
 * rise re-check probe the identical two upper-body columns at the identical row for every
 * x -- there is no launch-vs-rise geometry drift for off-grid x. NOTE the DESTROY probe in
 * do_head_break is deliberately DIFFERENT (a single facing-column probe x+0x12/x+0x0c at
 * y-4, asm FUN_10014524 frame 5), so detection and destruction CAN target different cells
 * at a column boundary -- that detect-vs-destroy asymmetry is faithful and is exactly what
 * the boundary-straddle test guards; do NOT "unify" the two probes. */
static int headroom_clear(const SoiWorld *w, const SoiPlayer *p)
{
    int yTop = p->y - 2;
    int row  = px_row1(yTop);
    if (cell1(w, px_col1(p->x + 0x10), row) & SOI_CELL_SUPPORTIVE) return 0;
    if (cell1(w, px_col1(p->x + 0x0e), row) & SOI_CELL_SUPPORTIVE) return 0;
    if (yTop < 0x20) return 0;
    return 1;
}

/* Airborne horizontal steer (jump only, asm FUN_10013404): +/-2 px toward the held run key
 * (right first) if the cell ahead is clear. It does NOT turn the player -- the asm never
 * writes the facing in the air, so a jump keeps its launch direction (and its tumble art)
 * even while steered back the other way. The fall never steers. */
static void air_drift(SoiWorld *w, SoiPlayer *p, uint8_t in)
{
    if (in & SOI_IN_RIGHT) {
        if (move_clear(w, p, 1)) p->x += 2;
    } else if (in & SOI_IN_LEFT) {
        if (move_clear(w, p, -1)) p->x -= 2;
    }
}

/* The head-bonk destroy (asm FUN_1002ca5c via the state-4 handler FUN_10014524 at
 * frame 5): recompute the overhead cell from the player's CURRENT (frozen) x/y with
 * the asm's facing-dependent probe -- FUN_1002e6cc(x + 0x12 right / + 0xc left) ==
 * px_col1, FUN_1002e6f8(y - 4) == px_row1 -- then run the TWO-STAGE crack/break. The
 * first bonk CRACKS the block (sets 0x4000, sfx 0x23); a second bonk BREAKS the cracked
 * block (reveals any 0x1000 payload, sfx 0x24). Permanent (0x100) and door (0x800)
 * blocks are IMMUNE -- the recoil plays but nothing breaks (FUN_1002ca5c line 39), and
 * so is an empty-typed cell (a block still shrinking away). The break SHATTERS the
 * block: its four quarters burst up and out and fall away (FUN_1002ca5c ->
 * FUN_100278bc x4, gravity). */
static void do_head_break(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int aCol = px_col1(p->x + (p->facing >= 0 ? 0x12 : 0x0c));
    int aRow = px_row1(p->y - 4);
    uint32_t a = cell1(w, aCol, aRow);
    if (!(a & SOI_CELL_SUPPORTIVE)) return;                 /* block already gone */
    if (a & (SOI_CELL_PERMANENT | SOI_CELL_DOOR)) return;   /* immune: bonk but no break */
    if (SOI_CELL_TYPE(a) == 0) return;
    if (!(a & SOI_CELL_CRACKED)) {
        set_cell1(w, aCol, aRow, a | SOI_CELL_CRACKED);
        soi_sfx_emit(w, SOI_SFX_BLOCK_CRACK);
    } else {
        soi_block_shatter(w, aCol - 1, aRow - 1, SOI_SHATTER_BONK, 0, 0);
        soi_sfx_emit(w, SOI_SFX_BLOCK_BREAK);
    }
}

/* Enter the jump (a jump press seen by the idle / run / turn handlers): the asm only sets
 * state 2 with its counter at 0 on the press frame; the launch itself -- headroom test, bonk
 * or leap -- happens on the NEXT player frame, in jump_step. */
static void begin_jump(SoiPlayer *p)
{
    p->ground_state = SOI_ST_JUMP;
    p->in_air = 1;
    p->jump_t = 0;
}

static int check_jump_trigger(const SoiWorld *w, SoiPlayer *p, uint8_t in, uint8_t edge)
{
    if (w->input_assist) {
        if ((in & SOI_IN_JUMP) || (p->buf & SOI_IN_JUMP) || (edge & SOI_IN_JUMP)) {
            p->buf &= ~SOI_IN_JUMP;
            return 1;
        }
        return 0;
    }
    return (edge & SOI_IN_JUMP) != 0;
}

/* One head-bonk frame (asm ground-state 4, FUN_10014524): a fixed 10-frame recoil. The
 * frame counter is jump_t -- the asm reuses field 0x1003a9e2 for both the jump arc and
 * this bonk (you cannot jump and bonk at once), so the port does too. Each frame advances
 * the counter; the block is cracked/broken ONCE, at the MIDPOINT (counter == 5); on the
 * 10th frame the player returns to IDLE. This handler moves nothing -- the caller's
 * `return` after it is the FREEZE (no run/build/jump while the recoil plays). */
static void bonk_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    p->jump_t++;                                  /* asm: sVar3 = counter + 1; counter = sVar3 */
    if (p->jump_t < 10) {
        p->frame = (p->facing == 1) ? BONK_R[p->jump_t] : BONK_L[p->jump_t];   /* the arm-up recoil */
        if (p->jump_t == 5) do_head_break(w, player);
    } else {
        p->ground_state = SOI_ST_IDLE;            /* asm: counter reaches 10 -> ground_state 0 */
        p->frame = stand_frame(p);
        p->jump_t = 0;
    }
}

/* Commit a finished death: debit a life (from the co-op pool, FUN_1000e9c8) and either
 * schedule the board reload or eliminate at lives < 0 (the displayed "0 lives" is still a
 * playable last life: FUN_1000e9c8 allows -1, FUN_1001f4f8 games-over at lives<0, the HUD
 * clamps to 0). In a CHALLENGE ROUND the round just fails instead: FUN_10016f80(failed)
 * restores the board-start score/lives/ammo and the board is skipped, so no life is spent and
 * no reload is scheduled -- the player stays down and soi_challenge_failed reports it. */
static void commit_death(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    p->in_air = 0;
    p->alive = 0;
    p->ground_state = SOI_ST_IDLE;
    if (w->challenge) return;
    if (--soi_pool(w, player)->lives < 0) p->eliminated = 1;
    else p->respawn_timer = 90;
}

/* One JUMP frame (asm FUN_10013404, ground-state 2): the table-driven arc. */
static void jump_step(SoiWorld *w, int player, uint8_t in)
{
    SoiPlayer *p = &w->players[player];
    int y;
    restore_frame(p);
    /* The LAUNCH frame (counter 0, the player frame after the press): a solid block directly
     * overhead is a HEAD-BONK, not a leap (FUN_10012444 head-clear fails -> ground-state 4
     * FUN_10014524, entered with its counter at 0) -- the frozen 10-frame recoil. It uses the
     * SAME two-column head-clear as the rising jump, so the bonk detection and the midpoint
     * destroy (do_head_break) resolve the overhead cell by the asm's own geometry for every x.
     * Permanent (0x100) / door (0x800) blocks ALSO bonk (the recoil plays) but survive: the
     * midpoint destroy no-ops on them. Headroom is blocked by the SUPPORTIVE bit ALONE, so a
     * non-solid goodie/coin overhead (0x9xx, no 0x200) is NOT a bonk -- the player leaps up INTO
     * it. The destroy uses the facing column (x+0x12 right / x+0xc left) while this detection
     * uses the x+0x10 & x+0x0e straddle -- that asymmetry is in the ORIGINAL, so at a column
     * boundary a bonk can leave the facing destroy-target empty (a faithful bonk-without-
     * break). With clear headroom the tumble starts from frame 0x85 (facing right) / 0x7e
     * (left). The launch is SILENT. */
    if (p->jump_t == 0) {
        if (!headroom_clear(w, p)) {
            p->ground_state = SOI_ST_BONK;
            p->in_air = 0;
            return;
        }
        p->aux = (p->facing == 1) ? 0x85 : 0x7e;
    }
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
        commit_death(w, player);
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    if (y < IN_AIR_TOP_Y) y = IN_AIR_TOP_Y;
    p->y = (int16_t)y;
    p->aux++;                                     /* the somersault advances a frame per player frame */
    air_drift(w, p, in);                          /* input air-steer only (wall-rebound handled above) */
    if (p->facing == 1) { if (p->aux > 0x8d) p->aux = 0x86; }   /* right tumble 0x86..0x8d */
    else if (p->aux > 0x85) p->aux = 0x7e;                      /* left tumble 0x7e..0x85 */
    if (p->jump_t > 12 && supported(w, p)) {      /* past the apex + ground -> land */
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
        if (in & (SOI_IN_LEFT | SOI_IN_RIGHT)) {  /* landing with a direction held runs on at once */
            p->ground_state = SOI_ST_RUN;
            p->jump_t = 0;
        }
    }
    /* the tumble art comes in two sets drawn 2 px apart: +0x10 at an odd 2-px x (the sprite is
     * blitted 4-px aligned) */
    p->frame = (int16_t)(p->aux + ((p->x & 2) ? 0x10 : 0));
}

/* Gravity fall (asm state 3, FUN_1001386c): a flat 4 px/frame descent until the
 * feet find ground; off the board bottom (y >= 446) is a pit death. The fall is
 * PURELY VERTICAL -- FUN_1001386c calls ONLY the wall-rebound (FUN_10012554) for
 * any x change; it reads NO input, so you CANNOT steer a cliff-fall (unlike the
 * jump FUN_10013404, which does air-steer). Walking off a ledge drops straight
 * down (+ wall rebound if you fall against a wall), never at an angle. The player
 * shows the stand frame while falling, and lands into the stand (state 0). */
static void fall_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int y;
    restore_frame(p);
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
    p->frame = stand_frame(p);
    y = p->y + 4;
    if (y >= IN_AIR_DEATH_Y) {
        commit_death(w, player);
        soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
        return;
    }
    p->y = (int16_t)y;
    if (supported(w, p)) {
        p->in_air = 0;
        p->ground_state = SOI_ST_IDLE;
        snap_to_ground(p);
        p->frame = stand_frame(p);
        p->jump_t = 0;
        return;
    }
}

/* One DEATH-THROW frame (asm FUN_10011fcc, dying flag +0x28): the computed
 * parabola Y = (base*10 - 30*t + floor(t*t/2)) / 10, clamp low 48. It NEVER lands;
 * the arc carries the dying player off the bottom (y >= 446) to the life-loss +
 * respawn commit. The death cry already played at launch (soi_player_hit). The arms
 * flap by ping-ponging the frame 0x75..0x7d (FUN_10012228 starts it at 0x75 stepping
 * down, so the first shown frame is 0x76). */
static void death_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    int t, y;
    p->jump_t++;
    p->frame = (int16_t)(p->frame + p->dstep);
    if (p->frame >= 0x7e)     { p->frame = 0x7c; p->dstep = -1; }
    else if (p->frame < 0x75) { p->frame = 0x76; p->dstep = 1; }
    t = p->jump_t;
    y = (p->launch_y * 10 - 30 * t + (t * t) / 2) / 10;
    if (y < IN_AIR_TOP_Y) y = IN_AIR_TOP_Y;
    if (y >= IN_AIR_DEATH_Y) {
        commit_death(w, player);
        return;
    }
    p->y = (int16_t)y;
}

/* The two run cycles (asm FUN_10012bf4): one frame per 2 px stride, right 0x19..0x30 and
 * left 1..0x18 -- 24 directional frames each, never mirrored. */
static void run_frame_r(SoiPlayer *p) { if (++p->frame >= 0x31) p->frame = 0x19; }
static void run_frame_l(SoiPlayer *p) { if (++p->frame >= 0x19) p->frame = 1; }

/* IDLE (asm FUN_100128f8, state 0): stand 4-px aligned; walk off -> fall; a jump press ->
 * jump; a held direction -> run, or first TURN (states 9/10) if facing the other way.
 * Right beats left, and a jump beats both. */
static void idle_step(SoiWorld *w, int player, uint8_t in, uint8_t edge)
{
    SoiPlayer *p = &w->players[player];
    restore_frame(p);
    p->x &= ~3;
    p->frame = stand_frame(p);
    if (!supported(w, p)) {
        p->in_air = 1;
        p->ground_state = SOI_ST_FALL;
        return;
    }
    /* (the asm also re-snaps y to the row here, FUN_100137f8 -- a no-op for a player at rest,
     * which an idle player always is: every landing and spawn already rests him on the row) */
    if (check_jump_trigger(w, p, in, edge)) { begin_jump(p); return; }
    if (in & SOI_IN_RIGHT) {
        p->jump_t = 0;
        if (p->facing == 1) p->ground_state = SOI_ST_RUN;
        else { p->ground_state = SOI_ST_TURN_R; p->facing = 1; }
    } else if (in & SOI_IN_LEFT) {
        p->jump_t = 0;
        if (p->facing == -1) p->ground_state = SOI_ST_RUN;
        else { p->ground_state = SOI_ST_TURN_L; p->facing = -1; }
    }
}

/* RUN (asm FUN_10012bf4, state 1): a 2 px stride per frame with the leg frame advancing one
 * step. The first stride frame is picked by x parity (right 0x1a / 0x19, left 1 / 2). Letting
 * go of the key does not stop the player dead: a stride only ends 4-px aligned, so a half
 * stride is finished first (stepping back instead if the way ahead is now blocked), and then
 * the player STOPs (state 0xc) -- or, if the other direction is held, TURNS round (state 0xb).
 * Running into a wall runs in place (two leg frames every other frame). A jump press leaps
 * from the stride. Walking off a ledge falls. An action that interrupted the run resumes its
 * stride, or drops straight to the stand if no direction is still held. */
static void run_step(SoiWorld *w, int player, uint8_t in, uint8_t edge)
{
    SoiPlayer *p = &w->players[player];
    const int R = (in & SOI_IN_RIGHT) != 0, L = (in & SOI_IN_LEFT) != 0;
    if (p->act_dirty) {
        restore_frame(p);
        if (!R && !L) {
            p->ground_state = SOI_ST_IDLE;
            p->jump_t = 0;
            p->frame = stand_frame(p);
            return;
        }
    }
    if (!supported(w, p)) {
        p->in_air = 1;
        p->ground_state = SOI_ST_FALL;
        return;
    }
    if (p->facing == 1) {
        if (p->jump_t == 0) p->frame = (p->x & 2) ? 0x1a : 0x19;
        if (check_jump_trigger(w, p, in, edge)) { begin_jump(p); return; }
        if (R || (p->x & 2)) {
            if (move_clear(w, p, 1))  { p->x += 2; run_frame_r(p); }
            else if (!R)              { p->x -= 2; run_frame_r(p); }   /* blocked mid-stride: back */
            else if (p->jump_t & 1)   { run_frame_r(p); run_frame_r(p); }   /* against a wall */
            p->jump_t++;
        } else if (L) {
            p->ground_state = SOI_ST_TURN; p->jump_t = 0; p->facing = -1;
        } else {
            p->ground_state = SOI_ST_STOP; p->jump_t = 0;
        }
    } else if (p->facing == -1) {
        if (p->jump_t == 0) p->frame = (p->x & 2) ? 1 : 2;
        if (check_jump_trigger(w, p, in, edge)) { begin_jump(p); return; }
        if (L || (p->x & 2)) {
            if (move_clear(w, p, -1)) { p->x -= 2; run_frame_l(p); }
            else if (!L)              { p->x += 2; run_frame_l(p); }
            else if (p->jump_t & 1)   { run_frame_l(p); run_frame_l(p); }
            p->jump_t++;
        } else if (R) {
            p->ground_state = SOI_ST_TURN; p->jump_t = 0; p->facing = 1;
        } else {
            p->ground_state = SOI_ST_STOP; p->jump_t = 0;
        }
    }
}

/* TURN from a stand (asm FUN_10013ddc state 9 = face right / FUN_10013f68 state 10 = face
 * left): three turning frames (0x5b..0x5d / 0x5e..0x60) standing still, then run on from
 * frame 0x27 / 2 if the key is still held, else stand. A jump press leaps out of it. */
static void turn_idle_step(SoiWorld *w, int player, uint8_t in, uint8_t edge, int right)
{
    SoiPlayer *p = &w->players[player];
    (void)w;
    restore_frame(p);
    p->facing = (int16_t)(right ? 1 : -1);
    if (p->jump_t++ == 0) p->frame = right ? 0x5a : 0x5d;
    if (check_jump_trigger(w, p, in, edge)) { begin_jump(p); return; }
    if (++p->frame > (right ? 0x5d : 0x60)) {
        if (in & (right ? SOI_IN_RIGHT : SOI_IN_LEFT)) {
            p->ground_state = SOI_ST_RUN;             /* the counter stays > 0: no stride restart */
            p->frame = right ? 0x27 : 2;
        } else {
            p->ground_state = SOI_ST_IDLE;
        }
    }
}

/* TURN mid-run (asm FUN_10013c18, state 0xb; the facing is already the new one): a 4-frame
 * turn standing still -- three frames from TURN_FROM[stride frame], then the run carries on in
 * the new direction from TURN_TO[stride frame]. A jump press leaps out of it. */
static void turn_run_step(SoiWorld *w, int player, uint8_t in, uint8_t edge)
{
    SoiPlayer *p = &w->players[player];
    (void)w;
    restore_frame(p);
    if (check_jump_trigger(w, p, in, edge)) { begin_jump(p); return; }
    if (p->jump_t++ == 0) {
        p->aux = TURN_TO[run_index(p->frame)];
        p->frame = TURN_FROM[run_index(p->frame)];
    } else {
        p->frame++;
        if (p->jump_t == 4) {
            p->ground_state = SOI_ST_RUN;
            p->frame = p->aux;
        }
    }
}

/* STOP (asm FUN_100140f4, state 0xc): the legs come together -- the frame steps 2 at a time
 * to STOP_TO[stride frame] -- then SETTLE. No key is read meanwhile: the player cannot run
 * or jump until he has settled (a build/fire still starts, and afterwards he just stands). */
static void stop_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    (void)w;
    if (p->act_dirty) {
        restore_frame(p);
        p->ground_state = SOI_ST_IDLE; p->jump_t = 0;
        p->frame = stand_frame(p);
        return;
    }
    if (w->input_assist && check_jump_trigger(w, p, p->input, 0)) {
        begin_jump(p);
        return;
    }
    if (p->jump_t++ == 0) p->aux = STOP_TO[run_index(p->frame)];
    p->frame = (int16_t)(p->frame + ((p->aux < p->frame) ? -2 : 2));
    /* A stride always ends on a frame of the target's parity (the run advances one frame per
     * 2 px from an x-parity start, and a stop comes 4-px aligned). Only a teleport mid-stride
     * could break that; bound the swing so it can never leave the player stuck. */
    if (p->frame == p->aux || p->jump_t > 12) {
        p->frame = p->aux;
        if (p->frame == 0x1a) p->frame = 2;
        if (p->frame == 0x31) p->frame = 0x19;
        p->ground_state = SOI_ST_SETTLE; p->jump_t = 0;
    }
}

/* SETTLE (asm FUN_1001431c, state 0xd): three frames of the feet planting (from 0x31 / 0x36 /
 * 0x3a / 0x3f by the leg frame), then the stand. Also ignores the keys. */
static void settle_step(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    (void)w;
    if (p->act_dirty) {
        restore_frame(p);
        p->ground_state = SOI_ST_IDLE; p->jump_t = 0;
        p->frame = stand_frame(p);
        return;
    }
    if (w->input_assist && check_jump_trigger(w, p, p->input, 0)) {
        begin_jump(p);
        return;
    }
    if (p->jump_t++ == 0) {
        if      (p->frame < 5)    p->frame = 0x31;
        else if (p->frame < 0x11) p->frame = 0x36;
        else if (p->frame < 0x1c) p->frame = 0x3a;
        else if (p->frame < 0x28) p->frame = 0x3f;
    } else {
        p->frame++;
    }
    if (p->jump_t > 2) { p->ground_state = SOI_ST_IDLE; p->jump_t = 0; }
}

/* The build/fire ACTION (asm FUN_1001166c lines 14-157). It runs before the movement
 * handler on every live player frame, whatever the ground state -- idle, running, mid-
 * jump, falling, even mid head-bonk. With no action running, a key PRESS starts one: its
 * anim mode picks the pose table (3/4 facing right, 1/2 left; 4/2 = the low block) and
 * nothing else happens that frame. Each later frame advances the counter: frames 1..6 show
 * pose[counter], the VERB -- toggle the block, or fire -- happens on frame 5, and on frame 7
 * the action ends and the movement handler runs again on that SAME frame. So every action
 * freezes the player for 7 frames, and a new one can start no sooner than the frame after
 * the release (a press during an action is lost: the key latches are rebuilt from fresh
 * press edges every frame, FUN_1002d440). A player mashing the block key in mid-air
 * therefore keeps sinking -- one fall step (4 px) per 8 frames -- instead of hovering.
 * Key priority is the asm nesting: high block, low block, Arrow (latch +0x24 -> FUN_100110b4
 * = the port's straight soi_ball_fire), Ball (+0x23 -> FUN_10010d30 = the rolling
 * soi_projectile_fire). Returns 1 while the movement handler must not run. */
static int action_step(SoiWorld *w, int player, uint8_t edge)
{
    SoiPlayer *p = &w->players[player];
    const int right = (p->facing >= 0);
    if (p->pose == 0) {
        uint8_t act = edge;
        if (w->input_assist) act |= p->buf;
        if      (act & SOI_IN_BLOCK_HIGH) { p->pose = right ? 3 : 1; p->act_verb = SOI_ACT_BLOCK; p->buf &= ~SOI_IN_BLOCK_HIGH; }
        else if (act & SOI_IN_BLOCK_LOW)  { p->pose = right ? 4 : 2; p->act_verb = SOI_ACT_BLOCK; p->buf &= ~SOI_IN_BLOCK_LOW; }
        else if (act & SOI_IN_ARROW)      { p->pose = right ? 3 : 1; p->act_verb = SOI_ACT_ARROW; p->buf &= ~SOI_IN_ARROW; }
        else if (act & SOI_IN_BALL)       { p->pose = right ? 3 : 1; p->act_verb = SOI_ACT_BALL; p->buf &= ~SOI_IN_BALL; }
        else return 0;
        p->pose_t = 0;
        p->act_dirty = 1;                  /* FUN_10014700: remember the frame it interrupts */
        p->frame_save = p->frame;
        return 1;
    }
    if (++p->pose_t < 7) p->frame = ACT_FRAMES[p->pose][p->pose_t];
    if (p->pose_t == 5) {
        if (p->act_verb == SOI_ACT_BLOCK)
            do_block(w, player, p->pose == 1 || p->pose == 3, p->pose >= 3);
        else if (p->act_verb == SOI_ACT_ARROW)
            soi_ball_fire(w, player);
        else if (p->act_verb == SOI_ACT_BALL)
            soi_projectile_fire(w, player);
    }
    if (p->pose_t < 7) return 1;
    p->pose = 0;
    p->act_verb = SOI_ACT_NONE;
    return 0;
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

    if (w->input_assist) {
        uint8_t verbs = edge & (SOI_IN_JUMP | SOI_IN_BLOCK_HIGH | SOI_IN_BLOCK_LOW | SOI_IN_ARROW | SOI_IN_BALL);
        if (verbs) {
            p->buf |= verbs;
            p->buf_t = 6;
        } else if (p->pose == 0 && p->ground_state != SOI_ST_BONK && p->buf_t > 0) {
            if (--p->buf_t == 0) p->buf = 0;
        }
    }

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

    /* The build/fire ACTION runs FIRST, whatever the ground state (see action_step): while
     * one is running -- its start frame included -- the movement handler below does not run
     * at all, so the player hangs frozen mid-run, mid-jump, mid-fall or mid-bonk. */
    if (action_step(w, player, edge)) return;

    /* The movement switch (asm FUN_1001166c case-switch on +0x1c). The head-bonk recoil
     * (case 4, FUN_10014524) is a frozen 10-frame animation dispatched AFTER the walk-over
     * pickup: the asm runs the per-player pickup pass (FUN_1002bc64) every 30Hz frame gated
     * ONLY on the player-active flags, NEVER on ground_state, so a bonking player still
     * collects goodies. Wall-rebound (FUN_10012554) and the pit death live INSIDE the jump /
     * fall handlers, so an action freezes them too. (A dying player never reaches here --
     * gated at the top on SOI_ST_DEAD, matching asm FUN_1001166c line 13.) */
    switch (p->ground_state) {
        case SOI_ST_IDLE:   idle_step(w, player, in, edge);         break;
        case SOI_ST_RUN:    run_step(w, player, in, edge);          break;
        case SOI_ST_JUMP:   jump_step(w, player, in);               break;
        case SOI_ST_FALL:   fall_step(w, player);                   break;
        case SOI_ST_BONK:   bonk_step(w, player);                   break;
        case SOI_ST_TURN_R: turn_idle_step(w, player, in, edge, 1); break;
        case SOI_ST_TURN_L: turn_idle_step(w, player, in, edge, 0); break;
        case SOI_ST_TURN:   turn_run_step(w, player, in, edge);     break;
        case SOI_ST_STOP:   stop_step(w, player);                   break;
        case SOI_ST_SETTLE: settle_step(w, player);                 break;
        default:                                                    break;
    }
}
