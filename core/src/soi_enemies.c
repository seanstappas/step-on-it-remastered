/* soi_enemies.c — enemy entities: the bestiary point table (CONFIRMED), spawn,
 * a first-draft walk-and-turn update (the CONFIRMED baseline for the simple
 * types), and kill->score. Per-type AI (Hammer jump, Beanie split, Robo
 * multi-state, Wheelie/Walker seek) and exact tuning are TODO(oracle).
 * (docs runtime-structures §3/§11.)
 */
#include "soi_internal.h"

static int enemy_speed(int type);   /* per-type base speed (defined below) */

/* Frames between Cannon shots. The asm (FUN_100071a0) reloads to SpawnDelay*6
 * (the per-block delay byte, ~20 -> ~120); we use a fixed cadence pending the
 * per-enemy delay plumbing. TODO(oracle): store the spawn-block delay byte. */
#define SOI_CANNON_RELOAD 120

int16_t soi_enemy_points(SoiEnemyType t)
{
    switch (t) {
        case SOI_ENEMY_ANT:     return 50;
        case SOI_ENEMY_OSTRICH: return 100;
        case SOI_ENEMY_HIPPO:   return 200;
        case SOI_ENEMY_PIGGY:   return 250;
        case SOI_ENEMY_WHEELIE: return 300;
        case SOI_ENEMY_SMILEY:  return 400;
        case SOI_ENEMY_HAMMER:  return 500;
        case SOI_ENEMY_BEANIE:  return 750;
        case SOI_ENEMY_ROBO:    return 1000;
        case SOI_ENEMY_WALKER:  return 1250;
        case SOI_ENEMY_TEETH:   return 1500;
        case SOI_ENEMY_CANNON:  return 1000;   /* CONFIRMED: +0x8a in FUN_1000c2e8 */
        case SOI_ENEMY_SPINNER: return 0;      /* CONFIRMED: no score awarded */
        case SOI_ENEMY_GARGOYLE:return 0;      /* CONFIRMED: no score awarded */
        case SOI_ENEMY_KNIGHT:  return 0;      /* CONFIRMED: no score awarded */
        default:                return 0;
    }
}

/* Map a BORD spawn-block badguy type to our bestiary enum. The original's placed-
 * enemy per-frame dispatcher (asm FUN_1000503c) switches on the spawn block's low
 * byte (1-19). Several indices are stationary SPAWNERS that emit a base nasty
 * (struct type = index+0x64); we map them to the nasty they emit (a simplification
 * -- the real spawner keeps emitting). CONFIRMED: 2=Wheelie, 4=Walker, 7/8=Beanie,
 * 15=Robo. Spawners: 5->Hippo,6->Hammer,10->Teeth,11->Smiley,12->Ant,18->Ostrich,
 * 19->Piggy. Shooters/hazards: 1&13=Cannon, 9=Spinner, 16=Gargoyle, 17=Knight,
 * 14=Hammer. TODO(oracle): a few points/behaviours still first-draft. */
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
        SOI_ENEMY_CANNON,    /* 13  shooter (FUN_1000c2e8 fires 0x71) */
        SOI_ENEMY_HAMMER,    /* 14  HIGH */
        SOI_ENEMY_ROBO,      /* 15  CONFIRMED */
        SOI_ENEMY_GARGOYLE,  /* 16  shooter (FUN_10008618) */
        SOI_ENEMY_KNIGHT,    /* 17  shooter (FUN_10008b18) */
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
        e->anim   = 0;
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
        w->players[by_player].score += e->points;   /* award (+0x42 -> +0x3c) */
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
    /* TODO(oracle): death animation, chain reactions, Beanie-child cleanup. */
}

/* Damage a player: i-frames block repeat hits; a held shield absorbs one hit
 * (granting brief invulnerability); otherwise the player dies / loses a life.
 * TODO(oracle): exact i-frame count + shield/respawn sequence. */
