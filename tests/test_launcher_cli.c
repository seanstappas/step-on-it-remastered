#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <assert.h>

#define main launcher_real_main
#include "../tools/launcher/launcher.c"
#undef main

/* Helper to replicate the exact command line construction in launcher.c */
static void build_test_cmd(int argc, char **argv, char *cmd_line, size_t cap) {
    size_t offset = 0;
    int written = snprintf(cmd_line, cap, "\"D:\\Code\\step-on-it-remastered\\build\\win\\StepOnIt.exe\"");
    if (written > 0 && (size_t)written < cap) {
        offset = (size_t)written;
    }

    append_arg(cmd_line, cap, &offset, "--main-pack");
    append_arg(cmd_line, cap, &offset, "D:\\Code\\step-on-it-remastered\\build\\win\\StepOnIt.pck");

    bool has_visual_flag = false;
    bool has_music_flag = false;

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (strcmp(a, "--3d") == 0 || strcmp(a, "--hd") == 0 || strcmp(a, "--original") == 0) {
            has_visual_flag = true;
        }
        if (strcmp(a, "--music") == 0 || strcmp(a, "--no-music") == 0) {
            has_music_flag = true;
        }
    }

    /* Engine flags go before '--' */
    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (is_velo_or_squirrel_arg(a)) continue;
        if (is_godot_engine_arg(a)) {
            append_arg(cmd_line, cap, &offset, a);
            /* If this flag takes an argument value (e.g. --resolution 640x480, --position 0,0, --quit-after 600) */
            if (is_godot_value_arg(a) && i + 1 < argc && argv[i + 1][0] != '-') {
                i++;
                append_arg(cmd_line, cap, &offset, argv[i]);
            }
        }
    }

    /* Game arguments go after '--' */
    append_arg(cmd_line, cap, &offset, "--");

    if (!has_visual_flag) {
        append_arg(cmd_line, cap, &offset, "--3d");
    }
    if (!has_music_flag) {
        append_arg(cmd_line, cap, &offset, "--music");
    }

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (is_velo_or_squirrel_arg(a)) continue;
        if (strcmp(a, "--") == 0) continue;
        if (!is_godot_engine_arg(a)) {
            append_arg(cmd_line, cap, &offset, a);
        } else if (is_godot_value_arg(a) && i + 1 < argc && argv[i + 1][0] != '-') {
            /* Skip value consumed above by engine flag */
            i++;
        }
    }
}

