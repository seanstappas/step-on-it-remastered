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
var has_p3: bool = false
var friendly_fire: bool = false
var victory_rule: int = 0 # 0=Lives, 1=Score, 2=Door
var starting_lives: int = 3
var bonus_time: int = 6000

# Grid 2D array: cells[row][col] -> tile int
var cells: Array = []

# Available brushes
const BRUSHES = [
	{"name": "Eraser", "tile": 0x0000, "char": "."},
	{"name": "Wall", "tile": 0x0307, "char": "#"},
	{"name": "Breakable", "tile": 0x0207, "char": "="},
	{"name": "Ladder", "tile": 0x0197, "char": "H"},
	{"name": "Ice", "tile": 0x0387, "char": "_"},
	{"name": "P1 Spawn", "tile": -1, "char": "1"},
	{"name": "P2 Spawn", "tile": -2, "char": "2"},
	{"name": "P3 Spawn", "tile": -3, "char": "3"},
	{"name": "Coin", "tile": 0x090A, "char": "c"},
	{"name": "Gold Coin", "tile": 0x0917, "char": "g"},
	{"name": "Arrow Ammo", "tile": 0x0911, "char": "a"},
	{"name": "Ball Ammo", "tile": 0x0912, "char": "o"},
	{"name": "Speed Shoes", "tile": 0x0932, "char": "s"},
	{"name": "Shield", "tile": 0x0930, "char": "p"},
	{"name": "Key (Univ)", "tile": 0x0907, "char": "k"},
	{"name": "Lock (Univ)", "tile": 0x0904, "char": "l"},
	{"name": "Door (Univ)", "tile": 0x0901, "char": "d"},
	{"name": "Key (P3 Red)", "tile": 0x0933, "char": "K3"},
	{"name": "Lock (P3 Red)", "tile": 0x0934, "char": "L3"},
	{"name": "Door (P3 Red)", "tile": 0x0935, "char": "D3"},
]

var brush_idx: int = 1
var current_brush: int = 0x0307
var is_mouse_down: bool = false
var status_msg: String = ""
var status_timer: float = 0.0


func _ready() -> void:
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
	elif event is InputEventMouseMotion and is_mouse_down:
		if event.position.y >= 48.0:
			_paint_at(event.position)


func _handle_hud_click(pos: Vector2) -> void:
	# Buttons along HUD bar:
	# 16..120: Brush selector (click cycles brush)
	# 140..220: Size toggle
	# 230..280: Save
	# 290..340: Load
	# 350..420: Playtest
	# 430..470: Exit
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
	_set_status("Brush: %s" % BRUSHES[brush_idx]["name"])


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

	# Brush Info
	draw_string(font, Vector2(16, 20), "Brush: %s" % BRUSHES[brush_idx]["name"], HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color.YELLOW)
	draw_string(font, Vector2(16, 38), "[1..9/Wheel]", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(0.7, 0.7, 0.7))

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
			elif tile_id > 0:
				draw_rect(rect, Color(1.0, 0.85, 0.2)) # Pickup/Coin
			draw_rect(rect, Color(0.2, 0.2, 0.25, 0.25), false, 1.0) # Grid line

	# 3. Draw Spawn Points
	draw_circle(Vector2(p1_spawn.x * cell_w + cell_w * 0.5, hud_h + p1_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.DODGER_BLUE)
	draw_circle(Vector2(p2_spawn.x * cell_w + cell_w * 0.5, hud_h + p2_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.LIME_GREEN)
	if has_p3:
		draw_circle(Vector2(p3_spawn.x * cell_w + cell_w * 0.5, hud_h + p3_spawn.y * cell_h + cell_h * 0.5), cell_w * 0.35, Color.CRIMSON)


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

	# 4 extra vs spawns (8 bytes) -> default to 0
	for i in range(8):
		out[ext_idx + 12 + i] = 0
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
	var path := "%s/custom_map.bord" % dir
	var raw := serialize_to_bord()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f != null:
		f.store_buffer(raw)
		f.close()
		_set_status("Saved to user://custom_maps/custom_map.bord")
		print("Map editor saved: %s (%d bytes)" % [path, raw.size()])
	else:
		_set_status("Error saving map")


func load_from_default_file() -> void:
	var path := "user://custom_maps/custom_map.bord"
	if not FileAccess.file_exists(path):
		_set_status("No saved map found")
		return
	var raw := FileAccess.get_file_as_bytes(path)
	if load_from_bord(raw):
		_set_status("Loaded user://custom_maps/custom_map.bord")
		print("Map editor loaded: %s (%d bytes)" % [path, raw.size()])
	else:
		_set_status("Error parsing map file")


func playtest_in_memory() -> void:
	var raw := serialize_to_bord()
	if Session:
		Session.set_meta("custom_board_bytes", raw)
		Session.set_meta("editor_return", true)
	get_tree().change_scene_to_file("res://scenes/game.tscn")
