#include "soi_env.h"

#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "soi_core.h"

#define CELL_TYPE(c) ((unsigned)((c) & 0xFFu))
#define CELL_DOOR 0x800u
#define DEFAULT_MAX_MOVES 2000
#define IDLE_DEFAULT_MAX_MOVES 60

typedef struct Trace {
    uint8_t *moves;
    int count;
} Trace;

static const char *base_name(const char *path)
{
    const char *p = path;
    const char *last = path;
    while (*p) {
        if (*p == '\\' || *p == '/') last = p + 1;
        p++;
    }
    return last;
}

static void board_id(const char *path, char *out, size_t cap)
{
    const char *base = base_name(path);
    size_t n = 0;
    while (base[n] && base[n] != '.' && n + 1u < cap) {
        out[n] = base[n];
        n++;
    }
    out[n] = '\0';
}

static int abs_i(int v) { return v < 0 ? -v : v; }

static int is_treasure(uint32_t cell)
{
    unsigned t = CELL_TYPE(cell);
    return t == 0x0Au || t == 0x17u || t == 0x18u || t == 0x19u;
}

static int is_key(uint32_t cell)
{
    unsigned t = CELL_TYPE(cell);
    return t == 0x0Bu || ((cell & CELL_DOOR) && t >= 7u && t <= 9u);
}

static int is_open_door(uint32_t cell)
{
    unsigned t = CELL_TYPE(cell);
    return (cell & CELL_DOOR) && t <= 3u;
}

static int find_target(SoiEnv *env, int *target_col, int *target_row)
{
    int pc = env_player_col(env);
    int pr = env_player_row(env);
    int has_key = env_has_key(env);
    int treasure_left = env_treasure_left(env);
    int best_dist = 1000000;
    int best_col = -1;
    int best_row = -1;
    int row;
    int col;

    for (row = 0; row < SOI_GRID_ROWS; row++) {
        for (col = 0; col < SOI_GRID_COLS; col++) {
            uint32_t cell = env_grid_cell(env, col, row);
            int wanted = 0;
            if (treasure_left > 0) wanted = is_treasure(cell);
            else if (!has_key) wanted = is_key(cell);
            else wanted = is_open_door(cell);

            if (wanted) {
                int dist = abs_i(col - pc) + abs_i(row - pr);
                if (dist < best_dist) {
                    best_dist = dist;
                    best_col = col;
                    best_row = row;
                }
            }
        }
    }

    if (best_col < 0) return 0;
    *target_col = best_col;
    *target_row = best_row;
    return 1;
}

static uint8_t policy_right(SoiEnv *env, int move, int *last_x, int *stuck, int *jump_left)
{
    int x = env_player_x(env);
    uint8_t input = SOI_IN_RIGHT;

    if (move == 0 || x > *last_x) *stuck = 0;
    else (*stuck)++;

    if (*stuck >= 4) {
        *jump_left = 3;
        *stuck = 0;
    }
    if (*jump_left > 0) {
        input |= SOI_IN_JUMP;
        (*jump_left)--;
    }

    *last_x = x;
    return input;
}

static uint8_t policy_wander(SoiEnv *env, int move, int *last_x, int *stuck, int *jump_left)
{
    int target_col;
    int target_row;
    int pc = env_player_col(env);
    int pr = env_player_row(env);
    int x = env_player_x(env);
    uint8_t input = 0;

    if (find_target(env, &target_col, &target_row)) {
        if (target_col > pc) input |= SOI_IN_RIGHT;
        else if (target_col < pc) input |= SOI_IN_LEFT;
        else if ((move / 12) & 1) input |= SOI_IN_RIGHT;
        else input |= SOI_IN_LEFT;

        if (target_row < pr) input |= SOI_IN_JUMP;
    } else {
        input = ((move / 40) & 1) ? SOI_IN_LEFT : SOI_IN_RIGHT;
    }

    if (move == 0 || x != *last_x) *stuck = 0;
    else (*stuck)++;

    if (*stuck >= 5) {
        *jump_left = 3;
        *stuck = 0;
    }
    if (*jump_left > 0) {
        input |= SOI_IN_JUMP;
        (*jump_left)--;
    }

    *last_x = x;
    return input;
}

