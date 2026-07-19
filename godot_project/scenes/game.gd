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

# Bug #3 proof reel: walk up to a Robo perched on a single breakable block, pull the
# block out from under it, and watch it drop STRAIGHT DOWN onto the floor and die (the
# kill "ding"). Edge-turners (Robo/Walker) die the instant they land from a fall.
const DEMO_BUG3 := [
	[0, 45],                       # settle on the floor (P1 starts at col 6)
	[IN_RIGHT, 135], [0, 30],      # walk right, stop against the Robo's block (col 9)
	[IN_BLOCK_HIGH, 6],            # destroy the block DIRECTLY UNDER the Robo
	[0, 175],                      # HOLD: the Robo falls straight down and dies on landing
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
var _demo_script: Array = DEMO   # which scripted timeline --demo/--bug3 plays
var _play_frames := -1   # --play=N: play the loaded (real) board for N frames, then quit
var _enemy_lastpos := {}   # slot -> Vector2, for travel-synced enemy animation
var _enemy_walk := {}      # slot -> float, accumulated movement distance
var _proj_lastpos := {}    # projectile idx -> Vector2, to aim the arrow along travel
var _grid_prev := {}       # cell key -> last-frame cell value (create/destroy detection)
var _cell_fx := {}         # cell key -> { grow:bool, cell:int, t:float } grow/shrink pop
var _death_pops := []      # active enemy death "pops" (asm FUN_10028014 flying death sprite): { folder,frame,flip,x0,y0,t,px,py }
# Stop/Go SWITCH flip (asm FUN_10016544/10016784): stepping onto a switch cell (low 0x24-0x2D)
# flips its paired block group's sign (Stop octagon <-> Go circle) over an ~8-frame animation +
# a click. Both states stay solid, so this is a purely COSMETIC front-end overlay (no core/sim).
var _sg_toggled := [false, false, false, false, false]   # per group g=0..4: show the FLIPPED sign?
var _sg_anim := [0.0, 0.0, 0.0, 0.0, 0.0]                # per group: flip animation timer (1 -> 0)
var _sg_last := [-1, -1, -1, -1]                          # per player 1..3: last switch cell key (edge-detect)
var _mode := 0   # display mode: 0 = Retro (faithful 1996 look), 1 = Remastered (glow + vignette)
var _paused := false
var _num_players := 2   # 2 = original co-op; 3 = remaster's extra RED co-op player (--players=3)
var _mode_compete := false   # Session.mode: false = Cooperate (shared), true = Compete (first to exit wins)
var _win_video: VideoStreamPlayer = null   # Compete victory animation (extracted/movies/*.ogv)
var _win_clip := ""                          # currently-loaded win clip path ("" = none) -> avoid restarts
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
# Board-clear "warp": the original zooms through a tunnel of nested R/G/B rectangles between the
# cleared board and the tally (gameplay-neutral presentation; verified vs the original gameplay
# video -- every board clear plays it before "Board Completed"). ~0.5-0.7s depending on Speed.
const WARP_FRAMES := 72.0
# Options -> Speed (About doc 8; plan 10 -- a LOCAL sim-rate option; Medium = the canonical
# deterministic rate). This scales Godot's physics tick (which drives the core tick), NOT the
# core logic, so determinism is unaffected. Rates are reasonable multiples (exact originals
# undocumented).
const SPEED_HZ := [90, 75, 60, 45]   # Really Fast / Fast / Medium / Slow
var _tally_pre := {}        # idx -> score before the current tick (to size the bonus award)
var _tally_bonus := {}      # idx -> total awarded at completion (bonus x mult + no-weapons reward)
var _tally_final := {}      # idx -> final score at completion
var _tally_reward := {}     # idx -> No-Weapons Reward awarded (BORD 0x16: 5000, or 0 if a weapon fired)
var _tally_captured := false
var _tally_anim := 0.0      # 0..1 count-up progress on the completed screen
var _tally_prebonus := 0    # bonus_time() before the completing tick (to derive the multiplier)
var _tally_award_max := 0   # largest per-player award (the exiting player's bonus)
var _tally_mult := 1        # award / prebonus, clamped 1..5 = how many rising count-up notes
var _warp_anim := 0.0       # 0..1 board-clear R/G/B tunnel wipe; plays BEFORE the tally count-up
var _warp_vp := Vector2(320, 240)   # tunnel vanishing point = the exiting player's centre (the door)
# Transporter WARP-SLIDE (asm FUN_1002b9bc): stepping onto an IN pad glides the player across the screen
# -- as the spinning `transporter/` sprite -- to the paired OUT pad, as a BLOCKING cinematic (the sim
# freezes). The original runs 211 steps at the 60Hz Mac TickCount => ~3.5s (VERIFIED: FUN_10015fe4 IS
# TickCount). Front-end only: we spot the core's instant teleport (SOI_SFX_TELEPORT + a position jump),
# freeze the tick, and glide the sprite. TRANSPORT_FRAMES is the faithful 211 -- tune down if too slow.
const SFX_TELEPORT := 8             # SOI_SFX_TELEPORT (soi_core.h SoiSfx enum)
const TRANSPORT_FRAMES := 211
var _tp_frames := 0                 # >0 = a transporter slide is playing (the sim is frozen)
var _tp_player := 1                 # the warping player
var _tp_from := Vector2.ZERO        # slide start (IN pad, player top-left px)
var _tp_to := Vector2.ZERO          # slide end (OUT pad)
var _tp_pre := {}                   # idx -> pre-tick pixel pos (to spot the teleport jump)

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
var _sprites_dir := SPRITES_DIR    # --hd repoints this at extracted/sprites_hd (4x AI-upscaled sheets)
var _sprite_scale := 1             # loaded sprites are this many x the logical (SD 640x480) footprint
# Player (Ted) animation frames into BP_sprites / GP_sprites (CONFIRMED: the sheet
# has SEPARATE left/right blocks — idle 61 right / 52 left; run cycles follow each
# idle; jump 133; land 26). Frames are directional, so run/idle are NOT flipped.
# All BP/GP player art faces RIGHT; left is drawn by flipping. (Earlier notes
# claimed 52-60 were a left-facing block -- they are NOT, they also face right.)
const PLAYER_IDLE := 61          # standing pose
const PLAYER_RUN := 37            # RIGHT-facing run cycle f37-f48 (mirrored for left). The sheet's f25-f36
                                 # run the body forward but with the HEAD turned BACK -- a facing scan
                                 # calibrated on f61(R-idle)/f52(L-idle) shows f25-36 = skin-LEFT (head
                                 # back) vs f37-48 = skin-RIGHT (head forward). The port used to start the
                                 # rightward run at f25, so the head faced BACKWARD each stride = the
                                 # "flip". f37-f48 keeps the head forward; mirror it for a leftward run.
const PLAYER_RUN_CYCLE := 12
const PLAYER_RUN_PX := 2.0       # asm advances the leg frame 1 per 2px moved (matches the 2px/tick run)
# The JUMP is a somersault TUMBLE with DIRECTIONAL art (asm FUN_10013404 +0x10, chosen at launch from
# facing): a RIGHT jump plays f133-141, a LEFT jump plays f127-133 -- the two HALVES of ONE continuous
# tumble that rotates the SAME way (NOT mirrors; both show the head LEFT at the horizontal mid-tumble).
# The jump art is the 32x31 block f127-141. NB: f118-126 are the LARGER 36x34 DEATH arm-flap frames --
# f126 (arms fully up) is a DEATH pose, NOT a jump frame. An earlier version started the left jump at
# f126, so a left jump briefly flashed the death arms-up pose; the tumble is f127+ only.
const PLAYER_JUMP_FRAME := 133   # RIGHT somersault f133-141
const PLAYER_JUMP_CYCLE := 9     # jump animates frames 133..141 while airborne
const PLAYER_JUMP_FRAME_L := 127 # LEFT somersault f127-133 (32x31 tumble; f126 is the DEATH arms-up, excluded)
const PLAYER_JUMP_CYCLE_L := 7
# The DEATH throw (hit by a nasty / thrown off) is an ARM-FLAP, NOT a somersault: the character flails
# both arms UP then DOWN (the larger 36x34 frames f118-126; f126 = arms fully up). The asm (FUN_10011fcc)
# PING-PONGS 0x75..0x7e (117-126) -- up to the peak then back down, repeating. We ping-pong f118-126 so
# the flap actually reaches the arms-up peak. This is a DIFFERENT animation from the jump TUMBLE
# (f127-141) above -- the arms-up f126 belongs ONLY here, never in a jump.
const PLAYER_DEATH_SPIN := [118, 119, 120, 121, 122, 123, 124, 125, 126, 125, 124, 123, 122, 121, 120, 119]
const PLAYER_LAND_FRAME := 26
# The standing pose is DIRECTIONAL, not a flip: idle (asm FUN_100128f8) and fall
# (asm FUN_1001386c) both set frame 0x3D facing right / 0x34 facing left.
const PLAYER_STAND_R := 61
const PLAYER_STAND_L := 52
# Action pose (DISPLAY hint): fire + build share the same arm-extension swing. Frame
# sequences recovered from the PEF step tables (asm FUN_1001166c): facing==right selects
# the mode-3 table @0x100346ec [102,104,106,106,104,102]; facing==left selects the mode-1
# table @0x100346fa [97,99,101,101,99,97]. DIRECTIONAL art (no mirror). Recover with
# tools/dump_pose_tables.py.
#
# NOTE: our BP_sprites PNG extraction is offset +1 from the asm's internal frame numbering
# for this action block, so the raw asm numbers must be shifted +1 to hit the correct PNGs.
# Verified visually at 22x zoom: PNG f97-f102 face LEFT, f103-f108 face RIGHT, and f97 is a
# raised-leg WALK frame (not part of the swing). The neutral "arm-down, feet planted" build
# frame is f98 (left) / f103 (right). Applying +1: asm right [102,104,106]->PNG [103,105,107]
# (all right-facing) and asm left [97,99,101]->PNG [98,100,102] (all left-facing). Without the
# shift, the right swing's first/last frame (asm 102 -> PNG 102) rendered LEFT-facing during a
# right-facing build (the reported "wrong way for 2 frames" bug), and the left swing started on
# the stray raised-leg frame f97.
const PLAYER_ACT_R := [103, 105, 107, 107, 105, 103]
const PLAYER_ACT_L := [98, 100, 102, 102, 100, 98]
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
const ENEMY_SPIN := { 5: 22, 13: 14 }   # creeper (16) is NOT here -- it's a travel-gated moving block (handled in _draw_enemy) so it animates ONLY while stepping, never on a free-running timer
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
	1:  { "r": [34, 12], "l": [2, 12],  "flip": false },   # ant: VERIFIED f02-13 face LEFT, f34-45 face RIGHT (asm tables DAT_10034230 left / DAT_100341f0 right) -- was left-for-both = moonwalk
	2:  { "r": [2, 12],  "l": [21, 12], "flip": false },   # ostrich: right f02-13, left f21-32
	3:  { "r": [21, 12], "l": [2, 12],  "flip": false },   # hippo: right f21-32, left f02-13
	4:  { "r": [21, 12], "l": [2, 8],   "flip": false },   # piggy: right f21-32, left f02-09
	7:  { "r": [2, 10],  "l": [12, 10], "flip": false },   # hammer: run/hop right f02-11, left f12-21
	8:  { "r": [66, 12], "l": [66, 12], "flip": true  },   # beanie: floating kid, propeller-cap body
	9:  { "r": [38, 12], "l": [62, 12], "flip": false },   # robo: right-walk f38-49, left-walk f62-73
	10: { "r": [26, 12], "l": [2, 12],  "flip": false },   # sheep/walker: VERIFIED f02-13 face LEFT, f26-37 face RIGHT -> r(right travel)=f26-37, l=f02-13 (were swapped = moonwalk)
	11: { "r": [2, 12],  "l": [2, 12],  "flip": true  },   # teeth: symmetric chomp cycle, mirror to face
}
var _sprite_index := {}   # folder -> { frame:int -> absolute path }
var _tex_cache := {}      # "folder/frame/flip" -> Texture2D (or null)
var _p_lastx := {}        # player idx -> last x (run-animation motion tracking)
var _p_runtimer := {}     # player idx -> frames of run animation left to play
var _p_walkdist := {}     # player idx -> accumulated |travel| px (leg cadence)
var _p_movedx := {}       # player idx -> last non-zero core x-step (30Hz->60fps run smoothing)
var _p_holdc := {}        # player idx -> consecutive frames the core x has held (30Hz cadence)
var _p_stuck := {}        # player idx -> frames held-but-not-moving (run-in-place at a wall)
var _p_prevst := {}       # player idx -> ground_state last frame (to detect the jump start)
var _p_jumptick := {}     # player idx -> core tick at the last jump start (somersault phase origin)

