# Epic music renders — A/B sets

FluidSynth + premium-SoundFont renders of the faithful QTMA MIDIs (`extracted/music/*.mid`),
mastered to −14 LUFS / peak ≤ −1 dBFS OGG Vorbis (48 kHz stereo). The notes/timing/tempo are
unchanged from the QTMA extraction; only the **voicing** changes (real SoundFont instruments
instead of the pure-numpy synth in `tools/render_music.py`).

The current **LIVE** set is `studio8` — the per-channel stem mix, tuned against the composer's
reference recordings (`refs/music/`). Faithful notes/timing (no humanization); every channel
rendered melodically (the QTMA extraction puts parts on channels blindly, so ch9 is NOT drums).
`bass_for_lunch` gets heavy per-part tuning: loud sustained sawtooth leads (velocity floor +
legato), a lead-forward balance, **time-scoped sustain-emphasis** (fast/busy notes ducked ONLY in
the 1:04–1:28 "crazy run" so the sparser lead phrases stay full), an **intro duck** (the opening
sustain sits back), an actual **drum** part at the end (ch6 → GM percussion), and master
loudness-levelling (`dynaudnorm`) for a consistent, loud level like the originals.

**studio8 recovers the QTMA pitch-bend automation.** `tools/qtma_to_midi.py` now parses QTMA
*control* events (`top==010`): controller `0x20` = **pitch bend**, value = signed 8.8 fixed-point
semitones, emitted as MIDI pitch-bend and carried through the stem renderer. This restores
`bass_for_lunch`'s **2-semitone slide on the sustain lead** at ~1:00 and ~1:43 (355 bend events on
part 11) that earlier sets discarded. **studio7** fixed the extraction bug before it: the QTMA
*Extended Note* (`top==100`) events were being dropped and a mis-attached branch on `top==011` was
swallowing real notes — fixing both recovered ~30–40 notes/track incl. the sustained 0:47 lead
(B5), replacing the old by-ear `_inject` hack. Earlier sets are kept for A/B and history.

## Sets (each has all 9 tracks: 6lilt, 6lilt_thin, Angel_Pie, bass_for_lunch[_thin],
##       Cminor[_thin], spooky[_thin])

| Folder            | SoundFont          | Arrangement | Notes |
|-------------------|--------------------|-------------|-------|
| `studio8`         | GeneralUser GS + MuseScore (hybrid) | faithful, **studio mix** | **LIVE** — QTMA pitch-bend recovery (2-semitone sustain slide at ~1:00/1:43) + time-scoped emphasis + intro duck |
| `studio7`         | GeneralUser GS + MuseScore (hybrid) | faithful, studio mix | QTMA Extended-Note extraction fix (real 0:47 lead recovered, `_inject` removed) + `bass_for_lunch` tuning |
| `studio1`–`studio6` | GeneralUser GS + MuseScore (hybrid) | faithful, studio mix | earlier stem passes (saw leads / legato / velocity floor / middle balance / by-ear `_inject`) — kept for history |
| `gugs_faithful`   | GeneralUser GS     | faithful    | single-font, punchy |
| `muse_faithful`   | MuseScore_General  | faithful    | single-font, lusher |
| `gugs_cinematic`  | GeneralUser GS     | re-orchestrated | organs/gtr/pads → strings, bigger hall (less 1:1) |
| `muse_cinematic`  | MuseScore_General  | re-orchestrated | ditto, lusher font |

A/B lead-instrument clips for `bass_for_lunch` (0:18–0:40) are in
`../../media/reference/music/bfl_lead_ab/` (saw / dist guitar / synth brass / bass lead vs the
original reference); swap the lead via `SOI_BFL_LEAD=<GM program>` or the `OVERRIDES` table in
`tools/render_music_studio.py`.

The previous pure-numpy render is preserved in `../pass3_numpy/` for A/B and rollback.

## SoundFonts (installed on D:, outside the repo)
- **GeneralUser GS** `D:\SOI-tools\soundfonts\GeneralUser-GS.sf2` (30.8 MB) — S. Christian
  Collins, from github.com/mrbumpy409/GeneralUser-GS (permissive license).
- **MuseScore_General** `D:\SOI-tools\soundfonts\MuseScore_General.sf3` (38 MB SF3, ~200 MB of
  samples) — MIT, from the official OSU OSL MuseScore mirror. Used as the lush/cinematic font
  (the original Arachno/SGM are not redistributably hosted; MuseScore_General is the standard
  lush free substitute).
- Synth: **FluidSynth 2.5.6** `D:\SOI-tools\fluidsynth\x64\...\bin\fluidsynth.exe`.

## A/B / swapping
To audition a different set in-game, copy its OGGs over the live set:
```
Copy-Item extracted/music/renders/muse_cinematic/*.ogg extracted/music/ -Force
```
To roll back to the numpy render: `Copy-Item extracted/music/pass3_numpy/*.ogg extracted/music/ -Force`.
Music is OFF by default (as in the original); enable it via Sound → Music.

## Reproduce
```powershell
# studio mix (LIVE) -- per-channel stems + hybrid fonts + humanize + mixed master:
py tools/render_music_studio.py extracted/music extracted/music/renders/studio

# faithful single-font, MuseScore:
powershell -ExecutionPolicy Bypass -File tools/render_music_epic.ps1 `
    -SoundFont 'D:\SOI-tools\soundfonts\MuseScore_General.sf3' `
    -InDir extracted/music -OutDir extracted/music/renders/muse_faithful

# cinematic (re-orchestrated): first remap programs, then render with -Cinematic:
py tools/midi_remap.py extracted/music D:\SOI-tools\scratch\cinematic_mid
powershell -ExecutionPolicy Bypass -File tools/render_music_epic.ps1 `
    -SoundFont 'D:\SOI-tools\soundfonts\MuseScore_General.sf3' `
    -InDir D:\SOI-tools\scratch\cinematic_mid `
    -OutDir extracted/music/renders/muse_cinematic -Cinematic
```
Master chain (per track): FluidSynth (hall reverb) → trim lead/trail silence → tone
(bass/treble) → glue compressor → loudness-match to −14 LUFS → limiter (−2.5 dB ceiling,
`level=false`) → libvorbis q6. See `tools/render_music_epic.ps1`.

Spectrogram A/B (6lilt): `../../media/reference/music/spec_6lilt_{0_numpy,1_gugs,2_muse,3_cine}.png`.
