class_name MacMenuPopup
extends Control

## Classic Macintosh System 7 Menu Popup.
## Renders directly on the 2D canvas (NOT an embedded Window), ensuring razor-sharp
## vector/MSDF font rendering at any resolution (1080p, 1440p, 4K) without the
## Godot 4.3 embedded-window bilinear scaling blur.

signal id_pressed(id: int)
signal about_to_popup
signal popup_hide

const COLOR_PANEL_BG := Color(0.906, 0.906, 0.906)        # System 7 window grey #e7e7e7
const COLOR_HIGHLIGHT := Color(0.33, 0.33, 0.70)          # System 7 menu blue highlight #5454b3
const COLOR_TEXT := Color(0.0, 0.0, 0.0)                  # Black text
const COLOR_TEXT_HIGHLIGHT := Color(1.0, 1.0, 1.0)        # White text when selected
const COLOR_TEXT_DISABLED := Color(0.53, 0.53, 0.53)      # System 7 disabled grey #878787
const COLOR_SEPARATOR := Color(0.70, 0.70, 0.70)          # Separator line #b3b3b3

class CheckmarkIcon extends Control:
	var checked: bool = false
	var color: Color = Color.BLACK

	func _init() -> void:
		custom_minimum_size = Vector2(14, 14)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func set_state(c: bool, col: Color) -> void:
		checked = c
		color = col
		queue_redraw()

	func _draw() -> void:
		if not checked:
			return
		var pts := PackedVector2Array([Vector2(3, 7), Vector2(6, 11), Vector2(12, 3)])
		draw_polyline(pts, color, 1.6, true)

class SubmenuArrowIcon extends Control:
	var color: Color = Color.BLACK

	func _init() -> void:
		custom_minimum_size = Vector2(10, 14)
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func set_color(col: Color) -> void:
		color = col
		queue_redraw()

	func _draw() -> void:
		var pts := PackedVector2Array([Vector2(2, 4), Vector2(7, 7.5), Vector2(2, 11)])
		draw_colored_polygon(pts, color)

class MenuItem:
	var label: String = ""
	var id: int = -1
	var is_separator: bool = false
	var is_check: bool = false
	var is_radio: bool = false
	var checked: bool = false
	var disabled: bool = false
	var submenu: MacMenuPopup = null
	var row_control: PanelContainer = null
	var check_icon: CheckmarkIcon = null
	var text_label: Label = null
	var sub_arrow: SubmenuArrowIcon = null

var _items: Array[MenuItem] = []
var _font: Font = null
var _font_size: int = 12
var _owner_button: Control = null
var _parent_popup: MacMenuPopup = null
var _active_submenu: MacMenuPopup = null
var _panel_container: PanelContainer = null
var _vbox: VBoxContainer = null
var _backdrop: Control = null
var _hovered_index: int = -1
var _is_open: bool = false

static var _currently_open_root_popup: MacMenuPopup = null

func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 100
	visible = false

func set_owner_button(btn: Control) -> void:
	_owner_button = btn

func set_font(font: Font, font_size: int = 12) -> void:
	_font = font
	_font_size = font_size

func add_item(label: String, id: int = -1) -> void:
	var it := MenuItem.new()
	it.label = label
	it.id = id if id >= 0 else _items.size()
	_items.append(it)

func add_check_item(label: String, id: int = -1) -> void:
	var it := MenuItem.new()
	it.label = label
	it.id = id if id >= 0 else _items.size()
	it.is_check = true
	_items.append(it)

func add_radio_check_item(label: String, id: int = -1) -> void:
	var it := MenuItem.new()
	it.label = label
	it.id = id if id >= 0 else _items.size()
	it.is_radio = true
	_items.append(it)

func add_separator() -> void:
	var it := MenuItem.new()
	it.is_separator = true
	_items.append(it)

func add_submenu_node_item(label: String, submenu: MacMenuPopup, id: int = -1) -> void:
	var it := MenuItem.new()
	it.label = label
	it.id = id if id >= 0 else _items.size()
	it.submenu = submenu
	submenu._parent_popup = self
	_items.append(it)

