extends Node
## audio.gd — autoload "Audio". Loads the extracted SFX WAVs at startup and
## plays SoiSfx events emitted by the core. WAVs live outside res:// (in
## extracted/audio/wav) and are un-imported, so they are parsed into
## AudioStreamWAV at runtime. The event→snd map (SFX_ID) is PINNED from the
## binary's DAT_10037074 table (tools/pef_tables.py, DBASE 0x100337f0) and
## re-verified 2026-07-06; the name-keyword table is only a fallback. Music
## playback (remaster/original) is in the Music section further down.

# SoiSfx event id -> original `snd ` resource id. CONCLUSIVE: extracted from the
# PEF sound-event table DAT_10037074 (tools/pef_tables.py, DBASE 0x100337f0) and
# joined to the snd inventory. Each maps our event to the exact game snd id that
# FUN_1002b020 played. (COIN and ENEMY_KILL are single events in our core but the
# original used a sound PER coin-value / PER enemy -- those are a later refinement.)
const SFX_ID := {
	1: 8345,    # BLOCK_CREATE  -> game evt 4  "Whoah"
	2: 7840,    # BLOCK_DESTROY -> game evt 3  "Fim"
	3: 20478,   # COIN          -> game evt 21 silver coin "Razz SysBark"
	4: 29940,   # ENEMY_KILL    -> "Smack" (generic squash; per-enemy evts 5..15 = refinement)
	5: 26486,   # PLAYER_HIT    -> game evt 33 "moon blast 11khz" (also the death cry)
	# 6 (JUMP) intentionally omitted: the jump launch is SILENT in the original
	7: 28670,   # FIRE          -> game evt 2  "Psiou" (rolling Magic Ball, FUN_10010d30)
	8: 19339,   # TELEPORT      -> game evt 37 "transport"
	9: 1001,    # POWERUP       -> game evt 39 door/key "bugle 11khz" (generic goody)
	10: 1000,   # THUNDER       -> game evt 38 "chime1 11khz"
	11: 10637,  # COIN_GOLD     -> game evt 0x1c "Brass fanfare 1"
	12: 11228,  # COIN_GEM      -> game evt 0x1d "DumDaDumDum"
	13: 5548,   # COIN_BARS     -> game evt 0x1e "bugle1 11khz"
	14: 4397,   # BALL          -> game evt 1  "Whip" (straight Magic Arrow, FUN_100110b4)
	15: 12863,  # CANNON_FIRE   -> game evt 0x10 "Flens"
	16: 4704,   # KILL_WHEELIE  -> game evt 0x0b "Gabing"
	17: 2224,   # KILL_HAMMER   -> game evt 0x05 "hammer half speed"
	18: 25564,  # KILL_BEANIE   -> game evt 0x07 "knock"
	19: 18366,  # KILL_ROBO     -> game evt 0x0a "Bell"
	20: 30612,  # KILL_WALKER   -> game evt 0x0c "metal crash"
	21: 1769,   # KILL_ANT      -> game evt 0x0e "Cow bell"
	22: 1628,   # KILL_OSTRICH  -> game evt 0x0f "bike horn"
	23: 18221,  # KILL_HIPPO    -> game evt 0x09 "Moof"
	24: 400,    # KILL_PIGGY    -> game evt 0x0d "Train whistle"
	25: 404,    # KILL_SMILEY   -> game evt 0x06 "Baby seagull"
	26: 32129,  # KILL_TEETH    -> game evt 0x08 "Honk"
	27: 13478,  # BLOCK_CRACK   -> head-bonk 1st hit, game evt 0x23
	28: 29940,  # BLOCK_BREAK   -> head-bonk 2nd hit, game evt 0x24 "Smack"
	29: 15960,  # ROBO_PUNCH    -> Robo block smash, game evt 0x11 "Metal"
	30: 1005,   # CLOCK         -> slow-enemies power-up, game evt 0x2B "slow"
	31: 24336,  # PICKUP_BALL   -> goody 0x12 (red arrow: Magic Arrow ammo), game evt 0x1a "slide whistle"
	32: 3001,   # PICKUP_ARROW  -> goody 0x11 (bottled swirl: Magic Ball ammo), game evt 0x19 "rooster"
	33: 31429,  # PICKUP_SHIELD -> shield pickup (goody 0x10), game evt 0x18 "oh la la"
	34: 7119,   # PICKUP_TIME   -> time bonus, game evt 0x1b "space balls"
	35: 1002,   # SHOES         -> speed-shoes goody 0x32, game evt 0x28 "zap"
	36: 1003,   # SHIELD_ON     -> shield-activate goody 0x30, game evt 0x29 "gong"
	37: 1004,   # WHISTLE       -> enemy-claim goody 0x31, game evt 0x2a "whistle"
	38: 17661,  # KEY           -> colored-key collect, game evt 0x14 "Announce"
	39: 1007,   # HURRY         -> low-bonus "hurry up" warning (timer passes 1000), game evt 0x2d -> 1007_hurry_up
	40: 2689,   # WALKER_FIRE    -> Walker bolt throw, game evt 0x13 "Strings" (DAT_10037074[0x13])
	41: 1006,   # SWITCH         -> Stop/Go switch flip, game evt 0x2c "snap" (DAT_10037074[0x2c])
	42: 2937,   # BEANIE_BUD     -> Beanie bud shot, game evt 0x12 (DAT_10037074[0x12])
	43: 15128,  # MULT           -> score-multiplier goody 0x0C-0x0F, game evt 0x17 "Eastern" (DAT_10037074[0x17])
}
# name-keyword fallbacks (used only if the id above isn't present)
const SFX := {
	1: ["whoah"], 2: ["fim"], 3: ["razz"], 4: ["smack"], 5: ["moon blast", "blast"],
	7: ["psiou"], 8: ["transport"], 9: ["bugle"], 10: ["chime"],
}

