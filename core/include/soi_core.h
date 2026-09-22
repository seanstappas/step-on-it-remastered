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
#define SOI_MAX_PLAYERS   4     /* slots 0(reserved),1(P1),2(P2),3(P3 = remaster co-op) */
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
    SOI_IN_ARROW      = 1u << 5,  /* fire the Magic Arrow (straight; key slot 5 -> latch +0x24) */
    SOI_IN_BALL       = 1u << 6   /* fire the Magic Ball (rolls along walls; slot 6 -> +0x23) */

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
    SOI_SFX_HURRY,        /* low-bonus warning as the timer passes 1000 (asm FUN_10018b24 -> evt 0x2d) */
    SOI_SFX_WALKER_FIRE,  /* Walker bolt throw (asm event 0x13 -> snd 2689 "Strings") */
    SOI_SFX_SWITCH,       /* Stop/Go switch flip (asm FUN_10016544 -> FUN_1002b020 evt 0x2c) */
    SOI_SFX_BEANIE_BUD,   /* Beanie shoots its block-breaking bud (asm FUN_10006d44/6f6c evt 0x12 -> snd 2937) */
    SOI_SFX_COUNT
} SoiSfx;

#define SOI_SFX_QUEUE_MAX 32   /* per-tick sound-event capacity */
#define SOI_DEATH_QUEUE_MAX 32 /* per-tick enemy-death effect capacity (== SOI_MAX_ENEMIES) */

/* Opaque world state. Allocate soi_world_size() bytes; the core never mallocs. */
typedef struct SoiWorld SoiWorld;

/* ---- lifecycle ---- */
size_t soi_world_size(void);
void   soi_world_init(SoiWorld *w, uint32_t seed);
void   soi_set_seed(SoiWorld *w, uint32_t seed);

/* Load a level from a raw big-endian BORD resource (docs BORD §). Returns 1 on
 * success, 0 on malformed input. Populates the grid + level parameters. */
int    soi_load_level(SoiWorld *w, const uint8_t *bord, size_t len);

/* Load the NEXT board while PRESERVING the persistent per-player stats (score, lives,
 * arrows, balls, shield -- reset only at new-game, FUN_1002b060) and continuing the RNG
 * stream. Everything else resets per board exactly as a fresh load (mult=1, positions,
 * has_key, grid, enemies -- the per-level reset FUN_1002b174). Use for board->board
 * transitions; use soi_world_init + soi_load_level for a NEW game. */
int    soi_next_level(SoiWorld *w, const uint8_t *bord, size_t len);

/* Overwrite a player's PERSISTENT stats (Resume restores a saved board-start game). */
void   soi_set_player_stats(SoiWorld *w, int idx, int score, int lives, int arrows, int balls, int shield);

/* Play modes, numbered as the original's mode selector (asm FUN_100263d8). */
enum { SOI_MODE_ONE = 1, SOI_MODE_ALTERNATE = 2, SOI_MODE_COOPERATE = 3, SOI_MODE_COMPETE = 4 };
/* Select the play mode. COOPERATE pools every player's score/lives/ammo/multiplier/Bonus
 * in player 1's slot (asm DAT_100370e4 == 0); in every mode but COMPETE a collected key
 * is shared by all players. Survives soi_next_level and the death-reload; soi_world_init
 * resets it to SOI_MODE_ONE. */
void   soi_set_play_mode(SoiWorld *w, int mode);
int    soi_play_mode(const SoiWorld *w);
/* Set the mode and apply the NEW-GAME stats (asm FUN_1002b060): every player starts with
 * score 0, 2 lives, 1 arrow, 1 ball; COOPERATE instead gives the shared pool 4/2/2. */
void   soi_new_game(SoiWorld *w, int mode);

/* CHALLENGE ROUND (asm FUN_10017a70 / FUN_10016c90 / FUN_10016f80): a board holding a Knight or
 * Gargoyle (every 10th campaign board). A death there costs NO life -- the round simply fails
 * (the caller restores the board-start stats and moves on to the next board); an exit pays the
 * Bonus x mult with no No-Weapons Reward. soi_challenge_failed = every active player is down. */
int    soi_challenge_round(const SoiWorld *w);
int    soi_challenge_failed(const SoiWorld *w);

/* Advance one logic frame with the two players' input bitmasks. */
void   soi_tick(SoiWorld *w, uint8_t p1_input, uint8_t p2_input);
/* Same, with a THIRD input channel for the remaster's 3rd co-op player (slot 3). */
void   soi_tick3(SoiWorld *w, uint8_t p1_input, uint8_t p2_input, uint8_t p3_input);
/* Remaster: activate the 3rd co-op player (BORD has no 3rd spawn; P1-derived). Call
 * after soi_load_level when 3 players are in the game. */
void   soi_spawn_player3(SoiWorld *w);

/* Deactivate every player with index > n (the BORD header always spawns P1+P2, so a
 * 1-player game must turn P2 off). n=1 keeps only P1; n>=3 leaves all active. */
void   soi_limit_players(SoiWorld *w, int n);

