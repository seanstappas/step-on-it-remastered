extends Node2D
## game.gd — the playable front-end for the Step On It! remaster.
##
## Owns a SoiCore (the deterministic C core via GDExtension), advances it one
## logic frame per physics tick, translates the keyboard into the per-player
## input bitmask, and renders the world from the core's read-only accessors.
##
## Rendering is deliberately "programmer art" (flat colored cells + entity
## shapes): the faithful retro sprites depend on the `sssf` codec, which is
## still being decoded (docs/original_game/graphics-and-audio.md). This scene
## proves the core is fully playable and observable end to end.

# --- input bitmask (matches enum in core/include/soi_core.h) ---
# Faithful 7-action platformer set (Configure-Keys screen): no up/down walk.
const IN_LEFT := 1 << 0
const IN_RIGHT := 1 << 1
const IN_JUMP := 1 << 2
const IN_BLOCK_HIGH := 1 << 3
const IN_BLOCK_LOW := 1 << 4
const IN_ARROW := 1 << 5
const IN_BALL := 1 << 6

# --- grid geometry (matches core constants) ---
const GRID_COLS := 19
const GRID_ROWS := 13
const CELL_PX := 32
const ORIGIN_X := 16
const ORIGIN_Y := 48
const MAX_ENEMIES := 32
const MAX_PROJECTILES := 8

# cell encoding (matches core/src/soi_internal.h)
const CELL_PERMANENT := 0x100
const CELL_SUPPORTIVE := 0x200   # standable solid block
const CELL_DOOR := 0x800
const CELL_SPECIAL := 0x1000

var _core: SoiCore
var _font: Font
var _shot_countdown := -1
var _demo_frames := -1
var _mode := 0   # display mode: 0 = Retro (faithful 1996 look), 1 = Remastered (glow + vignette)
var _paused := false
var _level_bytes: PackedByteArray

func _ready() -> void:
	_font = ThemeDB.fallback_font
	_core = SoiCore.new()
	_level_bytes = _load_level_bytes()
	if _level_bytes.is_empty():
		push_warning("using built-in demo level")
		_level_bytes = _demo_level()
	_start()

	print("SoiCore ready: P1=(%d,%d) bonus=%d hash=%d" %
		[_core.player_x(1), _core.player_y(1), _core.bonus_time(), _core.state_hash()])
	var ua := OS.get_cmdline_user_args()
	for arg in ua:
		if arg == "--mode=retro": _mode = 0
		elif arg == "--mode=remastered": _mode = 1
	if "--shot" in ua:
		_shot_countdown = 130
		for arg in ua:
			if arg.begins_with("--shotat="):
				_shot_countdown = int(arg.substr(9))
	if "--demo" in ua:
		_demo_frames = 600   # ~10 s of scripted play, then quit (for movie capture)
	set_physics_process(true)

## (re)start the current board from a clean core state.
func _start() -> void:
	_core.init(1)
	_core.load_level(_level_bytes)
	_paused = false

func _physics_process(_delta: float) -> void:
	if not _paused and not _core.game_over() and not _core.level_complete():
		var p1 := _read_input(0)
		if _shot_countdown > 0:
			p1 = IN_RIGHT              # scripted input for the --shot screenshot
		elif _demo_frames > 0:
			p1 = _demo_input()         # scripted play for the --demo movie
		_core.tick(p1, _read_input(1))
		for i in _core.sfx_count():
			Audio.play(_core.sfx_get(i))
	queue_redraw()
	if _demo_frames > 0:
		_demo_frames -= 1
		if _demo_frames == 0:
			get_tree().quit()          # ends the Movie Maker recording
	if _shot_countdown > 0:
		_shot_countdown -= 1
		if _shot_countdown == 0:
			await RenderingServer.frame_post_draw
			var img := get_viewport().get_texture().get_image()
			var dir := ProjectSettings.globalize_path("res://../media/screenshots")
			DirAccess.make_dir_recursive_absolute(dir)
			var stamp := Time.get_datetime_string_from_system().replace(":", "").replace("T", "_").replace("-", "")
			var path := "%s/shot_%s.png" % [dir, stamp]
			img.save_png(path)
			print("saved screenshot -> %s" % path)
			get_tree().quit()