## Build (once) a frame->path map for a sprite folder by parsing "fNN_WxH.png".
func _folder_index(folder: String) -> Dictionary:
	if _sprite_index.has(folder):
		return _sprite_index[folder]
	var idx := {}
	var dir := ProjectSettings.globalize_path("%s/%s" % [_sprites_dir, folder])
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

## A sprite's LOGICAL (SD 640x480) size. In --hd the loaded texture is _sprite_scale x
## bigger, so divide back to the footprint the cell/HUD layout math expects.
func _texsize(tex: Texture2D) -> Vector2:
	return tex.get_size() / float(_sprite_scale)

## Draw a sprite-sheet texture at pos at its LOGICAL size. SD (_sprite_scale==1) is exactly
## draw_texture; --hd draws the 4x texture into the logical footprint and the window's canvas
## content-scale then renders it crisp at the higher resolution.
func _dtex(tex: Texture2D, pos: Vector2) -> void:
	if _sprite_scale == 1:
		draw_texture(tex, pos)
	else:
		draw_texture_rect(tex, Rect2(pos, tex.get_size() / float(_sprite_scale)), false)

## Draw a sprite centered in a 32x32 cell at pos (nearest-neighbour, no scaling
## up beyond native). Returns true if a real sprite was drawn.
func _blit(folder: String, frame: int, pos: Vector2) -> bool:
	var tex := _sprite(folder, frame)
	if tex == null:
		return false
	var s := _texsize(tex)
	_dtex(tex, pos + (Vector2(CELL_PX, CELL_PX) - s) * 0.5)
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
	_dtex(tex, -_texsize(tex) * 0.5)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

# --- decoded PICT full-screen art (tools/pict_decode.py) ---
const PICT_DIR := "res://../extracted/pict"
var _pict_dir := PICT_DIR       # --hd repoints this at extracted/pict_hd (4x AI-upscaled art)
var _pict_scale := 1            # loaded PICTs are this many x the logical (SD 640x480) footprint
var _pict_cache := {}
func _pict(name_substr: String) -> Texture2D:
	if _pict_cache.has(name_substr):
		return _pict_cache[name_substr]
	var tex: Texture2D = null
	var dir := ProjectSettings.globalize_path(_pict_dir)
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
	_draw_pict(t, ((Vector2(640, 480) - _pict_size(t)) * 0.5).floor())
	# No on-screen key hint: the original screens show ONLY the art (faithful look). The
	# advance/back keys (Enter/Esc) still work; `hint` is kept for signature compatibility.

## A PICT's LOGICAL (SD 640x480) size; in --hd the loaded texture is _pict_scale x larger.
func _pict_size(t: Texture2D) -> Vector2:
	return t.get_size() / float(_pict_scale)

## Draw a PICT at pos at its LOGICAL size. SD (_pict_scale==1) is exactly draw_texture; --hd
## downsamples the 4x art into the 640x480 footprint, which the CANVAS_ITEMS content-scale
## then renders at the window's higher resolution.
func _draw_pict(t: Texture2D, pos: Vector2) -> void:
	if _pict_scale == 1:
		draw_texture(t, pos)
	else:
		draw_texture_rect(t, Rect2(pos, t.get_size() / float(_pict_scale)), false)

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

