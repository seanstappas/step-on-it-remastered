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
typedef HGDIOBJ (WINAPI *fn_GetStockObject)(int);

#define SOI_CHECK_TIMEOUT_MS    5000U
#define SOI_DOWNLOAD_TIMEOUT_MS (15ULL * 60ULL * 1000ULL)

#define WM_APP_UPDATE_PROGRESS  (WM_APP + 1)
#define WM_APP_UPDATE_DONE      (WM_APP + 2)

enum UpdateDecision {
    DECISION_PENDING = 0,
    DECISION_UPDATING = 1,
    DECISION_LAUNCH = 2,
    DECISION_APPLY_EXIT = 3
};

struct VelopackApi {
    HMODULE h_vpk;
    fn_vpkc_app_run p_app_run;
    fn_vpkc_new_source_github p_new_source_github;
    fn_vpkc_free_source p_free_source;
    fn_vpkc_new_update_manager p_new_update_manager;
    fn_vpkc_new_update_manager_with_source p_new_update_manager_with_source;
    fn_vpkc_check_for_updates p_check_for_updates;
    fn_vpkc_download_updates p_download_updates;
    fn_vpkc_wait_exit_then_apply_updates p_wait_exit_then_apply_updates;
    fn_vpkc_free_update_info p_free_update_info;
    fn_vpkc_free_update_manager p_free_update_manager;
    fn_vpkc_get_last_error p_get_last_error;
};

struct UpdateWorkerContext {
    struct VelopackApi api;
    char repo_url[1024];
    char token[1024];
    bool has_token;
    int argc;
    char **argv;
    HANDLE h_check_done_event;
    HANDLE h_download_done_event;
    volatile LONG decision;
    volatile LONG progress_pct;
    volatile LONG last_logged_pct;
    HWND volatile progress_hwnd;
};

struct UpdateUiState {
    HWND label_hwnd;
    LONG progress_pct;
    RECT bar_rect;
};

static FILE *g_log_file = NULL;
static INIT_ONCE g_log_cs_once = INIT_ONCE_STATIC_INIT;
static CRITICAL_SECTION g_log_cs;

static BOOL CALLBACK log_cs_init_cb(PINIT_ONCE once, PVOID param, PVOID *ctx) {
    (void)once;
    (void)param;
    (void)ctx;
    InitializeCriticalSection(&g_log_cs);
    return TRUE;
}

static void log_lock(void) {
    InitOnceExecuteOnce(&g_log_cs_once, log_cs_init_cb, NULL, NULL);
    EnterCriticalSection(&g_log_cs);
}

static void log_unlock(void) {
    LeaveCriticalSection(&g_log_cs);
}

static void secure_zero(void *ptr, size_t len) {
    volatile unsigned char *p = (volatile unsigned char *)ptr;
    while (len--) {
        *p++ = 0;
    }
}

static bool get_steponit_appdata_dir(char *out_dir, size_t max_len) {
    char local_app_data[MAX_PATH];
    DWORD len = GetEnvironmentVariableA("LOCALAPPDATA", local_app_data, sizeof(local_app_data));
    if (len == 0 || len >= sizeof(local_app_data)) {
        return false;
    }
    int n = snprintf(out_dir, max_len, "%s\\StepOnIt", local_app_data);
    return (n > 0 && (size_t)n < max_len);
}

static bool get_update_token_file_path(char *out_path, size_t max_len, char *out_dir, size_t dir_max_len) {
    char dir[MAX_PATH];
    if (!get_steponit_appdata_dir(dir, sizeof(dir))) {
        return false;
    }
    if (out_dir && dir_max_len > 0) {
        if (strlen(dir) >= dir_max_len) return false;
        strcpy(out_dir, dir);
    }
    int n = snprintf(out_path, max_len, "%s\\update_token.txt", dir);
    return (n > 0 && (size_t)n < max_len);
}

static void log_init(void) {
    char log_dir[MAX_PATH];
    if (get_steponit_appdata_dir(log_dir, sizeof(log_dir))) {
        CreateDirectoryA(log_dir, NULL);
        char log_path[MAX_PATH];
        int n = snprintf(log_path, sizeof(log_path), "%s\\launcher.log", log_dir);
        if (n > 0 && (size_t)n < sizeof(log_path)) {
            log_lock();
            if (!g_log_file) {
                g_log_file = fopen(log_path, "a");
            }
            log_unlock();
        }
    }
}

static void log_write(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    log_lock();
    if (g_log_file) {
        vfprintf(g_log_file, fmt, args);
        fflush(g_log_file);
    }
    log_unlock();
    va_end(args);
}

static void log_close(void) {
    log_lock();
    if (g_log_file) {
        fclose(g_log_file);
        g_log_file = NULL;
    }
    log_unlock();
}

