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
	[IN_BALL, 6], [0, 55],         # fire a Magic Ball: the swirl ROLLS along the ground/walls
	[IN_BALL, 6], [0, 50],         # roll another
	[IN_JUMP, 6], [0, 70],         # a plain jump -> shows the somersault spin
	[IN_ARROW, 6], [0, 40],        # fire a Magic Arrow -> it flies straight to the wall
	[IN_ARROW, 6], [0, 60],        # fire another
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
const MAX_ENEMIES := 64   # == SOI_MAX_ENEMIES
const MAX_PROJECTILES := 8
const BLOCKANIM_MAX := 10  # == SOI_BLOCKANIM_MAX (block build/remove animation slots)
# soi_fx_get fields / sheets (soi_core.h)
const FX_SHEET := 0
const FX_FRAME := 1
const FX_X := 2
const FX_Y := 3
const FX_VX := 4
const FX_VY := 5
const FX_GRAV := 6
const FX_SHEET_GOODY := 1

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
var _script: Array = []          # --script=FILE: [p1, frames, p2, cmd, arg] segments (verification runs)
var _script_f := 0               # physics frames elapsed in the --script run
var _script_hold := false        # --script HOLD: the simulation is frozen
var _play_frames := -1   # --play=N: play the loaded (real) board for N frames, then quit
var _enemy_lastpos := {}   # slot -> Vector2, for travel-synced enemy animation
var _enemy_walk := {}      # slot -> float, accumulated movement distance
var _proj_lastpos := {}    # projectile idx -> Vector2, to aim the arrow along travel
var _debris := []          # flying debris (asm FUN_100278bc/FUN_10028060): shattered-block quarters, popped goodies
var _death_pops := []      # active enemy death "pops" (asm FUN_10028014 flying death sprite): { folder,frame,flip,x0,y0,t,px,py }
# Stop/Go SWITCH flip (asm FUN_10016544/10016784): stepping onto a switch cell (low 0x24-0x2D)
# flips its paired block group's sign (Stop octagon <-> Go circle) over an ~8-frame animation +
# a click. Both states stay solid, so this is a purely COSMETIC front-end overlay (no core/sim).
var _sg_toggled := [false, false, false, false, false]   # per group g=0..4: show the FLIPPED sign?
var _sg_anim := [0.0, 0.0, 0.0, 0.0, 0.0]                # per group: flip animation timer (1 -> 0)
var _sg_t0 := [-1e6, -1e6, -1e6, -1e6, -1e6]             # per group: engine tick its flip started
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
var _alt_lives := [3, 3]         # per-player board ATTEMPTS left: the original's 2 reserve lives
                                 # (asm FUN_1002b060 +0x46 = 2) + the life in play
var _alt_ammo := [[1, 1], [1, 1]]   # per-player [arrows, balls] carried between turns (FUN_1002b060: 1 / 1)
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

# "Challenge Round" intro (PICT 300 + jingle 0x35, asm FUN_10016c90): shown at the start of every
# round on a board holding a Knight or Gargoyle (DAT_1003ad0e; boards 410, 420 ... 500).
var _challenge_intro := 0            # frames remaining to show the intro (freezes play)
var _challenge_forfeited := false    # the failed-challenge cue has played this round
var _harness_run := false            # a capture/demo run (--shot/--demo/--play/--bug3): no intro

# --- real sprite pipeline (decoded from the original sssf, tools/sssf_decode.py) ---
const SPRITES_DIR := "res://../extracted/sprites"
var _sprites_dir := SPRITES_DIR    # REMASTERED repoints this at extracted/sprites_hd (4x AI-upscaled sheets)
var _sprite_scale := 1             # loaded sprites are this many x the logical (SD 640x480) footprint
# REMASTERED: the frame-matched 3D renders (tools/soi3d/framematch.py) OVERLAY the HD sheets frame by
# frame (same fNN index, same 4x footprint), so the game's own frame logic drives them; a frame or sheet
# without a 3D render falls back to its HD frame. F2 flips the whole ORIGINAL <-> REMASTERED
# presentation live (_apply_presentation); F3 toggles HD <-> 3D sprites within REMASTERED.
const SPRITES_3D_DIR := "res://../extracted/sprites_3d_frames"
var _use_3d := false
var _remastered := false   # presentation: false = ORIGINAL (1996 SD art), true = REMASTERED (Session.remastered)
var _pres_toast := 0       # frames left to show the presentation label (after F2/F3, and at the first board)
var _toast_text := ""      # replaces the presentation label when set (F6 custom-sound notice)
# REMASTERED smooth rendering (D2R-style): the engine keeps the original tick; the picture redraws at
# the monitor's rate and shows every entity SMOOTH_DELAY ticks late, between its two engine states
# around that time -- position lerped, pose tweened (framematch.py `tweens` in-betweens).
const SMOOTH_DELAY := 2.0     # ticks: the next keyframe of a 2-tick mover is already known
const SMOOTH_SPAN := 3.0      # a step is drawn over at most this many ticks before its keyframe
const SMOOTH_SNAP := 48.0     # px: a longer jump (teleport, respawn, slot reuse) restarts the history
var _smooth := false
var _core_ticked := false     # the core ticked on the latest physics step (false while frozen)
var _rtick := 0.0             # render clock in engine ticks
var _drawn_tick := -1
var _smooth_t0 := 0           # engine tick when the histories last restarted
var _new_tick := true         # first draw since an engine tick: per-tick anim state advances
var _draw_serial := 0
var _hist := {}               # sprite key -> per-tick samples [tick, dpos, folder, frame, flip, red, planted, hide]
var _seen := {}               # sprite key -> _draw_serial of its last draw (the rest are drawn as ghosts)
var _grid_snaps: Array = []   # [[tick, PackedInt32Array]] -- the board as the delayed picture shows it
var _tween_idx := {}          # folder -> {"lo,hi": [n, {k: path}]} from sprites_3d_frames/<folder>/tw
var _TWEEN_RE := RegEx.create_from_string("^f(\\d+)-(\\d+)_(\\d+)of(\\d+)\\.png$")
var _proj_left := {}          # projectile idx -> heading left (per tick)
var _pop_seq := 0
# Real-time 3D (REMASTERED 3D, F4): sheets with a live rig (framematch.py `live`) are posed between
# frames and rendered live per entity instead of drawing pre-rendered frames (live3d.gd).
const LIVE_DIR := "res://../extracted/sprites_live"
var _live_on := true
var _live_index := {}         # sheet -> [[family, {frame: true}], ...] of the rigs that passed livegate
var _live_scanned := false
var _live := {}               # family -> Live3D (null when its rig failed to load)
# (The player's sprite frame comes from the core -- soi_player_frame, the original's own frame field.)
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
const ENEMY_SPIN := { 5: 24, 13: 16 }   # asm +0x56 range (Wheelie 1-0x18, Spinner 1-0x10); creeper (16) is travel-gated in _draw_enemy
# Stationary turrets (asm FUN_1000adc4 gargoyle=bord14 / FUN_1000c2e8 knight=bord13); their frame
# comes from the core (soi_enemy_anim = the asm +0x56 phase counter).
const ENEMY_SHOOTER := { 14: true, 15: true }
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
	7:  { "r": [34, 16], "l": [2, 16],  "flip": false },   # hammer: right f34-49, left f02-17 (asm tables 0x10034370/0330)
	8:  { "r": [66, 12], "l": [66, 12], "flip": true  },   # beanie: floating kid, propeller-cap body
	9:  { "r": [38, 12], "l": [62, 12], "flip": false },   # robo: right-walk f38-49, left-walk f62-73
	10: { "r": [26, 12], "l": [2, 12],  "flip": false },   # sheep/walker: VERIFIED f02-13 face LEFT, f26-37 face RIGHT -> r(right travel)=f26-37, l=f02-13 (were swapped = moonwalk)
	11: { "r": [2, 12],  "l": [2, 12],  "flip": true  },   # teeth: symmetric chomp cycle, mirror to face
}
var _sprite_index := {}   # folder -> { frame:int -> absolute path }
var _FRAME_RE := RegEx.create_from_string("^f(\\d+)_\\d+x\\d+\\.png$")
# The asm's own walk frames: each nasty's update sets frame = TABLE[x & 31] (x = its asm x),
# so the legs are planted to position. Tables from the PEF data section (DBASE 0x100337f0):
# ant 0x100341f0/0230, beanie 0270/02b0, hammer 0370/0330, hippo 03b0/03f0, ostrich 0430/0470, piggy 04b0/04f0,
# robo 0570/0530, teeth 05ec/062c, walker 06ac/066c. Values are asm frames (sheet fNN = +1).
const _W16_R := [26, 26, 27, 27, 28, 28, 29, 29, 30, 30, 31, 31, 32, 32, 25, 25]
const _W16_L := [7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 8, 8]
const ENEMY_WALK_TBL := {
	1: { "r": [35, 35, 37, 37, 39, 39, 41, 41, 43, 43, 45, 45, 47, 47, 33, 33],
		 "l": [1, 1, 3, 3, 5, 5, 7, 7, 9, 9, 11, 11, 13, 13, 15, 15], "dx": 0 },
	2: { "r": _W16_R, "l": _W16_L, "dx": 0 },
	3: { "r": _W16_R, "l": _W16_L, "dx": 0 },
	4: { "r": _W16_R, "l": _W16_L, "dx": 0 },
	7: { "r": [48, 48, 33, 33, 34, 34, 35, 35, 36, 36, 37, 37, 38, 38, 39, 39, 40, 40, 41, 41, 42, 42, 43, 43, 44, 44, 45, 45, 46, 46, 47, 47],
		 "l": [15, 15, 14, 14, 13, 13, 12, 12, 11, 11, 10, 10, 9, 9, 8, 8, 7, 7, 6, 6, 5, 5, 4, 4, 3, 3, 2, 2, 1, 1, 16, 16], "dx": 0 },
	8: { "r": [70, 70, 71, 71, 72, 72, 65, 65, 66, 66, 67, 67, 68, 68, 69, 69],
		 "l": [103, 103, 104, 104, 97, 97, 98, 98, 99, 99, 100, 100, 101, 101, 102, 102], "dx": 4 },
	9: { "r": [38, 38, 39, 39, 40, 40, 41, 41, 42, 42, 43, 43, 44, 44, 45, 45, 46, 46, 47, 47, 48, 48, 33, 33, 34, 34, 35, 35, 36, 36, 37, 37],
		 "l": [69, 69, 68, 68, 67, 67, 66, 66, 65, 65, 80, 80, 79, 79, 78, 78, 77, 77, 76, 76, 75, 75, 74, 74, 73, 73, 72, 72, 71, 71, 70, 70], "dx": 0 },
	10: { "r": [35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 33, 34],
		  "l": [14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 16, 15], "dx": 0 },
	11: { "r": [9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15, 16, 16, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8],
		  "l": [40, 40, 39, 39, 38, 38, 37, 37, 36, 36, 35, 35, 34, 34, 49, 49, 48, 48, 47, 47, 46, 46, 45, 45, 44, 44, 43, 43, 42, 42, 41, 41], "dx": 0 },
}
# Beanie turn-around frame tables (asm DAT_100342f0 horizontal / DAT_10034310 vertical).
const BEANIE_TURN := [73, 74, 75, 76, 77, 78, 79, 80, 89, 90, 91, 92, 93, 94, 95, 96]
const VBEANIE_TURN := [89, 90, 91, 92, 93, 94, 95, 96, 105, 106, 107, 108, 109, 110, 111, 112]
var _tex_cache := {}      # "folder/frame/flip" -> Texture2D (or null)

