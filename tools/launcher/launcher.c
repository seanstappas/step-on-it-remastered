#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdarg.h>
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

static FILE *g_log_file = NULL;

static void log_init(void) {
    char local_app_data[MAX_PATH];
    if (GetEnvironmentVariableA("LOCALAPPDATA", local_app_data, sizeof(local_app_data)) > 0) {
        char log_dir[MAX_PATH];
        snprintf(log_dir, sizeof(log_dir), "%s\\StepOnIt", local_app_data);
        CreateDirectoryA(log_dir, NULL);
        char log_path[MAX_PATH];
        snprintf(log_path, sizeof(log_path), "%s\\launcher.log", log_dir);
        g_log_file = fopen(log_path, "a");
    }
}

static void log_write(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    if (g_log_file) {
        vfprintf(g_log_file, fmt, args);
        fflush(g_log_file);
    }
    va_end(args);
}

static void log_close(void) {
    if (g_log_file) {
        fclose(g_log_file);
        g_log_file = NULL;
    }
}

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
    log_write("[Launcher] Downloading update... %zu%%\n", progress);
}

static void append_arg(char *buf, size_t cap, size_t *offset, const char *arg) {
    if (*offset >= cap) return;
    int written = snprintf(buf + *offset, cap - *offset, " \"%s\"", arg);
    if (written > 0 && *offset + (size_t)written < cap) {
        *offset += (size_t)written;
    } else {
        *offset = cap - 1;
    }
}

static bool is_godot_engine_arg(const char *arg) {
    if (strncmp(arg, "--headless", 10) == 0) return true;
    if (strcmp(arg, "--quit") == 0) return true;
    if (strncmp(arg, "--quit-after", 12) == 0) return true;
    if (strncmp(arg, "--verbose", 9) == 0) return true;
    if (strncmp(arg, "--quiet", 7) == 0) return true;
    if (strncmp(arg, "--debug", 7) == 0) return true;
    if (strncmp(arg, "--resolution", 12) == 0) return true;
    if (strncmp(arg, "--position", 10) == 0) return true;
    if (strncmp(arg, "--path", 6) == 0) return true;
    if (strncmp(arg, "--fullscreen", 12) == 0) return true;
    if (strncmp(arg, "--windowed", 10) == 0) return true;
    if (strncmp(arg, "--rendering-driver", 18) == 0) return true;
    if (strncmp(arg, "--display-driver", 16) == 0) return true;
    if (strncmp(arg, "--audio-driver", 14) == 0) return true;
    if (strcmp(arg, "-s") == 0 || strncmp(arg, "--script", 8) == 0) return true;
    if (strncmp(arg, "res://", 6) == 0) return true;
    return false;
}

static bool is_godot_value_arg(const char *arg) {
    if (strcmp(arg, "--resolution") == 0) return true;
    if (strcmp(arg, "--position") == 0) return true;
    if (strcmp(arg, "--path") == 0) return true;
    if (strcmp(arg, "--rendering-driver") == 0) return true;
    if (strcmp(arg, "--display-driver") == 0) return true;
    if (strcmp(arg, "--audio-driver") == 0) return true;
    if (strcmp(arg, "--quit-after") == 0) return true;
    if (strcmp(arg, "-s") == 0 || strcmp(arg, "--script") == 0) return true;
    return false;
}

static bool is_velo_or_squirrel_arg(const char *arg) {
    if (strncmp(arg, "--veloapp-", 10) == 0) return true;
    if (strncmp(arg, "--squirrel", 10) == 0) return true;
    return false;
}

static void run_velopack_and_check_updates(const char *base_dir, int argc, char **argv) {
    char dll_path[MAX_PATH];
    snprintf(dll_path, sizeof(dll_path), "%s\\velopack_libc_win_x64_msvc.dll", base_dir);
    HMODULE h_vpk = LoadLibraryA(dll_path);
    if (!h_vpk) {
        h_vpk = LoadLibraryA("velopack_libc_win_x64_msvc.dll");
    }
    if (!h_vpk) {
        log_write("[Launcher] velopack_libc DLL not found, skipping update check.\n");
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
        log_write("[Launcher] No valid repo_url configured.\n");
        FreeLibrary(h_vpk);
        return;
    }

    if (!p_new_update_manager || !p_check_for_updates || !p_download_updates ||
        !p_wait_exit_then_apply_updates || !p_free_update_info || !p_free_update_manager) {
        log_write("[Launcher] Velopack C exports missing.\n");
        FreeLibrary(h_vpk);
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
        FreeLibrary(h_vpk);
        return;
    }

    struct vpkc_update_info_t *update_info = NULL;
    log_write("[Launcher] Checking for updates at %s...\n", repo_url);
    vpkc_update_check_t check = p_check_for_updates(mgr, &update_info);
    if (check == UPDATE_AVAILABLE && update_info != NULL) {
        const char *ver = (update_info->TargetFullRelease && update_info->TargetFullRelease->Version)
                          ? update_info->TargetFullRelease->Version
                          : "latest";
        log_write("[Launcher] Update found (%s). Downloading...\n", ver);

        if (p_download_updates(mgr, update_info, on_download_progress, NULL)) {
            log_write("[Launcher] Applying update and restarting...\n");
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
                FreeLibrary(h_vpk);
                log_close();
                exit(0);
            }
        } else if (p_get_last_error) {
            char err_buf[512] = {0};
            p_get_last_error(err_buf, sizeof(err_buf));
            log_write("[Launcher] Update download failed (%s).\n", err_buf);
        }
    } else {
        log_write("[Launcher] No updates found (check code %d).\n", check);
    }

    if (update_info) p_free_update_info(update_info);
    p_free_update_manager(mgr);
    if (src && p_free_source) p_free_source(src);
    FreeLibrary(h_vpk);
}

