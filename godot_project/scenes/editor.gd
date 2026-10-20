extends Control

const EnemyDefs = preload("res://scenes/enemy_defs.gd")
const MacMenuPopup = preload("res://scenes/mac_menu.gd")
const MacMenuButton = preload("res://scenes/mac_menu_button.gd")
const TileCatalog = preload("res://scenes/tile_catalog.gd")
const TileArt = preload("res://scenes/tile_art.gd")

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
var cursor_cell: Vector2i = Vector2i(-1, -1)
var hover_cell: Vector2i = Vector2i(-1, -1)
var enemy_facing_left: bool = false

# Grid 2D array: cells[row][col] -> tile int
var cells: Array = []

# Presentation & UI State
var remastered: bool = true
var _sidebar_visible: bool = true
var _show_grid: bool = true
var _sidebar_scroll_y: float = 0.0
var _cat_collapsed: Dictionary = {}

# Active Brush Configuration
# Variant flag: 0x0300 (Wall), 0x0200 (Breakable), 0x0100 (Background), 0x1200 (Hidden)
var current_variant_flag: int = 0x0300
var current_family_t: int = 0x07
var current_hidden_goody: int = 0x17 # Gold Coin by default
var current_brush: int = 0x0307
var current_brush_name: String = "White Block (Wall)"
var current_brush_desc: String = "Solid permanent wall"

var brush_idx: int = 1 # Backwards compatibility index for BRUSHES
var BRUSHES: Array = [] # Populated in _init_brushes() for legacy tests

var is_mouse_down: bool = false
var is_right_mouse_down: bool = false
var status_msg: String = ""
var status_timer: float = 0.0
var _hover_palette_desc: String = ""

# Mac Menu & Dialog Nodes
var _menu_overlay: Control = null
var _menu_bar: HBoxContainer = null
var _properties_dialog: Control = null
var _apple_icon: Texture2D = null
var _chicago_font: Font = null


func _ready() -> void:
	_init_brushes()
	if Session:
		Session.init_presentation()
		if Session.has_meta("editor_remastered"):
			remastered = bool(Session.get_meta("editor_remastered"))
		else:
			remastered = true
	_apply_remastered(remastered)

	_build_mac_menu_bar()

	if Session and Session.has_meta("editor_state"):
		var st: Dictionary = Session.get_meta("editor_state")
		Session.remove_meta("editor_state")
		_restore_editor_state(st)
	else:
		_init_grid(grid_cols, grid_rows)
	_check_cli_args()


func _exit_tree() -> void:
	TileArt.clear_cache()


func _init_brushes() -> void:
	BRUSHES.clear()
	# Terrain
	BRUSHES.append({"cat": "Terrain", "name": "Eraser", "tile": 0x0000, "sprite": "", "frame": 0})
	for b in TileCatalog.BLOCK_FAMILIES:
		BRUSHES.append({"cat": "Terrain", "name": b["name"] + " (Wall)", "tile": 0x0300 | b["t"], "sprite": "block_sprites", "frame": b["frame"]})
		BRUSHES.append({"cat": "Terrain", "name": b["name"] + " (Break)", "tile": 0x0200 | b["t"], "sprite": "block_sprites", "frame": b["frame"]})
	# Mechanics
	for tr in TileCatalog.TRANSPORTERS:
		BRUSHES.append({"cat": "Mechanics", "name": tr["name"], "tile": tr["tile"], "sprite": tr["folder"], "frame": tr["frame"]})
	for sw in TileCatalog.SWITCHES:
		BRUSHES.append({"cat": "Mechanics", "name": sw["name"], "tile": sw["tile"], "sprite": sw["folder"], "frame": sw["frame"]})
	# Doors
	for dr in TileCatalog.DOORS_AND_KEYS:
		BRUSHES.append({"cat": "Doors", "name": dr["name"], "tile": dr["tile"], "sprite": dr["folder"], "frame": dr["frame"]})
	# Goodies
	for g in TileCatalog.GOODIES:
		BRUSHES.append({"cat": "Goodies", "name": g["name"], "tile": g["tile"], "sprite": g["folder"], "frame": g["frame"]})
	# Enemies
	for en in TileCatalog.ENEMIES:
		BRUSHES.append({"cat": "Enemies", "name": en["name"], "tile": en["tile"], "frame": en["frame"], "etype": en["etype"], "sprite": en["folder"]})
	# Spawns
	for sp in TileCatalog.SPAWNS:
		BRUSHES.append({"cat": "Spawns", "name": sp["name"], "tile": sp["tile"], "sprite": sp["folder"], "frame": sp["frame"]})


func _get_brush_folder(b: Dictionary) -> String:
	if b.has("etype"):
		return EnemyDefs.get_folder(b["etype"])
	return b.get("sprite", "")


func _apply_remastered(on: bool) -> void:
	remastered = on
	if Session != null:
		Session.set_meta("editor_remastered", on)
		Session.set_remastered(on)
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS if on else CanvasItem.TEXTURE_FILTER_NEAREST
	TileArt.clear_cache()
	queue_redraw()


func _get_chicago_font() -> Font:
	if _chicago_font != null:
		return _chicago_font
	for p in ["res://scenes/Chicago.ttf", "res://scenes/chicago.ttf", "res://Chicago.ttf"]:
		if FileAccess.file_exists(p):
			var ff := FontFile.new()
			if ff.load_dynamic_font(p) == OK:
				ff.subpixel_positioning = TextServer.SUBPIXEL_POSITIONING_AUTO
				ff.msdf_pixel_range = 16
				_chicago_font = ff
				break
	if _chicago_font == null:
		_chicago_font = ThemeDB.fallback_font
	return _chicago_font


# --- Mac Menu Bar Construction ---

func _build_mac_menu_bar() -> void:
	# Menu bar background (20px white strip with 1px black line)
	var bar_bg := ColorRect.new()
	bar_bg.position = Vector2.ZERO
	bar_bg.size = Vector2(640, 20)
	bar_bg.color = Color.WHITE
	bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar_bg)

	var bar_line := ColorRect.new()
	bar_line.position = Vector2(0, 19)
	bar_line.size = Vector2(640, 1)
	bar_line.color = Color.BLACK
	bar_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar_line)

	var menu_overlay := Control.new()
	menu_overlay.name = "MenuOverlay"
	menu_overlay.position = Vector2.ZERO
	menu_overlay.size = Vector2(640, 480)
	menu_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_overlay.z_index = 100
	add_child(menu_overlay)
	_menu_overlay = menu_overlay

	var bar := HBoxContainer.new()
	bar.position = Vector2(6, 0)
	bar.size = Vector2(628, 19)
	bar.add_theme_constant_override("separation", 2)
	add_child(bar)
	_menu_bar = bar

	# Load Apple Logo Icon
	var apple_path := "res://scenes/apple_logo.png"
	if FileAccess.file_exists(apple_path):
		var img := Image.load_from_file(ProjectSettings.globalize_path(apple_path))
		if img != null:
			img.generate_mipmaps()
			_apple_icon = ImageTexture.create_from_image(img)

	# 1. Apple Menu
	var mb_apple := _create_mac_menu(bar, "", _apple_icon)
	var pop_apple := mb_apple.get_popup()
	pop_apple.add_item("About Map Editor...", 100)
	pop_apple.add_item("Help / Shortcuts...", 101)
	pop_apple.id_pressed.connect(_on_apple_menu)

	# 2. File Menu
	var mb_file := _create_mac_menu(bar, "File")
	var pop_file := mb_file.get_popup()
	pop_file.add_item("New Map", 200)
	pop_file.add_item("Open Map...", 201)
	pop_file.add_item("Open Original Board...", 202)
	pop_file.add_separator()
	pop_file.add_item("Save Map", 203)
	pop_file.add_item("Save Map As...", 204)
	pop_file.add_separator()
	pop_file.add_item("Exit to Main Menu", 205)
	pop_file.id_pressed.connect(_on_file_menu)

	# 3. Edit Menu
	var mb_edit := _create_mac_menu(bar, "Edit")
	var pop_edit := mb_edit.get_popup()
	pop_edit.add_item("Clear Board", 300)
	pop_edit.add_separator()
	pop_edit.add_item("Add Border Walls", 301)
	pop_edit.add_item("Remove Border Walls", 302)
	pop_edit.id_pressed.connect(_on_edit_menu)

	# 4. Map Menu
	var mb_map := _create_mac_menu(bar, "Map")
	var pop_map := mb_map.get_popup()
	pop_map.add_item("Map Properties...", 400)
	pop_map.add_separator()
	pop_map.add_check_item("Size: 19x13 (Standard)", 410)
	pop_map.add_check_item("Size: 28x19 (Medium)", 411)
	pop_map.add_check_item("Size: 38x26 (Large)", 412)
	pop_map.add_separator()
	pop_map.add_check_item("Playtest: 1 Player", 420)
	pop_map.add_check_item("Playtest: 2 Players", 421)
	pop_map.add_check_item("Playtest: 3 Players", 422)
	_update_map_menu_checks(pop_map)
	pop_map.id_pressed.connect(func(id: int) -> void:
		_on_map_menu(id)
		_update_map_menu_checks(pop_map)
	)

	# 5. View Menu
	var mb_view := _create_mac_menu(bar, "View")
	var pop_view := mb_view.get_popup()
	pop_view.add_check_item("Remastered Graphics", 500)
	pop_view.add_check_item("Show Palette", 501)
	pop_view.add_check_item("Show Grid Lines", 502)
	_update_view_menu_checks(pop_view)
	pop_view.id_pressed.connect(func(id: int) -> void:
		_on_view_menu(id)
		_update_view_menu_checks(pop_view)
	)

	# Spacer
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(spacer)

	# Play [Tab] Quick Button
	var play_btn := Button.new()
	play_btn.text = "▶ Play [Tab]"
	play_btn.focus_mode = Control.FOCUS_NONE
	play_btn.add_theme_font_override("font", _get_chicago_font())
	play_btn.add_theme_font_size_override("font_size", 11)
	play_btn.add_theme_color_override("font_color", Color(0.1, 0.45, 0.1))
	play_btn.add_theme_color_override("font_hover_color", Color(0.05, 0.6, 0.05))
	play_btn.pressed.connect(playtest_in_memory)
	bar.add_child(play_btn)


