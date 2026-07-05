/* test_mechanics.c — white-box unit tests for the newer core verbs (arrow fire,
 * shield absorb, jump-break-above). Includes the INTERNAL header so it can set
 * up entity state directly (arrows, shields, enemies) that the public ABI does
 * not expose. Compiled together with the core sources. Exit 0 = all pass.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "soi_internal.h"

static int failures = 0;
#define CHECK(cond, msg) do { \
    if (!(cond)) { printf("FAIL: %s\n", (msg)); failures++; } \
    else         { printf("ok:   %s\n", (msg)); } \
} while (0)

/* Put a player on the field at (col,row) with a clear world. */
static void reset_player(SoiWorld *w, int idx, int col, int row)
{
    SoiPlayer *p = &w->players[idx];
    memset(p, 0, sizeof(*p));
    p->active = 1; p->alive = 1;
    p->x = soi_cell_x(col); p->y = soi_cell_y(row);
    p->facing = 1;                 /* +1 = right */
    p->lives = 3; p->block_type = 0x07;
    p->spawn_x = (int16_t)p->x; p->spawn_y = (int16_t)p->y;
}

/* Mark the player's feet cell supportive so soi_tick keeps it grounded instead
 * of dropping it into a fall. Support cell == the placement cell (col,row).
 * Use a pure SUPPORTIVE (0x200) surface, not a full wall, so it does not also
 * read as PERMANENT (which would, e.g., block a fired arrow at its spawn). */
static void ground_player(SoiWorld *w, int col, int row)
{
    soi_set_cell(w, col, row, SOI_CELL_SUPPORTIVE);
}