var _streams: Array[AudioStreamWAV] = []
var _names: Array[String] = []
var _by_event := {}
var _by_snd := {}   # original `snd ` resource id -> stream (for play_snd, e.g. the tally scale)
var _players: Array[AudioStreamPlayer] = []
var _next := 0
var _effects_db := 0.0   # Sound -> Effects Volume (About doc 8); applied to each SFX player on play

# --- Music (About doc 8; OFF BY DEFAULT, as in the original). The extracted QTMA
# tunes (extracted/music/*.mid) are rendered to OGG by tools/render_music.py +
# tools/render_music.ps1 and loaded on demand. FIDELITY: the notes / timing / tempo
# are faithful (from the QTMA extraction); the synth VOICE is an APPROXIMATE mellow
# default (see render_music.py) -- swap the OGGs for a fluidsynth+soundfont render
# to get closer to the original Apple QTMA voices. Which tune plays on which screen
# is presentational (TODO oracle); we default to one looping track. ---
var _music_player: AudioStreamPlayer = null
var _music_enabled := false
var _music_dir := ""
var _music_cache := {}          # "variant/track" -> AudioStream (or null if missing)
var _music_variant := "remaster"   # "remaster" (extracted/music) | "original" (extracted/music/original)
var _current_track := "6lilt"
var _music_light := false           # Sound->Music Full(false)/Light(true): Light uses the sparser "_thin" arrangement
var _current_selector := 0          # FUN_10018414 current-movie cache -> skip reloading the same selector (seamless loop)
const DEFAULT_MUSIC := "6lilt"

# "Hurry up" tempo: when a player's Bonus timer ticks past 1000 the original speeds the
# looping music via SetMovieRate(movie, 0x14000) -- 16.16 fixed-point, so 0x14000/0x10000 =
# 1.25x (asm FUN_10018b24, alongside the 0x2d "hurry up" sound). It resets to 1.0x when a
# time award lifts the last hurrying player back above 1000 (FUN_1000f3f0 -> FUN_10018ac4),
# and every new board restarts the movie at 1.0x (FUN_1001882c). QTMA is note-sequenced, so
# the speedup is TEMPO ONLY (pitch constant): we play a pre-rendered atempo=1.25 variant
# ("<track>_hurry.ogg", tools/render_music_hurry.ps1) rather than resampling, which would
# also shift pitch. See docs/original_game/music-tracks.md.
const HURRY_RATE := 1.25
var _music_hurry := false           # is the low-bonus tempo speedup currently engaged?

func _ready() -> void:
	var ov := _sfx_variant_override()
	if ov != "":
		_sfx_variant = ov
	_load_all()
	_map_events()
	for _i in 8:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	_init_music()
	if "--music" in OS.get_cmdline_user_args():
		_music_enabled = true   # launch with Sound -> Music on (the original defaults it off)
	print("audio: loaded %d SFX (variant=%s, %d enhanced), mapped %d events, music=%s" % [_streams.size(), _sfx_variant, _sfx_variant_hits, _by_event.size(), has_music()])