func _create_mac_menu(parent: Control, title: String, icon: Texture2D = null) -> MacMenuButton:
	var mb := MacMenuButton.new()
	var font := _get_chicago_font()
	if icon != null:
		var tr := TextureRect.new()
		tr.texture = icon
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size = Vector2(14, 16)
		tr.position = Vector2(6, 1)
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		mb.add_child(tr)
		mb.custom_minimum_size = Vector2(26, 19)
	else:
		mb.text = title

	var sb_norm := StyleBoxFlat.new()
	sb_norm.bg_color = Color.TRANSPARENT
	sb_norm.content_margin_left = 6
	sb_norm.content_margin_right = 6

	var sb_act := StyleBoxFlat.new()
	sb_act.bg_color = Color(0.33, 0.33, 0.70)
	sb_act.content_margin_left = 6
	sb_act.content_margin_right = 6

	mb.setup_styles(sb_norm, sb_act)
	mb.add_theme_color_override("font_color", Color.BLACK)
	mb.add_theme_color_override("font_hover_color", Color.BLACK)
	mb.add_theme_color_override("font_pressed_color", Color.WHITE)
	mb.add_theme_color_override("font_focus_color", Color.BLACK)
	mb.add_theme_color_override("font_disabled_color", Color(0.53, 0.53, 0.53))
	mb.add_theme_font_override("font", font)
	mb.add_theme_font_size_override("font_size", 12)

	var pop := MacMenuPopup.new()
	pop.set_font(font, 12)
	mb.set_popup(pop)
	if _menu_overlay != null:
		_menu_overlay.add_child(pop)
	else:
		add_child(pop)

	parent.add_child(mb)
	return mb


func _update_map_menu_checks(pop: MacMenuPopup) -> void:
	pop.set_item_checked(pop.get_item_index(410), size_idx == 0)
	pop.set_item_checked(pop.get_item_index(411), size_idx == 1)
	pop.set_item_checked(pop.get_item_index(412), size_idx == 2)
	pop.set_item_checked(pop.get_item_index(420), playtest_players == 1)
	pop.set_item_checked(pop.get_item_index(421), playtest_players == 2)
	pop.set_item_checked(pop.get_item_index(422), playtest_players == 3)


func _update_view_menu_checks(pop: MacMenuPopup) -> void:
	pop.set_item_checked(pop.get_item_index(500), remastered)
	pop.set_item_checked(pop.get_item_index(501), _sidebar_visible)
	pop.set_item_checked(pop.get_item_index(502), _show_grid)


func _on_apple_menu(id: int) -> void:
	if id == 100:
		_show_info_dialog("About Map Editor", "Step On It! Remastered Map Maker\nCreate and play custom boards.\nSupports 19x13, 28x19, 38x26 maps with EXT1 metadata.")
	elif id == 101:
		_show_info_dialog("Help & Shortcuts", "Tab: Playtest board in-memory\nEsc: Exit to Main Menu\nF2: Toggle Remastered Graphics\nB: Toggle Left Palette\nF: Flip hovered/active Enemy facing\n1..9 / Mouse Wheel: Cycle brushes\nCtrl+S: Save Map | Ctrl+O: Open Map")


func _on_file_menu(id: int) -> void:
	match id:
		200: # New Map
			_init_grid(grid_cols, grid_rows)
			_set_status("New Map created")
		201: # Open Map...
			_open_map_dialog()
		202: # Open Original Board...
			_open_original_board_dialog()
		203: # Save Map
			save_to_default_file()
		204: # Save Map As...
			_save_map_as_dialog()
		205: # Exit
			_confirm_or_proceed("Exit Map Editor?", func() -> void:
				if get_viewport():
					get_viewport().set_input_as_handled()
				get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
			)


func _on_edit_menu(id: int) -> void:
	match id:
		300: # Clear Board
			for r in range(grid_rows):
				for c in range(grid_cols):
					cells[r][c] = 0
			queue_redraw()
			_set_status("Board cleared")
		301: # Add Border Walls
			for c in range(grid_cols):
				cells[0][c] = 0x0307
				cells[grid_rows - 1][c] = 0x0307
			for r in range(grid_rows):
				cells[r][0] = 0x0307
				cells[r][grid_cols - 1] = 0x0307
			queue_redraw()
			_set_status("Border walls added")
		302: # Remove Border Walls
			for c in range(grid_cols):
				cells[0][c] = 0
				cells[grid_rows - 1][c] = 0
			for r in range(grid_rows):
				cells[r][0] = 0
				cells[r][grid_cols - 1] = 0
			queue_redraw()
			_set_status("Border walls removed")


func _on_map_menu(id: int) -> void:
	match id:
		400: # Map Properties...
			_open_properties_dialog()
		410:
			_set_canvas_size_idx(0)
		411:
			_set_canvas_size_idx(1)
		412:
			_set_canvas_size_idx(2)
		420:
			playtest_players = 1
			_set_status("Playtest players: 1P")
		421:
			playtest_players = 2
			_set_status("Playtest players: 2P")
		422:
			playtest_players = 3
			_set_status("Playtest players: 3P")


func _on_view_menu(id: int) -> void:
	match id:
		500: # Toggle Remastered
			_apply_remastered(not remastered)
			_set_status("Presentation: %s [F2]" % ("Remastered" if remastered else "Original"))
		501: # Toggle Palette
			_sidebar_visible = not _sidebar_visible
			_set_status("Palette: %s [B]" % ("Visible" if _sidebar_visible else "Hidden"))
			queue_redraw()
		502: # Toggle Grid Lines
			_show_grid = not _show_grid
			queue_redraw()


# --- Process & Status ---

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


# --- Grid Management ---

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
			else:
				row_arr.append(0)
		cells.append(row_arr)

	# Clamp spawns safely within bounds
	p1_spawn = Vector2i(clampi(p1_spawn.x, 0, grid_cols - 1), clampi(p1_spawn.y, 0, grid_rows - 1))
	p2_spawn = Vector2i(clampi(p2_spawn.x, 0, grid_cols - 1), clampi(p2_spawn.y, 0, grid_rows - 1))
	p3_spawn = Vector2i(clampi(p3_spawn.x, 0, grid_cols - 1), clampi(p3_spawn.y, 0, grid_rows - 1))

	queue_redraw()


func _set_canvas_size_idx(idx: int) -> void:
	size_idx = clampi(idx, 0, SIZES.size() - 1)
	var s: Vector2i = SIZES[size_idx]
	_init_grid(s.x, s.y)
	_set_status("Canvas size: %dx%d" % [s.x, s.y])


func cycle_canvas_size() -> void:
	_set_canvas_size_idx((size_idx + 1) % SIZES.size())


# --- Geometry & Uniform Zoom Math ---

func _get_sidebar_width() -> float:
	return 140.0 if _sidebar_visible else 0.0


func _get_playfield_geom() -> Dictionary:
	var vp_size := get_viewport_rect().size
	var sb_w := _get_sidebar_width()
	var top_bar_h := 20.0
	var status_bar_h := 20.0

	var avail_x := sb_w
	var avail_y := top_bar_h
	var avail_w := vp_size.x - avail_x
	var avail_h := vp_size.y - avail_y - status_bar_h

	# 20px margin around playfield for the 3D frame
	var frame_margin := 24.0
	var max_board_w := maxf(32.0, avail_w - frame_margin * 2.0)
	var max_board_h := maxf(32.0, avail_h - frame_margin * 2.0)

	var base_w := grid_cols * 32.0
	var base_h := grid_rows * 32.0

	# Uniform zoom: cells are GUARANTEED to be 1:1 square
	var zoom := minf(max_board_w / base_w, max_board_h / base_h)
	var pw := base_w * zoom
	var ph := base_h * zoom

	var px := avail_x + (avail_w - pw) * 0.5
	var py := avail_y + (avail_h - ph) * 0.5

	return {
		"x": px,
		"y": py,
		"w": pw,
		"h": ph,
		"zoom": zoom,
		"cell_w": 32.0 * zoom,
		"cell_h": 32.0 * zoom
	}


