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
var _num_players := 2   # 2 = original co-op; 3 = remaster's extra RED co-op player (--players=3)
var _mode_compete := false   # Session.mode: false = Cooperate (shared), true = Compete (first to exit wins)
var _level_bytes: PackedByteArray

# Board-completed BONUS tally. Grounded: the "Board Completed" screen is FUN_100153d0
# (PICT 1000) with per-player tally panels FUN_100159f4 (PICT 1010/1011/1020), and the
# score count-up is FUN_10015714 -- it adds the time BONUS (x score-multiplier) plus a
# second reward into the score step-by-step with ascending "ding" SFX. The door exit
# awards EACH player their own `bonus_time * mult` at completion (soi_grid.c, per-player);
# we size the award per player as the score delta across the completing tick and drain it
# into the shown score. The count-up is CONFIRMED and we now play its ascending "ding" scale
# (see _tally_dings); we approximate only the cadence (smooth vs the original's discrete per-
# multiplier steps) and render the multiplier as "xN" text (the original drew an icon). The
# original's second-reward ("Weapons-Reward") column is VESTIGIAL -- @player+0x1003a9f2 is only
# ever reset on weapon-
# fire and never incremented (no writer in the decomp), so it is always 0; omitting it is
# faithful. (NB: PICT 300/FUN_10016c90 is the separate "Challenge Round" screen, not this one.)
const TALLY_FRAMES := 90.0
# Options -> Speed (About doc 8; plan 10 -- a LOCAL sim-rate option; Medium = the canonical
# deterministic rate). This scales Godot's physics tick (which drives the core tick), NOT the
# core logic, so determinism is unaffected. Rates are reasonable multiples (exact originals
# undocumented).
const SPEED_HZ := [90, 75, 60, 45]   # Really Fast / Fast / Medium / Slow
var _tally_pre := {}        # idx -> score before the current tick (to size the bonus award)
var _tally_bonus := {}      # idx -> bonus awarded at completion
var _tally_final := {}      # idx -> final score at completion
var _tally_captured := false
var _tally_anim := 0.0      # 0..1 count-up progress on the completed screen
var _tally_prebonus := 0    # bonus_time() before the completing tick (to derive the multiplier)
var _tally_award_max := 0   # largest per-player award (the exiting player's bonus)
var _tally_mult := 1        # award / prebonus, clamped 1..5 = how many rising count-up notes

# Alternate mode (Session.mode == 2): two SEPARATE single-player games taking turns
# (gameplay-and-design.md 1a). One player holds the seat at a time; a turn is one board
# attempt and ends on a board clear (advance that player's board) or a death (lose a life),
# then the seat passes to the other player. Godot owns each player's lives/score/board pool
# because the core resets per board (soi_world_init). INTERPRETATION: the exact original
# turn-grain (one-attempt here) and cross-board score persistence are not pinned in the
# decomp -- flagged.
var _alt := false
var _alt_lives := [4, 4]         # per-player remaining lives (P1=index0, P2=index1)
var _alt_score := [0, 0]         # per-player banked score from finished board attempts
var _alt_board := [0, 0]         # per-player index into Session.board_list
var _alt_active := 0             # whose turn (0=P1, 1=P2)
var _alt_out := [false, false]   # per-player: out of lives / finished all boards
var _alt_prev_alive := true      # death-edge detector for the active player
var _alt_state := "play"         # "play" | "transition" (PLAYER N ready) | "results"

# High-score name entry: offered once when the game ends and the best score qualifies
# for the table (Session.high_scores, menu "High Scores").
var _hs_state := ""              # "" = inactive, "entry" = typing initials
var _hs_name := ""              # up to 3 initials
var _hs_score := 0             # the qualifying score being entered
var _hs_checked := false       # only offer the entry once per game-over

# QuickSave (Ctrl-S) / Resume (About doc 8). The save is a BOARD-START snapshot; we cache each
# board's entry stats and write those, so Resume restarts the board with the entry stats.
var _board_start_stats: Array = []   # per-player {score,lives,arrows,balls,shield} at this board's start
var _save_flash := 0                 # frames left to show the "GAME SAVED" confirmation

