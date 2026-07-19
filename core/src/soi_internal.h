/* soi_internal.h — internal state layout + shared helpers for the core.
 * Not part of the public ABI. All logical state lives in SoiWorld; it contains
 * only fixed-width integers so it serializes/hashes identically on every
 * platform (MASTER_PLAN §5.1/§5.2).
 */
#ifndef SOI_INTERNAL_H
#define SOI_INTERNAL_H

#include "soi_core.h"

/* Largest BORD resource we snapshot for the faithful death-reload (biggest shipped
 * board is 656 bytes; 1024 leaves headroom). */
#define SOI_BORD_MAX 1024u

/* ---- grid cell encoding (CONFIRMED from asm; docs decompiled-findings.md §0) ---- */
#define SOI_CELL_EMPTY        0u
#define SOI_CELL_TYPE(c)      ((c) & 0xFFu)          /* block/goodie type; 0=empty */
#define SOI_CELL_PERMANENT    0x100u                  /* immutable */
#define SOI_CELL_SUPPORTIVE   0x200u                  /* standable (you stand on it) */
#define SOI_CELL_DOOR         0x800u                  /* exit door (low type 0-3) */
#define SOI_CELL_SPECIAL      0x1000u                 /* has a payload in bits 16.. */
#define SOI_CELL_CRACKED      0x4000u                 /* head-bonked once; next bonk breaks it (asm 0x4000) */
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
    uint8_t  input_prev;  /* previous frame's input (for edge-triggered actions) */
    int16_t  lives;
    int32_t  score;
    int32_t  bonus_time;  /* per-player starting bonus (BORD 0x0E, default 5000) */
    int16_t  mult;        /* score multiplier (goody 0x0C-0x0F -> asm +0x44 via FUN_10011428);
                           * default 1; multiplies the end-of-level bonus (mult x bonus_time,
                           * tallied in FUN_10029264). Reset to 1 each level (FUN_1002b174). */
    int16_t  no_weapons_reward;  /* "No Weapons Reward" (BORD 0x16 -> asm FUN_1002b448): loaded to
                           * 5000 each board (the field is the 0x3A20 sentinel or 0, both -> 5000; no
                           * board ships a custom value). Zeroed the instant the player fires a
                           * ball/arrow (FUN_10010d30/100110b4). Added ONCE to the score at completion
                           * if still >0 (FUN_10015714). Reset per board. */
    int16_t  shield;
    int16_t  arrows;
    int16_t  balls;       /* Magic Ball ammo (+0x4a; separate from arrows +0x4c) */
    int16_t  invuln;      /* post-hit i-frames; >0 = damage-immune */
    int16_t  fire_cd;     /* fire cooldown; >0 = can't fire yet */
    int16_t  spawn_x, spawn_y;      /* respawn pixel position (level start) */
    int16_t  respawn_timer;         /* >0 = counting down to respawn */
    int16_t  fast;                  /* speed-shoes timer (goody 0x32 -> asm +0x5c/+0x6e);
                                     * >0 = 2x speed (player runs at 60Hz, not 30Hz) */
    uint8_t  pose;                  /* action pose for DISPLAY: 0 none, 1 fire, 2 build */
    int16_t  pose_t;                /* action-pose countdown (frames). Drives DISPLAY (the
                                     * fire/build pose out-ranks run in the renderer) AND gates
                                     * the ground run dispatch: while >0 the player is frozen in
                                     * the ~12-frame swing (the anti-"glide" stutter-stop, asm
                                     * FUN_1001166c +0x25). It self-releases because soi_state.c
                                     * decrements it UNCONDITIONALLY every frame -- keep that
                                     * drain ungated or the freeze becomes permanent. */
} SoiPlayer;

typedef struct {
    uint8_t  active;
    uint8_t  owner;       /* firing player index, for kill scoring */
    uint8_t  hostile;     /* 0 = player arrow (kills nasties); 1 = enemy shot (hits players) */
    uint8_t  kind;        /* 0 = Magic Arrow; 1 = Magic Ball (rolls); 2 = Knight gift (flies to a cell, drops a goody) */
    uint8_t  src_type;    /* shooter's SoiEnemyType for a hostile shot (0 = player); picks its art */
    int32_t  x, y;        /* pixel position */
    int16_t  vx, vy;      /* straight-line velocity (Magic Arrow) */
    int16_t  age;         /* frames alive (bouncing Magic Arrow fizzles at ~500) */
    uint8_t  pierce;      /* Gargoyle UltraBuster (pct_ultrabuster roll): 1 = passes THROUGH blocks,
                           * destroying several; 0 = breaks one block and dies (asm FUN_1000b0a4 +0x8a). */
    uint8_t  gtype;       /* Knight gift (kind 2): goody type to drop on arrival (FUN_1000c680) */
    int16_t  tcol, trow;  /* Knight gift: target cell it flies toward (FUN_1000c8bc/FUN_1000cafc) */
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
    uint8_t  claimed;     /* Shoes/Turtles owner (+0x88): 0 = none, else the
                           * collecting player this nasty is defeated for */
    uint16_t anim;        /* animation frame counter */
    int16_t  fire_cd;     /* shooter reload countdown (Cannon +0x6c) */
    int16_t  fire_period; /* shooter reload period = StartDelay(b0)*6 (Cannon +0x50) */
    uint8_t  spawn_child; /* persistent-spawner emitted nasty (SoiEnemyType; 0 = not a spawner) */
    int16_t  life;        /* transient lifespan in frames (0 = immortal; spawned children only) */
    uint8_t  child;       /* Beanie: slot+1 of its one living bud (0 = none) */
    uint32_t under;       /* Creeper: the tile it currently covers (asm +0x70), restored on leave */
} SoiEnemy;

