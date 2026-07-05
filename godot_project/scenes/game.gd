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

# Choreographed showcase for the --demo movie: [action_bitmask, frames]. Core
# actions are edge-triggered, so a short pulse fires exactly one jump/block/shot.
const DEMO := [
	[0, 40],                       # settle on the floor (start col 3)
	[IN_RIGHT, 190], [0, 30],      # run right, scooping arrows (5,6,7) + ball ammo (8,9)
	[IN_BALL, 6], [0, 55],         # fire a Magic Ball: a red ball ROLLS along the ground
	[IN_BALL, 6], [0, 50],         # roll another
	[IN_JUMP, 6], [0, 70],         # a plain jump -> shows the somersault spin
	[IN_ARROW, 6], [0, 40],        # fire a Magic Arrow -> it RICOCHETS up the right wall
	[IN_ARROW, 6], [0, 60],        # fire another -> watch them pinball
	[IN_LEFT, 90], [0, 15],        # step back...
	[IN_BLOCK_HIGH, 6], [0, 45],   # build a block in front (same row)
	[IN_BLOCK_HIGH, 6], [0, 55],   # knock it back out
]

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
const CELL_CRACKED := 0x4000     # head-bonked once; a second bonk breaks it

var _core: SoiCore
var _font: Font
var _font_hud: Font   # bold serif (original HUD font = Mac "New York" bold)
var _shot_countdown := -1
var _demo_frames := -1
var _play_frames := -1   # --play=N: play the loaded (real) board for N frames, then quit
var _enemy_lastpos := {}   # slot -> Vector2, for travel-synced enemy animation
var _enemy_walk := {}      # slot -> float, accumulated movement distance
var _proj_lastpos := {}    # projectile idx -> Vector2, to aim the arrow along travel
var _grid_prev := {}       # cell key -> last-frame cell value (create/destroy detection)
var _cell_fx := {}         # cell key -> { grow:bool, cell:int, t:float } grow/shrink pop
var _mode := 0   # display mode: 0 = Retro (faithful 1996 look), 1 = Remastered (glow + vignette)
var _paused := false
var _level_bytes: PackedByteArray