## Play the sound mapped to a SoiSfx event id (round-robin over a player pool).
func play(sfx_id: int) -> void:
	if not _by_event.has(sfx_id) or _players.is_empty():
		return
	var p := _players[_next]
	_next = (_next + 1) % _players.size()
	p.stream = _by_event[sfx_id]
	p.volume_db = _effects_db
	p.play()

## Play a sound by its ORIGINAL `snd ` resource id (bypasses the event map). Used for
## sequences the core does not emit as SoiSfx events -- e.g. the board-completed count-up
## scale (snd 1100 "hut", the rising notes 1102-1106, then 1101 "huh"), grounded in
## FUN_10015714's FUN_1002b020 calls resolved through the DAT_10037074 event->snd table.
func play_snd(snd_id: int) -> void:
	if not _by_snd.has(snd_id) or _players.is_empty():
		return
	var p := _players[_next]
	_next = (_next + 1) % _players.size()
	p.stream = _by_snd[snd_id]
	p.volume_db = _effects_db
	p.play()

## Sound -> Effects Volume (About doc 8). Applied to each SFX AudioStreamPlayer on play.
func set_effects_volume(db: float) -> void:
	_effects_db = db

func get_effects_volume() -> float:
	return _effects_db

# --- Music playback -----------------------------------------------------------
func _init_music() -> void:
	_music_dir = ProjectSettings.globalize_path("res://../extracted/music")
	_music_player = AudioStreamPlayer.new()
	_music_player.volume_db = -6.0            # sit under the SFX
	add_child(_music_player)

## Is the rendered music available on disk?
func has_music() -> bool:
	return _music_dir != "" and DirAccess.dir_exists_absolute(_music_dir)

## Resolve the OGG path for a track under the current variant. "original" prefers
## extracted/music/original/<track>.ogg and falls back to the remaster for any track
## the user didn't supply. (docs/original_game/music-tracks.md)
func _music_path(track: String) -> String:
	if _music_variant == "original":
		var op := _music_dir.path_join("original").path_join(track + ".ogg")
		if FileAccess.file_exists(op):
			return op
		# No capture of the sparser "_thin" (Sound->Music Light) arrangement: stay on the ORIGINAL
		# recording's full arrangement rather than switching soundtrack to the remaster's thin one.
		if "_thin" in track:
			var full := _music_dir.path_join("original").path_join(track.replace("_thin", "") + ".ogg")
			if FileAccess.file_exists(full):
				return full
		# A "_hurry" request whose ORIGINAL base recording exists but has no pre-rendered
		# original hurry: do NOT cross to the remaster (that jumps timbre mid-track). Return the
		# (absent) original path so _load_music yields null and set_music_hurry degrades via
		# pitch_scale on the SAME original recording. If the base itself is absent (the user
		# never supplied this tune) we fall through to the remaster below, as usual.
		if track.ends_with("_hurry") and FileAccess.file_exists(
				_music_dir.path_join("original").path_join(track.trim_suffix("_hurry") + ".ogg")):
			return op
	return _music_dir.path_join(track + ".ogg")

## Load a looping OGG track by base name (no extension). Cached per variant.
func _load_music(track: String) -> AudioStream:
	var key := _music_variant + "/" + track
	if _music_cache.has(key):
		return _music_cache[key]
	var s: AudioStream = null
	var path := _music_path(track)
	if FileAccess.file_exists(path):
		var ogg := AudioStreamOggVorbis.load_from_file(path)
		if ogg != null:
			ogg.loop = true
			s = ogg
	_music_cache[key] = s
	return s

## Select a looping track by base name; starts it only if music is enabled.
func play_music(track: String) -> void:
	if _music_player == null:
		return
	var s := _load_music(track)
	if s == null:
		return
	_current_track = track
	_music_hurry = false                 # a track change starts at 1.0x (asm FUN_1001882c)
	_music_player.pitch_scale = 1.0
	_music_player.stream = s
	_load_music(track + "_hurry")        # pre-warm the hurry variant into cache, off the per-tick
	                                     # hot path, so the first hurry engagement never disk-loads
	                                     # during a physics tick (no frame hitch)
	if _music_enabled:
		_music_player.play()