## Build (once) a frame->path map for a sprite folder by parsing "fNN_WxH.png" (strictly: stray
## files such as "f02_24x24_x16.png" inspection zooms must not shadow the real frame).
func _folder_index(folder: String) -> Dictionary:
	if _sprite_index.has(folder):
		return _sprite_index[folder]
	var idx := {}
	var dirs: Array = [ProjectSettings.globalize_path("%s/%s" % [_sprites_dir, folder])]
	if _use_3d and _remastered:              # the 3D overlay wins frame by frame
		dirs.append(ProjectSettings.globalize_path("%s/%s" % [SPRITES_3D_DIR, folder]))
	for dir in dirs:
		var da := DirAccess.open(dir)
		if da == null:
			continue
		for f in da.get_files():
			var m := _FRAME_RE.search(f)
			if m != null:
				idx[int(m.get_string(1))] = dir + "/" + f
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
	if not idx.has(frame):                  # e.g. an --hd tree built before a sheet's last frames
		for f in range(frame - 1, 1, -1):    # were recovered: use the nearest earlier frame
			if idx.has(f):
				frame = f
				break
	if idx.has(frame):
		var img := Image.load_from_file(idx[frame])
		if img:
			if red:
				_redden(img)
			if flip:
				img.flip_x()
			if _sprite_scale > 1:
				_prep_hd(img)
			tex = ImageTexture.create_from_image(img)
	_tex_cache[key] = tex
	return tex

## 4x art is drawn DOWN into its 1x logical footprint with linear+mipmap filtering (set in
## _apply_presentation): bleed edge colours into the transparent texels (no dark fringe under
## filtering) and build the mipmaps that filter samples.
func _prep_hd(img: Image) -> void:
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	img.fix_alpha_edges()
	img.generate_mipmaps()

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

## Like _blit, but CLIPS the sprite to a rect (the playfield). The original blits every
## sprite into a fixed playfield GWorld, so a projectile at a border cell is chopped at the
## frame edge instead of bleeding its body into the grey border / score bar. The core already
## keeps projectiles in-bounds (soi_in_bounds), so this only trims the sprite's overhang past
## the frame during travel / spawn. Returns true if a real sprite was resolved.
## Playfield-SPACE clip: call with NO active draw_set_transform (the projectile loop draws
## untransformed). `vis` is dst intersect clip, so vis is a subset of dst and its offset from
## dpos is >= 0 -- that is what keeps the source region inside the texture (SD and --hd alike).
func _blit_clip(folder: String, frame: int, pos: Vector2, clip: Rect2) -> bool:
	var tex := _sprite(folder, frame)
	if tex == null:
		return false
	_dtex_clip(tex, pos + (Vector2(CELL_PX, CELL_PX) - _texsize(tex)) * 0.5, clip)
	return true

func _dtex_clip(tex: Texture2D, dpos: Vector2, clip: Rect2) -> void:
	var s := _texsize(tex)
	var dst := Rect2(dpos, s)
	if clip.encloses(dst):
		_dtex(tex, dpos)                       # fully inside: normal path (keeps --hd handling)
		return
	var vis := dst.intersection(clip)
	if not vis.has_area():
		return                                 # fully off the playfield: draw nothing
	var sc := float(_sprite_scale)             # texture is sc x the logical footprint (--hd)
	# vis is a subset of dst, so (vis.position - dpos) >= 0 and (offset + size) * sc stays
	# within tex.get_size() == _texsize(tex) * _sprite_scale -- src never runs off the sheet.
	var src := Rect2((vis.position - dpos) * sc, vis.size * sc)
	draw_texture_rect_region(tex, vis, src)

## _blit_clip for a moving sprite: keyed so REMASTERED can draw it between engine ticks.
func _iblit_clip(key: String, folder: String, frame: int, pos: Vector2, clip: Rect2) -> bool:
	var tex := _sprite(folder, frame)
	if tex == null:
		return false
	_isprite(key, folder, frame, false, false, pos + (Vector2(CELL_PX, CELL_PX) - _texsize(tex)) * 0.5, false, clip)
	return true

## Draw an entity's sprite. ORIGINAL: at once, exactly as given. REMASTERED: record it as this
## tick's sample of `key`, then draw the key's state at the render time (_draw_hist). `planted`
## = the pose is tied to ground travel (walk/run): without an in-between it steps with its pose
## instead of gliding. `hide` samples keep the history going while the sprite is not drawn.
func _isprite(key: String, folder: String, frame: int, flip: bool, red: bool, dpos: Vector2,
		planted := false, clip := Rect2(), hide := false) -> void:
	if not _smooth:
		if not hide:
			var tex := _sprite(folder, frame, flip, red)
			if tex != null:
				_draw_sprite_at(tex, dpos, clip)
		return
	_seen[key] = _draw_serial
	var h: Array = _hist.get(key, [])
	if h.is_empty() or int(h[-1][0]) != _drawn_tick:
		var s := [_drawn_tick, dpos, folder, frame, flip, red, planted, hide]
		if not h.is_empty() and int(h[-1][0]) >= _drawn_tick - 8 and h[-1][2] == folder \
				and (h[-1][1] as Vector2).distance_to(dpos) <= SMOOTH_SNAP:
			h.append(s)
			if h.size() > 8:
				h.pop_front()
		else:
			h = [s]
		_hist[key] = h
	# a new entity appears on the delayed timeline; one already there when the histories restarted,
	# or a player whose history restarts (teleport, respawn), is shown at once instead of vanishing
	_draw_hist(key, h, clip, key.begins_with("p") or int(h[0][0]) <= _smooth_t0 + 1)

## Entities that left play (killed, collected, spent) stay on the delayed picture until the render
## time passes their last engine state; then their history is dropped.
func _draw_ghosts(prefix: String) -> void:
	if not _smooth:
		return
	var tr := _rtick - SMOOTH_DELAY
	for key in _hist.keys():
		if not (key as String).begins_with(prefix) or int(_seen.get(key, -1)) == _draw_serial:
			continue
		var h: Array = _hist[key]
		if tr >= float(h[-1][0]) + 1.0:
			_hist.erase(key)
			_seen.erase(key)
			for lv in _live.values():
				if lv != null:
					(lv as Live3D).release(key)
		else:
			_draw_hist(key, h, Rect2(ORIGIN_X, ORIGIN_Y, GRID_COLS * CELL_PX, GRID_ROWS * CELL_PX) if key.begins_with("j") else Rect2(), false)

## Draw a history at the render time: between the keyframe before it and the next one (a keyframe =
## a sample whose drawn state changed), the step spread over its last SMOOTH_SPAN ticks.
func _draw_hist(key: String, h: Array, clip: Rect2, early: bool) -> void:
	var tr := _rtick - SMOOTH_DELAY
	if float(h[0][0]) > tr:
		if early and not bool(h[0][7]) and not _draw_live(key, h[0][2], h[0][3], h[0][3], 0.0, h[0][4], h[0][5], h[0][1], clip):
			_draw_sprite_at(_sprite(h[0][2], h[0][3], h[0][4], h[0][5]), h[0][1], clip)
		return                                 # not on the delayed picture yet
	var ka := 0
	var kb := -1
	for i in range(1, h.size()):
		var p: Array = h[i - 1]
		var q: Array = h[i]
		if q[1] != p[1] or q[3] != p[3] or q[4] != p[4] or q[5] != p[5] or q[7] != p[7]:
			if float(q[0]) > tr:
				kb = i
				break
			ka = i
	var a: Array = h[ka]
	if kb < 0:
		if not bool(a[7]) and not _draw_live(key, a[2], a[3], a[3], 0.0, a[4], a[5], a[1], clip):
			_draw_sprite_at(_sprite(a[2], a[3], a[4], a[5]), a[1], clip)
		return
	var b: Array = h[kb]
	var span := minf(float(b[0]) - float(a[0]), SMOOTH_SPAN)
	var f := clampf((tr - (float(b[0]) - span)) / span, 0.0, 1.0)
	var pos: Vector2 = (a[1] as Vector2).lerp(b[1], f)
	var near: Array = a if f < 0.5 else b
	if bool(near[7]):
		return                                 # hidden (invulnerability blink)
	if a[2] == b[2] and a[4] == b[4] and a[5] == b[5] and _draw_live(key, a[2], a[3], b[3], f, a[4], a[5], pos, clip):
		return
	var tex: Texture2D = null
	if int(a[3]) != int(b[3]) and a[4] == b[4] and a[5] == b[5]:
		tex = _tween_sprite(a[2], a[3], b[3], f, a[4], a[5])
		if tex == null and bool(a[6]) and bool(b[6]):
			pos = a[1]                         # planted, no in-between: step with the pose
			near = a
	if tex == null:
		tex = _sprite(near[2], near[3], near[4], near[5])
	_draw_sprite_at(tex, pos, clip)

