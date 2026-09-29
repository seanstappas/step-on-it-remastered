/* soi_enemies.c — enemy entities: the bestiary point table (partly CONFIRMED — see
 * soi_enemy_points), spawn,
 * a walk-and-turn update (the CONFIRMED baseline for the simple types), and
 * kill->score. Per-type AI is ported and asm-verified: Hammer jump-smash
 * (FUN_10007998), Beanie block-breaking bud (FUN_10006378/6840), Robo/Walker
 * multi-state incl. edge-turner fall-death (FUN_1000a780/FUN_1000dd4c), and
 * Wheelie 8-dir wall-follow (FUN_10009e98, player-INDEPENDENT — no seek).
 * Remaining gaps are cosmetic/tuning only (see plan/REMAINING_WORK.md §C/§D2).
 * (docs runtime-structures §3/§11.)
 */
#include "soi_internal.h"

static int enemy_speed(int type);   /* per-type base speed (defined below) */
static int enemy_period(int type);  /* frames per AI step (defined below) */
static uint32_t cell_at_px(const SoiWorld *w, int px, int py, int *col, int *row);
static int cell_breakable(uint32_t c);
static void enemy_turn_around(SoiEnemy *e);
static void turret_anim(SoiEnemy *e);

/* Fallback cadence (frames) for a Cannon/spawner placed WITHOUT a per-block delay
 * byte (procedural/test spawns). Boards carry a SpawnDelay byte that the loader
 * (soi_state.c) turns into e->fire_period = SpawnDelay*6 -- the asm FUN_100071a0
 * reload -- which every shooter/spawner below prefers over this constant. So this
 * only applies when fire_period == 0 (no board byte). */
#define SOI_CANNON_RELOAD 120

/* Cannon/Spinner/Knight/Gargoyle and the block-laying Creeper are HAZARDS, not
 * scorable nasties. KILL/AWARD MECHANISM (asm): a weapon (FUN_1000fd5c) or a
 * thunderball claim (FUN_1000543c) writes the victim's +0x40 = the responsible
 * player; the NASTY's OWN update then reads `if (0 < +0x40)`, adds its +0x42 to that
 * player's score (+0x3c) and dies (FUN_1000602c/100093a0/... each inline this). These
 * five hazard types NEVER read +0x40 (grep-confirmed across the decomp) -- no self-
 * award/death path -- so the original CANNOT kill them; they are permanent. The in-
 * game Help "nasties and their values" screen agrees: 13 rows = the 11 scorable
 * nasties + Cannon/Spinner as "-" (Knight/Gargoyle are not even listed). Keep them out
 * of the player's kill paths (enemy_is_hazard) and award nothing. */
static int enemy_is_hazard(int type)
{
    return type == SOI_ENEMY_CANNON || type == SOI_ENEMY_SPINNER ||
           type == SOI_ENEMY_KNIGHT || type == SOI_ENEMY_GARGOYLE ||
           type == SOI_ENEMY_CREEPER;
}

int16_t soi_enemy_points(SoiEnemyType t)
{
    /* Enemy score = struct field +0x42, self-written by each nasty's init
     * (li rN,VAL; sth rN,0x42(r31)) and awarded by its own update (+0x42 -> player
     * +0x3c) when marked. All 11 scorable values match the in-game Help roster. */
    switch (t) {
        case SOI_ENEMY_ANT:     return 50;     /* CONFIRMED: Help=50; FUN_1000602c self-writes 0x32 & self-awards (+0x40 gate) */
        case SOI_ENEMY_OSTRICH: return 100;    /* CONFIRMED: FUN_100093a0 (emitted 0x76) self-writes 0x64 @1000945c */
        case SOI_ENEMY_HIPPO:   return 200;    /* CONFIRMED: FUN_100081f8 (emitted 0x69) self-writes 0xc8 @100082a8 */
        case SOI_ENEMY_PIGGY:   return 250;    /* CONFIRMED: FUN_10009a78 (emitted 0x77) self-writes 0xfa @10009b28 */
        case SOI_ENEMY_WHEELIE: return 300;    /* CONFIRMED: FUN_10009e98 self-writes 0x12c @10009f24 */
        case SOI_ENEMY_SMILEY:  return 400;    /* CONFIRMED: FUN_1000d130 (emitted 0x6f) self-writes 0x190 @1000d194 */
        case SOI_ENEMY_HAMMER:  return 500;    /* CONFIRMED: FUN_10007998 self-writes 0x1f4 @10007a4c */
        case SOI_ENEMY_BEANIE:  return 750;    /* CONFIRMED: FUN_10006378/FUN_10006840 (bord 7/8) self-write 0x2ee */
        case SOI_ENEMY_ROBO:    return 1000;   /* CONFIRMED: FUN_1000a780 self-writes 0x3e8 @1000a84c */
        case SOI_ENEMY_WALKER:  return 1250;   /* CONFIRMED: FUN_1000dd4c (bord 4) self-writes 0x4e2 (+0x42) */
        case SOI_ENEMY_TEETH:   return 1500;   /* CONFIRMED: FUN_1000d8c4 (emitted 0x6e = idx10+0x64) self-writes 0x5dc */
        /* --- HAZARDS: unkillable, award nothing (see enemy_is_hazard). Help lists Cannon/Spinner as "-". --- */
        case SOI_ENEMY_CANNON:  return 0;      /* hazard (type 1 FUN_100071a0): no +0x42 write, never reads +0x40. (Was a mislabeled 1000.) */
        case SOI_ENEMY_SPINNER: return 0;      /* hazard (type 9 FUN_1000d490): no +0x42 write, never reads +0x40. */
        case SOI_ENEMY_GARGOYLE:return 0;      /* hazard (type 14 FUN_1000adc4): writes VESTIGIAL +0x42=1000 @1000ae98 but never reads +0x40. */
        case SOI_ENEMY_KNIGHT:  return 0;      /* hazard (type 13 FUN_1000c2e8): writes VESTIGIAL +0x42=1000 @1000c3bc but never reads +0x40. */
        case SOI_ENEMY_CREEPER: return 0;      /* hazard (solid block FUN_10008618/8b18): +0x42 defaults to type byte; never reads +0x40. */
        default:                return 0;
    }
}

/* Map a BORD spawn-block badguy type to our bestiary enum. The original's placed-
 * enemy per-frame dispatcher (asm FUN_1000503c) switches on the spawn block's low
 * byte (1-19). Several indices are stationary SPAWNERS that emit a base nasty
 * (struct type = index+0x64); we map them to the nasty they emit (a simplification
 * -- the real spawner keeps emitting). CONFIRMED: 2=Wheelie, 4=Walker, 7/8=Beanie,
 * 15=Robo. Spawners: 5->Hippo,6->Hammer,10->Teeth,11->Smiley,12->Ant,18->Ostrich,
 * 19->Piggy. Shooters: 1=Cannon, 13=Knight (FUN_1000c2e8 fires 0x71), 14=Gargoyle
 * (FUN_1000adc4 fires 0x72/0xc8), 9=Spinner. Creepers (sssf 1016 'bigger mblock'):
 * 16=horizontal, 17=vertical (asm FUN_10008618/8b18 -- block-layers, NOT shooters).
 * Enemy type -> sprite is sssf id 1000+type (loader FUN_10017b68 -> FUN_10017cd8);
 * CONFIRMED via rezfork. TODO(oracle): a few points/behaviours still first-draft. */
SoiEnemyType soi_bord_badguy_type(uint8_t bord_type)
{
    static const uint8_t map[20] = {
        SOI_ENEMY_NONE,      /*  0 */
        SOI_ENEMY_CANNON,    /*  1  shooter (FUN_100071a0 fires 0x65) */
        SOI_ENEMY_WHEELIE,   /*  2  CONFIRMED */
        SOI_ENEMY_WHEELIE,   /*  3  same handler as 2 */
        SOI_ENEMY_WALKER,    /*  4  CONFIRMED */
        SOI_ENEMY_HIPPO,     /*  5  spawner -> Hippo (0x69) */
        SOI_ENEMY_HAMMER,    /*  6  spawner -> Hammer (0x6a) */
        SOI_ENEMY_BEANIE,    /*  7  CONFIRMED */
        SOI_ENEMY_BEANIE,    /*  8  CONFIRMED (child) */
        SOI_ENEMY_SPINNER,   /*  9  mobile hazard (FUN_1000d490) */
        SOI_ENEMY_TEETH,     /* 10  spawner -> Teeth (0x6e) */
        SOI_ENEMY_SMILEY,    /* 11  spawner -> Smiley (0x6f) */
        SOI_ENEMY_ANT,       /* 12  spawner -> Ant (0x70) */
        SOI_ENEMY_KNIGHT,    /* 13  Knight shooter (asm FUN_1000c2e8 fires 0x71; sssf 1013) */
        SOI_ENEMY_GARGOYLE,  /* 14  Gargoyle shooter (asm FUN_1000adc4 fires 0x72/0xc8; sssf 1014) */
        SOI_ENEMY_ROBO,      /* 15  CONFIRMED (sssf 1015) */
        SOI_ENEMY_CREEPER,   /* 16  block-laying creeper, HORIZONTAL (asm FUN_10008618; sssf 1016) */
        SOI_ENEMY_CREEPER,   /* 17  block-laying creeper, VERTICAL   (asm FUN_10008b18; sssf 1016) */
        SOI_ENEMY_OSTRICH,   /* 18  spawner -> Ostrich (0x76) */
        SOI_ENEMY_PIGGY,     /* 19  spawner -> Piggy (0x77) */
    };
    return (bord_type < 20) ? (SoiEnemyType)map[bord_type] : SOI_ENEMY_ANT;
}

/* Placement types that are STATIONARY PERSISTENT SPAWNERS (emit their base nasty
 * over time) rather than directly-placed nasties. CONFIRMED from the per-frame
 * dispatchers (FUN_10007efc/100076a8/1000d5d4/1000ce34/10005d30/100090a4/10009778
 * -- each spawns a child of type placement+0x64 on a StartDelay*6 timer). */
int soi_bord_is_spawner(uint8_t bord_type)
{
    switch (bord_type) {
        case 5: case 6: case 10: case 11: case 12: case 18: case 19: return 1;
        default: return 0;
    }
}

int soi_enemy_spawn(SoiWorld *w, SoiEnemyType t, int col, int row)
{
    int i;
    if (t <= SOI_ENEMY_NONE || t >= SOI_ENEMY_TYPE_COUNT) return -1;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        SoiEnemy *e = &w->enemies[i];
        if (e->active) continue;
        e->active = 1;
        e->type   = (uint8_t)t;
        e->x      = soi_cell_x(col);
        e->y      = soi_cell_y(row);
        e->dir    = 2;                 /* start moving right (caller may override) */
        e->state  = 1;
        e->vx     = (int16_t)enemy_speed((int)t);   /* per-type base speed */
        e->vy     = 0;
        e->points = soi_enemy_points(t);
        e->owner  = 0;
        e->claimed = 0;
        e->fire_cd = (t == SOI_ENEMY_CANNON || t == SOI_ENEMY_GARGOYLE || t == SOI_ENEMY_KNIGHT)
                         ? SOI_CANNON_RELOAD : 0;
        e->fire_period = (t == SOI_ENEMY_CANNON || t == SOI_ENEMY_GARGOYLE || t == SOI_ENEMY_KNIGHT)
                         ? SOI_CANNON_RELOAD : 0;
        e->spawn_child = 0;
        e->life = 0;
        e->child = 0;
        e->under = 0;
        e->anim   = 0;
        e->period = (uint8_t)enemy_period((int)t);
        e->stepc  = (uint8_t)(e->period - 1);   /* first update is a step frame (asm counters start expired) */
        e->turn   = 0;
        e->bud    = 0;
        if (t == SOI_ENEMY_WHEELIE) e->y += 2;   /* FUN_10009e98 init: +0x5a += 2 */
        return i;                      /* slot index so the caller can tweak dir/vx */
    }
    return -1;
}

