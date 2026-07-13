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

/* Walk-over goodie pickup for the player's current cell (FUN_1002bc64).
 * Coin/gem values are CONFIRMED; the rest are first-draft (TODO(oracle)). */
void soi_pickup_check(SoiWorld *w, int player)
{
    SoiPlayer *p = &w->players[player];
    uint32_t c;
    unsigned t;
    /* Pick up from the player's COLLISION-BOX CENTRE, not its left/top edge: asm
     * FUN_1002bc64 converts (x+0xc, y+0x10) to a cell before the goody lookup. The
     * port used raw p->x (the left edge), so a coin was only collected once the
     * player was fully centred/past it; +0xc/+0x10 collects it on first real touch. */
    int pcol = (p->x + 0x0C - SOI_ORIGIN_X) / SOI_CELL_PX;
    int prow = (p->y + 0x10 - SOI_ORIGIN_Y) / SOI_CELL_PX;
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
    /* DOOR: bit 0x800 with a LOW type 1-3 (the exit). The original gates the exit on the
     * PLAYER (asm FUN_1002bc64: uVar10 == sVar14+1 || uVar10 == 1): low 1 = UNIVERSAL,
     * low (player+1) = that player's OWN door (P1->low2, P2->low3). Coins/goodies also
     * carry 0x800 but with a higher low type, so the t<=3 bound also avoids swallowing them. */
    if ((c & SOI_CELL_DOOR) && t <= 3u && (t == 1u || t == (unsigned)player + 1u)) {
        if (p->has_key == 1) {            /* first exit through the door: level won */
            int j;
            p->has_key = 2;
            /* Board complete: award EACH player their OWN remaining bonus x mult and
             * zero it -- FUN_100153d0 runs the per-player tally FUN_10015714 for every
             * player, not just the door-exiter (per-player @0x1003a9f0 x @f4). */
            for (j = 1; j < SOI_MAX_PLAYERS; j++) {
                SoiPlayer *pj = &w->players[j];
                if (pj->active) {
                    pj->score += (int)pj->bonus_time * pj->mult;
                    pj->bonus_time = 0;
                    /* No-Weapons Reward: added ONCE (not x mult) if this player never fired a
                     * weapon this board -- asm FUN_10015714 draws it at row 0x158 and adds it. */
                    if (pj->no_weapons_reward >= 1)
                        pj->score += pj->no_weapons_reward;
                }
            }
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
    if ((c & SOI_CELL_DOOR) && t >= 7u && t <= 9u && (t == 7u || t == (unsigned)player + 7u)) {
        int cc, rr;
        p->has_key = 1;                              /* the key is now held (player-gated:
                                                      * key 7 universal, key player+7 own; asm
                                                      * FUN_1002bc64 uVar10 == sVar14+7 || == 7) */
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

    /* Stop/Go switches (0x24-0x2D = 5 pairs), each paired with a BLOCK GROUP
     * (0x9d-0xd3; group g: even 0x9d+12g / odd 0xa3+12g). CONFIRMED (asm FUN_10016544 /
     * 100166b8 / 10016784 / 1001604c + a full board scan, 2026-07-06): each toggle
     * stamps the block cell (code | 0x300) in BOTH states, and NO collision code
     * special-cases 0x9d-0xd3 -- so both states are SOLID walls and the switch is a
     * COSMETIC sprite swap (Stop-sign <-> Go-sign) with NO gameplay effect on player OR
     * enemy pathing. The port therefore treats it as a gameplay NO-OP (blocks stay solid
     * as loaded; boards are 152/152 winnable that way). The port previously mis-modeled
     * it as a global enemy-freeze, which the asm has no basis for -- enemies_frozen is
     * now vestigial. TODO(cosmetic-only, low pri): the animated sprite swap + switch
     * sound (evt 0x2c) -- needs edge-detection (pickup runs every player tick) and has
     * zero gameplay impact, so it is deferred. */
    if (t >= 0x24u && t <= 0x2Du)
        return;
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
        case 0x10: p->lives += 1;    break;   /* 1UP: goody 0x10 grants +1 LIFE. asm FUN_1002bc64 ->
                                               * FUN_1000e9c8(player, +1); +0x46 is the LIVES counter --
                                               * CONFIRMED: FUN_1000f500 calls FUN_1000e9c8(p, -1) when the
                                               * bonus reaches 0 ("if the Bonus reaches zero, you die"), and
                                               * FUN_1000e9c8 eliminates the player when the count goes < 0.
                                               * (The old "shield (+0x46)" label was WRONG -- +0x46 = lives.) */
        case 0x11: p->arrows += 1;   break;   /* Magic Arrow ammo (asm FUN_1000eb34 -> +0x4c, arrow-fire reads +0x4c) */
        case 0x12: p->balls += 1;    break;   /* Magic Ball ammo (asm FUN_1000ec50 -> +0x4a, ball-fire reads +0x4a) */
        case 0x2E:                            /* TURTLES (asm FUN_1002bc64 -> _DAT_1003b294 = 600):
                                               * SLOW every nasty to half speed for ~10s. (The CLOCK that
                                               * adds bonus points is the 0x13-0x16 time goodies above.) */
            w->enemy_slow = 600;
            break;
        case 0x13: case 0x14: case 0x15: case 0x16: {
            /* time bonuses x1..x4 = +2500/5000/7500/10000, cap 30000 (CONFIRMED,
             * decompiled FUN_1000f3f0). */
            static const int add[4] = { 2500, 5000, 7500, 10000 };
            p->bonus_time += add[t - 0x13];   /* adds to the COLLECTING player's bonus (FUN_1000f3f0) */
            if (p->bonus_time > 30000) p->bonus_time = 30000;
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
        case 0x30: p->invuln = 600; break;    /* shield (activate): timed i-frames */
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
            default:   s = SOI_SFX_POWERUP;       break;
        }
        soi_sfx_emit(w, s);
    }
    w->cell[prow][pcol] = SOI_CELL_EMPTY; /* a collected goodie clears its cell */
}
