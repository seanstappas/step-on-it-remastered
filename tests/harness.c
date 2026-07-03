/* harness.c — minimal host driver for the core: build a small level, tick it,
 * and print state + the deterministic hash. Proves the core compiles, runs, and
 * is reproducible. Later this grows into the fixture replayer (MASTER_PLAN §6).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "soi_core.h"

/* Build a tiny synthetic BORD in memory: 26-byte header + one wall-row record. */
static size_t make_test_bord(unsigned char *b, size_t cap)
{
    size_t n = 0;
    memset(b, 0, cap);
    /* header */
    b[0x06] = 0; b[0x07] = 3;   /* P1 col = 3 */
    b[0x08] = 0; b[0x09] = 11;  /* P1 row = 11 (on the floor) */
    b[0x0A] = 0; b[0x0B] = 9;   /* P2 col = 9 */
    b[0x0C] = 0; b[0x0D] = 11;  /* P2 row = 11 */
    b[0x16] = 0x13; b[0x17] = 0x88; /* bonus = 5000 */
    n = 0x18;
    /* one tile record: type 0x300 (permanent) along the bottom row 12 (floor),
     * across all 19 columns. Record coords are (col, row). */
    b[n++] = 0x00; b[n++] = 0x00; b[n++] = 0x03; b[n++] = 0x00; /* tile_type u32 = 0x300 */
    for (int c = 0; c < 19; c++) { b[n++] = (unsigned char)c; b[n++] = 12; } /* (col=c,row=12) */
    b[n++] = 100; b[n++] = 100; /* sentinel */
    b[n++] = 0x00; b[n++] = 0x00; b[n++] = 0x00; b[n++] = 0x00; /* tile_type 0 = end */
    return n;
}

int main(void)
{
    size_t sz = soi_world_size();
    SoiWorld *w = (SoiWorld *)malloc(sz);
    unsigned char bord[256];
    size_t blen;
    int t;

    if (!w) { fprintf(stderr, "alloc failed\n"); return 1; }
    printf("SoiWorld size = %zu bytes\n", sz);

    soi_world_init(w, 1);
    blen = make_test_bord(bord, sizeof(bord));
    if (!soi_load_level(w, bord, blen)) { fprintf(stderr, "load_level failed\n"); free(w); return 1; }

    printf("loaded: P1=(%d,%d) P2=(%d,%d) bonus=%d\n",
           soi_player_x(w, 1), soi_player_y(w, 1),
           soi_player_x(w, 2), soi_player_y(w, 2), soi_bonus_time(w));

    /* drive P1 right for a few ticks, P2 idle */
    for (t = 0; t < 20; t++)
        soi_tick(w, SOI_IN_RIGHT, 0);

    printf("after 20 ticks: P1 x=%d y=%d score=%d  tick=%u  enemies=%d\n",
           soi_player_x(w, 1), soi_player_y(w, 1),
           soi_player_score(w, 1), soi_tick_count(w), soi_enemy_count(w));
    printf("state hash = 0x%016llx\n", (unsigned long long)soi_state_hash(w));

    /* determinism check: a fresh identical run must hash identically. */
    {
        SoiWorld *w2 = (SoiWorld *)malloc(sz);
        soi_world_init(w2, 1);
        soi_load_level(w2, bord, blen);
        for (t = 0; t < 20; t++) soi_tick(w2, SOI_IN_RIGHT, 0);
        printf("determinism: %s\n",
               soi_state_hash(w) == soi_state_hash(w2) ? "PASS" : "FAIL");
        free(w2);
    }

    free(w);
    return 0;
}
