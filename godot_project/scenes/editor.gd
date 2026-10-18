extends Control

const EnemyDefs = preload("res://scenes/enemy_defs.gd")

# editor.gd — In-Game Map Maker for Step On It! Remastered
# Supports 19x13, 28x19, and 38x26 maps with EXT1 trailer, save/load, and Tab instant playtest.

const SIZES: Array[Vector2i] = [
	Vector2i(19, 13),
	Vector2i(28, 19),
	Vector2i(38, 26),
]

var size_idx: int = 0
var grid_cols: int = 19
var grid_rows: int = 13

var p1_spawn: Vector2i = Vector2i(2, 2)
var p2_spawn: Vector2i = Vector2i(16, 2)
var p3_spawn: Vector2i = Vector2i(9, 2)
var vs_spawns: Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0)]
var has_p3: bool = false
var default_mode: int = 0 # 0=Co-op, 1=Compete, 2=Versus
var friendly_fire: bool = false
var victory_rule: int = 0 # 0=Lives, 1=Score, 2=Door
var starting_lives: int = 3
var playtest_players: int = 2
var bonus_time: int = 6000
var map_name: String = "custom_map"
var cursor_cell: Vector2i = Vector2i(0, 0)
var hover_cell: Vector2i = Vector2i(0, 0)
var enemy_facing_left: bool = false

# Grid 2D array: cells[row][col] -> tile int
var cells: Array = []

# Categorized Palette Brushes
const BRUSHES = [
	# --- Terrain ---
	{"cat": "Terrain", "name": "Eraser", "tile": 0x0000, "sprite": "", "frame": 0},
	{"cat": "Terrain", "name": "Wall", "tile": 0x0307, "sprite": "block_sprites", "frame": 8},
	{"cat": "Terrain", "name": "Breakable", "tile": 0x0207, "sprite": "block_sprites", "frame": 8},
	{"cat": "Terrain", "name": "Ladder/Mesh", "tile": 0x0197, "sprite": "block_sprites", "frame": 152},
	{"cat": "Terrain", "name": "Ice Floor", "tile": 0x0387, "sprite": "block_sprites", "frame": 136},
	{"cat": "Terrain", "name": "Hazard 1", "tile": 0x0317, "sprite": "block_sprites", "frame": 24},
	{"cat": "Terrain", "name": "Hazard 2", "tile": 0x0318, "sprite": "block_sprites", "frame": 25},

	# --- Mechanics ---
	{"cat": "Mechanics", "name": "Teleport IN", "tile": 0x081A, "sprite": "goody_sprites", "frame": 27},
	{"cat": "Mechanics", "name": "Teleport OUT", "tile": 0x081B, "sprite": "goody_sprites", "frame": 28},
	{"cat": "Mechanics", "name": "Stop/Go Switch", "tile": 0x0824, "sprite": "Stop_Go_sprite_family", "frame": 2},
	{"cat": "Mechanics", "name": "Stop/Go Block (Solid)", "tile": 0x039D, "sprite": "Stop_Go_sprite_family", "frame": 3},
	{"cat": "Mechanics", "name": "Stop/Go Block (Pass)", "tile": 0x01A3, "sprite": "Stop_Go_sprite_family", "frame": 2},

	# --- Goodies ---
	{"cat": "Goodies", "name": "Silver Coin", "tile": 0x090A, "sprite": "goody_sprites", "frame": 11},
	{"cat": "Goodies", "name": "Gold Coin", "tile": 0x0917, "sprite": "goody_sprites", "frame": 24},
	{"cat": "Goodies", "name": "Large Gem", "tile": 0x0918, "sprite": "goody_sprites", "frame": 25},
	{"cat": "Goodies", "name": "Arrow Ammo", "tile": 0x0911, "sprite": "goody_sprites", "frame": 18},
	{"cat": "Goodies", "name": "Ball Ammo", "tile": 0x0912, "sprite": "goody_sprites", "frame": 19},
	{"cat": "Goodies", "name": "Speed Shoes", "tile": 0x0932, "sprite": "goody_sprites", "frame": 51},
	{"cat": "Goodies", "name": "Shield", "tile": 0x0930, "sprite": "goody_sprites", "frame": 49},

	# --- Keys & Doors ---
	{"cat": "Doors", "name": "Key (Univ)", "tile": 0x0907, "sprite": "goody_sprites", "frame": 8},
	{"cat": "Doors", "name": "Lock (Univ)", "tile": 0x0904, "sprite": "goody_sprites", "frame": 5},
	{"cat": "Doors", "name": "Door (Univ)", "tile": 0x0901, "sprite": "goody_sprites", "frame": 2},
	{"cat": "Doors", "name": "Key (P1 Blue)", "tile": 0x0908, "sprite": "goody_sprites", "frame": 9},
	{"cat": "Doors", "name": "Lock (P1 Blue)", "tile": 0x0905, "sprite": "goody_sprites", "frame": 6},
	{"cat": "Doors", "name": "Door (P1 Blue)", "tile": 0x0902, "sprite": "goody_sprites", "frame": 3},
	{"cat": "Doors", "name": "Key (P2 Green)", "tile": 0x0909, "sprite": "goody_sprites", "frame": 10},
	{"cat": "Doors", "name": "Lock (P2 Green)", "tile": 0x0906, "sprite": "goody_sprites", "frame": 7},
	{"cat": "Doors", "name": "Door (P2 Green)", "tile": 0x0903, "sprite": "goody_sprites", "frame": 4},
	{"cat": "Doors", "name": "Key (P3 Red)", "tile": 0x0933, "sprite": "goody_sprites", "frame": 9},
	{"cat": "Doors", "name": "Lock (P3 Red)", "tile": 0x0934, "sprite": "goody_sprites", "frame": 6},
	{"cat": "Doors", "name": "Door (P3 Red)", "tile": 0x0935, "sprite": "goody_sprites", "frame": 3},

	# --- Enemies ---
	{"cat": "Enemies", "name": "Turret/Cannon", "tile": 0x1E140601, "frame": 2, "etype": 12},
	{"cat": "Enemies", "name": "Wheelie", "tile": 0x0602, "frame": 2, "etype": 5},
	{"cat": "Enemies", "name": "Wheelie (slow)", "tile": 0x0603, "frame": 2, "etype": 5},
	{"cat": "Enemies", "name": "Walker", "tile": 0x14000604, "frame": 2, "etype": 10},
	{"cat": "Enemies", "name": "Hippo", "tile": 0x1E140705, "frame": 2, "etype": 3},
	{"cat": "Enemies", "name": "Hammer", "tile": 0x1E140706, "frame": 2, "etype": 7},
	{"cat": "Enemies", "name": "Beanie H", "tile": 0x0607, "frame": 66, "etype": 8},
	{"cat": "Enemies", "name": "Beanie V", "tile": 0x0608, "frame": 66, "etype": 8},
	{"cat": "Enemies", "name": "Spinner", "tile": 0x0609, "frame": 2, "etype": 13},
	{"cat": "Enemies", "name": "Teeth", "tile": 0x1E14070A, "frame": 2, "etype": 11},
	{"cat": "Enemies", "name": "Smiley", "tile": 0x1E14070B, "frame": 2, "etype": 6},
	{"cat": "Enemies", "name": "Ant", "tile": 0x1E14070C, "frame": 2, "etype": 1},
	{"cat": "Enemies", "name": "Knight", "tile": 0x1E14060D, "frame": 2, "etype": 15},
	{"cat": "Enemies", "name": "Gargoyle", "tile": 0x1E14060E, "frame": 2, "etype": 14},
	{"cat": "Enemies", "name": "Robo", "tile": 0x060F, "frame": 2, "etype": 9},
	{"cat": "Enemies", "name": "Creeper H", "tile": 0x14000610, "frame": 2, "etype": 16},
	{"cat": "Enemies", "name": "Creeper V", "tile": 0x14000611, "frame": 2, "etype": 16},
	{"cat": "Enemies", "name": "Ostrich", "tile": 0x1E140712, "frame": 2, "etype": 2},
	{"cat": "Enemies", "name": "Piggy", "tile": 0x1E140713, "frame": 2, "etype": 4},


	# --- Spawns ---
	{"cat": "Spawns", "name": "P1 Spawn", "tile": -1, "sprite": "BP_sprites", "frame": 2},
	{"cat": "Spawns", "name": "P2 Spawn", "tile": -2, "sprite": "GP_sprites", "frame": 2},
	{"cat": "Spawns", "name": "P3 Spawn", "tile": -3, "sprite": "BP_sprites", "frame": 2},
	{"cat": "Spawns", "name": "VS Spawn 1", "tile": -4, "sprite": "", "frame": 0},
	{"cat": "Spawns", "name": "VS Spawn 2", "tile": -5, "sprite": "", "frame": 0},
	{"cat": "Spawns", "name": "VS Spawn 3", "tile": -6, "sprite": "", "frame": 0},
	{"cat": "Spawns", "name": "VS Spawn 4", "tile": -7, "sprite": "", "frame": 0},
]

