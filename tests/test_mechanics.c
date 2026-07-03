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
    p->lives = 3; p->block_type = 1;
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
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 4, 9);   /* one cell to the right */
    CHECK(soi_enemy_count(w) == 1, "arrow: enemy present before firing");
    CHECK(soi_enemy_active(w, 0) == 1 && soi_enemy_type(w, 0) == SOI_ENEMY_ANT,
          "accessor: enemy slot 0 active + type readable");
    CHECK(soi_enemy_x(w, 0) == soi_cell_x(4) && soi_enemy_y(w, 0) == soi_cell_y(9),
          "accessor: enemy pixel position readable");

    soi_tick(w, SOI_IN_ARROW, 0);              /* fire once */
    CHECK(w->players[1].arrows == 1, "arrow: firing consumed one arrow");
    CHECK(soi_projectile_count(w) == 1, "arrow: a projectile is in flight");

    {
        int t;
        for (t = 0; t < 12 && soi_enemy_count(w) > 0; t++)
            soi_tick(w, 0, 0);                 /* idle while the arrow travels */
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
    soi_tick(w, 0, 0);
    CHECK(soi_player_alive(w, 1) == 1, "shield: player survives the hit");
    CHECK(w->players[1].shield == 0, "shield: one shield was spent");
    CHECK(w->players[1].invuln > 0,  "shield: i-frames granted after absorb");

    /* ---- 3. Jump breaks the (non-permanent) block directly above ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);                     /* stand so the jump can launch */
    soi_set_cell(w, 6, 8, 1);                  /* breakable block above head */
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(SOI_CELL_TYPE(soi_get_cell(w, 6, 8)) == SOI_CELL_EMPTY,
          "jump: block above the head was destroyed");

    /* a permanent block above must survive a jump */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 6, 9);
    ground_player(w, 6, 9);
    soi_set_cell(w, 6, 8, SOI_WALL);
    soi_tick(w, SOI_IN_JUMP, 0);
    CHECK(soi_get_cell(w, 6, 8) == SOI_WALL, "jump: permanent block is untouched");

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

    /* ---- 5. Clock pickup adds bonus time (capped at 30000) ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    w->bonus_timer = 5000;
    soi_set_cell(w, 4, 9, 0x2E);
    soi_pickup_check(w, 1);
    CHECK(w->bonus_timer == 5600, "clock: adds 600 bonus time");
    w->bonus_timer = 29900;
    soi_set_cell(w, 4, 9, 0x2E);
    soi_pickup_check(w, 1);
    CHECK(w->bonus_timer == 30000, "clock: bonus time capped at 30000");
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
    {
        int ex0 = soi_enemy_x(w, 0);
        soi_tick(w, 0, 0);
        CHECK(soi_enemy_x(w, 0) < ex0,
              "seek: wheelie steers left toward the player (overriding default)");
    }

    /* ---- 9. Sound events are queued for the front-end + reset each tick ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 4, 9);
    soi_set_cell(w, 4, 9, 0x17);               /* gold coin under the player */
    soi_pickup_check(w, 1);
    CHECK(soi_sfx_count(w) == 1 && soi_sfx_get(w, 0) == SOI_SFX_COIN,
          "sfx: coin pickup queues SOI_SFX_COIN");
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 6, 9);
    soi_enemy_kill(w, 0, 1);
    CHECK(soi_sfx_get(w, 1) == SOI_SFX_ENEMY_KILL,
          "sfx: enemy kill queues SOI_SFX_ENEMY_KILL");
    soi_tick(w, 0, 0);
    CHECK(soi_sfx_count(w) == 0, "sfx: queue is cleared at the start of each tick");

    /* ---- 10. Death → respawn at spawn cell while lives remain; else game over ---- */
    soi_world_init(w, 1);
    w->level_loaded = 1; w->pct_badguy = 0;
    reset_player(w, 1, 5, 9);
    w->players[1].lives = 2;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);   /* enemy on the player -> a hit */
    soi_tick(w, 0, 0);
    CHECK(soi_player_alive(w, 1) == 0 && w->players[1].lives == 1,
          "respawn: a hit downs the player and costs a life");
    CHECK(soi_game_over(w) == 0, "respawn: not game over while a life remains");
    {
        int t;
        for (t = 0; t < 95 && !soi_player_alive(w, 1); t++)
            soi_tick(w, 0, 0);
    }
    CHECK(soi_player_alive(w, 1) == 1 &&
          w->players[1].x == soi_cell_x(5) && w->players[1].y == soi_cell_y(9),
          "respawn: player revives at the spawn cell");
    /* burn the last life -> elimination -> game over */
    w->players[1].lives = 1; w->players[1].invuln = 0;
    soi_enemy_spawn(w, SOI_ENEMY_ANT, 5, 9);
    soi_tick(w, 0, 0);
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
        soi_pickup_check(w, 1);
        CHECK(w->players[1].has_key == 2, "levelclear: exited through the door");
        CHECK(soi_level_complete(w) == 1, "levelclear: key + door exit -> complete");
    }

    free(w);
    if (failures) { printf("\n%d CHECK(S) FAILED\n", failures); return 1; }
    printf("\nALL MECHANIC TESTS PASSED\n");
    return 0;
}