## Scripted input cycle for the --demo movie: runs and jumps/builds so the
## recording shows movement, block create/destroy and jumps.
func _demo_input() -> int:
	match (int(_core.tick_count()) / 35) % 6:
		0: return IN_RIGHT
		1: return IN_JUMP
		2: return IN_RIGHT
		3: return IN_BLOCK_HIGH
		4: return IN_LEFT
		_: return IN_ARROW

func _input(e: InputEvent) -> void:
	if not (e is InputEventKey and e.pressed):
		return
	match e.keycode:
		KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		KEY_P:
			if not _core.game_over():
				_paused = not _paused
		KEY_TAB:
			_mode = 1 - _mode   # toggle Retro <-> Remastered
		KEY_ENTER, KEY_KP_ENTER:
			if _core.game_over():
				_start()   # retry the board
			elif _core.level_complete():
				if Session.advance():
					_level_bytes = _load_level_bytes()   # next board (Session.board_path)
					_start()
				else:
					get_tree().change_scene_to_file("res://scenes/menu.tscn")

# --- input -------------------------------------------------------------------

## Translate the keyboard into a player's input bitmask (7-action platformer).
## Player 0 (P1): Left/Right arrows, Up = jump, Z = block-high, X = block-low,
##   C = magic arrow, V = magic ball.
## Player 1 (P2): A/D, W = jump, F = block-high, G = block-low, H = arrow, J = ball.
func _read_input(which: int) -> int:
	var m := 0
	if which == 0:
		if Input.is_key_pressed(KEY_LEFT): m |= IN_LEFT
		if Input.is_key_pressed(KEY_RIGHT): m |= IN_RIGHT
		if Input.is_key_pressed(KEY_UP): m |= IN_JUMP
		if Input.is_key_pressed(KEY_Z): m |= IN_BLOCK_HIGH
		if Input.is_key_pressed(KEY_X): m |= IN_BLOCK_LOW
		if Input.is_key_pressed(KEY_C): m |= IN_ARROW
		if Input.is_key_pressed(KEY_V): m |= IN_BALL
	else:
		if Input.is_key_pressed(KEY_A): m |= IN_LEFT
		if Input.is_key_pressed(KEY_D): m |= IN_RIGHT
		if Input.is_key_pressed(KEY_W): m |= IN_JUMP
		if Input.is_key_pressed(KEY_F): m |= IN_BLOCK_HIGH
		if Input.is_key_pressed(KEY_G): m |= IN_BLOCK_LOW
		if Input.is_key_pressed(KEY_H): m |= IN_ARROW
		if Input.is_key_pressed(KEY_J): m |= IN_BALL
	return m

# --- rendering ---------------------------------------------------------------

