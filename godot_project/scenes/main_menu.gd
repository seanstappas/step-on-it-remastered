extends Control

const MacMenuPopup = preload("res://scenes/mac_menu.gd")
const MacMenuButton = preload("res://scenes/mac_menu_button.gd")
const RollbackNetScript = preload("res://scenes/rollback_net.gd")
const LanDiscoveryScript = preload("res://scenes/lan_discovery.gd")
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
var _music_menu: MacMenuPopup = null
var _speed_menu: MacMenuPopup = null
var _sfx_menu: MacMenuPopup = null
var _mvol_menu: MacMenuPopup = null
var _menushot := -1
var _menushot_dialog := false
var _menushot_file := false
var _mb_file: MacMenuButton = null
var _menu_overlay: Control = null
var _starting_board_dialog: Control = null
var _selected_starting_board := 401
var _splash: Control = null
var _splash_frames := 0
var _hs_entries: Label = null
var _online_dialog: Control = null
var _lobby_net: RollbackNetScript = null
var _lan_disc: LanDiscoveryScript = null
var _set_keys_dialog: Control = null
var _opt_menu: MacMenuPopup = null
var _opt_fullscreen_id := 4
var _connect_active := false
var _connect_elapsed_sec := 0.0
var _connect_cancel_cb: Callable = Callable()
var _connect_timeout_cb: Callable = Callable()
var _lan_refresh_cb: Callable = Callable()
var _local_slots_lbl: Label = null
var _joy_nav_cd := 0.0
var _copy_flash_timers: Dictionary = {}
var _key_capture_slot := -1
var _key_capture_action := ""
var _key_capture_btn: Button = null
var _key_capture_status: Label = null
var _key_capture_snapshot: Array = []
var _set_keys_tab := 0
var _set_keys_tab_cbs: Array = []
var _online_tab := 0
var _online_tab_cbs: Array = []
var _online_primary_btn: Button = null
var _online_connect_btn: Button = null
var _title_buttons: Array = []
var _host_local_code_val := ""
var _host_wan_code_val := ""
var _host_copy_wan_btn: Button = null

# --- load an extracted PICT (they live in the repo, outside res://) ---
func _pict(pict_name: String) -> Texture2D:
	for sub in (["pict_hd_v2", "pict_hd", "pict"] if _hd else ["pict"]):
		var path := Session.ext_path("%s/%s" % [sub, pict_name])
		if FileAccess.file_exists(path):
			var img := Image.load_from_file(path)
			if img != null and not img.is_empty():
				return ImageTexture.create_from_image(img)
	return null

func _ready() -> void:
	get_tree().root.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST

	_apply_window_mode()
	Session.init_presentation()   # ORIGINAL, or REMASTERED when launched with --3d / --hd
	for a in OS.get_cmdline_user_args() + OS.get_cmdline_args():
		if a == "--relay" or a.begins_with("--relay="):
			get_tree().change_scene_to_file.call_deferred("res://scenes/headless_relay.tscn")
			return
		if a == "--editor" or a == "--test-editor":
			get_tree().change_scene_to_file.call_deferred("res://scenes/editor.tscn")
			return
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
	if not Input.joy_connection_changed.is_connected(_on_menu_joy_changed):
		Input.joy_connection_changed.connect(_on_menu_joy_changed)
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

func _process(dt: float) -> void:
	_joy_nav_cd = maxf(0.0, _joy_nav_cd - dt)
	if not _copy_flash_timers.is_empty():
		var expired: Array = []
		for btn in _copy_flash_timers.keys():
			var entry: Dictionary = _copy_flash_timers[btn]
			var rem: float = float(entry.get("secs", 0.0)) - dt
			if rem <= 0.0:
				expired.append(btn)
			else:
				entry["secs"] = rem
		for btn in expired:
			var orig_txt: String = str(_copy_flash_timers[btn].get("orig", "Copy"))
			_copy_flash_timers.erase(btn)
			if is_instance_valid(btn):
				(btn as Button).text = orig_txt

	if _lobby_net != null:
		_lobby_net.poll_network(Time.get_ticks_msec() / 1000.0)
	if _lan_disc != null:
		if _lan_disc.poll(Time.get_ticks_msec() / 1000.0):
			if _lan_refresh_cb.is_valid():
				_lan_refresh_cb.call()
	if _connect_active:
		_connect_elapsed_sec += dt
		if _connect_elapsed_sec >= 8.0:
			_connect_active = false
			if _connect_timeout_cb.is_valid():
				_connect_timeout_cb.call()
	_poll_joy_stick_nav()

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
		var dir := ProjectSettings.globalize_path("res://../media/screenshots") if OS.has_feature("editor") else ProjectSettings.globalize_path("user://screenshots")
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
	if ResourceLoader.exists("res://scenes/apple_logo.png"):
		_apple_icon = load("res://scenes/apple_logo.png") as Texture2D
	if _apple_icon == null and FileAccess.file_exists("res://scenes/apple_logo.png"):
		var raw_png := FileAccess.get_file_as_bytes("res://scenes/apple_logo.png")
		if not raw_png.is_empty():
			var img := Image.new()
			if img.load_png_from_buffer(raw_png) == OK and not img.is_empty():
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

	var menu_overlay := Control.new()
	menu_overlay.name = "MenuOverlay"
	menu_overlay.position = Vector2.ZERO
	menu_overlay.size = Vector2(640, 480)
	menu_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	menu_overlay.z_index = 100
	add_child(menu_overlay)
	_menu_overlay = menu_overlay

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
	pop_file.add_item("Play Custom Map...", 9)
	pop_file.add_item("Load Board Set...", 7)
	pop_file.add_item("Set Starting Board...", 1)
	pop_file.add_item("Map Editor...", 8)
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
	pop_options.add_check_item("Fullscreen (F11)", _opt_fullscreen_id)
	pop_options.set_item_checked(pop_options.get_item_index(_opt_fullscreen_id), Session.fullscreen)
	pop_options.add_separator()
	_opt_menu = pop_options
	pop_options.id_pressed.connect(_on_options_menu)

	var pop_speed := MacMenuPopup.new()
	pop_speed.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop_speed)
	pop_speed.name = "SpeedMenu"
	_style_mac_popup(pop_speed)
	var speed_names := ["Really Fast", "Fast", "Medium", "Slow"]
	for i in speed_names.size():
		pop_speed.add_radio_check_item(speed_names[i], 10 + i)
	pop_speed.set_item_checked(pop_speed.get_item_index(10 + clampi(Session.speed, 0, 3)), true)
	pop_speed.id_pressed.connect(_on_speed_menu)
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

	var pop_music := MacMenuPopup.new()
	pop_music.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop_music)
	pop_music.name = "MusicMenu"
	_style_mac_popup(pop_music)
	var mus_names := ["Full Music", "Light Music", "No Music"]
	for i in mus_names.size():
		pop_music.add_radio_check_item(mus_names[i], 30 + i)
	var mus_mode := 2
	if Audio.is_music_enabled():
		mus_mode = 1 if (Audio.has_method("is_music_light") and Audio.is_music_light()) else 0
	Session.music_mode = mus_mode
	pop_music.set_item_checked(pop_music.get_item_index(30 + mus_mode), true)
	pop_music.id_pressed.connect(_on_sound_music_menu)
	pop_sound.add_submenu_node_item("Music", pop_music)
	_music_menu = pop_music

	var pop_sfx := MacMenuPopup.new()
	pop_sfx.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop_sfx)
	pop_sfx.name = "SfxMenu"
	_style_mac_popup(pop_sfx)
	var vol_names := ["Full", "Medium", "Quiet", "Off"]
	for i in vol_names.size():
		pop_sfx.add_radio_check_item(vol_names[i], 20 + i)
	pop_sfx.set_item_checked(pop_sfx.get_item_index(20 + clampi(Session.sfx_vol_idx, 0, 3)), true)
	pop_sfx.id_pressed.connect(_on_sound_sfx_menu)
	pop_sound.add_submenu_node_item("Effects Volume", pop_sfx)
	_sfx_menu = pop_sfx

	var pop_mvol := MacMenuPopup.new()
	pop_mvol.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop_mvol)
	pop_mvol.name = "MusVolMenu"
	_style_mac_popup(pop_mvol)
	for i in vol_names.size():
		pop_mvol.add_radio_check_item(vol_names[i], 40 + i)
	pop_mvol.set_item_checked(pop_mvol.get_item_index(40 + clampi(Session.music_vol_idx, 0, 3)), true)
	pop_mvol.id_pressed.connect(_on_sound_mvol_menu)
	pop_sound.add_submenu_node_item("Music Volume", pop_mvol)
	_mvol_menu = pop_mvol

	# 7. Help Menu
	var mb_help := _create_mac_menu(bar, "Help")
	var pop_help := mb_help.get_popup()
	pop_help.add_item("Help Topics...", 1)
	pop_help.add_item("About Step On It!...", 0)
	pop_help.id_pressed.connect(_on_help)

var _chicago_font: Font = null