# "Challenge Round" intro (PICT 300). REMASTER PRESENTATION: shown when entering a board in the
# 1001-1050 Challenge set. The original's exact trigger (DAT_100393d0) is not statically
# recoverable, so this is keyed on the board id rather than the original gate -- flagged.
var _challenge_intro := 0            # frames remaining to show the intro (freezes play)
var _challenge_forfeited := false    # challenge boards: loot forfeited on game over (survive-to-keep)

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
# The DEATH throw (hit by a nasty / thrown off) is a SOMERSAULT: the asm (FUN_10011fcc,
# gated on the dying flag) PING-PONGS the larger 36x34 frames 0x75..0x7D (117-125) -- it
# counts UP 0x76->0x7d, snaps 0x7e->0x7c and reverses DOWN to 0x75, then snaps 0x74->0x76
# and repeats. We approximate with a forward loop over 0x76..0x7D (118-125); the brief
# 117 + the ping-pong wobble are a minor visual nuance (render-verified acceptable). This
# is a DIFFERENT animation from the jump above -- do not use it for a plain jump.
const PLAYER_DEATH_SPIN := [118, 119, 120, 121, 122, 123, 124, 125]
const PLAYER_LAND_FRAME := 26
# The standing pose is DIRECTIONAL, not a flip: idle (asm FUN_100128f8) and fall
# (asm FUN_1001386c) both set frame 0x3D facing right / 0x34 facing left.
const PLAYER_STAND_R := 61
const PLAYER_STAND_L := 52
# Action pose (DISPLAY hint): fire + build share the same arm-extension swing. Byte-exact
# frames recovered from the PEF step tables (asm FUN_1001166c): right = mode-3 table
# @0x100346ec, left = mode-1 table @0x100346fa. DIRECTIONAL art (no mirror).
# Recover with tools/dump_pose_tables.py.
const PLAYER_ACT_R := [102, 104, 106, 106, 104, 102]
const PLAYER_ACT_L := [97, 99, 101, 101, 99, 97]
const PLAYER_POSE_MAX := 12
# Core enemy enum (soi_core.h) -> decoded sssf sprite folder.
const ENEMY_FOLDER := {
	1: "ant_sprites", 2: "ostrich_sprites", 3: "hippo_sprites", 4: "piggy_sprites",
	5: "disk_sprites", 6: "smiley_sprites", 7: "hammer_sprites", 8: "beenie_sprites",
	9: "robo_sprites", 10: "walker_sprites", 11: "teeth_sprites",
	12: "cannon_sprites", 13: "spinner_sprites", 14: "Gargoyle_sprites", 15: "knight_sprites",
	16: "bigger_mblock",   # creeper (bord 16/17): a pulsing block that walks the grid (sssf 1016)
}
# Enemies whose whole frame set is a ROLL cycle (a ball tumbling along the
# ground) rather than a leg walk: the smiley "face-ball" (etype 6) is a red ball
# whose three holes rotate right through its ~47 frames. It must roll with travel
# (reversing when it moves left), not twitch between 4 walk frames.
const ENEMY_ROLL := { 6: true }
# Enemies that SPIN in place on a timer (rotate through their whole sheet): the
# Spinner trap (etype 13, 14 frames) and the flying star-disk Wheelie (etype 5,
# a green orb with a rotating red star, 22 frames). etype -> frame count.
const ENEMY_SPIN := { 5: 22, 13: 14, 16: 3 }   # 16 = creeper: only bigger_mblock's OPAQUE full-block frames f02-04 (f05-14 shrink w/ transparency -> showed the white cell behind + looked glitchy)
# Stationary turrets that IDLE then CHARGE an energy orb as their reload nears 0
# and RELEASE it at the shot (asm FUN_1000adc4 gargoyle=bord14 / FUN_1000c2e8 knight=bord13).
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
var _p_stuck := {}        # player idx -> frames held-but-not-moving (run-in-place at a wall)

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
func _sprite(folder: String, frame: int, flip: bool = false, red: bool = false) -> Texture2D:
	var key := "%s/%d/%s/%s" % [folder, frame, flip, red]
	if _tex_cache.has(key):
		return _tex_cache[key]
	var idx := _folder_index(folder)
	var tex: Texture2D = null
	if idx.has(frame):
		var img := Image.load_from_file(idx[frame])
		if img:
			if red:
				_redden(img)
			if flip:
				img.flip_x()
			tex = ImageTexture.create_from_image(img)
	_tex_cache[key] = tex
	return tex

## Recolour the BLUE player's shirt (its blue-dominant pixels) to RED, in place, for
## the remaster's 3rd co-op player -- the original ships no red sprite sheet. Skin,
## outline and the (already-red) pants are R>=B, so they are left untouched.
func _redden(img: Image) -> void:
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			if c.a > 0.0 and c.b > c.r + 0.06:
				img.set_pixel(x, y, Color(c.b, c.g * 0.45, c.r, c.a))

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

## Play the board-completed count-up scale as the SCORE climbs -- grounded in FUN_10015714:
## snd 1100 "hut" on reveal, the rising notes 1102..1106 (one per score-multiplier step,
## event 0x30+i), then snd 1101 "huh" as it settles. We spread the `_tally_mult` notes across
## the smooth count-up (the original ticks them per discrete multiplier step). Silent when
## there is no bonus to award.
func _tally_dings(prev_anim: float, cur_anim: float) -> void:
	if _tally_award_max <= 0:
		return
	if prev_anim <= 0.0 and cur_anim > 0.0:
		Audio.play_snd(1100)                       # "hut" -- bonus revealed
	for i in _tally_mult:
		var thresh := float(i + 1) / float(_tally_mult + 1)
		if prev_anim < thresh and cur_anim >= thresh:
			Audio.play_snd(1102 + mini(i, 4))      # rising note per multiplier step
	if prev_anim < 1.0 and cur_anim >= 1.0:
		Audio.play_snd(1101)                       # "huh" -- settle chime

## Per-player BONUS -> SCORE tally drawn into the black centre of the "Board Completed"
## frame (FUN_100153d0 / PICT 1000). Grounded in the animated count-up FUN_10015714 + the
## confirmed exit award (soi_grid.c:87): the remaining BONUS counts down while the SCORE
## counts up by the same amount, settling with the bonus fully drained into the score.
## (We render the multiplier as "xN" text where the original drew an icon; the separate
## second-reward column stays omitted -- it is vestigial/always-0 in this build.)
func _draw_complete_tally() -> void:
	var cols := [Color(0.4, 0.6, 1.0), Color(0.4, 0.9, 0.5), Color(1.0, 0.45, 0.4)]
	var names := ["BLUE", "GREEN", "RED"]
	var y := 196.0
	for idx in range(1, mini(_num_players, 3) + 1):
		var bonus := int(_tally_bonus.get(idx, 0))
		var final_score := int(_tally_final.get(idx, _core.player_score(idx)))
		var remaining := int(round(bonus * (1.0 - _tally_anim)))   # bonus drains to 0
		var shown_score := final_score - remaining                 # score rises to final
		var m := int(_core.player_mult(idx))                       # score-multiplier (FUN_10015714 shows it)
		var mtxt := ("  x%d" % m) if m > 1 else ""
		var line := "%s    BONUS %d%s    SCORE %d" % [names[idx - 1], remaining, mtxt, shown_score]
		draw_string(_font, Vector2(120, y), line, HORIZONTAL_ALIGNMENT_LEFT, 400, 20, cols[idx - 1])
		y += 46.0

