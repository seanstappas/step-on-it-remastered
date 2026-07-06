/* soi_core.h — public C ABI for the "Step On It!" reimplemented core.
 *
 * Freestanding, deterministic, integer-only game core (the faithful engine).
 * Everything here is reimplemented from the reverse-engineering notes in
 * docs/original_game/ (NOT compiled from decompiled code). Values marked
 * TODO(oracle) are first-draft and pending tick-trace confirmation against the
 * emulator (MASTER_PLAN §6).
 *
 * The core owns no OS/allocator/UI dependencies: the caller provides storage
 * (soi_world_size) and drives it one tick at a time with a per-player input
 * bitmask. Rendering, audio, netcode and UI live in the wrapper on top.
 */
#ifndef SOI_CORE_H
#define SOI_CORE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ---- canonical constants (from the RE, docs/original_game) ---- */
#define SOI_MAX_PLAYERS   3     /* slots 0(reserved),1(P1),2(P2) — §runtime-structures */
#define SOI_MAX_ENEMIES   32    /* enemy entity pool (original array is fixed-size) */
#define SOI_MAX_PROJECTILES 8   /* fired Magic Arrows in flight (pool) */
#define SOI_GRID_COLS     19    /* playable columns (X, 0x13 loop bound) */
#define SOI_GRID_ROWS     13    /* playable rows   (Y, 0x0d loop bound) */
#define SOI_CELL_PX       32    /* cell size, CONFIRMED (FUN_1002e6ac/bc) */
#define SOI_ORIGIN_X      16    /* x = col*32 + 16 */
#define SOI_ORIGIN_Y      48    /* y = row*32 + 48 */
#define SOI_SCREEN_W      640
#define SOI_SCREEN_H      480
#define SOI_MOVE_FRAMES   7     /* grid-step animation length (counter 0..6) */

/* Per-player input bitmask (per tick) — the 7 real actions from the game's
 * "Configure Keys" screen (CONFIRMED). Step On It! is a run-and-jump platformer:
 * there is NO up/down walk. */
enum {
    SOI_IN_LEFT       = 1u << 0,  /* run left */
    SOI_IN_RIGHT      = 1u << 1,  /* run right */
    SOI_IN_JUMP       = 1u << 2,  /* jump (breaks the block above) */
    SOI_IN_BLOCK_HIGH = 1u << 3,  /* switch the block above the head */
    SOI_IN_BLOCK_LOW  = 1u << 4,  /* switch the block at the feet */
    SOI_IN_ARROW      = 1u << 5,  /* fire a Magic Arrow */
    SOI_IN_BALL       = 1u << 6   /* fire a Magic Ball */

};

/* Bestiary (index doubles as the enemy type id). Point values are CONFIRMED. */
typedef enum {
    SOI_ENEMY_NONE = 0,
    SOI_ENEMY_ANT,      /*   50 */
    SOI_ENEMY_OSTRICH,  /*  100 */
    SOI_ENEMY_HIPPO,    /*  200 */
    SOI_ENEMY_PIGGY,    /*  250 */
    SOI_ENEMY_WHEELIE,  /*  300 */
    SOI_ENEMY_SMILEY,   /*  400 */
    SOI_ENEMY_HAMMER,   /*  500 */
    SOI_ENEMY_BEANIE,   /*  750 */
    SOI_ENEMY_ROBO,     /* 1000 */
    SOI_ENEMY_WALKER,   /* 1250 */
    SOI_ENEMY_TEETH,    /* 1500 */
    /* Extended roster: Cannon+Spinner complete the 13-creature in-game Help
     * roster; Gargoyle+Knight are the two extra sprite sets. Points TODO(oracle). */
    SOI_ENEMY_CANNON,
    SOI_ENEMY_SPINNER,
    SOI_ENEMY_GARGOYLE,
    SOI_ENEMY_KNIGHT,
    /* Creeper (bord types 16 & 17): a self-propelled "bigger mblock" (sssf 1016)
     * that walks the grid one cell at a time laying/solidifying blocks -- 16 =
     * horizontal (asm FUN_10008618), 17 = vertical (asm FUN_10008b18). NOT a
     * projectile shooter (our earlier map mislabelled these as Gargoyle/Knight). */
    SOI_ENEMY_CREEPER,
    SOI_ENEMY_TYPE_COUNT
} SoiEnemyType;

/* Abstract sound-effect events emitted by the core each tick (presentational
 * side-channel; NOT part of the hashed logical state). The front-end maps these
 * to the extracted `snd ` WAVs. The concrete snd id per event is TODO(oracle). */