func _pos_to_cell(pos: Vector2) -> Vector2i:
	var geom := _get_playfield_geom()
	var px: float = geom["x"]
	var py: float = geom["y"]
	var pw: float = geom["w"]
	var ph: float = geom["h"]
	var zoom: float = geom["zoom"]

	if pos.x < px or pos.x >= px + pw or pos.y < py or pos.y >= py + ph:
		return Vector2i(-1, -1)

	var cell_size := 32.0 * zoom
	var c := int((pos.x - px) / cell_size)
	var r := int((pos.y - py) / cell_size)
	return Vector2i(clampi(c, 0, grid_cols - 1), clampi(r, 0, grid_rows - 1))


# --- Sprite Proxy for Self-Test ---

func _get_sprite(folder: String, frame: int) -> Texture2D:
	return TileArt.get_sprite(folder, frame, remastered)


# --- Map Validation ---

func _validate_map() -> Array[String]:
	var warnings: Array[String] = []
	if p1_spawn == p2_spawn:
		warnings.append("P1 & P2 spawns overlap at (%d, %d)" % [p1_spawn.x, p1_spawn.y])
	if has_p3 and (p1_spawn == p3_spawn or p2_spawn == p3_spawn):
		warnings.append("P3 spawn overlaps another player spawn")

	var has_key := false
	var has_door := false
	for r in range(grid_rows):
		for c in range(grid_cols):
			var v: int = cells[r][c]
			if (v & 0x0800) != 0:
				var t := v & 0xFF
				if t in [0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x34, 0x35]:
					has_door = true
				if t in [0x07, 0x08, 0x09, 0x33]:
					has_key = true
	if has_door and not has_key:
		warnings.append("Map has an exit door but no key to unlock it")
	return warnings


# --- Persistence ---

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
		"current_brush": current_brush,
		"current_variant_flag": current_variant_flag,
		"current_family_t": current_family_t,
		"current_brush_name": current_brush_name,
		"cursor_cell": cursor_cell,
		"remastered": remastered,
		"_sidebar_visible": _sidebar_visible,
		"_show_grid": _show_grid,
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

	current_brush = st.get("current_brush", 0x0307)
	current_variant_flag = st.get("current_variant_flag", 0x0300)
	current_family_t = st.get("current_family_t", 0x07)
	current_brush_name = st.get("current_brush_name", "White Block (Wall)")
	cursor_cell = st.get("cursor_cell", Vector2i(-1, -1))

	if grid_cols == 38 and grid_rows == 26:
		size_idx = 2
	elif grid_cols == 28 and grid_rows == 19:
		size_idx = 1
	else:
		size_idx = 0

	_sidebar_visible = st.get("_sidebar_visible", _sidebar_visible)
	_show_grid = st.get("_show_grid", _show_grid)
	_apply_remastered(st.get("remastered", remastered))
	queue_redraw()


# --- Input Handling ---

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB:
			if get_viewport():
				get_viewport().set_input_as_handled()
			playtest_in_memory()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_TAB:
			if get_viewport():
				get_viewport().set_input_as_handled()
			playtest_in_memory()
		elif event.keycode == KEY_ESCAPE:
			if get_viewport():
				get_viewport().set_input_as_handled()
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		elif event.keycode == KEY_F2:
			_apply_remastered(not remastered)
			_set_status("Presentation: %s [F2]" % ("Remastered" if remastered else "Original"))
			if get_viewport():
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_B and not event.ctrl_pressed:
			_sidebar_visible = not _sidebar_visible
			_set_status("Palette: %s [B]" % ("Visible" if _sidebar_visible else "Hidden"))
			queue_redraw()
			if get_viewport():
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_S and event.ctrl_pressed:
			save_to_default_file()
			if get_viewport():
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_O and event.ctrl_pressed:
			_open_map_dialog()
			if get_viewport():
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_N and event.ctrl_pressed:
			_init_grid(grid_cols, grid_rows)
			_set_status("New Map created")
			if get_viewport():
				get_viewport().set_input_as_handled()
		elif event.keycode == KEY_F and not event.ctrl_pressed:
			_cycle_hovered_enemy_facing()
			if get_viewport():
				get_viewport().set_input_as_handled()


