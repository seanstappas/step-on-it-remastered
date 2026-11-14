param(
    [Parameter(Mandatory=$true)][string]$Version,
    [string]$RepoUrl = "https://github.com/seanstappas/step-on-it-remastered",
    [string]$ReleaseDir = "",
    [switch]$UploadToGitHub,
    [switch]$SkipAssetMirror
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$GodotConsole = "D:\SOI-tools\godot\Godot_v4.3-stable_win64_console.exe"
$Zig = "D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe"
$VpkRoot = "D:\SOI-tools\velopack"
$VpkLibcDir = "$VpkRoot\libc"
$VpkDll = "$VpkRoot\vpk\tools\net8.0\any\vpk.dll"
$BuildDir = "$Root\build\win"
if (-not $ReleaseDir) { $ReleaseDir = "$Root\releases" }

$Py = if (Test-Path "$Root\.venv\Scripts\python.exe") { "$Root\.venv\Scripts\python.exe" } else { "py" }

if ([string]::IsNullOrWhiteSpace($RepoUrl) -or $RepoUrl -match "YOUR_GITHUB_USER") {
    throw "-RepoUrl must be a valid repository URL (not empty or a placeholder)."
}

function Invoke-GhCapture {
    param([string[]]$Arguments)
    $prevEap = $ErrorActionPreference
    $prevNoUpdate = $env:GH_NO_UPDATE_NOTIFIER
    try {
        $ErrorActionPreference = "Continue"
        $env:GH_NO_UPDATE_NOTIFIER = "1"
        $out = & gh @Arguments 2>$null
        return [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output   = if ($null -ne $out) { ($out -join "`n").Trim() } else { "" }
        }
    } finally {
        $ErrorActionPreference = $prevEap
        if ($null -eq $prevNoUpdate) {
            Remove-Item Env:GH_NO_UPDATE_NOTIFIER -ErrorAction SilentlyContinue
        } else {
            $env:GH_NO_UPDATE_NOTIFIER = $prevNoUpdate
        }
    }
}

$GitHubToken = $env:GITHUB_TOKEN
if ($UploadToGitHub) {
    if ([string]::IsNullOrWhiteSpace($GitHubToken)) {
        $ghCmd = Get-Command gh -ErrorAction SilentlyContinue
        if ($ghCmd) {
            $ghRes = Invoke-GhCapture -Arguments @("auth", "token")
            if ($ghRes.ExitCode -eq 0 -and -not [string]::IsNullOrWhiteSpace($ghRes.Output)) {
                $GitHubToken = $ghRes.Output
            }
        }
    }
    if ([string]::IsNullOrWhiteSpace($GitHubToken)) {
        throw 'GITHUB_TOKEN environment variable is empty and "gh auth token" fallback failed. Set $env:GITHUB_TOKEN or run "gh auth login".'
    }
}

function Ensure-VelopackTools {
    $expectedLibcHash = "613D57DE5BCF043C9BBDBF175B3261E93D3D3A7DA00E19AF6AD633F712613222"
    $expectedVpkHash  = "D4257FF37A597C8DCD8EB4458029F68609166A8B48990CFADC785D6252AD04C5"

    if (-not (Test-Path "$VpkLibcDir\include\Velopack.h")) {
        Write-Host "=== Downloading Velopack C SDK (velopack_libc) ===" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $VpkLibcDir | Out-Null
        $libcZip = "$VpkRoot\libc.zip"
        & $Py -c "import urllib.request; urllib.request.urlretrieve('https://github.com/velopack/velopack/releases/download/0.0.1053/velopack_libc_0.0.1053.zip', r'$libcZip')"
        $actualHash = (Get-FileHash $libcZip -Algorithm SHA256).Hash
        if ($actualHash -ne $expectedLibcHash) {
            throw "velopack_libc SHA256 hash mismatch! Got $actualHash, expected $expectedLibcHash"
        }
        & $Py -c "import zipfile; zipfile.ZipFile(r'$libcZip').extractall(r'$VpkLibcDir')"
    }
    if (-not (Test-Path $VpkDll)) {
        Write-Host "=== Downloading Velopack CLI (vpk) ===" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path "$VpkRoot\vpk" | Out-Null
        $vpkZip = "$VpkRoot\vpk.zip"
        & $Py -c "import urllib.request; urllib.request.urlretrieve('https://www.nuget.org/api/v2/package/vpk/0.0.1053', r'$vpkZip')"
        $actualHash = (Get-FileHash $vpkZip -Algorithm SHA256).Hash
        if ($actualHash -ne $expectedVpkHash) {
            throw "vpk CLI SHA256 hash mismatch! Got $actualHash, expected $expectedVpkHash"
        }
        & $Py -c "import zipfile, json; zipfile.ZipFile(r'$vpkZip').extractall(r'$VpkRoot\vpk'); p = r'$VpkRoot\vpk\tools\net8.0\any\vpk.runtimeconfig.json'; cfg = json.load(open(p)); cfg['runtimeOptions']['frameworks'] = [f for f in cfg['runtimeOptions']['frameworks'] if f['name'] == 'Microsoft.NETCore.App']; json.dump(cfg, open(p, 'w'), indent=2)"
    }
}

Ensure-VelopackTools

Write-Host "=== 1. Building GDExtension (soi_bridge.dll) ===" -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File "$Root\bridge\build_zig.ps1"
if ($LASTEXITCODE -ne 0) { throw "GDExtension build failed" }

Write-Host "=== 2. Preparing Windows Build Staging ($BuildDir) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$BuildDir\bin" | Out-Null
New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

# Delete build/win/StepOnIt.pck and StepOnIt.exe before exporting
Remove-Item "$BuildDir\StepOnIt.pck", "$BuildDir\StepOnIt.exe" -Force -ErrorAction SilentlyContinue

# Export release using official template
& $GodotConsole --headless --path "$Root\godot_project" --export-release "Windows Desktop" "$BuildDir\StepOnIt.exe"
if ($LASTEXITCODE -ne 0) { throw "Godot export-release failed with exit code $LASTEXITCODE" }
if (-not (Test-Path "$BuildDir\StepOnIt.pck")) { throw "Missing $BuildDir\StepOnIt.pck after export" }
if (-not (Test-Path "$BuildDir\StepOnIt.exe")) { throw "Missing $BuildDir\StepOnIt.exe after export" }

Copy-Item "$Root\godot_project\bin\*.dll" "$BuildDir\bin\" -Force
Copy-Item "$Root\godot_project\bin\*.dll" "$BuildDir\" -Force

if (-not $SkipAssetMirror -or -not (Test-Path "$BuildDir\extracted\levels")) {
    Write-Host "=== 3. Mirroring Runtime Extracted Assets (~205 MB) ===" -ForegroundColor Cyan
    # Exclude offline render/intermediate folders (~620 MB) to keep installer compact
    $ExcludeDirs = @("renders", "first_pass", "pass2", "pass3_numpy", "sprites_uhd", "sprites_3d", "sprites_hd_test", "_qa")
    $null = robocopy "$Root\extracted" "$BuildDir\extracted" /MIR /XD $ExcludeDirs /NFL /NDL /NJH /NJS /NP
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }
} else {
    Write-Host "=== 3. Skipping Asset Mirror (-SkipAssetMirror) ===" -ForegroundColor Cyan
}