func set_item_disabled(index: int, disabled: bool) -> void:
	if index >= 0 and index < _items.size():
		_items[index].disabled = disabled
		_refresh_item_visual(index)

func set_item_checked(index: int, checked: bool) -> void:
	if index >= 0 and index < _items.size():
		_items[index].checked = checked
		_refresh_item_visual(index)

func is_item_checked(index: int) -> bool:
	if index >= 0 and index < _items.size():
		return _items[index].checked
	return false

func get_item_index(id: int) -> int:
	for i in _items.size():
		if _items[i].id == id:
			return i
	return -1

func get_item_text(index: int) -> String:
	if index >= 0 and index < _items.size():
		return _items[index].label
	return ""

func get_item_count() -> int:
	return _items.size()

func popup(target_rect: Rect2i = Rect2i()) -> void:
	if _parent_popup == null:
		if _currently_open_root_popup != null and _currently_open_root_popup != self:
			_currently_open_root_popup.hide_menu()
		_currently_open_root_popup = self

	_build_ui()
	about_to_popup.emit()

	# Position the dropdown
	if target_rect.size != Vector2i.ZERO or target_rect.position != Vector2i.ZERO:
		_panel_container.position = Vector2(target_rect.position)
	elif _parent_popup == null and _owner_button != null:
		_panel_container.position = Vector2(int(_owner_button.global_position.x), 20)
	elif _panel_container.position == Vector2.ZERO:
		_panel_container.position = Vector2(20, 20)

	# Ensure panel fits within 640x480 canvas
	var min_s := _panel_container.get_combined_minimum_size()
	if _panel_container.position.x + min_s.x > 638:
		_panel_container.position.x = maxf(2.0, 638.0 - min_s.x)

	_is_open = true
	visible = true

func popup_centered(target_size: Vector2i = Vector2i()) -> void:
	if _parent_popup == null:
		if _currently_open_root_popup != null and _currently_open_root_popup != self:
			_currently_open_root_popup.hide_menu()
		_currently_open_root_popup = self

	_build_ui()
	about_to_popup.emit()

	var s := Vector2(target_size) if target_size != Vector2i.ZERO else _panel_container.get_combined_minimum_size()
	_panel_container.position = (Vector2(640, 480) - s) / 2.0
	_panel_container.position.x = maxf(2.0, _panel_container.position.x)
	_panel_container.position.y = maxf(20.0, _panel_container.position.y)

	_is_open = true
	visible = true

func hide_menu() -> void:
	if not _is_open:
		return
	_is_open = false
	visible = false
	_unhighlight_all()
	if _active_submenu != null:
		_active_submenu.hide_menu()
		_active_submenu = null
	if _currently_open_root_popup == self:
		_currently_open_root_popup = null
	popup_hide.emit()

func is_menu_open() -> bool:
	return _is_open

func _unhandled_input(event: InputEvent) -> void:
	if not _is_open:
		return
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				hide_menu()
				get_viewport().set_input_as_handled()
			KEY_DOWN:
				_navigate_item(1)
				get_viewport().set_input_as_handled()
			KEY_UP:
				_navigate_item(-1)
				get_viewport().set_input_as_handled()
			KEY_ENTER, KEY_KP_ENTER, KEY_SPACE:
				if _hovered_index >= 0:
					_on_row_clicked(_hovered_index)
					get_viewport().set_input_as_handled()
			KEY_RIGHT:
				if _hovered_index >= 0 and _items[_hovered_index].submenu != null:
					var sub := _items[_hovered_index].submenu
					sub._navigate_item(1)
					get_viewport().set_input_as_handled()
			KEY_LEFT:
				if _parent_popup != null:
					hide_menu()
					get_viewport().set_input_as_handled()

