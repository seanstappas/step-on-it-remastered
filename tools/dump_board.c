/* dump_board.c — load a .bord and report where the player stands vs support,
 * then tick a few frames to see whether it rests stably or oscillates. */
#include <stdio.h>
#include <stdlib.h>
#include "soi_core.h"

int main(int argc, char **argv)
{
    if (argc < 2) { fprintf(stderr, "usage: dump_board <file.bord>\n"); return 2; }
    FILE *f = fopen(argv[1], "rb");
    if (!f) { fprintf(stderr, "open failed\n"); return 2; }
    fseek(f, 0, SEEK_END); long len = ftell(f); fseek(f, 0, SEEK_SET);
    unsigned char *b = (unsigned char *)malloc((size_t)len);
    if (fread(b, 1, (size_t)len, f) != (size_t)len) { return 2; }
    fclose(f);

    SoiWorld *w = (SoiWorld *)malloc(soi_world_size());
    soi_world_init(w, 1);
    soi_load_level(w, b, (size_t)len);

    int px = soi_player_x(w, 1), py = soi_player_y(w, 1);
    int pcol = (px - 16) / 32, prow = (py - 48) / 32;
    printf("P1 pixel=(%d,%d) => col=%d row=%d\n", px, py, pcol, prow);
    printf("enemies spawned: %d\n", soi_enemy_count(w));
    for (int i = 0; i < 32; i++) {
        if (!soi_enemy_active(w, i)) continue;
        int ex = soi_enemy_x(w, i), ey = soi_enemy_y(w, i);
        printf("  enemy[%d] type=%d at col=%d row=%d\n", i, soi_enemy_type(w, i),
               (ex - 16) / 32, (ey - 48) / 32);
    }
    printf("support column %d (bit 0x200 per row):\n", pcol);
    for (int r = 0; r < SOI_GRID_ROWS; r++) {
        unsigned c = (unsigned)soi_grid_cell(w, pcol, r);
        printf("  row %2d: cell=0x%04x %s%s\n", r, c,
               (c & 0x200) ? "SUPPORTIVE " : "",
               (r == prow) ? "<= player row" : "");
    }
    printf("tick trace (enemy[0] path):\n");
    for (int t = 0; t < 260; t++) {
        soi_tick(w, 0, 0);
        if (t % 20 == 0 && soi_enemy_active(w, 0)) {
            int ex = soi_enemy_x(w, 0), ey = soi_enemy_y(w, 0);
            printf("  t=%3d enemy col=%2d row=%2d (x=%d y=%d)\n", t,
                   (ex - 16) / 32, (ey - 48) / 32, ex, ey);
        }
    }
    return 0;
}
