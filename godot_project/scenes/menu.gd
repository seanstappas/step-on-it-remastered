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
	var want_play := false
	for a in ua:
		if a.begins_with("--play=") or a.begins_with("--script=") or a.begins_with("--board="):   # valued flags (not --players=N)
			want_play = true
	if "--shot" in ua or "--demo" in ua or "--bug3" in ua or want_play:
		# --board=<file> overrides; else --demo uses a challenge board (has nasties).
		# --bug3 builds its OWN board in game.gd (_showcase_bug3_level), so the picked
		# board here is just a placeholder that game.gd immediately overrides.
		var target := ""
		for arg in ua:
			if arg.begins_with("--board="):
				target = arg.substr(8)
		if target == "":
			target = "board_450.bord" if "--demo" in ua else "board_401.bord"
		if target.is_absolute_path() and FileAccess.file_exists(target):
			# a crafted test board outside extracted/levels (tools/verify_scripts/*.bord)
			Session.board_list = PackedStringArray([target])
			Session.board_index = 0
			Session.board_path = target
			get_tree().change_scene_to_file.call_deferred("res://scenes/game.tscn")
			return
		# match by basename so "--board=board_450" and "--board=board_450.bord" both
		# resolve (a strict ends_with silently fell back to board_401 without the ext).
		var want := (target as String).get_file().get_basename()
		var idx := 0
		for i in _files.size():
			if (_files[i] as String).get_file().get_basename() == want:
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
	var is_dev := _is_dev_mode()
	var ua := OS.get_cmdline_user_args()
	for a in ua:
		if a.begins_with("--board=") or a.begins_with("--play=") or a.begins_with("--script=") or a == "--demo" or a == "--bug3" or a == "--shot":
			is_dev = true
			break
	if not is_dev:
		const STARTING_BOARDS := [401, 421, 441, 461, 481]
		var filtered: Array[String] = []
		for n in names:
			if _board_num(n) in STARTING_BOARDS:
				filtered.append(n)
		names = filtered
	for n in names:
		_files.append(_levels_dir.path_join(n))
		_list.add_item(_board_label(_board_num(n), is_dev))

func _is_dev_mode() -> bool:
	var all_args: Array = OS.get_cmdline_user_args()
	all_args.append_array(OS.get_cmdline_args())
	for a in all_args:
		if a == "--dev" or a == "--debug" or a == "--admin":
			return true
	return false

func _board_num(fn: String) -> int:
	return fn.get_basename().replace("board_", "").to_int()

## Grounded difficulty tiers (gameplay-and-design.md 8): the tiered campaign is BORD 401-500
## in five tiers of 20 -- Beginner / Novice / Intermediate / Advanced / Expert; 1001-1050 are
## the Compete set (asm FUN_1002b448: BORD N+1000 in Compete mode). Label each board by tier so
## "Set Starting Board" reads by difficulty.
func _board_label(num: int, is_dev: bool = true) -> String:
	if not is_dev:
		var start_labels := {
			401: "1, Beginner",
			421: "21, Novice",
			441: "41, Intermediate",
			461: "61, Advanced",
			481: "81, Expert"
		}
		if start_labels.has(num):
			return start_labels[num]
	if num >= 401 and num <= 500:
		var tiers := ["Beginner", "Novice", "Intermediate", "Advanced", "Expert"]
		return "%s  %d   (board_%d)" % [tiers[(num - 401) / 20], (num - 401) % 20 + 1, num]
	if num >= 1001 and num <= 1050:
		return "Compete  %d   (board_%d)" % [num - 1000, num]
	return "board_%d" % num

func _on_activated(idx: int) -> void:
	if idx >= 0 and idx < _files.size():
		# Advance within the picked board's own set (campaign 401-500 or compete 1001-1050),
		# never running off the end of one set into the next.
		var n := _board_num((_files[idx] as String).get_file())
		var set_files := PackedStringArray()
		for fpath in _files:
			var m := _board_num((fpath as String).get_file())
			if (n >= 401 and n <= 500 and m >= 401 and m <= 500) or \
					(n >= 1001 and n <= 1050 and m >= 1001 and m <= 1050) or m == n:
				set_files.append(fpath)
		Session.board_list = set_files
		Session.board_index = set_files.find(_files[idx])
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
