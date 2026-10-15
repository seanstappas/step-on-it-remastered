extends Control

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
var bonus_time: int = 6000
var map_name: String = "custom_map"
var cursor_cell: Vector2i = Vector2i(0, 0)

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
	{"cat": "Mechanics", "name": "Stop/Go Switch", "tile": 0x081C, "sprite": "Stop_Go_sprite_family", "frame": 1},
	{"cat": "Mechanics", "name": "Stop/Go Block", "tile": 0x081D, "sprite": "Stop_Go_sprite_family", "frame": 3},

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
	{"cat": "Doors", "name": "Key (P1 Blue)", "tile": 0x0913, "sprite": "goody_sprites", "frame": 20},
	{"cat": "Doors", "name": "Lock (P1 Blue)", "tile": 0x0914, "sprite": "goody_sprites", "frame": 21},
	{"cat": "Doors", "name": "Door (P1 Blue)", "tile": 0x0915, "sprite": "goody_sprites", "frame": 22},
	{"cat": "Doors", "name": "Key (P2 Green)", "tile": 0x0923, "sprite": "goody_sprites", "frame": 36},
	{"cat": "Doors", "name": "Lock (P2 Green)", "tile": 0x0924, "sprite": "goody_sprites", "frame": 37},
	{"cat": "Doors", "name": "Door (P2 Green)", "tile": 0x0925, "sprite": "goody_sprites", "frame": 38},
	{"cat": "Doors", "name": "Key (P3 Red)", "tile": 0x0933, "sprite": "goody_sprites", "frame": 9},
	{"cat": "Doors", "name": "Lock (P3 Red)", "tile": 0x0934, "sprite": "goody_sprites", "frame": 6},
	{"cat": "Doors", "name": "Door (P3 Red)", "tile": 0x0935, "sprite": "goody_sprites", "frame": 3},

	# --- Enemies ---
	{"cat": "Enemies", "name": "Ant/Teeth (L)", "tile": 0x0701, "sprite": "ant_teeth", "frame": 2},
	{"cat": "Enemies", "name": "Hippo/Pig (L)", "tile": 0x0702, "sprite": "enemy_family_02", "frame": 2},
	{"cat": "Enemies", "name": "Ostrich (L)", "tile": 0x0703, "sprite": "enemy_family_03", "frame": 2},
	{"cat": "Enemies", "name": "Robo (L)", "tile": 0x0704, "sprite": "enemy_family_04", "frame": 2},
	{"cat": "Enemies", "name": "Smiley (L)", "tile": 0x0706, "sprite": "enemy_family_06", "frame": 2},
	{"cat": "Enemies", "name": "Hammer (L)", "tile": 0x0707, "sprite": "enemy_family_07", "frame": 2},
	{"cat": "Enemies", "name": "Turret/Cannon", "tile": 0x070C, "sprite": "cannon_sprites", "frame": 2},

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


func _get_sprite(folder: String, frame: int) -> Texture2D:
	if folder == "":
		return null
	var key := "%s_%d" % [folder, frame]
	if _tex_cache.has(key):
		return _tex_cache[key]
	var path := "res://../extracted/sprites/%s/frame_%03d.png" % [folder, frame]
	if not FileAccess.file_exists(path):
		path = "res://sprites/%s/frame_%03d.png" % [folder, frame]
	if FileAccess.file_exists(path):
		var img := Image.load_from_file(ProjectSettings.globalize_path(path))
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
	var has_key_p3 := false
	var has_door_p3 := false
	for r in range(grid_rows):
		for c in range(grid_cols):
			var t: int = cells[r][c]
			if t == 0x0907: has_key_univ = true
			elif t == 0x0901 or t == 0x0904: has_door_univ = true
			elif t == 0x0933: has_key_p3 = true
			elif t == 0x0934 or t == 0x0935: has_door_p3 = true

	if has_key_univ and not has_door_univ:
		warnings.append("Universal key placed but no door found")
	if has_door_univ and not has_key_univ:
		warnings.append("Universal door placed but no key found")
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