func _draw() -> void:
	# black outside the frame (the original sits on a black CRT field)
	draw_rect(Rect2(0, 0, 640, 480), Color.BLACK)
	var W := GRID_COLS * CELL_PX
	var H := GRID_ROWS * CELL_PX
	var pf := Rect2(ORIGIN_X, ORIGIN_Y, W, H)
	_draw_frame(pf)
	draw_rect(pf, Color.BLACK)   # black playfield

	# grid cells: beveled blocks / red balls / coins / key / door
	for r in range(GRID_ROWS):
		for c in range(GRID_COLS):
			var cell := int(_core.grid_cell(c, r))
			if cell == 0:
				continue
			_draw_cell(cell, Vector2(ORIGIN_X + c * CELL_PX, ORIGIN_Y + r * CELL_PX))

	# projectiles (Magic Arrows) — a small red-tipped dart
	for i in range(MAX_PROJECTILES):
		if _core.projectile_active(i):
			var p := Vector2(_core.projectile_x(i), _core.projectile_y(i)) + Vector2(16, 16)
			_glow(p, 8.0, Color(1, 0.9, 0.2))
			draw_circle(p, 4.0, Color(0.95, 0.85, 0.2))
			draw_circle(p, 2.0, Color(0.9, 0.1, 0.1))

	# enemies
	for i in range(MAX_ENEMIES):
		if _core.enemy_active(i):
			_draw_enemy(Vector2(_core.enemy_x(i), _core.enemy_y(i)), int(_core.enemy_type(i)))

	# players
	_draw_player(1, Color(0.15, 0.25, 0.85))
	_draw_player(2, Color(0.15, 0.6, 0.2))
	_post_fx()

	_draw_hud()
	if _core.game_over():
		_draw_banner("GAME OVER", "Enter: retry     Esc: menu")
	elif _core.level_complete():
		_draw_banner("LEVEL CLEAR!", "Enter: next board     Esc: menu")
	elif _paused:
		_draw_banner("PAUSED", "P: resume     Esc: menu")

func _draw_banner(title: String, hint: String) -> void:
	draw_rect(Rect2(0, 200, 640, 90), Color(0, 0, 0, 0.6))
	draw_string(_font, Vector2(0, 245), title, HORIZONTAL_ALIGNMENT_CENTER, 640, 32, Color.WHITE)
	draw_string(_font, Vector2(0, 275), hint, HORIZONTAL_ALIGNMENT_CENTER, 640, 16, Color(0.85, 0.85, 0.85))

## Soft glow behind an entity (Remastered only).
func _glow(center: Vector2, radius: float, color: Color) -> void:
	if _mode == 0:
		return
	draw_circle(center, radius * 1.9, Color(color.r, color.g, color.b, 0.10))
	draw_circle(center, radius * 1.4, Color(color.r, color.g, color.b, 0.20))

## Full-screen post effects (Remastered only). The faithful Retro view adds
## nothing on top of the playfield.
func _post_fx() -> void:
	if _mode == 1:
		var edge := 40.0
		draw_rect(Rect2(0, 0, 640, edge), Color(0, 0, 0, 0.30))
		draw_rect(Rect2(0, 480 - edge, 640, edge), Color(0, 0, 0, 0.30))
		draw_rect(Rect2(0, 0, edge, 480), Color(0, 0, 0, 0.22))
		draw_rect(Rect2(640 - edge, 0, edge, 480), Color(0, 0, 0, 0.22))

func _draw_player(idx: int, shirt: Color) -> void:
	if not _core.player_alive(idx):
		return
	# flash while invulnerable (post-hit / spawn grace): blink at ~8 Hz
	if _core.player_invuln(idx) > 0 and (int(_core.tick_count()) / 4) % 2 == 0:
		return
	var pos := Vector2(_core.player_x(idx), _core.player_y(idx))
	if _mode == 1:
		_glow(pos + Vector2(16, 16), 14.0, shirt)
	var skin := Color(0.98, 0.8, 0.62)
	var pants := Color(0.12, 0.12, 0.45)
	var facing := int(_core.player_facing(idx))
	# hair / cap
	draw_rect(Rect2(pos + Vector2(11, 3), Vector2(10, 3)), Color(0.35, 0.2, 0.1))
	# head
	draw_circle(pos + Vector2(16, 8), 4.5, skin)
	# body (shirt)
	draw_rect(Rect2(pos + Vector2(11, 12), Vector2(10, 9)), shirt)
	# arms
	draw_rect(Rect2(pos + Vector2(9, 13), Vector2(2, 6)), skin)
	draw_rect(Rect2(pos + Vector2(21, 13), Vector2(2, 6)), skin)
	# legs
	draw_rect(Rect2(pos + Vector2(12, 21), Vector2(3, 9)), pants)
	draw_rect(Rect2(pos + Vector2(17, 21), Vector2(3, 9)), pants)
	# facing eye
	var ex := 2.0 if facing >= 0 else -2.0
	draw_circle(pos + Vector2(16 + ex, 8), 1.3, Color.BLACK)

