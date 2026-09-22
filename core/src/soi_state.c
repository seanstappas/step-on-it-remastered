/* soi_state.c — world lifecycle, BORD level loading, the per-frame tick, and
 * the canonical serialize + FNV-1a-64 state hash (MASTER_PLAN §5.5).
 * Integer-only; all logical state is fixed-width for cross-platform identical
 * hashing.
 */
#include "soi_internal.h"

/* ---------- byte helpers ---------- */
static uint16_t be16(const uint8_t *p) { return (uint16_t)((p[0] << 8) | p[1]); }
static uint32_t be32(const uint8_t *p)
{
    return ((uint32_t)p[0] << 24) | ((uint32_t)p[1] << 16) |
           ((uint32_t)p[2] << 8) | (uint32_t)p[3];
}

typedef struct { uint8_t *p; size_t cap, len; } SoiBuf;
static void bput(SoiBuf *b, const void *src, size_t n)
{
    const uint8_t *s = (const uint8_t *)src;
    size_t i;
    for (i = 0; i < n; i++) {
        if (b->len < b->cap && b->p) b->p[b->len] = s[i];
        b->len++;
    }
}
static void bput_u32(SoiBuf *b, uint32_t v)  /* little-endian */
{
    uint8_t t[4] = { (uint8_t)v, (uint8_t)(v >> 8), (uint8_t)(v >> 16), (uint8_t)(v >> 24) };
    bput(b, t, 4);
}
static void bput_i32(SoiBuf *b, int32_t v)  { bput_u32(b, (uint32_t)v); }
static void bput_u16(SoiBuf *b, uint16_t v) { uint8_t t[2] = { (uint8_t)v, (uint8_t)(v >> 8) }; bput(b, t, 2); }
static void bput_u8(SoiBuf *b, uint8_t v)   { bput(b, &v, 1); }

/* ---------- lifecycle ---------- */
size_t soi_world_size(void) { return sizeof(struct SoiWorld); }

static void zero_world(SoiWorld *w)
{
    uint8_t *p = (uint8_t *)w; size_t i;
    for (i = 0; i < sizeof(*w); i++) p[i] = 0;
}

void soi_world_init(SoiWorld *w, uint32_t seed)
{
    int i;
    zero_world(w);
    soi_rng_seed(w, seed ? seed : 1u);   /* Toolbox default seed = 1 */
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].lives = 2;         /* new-game lives (asm FUN_1002b060 -> +0x46 = 2; the 4 is COOPERATE's
                                          * shared pool only -- see soi_new_game). refs/images board_1/3 HUD: 02 */
        w->players[i].shield = 2;        /* VESTIGIAL (save/ABI stability only; the original has no hit-buffer) */
        w->players[i].block_type = 0x19; /* BLUE block: the player's BUILT blocks are blue in the
                                          * refs (montage/video), distinct from board white 0x07
                                          * (block_sprites: 0x07 white, 0x13 green, 0x19 blue). */
        w->players[i].balls  = 1;        /* new-game ammo (asm FUN_1002b060 -> +0x4a = 1) */
        w->players[i].arrows = 1;        /* new-game ammo (asm FUN_1002b060 -> +0x4c = 1) */
        w->players[i].mult   = 1;        /* score multiplier default 1 (asm FUN_1002b174 -> +0x44 = 1) */
    }
}

void soi_set_seed(SoiWorld *w, uint32_t seed) { soi_rng_seed(w, seed ? seed : 1u); }

/* ---------- BORD level loader (docs BORD §, FUN_1002b448/FUN_1001a348) ---------- */
static void place_player(SoiWorld *w, int idx, int col, int row)
{
    SoiPlayer *p = &w->players[idx];
    p->active = 1; p->alive = 1; p->eliminated = 0;
    p->x = soi_cell_x(col); p->y = soi_cell_y(row) + 1;   /* rest at block-top+1 (asm) */
    p->facing = 1;                 /* face right */
    p->move_ctr = 0; p->run_dir = 0; p->in_air = 0; p->ground_state = SOI_ST_IDLE;
    p->spawn_x = (int16_t)p->x; p->spawn_y = (int16_t)p->y;
    p->respawn_timer = 0;
    p->block_type = 0x07;
    p->input = 0; p->input_prev = 0;
    p->prev_pcol = (int16_t)col; p->prev_prow = (int16_t)row;   /* seed switch entry-edge to spawn cell */
    p->mult = 1;                   /* multiplier resets to 1 each level (asm FUN_1002b174 -> +0x44) */
}

/* Remaster extension: activate the 3rd co-op player. The BORD header has only two
 * spawns (P1 @0x06, P2 @0x0A), so P3 starts at P1's spawn column -- one cell to the
 * right if that cell is clear. Call after soi_load_level when 3 players are in. */
void soi_spawn_player3(SoiWorld *w)
{
    int col = (w->players[1].spawn_x - SOI_ORIGIN_X) / SOI_CELL_PX;
    int row = (w->players[1].spawn_y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    if (soi_in_bounds(col + 1, row) && SOI_CELL_TYPE(w->cell[row][col + 1]) == 0)
        col += 1;
    place_player(w, 3, col, row);
    w->players[3].bonus_time = w->players[1].bonus_time;   /* P3 shares the board's starting bonus */
}

/* Deactivate every player with index > n. The BORD header always spawns P1+P2, so a
 * 1-player game must turn P2 off (else it walks, draws, and consumes P2's input). Marks
 * them eliminated so completion / HUD / enemy-target logic all skip them. */
void soi_limit_players(SoiWorld *w, int n)
{
    int i;
    for (i = 1; i < SOI_MAX_PLAYERS; i++)
        if (i > n) {
            w->players[i].active = 0;
            w->players[i].alive = 0;
            w->players[i].eliminated = 1;
        }
}

/* Board->board transition: preserve the persistent per-player stats (score/lives/ammo/
 * shield -- new-game-only per FUN_1002b060) and the RNG stream, but otherwise fully reset
 * for the incoming board (mult=1/positions/has_key/grid/enemies via world_init+load_level,
 * matching the per-level reset FUN_1002b174). */
int soi_next_level(SoiWorld *w, const uint8_t *bord, size_t len)
{
    struct { int32_t score; int16_t lives, arrows, balls, shield; uint8_t elim; } keep[SOI_MAX_PLAYERS];
    uint32_t seed = w->rng_seed;
    uint8_t  mode = w->play_mode;
    int i, r;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        keep[i].score  = w->players[i].score;
        keep[i].lives  = w->players[i].lives;
        keep[i].arrows = w->players[i].arrows;
        keep[i].balls  = w->players[i].balls;
        keep[i].shield = w->players[i].shield;
        keep[i].elim   = w->players[i].eliminated;
    }
    soi_world_init(w, 1);                 /* full per-board reset (mult=1, transient cleared) */
    w->rng_seed = seed;                   /* continue the RNG stream across boards */
    w->play_mode = mode;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].score  = keep[i].score;
        w->players[i].lives  = keep[i].lives;
        w->players[i].arrows = keep[i].arrows;
        w->players[i].balls  = keep[i].balls;
        w->players[i].shield = keep[i].shield;
    }
    r = soi_load_level(w, bord, len);
    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (keep[i].elim) { w->players[i].eliminated = 1; w->players[i].alive = 0; }
    return r;
}

