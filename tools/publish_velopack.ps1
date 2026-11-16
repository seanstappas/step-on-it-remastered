param(
    [Parameter(Mandatory=$true)][string]$Version,
    [string]$RepoUrl = "https://github.com/seanstappas/step-on-it-remastered",
    [string]$ReleaseDir = "",
    [string]$EmbedUpdateToken = "",
    [switch]$AllowNoEmbedToken,
    [switch]$AllowBroadEmbedToken,
    [switch]$NoEmbedToken,
    [switch]$UploadToGitHub,
    [switch]$SkipAssetMirror,
    [switch]$SkipBridgeBuild
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

if ($Version -notmatch '^(\d+)\.(\d+)\.(\d+)(?:[-+].*)?$') {
    throw "Invalid -Version '$Version'. Expected semantic version MAJOR.MINOR.PATCH (e.g. 1.1.3)."
}
$VerMajor = [int]$Matches[1]
$VerMinor = [int]$Matches[2]
$VerPatch = [int]$Matches[3]

function Invoke-NativeChecked {
    param(
        [string]$Exe,
        [string[]]$Arguments,
        [string]$Label,
        [int]$MaxOkExit = 0
    )
    $prevEap = $ErrorActionPreference
    try {
        $ErrorActionPreference = "Continue"
        & $Exe @Arguments
        $rc = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $prevEap
    }
    if ($null -eq $rc -or $rc -lt 0 -or $rc -gt $MaxOkExit) {
        throw "$Label failed with exit code $rc"
    }
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

$ResolvedEmbedToken = ""
if (-not $NoEmbedToken) {
    if (-not [string]::IsNullOrWhiteSpace($EmbedUpdateToken)) {
        $ResolvedEmbedToken = $EmbedUpdateToken.Trim()
    } elseif (-not [string]::IsNullOrWhiteSpace($env:SOI_EMBED_UPDATE_TOKEN)) {
        $ResolvedEmbedToken = $env:SOI_EMBED_UPDATE_TOKEN.Trim()
    } elseif (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $embedTokenFile = Join-Path (Join-Path $env:LOCALAPPDATA "StepOnIt") "release_embed_token.txt"
        if (Test-Path $embedTokenFile) {
            $fileRaw = [System.IO.File]::ReadAllText($embedTokenFile, [System.Text.Encoding]::UTF8)
            if ($null -ne $fileRaw) {
                $ResolvedEmbedToken = $fileRaw.Trim([char]0xFEFF, ' ', "`t", "`r", "`n")
            }
        }
    }

    if (-not [string]::IsNullOrWhiteSpace($ResolvedEmbedToken)) {
        if ($ResolvedEmbedToken -match '\s') {
            throw "Resolved embed update token contains internal whitespace or newline characters."
        }
        if (($ResolvedEmbedToken -match '^(gho_|ghu_)') -and (-not $AllowBroadEmbedToken)) {
            throw "Refusing to embed a broad OAuth/gh CLI token (gho_/ghu_) into a distributable installer. Create a fine-grained read-only token (github_pat_..., Contents: Read-only) and save it with tools/set_release_token.ps1, or pass -AllowBroadEmbedToken."
        }
    } elseif ($UploadToGitHub -and (-not $AllowNoEmbedToken)) {
        throw "No read-only update token found to embed into StepOnItLauncher.exe. Save one first with: powershell -ExecutionPolicy Bypass -File tools/set_release_token.ps1 -FromClipboard (or pass -AllowNoEmbedToken)."
    }
} elseif ($UploadToGitHub -and (-not $AllowNoEmbedToken)) {
    throw "-NoEmbedToken cannot be combined with -UploadToGitHub unless -AllowNoEmbedToken is also passed."
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

$hasBridgeDll = Test-Path "$Root\godot_project\bin\soi_bridge.windows.template_release.x86_64.dll"
$hasBridgePdb = Test-Path "$Root\godot_project\bin\soi_bridge.pdb"
if ($SkipBridgeBuild -and $hasBridgeDll -and $hasBridgePdb) {
    Write-Host "=== 1. Skipping GDExtension Build (-SkipBridgeBuild) ===" -ForegroundColor Cyan
} else {
    Write-Host "=== 1. Building GDExtension (soi_bridge.dll) ===" -ForegroundColor Cyan
    Invoke-NativeChecked -Exe "powershell" -Arguments @("-ExecutionPolicy", "Bypass", "-File", "$Root\bridge\build_zig.ps1") -Label "GDExtension build"
}

Write-Host "=== 2. Preparing Windows Build Staging ($BuildDir) ===" -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path "$BuildDir\bin" | Out-Null
New-Item -ItemType Directory -Force -Path $ReleaseDir | Out-Null

# Delete build/win/StepOnIt.pck and StepOnIt.exe before exporting
Remove-Item "$BuildDir\StepOnIt.pck", "$BuildDir\StepOnIt.exe" -Force -ErrorAction SilentlyContinue

# Export release using official template
Invoke-NativeChecked -Exe $GodotConsole -Arguments @("--headless", "--path", "$Root\godot_project", "--export-release", "Windows Desktop", "$BuildDir\StepOnIt.exe") -Label "Godot export-release"
if (-not (Test-Path "$BuildDir\StepOnIt.pck")) { throw "Missing $BuildDir\StepOnIt.pck after export" }
if (-not (Test-Path "$BuildDir\StepOnIt.exe")) { throw "Missing $BuildDir\StepOnIt.exe after export" }

Copy-Item "$Root\godot_project\bin\*.dll" "$BuildDir\bin\" -Force
Copy-Item "$Root\godot_project\bin\*.dll" "$BuildDir\" -Force

if (-not $SkipAssetMirror -or -not (Test-Path "$BuildDir\extracted\levels")) {
    Write-Host "=== 3. Mirroring Runtime Extracted Assets (~168 MB) ===" -ForegroundColor Cyan
    # Exclude offline render/intermediate folders and duplicate pict_hd (superseded by pict_hd_v2)
    $ExcludeDirs = @("renders", "first_pass", "pass2", "pass3_numpy", "sprites_uhd", "sprites_3d", "sprites_hd_test", "_qa")
    if (Test-Path "$Root\extracted\pict_hd_v2") {
        $ExcludeDirs += "pict_hd"
    }
    $robocopyArgs = @("$Root\extracted", "$BuildDir\extracted", "/MIR", "/XD") + $ExcludeDirs + @("/NFL", "/NDL", "/NJH", "/NJS", "/NP")
    $null = Invoke-NativeChecked -Exe "robocopy" -Arguments $robocopyArgs -Label "robocopy asset mirror" -MaxOkExit 7
} else {
    Write-Host "=== 3. Skipping Asset Mirror (-SkipAssetMirror) ===" -ForegroundColor Cyan
}
if ((Test-Path "$Root\extracted\pict_hd_v2") -and (Test-Path "$BuildDir\extracted\pict_hd")) {
    Remove-Item "$BuildDir\extracted\pict_hd" -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "=== 4. Building Native StepOnItLauncher.exe ===" -ForegroundColor Cyan
$iconPath = "$Root\tools\launcher\app_icon.ico"
if (-not (Test-Path $iconPath)) {
    Write-Host "Generating missing app icon via tools/build_icon.py..." -ForegroundColor Yellow
    Invoke-NativeChecked -Exe $Py -Arguments @("$Root\tools\build_icon.py") -Label "build_icon.py"
    if (-not (Test-Path $iconPath)) {
        throw "Failed to generate $iconPath"
    }
}

$embedHeaderPath = "$BuildDir\soi_embedded_token.h"
$launcherResPath = "$BuildDir\launcher.res"
Remove-Item $embedHeaderPath, $launcherResPath -Force -ErrorAction SilentlyContinue
try {
    $verStrMacro = '/DSOI_VER_STR=\"' + $Version + '\"'
    Invoke-NativeChecked -Exe $Zig -Arguments @("rc", "/DSOI_VER_MAJOR=$VerMajor", "/DSOI_VER_MINOR=$VerMinor", "/DSOI_VER_PATCH=$VerPatch", $verStrMacro, "/fo", $launcherResPath, "$Root\tools\launcher\launcher.rc") -Label "launcher.rc compilation"
    if (-not (Test-Path $launcherResPath)) {
        throw "launcher.rc compilation did not produce $launcherResPath"
    }

    if (-not [string]::IsNullOrWhiteSpace($ResolvedEmbedToken)) {
        $tokBytes = [System.Text.Encoding]::UTF8.GetBytes($ResolvedEmbedToken)
        if ($tokBytes.Length -eq 0 -or $tokBytes.Length -ge 1024) {
            throw "Embedded update token byte length ($($tokBytes.Length)) is out of supported range (1..1023)."
        }

        $xorKey = New-Object byte[] 32
        $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
        try {
            $rng.GetBytes($xorKey)
        } finally {
            $rng.Dispose()
        }

        $cipherBytes = New-Object byte[] $tokBytes.Length
        for ($i = 0; $i -lt $tokBytes.Length; $i++) {
            $cipherBytes[$i] = [byte]($tokBytes[$i] -bxor $xorKey[$i % $xorKey.Length])
        }

        $keyHex = ($xorKey | ForEach-Object { "0x{0:X2}" -f $_ }) -join ", "
        $cipherHex = ($cipherBytes | ForEach-Object { "0x{0:X2}" -f $_ }) -join ", "
        $headerContent = @"
#ifndef SOI_EMBEDDED_TOKEN_H
#define SOI_EMBEDDED_TOKEN_H
#define SOI_EMBEDDED_TOKEN_LEN $($tokBytes.Length)u
static const unsigned char SOI_EMBEDDED_TOKEN_XOR_KEY[32] = { $keyHex };
static const unsigned char SOI_EMBEDDED_TOKEN_CIPHER[$($tokBytes.Length)] = { $cipherHex };
#endif
"@ + "`n"
        [System.IO.File]::WriteAllText($embedHeaderPath, $headerContent, [System.Text.UTF8Encoding]::new($false))

        Invoke-NativeChecked -Exe $Zig -Arguments @("cc", "-O2", "-Wall", "-Wextra", "-Wl,--subsystem,windows", "-DSOI_HAS_EMBEDDED_TOKEN_HEADER=1", "-I$BuildDir", "-I$VpkLibcDir\include", "$Root\tools\launcher\launcher.c", $launcherResPath, "-o", "$BuildDir\StepOnItLauncher.exe") -Label "StepOnItLauncher.exe build"
        Write-Host ("Embedded XOR-masked update token into StepOnItLauncher.exe (token: present, {0} bytes)." -f $tokBytes.Length) -ForegroundColor Green
    } else {
        Invoke-NativeChecked -Exe $Zig -Arguments @("cc", "-O2", "-Wall", "-Wextra", "-Wl,--subsystem,windows", "-I$VpkLibcDir\include", "$Root\tools\launcher\launcher.c", $launcherResPath, "-o", "$BuildDir\StepOnItLauncher.exe") -Label "StepOnItLauncher.exe build"
    }
} finally {
    Remove-Item $embedHeaderPath, $launcherResPath -Force -ErrorAction SilentlyContinue
}
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
        Invoke-NativeChecked -Exe "dotnet" -Arguments @($VpkDll, "download", "github", "--repoUrl", $RepoUrl, "--token", $GitHubToken, "-o", $ReleaseDir) -Label "vpk download github"
    } else {
        Write-Host "No existing GitHub releases found for $slug; skipping prior package download (first publish)." -ForegroundColor Yellow
    }
}
$packArgs = @($VpkDll, "pack", "-u", "StepOnIt", "-v", $Version, "-p", $BuildDir, "-e", "StepOnItLauncher.exe", "-o", $ReleaseDir, "--packTitle", "Step On It! Remastered", "--icon", $iconPath, "--verbose")
try {
    Invoke-NativeChecked -Exe "dotnet" -Arguments $packArgs -Label "vpk pack"
} catch {
    Write-Host "vpk pack failed on first attempt ($($_.Exception.Message)); retrying once after 1s..." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
    Invoke-NativeChecked -Exe "dotnet" -Arguments $packArgs -Label "vpk pack"
}

if ($UploadToGitHub -and $RepoUrl) {
    Write-Host "=== 6. Uploading Release v$Version to GitHub Releases ===" -ForegroundColor Cyan
    Invoke-NativeChecked -Exe "dotnet" -Arguments @($VpkDll, "upload", "github", "--repoUrl", $RepoUrl, "--token", $GitHubToken, "--publish", "--releaseName", "Step On It! v$Version", "-o", $ReleaseDir) -Label "vpk upload"
}

Write-Host "=== Release v$Version Ready in $ReleaseDir ===" -ForegroundColor Green
