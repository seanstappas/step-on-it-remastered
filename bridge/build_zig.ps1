# build_zig.ps1 — build the SoiCore GDExtension with the portable Zig toolchain.
#
# Fallback build path used when no MSVC/Clang/CMake/SCons is installed (only Zig).
# The canonical builds are CMakeLists.txt and SConstruct; this reproduces what
# they do using `zig cc` / `zig c++`.
#
# Prereqs (one-time):
#   git clone --depth 1 -b 4.3 https://github.com/godotengine/godot-cpp bridge/godot-cpp
#   Push-Location bridge/godot-cpp
#   py -c "import binding_generator as b; b.generate_bindings('gdextension/extension_api.json', False, '64', 'single', '.')"
#   Pop-Location
#
# Run from the repo root:  pwsh bridge/build_zig.ps1
param(
    [string]$Zig = 'D:\SOI-tools\zig\zig-windows-x86_64-0.13.0\zig.exe'
)
$ErrorActionPreference = 'Stop'
$gcpp = 'bridge/godot-cpp'

$tmpDir = Join-Path $env:TEMP "soi_bridge_build_$PID"
$objDir = Join-Path $tmpDir 'obj'
New-Item -ItemType Directory -Force -Path $objDir | Out-Null

function Invoke-Zig([string[]]$ZigArgs, [string]$Label) {
    $code = 1
    $out = @()
    for ($attempt = 1; $attempt -le 5; $attempt++) {
        $prevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        try {
            $out = & $Zig @ZigArgs 2>&1
            $code = $LASTEXITCODE
        } finally {
            $ErrorActionPreference = $prevEap
        }
        if ($code -eq 0) {
            if ($out) { $out | ForEach-Object { Write-Host $_ } }
            return
        }
        if ($attempt -lt 5) {
            Start-Sleep -Milliseconds (300 * $attempt)
        }
    }
    $out | ForEach-Object { Write-Host $_ }
    throw "$Label (exit $code)"
}

try {
    # 1. Compile the C core into objects (C, not C++), enforcing strict warnings.
    foreach ($f in Get-ChildItem core/src/*.c) {
        $obj = Join-Path $objDir "$($f.BaseName).o"
        Invoke-Zig @('cc','-std=c17','-O2','-Wall','-Wextra','-Wshadow','-Wconversion','-Werror','-fPIC','-Icore/include','-c',$f.FullName,'-o',$obj) "core compile failed: $($f.Name)"
    }

    # 2. Compile bridge C++ wrapper sources strictly (-Wall -Wextra -Werror).
    $gitSha = try { (git rev-parse --short=8 HEAD).Trim() } catch { "0" }
    $buildId = try { [Convert]::ToInt64($gitSha, 16) } catch { 0 }
    $buildMacro = "-DSOI_BUILD_ID=0x$($buildId.ToString('X'))"

    foreach ($f in Get-ChildItem bridge/src/*.cpp) {
        $obj = Join-Path $objDir "bridge_$($f.BaseName).o"
        Invoke-Zig @('c++','-std=c++17','-O2','-g','-Wall','-Wextra','-Werror','-fPIC',
                     '-isystem',"$gcpp/include",'-isystem',"$gcpp/gen/include",'-isystem',"$gcpp/gdextension",
                     '-Icore/include','-Ibridge/src',$buildMacro,'-c',$f.FullName,'-o',$obj) "bridge compile failed: $($f.Name)"
    }

    # 3. Compile godot-cpp + generated bindings and link with core + bridge objects.
    # Use >=45-char template filenames so Godot's in-place PE RSDS rewrite never shortens to '~soi_b_...'.
    $dllOut = Join-Path $tmpDir 'soi_bridge.windows.template_release.x86_64.dll'
    $pdbOut = Join-Path $tmpDir 'soi_bridge.windows.template_release.x86_64.pdb'
    $rspOut = Join-Path $tmpDir 'build.rsp'

    $args = @('-shared','-std=c++17','-O2','-g','-fPIC',
              "-I$gcpp/include","-I$gcpp/gen/include","-I$gcpp/gdextension",
              '-Icore/include','-Ibridge/src',$buildMacro,'-o',$dllOut)
    $args += (Get-ChildItem "$gcpp/src" -Recurse -Filter *.cpp | ForEach-Object FullName)
    $args += (Get-ChildItem "$gcpp/gen/src" -Recurse -Filter *.cpp | ForEach-Object FullName)
    $args += (Get-ChildItem $objDir -Filter *.o | ForEach-Object FullName)
    Set-Content $rspOut ($args -join "`n")
    Invoke-Zig @('c++',"@$rspOut") 'bridge link failed'

    # 4. Deploy DLLs + PDBs to the Godot project (names must match godot_project/soi.gdextension).
    New-Item -ItemType Directory -Force -Path godot_project/bin | Out-Null
    Remove-Item 'godot_project/bin/~soi_b_*.pdb' -Force -ErrorAction SilentlyContinue
    Copy-Item $dllOut 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.dll' -Force
    Copy-Item $dllOut 'godot_project/bin/soi_bridge.windows.template_release.x86_64.dll' -Force
    if (-not (Test-Path $pdbOut)) {
        throw "Expected PDB was not emitted at $pdbOut"
    }
    Copy-Item $pdbOut 'godot_project/bin/soi_bridge.pdb' -Force
    Copy-Item $pdbOut 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.pdb' -Force
    Copy-Item $pdbOut 'godot_project/bin/soi_bridge.windows.template_release.x86_64.pdb' -Force
    Write-Host 'GDExtension built -> godot_project/bin/ (DLL + PDB)'
} finally {
    Remove-Item $tmpDir -Recurse -Force -ErrorAction SilentlyContinue
}
