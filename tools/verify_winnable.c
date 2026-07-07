/* verify_winnable.c — load each real .bord through the core and confirm its
 * colored-key/lock/door exit actually completes the level. Proves the colored
 * key/lock win system works on real board data (not just synthetic test cells).
 * Usage: verify_winnable <file.bord> [file.bord ...]   Exit 0 = all winnable. */
#include <stdio.h>
#include <stdlib.h>
#include "soi_internal.h"

/* Run one board end-to-end. Returns: 0 winnable, 1 broken (key but no exit),
 * 2 no key present (informational, not a failure). */
static int check_board(const char *path, int verbose)
{
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "open failed: %s\n", path); return 3; }
    fseek(f, 0, SEEK_END); long len = ftell(f); fseek(f, 0, SEEK_SET);
    unsigned char *b = (unsigned char *)malloc((size_t)len);
    if (!b || fread(b, 1, (size_t)len, f) != (size_t)len) { fclose(f); return 3; }
    fclose(f);

    SoiWorld *w = (SoiWorld *)malloc(soi_world_size());
    soi_world_init(w, 1);
    soi_load_level(w, b, (size_t)len);
    free(b);

    int keys[3] = {0,0,0}, locks[3] = {0,0,0};
    int kcol = -1, krow = -1, r, c;
    /* A board may CONCEAL its colored key inside a payload block (e.g. board_489
     * hides key 7 in 0x09071291); the player smashes the block to expose it.
     * Simulate that here so the check reflects real play. */
    for (r = 0; r < SOI_GRID_ROWS; r++)
        for (c = 0; c < SOI_GRID_COLS; c++) {
            uint32_t cell = soi_get_cell(w, c, r);
            if (cell & SOI_CELL_SPECIAL) {
                unsigned pt = (cell >> 16) & 0xFFu;
                if (pt >= 7 && pt <= 9) soi_set_cell(w, c, r, SOI_CELL_PAYLOAD(cell));
            }
        }
    for (r = 0; r < SOI_GRID_ROWS; r++)
        for (c = 0; c < SOI_GRID_COLS; c++) {
            uint32_t cell = soi_get_cell(w, c, r);
            unsigned t = SOI_CELL_TYPE(cell);
            if (!(cell & SOI_CELL_DOOR)) continue;
            if (t >= 7 && t <= 9) { keys[t-7]++;
                /* simulate PLAYER 1: pick the first key P1 can actually collect --
                 * universal (7) or P1's own (8) -- matching the player-gated
                 * soi_pickup_check (P2's key 9 is not P1-collectible / not P1-winnable). */
                if (kcol < 0 && (t == 7 || t == 8)) { kcol = c; krow = r; } }
            if (t >= 4 && t <= 6) locks[t-4]++;
        }

    int rc;
    if (kcol < 0) {
        rc = 2;                                 /* no colored key on this board */
    } else {
        /* collect the first key, then step on the door it opens */
        w->players[1].x = soi_cell_x(kcol); w->players[1].y = soi_cell_y(krow);
        soi_pickup_check(w, 1);
        int dcol = -1, drow = -1;
        for (r = 0; r < SOI_GRID_ROWS && dcol < 0; r++)
            for (c = 0; c < SOI_GRID_COLS; c++) {
                uint32_t cell = soi_get_cell(w, c, r);
                unsigned t = SOI_CELL_TYPE(cell);
                if ((cell & SOI_CELL_DOOR) && t >= 1 && t <= 3) { dcol = c; drow = r; break; }
            }
        if (dcol < 0) { rc = 1; }               /* key opened no door -> broken */
        else {
            w->players[1].x = soi_cell_x(dcol); w->players[1].y = soi_cell_y(drow);
            soi_pickup_check(w, 1);
            rc = soi_level_complete(w) ? 0 : 1;
        }
    }

    if (verbose || rc == 1) {
        printf("%-40s keys=%d/%d/%d locks=%d/%d/%d  %s\n", path,
               keys[0],keys[1],keys[2], locks[0],locks[1],locks[2],
               rc == 0 ? "WINNABLE" : rc == 2 ? "(no key)" : "*** BROKEN ***");
    }
    free(w);
    return rc;
}

int main(int argc, char **argv)
{
    if (argc < 2) { fprintf(stderr, "usage: verify_winnable <file.bord> [...]\n"); return 2; }
    int verbose = (argc == 2);                  /* dump detail for a single board */
    int nwin = 0, nbroken = 0, nokey = 0, i;
    for (i = 1; i < argc; i++) {
        int rc = check_board(argv[i], verbose);
        if (rc == 0) nwin++; else if (rc == 1) nbroken++; else if (rc == 2) nokey++;
    }
    printf("\n=== %d boards: %d winnable, %d no-key, %d BROKEN ===\n",
           argc - 1, nwin, nokey, nbroken);
    return nbroken ? 1 : 0;
}