void soi_enemy_kill(SoiWorld *w, int idx, int by_player)
{
    SoiEnemy *e;
    if (idx < 0 || idx >= SOI_MAX_ENEMIES) return;
    e = &w->enemies[idx];
    if (!e->active) return;
    if (by_player >= 0 && by_player < SOI_MAX_PLAYERS)
        soi_pool(w, by_player)->score += e->points;   /* award (+0x42 -> +0x3c); co-op -> pool */
    e->active = 0;
    /* Per-enemy kill sound: in the asm each nasty's behaviour plays its own event
     * on channel 5 (mapped via the child-type dispatch FUN_1000503c). Ids are from
     * the binary event->snd table; the four turret/hazard types have no kill sound. */
    {
        SoiSfx s = SOI_SFX_ENEMY_KILL;
        switch (e->type) {
            case SOI_ENEMY_ANT:     s = SOI_SFX_KILL_ANT;     break;
            case SOI_ENEMY_OSTRICH: s = SOI_SFX_KILL_OSTRICH; break;
            case SOI_ENEMY_HIPPO:   s = SOI_SFX_KILL_HIPPO;   break;
            case SOI_ENEMY_PIGGY:   s = SOI_SFX_KILL_PIGGY;   break;
            case SOI_ENEMY_WHEELIE: s = SOI_SFX_KILL_WHEELIE; break;
            case SOI_ENEMY_SMILEY:  s = SOI_SFX_KILL_SMILEY;  break;
            case SOI_ENEMY_HAMMER:  s = SOI_SFX_KILL_HAMMER;  break;
            case SOI_ENEMY_BEANIE:  s = SOI_SFX_KILL_BEANIE;  break;
            case SOI_ENEMY_ROBO:    s = SOI_SFX_KILL_ROBO;    break;
            case SOI_ENEMY_WALKER:  s = SOI_SFX_KILL_WALKER;  break;
            case SOI_ENEMY_TEETH:   s = SOI_SFX_KILL_TEETH;   break;
            default: break;
        }
        soi_sfx_emit(w, s);
    }
    /* Death "pop": the asm plays a flying death sprite on every kill (FUN_10028014 ->
     * FUN_100278bc: vy=-80 up-pop, vx=+40 drift, gravity 0.5/frame^2) that arcs up ~64px
     * and off the screen. It is cosmetic and rendered by the Godot layer, fed by this
     * transient per-tick queue. A lifespan despawn never reaches here, so it never pops
     * (matching the asm, which erases those without a death effect). Snapshot the dying
     * nasty's pixel pos + type + facing now, while they're still intact. */
    soi_death_emit(w, e->x, e->y, e->type, e->dir);
}

/* Damage a player: TIMED invuln (the 0x30 potion + ~90f respawn grace) blocks a hit;
 * otherwise the hit is FATAL -- launch the death-throw somersault (air_step commits the
 * life-loss + respawn). The ORIGINAL has NO shield-count hit-absorber: asm FUN_10012228
 * goes straight to the death/respawn state (only the already-dying flag gates it), and
 * the single survival counter +0x46 (the face-icon "lives") is decremented on every
 * death (VERIFIED 2026-07-06). The old 2-hit shield buffer was a PORT-ISM that made the
 * game easier; p->shield is now VESTIGIAL (kept only for save/ABI stability). */
void soi_player_hit(SoiWorld *w, int idx)
{
    SoiPlayer *p;
    if (idx < 0 || idx >= SOI_MAX_PLAYERS) return;
    p = &w->players[idx];
    if (!p->active || !p->alive || p->eliminated) return;
    if (p->ground_state == SOI_ST_DEAD) return; /* already mid death-throw */
    if (p->invuln > 0) return;                 /* still in post-hit grace / potion i-frames */
    /* Death throw (asm FUN_10012228): launch the airborne somersault instead of
     * vanishing on the spot. The parabola base is y-3 (a small upward kick), the
     * dying marker is ground_state=DEAD, and the death cry (26486) plays now, at
     * launch. air_step carries the arc off the bottom -- it never lands a dying
     * player -- and commits the life-loss + respawn when y reaches the death line
     * (asm FUN_10011fcc: y>=0x1be -> FUN_10004cb0). */
    p->in_air = 1;
    p->jump_t = 0;
    p->launch_y = (int16_t)(p->y - 3);
    p->ground_state = SOI_ST_DEAD;
    p->frame = 0x75; p->dstep = -1;            /* the arm flap (FUN_10012228: +0x0e = 0x75, +0x2e = -1) */
    soi_sfx_emit(w, SOI_SFX_PLAYER_HIT);
}

/* Index of an active enemy occupying grid cell (col,row), or -1. */
int soi_enemy_at(const SoiWorld *w, int col, int row)
{
    int i;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *e = &w->enemies[i];
        if (!e->active) continue;
        if ((e->x - SOI_ORIGIN_X) / SOI_CELL_PX == col &&
            (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX == row)
            return i;
    }
    return -1;
}

/* Advance one enemy: baseline horizontal walk-and-turn (CONFIRMED pattern), with
 * per-type speed. NOTE (verified 2026-07-06): NEITHER the Wheelie nor the Walker homes
 * on the player -- the Wheelie is a wall-bouncing FLYER (enemy_fly_bounce) and the Walker
 * PATROLS + shoots (enemy_walker_fire); the docs' "seek" label was a HYPOTHESIS that the
 * asm contradicts (FUN_10009e98/dd4c never read the player-position globals). Hammer-jump /
 * Beanie-split / Robo-punch are ported; exact tuning of several types remains TODO(oracle). */
static int enemy_speed(int type)
{
    switch (type) {
        case SOI_ENEMY_WALKER:  return 1;   /* FUN_1000dd4c: +/-1 px per 3-frame step */
        case SOI_ENEMY_CANNON:
        case SOI_ENEMY_SPINNER:
        case SOI_ENEMY_GARGOYLE:  /* stationary shooter (asm FUN_1000adc4, bord 14) */
        case SOI_ENEMY_KNIGHT:    /* stationary shooter (asm FUN_1000c2e8, bord 13) */
        case SOI_ENEMY_CREEPER:   /* self-propelled; steps in enemy_creeper(), not via vx */
            return 0;    /* stationary hazards (spin/fire in place; never move their own pos) */
        default:                return 2;   /* +/-2 px per 2-frame step (FUN_1000602c &c) */
    }
}

/* Frames per AI step = the asm's +0x6c reload + 1: the walkers (Ant/Ostrich/Hippo/Piggy/
 * Smiley/Teeth/Hammer/Beanie/Robo/Spinner) reload 1 -> a step every 2nd frame; the Walker
 * reloads 2 (every 3rd); the Wheelie (type-2 variant), the turrets and the Creeper run their
 * own per-frame logic. Movement, falling (+4 px per step), lifespans and step-counted
 * animations all advance only on a step frame. */
static int enemy_period(int type)
{
    switch (type) {
        case SOI_ENEMY_WALKER:   return 3;
        case SOI_ENEMY_CREEPER:  return 3;   /* FUN_10008618: +0x6c reload 2 */
        case SOI_ENEMY_WHEELIE:
        case SOI_ENEMY_CANNON:
        case SOI_ENEMY_GARGOYLE:
        case SOI_ENEMY_KNIGHT:  return 1;
        default:                 return 2;
    }
}

/* Pixel-level solid probe (asm FUN_1000554c): does the cell under pixel (px,py) carry
 * the SUPPORTIVE bit (0x200)? Off the field reads as solid (soi_get_cell -> SOI_WALL) so
 * the flyer turns at the border. The asm's col/row converters (FUN_1002e6cc/6f8) number
 * columns one higher than the port's zero-based grid, but that +1 cancels against the
 * port's grid origin (both resolve the SAME physical cell for a given pixel), so the
 * asm's pixel probe offsets below transfer verbatim. */
static int wheelie_solid(const SoiWorld *w, int px, int py)
{
    int cx = px - SOI_ORIGIN_X, cy = py - SOI_ORIGIN_Y;
    int col = (cx >= 0) ? cx / SOI_CELL_PX : -1;
    int row = (cy >= 0) ? cy / SOI_CELL_PX : -1;
    return (soi_get_cell(w, col, row) & SOI_CELL_SUPPORTIVE) != 0;
}

/* The Wheelie (bord 2/3, asm FUN_10009e98) is a gravity-free FLYER that WALL-FOLLOWS:
 * it rolls in one cardinal heading (dir 1=left, 2=right, 8=up, 9=down) and, probing its
 * leading edge plus the trailing corner every step, either advances or TURNS 90 deg to
 * hug the wall -- so it rounds obstacle perimeters rather than bouncing off. VERIFIED
 * 2026-07-06: FUN_10009e98 never reads the player-position globals (0x3be0-6): it is
 * player-INDEPENDENT (no homing). Turn HANDEDNESS (asm mode +0x6e) is LOCKED once to the
 * spawn heading (asm sets +0x6e = initial +0x4c): a right-spawned wheelie follows walls
 * one way (mode 2), a left-spawned one mirrors it (mode 1) -- so a board's placement bits
 * (loader: 0x100 -> left) fan the flock out naturally. Speed is 2 px/step (the asm
 * bord-type-2 wheelie; the slower type-3 0.5 px variant is folded into this one type).
 * On a turn frame the asm only rewrites the heading (it advances next frame); we mirror
 * that, which paces the wall-hugging exactly. e->state caches the locked mode (1/2);
 * e->under is the once-only "mode initialised" sentinel (0 at spawn). The bord-type-3
 * variant steps 1 px every 2nd frame (period 2) instead of 2 px every frame. */
static void enemy_fly_bounce(SoiWorld *w, SoiEnemy *e)
{
    const int s = (e->period >= 2) ? 1 : 2;
    int mode;
    if (!e->under) {                       /* lock handedness after the loader picks dir */
        e->state = (uint8_t)((e->dir == 1 || e->dir == 8) ? 1 : 2);
        e->under = 1;
    }
    mode = e->state;
    /* +0x56 spin frame 1..0x18: forward by the step size in mode 2, backward in mode 1. */
    if (mode == 2) { e->anim = (uint16_t)(e->anim + s); if (e->anim > 0x18) e->anim = 1; }
    else if (e->anim <= (uint16_t)s) e->anim = 0x18;
    else e->anim = (uint16_t)(e->anim - s);

    if (mode == 2) {
        switch (e->dir) {
        case 1: /* LEFT */
            if (wheelie_solid(w, e->x - 1, e->y + 0x10)) { e->dir = 9; return; }
            if (!wheelie_solid(w, e->x + 0x1d, e->y - 1) &&
                !wheelie_solid(w, e->x - 1,    e->y - 1) &&
                 wheelie_solid(w, e->x + 0x1e, e->y - 1)) { e->dir = 8; return; }
            e->x -= s; break;
        case 8: /* UP */
            if (wheelie_solid(w, e->x + 0x10, e->y - 1)) { e->dir = 1; return; }
            if (!wheelie_solid(w, e->x + 0x1e, e->y + 0x1d) &&
                !wheelie_solid(w, e->x + 0x1e, e->y - 1) &&
                 wheelie_solid(w, e->x + 0x1e, e->y + 0x1e)) { e->dir = 2; return; }
            e->y -= s; break;
        case 2: /* RIGHT */
            if (wheelie_solid(w, e->x + 0x1e, e->y + 0x10)) { e->dir = 8; return; }
            if (!wheelie_solid(w, e->x,       e->y + 0x1e) &&
                !wheelie_solid(w, e->x + 0x1e, e->y + 0x1e) &&
                 wheelie_solid(w, e->x - 1,    e->y + 0x1e)) { e->dir = 9; return; }
            e->x += s; break;
        default: /* 9 DOWN */
            if (wheelie_solid(w, e->x + 0x10, e->y + 0x1e)) { e->dir = 2; return; }
            if (!wheelie_solid(w, e->x - 1, e->y) &&
                !wheelie_solid(w, e->x - 1, e->y + 0x1e) &&
                 wheelie_solid(w, e->x - 1, e->y - 1)) { e->dir = 1; return; }
            e->y += s; break;
        }
    } else {                                /* mode 1: the mirror handedness */
        switch (e->dir) {
        case 1: /* LEFT */
            if (wheelie_solid(w, e->x - 1, e->y + 0x10)) { e->dir = 8; return; }
            if (!wheelie_solid(w, e->x + 0x1d, e->y + 0x1e) &&
                !wheelie_solid(w, e->x - 1,    e->y + 0x1e) &&
                 wheelie_solid(w, e->x + 0x1e, e->y + 0x1e)) { e->dir = 9; return; }
            e->x -= s; break;
        case 8: /* UP */
            if (wheelie_solid(w, e->x + 0x10, e->y - 1)) { e->dir = 2; return; }
            if (!wheelie_solid(w, e->x - 1, e->y + 0x1d) &&
                !wheelie_solid(w, e->x - 1, e->y - 1) &&
                 wheelie_solid(w, e->x - 1, e->y + 0x1e)) { e->dir = 1; return; }
            e->y -= s; break;
        case 2: /* RIGHT */
            if (wheelie_solid(w, e->x + 0x1e, e->y + 0x10)) { e->dir = 9; return; }
            if (!wheelie_solid(w, e->x,       e->y - 1) &&
                !wheelie_solid(w, e->x + 0x1e, e->y - 1) &&
                 wheelie_solid(w, e->x - 1,    e->y - 1)) { e->dir = 8; return; }
            e->x += s; break;
        default: /* 9 DOWN */
            if (wheelie_solid(w, e->x + 0xc, e->y + 0x1e)) { e->dir = 1; return; }
            if (!wheelie_solid(w, e->x + 0x1e, e->y) &&
                !wheelie_solid(w, e->x + 0x1e, e->y + 0x1e) &&
                 wheelie_solid(w, e->x + 0x1e, e->y - 1)) { e->dir = 2; return; }
            e->y += s; break;
        }
    }
}

