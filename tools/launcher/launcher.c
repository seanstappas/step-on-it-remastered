#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include "Velopack.h"

typedef void (*fn_vpkc_app_run)(void *);
typedef vpkc_update_source_t *(*fn_vpkc_new_source_github)(const char *, const char *, bool);
typedef void (*fn_vpkc_free_source)(vpkc_update_source_t *);
typedef bool (*fn_vpkc_new_update_manager)(const char *, struct vpkc_update_options_t *, struct vpkc_locator_config_t *, vpkc_update_manager_t **);
typedef bool (*fn_vpkc_new_update_manager_with_source)(vpkc_update_source_t *, struct vpkc_update_options_t *, struct vpkc_locator_config_t *, vpkc_update_manager_t **);
typedef vpkc_update_check_t (*fn_vpkc_check_for_updates)(vpkc_update_manager_t *, struct vpkc_update_info_t **);
typedef bool (*fn_vpkc_download_updates)(vpkc_update_manager_t *, struct vpkc_update_info_t *, vpkc_progress_callback_t, void *);
typedef bool (*fn_vpkc_wait_exit_then_apply_updates)(vpkc_update_manager_t *, struct vpkc_asset_t *, bool, bool, char **, size_t);
typedef void (*fn_vpkc_free_update_info)(struct vpkc_update_info_t *);
typedef void (*fn_vpkc_free_update_manager)(vpkc_update_manager_t *);
typedef size_t (*fn_vpkc_get_last_error)(char *, size_t);

static void get_exe_dir(char *out_dir, size_t max_len) {
    char path[MAX_PATH];
    DWORD len = GetModuleFileNameA(NULL, path, MAX_PATH);
    if (len == 0 || len >= MAX_PATH) {
        strncpy(out_dir, ".", max_len);
        return;
    }
    char *last_sep = strrchr(path, '\\');
    if (!last_sep) last_sep = strrchr(path, '/');
    if (last_sep) *last_sep = '\0';
    strncpy(out_dir, path, max_len);
    out_dir[max_len - 1] = '\0';
}

static bool file_exists(const char *path) {
    DWORD attr = GetFileAttributesA(path);
    return (attr != INVALID_FILE_ATTRIBUTES && !(attr & FILE_ATTRIBUTE_DIRECTORY));
}

static bool read_repo_url_from_json(const char *json_path, char *out_url, size_t max_len) {
    if (!file_exists(json_path)) return false;
    FILE *f = fopen(json_path, "rb");
    if (!f) return false;
    char buf[4096];
    size_t n = fread(buf, 1, sizeof(buf) - 1, f);
    fclose(f);
    buf[n] = '\0';

    const char *key = strstr(buf, "\"repo_url\"");
    if (!key) return false;
    const char *colon = strchr(key + 10, ':');
    if (!colon) return false;
    const char *q1 = strchr(colon + 1, '"');
    if (!q1) return false;
    q1++;
    const char *q2 = strchr(q1, '"');
    if (!q2) return false;

    size_t len = (size_t)(q2 - q1);
    if (len == 0 || len >= max_len) return false;
    memcpy(out_url, q1, len);
    out_url[len] = '\0';
    return true;
}

static void on_download_progress(void *user_data, size_t progress) {
    (void)user_data;
    printf("\r[Launcher] Downloading update... %zu%%", progress);
    fflush(stdout);
}

