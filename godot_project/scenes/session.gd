extends Node
## session.gd — tiny autoload singleton that carries the player's board choice
## from the menu into the game scene (registered as "Session" in project.godot).

var board_path: String = ""
var board_list: PackedStringArray = PackedStringArray()
var board_index: int = -1
var num_players: int = 2   # 1/2/3 (the main menu sets this; 3 = the remaster's co-op P3)
var mode: int = 0          # 0 = Cooperate (shared board), 1 = Compete (separate doors, first to exit
                           # wins), 2 = Alternate (two solo games taking turns), 3 = Versus (PvP arena)
var victory_rule: int = -1  # -1 = Map Default, 0 = Lives (Elimination), 1 = Score, 2 = Door
var friendly_fire: int = -1 # -1 = Map Default, 0 = off, 1 = on
var input_assist: bool = true
var start_lives: int = 2
var p3_any_key: bool = false
var custom_map_path: String = ""
var custom_board_bytes: PackedByteArray = PackedByteArray()
var player_device: Array = [-1, -2, -3] # Device routing: -1 KB1, -2 KB2, -3 KB3, 0..3 Joypad device_id
var net: RollbackNet = null
var is_online: bool = false
var online_bord_bytes: PackedByteArray = PackedByteArray()
var online_seed: int = 1
var online_start_board: int = 0
var speed: int = 2 # 0 = Really Fast, 1 = Fast, 2 = Medium (71 Hz default), 3 = Slow

const SETTINGS_PATH := "user://settings.json"
const SFX_VOL_DB := [0.0, -10.0, -22.0, -80.0]
const MUSIC_VOL_DB := [-6.0, -14.0, -24.0, -80.0]
const DEFAULT_KEYBINDS := [
	{"left": KEY_LEFT, "right": KEY_RIGHT, "jump": KEY_UP, "block_high": KEY_Z, "block_low": KEY_X, "arrow": KEY_C, "ball": KEY_V},
	{"left": KEY_A, "right": KEY_D, "jump": KEY_W, "block_high": KEY_F, "block_low": KEY_G, "arrow": KEY_H, "ball": KEY_J},
	{"left": KEY_KP_4, "right": KEY_KP_6, "jump": KEY_KP_8, "block_high": KEY_KP_7, "block_low": KEY_KP_9, "arrow": KEY_KP_1, "ball": KEY_KP_3},
]
var sfx_vol_idx: int = 0
var music_vol_idx: int = 0
var music_mode: int = 2 # 0 = Full, 1 = Light, 2 = Off
var fullscreen: bool = false
var keybinds: Array = []
var _settings_loaded_remastered: int = -1
var _has_saved_settings: bool = false

func _is_automated_run() -> bool:
	if DisplayServer.get_name() == "headless":
		return true
	for a in OS.get_cmdline_user_args() + OS.get_cmdline_args():
		for pfx in ["--shot", "--menushot", "--demo", "--play=", "--bug3", "--script=", "--test-editor", "--hidden"]:
			if str(a).begins_with(pfx):
				return true
	return false

func reset_keybinds() -> void:
	keybinds = []
	for d in DEFAULT_KEYBINDS:
		keybinds.append((d as Dictionary).duplicate())

func get_keybind(slot: int, action: String) -> int:
	var idx := clampi(slot, 0, 2)
	if keybinds.size() <= idx:
		reset_keybinds()
	var d: Dictionary = keybinds[idx]
	return int(d.get(action, (DEFAULT_KEYBINDS[idx] as Dictionary).get(action, KEY_NONE)))

func set_keybind(slot: int, action: String, keycode: int) -> void:
	var idx := clampi(slot, 0, 2)
	if keybinds.size() <= idx:
		reset_keybinds()
	(keybinds[idx] as Dictionary)[action] = keycode

func set_fullscreen(on: bool, persist: bool = true) -> void:
	fullscreen = on
	if not _is_automated_run():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if on else DisplayServer.WINDOW_MODE_WINDOWED)
	if persist:
		save_settings()

func toggle_fullscreen() -> void:
	set_fullscreen(not fullscreen, true)

