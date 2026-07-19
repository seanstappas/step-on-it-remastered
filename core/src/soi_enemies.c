/* soi_enemies.c — enemy entities: the bestiary point table (partly CONFIRMED — see
 * soi_enemy_points), spawn,
 * a walk-and-turn update (the CONFIRMED baseline for the simple types), and
 * kill->score. Per-type AI is ported and asm-verified: Hammer jump-smash
 * (FUN_10007998), Beanie split (parent<->child bookkeeping), Robo/Walker
 * multi-state incl. edge-turner fall-death (FUN_1000a780/FUN_1000dd4c), and
 * Wheelie 8-dir wall-follow (FUN_10009e98, player-INDEPENDENT — no seek).
 * Remaining gaps are cosmetic/tuning only (see plan/REMAINING_WORK.md §C/§D2).
 * (docs runtime-structures §3/§11.)
 */
#include "soi_internal.h"

static int enemy_speed(int type);   /* per-type base speed (defined below) */

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
        return i;                      /* slot index so the caller can tweak dir/vx */
    }
    return -1;
}

/* Beanie bookkeeping (asm FUN_10006d44:40 / FUN_10006f6c:40,56): when a bud LEAVES
 * -- its transient life expires OR a player defeats it -- the parent's one-bud slot
 * (+0x7a) is cleared so the parent may bud again. There is NO cascade: defeating a
 * beanie never kills its parent or child (verified -- none of FUN_10006378/10006840/
 * FUN_10006d44/FUN_10006f6c touch another enemy's active flag on removal). */
static void beanie_orphan(SoiWorld *w, int slot)
{
    int p;
    for (p = 0; p < SOI_MAX_ENEMIES; p++)
        if (w->enemies[p].child == (uint8_t)(slot + 1)) { w->enemies[p].child = 0; break; }
}

void soi_enemy_kill(SoiWorld *w, int idx, int by_player)
{
    SoiEnemy *e;
    if (idx < 0 || idx >= SOI_MAX_ENEMIES) return;
    e = &w->enemies[idx];
    if (!e->active) return;
    if (by_player >= 0 && by_player < SOI_MAX_PLAYERS)
        w->players[by_player].score += e->points;   /* award (+0x42 -> +0x3c) */
    e->active = 0;
    if (e->type == SOI_ENEMY_BEANIE) beanie_orphan(w, idx);  /* free the parent's bud slot */
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
    /* No score/chain bookkeeping remains here: the asm has NO cascade kill, and a beanie
     * bud frees its parent's slot via beanie_orphan (above). */
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
        case SOI_ENEMY_OSTRICH:
        case SOI_ENEMY_WHEELIE:
        case SOI_ENEMY_WALKER:
        case SOI_ENEMY_TEETH:   return 3;
        case SOI_ENEMY_CANNON:
        case SOI_ENEMY_SPINNER:
        case SOI_ENEMY_GARGOYLE:  /* stationary shooter (asm FUN_1000adc4, bord 14) */
        case SOI_ENEMY_KNIGHT:    /* stationary shooter (asm FUN_1000c2e8, bord 13) */
        case SOI_ENEMY_CREEPER:   /* self-propelled; steps in enemy_creeper(), not via vx */
            return 0;    /* stationary hazards (spin/fire in place; never move their own pos) */
        default:                return 2;
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
 * e->under is the once-only "mode initialised" sentinel (0 at spawn). */
static void enemy_fly_bounce(SoiWorld *w, SoiEnemy *e)
{
    const int s = 2;
    int mode;
    if (!e->under) {                       /* lock handedness after the loader picks dir */
        e->state = (uint8_t)((e->dir == 1 || e->dir == 8) ? 1 : 2);
        e->under = 1;
    }
    mode = e->state;

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
    int col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    int row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    int ahead;
    if (e->fire_cd != 0) {                               /* mid jump-smash: hold, strike, drop */
        int brow = (e->y + 11 - SOI_ORIGIN_Y) / SOI_CELL_PX;   /* body row (un-lift the 11px hop) */
        int a = (e->dir == 2) ? col + 1 : col - 1;
        e->fire_cd++;
        if (e->fire_cd == 11) {                          /* asm strike frame 0x4b/0x3b */
            uint32_t fc = soi_get_cell(w, a, brow);
            if (soi_in_bounds(a, brow) && (fc & SOI_CELL_SUPPORTIVE) &&
                !(fc & SOI_CELL_PERMANENT) && SOI_CELL_TYPE(fc) != 0) {
                soi_set_cell(w, a, brow, (fc & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(fc) : 0u);
                soi_sfx_emit(w, SOI_SFX_ROBO_PUNCH);     /* asm sound event 0x11 (Metal) */
            }
        }
        if (e->fire_cd > 16) {                           /* asm +0x6e wraps past 0x50/0x40 */
            e->y = (int16_t)(e->y + 11);                 /* drop back down (asm +0x5a += 0xb) */
            e->fire_cd = 0;                              /* resume walking */
        }
        return;                                          /* hold x through the swing */
    }
    if (!(soi_get_cell(w, col, row + 1) & SOI_CELL_SUPPORTIVE)) { e->y += 4; return; }  /* fall off a ledge */
    ahead = (e->dir == 2) ? col + 1 : col - 1;
    if (!soi_in_bounds(ahead, row)) {
        e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);       /* turn at the edge */
        e->vx  = (int16_t)-e->vx;
        return;
    }
    {
        uint32_t fc = soi_get_cell(w, ahead, row);
        if (fc & SOI_CELL_SUPPORTIVE) {
            if (fc & SOI_CELL_PERMANENT) {               /* permanent wall -> turn */
                e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);
                e->vx  = (int16_t)-e->vx;
                return;
            }
            if (SOI_CELL_TYPE(fc) != 0) {                /* breakable wall -> begin the jump-smash */
                e->y = (int16_t)(e->y - 11);             /* the rise (asm +0x5a -= 0xb) */
                e->fire_cd = 1;                          /* enter the hold/strike/drop phase */
                return;
            }
        }
    }
    e->x += (e->dir == 2) ? 2 : -2;                      /* walk flat (asm +0x10 += 2) */
}