func _draw_hud() -> void:
	var blue := Color(0.16, 0.22, 0.95)
	var red := Color(0.85, 0.12, 0.12)
	var fs := 15
	var y := 20.0
	# Score (blue label + red digits) — original: "Score 0000000000"
	draw_string(_font, Vector2(18, y), "Score", HORIZONTAL_ALIGNMENT_LEFT, -1, fs, blue)
	draw_string(_font, Vector2(64, y), "%010d" % _core.player_score(1), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, red)
	# Bonus
	draw_string(_font, Vector2(208, y), "Bonus", HORIZONTAL_ALIGNMENT_LEFT, -1, fs, blue)
	draw_string(_font, Vector2(256, y), "%05d" % _core.bonus_time(), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, red)
	# lives (face icon + count)
	_hud_face(Vector2(330, 8))
	draw_string(_font, Vector2(348, y), "%02d" % _core.player_lives(1), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, blue)
	# arrows (dart icon + count)
	_hud_arrow(Vector2(388, 6))
	draw_string(_font, Vector2(398, y), "%02d" % _core.player_arrows(1), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, blue)
	# potion (flask icon + count)
	_hud_potion(Vector2(436, 6))
	draw_string(_font, Vector2(452, y), "%02d" % _core.player_shield(1), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, blue)
	# Board number (red)
	draw_string(_font, Vector2(516, y), "Board#%03d" % _board_number(), HORIZONTAL_ALIGNMENT_LEFT, -1, fs, red)
	# key-held indicator
	if _core.player_has_key(1) >= 1:
		_draw_key(Vector2(608, 4))
	if not _core.player_alive(1) and not _core.game_over():
		draw_string(_font, Vector2(18, 44), "RESPAWNING…", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1.0, 0.6, 0.6))

func _board_number() -> int:
	if Session.board_index >= 0:
		return Session.board_index + 1
	return 1

# --- HUD icons ---------------------------------------------------------------
func _hud_face(p: Vector2) -> void:
	draw_circle(p + Vector2(6, 6), 6, Color(0.98, 0.8, 0.62))
	draw_circle(p + Vector2(4, 5), 1, Color.BLACK)
	draw_circle(p + Vector2(8, 5), 1, Color.BLACK)
	draw_rect(Rect2(p + Vector2(4, 8), Vector2(4, 1)), Color(0.6, 0.2, 0.15))

func _hud_arrow(p: Vector2) -> void:
	draw_rect(Rect2(p + Vector2(3, 3), Vector2(2, 9)), Color(0.85, 0.12, 0.12))
	draw_colon_triangle(p)

func draw_colon_triangle(p: Vector2) -> void:
	var pts := PackedVector2Array([p + Vector2(1, 4), p + Vector2(7, 4), p + Vector2(4, 0)])
	draw_colored_polygon(pts, Color(0.9, 0.85, 0.85))

func _hud_potion(p: Vector2) -> void:
	draw_rect(Rect2(p + Vector2(4, 0), Vector2(3, 3)), Color(0.6, 0.6, 0.65))     # neck
	draw_circle(p + Vector2(5.5, 8), 5, Color(0.2, 0.8, 0.3))                     # bulb
	draw_circle(p + Vector2(4, 7), 1.5, Color(0.6, 1.0, 0.7))                     # shine

# --- faithful cell / entity drawing ------------------------------------------