func _navigate_item(delta: int) -> void:
	if _items.is_empty():
		return
	var count := _items.size()
	var cur := _hovered_index
	for step in count:
		cur = (cur + delta + count) % count
		var it := _items[cur]
		if not it.disabled and not it.is_separator:
			_on_row_hovered(cur)
			break

func _build_ui() -> void:
	if _panel_container != null:
		_refresh_all_items()
		return

	# Backdrop: invisible click catcher outside the popup
	if _parent_popup == null:
		_backdrop = Control.new()
		_backdrop.position = Vector2.ZERO
		_backdrop.size = Vector2(640, 480)
		_backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
		_backdrop.gui_input.connect(func(event: InputEvent) -> void:
			if event is InputEventMouseButton and event.pressed:
				hide_menu()
		)
		add_child(_backdrop)

	_panel_container = PanelContainer.new()
	_panel_container.mouse_filter = Control.MOUSE_FILTER_PASS

	var p_panel := StyleBoxFlat.new()
	p_panel.bg_color = COLOR_PANEL_BG
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
	p_panel.content_margin_left = 1
	p_panel.content_margin_right = 1
	p_panel.content_margin_top = 2
	p_panel.content_margin_bottom = 3

	_panel_container.add_theme_stylebox_override("panel", p_panel)

	_vbox = VBoxContainer.new()
	_vbox.add_theme_constant_override("separation", 0)
	_panel_container.add_child(_vbox)

	for idx in _items.size():
		var it := _items[idx]
		if it.is_separator:
			var sep_box := MarginContainer.new()
			sep_box.add_theme_constant_override("margin_top", 3)
			sep_box.add_theme_constant_override("margin_bottom", 3)
			sep_box.add_theme_constant_override("margin_left", 2)
			sep_box.add_theme_constant_override("margin_right", 2)
			var sep := ColorRect.new()
			sep.custom_minimum_size = Vector2(0, 1)
			sep.color = COLOR_SEPARATOR
			sep_box.add_child(sep)
			_vbox.add_child(sep_box)
		else:
			var row := PanelContainer.new()
			it.row_control = row
			row.mouse_filter = Control.MOUSE_FILTER_STOP

			var sb_empty := StyleBoxEmpty.new()
			sb_empty.content_margin_left = 4
			sb_empty.content_margin_right = 14
			sb_empty.content_margin_top = 1
			sb_empty.content_margin_bottom = 1
			row.add_theme_stylebox_override("panel", sb_empty)

			var hbox := HBoxContainer.new()
			hbox.add_theme_constant_override("separation", 4)
			row.add_child(hbox)

			# Checkmark column
			var chk := CheckmarkIcon.new()
			chk.set_state(it.checked, COLOR_TEXT)
			hbox.add_child(chk)
			it.check_icon = chk

			# Item text
			var lbl := Label.new()
			if _font != null:
				lbl.add_theme_font_override("font", _font)
			lbl.add_theme_font_size_override("font_size", _font_size)
			lbl.text = it.label
			lbl.add_theme_color_override("font_color", COLOR_TEXT_DISABLED if it.disabled else COLOR_TEXT)
			hbox.add_child(lbl)
			it.text_label = lbl

			# Spacer
			var sp := Control.new()
			sp.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hbox.add_child(sp)

			# Submenu arrow
			if it.submenu != null:
				var arr := SubmenuArrowIcon.new()
				arr.set_color(COLOR_TEXT_DISABLED if it.disabled else COLOR_TEXT)
				hbox.add_child(arr)
				it.sub_arrow = arr

			# Row mouse interaction
			var cur_idx := idx
			row.mouse_entered.connect(func() -> void: _on_row_hovered(cur_idx))
			row.mouse_exited.connect(func() -> void: _on_row_unhovered(cur_idx))
			row.gui_input.connect(func(ev: InputEvent) -> void:
				if ev is InputEventMouseButton and ev.pressed and ev.button_index == MOUSE_BUTTON_LEFT:
					_on_row_clicked(cur_idx)
			)

			_vbox.add_child(row)

	add_child(_panel_container)