int main(void) {
    printf("=== Running Launcher CLI Adversarial Unit Tests ===\n");

    /* 1. Test is_godot_engine_arg categorization */
    assert(is_godot_engine_arg("--headless") == true);
    assert(is_godot_engine_arg("--quit") == true);
    assert(is_godot_engine_arg("--quit-after") == true);
    assert(is_godot_engine_arg("--verbose") == true);
    assert(is_godot_engine_arg("--quiet") == true);
    assert(is_godot_engine_arg("--debug") == true);
    assert(is_godot_engine_arg("--resolution") == true);
    assert(is_godot_engine_arg("--position") == true);
    assert(is_godot_engine_arg("--path") == true);
    assert(is_godot_engine_arg("--fullscreen") == true);
    assert(is_godot_engine_arg("--windowed") == true);
    assert(is_godot_engine_arg("--rendering-driver") == true);
    assert(is_godot_engine_arg("--display-driver") == true);
    assert(is_godot_engine_arg("--audio-driver") == true);
    assert(is_godot_engine_arg("-s") == true);
    assert(is_godot_engine_arg("--script") == true);
    assert(is_godot_engine_arg("res://scenes/smoke_test.tscn") == true);
    assert(is_godot_engine_arg("res://scenes/game.tscn") == true);

    /* Negative checks */
    assert(is_godot_engine_arg("--quitter") == false);
    assert(is_godot_engine_arg("--quit-game") == false);
    assert(is_godot_engine_arg("board_401.bord") == false);
    assert(is_godot_engine_arg("--some-game-option") == false);
    printf("[PASS] is_godot_engine_arg unit assertions\n");

    /* 2. Test is_godot_value_arg categorization */
    assert(is_godot_value_arg("--resolution") == true);
    assert(is_godot_value_arg("--position") == true);
    assert(is_godot_value_arg("--path") == true);
    assert(is_godot_value_arg("--rendering-driver") == true);
    assert(is_godot_value_arg("--display-driver") == true);
    assert(is_godot_value_arg("--audio-driver") == true);
    assert(is_godot_value_arg("--quit-after") == true);
    assert(is_godot_value_arg("-s") == true);
    assert(is_godot_value_arg("--script") == true);

    /* Boolean flags MUST NOT be value args */
    assert(is_godot_value_arg("--headless") == false);
    assert(is_godot_value_arg("--quit") == false);
    assert(is_godot_value_arg("--verbose") == false);
    assert(is_godot_value_arg("--quiet") == false);
    assert(is_godot_value_arg("--debug") == false);
    assert(is_godot_value_arg("--fullscreen") == false);
    assert(is_godot_value_arg("--windowed") == false);
    assert(is_godot_value_arg("res://scenes/smoke_test.tscn") == false);
    printf("[PASS] is_godot_value_arg unit assertions\n");

    /* 3. Challenge Case 1: --headless res://scenes/smoke_test.tscn */
    {
        char *argv[] = {
            "launcher.exe",
            "--headless",
            "res://scenes/smoke_test.tscn"
        };
        char cmd[2048] = {0};
        build_test_cmd(3, argv, cmd, sizeof(cmd));
        printf("Case 1 output: %s\n", cmd);

        /* Ensure --headless is followed by res:// before -- */
        char *h = strstr(cmd, "\"--headless\"");
        char *scene = strstr(cmd, "\"res://scenes/smoke_test.tscn\"");
        char *dashdash = strstr(cmd, "\"--\"");
        assert(h != NULL);
        assert(scene != NULL);
        assert(dashdash != NULL);
        assert(h < scene);
        assert(scene < dashdash);
        (void)h; (void)scene; (void)dashdash;
        printf("[PASS] Case 1: res://scene not consumed as value to --headless\n");
    }

    /* 4. Challenge Case 2: --verbose --resolution 640x480 --quit */
    {
        char *argv[] = {
            "launcher.exe",
            "--verbose",
            "--resolution",
            "640x480",
            "--quit"
        };
        char cmd[2048] = {0};
        build_test_cmd(5, argv, cmd, sizeof(cmd));
        printf("Case 2 output: %s\n", cmd);

        char *v = strstr(cmd, "\"--verbose\"");
        char *res = strstr(cmd, "\"--resolution\"");
        char *val = strstr(cmd, "\"640x480\"");
        char *q = strstr(cmd, "\"--quit\"");
        char *dashdash = strstr(cmd, "\"--\"");
        assert(v != NULL);
        assert(res != NULL);
        assert(val != NULL);
        assert(q != NULL);
        assert(dashdash != NULL);
        assert(v < res);
        assert(res < val);
        assert(val < q);
        assert(q < dashdash);
        (void)v; (void)res; (void)val; (void)q; (void)dashdash;
        printf("[PASS] Case 2: --verbose, --resolution 640x480, and --quit preserved cleanly\n");
    }

    /* 5. Challenge Case 3: --verbose --resolution 640x480 --quit with trailing args */
    {
        char *argv[] = {
            "launcher.exe",
            "--verbose",
            "--resolution",
            "640x480",
            "--quit",
            "trailing_game_arg"
        };
        char cmd[2048] = {0};
        build_test_cmd(6, argv, cmd, sizeof(cmd));
        printf("Case 3 output: %s\n", cmd);

        char *q = strstr(cmd, "\"--quit\"");
        char *dashdash = strstr(cmd, "\"--\"");
        char *trailing = strstr(cmd, "\"trailing_game_arg\"");
        assert(q != NULL);
        assert(dashdash != NULL);
        assert(trailing != NULL);
        assert(q < dashdash);
        assert(dashdash < trailing);
        (void)q; (void)dashdash; (void)trailing;
        printf("[PASS] Case 3: --quit does NOT swallow trailing args (placed after '--')\n");
    }

    /* 6. Challenge Case 4: --quit-after 10 */
    {
        char *argv[] = {
            "launcher.exe",
            "--quit-after",
            "10"
        };
        char cmd[2048] = {0};
        build_test_cmd(3, argv, cmd, sizeof(cmd));
        printf("Case 4 output: %s\n", cmd);

        char *qa = strstr(cmd, "\"--quit-after\"");
        char *val = strstr(cmd, "\"10\"");
        char *dashdash = strstr(cmd, "\"--\"");
        assert(qa != NULL);
        assert(val != NULL);
        assert(dashdash != NULL);
        assert(qa < val);
        assert(val < dashdash);
        /* Ensure 10 is NOT repeated after -- */
        char *after_dash = dashdash + 4;
        assert(strstr(after_dash, "\"10\"") == NULL);
        (void)qa; (void)val; (void)after_dash;
        printf("[PASS] Case 4: --quit-after 10 properly consumes value and does not bleed\n");
    }

    /* 7. Challenge Case 5: Complex combination with mixed boolean and value flags */
    {
        char *argv[] = {
            "launcher.exe",
            "--headless",
            "--position",
            "100,200",
            "--quiet",
            "--quit-after",
            "300",
            "res://scenes/editor.tscn",
            "--test-editor"
        };
        char cmd[2048] = {0};
        build_test_cmd(9, argv, cmd, sizeof(cmd));
        printf("Case 5 output: %s\n", cmd);

        char *h = strstr(cmd, "\"--headless\"");
        char *pos = strstr(cmd, "\"--position\"");
        char *pos_val = strstr(cmd, "\"100,200\"");
        char *quiet = strstr(cmd, "\"--quiet\"");
        char *qa = strstr(cmd, "\"--quit-after\"");
        char *qa_val = strstr(cmd, "\"300\"");
        char *scene = strstr(cmd, "\"res://scenes/editor.tscn\"");
        char *dashdash = strstr(cmd, "\"--\"");
        char *game_arg = strstr(cmd, "\"--test-editor\"");

        assert(h != NULL && pos != NULL && pos_val != NULL);
        assert(quiet != NULL && qa != NULL && qa_val != NULL);
        assert(scene != NULL && dashdash != NULL && game_arg != NULL);

        assert(h < pos);
        assert(pos < pos_val);
        assert(pos_val < quiet);
        assert(quiet < qa);
        assert(qa < qa_val);
        assert(qa_val < scene);
        assert(scene < dashdash);
        assert(dashdash < game_arg);

        /* Confirm pos_val and qa_val are not repeated after dashdash */
        assert(strstr(dashdash + 4, "\"100,200\"") == NULL);
        assert(strstr(dashdash + 4, "\"300\"") == NULL);
        (void)h; (void)pos; (void)pos_val; (void)quiet; (void)qa; (void)qa_val; (void)scene; (void)dashdash; (void)game_arg;
        printf("[PASS] Case 5: Complex combination formatted correctly\n");
    }

    /* 8. Challenge Case 6: Squirrel/Velopack arg filtering */
    {
        char *argv[] = {
            "launcher.exe",
            "--veloapp-install",
            "--headless",
            "--squirrel-firstrun",
            "--quit"
        };
        char cmd[2048] = {0};
        build_test_cmd(5, argv, cmd, sizeof(cmd));
        printf("Case 6 output: %s\n", cmd);

        assert(strstr(cmd, "veloapp") == NULL);
        assert(strstr(cmd, "squirrel") == NULL);
        assert(strstr(cmd, "\"--headless\"") != NULL);
        assert(strstr(cmd, "\"--quit\"") != NULL);
        printf("[PASS] Case 6: Velopack/Squirrel installer hooks stripped\n");
    }

    printf("\nALL LAUNCHER CLI ADVERSARIAL TESTS PASSED!\n");
    return 0;
}