func _run_self_test() -> void:
	print("--- Running MapEditor Self-Test ---")
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

	cells[25][37] = 0x0307 # Solid wall
	cells[10][10] = 0x0207 # Breakable
	cells[5][5] = 0x090A   # Coin

	var raw := serialize_to_bord()
	assert(raw.size() > 24, "Serialized size too small")
	assert(raw.size() >= 48 and raw[raw.size() - 24] == 0x45 and raw[raw.size() - 23] == 0x58 and raw[raw.size() - 22] == 0x54 and raw[raw.size() - 21] == 0x31, "EXT1 trailer missing")

	# Save to test file
	var test_path := "user://custom_maps/test_roundtrip.bord"
	DirAccess.make_dir_recursive_absolute("user://custom_maps")
	var f := FileAccess.open(test_path, FileAccess.WRITE)
	assert(f != null, "Cannot write test_roundtrip.bord")
	f.store_buffer(raw)
	f.close()

	# Reset state
	_init_grid(19, 13)
	has_p3 = false

	# Reload
	var reloaded := FileAccess.get_file_as_bytes(test_path)
	var ok := load_from_bord(reloaded)
	assert(ok, "load_from_bord failed")
	assert(grid_cols == 38, "grid_cols mismatch: %d" % grid_cols)
	assert(grid_rows == 26, "grid_rows mismatch: %d" % grid_rows)
	assert(has_p3 == true, "has_p3 mismatch")
	assert(friendly_fire == true, "friendly_fire mismatch")
	assert(victory_rule == 1, "victory_rule mismatch")
	assert(starting_lives == 5, "starting_lives mismatch")
	assert(cells[25][37] == 0x0307, "cell (37, 25) mismatch")
	assert(cells[10][10] == 0x0207, "cell (10, 10) mismatch")
	assert(cells[5][5] == 0x090A, "cell (5, 5) mismatch")
	assert(p3_spawn == Vector2i(19, 2), "p3_spawn mismatch")
	assert(vs_spawns[0] == Vector2i(10, 5), "vs_spawns[0] mismatch")
	assert(vs_spawns[1] == Vector2i(20, 5), "vs_spawns[1] mismatch")

	# Verify in-memory state persistence
	var saved_dict := _save_editor_state()
	_init_grid(19, 13)
	_restore_editor_state(saved_dict)
	assert(grid_cols == 38, "persistence grid_cols mismatch")
	assert(cells[10][10] == 0x0207, "persistence cells mismatch")

	print("MapEditor CLI self-test: PASS")


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
		elif event.keycode == KEY_G or event.keycode == KEY_C:
			cycle_canvas_size()
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
			if event.pressed and event.position.y >= 48.0:
				_erase_at(event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_set_brush(brush_idx - 1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_set_brush(brush_idx + 1)
	elif event is InputEventMouseMotion:
		cursor_cell = _pos_to_cell(event.position)
		if is_mouse_down and event.position.y >= 48.0:
			_paint_at(event.position)


func _handle_hud_click(pos: Vector2) -> void:
	if pos.x >= 140.0 and pos.x <= 220.0:
		cycle_canvas_size()
	elif pos.x >= 230.0 and pos.x <= 280.0:
		save_to_default_file()
	elif pos.x >= 290.0 and pos.x <= 340.0:
		load_from_default_file()
	elif pos.x >= 350.0 and pos.x <= 420.0:
		playtest_in_memory()
	elif pos.x >= 430.0 and pos.x <= 480.0:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	else:
		_set_brush(brush_idx + 1)


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
		cells[cell_coords.y][cell_coords.x] = current_brush

	queue_redraw()


func _erase_at(pos: Vector2) -> void:
	var cell_coords := _pos_to_cell(pos)
	if cell_coords.x >= 0 and cell_coords.x < grid_cols and cell_coords.y >= 0 and cell_coords.y < grid_rows:
		cells[cell_coords.y][cell_coords.x] = 0
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

	# 1. Draw HUD bar
	draw_rect(Rect2(0, 0, vp_size.x, hud_h), Color(0.12, 0.12, 0.16))
	var font := ThemeDB.fallback_font

	# Brush Info & Sprite Preview
	var cur_item: Dictionary = BRUSHES[brush_idx]
	draw_string(font, Vector2(16, 20), "[%s] %s" % [cur_item["cat"], cur_item["name"]], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color.YELLOW)
	draw_string(font, Vector2(16, 38), "[1..9/Wheel/[]: Brush]", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.7, 0.7, 0.7))

	# Size Button
	draw_rect(Rect2(140, 8, 80, 32), Color(0.22, 0.22, 0.28))
	draw_rect(Rect2(140, 8, 80, 32), Color(0.4, 0.4, 0.5), false, 1.0)
	draw_string(font, Vector2(148, 28), "%dx%d [G]" % [grid_cols, grid_rows], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color.WHITE)

	# Save Button
	draw_rect(Rect2(230, 8, 50, 32), Color(0.18, 0.28, 0.22))
	draw_rect(Rect2(230, 8, 50, 32), Color(0.3, 0.5, 0.35), false, 1.0)
	draw_string(font, Vector2(238, 28), "Save", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.8, 1.0, 0.8))

	# Load Button
	draw_rect(Rect2(290, 8, 50, 32), Color(0.22, 0.22, 0.32))
	draw_rect(Rect2(290, 8, 50, 32), Color(0.4, 0.4, 0.6), false, 1.0)
	draw_string(font, Vector2(298, 28), "Load", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.8, 0.8, 1.0))

	# Playtest Button
	draw_rect(Rect2(350, 8, 70, 32), Color(0.28, 0.22, 0.18))
	draw_rect(Rect2(350, 8, 70, 32), Color(0.6, 0.45, 0.3), false, 1.0)
	draw_string(font, Vector2(356, 28), "Play [Tab]", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1.0, 0.9, 0.7))

	# Exit Button
	draw_rect(Rect2(430, 8, 50, 32), Color(0.28, 0.18, 0.18))
	draw_rect(Rect2(430, 8, 50, 32), Color(0.6, 0.3, 0.3), false, 1.0)
	draw_string(font, Vector2(438, 28), "Exit", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(1.0, 0.8, 0.8))

	# Status toast message
	if status_msg != "":
		draw_string(font, Vector2(490, 28), status_msg, HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.4, 1.0, 0.6))

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
			var tile_id: int = cells[r][c]
			if tile_id != 0:
				var spr: Texture2D = null
				var spr_folder := ""
				var spr_frame := 0
				for b in BRUSHES:
					if b["tile"] == tile_id:
						spr_folder = b["sprite"]
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