/* Creeper (asm FUN_10008618 horizontal / FUN_10008b18 vertical; bord types 16/17):
 * a self-propelled "bigger mblock" (sssf 1016) that steps one cell at a time along
 * its axis (state 0 = horizontal, 1 = vertical), reversing at a wall or edge. It
 * carries NO projectile. While active it TEMP-SOLIDIFIES the cell it occupies (asm
 * lays cell|0x300) so it is a moving SOLID block (stand on / blocked -- NOT a touch
 * hazard). It steps onto any NON-SOLID cell (empty, 0x197 background, &c -- asm
 * FUN_10009030), remembering the covered tile in `under` (asm +0x70) and restoring
 * it exactly on leaving, so nothing is erased; it never steps onto a player.
 * fire_cd = step countdown, fire_period = interval (board StartDelay byte; the asm's
 * exact multi-counter cadence at +0x24/+0x26 is approximated here as a single timer).
 *
 * FAITHFULNESS (fully decoded vs asm FUN_10008618 horizontal / FUN_10008b18 vertical):
 * the original is NOT one persistent block -- each segment carries a grow timer
 * +0x6e (= StartDelay*3) and a sprite grow/shrink counter +0x56 (cap 0xf). When the
 * grow timer expires the segment probes the cell ahead (FUN_1000554c solid? +
 * FUN_10004650 / FUN_10009030 passable?) and, if clear, SPAWNS ONE CHILD one cell
 * ahead (FUN_10005948, x/y +0x20) then enters a shrink phase that RESTORES its covered
 * tile (+0x70 via FUN_10005630) and self-removes; if blocked it just reverses
 * (state/dir flips: h 1<->2, v 8<->9). So a Creeper is a TRANSIENT forward-creeping
 * BAND whose tail dissolves (restoring tiles) as the head advances -- it never
 * permanently seals a route. Its band WIDTH depends on StartDelay (small delay =>
 * child spawns before parent dissolves => a few overlapping cells).
 *
 * PORT MODEL -- ONE moving solid block that restores what it covers. This reproduces
 * the creeper's observable solid-footprint MOTION (a solid that creeps forward and
 * frees the tile behind it, reversing when blocked) and is provably leak-free: every
 * move restores the old cell before solidifying the new one. It is winnability-SAFE.
 * The full child-spawn band is deliberately NOT ported, for two concrete reasons:
 *   1. The winnable harness (tools/verify_winnable.c) is a STATIC key->door topology
 *      check that never steps enemies, so it CANNOT validate any creeper behavior --
 *      shipping the multi-segment chain would keep the gate green with zero assurance.
 *   2. A multi-segment chain (per-segment slot alloc + restore-on-remove) adds real
 *      risk of a tile-restore bug that PERMANENTLY solidifies a cell -> an unwinnable
 *      board that no gate would catch. The only unshipped gap is cosmetic: the band's
 *      1-2 cell visual width and the sprite grow/shrink animation. */
