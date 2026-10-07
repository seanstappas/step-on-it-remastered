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

/* Stop/Go switch-block registry capacity. VERIFIED: the densest shipped board
 * (board_1037) has 14 switch blocks; a full scan of all 152 boards never exceeds
 * that, so 64 is >4x headroom and the sw_count cap is unreachable in practice. */
#define SOI_SWITCH_MAX 64

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

/* Ground state machine selector (player.ground_state; asm FUN_1001166c +0x1c), numbered as
 * the asm's movement switch: 0 idle FUN_100128f8, 1 run FUN_10012bf4, 2 jump FUN_10013404,
 * 3 fall FUN_1001386c, 4 head-bonk recoil FUN_10014524, 9 / 10 turn to face right / left
 * from a stand FUN_10013ddc / FUN_10013f68, 0xB turn round mid-run FUN_10013c18, 0xC stop
 * (legs come together) FUN_100140f4, 0xD settle into the stand FUN_1001431c. The asm marks a
 * DYING player with a separate flag (+0x28); the port folds it into ground_state as
 * SOI_ST_DEAD, a value outside the asm's switch. */
enum { SOI_ST_IDLE = 0, SOI_ST_RUN = 1, SOI_ST_JUMP = 2, SOI_ST_FALL = 3,
       SOI_ST_BONK = 4, SOI_ST_TURN_R = 9, SOI_ST_TURN_L = 10, SOI_ST_TURN = 0xB,
       SOI_ST_STOP = 0xC, SOI_ST_SETTLE = 0xD, SOI_ST_DEAD = 0x80 };

/* Build/fire action verbs (asm FUN_1001166c +0x2e): the high/low block choice lives in
 * the anim mode (pose 3/1 vs 4/2), the fire verbs in the verb. */
enum { SOI_ACT_NONE = 0, SOI_ACT_BLOCK = 1, SOI_ACT_BALL = 2, SOI_ACT_ARROW = 3 };

