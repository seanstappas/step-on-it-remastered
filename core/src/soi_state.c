/* soi_state.c — world lifecycle, BORD level loading, the per-frame tick, and
 * the canonical serialize + FNV-1a-64 state hash (MASTER_PLAN §5.5).
 * Integer-only; all logical state is fixed-width for cross-platform identical
 * hashing.
 */
#include "soi_internal.h"
#include <string.h>

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

static uint16_t ext1_crc16(const uint8_t *data, size_t len)
{
    uint16_t crc = 0xFFFF;
    size_t i;
    for (i = 0; i < len; i++) {
        crc ^= ((uint16_t)data[i] << 8);
        for (int b = 0; b < 8; b++) {
            if (crc & 0x8000)
                crc = (uint16_t)((crc << 1) ^ 0x1021);
            else
                crc = (uint16_t)(crc << 1);
        }
    }
    return crc;
}

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
    w->grid_cols = SOI_GRID_COLS;
    w->grid_rows = SOI_GRID_ROWS;
    w->p3_col = 0;
    w->p3_row = 0;
    w->p3_block = 0x020D;
    w->p3_any_key = 0;
    w->ext_starting_lives = 0;
    memset(w->vs_spawns, 0, sizeof(w->vs_spawns));
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].lives = 2;         /* new-game lives (asm FUN_1002b060 -> +0x46 = 2; the 4 is COOPERATE's
                                          * shared pool only -- see soi_new_game). refs/images board_1/3 HUD: 02 */
        w->players[i].shield = 2;        /* VESTIGIAL (save/ABI stability only; the original has no hit-buffer) */
        w->players[i].block_type = (i == 2) ? 0x73 : (i == 3) ? 0x0D : 0x6D;
                                         /* the block each player BUILDS: every shipped BORD header
                                          * carries P1 0x026D (0x02) / P2 0x0273 (0x04) = the BLUE /
                                          * GREEN player blocks (block_sprites f110 / f116); the
                                          * loader re-reads them per board (asm FUN_1002b448 ->
                                          * player +0x36). The remaster's red P3 builds the red
                                          * block 0x0D (f14). */
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
    p->pose = 0; p->pose_t = 0; p->act_verb = SOI_ACT_NONE;   /* no build/fire action running */
    p->frame = 0x3d; p->frame_save = 0x3d; p->act_dirty = 0; p->aux = 0; p->dstep = 0;   /* standing, facing right */
    p->input = 0; p->input_prev = 0;
    p->keys = 0;
    p->in_pend = 0; p->buf = 0; p->buf_t = 0;
    p->prev_pcol = (int16_t)col; p->prev_prow = (int16_t)row;   /* seed switch entry-edge to spawn cell */
    p->mult = 1;                   /* multiplier resets to 1 each level (asm FUN_1002b174 -> +0x44) */
}

/* Remaster extension: activate the 3rd co-op player. The BORD header has only two
 * spawns (P1 @0x06, P2 @0x0A), so P3 starts at P1's spawn column -- one cell to the
 * right if that cell is clear. Call after soi_load_level when 3 players are in. */
static int is_valid_p3_spawn(const SoiWorld *w, int c, int r)
{
    if (c < 0 || c >= w->grid_cols || r < 1 || r + 1 >= w->grid_rows)
        return 0;
    uint32_t at = w->cell[r][c];
    uint32_t above = w->cell[r - 1][c];
    if (SOI_CELL_TYPE(at) != 0 || (at & SOI_CELL_SUPPORTIVE) != 0 || (at & SOI_CELL_DOOR) != 0)
        return 0;
    if (SOI_CELL_TYPE(above) != 0 || (above & SOI_CELL_SUPPORTIVE) != 0 || (above & SOI_CELL_DOOR) != 0)
        return 0;
    uint32_t below = w->cell[r + 1][c];
    if ((below & SOI_CELL_SUPPORTIVE) == 0)
        return 0;
    return 1;
}