static void enemy_creeper(SoiWorld *w, SoiEnemy *e)
{
    int col, row, ac, ar, pj, blocked;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    /* invariant: our cell is solid; on first touch capture what we cover (asm +0x70). */
    if (!(soi_get_cell(w, col, row) & SOI_CELL_SUPPORTIVE)) {
        e->under = soi_get_cell(w, col, row);
        soi_set_cell(w, col, row, SOI_WALL);
    }
    if (e->fire_cd > 0) { e->fire_cd--; return; }        /* wait out the step interval */
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : 24;
    ac = col + ((e->state == 0) ? ((e->dir == 2) ? 1 : -1) : 0);   /* horizontal step */
    ar = row + ((e->state == 1) ? ((e->dir == 2) ? 1 : -1) : 0);   /* vertical step */
    /* blocked by an edge, a SOLID (0x200) cell, or a standing player -- else it may
     * cross empty / background / non-solid tiles (asm FUN_10009030). */
    blocked = (!soi_in_bounds(ac, ar) || (soi_get_cell(w, ac, ar) & SOI_CELL_SUPPORTIVE));
    for (pj = 1; !blocked && pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        if (p->active && p->alive &&
            (p->x - SOI_ORIGIN_X) / SOI_CELL_PX == ac &&
            (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX == ar) blocked = 1;
    }
    if (blocked) { e->dir = (uint8_t)((e->dir == 2) ? 1 : 2); return; }  /* reverse */
    soi_set_cell(w, col, row, e->under);                 /* restore what we covered (asm +0x70) */
    e->under = soi_get_cell(w, ac, ar);                  /* capture the cell we move onto */
    e->x = soi_cell_x(ac);
    e->y = soi_cell_y(ar);
    soi_set_cell(w, ac, ar, SOI_WALL);                   /* temp-solidify (covered by the sprite) */
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

static void enemy_step(SoiWorld *w, SoiEnemy *e)
{
    int col, row, ahead, spd = enemy_speed(e->type);

    e->anim++;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;

    /* Wheelie: a gravity-free flyer that bounces by wall-collision (no homing). */
    if (e->type == SOI_ENEMY_WHEELIE) { enemy_fly_bounce(w, e); return; }
    /* Hammer: a WALKER that jump-smashes breakable walls (enemy_hammer_hop). A Hammer
     * SPAWNER (spawn_child set) stays put and emits, so only real Hammers are routed here. */
    if (e->type == SOI_ENEMY_HAMMER && e->spawn_child == 0) { enemy_hammer_hop(w, e); return; }
    /* Creeper: self-propelled block that steps cell-to-cell; gravity-free. */
    if (e->type == SOI_ENEMY_CREEPER) { enemy_creeper(w, e); return; }
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
        int lc = (e->x + 6 - SOI_ORIGIN_X) / SOI_CELL_PX;               /* left foot  (asm inset +6)      */
        int rc = (e->x + 0x1a - SOI_ORIGIN_X) / SOI_CELL_PX;            /* right foot (asm inset +0x1a=26) */
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
            }
            return;
        }
    }

    /* The Robo PUNCHES through a breakable block (asm state +0x6e): it stands and
     * swings, smashes the block mid-animation (FUN_10027d84 clears the cell +
     * flings debris), then walks on. fire_cd (idle for the Robo otherwise) carries
     * the swing countdown. */
    if (e->type == SOI_ENEMY_ROBO && e->fire_cd > 0) {
        e->fire_cd--;
        if (e->fire_cd == 8) {                            /* mid-swing: smash the block ahead */
            int a = (e->dir == 2) ? col + 1 : col - 1;
            uint32_t bc = soi_get_cell(w, a, row);
            if (soi_in_bounds(a, row) && !(bc & SOI_CELL_PERMANENT) && SOI_CELL_TYPE(bc) != 0) {
                soi_set_cell(w, a, row,
                             (bc & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(bc) : 0u);
                soi_sfx_emit(w, SOI_SFX_ROBO_PUNCH);      /* asm event 0x11 -> 15960 "Metal" */
            }
        }
        return;                                           /* hold position through the swing */
    }

    /* The Walker (asm FUN_1000dd4c) PATROLS: it walks in its facing direction and
     * turns at BOTH a wall ahead AND a ledge ahead (a foot-level ground probe). It
     * does not move TOWARD the player, but it DOES fire a bolt when a player is on
     * its row (enemy_walker_fire). The Robo (FUN_1000a780) likewise reverses at a
     * ledge (below). Ant/Ostrich turn at ANY wall and walk off ledges; Hippo/Piggy/
     * Smiley/Teeth instead PLOW THROUGH breakable walls (FUN_100279c4, above) and
     * only turn at permanent walls. */
    if (e->type == SOI_ENEMY_WALKER)
        e->vx = (int16_t)((e->dir == 2) ? spd : -spd);

    e->x += e->vx;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    /* Probe the LEADING foot, not a symmetric cell offset. The asm foot probes are
     * asymmetric because a nasty's x is its LEFT edge: the walker (FUN_1000dd4c)
     * probes x+0x22 heading right and x+2 heading left; the robo (FUN_1000a780)
     * x+0x1c / x+4. The port used col+-1 off the left-edge cell, so heading LEFT it
     * probed col-1 -- a full cell PAST the left foot -- and every ledge/wall-turning
     * nasty reversed one cell early, never reaching the left platform edge. Heading
     * RIGHT, +0x20 reproduces the old col+1 exactly (rightward patrol unchanged);
     * heading LEFT, +2 tracks the real left foot (asm x+2/x+4). VERIFIED 2026-07-06. */
    ahead = e->x + ((e->dir == 2) ? 0x20 : 2) - SOI_ORIGIN_X;
    ahead = (ahead >= 0) ? (ahead / SOI_CELL_PX) : -1;   /* floor at the LEFT field edge so a
                                                          * leftward nasty turns at the border
                                                          * instead of drifting off-screen (int
                                                          * division truncates toward 0, which
                                                          * otherwise pins ahead at col 0). */

    /* reverse when the next cell is a SOLID block or out of bounds. Only the
     * SUPPORTIVE bit (0x200, standable walls/blocks) blocks a nasty; coins and
     * other goodies (0x8xx) and background (0x197) are walked straight through.
     * The WALKER (FUN_1000dd4c) and ROBO (FUN_1000a780) also reverse at a LEDGE --
     * no ground in the cell ahead-and-below (foot probes FUN_1000554c: walker
     * (x+0x22,y+0x1a), robo (x+0x1c,y+0x1f)) -- so they PATROL the platform rather
     * than walk off it. The Robo does NOT climb: at a wall its asm response is a
     * PUNCH (breakable block -> FUN_10027d84 clears the cell + flings debris, sfx
     * 0x11) or a TURN (permanent wall) -- never a climb (the +0x6e state never
     * changes x/y). A breakable block ahead winds up the punch (which lands
     * mid-swing above); a permanent wall or a ledge turns it. */
    if ((e->type == SOI_ENEMY_HIPPO || e->type == SOI_ENEMY_PIGGY ||
         e->type == SOI_ENEMY_TEETH) &&
        soi_in_bounds(ahead, row) &&
        (soi_get_cell(w, ahead, row) & SOI_CELL_SUPPORTIVE) &&
        !(soi_get_cell(w, ahead, row) & SOI_CELL_PERMANENT) &&
        SOI_CELL_TYPE(soi_get_cell(w, ahead, row)) != 0) {
        /* Hippo/Piggy/Teeth PLOW through a breakable block (asm FUN_100279c4,
         * confirmed in FUN_100081f8/9a78/d8c4): clear it (revealing any 0x1000
         * payload) and keep walking -- they do NOT turn at a destructible block the
         * way ant/ostrich do. A permanent wall still turns them (below). The break is
         * SILENT: the asm plow-clear FUN_100279c4 -> FUN_1002754c emits NO sound; each
         * plow nasty's only FUN_1002b020 call is its DEATH cry, gated on the +0x88
         * "claimed" field. (bord 67: pigs break blocks silently.) NOTE: Hippo/Piggy
         * actually CHOMP-then-REVERSE in the asm (states +0x4c 5/6); the faithful
         * chomp delay is tracked separately -- for now they plow like Teeth. */
        uint32_t bc = soi_get_cell(w, ahead, row);
        soi_set_cell(w, ahead, row, (bc & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(bc) : 0u);
    } else if (e->type == SOI_ENEMY_SMILEY &&
        soi_in_bounds(ahead, row) &&
        (soi_get_cell(w, ahead, row) & SOI_CELL_SUPPORTIVE) &&
        !(soi_get_cell(w, ahead, row) & SOI_CELL_PERMANENT) &&
        SOI_CELL_TYPE(soi_get_cell(w, ahead, row)) != 0) {
        /* Smiley (faceball, bord 36, asm FUN_1000d130): does NOT plow. At a breakable
         * block it breaks it SILENTLY (FUN_100279c4), then REVERSES IMMEDIATELY (the
         * asm sets +0x4c to the opposite heading -- no chomp state). A permanent wall
         * reverses it via the generic turn below. (bord 36: faceballs flip to the
         * other side when they hit/break a block, and make no sound.) */
        uint32_t bc = soi_get_cell(w, ahead, row);
        soi_set_cell(w, ahead, row, (bc & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(bc) : 0u);
        e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);
        e->vx  = (int16_t)-e->vx;
    } else if (e->type == SOI_ENEMY_ROBO && soi_in_bounds(ahead, row) &&
        (soi_get_cell(w, ahead, row) & SOI_CELL_SUPPORTIVE) &&
        !(soi_get_cell(w, ahead, row) & SOI_CELL_PERMANENT) &&
        SOI_CELL_TYPE(soi_get_cell(w, ahead, row)) != 0) {
        e->fire_cd = 16;                     /* breakable block ahead -> punch, don't turn */
    } else if (!soi_in_bounds(ahead, row) ||
        (soi_get_cell(w, ahead, row) & SOI_CELL_SUPPORTIVE) ||
        ((e->type == SOI_ENEMY_WALKER || e->type == SOI_ENEMY_ROBO) &&
         !(soi_get_cell(w, ahead, row + 1) & SOI_CELL_SUPPORTIVE))) {
        /* Beanie: when a wall blocks it, it BUDS one child (FUN_10006378) -- at
         * most one living bud at a time -- then turns back. Buds are transient and
         * do not themselves bud (life > 0). */
        if (e->type == SOI_ENEMY_BEANIE && e->life == 0 &&
            (e->child == 0 || !w->enemies[e->child - 1].active ||
             w->enemies[e->child - 1].type != SOI_ENEMY_BEANIE)) {
            int bi = soi_enemy_spawn(w, SOI_ENEMY_BEANIE, col, row);
            if (bi >= 0) {
                w->enemies[bi].dir  = (uint8_t)((e->dir == 2) ? 1 : 2);
                w->enemies[bi].vx   = (int16_t)-e->vx;
                w->enemies[bi].life = 480;   /* transient bud */
                e->child = (uint8_t)(bi + 1);
            }
        }
        e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);
        e->vx  = (int16_t)-e->vx;
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
        pr->x = e->x + dc * 0x20;      /* one cell ahead in facing */
        pr->y = e->y;
        pr->vx = (int16_t)(dc * 4);    /* 4 px/frame (asm 0x65 mover FUN_1000744c: +0x10 +/- 4) */
        pr->vy = 0;
        soi_sfx_emit(w, SOI_SFX_CANNON_FIRE);   /* asm event 0x10 -> 12863 "Flens" (not the arrow) */
        return;
    }
}

