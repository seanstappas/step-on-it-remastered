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
var _hd := false   # REMASTERED presentation: prefer extracted/pict_hd_v2|pict_hd (linear-filtered)
var _bg: TextureRect = null           # the title art (re-textured on an F2 switch)
var _view_label: Label = null         # "F2: ORIGINAL / REMASTERED" status in the bottom strip
var _music_menu: PopupMenu = null
var _speed_menu: PopupMenu = null
var _sfx_menu: PopupMenu = null
var _mvol_menu: PopupMenu = null
var _menushot := -1
var _menushot_dialog := false
var _menushot_file := false
var _mb_file: MenuButton = null
var _starting_board_dialog: Control = null
var _selected_starting_board := 401
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
	Session.init_presentation()   # ORIGINAL, or REMASTERED when launched with --3d / --hd
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot") or a.begins_with("--demo") or a.begins_with("--play=") or a.begins_with("--bug3") or a.begins_with("--script=") or a.begins_with("--board="):
			get_tree().change_scene_to_file.call_deferred("res://scenes/menu.tscn")
			return
	if Session.num_players <= 0:
		Session.num_players = 2
	# REMASTERED prefers the 4x AI-upscaled PICT art (tools/upscale_picts.py) + linear filtering.
	# The window's canvas_items stretch (project.godot) renders the 640x480 canvas at window res
	# so the extra detail shows. (ORIGINAL = the SD art, unchanged.) F2 flips it live.
	_hd = Session.remastered and _hd_available()

	# title art fills the 640x480 screen (2x nearest-neighbour for the retro look)
	var bg := TextureRect.new()
	bg.texture = _pict("401_Title.png")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE   # FULL_RECT sets the size, not the (HD) texture's native size
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR if _hd else CanvasItem.TEXTURE_FILTER_NEAREST
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	_bg = bg

	_build_menu_bar()
	_build_buttons()
	if Audio.has_method("play_menu_music"):
		Audio.play_menu_music()   # title/menu tune (selector 5 = "6lilt"); silent unless music is on

	var all_args: Array = OS.get_cmdline_user_args()
	all_args.append_array(OS.get_cmdline_args())
	for a in all_args:
		if a.begins_with("--menushot="):
			_menushot = int(a.substr(11))
		if a == "--menushot-dialog":
			_menushot_dialog = true
		if a == "--menushot-file":
			_menushot_file = true
	if _menushot < 0:
		_show_splash()   # brief startup splash (skipped for --menushot captures / the harness)
	if _menushot_dialog:
		_show_starting_board_dialog()
	if _menushot_file and _mb_file != null:
		_mb_file.get_popup().popup()
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
	if _menushot_file and _mb_file != null and _menushot == 3:
		_mb_file.get_popup().popup()
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

var _apple_icon: Texture2D = null