struct UpdateWorkerParams {
    char base_dir[MAX_PATH];
    int argc;
    char **argv;
    bool completed;
};

static DWORD WINAPI update_worker_thread(LPVOID param) {
    struct UpdateWorkerParams *p = (struct UpdateWorkerParams *)param;
    run_velopack_and_check_updates(p->base_dir, p->argc, p->argv);
    p->completed = true;
    return 0;
}

int main(int argc, char **argv) {
    log_init();
    log_write("[Launcher] Starting Step On It Launcher...\n");

    char base_dir[MAX_PATH];
    get_exe_dir(base_dir, sizeof(base_dir));

    /* Hold named mutex to prevent concurrent updater conflicts */
    HANDLE h_mutex = CreateMutexA(NULL, FALSE, "StepOnIt_Launcher_Update_Mutex");

    /* 1. Run update check on worker thread with ~5s timeout */
    struct UpdateWorkerParams update_params;
    strncpy(update_params.base_dir, base_dir, sizeof(update_params.base_dir) - 1);
    update_params.base_dir[sizeof(update_params.base_dir) - 1] = '\0';
    update_params.argc = argc;
    update_params.argv = argv;
    update_params.completed = false;

    HANDLE h_thread = CreateThread(NULL, 0, update_worker_thread, &update_params, 0, NULL);
    if (h_thread) {
        DWORD wait_res = WaitForSingleObject(h_thread, 5000);
        if (wait_res == WAIT_TIMEOUT) {
            log_write("[Launcher] Update check timed out after 5s - proceeding to launch game.\n");
        }
        CloseHandle(h_thread);
    } else {
        run_velopack_and_check_updates(base_dir, argc, argv);
    }

    if (h_mutex) {
        CloseHandle(h_mutex);
    }

    /* 2. Route command line flags */
    char godot_exe[MAX_PATH];
    snprintf(godot_exe, sizeof(godot_exe), "%s\\StepOnIt.exe", base_dir);
    if (!file_exists(godot_exe)) {
        log_write("[Launcher] ERROR: Could not find %s\n", godot_exe);
        log_close();
        return 1;
    }

    char pck_path[MAX_PATH];
    snprintf(pck_path, sizeof(pck_path), "%s\\StepOnIt.pck", base_dir);

    char cmd_line[8192];
    size_t offset = 0;
    int written = snprintf(cmd_line, sizeof(cmd_line), "\"%s\"", godot_exe);
    if (written > 0 && (size_t)written < sizeof(cmd_line)) {
        offset = (size_t)written;
    }

    if (file_exists(pck_path)) {
        append_arg(cmd_line, sizeof(cmd_line), &offset, "--main-pack");
        append_arg(cmd_line, sizeof(cmd_line), &offset, pck_path);
    }

    bool wait_for_exit = false;
    bool has_visual_flag = false;
    bool has_music_flag = false;

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (strcmp(a, "--headless") == 0 || strcmp(a, "--quit") == 0 || strcmp(a, "--quit-after") == 0) {
            wait_for_exit = true;
        }
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
            append_arg(cmd_line, sizeof(cmd_line), &offset, a);
            /* If this flag takes an argument value (e.g. --resolution 640x480, --position 0,0, --quit-after 600) */
            if (is_godot_value_arg(a) && i + 1 < argc && argv[i + 1][0] != '-') {
                i++;
                append_arg(cmd_line, sizeof(cmd_line), &offset, argv[i]);
            }
        }
    }

    /* Game arguments go after '--' */
    append_arg(cmd_line, sizeof(cmd_line), &offset, "--");

    if (!has_visual_flag) {
        append_arg(cmd_line, sizeof(cmd_line), &offset, "--3d");
    }
    if (!has_music_flag) {
        append_arg(cmd_line, sizeof(cmd_line), &offset, "--music");
    }

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (is_velo_or_squirrel_arg(a)) continue;
        if (strcmp(a, "--") == 0) continue;
        if (!is_godot_engine_arg(a)) {
            append_arg(cmd_line, sizeof(cmd_line), &offset, a);
        } else if (is_godot_value_arg(a) && i + 1 < argc && argv[i + 1][0] != '-') {
            /* Skip value consumed above by engine flag */
            i++;
        }
    }

    log_write("[Launcher] Executing: %s\n", cmd_line);

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
        log_write("[Launcher] ERROR: CreateProcessA failed (%lu)\n", GetLastError());
        log_close();
        return 1;
    }

    DWORD exit_code = 0;
    if (wait_for_exit) {
        WaitForSingleObject(pi.hProcess, INFINITE);
        GetExitCodeProcess(pi.hProcess, &exit_code);
    }

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    log_close();
    return (int)exit_code;
}