func _get_chicago_font() -> Font:
	if _chicago_font == null:
		if ResourceLoader.exists("res://fonts/Chicago.ttf"):
			_chicago_font = load("res://fonts/Chicago.ttf") as Font
		if _chicago_font == null and OS.has_feature("editor"):
			var p := ProjectSettings.globalize_path("res://fonts/Chicago.ttf")
			if FileAccess.file_exists(p):
				var ff := FontFile.new()
				ff.load_dynamic_font(p)
				ff.multichannel_signed_distance_field = true
				_chicago_font = ff
	return _chicago_font if _chicago_font != null else ThemeDB.fallback_font

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
	sb_norm.content_margin_top = 0
	sb_norm.content_margin_bottom = 0

	var sb_act := StyleBoxFlat.new()
	sb_act.bg_color = Color(0.33, 0.33, 0.70)   # System 7 menu title blue highlight (#5454b3)
	sb_act.content_margin_left = 6
	sb_act.content_margin_right = 6
	sb_act.content_margin_top = 0
	sb_act.content_margin_bottom = 0

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

func _style_mac_popup(_pop: Variant) -> void:
	pass

func _build_buttons() -> void:
	_title_buttons.clear()
	# a translucent strip along the bottom keeps the controls legible over the art
	var strip := ColorRect.new()
	strip.color = Color(0, 0, 0, 0.65)
	strip.position = Vector2(0, 386)
	strip.size = Vector2(640, 94)
	strip.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(strip)

	_local_slots_lbl = Label.new()
	_local_slots_lbl.position = Vector2(10, 388)
	_local_slots_lbl.size = Vector2(620, 18)
	_local_slots_lbl.add_theme_font_size_override("font_size", 11)
	_local_slots_lbl.add_theme_color_override("font_color", Color(0.75, 0.9, 1.0))
	add_child(_local_slots_lbl)

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
		Session.num_players = players.get_item_id(i)
		_update_lobby_device_labels())
	sel.add_child(players)
	_title_buttons.append(players)
	_label(sel, "   Mode:")
	var modeb := OptionButton.new()
	modeb.add_item("Cooperate", 0)
	modeb.add_item("Compete", 1)
	modeb.add_item("Alternate", 2)
	modeb.add_item("Versus", 3)
	modeb.selected = clampi(Session.mode, 0, 3)
	modeb.item_selected.connect(func(i: int) -> void:
		Session.mode = modeb.get_item_id(i))
	sel.add_child(modeb)
	_title_buttons.append(modeb)
	_view_label = Label.new()
	_view_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.35))
	_view_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sel.add_child(_view_label)
	_update_view_label()
	_update_lobby_device_labels()

	# bottom row: the action buttons
	var row := HBoxContainer.new()
	row.position = Vector2(6, 446)
	row.add_theme_constant_override("separation", 4)
	add_child(row)
	_title_buttons.append(_button(row, "Start Game", _on_start))
	_title_buttons.append(_button(row, "Online Multiplayer", _show_online_lobby_dialog))
	_title_buttons.append(_button(row, "Choose Board", _on_choose_board))
	_title_buttons.append(_button(row, "Map Editor", func() -> void: get_tree().change_scene_to_file("res://scenes/editor.tscn")))
	_title_buttons.append(_button(row, "About", func() -> void: _show_picts(["600_About.png"])))
	_title_buttons.append(_button(row, "Help", func() -> void: _show_picts(["700_Help_1.png", "701_Help_2.png", "702_Help_3.png"])))
	_title_buttons.append(_button(row, "High Scores", func() -> void: _show_picts(["402_High_Scores.png"])))
	_title_buttons.append(_button(row, "Quit", func() -> void: get_tree().quit()))

func _label(parent: Control, text: String) -> void:
	var l := Label.new()
	l.text = text
	l.add_theme_color_override("font_color", Color(0.95, 0.95, 1.0))
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(l)

func _hd_available() -> bool:
	for sub in ["pict_hd_v2", "pict_hd"]:
		if DirAccess.dir_exists_absolute(Session.ext_path(sub)):
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
	Session.save_settings()

func _update_view_label() -> void:
	if _view_label != null:
		_view_label.text = "     F2:  %s" % ("REMASTERED" if Session.remastered else "ORIGINAL 1996")

func _button(parent: Control, text: String, cb: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.add_theme_font_size_override("font_size", 13)
	b.pressed.connect(cb)
	parent.add_child(b)
	return b

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
		9: _open_offline_custom_map_dialog() # Play Custom Map...
		8:                      # Map Editor...
			get_tree().change_scene_to_file("res://scenes/editor.tscn")
		7:                      # Load Board Set...
			if _is_dev_mode():
				get_tree().change_scene_to_file("res://scenes/menu.tscn")
		2: get_tree().quit()    # Quit

var _device_status_lbl: Label = null

func _claim_controller_slot(device: int) -> void:
	if Session.num_players == 1 and (_online_dialog == null or not _online_dialog.visible):
		if Session.player_device.size() > 0:
			Session.player_device[0] = device
		else:
			Session.player_device = [device]
	else:
		Session.claim_controller_slot(device)
	_update_lobby_device_labels()

func _on_menu_joy_changed(_dev: int, _connected: bool) -> void:
	_update_lobby_device_labels()

func _update_lobby_device_labels() -> void:
	var n_p := clampi(Session.num_players, 1, 3)
	var parts: Array[String] = []
	for p in range(n_p):
		var dev: int = Session.player_device[p] if p < Session.player_device.size() else -(p + 1)
		var dev_name := "KB1" if dev == -1 else ("KB2" if dev == -2 else ("KB3" if dev == -3 else "Xbox #%d" % (dev + 1)))
		parts.append("P%d: %s" % [p + 1, dev_name])
	var joined := " | ".join(parts)
	if is_instance_valid(_local_slots_lbl):
		_local_slots_lbl.text = "Controllers: " + joined + "   (Press Xbox A to assign)"
	if is_instance_valid(_device_status_lbl):
		_device_status_lbl.text = "Slots: " + joined + " (Press A / Space to claim)"


func _open_offline_custom_map_dialog() -> void:
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
				if fn.ends_with(".bord"):
					maps.append(fn)
				fn = d.get_next()
			d.list_dir_end()
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
			Session.custom_map_path = map_path
			Session.custom_board_bytes = raw
			Session.board_path = map_path
			Session.board_list = PackedStringArray([map_path])
			Session.board_index = 0
			Session.is_online = false

			var info: Dictionary = SoiCore.parse_ext1(raw)
			if info.get("valid", false):
				var flags: int = info.get("flags", 0)
				var dmode: int = info.get("default_mode", 0)
				Session.mode = 3 if dmode == 2 else (1 if dmode == 1 else 0)
				Session.num_players = 3 if info.get("has_p3", false) else 2
				Session.friendly_fire = 1 if info.get("friendly_fire", false) else 0
				Session.victory_rule = info.get("victory_rule", 0)
				Session.start_lives = info.get("starting_lives", 3)
			else:
				Session.victory_rule = -1
				Session.friendly_fire = -1

			get_tree().change_scene_to_file("res://scenes/game.tscn")
	)
	pop.popup_hide.connect(func() -> void:
		pop.queue_free()
	)
	pop.popup_centered(Vector2i(240, 200))


func _open_custom_map_selector(btn: Button, on_changed: Callable = Callable()) -> void:
	var pop := MacMenuPopup.new()
	pop.set_font(_get_chicago_font(), 12)
	_menu_overlay.add_child(pop)
	pop.add_item("Default Campaign", 0)
	var dir := "user://custom_maps"
	if DirAccess.dir_exists_absolute(dir):
		var d := DirAccess.open(dir)
		if d != null:
			d.list_dir_begin()
			var fn := d.get_next()
			var idx := 1
			while fn != "":
				if fn.ends_with(".bord"):
					pop.add_item(fn, idx)
					idx += 1
				fn = d.get_next()
			d.list_dir_end()
	pop.id_pressed.connect(func(id: int) -> void:
		if id == 0:
			Session.custom_map_path = ""
			btn.text = "Map: Default"
		else:
			var item_text := pop.get_item_text(pop.get_item_index(id))
			Session.custom_map_path = "%s/%s" % [dir, item_text]
			Session.board_path = Session.custom_map_path
			btn.text = "Map: %s" % item_text
		if on_changed.is_valid():
			on_changed.call()
	)
	pop.popup_hide.connect(func() -> void:
		pop.queue_free()
	)
	pop.popup_centered(Vector2i(240, 200))


var _upnp_thread: Thread = null
var _upnp_gen: int = 0
var _host_code_lbl: Label = null
var _host_direct_lbl: Label = null

func _cleanup_upnp_thread(wait_join: bool = true) -> void:
	_upnp_gen += 1
	_host_code_lbl = null
	_host_direct_lbl = null
	_host_copy_wan_btn = null
	if _upnp_thread != null:
		if _upnp_thread.is_started():
			if wait_join or not _upnp_thread.is_alive():
				_upnp_thread.wait_to_finish()
				_upnp_thread = null
		else:
			_upnp_thread = null

func _exit_tree() -> void:
	_cleanup_upnp_thread(true)
	_connect_active = false
	_connect_cancel_cb = Callable()
	_connect_timeout_cb = Callable()
	_lan_refresh_cb = Callable()
	if _lan_disc != null:
		_lan_disc.stop()
		_lan_disc = null
	if _lobby_net != null:
		_lobby_net.close()
		_lobby_net = null

static func _is_ascii_digits(s: String) -> bool:
	if s.is_empty():
		return false
	for i in range(s.length()):
		var c := s.unicode_at(i)
		if c < 48 or c > 57:
			return false
	return true

static func is_valid_ipv4(ip: String) -> bool:
	var octets := ip.split(".", true)
	if octets.size() != 4:
		return false
	for o in octets:
		if not _is_ascii_digits(o):
			return false
		var v := int(o)
		if v < 0 or v > 255:
			return false
	return true