/* One block build/remove animation (asm list @0x1003a370, stride 0x10, 10 slots). */
typedef struct {
    uint8_t  active;
    int8_t   step;      /* asm +6: +1 = build (grows 1..5), -1 = removal (shrinks 5..1) */
    int8_t   frame;     /* asm +4: 0 (build) / 6 (removal) at the start, then the drawn frame */
    uint8_t  type;      /* asm +8: block sprite a finished build draws (0 for a removal) */
    int16_t  col, row;  /* 0-based cell (the asm keeps the cell's pixel x/y) */
    uint32_t fin;       /* asm +0xA: the cell value stored when the animation ends */
} SoiBlockAnim;

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
    uint8_t  pose;                  /* build/fire ACTION anim mode (asm +0x30; the asm action-active
                                     * flag +0x25 is pose != 0): 1 left high/fire, 2 left low, 3 right
                                     * high/fire, 4 right low. Set by an action key press (FUN_1001166c
                                     * start branch), cleared when the counter reaches 7. */
    int16_t  pose_t;                /* action frame counter (asm +0x2c): 0 on the start frame, +1 per
                                     * player frame; frames 1..6 show pose-table[pose_t], the verb fires
                                     * at 5, and at 7 the action ends and the movement handler runs on
                                     * that SAME frame. While an action runs (start frame included) no
                                     * movement happens at all -- run, jump, fall, bonk are frozen. */
    uint8_t  act_verb;              /* the action's verb (asm +0x2e): SOI_ACT_* */
    int16_t  frame;                 /* sprite frame (asm +0x0e, asm numbering: the extracted
                                     * BP/GP_sprites PNG is f(frame+1)); every state handler sets it
                                     * exactly as the original does */
    int16_t  frame_save;            /* the frame an action interrupted (asm +0x1a, FUN_10014700) */
    uint8_t  act_dirty;             /* an action ran since the movement handler last restored
                                     * frame_save (asm +0x26; FUN_10014744 restores + clears it) */
    int16_t  aux;                   /* asm +0x10: the jump's tumble frame / the stop's target leg
                                     * frame / the run frame a mid-run turn resumes on */
    int8_t   dstep;                 /* death flap direction (+1/-1; the asm keeps it in +0x2e) */
    int16_t  prev_pcol, prev_prow;  /* the player's collision-centre cell LAST frame, for the
                                     * Stop/Go switch entry edge (asm FUN_1002bc64 bVar12 = cell
                                     * changed this frame). Seeded to the spawn cell so spawning ON
                                     * a switch tile does not toggle it. */
    /* REMASTER input assist (w->input_assist; NOT in the original, NOT serialized). */
    uint8_t  in_pend;               /* keys seen down on any tick since the last input sample, so a
                                     * tap shorter than the 2-frame sampling interval is not lost */
    uint8_t  buf;                   /* buffered verb presses (jump/block/arrow/ball) not yet usable */
    uint8_t  buf_t;                 /* player frames left before `buf` expires */
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
    uint8_t  period;      /* frames per AI step (asm +0x6c reload+1): 2 for the walkers, 3 Walker,
                           * 1 fast Wheelie / turrets / Creeper */
    uint8_t  stepc;       /* frames since the last AI step */
    uint8_t  turn;        /* AI steps left in a turn-around (asm +0x4c states 5/6); dir is already the new heading */
    uint8_t  bud;         /* Beanie: steps into its block-breaking bud (asm 0x6b/0x6c child); 0 = none */
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
                              * real solid<->passable block path-gate (see the switch code in soi_grid.c),
                              * NOT an enemy freeze -- toggling a switch never stops enemies. Kept only for
                              * serialize-format stability (still written by soi_serialize as a 0 byte). */
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
    uint8_t  play_mode;        /* SOI_MODE_* (0 behaves as SOI_MODE_ONE) */
    uint8_t  challenge;        /* 1 = CHALLENGE ROUND: the board holds a Knight or Gargoyle (asm
                                * FUN_10017a70 -> DAT_1003ad0e, computed at load by FUN_1002d980) */

    /* REMASTER input assist (soi_set_input_assist): 0 = faithful input (default); 1 = keep taps
     * shorter than the sampling interval and buffer verb presses for a few player frames.
     * Survives soi_load_level; zeroed by soi_world_init. NOT serialized/hashed. */
    uint8_t  input_assist;

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

    /* transient per-tick cosmetic debris queue (NOT serialized/hashed): the asm's particle
     * list (FUN_100278bc / mover FUN_10028060) is purely visual -- shattered-block quarters
     * and popped goodies never collide with anything -- so the core only reports each
     * particle's spawn and the Godot layer flies it (see soi_fx_get). */
    int16_t  fx_x[SOI_FX_QUEUE_MAX];
    int16_t  fx_y[SOI_FX_QUEUE_MAX];
    int16_t  fx_vx[SOI_FX_QUEUE_MAX];
    int16_t  fx_vy[SOI_FX_QUEUE_MAX];
    uint8_t  fx_sheet[SOI_FX_QUEUE_MAX];
    int16_t  fx_frame[SOI_FX_QUEUE_MAX];
    uint8_t  fx_grav[SOI_FX_QUEUE_MAX];
    uint8_t  fx_count;

    /* Block build/remove animations (asm FUN_1002754c / FUN_100283a0). GAMEPLAY state: the
     * cell holds an in-between value while one runs (0x300 during a build, 0x200 during a
     * removal) and only takes its final value when it ends -- serialized. */
    SoiBlockAnim banim[SOI_BLOCKANIM_MAX];

    /* Faithful death recovery: a copy of the CURRENT board's BORD bytes, captured at
     * load, so a death can RELOAD the board (asm FUN_1001f4f8 -> FUN_10029acc ->
     * FUN_1002b448: grid/enemies/bonus/positions reset, persistent stats kept). NOT part
     * of soi_serialize -- it is fixed input data, not evolving sim state -- so it is
     * absent from the determinism hash regardless of whether a reload ever fires. */
    uint16_t bord_len;                    /* 0 = no stored board (bare unit-test world) */
    uint8_t  bord_data[SOI_BORD_MAX];

    /* Stop/Go switch-block registry (asm array @_DAT_10038ec6, stride 0xe). Populated at
     * load by a grid scan for switch BLOCKS (low 0x9d-0xd3); a switch TILE (low 0x24-0x2d)
     * toggles every block in its GROUP. The blocks' live solid/passable state is stamped
     * into w->cell[][] (which IS serialized), so the gameplay-visible state is in the hash
     * via the grid; this registry is the animation bookkeeping and is NOT serialized (a
     * switch-free board -- e.g. the determinism harness -- leaves sw_count=0, so it is
     * hash-neutral there). No soi_deserialize exists -- soi_serialize feeds ONLY the
     * forward-only determinism hash -- so this omission cannot desync a save/resume, and
     * the sw_* / prev_pcol,prev_prow state is deterministic-from-input regardless.
     * State: 1=passable(settled), 2=solid(settled), 3=opening, 4=closing. */
    int16_t  sw_col[SOI_SWITCH_MAX];
    int16_t  sw_row[SOI_SWITCH_MAX];
    uint8_t  sw_group[SOI_SWITCH_MAX];
    uint8_t  sw_state[SOI_SWITCH_MAX];
    uint8_t  sw_ctr[SOI_SWITCH_MAX];      /* open/close animation counter */
    uint8_t  sw_solid[SOI_SWITCH_MAX];    /* group SOLID low code (0x9d+12g) */
    uint8_t  sw_pass[SOI_SWITCH_MAX];     /* group PASSABLE low code (0xa3+12g) */
    uint8_t  sw_count;
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