void soi_player_hit(SoiWorld *w, int idx)
{
    SoiPlayer *p;
    if (idx < 0 || idx >= SOI_MAX_PLAYERS) return;
    p = &w->players[idx];
    if (!p->active || !p->alive || p->eliminated) return;
    if (p->ground_state == SOI_ST_DEAD) return; /* already mid death-throw */
    if (p->invuln > 0) return;                 /* still in post-hit grace */
    if (p->shield > 0) {                        /* shield eats the hit */
        p->shield--;
        p->invuln = 60;
        return;
    }
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

/* Advance one enemy: baseline horizontal walk-and-turn (CONFIRMED pattern),
 * with per-type speed and a seek steer for the Wheelie/Walker chasers.
 * Per-type speed and the seek behaviour are first-draft HYPOTHESIS (the docs
 * name Wheelie/Walker as "seek" types); Hammer-jump / Beanie-split / Robo
 * multi-state remain TODO(oracle). */
static int enemy_speed(int type)
{
    switch (type) {
        case SOI_ENEMY_OSTRICH:
        case SOI_ENEMY_WHEELIE:
        case SOI_ENEMY_WALKER:
        case SOI_ENEMY_TEETH:   return 3;
        case SOI_ENEMY_CANNON:
        case SOI_ENEMY_SPINNER:
        case SOI_ENEMY_GARGOYLE:  /* stationary turret, fires horizontally (FUN_10008618) */
        case SOI_ENEMY_KNIGHT:    /* stationary turret, fires vertically   (FUN_10008b18) */
            return 0;    /* stationary hazards (spin/fire in place; never move their own pos) */
        default:                return 2;
    }
}

/* Clamp a step from `from` toward `to` to at most `spd` px (lands exactly when
 * within one step, so a flyer settles on the player's axis instead of jittering). */
static int enemy_toward(int from, int to, int spd)
{
    int d = to - from;
    if (d >  spd) return  spd;
    if (d < -spd) return -spd;
    return d;
}

/* The Wheelie is an 8-direction FLYER (FUN_10009e98 drives both +0x58/+0x5a with
 * NO gravity). We approximate its per-cell 8-dir navigation with a direct 2D
 * chase of the nearest living player, refusing to enter a solid (0x200) cell on
 * either axis. TODO(oracle): the exact collision-bounce steering. */
static void enemy_fly_seek(SoiWorld *w, SoiEnemy *e, int spd)
{
    int pj, tx = 0, ty = 0, bestd = 1 << 30, found = 0, sx, sy, c, r;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int dx, dy, d;
        if (!p->active || !p->alive || p->eliminated) continue;
        dx = p->x - e->x; dy = p->y - e->y;
        d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
        if (d < bestd) { bestd = d; tx = p->x; ty = p->y; found = 1; }
    }
    if (!found) return;
    sx = enemy_toward(e->x, tx, spd);
    sy = enemy_toward(e->y, ty, spd);
    if (sx) {
        c = (e->x + sx - SOI_ORIGIN_X) / SOI_CELL_PX;
        r = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        e->dir = (uint8_t)(sx > 0 ? 2 : 1);
        if (!(soi_get_cell(w, c, r) & SOI_CELL_SUPPORTIVE)) e->x += sx;
    }
    if (sy) {
        c = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        r = (e->y + sy - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (!(soi_get_cell(w, c, r) & SOI_CELL_SUPPORTIVE)) e->y += sy;
    }
}

/* Hammer (FUN_10007998): a HOPPER -- it bounds along in arcs (rises, arcs down
 * under gravity, lands, hops forward) instead of walking flat, pausing briefly
 * between hops and bouncing off walls. We approximate the asm's float-and-slam
 * arc with a short ballistic hop; the exact float duration + the landing SMASH
 * (FUN_10027aec) are TODO(oracle). */
static void enemy_hammer_hop(SoiWorld *w, SoiEnemy *e)
{
    int col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    int row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    int ahead;
    if (e->vy != 0) {                                    /* airborne: arc + drift forward */
        e->y  = (int32_t)(e->y + e->vy);
        e->vy = (int16_t)(e->vy + 3);                    /* hop gravity */
        ahead = (e->dir == 2) ? col + 1 : col - 1;
        if (!soi_in_bounds(ahead, row) || (soi_get_cell(w, ahead, row) & SOI_CELL_SUPPORTIVE)) {
            e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);   /* bounce off a wall */
            e->vx  = (int16_t)-e->vx;
        } else {
            e->x = (int32_t)(e->x + e->vx);
        }
        row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (e->vy > 0 && (soi_get_cell(w, col, row + 1) & SOI_CELL_SUPPORTIVE)) {
            uint32_t below = soi_get_cell(w, col, row + 1);
            e->y = soi_cell_y(row);                      /* land */
            e->vy = 0;
            e->fire_cd = 18;                             /* brief pause before the next hop */
            /* landing SMASH (FUN_10027aec -> FUN_1002cc10): shatter a DESTRUCTIBLE
             * block underfoot (revealing any 0x1000 payload); permanent floors and
             * borders survive. The Hammer then drops through the gap it made. */
            if (!(below & SOI_CELL_PERMANENT) && SOI_CELL_TYPE(below) != 0) {
                soi_set_cell(w, col, row + 1,
                             (below & SOI_CELL_SPECIAL) ? SOI_CELL_PAYLOAD(below) : 0u);
                soi_sfx_emit(w, SOI_SFX_BLOCK_DESTROY);
            }
        }
        return;
    }
    if (!(soi_get_cell(w, col, row + 1) & SOI_CELL_SUPPORTIVE)) { e->y += 4; return; }  /* fall */
    if (e->fire_cd > 0) { e->fire_cd--; return; }        /* grounded pause */
    e->vy = -11;                                         /* launch the next hop (asm -0xb) */
}