## The "Board Completed" tally, drawn into the black centre of PICT 1000 (which is ONLY the
## stone frame + red title). Grounded in the animated count-up FUN_10015714 + the confirmed
## exit award (soi_grid.c:87). The single-player LAYOUT -- rows, colours, the idle player and
## the divider bar -- is measured pixel-for-pixel from refs/images/board_completed.png:
##       [idle player, PICT 1010]        Board#  <n>
##       ------------------------        Bonus   <awarded>
##       No Weapons Reward               Score   <climbs to final>
## Blue labels (2,0,136) sit at x=212; red values (151,8,22) right-align to x=425. The Bonus
## row shows the AWARDED bonus while the Score counts up to the post-bonus final (the resting
## state matches the reference: Bonus 2513 / Score 4000).
func _draw_complete_tally() -> void:
	var label_col := Color8(2, 0, 136)
	var value_col := Color8(151, 8, 22)
	var bar_col := Color8(210, 207, 211)
	var lx := 212.0
	var vr := 425.0        # right edge the values right-align to
	var fs := 17           # cap-height ~11px, matched to the reference labels ("No Weapons Reward" ~155px)
	if _num_players <= 1:
		# Faithful single-player tally (asm FUN_100159f4 + FUN_10015714): the LABELS
		# ("Board#"/"Bonus"/"No Weapons Reward"/"Score") are the pre-rendered PICT 1020
		# panel art (blue), and the VALUES are the HUD SPRITE DIGITS -- FUN_10015714 draws
		# them via FUN_10015d94, which blits the SAME HUD digit bank (_DAT_1003ad28), NOT a
		# system font. (We used to draw Times-Bold text, which the original never does.)
		var panel := _pict("blue_tally")         # PICT 1020 (218x160): blue labels + bar
		var px := 140.0
		var py := 200.0
		if panel != null:
			_draw_pict(panel, Vector2(px, py))
		var pl := _pict("blue_player")           # PICT 1010: the idle blue player, to the right
		if pl != null:
			_draw_pict(pl, Vector2(474.0, py + 44.0))
		var delta := int(_tally_bonus.get(1, 0))                        # total awarded (bonus x mult + reward)
		var raw_bonus := _tally_prebonus                                # raw remaining bonus (FUN_10015714 row 0x134)
		var reward := int(_tally_reward.get(1, _core.player_no_weapons_reward(1)))
		var final_score := int(_tally_final.get(1, _core.player_score(1)))
		var shown := final_score - int(round(delta * (1.0 - _tally_anim)))   # SCORE climbs to final
		var vx := px + 300.0                     # value column right edge (clear of the long labels)
		_tally_digits(_board_number(), vx, py + 9.0)     # Board# row (panel y~10)
		_tally_digits(raw_bonus, vx, py + 63.0)          # Bonus row (panel y~64 = asm 0x134)
		_tally_digits(reward, vx, py + 98.0)             # No Weapons Reward row (panel y~99 = asm 0x158)
		_tally_digits(shown, vx, py + 134.0)             # Score row (panel y~135 = asm 0x17c)
		return
	# Co-op (2-3 players) has no single-screen reference; show each player in the same colour
	# scheme, stacked, sharing the one Board# header.
	_tally_line(lx, vr, 250.0, fs, "Board#", str(_board_number()), label_col, value_col)
	draw_rect(Rect2(lx, 263.0, vr - lx, 3.0), bar_col)
	var names := ["", "BLUE", "GREEN", "RED"]
	var pcol := [Color.WHITE, Color8(80, 130, 230), Color8(70, 200, 100), Color8(225, 80, 70)]
	var y := 292.0
	for idx in range(1, mini(_num_players, 3) + 1):
		var delta := int(_tally_bonus.get(idx, 0))
		var rw := int(_tally_reward.get(idx, 0))
		var bonus_only := maxi(delta - rw, 0)
		var f := int(_tally_final.get(idx, _core.player_score(idx)))
		var s := f - int(round(delta * (1.0 - _tally_anim)))
		draw_string(_font_hud, Vector2(lx, y), "%s   Bonus %d   Reward %d   Score %d" % [names[idx], bonus_only, rw, s], HORIZONTAL_ALIGNMENT_LEFT, 360, fs, pcol[idx])
		y += 38.0

## One tally row: a blue label at the left edge, a red value right-aligned to `vr`.
func _tally_line(lx: float, vr: float, y: float, fs: int, label: String, value: String, lc: Color, vc: Color) -> void:
	draw_string(_font_hud, Vector2(lx, y), label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, lc)
	draw_string(_font_hud, Vector2(lx, y), value, HORIZONTAL_ALIGNMENT_RIGHT, vr - lx, fs, vc)

## Draw a number with its RIGHT edge at `right_x`, using the extra_s HUD digit sprites
## (f06='0'..f15='9') -- the faithful tally digits (asm FUN_10015d94 blits the HUD bank
## _DAT_1003ad28, frame = digit+5), so the tally numbers match the top score bar exactly.
func _tally_digits(value: int, right_x: float, y: float) -> void:
	var s := str(maxi(0, value))
	var w := 0.0
	for i in s.length():
		var t := _sprite("extra_s", 6 + (s.unicode_at(i) - 48))
		if t != null:
			w += _texsize(t).x
	var x := right_x - w
	for i in s.length():
		var t := _sprite("extra_s", 6 + (s.unicode_at(i) - 48))
		if t != null:
			_dtex(t, Vector2(round(x), round(y)))
			x += _texsize(t).x

## Board-clear WARP: the original's tunnel of nested R/B/G rectangles that GROWS out of the exit
## door (`_warp_vp` = the vanishing point) over the still-visible cleared board, then fades to black
## so the "Board Completed" tally rises from black. Colours flow outward (R -> B -> G) as it expands.
## Matched to the original video. Drawn in the logical 640x480 space.
func _draw_board_warp() -> void:
	var cyc := [Color8(235, 30, 30), Color8(40, 40, 235), Color8(30, 200, 40)]  # R, B, G outward
	var w := 640.0
	var h := 480.0
	var px: float = clampf(_warp_vp.x, 32.0, w - 32.0)   # tiny margin only -> the vanishing point stays
	var py: float = clampf(_warp_vp.y, 32.0, h - 32.0)   # AT the exit door so the tunnel emerges FROM it
	var ratio := 0.66
	var zoom := _warp_anim * 6.0            # ~6 colour steps flow outward as the tunnel expands
	var fr := zoom - floorf(zoom)
	var base := int(floorf(zoom))
	# The tunnel EMERGES from the door: its outer ring grows from a small rect at the vanishing
	# point out to full-screen over the first 80% of the wipe (the cleared board stays visible
	# around it -- NO opaque backdrop), then the whole frame fades to black for the tally.
	var q_cap := lerpf(0.14, 1.7, clampf(_warp_anim / 0.8, 0.0, 1.0))
	for i in range(0, 26):                  # i=0 outermost -> higher i = nearer the vanishing point
		var q := pow(ratio, float(i) - fr)
		if q < 0.01 or q > q_cap:            # skip rings that have not yet grown out of the door
			continue
		var col: Color = cyc[(i + base) % 3]
		var x0 := px * (1.0 - q)
		var y0 := py * (1.0 - q)
		draw_rect(Rect2(x0, y0, (px + (w - px) * q) - x0, (py + (h - py) * q) - y0), col)
		var qd := q * pow(ratio, 0.5)        # 2-tone bevel groove: a darker inner step
		var xd := px * (1.0 - qd)
		var yd := py * (1.0 - qd)
		draw_rect(Rect2(xd, yd, (px + (w - px) * qd) - xd, (py + (h - py) * qd) - yd), Color(col.r * 0.55, col.g * 0.55, col.b * 0.55))
	var fade := clampf((_warp_anim - 0.8) / 0.2, 0.0, 1.0)   # fade to black over the last stretch
	if fade > 0.0:
		draw_rect(Rect2(0, 0, w, h), Color(0, 0, 0, fade))

## A transporter fired this tick (SOI_SFX_TELEPORT): the core already snapped the player to the OUT
## pad, so start gliding the warp sprite from its pre-tick (IN) position to it. Picks the player whose
## position jumped the most (co-op safe); a normal step is only a few px so 24px cleanly rules it out.
func _start_transport_slide() -> void:
	var best := 0
	var best_d := 24.0
	for idx in range(1, mini(_num_players, 3) + 1):
		var np := Vector2(_core.player_x(idx), _core.player_y(idx))
		var op: Vector2 = _tp_pre.get(idx, np)
		var d := op.distance_to(np)
		if d > best_d:
			best_d = d
			best = idx
			_tp_from = op
			_tp_to = np
	if best > 0:
		_tp_player = best
		_tp_frames = TRANSPORT_FRAMES

## Draw the transporter WARP-SLIDE: the spinning `transporter/` sprite gliding IN->OUT over
## TRANSPORT_FRAMES (asm FUN_1002b9bc). Cosmetic; the sim is frozen while it plays.
func _draw_transport() -> void:
	var step := TRANSPORT_FRAMES - _tp_frames
	var t := clampf(float(step) / float(TRANSPORT_FRAMES), 0.0, 1.0)
	var pos := _tp_from.lerp(_tp_to, t)
	var frame := 2 + (step % 13)             # cycle the transporter/ frames f02..f14 (fast spin)
	var tex := _sprite("transporter", frame)
	if tex == null:
		return
	var s := _texsize(tex)
	_dtex(tex, (pos + Vector2(CELL_PX, CELL_PX) * 0.5 - s * 0.5).floor())   # centred on the cell

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
	if _win_video != null and _win_video.visible:
		# The extracted victory animation renders via _win_video (a child node);
		# frame it with a caption + hint. (State managed in _update_win_video.)
		draw_rect(Rect2(0, 0, 640, 480), Color.BLACK)
		var w := _winner()
		var title := "NO WINNER"
		if w == 1: title = "BLUE WINS!"
		elif w == 2: title = "GREEN WINS!"
		draw_string(_font, Vector2(0, 72), title, HORIZONTAL_ALIGNMENT_CENTER, 640, 30, Color.WHITE)
		return
	match _winner():
		1: _draw_pict_screen("blue_wins", "BLUE WINS!", "Enter: next board     Esc: menu")
		2: _draw_pict_screen("green_wins", "GREEN WINS!", "Enter: next board     Esc: menu")
		3: _draw_banner("RED WINS!", "Enter: next board     Esc: menu")
		_: _draw_pict_screen("no_winner", "NO WINNER", "Enter: next board     Esc: menu")