func _build_menu_bar() -> void:
	var icon_path := ProjectSettings.globalize_path("res://scenes/apple_logo.png")
	if FileAccess.file_exists(icon_path):
		var img := Image.load_from_file(icon_path)
		if img != null and not img.is_empty():
			_apple_icon = ImageTexture.create_from_image(img)

	# Full-width classic Mac white bar
	var bar_bg := ColorRect.new()
	bar_bg.position = Vector2(0, 0)
	bar_bg.size = Vector2(640, 20)
	bar_bg.color = Color.WHITE
	bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar_bg)

	# 1px solid black baseline along bottom of menu bar
	var bar_line := ColorRect.new()
	bar_line.position = Vector2(0, 19)
	bar_line.size = Vector2(640, 1)
	bar_line.color = Color.BLACK
	bar_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bar_line)

	var bar := HBoxContainer.new()
	bar.position = Vector2(8, 0)
	bar.size = Vector2(624, 19)
	bar.add_theme_constant_override("separation", 2)
	add_child(bar)

	# 1. Apple Menu
	var mb_apple := _create_mac_menu(bar, "", _apple_icon)
	var pop_apple := mb_apple.get_popup()
	pop_apple.add_item("About Step On It!...", 0)
	pop_apple.add_item("Help...", 1)
	pop_apple.add_separator()
	pop_apple.add_item("High Scores...", 2)
	pop_apple.id_pressed.connect(_on_apple_menu)

	# 2. File Menu
	var mb_file := _create_mac_menu(bar, "File")
	_mb_file = mb_file
	var pop_file := mb_file.get_popup()
	pop_file.add_item("New Game", 0)
	pop_file.add_item("Resume Game", 3)
	pop_file.add_item("Open Saved Game...", 4)
	pop_file.add_item("Save Game", 5)
	pop_file.add_item("Save Game As...", 6)
	pop_file.add_separator()
	pop_file.add_item("Load Board Set...", 7)
	pop_file.add_item("Set Starting Board...", 1)
	pop_file.add_separator()
	pop_file.add_item("Quit", 2)

	if not Session.has_save():
		pop_file.set_item_disabled(pop_file.get_item_index(3), true)
		pop_file.set_item_disabled(pop_file.get_item_index(4), true)
	pop_file.set_item_disabled(pop_file.get_item_index(5), true)
	pop_file.set_item_disabled(pop_file.get_item_index(6), true)
	if not _is_dev_mode():
		pop_file.set_item_disabled(pop_file.get_item_index(7), true)

	pop_file.id_pressed.connect(_on_file)

	# 3. Edit Menu (disabled)
	var mb_edit := _create_mac_menu(bar, "Edit")
	mb_edit.disabled = true

	# 4. Options Menu
	var mb_options := _create_mac_menu(bar, "Options")
	var pop_options := mb_options.get_popup()
	pop_options.add_check_item("Allow Background Tasks", 1)
	pop_options.set_item_checked(pop_options.get_item_index(1), true)
	pop_options.add_check_item("Accurate Graphics (slower)", 2)
	pop_options.set_item_checked(pop_options.get_item_index(2), true)
	pop_options.add_item("Set Keys...", 3)
	pop_options.set_item_disabled(pop_options.get_item_index(3), true)
	pop_options.add_separator()

	var pop_speed := PopupMenu.new()
	pop_speed.name = "SpeedMenu"
	_style_mac_popup(pop_speed)
	var speed_names := ["Really Fast", "Fast", "Medium", "Slow"]
	for i in speed_names.size():
		pop_speed.add_radio_check_item(speed_names[i], 10 + i)
	pop_speed.set_item_checked(pop_speed.get_item_index(10 + clampi(Session.speed, 0, 3)), true)
	pop_speed.id_pressed.connect(_on_speed_menu)
	pop_options.add_child(pop_speed)
	pop_options.add_submenu_node_item("Speed", pop_speed)
	_speed_menu = pop_speed

	# 5. High Scores Menu
	var mb_hs := _create_mac_menu(bar, "High Scores")
	var pop_hs := mb_hs.get_popup()
	pop_hs.add_item("Show High Scores", 0)
	pop_hs.add_item("Clear High Scores", 1)
	pop_hs.id_pressed.connect(_on_hs_menu)

	# 6. Sound Menu
	var mb_sound := _create_mac_menu(bar, "Sound")
	var pop_sound := mb_sound.get_popup()

	var pop_music := PopupMenu.new()
	pop_music.name = "MusicMenu"
	_style_mac_popup(pop_music)
	var mus_names := ["Full Music", "Light Music", "No Music"]
	for i in mus_names.size():
		pop_music.add_radio_check_item(mus_names[i], 30 + i)
	var mus_mode := 2
	if Audio.is_music_enabled():
		mus_mode = 1 if (Audio.has_method("is_music_light") and Audio.is_music_light()) else 0
	pop_music.set_item_checked(pop_music.get_item_index(30 + mus_mode), true)
	pop_music.id_pressed.connect(_on_sound_music_menu)
	pop_sound.add_child(pop_music)
	pop_sound.add_submenu_node_item("Music", pop_music)
	_music_menu = pop_music

	var pop_sfx := PopupMenu.new()
	pop_sfx.name = "SfxMenu"
	_style_mac_popup(pop_sfx)
	var vol_names := ["Full", "Medium", "Quiet", "Off"]
	for i in vol_names.size():
		pop_sfx.add_radio_check_item(vol_names[i], 20 + i)
	pop_sfx.set_item_checked(pop_sfx.get_item_index(20), true)
	pop_sfx.id_pressed.connect(_on_sound_sfx_menu)
	pop_sound.add_child(pop_sfx)
	pop_sound.add_submenu_node_item("Effects Volume", pop_sfx)
	_sfx_menu = pop_sfx

	var pop_mvol := PopupMenu.new()
	pop_mvol.name = "MusVolMenu"
	_style_mac_popup(pop_mvol)
	for i in vol_names.size():
		pop_mvol.add_radio_check_item(vol_names[i], 40 + i)
	pop_mvol.set_item_checked(pop_mvol.get_item_index(40), true)
	pop_mvol.id_pressed.connect(_on_sound_mvol_menu)
	pop_sound.add_child(pop_mvol)
	pop_sound.add_submenu_node_item("Music Volume", pop_mvol)
	_mvol_menu = pop_mvol

	# 7. Help Menu
	var mb_help := _create_mac_menu(bar, "Help")
	var pop_help := mb_help.get_popup()
	pop_help.add_item("Help Topics...", 1)
	pop_help.add_item("About Step On It!...", 0)
	pop_help.id_pressed.connect(_on_help)