/* Overwrite a player's PERSISTENT stats -- used by Resume to restore a saved game onto a
 * freshly-loaded board (the save is board-start state, About doc 8). mult resets per board
 * (FUN_1002b174), so it is not restored here. */
void soi_set_player_stats(SoiWorld *w, int idx, int score, int lives, int arrows, int balls, int shield)
{
    SoiPlayer *p;
    if (idx < 1 || idx >= SOI_MAX_PLAYERS) return;
    p = &w->players[idx];
    p->score  = score;
    p->lives  = (int16_t)lives;
    p->arrows = (int16_t)arrows;
    p->balls  = (int16_t)balls;
    p->shield = (int16_t)shield;
}

void soi_set_play_mode(SoiWorld *w, int mode)
{
    if (mode < SOI_MODE_ONE || mode > SOI_MODE_COMPETE) mode = SOI_MODE_ONE;
    w->play_mode = (uint8_t)mode;
}

int soi_play_mode(const SoiWorld *w)
{
    return w->play_mode ? w->play_mode : SOI_MODE_ONE;
}

int soi_challenge_round(const SoiWorld *w) { return w->level_loaded && w->challenge; }

int soi_challenge_failed(const SoiWorld *w)
{
    int i, any = 0;
    if (!soi_challenge_round(w) || soi_level_complete(w)) return 0;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        const SoiPlayer *p = &w->players[i];
        if (!p->active || p->eliminated) continue;
        any = 1;
        if (p->alive) return 0;
    }
    return any;
}

/* New-game stats (asm FUN_1002b060): each player score 0 / lives 2 / ball 1 / arrow 1; in
 * COOPERATE (DAT_100370e4 == 0) player 1 instead holds the team pool 4 lives / 2 balls /
 * 2 arrows and player 2's own counter is parked at -1 (never read -- all credits go to the
 * pool). The remaster's P3 is treated like P2. */
void soi_new_game(SoiWorld *w, int mode)
{
    int i;
    soi_set_play_mode(w, mode);
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *p = &w->players[i];
        p->score = 0; p->lives = 2; p->balls = 1; p->arrows = 1;
    }
    if (w->play_mode == SOI_MODE_COOPERATE) {
        w->players[1].lives = 4; w->players[1].balls = 2; w->players[1].arrows = 2;
        for (i = 2; i < SOI_MAX_PLAYERS; i++) {
            w->players[i].lives = -1; w->players[i].balls = 0; w->players[i].arrows = 0;
        }
    }
}