func _draw_sprite_at(tex: Texture2D, dpos: Vector2, clip: Rect2) -> void:
	if tex == null:
		return
	if clip.has_area():
		_dtex_clip(tex, dpos, clip)
	else:
		_dtex(tex, dpos)

## Draw entity `key` with a live 3D rig of its sheet, posed f of the way from frame a to b, at the
## display's resolution; false when no gated rig covers both frames (or live 3D is off) -> the frames.
func _draw_live(key: String, folder: String, a: int, b: int, f: float, flip: bool, red: bool, dpos: Vector2,
		clip: Rect2) -> bool:
	if not (_live_on and _use_3d and _remastered):
		return false
	if not _live_scanned:
		_scan_live()
	var fam := ""
	for e in _live_index.get(folder, []):
		if (e[1] as Dictionary).has(a) and (e[1] as Dictionary).has(b):
			fam = e[0]
			break
	if fam == "":
		return false
	if not _live.has(fam):
		_live[fam] = Live3D.load_family(fam, self)
	var lv: Live3D = _live[fam]
	if lv == null:
		return false
	var ws := get_window().size
	var s := clampi(int(round(minf(float(ws.x) / 640.0, float(ws.y) / 480.0))), 1, 8)
	var tex := lv.texture_for(key, a, b, f, s, red, flip)
	if tex == null:
		return false
	var dst := Rect2(dpos, Vector2(lv.frame_size(a, b)))
	var vis := dst.intersection(clip) if clip.has_area() else dst
	if vis.has_area():
		draw_texture_rect_region(tex, vis, Rect2((vis.position - dpos) * s, vis.size * s))
	return true

## Index the live rigs that passed `framematch.py <family> livegate` (their gate.json) by sheet.
func _scan_live() -> void:
	_live_scanned = true
	var root := ProjectSettings.globalize_path(LIVE_DIR)
	if not DirAccess.dir_exists_absolute(root):
		return
	for fam in DirAccess.get_directories_at(root):
		var p := "%s/%s/gate.json" % [root, fam]
		if not FileAccess.file_exists(p):
			continue
		var g: Variant = JSON.parse_string(FileAccess.get_file_as_string(p))
		if not (g is Dictionary) or not bool(g.get("pass", false)):
			continue
		var frames := {}
		for n in g["frames"]:
			frames[int(n)] = true
		if not _live_index.has(g["sheet"]):
			_live_index[g["sheet"]] = []
		_live_index[g["sheet"]].append([fam, frames])

## The rendered in-between poses of a sheet (tools/soi3d/framematch.py `tweens`):
## sprites_3d_frames/<folder>/tw/fLO-HI_KofN.png = the pose K/N of the way from frame LO to HI.
func _tween_index(folder: String) -> Dictionary:
	if _tween_idx.has(folder):
		return _tween_idx[folder]
	var idx := {}
	var dir := ProjectSettings.globalize_path("%s/%s/tw" % [SPRITES_3D_DIR, folder])
	var da := DirAccess.open(dir)
	if da != null:
		for f in da.get_files():
			var m := _TWEEN_RE.search(f)
			if m != null:
				var pk := "%d,%d" % [int(m.get_string(1)), int(m.get_string(2))]
				if not idx.has(pk):
					idx[pk] = [int(m.get_string(4)), {}]
				idx[pk][1][int(m.get_string(3))] = dir + "/" + f
	_tween_idx[folder] = idx
	return idx

## The pose `f` of the way from frame a to frame b (3D sprites only), or null without in-betweens.
func _tween_sprite(folder: String, a: int, b: int, f: float, flip: bool, red: bool) -> Texture2D:
	if not (_use_3d and _remastered):
		return null
	var lo := mini(a, b)
	var hi := maxi(a, b)
	var e: Array = _tween_index(folder).get("%d,%d" % [lo, hi], [])
	if e.is_empty():
		return null
	var n: int = e[0]
	var k := int(round((f if a == lo else 1.0 - f) * float(n)))
	if k <= 0 or k >= n:
		return _sprite(folder, lo if k <= 0 else hi, flip, red)
	var path: String = e[1].get(k, "")
	if path == "":
		return null
	var key := "tw/%s/%d-%d/%d/%s/%s" % [folder, lo, hi, k, flip, red]
	if _tex_cache.has(key):
		return _tex_cache[key]
	var tex: Texture2D = null
	var img := Image.load_from_file(path)
	if img:
		if red:
			_redden(img)
		if flip:
			img.flip_x()
		_prep_hd(img)
		tex = ImageTexture.create_from_image(img)
	_tex_cache[key] = tex
	return tex

## The board as the delayed REMASTERED picture shows it (the live grid when not smoothing).
func _grid_at(c: int, r: int, snap: PackedInt32Array) -> int:
	return snap[r * GRID_COLS + c] if not snap.is_empty() else int(_core.grid_cell(c, r))

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
var _pict_dir := PICT_DIR       # REMASTERED repoints this at extracted/pict_hd_v2|pict_hd (4x AI-upscaled art)
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
					if _pict_scale > 1:
						_prep_hd(img)
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
	if _num_players <= 1 or not _mode_compete:
		# Co-op tallies ONE team pool (player 1's slot, asm FUN_100153d0 -> FUN_10015714(3)), so it
		# shares this single centred panel.
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
	# Per-player stacked rows (Compete; normally its wins screen is shown instead).
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
	var sub := Engine.get_physics_interpolation_fraction() if _smooth else 0.0   # the sim is frozen: glide on the frame clock
	var t := clampf((float(step) + sub) / float(TRANSPORT_FRAMES), 0.0, 1.0)
	var pos := _tp_from.lerp(_tp_to, t)
	var frame := 2 + (step % 13)             # cycle the transporter/ frames f02..f14 (fast spin)
	var tex := _sprite("transporter", frame)
	if tex == null:
		return
	var s := _texsize(tex)
	if _smooth:
		var tw := _tween_sprite("transporter", frame, 2 + (step + 1) % 13, sub, false, false)
		if tw != null:
			tex = tw
		_dtex(tex, pos + Vector2(CELL_PX, CELL_PX) * 0.5 - s * 0.5)
		return
	_dtex(tex, (pos + Vector2(CELL_PX, CELL_PX) * 0.5 - s * 0.5).floor())   # centred on the cell

## Challenge Round completion ("Your Rewards", asm FUN_10016f80(0)): PICT 301 with the blue tally
## panel PICT 303 centred at y=0x8c; the remaining Bonus is drawn at (0x1ad,0x9c) and the Score at
## (0x1ad,0xbf) climbs as Bonus x mult is added (a Challenge Round pays no No-Weapons Reward). Solo
## and co-op both show player 1 (co-op's team pool).
func _draw_challenge_rewards() -> void:
	_draw_pict_screen("challenge_rewards", "YOUR REWARDS", "Enter: next board     Esc: menu")
	var panel := _pict("blue_challenge_tally")
	if panel != null:
		_draw_pict(panel, Vector2(floorf(320.0 - _pict_size(panel).x * 0.5), 140.0))
	var delta := int(_tally_bonus.get(1, 0))
	var final_score := int(_tally_final.get(1, _core.player_score(1)))
	_tally_digits(_tally_prebonus, 429.0, 156.0)
	_tally_digits(final_score - int(round(delta * (1.0 - _tally_anim))), 429.0, 191.0)

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
	# Prefer the AI-upscaled HD clip (extracted/movies_hd, tools/upscale_win_movies.py) when
	# REMASTERED; ORIGINAL (and a missing HD clip) plays the faithful SD extraction (extracted/movies).
	for sub in (["movies_hd", "movies"] if _remastered else ["movies"]):
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
## or dock a life (on a death), and pass the seat to the other player. A death on a
## Challenge Round (FUN_10016f80(failed)) banks nothing and costs no life -- the loot is
## lost, the turn-start counters come back -- but that player still moves on a board.
func _alt_end_turn(won: bool) -> void:
	var failed_challenge := not won and _core.challenge_round()
	if not failed_challenge:
		_alt_score[_alt_active] += int(_core.player_score(1))
		_alt_ammo[_alt_active] = [int(_core.player_arrows(1)), int(_core.player_balls(1))]
		_alt_lives[_alt_active] = int(_core.player_lives(1)) + 1   # reserve (+1UPs / -death) + the life in play
	if won or failed_challenge:
		_alt_board[_alt_active] += 1
		if Session.board_list.size() > 0 and _alt_board[_alt_active] >= Session.board_list.size():
			_alt_out[_alt_active] = true            # cleared every board -> done
	elif _alt_lives[_alt_active] <= 0:
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
	_alt_apply_turn_stats()
	_alt_prev_alive = true
	_alt_state = "play"

## Load the active Alternate player's own counters into the core's single slot: the HUD face
## shows their RESERVE lives (attempts left - 1) and their banked ammo carries over.
func _alt_apply_turn_stats() -> void:
	var a: Array = _alt_ammo[_alt_active]
	_core.set_player_stats(1, 0, maxi(int(_alt_lives[_alt_active]) - 1, 0), int(a[0]), int(a[1]), 2)

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
		var status := "OUT" if _alt_out[i] else ("LIVES %d" % maxi(int(_alt_lives[i]) - 1, 0))   # reserve lives, as the HUD face
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
	if _core.challenge_failed() and not _has_next_board():
		return true   # failing the final (board-100) challenge still ends the campaign (FUN_1001768c)
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

## Is the current board a CHALLENGE ROUND? The original keys it on a Knight or Gargoyle being on
## the board (FUN_10017a70 -> DAT_1003ad0e) -- every 10th campaign board, 410..500.
func _is_challenge_board() -> bool:
	return _core != null and _core.challenge_round()