static func _is_routable_ipv4(ip: String) -> bool:
	return is_valid_ipv4(ip) and ip != "0.0.0.0" and ip != "255.255.255.255"

static func parse_join_target(raw_txt: String) -> Dictionary:
	var s := raw_txt.strip_edges()
	if s.is_empty():
		return {"ok": false, "ip": "", "port": 0, "error": "Enter a Join Code or IP[:Port]."}
	var up := s.to_upper()
	if up.begins_with("SOI-") or (not s.contains(".") and not s.contains(":")):
		if up == "SOI-00000-00000":
			return {"ok": false, "ip": "", "port": 0, "error": "Invalid Join Code."}
		var ip := RollbackNetScript.join_code_to_ip(s)
		var port := RollbackNetScript.join_code_to_port(s)
		if ip.contains(":"):
			ip = ip.split(":")[0]
		if ip.is_empty() or not _is_routable_ipv4(ip) or port < 1 or port > 65535:
			return {"ok": false, "ip": "", "port": 0, "error": "Invalid Join Code."}
		return {"ok": true, "ip": ip, "port": port, "error": ""}
	if s.contains(":"):
		var parts := s.split(":", true)
		var port_str := parts[1].strip_edges() if parts.size() == 2 else ""
		if parts.size() != 2 or parts[0].strip_edges().is_empty() or not _is_ascii_digits(port_str):
			return {"ok": false, "ip": "", "port": 0, "error": "Invalid IP:Port format."}
		var port := int(port_str)
		if port < 1 or port > 65535:
			return {"ok": false, "ip": "", "port": 0, "error": "Port must be 1..65535."}
		var ip := parts[0].strip_edges()
		if ip.to_lower() == "localhost":
			ip = "127.0.0.1"
		elif not _is_routable_ipv4(ip):
			return {"ok": false, "ip": "", "port": 0, "error": "Invalid IPv4 address."}
		return {"ok": true, "ip": ip, "port": port, "error": ""}
	if s.to_lower() == "localhost":
		return {"ok": true, "ip": "127.0.0.1", "port": 7777, "error": ""}
	if not _is_routable_ipv4(s):
		return {"ok": false, "ip": "", "port": 0, "error": "Invalid IPv4 address."}
	return {"ok": true, "ip": s, "port": 7777, "error": ""}

func _on_upnp_discovered(gen: int, ext_ip: String, local_tag: String, code: String, local_ip: String) -> void:
	if _upnp_thread != null and _upnp_thread.is_started():
		_upnp_thread.wait_to_finish()
		_upnp_thread = null
	if gen != _upnp_gen or not is_instance_valid(_online_dialog):
		return
	if ext_ip != "":
		_update_host_labels(_host_code_lbl, _host_direct_lbl, ext_ip, local_tag, code, local_ip)

func _get_preferred_local_ip() -> String:
	var addrs := IP.get_local_addresses()
	var tailscale_ip := ""
	var rfc1918_ip := ""
	var other_ip := ""

	for a in addrs:
		if a.find(":") != -1:
			continue
		if a == "127.0.0.1" or a.begins_with("169.254."):
			continue
		var parts := a.split(".")
		if parts.size() != 4:
			continue
		var o1 := parts[0].to_int()
		var o2 := parts[1].to_int()
		if o1 == 100 and o2 >= 64 and o2 <= 127:
			if tailscale_ip == "":
				tailscale_ip = a
		elif o1 == 10 or (o1 == 172 and o2 >= 16 and o2 <= 31) or (o1 == 192 and o2 == 168):
			if rfc1918_ip == "":
				rfc1918_ip = a
		elif other_ip == "":
			other_ip = a

	if tailscale_ip != "":
		return tailscale_ip
	if rfc1918_ip != "":
		return rfc1918_ip
	if other_ip != "":
		return other_ip
	return "127.0.0.1"

func _update_host_labels(code_lbl: Label, ip_lbl: Label, ext_ip: String, local_tag: String = "LAN", local_code: String = "", local_ip: String = "") -> void:
	if ext_ip != "":
		var wan_code := RollbackNetScript.ip_to_join_code(ext_ip)
		_host_wan_code_val = wan_code
		if is_instance_valid(_host_copy_wan_btn):
			_host_copy_wan_btn.visible = true
			_host_copy_wan_btn.disabled = false
		if is_instance_valid(code_lbl):
			if local_code != "":
				code_lbl.text = "%s: %s  |  WAN: %s" % [local_tag, local_code, wan_code]
			else:
				code_lbl.text = "WAN Code: %s" % wan_code
	if is_instance_valid(ip_lbl) and ext_ip != "":
		if local_ip != "":
			ip_lbl.text = "%s: %s:7777 | WAN: %s:7777" % [local_tag, local_ip, ext_ip]
		else:
			ip_lbl.text = "External IP: %s:7777" % ext_ip

func _flash_copy_btn(btn: Button, orig_label: String) -> void:
	if not is_instance_valid(btn):
		return
	btn.text = "Copied!"
	_copy_flash_timers[btn] = {"secs": 1.5, "orig": orig_label}

func _close_online_lobby_dialog() -> void:
	_connect_active = false
	_connect_cancel_cb = Callable()
	_connect_timeout_cb = Callable()
	_lan_refresh_cb = Callable()
	_online_tab_cbs.clear()
	_online_primary_btn = null
	_online_connect_btn = null
	_host_local_code_val = ""
	_host_wan_code_val = ""
	_host_copy_wan_btn = null
	_copy_flash_timers.clear()
	_cleanup_upnp_thread(false)
	if _lan_disc != null:
		_lan_disc.stop()
		_lan_disc = null
	if _lobby_net != null:
		_lobby_net.close()
		_lobby_net = null
	if _online_dialog != null:
		_online_dialog.queue_free()
		_online_dialog = null