static void enemy_step(SoiWorld *w, SoiEnemy *e)
{
    int col, row, ahead, spd = enemy_speed(e->type);

    e->anim++;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;

    /* Wheelie: a gravity-free 2D flyer that chases the player (enemy_fly_seek). */
    if (e->type == SOI_ENEMY_WHEELIE) { enemy_fly_seek(w, e, spd); return; }
    /* Hammer: a hopper that bounds in arcs. A Hammer SPAWNER (spawn_child set)
     * stays put and emits, so only real hopping Hammers are routed here. */
    if (e->type == SOI_ENEMY_HAMMER && e->spawn_child == 0) { enemy_hammer_hop(w, e); return; }

    /* Gravity: a nasty is supported while EITHER foot rests on a SOLID block
     * (0x200) in the cell below; only over open air (BOTH feet clear) does it
     * FALL -- and not walk -- until it lands. This two-foot probe matches the asm
     * (FUN_10005750 tests both footprint edges), so a nasty walks fully off a
     * ledge before dropping and can straddle a one-cell gap. It reverses only at
     * a body-height WALL (below), never at a ledge. OOB reads solid (0x300).
     * The Beanie is EXEMPT: it is a gravity-free FLOATER (asm FUN_10006378 only
     * ever changes x, never applying a fall), so it hovers at its spawn height. */
    if (e->type != SOI_ENEMY_BEANIE) {
        int lc = col;                                                   /* left-foot column  */
        int rc = (e->x + SOI_CELL_PX - 1 - SOI_ORIGIN_X) / SOI_CELL_PX;  /* right-foot column */
        if (!(soi_get_cell(w, lc, row + 1) & SOI_CELL_SUPPORTIVE) &&
            !(soi_get_cell(w, rc, row + 1) & SOI_CELL_SUPPORTIVE)) {
            e->y += 4;                                   /* fall speed (px/frame) */
            row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
            if ((soi_get_cell(w, lc, row + 1) & SOI_CELL_SUPPORTIVE) ||
                (soi_get_cell(w, rc, row + 1) & SOI_CELL_SUPPORTIVE))
                e->y = soi_cell_y(row);                  /* land: rest on the block top */
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
     * turns at BOTH a wall ahead AND a ledge ahead (a foot-level ground probe) --
     * it does NOT home on the player. The Robo (FUN_1000a780) likewise reverses at
     * a ledge (below). The simple walkers (ant/ostrich/hippo/piggy/smiley/teeth)
     * only turn at walls and walk off ledges. */
    if (e->type == SOI_ENEMY_WALKER)
        e->vx = (int16_t)((e->dir == 2) ? spd : -spd);

    e->x += e->vx;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    ahead = (e->dir == 2) ? col + 1 : col - 1;

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
    if (e->type == SOI_ENEMY_ROBO && soi_in_bounds(ahead, row) &&
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
        pr->vx = (int16_t)(dc * 8);
        pr->vy = 0;
        soi_sfx_emit(w, SOI_SFX_CANNON_FIRE);   /* asm event 0x10 -> 12863 "Flens" (not the arrow) */
        return;
    }
}

/* Gargoyle (FUN_10008618, horizontal) and Knight (FUN_10008b18, vertical) are
 * stationary turrets that fire at the player. The asm emits a short-range beam of
 * stationary "puffs"; we approximate it with a hostile projectile along the line
 * of fire (reusing the Cannon shot), AIMED at the nearest player (the asm faces
 * the player via its LOS checks). `vertical` selects the Knight's up/down axis. */
static void enemy_shooter_fire(SoiWorld *w, SoiEnemy *e, int vertical)
{
    int i, pj, tx = 0, ty = 0, bestd = 1 << 30, found = 0, dcx = 0, dcy = 0;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int dx, dy, d;
        if (!p->active || !p->alive || p->eliminated) continue;
        dx = p->x - e->x; dy = p->y - e->y;
        d = (dx < 0 ? -dx : dx) + (dy < 0 ? -dy : dy);
        if (d < bestd) { bestd = d; tx = p->x; ty = p->y; found = 1; }
    }
    if (!found) return;
    if (vertical) dcy = (ty >= e->y) ? 1 : -1;
    else { dcx = (tx >= e->x) ? 1 : -1; e->dir = (uint8_t)(dcx > 0 ? 2 : 1); }
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active  = 1;
        pr->owner   = 0;
        pr->hostile = 1;
        pr->src_type = (uint8_t)e->type;   /* Gargoyle puff / Knight bolt art */
        pr->age = 0;
        pr->x = e->x + dcx * 0x20;
        pr->y = e->y + dcy * 0x20;
        pr->vx = (int16_t)(dcx * 8);
        pr->vy = (int16_t)(dcy * 8);
        /* The Gargoyle (FUN_10008618) and Knight (FUN_10008b18) fire SILENTLY --
         * neither calls the SFX trigger (unlike the Cannon's event 0x10). */
        return;
    }
}