/* Gargoyle (bord 14, asm FUN_1000adc4): a STATIONARY 3-phase turret that fires a puff
 * AIMED at the nearest live player. The asm puff FUN_1000b44c (type 0x72) picks the live
 * player (globals 0x3be2/0 = P1, 0x3be6/4 = P2; a coord > 0x3e8 = dead sentinel) and sets
 * a NORMALIZED velocity toward them ((dx<<0xc)/dist, (dy<<0xc)/dist) -- so it tracks a
 * DIAGONAL player, not just H/V. pct_ultrabuster%% of shots are instead the 0xc8
 * UltraBuster (FUN_1000bf54). We reproduce the aim with the dominant axis at the confirmed
 * 4 px/frame + a proportional minor axis (integer approx of the normalized vector). (The
 * Knight, bord 13, drops gifts instead -- enemy_knight_gift.) */
static void enemy_shooter_fire(SoiWorld *w, SoiEnemy *e)
{
    int i, pj, tx = 0, ty = 0, bestd = 1 << 30, found = 0;
    int dx, dy, adx, ady, vx = 0, vy = 0, sx = 0, sy = 0;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
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
                                           /* UltraBuster (asm FUN_1000bf54): pct_ultrabuster%% of shots */
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

/* Seek-player spawner (asm mode 4, FUN_100054a4): pick the horizontal direction
 * toward the nearest live player (1 = left, 2 = right; defaults right if none). */
static int spawner_seek_dir(const SoiWorld *w, int col)
{
    int pj, bestd = 1 << 30, dir = 2;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int pc, d;
        if (!p->active || !p->alive) continue;
        pc = (p->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        d  = (pc < col) ? col - pc : pc - col;
        if (d < bestd) { bestd = d; dir = (pc < col) ? 1 : 2; }
    }
    return dir;
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
    if (e->state == 4) {                         /* seek the nearest player */
        cdir = spawner_seek_dir(w, col);
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
 * SIMPLIFICATION: FUN_1000e5c8 ALSO returns 1 when a destructible block sits within
 * ~4 cells ahead (so the original Walker preemptively blasts a wall in its path). We
 * fire ONLY on player-on-row to avoid the order-sensitive tangle with enemy_step's
 * turn-at-wall (which runs first and could flip our facing before this fires). */
static void enemy_walker_fire(SoiWorld *w, SoiEnemy *e)
{
    int i, pj, dc, aligned = 0;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int dy;
        if (!p->active || !p->alive || p->eliminated) continue;
        dy = p->y - e->y; if (dy < 0) dy = -dy;
        if (dy < 0x20) { aligned = 1; break; }   /* a player is on the Walker's row */
    }
    if (!aligned) return;
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : 96;   /* reload = StartDelay*4 (asm +0x6e), else slow */
    dc = (e->dir == 2) ? 1 : -1;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1; pr->owner = 0; pr->hostile = 1;
        pr->src_type = (uint8_t)SOI_ENEMY_WALKER; pr->kind = 0; pr->pierce = 0; pr->age = 0;
        pr->x = e->x + dc * 0x20; pr->y = e->y;
        pr->vx = (int16_t)(dc * 4); pr->vy = 0;    /* 4 px/frame (asm 0x68 UltraBuster FUN_1000e3c0: +0x10 +/- 4) */
        soi_sfx_emit(w, SOI_SFX_WALKER_FIRE);      /* asm event 0x13 -> snd 2689 "Strings" (NOT the cannon Flens) */
        return;
    }
}

void soi_enemies_update(SoiWorld *w)
{
    int i, pj;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        SoiEnemy *e = &w->enemies[i];
        if (!e->active) continue;
        /* Shoes/Turtles (+0x88): a claimed nasty self-destructs on its next
         * update, crediting the collecting player (FUN_1000543c marks every
         * real nasty; each one's own update awards +0x8a at its next anim
         * boundary). All of our spawned enemies are real nasties, so a claim
         * defeats them the way the goody does in the original. */
        if (e->claimed) {
            /* Thunderballs claim only real nasties; the hazard types (turrets, Creeper)
             * never read +0x40 in the asm, so a claim cannot defeat them. */
            if (!enemy_is_hazard(e->type)) { soi_enemy_kill(w, i, e->claimed); continue; }
            e->claimed = 0;
        }
        if (e->life > 0 && --e->life == 0) {             /* transient child expired */
            e->active = 0;
            if (e->type == SOI_ENEMY_BEANIE) beanie_orphan(w, i);  /* free the parent's bud slot */
            continue;
        }
        enemy_step(w, e);
        if (!e->active) continue;   /* enemy_step may kill it (edge-turner fall death); skip the rest */
        if (e->type == SOI_ENEMY_CANNON)
            enemy_cannon_fire(w, e);                /* stationary shooter (FUN_100071a0) */
        if (e->type == SOI_ENEMY_GARGOYLE)
            enemy_shooter_fire(w, e);               /* aimed puff; pierce/break by pct_ultrabuster */
        if (e->type == SOI_ENEMY_KNIGHT)
            enemy_knight_gift(w, e);                /* drops a random gift (FUN_1000c2e8) */
        if (e->type == SOI_ENEMY_WALKER)
            enemy_walker_fire(w, e);                /* fires a bolt when a player is on its row (FUN_1000e5c8/e7c8) */
        if (e->spawn_child)
            enemy_spawner_emit(w, i);               /* persistent spawner (FUN_100076a8 &c) */
        /* player contact: touching an enemy kills the player (first draft). The
         * Creeper is a solid moving BLOCK (it solidifies its cell), not a touch
         * hazard, so it is exempt. */
        for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
            SoiPlayer *p = &w->players[pj];
            int pl, pt, prt, pb, el, et, er, eb;
            if (!p->active || !p->alive || e->type == SOI_ENEMY_CREEPER) continue;
            /* Real player<->enemy contact is an AABB overlap of two INSET hurtboxes
             * (asm FUN_100299b4 -> FUN_100030d4), NOT a coarse "same grid cell" test.
             * The player box is a narrow central strip [x+0xd, x+0x12] x [y+4, y+(0x19
             * while JUMPING else 0x1d)]; the enemy box is [x+9, x+0x19] x [y+6, y+0x1e]
             * (Robo's, asm FUN_1000a780 +0x82/0x84/0x80/0x7e -- reused for every type as
             * a faithful representative, and far tighter than a whole cell). The short
             * 0x19 box is JUMP-only: asm FUN_100299b4 picks it solely when the motion
             * state field == 2 (JUMP per FUN_10013404); FALL (state 3) and grounded both
             * use the tall 0x1d box, so only a rising jump gets the shorter hurtbox.
             * Cell-equality wrongly killed a player who was safely on a DIFFERENT block
             * while a nasty fell THROUGH his column (bug: "he killed me while falling
             * even though I was on another block"). */
            pl = p->x + 0x0d; prt = p->x + 0x12;
            pt = p->y + 0x04; pb = p->y + (p->ground_state == SOI_ST_JUMP ? 0x19 : 0x1d);
            el = e->x + 0x09; er = e->x + 0x19;
            et = e->y + 0x06; eb = e->y + 0x1e;
            if (pl <= er && el <= prt && pt <= eb && et <= pb) {
                soi_player_hit(w, pj);   /* -> death-throw somersault; life-loss + respawn
                                          * commit in air_step (VERIFIED complete, not a TODO) */
            }
        }
    }
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