/* Hammer (bord 6 direct / spawner->child 0x6a, asm FUN_10007998): a WALKER that FALLS
 * off ledges and, at a BREAKABLE wall ahead, does a JUMP-SMASH -- it shatters the wall
 * (FUN_10027aec at X+0x1a,Y+0xa + sound event 0x11) and hops, then walks on through the
 * gap; it TURNS at a permanent wall (FUN_100056d4). VERIFIED 2026-07-06 by full asm read:
 * it does NOT hop continuously (the old ballistic-hopper port was WRONG) -- when there is
 * no wall it walks FLAT (2 px/frame, asm +0x10 += 2).
 *
 * The jump-smash is a FIXED-LIFT choreography, not a ballistic arc (asm smash counter
 * +0x6e): on meeting a breakable wall the Hammer rises a fixed 0xb (11) px in one step,
 * HOLDS that height for 16 update-steps (frames 0x41..0x50 right / 0x31..0x40 left),
 * SMASHES the wall on the 11th held step (frame 0x4b/0x3b -> FUN_10027aec + sound 0x11),
 * then DROPS the 11 px back to the floor and resumes walking through the gap. fire_cd
 * (idle for a Hammer otherwise, 0 on spawn) carries the phase counter: 0 = walking. */
static void enemy_hammer_hop(SoiWorld *w, SoiEnemy *e)
{
    int c, r, row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    uint32_t fc;
    if (e->fire_cd != 0) {                               /* mid jump-smash: hold, strike, drop */
        e->fire_cd++;
        if (e->fire_cd == 11) {                          /* asm strike frame 0x4b/0x3b */
            fc = cell_at_px(w, e->x + ((e->dir == 2) ? 0x1a : 4), e->y + 11 + 14, &c, &r);
            if (cell_breakable(fc)) {
                soi_block_shatter(w, c, r, SOI_SHATTER_DROP, 0, 0);   /* FUN_10027aec: pieces tumble down */
                soi_sfx_emit(w, SOI_SFX_ROBO_PUNCH);     /* asm sound event 0x11 (Metal) */
            }
        }
        if (e->fire_cd > 16) {                           /* asm +0x6e wraps past 0x50/0x40 */
            e->y += 11;                                  /* drop back down (asm +0x5a += 0xb) */
            if (e->dir == 1) e->x += 12;                 /* the left swing art sits 12 px left */
            e->fire_cd = 0;
        }
        return;
    }
    if (!(soi_get_cell(w, (e->x + 4 - SOI_ORIGIN_X) / SOI_CELL_PX, row + 1) & SOI_CELL_SUPPORTIVE) &&
        !(soi_get_cell(w, (e->x + 0x1a - SOI_ORIGIN_X) / SOI_CELL_PX, row + 1) & SOI_CELL_SUPPORTIVE)) {
        e->y += 4;                                       /* fall (feet x+4 / x+0x1a) */
        return;
    }
    if (e->turn) { e->turn--; return; }
    fc = cell_at_px(w, e->x + ((e->dir == 2) ? 0x1a : 4), e->y + 14, &c, &r);
    if (!(fc & SOI_CELL_SUPPORTIVE)) {
        e->x += (e->dir == 2) ? 2 : -2;                  /* walk flat (asm +0x58 += 2) */
    } else if (cell_breakable(fc)) {
        e->y -= 11;                                      /* the rise (asm +0x5a -= 0xb) */
        if (e->dir == 1) e->x -= 12;
        e->fire_cd = 1;                                  /* enter the hold/strike/drop phase */
    } else {
        enemy_turn_around(e);                            /* permanent wall -> 16-step turn */
    }
}

/* Creeper (asm FUN_10008618 horizontal / FUN_10008b18 vertical; bord types 16/17): a chain of
 * solid "bigger mblock" segments (sssf 1016). Each segment solidifies its cell (tile | 0x300,
 * the covered low word kept in `under` = asm +0x70), GROWS in (+0x56 = anim 0xf -> 1) while its
 * timer +0x6e = StartDelay*3 (fire_cd) runs down, then tries to SPAWN a child one cell ahead:
 * the cell must be non-solid, clear of any sprite (FUN_10004650 compares the screen with the
 * background) and hold an enterable tile (FUN_10009030). On success it SHRINKS out (anim ->
 * 0xf) and dies, restoring the covered tile; when blocked it reverses and retries the other way
 * on the next step, so a boxed-in segment waits. A step is every 3rd frame (+0x6c = 2).
 * state 0 = horizontal (dir 2 right / 1 left), 1 = vertical (dir 2 down / 1 up). */
void soi_creeper_init(SoiWorld *w, int idx)
{
    SoiEnemy *e = &w->enemies[idx];
    int col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX, row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    uint32_t c = soi_get_cell(w, col, row);
    e->under = c & 0xFFFFu;
    soi_set_cell(w, col, row, (c & 0xFFFF0000u) | e->under | SOI_WALL);
    e->fire_cd = (int16_t)(e->fire_period * 3);
    e->anim = 0x0f;
    e->stepc = 0;
}

static int creeper_enterable(uint32_t tile)
{
    tile &= 0xFFFFu;
    if (tile == 0 || tile == 0x197) return 1;
    return !(tile & SOI_CELL_SUPPORTIVE) && (tile & 0xFFu) > 0x9c && (tile & 0xFFu) < 0xd4;
}

/* FUN_10004650: is the cell's picture untouched by any sprite (player, nasty, shot)? */
static int creeper_cell_clear(const SoiWorld *w, int col, int row)
{
    int cx = soi_cell_x(col), cy = soi_cell_y(row), i;
    for (i = 1; i < SOI_MAX_PLAYERS; i++) {
        const SoiPlayer *p = &w->players[i];
        if (p->active && p->alive && p->x < cx + 32 && cx < p->x + 32 && p->y < cy + 32 && cy < p->y + 32)
            return 0;
    }
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *o = &w->enemies[i];
        if (o->active && o->type != SOI_ENEMY_CREEPER && !o->spawn_child &&
            o->x < cx + 32 && cx < o->x + 32 && o->y < cy + 32 && cy < o->y + 32)
            return 0;
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        const SoiProjectile *pr = &w->projectiles[i];
        if (pr->active && pr->x < cx + 32 && cx < pr->x + 24 && pr->y < cy + 32 && cy < pr->y + 24)
            return 0;
    }
    return 1;
}

static void enemy_creeper(SoiWorld *w, SoiEnemy *e)
{
    const int idx = (int)(e - w->enemies);
    int col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX, row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    int t;
    if (e->fire_cd < 1) {
        if (e->fire_cd < 0 && ++e->anim >= 0x0f) {        /* shrunk away: restore the covered tile */
            uint32_t c = soi_get_cell(w, col, row);
            soi_set_cell(w, col, row, (c & 0xFFFF0000u) | e->under);
            e->active = 0;
            return;
        }
    } else if (e->anim > 1) {
        e->anim--;                                        /* growing in */
    }
    t = e->fire_cd--;
    if (t == 0) {
        int ac = col, ar = row, ci = -1;
        if (e->state == 0) ac += (e->dir == 2) ? 1 : -1;
        else               ar += (e->dir == 2) ? 1 : -1;
        if (!(soi_get_cell(w, ac, ar) & SOI_CELL_SUPPORTIVE) && creeper_cell_clear(w, ac, ar) &&
            creeper_enterable(soi_get_cell(w, ac, ar)))
            ci = soi_enemy_spawn(w, SOI_ENEMY_CREEPER, ac, ar);
        if (ci >= 0) {
            SoiEnemy *c = &w->enemies[ci];
            c->state = e->state; c->dir = e->dir; c->vx = 0;
            c->fire_period = e->fire_period;
            soi_creeper_init(w, ci);
            if (ci > idx) c->stepc = 0xFF;                /* it starts updating next frame, as in the asm */
        } else {
            e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);    /* blocked: reverse, retry next step */
            e->fire_cd = 0;
        }
    }
}

/* Edge-TURNERS: the two AIs (Robo FUN_1000a780, Walker FUN_1000dd4c) that probe
 * the ground AHEAD and reverse at a ledge, so they patrol a platform and never
 * walk off it of their own accord. They are also the ONLY nasties whose asm fall
 * branch KILLS them on landing: both capture the credit player (FUN_1000581c) as
 * the fall begins, then award the kill when the ground re-probe (FUN_10005750)
 * finds a block under their feet again. Every other walker (Ant/Ostrich/Hippo/
 * Piggy/Smiley/Teeth) walks off ledges by design and its fall branch just resettles
 * it -- so those survive the drop. */
static int enemy_dies_on_fall(int type)
{
    return type == SOI_ENEMY_ROBO || type == SOI_ENEMY_WALKER;
}

/* Nearest in-play player to a pixel point, by squared distance -- the asm's
 * FUN_1000581c picks the closer of the two player slots to credit a fall kill.
 * Returns a 1-based player index, or -1 when no player is in play. */
static int nearest_player(const SoiWorld *w, int x, int y)
{
    int pj, best = -1, bestd = 1 << 30;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int dx, dy, d;
        if (!p->active || p->eliminated) continue;
        dx = p->x - x; dy = p->y - y;
        d = dx * dx + dy * dy;
        if (d < bestd) { bestd = d; best = pj; }
    }
    return best;
}

/* asm FUN_100054a4: which side the horizontally-nearest player is on (1 = left, 2 = right). */
static int nearest_player_side(const SoiWorld *w, int x)
{
    int pj, bestd = 1 << 30, side = 2;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int d;
        if (!p->active || p->eliminated) continue;
        d = p->x - x; if (d < 0) d = -d;
        if (d < bestd) { bestd = d; side = (x < p->x) ? 2 : 1; }
    }
    return side;
}

/* Grid cell under pixel (px,py), with its col/row (off-field reads as a wall). */
static uint32_t cell_at_px(const SoiWorld *w, int px, int py, int *col, int *row)
{
    int cx = px - SOI_ORIGIN_X, cy = py - SOI_ORIGIN_Y;
    *col = (cx >= 0) ? cx / SOI_CELL_PX : -1;
    *row = (cy >= 0) ? cy / SOI_CELL_PX : -1;
    return soi_get_cell(w, *col, *row);
}

static int cell_breakable(uint32_t c)
{
    return (c & SOI_CELL_SUPPORTIVE) && !(c & SOI_CELL_PERMANENT) && SOI_CELL_TYPE(c) != 0;
}

/* Walkers that stop and play a turn-around animation (asm +0x4c states 5/6) instead of
 * flipping on the spot. The turn lasts 16 AI steps after the step that starts it (the
 * Robo's 0x31..0x40 run is 15); the Smiley alone reverses instantly (FUN_1000d130). */
static int enemy_turns_slowly(int type)
{
    switch (type) {
        case SOI_ENEMY_ANT: case SOI_ENEMY_OSTRICH: case SOI_ENEMY_HIPPO: case SOI_ENEMY_PIGGY:
        case SOI_ENEMY_TEETH: case SOI_ENEMY_ROBO: case SOI_ENEMY_WALKER: case SOI_ENEMY_BEANIE:
        case SOI_ENEMY_HAMMER:
            return 1;
        default: return 0;
    }
}

static void enemy_turn_around(SoiEnemy *e)
{
    e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);
    e->vx  = (int16_t)-e->vx;
    if (enemy_turns_slowly(e->type))
        e->turn = (uint8_t)((e->type == SOI_ENEMY_ROBO) ? 15 : 16);
}

/* Wall probe x offsets (from the nasty's x) heading right / left, per asm update:
 * FUN_1000602c/81f8/9a78/93a0/d8c4 x+0x24 / x; FUN_1000d130 x+0x20 / x; FUN_1000a780
 * x+0x1c / x+4; FUN_1000dd4c x+0x22 / x+2. The probe row is y+10 (the nasty's own row). */
static int enemy_probe_dx(int type, int dir)
{
    switch (type) {
        case SOI_ENEMY_ROBO:   return (dir == 2) ? 0x1c : 4;
        case SOI_ENEMY_WALKER: return (dir == 2) ? 0x22 : 2;
        case SOI_ENEMY_SMILEY: return (dir == 2) ? 0x20 : 0;
        default:               return (dir == 2) ? 0x24 : 0;
    }
}

/* Beanie: horizontal (bord 7, FUN_10006378) or vertical (bord 8, FUN_10006840; e->state 8).
 * A gravity-free floater, drawn +4,+2 off its cell (asm init). It moves 2 px per step
 * until the cell ahead is solid: a BREAKABLE block makes it stop and shoot out a bud
 * (child 0x6b/0x6c, FUN_10006d44/6f6c) that extends for 16 steps, smashes the block,
 * retracts and vanishes -- the Beanie waits until it is gone (+0x7a), then walks on. A
 * permanent block makes it turn around (16 steps). It never spawns another Beanie. */