/* Persistent spawner (FUN_100076a8 &c): a stationary emitter that produces its
 * base nasty (child = placement+0x64) every fire_period frames. Emitted children
 * are TRANSIENT (given a lifespan) so the playfield does not fill up. */
static void enemy_spawner_emit(SoiWorld *w, int idx)
{
    SoiEnemy *e = &w->enemies[idx];
    int ci, col, row, spd;
    SoiEnemyType child = (SoiEnemyType)e->spawn_child;
    if (e->fire_cd > 0) { e->fire_cd--; return; }
    e->fire_cd = (e->fire_period > 0) ? e->fire_period : SOI_CANNON_RELOAD;
    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    ci = soi_enemy_spawn(w, child, col, row);
    if (ci >= 0) {
        spd = enemy_speed((int)child);
        w->enemies[ci].dir  = e->dir;
        w->enemies[ci].vx   = (int16_t)((e->dir == 1) ? -spd : spd);
        w->enemies[ci].life = (int16_t)((e->fire_period > 0) ? e->fire_period * 2 : 480);
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
        if (e->claimed) { soi_enemy_kill(w, i, e->claimed); continue; }
        if (e->life > 0 && --e->life == 0) { e->active = 0; continue; }  /* transient child expired */
        if (!w->enemies_frozen) enemy_step(w, e);   /* Stop switch halts nasties */
        if (!w->enemies_frozen && e->type == SOI_ENEMY_CANNON)
            enemy_cannon_fire(w, e);                /* stationary shooter (FUN_100071a0) */
        if (!w->enemies_frozen && e->type == SOI_ENEMY_GARGOYLE)
            enemy_shooter_fire(w, e, 0);            /* horizontal turret (FUN_10008618) */
        if (!w->enemies_frozen && e->type == SOI_ENEMY_KNIGHT)
            enemy_shooter_fire(w, e, 1);            /* vertical turret (FUN_10008b18) */
        if (!w->enemies_frozen && e->spawn_child)
            enemy_spawner_emit(w, i);               /* persistent spawner (FUN_100076a8 &c) */
        /* player contact: touching an enemy kills the player (first draft). */
        for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
            SoiPlayer *p = &w->players[pj];
            if (!p->active || !p->alive) continue;
            if ((p->x - SOI_ORIGIN_X) / SOI_CELL_PX == (e->x - SOI_ORIGIN_X) / SOI_CELL_PX &&
                (p->y - SOI_ORIGIN_Y) / SOI_CELL_PX == (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX) {
                soi_player_hit(w, pj);
                /* TODO(oracle): death sequence, respawn. */
            }
        }
    }
}