typedef enum {
    SOI_SFX_NONE = 0,
    SOI_SFX_BLOCK_CREATE,
    SOI_SFX_BLOCK_DESTROY,
    SOI_SFX_COIN,
    SOI_SFX_ENEMY_KILL,
    SOI_SFX_PLAYER_HIT,
    SOI_SFX_JUMP,         /* reserved/unused: the jump launch is silent in the original */
    SOI_SFX_FIRE,
    SOI_SFX_TELEPORT,
    SOI_SFX_POWERUP,
    SOI_SFX_THUNDER,
    SOI_SFX_COIN_GOLD,    /* gold coin 0x17 (asm event 0x1c) */
    SOI_SFX_COIN_GEM,     /* gem 0x18       (asm event 0x1d) */
    SOI_SFX_COIN_BARS,    /* gold bars 0x19 (asm event 0x1e) */
    SOI_SFX_BALL,         /* Magic Ball fire (asm event 1 "Whip"; distinct from the arrow) */
    /* Per-source sounds recovered from the binary event->snd table (DAT_10037074). */
    SOI_SFX_CANNON_FIRE,  /* Cannon fire  (asm event 0x10 -> snd 12863 "Flens") */
    SOI_SFX_KILL_WHEELIE, /* Wheelie kill (asm event 0x0b -> 4704  "Gabing") */
    SOI_SFX_KILL_HAMMER,  /* Hammer kill  (asm event 0x05 -> 2224  "hammer") */
    SOI_SFX_KILL_BEANIE,  /* Beanie kill  (asm event 0x07 -> 25564 "knock") */
    SOI_SFX_KILL_ROBO,    /* Robo kill    (asm event 0x0a -> 18366 "Bell") */
    SOI_SFX_KILL_WALKER,  /* Walker kill  (asm event 0x0c -> 30612 "metal crash") */
    SOI_SFX_KILL_ANT,     /* Ant kill     (asm event 0x0e -> 1769  "Cow bell") */
    SOI_SFX_KILL_OSTRICH, /* Ostrich kill (asm event 0x0f -> 1628  "bike horn") */
    SOI_SFX_KILL_HIPPO,   /* Hippo kill   (asm event 0x09 -> 18221 "Moof") */
    SOI_SFX_KILL_PIGGY,   /* Piggy kill   (asm event 0x0d -> 400   "Train whistle") */
    SOI_SFX_KILL_SMILEY,  /* Smiley kill  (asm event 0x06 -> 404   "Baby seagull") */
    SOI_SFX_KILL_TEETH,   /* Teeth kill   (asm event 0x08 -> 32129 "Honk") */
    SOI_SFX_BLOCK_CRACK,  /* head-bonk 1st hit -> crack (asm event 0x23 -> 13478) */
    SOI_SFX_BLOCK_BREAK,  /* head-bonk 2nd hit -> break (asm event 0x24 -> 29940 "Smack") */
    SOI_SFX_ROBO_PUNCH,   /* Robo smashes a breakable block (asm event 0x11 -> 15960 "Metal") */
    SOI_SFX_CLOCK,        /* Clock goody: slow every nasty (asm event 0x2B -> 1005 "slow") */
    SOI_SFX_PICKUP_BALL,  /* Magic Ball ammo goody 0x12  (asm event 0x1a -> 24336 "slide whistle") */
    SOI_SFX_PICKUP_ARROW, /* Magic Arrow ammo goody 0x11 (asm event 0x19 -> 3001  "rooster") */
    SOI_SFX_PICKUP_SHIELD,/* shield pickup goody 0x10    (asm event 0x18 -> 31429 "oh la la") */
    SOI_SFX_PICKUP_TIME,  /* time bonus x1-4  (asm event 0x1b -> 7119  "space balls") */
    SOI_SFX_SHOES,        /* speed-shoes goody 0x32 (asm event 0x28 -> 1002 "zap"; 2x speed, NOT a 1UP) */
    SOI_SFX_SHIELD_ON,    /* shield-activate goody 0x30 (asm event 0x29 -> 1003 "gong") */
    SOI_SFX_WHISTLE,      /* enemy-claim goody 0x31 (asm event 0x2a -> 1004 "whistle") */
    SOI_SFX_KEY,          /* colored-key collect (asm event 0x14 -> 17661 "Announce") */
    SOI_SFX_COUNT
} SoiSfx;

#define SOI_SFX_QUEUE_MAX 32   /* per-tick sound-event capacity */

/* Opaque world state. Allocate soi_world_size() bytes; the core never mallocs. */
typedef struct SoiWorld SoiWorld;