func _on_row_hovered(index: int) -> void:
	if index < 0 or index >= _items.size():
		return
	var it := _items[index]
	if it.disabled or it.is_separator:
		return

	if _hovered_index != -1 and _hovered_index != index:
		_highlight_row(_hovered_index, false)

	_hovered_index = index
	_highlight_row(index, true)

	# Handle submenu
	if it.submenu != null:
		if _active_submenu != null and _active_submenu != it.submenu:
			_active_submenu.hide_menu()
		_active_submenu = it.submenu
		var sub_x: int = int(_panel_container.position.x + _panel_container.size.x - 2)
		var sub_y: int = int(it.row_control.global_position.y - 2)
		_active_submenu.popup(Rect2i(sub_x, sub_y, 0, 0))
	elif _active_submenu != null:
		_active_submenu.hide_menu()
		_active_submenu = null

func _on_row_unhovered(index: int) -> void:
	if index == _hovered_index:
		var it := _items[index]
		if it.submenu == null:
			_highlight_row(index, false)
			_hovered_index = -1

func _unhighlight_all() -> void:
	for i in _items.size():
		_highlight_row(i, false)
	_hovered_index = -1

func _highlight_row(index: int, highlight: bool) -> void:
	if index < 0 or index >= _items.size():
		return
	var it := _items[index]
	if it.row_control == null or it.disabled:
		return

	if highlight:
		var sb_hi := StyleBoxFlat.new()
		sb_hi.bg_color = COLOR_HIGHLIGHT
		sb_hi.corner_radius_top_left = 0
		sb_hi.corner_radius_top_right = 0
		sb_hi.corner_radius_bottom_right = 0
		sb_hi.corner_radius_bottom_left = 0
		sb_hi.content_margin_left = 4
		sb_hi.content_margin_right = 14
		sb_hi.content_margin_top = 1
		sb_hi.content_margin_bottom = 1
		it.row_control.add_theme_stylebox_override("panel", sb_hi)
		it.text_label.add_theme_color_override("font_color", COLOR_TEXT_HIGHLIGHT)
		if it.check_icon != null:
			it.check_icon.set_state(it.checked, COLOR_TEXT_HIGHLIGHT)
		if it.sub_arrow != null:
			it.sub_arrow.set_color(COLOR_TEXT_HIGHLIGHT)
	else:
		var sb_empty := StyleBoxEmpty.new()
		sb_empty.content_margin_left = 4
		sb_empty.content_margin_right = 14
		sb_empty.content_margin_top = 1
		sb_empty.content_margin_bottom = 1
		it.row_control.add_theme_stylebox_override("panel", sb_empty)
		it.text_label.add_theme_color_override("font_color", COLOR_TEXT)
		if it.check_icon != null:
			it.check_icon.set_state(it.checked, COLOR_TEXT)
		if it.sub_arrow != null:
			it.sub_arrow.set_color(COLOR_TEXT)

func _on_row_clicked(index: int) -> void:
	if index < 0 or index >= _items.size():
		return
	var it := _items[index]
	if it.disabled or it.is_separator or it.submenu != null:
		return

	# Classic Macintosh 2-blink selection flash
	for flash in 2:
		_highlight_row(index, false)
		await get_tree().create_timer(0.03).timeout
		_highlight_row(index, true)
		await get_tree().create_timer(0.03).timeout

	var clicked_id: int = it.id
	if _parent_popup != null:
		_parent_popup.hide_menu()
	hide_menu()
	id_pressed.emit(clicked_id)

func _refresh_item_visual(index: int) -> void:
	if index < 0 or index >= _items.size():
		return
	var it := _items[index]
	if it.check_icon != null:
		it.check_icon.set_state(it.checked, COLOR_TEXT_DISABLED if it.disabled else COLOR_TEXT)
	if it.text_label != null:
		it.text_label.add_theme_color_override("font_color", COLOR_TEXT_DISABLED if it.disabled else COLOR_TEXT)

func _refresh_all_items() -> void:
	for i in _items.size():
		_refresh_item_visual(i)
