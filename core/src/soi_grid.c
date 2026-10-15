/* soi_grid.c — playfield grid: coordinate conversion, the block create/destroy
 * verb, and goodie pickup. Grid cell encoding + verb behaviour are CONFIRMED
 * (docs runtime-structures §6/§8, FUN_1002d04c / FUN_100279c4 / FUN_1002bc64).
 */
#include "soi_internal.h"

int soi_cell_x(int col) { return col * SOI_CELL_PX + SOI_ORIGIN_X; }
int soi_cell_y(int row) { return row * SOI_CELL_PX + SOI_ORIGIN_Y; }

int soi_in_bounds(int col, int row)
{
    return col >= 0 && col < SOI_MAX_GRID_COLS && row >= 0 && row < SOI_MAX_GRID_ROWS;
}

static inline int in_world_bounds(const SoiWorld *w, int col, int row)
{
    int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
    int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
    return col >= 0 && col < max_c && row >= 0 && row < max_r;
}

uint32_t soi_get_cell(const SoiWorld *w, int col, int row)
{
    if (!in_world_bounds(w, col, row)) return SOI_WALL; /* out of bounds = solid */
    return w->cell[row][col];
}

void soi_set_cell(SoiWorld *w, int col, int row, uint32_t v)
{
    if (in_world_bounds(w, col, row)) w->cell[row][col] = v;
}

/* ---------------------------------------------------------------------------
 * Block build/remove animations (asm FUN_1002754c starts one, FUN_100283a0 advances
 * every live one each frame, FUN_100274e8 links the 10 slots at a board start).
 * A BUILD grows through block_sprites frames 1..5 (small -> full white square) and
 * then shows the built block; a REMOVAL (the player's toggle, a chomping nasty's
 * FUN_100279c4) plays the same frames 5..1. Both take 6 frames, and the cell only
 * takes its final value when the animation ends:
 *   build:   cell |= 0x300 at once (standable AND locked -- nothing can toggle, smash
 *            or bonk a growing block), then `fin` = template + inherited payload;
 *   removal: the block is erased at once (FUN_1002cc10: a payload goody shows through,
 *            else empty) but the cell stays standable (|0x200) until it has shrunk,
 *            then `fin` = the payload or 0.
 * ------------------------------------------------------------------------- */