## Challenge-board completion ("Your Rewards", PICT 301): the LOOT kept = the score gained on
## this board (the survive-to-keep rule stated on PICT 300). REMASTER PRESENTATION for 1001-1050.
func _draw_challenge_rewards() -> void:
	_draw_pict_screen("challenge_rewards", "YOUR REWARDS", "Enter: next board     Esc: menu")
	var cols := [Color(0.4, 0.6, 1.0), Color(0.4, 0.9, 0.5), Color(1.0, 0.45, 0.4)]
	var names := ["BLUE", "GREEN", "RED"]
	var y := 200.0
	for idx in range(1, mini(_num_players, 3) + 1):
		var entry := 0
		if idx - 1 < _board_start_stats.size():
			entry = int(_board_start_stats[idx - 1].get("score", 0))
		var loot := maxi(int(_core.player_score(idx)) - entry, 0)
		draw_string(_font, Vector2(140, y), "%s    LOOT  %d" % [names[idx - 1], loot], HORIZONTAL_ALIGNMENT_LEFT, 360, 20, cols[idx - 1])
		y += 46.0

## Compete mode: the FIRST player to exit through their door wins (has_key == 2).
func _winner() -> int:
	for idx in range(1, mini(_num_players, 3) + 1):
		if _core.player_has_key(idx) == 2:
			return idx
	return 0

func _draw_win_screen() -> void:
	match _winner():
		1: _draw_pict_screen("blue_wins", "BLUE WINS!", "Enter: next board     Esc: menu")
		2: _draw_pict_screen("green_wins", "GREEN WINS!", "Enter: next board     Esc: menu")
		3: _draw_banner("RED WINS!", "Enter: next board     Esc: menu")
		_: _draw_pict_screen("no_winner", "NO WINNER", "Enter: next board     Esc: menu")

## --- Alternate mode (two solo games taking turns) ---------------------------

## End the active player's turn: bank their board score, then advance (on a clear)
## or dock a life (on a death), and pass the seat to the other player.
func _alt_end_turn(won: bool) -> void:
	_alt_score[_alt_active] += int(_core.player_score(1))
	if won:
		_alt_board[_alt_active] += 1
		if Session.board_list.size() > 0 and _alt_board[_alt_active] >= Session.board_list.size():
			_alt_out[_alt_active] = true            # cleared every board -> done
	else:
		_alt_lives[_alt_active] -= 1
		if _alt_lives[_alt_active] <= 0:
			_alt_out[_alt_active] = true
	if _alt_out[0] and _alt_out[1]:
		_alt_state = "results"
		return
	var other := 1 - _alt_active
	if not _alt_out[other]:
		_alt_active = other                         # hand the seat to the other player
	# else: the other player is out, so the still-in player keeps going solo
	_alt_state = "transition"

## Start the (new) active player's turn on their own current board.
func _alt_begin_turn() -> void:
	if Session.board_list.size() > 0:
		Session.board_path = Session.board_list[clampi(_alt_board[_alt_active], 0, Session.board_list.size() - 1)]
	_level_bytes = _load_level_bytes()
	_start()
	_alt_prev_alive = true
	_alt_state = "play"

## "PLAYER N -- GET READY" seat-hand-off screen with the running scoreboard.
func _draw_alt_transition() -> void:
	draw_rect(Rect2(0, 0, 640, 480), Color(0, 0, 0, 0.82))
	var who := "PLAYER %d" % (_alt_active + 1)
	var col: Color = Color(0.4, 0.6, 1.0) if _alt_active == 0 else Color(0.4, 0.9, 0.5)
	draw_string(_font, Vector2(0, 150), who, HORIZONTAL_ALIGNMENT_CENTER, 640, 40, col)
	draw_string(_font, Vector2(0, 192), "GET READY", HORIZONTAL_ALIGNMENT_CENTER, 640, 24, Color.WHITE)
	_draw_alt_scoreboard(250.0)
	draw_string(_font, Vector2(0, 372), "Enter: start your turn     Esc: menu", HORIZONTAL_ALIGNMENT_CENTER, 640, 15, Color(0.85, 0.85, 0.9))

## Final scoreboard + winner when both players are out.
func _draw_alt_results() -> void:
	draw_rect(Rect2(0, 0, 640, 480), Color.BLACK)
	draw_string(_font, Vector2(0, 120), "FINAL SCORES", HORIZONTAL_ALIGNMENT_CENTER, 640, 34, Color.WHITE)
	_draw_alt_scoreboard(200.0)
	var tie: bool = int(_alt_score[0]) == int(_alt_score[1])
	var winner := 0 if int(_alt_score[0]) >= int(_alt_score[1]) else 1
	var wc: Color = Color(0.4, 0.6, 1.0) if winner == 0 else Color(0.4, 0.9, 0.5)
	var msg := "TIE GAME" if tie else ("PLAYER %d WINS!" % (winner + 1))
	draw_string(_font, Vector2(0, 330), msg, HORIZONTAL_ALIGNMENT_CENTER, 640, 30, Color.WHITE if tie else wc)
	draw_string(_font, Vector2(0, 380), "Enter: menu", HORIZONTAL_ALIGNMENT_CENTER, 640, 15, Color(0.85, 0.85, 0.9))