func _gui_input(event: InputEvent) -> void:
	var sb_w := _get_sidebar_width()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_mouse_down = event.pressed
			if is_mouse_down:
				if event.position.y < 20.0:
					pass # Menu bar handled by buttons
				elif event.position.x < sb_w and event.position.y < (get_viewport_rect().size.y - 20.0):
					_handle_palette_click(event.position)
				else:
					_paint_at(event.position)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			is_right_mouse_down = event.pressed
			if is_right_mouse_down and event.position.x >= sb_w:
				_erase_at(event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			if event.position.x < sb_w:
				_sidebar_scroll_y = maxf(0.0, _sidebar_scroll_y - 36.0)
				queue_redraw()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			if event.position.x < sb_w:
				var max_s: float = maxf(0.0, _get_palette_total_height() - (get_viewport_rect().size.y - 40.0))
				_sidebar_scroll_y = minf(max_s, _sidebar_scroll_y + 36.0)
				queue_redraw()
	elif event is InputEventMouseMotion:
		cursor_cell = _pos_to_cell(event.position)
		hover_cell = cursor_cell
		if event.position.x < sb_w and event.position.y >= 20.0 and event.position.y < (get_viewport_rect().size.y - 20.0):
			_update_palette_hover(event.position)
		else:
			_hover_palette_desc = ""

		if is_mouse_down and event.position.x >= sb_w:
			_paint_at(event.position)
		elif is_right_mouse_down and event.position.x >= sb_w:
			_erase_at(event.position)
		queue_redraw()


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
		if (current_brush & 0x0400) != 0:
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


# --- Palette Management & Interaction ---

func _get_palette_total_height() -> float:
	var total := 28.0 # Eraser row
	# Blocks section
	total += 20.0
	if not _cat_collapsed.get("Blocks", false):
		total += 22.0 # Variant selector row
		total += 5 * 26.0 + 4.0 # 5x5 icon grid
	# Transporters
	total += 20.0
	if not _cat_collapsed.get("Transporters", false):
		total += TileCatalog.TRANSPORTERS.size() * 22.0
	# Stop/Go
	total += 20.0
	if not _cat_collapsed.get("Stop/Go", false):
		total += TileCatalog.SWITCHES.size() * 22.0
	# Doors
	total += 20.0
	if not _cat_collapsed.get("Doors", false):
		total += TileCatalog.DOORS_AND_KEYS.size() * 22.0
	# Goodies
	total += 20.0
	if not _cat_collapsed.get("Goodies", false):
		total += TileCatalog.GOODIES.size() * 22.0
	# Enemies
	total += 20.0
	if not _cat_collapsed.get("Enemies", false):
		total += TileCatalog.ENEMIES.size() * 22.0
	# Spawns
	total += 20.0
	if not _cat_collapsed.get("Spawns", false):
		total += TileCatalog.SPAWNS.size() * 22.0
	return total


func _select_block_family(t: int, bname: String) -> void:
	current_family_t = t
	if current_variant_flag == TileCatalog.FLAG_HIDDEN:
		current_brush = current_variant_flag | (current_hidden_goody << 16) | current_family_t
		current_brush_name = "%s (Hidden)" % bname
		current_brush_desc = "Breakable block containing hidden %s" % TileArt._get_goody_name(current_hidden_goody)
	else:
		current_brush = current_variant_flag | current_family_t
		var vlabel := "Wall" if current_variant_flag == TileCatalog.FLAG_WALL else ("Background" if current_variant_flag == TileCatalog.FLAG_BACKGROUND else "Breakable")
		current_brush_name = "%s (%s)" % [bname, vlabel]
		current_brush_desc = "Solid wall" if current_variant_flag == TileCatalog.FLAG_WALL else ("Decorative mesh" if current_variant_flag == TileCatalog.FLAG_BACKGROUND else "Head-bonkable breakable block")
	_set_status("Brush: %s" % current_brush_name)
	queue_redraw()


func _set_block_variant(flag: int) -> void:
	current_variant_flag = flag
	var bname := TileArt._get_block_family_name(current_family_t)
	_select_block_family(current_family_t, bname)


func _handle_palette_click(pos: Vector2) -> void:
	var rel_y := pos.y - 20.0 + _sidebar_scroll_y
	var cur_y := 4.0

	# 1. Eraser Button
	if rel_y >= cur_y and rel_y < cur_y + 22.0:
		current_brush = 0
		current_brush_name = "Eraser"
		current_brush_desc = "Clear tiles (Right-click also erases)"
		_set_status("Brush: Eraser")
		queue_redraw()
		return
	cur_y += 26.0

	# 2. Blocks Section
	if rel_y >= cur_y and rel_y < cur_y + 20.0:
		_cat_collapsed["Blocks"] = not _cat_collapsed.get("Blocks", false)
		queue_redraw()
		return
	cur_y += 20.0

	if not _cat_collapsed.get("Blocks", false):
		# Variant selector row: [Wall | Brk | Bkg | Hid]
		if rel_y >= cur_y and rel_y < cur_y + 20.0:
			var bx := pos.x
			if bx >= 4.0 and bx < 36.0:
				_set_block_variant(TileCatalog.FLAG_WALL)
			elif bx >= 38.0 and bx < 70.0:
				_set_block_variant(TileCatalog.FLAG_BREAKABLE)
			elif bx >= 72.0 and bx < 104.0:
				_set_block_variant(TileCatalog.FLAG_BACKGROUND)
			elif bx >= 106.0 and bx < 136.0:
				_set_block_variant(TileCatalog.FLAG_HIDDEN)
			return
		cur_y += 22.0

		# 5x5 Block Icon Grid
		for row in range(5):
			for col in range(5):
				var idx := row * 5 + col
				if idx < TileCatalog.BLOCK_FAMILIES.size():
					var icon_x := 6.0 + col * 26.0
					var icon_y := cur_y + row * 26.0
					if pos.x >= icon_x and pos.x < icon_x + 24.0 and rel_y >= icon_y and rel_y < icon_y + 24.0:
						var item: Dictionary = TileCatalog.BLOCK_FAMILIES[idx]
						_select_block_family(item["t"], item["name"])
						return
		cur_y += 5 * 26.0 + 4.0

	# 3. Transporters Section
	cur_y = _handle_list_section_click("Transporters", TileCatalog.TRANSPORTERS, rel_y, cur_y)
	if cur_y < 0: return

	# 4. Stop/Go Section
	cur_y = _handle_list_section_click("Stop/Go", TileCatalog.SWITCHES, rel_y, cur_y)
	if cur_y < 0: return

	# 5. Doors Section
	cur_y = _handle_list_section_click("Doors", TileCatalog.DOORS_AND_KEYS, rel_y, cur_y)
	if cur_y < 0: return

	# 6. Goodies Section
	cur_y = _handle_list_section_click("Goodies", TileCatalog.GOODIES, rel_y, cur_y)
	if cur_y < 0: return

	# 7. Enemies Section
	cur_y = _handle_list_section_click("Enemies", TileCatalog.ENEMIES, rel_y, cur_y)
	if cur_y < 0: return

	# 8. Spawns Section
	cur_y = _handle_list_section_click("Spawns", TileCatalog.SPAWNS, rel_y, cur_y)


func _handle_list_section_click(cat_name: String, items: Array, rel_y: float, cur_y: float) -> float:
	if rel_y >= cur_y and rel_y < cur_y + 20.0:
		_cat_collapsed[cat_name] = not _cat_collapsed.get(cat_name, false)
		queue_redraw()
		return -1.0
	cur_y += 20.0

	if not _cat_collapsed.get(cat_name, false):
		for item in items:
			if rel_y >= cur_y and rel_y < cur_y + 22.0:
				current_brush = item["tile"]
				current_brush_name = item["name"]
				current_brush_desc = item.get("desc", "")
				_set_status("Brush: %s" % current_brush_name)
				queue_redraw()
				return -1.0
			cur_y += 22.0
	return cur_y


func _update_palette_hover(pos: Vector2) -> void:
	var rel_y := pos.y - 20.0 + _sidebar_scroll_y
	var cur_y := 4.0

	if rel_y >= cur_y and rel_y < cur_y + 22.0:
		_hover_palette_desc = "Eraser: Erases any painted cell"
		return
	cur_y += 26.0

	# Blocks
	cur_y += 20.0
	if not _cat_collapsed.get("Blocks", false):
		if rel_y >= cur_y and rel_y < cur_y + 20.0:
			_hover_palette_desc = "Select block behavior: Wall / Breakable / Background / Hidden"
			return
		cur_y += 22.0
		for row in range(5):
			for col in range(5):
				var idx := row * 5 + col
				if idx < TileCatalog.BLOCK_FAMILIES.size():
					var icon_x := 6.0 + col * 26.0
					var icon_y := cur_y + row * 26.0
					if pos.x >= icon_x and pos.x < icon_x + 24.0 and rel_y >= icon_y and rel_y < icon_y + 24.0:
						var item: Dictionary = TileCatalog.BLOCK_FAMILIES[idx]
						_hover_palette_desc = "%s: authentic block family" % item["name"]
						return
		cur_y += 5 * 26.0 + 4.0

	for cat in [
		["Transporters", TileCatalog.TRANSPORTERS],
		["Stop/Go", TileCatalog.SWITCHES],
		["Doors", TileCatalog.DOORS_AND_KEYS],
		["Goodies", TileCatalog.GOODIES],
		["Enemies", TileCatalog.ENEMIES],
		["Spawns", TileCatalog.SPAWNS]
	]:
		var cname: String = cat[0]
		var items: Array = cat[1]
		cur_y += 20.0
		if not _cat_collapsed.get(cname, false):
			for it in items:
				if rel_y >= cur_y and rel_y < cur_y + 22.0:
					_hover_palette_desc = "%s: %s" % [it["name"], it.get("desc", "Game entity")]
					return
				cur_y += 22.0


# --- Map Properties Dialog ---

func _open_properties_dialog() -> void:
	if _properties_dialog != null and is_instance_valid(_properties_dialog):
		_properties_dialog.queue_free()

	var dlg := Control.new()
	dlg.name = "MapPropertiesDialog"
	dlg.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg.z_index = 150
	_properties_dialog = dlg
	add_child(dlg)

	# Dimmer backdrop
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0, 0, 0, 0.4)
	dlg.add_child(bg)

	# Dialog Window (360x320)
	var win_w := 360.0
	var win_h := 330.0
	var vp_size := get_viewport_rect().size
	var win_pos := (vp_size - Vector2(win_w, win_h)) * 0.5

	var win := Panel.new()
	win.position = win_pos
	win.size = Vector2(win_w, win_h)
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.92, 0.92, 0.94)
	sb.border_width_left = 1
	sb.border_width_top = 1
	sb.border_width_right = 2
	sb.border_width_bottom = 2
	sb.border_color = Color.BLACK
	sb.shadow_size = 3
	sb.shadow_color = Color(0, 0, 0, 0.5)
	win.add_theme_stylebox_override("panel", sb)
	dlg.add_child(win)

	# Title bar
	var title_lbl := Label.new()
	title_lbl.text = "Map Properties"
	title_lbl.position = Vector2(16, 8)
	title_lbl.add_theme_font_override("font", _get_chicago_font())
	title_lbl.add_theme_font_size_override("font_size", 12)
	title_lbl.add_theme_color_override("font_color", Color.BLACK)
	win.add_child(title_lbl)

	var form_y := 34.0
	var font := _get_chicago_font()

	# 1. Map Name
	_add_form_label(win, "Map Name:", Vector2(16, form_y))
	var edit_name := LineEdit.new()
	edit_name.text = map_name
	edit_name.position = Vector2(130, form_y - 2)
	edit_name.size = Vector2(210, 22)
	edit_name.add_theme_font_override("font", font)
	edit_name.add_theme_font_size_override("font_size", 11)
	win.add_child(edit_name)
	form_y += 28.0

	# 2. Game Mode
	_add_form_label(win, "Default Mode:", Vector2(16, form_y))
	var opt_mode := OptionButton.new()
	opt_mode.add_item("Co-operative (reach door together)", 0)
	opt_mode.add_item("Compete (race for highest score)", 1)
	opt_mode.add_item("Versus (battle each other)", 2)
	opt_mode.selected = default_mode
	opt_mode.position = Vector2(130, form_y - 2)
	opt_mode.size = Vector2(210, 22)
	opt_mode.add_theme_font_override("font", font)
	opt_mode.add_theme_font_size_override("font_size", 11)
	win.add_child(opt_mode)
	form_y += 28.0

	# 3. Victory Rule
	_add_form_label(win, "Victory Rule:", Vector2(16, form_y))
	var opt_rule := OptionButton.new()
	opt_rule.add_item("Last Player Alive", 0)
	opt_rule.add_item("Highest Score", 1)
	opt_rule.add_item("First to Exit Door", 2)
	opt_rule.selected = victory_rule
	opt_rule.position = Vector2(130, form_y - 2)
	opt_rule.size = Vector2(210, 22)
	opt_rule.add_theme_font_override("font", font)
	opt_rule.add_theme_font_size_override("font_size", 11)
	win.add_child(opt_rule)
	form_y += 28.0

	# 4. Friendly Fire
	var chk_ff := CheckBox.new()
	chk_ff.text = "Friendly Fire (weapons hit team mates)"
	chk_ff.button_pressed = friendly_fire
	chk_ff.position = Vector2(16, form_y)
	chk_ff.size = Vector2(320, 22)
	chk_ff.add_theme_font_override("font", font)
	chk_ff.add_theme_font_size_override("font_size", 11)
	chk_ff.add_theme_color_override("font_color", Color.BLACK)
	win.add_child(chk_ff)
	form_y += 28.0

	# 5. Starting Lives
	_add_form_label(win, "Starting Lives:", Vector2(16, form_y))
	var spin_lives := SpinBox.new()
	spin_lives.min_value = 1
	spin_lives.max_value = 9
	spin_lives.value = starting_lives
	spin_lives.position = Vector2(130, form_y - 2)
	spin_lives.size = Vector2(80, 22)
	win.add_child(spin_lives)
	form_y += 28.0

	# 6. Bonus Time
	_add_form_label(win, "Bonus Timer:", Vector2(16, form_y))
	var spin_bonus := SpinBox.new()
	spin_bonus.min_value = 1000
	spin_bonus.max_value = 30000
	spin_bonus.step = 500
	spin_bonus.value = bonus_time
	spin_bonus.position = Vector2(130, form_y - 2)
	spin_bonus.size = Vector2(100, 22)
	win.add_child(spin_bonus)
	form_y += 28.0

	# 7. Map Size
	_add_form_label(win, "Board Size:", Vector2(16, form_y))
	var opt_size := OptionButton.new()
	opt_size.add_item("19x13 (Standard)", 0)
	opt_size.add_item("28x19 (Medium)", 1)
	opt_size.add_item("38x26 (Large)", 2)
	opt_size.selected = size_idx
	opt_size.position = Vector2(130, form_y - 2)
	opt_size.size = Vector2(210, 22)
	opt_size.add_theme_font_override("font", font)
	opt_size.add_theme_font_size_override("font_size", 11)
	win.add_child(opt_size)
	form_y += 34.0

	# Buttons: Cancel / OK
	var btn_cancel := Button.new()
	btn_cancel.text = "Cancel"
	btn_cancel.position = Vector2(160, form_y)
	btn_cancel.size = Vector2(80, 24)
	btn_cancel.add_theme_font_override("font", font)
	btn_cancel.add_theme_font_size_override("font_size", 12)
	btn_cancel.pressed.connect(func() -> void: dlg.queue_free())
	win.add_child(btn_cancel)

	var btn_ok := Button.new()
	btn_ok.text = "OK"
	btn_ok.position = Vector2(255, form_y)
	btn_ok.size = Vector2(85, 24)
	btn_ok.add_theme_font_override("font", font)
	btn_ok.add_theme_font_size_override("font_size", 12)
	btn_ok.pressed.connect(func() -> void:
		map_name = edit_name.text.strip_edges()
		if map_name == "": map_name = "custom_map"
		default_mode = opt_mode.selected
		victory_rule = opt_rule.selected
		friendly_fire = chk_ff.button_pressed
		starting_lives = int(spin_lives.value)
		bonus_time = int(spin_bonus.value)
		if opt_size.selected != size_idx:
			_set_canvas_size_idx(opt_size.selected)
		dlg.queue_free()
		_set_status("Map Properties saved")
		queue_redraw()
	)
	win.add_child(btn_ok)


