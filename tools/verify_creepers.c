/* verify_creepers.c -- dynamic safety net for the Creeper chain (asm FUN_10008618/8b18).
 *
 * The winnability check (verify_winnable.c) is static and never steps enemies, so it cannot
 * see a Creeper segment that fails to restore its tile. This runs every board that holds a
 * Creeper for many thousands of ticks -- idle and with deterministic pseudo-random input --
 * and checks, EVERY tick, that
 *   1. every cell carrying the wall bits (0x300) that was not a wall at load holds a live
 *      Creeper segment (no leaked wall can seal a route), and each segment sits on a wall;
 *   2. no two segments share a cell;
 *   3. the board never runs out of Creeper segments (a chain never dies out).
 * Usage: verify_creepers <board.bord>...   Prints one line per board; exit 1 on any failure. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "soi_internal.h"

static int board_has_creeper(const SoiWorld *w)
{
    int i;
    for (i = 0; i < SOI_MAX_ENEMIES; i++)
        if (w->enemies[i].active && w->enemies[i].type == SOI_ENEMY_CREEPER) return 1;
    return 0;
}

static int check(const SoiWorld *w, const uint8_t *wall0, int *nseg_out, char *why, size_t n)
{
    int c, r, i, nseg = 0;
    static int owner[SOI_GRID_COLS][SOI_GRID_ROWS];
    memset(owner, 0, sizeof owner);
    for (i = 0; i < SOI_MAX_ENEMIES; i++) {
        const SoiEnemy *e = &w->enemies[i];
        if (!e->active || e->type != SOI_ENEMY_CREEPER) continue;
        c = (e->x - SOI_ORIGIN_X) / SOI_CELL_PX; r = (e->y - SOI_ORIGIN_Y) / SOI_CELL_PX;
        if (!soi_in_bounds(c, r)) { snprintf(why, n, "segment %d off the grid", i); return 0; }
        if (owner[c][r]) { snprintf(why, n, "two segments on (%d,%d)", c, r); return 0; }
        owner[c][r] = i + 1;
        if ((soi_get_cell(w, c, r) & SOI_WALL) != SOI_WALL) { snprintf(why, n, "segment on a non-wall (%d,%d)", c, r); return 0; }
        nseg++;
    }
    for (c = 0; c < SOI_GRID_COLS; c++)
        for (r = 0; r < SOI_GRID_ROWS; r++)
            if ((soi_get_cell(w, c, r) & SOI_WALL) == SOI_WALL && !wall0[c * SOI_GRID_ROWS + r] && !owner[c][r]) {
                snprintf(why, n, "leaked wall at (%d,%d) = 0x%X", c, r, (unsigned)soi_get_cell(w, c, r));
                return 0;
            }
    *nseg_out = nseg;
    return 1;
}

static int run(const uint8_t *bord, size_t len, int ticks, int random_input, char *why, size_t n)
{
    SoiWorld *w = calloc(1, sizeof *w);
    uint8_t wall0[SOI_GRID_COLS * SOI_GRID_ROWS];
    uint32_t seed = 12345u;
    int t, c, r, i, nseg, ok = 1;
    soi_world_init(w, 1);
    soi_load_level(w, bord, len);
    for (c = 0; c < SOI_GRID_COLS; c++)
        for (r = 0; r < SOI_GRID_ROWS; r++) {
            int seg = 0;
            for (i = 0; i < SOI_MAX_ENEMIES; i++)
                if (w->enemies[i].active && w->enemies[i].type == SOI_ENEMY_CREEPER &&
                    (w->enemies[i].x - SOI_ORIGIN_X) / SOI_CELL_PX == c &&
                    (w->enemies[i].y - SOI_ORIGIN_Y) / SOI_CELL_PX == r) seg = 1;
            wall0[c * SOI_GRID_ROWS + r] = (uint8_t)(!seg && (soi_get_cell(w, c, r) & SOI_WALL) == SOI_WALL);
        }
    for (t = 0; t < ticks && ok; t++) {
        uint8_t in1 = 0, in2 = 0;
        if (random_input) {
            seed = seed * 1103515245u + 12345u; in1 = (uint8_t)((seed >> 16) & 0x7F);
            seed = seed * 1103515245u + 12345u; in2 = (uint8_t)((seed >> 16) & 0x7F);
        }
        for (i = 1; i < SOI_MAX_PLAYERS; i++) w->players[i].invuln = 100;   /* keep everyone in play */
        w->players[1].bonus_time = 5000; w->players[2].bonus_time = 5000;
        soi_tick(w, in1, in2);
        if (soi_level_complete(w) || soi_game_over(w)) { soi_load_level(w, bord, len); continue; }
        if (!check(w, wall0, &nseg, why, n)) ok = 0;
        else if (nseg == 0) { snprintf(why, n, "all Creeper segments vanished at tick %d", t); ok = 0; }
        if (!ok) snprintf(why + strlen(why), n - strlen(why), " (tick %d)", t);
    }
    free(w);
    return ok;
}

int main(int argc, char **argv)
{
    static uint8_t buf[65536];
    int k, fails = 0, boards = 0;
    for (k = 1; k < argc; k++) {
        FILE *f = fopen(argv[k], "rb");
        size_t len;
        SoiWorld *probe;
        char why[160] = "";
        if (!f) continue;
        len = fread(buf, 1, sizeof buf, f); fclose(f);
        probe = calloc(1, sizeof *probe);
        soi_world_init(probe, 1); soi_load_level(probe, buf, len);
        if (!board_has_creeper(probe)) { free(probe); continue; }
        free(probe);
        boards++;
        if (!run(buf, len, 20000, 0, why, sizeof why) || !run(buf, len, 20000, 1, why, sizeof why)) {
            printf("FAIL %s: %s\n", argv[k], why);
            fails++;
        } else {
            printf("ok   %s\n", argv[k]);
        }
    }
    printf("=== %d Creeper boards: %d FAILED ===\n", boards, fails);
    return fails ? 1 : 0;
}