static void get_exe_dir(char *out_dir, size_t max_len) {
    char path[MAX_PATH];
    DWORD len = GetModuleFileNameA(NULL, path, MAX_PATH);
    if (len == 0 || len >= MAX_PATH) {
        if (max_len > 1) {
            strcpy(out_dir, ".");
        } else if (max_len == 1) {
            out_dir[0] = '\0';
        }
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

static bool is_ascii_ws(char c) {
    return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
}

static void strip_utf8_bom(char *buf, size_t *len) {
    if (*len >= 3 &&
        (unsigned char)buf[0] == 0xEF &&
        (unsigned char)buf[1] == 0xBB &&
        (unsigned char)buf[2] == 0xBF) {
        memmove(buf, buf + 3, *len - 3 + 1);
        *len -= 3;
    }
}

static void trim_whitespace(char *s) {
    if (!s) return;
    size_t len = strlen(s);
    size_t start = 0;
    while (start < len && is_ascii_ws(s[start])) {
        start++;
    }
    size_t end = len;
    while (end > start && is_ascii_ws(s[end - 1])) {
        end--;
    }
    size_t new_len = end - start;
    if (start > 0 && new_len > 0) {
        memmove(s, s + start, new_len);
    }
    s[new_len] = '\0';
}

static bool read_json_string_field(const char *json_path, const char *field_name, char *out_val, size_t max_len) {
    if (!json_path || !field_name || !out_val || max_len == 0) return false;
    out_val[0] = '\0';
    if (!file_exists(json_path)) return false;

    FILE *f = fopen(json_path, "rb");
    if (!f) return false;
    char buf[8192];
    size_t n = fread(buf, 1, sizeof(buf) - 1, f);
    fclose(f);
    buf[n] = '\0';
    strip_utf8_bom(buf, &n);

    char key_pattern[128];
    int kn = snprintf(key_pattern, sizeof(key_pattern), "\"%s\"", field_name);
    if (kn <= 0 || (size_t)kn >= sizeof(key_pattern)) {
        secure_zero(buf, sizeof(buf));
        return false;
    }

    const char *cursor = buf;
    const char *val_start = NULL;
    while ((cursor = strstr(cursor, key_pattern)) != NULL) {
        if (cursor > buf && cursor[-1] == '\\') {
            cursor += 1;
            continue;
        }
        const char *p = cursor + (size_t)kn;
        while (*p && is_ascii_ws(*p)) p++;
        if (*p != ':') {
            cursor += 1;
            continue;
        }
        p++;
        while (*p && is_ascii_ws(*p)) p++;
        if (*p != '"') {
            secure_zero(buf, sizeof(buf));
            return false;
        }
        val_start = p + 1;
        break;
    }

    if (!val_start) {
        secure_zero(buf, sizeof(buf));
        return false;
    }

    size_t out_idx = 0;
    const char *cur = val_start;
    while (*cur != '\0' && *cur != '"') {
        char ch = *cur;
        if (ch == '\\') {
            cur++;
            if (*cur == '\0') {
                out_val[0] = '\0';
                secure_zero(buf, sizeof(buf));
                return false;
            }
            switch (*cur) {
                case '\\': ch = '\\'; break;
                case '"':  ch = '"';  break;
                case '/':  ch = '/';  break;
                case 'n':  ch = '\n'; break;
                case 'r':  ch = '\r'; break;
                case 't':  ch = '\t'; break;
                case 'b':  ch = '\b'; break;
                case 'f':  ch = '\f'; break;
                default:   ch = *cur; break;
            }
        }
        if (out_idx + 1 >= max_len) {
            out_val[0] = '\0';
            secure_zero(buf, sizeof(buf));
            return false;
        }
        out_val[out_idx++] = ch;
        cur++;
    }

    if (*cur != '"') {
        out_val[0] = '\0';
        secure_zero(buf, sizeof(buf));
        return false;
    }

    out_val[out_idx] = '\0';
    secure_zero(buf, sizeof(buf));
    return (out_idx > 0);
}

static bool read_repo_url_from_json(const char *json_path, char *out_url, size_t max_len) {
    return read_json_string_field(json_path, "repo_url", out_url, max_len);
}

static bool resolve_repo_url(const char *base_dir, char *out_url, size_t max_len) {
    if (!out_url || max_len == 0) return false;
    out_url[0] = '\0';

    char env_buf[1024];
    DWORD env_len = GetEnvironmentVariableA("SOI_UPDATE_URL", env_buf, sizeof(env_buf));
    if (env_len > 0 && env_len < sizeof(env_buf)) {
        trim_whitespace(env_buf);
        if (env_buf[0] != '\0' && strlen(env_buf) < max_len) {
            strcpy(out_url, env_buf);
            return true;
        }
    }

    if (base_dir && base_dir[0] != '\0') {
        char cfg_path[MAX_PATH];
        int n = snprintf(cfg_path, sizeof(cfg_path), "%s\\update_config.json", base_dir);
        if (n > 0 && (size_t)n < sizeof(cfg_path) && read_repo_url_from_json(cfg_path, out_url, max_len)) {
            return true;
        }
        n = snprintf(cfg_path, sizeof(cfg_path), "%s\\..\\update_config.json", base_dir);
        if (n > 0 && (size_t)n < sizeof(cfg_path) && read_repo_url_from_json(cfg_path, out_url, max_len)) {
            return true;
        }
    }
    return false;
}

static bool resolve_update_token(const char *base_dir, char *out_token, size_t max_len) {
    if (!out_token || max_len == 0) return false;
    out_token[0] = '\0';

    char buf[1024];

    /* 1. Environment variable SOI_UPDATE_TOKEN */
    DWORD env_len = GetEnvironmentVariableA("SOI_UPDATE_TOKEN", buf, sizeof(buf));
    if (env_len > 0 && env_len < sizeof(buf)) {
        trim_whitespace(buf);
        if (buf[0] != '\0' && strlen(buf) < max_len) {
            strcpy(out_token, buf);
            secure_zero(buf, sizeof(buf));
            return true;
        }
    }
    secure_zero(buf, sizeof(buf));

    /* 2. %LOCALAPPDATA%\StepOnIt\update_token.txt */
    char token_path[MAX_PATH];
    if (get_update_token_file_path(token_path, sizeof(token_path), NULL, 0) && file_exists(token_path)) {
        FILE *f = fopen(token_path, "rb");
        if (f) {
            size_t n = fread(buf, 1, sizeof(buf) - 1, f);
            fclose(f);
            buf[n] = '\0';
            strip_utf8_bom(buf, &n);
            trim_whitespace(buf);
            if (buf[0] != '\0' && strlen(buf) < max_len) {
                strcpy(out_token, buf);
                secure_zero(buf, sizeof(buf));
                return true;
            }
        }
    }
    secure_zero(buf, sizeof(buf));

    /* 3. Optional "update_token" key in update_config.json */
    if (base_dir && base_dir[0] != '\0') {
        char cfg_path[MAX_PATH];
        int n = snprintf(cfg_path, sizeof(cfg_path), "%s\\update_config.json", base_dir);
        if (n > 0 && (size_t)n < sizeof(cfg_path) &&
            read_json_string_field(cfg_path, "update_token", buf, sizeof(buf))) {
            trim_whitespace(buf);
            if (buf[0] != '\0' && strlen(buf) < max_len) {
                strcpy(out_token, buf);
                secure_zero(buf, sizeof(buf));
                return true;
            }
        }
        secure_zero(buf, sizeof(buf));

        n = snprintf(cfg_path, sizeof(cfg_path), "%s\\..\\update_config.json", base_dir);
        if (n > 0 && (size_t)n < sizeof(cfg_path) &&
            read_json_string_field(cfg_path, "update_token", buf, sizeof(buf))) {
            trim_whitespace(buf);
            if (buf[0] != '\0' && strlen(buf) < max_len) {
                strcpy(out_token, buf);
                secure_zero(buf, sizeof(buf));
                return true;
            }
        }
    }

    secure_zero(buf, sizeof(buf));
    return false;
}

static bool has_console_or_pipe_output(void) {
    HANDLE h_out = GetStdHandle(STD_OUTPUT_HANDLE);
    if (h_out != NULL && h_out != INVALID_HANDLE_VALUE) {
        DWORD type = GetFileType(h_out);
        if (type == FILE_TYPE_PIPE || type == FILE_TYPE_DISK || type == FILE_TYPE_CHAR) {
            return true;
        }
    }
    if (AttachConsole(ATTACH_PARENT_PROCESS)) {
        if (freopen("CONOUT$", "w", stdout) != NULL) {
            return true;
        }
    }
    return false;
}

static void show_token_cli_confirmation(const char *msg, bool is_error, bool quiet_ui) {
    if (quiet_ui) {
        return;
    }
    if (has_console_or_pipe_output()) {
        fprintf(stdout, "%s\n", msg);
        fflush(stdout);
        return;
    }
    MessageBoxA(NULL, msg, "Step On It! Updater", MB_OK | (is_error ? MB_ICONERROR : MB_ICONINFORMATION));
}

static int write_update_token_file(const char *raw_token, bool quiet_ui) {
    char token_buf[1024];
    if (!raw_token || strlen(raw_token) >= sizeof(token_buf)) {
        show_token_cli_confirmation("Invalid or missing update token.", true, quiet_ui);
        return 1;
    }
    strcpy(token_buf, raw_token);
    trim_whitespace(token_buf);
    if (token_buf[0] == '\0') {
        secure_zero(token_buf, sizeof(token_buf));
        show_token_cli_confirmation("Update token cannot be empty.", true, quiet_ui);
        return 1;
    }

    char dir[MAX_PATH];
    char token_path[MAX_PATH];
    if (!get_update_token_file_path(token_path, sizeof(token_path), dir, sizeof(dir))) {
        secure_zero(token_buf, sizeof(token_buf));
        show_token_cli_confirmation("Could not resolve LOCALAPPDATA path.", true, quiet_ui);
        return 1;
    }

    if (!CreateDirectoryA(dir, NULL)) {
        DWORD err = GetLastError();
        if (err != ERROR_ALREADY_EXISTS) {
            secure_zero(token_buf, sizeof(token_buf));
            show_token_cli_confirmation("Failed to create StepOnIt app data directory.", true, quiet_ui);
            return 1;
        }
    }

    FILE *f = fopen(token_path, "wb");
    if (!f) {
        secure_zero(token_buf, sizeof(token_buf));
        show_token_cli_confirmation("Failed to write update token file.", true, quiet_ui);
        return 1;
    }

    size_t tok_len = strlen(token_buf);
    size_t wrote = fwrite(token_buf, 1, tok_len, f);
    int nl_ok = fputc('\n', f);
    fclose(f);
    secure_zero(token_buf, sizeof(token_buf));

    if (wrote != tok_len || nl_ok == EOF) {
        show_token_cli_confirmation("Failed while writing update token file.", true, quiet_ui);
        return 1;
    }

    log_write("[Launcher] Saved update token (token: present).\n");
    show_token_cli_confirmation("Update token saved.", false, quiet_ui);
    return 0;
}

static int clear_update_token_file(bool quiet_ui) {
    char token_path[MAX_PATH];
    if (!get_update_token_file_path(token_path, sizeof(token_path), NULL, 0)) {
        show_token_cli_confirmation("Could not resolve LOCALAPPDATA path.", true, quiet_ui);
        return 1;
    }

    if (DeleteFileA(token_path)) {
        log_write("[Launcher] Cleared update token (token: absent).\n");
        show_token_cli_confirmation("Update token cleared.", false, quiet_ui);
        return 0;
    }

    DWORD err = GetLastError();
    if (err == ERROR_FILE_NOT_FOUND || err == ERROR_PATH_NOT_FOUND) {
        log_write("[Launcher] Clear update token requested; none stored (token: absent).\n");
        show_token_cli_confirmation("No update token was saved.", false, quiet_ui);
        return 0;
    }

    show_token_cli_confirmation("Failed to delete update token file.", true, quiet_ui);
    return 1;
}

static void on_download_progress(void *user_data, size_t progress) {
    struct UpdateWorkerContext *ctx = (struct UpdateWorkerContext *)user_data;
    if (progress > 100) progress = 100;
    LONG pct = (LONG)progress;
    if (ctx) {
        InterlockedExchange(&ctx->progress_pct, pct);
        LONG prev = InterlockedExchange(&ctx->last_logged_pct, pct);
        if (prev != pct) {
            log_write("[Launcher] Downloading update... %ld%%\n", pct);
        }
        HWND hwnd = (HWND)InterlockedCompareExchangePointer((PVOID *)&ctx->progress_hwnd, NULL, NULL);
        if (hwnd != NULL) {
            PostMessageA(hwnd, WM_APP_UPDATE_PROGRESS, (WPARAM)pct, 0);
        }
    } else {
        log_write("[Launcher] Downloading update... %zu%%\n", progress);
    }
}

static LRESULT CALLBACK update_window_proc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    struct UpdateUiState *state = (struct UpdateUiState *)GetWindowLongPtrA(hwnd, GWLP_USERDATA);

    switch (msg) {
        case WM_NCCREATE: {
            CREATESTRUCTA *cs = (CREATESTRUCTA *)lParam;
            SetWindowLongPtrA(hwnd, GWLP_USERDATA, (LONG_PTR)cs->lpCreateParams);
            return TRUE;
        }
        case WM_APP_UPDATE_PROGRESS: {
            LONG pct = (LONG)wParam;
            if (pct < 0) pct = 0;
            if (pct > 100) pct = 100;
            if (state) {
                state->progress_pct = pct;
                if (state->label_hwnd) {
                    char text[64];
                    snprintf(text, sizeof(text), "Updating Step On It!... %ld%%", pct);
                    SetWindowTextA(state->label_hwnd, text);
                }
                InvalidateRect(hwnd, &state->bar_rect, FALSE);
            }
            return 0;
        }
        case WM_APP_UPDATE_DONE:
            DestroyWindow(hwnd);
            return 0;
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            RECT rc;
            GetClientRect(hwnd, &rc);
            FillRect(hdc, &rc, GetSysColorBrush(COLOR_BTNFACE));
            if (state) {
                RECT bar = state->bar_rect;
                FrameRect(hdc, &bar, GetSysColorBrush(COLOR_BTNSHADOW));
                RECT inner = bar;
                inner.left += 1;
                inner.top += 1;
                inner.right -= 1;
                inner.bottom -= 1;
                FillRect(hdc, &inner, GetSysColorBrush(COLOR_WINDOW));

                LONG inner_w = inner.right - inner.left;
                LONG fill_w = (inner_w * state->progress_pct) / 100;
                if (fill_w > 0) {
                    RECT fill_rc = inner;
                    fill_rc.right = inner.left + fill_w;
                    FillRect(hdc, &fill_rc, GetSysColorBrush(COLOR_HIGHLIGHT));
                }
            }
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_CLOSE:
            /* Ignore manual close while update download/apply is active */
            return 0;
        default:
            return DefWindowProcA(hwnd, msg, wParam, lParam);
    }
}

static HWND create_updating_window(struct UpdateUiState *state, LONG initial_pct) {
    memset(state, 0, sizeof(*state));
    state->progress_pct = initial_pct;
    state->bar_rect.left = 20;
    state->bar_rect.top = 46;
    state->bar_rect.right = 360;
    state->bar_rect.bottom = 68;

    HINSTANCE h_inst = GetModuleHandleA(NULL);
    WNDCLASSEXA wc;
    memset(&wc, 0, sizeof(wc));
    wc.cbSize = sizeof(wc);
    wc.lpfnWndProc = update_window_proc;
    wc.hInstance = h_inst;
    wc.hCursor = LoadCursorA(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1);
    wc.lpszClassName = "StepOnItUpdaterWindowClass";
    RegisterClassExA(&wc);

    DWORD style = WS_OVERLAPPED | WS_CAPTION;
    RECT wr = {0, 0, 380, 90};
    AdjustWindowRect(&wr, style, FALSE);
    int win_w = wr.right - wr.left;
    int win_h = wr.bottom - wr.top;
    int sx = GetSystemMetrics(SM_CXSCREEN);
    int sy = GetSystemMetrics(SM_CYSCREEN);
    int x = (sx > win_w) ? ((sx - win_w) / 2) : 0;
    int y = (sy > win_h) ? ((sy - win_h) / 2) : 0;

    HWND hwnd = CreateWindowExA(
        WS_EX_TOPMOST,
        "StepOnItUpdaterWindowClass",
        "Step On It! Updater",
        style,
        x, y, win_w, win_h,
        NULL, NULL, h_inst, state);
    if (!hwnd) {
        return NULL;
    }

    char init_text[64];
    snprintf(init_text, sizeof(init_text), "Updating Step On It!... %ld%%", initial_pct);
    state->label_hwnd = CreateWindowExA(
        0, "STATIC", init_text,
        WS_CHILD | WS_VISIBLE | SS_CENTER,
        20, 16, 340, 22,
        hwnd, NULL, h_inst, NULL);

    if (state->label_hwnd) {
        HMODULE h_gdi = GetModuleHandleA("gdi32.dll");
        if (!h_gdi) h_gdi = LoadLibraryA("gdi32.dll");
        if (h_gdi) {
            fn_GetStockObject p_get_stock = (fn_GetStockObject)(void *)GetProcAddress(h_gdi, "GetStockObject");
            if (p_get_stock) {
                HGDIOBJ font = p_get_stock(DEFAULT_GUI_FONT);
                if (font) {
                    SendMessageA(state->label_hwnd, WM_SETFONT, (WPARAM)font, TRUE);
                }
            }
        }
    }

    ShowWindow(hwnd, SW_SHOW);
    UpdateWindow(hwnd);
    return hwnd;
}

static bool load_velopack_api(const char *base_dir, struct VelopackApi *api) {
    memset(api, 0, sizeof(*api));
    char dll_path[MAX_PATH];
    snprintf(dll_path, sizeof(dll_path), "%s\\velopack_libc_win_x64_msvc.dll", base_dir);
    HMODULE h_vpk = LoadLibraryA(dll_path);
    if (!h_vpk) {
        h_vpk = LoadLibraryA("velopack_libc_win_x64_msvc.dll");
    }
    if (!h_vpk) {
        log_write("[Launcher] velopack_libc DLL not found, skipping update check.\n");
        return false;
    }

    api->h_vpk = h_vpk;
    api->p_app_run = (fn_vpkc_app_run)(void *)GetProcAddress(h_vpk, "vpkc_app_run");
    api->p_new_source_github = (fn_vpkc_new_source_github)(void *)GetProcAddress(h_vpk, "vpkc_new_source_github");
    api->p_free_source = (fn_vpkc_free_source)(void *)GetProcAddress(h_vpk, "vpkc_free_source");
    api->p_new_update_manager = (fn_vpkc_new_update_manager)(void *)GetProcAddress(h_vpk, "vpkc_new_update_manager");
    api->p_new_update_manager_with_source = (fn_vpkc_new_update_manager_with_source)(void *)GetProcAddress(h_vpk, "vpkc_new_update_manager_with_source");
    api->p_check_for_updates = (fn_vpkc_check_for_updates)(void *)GetProcAddress(h_vpk, "vpkc_check_for_updates");
    api->p_download_updates = (fn_vpkc_download_updates)(void *)GetProcAddress(h_vpk, "vpkc_download_updates");
    api->p_wait_exit_then_apply_updates = (fn_vpkc_wait_exit_then_apply_updates)(void *)GetProcAddress(h_vpk, "vpkc_wait_exit_then_apply_updates");
    api->p_free_update_info = (fn_vpkc_free_update_info)(void *)GetProcAddress(h_vpk, "vpkc_free_update_info");
    api->p_free_update_manager = (fn_vpkc_free_update_manager)(void *)GetProcAddress(h_vpk, "vpkc_free_update_manager");
    api->p_get_last_error = (fn_vpkc_get_last_error)(void *)GetProcAddress(h_vpk, "vpkc_get_last_error");
    return true;
}

static DWORD WINAPI update_worker_thread(LPVOID param) {
    struct UpdateWorkerContext *ctx = (struct UpdateWorkerContext *)param;
    struct VelopackApi *api = &ctx->api;

    vpkc_update_manager_t *mgr = NULL;
    vpkc_update_source_t *src = NULL;
    struct vpkc_update_info_t *update_info = NULL;
    bool ok = false;

    ULONGLONG t0 = GetTickCount64();

    if ((strncmp(ctx->repo_url, "https://github.com/", 19) == 0 ||
         strncmp(ctx->repo_url, "http://github.com/", 18) == 0) &&
        api->p_new_source_github && api->p_new_update_manager_with_source) {
        const char *tok_arg = ctx->has_token ? ctx->token : NULL;
        src = api->p_new_source_github(ctx->repo_url, tok_arg, false);
        secure_zero(ctx->token, sizeof(ctx->token));
        if (src) {
            ok = api->p_new_update_manager_with_source(src, NULL, NULL, &mgr);
        }
    } else {
        secure_zero(ctx->token, sizeof(ctx->token));
        ok = api->p_new_update_manager(ctx->repo_url, NULL, NULL, &mgr);
    }

    if (!ok || !mgr) {
        char err_buf[512] = {0};
        if (api->p_get_last_error) {
            api->p_get_last_error(err_buf, sizeof(err_buf));
        }
        log_write("[Launcher] Update manager init failed (%s).\n", err_buf[0] ? err_buf : "unknown");
        InterlockedCompareExchange(&ctx->decision, DECISION_LAUNCH, DECISION_PENDING);
        SetEvent(ctx->h_check_done_event);
        if (src && api->p_free_source) api->p_free_source(src);
        return 0;
    }

    log_write("[Launcher] Checking for updates at %s (token: %s)...\n",
              ctx->repo_url, ctx->has_token ? "present" : "absent");
    vpkc_update_check_t check = api->p_check_for_updates(mgr, &update_info);
    ULONGLONG elapsed_ms = GetTickCount64() - t0;

    if (check != UPDATE_AVAILABLE || update_info == NULL) {
        char err_buf[512] = {0};
        if (check == UPDATE_ERROR && api->p_get_last_error) {
            api->p_get_last_error(err_buf, sizeof(err_buf));
        }
        log_write("[Launcher] No updates found (check code %d, %llu ms%s%s).\n",
                  (int)check,
                  (unsigned long long)elapsed_ms,
                  err_buf[0] ? ", error: " : "",
                  err_buf[0] ? err_buf : "");
        InterlockedCompareExchange(&ctx->decision, DECISION_LAUNCH, DECISION_PENDING);
        SetEvent(ctx->h_check_done_event);
        if (update_info) api->p_free_update_info(update_info);
        api->p_free_update_manager(mgr);
        if (src && api->p_free_source) api->p_free_source(src);
        return 0;
    }

    /* Try to claim DECISION_UPDATING before main thread's 5s check timeout abandons check. */
    LONG prev = InterlockedCompareExchange(&ctx->decision, DECISION_UPDATING, DECISION_PENDING);
    SetEvent(ctx->h_check_done_event);
    if (prev != DECISION_PENDING) {
        log_write("[Launcher] Update found after check timeout (%llu ms); skipping download.\n",
                  (unsigned long long)elapsed_ms);
        api->p_free_update_info(update_info);
        api->p_free_update_manager(mgr);
        if (src && api->p_free_source) api->p_free_source(src);
        return 0;
    }

    const char *ver = (update_info->TargetFullRelease && update_info->TargetFullRelease->Version)
                      ? update_info->TargetFullRelease->Version
                      : "latest";
    log_write("[Launcher] Update found (%s) in %llu ms. Downloading...\n",
              ver, (unsigned long long)elapsed_ms);

    bool dl_ok = api->p_download_updates(mgr, update_info, on_download_progress, ctx);
    if (!dl_ok) {
        char err_buf[512] = {0};
        if (api->p_get_last_error) {
            api->p_get_last_error(err_buf, sizeof(err_buf));
        }
        log_write("[Launcher] Update download failed (%s).\n", err_buf[0] ? err_buf : "unknown");
        InterlockedExchange(&ctx->decision, DECISION_LAUNCH);
    } else if (InterlockedCompareExchange(&ctx->decision, DECISION_UPDATING, DECISION_UPDATING) != DECISION_UPDATING) {
        log_write("[Launcher] Update download finished after download timeout; skipping apply.\n");
    } else {
        log_write("[Launcher] Applying update and restarting...\n");
        char **restart_args = (ctx->argc > 1) ? (ctx->argv + 1) : NULL;
        size_t restart_argc = (ctx->argc > 1) ? (size_t)(ctx->argc - 1) : 0;
        if (api->p_wait_exit_then_apply_updates(
                mgr,
                update_info->TargetFullRelease,
                true,
                true,
                restart_args,
                restart_argc)) {
            LONG apply_prev = InterlockedCompareExchange(&ctx->decision, DECISION_APPLY_EXIT, DECISION_UPDATING);
            if (apply_prev != DECISION_UPDATING) {
                log_write("[Launcher] Main thread timed out before apply handoff.\n");
            }
        } else {
            char err_buf[512] = {0};
            if (api->p_get_last_error) {
                api->p_get_last_error(err_buf, sizeof(err_buf));
            }
            log_write("[Launcher] Update apply failed (%s).\n", err_buf[0] ? err_buf : "unknown");
            InterlockedExchange(&ctx->decision, DECISION_LAUNCH);
        }
    }

    api->p_free_update_info(update_info);
    api->p_free_update_manager(mgr);
    if (src && api->p_free_source) api->p_free_source(src);

    SetEvent(ctx->h_download_done_event);
    HWND hwnd = (HWND)InterlockedCompareExchangePointer((PVOID *)&ctx->progress_hwnd, NULL, NULL);
    if (hwnd != NULL) {
        PostMessageA(hwnd, WM_APP_UPDATE_DONE, 0, 0);
    }
    return 0;
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

static bool is_launcher_only_arg(const char *arg) {
    if (strcmp(arg, "--set-update-token") == 0) return true;
    if (strncmp(arg, "--set-update-token=", 19) == 0) return true;
    if (strcmp(arg, "--clear-update-token") == 0) return true;
    return false;
}

static bool is_launcher_value_arg(const char *arg) {
    return strcmp(arg, "--set-update-token") == 0;
}

static void build_godot_cmd_line(
        const char *godot_exe,
        const char *pck_path,
        bool has_pck,
        int argc,
        char **argv,
        char *cmd_line,
        size_t cap,
        bool *out_wait_for_exit) {
    size_t offset = 0;
    int written = snprintf(cmd_line, cap, "\"%s\"", godot_exe);
    if (written > 0 && (size_t)written < cap) {
        offset = (size_t)written;
    }

    if (has_pck && pck_path) {
        append_arg(cmd_line, cap, &offset, "--main-pack");
        append_arg(cmd_line, cap, &offset, pck_path);
    }

    bool wait_for_exit = false;
    bool has_visual_flag = false;
    bool has_music_flag = false;

    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (is_launcher_only_arg(a)) {
            if (is_launcher_value_arg(a) && i + 1 < argc) {
                i++;
            }
            continue;
        }
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
        if (is_launcher_only_arg(a)) {
            if (is_launcher_value_arg(a) && i + 1 < argc) {
                i++;
            }
            continue;
        }
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
        if (is_launcher_only_arg(a)) {
            if (is_launcher_value_arg(a) && i + 1 < argc) {
                i++;
            }
            continue;
        }
        if (is_velo_or_squirrel_arg(a)) continue;
        if (strcmp(a, "--") == 0) continue;
        if (!is_godot_engine_arg(a)) {
            append_arg(cmd_line, cap, &offset, a);
        } else if (is_godot_value_arg(a) && i + 1 < argc && argv[i + 1][0] != '-') {
            /* Skip value consumed above by engine flag */
            i++;
        }
    }

    if (out_wait_for_exit) {
        *out_wait_for_exit = wait_for_exit;
    }
}

/* Returns true if the caller should exit immediately without launching the game (update applied). */
static bool run_update_check_and_download(const char *base_dir, int argc, char **argv, bool is_headless) {
    static struct UpdateWorkerContext ctx;
    memset(&ctx, 0, sizeof(ctx));

    if (!load_velopack_api(base_dir, &ctx.api)) {
        return false;
    }

    if (ctx.api.p_app_run) {
        ctx.api.p_app_run(NULL);
    }

    if (!resolve_repo_url(base_dir, ctx.repo_url, sizeof(ctx.repo_url)) ||
        ctx.repo_url[0] == '\0' ||
        strstr(ctx.repo_url, "YOUR_GITHUB_USER") != NULL) {
        log_write("[Launcher] No valid repo_url configured.\n");
        FreeLibrary(ctx.api.h_vpk);
        return false;
    }

    if (!ctx.api.p_new_update_manager || !ctx.api.p_check_for_updates || !ctx.api.p_download_updates ||
        !ctx.api.p_wait_exit_then_apply_updates || !ctx.api.p_free_update_info || !ctx.api.p_free_update_manager) {
        log_write("[Launcher] Velopack C exports missing.\n");
        FreeLibrary(ctx.api.h_vpk);
        return false;
    }

    ctx.has_token = resolve_update_token(base_dir, ctx.token, sizeof(ctx.token));
    ctx.argc = argc;
    ctx.argv = argv;
    ctx.decision = DECISION_PENDING;
    ctx.progress_pct = 0;
    ctx.last_logged_pct = -1;
    ctx.progress_hwnd = NULL;

    ctx.h_check_done_event = CreateEventA(NULL, TRUE, FALSE, NULL);
    ctx.h_download_done_event = CreateEventA(NULL, TRUE, FALSE, NULL);
    if (!ctx.h_check_done_event || !ctx.h_download_done_event) {
        secure_zero(ctx.token, sizeof(ctx.token));
        if (ctx.h_check_done_event) CloseHandle(ctx.h_check_done_event);
        if (ctx.h_download_done_event) CloseHandle(ctx.h_download_done_event);
        FreeLibrary(ctx.api.h_vpk);
        return false;
    }

    HANDLE h_mutex = CreateMutexA(NULL, FALSE, "StepOnIt_Launcher_Update_Mutex");
    HANDLE h_thread = CreateThread(NULL, 0, update_worker_thread, &ctx, 0, NULL);
    if (!h_thread) {
        secure_zero(ctx.token, sizeof(ctx.token));
        if (h_mutex) CloseHandle(h_mutex);
        CloseHandle(ctx.h_check_done_event);
        CloseHandle(ctx.h_download_done_event);
        FreeLibrary(ctx.api.h_vpk);
        return false;
    }

    /* Phase 1: Bound only manager creation + check_for_updates (~5s). */
    DWORD wait_res = WaitForSingleObject(ctx.h_check_done_event, SOI_CHECK_TIMEOUT_MS);
    LONG dec = InterlockedCompareExchange(&ctx.decision, DECISION_LAUNCH, DECISION_PENDING);
    if (dec == DECISION_PENDING && wait_res == WAIT_TIMEOUT) {
        log_write("[Launcher] Update check timed out after 5s - proceeding to launch game.\n");
    }

    bool should_exit_for_apply = false;

    /* Phase 2: If an update is available, wait for download+apply with Updating UI. */
    if (dec == DECISION_UPDATING) {
        struct UpdateUiState ui_state;
        HWND hwnd = NULL;
        if (!is_headless) {
            LONG init_pct = InterlockedCompareExchange(&ctx.progress_pct, 0, 0);
            hwnd = create_updating_window(&ui_state, init_pct);
            if (hwnd) {
                InterlockedExchangePointer((PVOID *)&ctx.progress_hwnd, hwnd);
                LONG cur_pct = InterlockedCompareExchange(&ctx.progress_pct, 0, 0);
                PostMessageA(hwnd, WM_APP_UPDATE_PROGRESS, (WPARAM)cur_pct, 0);
            }
        }

        ULONGLONG dl_start = GetTickCount64();
        for (;;) {
            MSG msg;
            while (PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE)) {
                if (msg.message == WM_QUIT) {
                    goto download_wait_done;
                }
                TranslateMessage(&msg);
                DispatchMessageA(&msg);
            }

            if (WaitForSingleObject(ctx.h_download_done_event, 0) == WAIT_OBJECT_0) {
                break;
            }

            ULONGLONG elapsed = GetTickCount64() - dl_start;
            if (elapsed >= SOI_DOWNLOAD_TIMEOUT_MS) {
                log_write("[Launcher] Update download timed out after 15m - launching game.\n");
                break;
            }

            DWORD remaining = (DWORD)(SOI_DOWNLOAD_TIMEOUT_MS - elapsed);
            DWORD mr = MsgWaitForMultipleObjects(1, &ctx.h_download_done_event, FALSE, remaining, QS_ALLINPUT);
            if (mr == WAIT_OBJECT_0 || mr == WAIT_TIMEOUT || mr == WAIT_FAILED) {
                break;
            }
        }

download_wait_done:
        if (hwnd) {
            InterlockedExchangePointer((PVOID *)&ctx.progress_hwnd, NULL);
            if (IsWindow(hwnd)) {
                DestroyWindow(hwnd);
            }
            MSG msg;
            while (PeekMessageA(&msg, NULL, 0, 0, PM_REMOVE)) {
                TranslateMessage(&msg);
                DispatchMessageA(&msg);
            }
            UnregisterClassA("StepOnItUpdaterWindowClass", GetModuleHandleA(NULL));
        }

        LONG final_dec = InterlockedCompareExchange(&ctx.decision, DECISION_LAUNCH, DECISION_UPDATING);
        if (final_dec == DECISION_APPLY_EXIT) {
            should_exit_for_apply = true;
        }
    }

    if (h_mutex) {
        CloseHandle(h_mutex);
    }

    /* Wait briefly for worker cleanup so handles/DLL are freed cleanly when not hung. */
    DWORD join_ms = should_exit_for_apply ? 5000U : 50U;
    if (WaitForSingleObject(h_thread, join_ms) == WAIT_OBJECT_0) {
        FreeLibrary(ctx.api.h_vpk);
        CloseHandle(ctx.h_check_done_event);
        CloseHandle(ctx.h_download_done_event);
    }
    CloseHandle(h_thread);
    return should_exit_for_apply;
}

