param([string]$Log = "tmp/r14_ostrich.log")
# Hold the ostrich's two walk cycles at one yaw each (30 / 150: the original's fixed camera), re-fit the legs with
# yaw frozen, then republish (final verify tweens live livecal livegate) via fm_batch.
Set-Location (Split-Path -Parent $PSScriptRoot)
$t0 = Get-Date
py tmp/yaw_const.py ostrich_sprites 2,3,4,5,6,7,8,9 set 30 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^(optim: mean|yaw after)|(?i)error|Traceback' } | Add-Content -Path $Log
py tmp/yaw_const.py ostrich_sprites 26,27,28,29,30,31,32,33 set 150 2>&1 | ForEach-Object { "$_" } | Where-Object { $_ -match '^(optim: mean|yaw after)|(?i)error|Traceback' } | Add-Content -Path $Log
Add-Content -Path $Log -Value ("yaw refits done ({0:n0} s)" -f ((Get-Date) - $t0).TotalSeconds)
powershell -ExecutionPolicy Bypass -File tmp/fm_batch.ps1 -Log $Log -Stages "final verify tweens live livecal livegate" -Families ostrich_sprites
