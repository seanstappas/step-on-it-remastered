extends Node
## session.gd — tiny autoload singleton that carries the player's board choice
## from the menu into the game scene (registered as "Session" in project.godot).

var board_path: String = ""
var board_list: PackedStringArray = PackedStringArray()
var board_index: int = -1
var num_players: int = 2   # 1/2/3 (the main menu sets this; 3 = the remaster's co-op P3)
var mode: int = 0          # 0 = Cooperate (shared board), 1 = Compete (separate doors, first to exit
                           # wins), 2 = Alternate (two solo games taking turns; game.gd owns the pools)
var speed: int = 2         # Options->Speed: 0=Really Fast 1=Fast 2=Medium(default) 3=Slow (local, About 8)

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
	remastered = "--3d" in ua or "--hd" in ua
	var ov: String = Audio._sfx_variant_override()
	if ov != "":
		remaster_sfx = ov
	Audio.set_sfx_variant(remaster_sfx if remastered else "original")
	Audio.set_music_variant("remaster" if remastered else "original")

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
	return true

# --- New Game: build the board list and start at board 1. One Player / Alternate / Cooperate play
# the tiered campaign BORD 401-500; COMPETE plays the separate 1001-1050 set (asm FUN_1002b448 loads
# BORD N+1000 when the compete flag DAT_1003ab6c = r2+0x69fc is set; those boards carry the
# per-player keys 8/9 and doors). ---
func start_campaign() -> void:
	resume_stats = []
	var lo := 401
	var hi := 500
	if num_players >= 2 and mode == 1:
		lo = 1001
		hi = 1050
	var dir := ProjectSettings.globalize_path("res://../extracted/levels")
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

func _board_num_of(fn: String) -> int:
	return fn.get_file().get_basename().replace("board_", "").to_int()
