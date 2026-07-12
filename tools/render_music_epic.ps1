# render_music_epic.ps1 -- render the extracted QTMA MIDI (extracted/music/*.mid) to an
# EPIC/CINEMATIC soundtrack using FluidSynth + a premium SoundFont, then master with
# ffmpeg (silence-trim -> tone -> glue compression -> loudness-match -> limiter) to
# looping OGG Vorbis the Godot port plays (audio.gd loads <name>.ogg by base name).
#
# FIDELITY: the notes / timing / tempo / channel-program are FAITHFUL (straight from
# tools/qtma_to_midi.py's QTMA extraction). This path swaps the pure-numpy synth voice
# (tools/render_music.py) for real SoundFont instruments = a much richer timbre. The
# -Cinematic switch additionally drives a bigger hall + expects program-REMAPPED MIDIs
# (tools/midi_remap.py) for a re-orchestrated (less 1:1) variant.
#
# Requires: FluidSynth (fluidsynth.exe) + ffmpeg/ffprobe. A SoundFont (.sf2/.sf3).
# Usage:
#   powershell -ExecutionPolicy Bypass -File tools/render_music_epic.ps1 `
#       -SoundFont 'D:\SOI-tools\soundfonts\MuseScore_General.sf3' `
#       -InDir extracted/music -OutDir extracted/music/renders/muse_faithful
#   ... add -Cinematic (with remapped MIDIs) for the cinematic variant.
#   ... add -Only 6lilt to render a single track (for testing).
param(
    [Parameter(Mandatory = $true)][string]$SoundFont,
    [string]$InDir  = "extracted/music",
    [string]$OutDir = "extracted/music/renders/out",
    [switch]$Cinematic,
    [double]$Gain = 0.7,
    [double]$Lufs = -14.0,
    [double]$Ceiling = 0.75,   # linear pre-encode peak ceiling (~ -2.5 dBFS); leaves
                               # room for lossy OGG overshoot so decoded peak <= -1 dBFS
    [int]$Quality = 6,
    [string]$Only = ""
)
$ErrorActionPreference = "Stop"

function Find-Exe($name, $fallback) {
    $c = (Get-Command $name -ErrorAction SilentlyContinue).Source
    if ($c) { return $c }
    if (Test-Path $fallback) { return $fallback }
    throw "$name not found (also tried $fallback)"
}
$FS = Find-Exe "fluidsynth" "D:\SOI-tools\fluidsynth\x64\fluidsynth-v2.5.6-win10-x64-glib\bin\fluidsynth.exe"
$FF = Find-Exe "ffmpeg"     "D:\Program Files\Tools\ffmpeg.exe"
$FP = Find-Exe "ffprobe"    "D:\Program Files\Tools\ffprobe.exe"
if (-not (Test-Path $SoundFont)) { throw "SoundFont not found: $SoundFont" }

# Run a native exe capturing stdout+stderr as one string. Native tools (ffmpeg,
# fluidsynth) write progress to stderr; under $ErrorActionPreference='Stop' PS 5.1
# would treat that as a terminating error, so isolate it to 'Continue' here. We
# validate success by checking the output file instead of the exit code (ffmpeg's
# -f null measure pass can report non-zero on some builds).
function Invoke-Native([string]$Exe, [string[]]$NativeArgs) {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { return (& $Exe @NativeArgs 2>&1 | Out-String) }
    finally { $ErrorActionPreference = $prev }
}

# FluidSynth reverb/chorus: a bigger, lusher hall for the cinematic variant.
if ($Cinematic) {
    $rev = @("-o", "synth.reverb.room-size=0.95", "-o", "synth.reverb.damp=0.2",
             "-o", "synth.reverb.width=60", "-o", "synth.reverb.level=0.9",
             "-o", "synth.chorus.level=2.0")
    $tone = "bass=g=3:f=85,treble=g=2:f=9500"
} else {
    $rev = @("-o", "synth.reverb.room-size=0.8", "-o", "synth.reverb.damp=0.35",
             "-o", "synth.reverb.width=40", "-o", "synth.reverb.level=0.6",
             "-o", "synth.chorus.level=1.2")
    $tone = "bass=g=2:f=90,treble=g=1.5:f=9000"
}