## Grey 3D beveled frame around the playfield (the original's raised border).
func _draw_frame(pf: Rect2) -> void:
	var t := 12.0
	var o := Rect2(pf.position - Vector2(t, t), pf.size + Vector2(t * 2, t * 2))
	draw_rect(o, Color(0.74, 0.74, 0.77))
	draw_rect(Rect2(o.position, Vector2(o.size.x, 3)), Color(0.93, 0.93, 0.96))
	draw_rect(Rect2(o.position, Vector2(3, o.size.y)), Color(0.93, 0.93, 0.96))
	draw_rect(Rect2(o.position + Vector2(0, o.size.y - 3), Vector2(o.size.x, 3)), Color(0.42, 0.42, 0.47))
	draw_rect(Rect2(o.position + Vector2(o.size.x - 3, 0), Vector2(3, o.size.y)), Color(0.42, 0.42, 0.47))
	# inner groove framing the black field
	draw_rect(Rect2(pf.position - Vector2(3, 3), pf.size + Vector2(6, 6)), Color(0.30, 0.30, 0.34), false, 3.0)

## Dispatch a grid cell to the right sprite by its flags + low-byte type.
func _draw_cell(cell: int, pos: Vector2) -> void:
	var t := cell & 0xFF
	if t == 0x0B:
		_draw_key(pos)
	elif cell & CELL_SUPPORTIVE:
		if t == 0x2B:
			_draw_ball(pos, Color(0.85, 0.13, 0.13))
		elif t == 0x0D or t == 0x13 or t == 0x14:
			_draw_block(pos, Color(0.85, 0.16, 0.16))     # red block
		else:
			_draw_block(pos, Color(0.87, 0.87, 0.90))     # white block
	elif (cell & CELL_DOOR) and t <= 3:
		_draw_door(pos)
	elif (cell & CELL_DOOR) or t == 0x0A or t == 0x17 or t == 0x18 or t == 0x19:
		_draw_coin(pos, t == 0x17 or t == 0x19)
	else:
		# other goodie / decorative overlay: a small marker
		draw_circle(pos + Vector2(16, 16), 6, Color(0.5, 0.5, 0.9, 0.8))

## A rounded 3D-beveled block (white or red gumdrop tile).
func _draw_block(pos: Vector2, base: Color) -> void:
	var s := float(CELL_PX)
	draw_rect(Rect2(pos + Vector2(1, 1), Vector2(s - 2, s - 2)), base)
	draw_rect(Rect2(pos + Vector2(1, 1), Vector2(s - 2, 3)), base.lightened(0.45))   # top hi
	draw_rect(Rect2(pos + Vector2(1, 1), Vector2(3, s - 2)), base.lightened(0.45))   # left hi
	draw_rect(Rect2(pos + Vector2(1, s - 4), Vector2(s - 2, 3)), base.darkened(0.4)) # bottom sh
	draw_rect(Rect2(pos + Vector2(s - 4, 1), Vector2(3, s - 2)), base.darkened(0.4)) # right sh
	draw_rect(Rect2(pos + Vector2(5, 5), Vector2(9, 5)), base.lightened(0.7))        # gloss

## A shaded red sphere (the ball tile at structure corners).
func _draw_ball(pos: Vector2, base: Color) -> void:
	var c := pos + Vector2(16, 16)
	draw_circle(c, 15, base.darkened(0.4))
	draw_circle(c, 13, base)
	draw_circle(c - Vector2(3, 3), 6, base.lightened(0.4))
	draw_circle(c - Vector2(4.5, 4.5), 2.4, Color(1, 1, 1, 0.9))

## A silver/gold "$" coin.
func _draw_coin(pos: Vector2, gold: bool) -> void:
	var c := pos + Vector2(16, 16)
	var rim := Color(0.78, 0.6, 0.12) if gold else Color(0.5, 0.5, 0.55)
	var face := Color(1.0, 0.85, 0.2) if gold else Color(0.82, 0.82, 0.86)
	draw_circle(c, 12, rim)
	draw_circle(c, 10, face)
	draw_circle(c - Vector2(3, 3), 3, face.lightened(0.4))
	draw_string(_font, c + Vector2(-4, 5), "$", HORIZONTAL_ALIGNMENT_LEFT, -1, 13,
		Color(0.5, 0.4, 0.05) if gold else Color(0.32, 0.32, 0.38))