## Two-row PLAYER / SCORE / LIVES board shared by the transition + results screens.
func _draw_alt_scoreboard(y: float) -> void:
	var cols := [Color(0.4, 0.6, 1.0), Color(0.4, 0.9, 0.5)]
	for i in 2:
		var live := int(_alt_score[i]) + (int(_core.player_score(1)) if (_alt_state == "play" and _alt_active == i) else 0)
		var status := "OUT" if _alt_out[i] else ("LIVES %d" % int(_alt_lives[i]))
		var line := "PLAYER %d    SCORE %d    %s" % [i + 1, live, status]
		draw_string(_font, Vector2(150, y + i * 40.0), line, HORIZONTAL_ALIGNMENT_LEFT, 360, 20, cols[i])

## --- High-score name entry ---------------------------------------------------

## The game has ended for high-score purposes: co-op/compete game over, the Alternate
## results screen, OR the whole campaign beaten (final board cleared, no next board). The
## last case lets a WINNING run record its score -- otherwise beating the game discards it.
func _hs_game_ended() -> bool:
	if _alt:
		return _alt_state == "results"
	if _core.game_over():
		return true
	return _core.level_complete() and _tally_anim >= 1.0 and not _has_next_board()

## Is there another board to advance to after this one? Mirrors Session.advance()'s test
## without mutating -- used to detect "beat the campaign" on the final board.
func _has_next_board() -> bool:
	return Session.board_index >= 0 and Session.board_index + 1 < Session.board_list.size()

## The best final score to submit (max across players; max of both Alternate games).
func _hs_final_score() -> int:
	if _alt:
		return maxi(int(_alt_score[0]), int(_alt_score[1]))
	var best := 0
	for i in range(1, mini(_num_players, 3) + 1):
		best = maxi(best, int(_core.player_score(i)))
	return best

## Capture up to 3 initials; Enter commits to Session (defaults to "AAA").
func _hs_input(e: InputEventKey) -> void:
	match e.keycode:
		KEY_ENTER, KEY_KP_ENTER:
			Session.add_score(_hs_name if _hs_name != "" else "AAA", _hs_score)
			_hs_state = ""
		KEY_BACKSPACE:
			if _hs_name.length() > 0:
				_hs_name = _hs_name.substr(0, _hs_name.length() - 1)
		_:
			if _hs_name.length() < 3 and e.unicode > 0:
				var ch := String.chr(e.unicode).to_upper()
				if ch.length() == 1 and ((ch >= "A" and ch <= "Z") or (ch >= "0" and ch <= "9")):
					_hs_name += ch

## "NEW HIGH SCORE" initials prompt, drawn over the game-over / results screen.
func _draw_hs_entry() -> void:
	draw_rect(Rect2(0, 300, 640, 118), Color(0, 0, 0, 0.86))
	draw_string(_font, Vector2(0, 336), "NEW HIGH SCORE!   %d" % _hs_score, HORIZONTAL_ALIGNMENT_CENTER, 640, 24, Color(1.0, 0.85, 0.2))
	var shown := _hs_name
	while shown.length() < 3:
		shown += "_"
	draw_string(_font, Vector2(0, 378), "Type initials:  %s      Enter = confirm" % shown, HORIZONTAL_ALIGNMENT_CENTER, 640, 18, Color.WHITE)

## Snapshot each player's PERSISTENT stats at the current board's start (for QuickSave, which
## records board-start state so Resume restarts the board with these -- About doc 8).
func _capture_board_start() -> void:
	_board_start_stats = []
	for i in range(1, mini(_num_players, 3) + 1):
		_board_start_stats.append({
			"score": int(_core.player_score(i)), "lives": int(_core.player_lives(i)),
			"arrows": int(_core.player_arrows(i)), "balls": int(_core.player_balls(i)),
			"shield": int(_core.player_shield(i)),
		})

## QuickSave the current game (board + board-start stats). Not supported in Alternate mode
## (Godot owns those per-player pools) or after game over.
func _do_save() -> void:
	if _alt or _core.game_over():
		return
	if Session.save_game(_board_start_stats):
		_save_flash = 90
		Audio.play_snd(1101)   # "huh" confirmation (About doc 8: QuickSave plays a "Huuuh!" sound)