struct SoiWorld {
    uint32_t rng_seed;    /* Toolbox Random() state (low-mem randSeed analogue) */
    uint32_t tick;        /* virtual frame counter (pacing-only in the original) */

    uint32_t cell[SOI_GRID_ROWS][SOI_GRID_COLS];  /* live playfield */

    SoiPlayer players[SOI_MAX_PLAYERS];
    SoiEnemy  enemies[SOI_MAX_ENEMIES];
    SoiProjectile projectiles[SOI_MAX_PROJECTILES];
    uint8_t  frame_parity; /* input sampled every 2 frames */
    uint8_t  enemies_frozen; /* VESTIGIAL (always 0): a former Stop/Go "freeze" stand-in. Stop/Go is a
                              * cosmetic block-graphic swap with NO gameplay effect (see soi_grid.c), so the
                              * switch never freezes enemies. Kept only for serialize-format stability. */
    int16_t  enemy_slow;     /* Clock goody (asm _DAT_1003b294): >=0 = nasties at half rate; counts down */
    int16_t  bonus_div;      /* Bonus-countdown frame divider (asm _DAT_10038eb0): fires every 3rd frame */
    int16_t  reveal_timer;   /* Magnifying-glass goody 0x2F (asm FUN_10016b28): >0 = hidden 0x1000
                              * (SPECIAL) treasure cells are shown to the player; counts down (~300 frames). */

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

    /* transient per-tick enemy-death effect queue (NOT serialized/hashed): every KILL
     * (soi_enemy_kill) snapshots the dying nasty's position/type/facing so the Godot
     * layer can render the cosmetic death "pop" (asm FUN_10028014). Lifespan despawns
     * never enqueue (they just vanish, matching the asm's FUN_10004cb0 erase). */
    int16_t  death_x[SOI_DEATH_QUEUE_MAX];
    int16_t  death_y[SOI_DEATH_QUEUE_MAX];
    uint8_t  death_type[SOI_DEATH_QUEUE_MAX];
    uint8_t  death_dir[SOI_DEATH_QUEUE_MAX];
    uint8_t  death_count;

    /* Faithful death recovery: a copy of the CURRENT board's BORD bytes, captured at
     * load, so a death can RELOAD the board (asm FUN_1001f4f8 -> FUN_10029acc ->
     * FUN_1002b448: grid/enemies/bonus/positions reset, persistent stats kept). NOT part
     * of soi_serialize -- it is fixed input data, not evolving sim state -- so it is
     * absent from the determinism hash regardless of whether a reload ever fires. */
    uint16_t bord_len;                    /* 0 = no stored board (bare unit-test world) */
    uint8_t  bord_data[SOI_BORD_MAX];
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

/* ---- physics / players (soi_physics.c) ---- */
void     soi_player_update(SoiWorld *w, int player);

/* ---- enemies (soi_enemies.c) ---- */
int16_t  soi_enemy_points(SoiEnemyType t);
int      soi_enemy_spawn(SoiWorld *w, SoiEnemyType t, int col, int row);
SoiEnemyType soi_bord_badguy_type(uint8_t bord_type);
int      soi_bord_is_spawner(uint8_t bord_type);
void     soi_enemies_update(SoiWorld *w);
/* true if (col,row) is a legal Knight-gift target: in bounds, empty, and not within
 * the 3x3 neighborhood of a Knight or Gargoyle (keeps gifts out of the shooters' cages). */
int      soi_gift_cell_ok(SoiWorld *w, int col, int row);
void     soi_enemy_kill(SoiWorld *w, int idx, int by_player);
int      soi_enemy_at(const SoiWorld *w, int col, int row); /* -1 if none */
/* apply one point of damage to a player, spending a shield if held. */
void     soi_player_hit(SoiWorld *w, int idx);
/* fire a Magic Arrow in the player's facing direction (consumes an arrow). */
void     soi_projectile_fire(SoiWorld *w, int player);
/* fire a Magic Ball in the player's facing direction (consumes a ball); the ball
 * rolls horizontally at a fixed height and stops (without smashing) at a block. */
void     soi_ball_fire(SoiWorld *w, int player);
void     soi_projectiles_update(SoiWorld *w);

/* ---- goodies (soi_grid.c) ---- */
void     soi_pickup_check(SoiWorld *w, int player);

/* ---- sound events (soi_state.c) ---- */
void     soi_sfx_emit(SoiWorld *w, int id);   /* push one SoiSfx onto the tick queue */
void     soi_death_emit(SoiWorld *w, int x, int y, int type, int dir); /* push one death-pop onto the tick queue */

#endif /* SOI_INTERNAL_H */