# --- real sprite pipeline (decoded from the original sssf, tools/sssf_decode.py) ---
const SPRITES_DIR := "res://../extracted/sprites"
# Player (Ted) animation frames into BP_sprites / GP_sprites (CONFIRMED: the sheet
# has SEPARATE left/right blocks — idle 61 right / 52 left; run cycles follow each
# idle; jump 133; land 26). Frames are directional, so run/idle are NOT flipped.
# All BP/GP player art faces RIGHT; left is drawn by flipping. (Earlier notes
# claimed 52-60 were a left-facing block -- they are NOT, they also face right.)
const PLAYER_IDLE := 61          # standing pose
const PLAYER_RUN := 25           # REAL run cycle f25-f36 (right-facing; flipped for left) -- asm FUN_10012bf4 0x19..0x24
const PLAYER_RUN_CYCLE := 12
const PLAYER_RUN_PX := 2.0       # asm advances the leg frame 1 per 2px moved (matches the 2px/tick run)
const PLAYER_JUMP_FRAME := 133   # right-facing leap; flipped for left (asm FUN_10013404 +0x10 0x85..0x8D)
const PLAYER_JUMP_CYCLE := 9     # jump animates frames 133..141 while airborne
# The DEATH throw (hit by a nasty / thrown off) is a SOMERSAULT: the asm cycles the
# LARGER 36x34 frames 0x76..0x7D (FUN_10011fcc, gated on the dying flag). This is a
# DIFFERENT animation from the jump above -- do not use it for a plain jump.
const PLAYER_DEATH_SPIN := [118, 119, 120, 121, 122, 123, 124, 125]
const PLAYER_LAND_FRAME := 26
# The standing pose is DIRECTIONAL, not a flip: idle (asm FUN_100128f8) and fall
# (asm FUN_1001386c) both set frame 0x3D facing right / 0x34 facing left.
const PLAYER_STAND_R := 61
const PLAYER_STAND_L := 52
# Core enemy enum (soi_core.h) -> decoded sssf sprite folder.
const ENEMY_FOLDER := {
	1: "ant_sprites", 2: "ostrich_sprites", 3: "hippo_sprites", 4: "piggy_sprites",
	5: "disk_sprites", 6: "smiley_sprites", 7: "hammer_sprites", 8: "beenie_sprites",
	9: "robo_sprites", 10: "walker_sprites", 11: "teeth_sprites",
	12: "cannon_sprites", 13: "spinner_sprites", 14: "Gargoyle_sprites", 15: "knight_sprites",
}
# Enemies whose whole frame set is a ROLL cycle (a ball tumbling along the
# ground) rather than a leg walk: the smiley "face-ball" (etype 6) is a red ball
# whose three holes rotate right through its ~47 frames. It must roll with travel
# (reversing when it moves left), not twitch between 4 walk frames.
const ENEMY_ROLL := { 6: true }
# Enemies that SPIN in place on a timer (rotate through their whole sheet): the
# Spinner trap (etype 13, 14 frames) and the flying star-disk Wheelie (etype 5,
# a green orb with a rotating red star, 22 frames). etype -> frame count.
const ENEMY_SPIN := { 5: 22, 13: 14 }
# Stationary turrets that IDLE then CHARGE an energy orb as their reload nears 0
# and RELEASE it at the shot (asm FUN_10008618 gargoyle / FUN_10008b18 knight).
#   etype: { idle:[start,count], charge:[start,count] }  (charge over the last 30 reload frames)
const ENEMY_SHOOTER := {
	14: { "idle": [12, 9], "charge": [42, 31] },   # gargoyle: idle wings f12-20, red-orb charge f42-72
	15: { "idle": [12, 9], "charge": [52, 13] },   # knight:   idle f12-20, yellow-orb charge f52-64
}
# Per-enemy WALK cycles. Enemy sheets carry the walk as an explicit run of frames;
# several (pig, sheep) hold SEPARATE left- and right-facing runs, so we pick the
# matching run by travel direction instead of mirroring one fixed set -- mirroring
# 4 fixed frames is what produced the choppy "moonwalk". Format:
#   etype: { "r":[start,count], "l":[start,count], "flip":bool }
# "flip" mirrors the run for left travel only when the sheet is a single symmetric
# view (e.g. the top-down ant, whose left/right runs are the same frames).
const ENEMY_WALK := {
	1:  { "r": [2, 12],  "l": [2, 12],  "flip": false },   # ant: symmetric top-down, 12-frame cycle
	2:  { "r": [2, 12],  "l": [21, 12], "flip": false },   # ostrich: right f02-13, left f21-32
	3:  { "r": [21, 12], "l": [2, 12],  "flip": false },   # hippo: right f21-32, left f02-13
	4:  { "r": [21, 12], "l": [2, 8],   "flip": false },   # piggy: right f21-32, left f02-09
	7:  { "r": [2, 10],  "l": [12, 10], "flip": false },   # hammer: run/hop right f02-11, left f12-21
	8:  { "r": [66, 12], "l": [66, 12], "flip": true  },   # beanie: floating kid, propeller-cap body
	9:  { "r": [38, 12], "l": [62, 12], "flip": false },   # robo: right-walk f38-49, left-walk f62-73
	10: { "r": [2, 12],  "l": [26, 12], "flip": false },   # sheep/walker: right f02-13, left f26-37
	11: { "r": [2, 12],  "l": [2, 12],  "flip": true  },   # teeth: symmetric chomp cycle, mirror to face
}
var _sprite_index := {}   # folder -> { frame:int -> absolute path }
var _tex_cache := {}      # "folder/frame/flip" -> Texture2D (or null)
var _p_lastx := {}        # player idx -> last x (run-animation motion tracking)
var _p_runtimer := {}     # player idx -> frames of run animation left to play
var _p_walkdist := {}     # player idx -> accumulated |travel| px (leg cadence)

## Build (once) a frame->path map for a sprite folder by parsing "fNN_WxH.png".
func _folder_index(folder: String) -> Dictionary:
	if _sprite_index.has(folder):
		return _sprite_index[folder]
	var idx := {}
	var dir := ProjectSettings.globalize_path("%s/%s" % [SPRITES_DIR, folder])
	var da := DirAccess.open(dir)
	if da:
		for f in da.get_files():
			if f.begins_with("f") and f.ends_with(".png"):
				var us := f.find("_")
				if us > 1:
					idx[int(f.substr(1, us - 1))] = dir + "/" + f
	_sprite_index[folder] = idx
	return idx

