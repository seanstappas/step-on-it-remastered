<#
verify.ps1 -- one-command build + test + validate for the whole project.

Runs every stage of the pipeline and reports a single PASS/FAIL with an exit
code, so regressions are caught in one shot. Safe to run repeatedly.

Stages:
  1. core: mechanic unit tests          (tests/test_mechanics.c)
  2. core: harness + determinism        (tests/harness.c)
  3. core: rollback synctest            (tests/test_synctest.c over 152 boards)
  4. core: fixture-replay selftest      (tools/fixture_replay.py vs board_401)
  5. core: creeper chain simulation     (tools/verify_creepers.c over every Creeper board)
  6. core: 152-board winnability audit  (tools/verify_winnable.c over 152 boards)
  7. launcher: CLI & token unit tests   (tests/test_launcher_cli.c)
  8. tools: ascii2bord unit tests       (tools/test_ascii2bord.py)
  9. tools: ascii2bord 152-board rt     (tools/ascii2bord.py 152-board byte-exact roundtrip)
  10. art: 3D sprite frames             (tools/soi3d/framematch.py --check: published sets vs SD frames)
  11. bridge: GDExtension build         (bridge/build_zig.ps1: DLL + PDB)
  12. godot: import clean               (headless editor import, no script errors)
  13. godot: run + screenshot           (--shot render, off-screen -> media/screenshots/)
  14. net: rollback soak test           (120ms lag, 30ms jitter)
  15. net: 3-player adversarial soak    (random fuzz inputs, rollback desync detection)
  16. net: edge cases & peer disconnect (tick-0 drops, version mismatch, gating)
  17. net: online progression & retry   (board advances, retry sync)
  18. editor: headless map editor       (--test-editor self-test)
  19. ui: adversarial stress suite      (test_adversarial_m1.tscn: controller, editor, menu, export hygiene)
  (optional: -TestPackaging runs Velopack build, delta, install, and smoke test)

Usage (from repo root):  powershell -File tools/verify.ps1 [-TestPackaging]
#>
param(
    [string]$Zig   = 'D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe',
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64_console.exe',
    [switch]$SkipGodot,
    [switch]$TestPackaging
)

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
$script:fail = 0
$tmpDir = Join-Path $env:TEMP "soi_verify_$PID"
New-Item -ItemType Directory -Force -Path $tmpDir | Out-Null

