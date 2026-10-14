<#
launch_net_duo.ps1 — Launch two local visual game instances for side-by-side online testing.
Window 1 (Host): positioned at left (x=100, y=100, 640x480)
Window 2 (Client): positioned at right (x=760, y=100, 640x480)
#>
param(
    [string]$Godot = 'D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe'
)

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root

Write-Host "==> Launching Host and Client game windows for side-by-side local testing..." -ForegroundColor Cyan

$hostArgs = @(
    '--path', 'godot_project',
    '--position', '100,100',
    '--resolution', '640x480'
)

$clientArgs = @(
    '--path', 'godot_project',
    '--position', '760,100',
    '--resolution', '640x480'
)

$hostProc = Start-Process -FilePath $Godot -ArgumentList $hostArgs -PassThru
$clientProc = Start-Process -FilePath $Godot -ArgumentList $clientArgs -PassThru

Write-Host "[OK] Host launched (PID $($hostProc.Id)), Client launched (PID $($clientProc.Id))" -ForegroundColor Green
Pop-Location
