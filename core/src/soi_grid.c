/* soi_grid.c — playfield grid: coordinate conversion, the block create/destroy
 * verb, and goodie pickup. Grid cell encoding + verb behaviour are CONFIRMED
 * (docs runtime-structures §6/§8, FUN_1002d04c / FUN_100279c4 / FUN_1002bc64).
 */
#include "soi_internal.h"

int soi_cell_x(int col) { return col * SOI_CELL_PX + SOI_ORIGIN_X; }
int soi_cell_y(int row) { return row * SOI_CELL_PX + SOI_ORIGIN_Y; }

int soi_in_bounds(int col, int row)
{
    return col >= 0 && col < SOI_GRID_COLS && row >= 0 && row < SOI_GRID_ROWS;
}

uint32_t soi_get_cell(const SoiWorld *w, int col, int row)
{
    if (!soi_in_bounds(col, row)) return SOI_WALL; /* out of bounds = solid */
    return w->cell[row][col];
}

void soi_set_cell(SoiWorld *w, int col, int row, uint32_t v)
{
    if (soi_in_bounds(col, row)) w->cell[row][col] = v;
}

/* Create-or-destroy toggle at (col,row) for player (FUN_1002d04c). Permanent
 * cells are untouched; empty+buildable -> create the player's block type;
 * occupied -> destroy (revealing any 0x1000 payload as the new cell type). */
void soi_block_action(SoiWorld *w, int col, int row, int player)
{
    uint32_t c;
    if (!soi_in_bounds(col, row)) return;
    c = w->cell[row][col];
    if (c & SOI_CELL_PERMANENT) return;                 /* immutable */

    if (SOI_CELL_TYPE(c) == SOI_CELL_EMPTY) {
        /* create a block of the player's current type */
        uint8_t bt = w->players[player].block_type;
        int victim;
        if (bt == 0) bt = 1;                            /* default block type */
        /* a block created on an enemy's cell squashes it (the namesake verb). */
        victim = soi_enemy_at(w, col, row);
        if (victim >= 0) soi_enemy_kill(w, victim, player);
        w->cell[row][col] = bt;
        soi_sfx_emit(w, SOI_SFX_BLOCK_CREATE);
        /* TODO(oracle): support/adjacency rule + create SFX (FUN_1002b020(4,7)). */
    } else {
        /* destroy: if it carries a payload (special block), that becomes the
         * revealed goodie; otherwise the cell clears. */
        if (c & SOI_CELL_SPECIAL) {
            w->cell[row][col] = SOI_CELL_PAYLOAD(c);
        } else {
            w->cell[row][col] = SOI_CELL_EMPTY;
        }
        soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
        /* TODO(oracle): destroy animation + SFX (FUN_1002b020(3,7)); block-on-
         * enemy kill (a dropped/created block that lands on an enemy). */
    }
}

/* Walk-over goodie pickup for the player's current cell (FUN_1002bc64).
 * Coin/gem values are CONFIRMED; the rest are first-draft (TODO(oracle)). */