## Is the current board in the 1001-1050 Challenge set?
func _is_challenge_board() -> bool:
	var n := _board_number()
	return n >= 1001 and n <= 1050


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
	# Resolve player count + mode from Session (and cmdline overrides) BEFORE the first _start(),
	# so _start() spawns the 3rd co-op player on board 1 too. Otherwise P3 was absent on the first
	# board (only _next_board re-spawned it) and Resume wrote P3's stats to an unspawned player.
	var ua := OS.get_cmdline_user_args()
	_num_players = Session.num_players if Session.num_players > 0 else 2
	_mode_compete = Session.mode == 1
	_alt = Session.mode == 2
	for arg in ua:
		if arg == "--mode=retro": _mode = 0
		elif arg == "--mode=remastered": _mode = 1
		elif arg == "--players=3": _num_players = 3
	if _alt:
		_num_players = 1
		var s := maxi(Session.board_index, 0)
		_alt_board = [s, s]
		_alt_lives = [4, 4]; _alt_score = [0, 0]; _alt_active = 0
		_alt_out = [false, false]; _alt_prev_alive = true; _alt_state = "play"
	_start()

	print("SoiCore ready: P1=(%d,%d) bonus=%d hash=%d" %
		[_core.player_x(1), _core.player_y(1), _core.bonus_time(), _core.state_hash()])
	# Resume: apply the saved board-start stats onto the freshly-loaded board.
	if not _alt and not Session.resume_stats.is_empty():
		for i in range(1, mini(_num_players, 3) + 1):
			if i - 1 < Session.resume_stats.size():
				var st: Dictionary = Session.resume_stats[i - 1]
				_core.set_player_stats(i, int(st.get("score", 0)), int(st.get("lives", 4)),
					int(st.get("arrows", 1)), int(st.get("balls", 1)), int(st.get("shield", 2)))
	Session.resume_stats = []
	_capture_board_start()   # snapshot this board's entry stats (with the correct player count)
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
	var _harness := false
	for a in ua:
		if a.begins_with("--shot") or a.begins_with("--demo") or a.begins_with("--play"):
			_harness = true
	if not _alt and not _harness and _is_challenge_board():
		_challenge_intro = 150   # brief "Challenge Round" intro before a challenge board
	Engine.physics_ticks_per_second = SPEED_HZ[clampi(Session.speed, 0, 3)]   # Options->Speed (local)
	set_physics_process(true)

## (re)start the current board from a clean core state.
func _start() -> void:
	_core.init(1)
	_core.load_level(_level_bytes)
	if _num_players >= 3:
		_core.spawn_player3()   # remaster's 3rd co-op player (BORD has no 3rd spawn)
	_reset_round_ui()

## Advance to the next board WITHOUT wiping the persistent stats -- score/lives/ammo/shield
## carry across boards (new-game-only per FUN_1002b060); only mult + per-board state reset.
func _next_board() -> void:
	_core.next_level(_level_bytes)
	if _num_players >= 3:
		_core.spawn_player3()
	_reset_round_ui()

## Reset the per-round UI/animation state shared by _start and _next_board.
func _reset_round_ui() -> void:
	_paused = false
	_tally_captured = false
	_tally_anim = 0.0
	_tally_bonus.clear()
	_tally_final.clear()
	_tally_award_max = 0
	_tally_mult = 1
	_tally_prebonus = 0
	_hs_checked = false
	_hs_state = ""
	_challenge_forfeited = false
	_capture_board_start()