## Path to the extracted victory animation (.ogv) for a Compete winner, or "" if none
## (P3/red has no original movie; also "" when the file is missing). tools/extract_win_movies.py.
func _win_clip_path(w: int) -> String:
	var clip := ""
	match w:
		1: clip = "blue_wins"
		2: clip = "green_wins"
		3: clip = ""              # P3 red: the original 2-player game has no movie for it
		_: clip = "no_winner"
	if clip == "":
		return ""
	# Prefer the AI-upscaled HD clip (extracted/movies_hd, tools/upscale_win_movies.py);
	# fall back to the faithful SD extraction (extracted/movies).
	for sub in ["movies_hd", "movies"]:
		var p := ProjectSettings.globalize_path("res://../extracted/%s/%s.ogv" % [sub, clip])
		if FileAccess.file_exists(p):
			return p
	return ""

## Show/hide + (re)start the Compete victory animation, played on the results screen
## exactly like the original (asm FUN_10014d70 -> FUN_10018e88 loads a transient movie).
## It loops on the held results screen until the player continues.
func _update_win_video() -> void:
	if _win_video == null:
		return
	var want := _win_clip_path(_winner()) if (_mode_compete and _core.level_complete()) else ""
	if want == _win_clip:
		return
	_win_clip = want
	if want == "":
		_win_video.stop()
		_win_video.hide()
	else:
		var vs := VideoStreamTheora.new()
		vs.set_file(want)
		_win_video.stream = vs
		_win_video.show()
		_win_video.play()
		Audio.play_snd(1502)   # competition-winner jingle (asm event 0x37 -> snd 1502, FUN_10014d70)

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
	# Compete victory-animation player (extracted/movies/*.ogv, decoded from the original
	# QuickTime win movies by tools/extract_win_movies.py). Hidden until the win screen.
	_win_video = VideoStreamPlayer.new()
	_win_video.expand = true
	_win_video.position = Vector2(100, 106)
	_win_video.size = Vector2(440, 328)   # native 220x164, shown at 2x
	_win_video.hide()
	_win_video.finished.connect(_on_win_video_finished)
	add_child(_win_video)
	_level_bytes = _load_level_bytes()
	if _level_bytes.is_empty():
		push_warning("using built-in demo level")
		_level_bytes = _demo_level()
	# Resolve player count + mode from Session (and cmdline overrides) BEFORE the first _start(),
	# so _start() spawns the 3rd co-op player on board 1 too. Otherwise P3 was absent on the first
	# board (only _next_board re-spawned it) and Resume wrote P3's stats to an unspawned player.
	var ua := OS.get_cmdline_user_args()
	if "--hd" in ua:                       # opt-in HD: load the 4x AI-upscaled sheets and render the 640x480
		_sprites_dir = "res://../extracted/sprites_hd"   # canvas at the window's higher resolution so the extra
		_sprite_scale = 4                  # detail shows. The SD default is byte-for-byte unchanged (gate = SD).
		# Prefer the newest HD PICT set (pict_hd_v2), else pict_hd. Deleting the
		# pict_hd_v2 folder reverts to the previous set (tools/upscale_picts.py --out).
		for hd in ["pict_hd_v2", "pict_hd"]:
			if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://../extracted/" + hd)):
				_pict_dir = "res://../extracted/" + hd   # 4x AI-upscaled PICT art (tools/upscale_picts.py)
				_pict_scale = 4
				break
		var win := get_window()
		win.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
		win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP
		win.content_scale_size = Vector2i(640, 480)
	_num_players = Session.num_players if Session.num_players > 0 else 2
	_mode_compete = Session.mode == 1
	_alt = Session.mode == 2
	for arg in ua:
		if arg == "--mode=retro": _mode = 0
		elif arg == "--mode=remastered": _mode = 1
		elif arg == "--players=3": _num_players = 3
	if ("--demo" in ua) or ("--fx" in ua) or ("--bug3" in ua):
		_num_players = 1   # the showcase demos are single-player, so the faithful 1-player
		                   # Board-Completed tally (PICT 1020 panel + sprite digits) shows
		                   # instead of the co-op panel (the loader still parks P2; not drawn)
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
	elif not _alt:
		# New-game starting stats (asm FUN_1002b060): every player's survival counter (+0x46)
		# starts at 2 with 1 arrow + 1 ball; SINGLE-player alone bumps player 1 to 4 lives + 2
		# arrows + 2 balls (P2 disabled). So co-op/compete with 2+ players starts 2 lives / 1+1
		# ammo each; solo starts 4 lives / 2+2 ammo. VERIFIED vs refs/images: the 2-player HUD
		# smiley reads 02 (not 04), arrows/balls 01. (soi_world_init sets the solo 4-life default.)
		if _num_players == 1:
			_core.set_player_stats(1, 0, 4, 2, 2, 2)
		else:
			for i in range(1, mini(_num_players, 3) + 1):
				_core.set_player_stats(i, 0, 2, 1, 1, 2)
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
	if "--bug3" in ua:
		# Bug #3 proof: a Robo perched on one breakable block; the scripted player pulls
		# the block out from under it and it falls straight down and dies on landing.
		_demo_script = DEMO_BUG3
		_level_bytes = _showcase_bug3_level()
		_start()
		var total := 40
		for seg in DEMO_BUG3:
			total += int(seg[1])
		_demo_frames = total
	if "--fx" in ua:
		# Recent-fixes demo: a straight walk-right board that hits a transporter (slide),
		# then a key + its (key-opened) door -> the board-clear warp. Drive it with --play=N.
		_level_bytes = _showcase_fx_level()
		_start()
	for arg in ua:
		if arg.begins_with("--play="):
			_play_frames = int(arg.substr(7))   # record the real board (no showcase override)
	var _harness := false
	for a in ua:
		if a.begins_with("--shot") or a.begins_with("--demo") or a.begins_with("--play") or a.begins_with("--bug3"):
			_harness = true
	if not _alt and not _harness and _is_challenge_board():
		_challenge_intro = 150   # brief "Challenge Round" intro before a challenge board
		Audio.play_snd(1500)     # Challenge Round jingle (asm event 0x35 -> snd 1500, FUN_10016c90)
	Engine.physics_ticks_per_second = SPEED_HZ[clampi(Session.speed, 0, 3)]   # Options->Speed (local)
	set_physics_process(true)


func _on_win_video_finished() -> void:
	if is_instance_valid(_win_video) and _win_video.visible:
		_win_video.play()                  # loop while the results screen is held


func _exit_tree() -> void:
	# Stop stepping the core before we drop its refs, so no queued physics frame can
	# touch a half-freed scene while the tree is being torn down (window close).
	set_physics_process(false)
	# Release scene-owned refs to reduce the "ObjectDB instances leaked at exit" warning on window close.
	if _win_video != null and is_instance_valid(_win_video):
		if _win_video.finished.is_connected(_on_win_video_finished):
			_win_video.finished.disconnect(_on_win_video_finished)
		_win_video.queue_free()
	_win_video = null
	_tex_cache.clear()
	_pict_cache.clear()
	_core = null


## (re)start the current board from a clean core state.
func _start() -> void:
	_core.init(1)
	_core.load_level(_level_bytes)
	if _num_players >= 3:
		_core.spawn_player3()   # remaster's 3rd co-op player (BORD has no 3rd spawn)
	_core.limit_players(_num_players)   # BORD always spawns P1+P2 -> turn P2/P3 off for a 1-player game
	_reset_round_ui()
	_update_board_music()

## Advance to the next board WITHOUT wiping the persistent stats -- score/lives/ammo/shield
## carry across boards (new-game-only per FUN_1002b060); only mult + per-board state reset.
func _next_board() -> void:
	_core.next_level(_level_bytes)
	if _num_players >= 3:
		_core.spawn_player3()
	_core.limit_players(_num_players)   # keep the extra BORD-spawned P2 off in a 1-player game
	_reset_round_ui()
	_update_board_music()

## Reset the per-round UI/animation state shared by _start and _next_board.
func _reset_round_ui() -> void:
	_paused = false
	_tally_captured = false
	_tally_anim = 0.0
	_warp_anim = 0.0
	_tp_frames = 0
	_tally_bonus.clear()
	_tally_final.clear()
	_tally_reward.clear()
	_tally_award_max = 0
	_tally_mult = 1
	_tally_prebonus = 0
	_hs_checked = false
	_hs_state = ""
	_challenge_forfeited = false
	_sg_toggled = [false, false, false, false, false]
	_sg_anim = [0.0, 0.0, 0.0, 0.0, 0.0]
	_sg_last = [-1, -1, -1, -1]
	_death_pops.clear()
	_capture_board_start()