func save_to_default_file() -> void:
	var dir := "user://custom_maps"
	DirAccess.make_dir_recursive_absolute(dir)
	var path := "%s/%s.bord" % [dir, map_name]
	var raw := serialize_to_bord()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f != null:
		f.store_buffer(raw)
		f.close()
		_set_status("Saved to %s" % path)
		print("Map editor saved: %s (%d bytes)" % [path, raw.size()])
	else:
		_set_status("Error saving map")


func load_from_default_file() -> void:
	var path := "user://custom_maps/%s.bord" % map_name
	if not FileAccess.file_exists(path):
		path = "user://custom_maps/custom_map.bord"
	if not FileAccess.file_exists(path):
		_set_status("No saved map found")
		return
	var raw := FileAccess.get_file_as_bytes(path)
	if load_from_bord(raw):
		_set_status("Loaded %s" % path)
		print("Map editor loaded: %s (%d bytes)" % [path, raw.size()])
	else:
		_set_status("Error parsing map file")


func playtest_in_memory() -> void:
	var raw := serialize_to_bord()
	if Session:
		Session.set_meta("custom_board_bytes", raw)
		Session.set_meta("editor_return", true)
		Session.set_meta("editor_state", _save_editor_state())
	get_tree().change_scene_to_file("res://scenes/game.tscn")