/* ---- Stop/Go switches (soi_grid.c) ---- */
void     soi_switch_load_scan(SoiWorld *w);   /* register switch blocks after a board load */
void     soi_switch_toggle(SoiWorld *w, int tile_low);  /* flip the group a switch tile selects */
void     soi_switch_animate(SoiWorld *w);     /* advance open/close animations one frame */

/* ---- block build/remove animations + debris (soi_grid.c) ---- */
/* asm FUN_1002754c: start a build (step +1: the cell becomes solid+locked |0x300 at once and
 * `fin` when the grow ends) or a removal (step -1: the cell is cleared to its payload or 0,
 * kept standable |0x200, and becomes `fin` when the shrink ends). 0-based cell. */
void     soi_blockanim_start(SoiWorld *w, int col, int row, int step, int type, uint32_t fin);
void     soi_blockanims_update(SoiWorld *w);  /* asm FUN_100283a0: advance every animation a frame */
/* asm FUN_100279c4: remove a breakable block through the shrink animation (reveals a payload). */
void     soi_block_remove(SoiWorld *w, int col, int row);
/* Shatter a breakable block into its 4 flying quarters (asm FUN_1002ca5c head-bonk up-burst,
 * FUN_10027d84 / FUN_10027ecc right / left blast, FUN_10027aec Hammer smash, FUN_10027c34
 * along (vx,vy) in 1/10 px): clears it at once to its payload or 0 (FUN_1002cc10). */
enum { SOI_SHATTER_BONK = 0, SOI_SHATTER_RIGHT, SOI_SHATTER_LEFT, SOI_SHATTER_DROP, SOI_SHATTER_DIR };
void     soi_block_shatter(SoiWorld *w, int col, int row, int kind, int vx, int vy);
/* Queue one cosmetic particle (asm FUN_100278bc). */
void     soi_fx_emit(SoiWorld *w, int sheet, int frame, int x, int y, int vx, int vy, int grav);

/* ---- play-mode credit pool ----
 * Cooperate keeps ONE team pool in player 1's slot: every score/lives/ammo/multiplier/Bonus
 * credit for any player is redirected there (asm: FUN_1002bc64, FUN_1000e9c8, FUN_1000ed6c,
 * FUN_1000ee90, FUN_10010d30, FUN_100110b4, FUN_10011428 all do `if (!DAT_100370e4) p = 1`). */
static inline int soi_pool_idx(const SoiWorld *w, int idx)
{
    return (w->play_mode == SOI_MODE_COOPERATE && idx > 0) ? 1 : idx;
}
static inline SoiPlayer *soi_pool(SoiWorld *w, int idx) { return &w->players[soi_pool_idx(w, idx)]; }

/* ---- physics / players (soi_physics.c) ---- */
void     soi_player_update(SoiWorld *w, int player);

/* ---- enemies (soi_enemies.c) ---- */
int16_t  soi_enemy_points(SoiEnemyType t);
int      soi_enemy_spawn(SoiWorld *w, SoiEnemyType t, int col, int row);
void     soi_creeper_init(SoiWorld *w, int idx);   /* solidify + arm a Creeper segment (FUN_10008618 init) */
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
