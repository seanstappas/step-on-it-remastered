<#
test_net_soak.ps1 — Automated 2-instance loopback soak test over UDP (127.0.0.1)
Runs headless net_soak_test.tscn simulating 1,200 ticks with 120 ms latency and 30 ms jitter.
Verifies 0 state hash desyncs.
#>
param(
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root

Write-Host "==> net: loopback rollback soak test (120ms lag, 30ms jitter, 1200 ticks)" -ForegroundColor Cyan

$logFile = Join-Path $root "soak_test.log"
Remove-Item $logFile -ErrorAction SilentlyContinue

$argsList = @(
    '--headless',
    '--path', 'godot_project',
    '--log-file', $logFile,
    'res://scenes/net_soak_test.tscn'
)

$proc = Start-Process -FilePath $Godot -ArgumentList $argsList -Wait -PassThru -NoNewWindow
$code = $proc.ExitCode

$content = ""
if (Test-Path $logFile) {
    $content = Get-Content $logFile -Raw
    Write-Host $content
    Remove-Item $logFile -ErrorAction SilentlyContinue
}

$pass = ($null -eq $code -or $code -eq 0) -and ($content.Contains('SOAK TEST: PASS'))

if ($pass) {
    Write-Host "[PASS] net: rollback soak test passed with 0 desyncs" -ForegroundColor Green
    Pop-Location
    exit 0
} else {
    Write-Host "[FAIL] net: rollback soak test failed (exit code $code)" -ForegroundColor Red
    Pop-Location
    exit 1
}
