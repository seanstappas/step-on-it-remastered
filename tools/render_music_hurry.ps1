# render_music_hurry.ps1 -- build the "hurry up" (low-bonus) tempo-only music variants.
#
# RE finding (analysis/decomp): when a player's Bonus timer ticks PAST 1000 the original
# calls FUN_10018b24, which plays the "hurry up" sound (evt 0x2d) AND speeds the looping
# background QuickTime-Music movie via SetMovieRate(movie, 0x14000). Movie rate is a 16.16
# fixed-point value, so 0x14000 / 0x10000 = 1.25x. It drops back to 0x10000 (1.0x) via
# FUN_10018ac4 when a time award lifts the last hurrying player back above 1000, and each
# new board restarts the movie at 1.0x (FUN_1001882c). See docs/original_game/music-tracks.md.
#
# QTMA is note-sequenced synthesis, so rate 1.25x raises the TEMPO ONLY -- each note's pitch
# is unchanged. Our port pre-renders those tunes to fixed OGG audio, so we reproduce the
# tempo-only speedup faithfully with ffmpeg's `atempo` filter (WSOLA time-stretch: it changes
# duration WITHOUT changing pitch). Stretching the SHIPPED OGG (rather than re-synthesising
# from MIDI) also guarantees the hurry variant's timbre matches the normal track exactly, so
# the swap at the hurry-up moment is seamless.
#
# Output: <base>_hurry.ogg next to each in-play <base>.ogg (top level + original/ if present).
# Usage:  powershell -ExecutionPolicy Bypass -File tools/render_music_hurry.ps1
param(
    [string]$Dir  = "extracted/music",
    [double]$Rate = 1.25
)
$ErrorActionPreference = "Stop"
if ($Rate -lt 0.5 -or $Rate -gt 2.0) { throw "atempo needs 0.5 <= Rate <= 2.0 (chain filters outside that range); got $Rate" }

$ff = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source
if (-not $ff) { $ff = "D:\Program Files\Tools\ffmpeg.exe" }
if (-not (Test-Path $ff)) { throw "ffmpeg not found (needed for the atempo time-stretch)" }

# The in-play looping tunes (audio.gd MUSIC_SELECTOR 1-4) plus their Sound->Music "Light"
# (_thin) arrangements. These are the only tracks that play while a Bonus timer counts down,
# so they are the only ones that ever "hurry". Menu (5) / ending (6, Angel_Pie) never do.
$tunes = @("6lilt", "Cminor", "bass_for_lunch", "spooky")
$bases = @()
foreach ($t in $tunes) { $bases += $t; $bases += ($t + "_thin") }

# Resolve base -> hurry pairs across the top level and the optional original/ soundtrack.
$roots = @($Dir)
$origDir = Join-Path $Dir "original"
if (Test-Path $origDir) { $roots += $origDir }

$made = 0
# Format the rate with the invariant culture: ffmpeg's atempo needs a '.' decimal, but
# "atempo={0}" -f $Rate would emit "1,25" on comma-decimal locales (de-DE, fr-FR, ...).
$rateStr = $Rate.ToString([System.Globalization.CultureInfo]::InvariantCulture)
foreach ($root in $roots) {
    foreach ($b in $bases) {
        $src = Join-Path $root ($b + ".ogg")
        if (-not (Test-Path $src)) { continue }
        $dst = Join-Path $root ($b + "_hurry.ogg")
        & $ff -hide_banner -loglevel error -y -i $src -filter:a "atempo=$rateStr" -c:a libvorbis -q:a 4 $dst
        if ($LASTEXITCODE -ne 0) { throw "ffmpeg failed on $src" }
        Write-Host ("hurry ({0}x) -> {1}" -f $rateStr, $dst)
        $made++
    }
}
if ($made -eq 0) { throw "no source tunes found (looked for $($tunes -join ', ') under $($roots -join ', ')) -- nothing rendered" }
Write-Host ("done: {0} hurry variant(s) written" -f $made)