func _physics_process(_delta: float) -> void:
	if not _paused and not _core.game_over() and not _core.level_complete() and not (_alt and _alt_state != "play") and _challenge_intro == 0:
		_tally_prebonus = int(_core.bonus_time())   # remaining bonus before this tick (for the multiplier)
		for idx in range(1, mini(_num_players, 3) + 1):
			_tally_pre[idx] = int(_core.player_score(idx))   # pre-tick score; bonus award = post-tick delta
		var p1 := _read_input(0)
		if _demo_frames > 0:
			p1 = _demo_input()         # scripted play for the --demo movie / capture
		elif _play_frames > 0:
			p1 = _play_input()         # scripted play on a real board (--play recording)
		elif _shot_countdown > 0:
			p1 = IN_RIGHT              # scripted input for a plain --shot screenshot
		var p3 := _read_input(2) if _num_players >= 3 else 0
		_core.tick3(p1, _read_input(1), p3)
		for i in _core.sfx_count():
			Audio.play(_core.sfx_get(i))
		if _alt:
			if _alt_prev_alive and not _core.player_alive(1):
				_alt_end_turn(false)         # the active player died -> lose a life, pass the seat
			_alt_prev_alive = _core.player_alive(1)
		if _core.level_complete() and not _tally_captured:
			for idx in range(1, mini(_num_players, 3) + 1):
				var fin := int(_core.player_score(idx))
				_tally_final[idx] = fin
				var aw := maxi(fin - int(_tally_pre.get(idx, fin)), 0)   # bonus drained into score this tick
				_tally_bonus[idx] = aw
				_tally_award_max = maxi(_tally_award_max, aw)
			# rising-note count = award / remaining-bonus = the score multiplier (1..5),
			# matching FUN_10015714's per-multiplier count-up loop.
			_tally_mult = clampi(int(round(float(_tally_award_max) / float(maxi(_tally_prebonus, 1)))), 1, 5)
			_tally_captured = true
	if _core.level_complete() and _tally_anim < 1.0:
		var prev_anim := _tally_anim
		_tally_anim = minf(_tally_anim + 1.0 / TALLY_FRAMES, 1.0)   # count-up progress (also gates HS-on-win)
		# The count-up scale belongs to the VISIBLE coop "Board Completed" tally (FUN_10015714 /
		# PICT 1000) only -- not the Compete wins screens (blue_wins/green_wins), the Challenge
		# rewards (PICT 301), or Alternate's hand-off. Advance the anim in every mode (HS-on-win
		# needs it) but ring the dings only where the tally is actually drawn.
		if not _alt and not _mode_compete and not _is_challenge_board():
			_tally_dings(prev_anim, _tally_anim)
	if not _alt and _is_challenge_board() and _core.game_over() and not _challenge_forfeited:
		_challenge_forfeited = true   # challenge rule (PICT 300): lose the board's loot if you don't survive
		for i in range(1, mini(_num_players, 3) + 1):
			if i - 1 < _board_start_stats.size():
				_core.set_player_stats(i, int(_board_start_stats[i - 1].get("score", 0)),
					int(_core.player_lives(i)), int(_core.player_arrows(i)),
					int(_core.player_balls(i)), int(_core.player_shield(i)))
	if not _hs_checked and _hs_game_ended():
		_hs_checked = true
		var sc := _hs_final_score()
		if Session.qualifies(sc):
			_hs_score = sc; _hs_name = ""; _hs_state = "entry"   # NEW HIGH SCORE -> take initials
	if _save_flash > 0:
		_save_flash -= 1
	if _challenge_intro > 0:
		_challenge_intro -= 1
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
	if _challenge_intro > 0:
		_challenge_intro = 0   # any key dismisses the Challenge Round intro
		return
	if _hs_state == "entry":
		_hs_input(e)
		return
	match e.keycode:
		KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		KEY_TAB, KEY_P:
			if not _core.game_over():
				_paused = not _paused   # pause (the original pauses on Tab; P also works)
		KEY_M:
			_mode = 1 - _mode   # toggle Retro <-> Remastered display
		KEY_S:
			if (e as InputEventKey).ctrl_pressed:
				_do_save()   # QuickSave (About doc 8: Command-S; Ctrl-S here)
		KEY_ENTER, KEY_KP_ENTER:
			if _alt:
				if _alt_state == "results":
					get_tree().change_scene_to_file("res://scenes/menu.tscn")
				elif _alt_state == "transition":
					_alt_begin_turn()
				elif _core.level_complete():
					_alt_end_turn(true)   # board cleared -> advance this player's board, pass the seat
			elif _core.game_over():
				_start()   # retry the board
			elif _core.level_complete():
				if Session.advance():
					_level_bytes = _load_level_bytes()   # next board (Session.board_path)
					_next_board()   # keep score/lives/ammo across boards
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
	elif which == 1:
		if Input.is_key_pressed(KEY_A): m |= IN_LEFT
		if Input.is_key_pressed(KEY_D): m |= IN_RIGHT
		if Input.is_key_pressed(KEY_W): m |= IN_JUMP
		if Input.is_key_pressed(KEY_F): m |= IN_BLOCK_HIGH
		if Input.is_key_pressed(KEY_G): m |= IN_BLOCK_LOW
		if Input.is_key_pressed(KEY_H): m |= IN_ARROW
		if Input.is_key_pressed(KEY_J): m |= IN_BALL
	else:
		# P3 (remaster co-op): numpad 4/6/8 = left/right/jump, 7/9 = build high/low, 1/3 = arrow/ball
		if Input.is_key_pressed(KEY_KP_4): m |= IN_LEFT
		if Input.is_key_pressed(KEY_KP_6): m |= IN_RIGHT
		if Input.is_key_pressed(KEY_KP_8): m |= IN_JUMP
		if Input.is_key_pressed(KEY_KP_7): m |= IN_BLOCK_HIGH
		if Input.is_key_pressed(KEY_KP_9): m |= IN_BLOCK_LOW
		if Input.is_key_pressed(KEY_KP_1): m |= IN_ARROW
		if Input.is_key_pressed(KEY_KP_3): m |= IN_BALL
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

	# Magnifying glass (goody 0x2F): while the reveal timer is active, mark every hidden
	# treasure (SPECIAL 0x1000 cell) so the player can see where to dig. The asm
	# (FUN_10016b28) flashes each hidden cell for ~5s while busy-waiting; we overlay it
	# non-blocking so play continues.
	if _core.reveal_timer() > 0:
		for r in range(GRID_ROWS):
			for c in range(GRID_COLS):
				if int(_core.grid_cell(c, r)) & CELL_SPECIAL:
					_draw_reveal_marker(Vector2(ORIGIN_X + c * CELL_PX, ORIGIN_Y + r * CELL_PX))

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
					var bf := 4 + (int(_core.tick_count() / 2) % 18)
					if not _blit("cannon_sprites", bf, pp):
						draw_circle(c, 6.0, Color(0.9, 0.3, 0.2))
				elif _core.projectile_src_type(i) == 14:  # Gargoyle: a short-range PUFF (breath), not a bolt
					draw_circle(c, 8.0, Color(0.85, 0.5, 0.25, 0.30))
					draw_circle(c + Vector2(-3, -2), 4.5, Color(0.95, 0.65, 0.35, 0.55))
					draw_circle(c + Vector2(3, 2), 4.0, Color(0.90, 0.55, 0.30, 0.50))
				elif _core.projectile_src_type(i) == 10:  # Walker: its own small RED bolt
					# The walker fires a horizontal block-smashing bolt (asm type 0x68,
					# FUN_1000e3c0) that animates frames 0x31..0x40 -- the small 20x19
					# red-bolt frames on the walker sheet (f50..f63). Render THAT, not a
					# made-up green blob.
					var kf := 50 + (int(_core.tick_count() / 2) % 14)
					if not _blit("walker_sprites", kf, pp):
						draw_circle(c, 4.5, Color(0.85, 0.15, 0.12))
				else:                                     # other hostile shot: a generic energy bolt
					draw_circle(c, 5.0, Color(0.65, 0.1, 0.75))
					draw_circle(c, 2.5, Color(1, 0.55, 1))
			elif _core.projectile_kind(i) == 2:
				# Knight GIFT in flight: a random goody flown to a target cell
				# (enemy_knight_gift / FUN_1000c8bc) -- a treasure sparkle, NOT a
				# weapon shot. (It used to fall through to the arrow's ball swirl.)
				_draw_gift_sparkle(c)
			elif _core.projectile_kind(i) == 1:
				# Magic BALL: the candy swirl held at a FIXED frame -- it ROLLS, it does not
				# spin (asm FUN_1000fd5c draws the ball at a steady weapons frame by facing --
				# the higher of the sheet's top pair when moving right; only the ARROW cycles
				# the swirl). The weapons sheet is f02..f09; use its top pair 9/8. No glow.
				var bl: float = pp.x - float(_proj_lastpos.get(i, pp).x)
				if not _blit("weapons", 9 if bl >= 0.0 else 8, pp):
					draw_circle(c, 7.0, Color(0.82, 0.14, 0.1))
			else:
				# Magic ARROW: the SAME weapons swirl but CYCLING (it spins as it flies) --
				# asm FUN_1000fd5c animates the frame while it ricochets. BOTH shots are this
				# swirl; they differ only in BEHAVIOUR (ball rolls / arrow bounces). The pointed
				# red arrow goody f19 is the ball-AMMO PICKUP icon, NOT a projectile. No glow.
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
	_draw_player(3, Color(0.85, 0.2, 0.15))   # remaster's RED co-op player (drawn only when active)
	_post_fx()

	_draw_hud()
	if _alt and _alt_state == "results":
		_draw_alt_results()
	elif _alt and _alt_state == "transition":
		_draw_alt_transition()
	elif _core.game_over():
		if not _alt and _is_challenge_board():
			_draw_pict_screen("Nothing", "NOTHING!", "Enter: retry     Esc: menu")   # challenge: loot forfeited
		else:
			_draw_banner("GAME OVER", "Enter: retry     Esc: menu")
	elif _core.level_complete():
		if _mode_compete:
			_draw_win_screen()
		elif not _alt and _is_challenge_board():
			_draw_challenge_rewards()
		else:
			_draw_pict_screen("board_completed", "LEVEL CLEAR!", "Enter: next board     Esc: menu")
			_draw_complete_tally()
	elif _paused:
		_draw_pict_screen("paused", "PAUSED", "Tab: resume     Esc: menu")
	if _hs_state == "entry":
		_draw_hs_entry()
	if _save_flash > 0:
		draw_string(_font, Vector2(0, 232), "GAME SAVED", HORIZONTAL_ALIGNMENT_CENTER, 640, 26, Color(0.5, 1.0, 0.6, clampf(float(_save_flash) / 45.0, 0.0, 1.0)))
	if _challenge_intro > 0:
		_draw_pict_screen("Challenge_Title", "CHALLENGE ROUND", "")

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