## Load (cached) one decoded sprite frame as a Texture2D, or null if missing.
## `flip` returns a horizontally mirrored variant (for left-facing entities).
func _sprite(folder: String, frame: int, flip: bool = false) -> Texture2D:
	var key := "%s/%d/%s" % [folder, frame, flip]
	if _tex_cache.has(key):
		return _tex_cache[key]
	var idx := _folder_index(folder)
	var tex: Texture2D = null
	if idx.has(frame):
		var img := Image.load_from_file(idx[frame])
		if img:
			if flip:
				img.flip_x()
			tex = ImageTexture.create_from_image(img)
	_tex_cache[key] = tex
	return tex

## Draw a sprite centered in a 32x32 cell at pos (nearest-neighbour, no scaling
## up beyond native). Returns true if a real sprite was drawn.
func _blit(folder: String, frame: int, pos: Vector2) -> bool:
	var tex := _sprite(folder, frame)
	if tex == null:
		return false
	var s := tex.get_size()
	draw_texture(tex, pos + (Vector2(CELL_PX, CELL_PX) - s) * 0.5)
	return true

## Draw the Magic Arrow (goody f19, a red arrow whose art points UP) rotated so
## it aims along its travel direction, inferred from frame-to-frame movement (the
## core exposes no velocity). Falls back to a red dart if the sprite is missing.
func _draw_arrow(i: int, c: Vector2, pp: Vector2) -> void:
	var tex := _sprite("goody_sprites", 19)
	if tex == null:
		draw_circle(c, 4.0, Color(0.9, 0.15, 0.15))
		return
	var last: Vector2 = _proj_lastpos.get(i, pp)
	var d := pp - last
	var ang := -PI / 2.0                     # first frame: keep the art pointing up
	if d.length() > 0.5:
		ang = d.angle() + PI / 2.0           # f19 art points up (-Y); align it to velocity
	draw_set_transform(c, ang, Vector2.ONE)
	draw_texture(tex, -tex.get_size() * 0.5)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

# --- decoded PICT full-screen art (tools/pict_decode.py) ---
const PICT_DIR := "res://../extracted/pict"
var _pict_cache := {}
func _pict(name_substr: String) -> Texture2D:
	if _pict_cache.has(name_substr):
		return _pict_cache[name_substr]
	var tex: Texture2D = null
	var dir := ProjectSettings.globalize_path(PICT_DIR)
	var da := DirAccess.open(dir)
	if da:
		for f in da.get_files():
			if f.ends_with(".png") and name_substr in f:
				var img := Image.load_from_file(dir + "/" + f)
				if img:
					tex = ImageTexture.create_from_image(img)
				break
	_pict_cache[name_substr] = tex
	return tex

## Draw a decoded PICT screen centered on the 640x480 view, with a hint line.
## Falls back to the plain banner if the art is missing.
func _draw_pict_screen(name_substr: String, title: String, hint: String) -> void:
	var t := _pict(name_substr)
	if t == null:
		_draw_banner(title, hint)
		return
	draw_rect(Rect2(0, 0, 640, 480), Color.BLACK)
	draw_texture(t, ((Vector2(640, 480) - t.get_size()) * 0.5).floor())
	draw_string(_font, Vector2(0, 452), hint, HORIZONTAL_ALIGNMENT_CENTER, 640, 15, Color(0.9, 0.9, 0.95))


func _ready() -> void:
	_font = ThemeDB.fallback_font
	# HUD font: the original draws ALL text in Mac "Times" BOLD (font id 0x14 = 20,
	# TextFace(1)); the HUD score bar is Times Bold ~14pt. Resolve Times via the OS
	# (Times New Roman on Windows), crisp (no AA) for the retro bitmap-font look.
	var sf := SystemFont.new()
	sf.font_names = PackedStringArray(["Times New Roman", "Times", "Liberation Serif", "serif"])
	sf.font_weight = 700
	sf.antialiasing = TextServer.FONT_ANTIALIASING_NONE
	_font_hud = sf
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
		_level_bytes = _showcase_level()   # purpose-built board with room to show off
		_start()
		var total := 40
		for seg in DEMO:
			total += int(seg[1])
		_demo_frames = total               # scripted play, then quit (for movie capture)
	for arg in ua:
		if arg.begins_with("--play="):
			_play_frames = int(arg.substr(7))   # record the real board (no showcase override)
	set_physics_process(true)

