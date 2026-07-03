/* soi_internal.h — internal state layout + shared helpers for the core.
 * Not part of the public ABI. All logical state lives in SoiWorld; it contains
 * only fixed-width integers so it serializes/hashes identically on every
 * platform (MASTER_PLAN §5.1/§5.2).
 */
#ifndef SOI_INTERNAL_H
#define SOI_INTERNAL_H

#include "soi_core.h"

/* ---- grid cell encoding (CONFIRMED from asm; docs decompiled-findings.md §0) ---- */
#define SOI_CELL_EMPTY        0u
#define SOI_CELL_TYPE(c)      ((c) & 0xFFu)          /* block/goodie type; 0=empty */
#define SOI_CELL_PERMANENT    0x100u                  /* immutable */
#define SOI_CELL_SUPPORTIVE   0x200u                  /* standable (you stand on it) */
#define SOI_CELL_DOOR         0x800u                  /* exit door (low type 0-3) */
#define SOI_CELL_SPECIAL      0x1000u                 /* has a payload in bits 16.. */
#define SOI_CELL_PAYLOAD(c)   (((c) >> 16) & 0xFFFFu) /* revealed goodie when destroyed */
#define SOI_WALL              0x300u                  /* permanent + supportive wall (0x200|0x100) */

/* goodie / marker cell types (CONFIRMED, docs §2 / §0) */
#define SOI_TILE_KEY          0x0Bu                   /* the key (collect to open the door) */

/* Ground state machine selector (player.ground_state; asm FUN_1001166c +0x1c). */
enum { SOI_ST_IDLE = 0, SOI_ST_RUN = 1, SOI_ST_JUMP = 2, SOI_ST_FALL = 3,
       SOI_ST_DEAD = 0xC };

typedef struct {
    uint8_t  active;      /* slot in use */
    uint8_t  alive;       /* not currently dead/dying */
    uint8_t  eliminated;  /* out of lives */
    int32_t  x, y;        /* screen pixel position (x = cell left, y = cell top) */
    int16_t  facing;      /* +1 = right, -1 = left */
    uint8_t  ground_state;/* SOI_ST_*  (idle/run/jump/fall/dead) */
    uint8_t  in_air;      /* 1 = jump/fall parabola physics active */
    int16_t  move_ctr;    /* 0..6 run-step animation counter */
    int16_t  run_dir;     /* -1/0/+1 horizontal direction of the current run step */
    int32_t  run_x0;      /* x at the start of the current run step (for interp) */
    int16_t  jump_t;      /* parabola timer (frames since launch) */
    int16_t  launch_y;    /* parabola base Y (constant during an arc) */
    uint8_t  block_type;  /* block type this player creates */
    uint8_t  has_key;     /* collected the board's key */
    uint8_t  input;       /* input bitmask applied this frame */
    int16_t  lives;
    int32_t  score;
    int32_t  bonus_time;  /* per-player starting bonus (BORD 0x16, default 5000) */
    int16_t  shield;
    int16_t  arrows;
    int16_t  invuln;      /* post-hit i-frames; >0 = damage-immune */
    int16_t  fire_cd;     /* fire cooldown; >0 = can't fire yet */
    int16_t  spawn_x, spawn_y;      /* respawn pixel position (level start) */
    int16_t  respawn_timer;         /* >0 = counting down to respawn */
} SoiPlayer;

typedef struct {
    uint8_t  active;
    uint8_t  owner;       /* firing player index, for kill scoring */
    int32_t  x, y;        /* pixel position */
    int16_t  vx, vy;      /* straight-line velocity (Magic Arrow) */
} SoiProjectile;

typedef struct {
    uint8_t  active;
    uint8_t  type;        /* SoiEnemyType */
    uint8_t  dir;         /* 1 = left, 2 = right (walk-and-turn) */
    uint8_t  state;       /* type-specific AI state */
    int32_t  x, y;        /* pixel position (>>5 = cell) */
    int16_t  vx, vy;      /* velocity added each frame */
    int16_t  points;      /* score awarded on kill (+0x42) */
    uint8_t  owner;       /* killer player index, for scoring */
    uint16_t anim;        /* animation frame counter */
} SoiEnemy;

struct SoiWorld {
    uint32_t rng_seed;    /* Toolbox Random() state (low-mem randSeed analogue) */
    uint32_t tick;        /* virtual frame counter (pacing-only in the original) */

    uint32_t cell[SOI_GRID_ROWS][SOI_GRID_COLS];  /* live playfield */

    SoiPlayer players[SOI_MAX_PLAYERS];
    SoiEnemy  enemies[SOI_MAX_ENEMIES];
    SoiProjectile projectiles[SOI_MAX_PROJECTILES];
    int32_t  bonus_timer;  /* round countdown (_DAT_1003b294 analogue) */
    uint8_t  frame_parity; /* input sampled every 2 frames */
    uint8_t  enemies_frozen; /* Stop/Go switch state: 1 = nasties halted */

    /* level parameters (BORD header) */
    int16_t  pct_ultrabuster;  /* 0x10 */
    int16_t  thrown_badguy;    /* 0x12 (SoiEnemyType-ish index) */
    int16_t  pct_badguy;       /* 0x14 */
    uint8_t  level_loaded;
    int16_t  goodies_total;    /* treasure cells present at level load */
    int16_t  goodies_left;     /* treasure still uncollected */

    /* transient per-tick sound-event queue (NOT serialized/hashed) */
    uint8_t  sfx_queue[SOI_SFX_QUEUE_MAX];
    uint8_t  sfx_count;
};

/* ---- rng (soi_rng.c) ---- */
void     soi_rng_seed(SoiWorld *w, uint32_t seed);
int32_t  soi_rng_next(SoiWorld *w);          /* signed 16-bit, like Toolbox Random() */
int      soi_rand_range(SoiWorld *w, int n); /* 1..n, RandomInRange (FUN_1000c278) */

/* ---- grid (soi_grid.c) ---- */
int      soi_cell_x(int col);   /* col -> screen px */
int      soi_cell_y(int row);
int      soi_in_bounds(int col, int row);
uint32_t soi_get_cell(const SoiWorld *w, int col, int row);
void     soi_set_cell(SoiWorld *w, int col, int row, uint32_t v);
/* create-or-destroy toggle at (col,row) for player p (FUN_1002d04c). */
void     soi_block_action(SoiWorld *w, int col, int row, int player);

/* ---- physics / players (soi_physics.c) ---- */
void     soi_player_update(SoiWorld *w, int player);

/* ---- enemies (soi_enemies.c) ---- */
int16_t  soi_enemy_points(SoiEnemyType t);
void     soi_enemy_spawn(SoiWorld *w, SoiEnemyType t, int col, int row);
void     soi_enemies_update(SoiWorld *w);
void     soi_enemy_kill(SoiWorld *w, int idx, int by_player);
int      soi_enemy_at(const SoiWorld *w, int col, int row); /* -1 if none */
/* apply one point of damage to a player, spending a shield if held. */
void     soi_player_hit(SoiWorld *w, int idx);
/* fire a Magic Arrow in the player's facing direction (consumes an arrow). */
void     soi_projectile_fire(SoiWorld *w, int player);
void     soi_projectiles_update(SoiWorld *w);

/* ---- goodies (soi_grid.c) ---- */
void     soi_pickup_check(SoiWorld *w, int player);

/* ---- sound events (soi_state.c) ---- */
void     soi_sfx_emit(SoiWorld *w, int id);   /* push one SoiSfx onto the tick queue */

#endif /* SOI_INTERNAL_H */