func _show_online_lobby_dialog() -> void:
	_close_online_lobby_dialog()

	var dlg := Control.new()
	dlg.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dlg)
	_online_dialog = dlg
	set_process(true)
	_lan_disc = LanDiscoveryScript.new()

	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.45)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(backdrop)

	var dw := 480.0
	var dh := 410.0
	var dx := (640.0 - dw) * 0.5
	var dy := (480.0 - dh) * 0.5

	var shadow := ColorRect.new()
	shadow.position = Vector2(dx + 3, dy + 3)
	shadow.size = Vector2(dw, dh)
	shadow.color = Color(0, 0, 0, 0.7)
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(shadow)

	var body := ColorRect.new()
	body.position = Vector2(dx, dy)
	body.size = Vector2(dw, dh)
	body.color = Color(0.82, 0.82, 0.82)
	body.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(body)

	var outline := ReferenceRect.new()
	outline.position = Vector2(dx, dy)
	outline.size = Vector2(dw, dh)
	outline.border_color = Color.BLACK
	outline.border_width = 1.0
	outline.editor_only = false
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(outline)

	var font := _get_chicago_font()

	var title := Label.new()
	title.position = Vector2(dx + 10, dy + 8)
	title.size = Vector2(dw - 20, 22)
	title.text = "Online Multiplayer (Rollback Netcode)"
	title.add_theme_font_override("font", font)
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color.BLACK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg.add_child(title)

	# Mode toggle: Host / Join
	var tab_row := HBoxContainer.new()
	tab_row.position = Vector2(dx + 20, dy + 34)
	tab_row.size = Vector2(dw - 40, 26)
	tab_row.alignment = BoxContainer.ALIGNMENT_CENTER
	dlg.add_child(tab_row)

	var host_tab_btn := Button.new()
	host_tab_btn.text = "Host Match"
	host_tab_btn.add_theme_font_override("font", font)
	host_tab_btn.add_theme_font_size_override("font_size", 11)
	tab_row.add_child(host_tab_btn)

	var join_tab_btn := Button.new()
	join_tab_btn.text = "Join Match"
	join_tab_btn.add_theme_font_override("font", font)
	join_tab_btn.add_theme_font_size_override("font_size", 11)
	tab_row.add_child(join_tab_btn)

	# Host panel
	var host_panel := VBoxContainer.new()
	host_panel.position = Vector2(dx + 18, dy + 64)
	host_panel.size = Vector2(dw - 36, dh - 102)
	host_panel.add_theme_constant_override("separation", 4)
	dlg.add_child(host_panel)

	var h_row1 := HBoxContainer.new()
	h_row1.add_theme_constant_override("separation", 6)
	var host_players := OptionButton.new()
	host_players.add_item("2 Players", 2)
	host_players.add_item("3 Players (Co-op)", 3)
	host_players.selected = 1 if Session.num_players == 3 else 0
	h_row1.add_child(host_players)

	var host_mode := OptionButton.new()
	host_mode.add_item("Cooperate", 0)
	host_mode.add_item("Compete", 1)
	host_mode.add_item("Versus", 3)
	if Session.mode == 1:
		host_mode.selected = 1
	elif Session.mode == 3:
		host_mode.selected = 2
	else:
		host_mode.selected = 0
	h_row1.add_child(host_mode)

	var host_start_board := OptionButton.new()
	host_start_board.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h_row1.add_child(host_start_board)
	host_panel.add_child(h_row1)

	# Row 2: Victory Rule & Friendly Fire
	var h_row2 := HBoxContainer.new()
	h_row2.add_theme_constant_override("separation", 6)
	var host_vrule := OptionButton.new()
	host_vrule.add_item("Rule: Map Default", -1)
	host_vrule.add_item("Rule: Lives", 0)
	host_vrule.add_item("Rule: Score", 1)
	host_vrule.add_item("Rule: Door", 2)
	h_row2.add_child(host_vrule)

	var host_ff := OptionButton.new()
	host_ff.add_item("FF: Default", -1)
	host_ff.add_item("FF: Off", 0)
	host_ff.add_item("FF: On", 1)
	h_row2.add_child(host_ff)
	host_panel.add_child(h_row2)

	# Row 3: P3 Any-Key & Custom Map Selector
	var h_row3 := HBoxContainer.new()
	h_row3.add_theme_constant_override("separation", 8)
	var host_p3_any := CheckBox.new()
	host_p3_any.text = "3P Any-Key"
	host_p3_any.add_theme_color_override("font_color", Color.BLACK)
	host_p3_any.add_theme_color_override("font_hover_color", Color.BLACK)
	host_p3_any.add_theme_color_override("font_pressed_color", Color.BLACK)
	host_p3_any.add_theme_color_override("font_focus_color", Color.BLACK)
	host_p3_any.button_pressed = Session.p3_any_key
	h_row3.add_child(host_p3_any)

	var host_map_btn := Button.new()
	host_map_btn.text = "Map: " + (Session.custom_map_path.get_file() if Session.custom_map_path != "" else "Default")
	h_row3.add_child(host_map_btn)
	host_panel.add_child(h_row3)

	var ctrl_lbl := Label.new()
	ctrl_lbl.text = "Controls: Keyboard (Arrows/WASD) or any Xbox Controller"
	ctrl_lbl.add_theme_color_override("font_color", Color(0.1, 0.25, 0.55))
	ctrl_lbl.add_theme_font_override("font", font)
	ctrl_lbl.add_theme_font_size_override("font_size", 10)
	host_panel.add_child(ctrl_lbl)

	var host_status := Label.new()
	host_status.text = "Port: 7777 (UDP) — Open Lobby & Listen to host"
	host_status.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	host_status.add_theme_font_override("font", font)
	host_status.add_theme_font_size_override("font_size", 10)
	host_panel.add_child(host_status)

	var host_peers_rtl := RichTextLabel.new()
	host_peers_rtl.bbcode_enabled = true
	host_peers_rtl.scroll_active = false
	host_peers_rtl.fit_content = false
	host_peers_rtl.custom_minimum_size = Vector2(0, 34)
	host_peers_rtl.add_theme_font_override("normal_font", font)
	host_peers_rtl.add_theme_font_size_override("normal_font_size", 10)
	host_peers_rtl.text = "[color=#333333]Lobby closed. Click Open Lobby & Listen to accept players.[/color]"
	host_panel.add_child(host_peers_rtl)

	var code_row := HBoxContainer.new()
	code_row.add_theme_constant_override("separation", 6)
	var host_code_lbl := Label.new()
	host_code_lbl.text = "Join Code: Not hosted yet"
	host_code_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	host_code_lbl.add_theme_color_override("font_color", Color(0.1, 0.1, 0.5))
	host_code_lbl.add_theme_font_override("font", font)
	host_code_lbl.add_theme_font_size_override("font_size", 11)
	code_row.add_child(host_code_lbl)

	var copy_code_btn := Button.new()
	copy_code_btn.text = "Copy"
	copy_code_btn.disabled = true
	copy_code_btn.add_theme_font_override("font", font)
	copy_code_btn.add_theme_font_size_override("font_size", 10)
	code_row.add_child(copy_code_btn)

	var copy_wan_btn := Button.new()
	copy_wan_btn.text = "Copy WAN"
	copy_wan_btn.visible = false
	copy_wan_btn.disabled = true
	copy_wan_btn.add_theme_font_override("font", font)
	copy_wan_btn.add_theme_font_size_override("font_size", 10)
	code_row.add_child(copy_wan_btn)
	_host_copy_wan_btn = copy_wan_btn
	host_panel.add_child(code_row)

	var host_direct_lbl := Label.new()
	host_direct_lbl.text = "Direct IP: 127.0.0.1:7777"
	host_direct_lbl.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	host_direct_lbl.add_theme_font_override("font", font)
	host_direct_lbl.add_theme_font_size_override("font_size", 10)
	host_panel.add_child(host_direct_lbl)

	var host_btn_row := HBoxContainer.new()
	host_btn_row.add_theme_constant_override("separation", 8)
	var host_action_btn := Button.new()
	host_action_btn.text = "Open Lobby & Listen"
	host_action_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	host_action_btn.add_theme_font_override("font", font)
	host_action_btn.add_theme_font_size_override("font_size", 11)
	host_btn_row.add_child(host_action_btn)

	var start_match_btn := Button.new()
	start_match_btn.text = "Start Match"
	start_match_btn.disabled = true
	start_match_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	start_match_btn.add_theme_font_override("font", font)
	start_match_btn.add_theme_font_size_override("font_size", 11)
	host_btn_row.add_child(start_match_btn)
	host_panel.add_child(host_btn_row)

	# Join panel
	var join_panel := VBoxContainer.new()
	join_panel.position = Vector2(dx + 18, dy + 64)
	join_panel.size = Vector2(dw - 36, dh - 102)
	join_panel.add_theme_constant_override("separation", 5)
	join_panel.visible = false
	dlg.add_child(join_panel)

	var lan_hdr_row := HBoxContainer.new()
	var lan_hdr_lbl := Label.new()
	lan_hdr_lbl.text = "Open LAN Lobbies:"
	lan_hdr_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lan_hdr_lbl.add_theme_color_override("font_color", Color.BLACK)
	lan_hdr_lbl.add_theme_font_override("font", font)
	lan_hdr_lbl.add_theme_font_size_override("font_size", 11)
	lan_hdr_row.add_child(lan_hdr_lbl)

	var lan_refresh_btn := Button.new()
	lan_refresh_btn.text = "Refresh"
	lan_refresh_btn.add_theme_font_override("font", font)
	lan_refresh_btn.add_theme_font_size_override("font_size", 10)
	lan_hdr_row.add_child(lan_refresh_btn)
	join_panel.add_child(lan_hdr_row)

	var lan_frame := PanelContainer.new()
	lan_frame.custom_minimum_size = Vector2(dw - 36, 114)
	var lan_sb := StyleBoxFlat.new()
	lan_sb.bg_color = Color(0.95, 0.95, 0.95)
	lan_sb.border_width_left = 1
	lan_sb.border_width_top = 1
	lan_sb.border_width_right = 1
	lan_sb.border_width_bottom = 1
	lan_sb.border_color = Color.BLACK
	lan_sb.content_margin_left = 4
	lan_sb.content_margin_right = 4
	lan_sb.content_margin_top = 4
	lan_sb.content_margin_bottom = 4
	lan_frame.add_theme_stylebox_override("panel", lan_sb)
	var lan_scroll := ScrollContainer.new()
	lan_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lan_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var lan_list_vbox := VBoxContainer.new()
	lan_list_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lan_list_vbox.add_theme_constant_override("separation", 3)
	lan_scroll.add_child(lan_list_vbox)
	lan_frame.add_child(lan_scroll)
	join_panel.add_child(lan_frame)

	var j_prompt := Label.new()
	j_prompt.text = "Or Enter Join Code (SOI-XXXX-XXXX) or Direct IP:Port:"
	j_prompt.add_theme_color_override("font_color", Color.BLACK)
	j_prompt.add_theme_font_override("font", font)
	j_prompt.add_theme_font_size_override("font_size", 11)
	join_panel.add_child(j_prompt)

	var join_row := HBoxContainer.new()
	join_row.add_theme_constant_override("separation", 6)
	var join_input := LineEdit.new()
	join_input.text = ""
	join_input.placeholder_text = "SOI-XXXX-XXXX or 192.168.1.50:7777"
	join_input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	join_row.add_child(join_input)

	var paste_btn := Button.new()
	paste_btn.text = "Paste"
	paste_btn.add_theme_font_override("font", font)
	paste_btn.add_theme_font_size_override("font_size", 10)
	join_row.add_child(paste_btn)
	join_panel.add_child(join_row)

	var join_status := Label.new()
	join_status.text = "Ready to connect."
	join_status.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2))
	join_status.add_theme_font_override("font", font)
	join_status.add_theme_font_size_override("font_size", 10)
	join_panel.add_child(join_status)

	var join_btn_row := HBoxContainer.new()
	join_btn_row.add_theme_constant_override("separation", 8)
	var connect_btn := Button.new()
	connect_btn.text = "Connect"
	connect_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	connect_btn.add_theme_font_override("font", font)
	connect_btn.add_theme_font_size_override("font_size", 11)
	join_btn_row.add_child(connect_btn)

	var cancel_connect_btn := Button.new()
	cancel_connect_btn.text = "Cancel Connect"
	cancel_connect_btn.visible = false
	cancel_connect_btn.add_theme_font_override("font", font)
	cancel_connect_btn.add_theme_font_size_override("font_size", 11)
	join_btn_row.add_child(cancel_connect_btn)
	join_panel.add_child(join_btn_row)

	# Bottom close button
	var close_btn := Button.new()
	close_btn.text = "Close"
	close_btn.position = Vector2(dx + (dw - 90) * 0.5, dy + dh - 32)
	close_btn.size = Vector2(90, 24)
	close_btn.add_theme_font_override("font", font)
	close_btn.add_theme_font_size_override("font_size", 11)
	close_btn.pressed.connect(_close_online_lobby_dialog)
	dlg.add_child(close_btn)

	var is_hosting_active := [false]

	var populate_start_boards := func() -> void:
		var prev_id: int = host_start_board.get_selected_id() if host_start_board.item_count > 0 else 0
		host_start_board.clear()
		var g_mode: int = host_mode.get_selected_id()
		var candidates := [1001, 1011, 1021, 1031, 1041] if g_mode == 1 else [401, 421, 441, 461, 481]
		var bnames := (
			{1001: "Board 1 (1001)", 1011: "Board 11 (1011)", 1021: "Board 21 (1021)", 1031: "Board 31 (1031)", 1041: "Board 41 (1041)"}
			if g_mode == 1 else
			{401: "Board 1 (401)", 421: "Board 21 (421)", 441: "Board 41 (441)", 461: "Board 61 (461)", 481: "Board 81 (481)"}
		)
		for bn in candidates:
			if FileAccess.file_exists(Session.ext_path("levels/board_%d.bord" % bn)) or bn == candidates[0]:
				host_start_board.add_item(str(bnames.get(bn, "Board %d" % bn)), bn)
		var found := false
		for idx in host_start_board.item_count:
			if host_start_board.get_item_id(idx) == prev_id:
				host_start_board.selected = idx
				found = true
				break
		if not found and host_start_board.item_count > 0:
			host_start_board.selected = 0
		host_start_board.disabled = (Session.custom_map_path != "")

	var update_beacon_info := func() -> void:
		if _lan_disc == null or not is_hosting_active[0] or _lobby_net == null:
			return
		_lan_disc.update_broadcast({
			"players": _lobby_net.get_connected_player_count(),
			"max_players": host_players.get_selected_id(),
			"mode": host_mode.get_selected_id(),
			"board": int(host_start_board.get_selected_id()) if host_start_board.item_count > 0 else 401,
			"map": Session.custom_map_path.get_file() if Session.custom_map_path != "" else "",
		})

	var update_host_peer_ui := func() -> void:
		if not is_hosting_active[0] or _lobby_net == null or not is_instance_valid(host_peers_rtl):
			return
		var max_p: int = host_players.get_selected_id()
		var connected: int = _lobby_net.get_connected_player_count()
		var slot_map: Dictionary = _lobby_net.peer_instances
		var parts: Array[String] = ["[color=#125c1d]P1 (Host): Connected[/color]"]
		for s in range(1, max_p):
			var has_s := false
			for pid in slot_map.keys():
				if int(slot_map[pid]) == s:
					has_s = true
					break
			if has_s:
				parts.append("[color=#125c1d]P%d: Connected[/color]" % (s + 1))
			else:
				parts.append("[color=#555555]P%d: Waiting...[/color]" % (s + 1))
		host_peers_rtl.text = "   ".join(parts)
		var can_start := (connected >= 2) and (connected >= max_p or slot_map.values().has(1))
		start_match_btn.disabled = not can_start
		if can_start and connected < max_p:
			start_match_btn.text = "Start Match (%dP)" % connected
		else:
			start_match_btn.text = "Start Match"
		update_beacon_info.call()

	populate_start_boards.call()

	host_players.item_selected.connect(func(_i: int) -> void:
		if host_players.get_selected_id() == 3 and host_mode.get_selected_id() == 1:
			host_p3_any.button_pressed = true
		update_beacon_info.call()
	)
	host_mode.item_selected.connect(func(_i: int) -> void:
		populate_start_boards.call()
		if host_players.get_selected_id() == 3 and host_mode.get_selected_id() == 1:
			host_p3_any.button_pressed = true
		update_beacon_info.call()
	)
	host_start_board.item_selected.connect(func(_i: int) -> void:
		update_beacon_info.call()
	)
	host_map_btn.pressed.connect(func() -> void:
		_open_custom_map_selector(host_map_btn, func() -> void:
			populate_start_boards.call()
			update_beacon_info.call()
		)
	)

	copy_code_btn.pressed.connect(func() -> void:
		if _host_local_code_val != "":
			DisplayServer.clipboard_set(_host_local_code_val)
			_flash_copy_btn(copy_code_btn, "Copy")
	)
	copy_wan_btn.pressed.connect(func() -> void:
		if _host_wan_code_val != "":
			DisplayServer.clipboard_set(_host_wan_code_val)
			_flash_copy_btn(copy_wan_btn, "Copy WAN")
	)

	paste_btn.pressed.connect(func() -> void:
		join_input.text = DisplayServer.clipboard_get().strip_edges()
	)

	var begin_connect := func(target_ip: String, target_port: int) -> void:
		if _lobby_net != null:
			_lobby_net.close()
			_lobby_net = null
		_lobby_net = RollbackNetScript.new()
		var err := _lobby_net.start_client(target_ip, target_port)
		if err != OK:
			_lobby_net.close()
			_lobby_net = null
			_connect_active = false
			join_status.text = "Failed to connect to %s:%d (err %d)" % [target_ip, target_port, err]
			return
		_connect_active = true
		_connect_elapsed_sec = 0.0
		join_status.text = "Connecting to %s:%d... (timeout in 8s)" % [target_ip, target_port]
		connect_btn.disabled = true
		cancel_connect_btn.visible = true

		_connect_cancel_cb = func() -> void:
			_connect_active = false
			if _lobby_net != null:
				_lobby_net.close()
				_lobby_net = null
			if is_instance_valid(connect_btn):
				connect_btn.disabled = false
			if is_instance_valid(cancel_connect_btn):
				cancel_connect_btn.visible = false
			if is_instance_valid(join_status):
				join_status.text = "Connection canceled."

		_connect_timeout_cb = func() -> void:
			_connect_active = false
			if _lobby_net != null:
				_lobby_net.close()
				_lobby_net = null
			if is_instance_valid(connect_btn):
				connect_btn.disabled = false
			if is_instance_valid(cancel_connect_btn):
				cancel_connect_btn.visible = false
			if is_instance_valid(join_status):
				join_status.text = "Timed out after 8s. Check firewall, Join Code, or IP."

		_lobby_net.peer_connected.connect(func(_slot: int) -> void:
			_connect_active = false
			if is_instance_valid(cancel_connect_btn):
				cancel_connect_btn.visible = false
			if is_instance_valid(join_status):
				join_status.text = "Connected! Waiting for host to start match..."
		)
		_lobby_net.peer_disconnected.connect(func(_slot: int) -> void:
			_connect_active = false
			if is_instance_valid(cancel_connect_btn):
				cancel_connect_btn.visible = false
			if is_instance_valid(join_status):
				join_status.text = "Disconnected from host."
			if is_instance_valid(connect_btn):
				connect_btn.disabled = false
		)
		_lobby_net.match_started.connect(func(bord_bytes: PackedByteArray, rng_seed: int, speed: int, num_p: int, mode: int, _slot: int) -> void:
			_connect_active = false
			_lan_refresh_cb = Callable()
			_online_tab_cbs.clear()
			if _lan_disc != null:
				_lan_disc.stop()
				_lan_disc = null
			Session.num_players = num_p
			Session.mode = mode
			Session.speed = speed
			if Session.online_start_board > 0:
				Session.start_campaign_at(Session.online_start_board)
			else:
				Session.start_campaign()
			Session.net = _lobby_net
			_lobby_net = null
			Session.is_online = true
			Session.online_bord_bytes = bord_bytes
			Session.online_seed = rng_seed
			dlg.queue_free()
			_online_dialog = null
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		)

	cancel_connect_btn.pressed.connect(func() -> void:
		if _connect_cancel_cb.is_valid():
			_connect_cancel_cb.call()
	)

	var rebuild_lan_list := func() -> void:
		if not is_instance_valid(lan_list_vbox):
			return
		for ch in lan_list_vbox.get_children():
			ch.queue_free()
		var lobbies: Array = _lan_disc.get_lobbies() if _lan_disc != null else []
		if lobbies.is_empty():
			var empty_lbl := Label.new()
			if _lan_disc != null and _lan_disc.listen_error != "":
				empty_lbl.text = _lan_disc.listen_error + " — paste Join Code or IP below."
				empty_lbl.add_theme_color_override("font_color", Color(0.65, 0.25, 0.0))
			else:
				empty_lbl.text = "Searching local network... (Click Host Match on LAN to appear here)"
				empty_lbl.add_theme_color_override("font_color", Color(0.35, 0.35, 0.35))
			empty_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD
			empty_lbl.add_theme_font_override("font", font)
			empty_lbl.add_theme_font_size_override("font_size", 10)
			lan_list_vbox.add_child(empty_lbl)
			return
		for lby in lobbies:
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 6)
			var b_str: String = ("Map: " + str(lby.get("map", ""))) if str(lby.get("map", "")) != "" else ("Board %d" % int(lby.get("board", 401)))
			var lbl := Label.new()
			lbl.text = "%s (%d/%d) — %s — %s (%s)" % [
				LanDiscoveryScript.mode_label(int(lby.get("mode", 0))),
				int(lby.get("players", 1)),
				int(lby.get("max_players", 2)),
				b_str,
				str(lby.get("ip", "")),
				str(lby.get("name", "Host")),
			]
			lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			lbl.add_theme_color_override("font_color", Color.BLACK)
			lbl.add_theme_font_override("font", font)
			lbl.add_theme_font_size_override("font_size", 10)
			row.add_child(lbl)

			var jbtn := Button.new()
			jbtn.text = "Join"
			jbtn.add_theme_font_override("font", font)
			jbtn.add_theme_font_size_override("font_size", 10)
			var tgt_ip := str(lby.get("ip", ""))
			var tgt_port := int(lby.get("port", 7777))
			jbtn.pressed.connect(func() -> void:
				join_input.text = "%s:%d" % [tgt_ip, tgt_port]
				begin_connect.call(tgt_ip, tgt_port)
			)
			row.add_child(jbtn)
			lan_list_vbox.add_child(row)

	_lan_refresh_cb = rebuild_lan_list
	lan_refresh_btn.pressed.connect(func() -> void:
		if _lan_disc != null:
			_lan_disc.refresh_scan()
			_lan_disc.start_listening()
		rebuild_lan_list.call()
	)

	var switch_online_tab := func(tab_idx: int) -> void:
		_online_tab = clampi(tab_idx, 0, 1)
		host_panel.visible = (_online_tab == 0)
		join_panel.visible = (_online_tab == 1)
		_online_primary_btn = start_match_btn if (_online_tab == 0 and not start_match_btn.disabled) else (host_action_btn if _online_tab == 0 else connect_btn)
		if _online_tab == 1:
			if _lan_disc != null:
				_lan_disc.start_listening()
			rebuild_lan_list.call()
		else:
			if _lan_disc != null and not is_hosting_active[0]:
				_lan_disc.stop()

	_online_tab_cbs = [
		func() -> void: switch_online_tab.call(0),
		func() -> void: switch_online_tab.call(1),
	]
	_online_primary_btn = host_action_btn
	_online_connect_btn = connect_btn

	host_tab_btn.pressed.connect(func() -> void:
		switch_online_tab.call(0)
	)
	join_tab_btn.pressed.connect(func() -> void:
		switch_online_tab.call(1)
	)

	host_action_btn.pressed.connect(func() -> void:
		var n_players: int = host_players.get_selected_id()
		if _lobby_net != null:
			_lobby_net.close()
			_lobby_net = null
		_lobby_net = RollbackNetScript.new()
		_lobby_net.num_players = n_players
		var err := _lobby_net.start_host(7777, n_players - 1)
		if err != OK:
			_lobby_net.close()
			_lobby_net = null
			host_status.text = "Failed to bind port 7777 (err %d)" % err
			return
		is_hosting_active[0] = true
		host_action_btn.disabled = true
		host_players.disabled = true
		start_match_btn.disabled = true
		_online_primary_btn = start_match_btn
		host_status.text = "Hosting! Connected: 1 / %d" % n_players
		var local_ip := _get_preferred_local_ip()
		var is_ts := local_ip.begins_with("100.")
		var local_tag := "Tailscale" if is_ts else "LAN"
		var code := RollbackNetScript.ip_to_join_code(local_ip)
		_host_local_code_val = code
		copy_code_btn.disabled = false
		host_code_lbl.text = "%s Code: %s" % [local_tag, code]
		host_direct_lbl.text = "%s IP: %s:7777" % [local_tag, local_ip]

		if _lan_disc != null:
			_lan_disc.start_broadcasting({
				"name": "LAN Host",
				"port": 7777,
				"players": 1,
				"max_players": n_players,
				"mode": host_mode.get_selected_id(),
				"board": int(host_start_board.get_selected_id()) if host_start_board.item_count > 0 else 401,
				"map": Session.custom_map_path.get_file() if Session.custom_map_path != "" else "",
				"build": int(SoiCore.build_id() & 0xFFFFFFFF) if ClassDB.class_has_method("SoiCore", "build_id") else 0,
			})
		update_host_peer_ui.call()

		_cleanup_upnp_thread(true)
		_host_code_lbl = host_code_lbl
		_host_direct_lbl = host_direct_lbl
		_host_copy_wan_btn = copy_wan_btn
		var gen := _upnp_gen
		_upnp_thread = Thread.new()
		_upnp_thread.start(func() -> void:
			var ext_ip := ""
			var upnp := UPNP.new()
			var d_err := upnp.discover(1500, 2, "InternetGatewayDevice")
			if d_err == OK and upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
				upnp.add_port_mapping(7777, 7777, "StepOnIt", "UDP")
				ext_ip = upnp.query_external_address()
			call_deferred("_on_upnp_discovered", gen, ext_ip, local_tag, code, local_ip)
		)

		_lobby_net.peer_connected.connect(func(slot: int) -> void:
			if _lobby_net == null or not is_instance_valid(host_status):
				return
			var connected := _lobby_net.get_connected_player_count()
			host_status.text = "Peer %d connected! Total: %d / %d" % [slot, connected, n_players]
			update_host_peer_ui.call()
		)
		_lobby_net.peer_disconnected.connect(func(slot: int) -> void:
			if _lobby_net == null or not is_instance_valid(host_status):
				return
			var connected := _lobby_net.get_connected_player_count()
			host_status.text = "Peer %d disconnected. Total: %d / %d" % [slot, connected, n_players]
			update_host_peer_ui.call()
		)
	)

	start_match_btn.pressed.connect(func() -> void:
		if _lobby_net == null:
			return
		_cleanup_upnp_thread(false)
		if _lan_disc != null:
			_lan_disc.stop()
			_lan_disc = null
		_online_tab_cbs.clear()
		var connected_n := _lobby_net.get_connected_player_count()
		var n_players := maxi(2, mini(host_players.get_selected_id(), connected_n))
		_lobby_net.num_players = n_players
		var g_mode: int = host_mode.get_selected_id()
		Session.num_players = n_players
		Session.mode = g_mode
		Session.victory_rule = host_vrule.get_selected_id()
		Session.friendly_fire = host_ff.get_selected_id()
		Session.p3_any_key = host_p3_any.button_pressed
		var chosen_map: String = Session.custom_map_path
		var start_board_num := 0
		var bord_bytes: PackedByteArray
		if chosen_map != "" and FileAccess.file_exists(chosen_map):
			Session.start_campaign()
			Session.custom_map_path = chosen_map
			Session.board_path = chosen_map
			bord_bytes = FileAccess.get_file_as_bytes(chosen_map)
		else:
			start_board_num = int(host_start_board.get_selected_id()) if host_start_board.item_count > 0 else (1001 if g_mode == 1 else 401)
			Session.start_campaign_at(start_board_num)
			bord_bytes = FileAccess.get_file_as_bytes(Session.board_path)
		Session.online_start_board = start_board_num
		var seed_val := randi() % 1000000 + 1
		Session.net = _lobby_net
		_lobby_net = null
		Session.is_online = true
		Session.online_bord_bytes = bord_bytes
		Session.online_seed = seed_val
		Session.net.send_match_init(bord_bytes, seed_val, Session.speed, g_mode, Session.victory_rule, Session.friendly_fire, start_board_num)
		dlg.queue_free()
		_online_dialog = null
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	)

	connect_btn.pressed.connect(func() -> void:
		var parsed := parse_join_target(join_input.text)
		if not parsed.get("ok", false):
			join_status.text = str(parsed.get("error", "Invalid target."))
			return
		begin_connect.call(str(parsed["ip"]), int(parsed["port"]))
	)

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