func save_settings(path: String = SETTINGS_PATH) -> bool:
	if path == SETTINGS_PATH and _is_automated_run():
		return true
	if keybinds.size() < 3:
		reset_keybinds()
	var kb_out: Array = []
	for i in range(3):
		var d: Dictionary = keybinds[i]
		var clean_d: Dictionary = {}
		for k in d.keys():
			clean_d[str(k)] = int(d[k])
		kb_out.append(clean_d)
	var data := {
		"speed": clampi(speed, 0, 3),
		"remastered": remastered,
		"music_mode": clampi(music_mode, 0, 2),
		"sfx_vol_idx": clampi(sfx_vol_idx, 0, 3),
		"music_vol_idx": clampi(music_vol_idx, 0, 3),
		"fullscreen": fullscreen,
		"keybinds": kb_out,
	}
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(data))
	return true

func load_settings(path: String = SETTINGS_PATH) -> bool:
	if keybinds.size() < 3:
		reset_keybinds()
	if not FileAccess.file_exists(path):
		return false
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var data: Variant = JSON.parse_string(f.get_as_text())
	if not (data is Dictionary):
		return false
	var d := data as Dictionary
	if d.has("speed"):
		speed = clampi(int(d["speed"]), 0, 3)
	if d.has("remastered"):
		_settings_loaded_remastered = 1 if bool(d["remastered"]) else 0
	if d.has("music_mode"):
		music_mode = clampi(int(d["music_mode"]), 0, 2)
	if d.has("sfx_vol_idx"):
		sfx_vol_idx = clampi(int(d["sfx_vol_idx"]), 0, 3)
	if d.has("music_vol_idx"):
		music_vol_idx = clampi(int(d["music_vol_idx"]), 0, 3)
	if d.has("fullscreen"):
		fullscreen = bool(d["fullscreen"])
	if d.has("keybinds") and d["keybinds"] is Array:
		var kbarr := d["keybinds"] as Array
		for slot in range(mini(3, kbarr.size())):
			if kbarr[slot] is Dictionary:
				var src_d := kbarr[slot] as Dictionary
				for act in (DEFAULT_KEYBINDS[slot] as Dictionary).keys():
					if src_d.has(act):
						var kc := int(src_d[act])
						if kc > 0:
							(keybinds[slot] as Dictionary)[act] = kc
	_has_saved_settings = true
	return true

## Claim a controller device into player slots, avoiding duplicate assignments and reusing free KB IDs
func claim_controller_slot(device: int) -> int:
	var n_p := clampi(num_players, 1, 3)
	while player_device.size() < maxi(n_p, 3):
		player_device.append(get_unused_keyboard_id(player_device.size()))

	var current_slot: int = -1
	for slot in range(player_device.size()):
		if player_device[slot] == device:
			if slot < n_p and current_slot == -1:
				current_slot = slot
			else:
				player_device[slot] = get_unused_keyboard_id(slot)

	if current_slot >= 0:
		var target_slot: int = (current_slot + 1) % n_p
		var old_dev: int = player_device[target_slot]
		player_device[target_slot] = device
		player_device[current_slot] = old_dev if old_dev != device else get_unused_keyboard_id(current_slot)
		return target_slot
	else:
		var unassigned_slot: int = -1
		for s in range(n_p):
			if player_device[s] < 0:
				unassigned_slot = s
				break
		if unassigned_slot >= 0:
			player_device[unassigned_slot] = device
			return unassigned_slot
		else:
			player_device[0] = device
			return 0

## Fallback disconnected pads to distinct, unused keyboard slots
func fallback_disconnected_pads(connected_pads: Array) -> void:
	for p in range(player_device.size()):
		var dev: int = player_device[p]
		if dev >= 0 and not connected_pads.has(dev):
			player_device[p] = get_unused_keyboard_id(p)

## Returns a keyboard ID (< 0) not currently assigned to any slot, preferring -(preferred_slot + 1)
func get_unused_keyboard_id(preferred_slot: int = 0) -> int:
	var pref := -(preferred_slot + 1)
	if not player_device.has(pref):
		return pref
	for kb in [-1, -2, -3, -4]:
		if not player_device.has(kb):
			return kb
	return pref


func ext_path(rel: String = "") -> String:
	var sub := rel.trim_prefix("/")
	if sub.begins_with("extracted/"):
		sub = sub.substr("extracted/".length())

	var exe_dir := OS.get_executable_path().get_base_dir()
	var pkg_base := exe_dir.path_join("extracted")
	var base := pkg_base
	if DirAccess.dir_exists_absolute(pkg_base):
		base = pkg_base
	elif OS.has_feature("editor"):
		var dev_base := ProjectSettings.globalize_path("res://../extracted")
		if DirAccess.dir_exists_absolute(dev_base):
			base = dev_base
		else:
			base = pkg_base
	else:
		base = pkg_base

	if sub == "":
		return base
	return base.path_join(sub)

