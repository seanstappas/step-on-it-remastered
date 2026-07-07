# render_music.ps1 -- render the extracted QTMA MIDI (extracted/music/*.mid) to
# looping OGG tracks the Godot port can play (audio.gd loads <name>.ogg by name).
#
# Pipeline: tools/render_music.py (pure-Python synth) -> 16-bit WAV, then ffmpeg
# -> OGG (libvorbis). If ffmpeg is unavailable the WAVs are kept (Godot can load
# either). FIDELITY: the notes/timing/tempo are FAITHFUL (from the QTMA extraction);
# the synth VOICE is an approximate mellow default -- for a closer match to the
# original Apple QTMA instruments, re-render the same MIDIs through fluidsynth with
# a General-MIDI soundfont and drop the resulting .ogg files in $OutDir.
#
# Usage:  powershell -ExecutionPolicy Bypass -File tools/render_music.ps1
param(
    [string]$InDir  = "extracted/music",
    [string]$OutDir = "extracted/music"
)
$ErrorActionPreference = "Stop"

$ff = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source
if (-not $ff) { $ff = "D:\Program Files\Tools\ffmpeg.exe" }

$tmp = Join-Path $env:TEMP ("soi_music_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
try {
    py tools/render_music.py $InDir $tmp
    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
    foreach ($w in Get-ChildItem "$tmp/*.wav") {
        if (Test-Path $ff) {
            $ogg = Join-Path $OutDir ($w.BaseName + ".ogg")
            & $ff -hide_banner -loglevel error -y -i $w.FullName -c:a libvorbis -q:a 4 $ogg
            Write-Host ("ogg  -> " + $ogg)
        } else {
            $dst = Join-Path $OutDir ($w.BaseName + ".wav")
            Copy-Item $w.FullName $dst -Force
            Write-Host ("ffmpeg missing; kept WAV -> " + $dst)
        }
    }
} finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