## Stop/Go SWITCH flip (asm FUN_10016544): a player stepping onto a switch cell (low 0x24-0x2D,
## 0x800 class) flips its paired block group's sign over an ~8-frame animation + a click (evt 0x2c
## -> snd 1006). Purely COSMETIC -- both Stop and Go blocks stay solid, so the core/sim is untouched.
func _update_stopgo() -> void:
	for g in 5:
		if _sg_anim[g] > 0.0:
			_sg_anim[g] = maxf(_sg_anim[g] - 0.14, 0.0)
	for idx in range(1, mini(_num_players, 3) + 1):
		if not _core.player_alive(idx):
			_sg_last[idx] = -1
			continue
		var col := int((_core.player_x(idx) + 0x0C - ORIGIN_X) / CELL_PX)
		var row := int((_core.player_y(idx) + 0x10 - ORIGIN_Y) / CELL_PX)
		if col < 0 or col >= GRID_COLS or row < 0 or row >= GRID_ROWS:
			_sg_last[idx] = -1
			continue
		var cell := int(_core.grid_cell(col, row))
		var t := cell & 0xFF
		if (cell & CELL_DOOR) and t >= 0x24 and t <= 0x2D:
			var key := row * GRID_COLS + col
			if _sg_last[idx] != key:
				var g := (t - 0x24) / 2
				_sg_toggled[g] = not _sg_toggled[g]
				_sg_anim[g] = 1.0
				Audio.play_snd(1006)   # switch click (evt 0x2c; sequential after clock 0x2B -> 1005)
				_sg_last[idx] = key
		else:
			_sg_last[idx] = -1