## (re)start the current board from a clean core state.
func _start() -> void:
	_core.init(1)
	_core.load_level(_level_bytes)
	_paused = false

func _physics_process(_delta: float) -> void:
	if not _paused and not _core.game_over() and not _core.level_complete():
		var p1 := _read_input(0)
		if _demo_frames > 0:
			p1 = _demo_input()         # scripted play for the --demo movie / capture
		elif _play_frames > 0:
			p1 = _play_input()         # scripted play on a real board (--play recording)
		elif _shot_countdown > 0:
			p1 = IN_RIGHT              # scripted input for a plain --shot screenshot
		_core.tick(p1, _read_input(1))
		for i in _core.sfx_count():
			Audio.play(_core.sfx_get(i))
	queue_redraw()
	if _demo_frames > 0:
		_demo_frames -= 1
		if _demo_frames == 0:
			get_tree().quit()          # ends the Movie Maker recording
	if _play_frames > 0:
		_play_frames -= 1
		if _play_frames == 0:
			get_tree().quit()          # ends the real-board Movie Maker recording
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

## Real-board recording input (--play): hold the opening layout briefly so it
## reads, then walk right off the ledge so player one falls off the cliff.
func _play_input() -> int:
	if int(_core.tick_count()) < 24:
		return 0
	return IN_RIGHT