void soi_pickup_check(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    uint32_t c;
    unsigned t;
    int pcol = (p->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    int prow = (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    if (!soi_in_bounds(pcol, prow)) return;
    c = w->cell[prow][pcol];
    t = SOI_CELL_TYPE(c);

    /* KEY (0x0B, CONFIRMED docs §0): collect to open the door. */
    if (t == SOI_TILE_KEY) {
        p->has_key = 1;
        soi_sfx_emit(w, SOI_SFX_POWERUP);
        w->cell[prow][pcol] = SOI_CELL_EMPTY;
        return;
    }
    /* DOOR: bit 0x800 with a LOW type 0-3 (the exit, matched to the player id;
     * docs §0). Coins/goodies also carry 0x800 but with a higher low type, so
     * gate on t <= 3 to avoid swallowing them here. */
    if ((c & SOI_CELL_DOOR) && t <= 3u) {
        if (p->has_key == 1) {            /* first exit through the door: level won */
            p->has_key = 2;
            p->score += w->bonus_timer * p->mult; /* bonus x score-multiplier (FUN_10029264: +0x40 * +0x44) */
            w->bonus_timer = 0;
            soi_sfx_emit(w, SOI_SFX_POWERUP);
        }
        return;
    }
    /* COLORED KEY (low 7/8/9 with 0x800) -- the real boards' key/exit system
     * (FUN_1002bc64). No board ships a plain 0x0B key or a pre-open 0x80x door;
     * instead each board pairs a colored key (0x0907/8/9) with matching LOCK
     * cells (0x0904/5/6, low = key-3). Collecting the key holds it and sweeps the
     * grid, turning every matching lock into an OPENED DOOR (cell = low + 0x8fd
     * => 0x901/0x902/0x903 = low 1/2/3 + 0x800). Stepping on an opened door then
     * hits the DOOR branch above and completes the level. Key 7 is universal;
     * 8/9 are per-player, but low-1 doors (from key 7) are universal exits. */
    if ((c & SOI_CELL_DOOR) && t >= 7u && t <= 9u) {
        int cc, rr;
        p->has_key = 1;                              /* the key is now held */
        for (rr = 0; rr < SOI_GRID_ROWS; rr++)
            for (cc = 0; cc < SOI_GRID_COLS; cc++) {
                uint32_t lc = w->cell[rr][cc];
                unsigned lt = SOI_CELL_TYPE(lc);
                if ((lc & SOI_CELL_DOOR) && lt + 3u == t)
                    w->cell[rr][cc] = lt + 0x8FDu;   /* lock -> opened door (asm) */
            }
        soi_sfx_emit(w, SOI_SFX_KEY);                /* colored-key collect (evt 0x14 -> 17661 "Announce") */
        w->cell[prow][pcol] = SOI_CELL_EMPTY;        /* consume the key */
        return;
    }
    if (t == 0) return;

    /* Transporters (0x1A-0x23 = 5 IN/OUT pairs): stepping on an IN marker zaps
     * the player to its paired OUT marker (FUN_1002b9bc). These are permanent
     * infrastructure — handled before the permanent guard and never consumed.
     * Pairing CONFIRMED (decompiled FUN_1002bc64: five hardcoded blocks scan the
     * whole grid for code IN+1 and teleport to the FIRST match; even = IN, the next
     * odd = OUT; OUT tiles are inert; no row constraint. The asm also gates on the
     * player being fully within one column before firing — our pickup only runs
     * when the player is cell-aligned, so that gate is already satisfied). */
    if (t >= 0x1Au && t <= 0x23u) {
        if ((t & 1u) == 0u) {                 /* even = IN: seek the paired OUT */
            unsigned out_type = t + 1u;
            int r, col;
            for (r = 0; r < SOI_GRID_ROWS; r++)
                for (col = 0; col < SOI_GRID_COLS; col++)
                    if (SOI_CELL_TYPE(w->cell[r][col]) == out_type &&
                        !(w->cell[r][col] & SOI_CELL_SUPPORTIVE)) {   /* a walk-on OUT marker,
                              * NOT a solid block that shares the low byte (pink = 0x1F) */
                        p->x = soi_cell_x(col); p->y = soi_cell_y(r);
                        soi_sfx_emit(w, SOI_SFX_TELEPORT);
                        return;
                    }
        }
        return;                               /* OUT marker (odd): no teleport */
    }

    /* Stop/Go switches (0x24-0x2D = 5 pairs): stepping on a Stop marker (even)
     * halts every nasty; a Go marker (odd) resumes them. Persistent infra, not
     * consumed. Freeze-semantics + even/odd pairing are HYPOTHESIS TODO(oracle). */
    if (t >= 0x24u && t <= 0x2Du) {
        w->enemies_frozen = (uint8_t)(((t & 1u) == 0u) ? 1 : 0);
        return;
    }
    /* Solid blocks (0x2xx/0x3xx) carry the 0x200 SUPPORTIVE bit and are never
     * "collected" — bail before the goodie switch so a block whose low byte
     * happens to collide with a goodie type is not consumed. Goodies/coins are
     * non-supportive overlays (0x800/0x900, no 0x200). */
    if (c & SOI_CELL_SUPPORTIVE) return;

    switch (t) {
        case 0x0A: p->score += 500;  break;   /* silver coin   (CONFIRMED) */
        case 0x17: p->score += 1000; break;   /* gold coin     (CONFIRMED) */
        case 0x18: p->score += 2000; break;   /* gem           (CONFIRMED) */
        case 0x19: p->score += 5000; break;   /* gold bars     (CONFIRMED) */
        case 0x10: p->shield += 1;   break;   /* shield/protective pickup (asm FUN_1000e9c8 -> player +0x46) */
        case 0x11: p->arrows += 1;   break;   /* Magic Arrow ammo (asm FUN_1000eb34 -> +0x4c, arrow-fire reads +0x4c) */
        case 0x12: p->balls += 1;    break;   /* Magic Ball ammo (asm FUN_1000ec50 -> +0x4a, ball-fire reads +0x4a) */
        case 0x2E:                            /* clock (asm FUN_1002bc64 -> _DAT_1003b294 = 600):
                                               * SLOW every nasty to half speed for ~10s. */
            w->enemy_slow = 600;
            break;
        case 0x13: case 0x14: case 0x15: case 0x16: {
            /* time bonuses x1..x4 = +2500/5000/7500/10000, cap 30000 (CONFIRMED,
             * decompiled FUN_1000f3f0). */
            static const int add[4] = { 2500, 5000, 7500, 10000 };
            w->bonus_timer += add[t - 0x13];
            if (w->bonus_timer > 30000) w->bonus_timer = 30000;
            break;
        }
        case 0x2F: {                          /* thunderballs: kill every nasty */
            int e;
            for (e = 0; e < SOI_MAX_ENEMIES; e++)
                if (w->enemies[e].active) soi_enemy_kill(w, e, player);
            break;
        }
        case 0x30: p->invuln = 600; break;    /* shield (activate): timed i-frames */
        case 0x31: {                          /* shoes/turtles: tame every real nasty
                                               * so each is defeated for this player
                                               * (FUN_1000543c sets enemy +0x88). */
            int e;
            for (e = 0; e < SOI_MAX_ENEMIES; e++)
                if (w->enemies[e].active) w->enemies[e].claimed = (uint8_t)player;
            break;
        }
        case 0x32:                            /* speed shoes: 2x player speed for ~20s.
                                               * asm FUN_10014ccc arms fast-mode +0x5c=1 +
                                               * timer +0x6e=0x4b0(1200). NOT a 1UP -- no
                                               * goody grants a life in the dispatch. */
            p->fast = 1200;
            break;
        case 0x0C: case 0x0D: case 0x0E: case 0x0F:
            /* score multiplier 2x/3x/4x/5x (asm FUN_10011428(player, type-0x0A) -> +0x44).
             * SET (not stacked); multiplies the end-of-level bonus at the door exit
             * (mult x bonus_timer, tallied by FUN_10029264). Coins stay unmultiplied. */
            p->mult = (int16_t)(t - 0x0Au);
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
            case 0x10: s = SOI_SFX_PICKUP_SHIELD; break;   /* shield pickup (evt 0x18 -> 31429) */
            case 0x11: s = SOI_SFX_PICKUP_ARROW;  break;   /* arrow ammo    (evt 0x19 -> 3001)  */
            case 0x12: s = SOI_SFX_PICKUP_BALL;   break;   /* ball ammo     (evt 0x1a -> 24336) */
            case 0x13: case 0x14: case 0x15: case 0x16:
                       s = SOI_SFX_PICKUP_TIME;   break;   /* time bonus    (evt 0x1b -> 7119)  */
            case 0x2E: s = SOI_SFX_CLOCK;         break;   /* clock (slow)  (evt 0x2B -> 1005)  */
            case 0x2F: s = SOI_SFX_THUNDER;       break;   /* thunderballs                     */
            case 0x30: s = SOI_SFX_SHIELD_ON;     break;   /* shield on     (evt 0x29 -> 1003)  */
            case 0x31: s = SOI_SFX_WHISTLE;       break;   /* enemy-claim (FUN_1000543c, evt 0x2a -> 1004) */
            case 0x32: s = SOI_SFX_SHOES;         break;   /* speed shoes (FUN_10014ccc, evt 0x28 -> 1002) */
            default:   s = SOI_SFX_POWERUP;       break;
        }
        soi_sfx_emit(w, s);
    }
    w->cell[prow][pcol] = SOI_CELL_EMPTY; /* a collected goodie clears its cell */
}