Write-Host "=== 4. Building Native StepOnItLauncher.exe ===" -ForegroundColor Cyan
& $Zig cc -O2 '-Wl,--subsystem,windows' -I"$VpkLibcDir\include" "$Root\tools\launcher\launcher.c" -o "$BuildDir\StepOnItLauncher.exe"
if ($LASTEXITCODE -ne 0) { throw "StepOnItLauncher.exe build failed with exit code $LASTEXITCODE" }
Copy-Item "$VpkLibcDir\lib\velopack_libc_win_x64_msvc.dll" "$BuildDir\velopack_libc_win_x64_msvc.dll" -Force

$cfgJson = (@{ repo_url = $RepoUrl } | ConvertTo-Json) + "`n"
[System.IO.File]::WriteAllText("$BuildDir\update_config.json", $cfgJson, [System.Text.UTF8Encoding]::new($false))

Write-Host "=== 5. Packaging Velopack Release v$Version (Full + Delta) ===" -ForegroundColor Cyan
if ($UploadToGitHub) {
    $hasExistingReleases = $true
    $ghCmd = Get-Command gh -ErrorAction SilentlyContinue
    $cleanRepoUrl = ($RepoUrl.TrimEnd('/')) -replace '\.git$', ''
    if ($ghCmd -and $cleanRepoUrl -match 'github\.com[:/]([^/]+/[^/]+)$') {
        $slug = $Matches[1]
        $prevGhToken = $env:GH_TOKEN
        try {
            $env:GH_TOKEN = $GitHubToken
            $ghRes = Invoke-GhCapture -Arguments @("release", "list", "--repo", $slug, "--limit", "1")
            if ($ghRes.ExitCode -eq 0 -and [string]::IsNullOrWhiteSpace($ghRes.Output)) {
                $hasExistingReleases = $false
            }
        } finally {
            if ($null -eq $prevGhToken) {
                Remove-Item Env:GH_TOKEN -ErrorAction SilentlyContinue
            } else {
                $env:GH_TOKEN = $prevGhToken
            }
        }
    }
    if ($hasExistingReleases) {
        dotnet $VpkDll download github --repoUrl $RepoUrl --token $GitHubToken -o $ReleaseDir
        if ($LASTEXITCODE -ne 0) { throw "vpk download github failed with exit code $LASTEXITCODE" }
    } else {
        Write-Host "No existing GitHub releases found for $slug; skipping prior package download (first publish)." -ForegroundColor Yellow
    }
}
dotnet $VpkDll pack -u StepOnIt -v $Version -p $BuildDir -e StepOnItLauncher.exe -o $ReleaseDir
if ($LASTEXITCODE -ne 0) { throw "vpk pack failed" }

if ($UploadToGitHub -and $RepoUrl) {
    Write-Host "=== 6. Uploading Release v$Version to GitHub Releases ===" -ForegroundColor Cyan
    dotnet $VpkDll upload github --repoUrl $RepoUrl --token $GitHubToken --publish --releaseName "Step On It! v$Version" -o $ReleaseDir
    if ($LASTEXITCODE -ne 0) { throw "vpk upload failed" }
}

Write-Host "=== Release v$Version Ready in $ReleaseDir ===" -ForegroundColor Green