## A failed Challenge Round (FUN_10016f80(failed)): the board-start score / lives / ammo come back
## (the loot is lost, no life is spent) and play moves on to the NEXT board regardless.
func _challenge_fail_advance() -> void:
	var saved := _board_start_stats.duplicate(true)
	if not Session.advance():
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		return
	_level_bytes = _load_level_bytes()
	for i in range(1, mini(_num_players, 3) + 1):
		if i - 1 < saved.size():
			var st: Dictionary = saved[i - 1]
			_core.set_player_stats(i, int(st.get("score", 0)), int(st.get("lives", 2)),
				int(st.get("arrows", 1)), int(st.get("balls", 1)), int(st.get("shield", 2)))
	_next_board()

## "Nothing!" -- the failed-challenge screen: PICT 301 with PICT 302 centred at (318,275).
func _draw_challenge_failed() -> void:
	_draw_pict_screen("challenge_rewards", "NOTHING!", "")
	var t := _pict("Nothing")
	if t != null:
		_draw_pict(t, (Vector2(318, 275) - _pict_size(t) * 0.5).floor())


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
	for a in ua:
		if a.begins_with("--shot") or a.begins_with("--demo") or a.begins_with("--play=") or a.begins_with("--bug3"):
			_harness_run = true
	if "--hd" in ua or "--3d" in ua:      # opt-in HD: load the 4x AI-upscaled sheets and render the 640x480
		var win := get_window()            # canvas at the window's higher resolution so the extra detail shows
		win.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS   # (project.godot already sets
		win.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_KEEP       # the same stretch, so a live F2
		win.content_scale_size = Vector2i(640, 480)                        # switch needs no window change)
	# ORIGINAL <-> REMASTERED presentation: starts REMASTERED with --3d / --hd (Session), F2 flips it
	# live. REMASTERED shows the 3D overlay unless launched with plain --hd (HD sheets only; F3 toggles).
	# The ORIGINAL (default) path is the byte-for-byte SD one the gate captures.
	Session.init_presentation()
	_use_3d = "--3d" in ua or not ("--hd" in ua)
	_apply_presentation(Session.remastered)
	_num_players = Session.num_players if Session.num_players > 0 else 2
	_mode_compete = Session.mode == 1
	_alt = Session.mode == 2
	for arg in ua:
		if arg == "--mode=retro": _mode = 0
		elif arg == "--mode=remastered": _mode = 1
		elif arg == "--players=3": _num_players = 3
		elif arg == "--players=2": _num_players = 2
		elif arg == "--players=1": _num_players = 1
		elif arg == "--compete": _mode_compete = true
		elif arg == "--alternate": _alt = true
	if ("--demo" in ua) or ("--fx" in ua) or ("--bug3" in ua):
		_num_players = 1   # the showcase demos are single-player, so the faithful 1-player
		                   # Board-Completed tally (PICT 1020 panel + sprite digits) shows
		                   # instead of the co-op panel (the loader still parks P2; not drawn)
	if _alt:
		_num_players = 1
		var s := maxi(Session.board_index, 0)
		_alt_board = [s, s]
		_alt_lives = [3, 3]; _alt_ammo = [[1, 1], [1, 1]]; _alt_score = [0, 0]; _alt_active = 0
		_alt_out = [false, false]; _alt_prev_alive = true; _alt_state = "play"
	_start()
	if not _harness_run and not Session.presentation_hint_shown:
		Session.presentation_hint_shown = true
		_pres_toast = 240   # once per launch: say which presentation this is + that F2 switches it

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
		_core.new_game(_core_mode())   # new-game stats per mode (asm FUN_1002b060; see _core_mode)
	if _alt:
		_alt_apply_turn_stats()
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
		elif arg.begins_with("--script="):
			_load_script(arg.substr(9))
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
	for lv in _live.values():
		if lv != null:
			(lv as Live3D).dispose()
	_live.clear()
	_core = null


## Switch the whole presentation live (F2): ORIGINAL = the 1996 SD sprite sheets + PICTs;
## REMASTERED = the 4x HD sheets under the frame-matched 3D overlay (_folder_index) + the HD
## PICTs. Gameplay is untouched -- only what is drawn (and, via Session.set_remastered, the
## SFX set + soundtrack) changes, so a switch mid-board is seamless.
func _apply_presentation(on: bool) -> void:
	_remastered = on
	_sprites_dir = "res://../extracted/sprites_hd" if on else SPRITES_DIR
	_sprite_scale = 4 if on else 1
	_pict_dir = PICT_DIR
	_pict_scale = 1
	if on:
		# Prefer the newest HD PICT set (pict_hd_v2), else pict_hd. Deleting the
		# pict_hd_v2 folder reverts to the previous set (tools/upscale_picts.py --out).
		for hd in ["pict_hd_v2", "pict_hd"]:
			if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://../extracted/" + hd)):
				_pict_dir = "res://../extracted/" + hd
				_pict_scale = 4
				break
	# 4x art resamples smoothly into its 1x footprint at any window size (mipmapped, _prep_hd);
	# the 1996 pixel art stays nearest-neighbour -- crisp pixels, the project default.
	texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS if on else CanvasItem.TEXTURE_FILTER_NEAREST
	_tex_cache.clear()
	_sprite_index.clear()
	_pict_cache.clear()
	_tween_idx.clear()
	_smooth = on
	_reset_smoothing()
	if Session.remastered != on:
		Session.set_remastered(on)

## Forget the per-entity histories and the delayed board (a new board, or a presentation switch).
func _reset_smoothing() -> void:
	_hist.clear()
	_seen.clear()
	_grid_snaps.clear()
	_release_live()
	_drawn_tick = -1
	_rtick = float(_core.tick_count()) if _core != null else 0.0
	_smooth_t0 = int(_rtick)

## REMASTERED redraws every rendered frame (the monitor's rate); the engine keeps its own tick.
func _process(_delta: float) -> void:
	if _smooth:
		queue_redraw()
	if Engine.get_process_frames() % 60 == 0:
		for lv in _live.values():
			if lv != null:
				(lv as Live3D).release_idle(30)   # killed / off-board entities

## Free every live 3D render (they are re-made on demand).
func _release_live() -> void:
	for lv in _live.values():
		if lv != null:
			(lv as Live3D).release_all()

## The presentation label, shown briefly after F2/F3 (and once at the first board).
func _draw_presentation_toast() -> void:
	var a := clampf(float(_pres_toast) / 30.0, 0.0, 1.0)
	var label := "ORIGINAL  -  1996 art, sound and music      [F2: remastered]"
	if _toast_text != "":
		label = _toast_text
	elif _remastered and _use_3d:
		label = "REMASTERED  -  %s 3D sprites, remastered sound and music    [F2: original   F3: HD   F4: %s]" % [
			"live" if _live_on else "pre-rendered", "pre-rendered 3D" if _live_on else "live 3D"]
	elif _remastered:
		label = "REMASTERED  -  HD sprites, remastered sound and music      [F2: original   F3: 3D]"
	var fs := 13
	while fs > 9 and _font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > 632.0:
		fs -= 1
	draw_rect(Rect2(0, 454, 640, 22), Color(0, 0, 0, 0.72 * a))
	draw_string(_font, Vector2(0, 470), label, HORIZONTAL_ALIGNMENT_CENTER, 640, fs, Color(1, 1, 1, a))


## The core play mode (asm FUN_100263d8 numbering): 1 One Player, 2 Alternate, 3 Cooperate
## (one shared score/lives/ammo/Bonus pool in P1's slot), 4 Compete.
func _core_mode() -> int:
	if _alt:
		return 2
	if _num_players <= 1:
		return 1
	return 4 if _mode_compete else 3

## (re)start the current board from a clean core state.
func _start() -> void:
	_core.init(1)
	_core.load_level(_level_bytes)
	_core.set_play_mode(_core_mode())
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
	_sg_t0 = [-1e6, -1e6, -1e6, -1e6, -1e6]
	_sg_last = [-1, -1, -1, -1]
	_death_pops.clear()
	_debris.clear()
	_reset_smoothing()
	_capture_board_start()
	if not _harness_run and _core.challenge_round():
		_challenge_intro = 150   # "Challenge Round" intro before a challenge board
		Audio.play_snd(1500)     # Challenge Round jingle (asm event 0x35 -> snd 1500, FUN_10016c90)

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
				_sg_t0[g] = float(_core.tick_count())
				Audio.play_snd(1006)   # switch click (evt 0x2c; sequential after clock 0x2B -> 1005)
				_sg_last[idx] = key
		else:
			_sg_last[idx] = -1