static void enemy_beanie(SoiWorld *w, SoiEnemy *e)
{
    const int vert = (e->state == 8);
    const int ax = e->x + 4, ay = e->y + 2;
    int px, py, c, r;
    uint32_t cell;
    if (e->bud) {
        e->bud++;
        if (e->bud == (vert ? 18 : 17)) {             /* fully extended: smash the block */
            if (!vert) { px = ax + ((e->dir == 2) ? 0x2c : -0x18); py = ay + ((e->dir == 2) ? 3 : 2); }
            else       { px = ax + ((e->dir == 2) ? 0x0c : 0x14); py = ay + ((e->dir == 2) ? 0x30 : -0x0e); }
            (void)cell_at_px(w, px, py, &c, &r);
            if (cell_breakable(soi_get_cell(w, c, r)))
                soi_block_remove(w, c, r);             /* FUN_100279c4: the block shrinks away */
        }
        if (e->bud >= (vert ? 33 : 32)) e->bud = 0;  /* retracted: the bud is gone */
        return;
    }
    if (e->turn) { e->turn--; return; }
    if (!vert) { px = ax + ((e->dir == 2) ? 0x1c : 0); py = ay + 10; }
    else       { px = ax; py = ay + ((e->dir == 2) ? 0x1e : -1); }
    cell = cell_at_px(w, px, py, &c, &r);
    if (!(cell & SOI_CELL_SUPPORTIVE)) {
        if (vert) e->y += (e->dir == 2) ? 2 : -2;
        else      e->x += (e->dir == 2) ? 2 : -2;
    } else if (cell_breakable(cell)) {
        e->bud = 1;
        soi_sfx_emit(w, SOI_SFX_BEANIE_BUD);
    } else {
        enemy_turn_around(e);
    }
}

static void enemy_step(SoiWorld *w, SoiEnemy *e)
{
    int row, ahead, spd = enemy_speed(e->type);

    /* Wheelie: a gravity-free flyer that bounces by wall-collision (no homing). */
    if (e->type == SOI_ENEMY_WHEELIE) { enemy_fly_bounce(w, e); return; }
    if (e->type == SOI_ENEMY_SPINNER && ++e->anim > 0x10) e->anim = 1;   /* FUN_1000d490 spin 1..16 */
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    /* Hammer: a WALKER that jump-smashes breakable walls (enemy_hammer_hop). A Hammer
     * SPAWNER (spawn_child set) stays put and emits, so only real Hammers are routed here. */
    if (e->type == SOI_ENEMY_HAMMER && e->spawn_child == 0) { enemy_hammer_hop(w, e); return; }
    /* Creeper: self-propelled block that steps cell-to-cell; gravity-free. */
    if (e->type == SOI_ENEMY_CREEPER) { enemy_creeper(w, e); return; }
    if (e->type == SOI_ENEMY_BEANIE) { enemy_beanie(w, e); return; }
    /* Cannon/Knight/Gargoyle: MOUNTED TURRETS. Their asm updates (FUN_100071a0,
     * FUN_1000c2e8, FUN_1000adc4) never call the gravity predicate FUN_10005750 and
     * never write their own +0x58/+0x5a (x/y) after init -- they hold their spawn
     * position and only fire on a timer (dispatched separately after enemy_step). So
     * they are EXEMPT from gravity and the walk/ledge logic below: a Cannon hung in
     * mid-board (bord 44) must NOT drop onto -- and kill -- the player under it, and a
     * column of flying shooters must keep its placed vertical spread instead of all
     * falling and stacking on the floor. The SPINNER (FUN_1000d490) is the ONE hazard
     * that DOES call FUN_10005750, so it is deliberately NOT exempt and still falls. */
    if (e->type == SOI_ENEMY_CANNON || e->type == SOI_ENEMY_KNIGHT ||
        e->type == SOI_ENEMY_GARGOYLE) return;

    /* Persistent SPAWNERS are likewise STATIONARY. Placed AFTER the turret exemption
     * above is safe because the loader never flags a turret type as a spawner (it sets
     * spawn_child only for HIPPO/HAMMER/TEETH/SMILEY/ANT/OSTRICH/PIGGY). The loader
     * fuses a spawn-block placement into ONE enemy typed as its emitted child but
     * flagged with spawn_child (the loader's .bord enemy scan, which also zeroes vx);
     * the asm keeps these two entities
     * distinct -- the placed spawner (e.g. Piggy struct type 0x13 -> FUN_10009778)
     * runs a dispatcher that NEVER calls the gravity predicate FUN_10005750 and
     * never writes its own +0x58/+0x5a, while only the emitted child (0x77 ->
     * FUN_10009a78) obeys gravity. All spawner dispatchers (FUN_100076a8 / 10007efc
     * / 1000d5d4 / 1000ce34 / 10005d30 / 100090a4 / 10009778) are gravity-free. So a
     * spawner holds its placed cell and only emits (enemy_spawner_emit, dispatched
     * after enemy_step): a Piggy spawner hung over open air (Board 44's c0,r9) must
     * NOT fall onto -- and kill -- the player beneath it. The emitted child is a
     * normal walker and still falls. */
    if (e->spawn_child) return;

    /* Gravity: a nasty is supported while EITHER foot rests on a SOLID block
     * (0x200) in the cell below; only over open air (BOTH feet clear) does it
     * FALL -- and not walk -- until it lands. The asm FUN_10005750 probes the two
     * INSET feet at x+6 and x+0x1a (a ~20 px stance inside the 32 px tile), NOT the
     * full-cell edges: so a nasty tips the instant those inset feet clear the block
     * under it, instead of clinging until its whole body is past the edge. This is
     * why pulling the block out from under a patrolling Robo now reliably drops it
     * (bug: break-under used to demand the Robo be dead-on the far cell edge). It
     * reverses only at a body-height WALL (below), never at a ledge. OOB reads solid
     * (0x300). The Beanie is EXEMPT: a gravity-free FLOATER (asm FUN_10006378 only
     * ever changes x, never applying a fall), so it hovers at its spawn height. */
    if (e->type != SOI_ENEMY_BEANIE) {
        int fl = 6, fr = 0x1a;                                          /* Robo (FUN_1000a780) */
        int lc, rc;
        switch (e->type) {                                              /* each AI's FUN_10005750 feet */
            case SOI_ENEMY_ANT: case SOI_ENEMY_PIGGY: fl = 4; fr = 0x20; break;
            case SOI_ENEMY_HIPPO: case SOI_ENEMY_TEETH: fl = 6; fr = 0x1e; break;
            case SOI_ENEMY_OSTRICH: fl = 8; fr = 0x1e; break;
            case SOI_ENEMY_SMILEY:  fl = 2; fr = 0x1e; break;
            case SOI_ENEMY_WALKER:  fl = 8; fr = 0x20; break;
            case SOI_ENEMY_SPINNER: fl = 8; fr = 0x18; break;          /* +4 init shift */
            default: break;
        }
        lc = (e->x + fl - SOI_ORIGIN_X) / SOI_CELL_PX;
        rc = (e->x + fr - SOI_ORIGIN_X) / SOI_CELL_PX;
        if (!(soi_get_cell(w, lc, row + 1) & SOI_CELL_SUPPORTIVE) &&
            !(soi_get_cell(w, rc, row + 1) & SOI_CELL_SUPPORTIVE)) {
            e->y += 4;                                   /* fall speed (px/frame) */
            row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
            if ((soi_get_cell(w, lc, row + 1) & SOI_CELL_SUPPORTIVE) ||
                (soi_get_cell(w, rc, row + 1) & SOI_CELL_SUPPORTIVE)) {
                e->y = soi_cell_y(row);                  /* land: rest on the block top */
                /* An edge-TURNER (Robo/Walker) DIES the instant it lands from a
                 * fall: pulling the block out from under a patrolling Robo drops it
                 * straight down onto the next block and kills it there (asm fall
                 * branch -> kill sound + score + death flag), crediting the nearest
                 * player. Edge-walkers fall harmlessly and are exempt (above). */
                if (enemy_dies_on_fall(e->type))
                    soi_enemy_kill(w, (int)(e - w->enemies),
                                   nearest_player(w, e->x, e->y));
                else if ((e->type == SOI_ENEMY_OSTRICH || e->type == SOI_ENEMY_TEETH) && !e->turn &&
                         nearest_player_side(w, e->x) != e->dir)
                    enemy_turn_around(e);   /* on landing it turns to face the nearest player (FUN_100054a4) */
            }
            if (e->type == SOI_ENEMY_WALKER) e->stepc = 1;   /* falls every 2nd frame (+0x6c reload 1) */
            return;
        }
    }

    /* Turning around (asm +0x4c 5/6): stand still while the turn animation plays. The
     * Walker's left-to-right turn ends with x -= 3 (FUN_1000dd4c state 6 exit). */
    if (e->turn) {
        if (--e->turn == 0 && e->type == SOI_ENEMY_WALKER && e->dir == 2) e->x -= 3;
        return;
    }

    /* The Robo PUNCHES through a breakable block (asm +0x6e): it stands and swings for
     * 16 steps and smashes the block on the 7th (+0x6e hits 0x18 / 8: FUN_10027d84 at
     * col(x+0x20) heading right, FUN_10027ecc at col(x) heading left), then walks on.
     * fire_cd (idle for the Robo otherwise) carries the swing countdown. */
    if (e->type == SOI_ENEMY_ROBO && e->fire_cd > 0) {
        e->fire_cd--;
        if (e->fire_cd == 9) {
            int a, r;
            (void)cell_at_px(w, e->x + ((e->dir == 2) ? 0x20 : 0), e->y + 14, &a, &r);
            if (cell_breakable(soi_get_cell(w, a, r))) {
                soi_block_shatter(w, a, r, (e->dir == 2) ? SOI_SHATTER_RIGHT : SOI_SHATTER_LEFT, 0, 0);
                soi_sfx_emit(w, SOI_SFX_ROBO_PUNCH);      /* asm event 0x11 -> 15960 "Metal" */
            }
        }
        return;                                           /* hold position through the swing */
    }

    /* The Walker (FUN_1000dd4c) and Robo (FUN_1000a780) PATROL: they turn at a wall AND at
     * a ledge (no ground ahead-and-below: walker (x+0x22|x+2, y+0x1a), robo (x+0x1c|x+4,
     * y+0x1f)). Everyone else walks off ledges. At a solid block ahead each type answers
     * differently (asm FUN_100279c4 breaks are SILENT):
     *   Hippo/Piggy (FUN_100081f8/9a78): a breakable block is chomped away AND they turn;
     *   Teeth (FUN_1000d8c4): chomps a breakable block and walks on (turns only at a wall);
     *   Smiley (FUN_1000d130): breaks it and reverses at once;
     *   Robo: winds up a punch (above);
     *   Ant/Ostrich/Walker, and all of them at a permanent wall: turn around.
     * The probe is taken BEFORE moving; the step is committed only when the way is clear. */
    if (e->type == SOI_ENEMY_WALKER)
        e->vx = (int16_t)((e->dir == 2) ? spd : -spd);
    {
        int ar;
        uint32_t ac = cell_at_px(w, e->x + enemy_probe_dx(e->type, e->dir), e->y + 12, &ahead, &ar);
        if (!(ac & SOI_CELL_SUPPORTIVE)) {
            if ((e->type == SOI_ENEMY_WALKER || e->type == SOI_ENEMY_ROBO) &&
                !(soi_get_cell(w, ahead, row + 1) & SOI_CELL_SUPPORTIVE))
                enemy_turn_around(e);                /* ledge */
            else
                e->x += e->vx;                       /* clear ahead -> advance a full step */
        } else if (cell_breakable(ac) &&
                   (e->type == SOI_ENEMY_HIPPO || e->type == SOI_ENEMY_PIGGY ||
                    e->type == SOI_ENEMY_TEETH || e->type == SOI_ENEMY_SMILEY)) {
            soi_block_remove(w, ahead, ar);          /* FUN_100279c4: chomped away (shrinks) */
            if (e->type != SOI_ENEMY_TEETH) {
                if (e->type == SOI_ENEMY_SMILEY) { e->dir = (uint8_t)((e->dir == 2) ? 1 : 2); e->vx = (int16_t)-e->vx; }
                else enemy_turn_around(e);
            }
        } else if (cell_breakable(ac) && e->type == SOI_ENEMY_ROBO) {
            e->fire_cd = 16;                         /* breakable block ahead -> punch, don't turn */
        } else {
            enemy_turn_around(e);
        }
    }
}