## A red key.
func _draw_key(pos: Vector2) -> void:
	var red := Color(0.85, 0.1, 0.1)
	var c := pos + Vector2(16, 9)
	draw_circle(c, 5, red)
	draw_circle(c, 2.3, Color.BLACK)
	draw_rect(Rect2(pos + Vector2(14.5, 12), Vector2(3, 15)), red)
	draw_rect(Rect2(pos + Vector2(14.5, 22), Vector2(6, 3)), red)
	draw_rect(Rect2(pos + Vector2(14.5, 26), Vector2(5, 3)), red)

## The exit door.
func _draw_door(pos: Vector2) -> void:
	draw_rect(Rect2(pos + Vector2(4, 2), Vector2(24, 28)), Color(0.35, 0.22, 0.1))
	draw_rect(Rect2(pos + Vector2(6, 4), Vector2(20, 26)), Color(0.6, 0.4, 0.16))
	draw_circle(pos + Vector2(23, 16), 2, Color(1, 0.85, 0.2))

## A small creature body (per-type hue until real sprites land).
func _draw_enemy(e: Vector2, etype: int) -> void:
	var c := e + Vector2(16, 16)
	var body := _enemy_color(etype)
	if _mode == 1:
		_glow(c, 12.0, body)
	draw_circle(c, 11, body.darkened(0.25))
	draw_circle(c, 9, body)
	draw_circle(c + Vector2(-3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(-3.5, -3), 1.0, Color.BLACK)
	draw_circle(c + Vector2(3.5, -3), 1.0, Color.BLACK)

func _enemy_color(etype: int) -> Color:
	# distinct hue per bestiary index (1..11) until real sprites land
	var h := fposmod(float(etype) * 0.13, 1.0)
	return Color.from_hsv(h, 0.7, 0.95)

# --- level loading -----------------------------------------------------------

func _load_level_bytes() -> PackedByteArray:
	# 1) a board explicitly chosen in the menu (absolute path via Session autoload)
	if Session.board_path != "":
		var chosen := FileAccess.get_file_as_bytes(Session.board_path)
		if not chosen.is_empty():
			return chosen
	# 2) otherwise fall back to a bundled/extracted default
	var candidates := [
		"res://../extracted/levels/board_401.bord",
		"res://levels/board_401.bord",
	]
	for path in candidates:
		var b := FileAccess.get_file_as_bytes(path)
		if not b.is_empty():
			return b
	return PackedByteArray()

## Build a tiny synthetic BORD in memory so the scene always has something to
## show. Mirrors tests/harness.c: a floor row + a couple of coins.
func _demo_level() -> PackedByteArray:
	var b := PackedByteArray()
	b.resize(256)
	b.fill(0)
	# header (big-endian u16 fields)
	b[0x07] = 3          # P1 col = 3
	b[0x09] = 11         # P1 row = 11 (on the floor)
	b[0x0B] = 9          # P2 col = 9
	b[0x0D] = 11         # P2 row = 11
	b[0x16] = 0x13; b[0x17] = 0x88   # bonus = 5000
	var n := 0x18
	# record 1: permanent floor (0x300) across the bottom row 12, all 19 columns
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x03; b[n + 3] = 0x00; n += 4
	for c in range(GRID_COLS):
		b[n] = c; b[n + 1] = 12; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# record 2: gold coins (0x17) floating in mid-air (col, row)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x17; n += 4
	b[n] = 5; b[n + 1] = 6; n += 2
	b[n] = 7; b[n + 1] = 6; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# terminator record (tile_type 0)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x00; n += 4
	b.resize(n)
	return b