int soi_load_level(SoiWorld *w, const uint8_t *bord, size_t len)
{
    size_t off;
    int bonus, i;
    if (!bord || len < 0x1A) return 0;

    /* header (26 bytes, big-endian u16) — CONFIRMED field roles */
    place_player(w, 1, be16(bord + 0x06), be16(bord + 0x08));
    place_player(w, 2, be16(bord + 0x0A), be16(bord + 0x0C));
    /* pct_ultrabuster (0x10), thrown_badguy (0x12), pct_badguy (0x14): the original VALIDATES
     * these at load (asm FUN_1002b448) -- any out-of-range value -> 0 (pct 0..100, thrown 0..20),
     * and thrown & pct are LINKED (either being 0 zeros both). 5 boards carry GARBAGE here:
     * 301/428/446/498 hold the ASCII marker "DATA" in bytes 0x10-0x15 (pct_ultra=8224,
     * thrown=17473, pct=21569) and board_440 has thrown=25. Without this clamp the port read them
     * raw, so pct_ultrabuster=8224 made EVERY Gargoyle shot an UltraBuster (always-pierce) -- an
     * unfaithful difficulty spike on those boards. */
    {
        int pu = (int16_t)be16(bord + 0x10);
        int tb = (int16_t)be16(bord + 0x12);
        int pb = (int16_t)be16(bord + 0x14);
        if (pu > 100 || pu < 0) pu = 0;
        if (tb > 20  || tb < 0) tb = 0;
        if (pb > 100 || pb < 0) pb = 0;
        if (tb == 0) pb = 0;
        if (pb == 0) tb = 0;
        w->pct_ultrabuster = (int16_t)pu;
        w->thrown_badguy   = (int16_t)tb;
        w->pct_badguy      = (int16_t)pb;
    }
    /* Per-board starting Bonus is at 0x0E, NOT 0x16. VERIFIED vs refs/images: board_1 has
     * 0x0E=3000 and the reference HUD reads "Bonus 02968"; board_2 has 0x0E=6000 and reads
     * "05995". Values are clean thousands (1500..30000, usually 6000). The old 0x16 read is
     * a separate 0/0x3A20 flag, so EVERY board wrongly defaulted to 5000 -- a timer AND
     * end-of-level-bonus (bonus x mult) fidelity bug across the whole campaign. */
    bonus = (int)be16(bord + 0x0E);
    if (bonus <= 0) bonus = 5000;   /* safety default */
    /* the "Bonus" is PER-PLAYER (@0x1003a9f0): each player gets their own copy of the
     * board's starting bonus, counts it down, and is awarded it x mult at the tally
     * (FUN_10015714, run per-player by FUN_100153d0). */
    for (i = 1; i < SOI_MAX_PLAYERS; i++)
        w->players[i].bonus_time = bonus;

    /* "No Weapons Reward" (BORD 0x16): each player is awarded it at completion UNLESS they fire a
     * weapon this board (asm FUN_1002b448 init / FUN_10010d30+100110b4 zero on fire / FUN_10015714
     * award). The field is the 0x3A20 sentinel (57 boards) or 0 (95 boards) -- BOTH map to 5000; no
     * board ships a custom value. VERIFIED vs the original gameplay video: the tally reads
     * "No Weapons Reward 5000" on every board. */
    {
        int16_t rwf = (int16_t)be16(bord + 0x16);
        int reward = (rwf == 0x3A20 || rwf < 1) ? 5000 : rwf;
        for (i = 1; i < SOI_MAX_PLAYERS; i++)
            w->players[i].no_weapons_reward = (int16_t)reward;
    }

    /* body: tile-placement records from 0x18, terminated by tile_type == 0.
     * record = [tile_type:u32 BE][ (col:u8, row:u8) pairs... ][ 0x64 0x64 ]
     * (first byte = COLUMN 0-18, second = ROW 0-12 -- CONFIRMED; matches the
     * (col,row) store below and soi_set_cell/soi_enemy_spawn's signatures). */
    off = 0x18;
    while (off + 4 <= len) {
        uint32_t tile = be32(bord + off);
        off += 4;
        if (tile == 0) break;               /* end of tile section */
        while (off + 2 <= len) {
            uint8_t a = bord[off], b = bord[off + 1];
            off += 2;
            if (a == 100 || b == 100) break; /* (100,100) sentinel */
            /* Badguy spawn block: the asm scanner FUN_1002d980 keys on bit 0x400
             * (byte2 == 0x05/0x06/0x07) and emits one enemy per block (low byte =
             * type; it does NOT stay in the grid as a tile). TODO(oracle): the
             * Start/Spawn-delay respawn cadence and the starting direction
             * (byte2's low 2 bits: 1=left, 2=right, 3=alternate). */
            if (tile & 0x400u) {
                int ei = soi_enemy_spawn(w, soi_bord_badguy_type((uint8_t)(tile & 0xFFu)), a, b);
                /* faithful starting direction (asm FUN_1002d980): cell bit 0x100
                 * => left, 0x200 => right, both => alternate, 0x2000 => seek. The
                 * spawn defaults to right; flip to left when only 0x100 is set. */
                if (ei >= 0 && (tile & 0x100u) && !(tile & 0x200u)) {
                    w->enemies[ei].dir = 1;
                    w->enemies[ei].vx  = (int16_t)-w->enemies[ei].vx;
                }
                if (ei >= 0) {
                    unsigned b0 = (tile >> 24) & 0xFFu;   /* StartDelay -> reload */
                    unsigned b1 = (tile >> 16) & 0xFFu;   /* SpawnDelay -> initial */
                    if ((tile & 0xFFu) == 3u)
                        w->enemies[ei].period = 2;       /* slow Wheelie: 1 px / 2 frames (FUN_10009e98) */
                    if ((tile & 0xFFu) == 8u)
                        w->enemies[ei].state = 8;        /* vertical Beanie (FUN_10006840): dir 2 = down, 1 = up */
                    if (w->enemies[ei].type == SOI_ENEMY_GARGOYLE ||
                        w->enemies[ei].type == SOI_ENEMY_KNIGHT) {
                        /* Throw cadence = the exact length of the asm phase machines (enemy
                         * +0x4e = b1 feeds the first wait, +0x50 = b0 every later one):
                         * Gargoyle FUN_1000adc4 = 96f wing flap, then max(1,b*6/80) 64f charge
                         * loops + a 172f wind-up per throw; Knight FUN_1000c2e8 = 96f flap,
                         * then a 4*max(1,b*6/5) hold + a 200f wind-up. Values are one less
                         * because enemy_shooter_fire throws on the call after fire_cd hits 0. */
                        int l0, l1;
                        if (w->enemies[ei].type == SOI_ENEMY_GARGOYLE) {
                            l0 = (int)(b0 * 6u / 80u); if (l0 < 1) l0 = 1;
                            l1 = (int)(b1 * 6u / 80u); if (l1 < 1) l1 = 1;
                            w->enemies[ei].fire_period = (int16_t)(64 * l0 + 172 - 1);
                            w->enemies[ei].fire_cd     = (int16_t)(64 * l1 + 269 - 1);
                        } else {
                            l0 = (int)(b0 * 6u / 5u); if (l0 < 1) l0 = 1;
                            l1 = (int)(b1 * 6u / 5u); if (l1 < 1) l1 = 1;
                            w->enemies[ei].fire_period = (int16_t)(4 * l0 + 200 - 1);
                            w->enemies[ei].fire_cd     = (int16_t)(4 * l1 + 301 - 1);
                        }
                    } else if (w->enemies[ei].type == SOI_ENEMY_CANNON) {
                        soi_set_cell(w, a, b, SOI_WALL);   /* FUN_100071a0 init: the cannon IS a solid wall cell */
                        /* Shooter fire cadence from the delay bytes
                         * (FUN_1002d980/FUN_100071a0 &c). */
                        if (b0 > 0) w->enemies[ei].fire_period = (int16_t)(b0 * 6);
                        w->enemies[ei].fire_cd = (int16_t)(b1 * 6);
                    } else if (soi_bord_is_spawner((uint8_t)(tile & 0xFFu))) {
                        /* Persistent spawner (FUN_100076a8 &c): a STATIONARY emitter
                         * that produces its base nasty (child = placement+0x64) every
                         * StartDelay*6 frames. We render it as a stationary instance
                         * of that nasty. TODO(oracle): the distinct spawner sprite. */
                        w->enemies[ei].spawn_child = (uint8_t)w->enemies[ei].type;
                        w->enemies[ei].vx = 0;                       /* stationary */
                        soi_set_cell(w, a, b, SOI_CELL_PERMANENT);   /* FUN_100076a8 &c init stamp: 0x100 */
                        w->enemies[ei].fire_period = (int16_t)((b0 ? b0 : 20u) * 6u);
                        w->enemies[ei].fire_cd = (int16_t)(b1 * 6u);
                        /* Emit DIRECTION MODE (asm FUN_100076a8 switch on +0x4c): the
                         * fixed left/right cases use the dir set above; flag ALTERNATE
                         * (both dir bits 0x100|0x200 -> toggle each emit) and SEEK
                         * (0x2000 -> aim at the nearest player) in `state` for the emitter. */
                        if (tile & 0x2000u)                 w->enemies[ei].state = 4;
                        else if ((tile & 0x300u) == 0x300u) w->enemies[ei].state = 3;
                    } else if (w->enemies[ei].type == SOI_ENEMY_CREEPER) {
                        /* Creeper (asm FUN_10008618/8b18): bord 16 = horizontal,
                         * 17 = vertical (state). Step interval = cell byte3 (asm
                         * +0x50 = StartDelay) * ~6 (asm +0x6e = +0x50*3 at a 2-frame
                         * cadence). It is self-propelled, never a shooter. */
                        w->enemies[ei].state = (uint8_t)(((tile & 0xFFu) == 0x11u) ? 1 : 0);
                        w->enemies[ei].vx = 0;
                        w->enemies[ei].fire_period = (int16_t)(b0 ? b0 * 6u : 24u);
                        w->enemies[ei].fire_cd = (int16_t)(b0 ? b0 * 6u : 24u);
                    } else if (w->enemies[ei].type == SOI_ENEMY_WALKER) {
                        /* Walker (asm FUN_1000dd4c): its fire gate +0x6e counts WALKER STEPS (one
                         * per 3 frames): it opens after StartDelay(+0x50)*6 steps and reloads to
                         * StartDelay<<2 steps after each bolt -> b0*18 / b0*12 frames. */
                        w->enemies[ei].fire_period = (int16_t)(b0 ? b0 * 12u : 96u);
                        w->enemies[ei].fire_cd     = (int16_t)(b0 * 18u);
                    }
                }
                continue;
            }
            /* Record coords are (col, row): the first byte is the COLUMN (X,
             * 0-18) and the second is the ROW (Y, 0-12). The grid is 19 wide x
             * 13 tall (landscape) -- the 0x3c-stride live-grid dimension (from
             * X) spans 19, Y spans 13 (asm FUN_1002b708 / FUN_10012348). The
             * BORD cell value already carries its flag bits (0x2xx/0x3xx solid,
             * 0x9xx goodie, 0x197 background); store it verbatim. */
            soi_set_cell(w, a, b, tile);
        }
    }
    w->level_loaded = 1;
    soi_switch_load_scan(w);   /* register Stop/Go switch blocks + normalise their cells (b41) */
    w->challenge = 0;          /* Knight/Gargoyle on the board -> Challenge Round (FUN_10017a70) */
    for (i = 0; i < SOI_MAX_ENEMIES; i++)
        if (w->enemies[i].active &&
            (w->enemies[i].type == SOI_ENEMY_KNIGHT || w->enemies[i].type == SOI_ENEMY_GARGOYLE))
            w->challenge = 1;
    /* Level objective (FIRST-DRAFT, TODO(oracle)): clear all treasure placed on
     * the board (coins/gems/gold). Count it now; pickups decrement it. */
    w->goodies_total = (int16_t)soi_count_treasure(w);
    w->goodies_left  = w->goodies_total;
    /* Snapshot the board bytes so a death can faithfully reload it. reload_board_on_death
     * copies these into a LOCAL buffer before the reload, because soi_world_init zeroes
     * bord_data before the reload's soi_load_level re-runs. A board too big to snapshot
     * (> SOI_BORD_MAX, none ship that large) disables reload recovery rather than leaving a
     * stale snapshot from a previous board. */
    if (len <= sizeof(w->bord_data)) {
        size_t k;
        for (k = 0; k < len; k++) w->bord_data[k] = bord[k];
        w->bord_len = (uint16_t)len;
    } else {
        w->bord_len = 0;
    }
    return 1;
}