/* Cannon (FUN_100071a0): a stationary shooter that lobs a hostile Magic-Arrow
 * projectile (type 0x65) one cell ahead in its facing on a fixed reload. The
 * shot destroys destructible blocks and hits a player on contact. */
static void enemy_cannon_fire(SoiWorld *w, SoiEnemy *e)
{
    int i, dc;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    dc = (e->dir == 2) ? 1 : -1;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active  = 1;
        pr->owner   = 0;
        pr->hostile = 1;
        pr->src_type = SOI_ENEMY_CANNON;   /* drawn as the cannon's spinning beach ball */
        pr->age = 0;
        pr->x = e->x + ((dc > 0) ? 0x1c : -0x0c);   /* FUN_100071a0 spawn point */
        pr->y = e->y + 8;
        pr->vx = (int16_t)(dc * 4);    /* 4 px/frame (asm 0x65 mover FUN_1000744c: +0x10 +/- 4) */
        pr->vy = 0;
        soi_sfx_emit(w, SOI_SFX_CANNON_FIRE);   /* asm event 0x10 -> 12863 "Flens" (not the arrow) */
        return;
    }
}

/* Gargoyle BADGUY EGG (asm FUN_1000bf54 -> type-200 mover FUN_1000b6a0 -> FUN_1000b7dc): a
 * harmless egg flown to a random EMPTY cell in the top three rows (FUN_1000c194: 10 tries of
 * Random(19) x Random(3), rejecting cells next to a Knight/Gargoyle), else to a player's cell;
 * on arrival it hatches the board's thrown_badguy nasty with a 400-frame lifespan. */
static SoiEnemyType thrown_badguy_type(int sel)
{
    switch (sel) {                         /* FUN_1000b7dc switch; 18 and anything else -> Ostrich */
        case 5: case 6: case 10: case 11: case 12: case 19: return soi_bord_badguy_type((uint8_t)sel);
        default: return SOI_ENEMY_OSTRICH;
    }
}

static void gargoyle_egg(SoiWorld *w, const SoiEnemy *e)
{
    int tries, tcol = -1, trow = -1, i;
    for (tries = 0; tries < 10 && tcol < 0; tries++) {
        int c = soi_rand_range(w, SOI_GRID_COLS) - 1;
        int r = soi_rand_range(w, 3) - 1;
        if (soi_gift_cell_ok(w, c, r)) { tcol = c; trow = r; }
    }
    if (tcol < 0) {
        int bestd = 1 << 30, pj;
        for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
            const SoiPlayer *p = &w->players[pj];
            int dx, dy, d;
            if (!p->active || !p->alive || p->eliminated) continue;
            dx = p->x - e->x; dy = p->y - e->y;
            d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
            if (d < bestd) {
                bestd = d;
                tcol = (p->x + 0x0C - SOI_ORIGIN_X) / SOI_CELL_PX;
                trow = (p->y + 0x10 - SOI_ORIGIN_Y) / SOI_CELL_PX;
            }
        }
        if (tcol < 0) return;
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1; pr->owner = 0; pr->hostile = 0; pr->kind = 3;
        pr->src_type = (uint8_t)SOI_ENEMY_GARGOYLE; pr->pierce = 0;
        pr->gtype = (uint8_t)thrown_badguy_type(w->thrown_badguy);
        pr->tcol = (int16_t)tcol; pr->trow = (int16_t)trow;
        pr->x = e->x; pr->y = e->y;
        pr->vx = (int16_t)e->x; pr->vy = (int16_t)e->y;   /* launch point, as the kind-2 gift */
        pr->age = 0;
        return;
    }
}

/* Gargoyle (bord 14, asm FUN_1000adc4): a STATIONARY 3-phase turret that fires a puff
 * AIMED at the nearest live player. The asm puff FUN_1000b44c (type 0x72) picks the live
 * player (globals 0x3be2/0 = P1, 0x3be6/4 = P2; a coord > 0x3e8 = dead sentinel) and sets
 * a NORMALIZED velocity toward them ((dx<<0xc)/dist, (dy<<0xc)/dist) -- so it tracks a
 * DIAGONAL player, not just H/V. On each throw the asm first rolls Random(100) against
 * pct_badguy: at or below it the Gargoyle lobs a BADGUY EGG instead (FUN_1000bf54,
 * gargoyle_egg); pct_ultrabuster%% of the puffs pierce blocks (FUN_1000b44c +0x8a == 2).
 * We reproduce the aim with the dominant axis at the confirmed
 * 4 px/frame + a proportional minor axis (integer approx of the normalized vector). (The
 * Knight, bord 13, drops gifts instead -- enemy_knight_gift.) */
static void enemy_shooter_fire(SoiWorld *w, SoiEnemy *e)
{
    int i, pj, tx = 0, ty = 0, bestd = 1 << 30, found = 0;
    int dx, dy, adx, ady, vx = 0, vy = 0, sx = 0, sy = 0;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    if (e->type == SOI_ENEMY_GARGOYLE && soi_rand_range(w, 100) <= w->pct_badguy) {
        gargoyle_egg(w, e);
        return;
    }
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int ddx, ddy, d;
        if (!p->active || !p->alive || p->eliminated) continue;
        ddx = p->x - e->x; ddy = p->y - e->y;
        d = (ddx < 0 ? -ddx : ddx) + (ddy < 0 ? -ddy : ddy);
        if (d < bestd) { bestd = d; tx = p->x; ty = p->y; found = 1; }
    }
    if (!found) return;
    /* Aim STRAIGHT at the player (asm FUN_1000b44c normalized velocity): the dominant
     * axis runs at the confirmed 4 px/frame, the minor axis is scaled so |minor| <= 4 ->
     * the shot tracks a diagonal player. Same row/col -> a pure H/V shot. */
    dx = tx - e->x; dy = ty - e->y;
    adx = (dx < 0) ? -dx : dx;
    ady = (dy < 0) ? -dy : dy;
    if (adx >= ady) {
        sx = (dx >= 0) ? 1 : -1;
        vx = sx * 4;
        vy = (adx > 0) ? (dy * 4) / adx : 0;
        e->dir = (uint8_t)(sx > 0 ? 2 : 1);
    } else {
        sy = (dy >= 0) ? 1 : -1;
        vy = sy * 4;
        vx = (ady > 0) ? (dx * 4) / ady : 0;
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active  = 1;
        pr->owner   = 0;
        pr->hostile = 1;
        pr->src_type = (uint8_t)e->type;   /* Gargoyle puff / Knight bolt art */
        pr->kind = 0;                      /* hostile aimed puff */
        pr->pierce = (e->type == SOI_ENEMY_GARGOYLE &&
                      soi_rand_range(w, 100) <= w->pct_ultrabuster) ? 1 : 0;
                                           /* pierce: pct_ultrabuster%% of puffs (FUN_1000b44c +0x8a == 2) */
        pr->age = 0;
        /* Spawn the puff at the Gargoyle's OWN top-left (e->x, e->y), NOT one cell toward the
         * aim. The asm FUN_1000adc4 hands FUN_1000b44c a sub-tile muzzle (gx+0x1e, gy-8) that
         * still resolves to the Gargoyle's own cell; the port uses the tile origin instead
         * because it lands in the SAME collision cell yet avoids gy-8 straying up into the row
         * ABOVE (also a wall for the caged board_410 Gargoyle). The old "e->x + sx*0x20"
         * launched the puff a full cell in the aim direction -- for that caged Gargoyle that is
         * straight INTO the adjacent wall, so the puff was killed on its first tick
         * (soi_projectiles_update wall check) and never appeared ("Gargoyle doesn't shoot out
         * the dangerous projectile"). From its own open tile the puff is visible and tracks the
         * player. (The Cannon/Walker keep their one-cell-ahead muzzle: they are OPEN turrets on
         * every shipped board, never caged, so their forward muzzle never fires into a wall.) */
        pr->x = e->x;
        pr->y = e->y;
        pr->vx = (int16_t)vx;
        pr->vy = (int16_t)vy;
        /* The Gargoyle fires SILENTLY (asm FUN_1000adc4 -- no SFX trigger, unlike the
         * Cannon's 0x10). */
        return;
    }
}

/* ---- Knight gifts (bord 13, asm FUN_1000c2e8 3-phase -> FUN_1000c8bc spawn -> proj
 * 0x71 mover FUN_1000c544 -> FUN_1000c680 drop) ----
 * The Knight does NOT shoot a hostile bolt: it periodically launches a kind-2 GIFT
 * projectile (0x71) aimed at a target cell. FUN_1000cafc picks a random EMPTY cell
 * not adjacent to a Spinner/Gargoyle; if none is found FUN_1000c8bc falls back to a
 * player's cell. The gift flies there and, on REACHING the target cell (FUN_1000c544
 * col/row match), calls FUN_1000c680 to stamp a RANDOM GOODY (Random()&0x3f table) --
 * it never damages the player. A cell the player has BLOCKED mid-flight becomes a
 * gift-BLOCK (goody buried as a 0x1000 payload; destroy to reveal it). VERIFIED
 * 2026-07-06: FUN_1000c544 drops a goody, not a hit -> "Knight shoots" was a render
 * bug (gift drawn as an arrow swirl), since fixed to a gift sparkle. */
static uint8_t gift_goody(SoiWorld *w)
{
    int r = soi_rand_range(w, 64) - 1;   /* 0..63, matching Random()&0x3f (FUN_1000c680) */
    if (r < 0x1B) return 0x0A;           /* silver coin (dominant ~42%) */
    if (r < 0x23) return 0x17;           /* gold coin */
    if (r < 0x27) return 0x18;           /* gem */
    if (r < 0x29) return 0x19;           /* gold bars */
    if (r == 0x29) return 0x12;          /* magic ball */
    if (r == 0x2A) return 0x11;          /* magic arrow */
    if (r == 0x2B) return 0x10;          /* shield */
    if (r < 0x2E) return 0x13;           /* time bonus */
    if (r < 0x36) return 0x0C;           /* 2x multiplier */
    if (r < 0x3A) return 0x0D;           /* 3x multiplier */
    if (r < 0x3C) return 0x0E;           /* 4x multiplier */
    if (r < 0x3E) return 0x0F;           /* 5x multiplier */
    return 0x30u;                        /* 0x3E-0x3F: invuln potion. asm FUN_1000c680: r>0x3d -> 0x30;
                                          * its r>0x3f -> 0x32 branch is DEAD CODE (Random()&0x3f maxes
                                          * at 0x3f), so 0x32 (shoes) is never dropped by this table. */
}

/* A gift target must be EMPTY and not adjacent to a Knight or Gargoyle (asm FUN_1000cc50
 * rejects any cell whose neighbourhood holds the entity markers 0x40d = Knight (0x400|13)
 * or 0x40e = Gargoyle (0x400|14)). The port scans a symmetric 3x3 of live-enemy positions,
 * which is at least as strict as the asm's 8-cell (sides + the two rows below) mask. This
 * is what stops the Knight from raining its OWN gifts into its (and the caged Gargoyle's)
 * area -- the old code checked SPINNER instead of KNIGHT, so nothing guarded the shooters'
 * own tiles and the board filled with goodies up to and inside the cage. */
int soi_gift_cell_ok(SoiWorld *w, int col, int row)
{
    int dc, dr;
    if (!soi_in_bounds(col, row) || soi_get_cell(w, col, row) != 0) return 0;
    for (dr = -1; dr <= 1; dr++)
        for (dc = -1; dc <= 1; dc++) {
            int a = soi_enemy_at(w, col + dc, row + dr);
            if (a >= 0 && (w->enemies[a].type == SOI_ENEMY_KNIGHT ||
                           w->enemies[a].type == SOI_ENEMY_GARGOYLE))
                return 0;
        }
    return 1;
}

/* Drop the gift's goody at (col,row): empty -> a plain collectible; a player-built
 * block -> a gift-BLOCK burying the goody as a 0x1000 payload (FUN_1000c680). */
static void soi_gift_land(SoiWorld *w, int col, int row, uint8_t gtype)
{
    uint32_t cell;
    if (!soi_in_bounds(col, row)) return;
    cell = soi_get_cell(w, col, row);
    if (cell == 0)
        soi_set_cell(w, col, row, 0x900u | gtype);
    else if (!(cell & SOI_CELL_PERMANENT))
        soi_set_cell(w, col, row, (cell & 0xFFFFu) | SOI_CELL_SPECIAL | ((uint32_t)(0x900u | gtype) << 16));
}