int main(int argc, char **argv) {
    log_init();
    log_write("[Launcher] Starting Step On It Launcher...\n");

    bool quiet_ui = false;
    bool is_headless = false;
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--headless") == 0) {
            is_headless = true;
            quiet_ui = true;
        } else if (strcmp(argv[i], "--quiet") == 0 || strcmp(argv[i], "--silent") == 0) {
            quiet_ui = true;
        }
    }

    /* 0. Handle token management flags without launching the game */
    for (int i = 1; i < argc; i++) {
        const char *a = argv[i];
        if (strcmp(a, "--set-update-token") == 0) {
            const char *tok = (i + 1 < argc) ? argv[i + 1] : NULL;
            int rc = write_update_token_file(tok, quiet_ui);
            log_close();
            return rc;
        }
        if (strncmp(a, "--set-update-token=", 19) == 0) {
            int rc = write_update_token_file(a + 19, quiet_ui);
            log_close();
            return rc;
        }
        if (strcmp(a, "--clear-update-token") == 0) {
            int rc = clear_update_token_file(quiet_ui);
            log_close();
            return rc;
        }
    }

    char base_dir[MAX_PATH];
    get_exe_dir(base_dir, sizeof(base_dir));

    /* 1. Run update check (bounded ~5s) and download+apply if available */
    if (run_update_check_and_download(base_dir, argc, argv, is_headless)) {
        log_write("[Launcher] Exiting so updater can apply update and restart.\n");
        log_close();
        return 0;
    }

    /* 2. Route command line flags to StepOnIt.exe */
    char godot_exe[MAX_PATH];
    snprintf(godot_exe, sizeof(godot_exe), "%s\\StepOnIt.exe", base_dir);
    if (!file_exists(godot_exe)) {
        log_write("[Launcher] ERROR: Could not find %s\n", godot_exe);
        log_close();
        return 1;
    }

    char pck_path[MAX_PATH];
    snprintf(pck_path, sizeof(pck_path), "%s\\StepOnIt.pck", base_dir);
    bool has_pck = file_exists(pck_path);

    char cmd_line[8192];
    bool wait_for_exit = false;
    build_godot_cmd_line(godot_exe, pck_path, has_pck, argc, argv, cmd_line, sizeof(cmd_line), &wait_for_exit);

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
