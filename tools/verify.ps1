<#
verify.ps1 — one-command build + test + validate for the whole project.

Runs every stage of the pipeline and reports a single PASS/FAIL with an exit
code, so regressions are caught in one shot. Safe to run repeatedly.

Stages:
  1. core: mechanic unit tests          (tests/test_mechanics.c)
  2. core: harness + determinism        (tests/harness.c)
  3. core: fixture-replay selftest       (tools/fixture_replay.py vs board_401)
  4. bridge: GDExtension build           (bridge/build_zig.ps1)
  5. godot: import clean                 (headless editor import, no script errors)
  6. godot: run + screenshot             (windowed --shot -> soi_shot.png)

Godot stages are skipped automatically if the editor isn't present (or -SkipGodot).

Usage (from repo root):  powershell -File tools/verify.ps1
#>
param(
    [string]$Zig   = 'D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe',
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe',
    [switch]$SkipGodot
)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
$script:fail = 0

function Stage([string]$name, [scriptblock]$body) {
    Write-Host "==> $name" -ForegroundColor Cyan
    $ok = $false
    try { $ok = [bool](& $body) } catch { Write-Host $_.Exception.Message -ForegroundColor DarkRed }
    if ($ok) { Write-Host "[PASS] $name" -ForegroundColor Green }
    else     { Write-Host "[FAIL] $name" -ForegroundColor Red; $script:fail++ }
}

$srcs = Get-ChildItem core/src/*.c | ForEach-Object FullName

Stage 'core: mechanic unit tests' {
    & $Zig cc -std=c17 -Wall -Wextra -Icore/include -Icore/src @srcs tests/test_mechanics.c -o soi_mech.exe 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { return $false }
    $out = & .\soi_mech.exe
    Remove-Item soi_mech.exe, soi_mech.pdb -ErrorAction SilentlyContinue
    [bool]($out -match 'ALL MECHANIC TESTS PASSED')
}

Stage 'core: harness + determinism' {
    & $Zig cc -std=c17 -Wall -Wextra -Icore/include @srcs tests/harness.c -o soi_harness.exe 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { return $false }
    $out = & .\soi_harness.exe
    Remove-Item soi_harness.exe, soi_harness.pdb -ErrorAction SilentlyContinue
    [bool]($out -match 'determinism: PASS')
}

Stage 'core: fixture-replay selftest' {
    & $Zig cc -shared -std=c17 -Icore/include @srcs -o soi_core.dll '-Wl,--export-all-symbols' 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { return $false }
    if (-not (Test-Path 'extracted/levels/board_401.bord')) {
        Write-Host '   (no extracted board_401.bord — run tools/extract_assets.py first)' -ForegroundColor Yellow
        return $false
    }
    $out = & py tools/fixture_replay.py --lib soi_core.dll --bord extracted/levels/board_401.bord --selftest
    [bool]($out -match 'SELFTEST: PASS')
}

Stage 'bridge: GDExtension build' {
    if (-not (Test-Path 'bridge/godot-cpp')) {
        Write-Host '   (bridge/godot-cpp missing — clone it per bridge/build_zig.ps1 header)' -ForegroundColor Yellow
        return $false
    }
    $dll = 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.dll'
    & (Join-Path $root 'bridge/build_zig.ps1') 2>&1 | Out-Null
    # success = a freshly-written DLL (build_zig throws on failure)
    (Test-Path $dll) -and ((Get-Item $dll).LastWriteTime -gt (Get-Date).AddMinutes(-3))
}

if (-not $SkipGodot -and (Test-Path $Godot)) {
    Stage 'godot: import clean' {
        & $Godot --headless --editor --path godot_project --quit 2>&1 | Out-Null   # warm import
        $out = & $Godot --headless --editor --path godot_project --quit 2>&1
        -not [bool]($out -match 'SCRIPT ERROR|Compilation failed')
    }
    Stage 'godot: run + screenshot' {
        & $Godot --path godot_project --resolution 640x480 -- --shot 2>&1 | Out-Null
        # success = the --shot harness archived a fresh screenshot
        $latest = Get-ChildItem 'media/screenshots/*.png' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        [bool]($latest) -and ($latest.LastWriteTime -gt (Get-Date).AddMinutes(-3))
    }
} else {
    Write-Host '==> godot stages skipped (editor not found or -SkipGodot)' -ForegroundColor Yellow
}

Pop-Location
Write-Host ''
if ($script:fail -eq 0) { Write-Host 'ALL STAGES PASSED' -ForegroundColor Green; exit 0 }
else { Write-Host ("{0} STAGE(S) FAILED" -f $script:fail) -ForegroundColor Red; exit 1 }