static void enemy_knight_gift(SoiWorld *w, SoiEnemy *e)
{
    int tries, tcol = -1, trow = -1, i;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    for (tries = 0; tries < 10 && tcol < 0; tries++) {
        int c = soi_rand_range(w, SOI_GRID_COLS) - 1;
        int r = soi_rand_range(w, SOI_GRID_ROWS) - 1;
        if (soi_gift_cell_ok(w, c, r)) { tcol = c; trow = r; }
    }
    if (tcol < 0) {                                  /* board walled in -> aim at a player */
        int bestd = 1 << 30, pj;
        for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
            const SoiPlayer *p = &w->players[pj];
            int cc, rr, d;
            if (!p->active || !p->alive || p->eliminated) continue;
            cc = (p->x - SOI_ORIGIN_X) / SOI_CELL_PX;
            rr = (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
            d = cc + rr;
            if (d < bestd) { bestd = d; tcol = cc; trow = rr; }
        }
        if (tcol < 0) return;                        /* no players -> nothing to drop */
    }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1; pr->owner = 0; pr->hostile = 0; pr->kind = 2;
        pr->src_type = (uint8_t)SOI_ENEMY_KNIGHT; pr->pierce = 0;
        pr->gtype = gift_goody(w);
        pr->tcol = (int16_t)tcol; pr->trow = (int16_t)trow;
        pr->x = e->x; pr->y = e->y;
        pr->vx = (int16_t)e->x; pr->vy = (int16_t)e->y;  /* a gift reuses vx/vy to remember its
                                                          * LAUNCH pixel position (kind-2 has no
                                                          * velocity of its own -- see the mover) */
        pr->age = 0;
        return;
    }
}

/* Persistent spawner (FUN_100076a8 &c): a stationary emitter that produces its
 * base nasty (child = placement+0x64) every fire_period frames. Emitted children
 * are TRANSIENT (given a lifespan) so the playfield does not fill up. Emit
 * DIRECTION follows the asm +0x4c mode carried in e->state: 3 = ALTERNATE (flip
 * each emit, toggled via the otherwise-unused e->child), 4 = SEEK the nearest
 * player, else the fixed e->dir set at load. */
static void enemy_spawner_emit(SoiWorld *w, int idx)
{
    SoiEnemy *e = &w->enemies[idx];
    int ci, col, row, spd, cdir;
    SoiEnemyType child = (SoiEnemyType)e->spawn_child;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    if (e->state == 4) {                         /* seek the nearest player (FUN_100054a4) */
        cdir = nearest_player_side(w, e->x);
    } else if (e->state == 3) {                  /* alternate right/left each emit */
        cdir = e->child ? 1 : 2;
        e->child = (uint8_t)(e->child ? 0 : 1);
    } else {                                     /* fixed direction (from load) */
        cdir = (e->dir == 1) ? 1 : 2;
    }
    ci = soi_enemy_spawn(w, child, col, row);
    if (ci >= 0) {
        spd = enemy_speed((int)child);
        w->enemies[ci].dir  = (uint8_t)cdir;
        w->enemies[ci].vx   = (int16_t)((cdir == 1) ? -spd : spd);
        /* Child lifespan = SpawnDelay*8 (asm FUN_100076a8: child+0x74 = (spawner
         * +0x50)<<3). The reload interval is SpawnDelay*6 == e->fire_period, so
         * life = fire_period*4/3. (Was *2 = SpawnDelay*12 -> children over-lived
         * 1.5x, inflating on-screen enemy density.) */
        w->enemies[ci].life = (int16_t)((e->fire_period > 0) ? e->fire_period * 4 / 3 : 160);
        if (child == SOI_ENEMY_PIGGY && cdir == 2) w->enemies[ci].x -= 4;   /* FUN_10009778 */
    }
}

/* Walker (bord 4, asm FUN_1000dd4c + FUN_1000e5c8/e7c8): besides patrolling, the
 * Walker FIRES a horizontal bolt in its facing direction when a live player is on
 * its ROW -- FUN_1000e5c8 (right) / FUN_1000e7c8 (left) return 1 when a player's Y
 * is within 0x20 (one cell) of the Walker's Y, which triggers the projectile spawn
 * (FUN_10005948) at walker.x+0x1e and a sound (evt 0x13). We reload between shots.
 * The bolt is projectile type 0x68 (UltraBuster, handler FUN_1000e3c0): it smashes
 * any destructible (0x200 non-permanent) block it hits and stops at a permanent wall
 * -- NOT gated by pct_ultrabuster (that gate is on the Gargoyle 0x72 puff pierce);
 * our hostile-shot path already matches this exactly.
 * It ALSO fires when a breakable block sits in any of the 4 cells ahead (FUN_1000e5c8 scans
 * col(x+0x24)..+3, FUN_1000e7c8 col(x-8)..-3, on the Walker's row), and it aims along the
 * heading it had BEFORE this step's turn -- the asm tests line-of-fire right after deciding
 * to turn and still fires the way it was walking, i.e. straight at the block it met. */
static int walker_block_ahead(const SoiWorld *w, const SoiEnemy *e, int dir)
{
    int px = e->x + ((dir == 2) ? 0x24 : -8) - SOI_ORIGIN_X;
    int c = (px >= 0) ? px / SOI_CELL_PX : -1, r = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX, k;
    for (k = 0; k < 4; k++) {
        int cc = (dir == 2) ? c + k : c - k;
        uint32_t cell;
        if (!soi_in_bounds(cc, r)) break;
        cell = soi_get_cell(w, cc, r);
        if ((cell & SOI_CELL_SUPPORTIVE) && !(cell & SOI_CELL_PERMANENT)) return 1;
    }
    return 0;
}

static void enemy_walker_fire(SoiWorld *w, SoiEnemy *e, int dir)
{
    int i, pj, dc, aligned = 0;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int dy;
        if (!p->active || !p->alive || p->eliminated) continue;
        dy = p->y - (e->y + 6); if (dy < 0) dy = -dy;   /* the asm Walker sits 6 px lower (init +0x5a += 6) */
        if (dy < 0x20) { aligned = 1; break; }
    }
    if (!aligned && !walker_block_ahead(w, e, dir)) return;
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : 96;   /* reload = StartDelay<<2 steps (asm +0x6e) */
    dc = (dir == 2) ? 1 : -1;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1; pr->owner = 0; pr->hostile = 1;
        pr->src_type = (uint8_t)SOI_ENEMY_WALKER; pr->kind = 0; pr->pierce = 0; pr->age = 0;
        pr->x = e->x + ((dc > 0) ? 0x1e : -8);       /* FUN_1000dd4c: x+0x1e,y+8 / x-8,y+4 off the */
        pr->y = e->y + 6 + ((dc > 0) ? 8 : 4);        /* Walker's asm position (6 px below its cell) */
        pr->vx = (int16_t)(dc * 4); pr->vy = 0;    /* 4 px/frame (asm 0x68 UltraBuster FUN_1000e3c0: +0x10 +/- 4) */
        soi_sfx_emit(w, SOI_SFX_WALKER_FIRE);      /* asm event 0x13 -> snd 2689 "Strings" (NOT the cannon Flens) */
        return;
    }
}

/* A nasty's touch hurtbox (asm enemy +0x82/+0x80/+0x84/+0x7e, tested by FUN_100030d4).
 * The Cannon (FUN_100071a0) and every persistent spawner (FUN_100076a8 &c) park their box
 * top at 1000 -- they never touch the player; the Spinner (FUN_1000d490, spawned +4/+6) and
 * Wheelie (FUN_10009e98, +0/+2) have their own boxes; the rest use the Robo box
 * (FUN_1000a780), a close stand-in for the walkers. Returns 0 when there is no hurtbox. */
static int enemy_hurtbox(const SoiEnemy *e, int k, int *l, int *t, int *r, int *b)
{
    int bl = 0x09, bt = 0x0a, br = 0x19, bb = 0x22;
    if (k == 1) {   /* a Beanie's bud (0x6b/0x6c boxes, FUN_10006d44/6f6c) while it is out */
        int ax = e->x + 4, ay = e->y + 2, bx, by;
        if (e->type != SOI_ENEMY_BEANIE || e->bud < 2) return 0;
        if (e->state != 8) {
            bx = ax + ((e->dir == 2) ? 0x1c : -0x18); by = ay + ((e->dir == 2) ? 3 : 2);
            *l = bx + 4; *t = by + 5; *r = bx + 0x1c; *b = by + 0x0f;
        } else {
            bx = ax + ((e->dir == 2) ? -4 : 4); by = ay + ((e->dir == 2) ? 0x12 : -8);
            *l = bx + 10; *t = by + 5; *r = bx + 0x0f; *b = by + 0x1c;
        }
        return 1;
    }
    if (e->type == SOI_ENEMY_CANNON || e->type == SOI_ENEMY_CREEPER || e->spawn_child) return 0;
    /* asm box offsets shifted by where each nasty rests in its cell: spawners/eggs place the child
     * at its standing height (FUN_100076a8 &c: Ant +16, Hippo +14, Piggy +5, Teeth +4, others +2);
     * a placed Robo falls to +4, the Walker's init adds +6; Beanie/turrets carry init shifts. */
    switch (e->type) {
        case SOI_ENEMY_SPINNER:  bl = 0x05; bt = 0x12; br = 0x1b; bb = 0x20; break;
        case SOI_ENEMY_WHEELIE:  bl = 0x04; bt = 0x04; br = 0x1a; bb = 0x1a; break;
        case SOI_ENEMY_ANT:      bl = 0x06; bt = 0x10; br = 0x20; bb = 0x20; break;
        case SOI_ENEMY_HIPPO:    bl = 0x05; bt = 0x10; br = 0x20; bb = 0x20; break;
        case SOI_ENEMY_PIGGY:    bl = 0x07; bt = 0x09; br = 0x1e; bb = 0x20; break;
        case SOI_ENEMY_TEETH:    bl = 0x06; bt = 0x08; br = 0x20; bb = 0x1f; break;
        case SOI_ENEMY_OSTRICH:  bl = 0x08; bt = 0x04; br = 0x1e; bb = 0x20; break;
        case SOI_ENEMY_SMILEY:   bl = 0x04; bt = 0x06; br = 0x1e; bb = 0x1e; break;
        case SOI_ENEMY_HAMMER:   bl = 0x06; bt = 0x08; br = 0x18; bb = 0x20; break;
        case SOI_ENEMY_WALKER:   bl = 0x08; bt = 0x0a; br = 0x1e; bb = 0x1e; break;
        case SOI_ENEMY_BEANIE:
            if (e->state == 8) { bl = 0x06; bt = 0x04; br = 0x1a; bb = 0x1e; }
            else               { bl = 0x0a; bt = 0x04; br = 0x1c; bb = 0x1e; }
            break;
        case SOI_ENEMY_GARGOYLE: bl = -0x0f; bt = -0x25; br = 0x01; bb = -0x0d; break;
        case SOI_ENEMY_KNIGHT:   bl = -0x07; bt = -0x2a; br = 0x09; bb = -0x12; break;
        default: break;          /* Robo (FUN_1000a780) */
    }
    *l = e->x + bl; *t = e->y + bt; *r = e->x + br; *b = e->y + bb;
    return 1;
}

