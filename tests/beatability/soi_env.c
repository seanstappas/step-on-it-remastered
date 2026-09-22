#include "soi_env.h"

#include <stdio.h>
#include <stdlib.h>

#include "soi_core.h"

struct SoiEnv {
    SoiWorld *world;
};

static int cell_from_x(int x)
{
    int col = (x + 12 - SOI_ORIGIN_X) / SOI_CELL_PX;
    if (col < 0) return 0;
    if (col >= SOI_GRID_COLS) return SOI_GRID_COLS - 1;
    return col;
}

static int cell_from_y(int y)
{
    int row = (y + 16 - SOI_ORIGIN_Y) / SOI_CELL_PX;
    if (row < 0) return 0;
    if (row >= SOI_GRID_ROWS) return SOI_GRID_ROWS - 1;
    return row;
}

static int read_file(const char *path, uint8_t **out, size_t *out_len)
{
    FILE *f;
    long len;
    uint8_t *buf;

    *out = NULL;
    *out_len = 0;

    f = fopen(path, "rb");
    if (!f) return 0;
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return 0; }
    len = ftell(f);
    if (len < 0) { fclose(f); return 0; }
    if (fseek(f, 0, SEEK_SET) != 0) { fclose(f); return 0; }

    buf = (uint8_t *)malloc((size_t)len ? (size_t)len : 1u);
    if (!buf) { fclose(f); return 0; }
    if (len > 0 && fread(buf, 1u, (size_t)len, f) != (size_t)len) {
        free(buf);
        fclose(f);
        return 0;
    }
    fclose(f);
    *out = buf;
    *out_len = (size_t)len;
    return 1;
}

SoiEnv *env_create(void)
{
    SoiEnv *env = (SoiEnv *)calloc(1u, sizeof(*env));
    if (!env) return NULL;
    env->world = (SoiWorld *)malloc(soi_world_size());
    if (!env->world) {
        free(env);
        return NULL;
    }
    return env;
}

void env_destroy(SoiEnv *env)
{
    if (!env) return;
    free(env->world);
    free(env);
}

int env_reset(SoiEnv *env, const char *board_path)
{
    uint8_t *bytes;
    size_t len;
    int ok;

    if (!env || !env->world || !board_path) return 0;
    if (!read_file(board_path, &bytes, &len)) return 0;

    soi_world_init(env->world, 1u);
    ok = soi_load_level(env->world, bytes, len);
    free(bytes);
    if (!ok) return 0;

    soi_limit_players(env->world, 1);
    return 1;
}

void env_step(SoiEnv *env, uint8_t input)
{
    if (!env || !env->world) return;
    soi_tick(env->world, input, 0);
    soi_tick(env->world, input, 0);
}

int env_alive(const SoiEnv *env) { return env && env->world ? soi_player_alive(env->world, 1) : 0; }
int env_level_complete(const SoiEnv *env) { return env && env->world ? soi_level_complete(env->world) : 0; }
int env_game_over(const SoiEnv *env) { return env && env->world ? soi_game_over(env->world) : 1; }
int env_player_x(const SoiEnv *env) { return env && env->world ? soi_player_x(env->world, 1) : 0; }
int env_player_y(const SoiEnv *env) { return env && env->world ? soi_player_y(env->world, 1) : 0; }
int env_player_col(const SoiEnv *env) { return env && env->world ? cell_from_x(env_player_x(env)) : 0; }
int env_player_row(const SoiEnv *env) { return env && env->world ? cell_from_y(env_player_y(env)) : 0; }
int env_has_key(const SoiEnv *env) { return env && env->world ? soi_player_has_key(env->world, 1) : 0; }
int env_treasure_left(const SoiEnv *env) { return env && env->world ? soi_count_treasure(env->world) : 0; }
uint32_t env_tick_count(const SoiEnv *env) { return env && env->world ? soi_tick_count(env->world) : 0u; }
uint32_t env_grid_cell(const SoiEnv *env, int col, int row)
{
    if (!env || !env->world) return 0u;
    return soi_grid_cell(env->world, col, row);
}