var brush_idx: int = 1
var current_brush: int = 0x0307
var is_mouse_down: bool = false
var is_right_mouse_down: bool = false
var status_msg: String = ""
var status_timer: float = 0.0
var _tex_cache: Dictionary = {}


func _ready() -> void:
	if Session and Session.has_meta("editor_state"):
		var st: Dictionary = Session.get_meta("editor_state")
		Session.remove_meta("editor_state")
		_restore_editor_state(st)
	else:
		_init_grid(grid_cols, grid_rows)
	_check_cli_args()


func _get_brush_folder(b: Dictionary) -> String:
	if b.has("etype"):
		return EnemyDefs.get_folder(b["etype"])
	return b.get("sprite", "")


func _process(delta: float) -> void:
	if status_timer > 0.0:
		status_timer -= delta
		if status_timer <= 0.0:
			status_msg = ""
			queue_redraw()


func _set_status(msg: String) -> void:
	status_msg = msg
	status_timer = 3.5
	queue_redraw()


func _init_grid(cols: int, rows: int) -> void:
	var old_cells := cells.duplicate(true)
	var old_rows := grid_rows
	var old_cols := grid_cols

	grid_cols = cols
	grid_rows = rows
	cells.clear()

	for r in range(grid_rows):
		var row_arr: Array = []
		for c in range(grid_cols):
			if r < old_rows and c < old_cols and not old_cells.is_empty() and r < old_cells.size() and c < old_cells[r].size():
				row_arr.append(old_cells[r][c])
			elif r == 0 or r == grid_rows - 1 or c == 0 or c == grid_cols - 1:
				row_arr.append(0x0307)
			else:
				row_arr.append(0)
		cells.append(row_arr)

	# Ensure perimeter border walls on resize
	for c in range(grid_cols):
		cells[0][c] = 0x0307
		cells[grid_rows - 1][c] = 0x0307
	for r in range(grid_rows):
		cells[r][0] = 0x0307
		cells[r][grid_cols - 1] = 0x0307

	# Clamp spawns
	p1_spawn = Vector2i(clampi(p1_spawn.x, 1, grid_cols - 2), clampi(p1_spawn.y, 1, grid_rows - 2))
	p2_spawn = Vector2i(clampi(p2_spawn.x, 1, grid_cols - 2), clampi(p2_spawn.y, 1, grid_rows - 2))
	p3_spawn = Vector2i(clampi(p3_spawn.x, 1, grid_cols - 2), clampi(p3_spawn.y, 1, grid_rows - 2))

	queue_redraw()


func cycle_canvas_size() -> void:
	size_idx = (size_idx + 1) % SIZES.size()
	var s: Vector2i = SIZES[size_idx]
	_init_grid(s.x, s.y)
	_set_status("Canvas size: %dx%d" % [s.x, s.y])


var _FRAME_RE := RegEx.create_from_string("^f0*(\\d+)_\\d+x\\d+\\.png$")
var _folder_indices: Dictionary = {}

func _get_sprite(folder: String, frame: int) -> Texture2D:
	if folder == "":
		return null
	var key := "%s_%d" % [folder, frame]
	if _tex_cache.has(key):
		return _tex_cache[key]
	if not _folder_indices.has(folder):
		var idx: Dictionary = {}
		var dir_path := Session.ext_path("sprites/%s" % folder)
		var da := DirAccess.open(dir_path)
		if da != null:
			for f in da.get_files():
				var m := _FRAME_RE.search(f)
				if m != null:
					idx[int(m.get_string(1))] = dir_path.path_join(f)
		_folder_indices[folder] = idx
	var fidx: Dictionary = _folder_indices[folder]
	var target_frame: int = frame
	if not fidx.has(target_frame):
		for f in range(target_frame - 1, 0, -1):
			if fidx.has(f):
				target_frame = f
				break
		if not fidx.has(target_frame):
			for f in range(target_frame + 1, target_frame + 20):
				if fidx.has(f):
					target_frame = f
					break
	var path: String = fidx.get(target_frame, "")
	if path != "" and FileAccess.file_exists(path):
		var img := Image.load_from_file(path)
		if img != null:
			var tex := ImageTexture.create_from_image(img)
			_tex_cache[key] = tex
			return tex
	_tex_cache[key] = null
	return null