void soi_enemies_update(SoiWorld *w)
{
    int i, pj;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        SoiEnemy *e = &w->enemies[i];
        uint8_t pre_dir, pre_turn;
        if (!e->active) continue;
        pre_dir = e->dir;
        pre_turn = e->turn;
        if (++e->stepc >= (e->period ? e->period : 1)) {   /* an AI step frame (asm +0x6c expiry) */
            e->stepc = 0;
            /* Shoes/Turtles (+0x88): a claimed nasty self-destructs on its next
             * step, crediting the collecting player (FUN_1000543c marks every
             * real nasty; each one's own update awards +0x8a at its next anim
             * boundary). All of our spawned enemies are real nasties, so a claim
             * defeats them the way the goody does in the original. */
            if (e->claimed) {
                /* Thunderballs claim only real nasties; the hazard types (turrets, Creeper)
                 * never read +0x40 in the asm, so a claim cannot defeat them. */
                if (!enemy_is_hazard(e->type)) { soi_enemy_kill(w, i, e->claimed); continue; }
                e->claimed = 0;
            }
            if (e->life > 0 && --e->life == 0) {             /* transient child expired (+0x74, per step) */
                e->active = 0;
                continue;
            }
            enemy_step(w, e);
            if (!e->active) continue;   /* enemy_step may kill it (edge-turner fall death); skip the rest */
        }
        if (e->type == SOI_ENEMY_CANNON)
            enemy_cannon_fire(w, e);                /* stationary shooter (FUN_100071a0) */
        if (e->type == SOI_ENEMY_GARGOYLE)
            enemy_shooter_fire(w, e);               /* aimed puff; pierce/break by pct_ultrabuster */
        if (e->type == SOI_ENEMY_KNIGHT)
            enemy_knight_gift(w, e);                /* drops a random gift (FUN_1000c2e8) */
        if (e->type == SOI_ENEMY_GARGOYLE || e->type == SOI_ENEMY_KNIGHT)
            turret_anim(e);
        if (e->type == SOI_ENEMY_WALKER && !pre_turn)   /* no line-of-fire test while turning (FUN_1000dd4c) */
            enemy_walker_fire(w, e, pre_dir);       /* bolt at a player on its row / a block ahead (FUN_1000e5c8/e7c8) */
        if (e->spawn_child)
            enemy_spawner_emit(w, i);               /* persistent spawner (FUN_100076a8 &c) */
        /* player contact: touching an enemy kills the player (first draft). The
         * Creeper is a solid moving BLOCK (it solidifies its cell), not a touch
         * hazard, so it is exempt. */
        for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
            SoiPlayer *p = &w->players[pj];
            int pl, pt, prt, pb, el, et, er, eb, k;
            if (!p->active || !p->alive || e->type == SOI_ENEMY_CREEPER) continue;
            /* Real player<->enemy contact is an AABB overlap of two INSET hurtboxes
             * (asm FUN_100299b4 -> FUN_100030d4), NOT a coarse "same grid cell" test.
             * The player box is a narrow central strip [x+0xd, x+0x12] x [y+4, y+(0x19
             * while JUMPING else 0x1d)]; the enemy box is its per-type asm box
             * (enemy_hurtbox), plus a Beanie's bud while it is out. The short
             * 0x19 box is JUMP-only: asm FUN_100299b4 picks it solely when the motion
             * state field == 2 (JUMP per FUN_10013404); FALL (state 3) and grounded both
             * use the tall 0x1d box, so only a rising jump gets the shorter hurtbox.
             * Cell-equality wrongly killed a player who was safely on a DIFFERENT block
             * while a nasty fell THROUGH his column (bug: "he killed me while falling
             * even though I was on another block"). */
            pl = p->x + 0x0d; prt = p->x + 0x12;
            pt = p->y + 0x04; pb = p->y + (p->ground_state == SOI_ST_JUMP ? 0x19 : 0x1d);
            for (k = 0; k < 2; k++) {
                if (!enemy_hurtbox(e, k, &el, &et, &er, &eb)) continue;
                if (pl <= er && el <= prt && pt <= eb && et <= pb) {
                    soi_player_hit(w, pj);   /* -> death-throw somersault; life-loss + respawn
                                              * commit in air_step (VERIFIED complete, not a TODO) */
                    break;
                }
            }
        }
    }
}

/* The turret's asm +0x56 frame for its place in the throw cycle (FUN_1000adc4 / FUN_1000c2e8):
 * first cycle the wings unfold 1..0x11 (a frame per 6); then the Gargoyle flaps 0x11..0x20 and
 * winds up 0x20..0x49 over its last 168 frames, the Knight holds 0x10 and winds up 0x10..0x41
 * over its last 200 (a frame per 4). */
static void turret_anim(SoiEnemy *e)
{
    const int garg = (e->type == SOI_ENEMY_GARGOYLE);
    const int win = garg ? 168 : 200, fcd = e->fire_cd, per = e->fire_period;
    int a;
    if (fcd > per) {
        a = 0x11 - (fcd - per) / 6;
        if (a < 1) a = 1;
    } else if (fcd <= win) {
        a = (garg ? 0x20 : 0x10) + (win - fcd) / 4;
        if (a > (garg ? 0x49 : 0x41)) a = garg ? 0x49 : 0x41;
    } else {
        a = garg ? 0x20 - ((fcd - win) / 4) % 16 : 0x10;
    }
    e->anim = (uint16_t)a;
}

/* The asm gives each player a SINGLE projectile slot (player +0x4e = the live
 * arrow/ball X, 0 = none). Both fire handlers -- FUN_10010d30 (arrow) and
 * FUN_100110b4 (ball) -- gate on "+0x4e == 0", so a player cannot fire again
 * until their previous shot has despawned, and the arrow and ball SHARE the one
 * slot. There is NO frame cooldown in the original: this one-shot-in-flight gate
 * IS the throttle. (The weapon-audit's guessed fire_cd=15 is now retired.) */
static int player_has_projectile(const SoiWorld *w, int player)
{
    int i;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        const SoiProjectile *pr = &w->projectiles[i];
        if (pr->active && !pr->hostile && pr->owner == (uint8_t)player) return 1;
    }
    return 0;
}

/* Weapon launch x (FUN_10010d30/100110b4): x+0x14 / x-0xe off the firer, pulled back to a
 * cell boundary when that spot is already inside a block. */
static int weapon_spawn_x(const SoiWorld *w, int px, int dc, int wy)
{
    int c, r, x = px + ((dc > 0) ? 0x14 : -0x0e);
    if (dc > 0) {
        if (cell_at_px(w, x + 0x18, wy, &c, &r) & SOI_CELL_SUPPORTIVE) {
            (void)cell_at_px(w, x - 8, wy, &c, &r);
            x = soi_cell_x(c) + 8;
        }
    } else if (cell_at_px(w, x, wy, &c, &r) & SOI_CELL_SUPPORTIVE) {
        (void)cell_at_px(w, x + 0x20, wy, &c, &r);
        x = soi_cell_x(c);
    }
    return x;
}

/* Fire the player's spinning ball (the "arrow" ammo pool +0x4c) in the facing
 * direction. CONFIRMED asm FUN_10010d30 fire + FUN_1000fd5c mover, type +0x54 ==
 * 2 (fired right) / 3 (fired left): it is a 4-STATE TERRAIN FOLLOWER, hugging the
 * floor/wall it travels along (down a cliff, up a wall) rather than a bare straight
 * ricochet, and it kills any nasty it overlaps. Consumes one shot; the asm allows
 * only ONE live shot per player (player_has_projectile). Moves 2 px/frame (asm
 * state x/y +/-= 2 each frame). */
void soi_projectile_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (soi_pool(w, player)->arrows <= 0 || player_has_projectile(w, player)) return;
    dc = (p->facing >= 0) ? 1 : -1;   /* Magic Arrow: fired horizontally, then ricochets */
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1;
        pr->owner  = (uint8_t)player;
        pr->hostile = 0;
        pr->kind = 0;                  /* the spinning wall-follower ball */
        pr->age = 0;
        /* Snap Y to the firing row (asm FUN_10010d30 lines 45-49:
         * FUN_1002e6ac(FUN_1002e6cc(playerY+0x10))+8 == (playerY & ~31)+24 ==
         * soi_cell_y(row)+8). The +8 seat keeps the ball's centre probe (+0xc) in
         * its own row while the floor probe (+0x19) reaches the row below, so the
         * terrain follower can feel the floor it hugs. */
        pr->y = (p->y & ~31) + 24;
        pr->x = weapon_spawn_x(w, p->x, dc, pr->y);
        /* kind 0 has no dedicated state fields, so (like the kind-2 gift, which
         * reuses vx/vy for its launch point) it stores its follower STATE in vx and
         * follower TYPE in vy: vx = dir-state (asm +0x52, 1=L/2=U/3=R/4=D), vy = type
         * (asm +0x54). Fire right -> type 2 rolling RIGHT (state 3); fire left ->
         * type 3 rolling LEFT (state 1). */
        pr->vx = (int16_t)(dc > 0 ? 3 : 1);
        pr->vy = (int16_t)(dc > 0 ? 2 : 3);
        soi_pool(w, player)->arrows--;             /* co-op: the team pool (asm FUN_10010d30 uVar1) */
        soi_pool(w, player)->no_weapons_reward = 0;   /* firing forfeits the board's No-Weapons Reward (asm FUN_10010d30 clears +0x42) */
        soi_sfx_emit(w, SOI_SFX_FIRE);
        return;
    }
}

/* Fire the straight shot (asm FUN_100110b4 fire + FUN_1000fd5c mover, +0x54==1): it flies
 * HORIZONTALLY at a fixed height at 4 px/frame, is spent on the first nasty it touches, and
 * vanishes at the first solid block without smashing it. Ammo +0x4a. By its art (weapons
 * f10/f11) and its ammo goody 0x12 (a red arrow) this is the game's ARROW; the port's "ball"
 * name is historical. */
void soi_ball_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (soi_pool(w, player)->balls <= 0 || player_has_projectile(w, player)) return;
    dc = (p->facing >= 0) ? 1 : -1;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1;
        pr->owner  = (uint8_t)player;
        pr->hostile = 0;
        pr->kind = 1;                  /* Magic Ball */
        pr->age = 0;
        pr->y = (p->y & ~31) + 24;     /* same row-snapped height as the other weapon (asm +0x50) */
        pr->x = weapon_spawn_x(w, p->x, dc, pr->y);
        pr->vx = (int16_t)(dc * 4);   /* 4 px/frame horizontal roll (asm) */
        pr->vy = 0;                   /* no gravity: fixed Y */
        soi_pool(w, player)->balls--;              /* co-op: the team pool (asm FUN_100110b4) */
        soi_pool(w, player)->no_weapons_reward = 0;   /* firing forfeits the board's No-Weapons Reward (asm FUN_100110b4 clears +0x42) */
        soi_sfx_emit(w, SOI_SFX_BALL);
        return;
    }
}

/* Terrain probe for the wall-follower ball (asm FUN_1000fd5c cell test): does the
 * pixel (px,py) fall in a SOLID cell? Solidity is the SUPPORTIVE bit ALONE (asm
 * (cell & 0x200), matching FUN_1000554c), so the ball rolls THROUGH goodies/coins
 * (0x9xx) but hugs real blocks. Out-of-bounds reads SOLID (soi_get_cell returns
 * SOI_WALL), so the follower turns at the field border instead of leaving it. Col/
 * row use the asm helpers FUN_1002e6cc/FUN_1002e6f8 = floor((px-16)/32) /
 * floor((py-48)/32) (explicit floor so pixels left/above the field read as OOB). */
static int proj_col(int px){ int c = px - SOI_ORIGIN_X; return (c >= 0) ? c / SOI_CELL_PX : -1 - (-c - 1) / SOI_CELL_PX; }
static int proj_row(int py){ int c = py - SOI_ORIGIN_Y; return (c >= 0) ? c / SOI_CELL_PX : -1 - (-c - 1) / SOI_CELL_PX; }

static int proj_solid(const SoiWorld *w, int px, int py)
{
    return (soi_get_cell(w, proj_col(px), proj_row(py)) & SOI_CELL_SUPPORTIVE) != 0;
}

/* asm FUN_100030ac/30d4: the first entity whose hurtbox overlaps rect (l,t,r,b). Returns its
 * slot, or -1; *killable is 0 for hazards and for a Beanie's bud (both ignore the mark). */
static int weapon_hit(const SoiWorld *w, int l, int t, int r, int b, int *killable)
{
    int i, k, el, et, er, eb;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *e = &w->enemies[i];
        if (!e->active) continue;
        for (k = 0; k < 2; k++) {
            if (!enemy_hurtbox(e, k, &el, &et, &er, &eb)) continue;
            if (t <= eb && et <= b && el <= r && l <= er) {
                *killable = (k == 0) && !enemy_is_hazard(e->type);
                return i;
            }
        }
    }
    return -1;
}

/* Advance projectiles. Behaviours, per the disassembly:
 *  - Player wall-follower BALL (kind 0, friendly; asm FUN_1000fd5c +0x54==2/3): a
 *    4-state TERRAIN FOLLOWER. It travels 2 px/frame hugging the floor/wall it runs
 *    along -- turning DOWN at a convex corner (a cliff edge) and UP into a concave
 *    corner (a wall) -- so it flows around obstacles instead of flying straight off
 *    a ledge. Kills any nasty it overlaps; fizzles after 500 ticks.
 *  - Player MAGIC BALL (kind 1, friendly): rolls straight, kills one nasty, and
 *    stops dead at a block.
 *  - Hostile shot (kind 0, hostile: Cannon/Gargoyle/Knight; asm FUN_1000744c):
 *    flies straight, SMASHES the player's destructible blocks, and hits a player. */