static int load_trace(const char *path, Trace *trace)
{
    FILE *f = fopen(path, "r");
    char line[128];
    int cap = 256;

    trace->moves = NULL;
    trace->count = 0;
    if (!f) return 0;
    trace->moves = (uint8_t *)malloc((size_t)cap);
    if (!trace->moves) { fclose(f); return 0; }

    while (fgets(line, sizeof(line), f)) {
        char *end;
        long v;
        char *p = line;
        while (*p && isspace((unsigned char)*p)) p++;
        if (*p == '\0' || *p == '#') continue;
        v = strtol(p, &end, 0);
        if (p == end || v < 0 || v > 255) {
            free(trace->moves);
            trace->moves = NULL;
            fclose(f);
            return 0;
        }
        if (trace->count >= cap) {
            uint8_t *next;
            if (cap > 1073741823) {
                free(trace->moves);
                trace->moves = NULL;
                fclose(f);
                return 0;
            }
            cap *= 2;
            next = (uint8_t *)realloc(trace->moves, (size_t)cap);
            if (!next) {
                free(trace->moves);
                trace->moves = NULL;
                fclose(f);
                return 0;
            }
            trace->moves = next;
        }
        trace->moves[trace->count++] = (uint8_t)v;
    }

    fclose(f);
    return 1;
}

static int parse_positive_int(const char *s, int *out)
{
    char *end;
    long value;

    if (!s || !*s) return 0;
    value = strtol(s, &end, 10);
    if (end == s || *end != '\0' || value < 1 || value > 2147483647L) return 0;
    *out = (int)value;
    return 1;
}

static void print_json_string(const char *s)
{
    putchar('"');
    while (*s) {
        unsigned char c = (unsigned char)*s++;
        if (c == '"' || c == '\\') {
            putchar('\\');
            putchar((int)c);
        } else if (c == '\b') printf("\\b");
        else if (c == '\f') printf("\\f");
        else if (c == '\n') printf("\\n");
        else if (c == '\r') printf("\\r");
        else if (c == '\t') printf("\\t");
        else if (c < 0x20u) printf("\\u%04x", (unsigned)c);
        else putchar((int)c);
    }
    putchar('"');
}

static void print_result(const char *board, const char *policy, const char *outcome, int moves, SoiEnv *env)
{
    printf("{\"board\":");
    print_json_string(board);
    printf(",\"policy\":");
    print_json_string(policy);
    printf(",\"outcome\":");
    print_json_string(outcome);
    printf(",\"moves\":%d,\"final_col\":%d,\"final_row\":%d,\"treasure_left\":%d}\n",
           moves, env_player_col(env), env_player_row(env), env_treasure_left(env));
}

int main(int argc, char **argv)
{
    const char *board_path;
    const char *policy;
    char board[128];
    const char *outcome = "timeout";
    SoiEnv *env;
    int max_moves;
    int move;
    int last_x = 0;
    int stuck = 0;
    int jump_left = 0;
    Trace trace;
    int use_trace = 0;

    if (argc < 3) {
        fprintf(stderr, "usage: beat_level.exe <board_path> <policy> [max_moves]\n");
        return 2;
    }

    board_path = argv[1];
    policy = argv[2];
    max_moves = (strcmp(policy, "idle") == 0) ? IDLE_DEFAULT_MAX_MOVES : DEFAULT_MAX_MOVES;
    if (argc >= 4) {
        if (!parse_positive_int(argv[3], &max_moves)) {
            fprintf(stderr, "invalid max_moves: %s\n", argv[3]);
            return 2;
        }
    }

    trace.moves = NULL;
    trace.count = 0;
    if (strncmp(policy, "trace:", 6u) == 0) {
        use_trace = 1;
        if (!load_trace(policy + 6, &trace)) {
            fprintf(stderr, "failed to read trace: %s\n", policy + 6);
            return 2;
        }
        if (argc < 4) max_moves = trace.count;
    }

    env = env_create();
    if (!env) {
        free(trace.moves);
        fprintf(stderr, "env_create failed\n");
        return 1;
    }
    if (!env_reset(env, board_path)) {
        free(trace.moves);
        env_destroy(env);
        fprintf(stderr, "failed to load board: %s\n", board_path);
        return 1;
    }

    board_id(board_path, board, sizeof(board));
    last_x = env_player_x(env);

    for (move = 0; move < max_moves; move++) {
        uint8_t input = 0;
        if (strcmp(policy, "idle") == 0) input = 0;
        else if (strcmp(policy, "right") == 0) input = policy_right(env, move, &last_x, &stuck, &jump_left);
        else if (strcmp(policy, "wander") == 0) input = policy_wander(env, move, &last_x, &stuck, &jump_left);
        else if (use_trace) {
            if (move >= trace.count) break;
            input = trace.moves[move];
        } else {
            free(trace.moves);
            env_destroy(env);
            fprintf(stderr, "unknown policy: %s\n", policy);
            return 2;
        }

        env_step(env, input);

        if (env_level_complete(env)) {
            move++;
            outcome = "complete";
            break;
        }
        if (env_game_over(env) || !env_alive(env)) {
            move++;
            outcome = "dead";
            break;
        }
    }

    print_result(board, policy, outcome, move, env);

    free(trace.moves);
    env_destroy(env);
    return 0;
}