func _validate_map() -> Array[String]:
	var warnings: Array[String] = []
	if p1_spawn == p2_spawn:
		warnings.append("P1 & P2 spawns overlap at (%d, %d)" % [p1_spawn.x, p1_spawn.y])
	if has_p3 and (p1_spawn == p3_spawn or p2_spawn == p3_spawn):
		warnings.append("P3 spawn overlaps another player spawn")

	var has_key_univ := false
	var has_door_univ := false
	var has_key_p1 := false
	var has_door_p1 := false
	var has_key_p2 := false
	var has_door_p2 := false
	var has_key_p3 := false
	var has_door_p3 := false
	for r in range(grid_rows):
		for c in range(grid_cols):
			var t: int = cells[r][c] & 0xFFFF
			if t == 0x0907: has_key_univ = true
			elif t == 0x0901 or t == 0x0904: has_door_univ = true
			elif t == 0x0908: has_key_p1 = true
			elif t == 0x0902 or t == 0x0905: has_door_p1 = true
			elif t == 0x0909: has_key_p2 = true
			elif t == 0x0903 or t == 0x0906: has_door_p2 = true
			elif t == 0x0933: has_key_p3 = true
			elif t == 0x0934 or t == 0x0935: has_door_p3 = true

	if has_key_univ and not has_door_univ:
		warnings.append("Universal key placed but no door found")
	if has_door_univ and not has_key_univ:
		warnings.append("Universal door placed but no key found")
	if has_key_p1 and not has_door_p1:
		warnings.append("P1 Blue key placed but no Blue door found")
	if has_door_p1 and not has_key_p1:
		warnings.append("P1 Blue door placed but no Blue key found")
	if has_key_p2 and not has_door_p2:
		warnings.append("P2 Green key placed but no Green door found")
	if has_door_p2 and not has_key_p2:
		warnings.append("P2 Green door placed but no Green key found")
	if has_key_p3 and not has_door_p3:
		warnings.append("P3 Red key placed but no Red door found")
	if has_door_p3 and not has_key_p3:
		warnings.append("P3 Red door placed but no Red key found")

	return warnings


func _save_editor_state() -> Dictionary:
	return {
		"cells": cells.duplicate(true),
		"grid_cols": grid_cols,
		"grid_rows": grid_rows,
		"p1_spawn": p1_spawn,
		"p2_spawn": p2_spawn,
		"p3_spawn": p3_spawn,
		"vs_spawns": vs_spawns.duplicate(),
		"has_p3": has_p3,
		"default_mode": default_mode,
		"victory_rule": victory_rule,
		"friendly_fire": friendly_fire,
		"starting_lives": starting_lives,
		"playtest_players": playtest_players,
		"bonus_time": bonus_time,
		"map_name": map_name,
		"brush_idx": brush_idx,
		"cursor_cell": cursor_cell,
	}


func _restore_editor_state(st: Dictionary) -> void:
	if st.is_empty():
		return
	grid_cols = st.get("grid_cols", 19)
	grid_rows = st.get("grid_rows", 13)
	cells = st.get("cells", []).duplicate(true)
	p1_spawn = st.get("p1_spawn", Vector2i(2, 2))
	p2_spawn = st.get("p2_spawn", Vector2i(16, 2))
	p3_spawn = st.get("p3_spawn", Vector2i(9, 2))
	vs_spawns = st.get("vs_spawns", [Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0), Vector2i(0, 0)]).duplicate()
	has_p3 = st.get("has_p3", false)
	default_mode = st.get("default_mode", 0)
	victory_rule = st.get("victory_rule", 0)
	friendly_fire = st.get("friendly_fire", false)
	starting_lives = st.get("starting_lives", 3)
	playtest_players = st.get("playtest_players", 2)
	bonus_time = st.get("bonus_time", 6000)
	map_name = st.get("map_name", "custom_map")
	brush_idx = st.get("brush_idx", 1)
	cursor_cell = st.get("cursor_cell", Vector2i(0, 0))
	if brush_idx >= 0 and brush_idx < BRUSHES.size():
		current_brush = BRUSHES[brush_idx]["tile"]
	if grid_cols == 38 and grid_rows == 26:
		size_idx = 2
	elif grid_cols == 28 and grid_rows == 19:
		size_idx = 1
	else:
		size_idx = 0
	queue_redraw()


