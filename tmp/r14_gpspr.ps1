Set-Location (Split-Path -Parent $PSScriptRoot)
py tmp/hold_pose.py GP_sprites '{\"75\": {\"yaw\": 90, \"hd\": 0}, \"97\": {\"hd\": 0}}' '{\"hd\": {\"min\": -60, \"max\": 60}}' - 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^f\d|optim: (mean|reseed)|improved|(?i)error|Traceback' } | Add-Content -Path tmp/r14_gpspr.log
Add-Content -Path tmp/r14_gpspr.log -Value "HOLD DONE"
powershell -ExecutionPolicy Bypass -File tmp/fm_batch.ps1 -Log tmp/r14_gpspr.log -Stages "final verify tweens live livecal livegate" -Families GP_sprites