/* Faithful death recovery (asm FUN_1001f4f8 -> FUN_10029acc -> FUN_1002b448 +
 * FUN_1002b174): reload the WHOLE board -- grid, enemies, positions, multiplier, key
 * and the Bonus timer all reset -- while score / lives / ammo / shield persist and the
 * RNG stream continues. This makes a bonus runout cost exactly one life with a fresh
 * clock (repeatable, no infinite cascade) and restores destroyed blocks on death. A
 * stored board is required; a bare unit-test world falls back to the simple in-place
 * respawn (caller checks bord_len). */
static void reload_board_on_death(SoiWorld *w)
{
    uint8_t tmp[SOI_BORD_MAX];
    struct { int32_t score; int16_t lives, arrows, balls, shield; uint8_t active, elim; }
        keep[SOI_MAX_PLAYERS];
    uint32_t seed   = w->rng_seed;
    uint32_t tick   = w->tick;          /* the reload runs MID-tick; keep the frame counter */
    uint8_t  parity = w->frame_parity;  /* monotonic so the tick-gated badguy throw + 30Hz  */
    uint8_t  mode   = w->play_mode;
    size_t len = w->bord_len, k;        /* input latch don't refire/desync (review finding). */
    int i, p3_active;

    if (len == 0u || len > sizeof(tmp)) return;   /* no board captured -> in-place fallback */
    for (k = 0; k < len; k++) tmp[k] = w->bord_data[k];

    p3_active = w->players[3].active && !w->players[3].eliminated;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        keep[i].score  = w->players[i].score;
        keep[i].lives  = w->players[i].lives;
        keep[i].arrows = w->players[i].arrows;
        keep[i].balls  = w->players[i].balls;
        keep[i].shield = w->players[i].shield;
        keep[i].active = w->players[i].active;
        keep[i].elim   = w->players[i].eliminated;
    }

    soi_world_init(w, 1);          /* full reset; also re-seeds default stats */
    w->rng_seed      = seed;       /* continue the RNG stream across the reload */
    w->tick          = tick;       /* restore the frame counter (see above) */
    w->frame_parity  = parity;
    w->play_mode     = mode;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].score  = keep[i].score;
        w->players[i].lives  = keep[i].lives;
        w->players[i].arrows = keep[i].arrows;
        w->players[i].balls  = keep[i].balls;
        w->players[i].shield = keep[i].shield;
    }
    soi_load_level(w, tmp, len);   /* rebuild grid/enemies, reseed bonus, re-store bytes */
    if (p3_active) soi_spawn_player3(w);
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {   /* keep disabled / eliminated players out */
        if (keep[i].elim)    { w->players[i].eliminated = 1; w->players[i].alive = 0; }
        if (!keep[i].active) { w->players[i].active = 0;     w->players[i].alive = 0; }
    }
}

