/* soi_enemies.c — enemy entities: the bestiary point table (CONFIRMED), spawn,
 * a first-draft walk-and-turn update (the CONFIRMED baseline for the simple
 * types), and kill->score. Per-type AI (Hammer jump, Beanie split, Robo
 * multi-state, Wheelie/Walker seek) and exact tuning are TODO(oracle).
 * (docs runtime-structures §3/§11.)
 */
#include "soi_internal.h"

static int enemy_speed(int type);   /* per-type base speed (defined below) */

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
        default:                return 0;
    }
}

void soi_enemy_spawn(SoiWorld *w, SoiEnemyType t, int col, int row)
{
    int i;
    if (t <= SOI_ENEMY_NONE || t >= SOI_ENEMY_TYPE_COUNT) return;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        SoiEnemy *e = &w->enemies[i];
        if (e->active) continue;
        e->active = 1;
        e->type   = (uint8_t)t;
        e->x      = soi_cell_x(col);
        e->y      = soi_cell_y(row);
        e->dir    = 2;                 /* start moving right */
        e->state  = 1;
        e->vx     = (int16_t)enemy_speed((int)t);   /* per-type base speed */
        e->vy     = 0;
        e->points = soi_enemy_points(t);
        e->owner  = 0;
        e->anim   = 0;
        return;
    }
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
    soi_sfx_emit(w, SOI_SFX_ENEMY_KILL);
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
    if (p->invuln > 0) return;                 /* still in post-hit grace */
    if (p->shield > 0) {                        /* shield eats the hit */
        p->shield--;
        p->invuln = 60;
        return;
    }
    p->alive = 0;
    if (--p->lives < 1) p->eliminated = 1;      /* out of lives -> stay down */
    else p->respawn_timer = 90;                 /* revive at spawn after a beat */
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
        default:                return 2;
    }
}

/* Column of the nearest living player to this enemy, or -1 if none. */
static int nearest_player_col(const SoiWorld *w, const SoiEnemy *e)
{
    int ec = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    int best = -1, bestd = 1 << 30, pj;
    for (pj = 1; pj < SOI_MAX_PLAYERS; pj++) {
        const SoiPlayer *p = &w->players[pj];
        int d, pc;
        if (!p->active || !p->alive || p->eliminated) continue;
        pc = (p->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        d = pc - ec; if (d < 0) d = -d;
        if (d < bestd) { bestd = d; best = pc; }
    }
    return best;
}

static void enemy_step(SoiWorld *w, SoiEnemy *e)
{
    int col, row, ahead, spd = enemy_speed(e->type);

    /* seek types steer horizontally toward the nearest player before moving */
    if (e->type == SOI_ENEMY_WHEELIE || e->type == SOI_ENEMY_WALKER) {
        int ec = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        int pc = nearest_player_col(w, e);
        if (pc >= 0 && pc != ec) {
            e->dir = (uint8_t)((pc > ec) ? 2 : 1);
            e->vx  = (int16_t)((pc > ec) ? spd : -spd);
        }
    }

    e->x += e->vx;
    e->y += e->vy;
    e->anim++;

    col = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX;
    row = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
    ahead = (e->dir == 2) ? col + 1 : col - 1;

    /* reverse when the next cell is solid or out of bounds */
    if (!soi_in_bounds(ahead, row) ||
        SOI_CELL_TYPE(soi_get_cell(w, ahead, row)) != SOI_CELL_EMPTY) {
        e->dir = (uint8_t)((e->dir == 2) ? 1 : 2);
        e->vx  = (int16_t)-e->vx;
    }
    /* TODO(oracle): gravity/support, Hammer-jump / Beanie-split / Robo states. */
}

void soi_enemies_update(SoiWorld *w)
{
    int i, pj;
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        SoiEnemy *e = &w->enemies[i];
        if (!e->active) continue;
        if (!w->enemies_frozen) enemy_step(w, e);   /* Stop switch halts nasties */
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
    int i, dc = 0, dr = 0;
    if (player < 0 || player >= SOI_MAX_PLAYERS) return;
    p = &w->players[player];
    if (p->arrows <= 0 || p->fire_cd > 0) return;
    dc = (p->facing >= 0) ? 1 : -1; dr = 0;   /* Magic Arrow: straight, horizontal */
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (pr->active) continue;
        pr->active = 1;
        pr->owner  = (uint8_t)player;
        pr->x = p->x;
        pr->y = p->y;
        pr->vx = (int16_t)(dc * 8);   /* 8 px/frame straight line */
        pr->vy = (int16_t)(dr * 8);
        p->arrows--;
        p->fire_cd = 15;
        soi_sfx_emit(w, SOI_SFX_FIRE);
        return;
    }
}

/* Advance arrows: straight-line flight; kill an enemy sharing the cell; despawn
 * on a permanent wall or leaving the field. */
void soi_projectiles_update(SoiWorld *w)
{
    int i, col, row, victim;
    for (i = 0; i < SOI_MAX_PROJECTILES; i++) {
        SoiProjectile *pr = &w->projectiles[i];
        if (!pr->active) continue;
        pr->x += pr->vx;
        pr->y += pr->vy;
        col = (pr->x - SOI_ORIGIN_X) / SOI_CELL_PX;
        row = (pr->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (!soi_in_bounds(col, row) ||
            (soi_get_cell(w, col, row) & SOI_CELL_PERMANENT)) {
            pr->active = 0;
            continue;
        }
        victim = soi_enemy_at(w, col, row);
        if (victim >= 0) {
            soi_enemy_kill(w, victim, pr->owner);
            pr->active = 0;
        }
    }
}
