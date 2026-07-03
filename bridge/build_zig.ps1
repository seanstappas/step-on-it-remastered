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

# 1. Compile the C core into objects (C, not C++).
New-Item -ItemType Directory -Force -Path obj | Out-Null
foreach ($f in Get-ChildItem core/src/*.c) {
    & $Zig cc -std=c17 -O1 -fPIC -Icore/include -c $f.FullName -o "obj/$($f.BaseName).o"
    if ($LASTEXITCODE -ne 0) { throw "core compile failed: $($f.Name)" }
}

# 2. Compile godot-cpp + generated bindings + the wrapper (C++17), link the core.
$args = @('-shared','-std=c++17','-O1','-fPIC',
          "-I$gcpp/include","-I$gcpp/gen/include","-I$gcpp/gdextension",
          '-Icore/include','-Ibridge/src','-o','soi_bridge.dll')
$args += (Get-ChildItem "$gcpp/src" -Recurse -Filter *.cpp | ForEach-Object FullName)
$args += (Get-ChildItem "$gcpp/gen/src" -Recurse -Filter *.cpp | ForEach-Object FullName)
$args += (Get-ChildItem 'bridge/src' -Filter *.cpp | ForEach-Object FullName)
$args += (Get-ChildItem 'obj/*.o' | ForEach-Object FullName)
Set-Content build.rsp ($args -join "`n")
& $Zig c++ '@build.rsp'
if ($LASTEXITCODE -ne 0) { throw 'bridge link failed' }

# 3. Deploy to the Godot project (names must match godot_project/soi.gdextension).
New-Item -ItemType Directory -Force -Path godot_project/bin | Out-Null
Copy-Item soi_bridge.dll 'godot_project/bin/soi_bridge.windows.template_debug.x86_64.dll' -Force
Copy-Item soi_bridge.dll 'godot_project/bin/soi_bridge.windows.template_release.x86_64.dll' -Force
Remove-Item soi_bridge.dll,soi_bridge.pdb,soi_bridge.lib,build.rsp -ErrorAction SilentlyContinue
Remove-Item obj -Recurse -Force -ErrorAction SilentlyContinue
Write-Host 'GDExtension built -> godot_project/bin/'