/* ---------- tick ---------- */
void soi_tick(SoiWorld *w, uint8_t p1_input, uint8_t p2_input)
{
    soi_tick3(w, p1_input, p2_input, 0);   /* 2-player entry; the 3rd co-op player gets no input here */
}

/* Advance one frame with up to THREE player inputs (the remaster's 3rd co-op player is
 * slot 3; the original is 2-player). */
void soi_tick3(SoiWorld *w, uint8_t p1_input, uint8_t p2_input, uint8_t p3_input)
{
    int i;
    w->tick++;
    w->frame_parity ^= 1u;
    w->sfx_count = 0;   /* drop last frame's sound events; this tick refills */
    w->death_count = 0; /* drop last frame's death-pop events; this tick refills */

    /* Input is sampled every 2 frames and so is the PLAYER state machine: the asm
     * main loop (FUN_10028a0c) gates {input FUN_1002d440 + locomotion FUN_1001166c
     * + pickup FUN_1002bc64} behind the sVar7 divider = every 2nd VBL (30Hz), while
     * enemies run ~every frame (60Hz). Latch input on the odd tick; reuse on even. */
    if ((w->tick & 1u) != 0u) {
        w->players[1].input = p1_input;
        w->players[2].input = p2_input;
        w->players[3].input = p3_input;
    } else {
        /* SPEED SHOES: the asm drops the divider to 1 for a fast player (FUN_10028a0c:
         * `if (+0x5c == 1) sVar7 = 1`), so input is sampled EVERY frame along with the
         * doubled locomotion below -- not held over from the odd tick. */
        if (w->players[1].fast > 0) w->players[1].input = p1_input;
        if (w->players[2].fast > 0) w->players[2].input = p2_input;
        if (w->players[3].fast > 0) w->players[3].input = p3_input;
    }

    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].invuln > 0) w->players[i].invuln--;   /* tick i-frames */
    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].fire_cd > 0) w->players[i].fire_cd--; /* vestigial: player weapons now
                                                                * gate on one-shot-in-flight, not a
                                                                * timer (asm has no fire cooldown) */
    /* Respawn commit. FAITHFUL death recovery: the asm reloads the whole board after
     * every death (session loop FUN_1001f4f8 -> FUN_10029acc -> FUN_1002b448), so the
     * grid, enemies, positions and the Bonus timer all reset while score / lives / ammo /
     * shield persist -- a death RESETS THE BOARD and a runout comes back with a fresh
     * clock. A captured board is required; a bare unit-test world (no board loaded) keeps
     * the simple in-place respawn. reload_board_on_death revives every active player at
     * once, so break out of the per-player loop after it runs. */
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {                      /* respawn timer */
        SoiPlayer *rp = &w->players[i];
        if (rp->active && !rp->alive && !rp->eliminated && rp->respawn_timer > 0) {
            if (--rp->respawn_timer == 0) {
                if (w->bord_len > 0) {
                    reload_board_on_death(w);
                    break;
                }
                rp->x = rp->spawn_x; rp->y = rp->spawn_y;
                rp->alive = 1; rp->in_air = 0; rp->move_ctr = 0; rp->run_dir = 0;
                rp->ground_state = SOI_ST_IDLE;
                rp->invuln = 90;                                /* spawn grace (no-board fallback) */
            }
        }
    }

    /* Player logic at 30Hz (odd tick); a DYING player's death-throw keeps animating
     * every frame (the asm loop runs the state machine while the dying flag is set).
     * Enemies + projectiles run every frame (60Hz). */
    if ((w->tick & 1u) != 0u) {
        for (i = 1; i < SOI_MAX_PLAYERS; i++) soi_player_update(w, i);
    } else {
        /* even tick: a DYING player animates every frame; a SPEED-SHOES player (goody
         * 0x32 -> asm fast-mode +0x5c) also updates -> 60Hz = 2x speed. Its input was
         * re-sampled this frame (above); actions stay edge-triggered, so a held key
         * still fires only once. */
        for (i = 1; i < SOI_MAX_PLAYERS; i++)
            if (w->players[i].ground_state == SOI_ST_DEAD || w->players[i].fast > 0)
                soi_player_update(w, i);
    }
    for (i = 1; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].fast > 0) w->players[i].fast--;
    /* Action pose (fire/build): count it down. This also RELEASES the run-dispatch
     * freeze that soi_player_update holds while pose_t > 0 (the anti-glide stutter-stop),
     * so the decrement MUST stay unconditional -- gating it would freeze the player. */
    for (i = 1; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].pose_t > 0 && --w->players[i].pose_t == 0) w->players[i].pose = 0;
    /* Clock power-up (goody 0x2E): halves the enemy update rate for ~10s. The asm
     * (_DAT_1003b294) decrements a counter each frame and runs the nasties only when
     * it is < 0 (expired -> normal) or ODD -> every other frame = 30Hz while active. */
    if (w->enemy_slow >= 0) w->enemy_slow--;
    if (w->enemy_slow < 0 || (w->enemy_slow & 1))
        soi_enemies_update(w);
    if (w->reveal_timer > 0) w->reveal_timer--;   /* magnifying-glass reveal (goody 0x2F) counts down */
    soi_projectiles_update(w);
    soi_switch_animate(w);   /* advance Stop/Go open/close animations (b41; no-op when sw_count==0) */

    /* PER-PLAYER Bonus countdown (@0x1003a9f0, decremented by FUN_1000f500). Each
     * player's on-screen "Bonus" is their own survival timer; reaching 0 costs THAT
     * player a life (gameplay-and-design.md 1: "if the Bonus reaches zero, you die").
     * FUN_1000f500 runs once per VBL but decrements the bonus only every 3rd frame
     * via a divider (_DAT_10038eb0: clamp<=3, --, fires at <1 -> reset 3), so the
     * clock ticks at ~20Hz. Decrementing every tick would run it 3x too fast. A
     * warning fires as the bonus passes 1000 (FUN_10018b24 -> sound evt 0x2d). */
    if (w->bonus_div > 3) w->bonus_div = 3;
    if (--w->bonus_div < 1) {
        w->bonus_div = 3;
        if (w->play_mode == SOI_MODE_COOPERATE) {
            /* COOPERATE: ONE team Bonus in the pool slot (asm FUN_1000f500 non-compete branch
             * decrements a single counter); its runout kills EVERY player (FUN_10012228(1) and,
             * with two players in, FUN_10012228(2)). */
            SoiPlayer *pool = &w->players[1];
            int any = 0;
            for (i = 1; i < SOI_MAX_PLAYERS; i++) {
                const SoiPlayer *p = &w->players[i];
                if (w->level_loaded && p->active && p->alive && !p->eliminated) any = 1;
            }
            if (any) {
                pool->bonus_time--;
                if (pool->bonus_time == 1000) soi_sfx_emit(w, SOI_SFX_HURRY);
                if (pool->bonus_time < 0) {
                    pool->bonus_time = 0;
                    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
                        SoiPlayer *p = &w->players[i];
                        if (!p->active || !p->alive || p->eliminated) continue;
                        p->invuln = 0;
                        soi_player_hit(w, i);
                    }
                }
            }
        } else
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            SoiPlayer *p = &w->players[i];
            /* level_loaded gate (cf. the badguy-throw below): the asm's timer FUN_1000f500
             * runs only from the in-play game loop, never pre-board. Mirror that so an active
             * player left at bonus 0 before a board is up can't be insta-killed on tick 0. */
            if (w->level_loaded && p->active && p->alive && !p->eliminated) {
                p->bonus_time--;
                if (p->bonus_time == 1000) soi_sfx_emit(w, SOI_SFX_HURRY);
                if (p->bonus_time < 0) {
                    /* Timeout death, per asm FUN_1000f500: decrement every in-play tick,
                     * SURVIVE the tick the counter first reads 0, and die only when the next
                     * decrement goes negative (line 43 `< 0`), clamping back to 0 (line 45).
                     * Route through FUN_10012228 (== soi_player_hit): the SAME airborne
                     * death-throw + hit cry as an enemy hit; the life is debited in air_step.
                     * The runout is NOT i-frame gated (FUN_10012228 has no invuln check), so
                     * spawn / potion grace can't cheese it -- clear invuln first so
                     * soi_player_hit doesn't early-return. Recovery is faithful: the death
                     * reloads the board (see the respawn commit above), which RESEEDS the
                     * bonus, so a timed-out player returns with a fresh clock -- one life per
                     * runout, repeatable until the lives run out (no infinite cascade). The
                     * SOI_ST_DEAD guard in soi_player_hit keeps the still-clamped-0 bonus from
                     * re-launching the same death mid-arc. */
                    p->bonus_time = 0;
                    p->invuln = 0;
                    soi_player_hit(w, i);
                }
            }
        }
    }

    /* No global badguy spawn: thrown_badguy (BORD 0x12) / pct_badguy (0x14) are used ONLY by the
     * Gargoyle's egg throw (enemy_shooter_fire -> gargoyle_egg, asm FUN_1000bf54 / FUN_1000b7dc). */
    /* Level-complete is polled via soi_level_complete() below (the CONFIRMED win
     * condition = key + door exit, docs gameplay-and-design.md 1); nothing per-tick. */
}