# Pre-master: trim leading+trailing silence (clean loop, no dead air), gentle tone
# shaping, then glue bus compression (no makeup gain -- final level is set by the
# loudness-match stage below so the limiter is not slammed).
$trim = "silenceremove=start_periods=1:start_threshold=-50dB:start_silence=0.05," +
        "areverse,silenceremove=start_periods=1:start_threshold=-50dB:start_silence=0.05,areverse"
$pre  = "$trim,$tone,acompressor=threshold=-20dB:ratio=2.5:attack=15:release=200:makeup=1"

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
# Keep the big intermediate WAVs OFF C: (may be low on space) -- prefer D:\SOI-tools.
$tempRoot = if (Test-Path 'D:\SOI-tools') { 'D:\SOI-tools' } else { $env:TEMP }
$tmp = Join-Path $tempRoot ("soi_epic_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$failed = @()
try {
    $mids = Get-ChildItem (Join-Path $InDir "*.mid")
    if ($Only) { $mids = $mids | Where-Object { $_.BaseName -eq $Only } }
    foreach ($m in $mids) {
        $base  = $m.BaseName
        $raw   = Join-Path $tmp "$base.wav"
        $pmwav = Join-Path $tmp "$base.pm.wav"
      try {

        # 1) FluidSynth render (float WAV headroom, big polyphony, hall reverb).
        Invoke-Native $FS (@("-ni", "-F", $raw, "-r", "48000", "-O", "float", "-g", "$Gain",
                             "-o", "synth.polyphony=256") + $rev + @($SoundFont, $m.FullName)) | Out-Null
        if (-not (Test-Path $raw) -or (Get-Item $raw).Length -lt 1024) { throw "FluidSynth render failed for $base" }

        # 2) Pre-master (trim/tone/glue) to an intermediate WAV.
        Invoke-Native $FF @("-hide_banner", "-loglevel", "error", "-y", "-i", $raw, "-af", $pre, $pmwav) | Out-Null
        if (-not (Test-Path $pmwav) -or (Get-Item $pmwav).Length -lt 1024) { throw "pre-master failed for $base" }

        # 3) Loudness-match: measure integrated LUFS, then apply ONE linear gain to hit
        #    the target. Deterministic (no dynamic-mode surprises from loudnorm).
        $measRaw = Invoke-Native $FF @("-hide_banner", "-i", $pmwav, "-af",
                    "loudnorm=I=$($Lufs):TP=-1.5:print_format=json", "-f", "null", "NUL")
        $a = $measRaw.LastIndexOf('{'); $b = $measRaw.LastIndexOf('}')
        if ($a -lt 0 -or $b -le $a) { throw "loudnorm measure failed for $base" }
        $j = $measRaw.Substring($a, $b - $a + 1) | ConvertFrom-Json
        # NB: name must NOT collide with $Gain (PS is case-insensitive -> would clobber
        # the FluidSynth synth-gain param on the next loop iteration).
        $normGain = [math]::Round($Lufs - [double]$j.input_i, 2)

        # 4) Apply gain + hard limiter (ceiling below 0 dBFS so the lossy OGG decode
        #    stays <= -1 dBFS). alimiter defaults to level=true (auto-levels output
        #    back toward 0 dBFS) -- MUST set level=false or the ceiling is ignored.
        $ogg = Join-Path $OutDir "$base.ogg"
        Invoke-Native $FF @("-hide_banner", "-loglevel", "error", "-y", "-i", $pmwav, "-af",
                            "volume=$($normGain)dB,alimiter=limit=$($Ceiling):level=false", "-c:a", "libvorbis", "-q:a", "$Quality", $ogg) | Out-Null
        if (-not (Test-Path $ogg) -or (Get-Item $ogg).Length -lt 1024) { throw "encode failed for $base" }
        $dur = & $FP -v error -show_entries format=duration -of csv=p=0 $ogg
        Write-Host ("{0,-24} -> {1,6:N1}s  {2}" -f $base, [double]$dur, (Split-Path $OutDir -Leaf))
      }
      catch { Write-Warning $_.Exception.Message; $failed += $base }
      finally { Remove-Item $raw, $pmwav -Force -ErrorAction SilentlyContinue }
    }
} finally {
    Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
if ($failed.Count) { Write-Warning ("FAILED tracks: " + ($failed -join ', ')); exit 1 }