func _add_form_label(parent: Control, text: String, pos: Vector2) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.position = pos
	lbl.add_theme_font_override("font", _get_chicago_font())
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", Color.BLACK)
	parent.add_child(lbl)


# --- Draw ---

func _draw() -> void:
	var vp_size := get_viewport_rect().size
	var font := _get_chicago_font()
	var sb_w := _get_sidebar_width()

	# 1. Background (dark neutral canvas)
	draw_rect(Rect2(0, 20, vp_size.x, vp_size.y - 20), Color(0.1, 0.1, 0.13))

	# 2. Draw Left Palette
	if _sidebar_visible and sb_w > 0:
		var pal_h := vp_size.y - 40.0 # 20px top bar, 20px bottom status
		draw_rect(Rect2(0, 20, sb_w, pal_h), Color(0.14, 0.14, 0.18))
		draw_line(Vector2(sb_w, 20), Vector2(sb_w, 20 + pal_h), Color(0.3, 0.3, 0.38), 1.0)

		var cur_y := 4.0

		# Eraser Button Row
		var is_eraser := (current_brush == 0)
		var eraser_bg := Color(0.28, 0.18, 0.18) if is_eraser else Color(0.18, 0.18, 0.22)
		draw_rect(Rect2(4, 20 + cur_y, sb_w - 10, 22), eraser_bg)
		draw_rect(Rect2(4, 20 + cur_y, sb_w - 10, 22), Color(0.8, 0.3, 0.3) if is_eraser else Color(0.4, 0.4, 0.45), false, 1.0)
		draw_string(font, Vector2(10, 20 + cur_y + 15), "[X] Eraser", HORIZONTAL_ALIGNMENT_LEFT, -1, 10, Color(1.0, 0.8, 0.8))
		cur_y += 26.0

		# Blocks Section Header
		cur_y = _draw_palette_section_header("Blocks", TileCatalog.BLOCK_FAMILIES.size(), cur_y, sb_w, pal_h)

		if not _cat_collapsed.get("Blocks", false):
			# Variant Selector: [Wall | Break | Bkg | Hid]
			var var_y := 20.0 + cur_y - _sidebar_scroll_y
			if var_y + 20.0 >= 20.0 and var_y <= 20.0 + pal_h:
				_draw_variant_selector(var_y, sb_w, font)
			cur_y += 22.0

			# 5x5 Block Family Icon Grid
			for row in range(5):
				for col in range(5):
					var idx := row * 5 + col
					if idx < TileCatalog.BLOCK_FAMILIES.size():
						var item: Dictionary = TileCatalog.BLOCK_FAMILIES[idx]
						var icon_x := 6.0 + col * 26.0
						var icon_y := 20.0 + cur_y + row * 26.0 - _sidebar_scroll_y
						if icon_y + 24.0 >= 20.0 and icon_y <= 20.0 + pal_h:
							var is_sel: bool = (current_family_t == item["t"])
							var b_rect := Rect2(icon_x, icon_y, 24, 24)
							if is_sel:
								draw_rect(b_rect, Color(0.33, 0.33, 0.70))
								draw_rect(b_rect, Color.WHITE, false, 1.0)
							else:
								draw_rect(b_rect, Color(0.2, 0.2, 0.25))

							# Preview texture
							var spr := TileArt.get_sprite("block_sprites", item["frame"], remastered)
							if spr != null:
								draw_texture_rect(spr, b_rect.grow(-2), false)
			cur_y += 5 * 26.0 + 4.0

		# Transporters
		cur_y = _draw_palette_list_section("Transporters", TileCatalog.TRANSPORTERS, cur_y, sb_w, pal_h, font)

		# Stop/Go
		cur_y = _draw_palette_list_section("Stop/Go", TileCatalog.SWITCHES, cur_y, sb_w, pal_h, font)

		# Doors & Keys
		cur_y = _draw_palette_list_section("Doors", TileCatalog.DOORS_AND_KEYS, cur_y, sb_w, pal_h, font)

		# Goodies
		cur_y = _draw_palette_list_section("Goodies", TileCatalog.GOODIES, cur_y, sb_w, pal_h, font)

		# Enemies
		cur_y = _draw_palette_list_section("Enemies", TileCatalog.ENEMIES, cur_y, sb_w, pal_h, font)

		# Spawns
		cur_y = _draw_palette_list_section("Spawns", TileCatalog.SPAWNS, cur_y, sb_w, pal_h, font)

		# Scrollbar indicator
		var total_h := _get_palette_total_height()
		if total_h > pal_h:
			draw_rect(Rect2(sb_w - 5, 20, 5, pal_h), Color(0.1, 0.1, 0.13))
			var thumb_h: float = maxf(16.0, pal_h * (pal_h / total_h))
			var thumb_y: float = 20.0 + (_sidebar_scroll_y / (total_h - pal_h)) * (pal_h - thumb_h)
			draw_rect(Rect2(sb_w - 4, thumb_y, 4, thumb_h), Color(0.4, 0.45, 0.55))

	# 3. Draw Board Playfield (Uniform Zoom & Square Cells)
	var geom := _get_playfield_geom()
	var px: float = geom["x"]
	var py: float = geom["y"]
	var pw: float = geom["w"]
	var ph: float = geom["h"]
	var zoom: float = geom["zoom"]
	var cell_w: float = geom["cell_w"]
	var cell_h: float = geom["cell_h"]

	# Draw authentic metallic 3D beveled frame
	var pf_rect := Rect2(px, py, pw, ph)
	_draw_frame(pf_rect)
	draw_rect(pf_rect, Color.BLACK)

	# Draw Grid Cells
	for r in range(grid_rows):
		for c in range(grid_cols):
			var cell_rect := Rect2(px + c * cell_w, py + r * cell_h, cell_w, cell_h)
			var cell_val: int = cells[r][c]

			if cell_val != 0:
				var info := TileArt.resolve_cell(cell_val)
				var folder: String = info.get("folder", "")
				var frame: int = info.get("frame", 0)
				var is_red: bool = info.get("red", false)
				var facing_left: bool = info.get("facing_left", false)

				if folder != "" and frame > 0:
					var spr := TileArt.get_sprite(folder, frame, remastered, facing_left, is_red)
					if spr != null:
						var lsize := TileArt.logical_size(spr, remastered)
						var spr_w := lsize.x * zoom
						var spr_h := lsize.y * zoom
						var spr_pos := cell_rect.position + (cell_rect.size - Vector2(spr_w, spr_h)) * 0.5
						draw_texture_rect(spr, Rect2(spr_pos, Vector2(spr_w, spr_h)), false)
					else:
						draw_rect(cell_rect, Color(0.3, 0.3, 0.4))
				elif info.get("type", "") == "unknown":
					draw_rect(cell_rect, Color(0.22, 0.08, 0.08))
					draw_rect(cell_rect, Color.RED, false, 1.0)
					draw_string(font, cell_rect.position + Vector2(6, 18) * zoom, "?", HORIZONTAL_ALIGNMENT_CENTER, -1, int(13 * zoom), Color.YELLOW)

				if info.get("hidden", false):
					# Treasure dot in upper-left corner
					draw_circle(cell_rect.position + Vector2(4, 4) * zoom, 2.5 * zoom, Color(1.0, 0.85, 0.2))

			if _show_grid:
				draw_rect(cell_rect, Color(0.2, 0.2, 0.26, 0.35), false, 1.0)

	# Draw Spawns
	draw_circle(Vector2(px + (p1_spawn.x + 0.5) * cell_w, py + (p1_spawn.y + 0.5) * cell_h), cell_w * 0.36, Color.DODGER_BLUE)
	draw_string(font, Vector2(px + p1_spawn.x * cell_w, py + (p1_spawn.y + 0.65) * cell_h), "1", HORIZONTAL_ALIGNMENT_CENTER, int(cell_w), int(10 * zoom), Color.WHITE)

	draw_circle(Vector2(px + (p2_spawn.x + 0.5) * cell_w, py + (p2_spawn.y + 0.5) * cell_h), cell_w * 0.36, Color.LIME_GREEN)
	draw_string(font, Vector2(px + p2_spawn.x * cell_w, py + (p2_spawn.y + 0.65) * cell_h), "2", HORIZONTAL_ALIGNMENT_CENTER, int(cell_w), int(10 * zoom), Color.WHITE)

	if has_p3:
		draw_circle(Vector2(px + (p3_spawn.x + 0.5) * cell_w, py + (p3_spawn.y + 0.5) * cell_h), cell_w * 0.36, Color.CRIMSON)
		draw_string(font, Vector2(px + p3_spawn.x * cell_w, py + (p3_spawn.y + 0.65) * cell_h), "3", HORIZONTAL_ALIGNMENT_CENTER, int(cell_w), int(10 * zoom), Color.WHITE)

	for i in range(4):
		var vs: Vector2i = vs_spawns[i]
		if vs.x > 0 or vs.y > 0:
			draw_circle(Vector2(px + (vs.x + 0.5) * cell_w, py + (vs.y + 0.5) * cell_h), cell_w * 0.28, Color.ORANGE)
			draw_string(font, Vector2(px + vs.x * cell_w, py + (vs.y + 0.65) * cell_h), "V%d" % (i + 1), HORIZONTAL_ALIGNMENT_CENTER, int(cell_w), int(8 * zoom), Color.WHITE)

	# Cell Hover Highlight
	if hover_cell.x >= 0 and hover_cell.x < grid_cols and hover_cell.y >= 0 and hover_cell.y < grid_rows:
		var h_rect := Rect2(px + hover_cell.x * cell_w, py + hover_cell.y * cell_h, cell_w, cell_h)
		draw_rect(h_rect, Color(1, 1, 1, 0.25), false, 1.5)

	# 4. Bottom Status Bar (20px high)
	var status_y := vp_size.y - 20.0
	draw_rect(Rect2(0, status_y, vp_size.x, 20), Color(0.12, 0.12, 0.16))
	draw_line(Vector2(0, status_y), Vector2(vp_size.x, status_y), Color(0.25, 0.25, 0.3), 1.0)

	var left_txt := "Brush: %s" % current_brush_name
	if _hover_palette_desc != "":
		left_txt = _hover_palette_desc
	elif status_msg != "":
		left_txt = status_msg

	draw_string(font, Vector2(8, status_y + 14), left_txt, HORIZONTAL_ALIGNMENT_LEFT, 360, 10, Color(1.0, 0.9, 0.4) if status_msg != "" else Color.WHITE)

	if hover_cell.x >= 0 and hover_cell.x < grid_cols and hover_cell.y >= 0 and hover_cell.y < grid_rows:
		var hinfo := TileArt.resolve_cell(cells[hover_cell.y][hover_cell.x])
		var hname: String = hinfo.get("name", "Empty")
		draw_string(font, Vector2(370, status_y + 14), "(%d, %d): %s" % [hover_cell.x, hover_cell.y, hname], HORIZONTAL_ALIGNMENT_LEFT, 150, 10, Color(0.7, 0.85, 1.0))

	var right_txt := "Facing: %s [F]" % ("Left" if enemy_facing_left else "Right")
	draw_string(font, Vector2(vp_size.x - 110, status_y + 14), right_txt, HORIZONTAL_ALIGNMENT_RIGHT, 100, 10, Color(0.7, 0.7, 0.8))