func _physics_process(_delta: float) -> void:
	_core_ticked = false
	if _tp_frames > 0:
		_tp_frames -= 1              # transporter slide in progress: FREEZE the sim (skip the core tick)
	elif _script_hold:
		pass
	elif not _paused and not _core.game_over() and not _core.level_complete() and not (_alt and _alt_state != "play") and _challenge_intro == 0 and (_alt or not _core.challenge_failed()):
		_tally_prebonus = int(_core.bonus_time())   # remaining bonus before this tick (for the multiplier)
		for idx in range(1, mini(_num_players, 3) + 1):
			_tally_pre[idx] = int(_core.player_score(idx))   # pre-tick score; bonus award = post-tick delta
			_tp_pre[idx] = Vector2(_core.player_x(idx), _core.player_y(idx))   # pre-tick pos (teleport detect)
		var p1 := _read_input(0)
		var p2 := _read_input(1) if _num_players >= 2 else 0   # single-player: P2 (WASD) is off
		if not _script.is_empty():
			var seg: Array = _script_seg()
			p1 = int(seg[0])
			p2 = int(seg[2])
		elif _demo_frames > 0:
			p1 = _demo_input()         # scripted play for the --demo movie / capture
		elif _play_frames > 0:
			p1 = _play_input()         # scripted play on a real board (--play recording)
		elif _shot_countdown > 0:
			p1 = IN_RIGHT              # scripted input for a plain --shot screenshot
		var p3 := _read_input(2) if _num_players >= 3 else 0
		_core.tick3(p1, p2, p3)
		_core_ticked = true
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
		for fi in _core.fx_count():   # every block shatter / goody pop this tick -> its debris particles
			_spawn_debris(fi)
		_step_debris()
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
			# FUN_10029264 play FUN_1002b020(0x1f,100) at completion). A Challenge Round warps too.
			if not _alt and not _mode_compete:
				Audio.play_snd(16969)
			# Beat the whole campaign -> switch to the ending tune (Angel Pie, FUN_1001768c).
			# Co-op/single only; Alternate + Compete have their own end screens.
			if not _alt and not _mode_compete and not _has_next_board():
				Audio.play_ending_music()
	if _core.level_complete():
		# The board-clear WARP plays first (coop/single, Challenge Rounds included -- FUN_10028a0c
		# runs FUN_10026bb8 before choosing the tally or the challenge reward); the count-up waits
		# until the tunnel finishes. Compete/Alternate have no warp -> tally at once.
		if not _alt and not _mode_compete and _warp_anim < 1.0:
			_warp_anim = minf(_warp_anim + 1.0 / WARP_FRAMES, 1.0)
		elif _tally_anim < 1.0:
			var prev_anim := _tally_anim
			_tally_anim = minf(_tally_anim + 1.0 / TALLY_FRAMES, 1.0)   # count-up progress (also gates HS-on-win)
			# The count-up scale rings on the coop "Board Completed" tally (FUN_10015714) and the
			# Challenge reward (FUN_10016f80 plays the same 0x2e / 0x30+i / 0x2f notes) -- not the
			# Compete wins screens or Alternate's hand-off.
			if not _alt and not _mode_compete:
				_tally_dings(prev_anim, _tally_anim)
	if not _alt and _core.challenge_failed() and not _challenge_forfeited:
		_challenge_forfeited = true   # FUN_10016f80(failed): "Nothing!" + event 8
		Audio.play_snd(32129)
	if not _hs_checked and _hs_game_ended():
		_hs_checked = true
		var sc := _hs_final_score()
		if Session.qualifies(sc):
			_hs_score = sc; _hs_name = ""; _hs_state = "entry"   # NEW HIGH SCORE -> take initials
			Audio.play_snd(1501)   # high-score entry jingle (asm event 0x36 -> snd 1501, FUN_10022dfc)
	if _save_flash > 0:
		_save_flash -= 1
	if _pres_toast > 0:
		_pres_toast -= 1
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
	if not _smooth:
		queue_redraw()                 # (smooth: _process redraws every rendered frame instead)
	if _demo_frames > 0:
		_demo_frames -= 1
		if _demo_frames == 0:
			get_tree().quit()          # ends the Movie Maker recording
	if _play_frames > 0:
		_play_frames -= 1
		if _play_frames == 0:
			get_tree().quit()          # ends the real-board Movie Maker recording
	if not _script.is_empty():
		_script_step()
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

## --script=FILE (verification runs): one segment per line, `<p1> <frames> [p2]`, where an input
## is a bitmask or letters L R J H(block high) W(block low) A(arrow) O(ball) and 0 = none.
## `ENTER` presses Enter, `F2` / `F3` / `F4` press those keys (presentation switch), `HOLD` freezes /
## resumes the simulation (no pause screen: shoot one instant twice), `SHOT <name>` saves
## media/screenshots/verify_<name>.png, `QUIT` ends,
## `SPEED <n>` fast-forwards n physics frames per rendered frame (so a movie skips a long wait).
## Frames count physics frames (they keep running through intros / result screens).
func _load_script(path: String) -> void:
	if not path.is_absolute_path():
		path = ProjectSettings.globalize_path("res://../" + path)
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_warning("--script: cannot open %s" % path)
		return
	while not f.eof_reached():
		var line := f.get_line().strip_edges()
		if line == "" or line.begins_with("#"):
			continue
		var parts := line.split(" ", false)
		var cmd := parts[0].to_upper()
		if cmd == "ENTER" or cmd == "SHOT" or cmd == "QUIT" or cmd == "SPEED" or cmd == "F2" or cmd == "F3" or cmd == "F4" or cmd == "HOLD":
			_script.append([0, 1, 0, cmd, parts[1] if parts.size() > 1 else ""])
		else:
			var frames := int(parts[1]) if parts.size() > 1 else 1
			var p2 := _script_mask(parts[2]) if parts.size() > 2 else 0
			_script.append([_script_mask(parts[0]), frames, p2, "", ""])

func _script_mask(s: String) -> int:
	if s.is_valid_int():
		return int(s)
	var m := 0
	for ch in s.to_upper():
		match ch:
			"L": m |= IN_LEFT
			"R": m |= IN_RIGHT
			"J": m |= IN_JUMP
			"H": m |= IN_BLOCK_HIGH
			"W": m |= IN_BLOCK_LOW
			"A": m |= IN_ARROW
			"O": m |= IN_BALL
	return m

## The segment active at the current script frame (or an idle one past the end).
func _script_seg() -> Array:
	var acc := 0
	for seg in _script:
		acc += int(seg[1])
		if _script_f < acc:
			return seg
	return [0, 1, 0, "", ""]

## Advance the script one frame, firing a command on its (single) frame.
func _script_step() -> void:
	var acc := 0
	var total := 0
	for seg in _script:
		total += int(seg[1])
	for seg in _script:
		if _script_f == acc and seg[3] != "":
			match seg[3]:
				"ENTER": _press_enter()
				"F2": _press_f2()
				"F3": _press_f3()
				"F4": _press_f4()
				"HOLD": _script_hold = not _script_hold
				"SHOT": _snap("verify_" + str(seg[4]))
				"QUIT": total = _script_f
				"SPEED":
					var n := maxi(int(seg[4]), 1)
					Engine.max_physics_steps_per_frame = maxi(n, 8)
					Engine.physics_ticks_per_second = SPEED_HZ[clampi(Session.speed, 0, 3)] * n
		acc += int(seg[1])
	_script_f += 1
	if _script_f > total:
		_script = []
		await RenderingServer.frame_post_draw
		get_tree().quit()

func _snap(name: String) -> void:
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	var dir := ProjectSettings.globalize_path("res://../media/screenshots")
	DirAccess.make_dir_recursive_absolute(dir)
	img.save_png("%s/%s.png" % [dir, name])
	print("saved screenshot -> %s/%s.png" % [dir, name])

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
		KEY_F2:
			if not e.echo:
				_press_f2()
		KEY_F3:
			if not e.echo:
				_press_f3()
		KEY_F4:
			if not e.echo:
				_press_f4()
		KEY_F6:
			if not e.echo:
				_press_f6()
		KEY_S:
			if (e as InputEventKey).ctrl_pressed:
				_do_save()   # QuickSave (About doc 8: Command-S; Ctrl-S here)
		KEY_ENTER, KEY_KP_ENTER:
			_press_enter()

## F2: ORIGINAL <-> REMASTERED -- art + SFX + music, live.
func _press_f2() -> void:
	_apply_presentation(not _remastered)
	_toast_text = ""
	_pres_toast = 150

## F6: custom-recording sound mode on/off (audio.gd CUSTOM_SFX_DIR).
func _press_f6() -> void:
	var n := Audio.set_custom_sfx(not Audio.is_custom_sfx())
	_toast_text = ("CUSTOM SOUNDS ON  -  %d recordings loaded from custom_sfx/      [F6: off]" % n) \
		if Audio.is_custom_sfx() else "CUSTOM SOUNDS OFF      [F6: on]"
	_pres_toast = 150

## F3 (REMASTERED only): HD <-> frame-matched 3D sprites (both are 4x sets).
func _press_f3() -> void:
	if _remastered:
		_use_3d = not _use_3d
		_tex_cache.clear()
		_sprite_index.clear()
		_release_live()
		_toast_text = ""
		_pres_toast = 150

## F4 (REMASTERED 3D only): sheets with a live rig drawn in real-time 3D <-> as pre-rendered frames.
func _press_f4() -> void:
	if _remastered and _use_3d:
		_live_on = not _live_on
		_release_live()
		_toast_text = ""
		_pres_toast = 150

