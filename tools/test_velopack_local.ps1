$ErrorActionPreference = 'Stop'
$RootDir = Split-Path -Parent $PSScriptRoot
Push-Location $RootDir
try {
    Write-Host "=================================================================="
    Write-Host "Step On It! Remastered - Velopack Local Packaging and Delta Test"
    Write-Host "=================================================================="

    $ReleaseDir = Join-Path $RootDir "releases"
    if (Test-Path $ReleaseDir) {
        Remove-Item "$ReleaseDir\*" -Force -ErrorAction SilentlyContinue
    }

    # 1. Build v1.0.0 full release
    powershell -ExecutionPolicy Bypass -File tools/publish_velopack.ps1 -Version "1.0.0" -SkipAssetMirror
    if ($LASTEXITCODE -ne 0) { throw "publish_velopack.ps1 v1.0.0 failed" }

    $FullPkg1 = Join-Path $ReleaseDir "StepOnIt-1.0.0-full.nupkg"
    $SetupExe = Join-Path $ReleaseDir "StepOnIt-win-Setup.exe"
    if (-not (Test-Path $FullPkg1)) { throw "Missing $FullPkg1" }
    if (-not (Test-Path $SetupExe)) { throw "Missing $SetupExe" }
    Write-Host "PASS: v1.0.0 full package and Setup.exe generated"

    # 2. Build v1.0.1 incremental update (skipping asset mirror since assets are unchanged)
    powershell -ExecutionPolicy Bypass -File tools/publish_velopack.ps1 -Version "1.0.1" -SkipAssetMirror
    if ($LASTEXITCODE -ne 0) { throw "publish_velopack.ps1 v1.0.1 failed" }

    $DeltaPkg = Join-Path $ReleaseDir "StepOnIt-1.0.1-delta.nupkg"
    if (-not (Test-Path $DeltaPkg)) { throw "Missing $DeltaPkg" }
    $DeltaBytes = (Get-Item $DeltaPkg).Length
    $DeltaSizeMB = [math]::Round($DeltaBytes / 1MB, 3)
    Write-Host "Delta package size: $DeltaSizeMB MB ($DeltaBytes bytes)"
    if ($DeltaSizeMB -ge 5.0) {
        throw "Delta package too large ($DeltaSizeMB MB)"
    }
    Write-Host "PASS: v1.0.1 delta package generated ($DeltaSizeMB MB < 5.0 MB)"

    # 3. Verify packaged binary runs headlessly from an isolated working directory
    $TempCwd = Join-Path $env:TEMP "soi_vpk_test"
    New-Item -ItemType Directory -Force -Path $TempCwd | Out-Null
    Push-Location $TempCwd
    try {
        $LauncherExe = Join-Path $RootDir "build\win\StepOnItLauncher.exe"
        $env:SOI_UPDATE_URL = $ReleaseDir
        & $LauncherExe --headless --quit
        if ($LASTEXITCODE -ne 0) {
            throw "StepOnItLauncher.exe --headless --quit exited with $LASTEXITCODE"
        }
        Write-Host "PASS: Packaged StepOnItLauncher.exe + StepOnIt.exe ran cleanly from isolated directory"
    } finally {
        Pop-Location
        Remove-Item $TempCwd -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Host "=================================================================="
    Write-Host "VELOPACK LOCAL PACKAGING & DELTA TEST: PASS"
    Write-Host "=================================================================="
} finally {
    Pop-Location
}