## Scripted input for the --demo movie: walk the DEMO timeline by tick so the
## recording shows a run, jumps, block create/destroy (incl. the mid-air
## jump-smash) and each weapon in turn.
func _demo_input() -> int:
	var t := int(_core.tick_count())
	var acc := 0
	for seg in DEMO:
		acc += int(seg[1])
		if t < acc:
			return int(seg[0])
	return 0

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

	# grid cells: beveled blocks / red balls / coins / key / door. A cell that just
	# became solid GROWS in (small->big); one just cleared SHRINKS out (big->small),
	# matching the original's block build/break pop.
	for r in range(GRID_ROWS):
		for c in range(GRID_COLS):
			var key := r * GRID_COLS + c
			var cell := int(_core.grid_cell(c, r))
			var prev: int = _grid_prev.get(key, 0)
			_grid_prev[key] = cell
			var pos := Vector2(ORIGIN_X + c * CELL_PX, ORIGIN_Y + r * CELL_PX)
			if (cell & CELL_SUPPORTIVE) and not (prev & CELL_SUPPORTIVE):
				_cell_fx[key] = { "grow": true, "cell": cell, "t": 0.0 }
			elif (prev & CELL_SUPPORTIVE) and not (cell & CELL_SUPPORTIVE):
				_cell_fx[key] = { "grow": false, "cell": prev, "t": 0.0 }
			if _cell_fx.has(key):
				var fx: Dictionary = _cell_fx[key]
				fx["t"] = float(fx["t"]) + 0.16
				if float(fx["t"]) < 1.0:
					var sc: float = float(fx["t"]) if fx["grow"] else (1.0 - float(fx["t"]))
					_draw_cell_scaled(int(fx["cell"]), pos, maxf(sc, 0.05))
					continue
				_cell_fx.erase(key)   # settle: fall through to the normal full-size draw
			if cell == 0:
				continue
			_draw_cell(cell, pos)

	# projectiles: BOTH the Magic Ball and Magic Arrow are the SAME spinning red-white
	# swirl -- the same projectile bank 0x83 in the asm (ball = index 9/10, arrow =
	# index 1, FUN_1000fd5c). They differ by BEHAVIOUR (ball rolls, arrow ricochets),
	# not by art. The pointed red arrow / potion are the AMMO PICKUP icons, not shots.
	# A hostile shot is a bolt.
	for i in range(MAX_PROJECTILES):
		if _core.projectile_active(i):
			var pp := Vector2(_core.projectile_x(i), _core.projectile_y(i))
			var c := pp + Vector2(16, 16)
			if _core.projectile_hostile(i):
				if _core.projectile_src_type(i) == 12:    # Cannon: its spinning beach ball (f04-21)
					if _mode == 1:
						_glow(c, 9.0, Color(1, 0.5, 0.2))
					var bf := 4 + (int(_core.tick_count() / 2) % 18)
					if not _blit("cannon_sprites", bf, pp):
						draw_circle(c, 6.0, Color(0.9, 0.3, 0.2))
				elif _core.projectile_src_type(i) == 14:  # Gargoyle: a short-range PUFF (breath), not a bolt
					if _mode == 1:
						_glow(c, 12.0, Color(1, 0.5, 0.2))
					draw_circle(c, 8.0, Color(0.85, 0.5, 0.25, 0.30))
					draw_circle(c + Vector2(-3, -2), 4.5, Color(0.95, 0.65, 0.35, 0.55))
					draw_circle(c + Vector2(3, 2), 4.0, Color(0.90, 0.55, 0.30, 0.50))
				else:                                     # Knight: an energy bolt
					_glow(c, 9.0, Color(0.85, 0.2, 0.95))
					draw_circle(c, 5.0, Color(0.65, 0.1, 0.75))
					draw_circle(c, 2.5, Color(1, 0.55, 1))
			elif _core.projectile_kind(i) == 1:
				# Magic Ball: the spinning red-white swirl (weapons sheet f02..f09)
				if _mode == 1:
					_glow(c, 10.0, Color(1, 0.4, 0.2))
				var wf := 2 + (int(_core.tick_count() / 2) % 8)   # spin the 8 weapon frames
				if not _blit("weapons", wf, pp):
					draw_circle(c, 7.0, Color(0.82, 0.14, 0.1))
			else:
				# Magic Arrow: ALSO the spinning red-white swirl (same bank as the ball;
				# arrow = bank index 1). It differs from the ball only in BEHAVIOUR
				# (it ricochets). The red arrow icon (goody f19) is the ammo PICKUP.
				if _mode == 1:
					_glow(c, 8.0, Color(1, 0.35, 0.2))
				var af := 2 + (int(_core.tick_count() / 2) % 8)
				if not _blit("weapons", af, pp):
					draw_circle(c, 7.0, Color(0.82, 0.14, 0.1))
			_proj_lastpos[i] = pp

	# enemies
	for i in range(MAX_ENEMIES):
		if _core.enemy_active(i):
			_draw_enemy(i, Vector2(_core.enemy_x(i), _core.enemy_y(i)),
				int(_core.enemy_type(i)), int(_core.enemy_dir(i)))

	# players
	_draw_player(1, Color(0.15, 0.25, 0.85))
	_draw_player(2, Color(0.15, 0.6, 0.2))
	_post_fx()

	_draw_hud()
	if _core.game_over():
		_draw_banner("GAME OVER", "Enter: retry     Esc: menu")
	elif _core.level_complete():
		_draw_pict_screen("board_completed", "LEVEL CLEAR!", "Enter: next board     Esc: menu")
	elif _paused:
		_draw_pict_screen("paused", "PAUSED", "P: resume     Esc: menu")

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
	var facing := int(_core.player_facing(idx))
	var right := facing >= 0
	var st := int(_core.player_state(idx))
	# The core's ground_state flickers idle<->run between grid steps, so keep the run
	# alive briefly off actual horizontal motion. Advance the leg cycle by DISTANCE
	# travelled (not the wall clock) so the feet stay planted to the ground.
	var dx: float = pos.x - float(_p_lastx.get(idx, pos.x))
	_p_lastx[idx] = pos.x
	if absf(dx) > 0.5 or st == 1:
		_p_runtimer[idx] = 6
		_p_walkdist[idx] = float(_p_walkdist.get(idx, 0.0)) + absf(dx)
	elif _p_runtimer.get(idx, 0) > 0:
		_p_runtimer[idx] = int(_p_runtimer[idx]) - 1
	# idle/fall default: a static DIRECTIONAL pose (asm idle FUN_100128f8 + fall
	# FUN_1001386c both set frame 0x3D right / 0x34 left -- distinct left/right art).
	# Jump / death / run below use right-facing art flipped for left.
	var frame := PLAYER_STAND_R if right else PLAYER_STAND_L
	var flip := false
	if st == 2:                                  # JUMP -> the leap frames (asm FUN_10013404 +0x10 0x85..0x8D)
		frame = PLAYER_JUMP_FRAME + (int(_core.tick_count() / 2) % PLAYER_JUMP_CYCLE)
		flip = not right
	elif st == 3:                                # FALL -> the static directional pose (same as idle)
		pass
	elif st == 12:                               # death-throw -> somersault spin (asm 0x75..0x7E)
		frame = PLAYER_DEATH_SPIN[int(_core.tick_count() / 2) % PLAYER_DEATH_SPIN.size()]
		flip = not right
	elif int(_p_runtimer.get(idx, 0)) > 0:       # running
		frame = PLAYER_RUN + int(float(_p_walkdist.get(idx, 0.0)) / PLAYER_RUN_PX) % PLAYER_RUN_CYCLE
		flip = not right
	var folder := "BP_sprites" if idx == 1 else "GP_sprites"
	var tex := _sprite(folder, frame, flip)
	if tex != null:
		var s := tex.get_size()
		# bottom-align the character to the cell (feet at pos.y + CELL_PX)
		draw_texture(tex, Vector2(pos.x + (CELL_PX - s.x) * 0.5, pos.y + CELL_PX - s.y))
		return
	# procedural fallback
	if _mode == 1:
		_glow(pos + Vector2(16, 16), 14.0, shirt)
	var skin := Color(0.98, 0.8, 0.62)
	var pants := Color(0.12, 0.12, 0.45)
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
	# The original HUD is pre-rendered SPRITES (the `extra's` sssf sheet): the
	# blue "Score"/"Bonus" labels (f04/f02), red digits 0-9 (f06-f15), the smiley
	# face (f16 = lives), rocket (f17 = arrows), potion (f18 = shield) and "Board#"
	# (f28). Blitting them gives the exact original font + icons.
	var y := 9.0
	var iy := 3.0
	var x := _ex(4, 14, y)                       # "Score"
	x = _ex_num(_core.player_score(1), 10, x + 4, y)
	x = _ex(2, x + 22, y)                        # "Bonus"
	x = _ex_num(_core.bonus_time(), 5, x + 4, y)
	x = _ex(16, x + 26, iy)                      # face (lives)
	x = _ex_num(_core.player_lives(1), 2, x + 3, y)
	x = _ex(17, x + 14, iy)                      # rocket (arrows)
	x = _ex_num(_core.player_arrows(1), 2, x + 3, y)
	x = _ex(18, x + 14, iy)                      # potion (Magic Ball ammo; asm draws +0x4a at x=0x184)
	x = _ex_num(_core.player_balls(1), 2, x + 3, y)
	x = _ex(28, x + 28, y)                       # "Board#"
	_ex_num(_board_number(), 3, x + 2, y)
	if _core.player_has_key(1) >= 1:
		_draw_key(Vector2(610, 2))
	if not _core.player_alive(1) and not _core.game_over():
		draw_string(_font, Vector2(18, 40), "RESPAWNING", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1.0, 0.6, 0.6))