/* ---- lifecycle ---- */
size_t soi_world_size(void);
void   soi_world_init(SoiWorld *w, uint32_t seed);
void   soi_set_seed(SoiWorld *w, uint32_t seed);

/* Load a level from a raw big-endian BORD resource (docs BORD §). Returns 1 on
 * success, 0 on malformed input. Populates the grid + level parameters. */
int    soi_load_level(SoiWorld *w, const uint8_t *bord, size_t len);

/* Advance one logic frame with the two players' input bitmasks. */
void   soi_tick(SoiWorld *w, uint8_t p1_input, uint8_t p2_input);

/* ---- read-only state accessors (player index 1 = P1, 2 = P2) ---- */
int32_t  soi_player_score(const SoiWorld *w, int player);
int      soi_player_lives(const SoiWorld *w, int player);
int      soi_player_alive(const SoiWorld *w, int player);
int      soi_game_over(const SoiWorld *w);   /* 1 = all active players eliminated */
int      soi_level_complete(const SoiWorld *w); /* 1 = a player exited the door with the key */
int      soi_player_x(const SoiWorld *w, int player);
int      soi_player_y(const SoiWorld *w, int player);
int      soi_player_arrows(const SoiWorld *w, int player);
int      soi_player_balls(const SoiWorld *w, int player);
int      soi_player_shield(const SoiWorld *w, int player);
int      soi_player_facing(const SoiWorld *w, int player);
int      soi_player_invuln(const SoiWorld *w, int player);  /* >0 = flashing/invulnerable */
int      soi_player_fast(const SoiWorld *w, int player);    /* >0 = speed-shoes (goody 0x32) active */
int      soi_player_has_key(const SoiWorld *w, int player); /* 0 none, 1 carrying, 2 exited */
int      soi_player_state(const SoiWorld *w, int player);   /* ground_state: 0 idle,1 run,2 jump,3 fall,0xC dead */
int      soi_player_movectr(const SoiWorld *w, int player); /* 0..6 run-step animation counter */
int      soi_player_pose(const SoiWorld *w, int player);    /* action pose (display): 0 none, 1 fire, 2 build */
int      soi_player_pose_t(const SoiWorld *w, int player);  /* action-pose countdown (frames) */
int      soi_goodies_total(const SoiWorld *w);   /* treasure at level load */
int      soi_goodies_left(const SoiWorld *w);    /* treasure still uncollected */
int      soi_count_treasure(const SoiWorld *w);  /* treasure cells now in the grid (objective count) */
int      soi_bonus_time(const SoiWorld *w);
uint32_t soi_tick_count(const SoiWorld *w);
uint32_t soi_grid_cell(const SoiWorld *w, int col, int row);
int      soi_enemy_count(const SoiWorld *w);
int      soi_projectile_count(const SoiWorld *w);

/* ---- sound events queued during the last soi_tick (drain each frame) ---- */
int      soi_sfx_count(const SoiWorld *w);
int      soi_sfx_get(const SoiWorld *w, int i);   /* SoiSfx id, or 0 if OOB */

/* ---- per-entity read accessors (index into the fixed pools; for rendering).
 *      soi_*_active returns 0 for an empty slot; the other fields are then
 *      meaningless. Positions are screen pixels. ---- */
int      soi_enemy_active(const SoiWorld *w, int i);
int      soi_enemy_type(const SoiWorld *w, int i);
int      soi_enemy_x(const SoiWorld *w, int i);
int      soi_enemy_y(const SoiWorld *w, int i);
int      soi_enemy_dir(const SoiWorld *w, int i);
int      soi_enemy_fire_cd(const SoiWorld *w, int i);   /* reload counter; small = about to fire */
int      soi_projectile_active(const SoiWorld *w, int i);
int      soi_projectile_x(const SoiWorld *w, int i);
int      soi_projectile_y(const SoiWorld *w, int i);
int      soi_projectile_hostile(const SoiWorld *w, int i);
int      soi_projectile_kind(const SoiWorld *w, int i);   /* 0 = Magic Arrow, 1 = Magic Ball */
int      soi_projectile_src_type(const SoiWorld *w, int i);   /* hostile shot's shooter type (0 = player) */

/* ---- determinism (MASTER_PLAN §5.5): canonical little-endian serialize +
 *      FNV-1a 64-bit hash over the logical state. ---- */
size_t   soi_serialize(const SoiWorld *w, uint8_t *out, size_t cap);
uint64_t soi_state_hash(const SoiWorld *w);

#ifdef __cplusplus
}
#endif
#endif /* SOI_CORE_H */