func _draw_variant_selector(var_y: float, sb_w: float, font: Font) -> void:
	var variants := [
		{"flag": TileCatalog.FLAG_WALL, "label": "Wall", "x": 4.0, "w": 32.0},
		{"flag": TileCatalog.FLAG_BREAKABLE, "label": "Brk", "x": 38.0, "w": 32.0},
		{"flag": TileCatalog.FLAG_BACKGROUND, "label": "Bkg", "x": 72.0, "w": 32.0},
		{"flag": TileCatalog.FLAG_HIDDEN, "label": "Hid", "x": 106.0, "w": 28.0},
	]
	for v in variants:
		var is_active: bool = (current_variant_flag == v["flag"])
		var r := Rect2(v["x"], var_y, v["w"], 18)
		draw_rect(r, Color(0.33, 0.33, 0.70) if is_active else Color(0.2, 0.2, 0.25))
		draw_rect(r, Color.WHITE if is_active else Color(0.35, 0.35, 0.4), false, 1.0)
		draw_string(font, Vector2(v["x"], var_y + 13), v["label"], HORIZONTAL_ALIGNMENT_CENTER, int(v["w"]), 9, Color.WHITE if is_active else Color(0.8, 0.8, 0.85))


func _draw_palette_section_header(title: String, count: int, cur_y: float, sb_w: float, pal_h: float) -> float:
	var is_collapsed: bool = _cat_collapsed.get(title, false)
	var header_y := 20.0 + cur_y - _sidebar_scroll_y
	if header_y + 20.0 >= 20.0 and header_y <= 20.0 + pal_h:
		draw_rect(Rect2(0, header_y, sb_w - 6, 20), Color(0.19, 0.19, 0.25))
		draw_rect(Rect2(0, header_y, sb_w - 6, 20), Color(0.32, 0.32, 0.4), false, 1.0)
		var arrow := "▶ " if is_collapsed else "▼ "
		draw_string(_get_chicago_font(), Vector2(4, header_y + 14), arrow + title, HORIZONTAL_ALIGNMENT_LEFT, int(sb_w - 36), 10, Color(0.9, 0.9, 1.0))
		draw_string(_get_chicago_font(), Vector2(sb_w - 28, header_y + 14), "%d" % count, HORIZONTAL_ALIGNMENT_RIGHT, 20, 9, Color(0.55, 0.55, 0.65))
	return cur_y + 20.0


func _draw_palette_list_section(title: String, items: Array, cur_y: float, sb_w: float, pal_h: float, font: Font) -> float:
	cur_y = _draw_palette_section_header(title, items.size(), cur_y, sb_w, pal_h)
	if not _cat_collapsed.get(title, false):
		for item in items:
			var item_y := 20.0 + cur_y - _sidebar_scroll_y
			if item_y + 22.0 >= 20.0 and item_y <= 20.0 + pal_h:
				var is_selected: bool = (current_brush == item["tile"])
				if is_selected:
					draw_rect(Rect2(2, item_y + 1, sb_w - 10, 20), Color(0.24, 0.28, 0.58))
					draw_rect(Rect2(2, item_y + 1, sb_w - 10, 20), Color(0.5, 0.6, 0.95), false, 1.0)
				else:
					draw_rect(Rect2(2, item_y + 1, sb_w - 10, 20), Color(0.15, 0.15, 0.19))

				var icon_rect := Rect2(4, item_y + 2, 18, 18)
				var tile: int = item["tile"]
				if tile == -1:
					draw_circle(Vector2(13, item_y + 11), 7.0, Color.DODGER_BLUE)
					draw_string(font, Vector2(10, item_y + 15), "1", HORIZONTAL_ALIGNMENT_CENTER, -1, 9, Color.WHITE)
				elif tile == -2:
					draw_circle(Vector2(13, item_y + 11), 7.0, Color.LIME_GREEN)
					draw_string(font, Vector2(10, item_y + 15), "2", HORIZONTAL_ALIGNMENT_CENTER, -1, 9, Color.WHITE)
				elif tile == -3:
					draw_circle(Vector2(13, item_y + 11), 7.0, Color.CRIMSON)
					draw_string(font, Vector2(10, item_y + 15), "3", HORIZONTAL_ALIGNMENT_CENTER, -1, 9, Color.WHITE)
				elif tile >= -7 and tile <= -4:
					draw_circle(Vector2(13, item_y + 11), 7.0, Color.ORANGE)
					draw_string(font, Vector2(7, item_y + 15), "V%d" % (-(tile + 4) + 1), HORIZONTAL_ALIGNMENT_CENTER, -1, 8, Color.WHITE)
				else:
					var folder: String = item.get("folder", "")
					var frame: int = item.get("frame", 0)
					var is_red: bool = item.get("red", false)
					var spr := TileArt.get_sprite(folder, frame, remastered, false, is_red)
					if spr != null:
						draw_texture_rect(spr, icon_rect, false)
					else:
						draw_rect(icon_rect, Color(0.3, 0.4, 0.5))

				var text_color := Color.WHITE if is_selected else Color(0.85, 0.85, 0.9)
				draw_string(font, Vector2(26, item_y + 15), item["name"], HORIZONTAL_ALIGNMENT_LEFT, int(sb_w - 36), 9, text_color)
			cur_y += 22.0
	return cur_y