## Enter: advance the current result screen (retry / next board / next Alternate turn).
func _press_enter() -> void:
	if _challenge_intro > 0:
		_challenge_intro = 0
		return
	if _alt:
		if _alt_state == "results":
			get_tree().change_scene_to_file("res://scenes/menu.tscn")
		elif _alt_state == "transition":
			_alt_begin_turn()
		elif _core.level_complete():
			_alt_end_turn(true)   # board cleared -> advance this player's board, pass the seat
	elif _core.game_over():
		_start()   # retry the board
		_core.new_game(_core_mode())
		_capture_board_start()
	elif _core.challenge_failed():
		_challenge_fail_advance()
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
	var tk := int(_core.tick_count())
	_new_tick = (not _smooth) or tk != _drawn_tick
	_drawn_tick = tk
	_draw_serial += 1
	var snap := PackedInt32Array()
	var banims := {}
	if _smooth:
		if _core_ticked:
			_rtick = float(tk) + Engine.get_physics_interpolation_fraction()
		if _new_tick or _grid_snaps.is_empty():
			var g := PackedInt32Array()
			g.resize(GRID_COLS * GRID_ROWS)
			for r in range(GRID_ROWS):
				for c in range(GRID_COLS):
					g[r * GRID_COLS + c] = int(_core.grid_cell(c, r))
			_grid_snaps.append([tk, g, _block_anims()])
			if _grid_snaps.size() > 6:
				_grid_snaps.pop_front()
		snap = _grid_snaps[0][1]
		banims = _grid_snaps[0][2]
		for gs in _grid_snaps:
			if float(gs[0]) <= _rtick - SMOOTH_DELAY:
				snap = gs[1]
				banims = gs[2]
	else:
		banims = _block_anims()
	# black outside the frame (the original sits on a black CRT field)
	draw_rect(Rect2(0, 0, 640, 480), Color.BLACK)
	var W := GRID_COLS * CELL_PX
	var H := GRID_ROWS * CELL_PX
	var pf := Rect2(ORIGIN_X, ORIGIN_Y, W, H)
	_draw_frame(pf)
	draw_rect(pf, Color.BLACK)   # black playfield

	# grid cells: beveled blocks / red balls / coins / key / door. A block being BUILT grows in,
	# and one being REMOVED (the player's toggle, a chomping nasty) shrinks out, through the
	# original's own block_sprites frames 1..5 (white squares, small -> full) -- the core's block
	# animation list (asm FUN_100283a0). The cell meanwhile holds a placeholder (a locked 0x300 /
	# a standable 0x200) that is not drawn; a removed block's payload goody shows at once under the
	# shrinking square (FUN_1002cc10). Blocks that SHATTER instead fly apart as debris (below).
	for r in range(GRID_ROWS):
		for c in range(GRID_COLS):
			var key := r * GRID_COLS + c
			var cell := _grid_at(c, r, snap)
			var pos := Vector2(ORIGIN_X + c * CELL_PX, ORIGIN_Y + r * CELL_PX)
			if banims.has(key):
				if cell & CELL_DOOR:
					_draw_cell(cell & ~CELL_SUPPORTIVE, pos)
				_blit("block_sprites", ((int(banims[key]) >> 16) & 0xFF) + 1, pos)
				continue
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

	# projectiles: the player's straight ARROW (weapons f10/f11) and rolling swirl BALL (f02-09),
	# the enemies' cannon balls, Walker bolts, Gargoyle puffs/eggs and Knight gifts.
	for i in range(MAX_PROJECTILES):
		if _core.projectile_active(i):
			var pp := Vector2(_core.projectile_x(i), _core.projectile_y(i))
			var c := pp + Vector2(16, 16)
			if _new_tick:
				_proj_left[i] = pp.x < float(_proj_lastpos.get(i, pp).x)
				_proj_lastpos[i] = pp
			var going_left: bool = _proj_left.get(i, false)
			var jk := "j%d" % i
			if _core.projectile_hostile(i):
				if _core.projectile_src_type(i) == 12:    # Cannon ball: asm frames 3..0x16 (f04-23), +1 a
					var sp := int(_core.tick_count()) % 20  # frame heading right, -1 heading left
					var bf := (23 - sp) if going_left else (4 + sp)
					if not _iblit_clip(jk, "cannon_sprites", bf, pp, pf):
						draw_circle(c, 6.0, Color(0.9, 0.3, 0.2))
				elif _core.projectile_src_type(i) == 14:  # Gargoyle puff: green cluster, master's objects (sssf 134)
					# asm FUN_1000b0a4 cycles frames 1..15 for a piercing puff, 0x1f..0x2d otherwise (+1 in the PNGs)
					var gbase := 2 if _core.projectile_pierce(i) else 32
					if not _iblit_clip(jk, "master_s_objects", gbase + int(_core.tick_count()) % 15, pp, pf):
						draw_circle(c, 6.0, Color(0.2, 0.7, 0.2))
				elif _core.projectile_src_type(i) == 10:  # Walker bolt (0x68, FUN_1000e3c0): asm frames
					var ks := int(_core.tick_count()) % 16  # 0x31..0x40 (f50-65) a frame each, backward left
					var kf := (65 - ks) if going_left else (50 + ks)
					if not _iblit_clip(jk, "walker_sprites", kf, pp, pf):
						draw_circle(c, 4.5, Color(0.85, 0.15, 0.12))
				else:                                     # other hostile shot: a generic energy bolt
					draw_circle(c, 5.0, Color(0.65, 0.1, 0.75))
					draw_circle(c, 2.5, Color(1, 0.55, 1))
			elif _core.projectile_kind(i) == 3:
				# Gargoyle BADGUY EGG in flight (asm FUN_1000b6a0: counter +1 per tick, past 0x3c back to
				# 0x2e = 15 frames, f47-f61 in the PNGs)
				if not _iblit_clip(jk, "master_s_objects", 47 + int(_core.tick_count()) % 15, pp, pf):
					draw_circle(c, 6.0, Color(0.6, 0.1, 0.1))
			elif _core.projectile_kind(i) == 2:
				# Knight GIFT in flight (enemy_knight_gift / FUN_1000c8bc): the asm mover FUN_1000c544
				# cycles master's objects 0x10..0x1e (+1 in the PNGs) -- a harmless tumbling box.
				if not _iblit_clip(jk, "master_s_objects", 17 + int(_core.tick_count()) % 15, pp, pf):
					_draw_gift_sparkle(c)
			elif _core.projectile_kind(i) == 1:
				# The straight shot (asm FUN_1000fd5c type 1, fired by FUN_100110b4) is drawn with the
				# weapons sheet's ARROW (asm frame 10 heading right / 9 left = f11 / f10, 24x9).
				if not _iblit_clip(jk, "weapons", 10 if going_left else 11, pp, pf):
					draw_circle(c, 7.0, Color(0.82, 0.14, 0.1))
			else:
				# The rolling swirl ball (types 2/3, FUN_10010d30): +0x5a steps 1..8 every frame,
				# forward when fired right, backward when fired left (f02..f09).
				var sp := int(_core.tick_count()) % 8
				var af := (9 - sp) if _core.projectile_fired_left(i) else (2 + sp)
				if not _iblit_clip(jk, "weapons", af, pp, pf):
					draw_circle(c, 7.0, Color(0.82, 0.14, 0.1))
	_draw_ghosts("j")

	# enemies
	for i in range(MAX_ENEMIES):
		if _core.enemy_active(i):
			_draw_enemy(i, Vector2(_core.enemy_x(i), _core.enemy_y(i)),
				int(_core.enemy_type(i)), int(_core.enemy_dir(i)))
	_draw_ghosts("e")
	_draw_death_pops()   # flying death sprites arcing off after a kill (drawn above the nasties)
	_draw_debris()       # shattered-block quarters and popped goodies
	_draw_ghosts("d")

	# players
	_draw_player(1, Color(0.15, 0.25, 0.85))
	_draw_player(2, Color(0.15, 0.6, 0.2))
	_draw_player(3, Color(0.85, 0.2, 0.15))   # remaster's RED co-op player (drawn only when active)
	_draw_ghosts("p")
	if _tp_frames > 0:
		_draw_transport()                     # transporter warp-slide (over the frozen board)
	_post_fx()

	_draw_hud()
	if _alt and _alt_state == "results":
		_draw_alt_results()
	elif _alt and _alt_state == "transition":
		_draw_alt_transition()
	elif _core.game_over():
		_draw_banner("GAME OVER", "Enter: retry     Esc: menu")
	elif _core.challenge_failed():
		_draw_challenge_failed()
	elif _core.level_complete():
		if _mode_compete:
			_draw_win_screen()
		elif _warp_anim < 1.0:
			_draw_board_warp()          # R/G/B tunnel wipe from the cleared board into the tally
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
	if _pres_toast > 0:
		_draw_presentation_toast()

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
func _draw_powerup_overlay(idx: int, pos: Vector2, hidden: bool) -> void:
	if _core.player_fast(idx) <= 0:
		return
	var n: int = _folder_index("spin_ind_sprite_family").size()
	if n <= 0:
		return
	var frame := 2 + (int(_core.tick_count() / 2) % n)
	var tex := _sprite("spin_ind_sprite_family", frame, false)
	if tex != null:
		var s := _texsize(tex)
		_isprite("p%d_shoe" % idx, "spin_ind_sprite_family", frame, false, false,
			Vector2(pos.x + (CELL_PX - s.x) * 0.5, pos.y - s.y * 0.5), false, Rect2(), hidden)


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
		_seen["p%d" % idx] = _draw_serial       # (no ghost of it at the IN pad meanwhile)
		_seen["p%d_shoe" % idx] = _draw_serial
		return                                   # drawn as the warp sprite by _draw_transport() instead
	# flash while invulnerable (post-hit / spawn grace): blink at ~8 Hz
	var hidden := _core.player_invuln(idx) > 0 and (int(_core.tick_count()) / 4) % 2 == 0
	if hidden and not _smooth:
		return
	var pos := Vector2(_core.player_x(idx), _core.player_y(idx))
	var facing := int(_core.player_facing(idx))
	var st := int(_core.player_state(idx))
	var pose := int(_core.player_pose(idx))
	# The sprite frame is the core's own copy of the original's frame field (asm +0x0e), set by
	# every state handler exactly as the original does: the directional stands 0x3d/0x34, the two
	# 24-frame run cycles, the turn / stop / settle frames, the jump tumbles, the head-bonk recoil,
	# the build/fire poses and the death flap. The extracted sheet is offset by one (PNG fNN =
	# frame + 1) and every pose is drawn as authored -- no mirroring.
	var frame := int(_core.player_frame(idx)) + 1
	var flip := false
	var folder := "GP_sprites" if idx == 2 else "BP_sprites"   # P2 = green art; P1/P3 = blue art
	# The original blits the player at (x & ~3, y) -- its frame TOP-LEFT on a 4-px column (the art of
	# the in-between strides and the +0x10 tumble set carries the other 2 px), and the dying player at
	# ((x - 4) & ~3, y) (FUN_10012228). No centring or bottom-aligning: a resting player (y = row top
	# + 1) stands with his soles on the floor, not a pixel into it.
	var dpos := Vector2(float((int(pos.x) - (4 if st == 0x80 else 0)) & ~3), pos.y)
	var tex := _sprite(folder, frame, flip, idx == 3)   # P3 = the blue art recoloured RED (_redden)
	if tex != null:
		_isprite("p%d" % idx, folder, frame, flip, idx == 3, dpos,
			st == 1 and pose == 0, Rect2(), hidden)
		_draw_powerup_overlay(idx, pos, hidden)
		return
	if hidden:
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
	if _mode_compete and _num_players >= 2 and not _alt:
		_draw_hud_compete(iy)
		return
	var x := _ex(4, 14, y)                       # "Score"
	x = _ex_num((_alt_score[_alt_active] + int(_core.player_score(1))) if _alt else int(_core.player_score(1)), 10, x + 4, y)
	x = _ex(2, x + 22, y)                        # "Bonus"
	x = _ex_num(_core.bonus_time(), 5, x + 4, y)
	x = _ex(16, x + 26, iy)                      # face = LIVES (asm FUN_1000fb18 draws +0x46 = lives)
	x = _ex_num(maxi(int(_core.player_lives(1)), 0), 2, x + 3, y)   # clamp <0 -> 0 (asm FUN_1000fb18: an
	                                             # eliminated player's -1 shows as 0, never a "-1")
	# The original HUD (asm FUN_1000fb18) pairs the ROCKET icon (bank frame 0x10 -> f17) with +0x4a
	# (drawn at x=0x184) and the POTION icon (0x11 -> f18) with +0x4c (x=0x1d4). +0x4a is the Magic
	# ARROW's ammo and +0x4c the Magic BALL's; the core's field names `balls`/`arrows` are swapped.
	x = _ex(17, x + 14, iy)                      # rocket icon -> Magic Arrow ammo (+0x4a, core `balls`)
	x = _ex_num(_core.player_balls(1), 2, x + 3, y)
	x = _ex(18, x + 14, iy)                      # potion icon -> Magic Ball ammo (+0x4c, core `arrows`)
	x = _ex_num(_core.player_arrows(1), 2, x + 3, y)
	x = _ex(28, x + 28, y)                       # "Board#"
	_ex_num(_board_number(), 3, x + 2, y)
	if _core.player_has_key(1) >= 1:
		_draw_key(Vector2(610, 2))