var _chicago_font: FontFile = null

func _get_chicago_font() -> Font:
	if _chicago_font == null:
		var p := ProjectSettings.globalize_path("res://fonts/Chicago.ttf")
		if FileAccess.file_exists(p):
			_chicago_font = FontFile.new()
			_chicago_font.load_dynamic_font(p)
			_chicago_font.multichannel_signed_distance_field = true
	return _chicago_font if _chicago_font != null else ThemeDB.fallback_font

func _create_mac_menu(parent: Control, title: String, icon: Texture2D = null) -> MenuButton:
	var mb := MenuButton.new()
	if icon != null:
		mb.icon = icon
		mb.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mb.custom_minimum_size = Vector2(24, 19)
	else:
		mb.text = title
	mb.flat = false
	mb.switch_on_hover = true

	var sb_norm := StyleBoxFlat.new()
	sb_norm.bg_color = Color.TRANSPARENT
	sb_norm.content_margin_left = 6
	sb_norm.content_margin_right = 6
	sb_norm.content_margin_top = 0
	sb_norm.content_margin_bottom = 0

	var sb_act := StyleBoxFlat.new()
	sb_act.bg_color = Color(0.33, 0.33, 0.70)   # System 7 menu title blue highlight (#5454b3)
	sb_act.content_margin_left = 6
	sb_act.content_margin_right = 6
	sb_act.content_margin_top = 0
	sb_act.content_margin_bottom = 0

	mb.add_theme_stylebox_override("normal", sb_norm)
	mb.add_theme_stylebox_override("hover", sb_act)
	mb.add_theme_stylebox_override("pressed", sb_act)
	mb.add_theme_stylebox_override("disabled", sb_norm)
	mb.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	mb.add_theme_color_override("font_color", Color.BLACK)
	mb.add_theme_color_override("font_hover_color", Color.WHITE)
	mb.add_theme_color_override("font_pressed_color", Color.WHITE)
	mb.add_theme_color_override("font_focus_color", Color.BLACK)
	mb.add_theme_color_override("font_disabled_color", Color(0.53, 0.53, 0.53))
	mb.add_theme_font_override("font", _get_chicago_font())
	mb.add_theme_font_size_override("font_size", 12)

	var pop := mb.get_popup()
	_style_mac_popup(pop)

	# Keep the menu title highlighted in blue with crisp white text while open,
	# and perfectly align the popup's top-left below the title button
	pop.about_to_popup.connect(func() -> void:
		mb.add_theme_stylebox_override("normal", sb_act)
		mb.add_theme_color_override("font_color", Color.WHITE)
		pop.position = Vector2i(int(mb.global_position.x), 20)
	)
	pop.popup_hide.connect(func() -> void:
		mb.add_theme_stylebox_override("normal", sb_norm)
		mb.add_theme_color_override("font_color", Color.BLACK)
	)

	parent.add_child(mb)
	return mb