## Blit one `extra's` HUD sprite at (x,y); returns the x just past it.
func _ex(frame: int, x: float, y: float) -> float:
	var tex := _sprite("extra_s", frame)
	if tex == null:
		return x
	draw_texture(tex, Vector2(round(x), round(y)))
	return x + tex.get_size().x

## Blit a zero-padded number using the red digit sprites (f06='0' … f15='9').
func _ex_num(value: int, ndigits: int, x: float, y: float) -> float:
	var s := str(maxi(0, int(value)))
	while s.length() < ndigits:
		s = "0" + s
	for i in s.length():
		var tex := _sprite("extra_s", 6 + (s.unicode_at(i) - 48))
		if tex != null:
			draw_texture(tex, Vector2(round(x), round(y)))
			x += tex.get_size().x
	return x

func _board_number() -> int:
	# The original campaign's Board#N is the extracted file board_(400+N): the main
	# set 401..500 = Board 1..100 (verified vs the reference montage: board_401 is
	# the 3-column Board#001). board_301 and board_1000+ are extras, not the #1.
	if Session.board_path != "":
		var num := Session.board_path.get_file().get_basename().replace("board_", "").to_int()
		if num >= 401 and num <= 500:
			return num - 400
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
## Both block and goody sprite frame = (tile low byte + 1)  (CONFIRMED: files are
## the game's own sssf sheets; e.g. block 0x07->f8 white, 0x0D->f14 red,
## 0x2B->f44 ball; goody 0x0A->f11 silver coin, 0x17->f24 gold, door 0x01->f2).
func _draw_cell(cell: int, pos: Vector2) -> void:
	var t := cell & 0xFF
	if cell & CELL_SUPPORTIVE:
		if not _blit("block_sprites", t + 1, pos):
			if t == 0x2B:
				_draw_ball(pos, Color(0.85, 0.13, 0.13))
			elif t == 0x0D or t == 0x13:
				_draw_block(pos, Color(0.85, 0.16, 0.16))
			else:
				_draw_block(pos, Color(0.87, 0.87, 0.90))
		if cell & CELL_CRACKED:                 # head-bonked once: show the fracture
			_draw_crack(pos)
		return
	if (cell & CELL_DOOR) or t == 0x0A or t == 0x17 or t == 0x18 or t == 0x19:
		if _blit("goody_sprites", t + 1, pos):
			return
		if t == 0x0B:
			_draw_key(pos)
		else:
			_draw_coin(pos, t == 0x17 or t == 0x19)
		return
	# background / decorative cell: nothing to draw over the black field