void soi_projectiles_update(SoiWorld *w)
{
    int i, victim;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (!pr->active) continue;

        /* ---- Knight gift (kind 2, asm FUN_1000c544): steps to its target cell and
         * drops the goody there (empty -> collectible, blocked -> gift-block). ---- */
        if (pr->kind == 2 || pr->kind == 3) {
            /* Fly STRAIGHT to the target cell (asm FUN_1000c8bc launches the gift with a
             * sqrt-normalized velocity, FUN_1000c544 adds it each frame -> a straight line).
             * The port keeps the flight on the exact LAUNCH->target line: step 6 px along the
             * dominant axis and derive the minor axis by interpolating from the stored launch
             * point (pr->vx/pr->vy hold the launch pixel position -- a kind-2 gift has no
             * velocity of its own). The earlier "step both axes by d*6/amax" version TRUNCATED
             * the minor step to 0 whenever |minor|*6 < |dominant| (a shallow shot), so the gift
             * ran flat and only snapped at the very end -- a visible bow of up to ~0.8 tile
             * (measured 26 px on a 640:50 delta). Interpolating from the launch line removes
             * that drift: the path never leaves the line by more than a rounding pixel. */
            int lx = pr->vx, ly = pr->vy;                    /* launch pixel position */
            int tx = soi_cell_x((int)pr->tcol), ty = soi_cell_y((int)pr->trow);
            int tdx = tx - lx, tdy = ty - ly;                /* total launch->target delta */
            int atdx = (tdx < 0) ? -tdx : tdx, atdy = (tdy < 0) ? -tdy : tdy;
            int rdx = tx - pr->x, rdy = ty - pr->y;          /* remaining to target */
            int ardx = (rdx < 0) ? -rdx : rdx, ardy = (rdy < 0) ? -rdy : rdy;
            int step = 4;                                    /* gift + egg: 4 px/frame (FUN_1000c8bc / FUN_1000bf54 unit vector) */
            if ((ardx <= step && ardy <= step) || (atdx == 0 && atdy == 0)) {
                pr->x = tx; pr->y = ty;                       /* final approach: snap onto the cell */
            } else if (atdx >= atdy) {                        /* x-dominant (tdx != 0 here) */
                pr->x += (rdx < 0) ? -step : step;
                pr->y = ly + (int)(((int64_t)(pr->x - lx) * tdy) / tdx);
            } else {                                          /* y-dominant (tdy != 0 here) */
                pr->y += (rdy < 0) ? -step : step;
                pr->x = lx + (int)(((int64_t)(pr->y - ly) * tdx) / tdy);
            }
            if ((pr->x == tx && pr->y == ty) || ++pr->age > 300) {
                if (pr->kind == 2) {
                    soi_gift_land(w, (int)pr->tcol, (int)pr->trow, pr->gtype);
                } else {
                    int ci = soi_enemy_spawn(w, (SoiEnemyType)pr->gtype, (int)pr->tcol, (int)pr->trow);
                    if (ci >= 0) {                            /* hatch (FUN_1000b7dc): seek dir, life 400 */
                        int cd = nearest_player_side(w, w->enemies[ci].x);
                        int spd = enemy_speed((int)pr->gtype);
                        w->enemies[ci].dir  = (uint8_t)cd;
                        w->enemies[ci].vx   = (int16_t)((cd == 1) ? -spd : spd);
                        w->enemies[ci].life = 400;
                        if (pr->gtype == SOI_ENEMY_PIGGY) w->enemies[ci].x -= 4;
                    }
                }
                pr->active = 0;
            }
            continue;
        }

        /* ---- Player wall-follower ball (kind 0): the 4-state terrain follower,
         * asm FUN_1000fd5c type +0x54 == 2 (fired right) / 3 (fired left). vx holds
         * the dir-state (+0x52: 1=L/2=U/3=R/4=D), vy the follower type. Each state
         * probes the terrain around the ball and either steps 2 px in its heading or
         * turns 90 deg to stay glued to the surface it runs along -- turning DOWN at
         * a cliff edge (state 3: floor ahead gone but floor behind still solid) and
         * UP into a wall. Reproduced 1:1 with the asm nested probes; proj_solid() is
         * the (cell & 0x200) test with OOB = solid. ---- */
        if (pr->kind == 0 && !pr->hostile) {
            int st   = pr->vx;             /* dir-state 1=L/2=U/3=R/4=D (asm +0x52) */
            int type = pr->vy;             /* 2 = fired-right, 3 = fired-left (asm +0x54) */
            int X = pr->x, Y = pr->y, kl;
            victim = weapon_hit(w, X + 1, Y + 1, X + 0x17, Y + 0x17, &kl);   /* tested before the step */
            if (victim >= 0 && kl) soi_enemy_kill(w, victim, pr->owner);     /* keeps flying */
            if (++pr->age >= 500) { pr->active = 0; continue; }   /* fizzle (asm age +0x56 >= 500) */
            if (type == 2) {
                /* fired RIGHT: asm FUN_1000fd5c type 2 (orig lines 155-401). NOTE the
                 * UP state's middle probe is X+5 (NOT X+0x19 like its siblings) -- a
                 * verified asm asymmetry (orig line 233), the counterpart of type 3
                 * DOWN's Y+0x18. Do NOT "correct" it to match the mirror. */
                if (st == 1) {                                              /* LEFT */
                    if (proj_solid(w, X - 2, Y + 0xc)) st = 4;
                    else if (!proj_solid(w, X + 0x17, Y - 2) && !proj_solid(w, X - 2, Y - 2) && proj_solid(w, X + 0x19, Y - 2)) st = 2;
                    else X -= 2;
                } else if (st == 2) {                                      /* UP */
                    if (proj_solid(w, X + 0xc, Y - 2)) st = 1;
                    else if (!proj_solid(w, X + 0x19, Y + 0x17) && !proj_solid(w, X + 5, Y - 2) && proj_solid(w, X + 0x19, Y + 0x19)) st = 3;
                    else Y -= 2;
                } else if (st == 3) {                                      /* RIGHT */
                    if (proj_solid(w, X + 0x19, Y + 0xc)) st = 2;
                    else if (!proj_solid(w, X, Y + 0x19) && !proj_solid(w, X + 0x19, Y + 0x19) && proj_solid(w, X - 2, Y + 0x19)) st = 4;
                    else X += 2;
                } else {                                                   /* DOWN (st==4) */
                    if (proj_solid(w, X + 0xc, Y + 0x19)) st = 3;
                    else if (!proj_solid(w, X - 2, Y) && !proj_solid(w, X - 2, Y + 0x19) && proj_solid(w, X - 2, Y - 2)) st = 1;
                    else Y += 2;
                }
            } else if (type == 3) {
                /* fired LEFT: asm FUN_1000fd5c type 3 (orig lines 465-711), the mirror
                 * of type 2. NOTE state 4 probes Y+0x18, NOT +0x19 -- a verified asm
                 * asymmetry (orig lines 653 & 665). */
                if (st == 1) {                                              /* LEFT */
                    if (proj_solid(w, X - 2, Y + 0xc)) st = 2;
                    else if (!proj_solid(w, X + 0x17, Y + 0x19) && !proj_solid(w, X - 2, Y + 0x19) && proj_solid(w, X + 0x19, Y + 0x19)) st = 4;
                    else X -= 2;
                } else if (st == 2) {                                      /* UP */
                    if (proj_solid(w, X + 0xc, Y - 2)) st = 3;
                    else if (!proj_solid(w, X - 2, Y + 0x17) && !proj_solid(w, X - 2, Y - 2) && proj_solid(w, X - 2, Y + 0x19)) st = 1;
                    else Y -= 2;
                } else if (st == 3) {                                      /* RIGHT */
                    if (proj_solid(w, X + 0x19, Y + 0xc)) st = 4;
                    else if (!proj_solid(w, X, Y - 2) && !proj_solid(w, X + 0x19, Y - 2) && proj_solid(w, X - 2, Y - 2)) st = 2;
                    else X += 2;
                } else {                                                   /* DOWN (st==4) */
                    if (proj_solid(w, X + 0xc, Y + 0x18)) st = 1;
                    else if (!proj_solid(w, X + 0x19, Y) && !proj_solid(w, X + 0x19, Y + 0x18) && proj_solid(w, X + 0x19, Y - 2)) st = 3;
                    else Y += 2;
                }
            }
            pr->x = X; pr->y = Y; pr->vx = (int16_t)st;
            continue;
        }

        /* ---- Magic Ball: rolls horizontally, STOPS DEAD *flush* at the first
         * solid block (asm FUN_1000fd5c). Test the LEADING edge (centre +/- a
         * half cell) rather than the top-left corner, so it comes to rest beside
         * the wall instead of rolling its body a half-cell into it (the visible
         * "clips through the wall" glitch). ---- */
        if (pr->kind == 1) {
            /* asm FUN_1000fd5c +0x54==1: hit-test (x, y+1)-(x+0xf, y+5); any overlap spends the
             * ball (a hazard or bud survives). Unspent and with a clear cell at (x+0x18 | x, y+3)
             * it rolls 4 px, else it is erased where it stands. */
            int kl, spent = 0;
            victim = weapon_hit(w, pr->x, pr->y + 1, pr->x + 0x0f, pr->y + 5, &kl);
            if (victim >= 0) {
                if (kl) soi_enemy_kill(w, victim, pr->owner);
                spent = 1;
            }
            if (!spent && !proj_solid(w, pr->x + ((pr->vx > 0) ? 0x18 : 0), pr->y + 3))
                pr->x += (pr->vx > 0) ? 4 : -4;
            else
                pr->active = 0;
            continue;
        }

        /* ---- Gargoyle PUFF (asm type 0x72, mover FUN_1000b0a4): flies until a SOLID (0x200)
         * cell touches one of three probes (sprite-relative (6,2) (0x13,0x13) (5,0x13); the
         * 24x24 sprite sits +4 inside the port's cell-aligned position). A breakable block is
         * smashed (a non-piercing puff dies on it); a permanent block stops it UNLESS its low
         * byte is 0x8b -- the Gargoyle cage blocks, which its puffs pass straight through.
         * No range limit. It hits a player by the enemy-contact boxes (FUN_100299b4: the puff
         * is an enemy entity, collision box sprite+2..+0x14). ---- */
        if (pr->src_type == SOI_ENEMY_GARGOYLE) {
            static const int8_t probe[3][2] = { { 10, 6 }, { 0x17, 0x17 }, { 9, 0x17 } };
            int k, dead = 0, pj;
            pr->x += pr->vx;
            pr->y += pr->vy;
            for (k = 0; k < 3; k++) {
                int px = pr->x + probe[k][0] - SOI_ORIGIN_X, py = pr->y + probe[k][1] - SOI_ORIGIN_Y;
                int pc = (px >= 0) ? px / SOI_CELL_PX : -1, prw = (py >= 0) ? py / SOI_CELL_PX : -1;
                uint32_t cell = soi_get_cell(w, pc, prw);
                if (!(cell & SOI_CELL_SUPPORTIVE)) continue;
                if (!(cell & SOI_CELL_PERMANENT)) {
                    if (SOI_CELL_TYPE(cell) != 0) {
                        /* FUN_10027c34: the quarters fly on along the puff's own heading
                         * (its velocity x10 in the 1/10-px particle units) */
                        soi_block_shatter(w, pc, prw, SOI_SHATTER_DIR, pr->vx * 10, pr->vy * 10);
                        soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
                    }
                    if (!pr->pierce) dead = 1;
                } else if (SOI_CELL_TYPE(cell) != 0x8b) {
                    dead = 1;
                }
            }
            if (dead) { pr->active = 0; continue; }
            for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
                SoiPlayer *p = &w->players[pj];
                int pb;
                if (!p->active || !p->alive) continue;
                pb = p->y + (p->ground_state == SOI_ST_JUMP ? 0x19 : 0x1d);
                if (p->x + 0x0d <= pr->x + 0x18 && pr->x + 6 <= p->x + 0x12 &&
                    p->y + 4 <= pr->y + 0x18 && pr->y + 6 <= pb)
                    soi_player_hit(w, pj);             /* the puff keeps flying (FUN_100299b4) */
            }
            continue;
        }

        /* ---- Cannon ball (0x65, FUN_1000744c) / Walker bolt (0x68, FUN_1000e3c0): 4 px a frame
         * (the ball waits 2 frames first); it dies on the first solid cell at (x+0x10|x-1, y+8),
         * smashing it if breakable, and kills a player by box (FUN_100299b4) without stopping. ---- */
        {
            const int right = pr->vx > 0, ball = (pr->src_type == SOI_ENEMY_CANNON);
            int c, r, pj, bl, br;
            uint32_t cell;
            if (ball && pr->age < 2) { pr->age++; continue; }
            pr->x += right ? 4 : -4;
            cell = cell_at_px(w, pr->x + (right ? 0x10 : -1), pr->y + 8, &c, &r);
            if (cell & SOI_CELL_SUPPORTIVE) {
                if (cell_breakable(cell)) {
                    /* FUN_1000744c / FUN_1000e3c0 -> FUN_10027d84 (right) / FUN_10027ecc (left):
                     * the block is blasted apart in the shot's direction */
                    soi_block_shatter(w, c, r, right ? SOI_SHATTER_RIGHT : SOI_SHATTER_LEFT, 0, 0);
                    soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
                }
                pr->active = 0;
                continue;
            }
            bl = pr->x + (ball ? 2 : 4); br = pr->x + (ball ? 0x0e : 0x10);
            for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
                SoiPlayer *p = &w->players[pj];
                int pb;
                if (!p->active || !p->alive) continue;
                pb = p->y + (p->ground_state == SOI_ST_JUMP ? 0x19 : 0x1d);
                if (p->x + 0x0d <= br && bl <= p->x + 0x12 && p->y + 4 <= pr->y + 0x0e && pr->y + 2 <= pb)
                    soi_player_hit(w, pj);
            }
        }
    }
}