/* ---------- accessors ---------- */
static const SoiPlayer *pget(const SoiWorld *w, int i)
{
    if (i < 0 || i >= SOI_MAX_PLAYERS) i = 0;
    return &w->players[i];
}
int32_t  soi_player_score(const SoiWorld *w, int p) { return pget(w, p)->score; }
int      soi_player_lives(const SoiWorld *w, int p) { return pget(w, p)->lives; }
int      soi_player_mult(const SoiWorld *w, int p)  { return pget(w, p)->mult; } int      soi_player_no_weapons_reward(const SoiWorld *w, int p) { return pget(w, p)->no_weapons_reward; }int      soi_player_alive(const SoiWorld *w, int p) { return pget(w, p)->active && pget(w, p)->alive && !pget(w, p)->eliminated; }
int      soi_game_over(const SoiWorld *w)
{
    int i, any = 0;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        if (!w->players[i].active) continue;
        any = 1;
        if (!w->players[i].eliminated) return 0;   /* someone is still in */
    }
    return any;   /* over only if there were active players and all are out */
}
int      soi_level_complete(const SoiWorld *w)
{
    /* WIN = a player exited through the DOOR carrying the KEY (CONFIRMED docs §0:
     * key cell 0x0B, door bit 0x800). soi_pickup_check sets has_key=2 on exit. */
    int i;
    if (!w->level_loaded) return 0;
    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].active && w->players[i].has_key == 2) return 1;
    return 0;
}
int      soi_player_x(const SoiWorld *w, int p)     { return pget(w, p)->x; }
int      soi_player_y(const SoiWorld *w, int p)     { return pget(w, p)->y; }
int      soi_player_arrows(const SoiWorld *w, int p) { return pget(w, p)->arrows; }
int      soi_player_balls(const SoiWorld *w, int p) { return pget(w, p)->balls; }
int      soi_player_shield(const SoiWorld *w, int p) { return pget(w, p)->shield; }
int      soi_player_facing(const SoiWorld *w, int p) { return pget(w, p)->facing; }
int      soi_player_invuln(const SoiWorld *w, int p) { return pget(w, p)->invuln; }
int      soi_player_fast(const SoiWorld *w, int p) { return pget(w, p)->fast; }
int      soi_player_has_key(const SoiWorld *w, int p) { return pget(w, p)->has_key; }
int      soi_player_state(const SoiWorld *w, int p) { return pget(w, p)->ground_state; }
int      soi_player_movectr(const SoiWorld *w, int p) { return pget(w, p)->move_ctr; }
int      soi_player_pose(const SoiWorld *w, int p) { const SoiPlayer *pp = pget(w, p); return pp->pose_t > 0 ? pp->pose : 0; }
int      soi_player_pose_t(const SoiWorld *w, int p) { return pget(w, p)->pose_t; }
int      soi_goodies_total(const SoiWorld *w)       { return w->goodies_total; }
int      soi_goodies_left(const SoiWorld *w)        { return w->goodies_left; }
int      soi_reveal_timer(const SoiWorld *w)        { return w->reveal_timer; }

/* Count the board's treasure -- the level-clear objective. A treasure is a VISIBLE
 * goodie (0x9xx) of a coin/gem/gold type (0x0A silver, 0x17 gold, 0x18 gem, 0x19
 * bars), OR a coin/gem/gold HIDDEN under a SPECIAL block (revealed when broken).
 * A plain colored BLOCK is NOT treasure: blue is type 0x19, which collides with
 * gold-bars' low byte, so we key off the 0x9xx goodie nibble / the special payload,
 * never the raw low byte (else e.g. board_422's blue maze blocks miscount as gold
 * bars and the objective can never clear). Matches the pickup's decrement set. */