func _check_cli_args() -> void:
	var all_args: Array = OS.get_cmdline_user_args()
	all_args.append_array(OS.get_cmdline_args())
	for arg in all_args:
		if arg == "--test-editor":
			_run_self_test()
			get_tree().quit(0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		push_error("SELF-TEST FAIL: " + msg)
		get_tree().quit(1)


func _run_self_test() -> void:
	print("--- Running MapEditor Self-Test ---")
	var orig_state := _save_editor_state()
	var orig_status := status_msg
	var orig_players := playtest_players

	_init_grid(38, 26)
	p1_spawn = Vector2i(2, 2)
	p2_spawn = Vector2i(35, 2)
	p3_spawn = Vector2i(19, 2)
	vs_spawns[0] = Vector2i(10, 5)
	vs_spawns[1] = Vector2i(20, 5)
	vs_spawns[2] = Vector2i(10, 20)
	vs_spawns[3] = Vector2i(20, 20)
	has_p3 = true
	friendly_fire = true
	victory_rule = 1
	starting_lives = 5
	default_mode = 2
	playtest_players = 3

	cells[25][37] = 0x0307 # Solid wall
	cells[10][10] = 0x0207 # Breakable
	cells[5][5] = 0x090A   # Coin

	var raw := serialize_to_bord()
	_check(raw.size() > 24, "Serialized size too small")
	_check(raw.size() >= 48 and raw[raw.size() - 24] == 0x45 and raw[raw.size() - 23] == 0x58 and raw[raw.size() - 22] == 0x54 and raw[raw.size() - 21] == 0x31, "EXT1 trailer missing")

	# Save to test file
	var test_path := "user://custom_maps/test_roundtrip.bord"
	DirAccess.make_dir_recursive_absolute("user://custom_maps")
	var f := FileAccess.open(test_path, FileAccess.WRITE)
	_check(f != null, "Cannot write test_roundtrip.bord")
	f.store_buffer(raw)
	f.close()

	# Reset state
	_init_grid(19, 13)
	has_p3 = false

	# Reload
	var reloaded := FileAccess.get_file_as_bytes(test_path)
	var ok := load_from_bord(reloaded)
	_check(ok, "load_from_bord failed")
	_check(grid_cols == 38, "grid_cols mismatch: %d" % grid_cols)
	_check(grid_rows == 26, "grid_rows mismatch: %d" % grid_rows)
	_check(has_p3 == true, "has_p3 mismatch")
	_check(friendly_fire == true, "friendly_fire mismatch")
	_check(victory_rule == 1, "victory_rule mismatch")
	_check(starting_lives == 5, "starting_lives mismatch")
	_check(default_mode == 2, "default_mode mismatch")
	_check(cells[25][37] == 0x0307, "cell (37, 25) mismatch")
	_check(cells[10][10] == 0x0207, "cell (10, 10) mismatch")
	_check(cells[5][5] == 0x090A, "cell (5, 5) mismatch")
	_check(p3_spawn == Vector2i(19, 2), "p3_spawn mismatch")
	_check(vs_spawns[0] == Vector2i(10, 5), "vs_spawns[0] mismatch")
	_check(vs_spawns[1] == Vector2i(20, 5), "vs_spawns[1] mismatch")

	# Clean up test file so self-test leaves no files behind
	if FileAccess.file_exists(test_path):
		DirAccess.remove_absolute(test_path)

	# Verify in-memory state persistence
	var saved_dict := _save_editor_state()
	_check(saved_dict.get("playtest_players") == 3, "persistence playtest_players mismatch")
	_init_grid(19, 13)
	playtest_players = 1
	_restore_editor_state(saved_dict)
	_check(grid_cols == 38, "persistence grid_cols mismatch")
	_check(cells[10][10] == 0x0207, "persistence cells mismatch")
	_check(playtest_players == 3, "restore playtest_players mismatch")

	# Verify Live3D.POST_SHADER compiles cleanly
	var sh := Shader.new()
	sh.code = Live3D.POST_SHADER
	_check(sh.code.count("{") == sh.code.count("}"), "Live3D.POST_SHADER unbalanced braces")

	# Verify all Enemy brushes map to valid BORD badguy IDs, have valid textures, match SoiCore enemy_type, and resolve in _draw
	var test_core := SoiCore.new()
	for b in BRUSHES:
		if b["cat"] == "Enemies":
			var etype: int = b.get("etype", 0)
			var folder: String = _get_brush_folder(b)
			var frame: int = b.get("frame", 0)

			# 1. Sprite exists and loads
			var spr := _get_sprite(folder, frame)
			_check(spr != null, "Sprite missing for enemy brush %s in folder %s frame %d" % [b["name"], folder, frame])

			# 2. test_core.enemy_type(0) == etype for default facing
			_init_grid(19, 13)
			has_p3 = false
			cells[6][9] = int(b["tile"])
			var ebord := serialize_to_bord()
			test_core.init(1)
			test_core.load_level(ebord)
			_check(test_core.enemy_count() >= 1, "Enemy brush %s (0x%X) did not spawn in SoiCore" % [b["name"], int(b["tile"])])
			_check(test_core.enemy_type(0) == etype, "Enemy brush %s default facing enemy_type(0) was %d, expected %d" % [b["name"], test_core.enemy_type(0), etype])

			# 2b. test_core.enemy_type(0) == etype for 0x0500 facing (left)
			_init_grid(19, 13)
			cells[6][9] = (int(b["tile"]) & ~0xFF00) | 0x0500
			ebord = serialize_to_bord()
			test_core.init(1)
			test_core.load_level(ebord)
			_check(test_core.enemy_count() >= 1, "Enemy brush %s left facing did not spawn in SoiCore" % b["name"])
			_check(test_core.enemy_type(0) == etype, "Enemy brush %s left facing enemy_type(0) was %d, expected %d" % [b["name"], test_core.enemy_type(0), etype])

			# 3. the _draw lookup resolves the same folder
			var cell_val: int = int(b["tile"])
			var tile_id: int = cell_val & 0xFFFF
			var resolved_folder := ""
			for ob in BRUSHES:
				if ob["tile"] == cell_val or ob["tile"] == tile_id or ((cell_val & 0x0400) != 0 and (int(ob["tile"]) & 0x0400) != 0 and (int(ob["tile"]) & 0xFF) == (cell_val & 0xFF)):
					resolved_folder = _get_brush_folder(ob)
					break
			_check(resolved_folder == folder, "Draw lookup folder %s != %s for %s" % [resolved_folder, folder, b["name"]])

	# Verify [F] enemy facing toggle updates bits 8..15 (0x0500 / 0x0600 / 0x0700)
	_init_grid(19, 13)
	cells[5][5] = 0x0609
	hover_cell = Vector2i(5, 5)
	_cycle_hovered_enemy_facing()
	_check(((cells[5][5] >> 8) & 0xFF) in [0x05, 0x06, 0x07], "Enemy facing bits not in 0x05..0x07")

	# Test Session controller claiming helpers directly (UI-7, UI-8)
	if Session:
		var orig_devs: Array = Session.player_device.duplicate()
		var orig_np: int = Session.num_players
		Session.player_device = [-1, -2]
		Session.num_players = 2
		var claimed_slot := Session.claim_controller_slot(0)
		_check(claimed_slot == 0 and Session.player_device[0] == 0, "Session.claim_controller_slot(0) failed")
		var unused_kb := Session.get_unused_keyboard_id()
		_check(unused_kb in [-1, -3], "Session.get_unused_keyboard_id returned invalid %d" % unused_kb)
		Session.fallback_disconnected_pads([])
		_check(Session.player_device[0] < 0, "Session.fallback_disconnected_pads failed to revert pad to keyboard")
		Session.player_device = orig_devs
		Session.num_players = orig_np

	# Verify Session.start_campaign() clears custom_board_bytes meta
	if Session:
		Session.set_meta("custom_board_bytes", raw)
		Session.start_campaign()
		_check(not Session.has_meta("custom_board_bytes"), "start_campaign() leaked custom_board_bytes meta")

	# Verify join_code_to_ip returns bare IP even when port != 7777
	var jc := RollbackNet.ip_to_join_code("127.0.0.1", 8888)
	_check(RollbackNet.join_code_to_ip(jc) == "127.0.0.1", "join_code_to_ip included port")
	_check(RollbackNet.join_code_to_port(jc) == 8888, "join_code_to_port mismatch")

	# Restore editor state afterwards
	_restore_editor_state(orig_state)
	status_msg = orig_status
	playtest_players = orig_players

	print("MapEditor CLI self-test: PASS")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			playtest_in_memory()
			get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			playtest_in_memory()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_S and event.ctrl_pressed:
			save_to_default_file()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_O and event.ctrl_pressed:
			load_from_default_file()
			get_viewport().set_input_as_handled()
		elif (event.keycode == KEY_G or event.keycode == KEY_C) and not event.ctrl_pressed:
			cycle_canvas_size()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_F and not event.ctrl_pressed:
			_cycle_hovered_enemy_facing()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_P and not event.ctrl_pressed:
			var max_p := 3 if has_p3 else 2
			playtest_players = 1 if playtest_players >= max_p else playtest_players + 1
			_set_status("Playtest players: %dP" % playtest_players)
			queue_redraw()
			get_viewport().set_input_as_handled()
		elif event.keycode == KEY_BRACKETLEFT:
			_set_brush(brush_idx - 1)
		elif event.keycode == KEY_BRACKETRIGHT:
			_set_brush(brush_idx + 1)
		elif event.keycode >= KEY_1 and event.keycode <= KEY_9:
			_set_brush(event.keycode - KEY_0)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_mouse_down = event.pressed
			if is_mouse_down:
				if event.position.y < 48.0:
					_handle_hud_click(event.position)
				else:
					_paint_at(event.position)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_right_mouse_down = event.pressed
			if is_right_mouse_down and event.position.y >= 48.0:
				_erase_at(event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_brush(brush_idx - 1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_brush(brush_idx + 1)
	elif event is InputEventMouseMotion:
		cursor_cell = _pos_to_cell(event.position)
		hover_cell = cursor_cell
		if is_mouse_down and event.position.y >= 48.0:
			_paint_at(event.position)
		elif is_right_mouse_down and event.position.y >= 48.0:
			_erase_at(event.position)


func _handle_hud_click(pos: Vector2) -> void:
	if pos.x < 245.0:
		_set_brush(brush_idx + 1)
	elif pos.y < 24.0:
		if pos.x >= 248.0 and pos.x <= 320.0:
			cycle_canvas_size()
		elif pos.x >= 324.0 and pos.x <= 372.0:
			save_to_default_file()
		elif pos.x >= 376.0 and pos.x <= 424.0:
			load_from_default_file()
		elif pos.x >= 428.0 and pos.x <= 496.0:
			playtest_in_memory()
		elif pos.x >= 500.0 and pos.x <= 548.0:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		if pos.x >= 248.0 and pos.x <= 316.0:
			default_mode = (default_mode + 1) % 3
			var mnames := ["Co-op", "Compete", "Versus"]
			_set_status("Mode: %s" % mnames[default_mode])
			queue_redraw()
		elif pos.x >= 320.0 and pos.x <= 388.0:
			victory_rule = (victory_rule + 1) % 3
			var rnames := ["Lives", "Score", "Door"]
			_set_status("Rule: %s" % rnames[victory_rule])
			queue_redraw()
		elif pos.x >= 392.0 and pos.x <= 446.0:
			friendly_fire = not friendly_fire
			_set_status("Friendly Fire: %s" % ("On" if friendly_fire else "Off"))
			queue_redraw()
		elif pos.x >= 450.0 and pos.x <= 496.0:
			starting_lives = (starting_lives % 9) + 1
			_set_status("Starting Lives: %d" % starting_lives)
			queue_redraw()
		elif pos.x >= 500.0 and pos.x <= 558.0:
			_cycle_hovered_enemy_facing()


func _cycle_hovered_enemy_facing() -> void:
	var c := hover_cell
	if c.x >= 0 and c.x < grid_cols and c.y >= 0 and c.y < grid_rows:
		var v: int = cells[c.y][c.x]
		if (v & 0x0400) != 0:
			var current_dir := (v >> 8) & 0xFF
			var next_dir := 0x05
			if current_dir == 0x05:
				next_dir = 0x06
			elif current_dir == 0x06:
				next_dir = 0x07
			elif current_dir == 0x07:
				next_dir = 0x05
			cells[c.y][c.x] = (v & ~0xFF00) | (next_dir << 8)
			var dname := "Left" if next_dir == 0x05 else ("Right" if next_dir == 0x06 else "Alt")
			_set_status("Enemy Facing: %s" % dname)
			queue_redraw()
			return
	enemy_facing_left = not enemy_facing_left
	_set_status("Enemy Facing: %s [F]" % ("Left" if enemy_facing_left else "Right"))
	queue_redraw()


func _set_brush(idx: int) -> void:
	brush_idx = posmod(idx, BRUSHES.size())
	current_brush = BRUSHES[brush_idx]["tile"]
	_set_status("[%s] %s" % [BRUSHES[brush_idx]["cat"], BRUSHES[brush_idx]["name"]])


func _paint_at(pos: Vector2) -> void:
	var cell_coords := _pos_to_cell(pos)
	if cell_coords.x < 0 or cell_coords.x >= grid_cols or cell_coords.y < 0 or cell_coords.y >= grid_rows:
		return

	if current_brush == -1:
		p1_spawn = cell_coords
	elif current_brush == -2:
		p2_spawn = cell_coords
	elif current_brush == -3:
		p3_spawn = cell_coords
		has_p3 = true
	elif current_brush >= -7 and current_brush <= -4:
		var vs_idx: int = -(current_brush + 4)
		vs_spawns[vs_idx] = cell_coords
	else:
		var tile_to_set: int = current_brush
		var cur_item: Dictionary = BRUSHES[brush_idx]
		if cur_item["cat"] == "Enemies" or ((current_brush & 0x0400) != 0):
			var brush_dir: int = (current_brush >> 8) & 0xFF
			if enemy_facing_left:
				tile_to_set = (current_brush & ~0xFF00) | 0x0500
			else:
				var dir_byte := 0x07 if brush_dir == 0x07 else 0x06
				tile_to_set = (current_brush & ~0xFF00) | (dir_byte << 8)
		cells[cell_coords.y][cell_coords.x] = tile_to_set


	queue_redraw()


func _erase_at(pos: Vector2) -> void:
	var cell_coords := _pos_to_cell(pos)
	if cell_coords.x >= 0 and cell_coords.x < grid_cols and cell_coords.y >= 0 and cell_coords.y < grid_rows:
		cells[cell_coords.y][cell_coords.x] = 0
		if has_p3 and p3_spawn == cell_coords:
			has_p3 = false
		for i in range(vs_spawns.size()):
			if vs_spawns[i] == cell_coords:
				vs_spawns[i] = Vector2i(0, 0)
		queue_redraw()


func _pos_to_cell(pos: Vector2) -> Vector2i:
	var hud_h := 48.0
	if pos.y < hud_h:
		return Vector2i(-1, -1)
	var playfield_w := float(get_viewport_rect().size.x)
	var playfield_h := float(get_viewport_rect().size.y) - hud_h
	var cell_w := playfield_w / float(grid_cols)
	var cell_h := playfield_h / float(grid_rows)
	var c := int(pos.x / cell_w)
	var r := int((pos.y - hud_h) / cell_h)
	return Vector2i(clampi(c, 0, grid_cols - 1), clampi(r, 0, grid_rows - 1))


func _draw() -> void:
	var hud_h := 48.0
	var vp_size := get_viewport_rect().size

	# 1. Draw HUD bar (2-row layout fitting within 640px width)
	draw_rect(Rect2(0, 0, vp_size.x, hud_h), Color(0.12, 0.12, 0.16))
	var font := ThemeDB.fallback_font

	# Brush Info & Sprite Preview (x=8..244)
	var cur_item: Dictionary = BRUSHES[brush_idx]
	draw_string(font, Vector2(8, 19), "[%s] %s" % [cur_item["cat"], cur_item["name"]], HORIZONTAL_ALIGNMENT_LEFT, 236, 12, Color.YELLOW)
	draw_string(font, Vector2(8, 38), "[1..9/Wheel/[]: Brush]", HORIZONTAL_ALIGNMENT_LEFT, 236, 10, Color(0.7, 0.7, 0.7))

	# Row 1 (y=3..22): Size, Save, Load, Play, Exit
	draw_rect(Rect2(248, 3, 72, 19), Color(0.22, 0.22, 0.28))
	draw_rect(Rect2(248, 3, 72, 19), Color(0.4, 0.4, 0.5), false, 1.0)
	draw_string(font, Vector2(252, 16), "%dx%d [G]" % [grid_cols, grid_rows], HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color.WHITE)

	draw_rect(Rect2(324, 3, 48, 19), Color(0.18, 0.28, 0.22))
	draw_rect(Rect2(324, 3, 48, 19), Color(0.3, 0.5, 0.35), false, 1.0)
	draw_string(font, Vector2(332, 16), "Save", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.8, 1.0, 0.8))

	draw_rect(Rect2(376, 3, 48, 19), Color(0.22, 0.22, 0.32))
	draw_rect(Rect2(376, 3, 48, 19), Color(0.4, 0.4, 0.6), false, 1.0)
	draw_string(font, Vector2(384, 16), "Load", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.8, 0.8, 1.0))

	draw_rect(Rect2(428, 3, 68, 19), Color(0.28, 0.22, 0.18))
	draw_rect(Rect2(428, 3, 68, 19), Color(0.6, 0.45, 0.3), false, 1.0)
	draw_string(font, Vector2(432, 16), "Play:%dP [Tab]" % playtest_players, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1.0, 0.9, 0.7))

	draw_rect(Rect2(500, 3, 48, 19), Color(0.28, 0.18, 0.18))
	draw_rect(Rect2(500, 3, 48, 19), Color(0.6, 0.3, 0.3), false, 1.0)
	draw_string(font, Vector2(510, 16), "Exit", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1.0, 0.8, 0.8))

	# Row 2 (y=25..44): Mode, Rule, FF, Lives, Face
	draw_rect(Rect2(248, 25, 68, 19), Color(0.2, 0.2, 0.3))
	draw_rect(Rect2(248, 25, 68, 19), Color(0.4, 0.4, 0.6), false, 1.0)
	var mnames := ["Co-op", "Compete", "Versus"]
	draw_string(font, Vector2(252, 38), mnames[default_mode], HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.9, 0.9, 1.0))

	draw_rect(Rect2(320, 25, 68, 19), Color(0.25, 0.2, 0.25))
	draw_rect(Rect2(320, 25, 68, 19), Color(0.5, 0.4, 0.5), false, 1.0)
	var rnames := ["Lives", "Score", "Door"]
	draw_string(font, Vector2(324, 38), "Win:" + rnames[victory_rule], HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1.0, 0.8, 1.0))

	draw_rect(Rect2(392, 25, 54, 19), Color(0.3, 0.2, 0.2) if friendly_fire else Color(0.18, 0.22, 0.2))
	draw_rect(Rect2(392, 25, 54, 19), Color(0.6, 0.3, 0.3) if friendly_fire else Color(0.35, 0.45, 0.35), false, 1.0)
	draw_string(font, Vector2(396, 38), "FF:" + ("On" if friendly_fire else "Off"), HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1.0, 0.7, 0.7) if friendly_fire else Color(0.8, 0.9, 0.8))

	draw_rect(Rect2(450, 25, 46, 19), Color(0.2, 0.25, 0.2))
	draw_rect(Rect2(450, 25, 46, 19), Color(0.4, 0.5, 0.4), false, 1.0)
	draw_string(font, Vector2(456, 38), "L:%d" % starting_lives, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.8, 1.0, 0.8))

	draw_rect(Rect2(500, 25, 58, 19), Color(0.22, 0.22, 0.26))
	draw_rect(Rect2(500, 25, 58, 19), Color(0.45, 0.45, 0.5), false, 1.0)
	draw_string(font, Vector2(504, 38), "Face:" + ("L" if enemy_facing_left else "R"), HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color.WHITE)

	# 2. Draw Playfield Grid
	var playfield_w := vp_size.x
	var playfield_h := vp_size.y - hud_h
	var cell_w := playfield_w / float(grid_cols)
	var cell_h := playfield_h / float(grid_rows)

	# Background black field
	draw_rect(Rect2(0, hud_h, playfield_w, playfield_h), Color.BLACK)

	for r in range(grid_rows):
		for c in range(grid_cols):
			var rect := Rect2(c * cell_w, hud_h + r * cell_h, cell_w, cell_h)
			var cell_val: int = cells[r][c]
			var tile_id: int = cell_val & 0xFFFF
			if cell_val != 0:
				var spr: Texture2D = null
				var spr_folder := ""
				var spr_frame := 0
				for b in BRUSHES:
					if b["tile"] == cell_val or b["tile"] == tile_id or ((cell_val & 0x0400) != 0 and (int(b["tile"]) & 0x0400) != 0 and (int(b["tile"]) & 0xFF) == (cell_val & 0xFF)):
						spr_folder = _get_brush_folder(b)
						spr_frame = b["frame"]
						break
				if spr_folder != "":
					spr = _get_sprite(spr_folder, spr_frame)

				if spr != null:
					draw_texture_rect(spr, rect, false)
				else:
					if tile_id == 0x0307:
						draw_rect(rect, Color(0.65, 0.65, 0.7)) # Solid wall
					elif tile_id == 0x0207:
						draw_rect(rect, Color(0.7, 0.5, 0.3)) # Breakable
					elif tile_id == 0x0197:
						draw_rect(rect, Color(0.4, 0.6, 0.8)) # Ladder
					elif tile_id == 0x0387:
						draw_rect(rect, Color(0.8, 0.9, 1.0)) # Ice
					elif tile_id == 0x0907 or tile_id == 0x0933:
						draw_rect(rect, Color(0.9, 0.2, 0.2)) # Key
					elif tile_id == 0x0904 or tile_id == 0x0934 or tile_id == 0x0901 or tile_id == 0x0935:
						draw_rect(rect, Color(0.5, 0.3, 0.15)) # Lock/Door
					else:
						draw_rect(rect, Color(1.0, 0.85, 0.2)) # Pickup/Coin
			draw_rect(rect, Color(0.2, 0.2, 0.25, 0.25), false, 1.0) # Grid line

	# 3. Draw Player & VS Spawns
	draw_circle(Vector2(p1_spawn.x * cell_w + cell_w * 0.5, hud_h + p1_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.DODGER_BLUE)
	draw_circle(Vector2(p2_spawn.x * cell_w + cell_w * 0.5, hud_h + p2_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.LIME_GREEN)
	if has_p3:
		draw_circle(Vector2(p3_spawn.x * cell_w + cell_w * 0.5, hud_h + p3_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.CRIMSON)

	for i in range(4):
		var vs: Vector2i = vs_spawns[i]
		if vs.x > 0 or vs.y > 0:
			draw_circle(Vector2(vs.x * cell_w + cell_w * 0.5, hud_h + vs.y * cell_h + cell_h * 0.5), cell_w * 0.25, Color.ORANGE)

	# 4. Draw Validation Banner if warnings exist
	var warnings := _validate_map()
	if warnings.size() > 0:
		draw_rect(Rect2(0, vp_size.y - 24, vp_size.x, 24), Color(0.4, 0.1, 0.1, 0.85))
		draw_string(font, Vector2(16, vp_size.y - 8), "WARNING: %s" % warnings[0], HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(1.0, 0.9, 0.4))

	# 5. Status toast message as playfield overlay
	if status_msg != "":
		var toast_w := 340.0
		var toast_h := 24.0
		var toast_x := (vp_size.x - toast_w) * 0.5
		var toast_y := hud_h + 10.0
		draw_rect(Rect2(toast_x, toast_y, toast_w, toast_h), Color(0.08, 0.08, 0.12, 0.85))
		draw_rect(Rect2(toast_x, toast_y, toast_w, toast_h), Color(0.3, 0.6, 0.9, 0.8), false, 1.0)
		draw_string(font, Vector2(toast_x, toast_y + 16.0), status_msg, HORIZONTAL_ALIGNMENT_CENTER, int(toast_w), 11, Color(0.4, 1.0, 0.6))


# --- Strict Big-Endian Byte Helpers ---

func _put_be16(arr: PackedByteArray, offset: int, val: int) -> void:
	arr[offset] = (val >> 8) & 0xFF
	arr[offset + 1] = val & 0xFF


func _put_be32(arr: PackedByteArray, offset: int, val: int) -> void:
	arr[offset] = (val >> 24) & 0xFF
	arr[offset + 1] = (val >> 16) & 0xFF
	arr[offset + 2] = (val >> 8) & 0xFF
	arr[offset + 3] = val & 0xFF


func serialize_to_bord() -> PackedByteArray:
	var out := PackedByteArray()
	out.resize(24)

	# Header 24 bytes (12x uint16 big-endian)
	_put_be16(out, 0, 0)                  # flags
	_put_be16(out, 2, 0x026D)             # p1_block
	_put_be16(out, 4, 0x0273)             # p2_block
	_put_be16(out, 6, p1_spawn.x)         # p1_x
	_put_be16(out, 8, p1_spawn.y)         # p1_y
	_put_be16(out, 10, p2_spawn.x)        # p2_x
	_put_be16(out, 12, p2_spawn.y)        # p2_y
	_put_be16(out, 14, bonus_time)        # bonus
	_put_be16(out, 16, 0)                 # pct_u
	_put_be16(out, 18, 0)                 # tb
	_put_be16(out, 20, 0)                 # pb
	_put_be16(out, 22, 5000)              # reward

	# Tile records (grouped by tile_id)
	var tile_groups := {}
	for r in range(grid_rows):
		for c in range(grid_cols):
			var t: int = cells[r][c]
			if t != 0:
				if not tile_groups.has(t):
					tile_groups[t] = []
				tile_groups[t].append(Vector2i(c, r))

	for t in tile_groups:
		var cur_len := out.size()
		out.resize(cur_len + 4)
		_put_be32(out, cur_len, t)
		for pt in tile_groups[t]:
			out.append(pt.x)
			out.append(pt.y)
		out.append(100)
		out.append(100)

	# Terminator 0x00000000
	var term_idx := out.size()
	out.resize(term_idx + 4)
	_put_be32(out, term_idx, 0)

	# EXT1 trailer (24 bytes)
	var ext_idx := out.size()
	out.resize(ext_idx + 24)
	out[ext_idx + 0] = 0x45 # 'E'
	out[ext_idx + 1] = 0x58 # 'X'
	out[ext_idx + 2] = 0x54 # 'T'
	out[ext_idx + 3] = 0x31 # '1'
	out[ext_idx + 4] = 1    # version 1
	var flags := 0
	if has_p3: flags |= 1
	if friendly_fire: flags |= 2
	if grid_cols > 19 or grid_rows > 13: flags |= 4
	flags |= (default_mode & 3) << 3
	out[ext_idx + 5] = flags
	out[ext_idx + 6] = grid_cols
	out[ext_idx + 7] = grid_rows
	out[ext_idx + 8] = p3_spawn.x if has_p3 else 0
	out[ext_idx + 9] = p3_spawn.y if has_p3 else 0
	_put_be16(out, ext_idx + 10, 0x020D) # p3_block

	# 4 extra vs spawns (8 bytes)
	for i in range(4):
		var sp: Vector2i = vs_spawns[i] if i < vs_spawns.size() else Vector2i(0, 0)
		out[ext_idx + 12 + i * 2] = sp.x
		out[ext_idx + 12 + i * 2 + 1] = sp.y

	out[ext_idx + 20] = victory_rule
	out[ext_idx + 21] = starting_lives

	# CRC-16-CCITT (polynomial 0x1021, init 0xFFFF)
	var crc := 0xFFFF
	for i in range(22):
		crc ^= (out[ext_idx + i] << 8)
		for _b in range(8):
			if crc & 0x8000:
				crc = ((crc << 1) ^ 0x1021) & 0xFFFF
			else:
				crc = (crc << 1) & 0xFFFF
	_put_be16(out, ext_idx + 22, crc)

	return out


func load_from_bord(raw: PackedByteArray) -> bool:
	if raw.size() < 24:
		return false

	var sp1_x := int((raw[6] << 8) | raw[7])
	var sp1_y := int((raw[8] << 8) | raw[9])
	var sp2_x := int((raw[10] << 8) | raw[11])
	var sp2_y := int((raw[12] << 8) | raw[13])
	bonus_time = int((raw[14] << 8) | raw[15])

	var cols := 19
	var rows := 13
	var ext_has_p3 := false
	var sp3_x := 9
	var sp3_y := 2

	# Scan for EXT1 trailer
	var term_off := -1
	var off := 24
	while off + 4 <= raw.size():
		var t := (raw[off] << 24) | (raw[off + 1] << 16) | (raw[off + 2] << 8) | raw[off + 3]
		off += 4
		if t == 0:
			term_off = off
			break
		while off + 2 <= raw.size():
			var c := raw[off]
			var r := raw[off + 1]
			off += 2
			if c == 100 and r == 100:
				break

	if term_off >= 0:
		var ext_idx := -1
		if term_off + 24 <= raw.size() and raw[term_off] == 0x45 and raw[term_off + 1] == 0x58 and raw[term_off + 2] == 0x54 and raw[term_off + 3] == 0x31:
			ext_idx = term_off
		elif term_off + 26 <= raw.size() and raw[term_off + 2] == 0x45 and raw[term_off + 3] == 0x58 and raw[term_off + 4] == 0x54 and raw[term_off + 5] == 0x31:
			ext_idx = term_off + 2

		if ext_idx >= 0:
			var calc_crc := 0xFFFF
			for i in range(22):
				calc_crc ^= (raw[ext_idx + i] << 8)
				for _b in range(8):
					if calc_crc & 0x8000:
						calc_crc = ((calc_crc << 1) ^ 0x1021) & 0xFFFF
					else:
						calc_crc = (calc_crc << 1) & 0xFFFF
			var got_crc := (raw[ext_idx + 22] << 8) | raw[ext_idx + 23]
			if calc_crc == got_crc or got_crc == 0:
				var flags := raw[ext_idx + 5]
				cols = clampi(raw[ext_idx + 6], 19, 38)
				rows = clampi(raw[ext_idx + 7], 13, 26)
				ext_has_p3 = bool(flags & 1)
				friendly_fire = bool(flags & 2)
				default_mode = (flags >> 3) & 3
				sp3_x = raw[ext_idx + 8]
				sp3_y = raw[ext_idx + 9]
				for i in range(4):
					vs_spawns[i] = Vector2i(raw[ext_idx + 12 + i * 2], raw[ext_idx + 12 + i * 2 + 1])
				victory_rule = raw[ext_idx + 20]
				starting_lives = raw[ext_idx + 21]

	# Set canvas dimensions
	grid_cols = cols
	grid_rows = rows
	if grid_cols == 38 and grid_rows == 26:
		size_idx = 2
	elif grid_cols == 28 and grid_rows == 19:
		size_idx = 1
	else:
		size_idx = 0

	p1_spawn = Vector2i(sp1_x, sp1_y)
	p2_spawn = Vector2i(sp2_x, sp2_y)
	p3_spawn = Vector2i(sp3_x, sp3_y)
	has_p3 = ext_has_p3

	# Re-init empty cells
	cells.clear()
	for r in range(grid_rows):
		var row_arr: Array = []
		for c in range(grid_cols):
			row_arr.append(0)
		cells.append(row_arr)

	# Read tile records into cells
	off = 24
	while off + 4 <= raw.size():
		var t := (raw[off] << 24) | (raw[off + 1] << 16) | (raw[off + 2] << 8) | raw[off + 3]
		off += 4
		if t == 0:
			break
		while off + 2 <= raw.size():
			var c := raw[off]
			var r := raw[off + 1]
			off += 2
			if c == 100 and r == 100:
				break
			if r < grid_rows and c < grid_cols:
				cells[r][c] = t

	queue_redraw()
	return true


func _confirm_or_proceed(action_name: String, callback: Callable) -> void:
	var warnings := _validate_map()
	if warnings.is_empty():
		callback.call()
		return
	var dlg := ConfirmationDialog.new()
	dlg.title = "Warning: Map Has Issues"
	dlg.dialog_text = "%s anyway?\n- %s" % [action_name, "\n- ".join(warnings)]
	dlg.confirmed.connect(callback)
	dlg.dialog_hide.connect(func() -> void: dlg.queue_free())
	add_child(dlg)
	dlg.popup_centered()


func save_to_default_file() -> void:
	var warnings := _validate_map()
	if warnings.size() > 0:
		_confirm_or_proceed("Save map with warnings", func() -> void: _prompt_save_as())
		return
	_prompt_save_as()


func _prompt_save_as() -> void:
	var dlg := ConfirmationDialog.new()
	dlg.title = "Save Map"
	var vbox := VBoxContainer.new()
	var lbl := Label.new()
	lbl.text = "Map name:"
	vbox.add_child(lbl)
	var le := LineEdit.new()
	le.text = map_name
	vbox.add_child(le)
	dlg.add_child(vbox)
	dlg.confirmed.connect(func() -> void:
		var fname := le.text.strip_edges()
		if fname.ends_with(".bord"):
			fname = fname.left(fname.length() - 5)
		var valid := fname.validate_filename()
		if valid == "":
			valid = "custom_map"
		map_name = valid
		save_to_file("user://custom_maps/%s.bord" % map_name)
	)
	dlg.dialog_hide.connect(func() -> void: dlg.queue_free())
	add_child(dlg)
	dlg.popup_centered(Vector2i(280, 100))
	le.select_all()
	le.grab_focus()


func save_to_file(path: String) -> bool:
	var dir := path.get_base_dir()
	DirAccess.make_dir_recursive_absolute(dir)
	var raw := serialize_to_bord()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f != null:
		f.store_buffer(raw)
		f.close()
		_set_status("Saved to %s" % path)
		print("Map editor saved: %s (%d bytes)" % [path, raw.size()])
		return true
	else:
		_set_status("Error saving map")
		return false


func load_from_default_file() -> void:
	_show_open_dialog()


func _show_open_dialog() -> void:
	var pop := PopupMenu.new()
	var dir := "user://custom_maps"
	var maps: Array[String] = []
	if DirAccess.dir_exists_absolute(dir):
		var d := DirAccess.open(dir)
		if d != null:
			d.list_dir_begin()
			var fn := d.get_next()
			while fn != "":
				if fn.ends_with(".bord") and not d.current_is_dir():
					maps.append(fn)
				fn = d.get_next()
			d.list_dir_end()
	maps.sort()
	if maps.is_empty():
		pop.add_item("No custom maps found in " + dir, 0)
		pop.set_item_disabled(0, true)
	else:
		for i in range(maps.size()):
			pop.add_item(maps[i], i + 1)
	pop.id_pressed.connect(func(id: int) -> void:
		if id > 0 and id <= maps.size():
			var map_file: String = maps[id - 1]
			var map_path: String = dir.path_join(map_file)
			var raw: PackedByteArray = FileAccess.get_file_as_bytes(map_path)
			if load_from_bord(raw):
				map_name = map_file.get_basename()
				_set_status("Loaded %s" % map_file)
				print("Map editor loaded: %s (%d bytes)" % [map_path, raw.size()])
			else:
				_set_status("Error parsing map file")
	)
	pop.popup_hide.connect(func() -> void:
		pop.queue_free()
	)
	add_child(pop)
	pop.popup_centered(Vector2i(240, 200))


func playtest_in_memory() -> void:
	var warnings := _validate_map()
	if warnings.size() > 0:
		_confirm_or_proceed("Playtest with warnings", func() -> void: _do_playtest())
		return
	_do_playtest()


func _do_playtest() -> void:
	var raw := serialize_to_bord()
	if Session:
		Session.set_meta("custom_board_bytes", raw)
		Session.set_meta("editor_return", true)
		Session.set_meta("editor_state", _save_editor_state())
		Session.custom_board_bytes = raw
		Session.is_online = false
		var max_p := 3 if has_p3 else 2
		Session.num_players = clampi(playtest_players, 1, max_p)
		Session.mode = 3 if default_mode == 2 else (1 if default_mode == 1 else 0)
		Session.victory_rule = victory_rule
		Session.friendly_fire = 1 if friendly_fire else 0
	get_tree().change_scene_to_file("res://scenes/game.tscn")
