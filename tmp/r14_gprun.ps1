Set-Location (Split-Path -Parent $PSScriptRoot)
py tmp/hold_pose.py GP_run '{\"7\": {\"yaw\": -10, \"hd\": 5}, \"10\": {\"hd\": 10}, \"19\": {\"hd\": 20}, \"35\": {\"hd\": -5}, \"47\": {\"hd\": -15}, \"49\": {\"hd\": -15}}' '{\"hd\": {\"min\": -35, \"max\": 35}}' yaw 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^f\d|optim: (mean|reseed)|improved|(?i)error|Traceback' } | Add-Content -Path tmp/r14_gprun.log
Add-Content -Path tmp/r14_gprun.log -Value "HOLD DONE"
powershell -ExecutionPolicy Bypass -File tmp/fm_batch.ps1 -Log tmp/r14_gprun.log -Stages "final verify tweens live livecal livegate" -Families GP_run