# --- 3D Beveled Metallic Playfield Frame (matching game.gd) ---

func _round_rect(rect: Rect2, rad: float, col: Color) -> void:
	var x := rect.position.x
	var y := rect.position.y
	var w := rect.size.x
	var h := rect.size.y
	rad = minf(rad, minf(w, h) * 0.5)
	draw_rect(Rect2(x + rad, y, w - rad * 2.0, h), col)
	draw_rect(Rect2(x, y + rad, rad, h - rad * 2.0), col)
	draw_rect(Rect2(x + w - rad, y + rad, rad, h - rad * 2.0), col)
	draw_circle(Vector2(x + rad, y + rad), rad, col)
	draw_circle(Vector2(x + w - rad, y + rad), rad, col)
	draw_circle(Vector2(x + rad, y + h - rad), rad, col)
	draw_circle(Vector2(x + w - rad, y + h - rad), rad, col)


func _draw_frame(pf: Rect2) -> void:
	var t := 16.0
	var rad := 14.0
	var face := Color(0.61, 0.61, 0.65)
	var lite := Color(0.93, 0.93, 0.96)
	var dark := Color(0.33, 0.33, 0.39)
	var o := pf.grow(t)
	_round_rect(o, rad, face)
	var ox := o.position.x
	var oy := o.position.y
	var ow := o.size.x
	var oh := o.size.y
	var ix := pf.position.x
	var iy := pf.position.y
	var iw := pf.size.x
	var ih := pf.size.y
	# top edge
	draw_polygon(PackedVector2Array([Vector2(ox + rad, oy), Vector2(ox + ow - rad, oy), Vector2(ix + iw, iy), Vector2(ix, iy)]),
		PackedColorArray([lite, lite, face, face]))
	# left edge
	draw_polygon(PackedVector2Array([Vector2(ox, oy + rad), Vector2(ix, iy), Vector2(ix, iy + ih), Vector2(ox, oy + oh - rad)]),
		PackedColorArray([lite, face, face, lite]))
	# bottom edge
	draw_polygon(PackedVector2Array([Vector2(ox + rad, oy + oh), Vector2(ix, iy + ih), Vector2(ix + iw, iy + ih), Vector2(ox + ow - rad, oy + oh)]),
		PackedColorArray([dark, face, face, dark]))
	# right edge
	draw_polygon(PackedVector2Array([Vector2(ox + ow, oy + rad), Vector2(ox + ow, oy + oh - rad), Vector2(ix + iw, iy + ih), Vector2(ix + iw, iy)]),
		PackedColorArray([dark, dark, face, face]))
	# inner recessed lip
	draw_rect(Rect2(pf.position - Vector2(1, 1), pf.size + Vector2(2, 2)), Color(0.22, 0.22, 0.27), false, 1.5)


# --- Serialization & BORD Format ---

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
	_put_be16(out, 0, 0)
	_put_be16(out, 2, 0x026D)
	_put_be16(out, 4, 0x0273)
	_put_be16(out, 6, p1_spawn.x)
	_put_be16(out, 8, p1_spawn.y)
	_put_be16(out, 10, p2_spawn.x)
	_put_be16(out, 12, p2_spawn.y)
	_put_be16(out, 14, bonus_time)
	_put_be16(out, 16, 0)
	_put_be16(out, 18, 0)
	_put_be16(out, 20, 0)
	_put_be16(out, 22, 5000)

	var tile_cells := {}
	for r in range(grid_rows):
		for c in range(grid_cols):
			var tile: int = cells[r][c]
			if tile != 0:
				if not tile_cells.has(tile):
					tile_cells[tile] = []
				tile_cells[tile].append(Vector2i(c, r))

	var sorted_tiles := tile_cells.keys()
	sorted_tiles.sort()

	for t in sorted_tiles:
		var start_off := out.size()
		out.resize(start_off + 4)
		_put_be32(out, start_off, t)

		var cell_list: Array = tile_cells[t]
		for coord in cell_list:
			out.append(coord.x)
			out.append(coord.y)
		out.append(100)
		out.append(100)

	out.append(0)
	out.append(0)
	out.append(0)
	out.append(0)

	var ext_bytes := _pack_ext1()
	out.append_array(ext_bytes)
	return out


func _crc16_ccitt(data: PackedByteArray) -> int:
	var crc: int = 0xFFFF
	for b in data:
		crc ^= (b << 8)
		for _i in range(8):
			if (crc & 0x8000) != 0:
				crc = ((crc << 1) ^ 0x1021) & 0xFFFF
			else:
				crc = (crc << 1) & 0xFFFF
	return crc


func _pack_ext1() -> PackedByteArray:
	var flags := 0
	if has_p3:
		flags |= 1
	if friendly_fire:
		flags |= 2
	if grid_cols > 19 or grid_rows > 13:
		flags |= 4
	flags |= (default_mode & 3) << 3

	var body := PackedByteArray()
	body.append(0x45) # E
	body.append(0x58) # X
	body.append(0x54) # T
	body.append(0x31) # 1
	body.append(1)    # version
	body.append(flags)
	body.append(grid_cols)
	body.append(grid_rows)
	body.append(p3_spawn.x)
	body.append(p3_spawn.y)
	body.append(0x02)
	body.append(0x0D)

	for i in range(4):
		var vs: Vector2i = vs_spawns[i]
		body.append(vs.x)
		body.append(vs.y)

	body.append(victory_rule)
	body.append(starting_lives)

	var crc := _crc16_ccitt(body)
	body.append((crc >> 8) & 0xFF)
	body.append(crc & 0xFF)
	return body


func load_from_bord(raw: PackedByteArray) -> bool:
	if raw.size() < 24:
		return false

	p1_spawn = Vector2i(raw[7], raw[9])
	p2_spawn = Vector2i(raw[11], raw[13])
	bonus_time = (raw[14] << 8) | raw[15]

	var cols := 19
	var rows := 13
	var ext_found := false

	if raw.size() >= 48:
		for off in range(raw.size() - 24, 23, -2):
			if raw[off] == 0x45 and raw[off+1] == 0x58 and raw[off+2] == 0x54 and raw[off+3] == 0x31:
				var calc := _crc16_ccitt(raw.slice(off, off + 22))
				var stored := (raw[off + 22] << 8) | raw[off + 23]
				if calc == stored:
					var flags: int = raw[off + 5]
					cols = raw[off + 6]
					rows = raw[off + 7]
					p3_spawn = Vector2i(raw[off + 8], raw[off + 9])
					has_p3 = bool(flags & 1)
					friendly_fire = bool(flags & 2)
					default_mode = (flags >> 3) & 3
					for i in range(4):
						vs_spawns[i] = Vector2i(raw[off + 12 + i * 2], raw[off + 13 + i * 2])
					victory_rule = raw[off + 20]
					starting_lives = raw[off + 21]
					ext_found = true
					break

	if not ext_found:
		has_p3 = false
		friendly_fire = false
		default_mode = 0
		victory_rule = 0
		starting_lives = 3
		for i in range(4):
			vs_spawns[i] = Vector2i(0, 0)

	_init_grid(cols, rows)
	if cols == 38 and rows == 26: size_idx = 2
	elif cols == 28 and rows == 19: size_idx = 1
	else: size_idx = 0

	var offset := 24
	while offset + 4 <= raw.size():
		var tile: int = (raw[offset] << 24) | (raw[offset+1] << 16) | (raw[offset+2] << 8) | raw[offset+3]
		offset += 4
		if tile == 0:
			break
		while offset + 2 <= raw.size():
			var c: int = raw[offset]
			var r: int = raw[offset+1]
			offset += 2
			if c == 100 or r == 100:
				break
			if r < grid_rows and c < grid_cols:
				cells[r][c] = tile

	queue_redraw()
	return true


# --- Dialogs (File Load / Save) ---

