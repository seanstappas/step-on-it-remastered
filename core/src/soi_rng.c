/* soi_rng.c — reproduction of the classic Mac Toolbox Random().
 *
 * Random() is InterfaceLib code (not in the game binary), so it is reimplemented
 * from its documented behaviour: the minimal-standard Park-Miller LCG
 *     seed = (seed * 16807) mod (2^31 - 1)
 * computed with Schrage's method (overflow-safe in 32-bit), returning the low
 * 16 bits interpreted as a signed short — the value range Random() yields.
 *
 * The game never seeds randSeed (CONFIRMED), so the Toolbox default seed of 1
 * is the canonical start. The LCG itself is validated against the canonical
 * Park-Miller checkpoint (seed 1 -> 10000th iterate == 1043618065; see
 * test_mechanics.c test 21), so our Schrage's-method stream is proven exact.
 * TODO(oracle): confirm Mac Random() IS this minimal-standard stream (not a
 * variant) + its return-bit mapping, against real draws captured from the
 * emulator (MASTER_PLAN §5.3).
 */
#include "soi_internal.h"

#define SOI_RNG_A 16807
#define SOI_RNG_M 2147483647   /* 2^31 - 1 */
#define SOI_RNG_Q 127773       /* M / A */
#define SOI_RNG_R 2836         /* M % A */

void soi_rng_seed(SoiWorld *w, uint32_t seed)
{
    /* seed must be in [1, M-1]; 0 collapses the generator. */
    int32_t s = (int32_t)(seed % SOI_RNG_M);
    if (s <= 0) s = 1;
    w->rng_seed = (uint32_t)s;
}

/* Advance the LCG and return Random()'s signed-16-bit result. */
int32_t soi_rng_next(SoiWorld *w)
{
    int32_t seed = (int32_t)w->rng_seed;
    int32_t hi = seed / SOI_RNG_Q;
    int32_t lo = seed % SOI_RNG_Q;
    seed = SOI_RNG_A * lo - SOI_RNG_R * hi;
    if (seed <= 0) seed += SOI_RNG_M;
    w->rng_seed = (uint32_t)seed;
    /* Toolbox Random() returns a signed 16-bit value. */
    return (int16_t)(seed & 0xFFFF);
}

/* RandomInRange(1, n): ((Random() & 0x7fff) * n) / 0x7fff + 1, clamped to n.
 * Matches FUN_1000c278 / FUN_1000cbe0 (CONFIRMED). */
int soi_rand_range(SoiWorld *w, int n)
{
    int r;
    if (n < 1) return 0;
    r = (int)(((int32_t)(soi_rng_next(w) & 0x7FFF) * n) / 0x7FFF) + 1;
    if (r > n) r = n;
    return r;
}