func _sync_fullscreen_menu_check() -> void:
	if is_instance_valid(_opt_menu):
		var idx := _opt_menu.get_item_index(_opt_fullscreen_id)
		if idx >= 0:
			_opt_menu.set_item_checked(idx, Session.fullscreen)

func _on_options_menu(id: int) -> void:
	if id == 1 or id == 2:
		if is_instance_valid(_opt_menu):
			var idx := _opt_menu.get_item_index(id)
			if idx >= 0:
				_opt_menu.set_item_checked(idx, not _opt_menu.is_item_checked(idx))
	elif id == 3:
		_show_set_keys_dialog()
	elif id == _opt_fullscreen_id:
		Session.toggle_fullscreen()
		_sync_fullscreen_menu_check()

func _on_speed_menu(id: int) -> void:
	if id >= 10 and id <= 13:
		Session.speed = id - 10
		if _speed_menu != null:
			for j in 4:
				_speed_menu.set_item_checked(_speed_menu.get_item_index(10 + j), 10 + j == id)
		Session.save_settings()

func _on_sound_music_menu(id: int) -> void:
	if id >= 30 and id <= 32:
		Session.music_mode = id - 30
		_set_music_mode(Session.music_mode)
		if _music_menu != null:
			for j in 3:
				_music_menu.set_item_checked(_music_menu.get_item_index(30 + j), 30 + j == id)
		Session.save_settings()

