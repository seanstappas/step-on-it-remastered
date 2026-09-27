param([string[]]$Families, [string]$Log)
# Scratch batch: export, calibrate and gate each family's live 3D rig, one after another.
Set-Location (Split-Path -Parent $PSScriptRoot)
$Families = $Families | ForEach-Object { $_ -split '[,\s]+' } | Where-Object { $_ }   # -File passes a list as ONE string
foreach ($f in $Families) {
    $t0 = Get-Date
    $out = py tools/soi3d/framematch.py $f live livecal livegate 2>&1 | ForEach-Object { "$_" }
    $keep = $out | Where-Object { $_ -match '^(live|livecal|livegate|  live|  cycles|  worst)' -or $_ -match '(?i)error|Traceback|SystemExit|failed' }
    Add-Content -Path $Log -Value ("== {0} ({1:n0} s, exit {2})" -f $f, ((Get-Date) - $t0).TotalSeconds, $LASTEXITCODE)
    Add-Content -Path $Log -Value $keep
}
Add-Content -Path $Log -Value "BATCH DONE"
