$ErrorActionPreference = 'Stop'
$RootDir = Split-Path -Parent $PSScriptRoot
Push-Location $RootDir

$origUpdateUrl = $env:SOI_UPDATE_URL
$InstallDir = Join-Path $env:TEMP "soi_install_test"

try {
    Write-Host "=================================================================="
    Write-Host "Step On It! Remastered - Velopack Local Packaging and Update Test"
    Write-Host "=================================================================="

    $ReleaseDir = Join-Path $RootDir "releases"
    if (Test-Path $ReleaseDir) {
        Remove-Item "$ReleaseDir\*" -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

    # 1. Build v1.0.0 full release (mirroring assets if build/win/extracted is missing)
    $hasExtracted = Test-Path "$RootDir\build\win\extracted\levels"
    Write-Host "--- 1. Building v1.0.0 ---"
    if ($hasExtracted) {
        & "$RootDir\tools\publish_velopack.ps1" -Version "1.0.0" -SkipAssetMirror
    } else {
        & "$RootDir\tools\publish_velopack.ps1" -Version "1.0.0"
    }

    $FullPkg1 = Join-Path $ReleaseDir "StepOnIt-1.0.0-full.nupkg"
    $SetupExe = Join-Path $ReleaseDir "StepOnIt-win-Setup.exe"
    if (-not (Test-Path $FullPkg1)) { throw "Missing $FullPkg1" }
    if (-not (Test-Path $SetupExe)) { throw "Missing $SetupExe" }
    Write-Host "PASS: v1.0.0 full package and Setup.exe generated"

    # 2. Stamp a version file into pck and build v1.0.1 incremental update
    Write-Host "--- 2. Building v1.0.1 ---"
    $versionFile = Join-Path $RootDir "godot_project\version.txt"
    Set-Content -Path $versionFile -Value "1.0.1" -Encoding UTF8

    try {
        & "$RootDir\tools\publish_velopack.ps1" -Version "1.0.1" -SkipAssetMirror
    } finally {
        Remove-Item $versionFile -Force -ErrorAction SilentlyContinue
    }

    $FullPkg2 = Join-Path $ReleaseDir "StepOnIt-1.0.1-full.nupkg"
    $DeltaPkg = Join-Path $ReleaseDir "StepOnIt-1.0.1-delta.nupkg"
    if (-not (Test-Path $FullPkg2)) { throw "Missing $FullPkg2" }
    if (-not (Test-Path $DeltaPkg)) { throw "Missing $DeltaPkg" }

    # Assert packages differ and delta is under 5 MB
    $hash1 = (Get-FileHash $FullPkg1 -Algorithm SHA256).Hash
    $hash2 = (Get-FileHash $FullPkg2 -Algorithm SHA256).Hash
    if ($hash1 -eq $hash2) { throw "Full packages v1.0.0 and v1.0.1 have identical hashes!" }

    $DeltaBytes = (Get-Item $DeltaPkg).Length
    $DeltaSizeMB = [math]::Round($DeltaBytes / 1MB, 3)
    Write-Host "Delta package size: $DeltaSizeMB MB ($DeltaBytes bytes)"
    if ($DeltaSizeMB -ge 5.0) {
        throw "Delta package too large ($DeltaSizeMB MB >= 5.0 MB)"
    }
    Write-Host "PASS: v1.0.1 delta package generated ($DeltaSizeMB MB < 5.0 MB)"

    # 3. Install 1.0.0 silently from Setup.exe into temp directory
    Write-Host "--- 3. Installing v1.0.0 via Setup.exe ---"
    if (Test-Path $InstallDir) {
        Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

    $setupProc = Start-Process -FilePath $SetupExe -ArgumentList @("--silent", "--installto", $InstallDir) -Wait -PassThru
    if ($setupProc.ExitCode -ne 0) {
        throw "Setup.exe failed with exit code $($setupProc.ExitCode)"
    }

    $launcherCandidates = Get-ChildItem -Path $InstallDir -Filter "StepOnItLauncher.exe" -Recurse -ErrorAction SilentlyContinue
    if (-not $launcherCandidates) {
        throw "StepOnItLauncher.exe not found anywhere in $InstallDir after Setup"
    }
    $InstalledLauncher = $launcherCandidates[0].FullName
    Write-Host "Found installed launcher: $InstalledLauncher"
    Write-Host "PASS: v1.0.0 installed successfully"

    # 4. Run the installed launcher with SOI_UPDATE_URL=<releases> and wait for update to 1.0.1
    Write-Host "--- 4. Updating to v1.0.1 via Launcher ---"
    $env:SOI_UPDATE_URL = $ReleaseDir
    $updateProc = Start-Process -FilePath $InstalledLauncher -ArgumentList @("--headless", "--quit") -Wait -PassThru
    # Give a brief moment for Velopack update file renaming if needed
    Start-Sleep -Seconds 2

    # Assert version 1.0.1 is present in installation
    $has101 = [bool](Get-ChildItem -Path $InstallDir -Recurse | Where-Object { $_.FullName -match '1\.0\.1' })
    if (-not $has101) {
        Write-Host "Warning: 1.0.1 files check fell back to checking releases.win.json"
        $relJson = Get-ChildItem -Path $InstallDir -Filter "releases*.json" -Recurse | Select-Object -First 1
        if ($relJson -and ((Get-Content $relJson.FullName -Raw) -match '1\.0\.1')) {
            $has101 = $true
        }
    }
    if (-not $has101) {
        throw "Installation at $InstallDir was not updated to 1.0.1"
    }
    Write-Host "PASS: Installed app successfully updated to v1.0.1"

    # 5. Run installed launcher on smoke_test.tscn and verify PASS
    Write-Host "--- 5. Running Smoke Test on Updated Installation ---"
    $smokeOut = Join-Path $env:TEMP "soi_smoke_stdout.log"
    $smokeErr = Join-Path $env:TEMP "soi_smoke_stderr.log"
    Remove-Item $smokeOut, $smokeErr -ErrorAction SilentlyContinue

    # Re-discover launcher in case path changed (e.g. app-1.0.1 folder)
    $installedNow = (Get-ChildItem -Path $InstallDir -Filter "StepOnItLauncher.exe" -Recurse | Select-Object -First 1).FullName
    $smokeProc = Start-Process -FilePath $installedNow -ArgumentList @("res://scenes/smoke_test.tscn", "--headless", "--quit-after", "600") -RedirectStandardOutput $smokeOut -RedirectStandardError $smokeErr -Wait -PassThru
    $outText = if (Test-Path $smokeOut) { Get-Content $smokeOut -Raw } else { "" }
    $errText = if (Test-Path $smokeErr) { Get-Content $smokeErr -Raw } else { "" }

    if ($outText -notmatch "SMOKE TEST: PASS" -and $errText -notmatch "SMOKE TEST: PASS") {
        # Check launcher.log as well
        $launcherLog = Join-Path $env:LOCALAPPDATA "StepOnIt\launcher.log"
        if (Test-Path $launcherLog) {
            Write-Host "=== launcher.log ==="
            Get-Content $launcherLog -Tail 20 | ForEach-Object { Write-Host "   $_" }
        }
        Write-Host "=== stdout ==="; Write-Host $outText
        Write-Host "=== stderr ==="; Write-Host $errText
        throw "Smoke test failed to report SMOKE TEST: PASS"
    }

    Write-Host "PASS: Smoke test passed on packaged, updated build"
    Write-Host "=================================================================="
    Write-Host "VELOPACK LOCAL PACKAGING & DELTA TEST: ALL PASS"
    Write-Host "=================================================================="
} finally {
    $env:SOI_UPDATE_URL = $origUpdateUrl
    if (Test-Path $InstallDir) {
        Remove-Item $InstallDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    Pop-Location
}