## Compete HUD (asm FUN_1000fb18 / FUN_1000efb4 / FUN_1000f500 two-player branch): the same
## icons, but every counter is drawn TWICE -- player 1's values on the top line (asm y=0) and
## player 2's underneath (asm y=0x10) -- with the blue / green "Score" labels.
func _draw_hud_compete(iy: float) -> void:
	var rows := [[1, 1.0, 4], [2, 17.0, 5]]   # [player, y, Score label frame (blue f04 / green f05)]
	for r in rows:
		var idx: int = r[0]
		var y: float = r[1]
		var x := _ex(r[2], 14, y)
		x = _ex_num(int(_core.player_score(idx)), 10, x + 4, y)
		x = _ex(2, x + 22, y)
		x = _ex_num(maxi(int(_core.player_bonus(idx)), 0), 5, x + 4, y)
		x = _ex(16, x + 26, iy) if idx == 1 else x + _ex_w(16) + 26
		x = _ex_num(maxi(int(_core.player_lives(idx)), 0), 2, x + 3, y)
		x = _ex(17, x + 14, iy) if idx == 1 else x + _ex_w(17) + 14
		x = _ex_num(_core.player_balls(idx), 2, x + 3, y)
		x = _ex(18, x + 14, iy) if idx == 1 else x + _ex_w(18) + 14
		x = _ex_num(_core.player_arrows(idx), 2, x + 3, y)
		if idx == 1:
			x = _ex(28, x + 28, 9.0)
			_ex_num(_board_number(), 3, x + 2, 9.0)

## Width of one `extra's` HUD sprite (0 if missing).
func _ex_w(frame: int) -> float:
	var tex := _sprite("extra_s", frame)
	return _texsize(tex).x if tex != null else 0.0

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
	# the 3-column Board#001). The Compete set 1001..1050 is numbered Board 1..50
	# (asm FUN_1002b448 loads BORD N+1000 in Compete). board_301 and board_501 are unnumbered
	# extras (reachable only via level-select) -> they use the play-order index.
	if Session.board_path != "":
		var num := Session.board_path.get_file().get_basename().replace("board_", "").to_int()
		if num >= 401 and num <= 500:
			return num - 400
		if num >= 1001 and num <= 1050:
			return num - 1000
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
				# (Stop 2/10/18/26/34 <-> Go 9/17/25/33/41: five 8-frame flip runs).
				var stop_f: int = [2, 10, 18, 26, 34][g]
				var go_f: int = [9, 17, 25, 33, 41][g]
				var disp_stop: bool = loaded_stop != _sg_toggled[g]
				var new_f := stop_f if disp_stop else go_f
				var a: float = _sg_anim[g]
				if _smooth:                 # the same 0.14/tick run, sampled at the delayed render time
					a = clampf(1.0 - 0.14 * (_rtick - SMOOTH_DELAY - float(_sg_t0[g])), 0.0, 1.0)
				if a > 0.0:
					var old_f := go_f if disp_stop else stop_f
					var fr := float(new_f) + float(old_f - new_f) * a
					var lo := int(floor(fr))
					var tw := _tween_sprite("Stop_Go_sprite_family", lo, lo + 1, fr - float(lo), false, false) if _smooth else null
					if tw != null:
						_dtex(tw, pos + (Vector2(CELL_PX, CELL_PX) - _texsize(tw)) * 0.5)
						if cell & CELL_CRACKED:
							_draw_crack(pos)
						return
					sgf = int(round(fr))
				else:
					sgf = new_f
		if sgf >= 0 and _blit("Stop_Go_sprite_family", sgf, pos):
			if cell & CELL_CRACKED:
				_draw_crack(pos)
			return
		# asm FUN_1002cc10: a CRACKED (0x4000, head-bonked once) block draws the sheet's
		# NEXT frame -- the game's own dedicated cracked sprite (e.g. white 0x07 f8->f9,
		# red 0x0D f14->f15) -- NOT the whole block plus a drawn-on fracture.
		var bframe: int = (t + 2) if (cell & CELL_CRACKED) else (t + 1)
		if not _blit("block_sprites", bframe, pos):
			if t == 0x2B:
				_draw_ball(pos, Color(0.85, 0.13, 0.13))
			elif t == 0x0D or t == 0x13:
				_draw_block(pos, Color(0.85, 0.16, 0.16))
			else:                               # plain solid (incl. low-0 permanent floor/border walls)
				_draw_block(pos, Color(0.87, 0.87, 0.90))
			if cell & CELL_CRACKED:             # procedural fracture only when the real cracked sprite is absent
				_draw_crack(pos)
		return
	if (cell & CELL_DOOR) or t == 0x0A or t == 0x17 or t == 0x18 or t == 0x19:
		if t == 0xFF and _blit("master_s_objects", 17, pos):   # a landed Knight gift box (asm FUN_1000c680: frame 0x10 at +4,+4)
			return
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