func _on_sound_sfx_menu(id: int) -> void:
	if id >= 20 and id <= 23:
		Session.sfx_vol_idx = id - 20
		Audio.set_effects_volume(Session.SFX_VOL_DB[Session.sfx_vol_idx])
		if _sfx_menu != null:
			for j in 4:
				_sfx_menu.set_item_checked(_sfx_menu.get_item_index(20 + j), 20 + j == id)
		Session.save_settings()

func _on_sound_mvol_menu(id: int) -> void:
	if id >= 40 and id <= 43:
		Session.music_vol_idx = id - 40
		Audio.set_music_volume(Session.MUSIC_VOL_DB[Session.music_vol_idx])
		if _mvol_menu != null:
			for j in 4:
				_mvol_menu.set_item_checked(_mvol_menu.get_item_index(40 + j), 40 + j == id)
		Session.save_settings()

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
	Session.music_mode = clampi(mode, 0, 2)
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

func _key_label(kc: int) -> String:
	var s := OS.get_keycode_string(kc)
	return s if not s.is_empty() else ("Key %d" % kc)

func _close_set_keys_dialog(save_changes: bool) -> void:
	_key_capture_slot = -1
	_key_capture_action = ""
	_key_capture_btn = null
	_key_capture_status = null
	_set_keys_tab_cbs.clear()
	if save_changes:
		Session.save_settings()
	elif not _key_capture_snapshot.is_empty():
		Session.keybinds = _key_capture_snapshot.duplicate(true)
	_key_capture_snapshot.clear()
	if _set_keys_dialog != null:
		_set_keys_dialog.queue_free()
		_set_keys_dialog = null