func _style_mac_popup(pop: PopupMenu) -> void:
	var p_panel := StyleBoxFlat.new()
	p_panel.bg_color = Color(0.906, 0.906, 0.906)   # System 7 window grey #e7e7e7
	p_panel.border_width_left = 1
	p_panel.border_width_top = 1
	p_panel.border_width_right = 1
	p_panel.border_width_bottom = 1
	p_panel.border_color = Color.BLACK
	p_panel.shadow_color = Color.BLACK
	p_panel.shadow_size = 2
	p_panel.shadow_offset = Vector2(2, 2)
	p_panel.corner_radius_top_left = 0
	p_panel.corner_radius_top_right = 0
	p_panel.corner_radius_bottom_right = 0
	p_panel.corner_radius_bottom_left = 0
	p_panel.content_margin_left = 12
	p_panel.content_margin_right = 14
	p_panel.content_margin_top = 4
	p_panel.content_margin_bottom = 4

	var p_hover := StyleBoxFlat.new()
	p_hover.bg_color = Color(0.33, 0.33, 0.70)   # System 7 blue hover (#5454b3)
	p_hover.corner_radius_top_left = 0
	p_hover.corner_radius_top_right = 0
	p_hover.corner_radius_bottom_right = 0
	p_hover.corner_radius_bottom_left = 0
	p_hover.content_margin_left = 6
	p_hover.content_margin_right = 6

	var p_sep := StyleBoxLine.new()
	p_sep.color = Color(0.70, 0.70, 0.70)
	p_sep.thickness = 1

	pop.add_theme_stylebox_override("panel", p_panel)
	pop.add_theme_stylebox_override("hover", p_hover)
	pop.add_theme_stylebox_override("separator", p_sep)
	pop.add_theme_color_override("font_color", Color.BLACK)
	pop.add_theme_color_override("font_hover_color", Color.WHITE)
	pop.add_theme_color_override("font_disabled_color", Color(0.53, 0.53, 0.53))
	pop.add_theme_color_override("font_separator_color", Color(0.50, 0.50, 0.50))
	pop.add_theme_font_override("font", _get_chicago_font())
	pop.add_theme_font_size_override("font_size", 12)

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
	_view_label = Label.new()
	_view_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	_view_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sel.add_child(_view_label)
	_update_view_label()

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

func _hd_available() -> bool:
	for sub in ["pict_hd_v2", "pict_hd"]:
		if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("res://../extracted/" + sub)):
			return true
	return false

## F2: flip ORIGINAL <-> REMASTERED (Session carries it into the game). The title art swaps
## SD <-> HD here; Session.set_remastered swaps the SFX set + soundtrack (the tune keeps its place).
func _toggle_presentation() -> void:
	Session.set_remastered(not Session.remastered)
	_hd = Session.remastered and _hd_available()
	var filt := CanvasItem.TEXTURE_FILTER_LINEAR if _hd else CanvasItem.TEXTURE_FILTER_NEAREST
	if _bg != null:
		_bg.texture = _pict("401_Title.png")
		_bg.texture_filter = filt
	if _overlay != null and _overlay.visible:
		_overlay.texture = _pict(_overlay_pages[_overlay_idx])
		_overlay.texture_filter = filt
	_update_view_label()

func _update_view_label() -> void:
	if _view_label != null:
		_view_label.text = "     F2:  %s" % ("REMASTERED" if Session.remastered else "ORIGINAL 1996")

