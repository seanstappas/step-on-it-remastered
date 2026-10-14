param(
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root

Write-Host "==> net: online progression and retry test" -ForegroundColor Cyan

$logFile = Join-Path $root "progression_test.log"
Remove-Item $logFile -ErrorAction SilentlyContinue

$argsList = @(
    '--headless',
    '--path', 'godot_project',
    '--log-file', $logFile,
    'res://scenes/test_net_progression.tscn'
)

$proc = Start-Process -FilePath $Godot -ArgumentList $argsList -Wait -PassThru -NoNewWindow
$code = $proc.ExitCode

$content = ""
if (Test-Path $logFile) {
    $content = Get-Content $logFile -Raw
    Write-Host $content
    Remove-Item $logFile -ErrorAction SilentlyContinue
}

$pass = ($null -eq $code -or $code -eq 0) -and ($content.Contains('BOARD PROGRESSION TEST: PASS'))

if ($pass) {
    Write-Host "[PASS] net: online progression and retry test passed" -ForegroundColor Green
    Pop-Location
    exit 0
} else {
    Write-Host "[FAIL] net: online progression and retry test failed (exit code $code)" -ForegroundColor Red
    Pop-Location
    exit 1
}