func _show_set_keys_dialog() -> void:
	if _set_keys_dialog != null:
		_set_keys_dialog.queue_free()
		_set_keys_dialog = null
	_key_capture_slot = -1
	_key_capture_action = ""
	_key_capture_btn = null
	_key_capture_snapshot = Session.keybinds.duplicate(true)

	var dlg := Control.new()
	dlg.set_anchors_preset(Control.PRESET_FULL_RECT)
	dlg.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dlg)
	_set_keys_dialog = dlg

	var backdrop := ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.45)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(backdrop)

	var dw := 360.0
	var dh := 304.0
	var dx := (640.0 - dw) * 0.5
	var dy := (480.0 - dh) * 0.5

	var shadow := ColorRect.new()
	shadow.position = Vector2(dx + 3, dy + 3)
	shadow.size = Vector2(dw, dh)
	shadow.color = Color(0, 0, 0, 0.7)
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(shadow)

	var body := ColorRect.new()
	body.position = Vector2(dx, dy)
	body.size = Vector2(dw, dh)
	body.color = Color(0.82, 0.82, 0.82)
	body.mouse_filter = Control.MOUSE_FILTER_STOP
	dlg.add_child(body)

	var outline := ReferenceRect.new()
	outline.position = Vector2(dx, dy)
	outline.size = Vector2(dw, dh)
	outline.border_color = Color.BLACK
	outline.border_width = 1.0
	outline.editor_only = false
	outline.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dlg.add_child(outline)

	var font := _get_chicago_font()

	var title := Label.new()
	title.position = Vector2(dx + 10, dy + 8)
	title.size = Vector2(dw - 20, 22)
	title.text = "Set Player Keyboard Controls"
	title.add_theme_font_override("font", font)
	title.add_theme_font_size_override("font_size", 13)
	title.add_theme_color_override("font_color", Color.BLACK)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dlg.add_child(title)

	var tab_row := HBoxContainer.new()
	tab_row.position = Vector2(dx + 20, dy + 34)
	tab_row.size = Vector2(dw - 40, 24)
	tab_row.alignment = BoxContainer.ALIGNMENT_CENTER
	tab_row.add_theme_constant_override("separation", 8)
	dlg.add_child(tab_row)

	var rows_box := VBoxContainer.new()
	rows_box.position = Vector2(dx + 22, dy + 66)
	rows_box.size = Vector2(dw - 44, 174)
	rows_box.add_theme_constant_override("separation", 3)
	dlg.add_child(rows_box)

	var status_lbl := Label.new()
	status_lbl.position = Vector2(dx + 16, dy + 242)
	status_lbl.size = Vector2(dw - 32, 18)
	status_lbl.text = "Click an action button then press a key (Esc to cancel)."
	status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_lbl.add_theme_color_override("font_color", Color(0.15, 0.15, 0.45))
	status_lbl.add_theme_font_override("font", font)
	status_lbl.add_theme_font_size_override("font_size", 10)
	dlg.add_child(status_lbl)
	_key_capture_status = status_lbl

	const ACTIONS := [
		["left", "Move Left"],
		["right", "Move Right"],
		["jump", "Jump / Up"],
		["block_high", "Place High Block"],
		["block_low", "Place Low Block"],
		["arrow", "Shoot Arrow"],
		["ball", "Drop Ball"],
	]

	var tab_btns: Array = []
	var rebuild_rows := func() -> void:
		for ch in rows_box.get_children():
			ch.queue_free()
		for i in tab_btns.size():
			var tb: Button = tab_btns[i]
			tb.disabled = (i == _set_keys_tab)
		for entry in ACTIONS:
			var act_key: String = entry[0]
			var act_lbl: String = entry[1]
			var r := HBoxContainer.new()
			var l := Label.new()
			l.text = act_lbl
			l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			l.add_theme_color_override("font_color", Color.BLACK)
			l.add_theme_font_override("font", font)
			l.add_theme_font_size_override("font_size", 11)
			r.add_child(l)
			var kbtn := Button.new()
			kbtn.custom_minimum_size = Vector2(118, 20)
			kbtn.text = _key_label(Session.get_keybind(_set_keys_tab, act_key))
			kbtn.add_theme_font_override("font", font)
			kbtn.add_theme_font_size_override("font_size", 10)
			var cap_slot := _set_keys_tab
			kbtn.pressed.connect(func() -> void:
				if is_instance_valid(_key_capture_btn) and _key_capture_btn != kbtn:
					_key_capture_btn.text = _key_label(Session.get_keybind(_key_capture_slot, _key_capture_action))
				_key_capture_slot = cap_slot
				_key_capture_action = act_key
				_key_capture_btn = kbtn
				kbtn.text = "Press key..."
				if is_instance_valid(_key_capture_status):
					_key_capture_status.text = "Press key for P%d %s (Esc cancels)..." % [cap_slot + 1, act_lbl]
			)
			r.add_child(kbtn)
			rows_box.add_child(r)

	_set_keys_tab_cbs.clear()
	for s in range(3):
		var tb := Button.new()
		tb.text = "Player %d" % (s + 1)
		tb.add_theme_font_override("font", font)
		tb.add_theme_font_size_override("font_size", 11)
		var cap_s := s
		var switch_cb := func() -> void:
			_key_capture_slot = -1
			_key_capture_action = ""
			_key_capture_btn = null
			_set_keys_tab = cap_s
			rebuild_rows.call()
		tb.pressed.connect(switch_cb)
		_set_keys_tab_cbs.append(switch_cb)
		tab_row.add_child(tb)
		tab_btns.append(tb)

	rebuild_rows.call()

	var btn_def := Button.new()
	btn_def.text = "Defaults"
	btn_def.position = Vector2(dx + 22, dy + dh - 34)
	btn_def.size = Vector2(84, 24)
	btn_def.add_theme_font_override("font", font)
	btn_def.add_theme_font_size_override("font_size", 11)
	btn_def.pressed.connect(func() -> void:
		Session.reset_keybinds()
		_key_capture_slot = -1
		_key_capture_action = ""
		_key_capture_btn = null
		rebuild_rows.call()
		if is_instance_valid(_key_capture_status):
			_key_capture_status.text = "Reset P1-P3 keys to defaults."
	)
	dlg.add_child(btn_def)

	var btn_cancel := Button.new()
	btn_cancel.text = "Cancel"
	btn_cancel.position = Vector2(dx + dw - 178, dy + dh - 34)
	btn_cancel.size = Vector2(74, 24)
	btn_cancel.add_theme_font_override("font", font)
	btn_cancel.add_theme_font_size_override("font_size", 11)
	btn_cancel.pressed.connect(func() -> void: _close_set_keys_dialog(false))
	dlg.add_child(btn_cancel)

	var btn_ok := Button.new()
	btn_ok.text = "OK"
	btn_ok.position = Vector2(dx + dw - 94, dy + dh - 34)
	btn_ok.size = Vector2(72, 24)
	btn_ok.add_theme_font_override("font", font)
	btn_ok.add_theme_font_size_override("font_size", 11)
	btn_ok.pressed.connect(func() -> void: _close_set_keys_dialog(true))
	dlg.add_child(btn_ok)

func _is_overlay_or_splash_open() -> bool:
	return _splash != null or (_overlay != null and _overlay.visible)

func _collect_focusables(root: Node, out: Array) -> void:
	for ch in root.get_children():
		if ch is Control and not (ch as Control).is_visible_in_tree():
			continue
		if ch is BaseButton:
			var b := ch as BaseButton
			if not b.disabled and b.focus_mode != Control.FOCUS_NONE:
				out.append(b)
		elif ch is LineEdit:
			var le := ch as LineEdit
			if le.editable and le.focus_mode != Control.FOCUS_NONE:
				out.append(le)
		_collect_focusables(ch, out)

func _active_nav_controls() -> Array:
	var out: Array = []
	if _set_keys_dialog != null and _set_keys_dialog.visible:
		_collect_focusables(_set_keys_dialog, out)
		return out
	if _online_dialog != null and _online_dialog.visible:
		_collect_focusables(_online_dialog, out)
		return out
	if _starting_board_dialog != null and _starting_board_dialog.visible:
		_collect_focusables(_starting_board_dialog, out)
		return out
	for b in _title_buttons:
		if is_instance_valid(b) and (b as Control).is_visible_in_tree():
			if b is BaseButton and not (b as BaseButton).disabled:
				out.append(b)
	return out

