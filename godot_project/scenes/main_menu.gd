extends Control
## main_menu.gd — the title screen / main menu, faithful to the original (PICT
## 401_Title) with a Mac-style menu bar (File / Sound / Options / Help) and the
## Start buttons. Picks the player count (incl. the remaster's 3rd co-op player)
## and enters the game. Registered as the project's main scene.
##
## The render / movie / play harness (tools/verify.ps1, --shot/--demo/--play) skips
## the title and drops straight into the board picker, which auto-launches a board,
## so the gate still captures a frame. These capture runs also render the window
## OFF-SCREEN so they don't pop up on the desktop (see _apply_window_mode); --hidden
## forces it for any run, --visible keeps the window on-screen.

var _overlay_bg: ColorRect = null
var _overlay: TextureRect = null
var _overlay_hint: Label = null
var _overlay_pages: Array = []
var _overlay_idx := 0
var _hd := false   # --hd: prefer extracted/pict_hd + render the canvas at the window's resolution
var _music_menu: PopupMenu = null
var _menushot := -1
var _splash: Control = null
var _splash_frames := 0
var _hs_entries: Label = null

# --- load an extracted PICT (they live in the repo, outside res://) ---
func _pict(pict_name: String) -> Texture2D:
	for sub in (["pict_hd_v2", "pict_hd", "pict"] if _hd else ["pict"]):
		var path := ProjectSettings.globalize_path("res://../extracted/%s/%s" % [sub, pict_name])
		if FileAccess.file_exists(path):
			var img := Image.load_from_file(path)
			if img != null and not img.is_empty():
				return ImageTexture.create_from_image(img)
	return null

func _ready() -> void:
	_apply_window_mode()
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot") or a.begins_with("--demo") or a.begins_with("--play=") or a.begins_with("--bug3") or a.begins_with("--script="):
			get_tree().change_scene_to_file.call_deferred("res://scenes/menu.tscn")
			return
	if Session.num_players <= 0:
		Session.num_players = 2
	# --hd (or --3d, which is HD + the 3D sprite overlay): prefer the 4x AI-upscaled PICT art
	# (tools/upscale_picts.py) + linear filtering. The window's canvas_items stretch (project.godot)
	# renders the 640x480 canvas at window res so the extra detail shows. (SD default unchanged.)
	var _ua := OS.get_cmdline_user_args()
	if ("--hd" in _ua or "--3d" in _ua) and (DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://../extracted/pict_hd_v2")) or DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://../extracted/pict_hd"))):
		_hd = true

	# title art fills the 640x480 screen (2x nearest-neighbour for the retro look)
	var bg := TextureRect.new()
	bg.texture = _pict("401_Title.png")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE   # FULL_RECT sets the size, not the (HD) texture's native size
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if _hd else CanvasItem.TEXTURE_FILTER_NEAREST
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	_build_menu_bar()
	_build_buttons()
	if Audio.has_method("play_menu_music"):
		Audio.play_menu_music()   # title/menu tune (selector 5 = "6lilt"); silent unless music is on

	for a in OS.get_cmdline_user_args():
		if a.begins_with("--menushot="):
			_menushot = int(a.substr(11))
	if _menushot < 0:
		_show_splash()   # brief startup splash (skipped for --menushot captures / the harness)
	if _menushot >= 0:
		set_process(true)

## Headless-style capture: MINIMIZE the window so agent/CI screenshot + movie runs don't
## pop up a window on the desktop. The window still renders on the GPU (unlike Godot's
## --headless, which uses the dummy driver and captures BLANK), so --shot / --write-movie
## keep working. Auto-applied for the capture flags; force with --hidden, or keep it
## on-screen with --visible. (Launch with `--position 9000,9000` to also skip the brief
## on-screen flash while the window is created, before this runs.)
func _apply_window_mode() -> void:
	var ua := OS.get_cmdline_user_args()
	if "--visible" in ua:
		return
	const HIDE_FLAGS := ["--hidden", "--shot", "--menushot", "--demo", "--play=", "--bug3", "--script="]
	for a in ua:
		for f in HIDE_FLAGS:
			if a.begins_with(f):
				# Render OFF-SCREEN (not minimized): the window still PRESENTS, so the --shot
				# frame_post_draw await + --write-movie keep working. (Godot --headless captures
				# BLANK; a MINIMIZED window never presents -> --shot would hang.)
				get_window().position = Vector2i(9000, 9000)
				return

func _process(_dt: float) -> void:
	if _splash != null:
		_splash_frames -= 1
		if _splash_frames <= 0:
			_dismiss_splash()
	if _menushot < 0:
		return
	_menushot -= 1
	if _menushot <= 0:
		await RenderingServer.frame_post_draw
		var img := get_viewport().get_texture().get_image()
		var dir := ProjectSettings.globalize_path("res://../media/screenshots")
		DirAccess.make_dir_recursive_absolute(dir)
		img.save_png("%s/menu_%d.png" % [dir, Time.get_ticks_msec()])
		get_tree().quit()

## Startup splash (PICT 800): shows over the menu for ~2s, dismissable by any input.
func _show_splash() -> void:
	var t := _pict("800_startup_splash_screen.png")
	if t == null:
		return
	_splash = Control.new()
	_splash.set_anchors_preset(Control.PRESET_FULL_RECT)
	_splash.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_splash)
	var sbg := ColorRect.new()
	sbg.color = Color.BLACK
	sbg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_splash.add_child(sbg)
	var tr := TextureRect.new()
	tr.texture = t
	tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if _hd else CanvasItem.TEXTURE_FILTER_NEAREST
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_splash.add_child(tr)
	_splash_frames = 130
	set_process(true)

