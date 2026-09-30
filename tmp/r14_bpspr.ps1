Set-Location (Split-Path -Parent $PSScriptRoot)
py tmp/hold_pose.py BP_sprites '{\"75\": {\"yaw\": 90, \"hd\": 0}, \"97\": {\"hd\": 0}}' '{\"hd\": {\"min\": -60, \"max\": 60}}' - 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^f\d|optim: (mean|reseed)|improved|(?i)error|Traceback' } | Add-Content -Path tmp/r14_bpspr.log
Add-Content -Path tmp/r14_bpspr.log -Value "HOLD DONE"