func _move_menu_focus(dir_vec: Vector2) -> void:
	var items := _active_nav_controls()
	if items.is_empty():
		return
	var foc := get_viewport().gui_get_focus_owner()
	if foc == null or not items.has(foc):
		(items[0] as Control).grab_focus()
		return
	var origin: Vector2 = foc.get_global_rect().get_center()
	var perp := Vector2(-dir_vec.y, dir_vec.x)
	var best: Control = null
	var best_score := 1e12
	for c in items:
		if c == foc:
			continue
		var ctrl := c as Control
		var delta := ctrl.get_global_rect().get_center() - origin
		var proj := delta.dot(dir_vec)
		if proj > 4.0:
			var sc := proj + absf(delta.dot(perp)) * 2.2
			if sc < best_score:
				best_score = sc
				best = ctrl
	if best == null:
		var idx := items.find(foc)
		var step := -1 if (dir_vec.x < 0.0 or dir_vec.y < 0.0) else 1
		best = items[(idx + step + items.size()) % items.size()] as Control
	if best != null:
		best.grab_focus()

func _activate_control(ctrl: Control) -> bool:
	if ctrl == null or not is_instance_valid(ctrl) or not ctrl.is_visible_in_tree():
		return false
	if ctrl is OptionButton:
		var ob := ctrl as OptionButton
		if ob.disabled or ob.item_count <= 0:
			return false
		var nxt := (ob.selected + 1) % ob.item_count
		ob.select(nxt)
		ob.item_selected.emit(nxt)
		return true
	if ctrl is CheckBox:
		var cb := ctrl as CheckBox
		if cb.disabled:
			return false
		cb.button_pressed = not cb.button_pressed
		cb.toggled.emit(cb.button_pressed)
		cb.pressed.emit()
		return true
	if ctrl is BaseButton:
		var bb := ctrl as BaseButton
		if bb.disabled:
			return false
		bb.pressed.emit()
		return true
	return false

func _poll_joy_stick_nav() -> void:
	if _joy_nav_cd > 0.0 or _key_capture_slot >= 0 or _is_overlay_or_splash_open():
		return
	for dev in Input.get_connected_joypads():
		var ax := Input.get_joy_axis(dev, JOY_AXIS_LEFT_X)
		var ay := Input.get_joy_axis(dev, JOY_AXIS_LEFT_Y)
		var dir := Vector2.ZERO
		if absf(ax) >= absf(ay):
			if ax < -0.55:
				dir = Vector2.LEFT
			elif ax > 0.55:
				dir = Vector2.RIGHT
		else:
			if ay < -0.55:
				dir = Vector2.UP
			elif ay > 0.55:
				dir = Vector2.DOWN
		if dir != Vector2.ZERO:
			_move_menu_focus(dir)
			_joy_nav_cd = 0.20
			return

func _input(e: InputEvent) -> void:
	if _key_capture_slot >= 0:
		if e is InputEventKey and e.pressed and not e.echo:
			get_viewport().set_input_as_handled()
			if e.keycode == KEY_ESCAPE:
				if is_instance_valid(_key_capture_btn):
					_key_capture_btn.text = _key_label(Session.get_keybind(_key_capture_slot, _key_capture_action))
				_key_capture_slot = -1
				_key_capture_action = ""
				_key_capture_btn = null
				if is_instance_valid(_key_capture_status):
					_key_capture_status.text = "Key capture canceled."
				return
			if e.keycode in [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META, KEY_CAPSLOCK]:
				return
			Session.set_keybind(_key_capture_slot, _key_capture_action, e.keycode)
			if is_instance_valid(_key_capture_btn):
				_key_capture_btn.text = _key_label(e.keycode)
			if is_instance_valid(_key_capture_status):
				_key_capture_status.text = "Bound P%d %s to %s." % [_key_capture_slot + 1, _key_capture_action, _key_label(e.keycode)]
			_key_capture_slot = -1
			_key_capture_action = ""
			_key_capture_btn = null
		return

	if e is InputEventKey and e.pressed and not e.echo:
		if e.keycode == KEY_F11 or ((e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER) and e.alt_pressed):
			get_viewport().set_input_as_handled()
			Session.toggle_fullscreen()
			_sync_fullscreen_menu_check()
			return

	if e is InputEventJoypadButton and e.pressed:
		var joy_ev := e as InputEventJoypadButton
		var jb := joy_ev.button_index
		if jb == JOY_BUTTON_A:
			if (_online_dialog != null and _online_dialog.visible) or Session.num_players >= 1:
				_claim_controller_slot(joy_ev.device)
			if _splash != null:
				get_viewport().set_input_as_handled()
				_dismiss_splash()
				return
			if _overlay != null and _overlay.visible:
				get_viewport().set_input_as_handled()
				_overlay_idx += 1
				if _overlay_idx >= _overlay_pages.size():
					_close_overlay()
				else:
					_overlay.texture = _pict(_overlay_pages[_overlay_idx])
				return
			var foc := get_viewport().gui_get_focus_owner()
			if _set_keys_dialog != null and _set_keys_dialog.visible:
				if foc != null and _set_keys_dialog.is_ancestor_of(foc) and _activate_control(foc):
					get_viewport().set_input_as_handled()
				return
			if _starting_board_dialog != null and _starting_board_dialog.visible:
				if foc != null and _starting_board_dialog.is_ancestor_of(foc) and _activate_control(foc):
					get_viewport().set_input_as_handled()
					return
				get_viewport().set_input_as_handled()
				_on_starting_board_ok()
				return
			if _online_dialog != null and _online_dialog.visible:
				if foc != null and _online_dialog.is_ancestor_of(foc) and _activate_control(foc):
					get_viewport().set_input_as_handled()
				return
			if foc != null and foc is BaseButton and foc.is_visible_in_tree():
				if _activate_control(foc):
					get_viewport().set_input_as_handled()
			return
		elif jb == JOY_BUTTON_B:
			get_viewport().set_input_as_handled()
			if _splash != null:
				_dismiss_splash()
			elif _overlay != null and _overlay.visible:
				_close_overlay()
			elif _set_keys_dialog != null and _set_keys_dialog.visible:
				_close_set_keys_dialog(false)
			elif _starting_board_dialog != null and _starting_board_dialog.visible:
				_close_starting_board_dialog()
			elif _online_dialog != null and _online_dialog.visible:
				if _connect_active and _connect_cancel_cb.is_valid():
					_connect_cancel_cb.call()
				else:
					_close_online_lobby_dialog()
			return
		elif jb == JOY_BUTTON_START:
			get_viewport().set_input_as_handled()
			if _splash != null:
				_dismiss_splash()
			elif _overlay != null and _overlay.visible:
				_close_overlay()
			elif _set_keys_dialog != null and _set_keys_dialog.visible:
				_close_set_keys_dialog(true)
			elif _starting_board_dialog != null and _starting_board_dialog.visible:
				_on_starting_board_ok()
			elif _online_dialog != null and _online_dialog.visible:
				if is_instance_valid(_online_primary_btn) and _online_primary_btn.is_visible_in_tree() and not _online_primary_btn.disabled:
					_online_primary_btn.pressed.emit()
				elif is_instance_valid(_online_connect_btn) and _online_connect_btn.is_visible_in_tree() and not _online_connect_btn.disabled:
					_online_connect_btn.pressed.emit()
			else:
				var foc := get_viewport().gui_get_focus_owner()
				if foc != null and foc is BaseButton and foc.is_visible_in_tree():
					_activate_control(foc)
				else:
					_on_start()
			return
		elif jb == JOY_BUTTON_LEFT_SHOULDER or jb == JOY_BUTTON_RIGHT_SHOULDER:
			var step := -1 if jb == JOY_BUTTON_LEFT_SHOULDER else 1
			if _online_dialog != null and _online_dialog.visible and _online_tab_cbs.size() == 2:
				get_viewport().set_input_as_handled()
				(_online_tab_cbs[(_online_tab + step + 2) % 2] as Callable).call()
				return
			if _set_keys_dialog != null and _set_keys_dialog.visible and _set_keys_tab_cbs.size() == 3:
				get_viewport().set_input_as_handled()
				(_set_keys_tab_cbs[(_set_keys_tab + step + 3) % 3] as Callable).call()
				return
		elif jb == JOY_BUTTON_DPAD_LEFT or jb == JOY_BUTTON_DPAD_RIGHT or jb == JOY_BUTTON_DPAD_UP or jb == JOY_BUTTON_DPAD_DOWN:
			get_viewport().set_input_as_handled()
			if _splash != null:
				_dismiss_splash()
				return
			if _overlay != null and _overlay.visible:
				return
			var dir := Vector2.LEFT
			if jb == JOY_BUTTON_DPAD_RIGHT:
				dir = Vector2.RIGHT
			elif jb == JOY_BUTTON_DPAD_UP:
				dir = Vector2.UP
			elif jb == JOY_BUTTON_DPAD_DOWN:
				dir = Vector2.DOWN
			_move_menu_focus(dir)
			return

	if _set_keys_dialog != null and _set_keys_dialog.visible:
		if e is InputEventKey and e.pressed and not e.echo and e.keycode == KEY_ESCAPE:
			get_viewport().set_input_as_handled()
			_close_set_keys_dialog(false)
		return

	if _online_dialog != null and _online_dialog.visible:
		if e is InputEventKey and e.pressed and not e.echo:
			if e.keycode == KEY_ESCAPE:
				get_viewport().set_input_as_handled()
				if _connect_active and _connect_cancel_cb.is_valid():
					_connect_cancel_cb.call()
				else:
					_close_online_lobby_dialog()
				return
			elif e.keycode == KEY_SPACE:
				var foc := get_viewport().gui_get_focus_owner()
				if not (foc is LineEdit):
					_claim_controller_slot(-1)
					return
		return

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