void soi_blockanim_start(SoiWorld *w, int col, int row, int step, int type, uint32_t fin)
{
    int i, slot = -1;
    SoiBlockAnim *a;
    if (!in_world_bounds(w, col, row)) return;
    for (i = 0; i < SOI_BLOCKANIM_MAX; i++)            /* FUN_10027834: this cell already animating? */
        if (w->banim[i].active && w->banim[i].col == col && w->banim[i].row == row) slot = i;
    for (i = 0; slot < 0 && i < SOI_BLOCKANIM_MAX; i++)
        if (!w->banim[i].active) slot = i;
    if (slot < 0) return;                               /* all 10 busy: the asm drops the request */
    a = &w->banim[slot];
    a->active = 1;
    a->col = (int16_t)col; a->row = (int16_t)row;
    a->step = (int8_t)((step < 0) ? -1 : 1);
    a->type = (uint8_t)type;
    a->fin = fin;
    if (a->step < 0) {
        uint32_t c = w->cell[row][col];
        a->frame = 6;
        w->cell[row][col] = ((c & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(c) : 0u) | SOI_CELL_SUPPORTIVE;
    } else {
        a->frame = 0;
        w->cell[row][col] |= SOI_WALL;
    }
}

void soi_blockanims_update(SoiWorld *w)
{
    int i;
    for (i = 0; i < SOI_BLOCKANIM_MAX; i++) {
        SoiBlockAnim *a = &w->banim[i];
        int next;
        if (!a->active) continue;
        next = a->frame + a->step;
        if (next > 0 && next < 6) { a->frame = (int8_t)next; continue; }   /* show frame `next` */
        w->cell[a->row][a->col] = a->fin;   /* finished: the built block, or the payload / empty */
        a->active = 0;
    }
}

/* asm FUN_100279c4: a breakable block (not permanent, non-empty) is removed through the
 * shrink animation, revealing its 0x1000 payload goody when it ends. */
void soi_block_remove(SoiWorld *w, int col, int row)
{
    uint32_t c = soi_get_cell(w, col, row);
    if (!in_world_bounds(w, col, row) || (c & SOI_CELL_PERMANENT) || SOI_CELL_TYPE(c) == 0) return;
    soi_blockanim_start(w, col, row, -1, 0, (c & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(c) : 0u);
}

/* Shatter a breakable block: FUN_1002cc10 clears it at once (to its payload goody or 0)
 * and its four 16x16 quarters (block_sprites asm frames type+2..type+5: top-left,
 * top-right, bottom-right, bottom-left) fly off as debris. Offsets + velocities (1/10 px
 * per frame) are the asm's own, including FUN_10027ecc's second piece starting at the
 * top-LEFT corner. */
void soi_block_shatter(SoiWorld *w, int col, int row, int kind, int vx, int vy)
{
    static const int8_t OFS[4][2] = { { 0, 0 }, { 16, 0 }, { 16, 16 }, { 0, 16 } };
    static const int8_t VEL[4][4][2] = {
        { { -40, -80 }, { 40, -80 }, { 60, -70 }, { -60, -70 } },   /* FUN_1002ca5c head-bonk (gravity) */
        { {  40, -40 }, { 53, -20 }, { 53,  20 }, {  40,  40 } },   /* FUN_10027d84 blast right */
        { { -53, -20 }, { -40, -40 }, { -40, 40 }, { -53, 20 } },   /* FUN_10027ecc blast left */
        { { -10,  10 }, { 10,  10 }, { 15,  15 }, { -15,  15 } },   /* FUN_10027aec Hammer smash (gravity) */
    };
    static const int8_t SPREAD[4][2] = { { -3, -3 }, { 3, -3 }, { 3, 3 }, { -3, 3 } };   /* FUN_10027c34 */
    uint32_t c = soi_get_cell(w, col, row);
    int t, x, y, k;
    if (!in_world_bounds(w, col, row) || (c & SOI_CELL_PERMANENT) || SOI_CELL_TYPE(c) == 0) return;
    t = (int)SOI_CELL_TYPE(c);
    x = soi_cell_x(col); y = soi_cell_y(row);
    w->cell[row][col] = (c & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(c) : 0u;
    for (k = 0; k < 4; k++) {
        int px = x + OFS[k][0], py = y + OFS[k][1], pvx, pvy, grav;
        if (kind == SOI_SHATTER_LEFT && k == 1) px = x;      /* the asm's own quirk */
        if (kind == SOI_SHATTER_DIR) {
            pvx = vx + SPREAD[k][0]; pvy = vy + SPREAD[k][1]; grav = 0;
        } else {
            pvx = VEL[kind][k][0]; pvy = VEL[kind][k][1];
            grav = (kind == SOI_SHATTER_BONK || kind == SOI_SHATTER_DROP);
        }
        soi_fx_emit(w, SOI_FX_SHEET_BLOCK, t + 2 + k, px, py, pvx, pvy, grav);
    }
}

/* ---------------------------------------------------------------------------
 * Stop/Go switches (asm FUN_1001604c load-register / FUN_10016544 toggle /
 * FUN_100166b8 state-advance / FUN_10016784 per-frame animator; confirmed
 * against the decomp + a full board scan). A switch is a REAL solid<->passable
 * path-gate, not the cosmetic no-op the port previously assumed. A switch BLOCK
 * has low byte 0x9d-0xd3 (group g = (low-0x9d)/12; SOLID code 0x9d+12g, PASSABLE
 * code 0xa3+12g). A switch TILE (low 0x24-0x2d, walk-on) toggles every block in
 * its group (g = (low-0x24)/2) when the player STEPS onto it.
 * ------------------------------------------------------------------------- */

/* Register one switch BLOCK into the registry and normalise its live cell to the
 * canonical solid/passable code for its loaded state (asm FUN_1001604c). The asm
 * switches on the EXACT low byte: only the 10 settled codes -- SOLID 0x9d+12g (rem 0)
 * and PASSABLE 0xa3+12g (rem 6), for groups g=0..4 -- are real switch blocks. A low in
 * 0x9d..0xd3 that is not one of those (no board ships one) is ignored, matching the
 * asm's default-less switch. */
static void soi_switch_register(SoiWorld *w, int low, int col, int row)
{
    int g, rem, i;
    if (low < 0x9d || low > 0xd3) return;
    g   = (low - 0x9d) / 12;
    rem = (low - 0x9d) % 12;
    if (rem != 0 && rem != 6) return;         /* not one of the 10 real switch codes */
    if (w->sw_count >= SOI_SWITCH_MAX) return;
    i = w->sw_count++;
    w->sw_col[i]   = (int16_t)col;
    w->sw_row[i]   = (int16_t)row;
    w->sw_group[i] = (uint8_t)g;
    w->sw_solid[i] = (uint8_t)(0x9d + 12 * g);
    w->sw_pass[i]  = (uint8_t)(0xa3 + 12 * g);
    w->sw_ctr[i]   = 0;
    if (rem == 0) {                 /* loaded as the SOLID variant */
        w->sw_state[i] = 2;
        soi_set_cell(w, col, row, (uint32_t)w->sw_solid[i] + 0x300u);   /* PERMANENT|SUPPORTIVE */
    } else {                        /* rem == 6: loaded as the PASSABLE variant */
        w->sw_state[i] = 1;
        soi_set_cell(w, col, row, (uint32_t)w->sw_pass[i] + 0x100u);    /* PERMANENT, no 0x200 */
    }
}

/* Scan the whole grid after a board load and register every switch block. Mirrors
 * the asm post-load pass (FUN_1002de00: skip door 0x800 / badguy 0x400 / empty, then
 * FUN_1001604c(cell & 0xff, col, row) -- the LOW byte, so a raw 0x3a9 registers as 0xa9). */
void soi_switch_load_scan(SoiWorld *w)
{
    int r, c;
    int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
    int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
    w->sw_count = 0;
    for (r = 0; r < max_r; r++)
        for (c = 0; c < max_c; c++) {
            uint32_t cell = w->cell[r][c];
            if (cell == 0) continue;
            if (cell & (SOI_CELL_DOOR | 0x400u)) continue;   /* door / badguy spawn */
            soi_switch_register(w, (int)(cell & 0xffu), c, r);
        }
}

/* Toggle every switch block in the group a stepped-on switch TILE selects (asm
 * FUN_10016544 -> FUN_100166b8 state flip). The switch SOUND is played by the caller
 * on entry (asm FUN_1002bc64 plays FUN_1002b020(0x2c,10) unconditionally after this),
 * so it is NOT emitted here. Solidity is updated per-frame by soi_switch_animate. */
void soi_switch_toggle(SoiWorld *w, int tile_low)
{
    int g = (tile_low - 0x24) / 2;
    int i;
    for (i = 0; i < w->sw_count; i++) {
        if (w->sw_group[i] != g) continue;
        switch (w->sw_state[i]) {
            case 1: w->sw_state[i] = 4; w->sw_ctr[i] = 8; break;  /* passable -> closing */
            case 2: w->sw_state[i] = 3; w->sw_ctr[i] = 0; break;  /* solid    -> opening */
            case 3: w->sw_state[i] = 4; break;                    /* opening  -> closing (reverse) */
            case 4: w->sw_state[i] = 3; break;                    /* closing  -> opening (reverse) */
            default: break;
        }
    }
}

/* Advance every switch block's open/close animation one frame (asm FUN_10016784).
 * OPENING (state 3): stays SOLID for the whole ~9-frame swing, then settles PASSABLE.
 * CLOSING (state 4): SOLID immediately, counts the swing down, then settles SOLID.
 * So a block is passable ONLY once an open fully completes -- solid at all other times. */
void soi_switch_animate(SoiWorld *w)
{
    int i;
    for (i = 0; i < w->sw_count; i++) {
        int col = w->sw_col[i], row = w->sw_row[i];
        if (w->sw_state[i] == 3) {                 /* opening */
            if (w->sw_ctr[i] == 0)
                soi_set_cell(w, col, row, (uint32_t)w->sw_pass[i] + 0x300u); /* still solid while opening */
            w->sw_ctr[i]++;
            if (w->sw_ctr[i] >= 9) {
                w->sw_state[i] = 1;
                soi_set_cell(w, col, row, (uint32_t)w->sw_pass[i] + 0x100u); /* now passable */
            }
        } else if (w->sw_state[i] == 4) {          /* closing */
            soi_set_cell(w, col, row, (uint32_t)w->sw_solid[i] + 0x300u);    /* solid at once */
            if (w->sw_ctr[i] > 0) w->sw_ctr[i]--;
            if (w->sw_ctr[i] == 0) w->sw_state[i] = 2;
        }
    }
}

/* Mark a collected key held. Outside COMPETE every player gets the key flag (asm
 * FUN_1002bc64: DAT_1003ab6c == 0 -> uRam1003aa47 = uRam1003aab7 = 1); in COMPETE only
 * the collector does. A player who already exited (has_key 2) keeps that marker. */
static void give_key(SoiWorld *w, int player)
{
    int j;
    const int shared = (w->play_mode != SOI_MODE_COMPETE && w->play_mode != SOI_MODE_VERSUS);
    for (j = 1; j < SOI_MAX_PLAYERS; j++) {
        SoiPlayer *pj = &w->players[j];
        if (pj->has_key == 2) continue;
        if (j == player || (shared && pj->active)) pj->has_key = 1;
    }
}

/* Walk-over goodie pickup for the player's current cell (FUN_1002bc64).
 * Coin/gem values are CONFIRMED; the rest are first-draft (TODO(oracle)). */
void soi_pickup_check(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    SoiPlayer *cp = soi_pool(w, player);   /* who is CREDITED (the co-op pool, else self) */
    const int competitive = (w->play_mode == SOI_MODE_COMPETE || w->play_mode == SOI_MODE_VERSUS);
    const int p3_any = (player == 3 && w->p3_any_key);
    uint32_t c;
    unsigned t;
    /* Pick up from the player's COLLISION-BOX CENTRE, not its left/top edge: asm
     * FUN_1002bc64 converts (x+0xc, y+0x10) to a cell before the goody lookup. The
     * port used raw p->x (the left edge), so a coin was only collected once the
     * player was fully centred/past it; +0xc/+0x10 collects it on first real touch. */
    int pcol = (p->x + 0x0C - SOI_ORIGIN_X) / SOI_CELL_PX;
    int prow = (p->y + 0x10 - SOI_ORIGIN_Y) / SOI_CELL_PX;
    if (!in_world_bounds(w, pcol, prow)) return;
    c = w->cell[prow][pcol];
    t = SOI_CELL_TYPE(c);

    /* Stop/Go switch (b41): step onto a switch TILE (low 0x24-0x2d) to toggle its paired
     * block GROUP. The toggle fires ONLY on the frame the player ENTERS a new cell (asm
     * FUN_1002bc64 bVar12 = cell changed this frame), so a switch held under a standing
     * player does not re-fire. Track the collision-centre cell every frame -- BEFORE the
     * key/door/teleport early-returns below -- so the edge is never lost. */
    {
        int entered = (pcol != p->prev_pcol || prow != p->prev_prow);
        p->prev_pcol = (int16_t)pcol;
        p->prev_prow = (int16_t)prow;
        if (t >= 0x24u && t <= 0x2Du) {
            if (entered) {
                soi_switch_toggle(w, (int)t);
                soi_sfx_emit(w, SOI_SFX_SWITCH);  /* asm FUN_1002bc64 plays evt 0x2c on entry, always */
                w->cell[prow][pcol] = c ^ 1u;   /* flip the Stop<->Go sign (low bit) in place */
            }
            return;                             /* a switch tile is walk-on, never collected */
        }
    }

    /* KEY (0x0B, CONFIRMED docs §0): collect to open the door. */
    if (t == SOI_TILE_KEY) {
        give_key(w, player);
        soi_sfx_emit(w, SOI_SFX_POWERUP);
        soi_fx_emit(w, SOI_FX_SHEET_GOODY, (int)t, soi_cell_x(pcol), soi_cell_y(prow), 0, -80, 1);
        w->cell[prow][pcol] = SOI_CELL_EMPTY;
        return;
    }
    /* DOOR: bit 0x800 with a LOW type 1-3 (the exit). The original gates the exit on the
     * PLAYER (asm FUN_1002bc64: uVar10 == sVar14+1 || uVar10 == 1): low 1 = UNIVERSAL,
     * low (player+1) = that player's OWN door (P1->low2, P2->low3). Coins/goodies also
     * carry 0x800 but with a higher low type, so the t<=3 bound also avoids swallowing them.
     * There is NO held-key test: an opened door exists only after the colored-key sweep
     * (no board ships one pre-opened), so the door itself is the gate -- in co-op the partner
     * of the key collector can exit too. The asm DOES require the box not to straddle two
     * rows: row(y) must equal the pickup row(y+0x10) (FUN_1002e6f8(y) == sVar11). */
    if ((c & SOI_CELL_DOOR) &&
        ((t <= 3u && (t == 1u || t == (unsigned)player + 1u || p3_any)) ||
         ((player == 3 || !competitive || p3_any) && c == 0x0935u))) {
        int yrow = (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (p->y < SOI_ORIGIN_Y) yrow = -1;
        if (yrow == prow && p->has_key != 2) {   /* first exit through the door: level won */
            int j;
            p->has_key = 2;
            /* Board complete: award EACH player their OWN remaining bonus x mult and
             * zero it -- FUN_100153d0 runs the per-player tally FUN_10015714 for every
             * player, not just the door-exiter (per-player @0x1003a9f0 x @f4). In co-op
             * the team pool (player 1's slot) is tallied once. */
            for (j = 1; j < SOI_MAX_PLAYERS; j++) {
                SoiPlayer *pj = &w->players[j];
                if (soi_pool_idx(w, j) != j) continue;
                if (pj->active) {
                    pj->score += (int)pj->bonus_time * pj->mult;
                    pj->bonus_time = 0;
                    /* No-Weapons Reward: added ONCE (not x mult) if this player never fired a
                     * weapon this board -- asm FUN_10015714 draws it at row 0x158 and adds it.
                     * A Challenge Round skips that tally (FUN_10028a0c: `if (!DAT_1003ad0e)
                     * FUN_100153d0`); its reward screen FUN_10016f80 pays only Bonus x mult. */
                    if (pj->no_weapons_reward >= 1 && !w->challenge)
                        pj->score += pj->no_weapons_reward;
                }
            }
            soi_sfx_emit(w, SOI_SFX_POWERUP);
        }
        return;
    }
    /* COLORED KEY (low 7/8/9 with 0x800, and discrete P3 Red Key 0x0933) -- the real boards' key/exit system
     * (FUN_1002bc64). No board ships a plain 0x0B key or a pre-open 0x80x door;
     * instead each board pairs a colored key (0x0907/8/9) with matching LOCK
     * cells (0x0904/5/6, low = key-3). Collecting the key holds it and sweeps the
     * grid, turning every matching lock into an OPENED DOOR (cell = low + 0x8fd
     * => 0x901/0x902/0x903 = low 1/2/3 + 0x800). Stepping on an opened door then
     * hits the DOOR branch above and completes the level. Key 7 is universal;
     * 8/9 are per-player, but low-1 doors (from key 7) are universal exits.
     * Discrete P3 Red Key 0x0933 unlocks P3 Red Lock 0x0934 into 0x0935. */
    if ((c & SOI_CELL_DOOR) &&
        ((t >= 7u && t <= 9u && (t == 7u || t == (unsigned)player + 7u || p3_any)) ||
         (c == 0x0933u && (player == 3 || !competitive || p3_any)))) {
        int cc, rr;
        give_key(w, player);                         /* the key is now held (player-gated:
                                                      * key 7 universal, key player+7 own; asm
                                                      * FUN_1002bc64 uVar10 == sVar14+7 || == 7) */
        if (c == 0x0933u) {
            if (!competitive) {
                int pj;
                for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
                    if (w->players[pj].active) w->players[pj].keys |= (1u << 10);
                }
            } else {
                p->keys |= (1u << 10);
            }
        }
        int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
        int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
        for (rr = 0; rr < max_r; rr++) {
            for (cc = 0; cc < max_c; cc++) {
                uint32_t lc = w->cell[rr][cc];
                unsigned lt = SOI_CELL_TYPE(lc);
                if (c == 0x0933u) {
                    if (lc == 0x0934u)
                        w->cell[rr][cc] = 0x0935u;
                } else {
                    if ((lc & SOI_CELL_DOOR) && lt + 3u == t)
                        w->cell[rr][cc] = lt + 0x8FDu;   /* lock -> opened door (asm) */
                }
            }
        }
        soi_sfx_emit(w, SOI_SFX_KEY);                /* colored-key collect (evt 0x14 -> 17661 "Announce") */
        soi_fx_emit(w, SOI_FX_SHEET_GOODY, (int)(c == 0x0933u ? 0x33 : t), soi_cell_x(pcol), soi_cell_y(prow), 0, -80, 1);
        w->cell[prow][pcol] = SOI_CELL_EMPTY;        /* consume the key */
        return;
    }
    if (c == 0x0934u && (player == 3 || !competitive || p3_any) && (p->keys & (1u << 10))) {
        w->cell[prow][pcol] = 0x0935u | SOI_CELL_SUPPORTIVE | SOI_CELL_DOOR;
        return;
    }
    if (t == 0) return;

    /* Transporters (0x1A-0x23 = 5 IN/OUT pairs): stepping on an IN marker zaps
     * the player to its paired OUT marker (FUN_1002b9bc). These are permanent
     * infrastructure — handled before the permanent guard and never consumed.
     * Pairing CONFIRMED (decompiled FUN_1002bc64: five hardcoded blocks scan the
     * whole grid for code IN+1 and teleport to the FIRST match; even = IN, the next
     * odd = OUT; OUT tiles are inert; no row constraint. This transporter check
     * runs from soi_pickup_check, which now fires every tick (not only when the
     * player is cell-aligned); the player's occupied cell is resolved by the same
     * (x+0xc, y+0x10) probe the asm uses, so a mid-stride step onto an IN marker
     * teleports exactly as the original does. OUT tiles being inert prevents any
     * teleport loop, so this stays determinism-safe. */
    if (t >= 0x1Au && t <= 0x23u) {
        if ((t & 1u) == 0u) {                 /* even = IN: seek the paired OUT */
            unsigned out_type = t + 1u;
            int r, col;
            /* STRADDLE GUARD (asm FUN_1002bc64:44-49): for types 0x1a-0x22 the teleport
             * fires only when the collision box sits in ONE column -- if col(x+0x12) !=
             * the pickup-reference col(x+0xc)=pcol the box straddles two cells and the IN
             * does NOT trigger. Both sides use the same truncating /32 as pcol. For the
             * reachable range (the left border wall pins the player at x>=16, so both
             * dividends x-4 and x+2 are >= 0) this /32 equals the asm's FUN_1002e6cc(x+0xc)
             * vs FUN_1002e6cc(x+0x12) equality: the +1 cell-offset cancels. (The raw math
             * only diverges for x in [0,3], where x+0xc-16 is negative and truncation
             * clamps to 0 while the asm also returns 0 for the LEFT probe but 1 for the
             * right -- a window the wall makes unreachable.) Stops a half-stride step onto
             * an edge-of-cell IN from zapping before the player is over it. */
            if ((p->x + 0x12 - SOI_ORIGIN_X) / SOI_CELL_PX != pcol) return;
            int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
            int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
            for (r = 0; r < max_r; r++)
                for (col = 0; col < max_c; col++)
                    if (SOI_CELL_TYPE(w->cell[r][col]) == out_type &&
                        !(w->cell[r][col] & SOI_CELL_SUPPORTIVE)) {   /* a walk-on OUT marker,
                              * NOT a solid block that shares the low byte (pink = 0x1F) */
                        /* the asm moves the player by the cell delta, keeping its offset in the cell */
                        p->x += (col - pcol) * SOI_CELL_PX;
                        p->y += (r - prow) * SOI_CELL_PX;
                        soi_sfx_emit(w, SOI_SFX_TELEPORT);
                        if (w->play_mode != SOI_MODE_COMPETE) {
                            w->tp_freeze = 211;
                        }
                        return;
                    }
        }
        return;                               /* OUT marker (odd): no teleport */
    }

    /* Stop/Go switch TILES (low 0x24-0x2d) are now handled at the TOP of this function
     * (entry-edge toggle of the paired block group); control never reaches here for them.
     * The prior "cosmetic no-op" assumption was WRONG -- see the switch code in this file. */
    /* Solid blocks (0x2xx/0x3xx) carry the 0x200 SUPPORTIVE bit and are never
     * "collected" — bail before the goodie switch so a block whose low byte
     * happens to collide with a goodie type is not consumed. Goodies/coins are
     * non-supportive overlays (0x800/0x900, no 0x200). */
    if (c & SOI_CELL_SUPPORTIVE) return;

    if (t == 0xFFu && (c & SOI_CELL_DOOR))   /* a landed Knight GIFT BOX (asm uVar10 == 0xff): */
        t = SOI_CELL_PAYLOAD(c) & 0xFFu;       /* it pays out the goody kept in its high word */

    switch (t) {
        case 0x0A: cp->score += 500;  break;   /* silver coin   (CONFIRMED) */
        case 0x17: cp->score += 1000; break;   /* gold coin     (CONFIRMED) */
        case 0x18: cp->score += 2000; break;   /* gem           (CONFIRMED) */
        case 0x19: cp->score += 5000; break;   /* gold bars     (CONFIRMED) */
        case 0x10: cp->lives += 1;    break;   /* 1UP: goody 0x10 grants +1 LIFE. asm FUN_1002bc64 ->
                                               * FUN_1000e9c8(player, +1); +0x46 is the LIVES counter --
                                               * CONFIRMED: FUN_1000f500 calls FUN_1000e9c8(p, -1) when the
                                               * bonus reaches 0 ("if the Bonus reaches zero, you die"), and
                                               * FUN_1000e9c8 eliminates the player when the count goes < 0.
                                               * (The old "shield (+0x46)" label was WRONG -- +0x46 = lives.) */
        case 0x11: cp->arrows += 1;   break;   /* Magic Arrow ammo (asm FUN_1000eb34 -> +0x4c, arrow-fire reads +0x4c) */
        case 0x12: cp->balls += 1;    break;   /* Magic Ball ammo (asm FUN_1000ec50 -> +0x4a, ball-fire reads +0x4a) */
        case 0x2E:                            /* TURTLES (asm FUN_1002bc64 -> _DAT_1003b294 = 600):
                                               * SLOW every nasty to half speed for ~10s. (The CLOCK that
                                               * adds bonus points is the 0x13-0x16 time goodies above.) */
            w->enemy_slow = 600;
            break;
        case 0x13: case 0x14: case 0x15: case 0x16: {
            /* time bonuses x1..x4 = +2500/5000/7500/10000, cap 30000 (CONFIRMED,
             * decompiled FUN_1000f3f0). */
            static const int add[4] = { 2500, 5000, 7500, 10000 };
            cp->bonus_time += add[t - 0x13];  /* adds to the CREDITED player's bonus (FUN_1000f3f0) */
            if (cp->bonus_time > 30000) cp->bonus_time = 30000;
            break;
        }
        case 0x2F:                            /* MAGNIFYING GLASS (asm FUN_10016b28): temporarily reveal
                                               * every hidden-treasure (0x1000 SPECIAL) cell. The asm
                                               * busy-waits ~300 ticks drawing a marker over each hidden
                                               * cell, then hides them; we arm a non-blocking reveal timer
                                               * and draw the overlay Godot-side while it counts down.
                                               * NOTE: 0x2F is NOT thunderballs -- defeating every nasty is
                                               * the 0x31 goody below (FUN_1000543c). */
            w->reveal_timer = 300;
            break;
        case 0x30: p->invuln = 600; p->fast = 0; break;   /* shield (activate): timed i-frames. Shield
                                               * and shoes share ONE power-up slot (asm FUN_10014c28 /
                                               * FUN_10014ccc: mode +0x5c = 2 / 1, one timer +0x6e), so
                                               * grabbing either replaces the other. */
        case 0x31: {                          /* THUNDERBALLS (asm FUN_1000543c): defeat every real nasty,
                                               * credited to the collecting player (sets each active
                                               * enemy's +0x88 "claimed" field -> defeated on its next update). */
            int e;
            for (e = 0; e < SOI_MAX_ENEMIES; e++)
                if (w->enemies[e].active) w->enemies[e].claimed = (uint8_t)player;
            break;
        }
        case 0x32:                            /* speed shoes: 2x player speed for ~20s.
                                               * asm FUN_10014ccc arms fast-mode +0x5c=1 +
                                               * timer +0x6e=0x4b0(1200). NOT a 1UP -- the
                                               * 1UP is goody 0x10 (FUN_1000e9c8 -> +0x46 lives). */
            p->fast = 1200;
            p->invuln = 0;                    /* replaces an active shield (shared slot, see 0x30) */
            break;
        case 0x0C: case 0x0D: case 0x0E: case 0x0F:
            /* score multiplier 2x/3x/4x/5x (asm FUN_10011428(player, type-0x0A) -> +0x44).
             * SET (not stacked); multiplies the end-of-level bonus at the door exit
             * (mult x bonus_timer, tallied by FUN_10029264). Coins stay unmultiplied. */
            cp->mult = (int16_t)(t - 0x0Au);
            break;
        default:
            /* 0x1a-0x23 transporters, 0x24-0x2d stop/go handled above. */
            return;
    }
    /* SFX: coins play a per-tier sound (asm FUN_1002bc64 events: silver 0x15,
     * gold 0x1c, gem 0x1d, bars 0x1e); everything else uses the generic chime. */
    if (t == 0x0A || t == 0x17 || t == 0x18 || t == 0x19) {
        soi_sfx_emit(w, (t == 0x17) ? SOI_SFX_COIN_GOLD :
                        (t == 0x18) ? SOI_SFX_COIN_GEM  :
                        (t == 0x19) ? SOI_SFX_COIN_BARS : SOI_SFX_COIN);
        if (w->goodies_left > 0) w->goodies_left--;   /* treasure collected (level objective) */
    } else {
        SoiSfx s;
        switch (t) {                                   /* per-goody sounds (FUN_1002bc64, ch 10) */
            case 0x10: s = SOI_SFX_PICKUP_SHIELD; break;   /* 1UP extra-life (asm evt 0x18 -> 31429; the enum
                                                             * name is a legacy misnomer -- 0x10 is a life, not a shield) */
            case 0x11: s = SOI_SFX_PICKUP_ARROW;  break;   /* arrow ammo    (evt 0x19 -> 3001)  */
            case 0x12: s = SOI_SFX_PICKUP_BALL;   break;   /* ball ammo     (evt 0x1a -> 24336) */
            case 0x13: case 0x14: case 0x15: case 0x16:
                       s = SOI_SFX_PICKUP_TIME;   break;   /* time bonus    (evt 0x1b -> 7119)  */
            case 0x2E: s = SOI_SFX_CLOCK;         break;   /* turtles (slow) (evt 0x2B -> 1005) */
            case 0x2F: s = SOI_SFX_THUNDER;       break;   /* magnifying glass (evt 0x26); the enum
                                                             * name is a legacy misnomer for this resource */
            case 0x30: s = SOI_SFX_SHIELD_ON;     break;   /* shield on     (evt 0x29 -> 1003)  */
            case 0x31: s = SOI_SFX_WHISTLE;       break;   /* thunderballs (FUN_1000543c, evt 0x2a -> 1004) */
            case 0x32: s = SOI_SFX_SHOES;         break;   /* speed shoes (FUN_10014ccc, evt 0x28 -> 1002) */
            case 0x0C: case 0x0D: case 0x0E: case 0x0F:
                       s = SOI_SFX_MULT;          break;   /* score multiplier (evt 0x17 -> 15128) */
            default:   s = SOI_SFX_POWERUP;       break;
        }
        soi_sfx_emit(w, s);
    }
    /* The collected goody POPS: asm FUN_1002bc64 erases it and launches its sprite as a
     * particle (FUN_100278bc(goody sheet, type, cell x/y, vx 0, vy -80, gravity)) that
     * jumps up two cells (64 px at frame 16) and falls off the bottom of the board. */
    soi_fx_emit(w, SOI_FX_SHEET_GOODY, (int)t, soi_cell_x(pcol), soi_cell_y(prow), 0, -80, 1);
    w->cell[prow][pcol] = SOI_CELL_EMPTY; /* a collected goodie clears its cell */
}

int soi_switch_block_frame(const SoiWorld *w, int col, int row)
{
    int i;
    if (!w) return -1;
    for (i = 0; i < w->sw_count; i++) {
        if (w->sw_col[i] == col && w->sw_row[i] == row) {
            int g = w->sw_group[i];
            int stop_f = 2 + 8 * g;
            int go_f   = 9 + 8 * g;
            if (w->sw_state[i] == 2) return stop_f;
            if (w->sw_state[i] == 1) return go_f;
            if (w->sw_state[i] == 3 || w->sw_state[i] == 4) {
                int ctr = w->sw_ctr[i];
                if (ctr > 7) ctr = 7;
                return stop_f + ctr;
            }
        }
    }
    return -1;
}