## Draw a grid cell scaled about its centre (for the block build/break pop).
func _draw_cell_scaled(cell: int, pos: Vector2, scale: float) -> void:
	var half := Vector2(CELL_PX, CELL_PX) * 0.5
	draw_set_transform(pos + half, 0.0, Vector2(scale, scale))
	_draw_cell(cell, -half)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

## A jagged dark fracture over a head-bonked (cracked) block -- one more bonk breaks it.
func _draw_crack(pos: Vector2) -> void:
	var c := Color(0.06, 0.06, 0.09, 0.85)
	var spine := PackedVector2Array([
		pos + Vector2(16, 2), pos + Vector2(12, 12), pos + Vector2(18, 18),
		pos + Vector2(13, 24), pos + Vector2(16, 30)])
	draw_polyline(spine, c, 1.5)
	draw_line(pos + Vector2(12, 12), pos + Vector2(4, 15), c, 1.2)
	draw_line(pos + Vector2(18, 18), pos + Vector2(27, 14), c, 1.2)

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

## A small creature body. Prefers the real decoded enemy sheet (walk cycle,
## flipped by travel direction); falls back to a per-type coloured blob.
func _draw_enemy(slot: int, e: Vector2, etype: int, edir: int) -> void:
	# travel-synced walk cycle: a moving nasty animates; a stationary one
	# (turret / spawner / Spinner) holds its frame instead of walking in place.
	var last: Vector2 = _enemy_lastpos.get(slot, e)
	var walk: float = _enemy_walk.get(slot, 0.0)
	var moved := (e - last).length()
	if moved > 0.5 and moved < 64.0:      # accumulate real motion; skip spawn/reuse teleports
		walk += moved
	_enemy_walk[slot] = walk
	_enemy_lastpos[slot] = e
	var folder: String = ENEMY_FOLDER.get(etype, "")
	if folder != "":
		var frame: int
		var face_left := (edir == 1)             # core enemy dir: 1 = left, 2 = right
		var flip := face_left
		if ENEMY_SPIN.has(etype):                # Spinner trap / flying star-disk: rotates on a
			frame = 2 + (int(_core.tick_count() / 2) % int(ENEMY_SPIN[etype]))   # timer in place
			flip = false
		elif etype == 12:                        # Cannon: a barrel that faces its firing direction
			frame = 2 if face_left else 3        # f02 barrel points left, f03 right
			flip = false
		elif ENEMY_SHOOTER.has(etype):           # Gargoyle/Knight turret: idle, then CHARGE an orb
			var sh: Dictionary = ENEMY_SHOOTER[etype]        # and RELEASE at the shot, driven by the
			var fcd: int = _core.enemy_fire_cd(slot)         # reload counter exposed by the core
			if fcd >= 0 and fcd <= 30:
				var ch: Array = sh["charge"]
				frame = int(ch[0]) + clampi(int((30 - fcd) * (int(ch[1]) - 1) / 30.0), 0, int(ch[1]) - 1)
			else:
				var idl: Array = sh["idle"]
				frame = int(idl[0]) + (int(_core.tick_count() / 8) % int(idl[1]))
			flip = false
		elif ENEMY_ROLL.has(etype):              # face-ball: a ball that ROLLS along the ground
			var nframes: int = max(1, _folder_index(folder).size())
			var step := int(walk / 3.0)          # ~one frame per 3px of travel
			if face_left:
				step = -step                     # roll backward when moving left
			frame = 2 + posmod(step, nframes)    # cycle the whole sheet; no flip (symmetric ball)
			flip = false
		elif etype == 9 and _core.enemy_fire_cd(slot) > 0:   # Robo PUNCH: it bounces its ball
			var pfcd: int = _core.enemy_fire_cd(slot)        # forward to smash a breakable block
			frame = 17 + clampi(16 - pfcd, 0, 15)            # (asm +0x6e swing f17-f32; ball hits
			flip = face_left                                 # ~f25) -- right swing, mirror for left
		elif ENEMY_WALK.has(etype):              # dedicated directional walk cycle
			var cfg: Dictionary = ENEMY_WALK[etype]
			var seg: Array = cfg["l"] if face_left else cfg["r"]
			frame = int(seg[0]) + (int(walk / 8.0) % int(seg[1]))
			flip = bool(cfg["flip"]) and face_left   # mirror only symmetric single-view sheets
		else:
			frame = 2 + (int(walk / 8.0) % 4)    # travel-synced walk cycle (fallback: 4 frames + flip)
		var tex := _sprite(folder, frame, flip)
		if tex != null:
			var s := tex.get_size()
			if _mode == 1:
				_glow(e + Vector2(16, 16), 12.0, Color(1, 0.4, 0.2))
			draw_texture(tex, Vector2(e.x + (CELL_PX - s.x) * 0.5, e.y + CELL_PX - s.y))
			return
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