int soi_count_treasure(const SoiWorld *w)
{
    int rr, cc, n = 0;
    for (rr = 0; rr < SOI_GRID_ROWS; rr++)
        for (cc = 0; cc < SOI_GRID_COLS; cc++) {
            uint32_t cell = w->cell[rr][cc];
            unsigned lo  = SOI_CELL_TYPE(cell);
            unsigned pay = SOI_CELL_TYPE(SOI_CELL_PAYLOAD(cell));
            int is_t_lo  = (lo  == 0x0A || lo  == 0x17 || lo  == 0x18 || lo  == 0x19);
            int is_t_pay = (pay == 0x0A || pay == 0x17 || pay == 0x18 || pay == 0x19);
            if (((cell & 0xF00u) == 0x900u && is_t_lo) ||   /* visible goodie */
                ((cell & SOI_CELL_SPECIAL) && is_t_pay))    /* hidden under a block */
                n++;
        }
    return n;
}
int      soi_bonus_time(const SoiWorld *w)          { return w->players[1].bonus_time; }
int      soi_player_bonus(const SoiWorld *w, int p) { return pget(w, p)->bonus_time; }
/* Shared "hurry up" music state: 1 if ANY in-play player's bonus timer is in the
 * low zone (0 < bonus_time <= 1000). The asm speeds the single background movie to
 * 1.25x (FUN_10018b24 SetMovieRate 0x14000) as a player's timer passes 1000, and
 * restores 1.0x (FUN_10018ac4) once lifted back above 1000 / on a new board. Because
 * the movie is shared, the sped-up state reflects ANY player being in the zone --
 * a read-only predicate (does not mutate state or emit events; hash-neutral). */
int      soi_music_hurry(const SoiWorld *w) {
    int i;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        const SoiPlayer *p = &w->players[i];
        if (p->active && p->alive && !p->eliminated &&
            p->bonus_time > 0 && p->bonus_time <= 1000)
            return 1;
    }
    return 0;
}
uint32_t soi_tick_count(const SoiWorld *w)          { return w->tick; }
uint32_t soi_grid_cell(const SoiWorld *w, int c, int r) { return soi_get_cell(w, c, r); }
int      soi_enemy_count(const SoiWorld *w)
{
    int i, n = 0;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) if (w->enemies[i].active) n++;
    return n;
}
int      soi_projectile_count(const SoiWorld *w)
{
    int i, n = 0;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) if (w->projectiles[i].active) n++;
    return n;
}

/* ---- sound-event queue ---- */
void soi_sfx_emit(SoiWorld *w, int id)
{
    if (w->sfx_count < SOI_SFX_QUEUE_MAX) w->sfx_queue[w->sfx_count++] = (uint8_t)id;
}
int soi_sfx_count(const SoiWorld *w) { return w->sfx_count; }
int soi_sfx_get(const SoiWorld *w, int i)
{
    return (i >= 0 && i < w->sfx_count) ? w->sfx_queue[i] : 0;
}

/* ---- enemy-death effect queue (transient; drives the cosmetic Godot death "pop") ---- */
void soi_death_emit(SoiWorld *w, int x, int y, int type, int dir)
{
    if (w->death_count < SOI_DEATH_QUEUE_MAX) {
        int k = w->death_count++;
        w->death_x[k]    = (int16_t)x;
        w->death_y[k]    = (int16_t)y;
        w->death_type[k] = (uint8_t)type;
        w->death_dir[k]  = (uint8_t)dir;
    }
}
int soi_death_count(const SoiWorld *w) { return w->death_count; }
int soi_death_x(const SoiWorld *w, int i)    { return (i >= 0 && i < w->death_count) ? w->death_x[i]    : 0; }
int soi_death_y(const SoiWorld *w, int i)    { return (i >= 0 && i < w->death_count) ? w->death_y[i]    : 0; }
int soi_death_type(const SoiWorld *w, int i) { return (i >= 0 && i < w->death_count) ? w->death_type[i] : 0; }
int soi_death_dir(const SoiWorld *w, int i)  { return (i >= 0 && i < w->death_count) ? w->death_dir[i]  : 0; }

/* per-entity accessors (bounds-checked; inactive/OOB slots read as 0). */
static const SoiEnemy *eget(const SoiWorld *w, int i)
{
    static const SoiEnemy dead;   /* zeroed */
    return (i >= 0 && i < SOI_MAX_ENEMIES) ? &w->enemies[i] : &dead;
}
int      soi_enemy_active(const SoiWorld *w, int i) { return eget(w, i)->active; }
int      soi_enemy_type(const SoiWorld *w, int i)   { return eget(w, i)->type; }
int      soi_enemy_x(const SoiWorld *w, int i)      { return eget(w, i)->x; }
int      soi_enemy_y(const SoiWorld *w, int i)      { return eget(w, i)->y; }
int      soi_enemy_dir(const SoiWorld *w, int i)    { return eget(w, i)->dir; }
int      soi_enemy_fire_cd(const SoiWorld *w, int i){ return eget(w, i)->fire_cd; }
int      soi_enemy_turn(const SoiWorld *w, int i)   { return eget(w, i)->turn; }
int      soi_enemy_bud(const SoiWorld *w, int i)    { return eget(w, i)->bud; }
int      soi_enemy_anim(const SoiWorld *w, int i)   { return eget(w, i)->anim; }
int      soi_enemy_vertical(const SoiWorld *w, int i){ const SoiEnemy *e = eget(w, i); return e->type == SOI_ENEMY_BEANIE && e->state == 8; }
int      soi_enemy_is_spawner(const SoiWorld *w, int i){ return eget(w, i)->spawn_child != 0; }

