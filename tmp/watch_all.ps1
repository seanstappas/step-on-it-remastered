# Wait for every running soi3d job (framematch.py / hold_pose.py / yaw_const.py / walker_f26.py ... under py.exe),
# printing each one's family, current step and render rate every 30 s until they all finish; then the r14 logs.
# powershell -ExecutionPolicy Bypass -File tmp/watch_all.ps1
$ErrorActionPreference = 'SilentlyContinue'
Set-Location (Split-Path -Parent $PSScriptRoot)
while ($true) {
    $jobs = Get-CimInstance Win32_Process -Filter "Name='python.exe' OR Name='py.exe'" |
        Where-Object { $_.CommandLine -match '(framematch|hold_pose|yaw_const|yaw_mirror|walker_f26)\.py\s+(\S+)' }
    $seen = @{}
    $pids = @()
    foreach ($j in $jobs) {
        $m = [regex]::Match($j.CommandLine, '(framematch|hold_pose|yaw_const|yaw_mirror|walker_f26)\.py\s+(\S+)')
        $fam = $m.Groups[2].Value
        if ($m.Groups[1].Value -eq 'walker_f26') { $fam = 'walker_body' }
        $pids += $j.ProcessId
        if ($seen.ContainsKey($fam)) { continue }
        $seen[$fam] = 1
        $all = Get-ChildItem "tmp/soi3d_work/$fam" -Recurse -File
        $new = $all | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        $rate = ($all | Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-1) }).Count
        $stage = ($new.BaseName -replace "^$fam`_", '') -replace '_\d+$', '' -replace '_f\d+$', ''
        $mins = [int]((Get-Date) - (Get-Process -Id $j.ProcessId).StartTime).TotalMinutes
        Write-Host ("{0:HH:mm:ss}  {1,-16} {2,-10} running {3,3} min | step {4,-16} | {5,4} renders/min" -f (Get-Date), $fam, $m.Groups[1].Value, $mins, $stage, $rate)
    }
    if (-not $pids) { Write-Host ("{0:HH:mm:ss}  all jobs finished" -f (Get-Date)); break }
    Wait-Process -Id $pids -Timeout 30
}
foreach ($l in (Get-ChildItem tmp/r14_*.log | Sort-Object LastWriteTime)) {
    Write-Host ("--- " + $l.Name)
    Get-Content $l.FullName | Where-Object { $_ -match '^==|^verify|^f\d\d (now|was)|HOLD DONE|yaw after|optim: mean|(?i)error' } | ForEach-Object { Write-Host $_ }
}
