# Wait for the running framematch batch jobs, printing progress every 30 s until they all finish.
# powershell -ExecutionPolicy Bypass -File tmp/watch_jobs.ps1
$ErrorActionPreference = 'SilentlyContinue'
while ($true) {
    $jobs = Get-CimInstance Win32_Process -Filter "Name='powershell.exe'" | Where-Object { $_.CommandLine -match 'fm_batch\.ps1' -and $_.CommandLine -notmatch 'watch_jobs' }
    if (-not $jobs) { Write-Host ("{0:HH:mm:ss}  all jobs finished" -f (Get-Date)); break }
    foreach ($j in $jobs) {
        $log = [regex]::Match($j.CommandLine, '-Log\s+(\S+)').Groups[1].Value
        $fam = [regex]::Match($j.CommandLine, '-Families\s+"?([^" ]+)').Groups[1].Value
        $all = Get-ChildItem "tmp/soi3d_work/$fam" -Recurse -File
        $new = $all | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        $rate = ($all | Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-1) }).Count
        $stage = ($new.BaseName -replace "^$fam`_", '') -replace '_\d+$', '' -replace '_f\d+$', ''
        $mins = [int]((Get-Date) - (Get-Process -Id $j.ProcessId).StartTime).TotalMinutes
        Write-Host ("{0:HH:mm:ss}  {1,-17} running {2,3} min | step {3,-14} | {4,4} renders/min | log {5}" -f (Get-Date), $fam, $mins, $stage, $rate, $log)
    }
    Wait-Process -Id ($jobs.ProcessId) -Timeout 30
}
foreach ($l in (Get-ChildItem tmp/r13_*.log | Sort-Object LastWriteTime -Descending | Select-Object -First 3)) {
    Get-Content $l.FullName | Where-Object { $_ -match '^==|^verify' } | ForEach-Object { Write-Host $_ }
}
