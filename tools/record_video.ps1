<#
record_video.ps1 - capture a scripted gameplay clip to media/video/ so we can
watch the remaster's progress over time.

Uses Godot's Movie Maker (--write-movie) with the front-end's built-in --demo
scripted play (600 physics frames, then it quits and finalizes the file), then
transcodes the raw AVI to a small mp4 with ffmpeg (if present).

Usage:
  powershell -ExecutionPolicy Bypass -File tools/record_video.ps1 [-Label sprites] [-Mode retro|remastered]
#>
param(
    [string]$Label = "gameplay",
    [ValidateSet("retro", "remastered")][string]$Mode = "retro",
    [string]$Board = "",          # e.g. board_301.bord — records this real board via --play
    [int]$Play = 0,               # frames to play the real board (0 = use the --demo showcase)
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
    $gargs = if ($Play -gt 0) { @("--play=$Play", "--mode=$Mode", "--board=$Board") } else { @("--demo", "--mode=$Mode") }
    # Godot can print a harmless "ObjectDB instances leaked at exit" warning to
    # stderr when it quits mid-movie; don't let that abort the transcode below.
    $prevEAP = $ErrorActionPreference; $ErrorActionPreference = 'Continue'
    & $Godot --path godot_project --resolution 640x480 --fixed-fps 60 `
        --write-movie $avi -- @gargs 2>&1 | Out-Null
    $ErrorActionPreference = $prevEAP

    if (-not (Test-Path $avi)) { throw "movie file was not written (Godot movie writer failed)" }
    $aviMB = [math]::Round((Get-Item $avi).Length / 1MB, 1)
    Write-Host "    wrote $avi ($aviMB MB)" -ForegroundColor Green

    $ff = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if ($ff) {
        Write-Host "==> transcoding -> $mp4" -ForegroundColor Cyan
        & $ff.Source -y -loglevel error -i $avi -c:v libx264 -pix_fmt yuv420p -crf 20 `
            -c:a aac -b:a 160k -vf "scale=iw*2:ih*2:flags=neighbor" $mp4
        if (Test-Path $mp4) {
            $mp4MB = [math]::Round((Get-Item $mp4).Length / 1MB, 1)
            Write-Host "    wrote $mp4 ($mp4MB MB, 2x nearest-neighbour)" -ForegroundColor Green
            Remove-Item $avi -ErrorAction SilentlyContinue   # keep only the small mp4
        }
    } else {
        Write-Host "    (ffmpeg not found; keeping the raw .avi)" -ForegroundColor Yellow
    }
}
finally {
    Pop-Location
}