func _physics_process(_delta: float) -> void:
	if _tp_frames > 0:
		_tp_frames -= 1              # transporter slide in progress: FREEZE the sim (skip the core tick)
	elif not _paused and not _core.game_over() and not _core.level_complete() and not (_alt and _alt_state != "play") and _challenge_intro == 0:
		_tally_prebonus = int(_core.bonus_time())   # remaining bonus before this tick (for the multiplier)
		for idx in range(1, mini(_num_players, 3) + 1):
			_tally_pre[idx] = int(_core.player_score(idx))   # pre-tick score; bonus award = post-tick delta
			_tp_pre[idx] = Vector2(_core.player_x(idx), _core.player_y(idx))   # pre-tick pos (teleport detect)
		var p1 := _read_input(0)
		if _demo_frames > 0:
			p1 = _demo_input()         # scripted play for the --demo movie / capture
		elif _play_frames > 0:
			p1 = _play_input()         # scripted play on a real board (--play recording)
		elif _shot_countdown > 0:
			p1 = IN_RIGHT              # scripted input for a plain --shot screenshot
		var p3 := _read_input(2) if _num_players >= 3 else 0
		var p2 := _read_input(1) if _num_players >= 2 else 0   # single-player: P2 (WASD) is off
		_core.tick3(p1, p2, p3)
		var teleported := false
		for i in _core.sfx_count():
			var ev := _core.sfx_get(i)
			Audio.play(ev)                 # SOI_SFX_HURRY (39) plays its warning cue here too
			if ev == SFX_TELEPORT:
				teleported = true
		if teleported:
			_start_transport_slide()   # a transporter fired -> glide the player to the OUT pad
		for di in _core.death_count():   # every enemy killed this tick -> spawn its cosmetic death "pop"
			_spawn_death_pop(int(_core.death_x(di)), int(_core.death_y(di)),
				int(_core.death_type(di)), int(_core.death_dir(di)))
		_step_death_pops()   # advance/cull the pops in lock-step with the sim (frozen when paused)
		_update_stopgo()
		if _alt:
			if _alt_prev_alive and not _core.player_alive(1):
				_alt_end_turn(false)         # the active player died -> lose a life, pass the seat
			_alt_prev_alive = _core.player_alive(1)
		if _core.level_complete() and not _tally_captured:
			for idx in range(1, mini(_num_players, 3) + 1):
				var fin := int(_core.player_score(idx))
				_tally_final[idx] = fin
				var rw := int(_core.player_no_weapons_reward(idx))   # No-Weapons Reward awarded (5000 or 0)
				_tally_reward[idx] = rw
				var aw := maxi(fin - int(_tally_pre.get(idx, fin)), 0)   # total drained into score this tick
				_tally_bonus[idx] = aw
				_tally_award_max = maxi(_tally_award_max, maxi(aw - rw, 0))   # bonus-only (reward isn't x mult)
			# rising-note count = bonus-award / remaining-bonus = the score multiplier (1..5),
			# matching FUN_10015714's per-multiplier count-up loop. The No-Weapons Reward is added
			# ONCE (not multiplied), so it is excluded from the multiplier estimate above.
			_tally_mult = clampi(int(round(float(_tally_award_max) / float(maxi(_tally_prebonus, 1)))), 1, 5)
			# Board-clear warp: the R/G/B tunnel converges on the exiting player's centre (the door
			# they left). The original's exact vanishing-point drift is unverified -> this is a faithful
			# approximation (gameplay-neutral, the score/tally values are unaffected).
			var ex := 1
			for idx2 in range(1, mini(_num_players, 3) + 1):
				if _core.player_has_key(idx2) == 2:
					ex = idx2
					break
			_warp_vp = Vector2(float(_core.player_x(ex)) + 16.0, float(_core.player_y(ex)) + 16.0)
			_tally_captured = true
			# Board-clear warp "whoosh": asm event 0x1f -> snd 16969 "Lore" (FUN_10028a0c /
			# FUN_10029264 play FUN_1002b020(0x1f,100) at completion). Coop/single warp only.
			if not _alt and not _mode_compete and not _is_challenge_board():
				Audio.play_snd(16969)
			# Beat the whole campaign -> switch to the ending tune (Angel Pie, FUN_1001768c).
			# Co-op/single only; Alternate + Compete have their own end screens.
			if not _alt and not _mode_compete and not _has_next_board():
				Audio.play_ending_music()
	if _core.level_complete():
		# The board-clear WARP plays first (standard coop/single clear only); the tally count-up
		# waits until the tunnel finishes. Compete/Alternate/Challenge have no warp -> tally at once.
		if not _alt and not _mode_compete and not _is_challenge_board() and _warp_anim < 1.0:
			_warp_anim = minf(_warp_anim + 1.0 / WARP_FRAMES, 1.0)
		elif _tally_anim < 1.0:
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
			Audio.play_snd(1501)   # high-score entry jingle (asm event 0x36 -> snd 1501, FUN_10022dfc)
	if _save_flash > 0:
		_save_flash -= 1
	if _challenge_intro > 0:
		_challenge_intro -= 1
	# Music "hurry-up" tempo is an ACTIVE-PLAY property. The original re-rates the one shared
	# background movie to 1.25x when a Bonus passes 1000 and only resets it to 1.0x on a time
	# award lifting the last hurrying player back above 1000, or on a NEW BOARD -- so the rate
	# PERSISTS through a blocking transporter slide (the sim is frozen but the sub-1000 bonus is
	# unchanged, so it stays fast rather than dipping to 1.0x and re-seating the loop twice).
	# Recompute every frame: 1.25x iff any in-play player's Bonus is in (0, 1000]
	# (_core.music_hurry(), read-only, valid whether or not the sim ticked) AND we are not in a
	# state that resets the movie -- pause, the board-clear tally / game-over / level-complete
	# (caught the same tick tick3 flips them, since these terms are re-read post-tick), an
	# alternating-players turn change, or a challenge intro. A transporter slide is NOT such a
	# state, so hurry rides through it unbroken (set_music_hurry is idempotent -> no reseat seam).
	# play_music resets to 1.0x on a track change; set_music_variant preserves the rate on a swap.
	var hurry_ok := not _paused and not _core.game_over() and not _core.level_complete() \
		and not (_alt and _alt_state != "play") and _challenge_intro == 0
	Audio.set_music_hurry(hurry_ok and _core.music_hurry())
	_update_win_video()
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
	for seg in _demo_script:
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
			# The block build/break POP (grow/shrink) is only for REAL blocks (non-zero low byte). A
			# moving CREEPER (etype 16) stamps a plain 0x300 wall (low byte 0) each step; the pop FX
			# drew that via the white _draw_block fallback SCALED, and the shrink-FX on the cell it
			# just LEFT (no sprite over it) flashed white. Skip the FX for low-byte-0 cells.
			if (cell & CELL_SUPPORTIVE) and not (prev & CELL_SUPPORTIVE) and (cell & 0xff) != 0:
				_cell_fx[key] = { "grow": true, "cell": cell, "t": 0.0 }
			elif (prev & CELL_SUPPORTIVE) and not (cell & CELL_SUPPORTIVE) and (prev & 0xff) != 0:
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
				elif _core.projectile_src_type(i) == 14:  # Gargoyle: the charged RED energy ball it releases
					draw_circle(c, 9.0, Color(0.9, 0.25, 0.2, 0.55))
					draw_circle(c, 6.0, Color(1.0, 0.4, 0.2, 0.95))
					draw_circle(c + Vector2(-2, -2), 3.0, Color(1.0, 0.85, 0.5, 0.95))
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
	_draw_death_pops()   # flying death sprites arcing off after a kill (drawn above the nasties)

	# players
	_draw_player(1, Color(0.15, 0.25, 0.85))
	_draw_player(2, Color(0.15, 0.6, 0.2))
	_draw_player(3, Color(0.85, 0.2, 0.15))   # remaster's RED co-op player (drawn only when active)
	if _tp_frames > 0:
		_draw_transport()                     # transporter warp-slide (over the frozen board)
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
		elif _warp_anim < 1.0:
			_draw_board_warp()          # R/G/B tunnel wipe from the cleared board into the tally
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
	# No key-hint line (faithful look); `hint` kept for signature compatibility.

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
		var s := _texsize(tex)
		_dtex(tex, Vector2(pos.x + (CELL_PX - s.x) * 0.5, pos.y - s.y * 0.5))


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
	if _tp_frames > 0 and idx == _tp_player:
		return                                   # drawn as the warp sprite by _draw_transport() instead
	# flash while invulnerable (post-hit / spawn grace): blink at ~8 Hz
	if _core.player_invuln(idx) > 0 and (int(_core.tick_count()) / 4) % 2 == 0:
		return
	var pos := Vector2(_core.player_x(idx), _core.player_y(idx))
	var facing := int(_core.player_facing(idx))
	var right := facing >= 0
	var st := int(_core.player_state(idx))
	var pose := int(_core.player_pose(idx))
	# The core's ground_state flickers idle<->run between grid steps, so keep the run
	# alive briefly off actual horizontal motion.
	var real_x := pos.x
	var real_dx: float = real_x - float(_p_lastx.get(idx, real_x))
	_p_lastx[idx] = real_x
	# Jump-start detection: when the core enters the JUMP state, latch the tick so the somersault phase
	# begins at the LAUNCH pose (the asm resets the jump frame at jump_t==0) instead of advancing off the
	# free-running global tick (which dropped the player into the middle of a spin).
	if st == 2 and int(_p_prevst.get(idx, -1)) != 2:
		_p_jumptick[idx] = int(_core.tick_count())
	_p_prevst[idx] = st
	# FAITHFUL run rendering (asm FUN_1001166c): draw the player at the core's exact 30 Hz position and
	# advance the leg cycle by REAL horizontal travel -- 2px per 30 Hz step => one leg frame per step,
	# EVEN and in lockstep with the body so the feet stay PLANTED. (My old remaster hacks -- a position
	# lerp that advanced the legs by the *smoothed* per-frame travel (~0.8/1.2px alternating = an uneven
	# leg stutter) plus a per-frame _run_align anchor shift -- were what ADDED the perceived "twitch".
	# The original simply steps the body and steps the legs together.)
	if absf(real_dx) > 0.5:                       # the core took a 30 Hz step this frame
		_p_walkdist[idx] = float(_p_walkdist.get(idx, 0.0)) + absf(real_dx)
		_p_runtimer[idx] = 6
		_p_stuck[idx] = 0
	elif st == 1:                                # held but not moving THIS frame
		_p_runtimer[idx] = 6
		_p_stuck[idx] = int(_p_stuck.get(idx, 0)) + 1
		if int(_p_stuck[idx]) >= 3:              # blocked by a wall for a few frames -> run IN PLACE
			# Advance the leg cycle at the SAME 30 Hz cadence as a real run step (half of
			# PLAYER_RUN_PX per 60 Hz draw = 2 px per 30 Hz step). Advancing a FULL PLAYER_RUN_PX
			# every draw cycled the legs at 60 Hz -- twice run speed -- which read as the player
			# "moving faster" while merely pushing against a wall.
			_p_walkdist[idx] = float(_p_walkdist.get(idx, 0.0)) + PLAYER_RUN_PX * 0.5
	elif _p_runtimer.get(idx, 0) > 0:
		_p_runtimer[idx] = int(_p_runtimer[idx]) - 1
	# idle/fall default: the static stand pose is DIRECTIONAL art (asm FUN_100128f8 idle /
	# FUN_1001386c fall set frame 0x3D=61 facing RIGHT, 0x34=52 facing LEFT). Verified at 22x vs
	# f61: f52 IS the native LEFT-facing idle, NOT right-facing -- so use the matching frame per
	# direction with NO mirror (same directional scheme as the run f37/f25 pair + the fire pose).
	# (An earlier comment wrongly claimed f52 faces right and mirrored f61 for the left idle.)
	var frame := PLAYER_STAND_R if right else PLAYER_STAND_L
	var flip := false
	# ASM runs FUN_1001166c every frame gated only by death: action pose overrides jump/fall/run; death overrides all.
	if st == 12:                                # death-throw -> somersault spin. NON-directional: the asm
		# FUN_10011fcc ping-pongs ONE frame range (0x75..0x7e) with NO facing branch, and the sheet has no
		# separate left-death block -> the tumble is drawn the SAME way regardless of facing. Mirroring it
		# for a left-facing death (the old `flip = not right`) spun the throw backwards, like the jump bug.
		frame = PLAYER_DEATH_SPIN[int(_core.tick_count() / 2) % PLAYER_DEATH_SPIN.size()]
		flip = false
	elif pose > 0:                               # fire/build arm-extension swing -- PRIORITY over jump/fall/run.
		# The asm action animation (FUN_1001166c, active-flag +0x25) plays its 7 DIRECTIONAL frames and
		# OVERRIDES the jump-tumble / fall / run-idle frame while it runs (gated only by the death-throw
		# above; +0x28). Ranking it ABOVE the jump (st==2) branch is exactly what makes a mid-air build/fire
		# show its swing instead of the jump art. Checking it BEFORE the run branch also stops a residual
		# run-timer (still counting down right after you stop moving) from bleeding a run frame into the
		# build/fire pose -- that one-frame run frame is the "flip" seen when acting immediately after running.
		var seq: Array = PLAYER_ACT_R if right else PLAYER_ACT_L
		frame = seq[clampi((PLAYER_POSE_MAX - int(_core.player_pose_t(idx))) / 2, 0, seq.size() - 1)]
		flip = false                             # frames are directional -- no mirror
	elif st == 2:                                # JUMP -> the somersault tumble; DIRECTIONAL art (asm
		# FUN_10013404 +0x10): RIGHT plays f133-141, LEFT plays its OWN f126-133 -- NOT a mirror (the two sets
		# are halves of one same-direction tumble, so mirroring the right set spun the left jump backwards).
		# Phase counts from the jump's launch tick (_p_jumptick) so the tumble STARTS at the launch pose.
		var jp := (int(_core.tick_count()) - int(_p_jumptick.get(idx, 0))) / 2
		if right:
			frame = PLAYER_JUMP_FRAME + (jp % PLAYER_JUMP_CYCLE)
		else:
			frame = PLAYER_JUMP_FRAME_L + (jp % PLAYER_JUMP_CYCLE_L)
		flip = false                             # native directional art -- no mirror
	elif st == 3:                                # FALL -> the static directional pose (same as idle)
		pass
	elif st == 1:                                # running (or holding into a wall = run-in-place)
		# Gate the run legs on the core's actual RUN state, NOT a lingering _p_runtimer. When the
		# player genuinely stops (st -> 0 idle) or falls (st 3), the countdown timer used to keep
		# drawing run frames for ~6 more frames, leaving one foot planted ahead of the other. The
		# core holds st==1 for the whole run (no idle<->run flicker between 30 Hz steps, verified),
		# so keying off st==1 keeps the legs alive while running yet snaps to the two-feet STAND the
		# instant the player is idle/falling/on an edge.
		frame = PLAYER_RUN + int(float(_p_walkdist.get(idx, 0.0)) / PLAYER_RUN_PX) % PLAYER_RUN_CYCLE
		flip = not right                         # right = f37-48 (head forward); left = the same, mirrored
	var folder := "GP_sprites" if idx == 2 else "BP_sprites"   # P2 = green art; P1/P3 = blue art
	# Draw the run frame at a FIXED anchor with NO per-frame offset -- exactly as the original does (the
	# body bob is authored into the frame art). (The old _run_align centroid-shift was a remaster hack
	# that slid the anchor every frame and slipped the planted foot = part of the "twitch"; removed.)
	var draw_dx := 0.0
	var tex := _sprite(folder, frame, flip, idx == 3)   # P3 = the blue art recoloured RED (_redden)
	if tex != null:
		var s := _texsize(tex)
		# bottom-align the character to the cell (feet at pos.y + CELL_PX)
		_dtex(tex, Vector2(pos.x + (CELL_PX - s.x) * 0.5 + draw_dx, pos.y + CELL_PX - s.y))
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
	x = _ex_num(maxi(int(_core.player_lives(1)), 0), 2, x + 3, y)   # clamp <0 -> 0 (asm FUN_1000fb18: an
	                                             # eliminated player's -1 shows as 0, never a "-1")
	# The original HUD (asm FUN_1000fb18) pairs the ROCKET icon (bank frame 0x10 -> f17) with the
	# BALL count (+0x4a, drawn at x=0x184) and the POTION icon (0x11 -> f18) with the ARROW count
	# (+0x4c, x=0x1d4) -- the same art!=effect quirk as the goodies (balls carry the arrow-shaped
	# art, arrows the potion art). We had the two counts swapped.
	x = _ex(17, x + 14, iy)                      # rocket icon -> Magic BALL count (asm frame 0x10 @ x=0x184)
	x = _ex_num(_core.player_balls(1), 2, x + 3, y)
	x = _ex(18, x + 14, iy)                      # potion icon -> Magic ARROW count (asm frame 0x11 @ x=0x1d4)
	x = _ex_num(_core.player_arrows(1), 2, x + 3, y)
	x = _ex(28, x + 28, y)                       # "Board#"
	_ex_num(_board_number(), 3, x + 2, y)
	if _core.player_has_key(1) >= 1:
		_draw_key(Vector2(610, 2))