/* ---- read-only state accessors (player index 1 = P1, 2 = P2) ---- */
int32_t  soi_player_score(const SoiWorld *w, int player);
int      soi_player_lives(const SoiWorld *w, int player);
int      soi_player_mult(const SoiWorld *w, int player);  /* score multiplier (1..5) */
int      soi_player_no_weapons_reward(const SoiWorld *w, int player);  /* BORD 0x16, 5000 unless a weapon was fired */
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
int      soi_player_state(const SoiWorld *w, int player);   /* ground_state: 0 idle,1 run,2 jump,3 fall,4 head-bonk recoil,0xC dead */
int      soi_player_movectr(const SoiWorld *w, int player); /* 0..6 run-step animation counter */
int      soi_player_pose(const SoiWorld *w, int player);    /* action pose (display): 0 none, 1 fire, 2 build */
int      soi_player_pose_t(const SoiWorld *w, int player);  /* action-pose countdown (frames) */
int      soi_goodies_total(const SoiWorld *w);   /* treasure at level load */
int      soi_goodies_left(const SoiWorld *w);    /* treasure still uncollected */
int      soi_count_treasure(const SoiWorld *w);  /* treasure cells now in the grid (objective count) */
int      soi_reveal_timer(const SoiWorld *w);    /* magnifying-glass reveal (goody 0x2F); >0 = hidden treasures shown */
int      soi_bonus_time(const SoiWorld *w);
int      soi_player_bonus(const SoiWorld *w, int player);   /* that player's own Bonus (Compete HUD row 2) */
int      soi_music_hurry(const SoiWorld *w);     /* 1 if ANY in-play player is in the low-bonus "hurry" zone (shared 1.25x music) */
uint32_t soi_tick_count(const SoiWorld *w);
uint32_t soi_grid_cell(const SoiWorld *w, int col, int row);
int      soi_enemy_count(const SoiWorld *w);
int      soi_projectile_count(const SoiWorld *w);

/* ---- sound events queued during the last soi_tick (drain each frame) ---- */
int      soi_sfx_count(const SoiWorld *w);
int      soi_sfx_get(const SoiWorld *w, int i);   /* SoiSfx id, or 0 if OOB */

/* ---- enemy-death effects queued during the last soi_tick (drain each frame) ----
 *      Every enemy KILL (weapon, fall-death, Shoes claim) enqueues one entry so the
 *      renderer can play the cosmetic death "pop" (the asm FUN_10028014 flying sprite
 *      that pops up and arcs off). A transient child that despawns on lifespan does
 *      NOT enqueue (the asm erases it without a death effect). NOT serialized/hashed. */
int      soi_death_count(const SoiWorld *w);
int      soi_death_x(const SoiWorld *w, int i);   /* pixel x at death, or 0 if OOB */
int      soi_death_y(const SoiWorld *w, int i);   /* pixel y at death, or 0 if OOB */
int      soi_death_type(const SoiWorld *w, int i);/* SoiEnemyType, or 0 if OOB */
int      soi_death_dir(const SoiWorld *w, int i); /* 1 = left, 2 = right, or 0 if OOB */

/* ---- per-entity read accessors (index into the fixed pools; for rendering).
 *      soi_*_active returns 0 for an empty slot; the other fields are then
 *      meaningless. Positions are screen pixels. ---- */
int      soi_enemy_active(const SoiWorld *w, int i);
int      soi_enemy_type(const SoiWorld *w, int i);
int      soi_enemy_x(const SoiWorld *w, int i);
int      soi_enemy_y(const SoiWorld *w, int i);
int      soi_enemy_dir(const SoiWorld *w, int i);
int      soi_enemy_fire_cd(const SoiWorld *w, int i);   /* reload counter; small = about to fire */
int      soi_enemy_turn(const SoiWorld *w, int i);      /* AI steps left in a turn-around (0 = walking) */
int      soi_enemy_bud(const SoiWorld *w, int i);       /* Beanie bud progress (0 = none) */
int      soi_enemy_vertical(const SoiWorld *w, int i);  /* 1 = vertical Beanie (bord 8) */
int      soi_enemy_anim(const SoiWorld *w, int i);      /* asm +0x56 spin frame (Wheelie 1-24, Spinner 1-16) */
int      soi_enemy_is_spawner(const SoiWorld *w, int i);/* 1 = persistent stationary spawner (draws as a spawn block, not a nasty) */
int      soi_projectile_active(const SoiWorld *w, int i);
int      soi_projectile_x(const SoiWorld *w, int i);
int      soi_projectile_y(const SoiWorld *w, int i);
int      soi_projectile_hostile(const SoiWorld *w, int i);
int      soi_projectile_kind(const SoiWorld *w, int i);   /* 0 = rolling Magic Ball, 1 = straight Magic Arrow */
int      soi_projectile_src_type(const SoiWorld *w, int i);   /* hostile shot's shooter type (0 = player) */
int      soi_projectile_pierce(const SoiWorld *w, int i);     /* 1 = block-piercing Gargoyle puff */
int      soi_projectile_fired_left(const SoiWorld *w, int i); /* kind 0 rolling ball fired left (asm type 3) */

/* ---- determinism (MASTER_PLAN §5.5): canonical little-endian serialize +
 *      FNV-1a 64-bit hash over the logical state. ---- */
size_t   soi_serialize(const SoiWorld *w, uint8_t *out, size_t cap);
uint64_t soi_state_hash(const SoiWorld *w);

#ifdef __cplusplus
}
#endif
#endif /* SOI_CORE_H */
