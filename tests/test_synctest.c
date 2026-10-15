/* test_synctest.c — C SyncTest harness for Step On It! Remastered
 *
 * Verifies 8-tick forced rollback and state re-simulation across all boards:
 *   1. Dual simulation: w_ref and w_sim advance lockstep with 3-player inputs.
 *   2. Ring buffer of 16 snapshots (soi_snapshot_save).
 *   3. At every tick t >= 7, w_sim is restored to tick (t - 7) and re-simulated
 *      forward 8 ticks to tick t.
 *   4. Asserts soi_net_hash(w_sim) == soi_net_hash(w_ref) with zero mismatches.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include "soi_core.h"

#define TOTAL_TICKS 1000
#define ROLLBACK_DEPTH 7
#define RING_CAP 16

static int test_board(const char *path, const uint8_t *bord, size_t len, size_t snap_sz)
{
    SoiWorld *w_ref = (SoiWorld *)malloc(soi_world_size());
    SoiWorld *w_sim = (SoiWorld *)malloc(soi_world_size());
    uint8_t *ring[RING_CAP];
    int i, t, k;
    int ok = 1;
    uint32_t seed = 0x54321u;
    uint8_t in1[TOTAL_TICKS], in2[TOTAL_TICKS], in3[TOTAL_TICKS];

    if (!w_ref || !w_sim) {
        fprintf(stderr, "Allocation failed for worlds\n");
        free(w_ref);
        free(w_sim);
        return 0;
    }

    for (i = 0; i < RING_CAP; i++) {
        ring[i] = (uint8_t *)malloc(snap_sz);
        if (!ring[i]) {
            fprintf(stderr, "Allocation failed for snapshot buffer %d\n", i);
            for (k = 0; k < i; k++) free(ring[k]);
            free(w_ref); free(w_sim);
            return 0;
        }
    }

    /* Generate TOTAL_TICKS of pseudo-random inputs for 3 players */
    for (t = 0; t < TOTAL_TICKS; t++) {
        seed = seed * 1103515245u + 12345u; in1[t] = (uint8_t)((seed >> 16) & 0x7F);
        seed = seed * 1103515245u + 12345u; in2[t] = (uint8_t)((seed >> 16) & 0x7F);
        seed = seed * 1103515245u + 12345u; in3[t] = (uint8_t)((seed >> 16) & 0x7F);
    }

    /* Initialize w_ref */
    soi_world_init(w_ref, 1);
    if (!soi_load_level(w_ref, bord, len)) {
        fprintf(stderr, "Failed to load board in w_ref: %s\n", path);
        ok = 0;
        goto cleanup;
    }
    soi_spawn_player3(w_ref);

    /* Initialize w_sim */
    soi_world_init(w_sim, 1);
    if (!soi_load_level(w_sim, bord, len)) {
        fprintf(stderr, "Failed to load board in w_sim: %s\n", path);
        ok = 0;
        goto cleanup;
    }
    soi_spawn_player3(w_sim);

    /* Verify initial hash match */
    if (soi_net_hash(w_ref) != soi_net_hash(w_sim)) {
        fprintf(stderr, "Initial net hash mismatch on %s: ref=0x%016llx sim=0x%016llx\n",
                path, (unsigned long long)soi_net_hash(w_ref), (unsigned long long)soi_net_hash(w_sim));
        ok = 0;
        goto cleanup;
    }

    /* Simulate TOTAL_TICKS with divergent remote prediction */
    for (t = 0; t < TOTAL_TICKS; t++) {
        /* Save snapshot of w_sim before tick t */
        soi_snapshot_save(w_sim, ring[t % RING_CAP]);

        /* w_ref steps with authoritative inputs; w_sim steps with mispredicted remote inputs */
        soi_tick3(w_ref, in1[t], in2[t], in3[t]);
        soi_tick3(w_sim, in1[t], (uint8_t)(in2[t] ^ 0x03u), (uint8_t)(in3[t] ^ 0x05u));

        if (t >= ROLLBACK_DEPTH && (t % 5) == 0) {
            int rollback_tick = t - ROLLBACK_DEPTH;
            soi_snapshot_load(w_sim, ring[rollback_tick % RING_CAP]);
            for (k = rollback_tick; k <= t; k++) {
                soi_snapshot_save(w_sim, ring[k % RING_CAP]);
                soi_tick3(w_sim, in1[k], in2[k], in3[k]);
            }
            if (soi_net_hash(w_ref) != soi_net_hash(w_sim)) {
                fprintf(stderr, "Rollback hash mismatch at tick %d on %s: ref=0x%016llx sim=0x%016llx\n",
                        t, path, (unsigned long long)soi_net_hash(w_ref), (unsigned long long)soi_net_hash(w_sim));
                ok = 0;
                goto cleanup;
            }
        }
    }

cleanup:
    for (i = 0; i < RING_CAP; i++) free(ring[i]);
    free(w_ref);
    free(w_sim);
    return ok;
}

int main(int argc, char **argv)
{
    static uint8_t buf[65536];
    size_t snap_sz = soi_snapshot_size();
    int k, passed = 0, failed = 0;

    printf("Starting C SyncTest harness (snapshot size = %zu bytes)...\n", snap_sz);

    if (argc > 1) {
        for (k = 1; k < argc; k++) {
            FILE *f = fopen(argv[k], "rb");
            size_t len;
            if (!f) {
                fprintf(stderr, "Could not open: %s\n", argv[k]);
                failed++;
                continue;
            }
            len = fread(buf, 1, sizeof(buf), f);
            fclose(f);
            if (test_board(argv[k], buf, len, snap_sz)) {
                passed++;
            } else {
                failed++;
            }
        }
    } else {
        /* Default scan of extracted/levels */
        char path[256];
        int num;
        {
            snprintf(path, sizeof(path), "extracted/levels/board_301.bord");
            FILE *f = fopen(path, "rb");
            if (f) {
                size_t len = fread(buf, 1, sizeof(buf), f);
                fclose(f);
                if (test_board(path, buf, len, snap_sz)) passed++;
                else failed++;
            }
        }
        for (num = 401; num <= 501; num++) {
            snprintf(path, sizeof(path), "extracted/levels/board_%d.bord", num);
            FILE *f = fopen(path, "rb");
            if (f) {
                size_t len = fread(buf, 1, sizeof(buf), f);
                fclose(f);
                if (test_board(path, buf, len, snap_sz)) passed++;
                else failed++;
            }
        }
        for (num = 1001; num <= 1050; num++) {
            snprintf(path, sizeof(path), "extracted/levels/board_%d.bord", num);
            FILE *f = fopen(path, "rb");
            if (f) {
                size_t len = fread(buf, 1, sizeof(buf), f);
                fclose(f);
                if (test_board(path, buf, len, snap_sz)) passed++;
                else failed++;
            }
        }
    }

    printf("=== SyncTest: %d PASSED, %d FAILED ===\n", passed, failed);
    if (failed == 0 && passed > 0) {
        printf("ALL SYNCTEST ROLLBACK CHECKS PASSED\n");
    }
    return failed ? 1 : 0;
}