## Blit one `extra's` HUD sprite at (x,y); returns the x just past it.
func _ex(frame: int, x: float, y: float) -> float:
	var tex := _sprite("extra_s", frame)
	if tex == null:
		return x
	_dtex(tex, Vector2(round(x), round(y)))
	return x + _texsize(tex).x

## Blit a zero-padded number using the red digit sprites (f06='0' … f15='9').
func _ex_num(value: int, ndigits: int, x: float, y: float) -> float:
	var s := str(maxi(0, int(value)))
	while s.length() < ndigits:
		s = "0" + s
	for i in s.length():
		var tex := _sprite("extra_s", 6 + (s.unicode_at(i) - 48))
		if tex != null:
			_dtex(tex, Vector2(round(x), round(y)))
			x += _texsize(tex).x
	return x

func _board_number() -> int:
	# The original campaign's Board#N is the extracted file board_(400+N): the main
	# set 401..500 = Board 1..100 (verified vs the reference montage: board_401 is
	# the 3-column Board#001). The Challenge set 1001..1050 is numbered Challenge
	# 1..50 (matches menu.gd _board_label). board_301 and board_501 are unnumbered
	# extras (reachable only via level-select) -> they use the play-order index.
	if Session.board_path != "":
		var num := Session.board_path.get_file().get_basename().replace("board_", "").to_int()
		if num >= 401 and num <= 500:
			return num - 400
		if num >= 1001 and num <= 1050:
			return num - 1000       # Challenge 1..50 (was the raw full-list sort index)
	if Session.board_index >= 0:
		return Session.board_index + 1
	return 1

## RE-grounded background music for the current board (FUN_10018c88 + FUN_10017a70).
## The original rotates three tunes by (level % 3) + 1, but a board holding a Knight or
## Gargoyle plays "spooky" instead. Called on every (re)load; the Audio autoload skips
## work when the tune is unchanged, so a seamless loop carries across same-tune boards.
func _update_board_music() -> void:
	Audio.play_level_music(_board_number(), _board_has_special_enemy())

## True if the loaded board contains a Knight or Gargoyle (dispatcher types 13/14 =
## SoiEnemyType 15/14). These turrets are placed, so they exist right after load --
## matching the original's live-enemy scan in FUN_10017a70.
func _board_has_special_enemy() -> bool:
	for i in _core.enemy_count():
		var t := int(_core.enemy_type(i))
		if t == 14 or t == 15:   # SOI_ENEMY_GARGOYLE / SOI_ENEMY_KNIGHT
			return true
	return false

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

## Fill a rounded rectangle (corner circles + a cross of rects).
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