void soi_spawn_player3(SoiWorld *w)
{
    if (!w) return;

    if (w->p3_col > 0 && w->p3_row > 0 &&
        w->p3_col < w->grid_cols && w->p3_row < w->grid_rows) {
        place_player(w, 3, w->p3_col, w->p3_row);
        w->players[3].block_type = (uint8_t)(w->p3_block & 0xFFu);
        w->players[3].bonus_time = w->players[1].bonus_time;
        if (w->play_mode == SOI_MODE_COOPERATE) {
            w->players[3].lives = -1;
            w->players[3].balls = 0;
            w->players[3].arrows = 0;
        } else {
            w->players[3].lives = w->players[1].lives;
            w->players[3].balls = w->players[1].balls;
            w->players[3].arrows = w->players[1].arrows;
        }
        return;
    }

    int spawn_c = -1, spawn_r = -1;
    if (is_valid_p3_spawn(w, 9, 1)) {
        spawn_c = 9;
        spawn_r = 1;
    } else {
        int p1_c = (w->players[1].spawn_x - SOI_ORIGIN_X) / SOI_CELL_PX;
        int p1_r = (w->players[1].spawn_y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        int p2_c = (w->players[2].spawn_x - SOI_ORIGIN_X) / SOI_CELL_PX;
        int p2_r = (w->players[2].spawn_y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        int mid_c = (p1_c + p2_c) / 2;
        int mid_r = (p1_r + p2_r) / 2;
        int max_dist = (int)w->grid_cols + (int)w->grid_rows;
        int dist, dc;

        for (dist = 1; dist <= max_dist && spawn_c < 0; dist++) {
            for (dc = -dist; dc <= dist; dc++) {
                int dr = dist - (dc < 0 ? -dc : dc);
                int cand_c = mid_c + dc;
                int cand_r1 = mid_r + dr;
                int cand_r2 = mid_r - dr;

                if (is_valid_p3_spawn(w, cand_c, cand_r1)) {
                    spawn_c = cand_c;
                    spawn_r = cand_r1;
                    break;
                }
                if (dr != 0 && is_valid_p3_spawn(w, cand_c, cand_r2)) {
                    spawn_c = cand_c;
                    spawn_r = cand_r2;
                    break;
                }
            }
        }
    }

    if (spawn_c < 0) {
        int col = (w->players[1].spawn_x - SOI_ORIGIN_X) / SOI_CELL_PX;
        int row = (w->players[1].spawn_y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (col + 1 < w->grid_cols && SOI_CELL_TYPE(w->cell[row][col + 1]) == 0)
            col += 1;
        spawn_c = col;
        spawn_r = row;
    }

    place_player(w, 3, spawn_c, spawn_r);
    w->players[3].block_type = (uint8_t)(w->p3_block & 0xFFu);
    w->players[3].bonus_time = w->players[1].bonus_time;
    if (w->play_mode == SOI_MODE_COOPERATE) {
        w->players[3].lives = -1;
        w->players[3].balls = 0;
        w->players[3].arrows = 0;
    } else {
        w->players[3].lives = w->players[1].lives;
        w->players[3].balls = w->players[1].balls;
        w->players[3].arrows = w->players[1].arrows;
    }
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

void soi_drop_player(SoiWorld *w, int player_slot)
{
    if (!w || player_slot < 1 || player_slot >= SOI_MAX_PLAYERS) return;
    w->players[player_slot].active = 0;
    w->players[player_slot].alive = 0;
    w->players[player_slot].eliminated = 1;
}

void soi_set_p3_any_key(SoiWorld *w, int enable)
{
    if (w) w->p3_any_key = enable ? 1 : 0;
}

int soi_p3_any_key(const SoiWorld *w)
{
    return w ? (int)w->p3_any_key : 0;
}

/* Board->board transition: preserve the persistent per-player stats (score/lives/ammo/
 * shield -- new-game-only per FUN_1002b060) and the RNG stream, but otherwise fully reset
 * for the incoming board (mult=1/positions/has_key/grid/enemies via world_init+load_level,
 * matching the per-level reset FUN_1002b174). */
int soi_next_level(SoiWorld *w, const uint8_t *bord, size_t len)
{
    struct { int32_t score; int16_t lives, arrows, balls, shield; uint16_t kills; uint8_t elim; } keep[SOI_MAX_PLAYERS];
    uint32_t seed = w->rng_seed;
    uint8_t  mode = w->play_mode;
    uint8_t  assist = w->input_assist;
    uint8_t  ffire = w->friendly_fire;
    uint8_t  vrule = w->victory_rule;
    uint8_t  p3any = w->p3_any_key;
    int i, r;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        keep[i].score  = w->players[i].score;
        keep[i].lives  = w->players[i].lives;
        keep[i].arrows = w->players[i].arrows;
        keep[i].balls  = w->players[i].balls;
        keep[i].shield = w->players[i].shield;
        keep[i].kills  = w->players[i].kills;
        keep[i].elim   = w->players[i].eliminated;
    }
    soi_world_init(w, 1);                 /* full per-board reset (mult=1, transient cleared) */
    w->rng_seed = seed;                   /* continue the RNG stream across boards */
    w->play_mode = mode;
    w->input_assist = assist;
    w->friendly_fire = ffire;
    w->victory_rule = vrule;
    w->p3_any_key = p3any;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].score  = keep[i].score;
        w->players[i].lives  = keep[i].lives;
        w->players[i].arrows = keep[i].arrows;
        w->players[i].balls  = keep[i].balls;
        w->players[i].shield = keep[i].shield;
        w->players[i].kills  = keep[i].kills;
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
    if (mode < SOI_MODE_ONE || mode > SOI_MODE_VERSUS) mode = SOI_MODE_ONE;
    w->play_mode = (uint8_t)mode;
    if (w->play_mode == SOI_MODE_VERSUS) {
        w->friendly_fire = 1;
        w->challenge = 0; /* Bug B6: disable challenge round death bypass in Versus */
    }
}

int soi_play_mode(const SoiWorld *w)
{
    return w->play_mode ? w->play_mode : SOI_MODE_ONE;
}

void soi_set_friendly_fire(SoiWorld *w, int on)
{
    w->friendly_fire = on ? 1 : 0;
}

int soi_friendly_fire(const SoiWorld *w)
{
    return (w->play_mode == SOI_MODE_VERSUS) ? 1 : (w->friendly_fire ? 1 : 0);
}

void soi_set_victory_rule(SoiWorld *w, int rule)
{
    if (rule < SOI_WIN_LIVES || rule > SOI_WIN_DOOR) rule = SOI_WIN_LIVES;
    w->victory_rule = (uint8_t)rule;
}

int soi_victory_rule(const SoiWorld *w)
{
    return w->victory_rule;
}

int soi_grid_cols(const SoiWorld *w)
{
    return (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
}

int soi_grid_rows(const SoiWorld *w)
{
    return (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
}

int soi_challenge_round(const SoiWorld *w) { return w->level_loaded && w->challenge && (w->play_mode != SOI_MODE_VERSUS); }

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
    int start_lives = (w->ext_starting_lives >= 1 && w->ext_starting_lives <= 9)
        ? (int)w->ext_starting_lives
        : 2;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *p = &w->players[i];
        p->score = 0; p->lives = start_lives; p->balls = 1; p->arrows = 1;
    }
    if (w->play_mode == SOI_MODE_COOPERATE) {
        int coop_pool = (w->ext_starting_lives >= 1 && w->ext_starting_lives <= 9)
            ? (int)w->ext_starting_lives
            : 4;
        w->players[1].lives = coop_pool; w->players[1].balls = 2; w->players[1].arrows = 2;
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

    /* Bug B5 Fix: Pre-scan EXT1 trailer to configure grid dimensions, P3 spawn, and rules
     * BEFORE placing players or processing tile records. */
    w->grid_cols = SOI_GRID_COLS;
    w->grid_rows = SOI_GRID_ROWS;
    w->p3_col = 0;
    w->p3_row = 0;
    w->p3_block = 0x020D;
    memset(w->vs_spawns, 0, sizeof(w->vs_spawns));

    int ext_has_p3 = 0;
    {
        size_t scan_off = 0x18;
        size_t term_off = 0;
        while (scan_off + 4 <= len) {
            uint32_t t = be32(bord + scan_off);
            scan_off += 4;
            if (t == 0) {
                term_off = scan_off;
                break;
            }
            while (scan_off + 2 <= len) {
                uint8_t a = bord[scan_off], b = bord[scan_off + 1];
                scan_off += 2;
                if (a == 100 || b == 100) break;
            }
        }
        if (term_off > 0) {
            const uint8_t *ext = NULL;
            if (term_off + 24 <= len && memcmp(bord + term_off, "EXT1", 4) == 0)
                ext = bord + term_off;
            else if (term_off + 2 + 24 <= len && memcmp(bord + term_off + 2, "EXT1", 4) == 0)
                ext = bord + term_off + 2;

            if (ext) {
                uint16_t calc_crc = ext1_crc16(ext, 22);
                uint16_t stored_crc = be16(ext + 22);
                if (calc_crc == stored_crc || stored_crc == 0) {
                    uint8_t flags = ext[5];
                    uint8_t cols = ext[6];
                    uint8_t rows = ext[7];
                    uint8_t p3_c = ext[8];
                    uint8_t p3_r = ext[9];
                    uint16_t p3_blk = be16(ext + 10);
                    uint8_t rule = ext[20];
                    uint8_t lives = ext[21];

                    if (cols < 19) cols = 19;
                    if (cols > SOI_MAX_GRID_COLS) cols = SOI_MAX_GRID_COLS;
                    if (rows < 13) rows = 13;
                    if (rows > SOI_MAX_GRID_ROWS) rows = SOI_MAX_GRID_ROWS;
                    w->grid_cols = cols;
                    w->grid_rows = rows;
                    w->p3_col = p3_c;
                    w->p3_row = p3_r;
                    w->p3_block = p3_blk ? p3_blk : 0x020D;
                    for (i = 0; i < 4; i++) {
                        w->vs_spawns[i][0] = ext[12 + i * 2];
                        w->vs_spawns[i][1] = ext[13 + i * 2];
                    }
                    if (flags & 1) ext_has_p3 = 1;
                    if (flags & 2) w->friendly_fire = 1;
                    if (rule <= 2) w->victory_rule = rule;
                    if (lives >= 1 && lives <= 9) {
                        w->ext_starting_lives = lives;
                        if (w->play_mode == SOI_MODE_COOPERATE) {
                            w->players[1].lives = lives;
                            for (i = 2; i < SOI_MAX_PLAYERS; i++)
                                w->players[i].lives = -1;
                        } else {
                            for (i = 1; i < SOI_MAX_PLAYERS; i++)
                                w->players[i].lives = lives;
                        }
                    }
                }
            }
        }
    }

    /* header (26 bytes, big-endian u16) — CONFIRMED field roles */
    place_player(w, 1, be16(bord + 0x06), be16(bord + 0x08));
    place_player(w, 2, be16(bord + 0x0A), be16(bord + 0x0C));
    if (ext_has_p3) {
        soi_spawn_player3(w);
    }
    /* Built-block templates (asm FUN_1002b448: P1 +0x36 = header 0x02, P2 +0x36 = header 0x04;
     * FUN_1002d04c/cf08/d190 build `template & 0xff`). Every shipped board holds 0x026D /
     * 0x0273: P1 builds the BLUE block (f110), P2 the GREEN one (f116). */
    w->players[1].block_type = (uint8_t)(be16(bord + 0x02) & 0xFFu);
    w->players[2].block_type = (uint8_t)(be16(bord + 0x04) & 0xFFu);
    /* A new board starts with no block animation running (asm FUN_10029acc/b18 -> FUN_100274e8). */
    for (i = 0; i < SOI_BLOCKANIM_MAX; i++) w->banim[i].active = 0;
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
                         * StartDelay*6 frames. The renderer draws its emblem block (the
                         * sheet's last frame, FUN_10004108). */
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
                        /* Creeper segment (asm FUN_10008618 h / FUN_10008b18 v): bord 16 =
                         * horizontal, 17 = vertical (state). fire_period keeps StartDelay
                         * (+0x50, copied to every child), fire_cd is the grow timer +0x6e. */
                        w->enemies[ei].state = (uint8_t)(((tile & 0xFFu) == 0x11u) ? 1 : 0);
                        w->enemies[ei].vx = 0;
                        w->enemies[ei].fire_period = (int16_t)b0;
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
    for (i = 0; i < SOI_MAX_ENEMIES; i++)
        if (w->enemies[i].active && w->enemies[i].type == SOI_ENEMY_CREEPER)
            soi_creeper_init(w, i);
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
        for (k = len; k < sizeof(w->bord_data); k++) w->bord_data[k] = 0;
        w->bord_len = (uint16_t)len;
    } else {
        memset(w->bord_data, 0, sizeof(w->bord_data));
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
    struct { int32_t score; int16_t lives, arrows, balls, shield; uint16_t kills; uint8_t active, elim; }
        keep[SOI_MAX_PLAYERS];
    uint32_t seed   = w->rng_seed;
    uint32_t tick   = w->tick;          /* the reload runs MID-tick; keep the frame counter */
    uint8_t  parity = w->frame_parity;  /* monotonic so the tick-gated badguy throw + 30Hz  */
    uint8_t  mode   = w->play_mode;
    uint8_t  assist = w->input_assist;
    uint8_t  ffire  = w->friendly_fire;
    uint8_t  vrule  = w->victory_rule;
    uint8_t  p3any  = w->p3_any_key;
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
        keep[i].kills  = w->players[i].kills;
        keep[i].active = w->players[i].active;
        keep[i].elim   = w->players[i].eliminated;
    }

    soi_world_init(w, 1);          /* full reset; also re-seeds default stats */
    w->rng_seed      = seed;       /* continue the RNG stream across the reload */
    w->tick          = tick;       /* restore the frame counter (see above) */
    w->frame_parity  = parity;
    w->play_mode     = mode;
    w->input_assist  = assist;
    w->friendly_fire = ffire;
    w->victory_rule  = vrule;
    w->p3_any_key    = p3any;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].score  = keep[i].score;
        w->players[i].lives  = keep[i].lives;
        w->players[i].arrows = keep[i].arrows;
        w->players[i].balls  = keep[i].balls;
        w->players[i].shield = keep[i].shield;
        w->players[i].kills  = keep[i].kills;
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

void soi_set_input_assist(SoiWorld *w, int on)
{
    int i;
    uint8_t v = on ? 1u : 0u;
    if (w->input_assist == v) return;
    w->input_assist = v;
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].in_pend = 0; w->players[i].buf = 0; w->players[i].buf_t = 0;
    }
}

static void respawn_player_in_place(SoiWorld *w, SoiPlayer *rp)
{
    int bonus = 5000;
    int col, row;
    if (w->bord_len >= 0x10) {
        bonus = (int)be16(w->bord_data + 0x0E);
        if (bonus <= 0) bonus = 5000;
    }
    if (w->play_mode == SOI_MODE_VERSUS) {
        int best_x = rp->spawn_x, best_y = rp->spawn_y;
        int max_min_dist = -1;
        int cand;

        for (cand = 1; cand < SOI_MAX_PLAYERS; cand++) {
            int cx = w->players[cand].spawn_x;
            int cy = w->players[cand].spawn_y;
            if (cand == 3 && !w->players[3].active) {
                if (w->p3_col > 0 && w->p3_row > 0) {
                    cx = soi_cell_x(w->p3_col);
                    cy = soi_cell_y(w->p3_row) + 1;
                }
            }
            if (cx == 0 && cy == 0) continue;

            int min_d = 999999;
            int op, ei;
            for (op = 1; op < SOI_MAX_PLAYERS; op++) {
                const SoiPlayer *other = &w->players[op];
                if (other == rp || !other->active || !other->alive || other->eliminated) continue;
                int dx = cx - other->x; if (dx < 0) dx = -dx;
                int dy = cy - other->y; if (dy < 0) dy = -dy;
                if (dx + dy < min_d) min_d = dx + dy;
            }
            for (ei = 0; ei < SOI_MAX_ENEMIES; ei++) {
                const SoiEnemy *e = &w->enemies[ei];
                if (!e->active) continue;
                int dx = cx - e->x; if (dx < 0) dx = -dx;
                int dy = cy - e->y; if (dy < 0) dy = -dy;
                if (dx + dy < min_d) min_d = dx + dy;
            }
            if (min_d > max_min_dist) {
                max_min_dist = min_d;
                best_x = cx;
                best_y = cy;
            }
        }

        for (cand = 0; cand < 4; cand++) {
            int sc = w->vs_spawns[cand][0];
            int sr = w->vs_spawns[cand][1];
            if (sc == 0 && sr == 0) continue;
            int cx = soi_cell_x(sc);
            int cy = soi_cell_y(sr) + 1;
            int min_d = 999999;
            int op, ei;
            for (op = 1; op < SOI_MAX_PLAYERS; op++) {
                const SoiPlayer *other = &w->players[op];
                if (other == rp || !other->active || !other->alive || other->eliminated) continue;
                int dx = cx - other->x; if (dx < 0) dx = -dx;
                int dy = cy - other->y; if (dy < 0) dy = -dy;
                if (dx + dy < min_d) min_d = dx + dy;
            }
            for (ei = 0; ei < SOI_MAX_ENEMIES; ei++) {
                const SoiEnemy *e = &w->enemies[ei];
                if (!e->active) continue;
                int dx = cx - e->x; if (dx < 0) dx = -dx;
                int dy = cy - e->y; if (dy < 0) dy = -dy;
                if (dx + dy < min_d) min_d = dx + dy;
            }
            if (min_d > max_min_dist) {
                max_min_dist = min_d;
                best_x = cx;
                best_y = cy;
            }
        }
        rp->x = best_x;
        rp->y = best_y;
        rp->invuln = 120;
    } else {
        rp->x = rp->spawn_x;
        rp->y = rp->spawn_y;
        rp->invuln = 90;
    }
    rp->alive = 1;
    rp->in_air = 0;
    rp->move_ctr = 0;
    rp->run_dir = 0;
    rp->ground_state = SOI_ST_IDLE;
    rp->pose = 0;
    rp->pose_t = 0;
    rp->act_verb = SOI_ACT_NONE;
    rp->act_dirty = 0;
    rp->frame = (rp->facing == 1) ? 0x3d : 0x34;
    rp->frame_save = rp->frame;
    rp->aux = 0;
    rp->fast = 0;
    rp->jump_t = 0;
    rp->dstep = 0;
    rp->in_pend = 0;
    rp->buf = 0;
    rp->buf_t = 0;
    rp->bonus_time = bonus;
    rp->respawn_timer = 0;
    rp->last_attacker = 0;
    rp->attacker_ttl = 0;
    col = (rp->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (rp->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    rp->prev_pcol = (int16_t)col;
    rp->prev_prow = (int16_t)row;

    if (w->play_mode == SOI_MODE_VERSUS) {
        if (col >= 0 && col < w->grid_cols) {
            if (row >= 0 && row < w->grid_rows) {
                uint32_t c0 = w->cell[row][col];
                if ((c0 & SOI_CELL_SUPPORTIVE) && !(c0 & (SOI_CELL_PERMANENT | SOI_CELL_DOOR)) && (c0 & 0xFFu) != 0) {
                    soi_block_shatter(w, col, row, SOI_SHATTER_BONK, 0, 0);
                }
            }
            if (row - 1 >= 0 && row - 1 < w->grid_rows) {
                uint32_t c1 = w->cell[row - 1][col];
                if ((c1 & SOI_CELL_SUPPORTIVE) && !(c1 & (SOI_CELL_PERMANENT | SOI_CELL_DOOR)) && (c1 & 0xFFu) != 0) {
                    soi_block_shatter(w, col, row - 1, SOI_SHATTER_BONK, 0, 0);
                }
            }
        }
        if (rp->arrows < 1) rp->arrows = 1;
        if (rp->balls < 1) rp->balls = 1;
    }
}

static void check_pvp_body_collisions(SoiWorld *w)
{
    if (!w->friendly_fire) return;
    int i, j;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *p1 = &w->players[i];
        if (!p1->active || !p1->alive || p1->eliminated || p1->ground_state == SOI_ST_DEAD) continue;
        for (j = i + 1; j < SOI_MAX_PLAYERS; j++) {
            SoiPlayer *p2 = &w->players[j];
            if (!p2->active || !p2->alive || p2->eliminated || p2->ground_state == SOI_ST_DEAD) continue;

            int dx = p1->x - p2->x; if (dx < 0) dx = -dx;
            int dy = p1->y - p2->y; if (dy < 0) dy = -dy;

            if (dx < 20 && dy < 24) {
                if (p1->fast > 0 && p2->fast > 0) {
                    int push = (20 - dx + 1) / 2;
                    if (push < 2) push = 2;
                    if (p1->x <= p2->x) {
                        p1->x -= push;
                        p2->x += push;
                        p1->facing = -1;
                        p2->facing = 1;
                    } else {
                        p1->x += push;
                        p2->x += push;
                        p1->facing = 1;
                        p2->facing = -1;
                    }
                    int min_x = SOI_ORIGIN_X;
                    int max_x = soi_cell_x(w->grid_cols - 1);
                    if (p1->x < min_x) p1->x = min_x;
                    if (p1->x > max_x) p1->x = max_x;
                    if (p2->x < min_x) p2->x = min_x;
                    if (p2->x > max_x) p2->x = max_x;
                    p1->run_x0 = p1->x;
                    p2->run_x0 = p2->x;
                    p1->move_ctr = 0;
                    p2->move_ctr = 0;
                    soi_sfx_emit(w, SOI_SFX_BLOCK_BREAK);
                } else if (p1->fast > 0 && p2->fast == 0) {
                    if (p2->invuln == 0) {
                        p2->last_attacker = (uint8_t)i;
                        p2->attacker_ttl = 0;
                        p1->kills++;
                        p1->score += 1000;
                        soi_player_hit(w, j);
                    }
                } else if (p2->fast > 0 && p1->fast == 0) {
                    if (p1->invuln == 0) {
                        p1->last_attacker = (uint8_t)j;
                        p1->attacker_ttl = 0;
                        p2->kills++;
                        p2->score += 1000;
                        soi_player_hit(w, i);
                    }
                }
            }
        }
    }
}

static void check_respawns(SoiWorld *w)
{
    int i, active_players = 0, living_players = 0, any_ready = 0;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *rp = &w->players[i];
        if (rp->active && !rp->eliminated) {
            active_players++;
            if (rp->alive) {
                living_players++;
            } else if (rp->respawn_timer > 0) {
                if (--rp->respawn_timer == 0) any_ready = 1;
            } else {
                any_ready = 1; /* timer was already 0 while waiting for partner to die */
            }
        }
    }
    if (active_players > 0 && living_players == 0 && any_ready) {
        if (w->bord_len > 0) {
            reload_board_on_death(w);
        } else {
            for (i = 1; i < SOI_MAX_PLAYERS; i++) {
                SoiPlayer *rp = &w->players[i];
                if (rp->active && !rp->alive && !rp->eliminated) {
                    respawn_player_in_place(w, rp);
                }
            }
        }
    } else if (living_players > 0) {
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            SoiPlayer *rp = &w->players[i];
            if (rp->active && !rp->alive && !rp->eliminated && rp->respawn_timer <= 0) {
                respawn_player_in_place(w, rp);
            }
        }
    }
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
    w->fx_count = 0;    /* drop last frame's debris-particle spawns; this tick refills */

    if (w->tp_freeze > 0) {
        w->tp_freeze--;
        return;
    }

    /* Input is sampled every 2 frames and so is the PLAYER state machine: the asm
     * main loop (FUN_10028a0c) gates {input FUN_1002d440 + locomotion FUN_1001166c
     * + pickup FUN_1002bc64} behind the sVar7 divider = every 2nd frame, while
     * enemies run every frame. Latch input on the odd tick; reuse on even.
     * SPEED SHOES: the asm drops the divider to 1 for a fast player (FUN_10028a0c:
     * `if (+0x5c == 1) sVar7 = 1`), so input is sampled EVERY frame along with the
     * doubled locomotion below -- not held over from the odd tick. */
    {
        const uint8_t ins[4] = { 0, p1_input, p2_input, p3_input };
        for (i = 1; i < SOI_MAX_PLAYERS && i < 4; i++) {
            SoiPlayer *ip = &w->players[i];
            const int sample = ((w->tick & 1u) != 0u) || ip->fast > 0;
            if ((w->play_mode == SOI_MODE_VERSUS || w->friendly_fire) && ip->invuln > 0 &&
                (ins[i] & (SOI_IN_BLOCK_HIGH | SOI_IN_BLOCK_LOW | SOI_IN_ARROW | SOI_IN_BALL))) {
                ip->invuln = 0;
            }
            if (w->input_assist) {
                /* REMASTER assist: remember every key seen down since the last sample, so a
                 * tap that lands only on the unsampled tick still registers. */
                ip->in_pend |= ins[i];
                if (sample) { ip->input = ip->in_pend; ip->in_pend = 0; }
            } else if (sample) {
                ip->input = ins[i];
            }
        }
    }

    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].invuln > 0) w->players[i].invuln--;   /* tick i-frames */
    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].fire_cd > 0) w->players[i].fire_cd--; /* vestigial: player weapons now
                                                                * gate on one-shot-in-flight, not a
                                                                * timer (asm has no fire cooldown) */
    check_respawns(w);

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

    check_pvp_body_collisions(w);

    if (w->play_mode == SOI_MODE_VERSUS) {
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            SoiPlayer *p = &w->players[i];
            if (!p->active || !p->alive || p->eliminated) continue;
            if (p->balls == 0) {
                p->ammo_regen_cd++;
                if (p->ammo_regen_cd >= 300) {
                    p->balls = 1;
                    p->ammo_regen_cd = 0;
                }
            } else {
                p->ammo_regen_cd = 0;
            }
        }
    }
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *p = &w->players[i];
        if (p->attacker_ttl > 0) p->attacker_ttl--;
    }
    /* (The build/fire action counter advances inside soi_player_update, once per PLAYER frame,
     * exactly like the asm FUN_1001166c counter +0x2c -- it is not drained per tick.) */
    /* Clock power-up (goody 0x2E): halves the enemy update rate for ~10s. The asm
     * (_DAT_1003b294) decrements a counter each frame and runs the nasties only when
     * it is < 0 (expired -> normal) or ODD -> every other frame = 30Hz while active. */
    if (w->enemy_slow >= 0) w->enemy_slow--;
    if (w->enemy_slow < 0 || (w->enemy_slow & 1))
        soi_enemies_update(w);
    if (w->reveal_timer > 0) w->reveal_timer--;   /* magnifying-glass reveal (goody 0x2F) counts down */
    soi_projectiles_update(w);
    soi_blockanims_update(w);   /* block grow/shrink animations: every frame, after the player's
                                 * shots (asm loop: FUN_1000fd5c, FUN_10028060, FUN_100283a0) */
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
void     soi_abort_game(SoiWorld *w)
{
    int i;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        SoiPlayer *p = &w->players[i];
        if (p->active && p->alive) {
            p->invuln = 0;
            soi_player_hit(w, i);
        }
    }
    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        w->players[i].lives = 0;
    }
}

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
    int i;
    if (!w->level_loaded) return 0;
    if (w->play_mode == SOI_MODE_VERSUS) {
        if (w->victory_rule == SOI_WIN_LIVES) {
            int active = 0, alive_count = 0;
            for (i = 1; i < SOI_MAX_PLAYERS; i++) {
                if (!w->players[i].active) continue;
                active++;
                if (!w->players[i].eliminated) alive_count++;
            }
            if (active >= 2 && alive_count <= 1) return 1;
            return 0;
        } else if (w->victory_rule == SOI_WIN_SCORE) {
            if (w->goodies_total > 0 && w->goodies_left == 0) return 1;
            int all_time_up = 1, active = 0, alive_count = 0;
            for (i = 1; i < SOI_MAX_PLAYERS; i++) {
                if (!w->players[i].active) continue;
                active++;
                if (!w->players[i].eliminated) {
                    alive_count++;
                    if (w->players[i].bonus_time > 0) all_time_up = 0;
                }
            }
            if (active >= 2 && (all_time_up || alive_count <= 1)) return 1;
            return 0;
        } else {
            /* SOI_WIN_DOOR */
            for (i = 1; i < SOI_MAX_PLAYERS; i++)
                if (w->players[i].active && w->players[i].has_key == 2) return 1;
            return 0;
        }
    }
    for (i = 0; i < SOI_MAX_PLAYERS; i++)
        if (w->players[i].active && w->players[i].has_key == 2) return 1;
    return 0;
}