static void run_velopack_and_check_updates(const char *base_dir, int argc, char **argv) {
    char dll_path[MAX_PATH];
    snprintf(dll_path, sizeof(dll_path), "%s\\velopack_libc_win_x64_msvc.dll", base_dir);
    HMODULE h_vpk = LoadLibraryA(dll_path);
    if (!h_vpk) {
        h_vpk = LoadLibraryA("velopack_libc_win_x64_msvc.dll");
    }
    if (!h_vpk) {
        return;
    }

    fn_vpkc_app_run p_app_run = (fn_vpkc_app_run)GetProcAddress(h_vpk, "vpkc_app_run");
    fn_vpkc_new_source_github p_new_source_github = (fn_vpkc_new_source_github)GetProcAddress(h_vpk, "vpkc_new_source_github");
    fn_vpkc_free_source p_free_source = (fn_vpkc_free_source)GetProcAddress(h_vpk, "vpkc_free_source");
    fn_vpkc_new_update_manager p_new_update_manager = (fn_vpkc_new_update_manager)GetProcAddress(h_vpk, "vpkc_new_update_manager");
    fn_vpkc_new_update_manager_with_source p_new_update_manager_with_source = (fn_vpkc_new_update_manager_with_source)GetProcAddress(h_vpk, "vpkc_new_update_manager_with_source");
    fn_vpkc_check_for_updates p_check_for_updates = (fn_vpkc_check_for_updates)GetProcAddress(h_vpk, "vpkc_check_for_updates");
    fn_vpkc_download_updates p_download_updates = (fn_vpkc_download_updates)GetProcAddress(h_vpk, "vpkc_download_updates");
    fn_vpkc_wait_exit_then_apply_updates p_wait_exit_then_apply_updates = (fn_vpkc_wait_exit_then_apply_updates)GetProcAddress(h_vpk, "vpkc_wait_exit_then_apply_updates");
    fn_vpkc_free_update_info p_free_update_info = (fn_vpkc_free_update_info)GetProcAddress(h_vpk, "vpkc_free_update_info");
    fn_vpkc_free_update_manager p_free_update_manager = (fn_vpkc_free_update_manager)GetProcAddress(h_vpk, "vpkc_free_update_manager");
    fn_vpkc_get_last_error p_get_last_error = (fn_vpkc_get_last_error)GetProcAddress(h_vpk, "vpkc_get_last_error");

    if (p_app_run) {
        p_app_run(NULL);
    }

    char repo_url[1024] = {0};
    const char *env_url = getenv("SOI_UPDATE_URL");
    if (env_url && env_url[0] != '\0') {
        strncpy(repo_url, env_url, sizeof(repo_url) - 1);
    } else {
        char cfg_path[MAX_PATH];
        snprintf(cfg_path, sizeof(cfg_path), "%s\\update_config.json", base_dir);
        if (!read_repo_url_from_json(cfg_path, repo_url, sizeof(repo_url))) {
            snprintf(cfg_path, sizeof(cfg_path), "%s\\..\\update_config.json", base_dir);
            read_repo_url_from_json(cfg_path, repo_url, sizeof(repo_url));
        }
    }

    if (repo_url[0] == '\0' || strstr(repo_url, "YOUR_GITHUB_USER") != NULL) {
        return;
    }

    if (!p_new_update_manager || !p_check_for_updates || !p_download_updates ||
        !p_wait_exit_then_apply_updates || !p_free_update_info || !p_free_update_manager) {
        return;
    }

    vpkc_update_manager_t *mgr = NULL;
    vpkc_update_source_t *src = NULL;
    bool ok = false;

    if ((strncmp(repo_url, "https://github.com/", 19) == 0 ||
         strncmp(repo_url, "http://github.com/", 18) == 0) &&
        p_new_source_github && p_new_update_manager_with_source) {
        src = p_new_source_github(repo_url, NULL, false);
        if (src) {
            ok = p_new_update_manager_with_source(src, NULL, NULL, &mgr);
        }
    } else {
        ok = p_new_update_manager(repo_url, NULL, NULL, &mgr);
    }

    if (!ok || !mgr) {
        if (src && p_free_source) p_free_source(src);
        return;
    }

    struct vpkc_update_info_t *update_info = NULL;
    vpkc_update_check_t check = p_check_for_updates(mgr, &update_info);
    if (check == UPDATE_AVAILABLE && update_info != NULL) {
        const char *ver = (update_info->TargetFullRelease && update_info->TargetFullRelease->Version)
                          ? update_info->TargetFullRelease->Version
                          : "latest";
        printf("[Launcher] Update found (%s). Downloading delta...\n", ver);
        fflush(stdout);

        if (p_download_updates(mgr, update_info, on_download_progress, NULL)) {
            printf("\n[Launcher] Applying update and restarting...\n");
            fflush(stdout);
            char **restart_args = (argc > 1) ? (argv + 1) : NULL;
            size_t restart_argc = (argc > 1) ? (size_t)(argc - 1) : 0;
            if (p_wait_exit_then_apply_updates(
                    mgr,
                    update_info->TargetFullRelease,
                    true,
                    true,
                    restart_args,
                    restart_argc)) {
                p_free_update_info(update_info);
                p_free_update_manager(mgr);
                if (src && p_free_source) p_free_source(src);
                exit(0);
            }
        } else if (p_get_last_error) {
            char err_buf[512] = {0};
            p_get_last_error(err_buf, sizeof(err_buf));
            printf("\n[Launcher] Update download skipped (%s) - launching current version.\n", err_buf);
        }
    }

    if (update_info) p_free_update_info(update_info);
    p_free_update_manager(mgr);
    if (src && p_free_source) p_free_source(src);
}

int main(int argc, char **argv) {
    char base_dir[MAX_PATH];
    get_exe_dir(base_dir, sizeof(base_dir));

    /* 1. Handle Velopack hooks and check/apply updates before StepOnIt.exe loads */
    run_velopack_and_check_updates(base_dir, argc, argv);

    /* 2. Launch StepOnIt.exe */
    char godot_exe[MAX_PATH];
    snprintf(godot_exe, sizeof(godot_exe), "%s\\StepOnIt.exe", base_dir);
    if (!file_exists(godot_exe)) {
        fprintf(stderr, "[Launcher] ERROR: Could not find %s\n", godot_exe);
        return 1;
    }

    char pck_path[MAX_PATH];
    snprintf(pck_path, sizeof(pck_path), "%s\\StepOnIt.pck", base_dir);

    char cmd_line[4096];
    int offset = snprintf(cmd_line, sizeof(cmd_line), "\"%s\"", godot_exe);
    if (file_exists(pck_path)) {
        offset += snprintf(cmd_line + offset, sizeof(cmd_line) - (size_t)offset, " --main-pack \"%s\"", pck_path);
    }

    bool wait_for_exit = false;
    if (argc > 1) {
        for (int i = 1; i < argc; i++) {
            if (strcmp(argv[i], "--headless") == 0 || strcmp(argv[i], "--quit") == 0) {
                wait_for_exit = true;
            }
            offset += snprintf(cmd_line + offset, sizeof(cmd_line) - (size_t)offset, " \"%s\"", argv[i]);
        }
    } else {
        offset += snprintf(cmd_line + offset, sizeof(cmd_line) - (size_t)offset, " -- --3d --music");
    }

    STARTUPINFOA si;
    PROCESS_INFORMATION pi;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));

    if (!CreateProcessA(
            godot_exe,
            cmd_line,
            NULL,
            NULL,
            TRUE,
            0,
            NULL,
            base_dir,
            &si,
            &pi)) {
        fprintf(stderr, "[Launcher] ERROR: CreateProcessA failed (%lu)\n", GetLastError());
        return 1;
    }

    DWORD exit_code = 0;
    if (wait_for_exit) {
        WaitForSingleObject(pi.hProcess, INFINITE);
        GetExitCodeProcess(pi.hProcess, &exit_code);
    }

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return (int)exit_code;
}
