param([string[]]$Families, [string]$Stages, [string]$Log)
# Scratch batch: run framematch stages on each family in turn, keeping the summary lines.
Set-Location (Split-Path -Parent $PSScriptRoot)
$Families = $Families | ForEach-Object { $_ -split '[,\s]+' } | Where-Object { $_ }
$st = $Stages -split '\s+' | Where-Object { $_ }
foreach ($f in $Families) {
    $t0 = Get-Date
    $out = py tools/soi3d/framematch.py $f @st 2>&1 | ForEach-Object { "$_" }
    $keep = $out | Where-Object { $_ -match '^(verify|tweens|live|livecal|livegate|bake|look:|final|  live|  cycles|  worst)' -or $_ -match '(?i)error|Traceback|SystemExit|failed|removed' }
    Add-Content -Path $Log -Value ("== {0} [{1}] ({2:n0} s, exit {3})" -f $f, $Stages, ((Get-Date) - $t0).TotalSeconds, $LASTEXITCODE)
    Add-Content -Path $Log -Value $keep
}
Add-Content -Path $Log -Value "BATCH DONE"