## The core's running block grow/shrink animations: cell key (r * GRID_COLS + c) -> packed
## soi_blockanim value (frame in bits 16..23).
func _block_anims() -> Dictionary:
	var d := {}
	for i in range(BLOCKANIM_MAX):
		var a := int(_core.blockanim(i))
		if a >= 0:
			d[((a >> 8) & 0xFF) * GRID_COLS + (a & 0xFF)] = a
	return d

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
	# A persistent SPAWNER (bord 5/6/10/11/12/18/19) is NOT a walking nasty: it stamps its cell
	# (0x100) and emits the moving children from it (asm FUN_10009778 / FUN_100076a8).
	if _core.enemy_is_spawner(slot):
		# The spawner draws its sheet's emblem block (FUN_10004108 frame: ant/teeth 0x32, smiley 0x31,
		# hammer 0x51, hippo/ostrich/piggy 0x21) -- a red block with a silver nasty (refs board_3).
		var sf: int = int({1: 0x32, 2: 0x21, 3: 0x21, 4: 0x21, 6: 0x31, 7: 0x51, 11: 0x32}.get(etype, 0))
		var nf: String = ENEMY_FOLDER.get(etype, "")
		var st: Texture2D = _sprite(nf, sf + 1, false) if (nf != "" and sf > 0) else null
		if st != null:
			_isprite("e%d" % slot, nf, sf + 1, false, false, e)
		else:
			_draw_block(e, Color(0.85, 0.16, 0.16))
		return
	# travel-synced walk cycle: a moving nasty animates; a stationary one
	# (turret / spawner / Spinner) holds its frame instead of walking in place.
	if _new_tick:
		var last: Vector2 = _enemy_lastpos.get(slot, e)
		var moved := (e - last).length()
		if moved > 0.5 and moved < 64.0:      # accumulate real motion; skip spawn/reuse teleports
			_enemy_walk[slot] = float(_enemy_walk.get(slot, 0.0)) + moved
		_enemy_lastpos[slot] = e
	var walk: float = _enemy_walk.get(slot, 0.0)
	if etype == 12:                       # CANNON: its cell is a plain 0x300 wall (asm FUN_100071a0) -> no white fallback
		draw_rect(Rect2(e, Vector2(CELL_PX, CELL_PX)), Color.BLACK)
	if etype == 16:                       # CREEPER segment: its cell is the covered tile | 0x300. A bare
		var ccell := int(_core.grid_cell(int((e.x - ORIGIN_X) / CELL_PX), int((e.y - ORIGIN_Y) / CELL_PX)))
		if (ccell & 0xFF) == 0:           # 0x300 would draw the white fallback -> cover it; a covered
			draw_rect(Rect2(e, Vector2(CELL_PX, CELL_PX)), Color.BLACK)   # tile (mesh) shows through
		var cf := clampi(int(_core.enemy_anim(slot)), 1, 15) + 1        # grow/shrink frame (asm +0x56:
		var ct := _sprite("bigger_mblock", cf, false)                   # 1 = full block, 0xf = shrunk) f02-f16
		if ct != null:
			var cs := _texsize(ct)
			_isprite("e%d" % slot, "bigger_mblock", cf, false, false, Vector2(e.x + (CELL_PX - cs.x) * 0.5, e.y + CELL_PX - cs.y))
		return
	var folder: String = ENEMY_FOLDER.get(etype, "")
	if folder != "":
		var frame: int
		var face_left := (edir == 1)             # core enemy dir: 1 = left, 2 = right
		var flip := face_left
		var planted := false                     # the pose follows ground travel (walk / roll)
		if ENEMY_SPIN.has(etype):                # Spinner trap / flying star-disk: the asm spin
			frame = clampi(int(_core.enemy_anim(slot)), 1, int(ENEMY_SPIN[etype])) + 1   # counter +0x56
			flip = false
		elif etype == 12:                        # Cannon: a barrel that faces its firing direction
			frame = 3 if face_left else 2        # FUN_100071a0: frame 1 (f02) muzzle right, 2 (f03) left
			flip = false
		elif ENEMY_SHOOTER.has(etype):           # Gargoyle/Knight: the core's asm +0x56 phase frame
			frame = maxi(1, int(_core.enemy_anim(slot))) + 1   # (unfold / flap-or-hold / wind-up to the throw)
			flip = false
		elif ENEMY_ROLL.has(etype):              # face-ball: FUN_1000d130 steps +0x56 by -1 per 2 px
			frame = posmod(-(int(e.x) >> 1), 48) + 2  # right / +1 left (1..0x30), i.e. tied to x
			flip = false
			planted = true
		elif etype == 9 and _core.enemy_fire_cd(slot) > 0:   # Robo PUNCH (asm +0x6e): right swing
			var pfcd: int = _core.enemy_fire_cd(slot)        # f18-33, left swing f02-17; the ball
			frame = (2 if face_left else 18) + clampi(16 - pfcd, 0, 15)   # meets the block ~7 steps in
			flip = false
		elif etype == 7 and _core.enemy_fire_cd(slot) > 0:   # Hammer jump-smash (asm +0x6e 0x31-40 left /
			frame = (0x30 if face_left else 0x40) + clampi(int(_core.enemy_fire_cd(slot)), 1, 16) + 1   # 0x41-50 right)
			var ht := _sprite(folder, frame, false)
			if ht != null:
				_isprite("e%d" % slot, folder, frame, false, false, Vector2(e.x, e.y + 2))   # top-left at the lifted asm position (41 px tall art)
				return
		elif _core.enemy_turn(slot) > 0 and _enemy_turn_frame(etype, int(_core.enemy_turn(slot)), face_left, _core.enemy_vertical(slot)) >= 0:
			frame = _enemy_turn_frame(etype, int(_core.enemy_turn(slot)), face_left, _core.enemy_vertical(slot)) + 1
			flip = false
		elif etype == 8 and _core.enemy_vertical(slot):     # vertical Beanie: 0x51-58 down / 0x71-78 up
			frame = (0x71 if face_left else 0x51) + posmod(int(e.y) / 2, 8) + 1
			flip = false
			planted = true
		elif ENEMY_WALK_TBL.has(etype):          # the asm's position-planted walk frame
			var wt: Dictionary = ENEMY_WALK_TBL[etype]
			var tb: Array = wt["l"] if face_left else wt["r"]
			frame = int(tb[posmod(int(e.x) + int(wt["dx"]), tb.size())]) + 1
			flip = false
			planted = true
		elif ENEMY_WALK.has(etype):              # dedicated directional walk cycle. The asm plants the leg
			var cfg: Dictionary = ENEMY_WALK[etype]  # frame to POSITION (frame = table[x mod 32], ~16px/cycle,
			var seg: Array = cfg["l"] if face_left else cfg["r"]   # FUN_1000dd4c). walk/8 was ~6x too slow ->
			frame = int(seg[0]) + (int(walk / 3.0) % int(seg[1]))  # legs glided = "moonwalk"; walk/3 ~= per-cell.
			flip = bool(cfg["flip"]) and face_left   # mirror only symmetric single-view sheets
			planted = true
		else:
			frame = 2 + (int(walk / 8.0) % 4)    # travel-synced walk cycle (fallback: 4 frames + flip)
			planted = true
		var tex := _sprite(folder, frame, flip)
		if tex != null:
			var s := _texsize(tex)
			# Wheelie: a flyer, drawn at its asm x/y (already +2)
			var dp := e if etype == 5 else Vector2(e.x + (CELL_PX - s.x) * 0.5, e.y + CELL_PX - s.y)
			_isprite("e%d" % slot, folder, frame, flip, false, dp, planted)
			if etype == 8 and _core.enemy_bud(slot) > 0:
				_draw_beanie_bud(slot, e, face_left)
			return
	var c := e + Vector2(16, 16)
	var body := _enemy_color(etype)
	draw_circle(c, 11, body.darkened(0.25))
	draw_circle(c, 9, body)
	draw_circle(c + Vector2(-3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(3.5, -3), 2.2, Color.WHITE)
	draw_circle(c + Vector2(-3.5, -3), 1.0, Color.BLACK)
	draw_circle(c + Vector2(3.5, -3), 1.0, Color.BLACK)

## asm frame of a turning nasty (+0x4c 5/6), or -1 for "keep the walk frame". `turn` counts the
## AI steps still to go (16 at the step the turn starts; 15 for the Robo); `face_left` is the
## heading it is turning TO.
func _enemy_turn_frame(etype: int, turn: int, face_left: bool, vertical: bool) -> int:
	match etype:
		1, 7, 10: return (0x10 + turn) if face_left else (0x21 - turn)   # ant / hammer / walker
		2, 3, 4: return (8 + turn) if face_left else (0x19 - turn)     # ostrich / hippo / piggy
		11: return (0x22 - turn) if face_left else (0x11 + turn)       # teeth
		9: return (0x40 - turn) if face_left else (0x31 + turn)        # robo
		8:
			var tb: Array = VBEANIE_TURN if vertical else BEANIE_TURN
			var i := (15 - turn) if face_left else turn
			return int(tb[i]) if i >= 0 and i < tb.size() else -1
	return -1

## A Beanie's bud (asm child 0x6b horizontal FUN_10006d44 / 0x6c vertical FUN_10006f6c): a
## colour beam that grows out of the Beanie for 16 steps, smashes the block, then retracts.
## Drawn at the asm child position off the Beanie's (x+4, y+2).
func _draw_beanie_bud(slot: int, e: Vector2, face_left: bool) -> void:
	var bud := int(_core.enemy_bud(slot))
	var ax := e.x + 4.0
	var ay := e.y + 2.0
	var ext: int
	var af: int
	var pos: Vector2
	if _core.enemy_vertical(slot):
		ext = (bud - 1) if bud <= 17 else (33 - bud)
		af = (0x30 if face_left else 0x10) + ext
		pos = Vector2(ax + (4.0 if face_left else -4.0), ay + (-8.0 if face_left else 18.0))
	else:
		ext = bud if bud <= 16 else (32 - bud)
		af = (0x20 if face_left else 0) + ext
		pos = Vector2(ax + (-24.0 if face_left else 28.0), ay + (2.0 if face_left else 3.0))
	if ext < 1:
		return
	var bt := _sprite("beenie_sprites", af + 1, false)
	if bt != null:
		_isprite("e%d_bud" % slot, "beenie_sprites", af + 1, false, false, pos)

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
	if ENEMY_WALK_TBL.has(etype):   # freeze on the walk frame it last showed (asm keeps the last live frame)
		var wt: Dictionary = ENEMY_WALK_TBL[etype]
		var tb: Array = wt["l"] if face_left else wt["r"]
		frame = int(tb[posmod(x0 + int(wt["dx"]), tb.size())]) + 1
		flip = false
	elif ENEMY_WALK.has(etype):
		var cfg: Dictionary = ENEMY_WALK[etype]
		var seg: Array = cfg["l"] if face_left else cfg["r"]
		frame = int(seg[0])
		flip = bool(cfg["flip"]) and face_left
	_pop_seq += 1
	_death_pops.append({
		"folder": folder, "frame": frame, "flip": flip, "id": _pop_seq,
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
			_isprite("d%d" % int(d["id"]), d["folder"], int(d["frame"]), bool(d["flip"]), false,
				Vector2(d["px"] + (CELL_PX - s.x) * 0.5, d["py"] + CELL_PX - s.y))

## One debris particle the core queued this tick (asm FUN_100278bc): a quarter of a shattered
## block (block_sprites asm frames type+2..type+5) or a collected goody popping away.
func _spawn_debris(fi: int) -> void:
	var goody := int(_core.fx_get(fi, FX_SHEET)) == FX_SHEET_GOODY
	_pop_seq += 1
	_debris.append({
		"folder": "goody_sprites" if goody else "block_sprites",
		"frame": int(_core.fx_get(fi, FX_FRAME)) + 1,      # asm frame -> extracted PNG fNN
		"x0": int(_core.fx_get(fi, FX_X)), "y0": int(_core.fx_get(fi, FX_Y)),
		"vx": int(_core.fx_get(fi, FX_VX)), "vy": int(_core.fx_get(fi, FX_VY)),
		"grav": int(_core.fx_get(fi, FX_GRAV)) != 0, "t": 0, "id": _pop_seq,
		"px": int(_core.fx_get(fi, FX_X)), "py": int(_core.fx_get(fi, FX_Y)),
	})

## Advance the debris one frame exactly as the asm mover FUN_10028060 does, in C integer math
## (truncating division), t = frames since the spawn:
##   x = (x0*10 + t*vx) / 10,  y = (y0*10 + t*vy [+ t*t*5/2 with gravity]) / 10
## A gravity piece never rises above y 0x28; a piece leaves play once outside 4 < x < 0x25e,
## 0x27 < y < 0x1be. Runs in lock-step with the sim (frozen when paused).
func _step_debris() -> void:
	var keep := []
	for d in _debris:
		var t: int = int(d["t"]) + 1
		d["t"] = t
		var x: int = (int(d["x0"]) * 10 + t * int(d["vx"])) / 10
		var ya: int = int(d["y0"]) * 10 + t * int(d["vy"])
		if d["grav"]:
			ya += (t * 5 * t) / 2
		var y: int = ya / 10
		if d["grav"] and y < 0x28:
			y = 0x28
		d["px"] = x
		d["py"] = y
		if x > 4 and x < 0x25e and y > 0x27 and y < 0x1be:
			keep.append(d)
	_debris = keep

## Draw the debris at the asm's own position -- each piece's top-left (a popped goody leaves from
## where its cell drew it).
func _draw_debris() -> void:
	for d in _debris:
		var tex := _sprite(d["folder"], int(d["frame"]))
		if tex == null:
			continue
		var pos := Vector2(float(d["px"]), float(d["py"]))
		if d["folder"] == "goody_sprites":
			pos += (Vector2(CELL_PX, CELL_PX) - _texsize(tex)) * 0.5
		_isprite("dx%d" % int(d["id"]), d["folder"], int(d["frame"]), false, false, pos)

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
