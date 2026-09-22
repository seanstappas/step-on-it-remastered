#ifndef SOI_BEATABILITY_ENV_H
#define SOI_BEATABILITY_ENV_H

#include <stdint.h>

typedef struct SoiEnv SoiEnv;

SoiEnv *env_create(void);
void env_destroy(SoiEnv *env);

int env_reset(SoiEnv *env, const char *board_path);
/* One ALE-style player move. The core samples at 60Hz but advances players on
 * odd ticks, so a held action is applied for two core ticks. */
void env_step(SoiEnv *env, uint8_t input);

int env_alive(const SoiEnv *env);
int env_level_complete(const SoiEnv *env);
int env_game_over(const SoiEnv *env);
int env_player_x(const SoiEnv *env);
int env_player_y(const SoiEnv *env);
int env_player_col(const SoiEnv *env);
int env_player_row(const SoiEnv *env);
int env_has_key(const SoiEnv *env);
int env_treasure_left(const SoiEnv *env);
uint32_t env_tick_count(const SoiEnv *env);
uint32_t env_grid_cell(const SoiEnv *env, int col, int row);

#endif