## Choose the soundtrack: "remaster" (synth default) or "original" (your recordings
## in extracted/music/original/). Reloads the current track at the SAME playback position:
## both soundtracks are one loop of the same tune clock (tools/build_original_music.py aligns
## the captures to it), so an A/B swap continues the same passage. See music-tracks.md.
func set_music_variant(v: String) -> void:
	if (v != "remaster" and v != "original") or v == _music_variant:
		return
	_music_variant = v
	if _music_player != null:
		var was_playing := _music_player.playing
		var pos := _music_player.get_playback_position() if was_playing else 0.0
		var was_hurry_stream := _music_hurry and is_equal_approx(_music_player.pitch_scale, 1.0)
		# Honor an active "hurry" speedup across the soundtrack swap (the asm re-rates the one
		# shared movie regardless of which recording is loaded): prefer this track's pre-rendered
		# "_hurry" variant; if the chosen soundtrack has none, fall back to base + pitch_scale.
		var s: AudioStream = _load_music(_current_track + "_hurry") if _music_hurry else null
		if s != null:
			_music_player.pitch_scale = 1.0
			if not was_hurry_stream:
				pos /= HURRY_RATE                # base-time position -> the re-timed hurry stream
		else:
			s = _load_music(_current_track)
			_music_player.pitch_scale = HURRY_RATE if _music_hurry else 1.0
			if was_hurry_stream:
				pos *= HURRY_RATE                # hurry-stream position -> base time
		if s != null:
			_music_player.stream = s
			if was_playing and _music_enabled:
				var slen := s.get_length()
				_music_player.play(fmod(pos, slen) if slen > 0.0 else 0.0)
		_load_music(_current_track + "_hurry")   # pre-warm the new soundtrack's hurry variant (as play_music does) so the first hurry after a swap never disk-loads mid-tick

func get_music_variant() -> String:
	return _music_variant

## Music on/off (Sound -> Music checkbox). Off by default (the original default).
func set_music_enabled(on: bool) -> void:
	_music_enabled = on
	if _music_player == null:
		return
	if on:
		if _music_player.stream == null:
			play_music(DEFAULT_MUSIC)
		elif not _music_player.playing:
			_music_player.play()
	else:
		_music_player.stop()

func is_music_enabled() -> bool:
	return _music_enabled

## "Hurry up" tempo control (asm FUN_10018b24 / FUN_10018ac4). Engage (on=true) when a
## player's Bonus timer passes 1000; release (on=false) when it is lifted back above 1000
## or a new board starts. Faithful behaviour is TEMPO ONLY (pitch constant), so we swap the
## looping stream to the pre-rendered "<track>_hurry.ogg" (atempo=1.25) and carry the
## playback position across so timbre and position stay close. (Unlike the original's in-place
## SetMovieRate, this restarts the loop at the mapped offset, so the seam is a sub-buffer
## approximation, not sample-exact.) If no pre-rendered variant exists we degrade gracefully to
## pitch_scale (tempo AND pitch rise) so the urgency cue is never silent.
func set_music_hurry(on: bool) -> void:
	if on == _music_hurry:
		return
	if _music_player == null:
		return                               # not initialised yet; the per-tick recompute re-engages once playing
	_music_hurry = on
	var was_playing := _music_player.playing
	var pos := _music_player.get_playback_position() if was_playing else 0.0
	var want := (_current_track + "_hurry") if on else _current_track
	var s := _load_music(want)
	if s == null:
		# No pre-rendered variant for this track -> resample in place (less faithful: this
		# raises pitch too), so the speedup still fires rather than doing nothing.
		_music_player.pitch_scale = HURRY_RATE if on else 1.0
		return
	_music_player.pitch_scale = 1.0
	if _music_player.stream == s:
		return
	# Map the position onto the re-timed stream: base->hurry compresses time by 1/1.25,
	# hurry->base expands it by 1.25. Wrap into the loop so play() never seeks past the end.
	var np: float = pos * ((1.0 / HURRY_RATE) if on else HURRY_RATE)
	_music_player.stream = s
	if was_playing and _music_enabled:
		var slen := s.get_length()
		np = fmod(np, slen) if slen > 0.0 else 0.0
		_music_player.play(np)

# --- RE-grounded per-screen music selection -----------------------------------
## The original chooses the looping background-music QuickTime movie via
## FUN_10018414(selector), selector 1..6. The Sound->Music "Light" setting
## (DAT_10039154) swaps the sparser "_thin" arrangement for the four in-play tunes
## (selectors 1-4); 5 (title/menu) and 6 (ending) have no thin variant. The movie
## names were resolved from the PEF data by tools/dump_movie_names.py:
##   1 6lilt   2 Cminor   3 bass_for_lunch   4 spooky   5 6lilt (menu)   6 Angel_Pie (ending)
const MUSIC_SELECTOR := {
	1: "6lilt", 2: "Cminor", 3: "bass_for_lunch", 4: "spooky",
	5: "6lilt", 6: "Angel_Pie",
}