try {
$Py = 'py'
if (Test-Path '.venv\Scripts\python.exe') {
    $Py = (Resolve-Path '.venv\Scripts\python.exe').Path
} elseif (Get-Command 'py' -ErrorAction SilentlyContinue) {
    $Py = 'py'
} elseif (Get-Command 'python' -ErrorAction SilentlyContinue) {
    $Py = 'python'
}

if ($Godot -notmatch '_console\.exe$' -and (Test-Path ($Godot -replace '\.exe$', '_console.exe'))) {
    $Godot = $Godot -replace '\.exe$', '_console.exe'
}

function Stage([string]$name, [scriptblock]$body) {
    Write-Host "==> $name" -ForegroundColor Cyan
    $ok = $false
    try { $ok = [bool](& $body) } catch { Write-Host $_.Exception.Message -ForegroundColor DarkRed }
    if ($ok) { Write-Host "[PASS] $name" -ForegroundColor Green }
    else     { Write-Host "[FAIL] $name" -ForegroundColor Red; $script:fail++ }
}

function Invoke-Zig([string[]]$ZigArgs) {
    $code = 1
    $out = @()
    for ($attempt = 1; $attempt -le 3; $attempt++) {
        $out = & $Zig @ZigArgs 2>&1
        $code = $LASTEXITCODE
        if ($code -eq 0) { return $true }
        if ($attempt -lt 3) { Start-Sleep -Milliseconds 250 }
    }
    Write-Host "   (zig build failed after 3 attempts, exit $code)" -ForegroundColor DarkRed
    $out | Select-Object -Last 15 | ForEach-Object { Write-Host "   $_" }
    return $false
}

$srcs = Get-ChildItem core/src/*.c | ForEach-Object FullName
$bords = Get-ChildItem extracted/levels/*.bord | ForEach-Object FullName

Stage 'core: mechanic unit tests' {
    $exe = Join-Path $tmpDir 'soi_mech.exe'
    if (-not (Invoke-Zig (@('cc','-std=c17','-O2','-Wall','-Wextra','-Werror','-Icore/include','-Icore/src') + $srcs + @('tests/test_mechanics.c','-o',$exe)))) { return $false }
    $out = & $exe
    [bool]($LASTEXITCODE -eq 0 -and ($out -match 'ALL MECHANIC TESTS PASSED'))
}

Stage 'core: harness + determinism' {
    $exe = Join-Path $tmpDir 'soi_harness.exe'
    if (-not (Invoke-Zig (@('cc','-std=c17','-O2','-Wall','-Wextra','-Wshadow','-Wconversion','-Werror','-Icore/include','-Icore/src') + $srcs + @('tests/harness.c','-o',$exe)))) { return $false }
    $out = & $exe
    [bool]($LASTEXITCODE -eq 0 -and ($out -match 'determinism: PASS'))
}

Stage 'core: rollback synctest (152 boards)' {
    $exe = Join-Path $tmpDir 'soi_synctest.exe'
    if (-not (Invoke-Zig (@('cc','-std=c17','-O2','-Wall','-Wextra','-Werror','-Icore/include') + $srcs + @('tests/test_synctest.c','-o',$exe)))) { return $false }
    $out = & $exe @bords
    [bool]($LASTEXITCODE -eq 0 -and ($out -match 'ALL SYNCTEST ROLLBACK CHECKS PASSED'))
}

Stage 'core: fixture-replay selftest' {
    $dll = Join-Path $tmpDir 'soi_core.dll'
    if (-not (Invoke-Zig (@('cc','-shared','-std=c17','-O2','-Wall','-Wextra','-Wshadow','-Wconversion','-Werror','-Icore/include') + $srcs + @('-o',$dll,'-Wl,--export-all-symbols')))) { return $false }
    if (-not (Test-Path 'extracted/levels/board_401.bord')) {
        Write-Host '   (no extracted board_401.bord -- run tools/extract_assets.py first)' -ForegroundColor Yellow
        return $false
    }
    $out = & $Py tools/fixture_replay.py --lib $dll --bord extracted/levels/board_401.bord --selftest
    [bool]($LASTEXITCODE -eq 0 -and ($out -match 'SELFTEST: PASS'))
}

Stage 'core: creeper chain simulation' {
    $exe = Join-Path $tmpDir 'soi_creeper_sim.exe'
    if (-not (Invoke-Zig (@('cc','-std=c17','-O2','-Wall','-Wextra','-Werror','-Icore/include','-Icore/src') + $srcs + @('tools/verify_creepers.c','-o',$exe)))) { return $false }
    $out = & $exe @bords
    $code = $LASTEXITCODE
    $out | Where-Object { $_ -match '^(FAIL|===)' } | ForEach-Object { Write-Host "   $_" }
    if (-not ($out -match '===')) { Write-Host "   (no summary line; exit code $code)"; $out | Select-Object -Last 5 | ForEach-Object { Write-Host "   $_" } }
    [bool]($code -eq 0 -and ($out -match ' 0 FAILED'))
}

Stage 'core: 152-board winnability audit' {
    $exe = Join-Path $tmpDir 'soi_winnable.exe'
    if (-not (Invoke-Zig (@('cc','-std=c17','-O2','-Wall','-Wextra','-Wshadow','-Wconversion','-Werror','-Icore/include','-Icore/src') + $srcs + @('tools/verify_winnable.c','-o',$exe)))) { return $false }
    $out = & $exe @bords
    $code = $LASTEXITCODE
    $out | Where-Object { $_ -match '^(===|BROKEN|NO-KEY)' } | ForEach-Object { Write-Host "   $_" }
    [bool]($code -eq 0 -and ($out -match '0 no-key, 0 BROKEN'))
}

Stage 'launcher: CLI & token unit tests' {
    $vpkInc = 'D:\SOI-tools\velopack\libc\include'
    if (-not (Test-Path (Join-Path $vpkInc 'Velopack.h'))) {
        $found = Get-ChildItem 'D:\SOI-tools\velopack' -Recurse -Filter 'Velopack.h' -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { $vpkInc = $found.DirectoryName }
    }
    if (-not (Test-Path (Join-Path $vpkInc 'Velopack.h'))) {
        Write-Host "   (Velopack.h not found under D:\SOI-tools\velopack)" -ForegroundColor Yellow
        return $false
    }
    $exe = Join-Path $tmpDir 'test_launcher_cli.exe'
    if (-not (Invoke-Zig @('cc','-std=c17','-O2','-Wall','-Wextra','-Werror',"-I$vpkInc",'tests/test_launcher_cli.c','-o',$exe))) { return $false }
    $out = & $exe
    $code = $LASTEXITCODE
    if ($code -ne 0) { $out | Select-Object -Last 15 | ForEach-Object { Write-Host "   $_" } }
    [bool]($code -eq 0 -and ($out -match 'ALL LAUNCHER CLI ADVERSARIAL TESTS PASSED!'))
}

Stage 'tools: ascii2bord unit tests' {
    $out = & $Py tools/test_ascii2bord.py
    [bool]($LASTEXITCODE -eq 0 -and ($out -match 'ALL ASSERTS PASSED'))
}

Stage 'tools: ascii2bord 152-board byte-exact roundtrip' {
    $out = & $Py tools/ascii2bord.py verify-roundtrip extracted/levels
    [bool]($LASTEXITCODE -eq 0 -and ($out -match '152 passed, 0 failed'))
}

Stage 'art: 3D sprite frames' {
    $out = & $Py tools/soi3d/framematch.py --check
    $code = $LASTEXITCODE
    $out | Where-Object { $_ -match '^(verify|check: (STRAY|PASS|FAIL))' } | ForEach-Object { Write-Host "   $_" }
    [bool]($code -eq 0 -and ($out -match '^check: PASS'))
}

Stage 'bridge: GDExtension build' {
    if (-not (Test-Path 'bridge/godot-cpp')) {
        Write-Host '   (bridge/godot-cpp missing -- clone it per bridge/build_zig.ps1 header)' -ForegroundColor Yellow
        return $false
    }
    $dllDbg = 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.dll'
    $dllRel = 'godot_project/bin/soi_bridge.windows.template_release.x86_64.dll'
    $pdbBase = 'godot_project/bin/soi_bridge.pdb'
    $pdbDbg = 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.pdb'
    $pdbRel = 'godot_project/bin/soi_bridge.windows.template_release.x86_64.pdb'
    & (Join-Path $root 'bridge/build_zig.ps1') -Zig $Zig 2>&1 | Out-Null
    $cutoff = (Get-Date).AddMinutes(-3)
    (Test-Path $dllDbg) -and (Test-Path $dllRel) -and (Test-Path $pdbBase) -and (Test-Path $pdbDbg) -and (Test-Path $pdbRel) -and
        ((Get-Item $dllDbg).LastWriteTime -gt $cutoff) -and ((Get-Item $pdbBase).LastWriteTime -gt $cutoff) -and ((Get-Item $pdbRel).LastWriteTime -gt $cutoff)
}

if (-not $SkipGodot -and (Test-Path $Godot)) {
    Stage 'godot: import clean' {
        & $Godot --headless --editor --path godot_project --quit 2>&1 | Out-Null   # warm import
        $out = & $Godot --headless --editor --path godot_project --quit 2>&1
        if ($out -match 'SCRIPT ERROR|Compilation failed') { return $false }
        $smokeOut = & $Godot --headless --path godot_project res://scenes/smoke_test.tscn --quit-after 300 2>&1
        [bool]($LASTEXITCODE -eq 0 -and ($smokeOut -match 'SMOKE TEST: PASS') -and -not ($smokeOut -match 'SCRIPT ERROR:|SMOKE TEST FAIL'))
    }
    Stage 'godot: run + screenshot' {
        $t0 = Get-Date
        & $Godot --path godot_project --resolution 640x480 --position 9000,9000 -- --shot 2>&1 | Out-Null
        # success = the --shot harness archived a fresh screenshot
        $latest = Get-ChildItem 'media/screenshots/shot_*.png' -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        [bool]($latest) -and ($latest.LastWriteTime -ge $t0.AddSeconds(-5))
    }
    Stage 'net: rollback soak test (120ms lag, 30ms jitter)' {
        $soakOut = & powershell -File (Join-Path $root 'tools/test_net_soak.ps1') -Godot $Godot
        [bool]($LASTEXITCODE -eq 0)
    }
    Stage 'net: 3-player adversarial soak test' {
        $advOut = & powershell -File (Join-Path $root 'tools/test_net_adversarial.ps1') -Godot $Godot
        [bool]($LASTEXITCODE -eq 0)
    }
    Stage 'net: edge cases & peer disconnect handling' {
        $edgeOut = & powershell -File (Join-Path $root 'tools/test_net_edge_cases.ps1') -Godot $Godot
        [bool]($LASTEXITCODE -eq 0)
    }
    Stage 'net: online progression & retry sync' {
        $progOut = & powershell -File (Join-Path $root 'tools/test_net_progression.ps1') -Godot $Godot
        [bool]($LASTEXITCODE -eq 0)
    }
    Stage 'editor: headless map editor self-test (--test-editor)' {
        $edOut = & $Godot --headless --path godot_project res://scenes/editor.tscn --quit-after 600 -- --test-editor 2>&1
        [bool]($LASTEXITCODE -eq 0 -and ($edOut -match 'MapEditor CLI self-test: PASS'))
    }
    Stage 'ui: controller, editor & menu adversarial suite' {
        $uiOut = & $Godot --headless --path godot_project res://scenes/test_adversarial_m1.tscn --quit-after 600 2>&1
        [bool]($LASTEXITCODE -eq 0 -and ($uiOut -match 'CHALLENGE VERDICT: ALL ADVERSARIAL STRESS TESTS PASSED') -and -not ($uiOut -match 'SCRIPT ERROR:|FAIL \['))
    }
} else {
    Write-Host '==> godot stages skipped (editor not found or -SkipGodot)' -ForegroundColor Yellow
}

if ($TestPackaging) {
    Stage 'package: velopack local packaging and update test' {
        $pkgOut = & powershell -ExecutionPolicy Bypass -File (Join-Path $root 'tools/test_velopack_local.ps1') 2>&1
        $code = $LASTEXITCODE
        $pass = [bool]($code -eq 0 -and ($pkgOut -match 'VELOPACK LOCAL PACKAGING & DELTA TEST: ALL PASS'))
        if (-not $pass) {
            $pkgOut | Select-Object -Last 10 | ForEach-Object { Write-Host "   $_" }
        }
        $pass
    }
}
} finally {
    Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
    Pop-Location
}
Write-Host ''
if ($script:fail -eq 0) { Write-Host 'ALL STAGES PASSED' -ForegroundColor Green; exit 0 }
else { Write-Host ("{0} STAGE(S) FAILED" -f $script:fail) -ForegroundColor Red; exit 1 }