## Grey 3D beveled frame around the playfield (the original's raised, rounded picture
## frame). A thick grey band with rounded outer corners and a smooth diagonal bevel:
## light on the top/left edges fading into the mid-grey face, dark on the bottom/right,
## so the whole border reads as raised. The bevel is drawn as per-vertex gradient quads
## (draw_polygon) rather than single hard bevel lines, matching the original's soft look.
func _draw_frame(pf: Rect2) -> void:
	var t := 20.0
	var rad := 18.0
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
	# top edge: light (outer) -> face (inner playfield edge)
	draw_polygon(
		PackedVector2Array([Vector2(ox + rad, oy), Vector2(ox + ow - rad, oy), Vector2(ix + iw, iy), Vector2(ix, iy)]),
		PackedColorArray([lite, lite, face, face]))
	# left edge: light -> face
	draw_polygon(
		PackedVector2Array([Vector2(ox, oy + rad), Vector2(ix, iy), Vector2(ix, iy + ih), Vector2(ox, oy + oh - rad)]),
		PackedColorArray([lite, face, face, lite]))
	# bottom edge: dark -> face
	draw_polygon(
		PackedVector2Array([Vector2(ox + rad, oy + oh), Vector2(ix, iy + ih), Vector2(ix + iw, iy + ih), Vector2(ox + ow - rad, oy + oh)]),
		PackedColorArray([dark, face, face, dark]))
	# right edge: dark -> face
	draw_polygon(
		PackedVector2Array([Vector2(ox + ow, oy + rad), Vector2(ox + ow, oy + oh - rad), Vector2(ix + iw, iy + ih), Vector2(ix + iw, iy)]),
		PackedColorArray([dark, dark, face, face]))
	# thin dark groove framing the black field (the recessed inner lip)
	draw_rect(Rect2(pf.position - Vector2(2, 2), pf.size + Vector2(4, 4)), Color(0.22, 0.22, 0.27), false, 2.0)

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
			var g := -1
			var loaded_stop := false
			if ds % 12 == 0 and ds < 60:
				g = ds / 12; loaded_stop = true
			elif dg >= 0 and dg % 12 == 0 and dg < 60:
				g = dg / 12
			if g >= 0:
				# a stepped SWITCH flips the displayed sign; animate across the group's frame run
				# (Stop 2/10/18/26/34 <-> Go 9/17/25/33/39; group 4 is a shorter run).
				var stop_f: int = [2, 10, 18, 26, 34][g]
				var go_f: int = [9, 17, 25, 33, 39][g]
				var disp_stop: bool = loaded_stop != _sg_toggled[g]
				var new_f := stop_f if disp_stop else go_f
				var a: float = _sg_anim[g]
				if a > 0.0:
					var old_f := go_f if disp_stop else stop_f
					sgf = int(round(float(new_f) + float(old_f - new_f) * a))
				else:
					sgf = new_f
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
	if (cell & CELL_PERMANENT) and t != 0:       # permanent DECORATIVE block (0x100, not standable):
		if not _blit("block_sprites", t + 1, pos):   # e.g. the 0x197 cross-hatch NET/mesh = block_sprites
			_draw_block(pos, Color(0.55, 0.55, 0.6))  # f152. The asm draws these from the block bank by
		return                                       # low byte like any block; the port dropped them (bg).
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
		_draw_block(e, Color(0.85, 0.16, 0.16))       # the red nest cell (asm stamps a solid marker),
		var nf: String = ENEMY_FOLDER.get(etype, "")  # then the emitted child stands on it -- etype IS
		if nf != "":                                   # the child's type (ref board_3: an ant on red).
			var it := _sprite(nf, 2, false)
			if it != null:
				var isz := _texsize(it)
				_dtex(it, Vector2(e.x + (CELL_PX - isz.x) * 0.5, e.y + CELL_PX - isz.y))
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
	if etype == 16:                       # CREEPER: a moving SOLID "pulsing block" (sssf 1016). Its own cell
		draw_rect(Rect2(e, Vector2(CELL_PX, CELL_PX)), Color.BLACK)   # is a plain 0x300 (white fallback) -> cover it
		# PULSE through the 13-frame morph (f02 full block <-> f14 ball), ping-ponged on a per-creeper
		# timer so the platform visibly animates even while it WAITS between its (instant) grid steps.
		var ph := int((int(_core.tick_count()) + slot * 5) / 4) % 24
		var cf := 2 + (ph if ph <= 12 else 24 - ph)
		var ct := _sprite("bigger_mblock", cf, false)
		if ct != null:
			var cs := _texsize(ct)
			_dtex(ct, Vector2(e.x + (CELL_PX - cs.x) * 0.5, e.y + CELL_PX - cs.y))
		return
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
			var idl: Array = sh["idle"]
			if fcd >= 0 and fcd <= 30:               # CHARGE: the energy orb grows to the shot (last 30)
				var ch: Array = sh["charge"]
				frame = int(ch[0]) + clampi(int((30 - fcd) * (int(ch[1]) - 1) / 30.0), 0, int(ch[1]) - 1)
			elif fcd >= 0 and fcd <= 30 + 40:        # WIND-UP: unfold the wings ONCE, synced to THIS
				var t := 70 - fcd                     # turret's own reload -- NOT the shared global clock
				frame = int(idl[0]) + clampi(int(t * (int(idl[1]) - 1) / 40.0), 0, int(idl[1]) - 1)
			else:                                    # waiting: hold the folded rest pose (stable, no flap
				frame = int(idl[0])                   # loop -- the old tick/8 loop snapped f20->f12 = twitch)
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
		elif ENEMY_WALK.has(etype):              # dedicated directional walk cycle. The asm plants the leg
			var cfg: Dictionary = ENEMY_WALK[etype]  # frame to POSITION (frame = table[x mod 32], ~16px/cycle,
			var seg: Array = cfg["l"] if face_left else cfg["r"]   # FUN_1000dd4c). walk/8 was ~6x too slow ->
			frame = int(seg[0]) + (int(walk / 3.0) % int(seg[1]))  # legs glided = "moonwalk"; walk/3 ~= per-cell.
			flip = bool(cfg["flip"]) and face_left   # mirror only symmetric single-view sheets
		else:
			frame = 2 + (int(walk / 8.0) % 4)    # travel-synced walk cycle (fallback: 4 frames + flip)
		var tex := _sprite(folder, frame, flip)
		if tex != null:
			var s := _texsize(tex)
			_dtex(tex, Vector2(e.x + (CELL_PX - s.x) * 0.5, e.y + CELL_PX - s.y))
			return
	var c := e + Vector2(16, 16)
	var body := _enemy_color(etype)
	draw_circle(c, 11, body.darkened(0.25))
	draw_circle(c, 9, body)
	draw_circle(c + Vector2(-3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(-3.5, -3), 1.0, Color.BLACK)
	draw_circle(c + Vector2(3.5, -3), 1.0, Color.BLACK)

## Enemy death "pop" (asm FUN_10028014 -> FUN_100278bc/FUN_10028060): every KILL enqueues one
## flying death sprite that pops UP ~64px and arcs off the screen. The core feeds us the dying
## nasty's pixel pos + type + facing via the transient soi_death_* queue; we replay the exact asm
## arc here as a pure front-end effect (not serialized/hashed, so determinism is untouched).
func _spawn_death_pop(x0: int, y0: int, etype: int, dir: int) -> void:
	var folder: String = ENEMY_FOLDER.get(etype, "")
	if folder == "":
		return   # no sprite sheet for this type -> nothing to pop (fallback circles don't get a corpse)
	var face_left := (dir == 1)   # enemy dir: 1 = left, 2 = right (soi_core.h)
	var frame := 2
	var flip := face_left
	if ENEMY_WALK.has(etype):   # freeze on the correct-facing walk frame (asm keeps the last live frame)
		var cfg: Dictionary = ENEMY_WALK[etype]
		var seg: Array = cfg["l"] if face_left else cfg["r"]
		frame = int(seg[0])
		flip = bool(cfg["flip"]) and face_left
	_death_pops.append({
		"folder": folder, "frame": frame, "flip": flip,
		"x0": float(x0), "y0": float(y0), "t": 0.0,
		"px": float(x0), "py": float(y0),
	})

## Advance every death pop one frame along the asm arc and cull those that leave the playfield
## (or exceed a safety cap). Called once per ticked sim frame, so pops are sim-synced and freeze
## when paused. asm (FUN_10028060, flag=1): x(t)=x0+4t, y(t)=y0-8t+t^2/4, clamped to the top rail.
func _step_death_pops() -> void:
	const BOTTOM := ORIGIN_Y + GRID_ROWS * CELL_PX   # 464: below-play cull line
	const LEFT := ORIGIN_X - CELL_PX                 # off-left cull line
	const RIGHT := ORIGIN_X + GRID_COLS * CELL_PX    # 624: off-right cull line
	var keep := []
	for d in _death_pops:
		var t: float = d["t"] + 1.0
		d["t"] = t
		d["px"] = d["x0"] + 4.0 * t
		d["py"] = maxf(d["y0"] - 8.0 * t + t * t * 0.25, float(ORIGIN_Y))
		if d["py"] < float(BOTTOM) and d["px"] > float(LEFT) and d["px"] < float(RIGHT) and t < 150.0:
			keep.append(d)
	_death_pops = keep

## Draw the active death pops, bottom-aligned & h-centred in the 32x32 cell (matching _draw_enemy).
func _draw_death_pops() -> void:
	for d in _death_pops:
		var tex := _sprite(d["folder"], int(d["frame"]), bool(d["flip"]))
		if tex != null:
			var s := _texsize(tex)
			_dtex(tex, Vector2(d["px"] + (CELL_PX - s.x) * 0.5, d["py"] + CELL_PX - s.y))

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
	b[0x0E] = 0x13; b[0x0F] = 0x88   # bonus (BORD 0x0E) = 5000
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
	b[0x0E] = 0x27; b[0x0F] = 0x10   # bonus (BORD 0x0E) = 10000
	# no procedural nasties: keep the showcase clean + deterministic
	b[0x12] = 0x00; b[0x13] = 0x00   # thrown_badguy = 0
	b[0x14] = 0x00; b[0x15] = 0x00   # pct_badguy = 0
	var n := 0x18
	# permanent floor along the bottom row (row 12), every column
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x03; b[n + 3] = 0x07; n += 4   # 0x0307 = white block (f08, flat) + PERMANENT|SUPPORTIVE
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

## Bug #3 proof board: a permanent floor, a Robo (placement type 15) perched on a SINGLE
## breakable block at (10,11), and the player starting to its left. The scripted player
## (DEMO_BUG3) walks up, destroys the block DIRECTLY UNDER the Robo, and it drops straight
## down onto the floor and dies (edge-turner fall-death). Loaded by the --bug3 flag.
func _showcase_bug3_level() -> PackedByteArray:
	var b := PackedByteArray()
	b.resize(512)
	b.fill(0)
	b[0x07] = 6          # P1 col = 6 (walks right along row 11)
	b[0x09] = 11         # P1 row = 11 (stands on the floor at row 12)
	b[0x0B] = 17         # P2 parked at the right edge (loader always places P2; not drawn solo)
	b[0x0D] = 11
	b[0x0E] = 0x27; b[0x0F] = 0x10   # bonus = 10000
	b[0x12] = 0x00; b[0x13] = 0x00   # thrown_badguy = 0 (no procedural spawns)
	b[0x14] = 0x00; b[0x15] = 0x00   # pct_badguy = 0
	var n := 0x18
	# permanent floor along the bottom row (row 12) -- the Robo's landing surface
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x03; b[n + 3] = 0x07; n += 4   # 0x0307 = PERMANENT|SUPPORTIVE
	for c in range(GRID_COLS):
		b[n] = c; b[n + 1] = 12; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# a SINGLE breakable block at (10,11) -- the Robo's perch, one cell above the floor
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x02; b[n + 3] = 0x07; n += 4   # 0x0207 = block + SUPPORTIVE
	b[n] = 10; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# the Robo (badguy placement type 15, right-facing) standing on that block at (10,10).
	# A badguy spawn block sets bit 0x400 (byte2 = 0x04) with the placement type in the low byte.
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x04; b[n + 3] = 0x0F; n += 4
	b[n] = 10; b[n + 1] = 10; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# terminator record (tile_type 0)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x00; n += 4
	b.resize(n)
	return b

## Demo board for the recent TRANSPORTER-SLIDE + BOARD-CLEAR-WARP fixes: one floor row
## with a transporter IN->OUT, then a key, then the key's locked door, all in a line so a
## plain walk-right (--play) triggers each in turn. Loaded by the --fx flag.
func _showcase_fx_level() -> PackedByteArray:
	var b := PackedByteArray()
	b.resize(512)
	b.fill(0)
	b[0x07] = 2          # P1 col (walks right along row 11)
	b[0x09] = 11         # P1 row (stands on the floor at row 12)
	b[0x0B] = 18         # P2 parked at the far right edge
	b[0x0D] = 11
	b[0x0E] = 0x27; b[0x0F] = 0x10   # bonus = 10000
	var n := 0x18
	# permanent floor along the bottom row (row 12)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x03; b[n + 3] = 0x07; n += 4   # 0x0307 = white block (f08, flat) + PERMANENT|SUPPORTIVE
	for c in range(GRID_COLS):
		b[n] = c; b[n + 1] = 12; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# transporter IN (0x081A, even) at (5,11) -> paired OUT (0x081B) at (8,11)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x08; b[n + 3] = 0x1A; n += 4
	b[n] = 5; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x08; b[n + 3] = 0x1B; n += 4
	b[n] = 8; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# universal key (0x0907) at (11,11) -- collecting it opens the low-4 lock
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x09; b[n + 3] = 0x07; n += 4
	b[n] = 11; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# locked door (0x0904 -> opened to 0x0901 by key 7) at (14,11) = the exit warp
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x09; b[n + 3] = 0x04; n += 4
	b[n] = 14; b[n + 1] = 11; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# gold coins (0x17) floating overhead for colour
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x17; n += 4
	b[n] = 4; b[n + 1] = 6; n += 2
	b[n] = 9; b[n + 1] = 6; n += 2
	b[n] = 13; b[n + 1] = 6; n += 2
	b[n] = 100; b[n + 1] = 100; n += 2
	# terminator record (tile_type 0)
	b[n] = 0x00; b[n + 1] = 0x00; b[n + 2] = 0x00; b[n + 3] = 0x00; n += 4
	b.resize(n)
	return b