static const SoiProjectile *prget(const SoiWorld *w, int i)
{
    static const SoiProjectile none;   /* zeroed */
    return (i >= 0 && i < SOI_MAX_PROJECTILES) ? &w->projectiles[i] : &none;
}
int      soi_projectile_active(const SoiWorld *w, int i) { return prget(w, i)->active; }
int      soi_projectile_x(const SoiWorld *w, int i)      { return prget(w, i)->x; }
int      soi_projectile_y(const SoiWorld *w, int i)      { return prget(w, i)->y; }
int      soi_projectile_hostile(const SoiWorld *w, int i){ return prget(w, i)->hostile; }
int      soi_projectile_kind(const SoiWorld *w, int i)   { return prget(w, i)->kind; }
int      soi_projectile_src_type(const SoiWorld *w, int i){ return prget(w, i)->src_type; }
int      soi_projectile_pierce(const SoiWorld *w, int i)  { return prget(w, i)->pierce; }
int      soi_projectile_fired_left(const SoiWorld *w, int i) { const SoiProjectile *p = prget(w, i); return p->kind == 0 && !p->hostile && p->vy == 3; }

/* ---------- canonical serialize (little-endian, field-by-field) ---------- */
size_t soi_serialize(const SoiWorld *w, uint8_t *out, size_t cap)
{
    SoiBuf b; int i, c, r;
    b.p = out; b.cap = cap; b.len = 0;

    bput_u32(&b, w->tick);
    bput_u32(&b, w->rng_seed);
    bput_u8(&b, w->frame_parity);
    bput_u8(&b, w->enemies_frozen);
    bput_u16(&b, (uint16_t)w->enemy_slow);
    bput_u16(&b, (uint16_t)w->reveal_timer);
    bput_u16(&b, (uint16_t)w->pct_ultrabuster);
    bput_u16(&b, (uint16_t)w->thrown_badguy);
    bput_u16(&b, (uint16_t)w->pct_badguy);
    bput_u16(&b, (uint16_t)w->goodies_total);
    bput_u16(&b, (uint16_t)w->goodies_left);
    bput_u8(&b, w->play_mode);
    bput_u8(&b, w->challenge);

    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        const SoiPlayer *p = &w->players[i];
        bput_u8(&b, p->active); bput_u8(&b, p->alive); bput_u8(&b, p->eliminated);
        bput_u8(&b, p->ground_state); bput_u8(&b, p->in_air); bput_u8(&b, p->block_type);
        bput_u8(&b, p->has_key); bput_u8(&b, p->input); bput_u8(&b, p->input_prev);
        bput_i32(&b, p->x); bput_i32(&b, p->y);
        bput_u16(&b, (uint16_t)p->facing); bput_u16(&b, (uint16_t)p->move_ctr);
        bput_u16(&b, (uint16_t)p->run_dir); bput_i32(&b, p->run_x0);
        bput_u16(&b, (uint16_t)p->jump_t); bput_u16(&b, (uint16_t)p->launch_y);
        bput_u16(&b, (uint16_t)p->lives);
        bput_i32(&b, p->score); bput_i32(&b, p->bonus_time);
        bput_u16(&b, (uint16_t)p->mult);
        bput_u16(&b, (uint16_t)p->no_weapons_reward);
        bput_u16(&b, (uint16_t)p->shield); bput_u16(&b, (uint16_t)p->arrows);
        bput_u16(&b, (uint16_t)p->balls);
        bput_u16(&b, (uint16_t)p->invuln); bput_u16(&b, (uint16_t)p->fire_cd);
        bput_u16(&b, (uint16_t)p->spawn_x); bput_u16(&b, (uint16_t)p->spawn_y);
        bput_u16(&b, (uint16_t)p->respawn_timer);
        bput_u16(&b, (uint16_t)p->fast);
        bput_u8(&b, p->pose);
        bput_u16(&b, (uint16_t)p->pose_t);
    }
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *e = &w->enemies[i];
        bput_u8(&b, e->active); bput_u8(&b, e->type); bput_u8(&b, e->dir); bput_u8(&b, e->state);
        bput_i32(&b, e->x); bput_i32(&b, e->y);
        bput_u16(&b, (uint16_t)e->vx); bput_u16(&b, (uint16_t)e->vy);
        bput_u16(&b, (uint16_t)e->points); bput_u8(&b, e->owner); bput_u8(&b, e->claimed);
        bput_u16(&b, e->anim); bput_u16(&b, (uint16_t)e->fire_cd);
        bput_u16(&b, (uint16_t)e->fire_period);
        bput_u8(&b, e->spawn_child); bput_u16(&b, (uint16_t)e->life);
        bput_u8(&b, e->child);
        bput_u32(&b, e->under);
        bput_u8(&b, e->period); bput_u8(&b, e->stepc);
        bput_u8(&b, e->turn); bput_u8(&b, e->bud);
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        const SoiProjectile *pr = &w->projectiles[i];
        bput_u8(&b, pr->active); bput_u8(&b, pr->owner); bput_u8(&b, pr->hostile);
        bput_u8(&b, pr->kind); bput_u8(&b, pr->src_type);
        bput_i32(&b, pr->x); bput_i32(&b, pr->y);
        bput_u16(&b, (uint16_t)pr->vx); bput_u16(&b, (uint16_t)pr->vy);
        bput_u16(&b, (uint16_t)pr->age);
        bput_u8(&b, pr->pierce);
        bput_u8(&b, pr->gtype);
        bput_u16(&b, (uint16_t)pr->tcol); bput_u16(&b, (uint16_t)pr->trow);
    }
    for (r = 0; r < SOI_GRID_ROWS; r++)
        for (c = 0; c < SOI_GRID_COLS; c++)
            bput_u32(&b, w->cell[r][c]);

    return b.len;
}

/* ---------- FNV-1a 64-bit over the serialized logical state ---------- */
uint64_t soi_state_hash(const SoiWorld *w)
{
    /* The serialize packs the SAME logical fields with no struct padding (and omits
     * the transient sfx queue), so its length is always < sizeof(SoiWorld). Sizing
     * the buffer to that makes truncation IMPOSSIBLE and auto-tracks the schema as
     * fields are added -- so the hash can never silently drop trailing state (the
     * grid is serialized last, so a too-small buffer would have dropped it). */
    uint8_t buf[sizeof(SoiWorld)];
    size_t n = soi_serialize(w, buf, sizeof(buf));
    uint64_t h = 1469598103934665603ULL;      /* FNV offset basis */
    size_t i;
    if (n > sizeof(buf)) n = sizeof(buf);      /* provably dead now; kept defensively */
    for (i = 0; i < n; i++) {
        h ^= buf[i];
        h *= 1099511628211ULL;                 /* FNV prime */
    }
    return h;
}
