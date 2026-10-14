param(
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root

Write-Host "==> net: edge cases and disconnect test (Join Code vectors, 3P drop heal, 2P/Host drop unblock)" -ForegroundColor Cyan

$logFile = Join-Path $root "edge_cases_test.log"
Remove-Item $logFile -ErrorAction SilentlyContinue

$argsList = @(
    '--headless',
    '--path', 'godot_project',
    '--log-file', $logFile,
    'res://scenes/test_net_edge_cases.tscn'
)

$proc = Start-Process -FilePath $Godot -ArgumentList $argsList -Wait -PassThru -NoNewWindow
$code = $proc.ExitCode

$content = ""
if (Test-Path $logFile) {
    $content = Get-Content $logFile -Raw
    Write-Host $content
    Remove-Item $logFile -ErrorAction SilentlyContinue
}

$pass = ($null -eq $code -or $code -eq 0) -and ($content.Contains('EDGE CASES TEST: PASS'))

if ($pass) {
    Write-Host "[PASS] net: edge cases and disconnect test passed" -ForegroundColor Green
    Pop-Location
    exit 0
} else {
    Write-Host "[FAIL] net: edge cases and disconnect test failed (exit code $code)" -ForegroundColor Red
    Pop-Location
    exit 1
}
