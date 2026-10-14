<#
test_net_adversarial.ps1 — Automated 3-Player adversarial soak test over UDP (127.0.0.1)
Runs headless test_net_adversarial.tscn simulating:
- 3 players over Star-Hub topology (P2 <-> P1 <-> P3)
- Asymmetric latency (up to 140 ms) & jitter (up to 35 ms)
- 10-15% packet loss on remote peers
- 1,500 continuous simulation ticks
Verifies 0 state hash desyncs across all 3 players.
#>
param(
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root

Write-Host "==> net: 3-player adversarial soak test (Star-Hub relay, asymmetric lag, 10-15% packet loss)" -ForegroundColor Cyan

$logFile = Join-Path $root "adv_test.log"
Remove-Item $logFile -ErrorAction SilentlyContinue

$argsList = @(
    '--headless',
    '--path', 'godot_project',
    '--log-file', $logFile,
    'res://scenes/test_net_adversarial.tscn'
)

$proc = Start-Process -FilePath $Godot -ArgumentList $argsList -Wait -PassThru -NoNewWindow
$code = $proc.ExitCode

$content = ""
if (Test-Path $logFile) {
    $content = Get-Content $logFile -Raw
    Write-Host $content
    Remove-Item $logFile -ErrorAction SilentlyContinue
}

$pass = ($null -eq $code -or $code -eq 0) -and ($content.Contains('ADVERSARIAL 3P TEST: PASS'))

if ($pass) {
    Write-Host "[PASS] net: 3-player adversarial soak test passed with 0 desyncs" -ForegroundColor Green
    Pop-Location
    exit 0
} else {
    Write-Host "[FAIL] net: 3-player adversarial soak test failed (exit code $code)" -ForegroundColor Red
    Pop-Location
    exit 1
}
