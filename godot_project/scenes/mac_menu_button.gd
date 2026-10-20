class_name MacMenuButton
extends Button

const MacMenuPopup = preload("res://scenes/mac_menu.gd")

## Classic Macintosh System 7 Menu Title Button.
## Coordinates with MacMenuPopup for authentic menu bar interaction:
## click to open, hover to switch menus while open, blue active highlight.

var _popup: MacMenuPopup = null
var _sb_norm: StyleBox = null
var _sb_act: StyleBox = null

static var _active_menu_button: MacMenuButton = null

func _init() -> void:
	flat = false
	focus_mode = Control.FOCUS_NONE
	mouse_default_cursor_shape = Control.CURSOR_ARROW

func setup_styles(sb_norm: StyleBox, sb_act: StyleBox) -> void:
	_sb_norm = sb_norm
	_sb_act = sb_act
	add_theme_stylebox_override("normal", _sb_norm)
	add_theme_stylebox_override("hover", _sb_norm)
	add_theme_stylebox_override("pressed", _sb_act)
	add_theme_stylebox_override("disabled", _sb_norm)
	add_theme_stylebox_override("focus", StyleBoxEmpty.new())

func set_popup(p: MacMenuPopup) -> void:
	_popup = p
	_popup.set_owner_button(self)
	_popup.about_to_popup.connect(_on_popup_shown)
	_popup.popup_hide.connect(_on_popup_hidden)

func get_popup() -> MacMenuPopup:
	if _popup == null:
		var p := MacMenuPopup.new()
		set_popup(p)
	return _popup

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	mouse_entered.connect(_on_mouse_entered)

func _on_button_pressed() -> void:
	if _popup == null:
		return
	if _popup.is_menu_open():
		_popup.hide_menu()
		_active_menu_button = null
	else:
		if _active_menu_button != null and _active_menu_button != self:
			_active_menu_button.get_popup().hide_menu()
		_active_menu_button = self
		_popup.popup()

func _on_mouse_entered() -> void:
	# If any menu is currently active, hovering over another top menu button
	# immediately switches to this menu (classic Mac menu behavior)
	if _active_menu_button != null and _active_menu_button != self:
		_active_menu_button.get_popup().hide_menu()
		_active_menu_button = self
		if _popup != null:
			_popup.popup()

func _on_popup_shown() -> void:
	_active_menu_button = self
	if _sb_act != null:
		add_theme_stylebox_override("normal", _sb_act)
		add_theme_stylebox_override("hover", _sb_act)
	add_theme_color_override("font_color", Color.WHITE)
	add_theme_color_override("font_hover_color", Color.WHITE)
	add_theme_color_override("font_pressed_color", Color.WHITE)

func _on_popup_hidden() -> void:
	if _active_menu_button == self:
		_active_menu_button = null
	if _sb_norm != null:
		add_theme_stylebox_override("normal", _sb_norm)
		add_theme_stylebox_override("hover", _sb_norm)
	add_theme_color_override("font_color", Color.BLACK)
	add_theme_color_override("font_hover_color", Color.BLACK)
	add_theme_color_override("font_pressed_color", Color.BLACK)
