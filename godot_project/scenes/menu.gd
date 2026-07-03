extends Control
## menu.gd — board picker. Scans the extracted levels folder and lets the player
## choose which of the 152 boards to play. The selection is handed to the game
## scene via the Session autoload.

var _list: ItemList
var _files: PackedStringArray = PackedStringArray()
var _levels_dir: String = ""

func _ready() -> void:
	var title := Label.new()
	title.text = "STEP ON IT!  —  choose a board  (Enter / double-click,  Esc to quit)"
	title.position = Vector2(12, 10)
	add_child(title)

	_list = ItemList.new()
	_list.set_anchors_preset(Control.PRESET_FULL_RECT)
	_list.offset_top = 40
	add_child(_list)

	_levels_dir = _find_levels_dir()
	_populate()
	_list.item_activated.connect(_on_activated)
	if _list.item_count > 0:
		_list.select(0)
	_list.grab_focus()
	print("menu: %d boards from %s" % [_files.size(), _levels_dir])

	# headless/windowed capture harness: auto-launch a known board
	var ua := OS.get_cmdline_user_args()
	if "--shot" in ua or "--demo" in ua:
		# --board=<file> overrides; else --demo uses a challenge board (has nasties)
		var target := ""
		for arg in ua:
			if arg.begins_with("--board="):
				target = arg.substr(8)
		if target == "":
			target = "board_450.bord" if "--demo" in ua else "board_401.bord"
		var idx := 0
		for i in _files.size():
			if _files[i].ends_with(target):
				idx = i
				break
		call_deferred("_on_activated", idx)

func _find_levels_dir() -> String:
	for d in [
		ProjectSettings.globalize_path("res://../extracted/levels"),
		ProjectSettings.globalize_path("res://levels"),
	]:
		if DirAccess.dir_exists_absolute(d):
			return d
	return ""

func _populate() -> void:
	if _levels_dir == "":
		_list.add_item("(no extracted/levels found — Enter starts the built-in demo level)")
		return
	var da := DirAccess.open(_levels_dir)
	if da == null:
		_list.add_item("(cannot open levels dir — Enter starts the demo level)")
		return
	var names: Array[String] = []
	da.list_dir_begin()
	var f := da.get_next()
	while f != "":
		if f.ends_with(".bord"):
			names.append(f)
		f = da.get_next()
	da.list_dir_end()
	names.sort_custom(func(a, b): return _board_num(a) < _board_num(b))
	for n in names:
		_files.append(_levels_dir.path_join(n))
		_list.add_item(n.get_basename())

func _board_num(fn: String) -> int:
	return fn.get_basename().replace("board_", "").to_int()

func _on_activated(idx: int) -> void:
	if idx >= 0 and idx < _files.size():
		Session.board_list = _files
		Session.board_index = idx
		Session.board_path = _files[idx]
	else:
		Session.board_path = ""   # fall back to the game's built-in demo level
		Session.board_index = -1
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _input(e: InputEvent) -> void:
	if e is InputEventKey and e.pressed:
		if e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER:
			var sel := _list.get_selected_items()
			_on_activated(sel[0] if sel.size() > 0 else -1)
		elif e.keycode == KEY_ESCAPE:
			get_tree().quit()