/* Fire a Magic Arrow in the player's facing direction (CONFIRMED: the Arrow
 * travels in a straight line, then RICOCHETS off blocks, and kills nasties).
 * Consumes one arrow. The asm allows only ONE live projectile per player at a
 * time (player_has_projectile). Speed = 2 px/frame (VERIFIED asm FUN_1000fd5c
 * ricochet state +0x54==2/3: x +/-= 2 each frame). */
void soi_projectile_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (p->arrows <= 0 || player_has_projectile(w, player)) return;
    dc = (p->facing >= 0) ? 1 : -1;   /* Magic Arrow: fired horizontally, then ricochets */
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1;
        pr->owner  = (uint8_t)player;
        pr->hostile = 0;
        pr->kind = 0;                  /* Magic Arrow */
        pr->age = 0;
        pr->x = p->x + (dc > 0 ? 0x14 : -0xe);  /* asm FUN_10010d30: +20px right / -14px left of the firer */
        pr->y = p->y;
        pr->vx = (int16_t)(dc * 2);   /* 2 px/frame (asm); it ricochets off blocks */
        pr->vy = 0;
        p->arrows--;
        p->no_weapons_reward = 0;   /* firing forfeits the board's No-Weapons Reward (asm FUN_10010d30 clears +0x42) */
        soi_sfx_emit(w, SOI_SFX_FIRE);
        return;
    }
}

