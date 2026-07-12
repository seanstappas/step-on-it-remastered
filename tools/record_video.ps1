<#
record_video.ps1 - capture a scripted gameplay clip to media/video/ so we can
watch the remaster's progress over time.

Uses Godot's Movie Maker (--write-movie) with the front-end's built-in --demo
scripted play (600 physics frames, then it quits and finalizes the file), then
transcodes the raw AVI to a small mp4 with ffmpeg (if present).

The game window renders OFF-SCREEN (position 9000,9000) so recording does not pop
up a window on the desktop -- the capture flags auto-hide it (Godot --headless would
be blank). Pass -Visible to watch it record on-screen instead.

Usage:
  powershell -ExecutionPolicy Bypass -File tools/record_video.ps1 [-Label sprites] [-Mode retro|remastered] [-Visible]
#>
param(
    [string]$Label = "gameplay",
    [ValidateSet("retro", "remastered")][string]$Mode = "retro",
    [string]$Board = "",          # e.g. board_301.bord — records this real board via --play
    [int]$Play = 0,               # frames to play the real board (0 = use the --demo showcase)
    [switch]$Bug3,                # record the bug #3 proof (Robo fall-death) via the --bug3 showcase
    [switch]$HD,                  # --hd: load the 4x AI-upscaled sheets + record at 1280x960 (native)
    [switch]$Visible,             # record with the window ON-SCREEN (default: hidden/off-screen)
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    $dir = Join-Path $root 'media/video'
    New-Item -ItemType Directory -Force $dir | Out-Null
    $stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $base = "{0}_{1}_{2}" -f $Label, $Mode, $stamp
    $avi = Join-Path $dir "$base.avi"
    $mp4 = Join-Path $dir "$base.mp4"

    if (-not (Test-Path $Godot)) { throw "Godot not found at $Godot" }

    Write-Host "==> recording $Mode demo -> $avi" -ForegroundColor Cyan
    $gargs = if ($Play -gt 0) { @("--play=$Play", "--mode=$Mode", "--board=$Board") } elseif ($Bug3) { @("--bug3", "--mode=$Mode") } else { @("--demo", "--mode=$Mode") }
    if ($HD) { $gargs += "--hd" }
    if ($Visible) { $gargs += "--visible" }   # else the --demo/--play capture flag auto-hides the window
    $gargs += "--hidden"   # force off-screen headless render (main_menu _apply_window_mode) so the
                           # capture never pops a window onto the desktop
    $res = if ($HD) { '1280x960' } else { '640x480' }   # HD renders the 640x480 canvas at 2x (crisp sprites)
    # Godot can print a harmless "ObjectDB instances leaked at exit" warning to
    # stderr when it quits mid-movie; don't let that abort the transcode below.
    $prevEAP = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    & $Godot --path godot_project --resolution $res --fixed-fps 60 --position 9000,9000 `
        --write-movie $avi -- @gargs 2>&1 | Out-Null
    $ErrorActionPreference = $prevEAP

    if (-not (Test-Path $avi)) { throw "movie file was not written (Godot movie writer failed)" }
    $aviMB = [math]::Round((Get-Item $avi).Length / 1MB, 1)
    Write-Host "    wrote $avi ($aviMB MB)" -ForegroundColor Green

    $ff = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($ff) {
        Write-Host "==> transcoding -> $mp4" -ForegroundColor Cyan
        $vf = if ($HD) { "scale=iw:ih" } else { "scale=iw*2:ih*2:flags=neighbor" }
        & $ff.Source -y -loglevel error -i $avi -c:v libx264 -pix_fmt yuv420p -crf 20 `
            -c:a aac -b:a 160k -vf $vf $mp4
        if (Test-Path $mp4) {
            $mp4MB = [math]::Round((Get-Item $mp4).Length / 1MB, 1)
            $note = if ($HD) { "1280x960 HD" } else { "2x nearest-neighbour" }
            Write-Host "    wrote $mp4 ($mp4MB MB, $note)" -ForegroundColor Green
            Remove-Item $avi -ErrorAction SilentlyContinue   # keep only the small mp4
        }
    } else {
        Write-Host "    (ffmpeg not found; keeping the raw .avi)" -ForegroundColor Yellow
    }
}
finally {
    Pop-Location
}
