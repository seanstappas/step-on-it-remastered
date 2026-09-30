Set-Location (Split-Path -Parent $PSScriptRoot)
py tmp/hold_pose.py robo_sprites '{\"3\": {\"s_f\": -11, \"e_f\": 1}, \"19\": {\"s_f\": -11, \"e_f\": 1}, \"20\": {\"s_f\": -11, \"e_f\": 1}, \"31\": {\"s_f\": -11, \"e_f\": 1}, \"32\": {\"s_f\": -11, \"e_f\": 1}}' '{}' s_f,e_f 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^f\d|optim: (mean|reseed)|improved|(?i)error|Traceback' } | Add-Content -Path tmp/r15_robo.log
Add-Content -Path tmp/r15_robo.log -Value "HOLD DONE"