func current_board_path() -> String:
	if board_index >= 0 and board_index < board_list.size():
		return board_list[board_index]
	return board_path

# --- ORIGINAL <-> REMASTERED presentation, flipped live with F2 (title menu + in game) ---
# ORIGINAL = the 1996 SD sprites/PICTs + the 8-bit SFX + the original game's music (captures in
# extracted/music/original, tools/build_original_music.py). REMASTERED = the frame-matched 3D
# sprites over the HD sheets + the HD PICTs + remastered SFX + the studio music remaster.
# Launching with --3d or --hd starts REMASTERED. Gameplay is identical in both.
var remastered := false
var remaster_sfx := "ai"    # SFX set for REMASTERED (audio.gd SFX_VARIANTS); --sfx-variant= overrides
var presentation_hint_shown := false   # the game shows its "F2 switches" label once per launch
var _presentation_ready := false

## Apply the launch presentation once (whichever scene comes first calls it). An explicit
## --sfx-variant= / SOI_SFX_VARIANT picks REMASTERED's SFX set (ORIGINAL is always "original").
func init_presentation() -> void:
	if _presentation_ready:
		return
	_presentation_ready = true
	var ua := OS.get_cmdline_user_args()
	var is_standalone := OS.has_feature("template") and not ("--original" in ua)
	var explicit_pres := ("--3d" in ua) or ("--hd" in ua) or ("--original" in ua)
	if explicit_pres or _is_automated_run() or _settings_loaded_remastered == -1:
		remastered = ("--3d" in ua) or ("--hd" in ua) or is_standalone
	else:
		remastered = (_settings_loaded_remastered == 1)
	var ov: String = Audio._sfx_variant_override()
	if ov != "":
		remaster_sfx = ov
	Audio.set_sfx_variant(remaster_sfx if remastered else "original")
	Audio.set_music_variant("remaster" if remastered else "original")
	Audio.set_effects_volume(SFX_VOL_DB[clampi(sfx_vol_idx, 0, 3)])
	Audio.set_music_volume(MUSIC_VOL_DB[clampi(music_vol_idx, 0, 3)])
	if "--no-music" in ua:
		music_mode = 2
		Audio.set_music_enabled(false)
	elif "--music" in ua:
		if music_mode == 2:
			music_mode = 0
		Audio.set_music_light(music_mode == 1)
		Audio.set_music_enabled(true)
	elif _has_saved_settings:
		Audio.set_music_light(music_mode == 1)
		Audio.set_music_enabled(music_mode != 2)
	elif is_standalone:
		music_mode = 0
		Audio.set_music_enabled(true)
	if fullscreen and not _is_automated_run():
		set_fullscreen(true, false)

## Switch the whole audio side of the presentation (the scenes swap their own art).
func set_remastered(on: bool) -> void:
	var t0 := Time.get_ticks_msec()
	remastered = on
	Audio.set_sfx_variant(remaster_sfx if on else "original")
	Audio.set_music_variant("remaster" if on else "original")
	print("presentation: %s (sfx %s, %d enhanced; music %s; %d ms)" % ["REMASTERED" if on else "ORIGINAL",
		Audio.get_sfx_variant(), Audio._sfx_variant_hits, Audio.get_music_variant(), Time.get_ticks_msec() - t0])

## Advance to the next board in the picked list. Returns false at the end.
func advance() -> bool:
	if board_index >= 0 and board_index + 1 < board_list.size():
		board_index += 1
		board_path = board_list[board_index]
		return true
	return false

# --- High scores (menu "High Scores" screen / About doc 8). Persisted to
# user://highscores.json; the game submits a qualifying final score with initials. ---
const HS_MAX := 10
const HS_PATH := "user://highscores.json"
var high_scores: Array = []   # [{name:String, score:int}, ...] sorted high->low, max HS_MAX

func _ready() -> void:
	reset_keybinds()
	if not _is_automated_run():
		load_settings()
	_load_scores()

