param(
    [string]$BeatLevel = "tests\beatability\beat_level.exe",
    [string]$LevelsDir = "extracted\levels",
    [int]$IdleMoves = 60,
    [int]$WanderMoves = 2000
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location -Path $root

if (-not (Test-Path $BeatLevel)) {
    throw "Beatability executable not found: $BeatLevel"
}

$boards = Get-ChildItem -Path $LevelsDir -Filter "board_*.bord" | Sort-Object Name
$rows = @()
$full = @()

foreach ($board in $boards) {
    $idleLine = & $BeatLevel $board.FullName "idle" $IdleMoves
    if ($LASTEXITCODE -ne 0) { throw "idle run failed for $($board.Name)" }
    $wanderLine = & $BeatLevel $board.FullName "wander" $WanderMoves
    if ($LASTEXITCODE -ne 0) { throw "wander run failed for $($board.Name)" }

    $idle = $idleLine | ConvertFrom-Json
    $wander = $wanderLine | ConvertFrom-Json
    $rows += [pscustomobject]@{
        board = $idle.board
        idle_outcome = $idle.outcome
        wander_outcome = $wander.outcome
    }
    $full += $idle
    $full += $wander
}

$spawnDeath = $rows | Where-Object { $_.idle_outcome -eq "dead" }
$wanderComplete = ($rows | Where-Object { $_.wander_outcome -eq "complete" } | Measure-Object).Count
$wanderTimeout = ($rows | Where-Object { $_.wander_outcome -eq "timeout" } | Measure-Object).Count
$wanderDead = ($rows | Where-Object { $_.wander_outcome -eq "dead" } | Measure-Object).Count
$reportPath = "tests\beatability\report.txt"

$report = New-Object System.Collections.Generic.List[string]
$report.Add("Step On It! beatability MVP report")
$report.Add(("Generated: {0:u}" -f (Get-Date)))
$report.Add("")
$report.Add("board,idle_outcome,wander_outcome")
foreach ($row in $rows) {
    $report.Add(("{0},{1},{2}" -f $row.board, $row.idle_outcome, $row.wander_outcome))
}
$report.Add("")
$report.Add("Spawn-death boards (idle -> dead):")
if ($spawnDeath.Count -eq 0) {
    $report.Add("(none)")
} else {
    foreach ($row in $spawnDeath) { $report.Add($row.board) }
}
$report.Add("")
$report.Add(("Wander complete: {0}" -f $wanderComplete))
$report.Add(("Wander timeout: {0}" -f $wanderTimeout))
$report.Add(("Wander dead: {0}" -f $wanderDead))
$report.Add("")
$report.Add("Raw JSON lines:")
foreach ($item in $full) {
    $report.Add(($item | ConvertTo-Json -Compress))
}

$report | Set-Content -Path $reportPath -Encoding ASCII

$report | ForEach-Object { Write-Output $_ }
