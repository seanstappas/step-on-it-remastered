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
	7: 28670,   # FIRE (arrow)  -> game evt 2  "Psiou"
	8: 19339,   # TELEPORT      -> game evt 37 "transport"
	9: 1001,    # POWERUP       -> game evt 39 door/key "bugle 11khz" (generic goody)
	10: 1000,   # THUNDER       -> game evt 38 "chime1 11khz"
	11: 10637,  # COIN_GOLD     -> game evt 0x1c "Brass fanfare 1"
	12: 11228,  # COIN_GEM      -> game evt 0x1d "DumDaDumDum"
	13: 5548,   # COIN_BARS     -> game evt 0x1e "bugle1 11khz"
	14: 4397,   # BALL          -> game evt 1  "Whip" (Magic Ball fire)
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
	31: 24336,  # PICKUP_BALL   -> Magic Ball ammo (goody 0x12), game evt 0x1a "slide whistle"
	32: 3001,   # PICKUP_ARROW  -> Magic Arrow ammo (goody 0x11), game evt 0x19 "rooster"
	33: 31429,  # PICKUP_SHIELD -> shield pickup (goody 0x10), game evt 0x18 "oh la la"
	34: 7119,   # PICKUP_TIME   -> time bonus, game evt 0x1b "space balls"
	35: 1002,   # SHOES         -> speed-shoes goody 0x32, game evt 0x28 "zap"
	36: 1003,   # SHIELD_ON     -> shield-activate goody 0x30, game evt 0x29 "gong"
	37: 1004,   # WHISTLE       -> enemy-claim goody 0x31, game evt 0x2a "whistle"
	38: 17661,  # KEY           -> colored-key collect, game evt 0x14 "Announce"
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
const DEFAULT_MUSIC := "6lilt"

func _ready() -> void:
	_load_all()
	_map_events()
	for _i in 8:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	_init_music()
	print("audio: loaded %d SFX, mapped %d events, music=%s" % [_streams.size(), _by_event.size(), has_music()])

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
	_music_player.stream = s
	if _music_enabled:
		_music_player.play()

## Choose the soundtrack: "remaster" (synth default) or "original" (your recordings
## in extracted/music/original/). Reloads the current track. See music-tracks.md.
func set_music_variant(v: String) -> void:
	if (v != "remaster" and v != "original") or v == _music_variant:
		return
	_music_variant = v
	if _music_player != null:
		var was_playing := _music_player.playing
		var s := _load_music(_current_track)
		if s != null:
			_music_player.stream = s
			if was_playing and _music_enabled:
				_music_player.play()

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

func _load_all() -> void:
	var dir := ProjectSettings.globalize_path("res://../extracted/audio/wav")
	var da := DirAccess.open(dir)
	if da == null:
		return
	da.list_dir_begin()
	var f := da.get_next()
	while f != "":
		if f.ends_with(".wav"):
			var s := _load_wav(dir.path_join(f))
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

## Minimal RIFF/WAVE parser -> AudioStreamWAV (8-bit unsigned is converted to
## the signed 8-bit AudioStreamWAV expects).
func _load_wav(path: String) -> AudioStreamWAV:
	var b := FileAccess.get_file_as_bytes(path)
	if b.size() < 44 or b.slice(0, 4).get_string_from_ascii() != "RIFF":
		return null
	var channels := b.decode_u16(22)
	var rate := b.decode_u32(24)
	var bits := b.decode_u16(34)
	var data := PackedByteArray()
	var o := 12
	while o + 8 <= b.size():
		var cid := b.slice(o, o + 4).get_string_from_ascii()
		var csz := b.decode_u32(o + 4)
		if cid == "data":
			data = b.slice(o + 8, min(o + 8 + csz, b.size()))
			break
		o += 8 + csz + (csz & 1)
	if data.is_empty():
		return null
	var s := AudioStreamWAV.new()
	s.mix_rate = rate
	s.stereo = channels == 2
	if bits == 8:
		s.format = AudioStreamWAV.FORMAT_8_BITS
		var out := PackedByteArray()
		out.resize(data.size())
		for i in data.size():
			out[i] = (data[i] - 128) & 0xFF     # unsigned -> signed
		s.data = out
	else:
		s.format = AudioStreamWAV.FORMAT_16_BITS
		s.data = data
	return s