/* Fire a Magic Ball in the player's facing direction. CONFIRMED (asm FUN_100110b4
 * fire + FUN_1000fd5c mover, +0x54==1): the ball rolls HORIZONTALLY at a fixed
 * height (no gravity), kills any nasty it rolls over, and STOPS DEAD at the first
 * solid block (it does NOT smash blocks like the Arrow does). Uses a separate ball
 * ammo pool (+0x4a). Speed = 4 px/frame (VERIFIED asm FUN_1000fd5c state +0x54==1: x += 4
 * each frame) -- FASTER than the 2 px/frame Arrow. (The "0xa" near this code in the asm is a
 * FUN_100043a0 draw-LAYER arg, not a step; ball 4 / arrow 2 are the real asm speeds.) */
void soi_ball_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (p->balls <= 0 || player_has_projectile(w, player)) return;
    dc = (p->facing >= 0) ? 1 : -1;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1;
        pr->owner  = (uint8_t)player;
        pr->hostile = 0;
        pr->kind = 1;                  /* Magic Ball */
        pr->age = 0;
        pr->x = p->x + (dc > 0 ? 0x14 : -0xe);  /* asm FUN_100110b4: +20px right / -14px left of the firer */
        pr->y = p->y;                  /* rolls at the height it was fired (asm: fixed Y) */
        pr->vx = (int16_t)(dc * 4);   /* 4 px/frame horizontal roll (asm) */
        pr->vy = 0;                   /* no gravity: fixed Y */
        p->balls--;
        p->no_weapons_reward = 0;   /* firing forfeits the board's No-Weapons Reward (asm FUN_100110b4 clears +0x42) */
        soi_sfx_emit(w, SOI_SFX_BALL);
        return;
    }
}