func _dismiss_splash() -> void:
	if _splash != null:
		_splash.queue_free()
		_splash = null

func _build_menu_bar() -> void:
	var bar := MenuBar.new()
	bar.set_anchors_preset(Control.PRESET_TOP_WIDE)
	bar.flat = false
	add_child(bar)

	var file := PopupMenu.new()
	file.name = "File"
	file.add_item("New Game", 0)
	file.add_item("Resume Game", 3)
	file.add_item("Set Starting Board...", 1)
	file.add_separator()
	file.add_item("Quit", 2)
	if not Session.has_save():
		file.set_item_disabled(file.get_item_index(3), true)   # nothing to resume
	file.id_pressed.connect(_on_file)
	bar.add_child(file)

	var snd := PopupMenu.new()
	snd.name = "Sound"
	# Music (About doc 8; the original's Sound -> Music: Full / Light / No). OFF by
	# default, as in the original. Full plays the rich arrangement, Light the sparser
	# "_thin" one (FUN_10018414 + DAT_10039154 pick the movie variant). The title screen
	# plays "6lilt" (selector 5); in-game the tune rotates per board (see audio.gd).
	snd.add_separator("Music")
	var mus_names := ["Full", "Light", "Off"]
	for i in mus_names.size():
		snd.add_radio_check_item(mus_names[i], 30 + i)
	var mus_mode := 2
	if Audio.is_music_enabled():
		mus_mode = 1 if (Audio.has_method("is_music_light") and Audio.is_music_light()) else 0
	snd.set_item_checked(snd.get_item_index(30 + mus_mode), true)
	# Effects Volume (About doc 8): controls the SFX.
	snd.add_separator("Effects Volume")
	var vol_names := ["Full", "Medium", "Quiet", "Off"]
	var vol_db := [0.0, -10.0, -22.0, -80.0]
	for i in vol_names.size():
		snd.add_radio_check_item(vol_names[i], 20 + i)
	snd.set_item_checked(snd.get_item_index(20), true)   # default Full
	snd.id_pressed.connect(func(id: int) -> void:
		if id >= 30 and id <= 32:
			_set_music_mode(id - 30)                      # 0 Full, 1 Light, 2 Off
			for j in mus_names.size():
				snd.set_item_checked(snd.get_item_index(30 + j), 30 + j == id)
		elif id >= 20 and id <= 23:
			Audio.set_effects_volume(vol_db[id - 20])
			for j in vol_names.size():
				snd.set_item_checked(snd.get_item_index(20 + j), 20 + j == id))
	bar.add_child(snd)
	_music_menu = snd

	var opt := PopupMenu.new()
	opt.name = "Options"
	opt.add_item("Set Keys... (see Help)", 0)
	opt.add_item("Accurate Graphics Mode", 1)
	opt.set_item_disabled(0, true)   # placeholder: key remap not implemented yet
	opt.set_item_disabled(1, true)
	# Options -> Speed: a LOCAL sim-rate option (About doc 8; plan 10). Medium = canonical.
	opt.add_separator("Speed")
	var speed_names := ["Really Fast", "Fast", "Medium", "Slow"]
	for i in speed_names.size():
		opt.add_radio_check_item(speed_names[i], 10 + i)
	opt.set_item_checked(opt.get_item_index(10 + clampi(Session.speed, 0, 3)), true)
	opt.id_pressed.connect(func(id: int) -> void:
		if id >= 10 and id <= 13:
			Session.speed = id - 10
			for j in speed_names.size():
				opt.set_item_checked(opt.get_item_index(10 + j), 10 + j == id))
	bar.add_child(opt)

	var help := PopupMenu.new()
	help.name = "Help"
	help.add_item("About", 0)
	help.add_item("Help", 1)
	help.add_item("High Scores", 2)
	help.id_pressed.connect(_on_help)
	bar.add_child(help)

