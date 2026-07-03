extends Node
## audio.gd — autoload "Audio". Loads the extracted SFX WAVs at startup and
## plays SoiSfx events emitted by the core. WAVs live outside res:// (in
## extracted/audio/wav) and are un-imported, so they are parsed into
## AudioStreamWAV at runtime. The event→sound mapping is presentational
## (matched by name keywords) until the oracle pins each snd id (TODO).

# SoiSfx enum id -> ordered name-keyword preferences (see core/include/soi_core.h)
const SFX := {
	1: ["snap", "pop", "tick", "click"],       # BLOCK_CREATE
	2: ["crash", "break", "snap", "smash"],    # BLOCK_DESTROY
	3: ["chime", "bell", "coin", "ding"],      # COIN
	4: ["zap", "squish", "pop", "splat"],      # ENEMY_KILL
	5: ["ahh", "gong", "ouch", "oh"],          # PLAYER_HIT
	6: ["boing", "moof", "jump", "hop"],       # JUMP
	7: ["zap", "laser", "fire", "pew"],        # FIRE
	8: ["transport", "warp", "psiou", "zap"],  # TELEPORT
	9: ["bugle", "fanfare", "chime", "bell"],  # POWERUP
	10: ["gong", "thunder", "brass", "zap"],   # THUNDER
}

var _streams: Array[AudioStreamWAV] = []
var _names: Array[String] = []
var _by_event := {}
var _players: Array[AudioStreamPlayer] = []
var _next := 0

func _ready() -> void:
	_load_all()
	_map_events()
	for _i in 8:
		var p := AudioStreamPlayer.new()
		add_child(p)
		_players.append(p)
	print("audio: loaded %d SFX, mapped %d events" % [_streams.size(), _by_event.size()])

## Play the sound mapped to a SoiSfx event id (round-robin over a player pool).
func play(sfx_id: int) -> void:
	if not _by_event.has(sfx_id) or _players.is_empty():
		return
	var p := _players[_next]
	_next = (_next + 1) % _players.size()
	p.stream = _by_event[sfx_id]
	p.play()

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
		f = da.get_next()
	da.list_dir_end()

func _map_events() -> void:
	for ev in SFX:
		var idx := -1
		for kw in SFX[ev]:
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