func _open_map_dialog() -> void:
	var pop := MacMenuPopup.new()
	pop.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop)
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
	)
	pop.popup_hide.connect(func() -> void: pop.queue_free())
	pop.popup_centered(Vector2i(260, 200))


func _open_original_board_dialog() -> void:
	var pop := MacMenuPopup.new()
	pop.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop)
	var dir := ProjectSettings.globalize_path("res://../extracted/levels")
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
		pop.add_item("No campaign boards found", 0)
		pop.set_item_disabled(0, true)
	else:
		for i in range(mini(maps.size(), 152)):
			pop.add_item(maps[i], i + 1)
	pop.id_pressed.connect(func(id: int) -> void:
		if id > 0 and id <= maps.size():
			var map_file: String = maps[id - 1]
			var map_path: String = dir.path_join(map_file)
			var raw: PackedByteArray = FileAccess.get_file_as_bytes(map_path)
			if load_from_bord(raw):
				map_name = map_file.get_basename()
				_set_status("Loaded campaign %s" % map_file)
	)
	pop.popup_hide.connect(func() -> void: pop.queue_free())
	pop.popup_centered(Vector2i(260, 240))


func save_to_default_file() -> void:
	var dir := "user://custom_maps"
	DirAccess.make_dir_recursive_absolute(dir)
	var path := "%s/%s.bord" % [dir, map_name]
	var raw := serialize_to_bord()
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f != null:
		f.store_buffer(raw)
		f.close()
		_set_status("Saved to %s.bord" % map_name)
	else:
		_set_status("Error saving map file")


func _save_map_as_dialog() -> void:
	var dlg := ConfirmationDialog.new()
	dlg.title = "Save Map As"
	var edit := LineEdit.new()
	edit.text = map_name
	edit.custom_minimum_size = Vector2(200, 24)
	dlg.add_child(edit)
	add_child(dlg)
	dlg.confirmed.connect(func() -> void:
		var fn := edit.text.strip_edges()
		if fn != "":
			map_name = fn
			save_to_default_file()
	)
	dlg.popup_hide.connect(func() -> void: dlg.queue_free())
	dlg.popup_centered()


func _show_info_dialog(title_txt: String, body_txt: String) -> void:
	var dlg := AcceptDialog.new()
	dlg.title = title_txt
	dlg.dialog_text = body_txt
	add_child(dlg)
	dlg.popup_hide.connect(func() -> void: dlg.queue_free())
	dlg.popup_centered()


func _confirm_or_proceed(prompt: String, callback: Callable) -> void:
	var dlg := ConfirmationDialog.new()
	dlg.dialog_text = prompt
	add_child(dlg)
	dlg.confirmed.connect(callback)
	dlg.popup_hide.connect(func() -> void: dlg.queue_free())
	dlg.popup_centered()


# --- Playtest ---

func playtest_in_memory() -> void:
	var warnings := _validate_map()
	if warnings.size() > 0:
		_confirm_or_proceed("Playtest with warnings: %s?" % warnings[0], func() -> void: _do_playtest())
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


# --- CLI Arguments & Self-Test ---

func _check_cli_args() -> void:
	var all_args: Array = OS.get_cmdline_user_args()
	all_args.append_array(OS.get_cmdline_args())
	for arg in all_args:
		if arg == "--test-editor":
			_run_self_test()
			get_tree().quit(0)
		elif arg == "--editorshot":
			_take_editorshot()


func _take_editorshot() -> void:
	# Populate sample board elements to visually verify in-editor remastered rendering
	# 1. Floor row of authentic blocks
	for x in range(1, 18):
		var b_entry: Dictionary = TileCatalog.BLOCK_FAMILIES[(x - 1) % TileCatalog.BLOCK_FAMILIES.size()]
		var b_tile: int = b_entry["t"] | TileCatalog.FLAG_WALL
		cells[11][x] = b_tile

	# 2. Floating platform with different variants
	cells[7][3] = TileCatalog.BLOCK_FAMILIES[0]["t"] | TileCatalog.FLAG_WALL
	cells[7][4] = TileCatalog.BLOCK_FAMILIES[1]["t"] | TileCatalog.FLAG_BREAKABLE
	cells[7][5] = TileCatalog.BLOCK_FAMILIES[2]["t"] | TileCatalog.FLAG_BACKGROUND
	cells[7][6] = TileCatalog.BLOCK_FAMILIES[3]["t"] | TileCatalog.FLAG_HIDDEN | (0x0917 << 16) # Hidden gold coin

	# 3. Transporters, Switches, Doors, Keys, Goodies, Enemies
	cells[10][2] = 0x0A00 # Teleport Red IN
	cells[10][8] = 0x0A01 # Teleport Red OUT
	cells[10][4] = 0x0905 # Universal Key
	cells[10][5] = 0x0906 # Universal Closed Door
	cells[10][12] = 0x090B # Star Bonus
	cells[10][14] = 0x0932 # Speed shoes
	cells[10][16] = 0x1E140705 # Hippo enemy
	cells[6][10] = 0x14000604 # Walker enemy

	queue_redraw()
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var dir := ProjectSettings.globalize_path("res://../media/screenshots")
	DirAccess.make_dir_recursive_absolute(dir)
	img.save_png("%s/editor_palette_verified.png" % dir)
	print("Saved editor screenshot: %s/editor_palette_verified.png" % dir)
	get_tree().quit(0)


func _check(cond: bool, msg: String) -> void:
	if not cond:
		push_error("SELF-TEST FAIL: " + msg)
		get_tree().quit(1)


func _run_self_test() -> void:
	print("--- Running MapEditor Self-Test ---")
	var orig_state := _save_editor_state()

	# 1. Roundtrip test with EXT1
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

	# Reload & verify
	_init_grid(19, 13)
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

	if FileAccess.file_exists(test_path):
		DirAccess.remove_absolute(test_path)

	# 2. Square cell verification
	for sidx in range(3):
		_set_canvas_size_idx(sidx)
		for sb_vis in [true, false]:
			_sidebar_visible = sb_vis
			var geom := _get_playfield_geom()
			var diff := absf(float(geom["cell_w"]) - float(geom["cell_h"]))
			_check(diff < 0.001, "Cells not square at size_idx=%d sidebar=%s: w=%f, h=%f" % [sidx, str(sb_vis), geom["cell_w"], geom["cell_h"]])
			# Verify roundtrip _pos_to_cell
			var c_center := Vector2(geom["x"] + 2.5 * geom["cell_w"], geom["y"] + 2.5 * geom["cell_h"])
			var c_res := _pos_to_cell(c_center)
			_check(c_res == Vector2i(2, 2), "Pos to cell inversion failed at (2, 2): got (%d, %d)" % [c_res.x, c_res.y])

	# 3. Palette Art Audit: Every block family and goody must resolve to a valid non-null sprite
	for b in TileCatalog.BLOCK_FAMILIES:
		var spr_sd := TileArt.get_sprite("block_sprites", b["frame"], false)
		_check(spr_sd != null, "Block family %s frame %d missing in SD" % [b["name"], b["frame"]])
		var spr_hd := TileArt.get_sprite("block_sprites", b["frame"], true)
		_check(spr_hd != null, "Block family %s frame %d missing in HD" % [b["name"], b["frame"]])
		_check(spr_sd.get_width() >= 32 and spr_sd.get_height() >= 32, "Block family %s SD frame size %dx%d < 32x32" % [b["name"], spr_sd.get_width(), spr_sd.get_height()])

	for g in TileCatalog.GOODIES:
		var g_sd := TileArt.get_sprite(g["folder"], g["frame"], false)
		_check(g_sd != null, "Goody %s frame %d missing in SD" % [g["name"], g["frame"]])
		var g_hd := TileArt.get_sprite(g["folder"], g["frame"], true)
		_check(g_hd != null, "Goody %s frame %d missing in HD" % [g["name"], g["frame"]])

	# 4. Check enemy brushes match SoiCore and enemy_type
	var test_core := SoiCore.new()
	for en in TileCatalog.ENEMIES:
		var etype: int = en["etype"]
		var folder: String = en["folder"]
		var frame: int = en["frame"]
		var spr := TileArt.get_sprite(folder, frame, true)
		_check(spr != null, "Enemy %s sprite missing" % en["name"])

		_init_grid(19, 13)
		has_p3 = false
		cells[6][9] = en["tile"]
		var ebord := serialize_to_bord()
		test_core.init(1)
		test_core.load_level(ebord)
		_check(test_core.enemy_count() >= 1, "Enemy %s did not spawn in SoiCore" % en["name"])
		_check(test_core.enemy_type(0) == etype, "Enemy %s etype mismatch: %d != %d" % [en["name"], test_core.enemy_type(0), etype])

	# 5. Check Live3D.POST_SHADER compiles
	var sh := Shader.new()
	sh.code = Live3D.POST_SHADER
	_check(sh.code.count("{") == sh.code.count("}"), "Live3D.POST_SHADER unbalanced braces")

	# Restore state
	_restore_editor_state(orig_state)
	print("MapEditor CLI self-test: PASS")
