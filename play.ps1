<#
play.ps1 -- launch Step On It! Remastered for play-testing the live ORIGINAL <-> REMASTERED switch.

  F2   ORIGINAL (1996 SD art, 8-bit SFX, original-game music)  <->  REMASTERED (frame-matched 3D
       sprites, remastered SFX, studio music remaster). Works on the title menu and in game; the
       board keeps playing and the music keeps its place.
  F3   (REMASTERED) 3D sprites <-> the HD AI-upscaled sheets (frames without a 3D render are HD).
  M    Retro <-> Remastered display effects (glow + vignette).
  P1 arrows (see Help for the full key list), Tab = pause, Esc = menu.

Starts REMASTERED with music on. The window is the largest whole multiple of 640x480 that fits
the primary monitor (4x on a 4K screen: the 3D art 1:1 and the 1996 pixels crisp).

  .\play.ps1                  # REMASTERED, music on
  .\play.ps1 -Original        # start in the ORIGINAL presentation
  .\play.ps1 -Sfx light       # REMASTERED uses the light SFX clean-up instead of the AudioSR set
  .\play.ps1 -Scale 2         # force a 1280x960 window;  -Fullscreen for full screen
#>
param(
    [switch]$Original,
    [switch]$NoMusic,
    [switch]$Fullscreen,
    [ValidateSet("ai", "light")] [string]$Sfx = "ai",
    [int]$Scale = 0,
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)
$ErrorActionPreference = "Stop"
if (-not (Test-Path $Godot)) { throw "Godot 4.3 not found at $Godot (pass -Godot <path to the exe>)" }
Set-Location $PSScriptRoot
if (-not (Test-Path "godot_project/bin/soi_bridge.windows.template_debug.x86_64.dll")) {
    throw "the GDExtension is not built yet -- run: powershell -ExecutionPolicy Bypass -File tools/verify.ps1"
}
if (-not (Test-Path "extracted/music/original/6lilt.ogg")) {
    Write-Warning "no original soundtrack yet (extracted/music/original) -- ORIGINAL will play the remaster music. Build it: py tools/build_original_music.py"
}

if ($Scale -le 0) {
    # physical pixels (this process is otherwise DPI-virtualised on a scaled 4K desktop)
    Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class SoiDpi { [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
    [SoiDpi]::SetProcessDPIAware() | Out-Null
    Add-Type -AssemblyName System.Windows.Forms
    $wa = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
    $Scale = [Math]::Max(1, [Math]::Min([Math]::Floor(($wa.Height - 80) / 480), [Math]::Floor($wa.Width / 640)))
}
$gargs = @("--path", "godot_project")
if ($Fullscreen) { $gargs += "--fullscreen" } else { $gargs += @("--resolution", ("{0}x{1}" -f (640 * $Scale), (480 * $Scale))) }
$gargs += "--"
if (-not $Original) { $gargs += "--3d" }
if (-not $NoMusic) { $gargs += "--music" }
if ($Sfx -ne "ai") { $gargs += "--sfx-variant=$Sfx" }
Write-Host ("Step On It! -- {0}, {1}. F2 = original/remastered, F3 = 3D/HD sprites." -f `
    $(if ($Original) { "ORIGINAL" } else { "REMASTERED" }), $(if ($Fullscreen) { "full screen" } else { "{0}x{1}" -f (640 * $Scale), (480 * $Scale) }))
& $Godot @gargs