func _button(parent: Control, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.pressed.connect(cb)
	parent.add_child(b)

func _on_start() -> void:
	Session.start_campaign()   # New Game: play the tiered campaign from board 1 (board_401)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _is_dev_mode() -> bool:
	var all_args: Array = OS.get_cmdline_user_args()
	all_args.append_array(OS.get_cmdline_args())
	for a in all_args:
		if a == "--dev" or a == "--debug" or a == "--admin":
			return true
	return false

func _on_choose_board() -> void:
	if _is_dev_mode():
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		_show_starting_board_dialog()

func _on_file(id: int) -> void:
	match id:
		0: _on_start()          # New Game
		3, 4: _on_resume()      # Resume Game (from a QuickSave)
		1: _on_choose_board()   # Set Starting Board...
		7:                      # Load Board Set...
			if _is_dev_mode():
				get_tree().change_scene_to_file("res://scenes/menu.tscn")
		2: get_tree().quit()    # Quit

func _show_starting_board_dialog() -> void:
	if _starting_board_dialog != null:
		_starting_board_dialog.queue_free()
		_starting_board_dialog = null

	var dlg := Control.new()
	dlg.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dlg)
	_starting_board_dialog = dlg

	# Dim background backdrop (eats clicks)
	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.25)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(backdrop)

	var dw := 310.0
	var dh := 240.0
	var dx := (640.0 - dw) * 0.5
	var dy := (480.0 - dh) * 0.5

	# Drop shadow (2px black at bottom and right)
	var shadow := ColorRect.new()
	shadow.position = Vector2(dx + 2, dy + 2)
	shadow.size = Vector2(dw, dh)
	shadow.color = Color.BLACK
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(shadow)

	# Dialog body (System 7 light grey #c6c6c6)
	var body := ColorRect.new()
	body.position = Vector2(dx, dy)
	body.size = Vector2(dw, dh)
	body.color = Color(0.78, 0.78, 0.78)
	body.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(body)

	# 1px black outline
	var outline := ReferenceRect.new()
	outline.position = Vector2(dx, dy)
	outline.size = Vector2(dw, dh)
	outline.border_color = Color.BLACK
	outline.border_width = 1.0
	outline.editor_only = false
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(outline)

	# Text prompt matching refs/images/menu_bar_starting_board.png
	var font := _get_chicago_font()
	var prompt := Label.new()
	prompt.text = "Select the board number where you\nwould like to start:"
	prompt.position = Vector2(dx + 18, dy + 16)
	prompt.size = Vector2(dw - 36, 40)
	prompt.add_theme_color_override("font_color", Color.BLACK)
	prompt.add_theme_font_override("font", font)
	prompt.add_theme_font_size_override("font_size", 12)
	dlg.add_child(prompt)

	# Radio options with classic Mac circular styling
	var tex_radio_checked := _make_radio_texture(true)
	var tex_radio_unchecked := _make_radio_texture(false)
	var bgroup := ButtonGroup.new()
	const START_OPTIONS := [
		{"num": 401, "label": "1, Beginner"},
		{"num": 421, "label": "21, Novice"},
		{"num": 441, "label": "41, Intermediate"},
		{"num": 461, "label": "61, Advanced"},
		{"num": 481, "label": "81, Expert"},
	]
	var start_y := dy + 66
	for i in START_OPTIONS.size():
		var opt: Dictionary = START_OPTIONS[i]
		var cb := CheckBox.new()
		cb.text = opt["label"]
		cb.button_group = bgroup
		cb.position = Vector2(dx + 80, start_y + i * 24)
		cb.add_theme_color_override("font_color", Color.BLACK)
		cb.add_theme_color_override("font_hover_color", Color.BLACK)
		cb.add_theme_color_override("font_pressed_color", Color.BLACK)
		cb.add_theme_color_override("font_focus_color", Color.BLACK)
		cb.add_theme_font_override("font", font)
		cb.add_theme_font_size_override("font_size", 12)
		cb.add_theme_icon_override("radio_checked", tex_radio_checked)
		cb.add_theme_icon_override("radio_unchecked", tex_radio_unchecked)
		cb.add_theme_icon_override("checked", tex_radio_checked)
		cb.add_theme_icon_override("unchecked", tex_radio_unchecked)
		if opt["num"] == _selected_starting_board:
			cb.button_pressed = true
		cb.pressed.connect(func() -> void: _selected_starting_board = opt["num"])
		dlg.add_child(cb)

	# Button Style
	var btn_style := StyleBoxFlat.new()
	btn_style.bg_color = Color(0.92, 0.92, 0.92)
	btn_style.border_width_left = 1
	btn_style.border_width_top = 1
	btn_style.border_width_right = 1
	btn_style.border_width_bottom = 1
	btn_style.border_color = Color.BLACK
	btn_style.corner_radius_top_left = 4
	btn_style.corner_radius_top_right = 4
	btn_style.corner_radius_bottom_right = 4
	btn_style.corner_radius_bottom_left = 4

	# Cancel Button
	var btn_cancel := Button.new()
	btn_cancel.text = "Cancel"
	btn_cancel.position = Vector2(dx + 52, dy + 196)
	btn_cancel.size = Vector2(76, 26)
	btn_cancel.add_theme_stylebox_override("normal", btn_style)
	btn_cancel.add_theme_stylebox_override("hover", btn_style)
	btn_cancel.add_theme_stylebox_override("pressed", btn_style)
	btn_cancel.add_theme_color_override("font_color", Color.BLACK)
	btn_cancel.add_theme_color_override("font_hover_color", Color.BLACK)
	btn_cancel.add_theme_color_override("font_pressed_color", Color.BLACK)
	btn_cancel.add_theme_font_override("font", font)
	btn_cancel.add_theme_font_size_override("font_size", 12)
	btn_cancel.pressed.connect(_close_starting_board_dialog)
	dlg.add_child(btn_cancel)

	# OK Button default ring (3px rounded black frame matching classic Mac OS)
	var ring_style := StyleBoxFlat.new()
	ring_style.draw_center = false
	ring_style.border_width_left = 3
	ring_style.border_width_top = 3
	ring_style.border_width_right = 3
	ring_style.border_width_bottom = 3
	ring_style.border_color = Color.BLACK
	ring_style.corner_radius_top_left = 6
	ring_style.corner_radius_top_right = 6
	ring_style.corner_radius_bottom_right = 6
	ring_style.corner_radius_bottom_left = 6

	var ok_ring := Panel.new()
	ok_ring.position = Vector2(dx + 180, dy + 192)
	ok_ring.size = Vector2(84, 34)
	ok_ring.add_theme_stylebox_override("panel", ring_style)
	ok_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(ok_ring)

	var btn_ok := Button.new()
	btn_ok.text = "OK"
	btn_ok.position = Vector2(dx + 184, dy + 196)
	btn_ok.size = Vector2(76, 26)
	btn_ok.add_theme_stylebox_override("normal", btn_style)
	btn_ok.add_theme_stylebox_override("hover", btn_style)
	btn_ok.add_theme_stylebox_override("pressed", btn_style)
	btn_ok.add_theme_color_override("font_color", Color.BLACK)
	btn_ok.add_theme_color_override("font_hover_color", Color.BLACK)
	btn_ok.add_theme_color_override("font_pressed_color", Color.BLACK)
	btn_ok.add_theme_font_override("font", font)
	btn_ok.add_theme_font_size_override("font_size", 12)
	btn_ok.add_theme_color_override("font_hover_color", Color.BLACK)
	btn_ok.add_theme_color_override("font_pressed_color", Color.BLACK)
	btn_ok.pressed.connect(_on_starting_board_ok)
	dlg.add_child(btn_ok)

