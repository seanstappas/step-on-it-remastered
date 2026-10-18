param(
    [Parameter(Mandatory=$true)][string]$Version,
    [string]$RepoUrl = "",
    [string]$ReleaseDir = "",
    [switch]$UploadToGitHub,
    [switch]$SkipAssetMirror
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$GodotConsole = "D:\SOI-tools\godot\Godot_v4.3-stable_win64_console.exe"
$GodotGui = "D:\SOI-tools\godot\Godot_v4.3-stable_win64.exe"
$Zig = "D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe"
$VpkRoot = "D:\SOI-tools\velopack"
$VpkLibcDir = "$VpkRoot\libc"
$VpkDll = "$VpkRoot\vpk\tools\net8.0\any\vpk.dll"
$BuildDir = "$Root\build\win"
if (-not $ReleaseDir) { $ReleaseDir = "$Root\releases" }

function Ensure-VelopackTools {
    if (-not (Test-Path "$VpkLibcDir\include\Velopack.h")) {
        Write-Host "=== Downloading Velopack C SDK (velopack_libc) ===" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path $VpkLibcDir | Out-Null
        & "$Root\.venv\Scripts\python.exe" -c "import urllib.request, zipfile; urllib.request.urlretrieve('https://github.com/velopack/velopack/releases/download/0.0.1053/velopack_libc-0.0.1053-win-x64.zip', r'$VpkRoot\libc.zip'); zipfile.ZipFile(r'$VpkRoot\libc.zip').extractall(r'$VpkLibcDir')"
    }
    if (-not (Test-Path $VpkDll)) {
        Write-Host "=== Downloading Velopack CLI (vpk) ===" -ForegroundColor Cyan
        New-Item -ItemType Directory -Force -Path "$VpkRoot\vpk" | Out-Null
        & "$Root\.venv\Scripts\python.exe" -c "import urllib.request, zipfile, json; urllib.request.urlretrieve('https://www.nuget.org/api/v2/package/vpk/0.0.1053', r'$VpkRoot\vpk.zip'); zipfile.ZipFile(r'$VpkRoot\vpk.zip').extractall(r'$VpkRoot\vpk'); p = r'$VpkRoot\vpk\tools\net8.0\any\vpk.runtimeconfig.json'; cfg = json.load(open(p)); cfg['runtimeOptions']['frameworks'] = [f for f in cfg['runtimeOptions']['frameworks'] if f['name'] == 'Microsoft.NETCore.App']; json.dump(cfg, open(p, 'w'), indent=2)"
    }
}

Ensure-VelopackTools

Write-Host "=== 1. Building GDExtension (soi_bridge.dll) ===" -ForegroundColor Cyan
powershell -ExecutionPolicy Bypass -File "$Root\bridge\build_zig.ps1"
if ($LASTEXITCODE -ne 0) { throw "GDExtension build failed" }

Write-Host "=== 2. Preparing Windows Build Staging ($BuildDir) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$BuildDir\bin" | Out-Null
New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

# Bundle Godot 4.3 GUI binary as StepOnIt.exe and export project pack as StepOnIt.pck
Copy-Item $GodotGui "$BuildDir\StepOnIt.exe" -Force
$prevEAP = $ErrorActionPreference
$ErrorActionPreference = "Continue"
& $GodotConsole --headless --path "$Root\godot_project" --export-pack "Windows Desktop" "$BuildDir\StepOnIt.pck"
$ErrorActionPreference = $prevEAP
if (-not (Test-Path "$BuildDir\StepOnIt.pck")) { throw "Failed to export StepOnIt.pck" }

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
& $Zig cc -O2 -I"$VpkLibcDir\include" "$Root\tools\launcher\launcher.c" -o "$BuildDir\StepOnItLauncher.exe"
if ($LASTEXITCODE -ne 0) { throw "StepOnItLauncher.exe build failed" }
Copy-Item "$VpkLibcDir\lib\velopack_libc_win_x64_msvc.dll" "$BuildDir\velopack_libc_win_x64_msvc.dll" -Force

if ($RepoUrl) {
    @{ repo_url = $RepoUrl } | ConvertTo-Json | Set-Content "$BuildDir\update_config.json" -Encoding UTF8
} elseif (-not (Test-Path "$BuildDir\update_config.json")) {
    @{ repo_url = "https://github.com/YOUR_GITHUB_USER/step-on-it-remastered" } | ConvertTo-Json | Set-Content "$BuildDir\update_config.json" -Encoding UTF8
}

Write-Host "=== 5. Packaging Velopack Release v$Version (Full + Delta) ===" -ForegroundColor Cyan
if ($UploadToGitHub -and $RepoUrl) {
    dotnet $VpkDll download github --repoUrl $RepoUrl -o $ReleaseDir
}
dotnet $VpkDll pack -u StepOnIt -v $Version -p $BuildDir -e StepOnItLauncher.exe -o $ReleaseDir
if ($LASTEXITCODE -ne 0) { throw "vpk pack failed" }

if ($UploadToGitHub -and $RepoUrl) {
    Write-Host "=== 6. Uploading Release v$Version to GitHub Releases ===" -ForegroundColor Cyan
    dotnet $VpkDll upload github --repoUrl $RepoUrl --publish --releaseName "Step On It! v$Version" -o $ReleaseDir
    if ($LASTEXITCODE -ne 0) { throw "vpk upload failed" }
}

Write-Host "=== Release v$Version Ready in $ReleaseDir ===" -ForegroundColor Green