# Speed-shoes (goody 0x32) draw a spinning indicator over the player while fast-mode
# is active (asm FUN_10014ccc sets player +0x6a = sssf 132 'spin ind sprite family';
# FUN_10014a10 blits it at ~player.x+6, y-0x10). 58 small (16x12) frames.
func _draw_powerup_overlay(idx: int, pos: Vector2) -> void:
	if _core.player_fast(idx) <= 0:
		return
	var n: int = _folder_index("spin_ind_sprite_family").size()
	if n <= 0:
		return
	var frame := 2 + (int(_core.tick_count() / 2) % n)
	var tex := _sprite("spin_ind_sprite_family", frame, false)
	if tex != null:
		var s := tex.get_size()
		draw_texture(tex, Vector2(pos.x + (CELL_PX - s.x) * 0.5, pos.y - s.y * 0.5))


# Magnifying-glass reveal marker: a pulsing gold diamond over a hidden-treasure cell.
func _draw_reveal_marker(pos: Vector2) -> void:
	var pulse := 0.5 + 0.5 * sin(float(int(_core.tick_count()) % 30) / 30.0 * TAU)
	var ctr := pos + Vector2(CELL_PX, CELL_PX) * 0.5
	var rad := CELL_PX * (0.28 + 0.06 * pulse)
	var gold := Color(1.0, 0.85, 0.15, 0.55 + 0.35 * pulse)
	var pts := PackedVector2Array([
		ctr + Vector2(0, -rad), ctr + Vector2(rad, 0),
		ctr + Vector2(0, rad), ctr + Vector2(-rad, 0)])
	draw_colored_polygon(pts, Color(gold.r, gold.g, gold.b, 0.22 * pulse))
	draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), gold, 2.0, true)