func _build_buttons() -> void:
	# a translucent strip along the bottom keeps the controls legible over the art
	var strip := ColorRect.new()
	strip.color = Color(0, 0, 0, 0.6)
	strip.position = Vector2(0, 402)
	strip.size = Vector2(640, 78)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(strip)

	# top row: player-count + game-mode selectors
	var sel := HBoxContainer.new()
	sel.position = Vector2(10, 408)
	sel.add_theme_constant_override("separation", 6)
	add_child(sel)
	_label(sel, "Players:")
	var players := OptionButton.new()
	players.add_item("1", 1)
	players.add_item("2", 2)
	players.add_item("3 (co-op)", 3)
	players.selected = clampi(Session.num_players - 1, 0, 2)
	players.item_selected.connect(func(i: int) -> void:
		Session.num_players = players.get_item_id(i))
	sel.add_child(players)
	_label(sel, "   Mode:")
	var modeb := OptionButton.new()
	modeb.add_item("Cooperate", 0)
	modeb.add_item("Compete", 1)
	modeb.add_item("Alternate", 2)
	modeb.selected = clampi(Session.mode, 0, 2)
	modeb.item_selected.connect(func(i: int) -> void:
		Session.mode = modeb.get_item_id(i))
	sel.add_child(modeb)

	# bottom row: the action buttons
	var row := HBoxContainer.new()
	row.position = Vector2(10, 444)
	row.add_theme_constant_override("separation", 8)
	add_child(row)
	_button(row, "Start Game", _on_start)
	_button(row, "Choose Board", _on_choose_board)
	_button(row, "About", func() -> void: _show_picts(["600_About.png"]))
	_button(row, "Help", func() -> void: _show_picts(["700_Help_1.png", "701_Help_2.png", "702_Help_3.png"]))
	_button(row, "High Scores", func() -> void: _show_picts(["402_High_Scores.png"]))
	_button(row, "Quit", func() -> void: get_tree().quit())

