# Beatability MVP harness

This directory contains an ALE-style test scaffold for the native C game core.
It is intentionally small: `soi_env` exposes reset/step/observe, and
`beat_level` runs deterministic policies against raw BORD files.

## Build

```powershell
$zig = "D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe"
& $zig cc -std=c17 -Wall -Wextra -Icore/include (Get-ChildItem core/src/*.c).FullName tests\beatability\soi_env.c tests\beatability\beat_level.c -o tests\beatability\beat_level.exe
```

## Run one board

```powershell
tests\beatability\beat_level.exe extracted\levels\board_1001.bord idle 60
tests\beatability\beat_level.exe extracted\levels\board_1001.bord right 500
tests\beatability\beat_level.exe extracted\levels\board_1001.bord wander 2000
```

Policies:

- `idle`: no input; flags spawn-death or instant-death regressions.
- `right`: holds right and hops when blocked.
- `wander`: greedily moves toward visible treasure, then key, then door.
- `trace:<path>`: replays one integer input bitmask per line.

## Full report

Python is unavailable in this environment, so the runner is PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File tools\run_beatability.ps1
```

It runs `idle` and `wander` over all `extracted\levels\board_*.bord` files,
prints a board/outcome CSV table, highlights idle deaths, counts wander
outcomes, and writes `tests\beatability\report.txt`.

This is an MVP scaffold for future reinforcement-learning work: the stable
surface is the ALE-style `reset -> step -> observe` ABI. A maintainer could
later add this as a report-only stage to the existing verification script
without changing game behavior.