/* Fire a Magic Arrow in the player's facing direction (CONFIRMED: the Arrow
 * travels in a straight line and kills nasties). Consumes one arrow and starts
 * a throttle so a held FIRE doesn't dump the whole stock at once.
 * TODO(oracle): arrow speed, wall interaction, and the Magic Ball (rolls). */
void soi_projectile_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (p->arrows <= 0 || p->fire_cd > 0) return;
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
        p->fire_cd = 15;
        soi_sfx_emit(w, SOI_SFX_FIRE);
        return;
    }
}

/* Fire a Magic Ball in the player's facing direction. CONFIRMED (asm FUN_100110b4
 * fire + FUN_1000fd5c mover, +0x54==1): the ball rolls HORIZONTALLY at a fixed
 * height (no gravity), kills any nasty it rolls over, and STOPS DEAD at the first
 * solid block (it does NOT smash blocks like the Arrow does). Uses a separate ball
 * ammo pool (+0x4a). The asm moves it +/-4 px/frame; we roll a touch slower than
 * the 8 px/frame Arrow so it reads as a heavier ground roll. */
void soi_ball_fire(SoiWorld *w, int player)
{
    SoiPlayer *p;
    int i, dc;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (p->balls <= 0 || p->fire_cd > 0) return;
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
        p->fire_cd = 15;
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

        /* ---- Player Magic Arrow: 4-direction ricochet ---- */
        if (pr->kind == 0 && !pr->hostile) {
            int cx, cy, ncol, nrow;
            uint32_t nc;
            if (++pr->age >= 500) { pr->active = 0; continue; }   /* fizzle */
            cx = pr->x + SOI_CELL_PX / 2;               /* arrow centre */
            cy = pr->y + SOI_CELL_PX / 2;
            ncol = (cx + pr->vx - SOI_ORIGIN_X) / SOI_CELL_PX;
            nrow = (cy + pr->vy - SOI_ORIGIN_Y) / SOI_CELL_PX;
            nc = soi_get_cell(w, ncol, nrow);
            if (!soi_in_bounds(ncol, nrow) || (nc & SOI_CELL_PERMANENT) ||
                ((nc & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(nc) != 0)) {
                /* wall ahead: turn 90 deg. Prefer CCW (wall-follow), then CW,
                 * then reverse; if every side is boxed in, fizzle. */
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
                    if (soi_in_bounds(tc, tr) && !(cc & SOI_CELL_PERMANENT) &&
                        !((cc & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(cc) != 0)) {
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
            if (victim >= 0) soi_enemy_kill(w, victim, pr->owner);   /* keeps flying */
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
            lcol = (lead - SOI_ORIGIN_X) / SOI_CELL_PX;
            lc = soi_get_cell(w, lcol, lrow);
            if (!soi_in_bounds(lcol, lrow) || (lc & SOI_CELL_PERMANENT) ||
                ((lc & SOI_CELL_SUPPORTIVE) && SOI_CELL_TYPE(lc) != 0)) {
                /* rest with the leading edge flush on the wall face */
                if (pr->vx > 0) pr->x = (int16_t)(SOI_ORIGIN_X + (lcol - 1) * SOI_CELL_PX);
                else            pr->x = (int16_t)(SOI_ORIGIN_X + (lcol + 1) * SOI_CELL_PX);
                pr->active = 0;
                continue;
            }
            col = (cx - SOI_ORIGIN_X) / SOI_CELL_PX;
            victim = soi_enemy_at(w, col, lrow);              /* kill a nasty it rolls over */
            if (victim >= 0) {
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
        if (pr->src_type == SOI_ENEMY_GARGOYLE && ++pr->age > 14) { pr->active = 0; continue; }
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
                pr->active = 0;
                continue;
            }
        }
        if (pr->hostile) {
            /* enemy shot (Cannon): damage a player sharing the cell. */
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