int main(void)
{
    SoiWorld *w = (SoiWorld *)malloc(soi_world_size());
    if (!w) return 2;

    /* ---- 1. Magic Arrow kills an enemy in its straight-line path ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1;
    w->pct_badguy = 0;                 /* disable procedural spawns during test */
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 2;
    w->players[1].facing = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* two cells to the right */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    CHECK(soi_enemy_count(w) == 1, "arrow: enemy present before firing");
    CHECK(soi_enemy_active(w, 0) == 1 && soi_enemy_type(w, 0) == SOI_ENEMY_ANT,
          "accessor: enemy slot 0 active + type readable");
    CHECK(soi_enemy_x(w, 0) == soi_cell_x(5) && soi_enemy_y(w, 0) == soi_cell_y(9),
          "accessor: enemy pixel position readable");

    soi_tick(w, SOI_IN_ARROW, 0);              /* fire once */
    CHECK(w->players[1].arrows == 1, "arrow: firing consumed one arrow");
    CHECK(soi_projectile_count(w) == 1, "arrow: a projectile is in flight");

    {
        int t;
        for (t = 0; t < 28 && soi_enemy_count(w) > 0; t++)
            soi_tick(w, 0, 0);                 /* idle while the arrow travels (2 px/frame) */
    }
    CHECK(soi_enemy_count(w) == 0, "arrow: enemy killed by the arrow");
    CHECK(soi_player_score(w, 1) == 50, "arrow: ant score (50) awarded to firer");

    /* ---- 2. Shield absorbs an enemy contact instead of dying ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].shield = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* enemy on the player's cell */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    soi_tick(w, 0, 0);
    CHECK(soi_player_alive(w, 1) == 1, "shield: player survives the hit");
    CHECK(w->players[1].shield == 0, "shield: one shield was spent");
    CHECK(w->players[1].invuln > 0,  "shield: i-frames granted after absorb");

    /* ---- 3. Head-bonk is a TWO-STAGE destroy: the first jump CRACKS the block
     * above (it stays, marked 0x4000), a second jump BREAKS it (asm FUN_1002ca5c). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                     /* stand so the jump can launch */
    soi_set_cell(w, 6, 8, 1);                  /* breakable block above head */
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) != SOI_CELL_EMPTY &&
          (soi_get_cell(w, 6, 8) & SOI_CELL_CRACKED),
          "bonk: the first jump cracks the block above (still there)");
    /* Input latches every 2 frames (soi_tick samples on odd ticks), so a second
     * edge needs the key released and re-pressed across a couple of frames each. */
    soi_tick(w, 0, 0); soi_tick(w, 0, 0);       /* release the jump key */
    soi_tick(w, SOI_IN_JUMP, 0); soi_tick(w, SOI_IN_JUMP, 0);  /* bonk again */
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
          "bonk: a second jump breaks the cracked block");

    /* a permanent block above must survive a jump */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);
    soi_set_cell(w, 6, 8, SOI_WALL);
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(soi_get_cell(w, 6, 8) == SOI_WALL, "jump: permanent block is untouched");

    /* ---- 3b. A clear-headroom jump leaps the table-driven arc (~37px peak, asm
     * FUN_10013404 + DAT_1003474c) and lands back on the ground, breaking nothing. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                      /* clear headroom at (6,8) */
    {
        int start_y = w->players[1].y;
        int min_y = start_y, t;
        soi_tick(w, SOI_IN_JUMP, 0);             /* edge-trigger the leap */
        CHECK(w->players[1].in_air == 1 && w->players[1].ground_state == SOI_ST_JUMP,
              "jump: clear headroom -> the player leaps (airborne)");
        for (t = 0; t < 40 && w->players[1].in_air; t++) {
            if (w->players[1].y < min_y) min_y = w->players[1].y;
            soi_tick(w, 0, 0);
        }
        CHECK(start_y - min_y >= 30 && start_y - min_y <= 40,
              "jump: the arc peaks ~37px up (recovered table DAT_1003474c)");
        CHECK(w->players[1].in_air == 0 && w->players[1].ground_state == SOI_ST_IDLE &&
              w->players[1].alive == 1,
              "jump: lands cleanly back on the ground");
        CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
              "jump: a clear-headroom leap breaks no block");
    }


    /* ---- 3b. Block create/destroy TOGGLE: two block-high presses at the same
     * front cell build then remove the block (the core build/dig mechanic; an
     * earlier demo looked out of sync, so this pins the behaviour down). ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    /* ---- 3b. Block create/destroy TOGGLE: two block-high presses at the same
     * front cell build then remove the block (the core build/dig mechanic; an
     * earlier demo looked out of sync, so this pins the behaviour down). Input is
     * latched every 2 frames (odd ticks), so each press/release is held 2 ticks. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].facing = 1;                   /* face right -> block-high targets the front cell */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);          /* press: build a block in front */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK((soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE) &&
          SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) != 0,
          "block-high: first press builds a block in front");
    soi_tick(w, 0, 0);                          /* release (must latch a 0 on an odd tick) */
    soi_tick(w, 0, 0);
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);          /* press again: remove the same block */
    soi_tick(w, SOI_IN_BLOCK_HIGH, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 9)) == SOI_CELL_EMPTY,
          "block-high: a second press at the same cell removes it");

    /* ---- 4. Thunderballs pickup clears every nasty on the board ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 1, 2);
    soi_enemy_spawn(w, SOI_ENEMY_HIPPO, 8, 5);
    soi_enemy_spawn(w, SOI_ENEMY_TEETH, 11, 12);
    CHECK(soi_enemy_count(w) == 3, "thunderballs: three nasties before pickup");
    soi_set_cell(w, 4, 9, 0x2F);               /* thunderballs on the player cell */
    soi_pickup_check(w, 1);
    CHECK(soi_enemy_count(w) == 0, "thunderballs: all nasties cleared");
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 4, 9)) == SOI_CELL_EMPTY,
          "thunderballs: pickup cell consumed");

    /* ---- 5. Time-bonus goodies 0x13-0x16 add 2500/5000/7500/10000 (CONFIRMED
     * FUN_1000f3f0). (The Clock 0x2E is a SLOW-enemies power-up, not a time bonus
     * -- see test 8g4.) ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    /* time-bonus goodies 0x13-0x16 add 2500/5000/7500/10000 (CONFIRMED) */
    w->bonus_timer = 1000;
    soi_set_cell(w, 4, 9, 0x15);
    soi_pickup_check(w, 1);
    CHECK(w->bonus_timer == 8500, "time bonus 0x15 (x3) adds 7500");

    /* ---- 6. Transporter zaps the player from an IN to the paired OUT ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 2, 2);
    soi_set_cell(w, 2, 2, 0x1A);               /* IN marker (pair 0) on player */
    soi_set_cell(w, 10, 10, 0x1B);             /* paired OUT marker elsewhere */
    soi_pickup_check(w, 1);
    CHECK(w->players[1].x == soi_cell_x(10) && w->players[1].y == soi_cell_y(10),
          "transporter: player zapped to the paired OUT cell");
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 2, 2)) == 0x1A,
          "transporter: IN marker persists (not consumed)");
    /* standing on an OUT marker must NOT teleport back */
    soi_pickup_check(w, 1);
    CHECK(w->players[1].x == soi_cell_x(10) && w->players[1].y == soi_cell_y(10),
          "transporter: OUT marker does not re-teleport");

    /* ---- 7. Stop/Go switch freezes and resumes the nasties ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 3, 9);
    soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    {
        int ex0, ex1;
        soi_set_cell(w, 6, 9, 0x24);           /* Stop switch (even) on the player */
        soi_pickup_check(w, 1);
        CHECK(w->enemies_frozen == 1, "stopgo: Stop switch freezes nasties");
        ex0 = soi_enemy_x(w, 0);
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_x(w, 0) == ex0, "stopgo: frozen nasty does not move");
        soi_set_cell(w, 6, 9, 0x25);           /* Go switch (odd) */
        soi_pickup_check(w, 1);
        CHECK(w->enemies_frozen == 0, "stopgo: Go switch resumes nasties");
        ex1 = soi_enemy_x(w, 0);
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_x(w, 0) != ex1, "stopgo: resumed nasty moves again");
    }

    /* ---- 8. Wheelie seeks toward the nearest player ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 2, 9);                  /* player is to the LEFT */
    soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 8, 9);/* spawns facing right by default */
    soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    {
        int ex0 = soi_enemy_x(w, 0);
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_x(w, 0) < ex0,
              "seek: wheelie steers left toward the player (overriding default)");
    }

    /* ---- 8b. The Wheelie is a 2D FLYER (FUN_10009e98 moves both axes, no
     * gravity): unsupported it does NOT fall, and it climbs toward a higher
     * player while staying in an aligned column. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 9, 3);                   /* player high, same column */
    soi_enemy_spawn(w, SOI_ENEMY_WHEELIE, 9, 10);  /* wheelie low, NO floor under it */
    {
        int ey0 = w->enemies[0].y, ex0 = w->enemies[0].x;
        soi_enemies_update(w);
        CHECK(w->enemies[0].y < ey0, "fly: the wheelie climbs toward a higher player (no gravity)");
        CHECK(w->enemies[0].x == ex0, "fly: aligned column -> no horizontal drift");
    }

    /* ---- 8c. Persistent SPAWNER (placement 5/6/10/11/12/18/19): a stationary
     * emitter that produces its base nasty (child = placement+0x64) every
     * StartDelay*6 frames; emitted children are TRANSIENT (lifespanned) so the
     * playfield does not fill up (FUN_100076a8 &c). */
    {
        int si, ci = -1, e;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        CHECK(soi_bord_is_spawner(6) && soi_bord_is_spawner(12) && !soi_bord_is_spawner(4),
              "spawner: placement 6/12 are spawners, 4 (Walker) is a direct nasty");
        si = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the spawner stands */
        w->enemies[si].spawn_child = (uint8_t)SOI_ENEMY_HAMMER;
        w->enemies[si].vx = 0;                          /* stationary spawner */
        w->enemies[si].fire_period = 1000;              /* emit once within the window */
        w->enemies[si].fire_cd = 0;                     /* emit on the next update */
        soi_enemies_update(w);
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (e != si && w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_HAMMER) { ci = e; break; }
        CHECK(ci >= 0, "spawner: a persistent spawner emits a child nasty");
        CHECK(ci >= 0 && w->enemies[ci].life > 0, "spawner: the emitted child is transient (lifespan set)");
        if (ci >= 0) w->enemies[ci].life = 2;           /* force it to the brink of expiry */
        soi_enemies_update(w); soi_enemies_update(w);
        CHECK(ci >= 0 && !w->enemies[ci].active, "spawner: a child despawns when its lifespan expires");
    }

    /* ---- 8d. The Robo does NOT climb (asm FUN_1000a780: its wall response is an
     * in-place punch/break animation or a turn -- it never steps up). Penned by a
     * wall on each side, it reverses off the walls and stays on its row. */
    {
        int ri, t, y0, turned = 0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;     /* heading right */
        w->enemies[ri].y = soi_cell_y(9);
        y0 = w->enemies[ri].y;
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);       /* floor (cols 4,5) */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE);        /* wall ahead (right) */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 3, 9, SOI_CELL_SUPPORTIVE);        /* wall behind (left) */
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);
        for (t = 0; t < 30; t++) {
            soi_enemies_update(w);
            if (w->enemies[ri].dir == 1) turned = 1;       /* reversed at the right wall */
        }
        CHECK(turned, "robo: turns back at a wall (does not climb over)");
        CHECK(w->enemies[ri].y == y0, "robo: stays on its row at a wall (no climb up)");
    }

    /* ---- 8d2. The Robo PUNCHES through a breakable block ahead (asm +0x6e ->
     * FUN_10027d84 clears the cell) and keeps its heading, rather than turning --
     * it only turns at a PERMANENT wall or a ledge. */
    {
        int ri, t, c;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 4, 9);
        w->enemies[ri].dir = 2; w->enemies[ri].vx = 2;         /* heading right */
        w->enemies[ri].y = soi_cell_y(9);
        for (c = 3; c <= 11; c++) soi_set_cell(w, c, 10, SOI_CELL_SUPPORTIVE);  /* long floor */
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE | 0x07);     /* a breakable block ahead */
        for (t = 0; t < 50; t++) soi_enemies_update(w);
        CHECK(!(soi_get_cell(w, 6, 9) & SOI_CELL_SUPPORTIVE), "robo: punches through a breakable block");
        CHECK(w->enemies[ri].dir == 2, "robo: keeps its heading after punching (no turn)");
    }

    /* ---- 8e. A Beanie BUDS a child when a wall blocks it (FUN_10006378), at most
     * one living bud at a time; buds are transient and do not themselves bud. */
    {
        int pi, n, e, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        pi = soi_enemy_spawn(w, SOI_ENEMY_BEANIE, 5, 9);
        w->enemies[pi].dir = 2; w->enemies[pi].vx = 2;     /* walking right into a wall */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);       /* floor */
        soi_set_cell(w, 6, 9, SOI_CELL_SUPPORTIVE);        /* wall ahead */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        soi_enemies_update(w);                             /* hits the wall -> buds + reverses */
        n = 0;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_BEANIE) n++;
        CHECK(n == 2, "beanie: buds one child at a wall");
        CHECK(w->enemies[pi].child != 0, "beanie: parent records its one living bud");
        for (t = 0; t < 6; t++) soi_enemies_update(w);     /* must not bud a second while it lives */
        n = 0;
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_BEANIE) n++;
        CHECK(n == 2, "beanie: at most one living bud at a time");
    }

    /* ---- 8f. The Gargoyle (horizontal) and Knight (vertical) turrets fire a
     * hostile shot aimed at the player on their reload; the Knight fires on the
     * VERTICAL axis (FUN_10008618/FUN_10008b18, approximated as an aimed shot). */
    {
        int gi, ki, i, gh = -1, kh = -1;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 8, 3);                       /* player right + high */
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 3, 9);   /* left of the player */
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);    /* floor so it stands */
        w->enemies[gi].fire_cd = 0;
        soi_enemies_update(w);
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].hostile) { gh = i; break; }
        CHECK(gh >= 0 && w->projectiles[gh].vx > 0 && w->projectiles[gh].vy == 0,
              "gargoyle: fires a hostile horizontal shot toward the player");
        for (i = 0; i < SOI_MAX_PROJECTILES; i++) w->projectiles[i].active = 0;
        ki = soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 8, 9);     /* below the player */
        soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[ki].fire_cd = 0;
        soi_enemies_update(w);
        for (i = 0; i < SOI_MAX_PROJECTILES; i++)
            if (w->projectiles[i].active && w->projectiles[i].hostile) { kh = i; break; }
        CHECK(kh >= 0 && w->projectiles[kh].vy < 0 && w->projectiles[kh].vx == 0,
              "knight: fires a hostile vertical shot toward the player (upward)");
    }

    /* ---- 8g. Enemies fall off a ledge only when BOTH feet clear it (the asm
     * probes two footprint cells, FUN_10005750): an enemy straddling a one-cell
     * gap stays up; one fully over the gap falls. */
    {
        int ai, y0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ai = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        w->enemies[ai].vx = 0;                          /* isolate gravity from the walk */
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* floor left of the gap */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* floor right; (5,10) is a one-cell GAP */
        w->enemies[ai].x = soi_cell_x(4) + 20;          /* straddle: left foot col 4, right foot col 5 */
        y0 = w->enemies[ai].y;
        soi_enemies_update(w);
        CHECK(w->enemies[ai].y == y0, "ledge: an enemy straddling a one-cell gap stays up");
        w->enemies[ai].x = soi_cell_x(5);               /* now fully over the gap */
        soi_enemies_update(w);
        CHECK(w->enemies[ai].y > y0, "ledge: an enemy fully over the gap falls");
    }

    /* ---- 8g2. The WALKER (asm FUN_1000dd4c) PATROLS: it turns at a LEDGE (a
     * foot-level ground probe ahead), unlike the simple walkers, so it stays on
     * its platform and walks back and forth instead of walking off. */
    {
        int wi, y0, minc = 99, maxc = -1, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_WALKER, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* 3-cell platform cols 4,5,6 */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* gaps at cols 3 and 7 */
        w->enemies[wi].dir = 2;
        w->enemies[wi].y = soi_cell_y(9);
        y0 = w->enemies[wi].y;
        for (t = 0; t < 200; t++) {
            int c;
            soi_enemies_update(w);
            c = (w->enemies[wi].x - SOI_ORIGIN_X) / SOI_CELL_PX;
            if (c < minc) minc = c;
            if (c > maxc) maxc = c;
        }
        CHECK(w->enemies[wi].y == y0, "walker: patrols without falling off the platform");
        CHECK(minc < maxc, "walker: walks back and forth (patrols, not stuck)");
        CHECK(minc >= 4 && maxc <= 6, "walker: turns around within the platform (cols 4-6)");
    }

    /* ---- 8g3. The ROBO (asm FUN_1000a780, the enemy on the real Board#1) also
     * PATROLS: it reverses at a ledge (a foot probe ahead) like the Walker, so it
     * stays on its platform instead of walking off the edge and falling. */
    {
        int ri, y0, minc = 99, maxc = -1, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        ri = soi_enemy_spawn(w, SOI_ENEMY_ROBO, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);    /* 3-cell platform cols 4,5,6 */
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);    /* gaps at cols 3 and 7 */
        w->enemies[ri].dir = 2;
        w->enemies[ri].vx = 2;
        w->enemies[ri].y = soi_cell_y(9);
        y0 = w->enemies[ri].y;
        for (t = 0; t < 200; t++) {
            int c;
            soi_enemies_update(w);
            c = (w->enemies[ri].x - SOI_ORIGIN_X) / SOI_CELL_PX;
            if (c < minc) minc = c;
            if (c > maxc) maxc = c;
        }
        CHECK(w->enemies[ri].y == y0, "robo: patrols without falling off the platform");
        CHECK(minc < maxc, "robo: walks back and forth (patrols, not stuck)");
        CHECK(minc >= 4 && maxc <= 6, "robo: turns around within the platform (cols 4-6)");
    }

    /* ---- 8g4. The Clock goody (0x2E, asm FUN_1002bc64 -> _DAT_1003b294 = 600)
     * SLOWS every nasty to half speed for ~10s: the enemy dispatcher runs every
     * OTHER frame while the counter is up, so a nasty travels ~half as far. */
    {
        int wi, start, x_fast, x_slow, t;

        /* collecting the 0x2E goody arms the counter */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x2Eu);
        soi_pickup_check(w, 1);
        CHECK(w->enemy_slow == 600, "clock: collecting the 0x2E goody arms the slow-enemies counter");
        CHECK(soi_sfx_count(w) == 1 && soi_sfx_get(w, 0) == SOI_SFX_CLOCK,
              "clock: pickup plays the 'slow' sound (evt 0x2B -> 1005)");

        /* baseline: a nasty's travel over 40 frames at full rate */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        for (t = 3; t <= 15; t++) soi_set_cell(w, t, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 2; w->enemies[wi].y = soi_cell_y(9);
        start = w->enemies[wi].x;
        for (t = 0; t < 40; t++) soi_tick(w, 0, 0);
        x_fast = w->enemies[wi].x - start;

        /* same run, but slowed by a Clock */
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        wi = soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);
        for (t = 3; t <= 15; t++) soi_set_cell(w, t, 10, SOI_CELL_SUPPORTIVE);
        w->enemies[wi].dir = 2; w->enemies[wi].vx = 2; w->enemies[wi].y = soi_cell_y(9);
        w->enemy_slow = 600;
        for (t = 0; t < 40; t++) soi_tick(w, 0, 0);
        x_slow = w->enemies[wi].x - start;

        CHECK(w->enemy_slow == 560, "clock: the slow counter ticks down (600 -> 560 over 40 frames)");
        CHECK(x_fast > 0 && x_slow > 0, "clock: the nasty still moves while slowed");
        CHECK(2 * x_slow >= x_fast - 8 && 2 * x_slow <= x_fast + 8, "clock: slowed nasty travels ~half as far");
    }

    /* ---- 8g5. Each goody plays its OWN pickup sound (asm FUN_1002bc64 events,
     * channel 10), not one generic chime. */
    {
        struct { unsigned type; int sfx; const char *msg; } g[] = {
            { 0x10, SOI_SFX_PICKUP_SHIELD, "goody: shield pickup plays its own sound (evt 0x18)" },
            { 0x11, SOI_SFX_PICKUP_ARROW,  "goody: arrow ammo plays its own sound (evt 0x19)"   },
            { 0x12, SOI_SFX_PICKUP_BALL,   "goody: ball ammo plays its own sound (evt 0x1a)"    },
            { 0x14, SOI_SFX_PICKUP_TIME,   "goody: time bonus plays its own sound (evt 0x1b)"   },
            { 0x30, SOI_SFX_SHIELD_ON,     "goody: shield activate plays its own sound (evt 0x29)" },
            { 0x31, SOI_SFX_SHOES,         "goody: shoes plays its own sound (evt 0x2a)"        },
            { 0x32, SOI_SFX_ONEUP,         "goody: 1-UP plays its own sound (evt 0x28)"         },
        };
        int k;
        for (k = 0; k < 7; k++) {
            soi_world_init(w, 1);
            w->players[1].active = 1; w->players[1].alive = 1;
            w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
            soi_set_cell(w, 5, 5, g[k].type);
            soi_pickup_check(w, 1);
            CHECK(soi_sfx_count(w) >= 1 && soi_sfx_get(w, 0) == g[k].sfx, g[k].msg);
        }

        /* a colored key (door bit 0x800 + low type 7) plays its own "Announce"
         * sound (evt 0x14), not the generic door/powerup chime */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x807u);
        soi_pickup_check(w, 1);
        CHECK(soi_sfx_count(w) >= 1 && soi_sfx_get(w, 0) == SOI_SFX_KEY,
              "goody: colored key plays its own sound (evt 0x14 -> 17661)");

        /* the ammo/shield goody EFFECTS (asm FUN_1000e9c8/eb34/ec50 -> player +0x46/
         * +0x4c/+0x4a): 0x10 -> shield, 0x11 -> arrows, 0x12 -> balls. 0x10 and 0x12
         * were SWAPPED in our port (ball-fire reads +0x4a, arrow-fire reads +0x4c). */
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x10u); soi_pickup_check(w, 1);
        CHECK(w->players[1].shield == 1 && w->players[1].balls == 0, "goody: 0x10 grants a shield (not a ball)");
        soi_world_init(w, 1);
        w->players[1].active = 1; w->players[1].alive = 1;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(5);
        soi_set_cell(w, 5, 5, 0x12u); soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == 1 && w->players[1].shield == 0, "goody: 0x12 grants a ball (not a shield)");
    }

    /* ---- 8h. The Hammer HOPS (FUN_10007998): it launches into a ballistic arc
     * rather than walking flat, going airborne then landing back on the floor. */
    {
        int hi, y0, t, wasAir = 0;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 4, 10, SOI_CELL_SUPPORTIVE);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);    /* floor to hop along */
        soi_set_cell(w, 6, 10, SOI_CELL_SUPPORTIVE);
        y0 = w->enemies[hi].y;
        for (t = 0; t < 12; t++) {
            soi_enemies_update(w);
            if (w->enemies[hi].y < y0) wasAir = 1;      /* rose above the floor = hopped */
        }
        CHECK(wasAir, "hammer: launches into a hop (goes airborne)");
        CHECK(soi_enemy_active(w, hi), "hammer: survives its hop cycle");
    }

    /* ---- 8i. The Hammer's landing SMASH shatters a DESTRUCTIBLE block underfoot
     * (FUN_10027aec); permanent floors survive. */
    {
        int hi;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 5, 9);
        soi_set_cell(w, 5, 10, 0x201u);                 /* a destructible block underfoot */
        w->enemies[hi].vx = 0;                          /* no drift for the test */
        w->enemies[hi].vy = 4;                          /* descending onto the block */
        soi_enemies_update(w);
        CHECK(!(soi_get_cell(w, 5, 10) & SOI_CELL_SUPPORTIVE),
              "hammer: the landing smash shatters a destructible block underfoot");
        /* a permanent floor is NOT smashed */
        soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE | SOI_CELL_PERMANENT | 0x01u);
        hi = soi_enemy_spawn(w, SOI_ENEMY_HAMMER, 8, 9);
        w->enemies[hi].vx = 0; w->enemies[hi].vy = 4;
        soi_enemies_update(w);
        CHECK((soi_get_cell(w, 8, 10) & SOI_CELL_SUPPORTIVE),
              "hammer: a permanent floor survives the smash");
    }

    /* ---- 9. Sound events are queued for the front-end + reset each tick ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_set_cell(w, 4, 9, 0x17);               /* gold coin under the player */
    soi_pickup_check(w, 1);
    CHECK(soi_sfx_count(w) == 1 && soi_sfx_get(w, 0) == SOI_SFX_COIN_GOLD,
          "sfx: gold coin queues its own SOI_SFX_COIN_GOLD");
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 6, 9);
    soi_enemy_kill(w, 0, 1);
    CHECK(soi_sfx_get(w, 1) == SOI_SFX_KILL_ANT,
          "sfx: killing an Ant queues its own kill sound (per-enemy, not the generic squash)");
    soi_tick(w, 0, 0);
    CHECK(soi_sfx_count(w) == 0, "sfx: queue is cleared at the start of each tick");

    /* 9b. Each coin tier plays a DISTINCT sound (asm FUN_1002bc64 events silver
     * 0x15, gold 0x1c, gem 0x1d, bars 0x1e) instead of one generic coin blip. */
    {
        unsigned tiles[4] = { 0x0A, 0x17, 0x18, 0x19 };
        int want[4] = { SOI_SFX_COIN, SOI_SFX_COIN_GOLD, SOI_SFX_COIN_GEM, SOI_SFX_COIN_BARS };
        const char *msg[4] = {
            "sfx: silver coin -> SOI_SFX_COIN", "sfx: gold coin -> SOI_SFX_COIN_GOLD",
            "sfx: gem -> SOI_SFX_COIN_GEM",     "sfx: gold bars -> SOI_SFX_COIN_BARS" };
        int k;
        for (k = 0; k < 4; k++) {
            soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
            reset_player(w, 1, 4, 9);
            soi_set_cell(w, 4, 9, tiles[k]);
            soi_pickup_check(w, 1);
            CHECK(soi_sfx_get(w, 0) == want[k], msg[k]);
        }
    }

    /* ---- 10. Death → respawn at spawn cell while lives remain; else game over ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    w->players[1].lives = 2;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* enemy on the player -> a hit */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);   /* floor so the nasty stands (gravity) */
    soi_tick(w, 0, 0);   /* the ant contacts the player -> death-throw launches */
    CHECK(soi_player_alive(w, 1) == 1 && w->players[1].ground_state == SOI_ST_DEAD,
          "death: a hit launches the somersault death-throw (still 'alive' mid-arc)");
    {   /* the arc carries the player off the bottom, then commits the life-loss */
        int t;
        for (t = 0; t < 200 && soi_player_alive(w, 1); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_player_alive(w, 1) == 0 && w->players[1].lives == 1,
          "death: the throw ends off-screen and costs a life");
    CHECK(soi_game_over(w) == 0, "respawn: not game over while a life remains");
    {
        int t;
        for (t = 0; t < 120 && !soi_player_alive(w, 1); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_player_alive(w, 1) == 1 &&
          w->players[1].x == soi_cell_x(5) && w->players[1].y == soi_cell_y(9),
          "respawn: player revives at the spawn cell");
    /* burn the last life -> elimination -> game over (one more death-throw) */
    w->players[1].lives = 1; w->players[1].invuln = 0;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
    {
        int t;
        for (t = 0; t < 200 && !soi_game_over(w); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_game_over(w) == 1, "gameover: all active players eliminated");

    /* ---- 11. Level complete = collect the KEY then exit through the DOOR ---- */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        soi_set_cell(w, 4, 9, SOI_TILE_KEY);            /* key on the player cell */
        CHECK(soi_level_complete(w) == 0, "levelclear: not complete before the key");
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "levelclear: key collected");
        CHECK(soi_level_complete(w) == 0, "levelclear: key alone is not the exit");
        /* walk to and enter the door */
        soi_set_cell(w, 10, 9, SOI_CELL_DOOR | 0x01u);
        w->players[1].x = soi_cell_x(10); w->players[1].y = soi_cell_y(9);
        w->bonus_timer = 2000;                          /* remaining round bonus */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "levelclear: exited through the door");
        CHECK(soi_level_complete(w) == 1, "levelclear: key + door exit -> complete");
        CHECK(w->players[1].score == 2000 && w->bonus_timer == 0,
              "levelclear: remaining bonus added to score on exit");
    }

    /* ---- 11b. Colored key/lock/door = the REAL boards' win system. Collecting a
     * colored key (low 7/8/9 + 0x800) sweeps the grid and turns every matching
     * LOCK (low = key-3, i.e. 4/5/6) into an OPENED DOOR (low + 0x8fd => 0x901/2/3
     * = low 1/2/3 + 0x800); stepping on an opened door completes the level. */
    {
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        reset_player(w, 1, 4, 9);
        soi_set_cell(w, 8, 9, 0x0904u);                 /* colored lock (opened by key 7) */
        soi_set_cell(w, 4, 9, 0x0907u);                 /* colored key 7 on the player cell */
        CHECK(soi_level_complete(w) == 0, "colorkey: not complete before the key");
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 1, "colorkey: colored key collected");
        CHECK(soi_get_cell(w, 4, 9) == SOI_CELL_EMPTY, "colorkey: key cell consumed");
        CHECK(soi_get_cell(w, 8, 9) == 0x0901u, "colorkey: matching lock opened into a door");
        CHECK(soi_level_complete(w) == 0, "colorkey: collecting the key is not yet the exit");
        w->players[1].x = soi_cell_x(8); w->players[1].y = soi_cell_y(9);
        w->bonus_timer = 1500;
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "colorkey: exited through the opened door");
        CHECK(soi_level_complete(w) == 1, "colorkey: key + opened-door exit -> complete");
        CHECK(w->players[1].score == 1500 && w->bonus_timer == 0,
              "colorkey: remaining bonus added to score on exit");
    }

    /* ---- 12. The player's Magic Arrow RICOCHETS off a solid block (asm
     * FUN_1000fd5c +0x54==2/3): it turns 90 deg and keeps flying rather than
     * smashing the block. Contrast the Ball (stops) and hostile shots (smash). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x201);                       /* destructible block directly ahead */
    soi_tick(w, SOI_IN_ARROW, 0);                       /* fire -> travels right */
    {
        int t;
        for (t = 0; t < 20; t++) soi_tick(w, 0, 0);     /* it reaches + deflects off the block */
    }
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) != SOI_CELL_EMPTY,
          "arrow: ricochets off a block WITHOUT smashing it");
    CHECK(soi_projectile_count(w) == 1,
          "arrow: keeps flying after the deflect (does not despawn on the block)");

    /* 12d. A ricochet arrow that reaches a wall at FLOOR level must climb (turn
     * up), not get trapped in the corner. Regression: the deflect probe must test
     * the ADJACENT cell, not a bare +/-2px that stays in the arrow's own row and
     * wrongly reads "down" (into the floor) as clear. */
    soi_world_init(w, 1); w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 11);
    ground_player(w, 6, 11);                                             /* player stands (own row) */
    { int c; for (c = 1; c <= 9; c++) soi_set_cell(w, c, 12, 0x300u); }  /* solid floor below the arrow */
    soi_set_cell(w, 3, 11, 0x300u); soi_set_cell(w, 3, 10, 0x300u);      /* wall to the left */
    w->players[1].arrows = 1; w->players[1].facing = -1;                 /* face left */
    soi_tick(w, SOI_IN_ARROW, 0);                                        /* fire left */
    {
        int y0 = w->projectiles[0].y, t;
        for (t = 0; t < 60 && soi_projectile_count(w) == 1; t++) soi_tick(w, 0, 0);
        CHECK(soi_projectile_count(w) == 1, "arrow: survives the floor-corner deflect (not trapped)");
        CHECK(w->projectiles[0].y < y0, "arrow: climbs up the wall at a floor corner");
    }

    /* ---- 12b. A destructible block that hides a PAYLOAD goody (BORD stores the
     * concealed goody in the high 16 bits with bit 0x1000; 326 such cells exist
     * across the real boards) reveals that goody when smashed, and the revealed
     * goody is then collectible. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].arrows = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x09121291u);                 /* supportive block hiding a Magic Ball goody 0x0912 */
    /* The player Arrow now ricochets (no smash); the smash+reveal path is driven
     * by a HOSTILE shot (Cannon/UltraBuster), which DOES smash the player's blocks. */
    w->projectiles[0].active = 1; w->projectiles[0].hostile = 1; w->projectiles[0].kind = 0;
    w->projectiles[0].owner = 0; w->projectiles[0].age = 0;
    w->projectiles[0].x = soi_cell_x(4); w->projectiles[0].y = soi_cell_y(9);
    w->projectiles[0].vx = 8; w->projectiles[0].vy = 0;
    {
        int t;
        for (t = 0; t < 12 && (soi_get_cell(w, 5, 9) & SOI_CELL_SUPPORTIVE); t++)
            soi_projectiles_update(w);
    }
    CHECK(soi_get_cell(w, 5, 9) == 0x0912u,
          "payload: smashing a special block reveals its concealed goody");
    {
        int b0 = w->players[1].balls;
        w->players[1].x = soi_cell_x(5); w->players[1].y = soi_cell_y(9);
        soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == b0 + 1, "payload: the revealed goody is collectible");
    }
    /* A type-0 payload cell (0x1000, e.g. 0x090A1000) is a hidden goody that the
     * original does NOT collect on walk-over (pickup gates on low-byte != 0);
     * it stays put until a reveal trigger. Confirm we faithfully leave it alone. */
    reset_player(w, 1, 7, 9);
    soi_set_cell(w, 7, 9, 0x090A1000u);
    {
        int sc0 = w->players[1].score;
        soi_pickup_check(w, 1);
        CHECK(soi_get_cell(w, 7, 9) == 0x090A1000u && w->players[1].score == sc0,
              "payload: a hidden type-0 payload cell is not collected on walk-over");
    }

    /* ---- 12c. Building a block on a type-0 hidden-payload cell makes the new
     * block INHERIT the payload (asm FUN_1002d04c); breaking it then reveals the
     * goody (12b), so the 218 low-byte-0 payload cells become obtainable. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    ground_player(w, 5, 9);
    w->players[1].facing = 1;                       /* face right */
    w->players[1].block_type = 0x07;
    { /* blanket the front / front-below cells with hidden coins; the block-low
       * verb builds on one and that block must inherit the payload. */
        int c, r, found = 0;
        for (c = 6; c <= 7; c++) for (r = 8; r <= 12; r++) soi_set_cell(w, c, r, 0x090A1000u);
        soi_tick(w, SOI_IN_BLOCK_LOW, 0);           /* build a block in front-below */
        for (c = 6; c <= 7; c++) for (r = 8; r <= 12; r++)
            if (soi_get_cell(w, c, r) == 0x090A1207u) found = 1;
        CHECK(found, "payload: a block built on a hidden-payload cell inherits the goody");
    }

    /* ---- 13. Shoes/Turtles goody (0x31) tames every real nasty: each is
     * defeated for the collecting player on the next enemies update, awarding
     * its points (FUN_1000543c marks enemy +0x88; the nasty self-destructs). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 8, 9);            /* Ant = 50 pts */
    {
        int score0 = w->players[1].score;
        soi_set_cell(w, 5, 9, 0x31);                    /* shoes/turtles on the player cell */
        soi_pickup_check(w, 1);
        CHECK(w->enemies[0].claimed == 1, "shoes: every nasty is claimed by the collector");
        CHECK(soi_get_cell(w, 5, 9) == SOI_CELL_EMPTY, "shoes: the goody is consumed");
        soi_enemies_update(w);
        CHECK(soi_enemy_active(w, 0) == 0, "shoes: a claimed nasty is defeated next update");
        CHECK(w->players[1].score == score0 + 50, "shoes: its points go to the collector");
    }

    /* ---- 14. A Cannon periodically fires a hostile projectile that flies in its
     * facing, and the shot hits the player on contact (asm FUN_100071a0 spawns a
     * flying 0x65). Friendly arrows kill nasties; hostile shots damage players. */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 8, 9);                          /* player to the cannon's right */
    {
        int ci = soi_enemy_spawn(w, SOI_ENEMY_CANNON, 3, 9);
        int lives0, fired = 0, hit = 0, t;
        CHECK(ci >= 0, "cannon: spawned");
        w->enemies[ci].dir = 2;                        /* face right, toward the player */
        w->enemies[ci].fire_cd = 0;                    /* fire on the next update */
        soi_set_cell(w, 3, 10, SOI_CELL_SUPPORTIVE);   /* floor so the cannon stands */
        soi_set_cell(w, 8, 10, SOI_CELL_SUPPORTIVE);   /* floor under the player */
        lives0 = w->players[1].lives;
        for (t = 0; t < 40; t++) {
            soi_enemies_update(w);
            soi_projectiles_update(w);
            if (soi_projectile_count(w) > 0) fired = 1;
            if (w->players[1].lives < lives0 || !soi_player_alive(w, 1) ||
                w->players[1].ground_state == SOI_ST_DEAD) { hit = 1; break; }
        }
        CHECK(fired, "cannon: fired a hostile projectile");
        CHECK(hit, "cannon: the shot hits the player");
    }

    /* ---- 14b. The Cannon's fire cadence is read from the spawn-block delay bytes
     * (b0 StartDelay -> reload*6, b1 SpawnDelay -> initial*6; FUN_1002d980). A
     * synthetic BORD with a cannon block (b0=40,b1=20) yields reload 240 / init 120. */
    {
        uint8_t bord[64];
        int e, found = -1;
        memset(bord, 0, sizeof(bord));
        bord[0x07] = 5; bord[0x09] = 9;                 /* p1 start (col,row), be16 low bytes */
        bord[0x18] = 0x28; bord[0x19] = 0x14;           /* b0=40 (StartDelay), b1=20 (SpawnDelay) */
        bord[0x1A] = 0x05; bord[0x1B] = 0x01;           /* dir-tag 0x05 (spawn+left), type 1 = Cannon */
        bord[0x1C] = 8; bord[0x1D] = 9;                 /* place the cannon at (8,9) */
        bord[0x1E] = 100; bord[0x1F] = 100;             /* record sentinel */
        soi_world_init(w, 1);
        soi_load_level(w, bord, sizeof(bord));
        for (e = 0; e < SOI_MAX_ENEMIES; e++)
            if (w->enemies[e].active && w->enemies[e].type == SOI_ENEMY_CANNON) { found = e; break; }
        CHECK(found >= 0, "cannon-cadence: a cannon spawned from the BORD block");
        CHECK(found >= 0 && w->enemies[found].fire_period == 240,
              "cannon-cadence: reload = StartDelay(40) * 6 = 240");
        CHECK(found >= 0 && w->enemies[found].fire_cd == 120,
              "cannon-cadence: initial = SpawnDelay(20) * 6 = 120");
    }

    /* ---- 14c. Gargoyle (16) and Knight (17) are STATIONARY turrets, not walkers
     * (verified: FUN_10008618/FUN_10008b18 never write their own +0x58/+0x5a).
     * Our port previously gave them walking speed; they must hold their ground. */
    {
        int gi, ki, gx0, kx0, t;
        soi_world_init(w, 1);
        w->level_loaded = 1; w->pct_badguy = 0;
        gi = soi_enemy_spawn(w, SOI_ENEMY_GARGOYLE, 5, 9);
        ki = soi_enemy_spawn(w, SOI_ENEMY_KNIGHT, 10, 9);
        soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);    /* floor so the turrets stand */
        soi_set_cell(w, 10, 10, SOI_CELL_SUPPORTIVE);
        gx0 = soi_enemy_x(w, gi); kx0 = soi_enemy_x(w, ki);
        for (t = 0; t < 20; t++) soi_enemies_update(w);
        CHECK(soi_enemy_x(w, gi) == gx0, "turret: the Gargoyle holds its ground (stationary)");
        CHECK(soi_enemy_x(w, ki) == kx0, "turret: the Knight holds its ground (stationary)");
    }

    /* ---- 15. Magic Ball: a distinct weapon (asm fire FUN_100110b4, mover
     * FUN_1000fd5c +0x54==1). It rolls horizontally at a fixed height, kills any
     * nasty it rolls over, and STOPS DEAD at a solid block WITHOUT smashing it
     * (unlike the Arrow). Separate ball ammo (+0x4a, the 0x10 pickup). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 2;
    w->players[1].arrows = 0;
    w->players[1].facing = 1;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);            /* two cells to the right */
    soi_set_cell(w, 5, 10, SOI_CELL_SUPPORTIVE);        /* floor so the nasty stands */
    soi_tick(w, SOI_IN_BALL, 0);                        /* fire the ball */
    CHECK(w->players[1].balls == 1, "ball: firing consumed one ball");
    CHECK(soi_projectile_count(w) == 1, "ball: a ball is in flight");
    CHECK(soi_projectile_active(w, 0) == 1 && soi_projectile_kind(w, 0) == 1,
          "ball: the projectile reports kind = Magic Ball");
    {
        int t;
        for (t = 0; t < 24 && soi_enemy_count(w) > 0; t++)
            soi_tick(w, 0, 0);                          /* the ball rolls right */
    }
    CHECK(soi_enemy_count(w) == 0, "ball: the rolling ball killed the nasty");

    /* 15b. The ball stops at a solid block and does NOT smash it (contrast the
     * Arrow, which clears the block in test 12). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    w->players[1].balls = 1;
    w->players[1].facing = 1;
    soi_set_cell(w, 5, 9, 0x201);                       /* destructible block ahead */
    soi_tick(w, SOI_IN_BALL, 0);
    {
        int t;
        for (t = 0; t < 24 && soi_projectile_count(w) > 0; t++)
            soi_tick(w, 0, 0);
    }
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 5, 9)) != SOI_CELL_EMPTY,
          "ball: a solid block in the path is NOT smashed");
    CHECK(soi_projectile_count(w) == 0, "ball: the ball despawns when it hits the block");

    /* 15c. The 0x12 pickup is Magic Ball ammo (not a life): collecting it bumps
     * the ball count (CONFIRMED FUN_1002bc64 -> FUN_1000ec50 adds +0x4a). */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 3, 9);
    ground_player(w, 3, 9);
    {
        int b0 = w->players[1].balls;
        soi_set_cell(w, 3, 9, 0x12);                    /* magic-ball goody on the player's cell */
        soi_pickup_check(w, 1);
        CHECK(w->players[1].balls == b0 + 1, "ball: the 0x12 pickup grants ball ammo");
    }

    free(w);
    if (failures) { printf("\n%d CHECK(S) FAILED\n", failures); return 1; }
    printf("\nALL MECHANIC TESTS PASSED\n");
    return 0;
}