func _load_scores() -> void:
	high_scores = []
	if FileAccess.file_exists(HS_PATH):
		var f := FileAccess.open(HS_PATH, FileAccess.READ)
		if f != null:
			var data: Variant = JSON.parse_string(f.get_as_text())
			if data is Array:
				for e in data:
					if e is Dictionary and e.has("name") and e.has("score"):
						high_scores.append({"name": str(e["name"]), "score": int(e["score"])})
	if high_scores.is_empty():
		high_scores = [
			{"name": "SOI", "score": 50000}, {"name": "TED", "score": 40000},
			{"name": "MAC", "score": 30000}, {"name": "ACE", "score": 20000},
			{"name": "YOU", "score": 10000},
		]
	_sort_scores()

func _sort_scores() -> void:
	high_scores.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return int(a["score"]) > int(b["score"]))
	if high_scores.size() > HS_MAX:
		high_scores.resize(HS_MAX)

## Does `score` make the table (an empty slot, or beating the lowest entry)?
func qualifies(score: int) -> bool:
	if score <= 0:
		return false
	if high_scores.size() < HS_MAX:
		return true
	return score > int(high_scores[HS_MAX - 1]["score"])

func add_score(pname: String, score: int) -> void:
	high_scores.append({"name": pname, "score": score})
	_sort_scores()
	_save_scores()

func _save_scores() -> void:
	var f := FileAccess.open(HS_PATH, FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify(high_scores))

# --- QuickSave / Resume (File menu; About doc 8: a saved game resumes at the START of the
# board where it was saved). We store the board + each player's board-start persistent stats. ---
const SAVE_PATH := "user://savegame.json"
var resume_stats: Array = []   # per-player [{score,lives,arrows,balls,shield}] applied on the next start

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game(stats: Array) -> bool:
	var data := {
		"mode": mode, "num_players": num_players,
		"board_index": board_index, "board_path": board_path,
		"board_list": Array(board_list), "players": stats,
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		return false
	f.store_string(JSON.stringify(data))
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return false
	var data: Variant = JSON.parse_string(f.get_as_text())
	if not (data is Dictionary):
		return false
	mode = int(data.get("mode", 0))
	num_players = int(data.get("num_players", 2))
	board_index = int(data.get("board_index", -1))
	board_path = str(data.get("board_path", ""))
	board_list = PackedStringArray(data.get("board_list", []))
	resume_stats = data.get("players", [])
	custom_board_bytes = PackedByteArray()
	custom_map_path = ""
	if has_meta("custom_board_bytes"):
		remove_meta("custom_board_bytes")
	if has_meta("editor_return"):
		remove_meta("editor_return")
	return true

# --- New Game: build the board list and start at board 1. One Player / Alternate / Cooperate play
# the tiered campaign BORD 401-500; COMPETE plays the separate 1001-1050 set (asm FUN_1002b448 loads
# BORD N+1000 when the compete flag DAT_1003ab6c = r2+0x69fc is set; those boards carry the
# per-player keys 8/9 and doors). ---
func start_campaign() -> void:
	custom_board_bytes = PackedByteArray()
	custom_map_path = ""
	if has_meta("custom_board_bytes"):
		remove_meta("custom_board_bytes")
	if has_meta("editor_return"):
		remove_meta("editor_return")
	resume_stats = []
	var lo := 401
	var hi := 500
	if num_players >= 2 and mode == 1:
		lo = 1001
		hi = 1050
	var dir := ext_path("levels")
	var files: Array[String] = []
	var da := DirAccess.open(dir)
	if da != null:
		da.list_dir_begin()
		var f := da.get_next()
		while f != "":
			if f.ends_with(".bord"):
				var n := _board_num_of(f)
				if n >= lo and n <= hi:
					files.append(dir.path_join(f))
			f = da.get_next()
		da.list_dir_end()
	files.sort_custom(func(a: String, b: String) -> bool: return _board_num_of(a) < _board_num_of(b))
	board_list = PackedStringArray(files)
	board_index = 0 if board_list.size() > 0 else -1
	board_path = board_list[0] if board_list.size() > 0 else ""

func start_campaign_at(start_num: int) -> void:
	start_campaign()
	for i in board_list.size():
		if _board_num_of(board_list[i]) == start_num:
			board_index = i
			board_path = board_list[i]
			break

func _board_num_of(fn: String) -> int:
	return fn.get_file().get_basename().replace("board_", "").to_int()
