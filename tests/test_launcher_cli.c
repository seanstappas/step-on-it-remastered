#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#ifdef NDEBUG
#undef NDEBUG
#endif
#include <assert.h>

#define main launcher_real_main
#include "../tools/launcher/launcher.c"
#undef main

static void build_test_cmd(int argc, char **argv, char *cmd_line, size_t cap) {
    build_godot_cmd_line(
        "D:\\Code\\step-on-it-remastered\\build\\win\\StepOnIt.exe",
        "D:\\Code\\step-on-it-remastered\\build\\win\\StepOnIt.pck",
        true,
        argc,
        argv,
        cmd_line,
        cap,
        NULL);
}

static void write_raw_file(const char *path, const void *data, size_t len) {
    FILE *f = fopen(path, "wb");
    assert(f != NULL);
    size_t w = fwrite(data, 1, len, f);
    fclose(f);
    assert(w == len);
    (void)w;
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
    assert(is_godot_engine_arg("--set-update-token") == false);
    assert(is_godot_engine_arg("--clear-update-token") == false);
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

    /* 9. Challenge Case 7: --set-update-token and --clear-update-token never forwarded to Godot */
    {
        assert(is_launcher_only_arg("--set-update-token") == true);
        assert(is_launcher_only_arg("--set-update-token=abc") == true);
        assert(is_launcher_only_arg("--clear-update-token") == true);
        assert(is_launcher_only_arg("--headless") == false);
        assert(is_launcher_value_arg("--set-update-token") == true);
        assert(is_launcher_value_arg("--clear-update-token") == false);

        char *argv1[] = {
            "launcher.exe",
            "--headless",
            "--set-update-token",
            "secret_tok_123",
            "--quit",
            "--3d"
        };
        char cmd1[2048] = {0};
        build_test_cmd(6, argv1, cmd1, sizeof(cmd1));
        printf("Case 7a output: %s\n", cmd1);
        assert(strstr(cmd1, "--set-update-token") == NULL);
        assert(strstr(cmd1, "secret_tok_123") == NULL);
        assert(strstr(cmd1, "\"--headless\"") != NULL);
        assert(strstr(cmd1, "\"--quit\"") != NULL);
        assert(strstr(cmd1, "\"--3d\"") != NULL);

        char *argv2[] = {
            "launcher.exe",
            "--set-update-token=secret_tok_456",
            "--clear-update-token",
            "--headless"
        };
        char cmd2[2048] = {0};
        build_test_cmd(4, argv2, cmd2, sizeof(cmd2));
        printf("Case 7b output: %s\n", cmd2);
        assert(strstr(cmd2, "--set-update-token") == NULL);
        assert(strstr(cmd2, "secret_tok_456") == NULL);
        assert(strstr(cmd2, "--clear-update-token") == NULL);
        assert(strstr(cmd2, "\"--headless\"") != NULL);
        printf("[PASS] Case 7: Update token CLI flags and values never forwarded to Godot\n");
    }

    /* 10. Challenge Case 8 & 9: JSON unescaping and token resolution precedence */
    {
        char temp_root[MAX_PATH] = {0};
        DWORD tlen = GetTempPathA(sizeof(temp_root), temp_root);
        assert(tlen > 0 && tlen < sizeof(temp_root));
        (void)tlen;

        char test_dir[MAX_PATH];
        snprintf(test_dir, sizeof(test_dir), "%ssoi_launcher_unit_%lu", temp_root, (unsigned long)GetCurrentProcessId());
        CreateDirectoryA(test_dir, NULL);

        char json_path[MAX_PATH];
        snprintf(json_path, sizeof(json_path), "%s\\update_config.json", test_dir);

        /* Test JSON unescaping for UNC paths and escaped quotes */
        const char *unc_json = "{\r\n  \"repo_url\": \"\\\\\\\\server\\\\share\\\\releases\\\"v1\\\"\",\r\n  \"update_token\": \"cfg_tok_val\"\r\n}\r\n";
        write_raw_file(json_path, unc_json, strlen(unc_json));

        char out_url[1024] = {0};
        assert(read_repo_url_from_json(json_path, out_url, sizeof(out_url)) == true);
        assert(strcmp(out_url, "\\\\server\\share\\releases\"v1\"") == 0);

        /* Test local backslash path unescaping */
        const char *win_json = "{ \"repo_url\": \"C:\\\\Games\\\\StepOnIt\\\\releases\" }\n";
        write_raw_file(json_path, win_json, strlen(win_json));
        assert(read_repo_url_from_json(json_path, out_url, sizeof(out_url)) == true);
        assert(strcmp(out_url, "C:\\Games\\StepOnIt\\releases") == 0);

        /* Test null repo_url does not spill into next key */
        const char *null_json = "{ \"repo_url\": null, \"update_token\": \"cfg_tok_only\" }\n";
        write_raw_file(json_path, null_json, strlen(null_json));
        assert(read_repo_url_from_json(json_path, out_url, sizeof(out_url)) == false);
        printf("[PASS] Case 8: read_repo_url_from_json unescapes \\\\ and \\\" and rejects null\n");

        /* Save original env vars */
        char orig_local[MAX_PATH] = {0};
        DWORD has_orig_local = GetEnvironmentVariableA("LOCALAPPDATA", orig_local, sizeof(orig_local));
        char orig_tok[1024] = {0};
        DWORD has_orig_tok = GetEnvironmentVariableA("SOI_UPDATE_TOKEN", orig_tok, sizeof(orig_tok));

        char fake_local[MAX_PATH];
        snprintf(fake_local, sizeof(fake_local), "%s\\localappdata", test_dir);
        CreateDirectoryA(fake_local, NULL);
        SetEnvironmentVariableA("LOCALAPPDATA", fake_local);
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", NULL);

        char resolved[512] = {0};
        /* Only update_config.json has token */
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "cfg_tok_only") == 0);

        /* Write file with UTF-8 BOM + whitespace -> overrides config */
        char soi_dir[MAX_PATH];
        snprintf(soi_dir, sizeof(soi_dir), "%s\\StepOnIt", fake_local);
        CreateDirectoryA(soi_dir, NULL);
        char tok_file[MAX_PATH];
        snprintf(tok_file, sizeof(tok_file), "%s\\update_token.txt", soi_dir);
        const unsigned char bom_tok[] = "\xEF\xBB\xBF  file_tok_123 \r\n ";
        write_raw_file(tok_file, bom_tok, sizeof(bom_tok) - 1);
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "file_tok_123") == 0);

        /* Env SOI_UPDATE_TOKEN overrides file + config */
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", "  env_tok_999\n ");
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "env_tok_999") == 0);

        /* Test write_update_token_file / clear_update_token_file */
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", NULL);
        assert(clear_update_token_file(true) == 0);
        assert(file_exists(tok_file) == false);
        assert(clear_update_token_file(true) == 0); /* Idempotent */
        assert(write_update_token_file("  written_tok_abc \r\n", true) == 0);
        assert(file_exists(tok_file) == true);
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "written_tok_abc") == 0);
        assert(clear_update_token_file(true) == 0);
        assert(file_exists(tok_file) == false);

        /* Restore env vars and cleanup temp files */
        SetEnvironmentVariableA("LOCALAPPDATA", has_orig_local ? orig_local : NULL);
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", has_orig_tok ? orig_tok : NULL);
        DeleteFileA(json_path);
        DeleteFileA(tok_file);
        RemoveDirectoryA(soi_dir);
        RemoveDirectoryA(fake_local);
        RemoveDirectoryA(test_dir);
        printf("[PASS] Case 9: Token precedence (env > file > config) and set/clear verified\n");
    }

    /* 11. Challenge Case 10: decode_xor_token and 4-tier embedded token precedence */
    {
        char temp_root[MAX_PATH] = {0};
        DWORD tlen = GetTempPathA(sizeof(temp_root), temp_root);
        assert(tlen > 0 && tlen < sizeof(temp_root));
        (void)tlen;

        char test_dir[MAX_PATH];
        snprintf(test_dir, sizeof(test_dir), "%ssoi_launcher_embed_%lu", temp_root, (unsigned long)GetCurrentProcessId());
        CreateDirectoryA(test_dir, NULL);

        char fake_local[MAX_PATH];
        snprintf(fake_local, sizeof(fake_local), "%s\\localappdata", test_dir);
        CreateDirectoryA(fake_local, NULL);

        char soi_dir[MAX_PATH];
        snprintf(soi_dir, sizeof(soi_dir), "%s\\StepOnIt", fake_local);
        CreateDirectoryA(soi_dir, NULL);

        char json_path[MAX_PATH];
        snprintf(json_path, sizeof(json_path), "%s\\update_config.json", test_dir);

        char tok_file[MAX_PATH];
        snprintf(tok_file, sizeof(tok_file), "%s\\update_token.txt", soi_dir);

        /* Save original env vars and globals */
        char orig_local[MAX_PATH] = {0};
        DWORD has_orig_local = GetEnvironmentVariableA("LOCALAPPDATA", orig_local, sizeof(orig_local));
        char orig_tok[1024] = {0};
        DWORD has_orig_tok = GetEnvironmentVariableA("SOI_UPDATE_TOKEN", orig_tok, sizeof(orig_tok));
        char orig_dis[64] = {0};
        DWORD has_orig_dis = GetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", orig_dis, sizeof(orig_dis));

        const unsigned char *orig_cipher = g_embedded_token_cipher;
        size_t orig_cipher_len = g_embedded_token_len;
        const unsigned char *orig_key = g_embedded_token_key;
        size_t orig_key_len = g_embedded_token_key_len;

        /* 10a. decode_xor_token round-trip, trimming, and validation rejections */
        const unsigned char xor_key[8] = { 0x5A, 0xC3, 0x19, 0x87, 0x42, 0xE1, 0x3D, 0xA6 };
        const char *padded_plain = "  github_pat_unit_test_payload_012345  \n";
        size_t plain_len = strlen(padded_plain);
        unsigned char cipher_buf[128] = {0};
        for (size_t i = 0; i < plain_len; i++) {
            cipher_buf[i] = (unsigned char)padded_plain[i] ^ xor_key[i % sizeof(xor_key)];
        }

        char out_tok[256] = {0};
        assert(decode_xor_token(cipher_buf, plain_len, xor_key, sizeof(xor_key), out_tok, sizeof(out_tok)) == true);
        assert(strcmp(out_tok, "github_pat_unit_test_payload_012345") == 0);

        /* Reject NULL, zero-length, oversized cipher, and too-small output buffer */
        assert(decode_xor_token(NULL, plain_len, xor_key, sizeof(xor_key), out_tok, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, 0, xor_key, sizeof(xor_key), out_tok, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, plain_len, NULL, sizeof(xor_key), out_tok, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, plain_len, xor_key, 0, out_tok, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, plain_len, xor_key, sizeof(xor_key), NULL, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, plain_len, xor_key, sizeof(xor_key), out_tok, 0) == false);
        assert(decode_xor_token(cipher_buf, 1024, xor_key, sizeof(xor_key), out_tok, sizeof(out_tok)) == false);
        assert(decode_xor_token(cipher_buf, plain_len, xor_key, sizeof(xor_key), out_tok, 10) == false);

        /* 10b. 4-tier resolve_update_token precedence: env > file > config > embedded */
        const char *embed_plain = "github_pat_embedded_fallback_token";
        size_t embed_len = strlen(embed_plain);
        unsigned char embed_cipher[128] = {0};
        for (size_t i = 0; i < embed_len; i++) {
            embed_cipher[i] = (unsigned char)embed_plain[i] ^ xor_key[i % sizeof(xor_key)];
        }
        g_embedded_token_cipher = embed_cipher;
        g_embedded_token_len = embed_len;
        g_embedded_token_key = xor_key;
        g_embedded_token_key_len = sizeof(xor_key);

        SetEnvironmentVariableA("LOCALAPPDATA", fake_local);
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", NULL);
        SetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", NULL);

        const char *no_tok_json = "{ \"repo_url\": \"https://github.com/seanstappas/step-on-it-remastered\" }\n";
        write_raw_file(json_path, no_tok_json, strlen(no_tok_json));

        char resolved[512] = {0};
        /* Tier 4: only embedded token exists */
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "github_pat_embedded_fallback_token") == 0);

        /* SOI_DISABLE_EMBEDDED_TOKEN disables fallback */
        SetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", "1");
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == false);
        SetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", "TRUE");
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == false);
        SetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", NULL);

        /* Tier 3: update_config.json overrides embedded */
        const char *with_tok_json = "{ \"repo_url\": \"https://github.com/seanstappas/step-on-it-remastered\", \"update_token\": \"cfg_tok_tier3\" }\n";
        write_raw_file(json_path, with_tok_json, strlen(with_tok_json));
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "cfg_tok_tier3") == 0);

        /* Tier 2: update_token.txt overrides config and embedded */
        const char *file_tok = "file_tok_tier2\r\n";
        write_raw_file(tok_file, file_tok, strlen(file_tok));
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "file_tok_tier2") == 0);

        /* Tier 1: SOI_UPDATE_TOKEN overrides file, config, and embedded */
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", "env_tok_tier1");
        assert(resolve_update_token(test_dir, resolved, sizeof(resolved)) == true);
        assert(strcmp(resolved, "env_tok_tier1") == 0);

        /* Restore globals, env vars, and cleanup temp files */
        g_embedded_token_cipher = orig_cipher;
        g_embedded_token_len = orig_cipher_len;
        g_embedded_token_key = orig_key;
        g_embedded_token_key_len = orig_key_len;
        SetEnvironmentVariableA("LOCALAPPDATA", has_orig_local ? orig_local : NULL);
        SetEnvironmentVariableA("SOI_UPDATE_TOKEN", has_orig_tok ? orig_tok : NULL);
        SetEnvironmentVariableA("SOI_DISABLE_EMBEDDED_TOKEN", has_orig_dis ? orig_dis : NULL);
        DeleteFileA(json_path);
        DeleteFileA(tok_file);
        RemoveDirectoryA(soi_dir);
        RemoveDirectoryA(fake_local);
        RemoveDirectoryA(test_dir);
        printf("[PASS] Case 10: XOR decode and 4-tier token precedence (env > file > config > embedded) verified\n");
    }

    printf("\nALL LAUNCHER CLI ADVERSARIAL TESTS PASSED!\n");
    return 0;
}