## A purpose-built board for the --demo showcase: a full floor, a breakable
## block right over the start cell (so the first JUMP smashes it in mid-air), a
## line of Magic-Arrow pickups to run through, and coins overhead for colour.
func _showcase_level() -> PackedByteArray:
	var b := PackedByteArray()
	b.resize(512)
	b.fill(0)
	b[0x07] = 3          # P1 col = 3
	b[0x09] = 11         # P1 row = 11 (stands on the floor at row 12)
	b[0x0B] = 17         # P2 parked at the right edge (loader always places P2)
	b[0x0D] = 11         # P2 row
	b[0x16] = 0x27; b[0x17] = 0x10   # bonus = 10000
	# no procedural nasties: keep the showcase clean + deterministic
	b[0x12] = 0x00; b[0x13] = 0x00   # thrown_badguy = 0
	b[0x14] = 0x00; b[0x15] = 0x00   # pct_badguy = 0
	var n := 0x18
	# permanent floor along the bottom row (row 12), every column
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x03; b[n + 3] = 0x00; n += 4
	for c in range(GRID_COLS):
		b[n] = c; b[n + 1] = 12; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# one breakable floor tile just right of the start cell for the block-low demo
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x02; b[n + 3] = 0x07; n += 4   # 0x207 = block 0x07 + SUPPORTIVE
	b[n] = 4; b[n + 1] = 12; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# a breakable red block one row above the start cell -> smashed by the jump
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x02; b[n + 3] = 0x0D; n += 4
	b[n] = 3; b[n + 1] = 10; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# Magic-Arrow pickups (0x11) sitting on the floor row to run through
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x11; n += 4
	b[n] = 5; b[n + 1] = 11; n += 2
	b[n] = 6; b[n + 1] = 11; n += 2
	b[n] = 7; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# Magic-Ball pickups (0x10) further along the same floor row
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x10; n += 4
	b[n] = 8; b[n + 1] = 11; n += 2
	b[n] = 9; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# gold coins (0x17) floating overhead for colour
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x17; n += 4
	b[n] = 12; b[n + 1] = 6; n += 2
	b[n] = 13; b[n + 1] = 6; n += 2
	b[n] = 14; b[n + 1] = 6; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# terminator record (tile_type 0)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x00; n += 4
	b.resize(n)
	return b
