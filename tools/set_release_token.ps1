param(
    [string]$Token = "",
    [switch]$FromClipboard,
    [switch]$Clear,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    throw "LOCALAPPDATA environment variable is not set."
}

$AppDir = Join-Path $env:LOCALAPPDATA "StepOnIt"
$TokenFile = Join-Path $AppDir "release_embed_token.txt"

if ($Clear) {
    if (Test-Path $TokenFile) {
        Remove-Item -Path $TokenFile -Force
        Write-Host "Removed release embed token at $TokenFile" -ForegroundColor Green
    } else {
        Write-Host "No release embed token present at $TokenFile" -ForegroundColor Yellow
    }
    exit 0
}

$raw = ""
if (-not [string]::IsNullOrWhiteSpace($Token)) {
    $raw = $Token
} elseif ($FromClipboard) {
    $clip = Get-Clipboard -Raw -ErrorAction SilentlyContinue
    if ($null -ne $clip) {
        $raw = [string]$clip
    }
} else {
    $sec = Read-Host -Prompt "Paste fine-grained read-only GitHub PAT (Contents: Read-only)" -AsSecureString
    $bstr = [IntPtr]::Zero
    try {
        $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
        $raw = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
    } finally {
        if ($bstr -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }
    }
}

$trimmed = if ($null -ne $raw) { $raw.Trim() } else { "" }
if ([string]::IsNullOrWhiteSpace($trimmed)) {
    throw "No token provided (empty after trimming whitespace)."
}
if ($trimmed -match '\s') {
    throw "Invalid token: contains internal whitespace or newline characters."
}

if (($trimmed -match '^(gho_|ghu_)') -and (-not $Force)) {
    throw "Refusing to store a broad OAuth/gh CLI token (gho_/ghu_) for installer embedding. Create a fine-grained read-only token (github_pat_..., Contents: Read-only) instead, or pass -Force to override."
}

New-Item -ItemType Directory -Force -Path $AppDir | Out-Null
[System.IO.File]::WriteAllText($TokenFile, $trimmed, [System.Text.UTF8Encoding]::new($false))

Write-Host ("Saved release embed token to {0} ({1} chars)." -f $TokenFile, $trimmed.Length) -ForegroundColor Green