## Select the movie for a 1..6 selector (mirrors FUN_10018414). Skips work when the
## same selector is already active, so the loop is seamless across same-tune boards
## (the original's `_DAT_1003904e == param_1` early-out). Sets the stream even when
## music is off, so enabling it later starts on the right track.
func play_music_selector(selector: int) -> void:
	if not MUSIC_SELECTOR.has(selector):
		return
	if selector == _current_selector:
		return
	_current_selector = selector
	play_music(_selector_track(selector))

## Resolve a selector to a track base name, honouring Light ("_thin") for tunes 1-4.
func _selector_track(selector: int) -> String:
	var track: String = MUSIC_SELECTOR.get(selector, DEFAULT_MUSIC)
	if _music_light and selector >= 1 and selector <= 4:
		var thin := track + "_thin"
		if _load_music(thin) != null:
			return thin
	return track

## Title / menu / attract music: selector 5 = "6lilt" (always the full arrangement).
func play_menu_music() -> void:
	play_music_selector(5)

## In-game music for a 1-based level number. The original rotates three tunes by
## (level % 3) + 1 (FUN_10018c88), UNLESS the board holds a Knight or Gargoyle, which
## forces selector 4 "spooky" (DAT_1003ad0e, set by FUN_10017a70 when an enemy of
## category 13/14 is present). `spooky` overrides the rotation.
func play_level_music(level: int, spooky: bool) -> void:
	play_music_selector(4 if spooky else (level % 3) + 1)

## Ending music (the whole campaign beaten): selector 6 = "Angel Pie" (FUN_1001768c).
func play_ending_music() -> void:
	play_music_selector(6)

## Sound->Music Full vs Light (the sparser "_thin" arrangement). Reloads the current
## movie so the change is audible immediately (the original reloads on the toggle).
func set_music_light(light: bool) -> void:
	if light == _music_light:
		return
	_music_light = light
	if _current_selector != 0:
		var sel := _current_selector
		_current_selector = 0           # force play_music_selector to reload with the new arrangement
		play_music_selector(sel)

func is_music_light() -> bool:
	return _music_light

# --- SFX variant selection ----------------------------------------------------
# Three parallel SFX sets, chosen at runtime. "original" is the faithful 8-bit
# source; the others are remaster passes (same filenames -> matched per file).
# ANY file missing or unreadable in the chosen set falls back to the original
# sound, so playback can never break. Default "original" leaves the SD set intact.
const SFX_VARIANTS := {
	"original": "res://../extracted/audio/wav",     # faithful 8-bit source
	"light": "res://../extracted/audio/wav_hd",     # denoised 16-bit 44.1k clean-up
	"ai": "res://../extracted/audio/wav_ai",        # AudioSR super-res (32-bit float)
}
var _sfx_variant := "original"
var _sfx_variant_hits := 0   # how many sounds actually came from the chosen variant

## Choose the SFX set: "original", "light" (extracted/audio/wav_hd) or "ai"
## (extracted/audio/wav_ai). Reloads all SFX; unknown values are ignored.
func set_sfx_variant(v: String) -> void:
	if not SFX_VARIANTS.has(v) or v == _sfx_variant:
		return
	_sfx_variant = v
	_reload_sfx()

func get_sfx_variant() -> String:
	return _sfx_variant

## Optional startup override so the SFX set can be A/B'd without a settings UI:
## set env SOI_SFX_VARIANT=ai (or light/original), or launch with `-- --sfx-variant=ai`.
func _sfx_variant_override() -> String:
	var v := OS.get_environment("SOI_SFX_VARIANT").strip_edges().to_lower()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--sfx-variant="):
			v = a.substr(a.find("=") + 1).strip_edges().to_lower()
	return v if SFX_VARIANTS.has(v) else ""

func _reload_sfx() -> void:
	_streams.clear()
	_names.clear()
	_by_snd.clear()
	_by_event.clear()
	_load_all()
	_map_events()