/* Advance projectiles. Three behaviours, per the disassembly:
 *  - Player MAGIC ARROW (kind 0, friendly; asm FUN_1000fd5c +0x54==2/3): a
 *    4-direction RICOCHET. It travels 2 px/frame and, on reaching a solid block,
 *    turns 90 deg (following the wall) rather than smashing it; it kills any nasty
 *    it passes through (and keeps going) and fizzles after ~500 ticks. The exact
 *    corner-deflection nesting is simplified to CCW-then-CW-then-reverse.
 *  - Player MAGIC BALL (kind 1, friendly): rolls straight, kills one nasty, and
 *    stops dead at a block.
 *  - Hostile shot (kind 0, hostile: Cannon/Gargoyle/Knight; asm FUN_1000744c):
 *    flies straight, SMASHES the player's destructible blocks, and hits a player. */
void soi_projectiles_update(SoiWorld *w)
{
    int i, col, row, victim;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (!pr->active) continue;

        /* ---- Knight gift (kind 2, asm FUN_1000c544): steps to its target cell and
         * drops the goody there (empty -> collectible, blocked -> gift-block). ---- */
        if (pr->kind == 2) {
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
            if ((ardx <= 6 && ardy <= 6) || (atdx == 0 && atdy == 0)) {
                pr->x = tx; pr->y = ty;                       /* final approach: snap onto the cell */
            } else if (atdx >= atdy) {                        /* x-dominant (tdx != 0 here) */
                pr->x += (rdx < 0) ? -6 : 6;
                pr->y = ly + (int)(((int64_t)(pr->x - lx) * tdy) / tdx);
            } else {                                          /* y-dominant (tdy != 0 here) */
                pr->y += (rdy < 0) ? -6 : 6;
                pr->x = lx + (int)(((int64_t)(pr->y - ly) * tdx) / tdy);
            }
            if ((pr->x == tx && pr->y == ty) || ++pr->age > 200) {
                soi_gift_land(w, (int)pr->tcol, (int)pr->trow, pr->gtype);
                pr->active = 0;
            }
            continue;
        }

        /* ---- Player Magic Arrow: 4-direction ricochet ---- */
        if (pr->kind == 0 && !pr->hostile) {
            int cx, cy, ncol, nrow;
            uint32_t nc;
            if (++pr->age >= 500) { pr->active = 0; continue; }   /* fizzle */
            cx = pr->x + SOI_CELL_PX / 2;               /* arrow centre */
            cy = pr->y + SOI_CELL_PX / 2;
            ncol = cx + pr->vx - SOI_ORIGIN_X;
            ncol = (ncol >= 0) ? (ncol / SOI_CELL_PX) : -1;   /* floor at the LEFT field edge */
            nrow = (cy + pr->vy - SOI_ORIGIN_Y) / SOI_CELL_PX;
            nc = soi_get_cell(w, ncol, nrow);
            if (!soi_in_bounds(ncol, nrow) || (nc & SOI_CELL_SUPPORTIVE)) {
                /* wall ahead: turn 90 deg. Solidity is the SUPPORTIVE bit ALONE (asm
                 * FUN_1000554c / FUN_1000fd5c probe (cell & 0x200) only), so the arrow
                 * ricochets off real blocks but flies straight through 0x9xx goodies.
                 * VERIFIED vs asm FUN_1000fd5c (ricochet states
                 * 0x52 1=L/2=U/3=R/4=D): the original turns PRIMARY (x,y)->(y,-x) then, at a
                 * corner, SECONDARY (x,y)->(-y,x). cand[0]={vy,-vx} and cand[1]={-vy,vx} below
                 * ARE those two transforms exactly (checked all 4 dirs: L->D/U, R->U/D, U->L/R,
                 * D->R/L). cand[2]=reverse is a port-only fallback for a fully-boxed corner (the
                 * asm cannot box itself in); fizzle only if even that is blocked. The single
                 * next-cell probe below simplifies the asm's multi-corner turn-vs-continue test. */
                int ov = pr->vx, ow = pr->vy, t;
                int cand[3][2] = { { ow, -ov }, { -ow, ov }, { -ov, -ow } };
                int acol = (cx - SOI_ORIGIN_X) / SOI_CELL_PX;   /* arrow's own cell */
                int arow = (cy - SOI_ORIGIN_Y) / SOI_CELL_PX;
                pr->vx = 0; pr->vy = 0;
                for (t = 0; t < 3; t++) {
                    /* probe the ADJACENT cell in the candidate direction (a bare
                     * +/-2 px would stay inside the arrow's own cell and wrongly
                     * read a blocked side as clear -- e.g. "down" into the floor). */
                    int tc = acol + (cand[t][0] > 0 ? 1 : cand[t][0] < 0 ? -1 : 0);
                    int tr = arow + (cand[t][1] > 0 ? 1 : cand[t][1] < 0 ? -1 : 0);
                    uint32_t cc = soi_get_cell(w, tc, tr);
                    if (soi_in_bounds(tc, tr) && !(cc & SOI_CELL_SUPPORTIVE)) {
                        pr->vx = (int16_t)cand[t][0];
                        pr->vy = (int16_t)cand[t][1];
                        break;
                    }
                }
                if (pr->vx == 0 && pr->vy == 0) { pr->active = 0; continue; }
            } else {
                pr->x += pr->vx; pr->y += pr->vy;
            }
            col = (pr->x + SOI_CELL_PX / 2 - SOI_ORIGIN_X) / SOI_CELL_PX;
            row = (pr->y + SOI_CELL_PX / 2 - SOI_ORIGIN_Y) / SOI_CELL_PX;
            victim = soi_enemy_at(w, col, row);
            if (victim >= 0 && !enemy_is_hazard(w->enemies[victim].type))
                soi_enemy_kill(w, victim, pr->owner);   /* keeps flying; hazards are immune */
            continue;
        }

        /* ---- Magic Ball: rolls horizontally, STOPS DEAD *flush* at the first
         * solid block (asm FUN_1000fd5c). Test the LEADING edge (centre +/- a
         * half cell) rather than the top-left corner, so it comes to rest beside
         * the wall instead of rolling its body a half-cell into it (the visible
         * "clips through the wall" glitch). ---- */
        if (pr->kind == 1) {
            int lrow, cx, lead, lcol;
            uint32_t lc;
            pr->x += pr->vx;
            pr->y += pr->vy;
            lrow = (pr->y + SOI_CELL_PX / 2 - SOI_ORIGIN_Y) / SOI_CELL_PX;
            cx = pr->x + SOI_CELL_PX / 2;                      /* ball centre */
            lead = cx + (pr->vx > 0 ? SOI_CELL_PX / 2 - 1 : -(SOI_CELL_PX / 2));
            lcol = lead - SOI_ORIGIN_X;
            lcol = (lcol >= 0) ? (lcol / SOI_CELL_PX) : -1;   /* floor at the LEFT field edge -> the ball stops, it does not roll off-screen */
            lc = soi_get_cell(w, lcol, lrow);
            if (!soi_in_bounds(lcol, lrow) || (lc & SOI_CELL_SUPPORTIVE)) {
                /* rest with the leading edge flush on the wall face. Solidity is the SUPPORTIVE
                 * bit ALONE (asm FUN_1000554c: (cell & 0x200) != 0) -- goodies/coins (0x9xx) alias
                 * PERMANENT 0x100 but carry no 0x200, so the ball rolls straight through them. */
                if (pr->vx > 0) pr->x = (int16_t)(SOI_ORIGIN_X + (lcol - 1) * SOI_CELL_PX);
                else            pr->x = (int16_t)(SOI_ORIGIN_X + (lcol + 1) * SOI_CELL_PX);
                pr->active = 0;
                continue;
            }
            col = (cx - SOI_ORIGIN_X) / SOI_CELL_PX;
            victim = soi_enemy_at(w, col, lrow);              /* kill a nasty it rolls over */
            if (victim >= 0) {
                if (!enemy_is_hazard(w->enemies[victim].type))  /* hazards survive; ball is still spent */
                    soi_enemy_kill(w, victim, pr->owner);
                pr->active = 0;
            }
            continue;
        }

        /* ---- Hostile shot (Cannon/Gargoyle/Knight): flies straight, SMASHES
         * the player's destructible block in its path, and hits a player. ---- */
        /* The Gargoyle's shot is really a short-range PUFF (asm FUN_10008618 spawns
         * a puff entity one cell ahead), so fizzle it after ~3 cells rather than
         * letting it fly the full width like the Cannon's ball. */
        if (pr->src_type == SOI_ENEMY_GARGOYLE && ++pr->age > 28) { pr->active = 0; continue; }
                                              /* ~3-cell puff range preserved at the new 4 px/frame */
        pr->x += pr->vx;
        pr->y += pr->vy;
        col = (pr->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        row = (pr->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        {
            uint32_t cell = soi_get_cell(w, col, row);
            if (!soi_in_bounds(col, row) || (cell & SOI_CELL_PERMANENT)) {
                pr->active = 0;                       /* stopped by a permanent wall / OOB */
                continue;
            }
            /* A hostile shot smashes the player's destructible block in its path
             * (asm FUN_10027d84/ecc: reveal any 0x1000 payload, else clear it). */
            if ((cell & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(cell) != 0) {
                soi_set_cell(w, col, row,
                             (cell & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(cell) : 0u);
                soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
                if (!pr->pierce) { pr->active = 0; continue; }  /* break: dies on 1 block. UltraBuster
                                                                 * (pierce): passes through, destroys more */
            }
        }
        if (pr->hostile) {
            /* enemy shot (Cannon/Gargoyle): damage a player sharing the projectile's
             * grid cell. This is a CELL-equality test on purpose — the original uses a
             * grid-cell comparison for player-vs-thing goody/damage checks (e.g. the
             * pickup/goody probe FUN_1002bc64), NOT the pixel AABB primitive
             * (FUN_100030d4) it uses for enemy-BODY contact above. The two models
             * legitimately differ in the original, so this must NOT be "unified" with
             * the contact AABB. */
            int pj;
            for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
                SoiPlayer *p = &w->players[pj];
                if (!p->active || !p->alive) continue;
                if ((p->x - SOI_ORIGIN_X) / SOI_CELL_PX == col &&
                    (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX == row) {
                    soi_player_hit(w, pj);
                    pr->active = 0;
                    break;
                }
            }
        }
    }
}