func _label(parent: Control, text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(l)

func _button(parent: Control, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.pressed.connect(cb)
	parent.add_child(b)

func _on_start() -> void:
	Session.start_campaign()   # New Game: play the tiered campaign from board 1 (board_401)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_choose_board() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_file(id: int) -> void:
	match id:
		0: _on_start()          # New Game
		3: _on_resume()         # Resume Game (from a QuickSave)
		1: _on_choose_board()   # Set Starting Board...
		2: get_tree().quit()    # Quit

func _on_resume() -> void:
	if Session.load_game():
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_help(id: int) -> void:
	match id:
		0: _show_picts(["600_About.png"])
		1: _show_picts(["700_Help_1.png", "701_Help_2.png", "702_Help_3.png"])
		2: _show_picts(["402_High_Scores.png"])

func _set_music_mode(mode: int) -> void:
	# Sound -> Music: 0 Full, 1 Light (sparser "_thin" arrangement), 2 Off. The title
	# screen tune is "6lilt" (selector 5); Full/Light choose its arrangement.
	if Audio.has_method("set_music_light"):
		Audio.set_music_light(mode == 1)
	if Audio.has_method("play_menu_music"):
		Audio.play_menu_music()      # ensure the menu tune is selected before enabling
	if Audio.has_method("set_music_enabled"):
		Audio.set_music_enabled(mode != 2)

# --- fullscreen PICT overlay (About / 3-page Help / High Scores) ---
func _show_picts(pages: Array) -> void:
	_overlay_pages = pages
	_overlay_idx = 0
	if _overlay_bg == null:
		_overlay_bg = ColorRect.new()
		_overlay_bg.color = Color.BLACK
		_overlay_bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		_overlay_bg.mouse_filter = Control.MOUSE_FILTER_STOP   # eat clicks to the buttons behind
		add_child(_overlay_bg)
		_overlay = TextureRect.new()
		_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		_overlay.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		_overlay.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_overlay.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if _hd else CanvasItem.TEXTURE_FILTER_NEAREST
		_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(_overlay)
		var hint := Label.new()
		hint.text = "click / any key to continue   \u2022   Esc to close"
		hint.position = Vector2(10, 458)
		add_child(hint)
		_overlay_hint = hint
	_overlay_bg.visible = true
	_overlay.visible = true
	_overlay_hint.visible = true
	_overlay.texture = _pict(_overlay_pages[0])
	_show_hs_entries("402" in String(_overlay_pages[0]))

func _close_overlay() -> void:
	if _overlay_bg != null:
		_overlay_bg.visible = false
		_overlay.visible = false
		_overlay_hint.visible = false
	if _hs_entries != null:
		_hs_entries.visible = false

## Overlay the real high-score table (Session.high_scores) on the High Scores PICT.
func _show_hs_entries(show_it: bool) -> void:
	if _hs_entries == null:
		_hs_entries = Label.new()
		_hs_entries.position = Vector2(0, 118)
		_hs_entries.size = Vector2(640, 344)
		_hs_entries.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_hs_entries.add_theme_font_size_override("font_size", 22)
		_hs_entries.add_theme_color_override("font_color", Color(0.12, 0.06, 0.06))
		add_child(_hs_entries)
	if show_it:
		var s := ""
		for i in Session.high_scores.size():
			var e: Dictionary = Session.high_scores[i]
			s += "%d.    %s    %d\n" % [i + 1, str(e["name"]), int(e["score"])]
		_hs_entries.text = s
	_hs_entries.visible = show_it

func _input(e: InputEvent) -> void:
	if _splash != null:
		if (e is InputEventKey and e.pressed) or (e is InputEventMouseButton and e.pressed):
			get_viewport().set_input_as_handled()
			_dismiss_splash()
		return
	if _overlay == null or not _overlay.visible:
		return
	var advance := false
	var close := false
	if e is InputEventKey and e.pressed:
		if e.keycode == KEY_ESCAPE:
			close = true
		else:
			advance = true
	elif e is InputEventMouseButton and e.pressed:
		advance = true
	if not (advance or close):
		return
	get_viewport().set_input_as_handled()
	if close:
		_close_overlay()
		return
	_overlay_idx += 1
	if _overlay_idx >= _overlay_pages.size():
		_close_overlay()
	else:
		_overlay.texture = _pict(_overlay_pages[_overlay_idx])