func _load_all() -> void:
	var orig := ProjectSettings.globalize_path(SFX_VARIANTS["original"])
	var vdir := ProjectSettings.globalize_path(SFX_VARIANTS.get(_sfx_variant, SFX_VARIANTS["original"]))
	var da := DirAccess.open(orig)
	if da == null:
		return
	_sfx_variant_hits = 0
	da.list_dir_begin()
	var f := da.get_next()
	while f != "":
		if f.ends_with(".wav"):
			var s: AudioStreamWAV = null
			# prefer the chosen variant; fall back to the original on miss/unreadable
			if _sfx_variant != "original":
				var cand := vdir.path_join(f)
				if FileAccess.file_exists(cand):
					s = _load_wav(cand)
					if s != null:
						_sfx_variant_hits += 1
			if s == null:
				s = _load_wav(orig.path_join(f))
			if s != null:
				_streams.append(s)
				_names.append(f.to_lower())
				var us := f.find("_")   # filenames are "<snd id>_<name>.wav"
				if us > 0:
					var sid := f.substr(0, us).to_int()
					if sid > 0:
						_by_snd[sid] = s
		f = da.get_next()
	da.list_dir_end()

func _map_events() -> void:
	for ev in SFX_ID:
		var idx := -1
		# 1) exact original snd id (filenames are "<id>_<name>.wav")
		var pref := "%d_" % SFX_ID[ev]
		for i in _names.size():
			if _names[i].begins_with(pref):
				idx = i
				break
		# 2) name-keyword fallback
		if idx < 0:
			for kw in SFX.get(ev, []):
				for i in _names.size():
					if kw in _names[i]:
						idx = i
						break
				if idx >= 0:
					break
		if idx < 0 and _streams.size() > 0:
			idx = ev % _streams.size()          # deterministic fallback
		if idx >= 0:
			_by_event[ev] = _streams[idx]

## RIFF/WAVE parser -> AudioStreamWAV. Walks the chunk list (does not trust fixed
## offsets) and reads the real fmt fields. Handles 8-bit unsigned PCM and 16-bit
## PCM natively; 32-bit IEEE float (e.g. AudioSR super-res output) is DOWN-CONVERTED
## to 16-bit here because AudioStreamWAV has no float format. Any other/broken layout
## returns null so the caller falls back to the original SD sound.
func _load_wav(path: String) -> AudioStreamWAV:
	var b := FileAccess.get_file_as_bytes(path)
	if b.size() < 44 or b.slice(0, 4).get_string_from_ascii() != "RIFF" \
			or b.slice(8, 12).get_string_from_ascii() != "WAVE":
		return null
	var fmt_tag := 0
	var channels := 0
	var rate := 0
	var bits := 0
	var data := PackedByteArray()
	var have_fmt := false
	var o := 12
	while o + 8 <= b.size():
		var cid := b.slice(o, o + 4).get_string_from_ascii()
		var csz := b.decode_u32(o + 4)
		var body := o + 8
		if cid == "fmt " and body + 16 <= b.size():
			fmt_tag = b.decode_u16(body)
			channels = b.decode_u16(body + 2)
			rate = b.decode_u32(body + 4)
			bits = b.decode_u16(body + 14)
			if fmt_tag == 0xFFFE and body + 26 <= b.size():
				fmt_tag = b.decode_u16(body + 24)   # EXTENSIBLE: real tag in the subformat GUID
			have_fmt = true
		elif cid == "data":
			data = b.slice(body, min(body + csz, b.size()))
			if have_fmt:
				break
		o += 8 + csz + (csz & 1)
	if not have_fmt or data.is_empty() or channels == 0 or rate == 0:
		return null
	var s := AudioStreamWAV.new()
	s.mix_rate = rate
	s.stereo = channels == 2
	if fmt_tag == 1 and bits == 8:
		s.format = AudioStreamWAV.FORMAT_8_BITS
		var out8 := PackedByteArray()
		out8.resize(data.size())
		for i in data.size():
			out8[i] = (data[i] - 128) & 0xFF     # unsigned -> signed
		s.data = out8
	elif fmt_tag == 1 and bits == 16:
		s.format = AudioStreamWAV.FORMAT_16_BITS
		s.data = data
	elif fmt_tag == 3 and bits == 32:
		s.format = AudioStreamWAV.FORMAT_16_BITS   # no float format -> down-convert to 16-bit
		var fl := data.to_float32_array()
		var out16 := PackedByteArray()
		out16.resize(fl.size() * 2)
		for i in fl.size():
			out16.encode_s16(i * 2, clampi(int(round(fl[i] * 32767.0)), -32768, 32767))
		s.data = out16
	else:
		return null                              # unsupported -> caller falls back
	return s