int      soi_versus_winner(const SoiWorld *w)
{
    if (!w || w->play_mode != SOI_MODE_VERSUS) return 0;
    int i;
    if (w->victory_rule == SOI_WIN_LIVES) {
        int winner = 0;
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            if (w->players[i].active && !w->players[i].eliminated) {
                if (winner != 0) return 0; /* multiple players alive */
                winner = i;
            }
        }
        return winner;
    } else if (w->victory_rule == SOI_WIN_SCORE) {
        int32_t high_score = -1;
        int winner = 0, tie = 0;
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            if (!w->players[i].active) continue;
            if (w->players[i].score > high_score) {
                high_score = w->players[i].score;
                winner = i;
                tie = 0;
            } else if (w->players[i].score == high_score) {
                tie = 1;
            }
        }
        return tie ? 0 : winner;
    } else if (w->victory_rule == SOI_WIN_DOOR) {
        for (i = 1; i < SOI_MAX_PLAYERS; i++) {
            if (w->players[i].active && w->players[i].has_key == 2) return i;
        }
    }
    return 0;
}

int      soi_player_kills(const SoiWorld *w, int p) { return (int)pget(w, p)->kills; }
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
int      soi_player_pose(const SoiWorld *w, int p) { return pget(w, p)->pose; }
int      soi_player_pose_t(const SoiWorld *w, int p) { const SoiPlayer *pp = pget(w, p); return pp->pose ? pp->pose_t : 0; }
int      soi_player_jump_t(const SoiWorld *w, int p) { return pget(w, p)->jump_t; }
int      soi_player_frame(const SoiWorld *w, int p) { return pget(w, p)->frame; }
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
    int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
    int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
    for (rr = 0; rr < max_r; rr++)
        for (cc = 0; cc < max_c; cc++) {
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

/* ---- cosmetic debris-particle queue (transient; the Godot layer flies each one) ---- */
void soi_fx_emit(SoiWorld *w, int sheet, int frame, int x, int y, int vx, int vy, int grav)
{
    int k;
    if (w->fx_count >= SOI_FX_QUEUE_MAX) return;
    k = w->fx_count++;
    w->fx_sheet[k] = (uint8_t)sheet;
    w->fx_frame[k] = (int16_t)frame;
    w->fx_x[k] = (int16_t)x;   w->fx_y[k] = (int16_t)y;
    w->fx_vx[k] = (int16_t)vx; w->fx_vy[k] = (int16_t)vy;
    w->fx_grav[k] = (uint8_t)(grav != 0);
}
int soi_fx_count(const SoiWorld *w) { return w->fx_count; }
int soi_fx_get(const SoiWorld *w, int i, int field)
{
    if (i < 0 || i >= w->fx_count) return 0;
    switch (field) {
        case SOI_FX_SHEET: return w->fx_sheet[i];
        case SOI_FX_FRAME: return w->fx_frame[i];
        case SOI_FX_X:     return w->fx_x[i];
        case SOI_FX_Y:     return w->fx_y[i];
        case SOI_FX_VX:    return w->fx_vx[i];
        case SOI_FX_VY:    return w->fx_vy[i];
        case SOI_FX_GRAV:  return w->fx_grav[i];
        default:           return 0;
    }
}

int soi_blockanim(const SoiWorld *w, int i)
{
    const SoiBlockAnim *a;
    if (i < 0 || i >= SOI_BLOCKANIM_MAX || !w->banim[i].active) return -1;
    a = &w->banim[i];
    if (a->frame < 1 || a->frame > 5) return -1;   /* not yet advanced (never visible to a caller) */
    return (a->col & 0xFF) | ((a->row & 0xFF) << 8) | ((a->frame & 0xFF) << 16) | ((a->step > 0) << 24);
}

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
        bput_u8(&b, p->act_verb);
        bput_u16(&b, (uint16_t)p->frame); bput_u16(&b, (uint16_t)p->frame_save);
        bput_u8(&b, p->act_dirty); bput_u16(&b, (uint16_t)p->aux); bput_u8(&b, (uint8_t)p->dstep);
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
    int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
    int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
    for (r = 0; r < max_r; r++)
        for (c = 0; c < max_c; c++)
            bput_u32(&b, w->cell[r][c]);
    for (i = 0; i < SOI_BLOCKANIM_MAX; i++) {
        const SoiBlockAnim *a = &w->banim[i];
        bput_u8(&b, a->active); bput_u8(&b, (uint8_t)a->step); bput_u8(&b, (uint8_t)a->frame);
        bput_u8(&b, a->type);
        bput_u16(&b, (uint16_t)a->col); bput_u16(&b, (uint16_t)a->row);
        bput_u32(&b, a->fin);
    }

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

/* ---------- Rollback Netcode Snapshot & Hash API ---------- */
size_t soi_snapshot_size(void)
{
    return sizeof(SoiWorld);
}

void soi_snapshot_save(const SoiWorld *w, uint8_t *dst_buf)
{
    if (!w || !dst_buf) return;
    memcpy(dst_buf, w, sizeof(SoiWorld));
}

void soi_snapshot_load(SoiWorld *w, const uint8_t *src_buf)
{
    if (!w || !src_buf) return;
    memcpy(w, src_buf, sizeof(SoiWorld));
}

int soi_tp_freeze(const SoiWorld *w)
{
    return w ? (int)w->tp_freeze : 0;
}

static inline void fnv1a_u8(uint64_t *h, uint8_t v)
{
    *h ^= (uint64_t)v;
    *h *= 1099511628211ULL;
}

static inline void fnv1a_u16(uint64_t *h, uint16_t v)
{
    fnv1a_u8(h, (uint8_t)(v & 0xFFu));
    fnv1a_u8(h, (uint8_t)((v >> 8) & 0xFFu));
}

static inline void fnv1a_u32(uint64_t *h, uint32_t v)
{
    fnv1a_u16(h, (uint16_t)(v & 0xFFFFu));
    fnv1a_u16(h, (uint16_t)((v >> 16) & 0xFFFFu));
}

static inline void fnv1a_i32(uint64_t *h, int32_t v)
{
    fnv1a_u32(h, (uint32_t)v);
}

uint64_t soi_net_hash(const SoiWorld *w)
{
    if (!w) return 0;
    uint64_t h = 1469598103934665603ULL; /* FNV offset basis */
    int i, r, c;

    fnv1a_u32(&h, w->tick);
    fnv1a_u32(&h, w->rng_seed);
    fnv1a_u8(&h, w->frame_parity);
    fnv1a_u8(&h, w->enemies_frozen);
    fnv1a_u16(&h, (uint16_t)w->enemy_slow);
    fnv1a_u16(&h, (uint16_t)w->bonus_div);
    fnv1a_u16(&h, (uint16_t)w->reveal_timer);
    fnv1a_u16(&h, (uint16_t)w->tp_freeze);
    fnv1a_u16(&h, (uint16_t)w->pct_ultrabuster);
    fnv1a_u16(&h, (uint16_t)w->thrown_badguy);
    fnv1a_u16(&h, (uint16_t)w->pct_badguy);
    fnv1a_u16(&h, (uint16_t)w->goodies_total);
    fnv1a_u16(&h, (uint16_t)w->goodies_left);
    fnv1a_u8(&h, w->level_loaded);
    fnv1a_u8(&h, w->play_mode);
    fnv1a_u8(&h, w->friendly_fire);
    fnv1a_u8(&h, w->victory_rule);
    fnv1a_u8(&h, w->challenge);
    fnv1a_u8(&h, w->input_assist);
    fnv1a_u8(&h, w->p3_col);
    fnv1a_u8(&h, w->p3_row);
    fnv1a_u16(&h, w->p3_block);
    fnv1a_u8(&h, w->p3_any_key);
    fnv1a_u8(&h, w->ext_starting_lives);
    for (i = 0; i < 4; i++) {
        fnv1a_u8(&h, w->vs_spawns[i][0]);
        fnv1a_u8(&h, w->vs_spawns[i][1]);
    }

    for (i = 0; i < SOI_MAX_PLAYERS; i++) {
        const SoiPlayer *p = &w->players[i];
        fnv1a_u8(&h, p->active); fnv1a_u8(&h, p->alive); fnv1a_u8(&h, p->eliminated);
        fnv1a_i32(&h, p->x); fnv1a_i32(&h, p->y);
        fnv1a_u16(&h, (uint16_t)p->facing);
        fnv1a_u8(&h, p->ground_state); fnv1a_u8(&h, p->in_air);
        fnv1a_u16(&h, (uint16_t)p->move_ctr); fnv1a_u16(&h, (uint16_t)p->run_dir);
        fnv1a_i32(&h, p->run_x0);
        fnv1a_u16(&h, (uint16_t)p->jump_t); fnv1a_u16(&h, (uint16_t)p->launch_y);
        fnv1a_u8(&h, p->block_type); fnv1a_u8(&h, p->has_key); fnv1a_u16(&h, p->keys);
        fnv1a_u8(&h, p->input); fnv1a_u8(&h, p->input_prev);
        fnv1a_u16(&h, (uint16_t)p->lives);
        fnv1a_i32(&h, p->score); fnv1a_i32(&h, p->bonus_time);
        fnv1a_u16(&h, (uint16_t)p->mult);
        fnv1a_u16(&h, (uint16_t)p->no_weapons_reward);
        fnv1a_u16(&h, (uint16_t)p->shield); fnv1a_u16(&h, (uint16_t)p->arrows);
        fnv1a_u16(&h, (uint16_t)p->balls);
        fnv1a_u16(&h, (uint16_t)p->invuln); fnv1a_u16(&h, (uint16_t)p->fire_cd);
        fnv1a_u16(&h, (uint16_t)p->spawn_x); fnv1a_u16(&h, (uint16_t)p->spawn_y);
        fnv1a_u16(&h, (uint16_t)p->respawn_timer);
        fnv1a_u16(&h, (uint16_t)p->fast);
        fnv1a_u8(&h, p->pose);
        fnv1a_u16(&h, (uint16_t)p->pose_t);
        fnv1a_u8(&h, p->act_verb);
        fnv1a_u16(&h, (uint16_t)p->frame); fnv1a_u16(&h, (uint16_t)p->frame_save);
        fnv1a_u8(&h, p->act_dirty); fnv1a_u16(&h, (uint16_t)p->aux);
        fnv1a_u8(&h, (uint8_t)p->dstep);
        fnv1a_u16(&h, (uint16_t)p->prev_pcol); fnv1a_u16(&h, (uint16_t)p->prev_prow);
        fnv1a_u8(&h, p->in_pend); fnv1a_u8(&h, p->buf); fnv1a_u8(&h, p->buf_t);
        fnv1a_u8(&h, p->last_attacker); fnv1a_u16(&h, p->attacker_ttl);
        fnv1a_u16(&h, p->kills); fnv1a_u16(&h, p->ammo_regen_cd);
    }
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *e = &w->enemies[i];
        fnv1a_u8(&h, e->active); fnv1a_u8(&h, e->type); fnv1a_u8(&h, e->dir); fnv1a_u8(&h, e->state);
        fnv1a_i32(&h, e->x); fnv1a_i32(&h, e->y);
        fnv1a_u16(&h, (uint16_t)e->vx); fnv1a_u16(&h, (uint16_t)e->vy);
        fnv1a_u16(&h, (uint16_t)e->points); fnv1a_u8(&h, e->owner); fnv1a_u8(&h, e->claimed);
        fnv1a_u16(&h, e->anim); fnv1a_u16(&h, (uint16_t)e->fire_cd);
        fnv1a_u16(&h, (uint16_t)e->fire_period);
        fnv1a_u8(&h, e->spawn_child); fnv1a_u16(&h, (uint16_t)e->life);
        fnv1a_u8(&h, e->child);
        fnv1a_u32(&h, e->under);
        fnv1a_u8(&h, e->period); fnv1a_u8(&h, e->stepc);
        fnv1a_u8(&h, e->turn); fnv1a_u8(&h, e->bud);
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        const SoiProjectile *pr = &w->projectiles[i];
        fnv1a_u8(&h, pr->active); fnv1a_u8(&h, pr->owner); fnv1a_u8(&h, pr->hostile);
        fnv1a_u8(&h, pr->kind); fnv1a_u8(&h, pr->src_type);
        fnv1a_i32(&h, pr->x); fnv1a_i32(&h, pr->y);
        fnv1a_u16(&h, (uint16_t)pr->vx); fnv1a_u16(&h, (uint16_t)pr->vy);
        fnv1a_u16(&h, (uint16_t)pr->age);
        fnv1a_u8(&h, pr->pierce);
        fnv1a_u8(&h, pr->gtype);
        fnv1a_u16(&h, (uint16_t)pr->tcol); fnv1a_u16(&h, (uint16_t)pr->trow);
    }
    int max_r = (w && w->grid_rows >= 13) ? (int)w->grid_rows : SOI_GRID_ROWS;
    int max_c = (w && w->grid_cols >= 19) ? (int)w->grid_cols : SOI_GRID_COLS;
    fnv1a_u8(&h, (uint8_t)max_c);
    fnv1a_u8(&h, (uint8_t)max_r);
    for (r = 0; r < max_r; r++) {
        for (c = 0; c < max_c; c++) {
            fnv1a_u32(&h, w->cell[r][c]);
        }
    }
    for (i = 0; i < SOI_BLOCKANIM_MAX; i++) {
        const SoiBlockAnim *a = &w->banim[i];
        fnv1a_u8(&h, a->active); fnv1a_u8(&h, (uint8_t)a->step); fnv1a_u8(&h, (uint8_t)a->frame);
        fnv1a_u8(&h, a->type);
        fnv1a_u16(&h, (uint16_t)a->col); fnv1a_u16(&h, (uint16_t)a->row);
        fnv1a_u32(&h, a->fin);
    }
    fnv1a_u8(&h, w->sw_count);
    for (i = 0; i < w->sw_count; i++) {
        fnv1a_u16(&h, (uint16_t)w->sw_col[i]);
        fnv1a_u16(&h, (uint16_t)w->sw_row[i]);
        fnv1a_u8(&h, w->sw_group[i]);
        fnv1a_u8(&h, w->sw_state[i]);
        fnv1a_u8(&h, w->sw_ctr[i]);
        fnv1a_u8(&h, w->sw_solid[i]);
        fnv1a_u8(&h, w->sw_pass[i]);
    }
    return h;
}