## The Knight's airborne GIFT (kind-2 projectile): a gold twinkle that reads as an
## incoming treasure, not a weapon. Drawn at the projectile centre `c`.
func _draw_gift_sparkle(c: Vector2) -> void:
	var t := float(_core.tick_count())
	var puls := 0.7 + 0.3 * sin(t * 0.45)
	if _mode == 1:
		_glow(c, 11.0, Color(1.0, 0.85, 0.3))
	var gold := Color(1.0, 0.9, 0.35)
	var r := 8.0 * puls
	var r2 := 4.5 * puls
	# 4-point star: long vertical/horizontal rays + shorter diagonals
	draw_line(c + Vector2(-r, 0), c + Vector2(r, 0), gold, 2.0)
	draw_line(c + Vector2(0, -r), c + Vector2(0, r), gold, 2.0)
	var diag := gold.lerp(Color.WHITE, 0.35)
	draw_line(c + Vector2(-r2, -r2), c + Vector2(r2, r2), diag, 1.5)
	draw_line(c + Vector2(-r2, r2), c + Vector2(r2, -r2), diag, 1.5)
	draw_circle(c, 2.6 * puls, Color(1.0, 1.0, 0.85))


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
	var pose := int(_core.player_pose(idx))
	# The core's ground_state flickers idle<->run between grid steps, so keep the run
	# alive briefly off actual horizontal motion. Advance the leg cycle by DISTANCE
	# travelled (not the wall clock) so the feet stay planted to the ground.
	var dx: float = pos.x - float(_p_lastx.get(idx, pos.x))
	_p_lastx[idx] = pos.x
	if absf(dx) > 0.5:                            # MOVING -> advance the legs by TRAVEL so the feet stay
		_p_walkdist[idx] = float(_p_walkdist.get(idx, 0.0)) + absf(dx)   # PLANTED (the 30Hz/60fps stutter
		_p_runtimer[idx] = 6                       # gives dx=2,0,2,0 -- must NOT double the leg cadence)
		_p_stuck[idx] = 0
	elif st == 1:                                # held but not moving THIS frame
		_p_runtimer[idx] = 6
		_p_stuck[idx] = int(_p_stuck.get(idx, 0)) + 1
		if int(_p_stuck[idx]) >= 3:              # blocked by a wall for a few frames -> run IN PLACE
			_p_walkdist[idx] = float(_p_walkdist.get(idx, 0.0)) + PLAYER_RUN_PX
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
	elif pose > 0:                               # fire/build arm-extension swing (asm FUN_1001166c step tables)
		var seq: Array = PLAYER_ACT_R if right else PLAYER_ACT_L
		frame = seq[clampi((PLAYER_POSE_MAX - int(_core.player_pose_t(idx))) / 2, 0, seq.size() - 1)]
		flip = false                             # frames are directional -- no mirror
	var folder := "GP_sprites" if idx == 2 else "BP_sprites"   # P2 = green art; P1/P3 = blue art
	var tex := _sprite(folder, frame, flip, idx == 3)   # P3 = the blue art recoloured RED (_redden)
	if tex != null:
		var s := tex.get_size()
		# bottom-align the character to the cell (feet at pos.y + CELL_PX)
		draw_texture(tex, Vector2(pos.x + (CELL_PX - s.x) * 0.5, pos.y + CELL_PX - s.y))
		_draw_powerup_overlay(idx, pos)
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
	# face (f16 = LIVES, the single +0x46 survival counter), rocket (f17 = arrows),
	# potion (f18 = balls) and "Board#" (f28). Blitting them gives the exact original
	# font + icons.
	var y := 9.0
	var iy := 3.0
	var x := _ex(4, 14, y)                       # "Score"
	x = _ex_num((_alt_score[_alt_active] + int(_core.player_score(1))) if _alt else int(_core.player_score(1)), 10, x + 4, y)
	x = _ex(2, x + 22, y)                        # "Bonus"
	x = _ex_num(_core.bonus_time(), 5, x + 4, y)
	x = _ex(16, x + 26, iy)                      # face = LIVES (asm FUN_1000fb18 draws +0x46 = lives)
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
		# Stop/Go BLOCK: low byte = 5 colour pairs x {Stop 0x9d+12g, Go 0xa3+12g} (g=0..4).
		# The original draws the flip SIGN on these solid blocks (asm FUN_10016784, its own
		# sheet Stop_Go_sprite_family) -- the block stays solid in BOTH states, only the sign
		# graphic flips. Draw the settled Stop (octagon) / Go (circle) sign for the low byte.
		var sgf := -1
		if t >= 0x9D and t <= 0xD3:
			var ds := t - 0x9D          # Stop block = 0x9d + 12*pair
			var dg := t - 0xA3          # Go block   = 0xa3 + 12*pair
			if ds % 12 == 0 and ds < 60:
				sgf = [2, 10, 18, 26, 34][ds / 12]
			elif dg >= 0 and dg % 12 == 0 and dg < 60:
				sgf = [9, 17, 25, 33, 39][dg / 12]
		if sgf >= 0 and _blit("Stop_Go_sprite_family", sgf, pos):
			if cell & CELL_CRACKED:
				_draw_crack(pos)
			return
		if not _blit("block_sprites", t + 1, pos):
			if t == 0x2B:
				_draw_ball(pos, Color(0.85, 0.13, 0.13))
			elif t == 0x0D or t == 0x13:
				_draw_block(pos, Color(0.85, 0.16, 0.16))
			else:                               # plain solid (incl. low-0 permanent floor/border walls)
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
	# A persistent SPAWNER (bord 5/6/10/11/12/18/19) is NOT a walking nasty. The
	# original stamps a solid RED block at the spawner cell and emits the moving
	# children from it (asm FUN_10009778 / FUN_100076a8). Reference board_3 top-right
	# shows this as a RED block with the spawned nasty standing on it -- NOT a grey
	# block and NOT a stuck-looking nasty. Render the red marker. VERIFIED vs
	# refs/images/board_3.png (2026-07-06).
	if _core.enemy_is_spawner(slot):
		_draw_block(e, Color(0.85, 0.16, 0.16))
		return
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
			draw_texture(tex, Vector2(e.x + (CELL_PX - s.x) * 0.5, e.y + CELL_PX - s.y))
			return
	var c := e + Vector2(16, 16)
	var body := _enemy_color(etype)
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
	# Magic-Arrow ammo (0x0911, +0x4c) on the floor row to run through. Real boards
	# store goodies in the 0x09xx class (0x800 goody bit set); a BARE 0x11 would be
	# collected but never rendered (draw + the original's pickup both need 0x800).
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x09; b[n + 3] = 0x11; n += 4
	b[n] = 5; b[n + 1] = 11; n += 2
	b[n] = 6; b[n + 1] = 11; n += 2
	b[n] = 7; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# Magic-Ball ammo (0x0912, +0x4a) further along the same floor row (0x10 is the
	# shield pickup, NOT the ball -- the ball is type 0x12; asm FUN_1000ec50).
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x09; b[n + 3] = 0x12; n += 4
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