func _make_radio_texture(checked: bool) -> ImageTexture:
	var img := Image.create(14, 14, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	for y in 14:
		for x in 14:
			var rdx := (x - 6.5)
			var rdy := (y - 6.5)
			var d := sqrt(rdx * rdx + rdy * rdy)
			if d <= 5.8 and d >= 4.4:
				img.set_pixel(x, y, Color.BLACK)
			elif d < 4.4:
				if checked and d <= 2.5:
					img.set_pixel(x, y, Color.BLACK)
				else:
					img.set_pixel(x, y, Color.WHITE)
	return ImageTexture.create_from_image(img)

func _close_starting_board_dialog() -> void:
	if _starting_board_dialog != null:
		_starting_board_dialog.queue_free()
		_starting_board_dialog = null

func _on_starting_board_ok() -> void:
	Session.start_campaign_at(_selected_starting_board)
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_apple_menu(id: int) -> void:
	match id:
		0: _show_picts(["600_About.png"])
		1: _show_picts(["700_Help_1.png", "701_Help_2.png", "702_Help_3.png"])
		2: _show_picts(["402_High_Scores.png"])

func _on_hs_menu(id: int) -> void:
	if id == 0:
		_show_picts(["402_High_Scores.png"])
	elif id == 1:
		Session.high_scores.clear()
		Session._save_scores()
		_show_picts(["402_High_Scores.png"])

func _on_speed_menu(id: int) -> void:
	if id >= 10 and id <= 13:
		Session.speed = id - 10
		if _speed_menu != null:
			for j in 4:
				_speed_menu.set_item_checked(_speed_menu.get_item_index(10 + j), 10 + j == id)

func _on_sound_music_menu(id: int) -> void:
	if id >= 30 and id <= 32:
		_set_music_mode(id - 30)
		if _music_menu != null:
			for j in 3:
				_music_menu.set_item_checked(_music_menu.get_item_index(30 + j), 30 + j == id)

func _on_sound_sfx_menu(id: int) -> void:
	const VOL_DB := [0.0, -10.0, -22.0, -80.0]
	if id >= 20 and id <= 23:
		Audio.set_effects_volume(VOL_DB[id - 20])
		if _sfx_menu != null:
			for j in 4:
				_sfx_menu.set_item_checked(_sfx_menu.get_item_index(20 + j), 20 + j == id)

func _on_sound_mvol_menu(id: int) -> void:
	if id >= 40 and id <= 43:
		if _mvol_menu != null:
			for j in 4:
				_mvol_menu.set_item_checked(_mvol_menu.get_item_index(40 + j), 40 + j == id)

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
	if _starting_board_dialog != null and _starting_board_dialog.visible:
		if e is InputEventKey and e.pressed and not e.echo:
			if e.keycode == KEY_ESCAPE:
				get_viewport().set_input_as_handled()
				_close_starting_board_dialog()
				return
			elif e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER or e.keycode == KEY_SPACE:
				get_viewport().set_input_as_handled()
				_on_starting_board_ok()
				return
			elif e.keycode >= KEY_1 and e.keycode <= KEY_5:
				get_viewport().set_input_as_handled()
				var boards := [401, 421, 441, 461, 481]
				_selected_starting_board = boards[e.keycode - KEY_1]
				_show_starting_board_dialog()
				return
		return

	if e is InputEventKey and e.pressed and not e.echo:
		if e.is_command_or_control_pressed():
			if e.keycode == KEY_N:
				get_viewport().set_input_as_handled()
				_on_start()
				return
			elif e.keycode == KEY_Q:
				get_viewport().set_input_as_handled()
				get_tree().quit()
				return
			elif e.keycode == KEY_O or e.keycode == KEY_R:
				get_viewport().set_input_as_handled()
				_on_resume()
				return
		if e.keycode == KEY_F2:
			get_viewport().set_input_as_handled()
			_toggle_presentation()
			return
		if e.keycode == KEY_F6:
			get_viewport().set_input_as_handled()
			Audio.set_custom_sfx(not Audio.is_custom_sfx())
			return
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
