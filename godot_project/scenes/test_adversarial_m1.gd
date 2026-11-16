extends Node
## Adversarial Stress Test Suite for M1 Remediation
## Verifies:
## 1. Canvas downsizing across all grid transitions (38x26 -> 28x19 -> 19x13) & vs_spawns clamping
## 2. EXT1 trailer discovery on odd/even buffer lengths, odd/even offsets, false headers & corruption
## 3. Hidden block brush 0x0900 payload prefix encoding, BORD roundtrip, and Godot rendering
## 4. Single-player controller claiming in main_menu.gd under Joypad Button A simulation

const EditorScene = preload("res://scenes/editor.tscn")
const MainMenuScene = preload("res://scenes/main_menu.tscn")
const MapEditorScript = preload("res://scenes/editor.gd")
const MainMenuScript = preload("res://scenes/main_menu.gd")
const GameScript = preload("res://scenes/game.gd")
const Live3DScript = preload("res://scenes/live3d.gd")
const RollbackNetScript = preload("res://scenes/rollback_net.gd")
const TileCatalog = preload("res://scenes/tile_catalog.gd")
const TileArt = preload("res://scenes/tile_art.gd")

var total_assertions: int = 0
var passed_assertions: int = 0
var failed_assertions: int = 0
var failures: Array[String] = []

func _assert_true(condition: bool, msg: String) -> void:
	total_assertions += 1
	if condition:
		passed_assertions += 1
	else:
		failed_assertions += 1
		var err: String = "FAIL [%d]: %s" % [total_assertions, msg]
		failures.append(err)
		printerr(err)

func _ready() -> void:
	print("==================================================================")
	print("Starting Adversarial Stress Test Suite (Challenger 1 - M1 Audit)")
	print("==================================================================")

	test_canvas_downsizing_and_spawns()
	test_ext1_trailer_discovery()
	test_hidden_block_brush_and_rendering()
	test_single_player_controller_claiming()
	test_export_hygiene_and_hardening()

	print("==================================================================")
	print("Stress Test Summary: %d total, %d passed, %d failed" % [total_assertions, passed_assertions, failed_assertions])
	print("==================================================================")

	if failed_assertions > 0:
		printerr("CHALLENGE VERDICT: REJECT - Failures encountered:")
		for f in failures:
			printerr("  " + f)
		get_tree().quit(1)
	else:
		print("CHALLENGE VERDICT: ALL ADVERSARIAL STRESS TESTS PASSED")
		get_tree().quit(0)


# ==============================================================================
# Challenge 1: Canvas Downsizing & Spawns
# ==============================================================================
func test_canvas_downsizing_and_spawns() -> void:
	print("\n--- Challenge 1: Canvas Downsizing Across All Transitions ---")
	var ed = EditorScene.instantiate()
	add_child(ed)

	# 1.1 Transition: 38x26 -> 28x19
	ed._init_grid(38, 26)
	ed.vs_spawns[0] = Vector2i(37, 25) # Max corner
	ed.vs_spawns[1] = Vector2i(30, 20)
	ed.vs_spawns[2] = Vector2i(27, 18)
	ed.vs_spawns[3] = Vector2i(99, 88) # Extreme out of bounds
	ed.p1_spawn = Vector2i(37, 25)
	ed.p2_spawn = Vector2i(35, 23)
	ed.p3_spawn = Vector2i(33, 21)

	ed._init_grid(28, 19)
	for i in range(4):
		_assert_true(ed.vs_spawns[i].x >= 0 and ed.vs_spawns[i].x < 28, "38->28: vs_spawns[%d].x in [0, 27]" % i)
		_assert_true(ed.vs_spawns[i].y >= 0 and ed.vs_spawns[i].y < 19, "38->28: vs_spawns[%d].y in [0, 18]" % i)
	_assert_true(ed.vs_spawns[0] == Vector2i(27, 18), "38->28: vs_spawns[0] clamped to (27, 18)")
	_assert_true(ed.vs_spawns[3] == Vector2i(27, 18), "38->28: vs_spawns[3] extreme clamped to (27, 18)")
	_assert_true(ed.p1_spawn == Vector2i(27, 18), "38->28: p1_spawn clamped to (27, 18)")
	_assert_true(ed.p2_spawn == Vector2i(27, 18), "38->28: p2_spawn clamped to (27, 18)")
	_assert_true(ed.p3_spawn == Vector2i(27, 18), "38->28: p3_spawn clamped to (27, 18)")

	# 1.2 Transition: 28x19 -> 19x13
	ed._init_grid(19, 13)
	for i in range(4):
		_assert_true(ed.vs_spawns[i].x >= 0 and ed.vs_spawns[i].x < 19, "28->19: vs_spawns[%d].x in [0, 18]" % i)
		_assert_true(ed.vs_spawns[i].y >= 0 and ed.vs_spawns[i].y < 13, "28->19: vs_spawns[%d].y in [0, 12]" % i)
	_assert_true(ed.vs_spawns[0] == Vector2i(18, 12), "28->19: vs_spawns[0] clamped to (18, 12)")
	_assert_true(ed.vs_spawns[3] == Vector2i(18, 12), "28->19: vs_spawns[3] clamped to (18, 12)")
	_assert_true(ed.p1_spawn == Vector2i(18, 12), "28->19: p1_spawn clamped to (18, 12)")

	# 1.3 Direct Transition: 38x26 -> 19x13 (skipping intermediate)
	ed._init_grid(38, 26)
	ed.vs_spawns[0] = Vector2i(37, 25)
	ed.vs_spawns[1] = Vector2i(36, 24)
	ed.vs_spawns[2] = Vector2i(35, 23)
	ed.vs_spawns[3] = Vector2i(34, 22)
	ed._init_grid(19, 13)
	for i in range(4):
		_assert_true(ed.vs_spawns[i].x >= 0 and ed.vs_spawns[i].x < 19, "38->19 direct: vs_spawns[%d].x in [0, 18]" % i)
		_assert_true(ed.vs_spawns[i].y >= 0 and ed.vs_spawns[i].y < 13, "38->19 direct: vs_spawns[%d].y in [0, 12]" % i)
		_assert_true(ed.vs_spawns[i] == Vector2i(18, 12), "38->19 direct: vs_spawns[%d] clamped to (18, 12)" % i)

	# 1.4 Negative Coordinates Stress
	ed._init_grid(38, 26)
	ed.vs_spawns[0] = Vector2i(-15, -30)
	ed.vs_spawns[1] = Vector2i(-1, 0)
	ed.vs_spawns[2] = Vector2i(0, -1)
	ed.vs_spawns[3] = Vector2i(-500, 500)
	ed._init_grid(19, 13)
	_assert_true(ed.vs_spawns[0] == Vector2i(0, 0), "negative coords: vs_spawns[0] clamped to (0, 0)")
	_assert_true(ed.vs_spawns[1] == Vector2i(0, 0), "negative coords: vs_spawns[1] clamped to (0, 0)")
	_assert_true(ed.vs_spawns[2] == Vector2i(0, 0), "negative coords: vs_spawns[2] clamped to (0, 0)")
	_assert_true(ed.vs_spawns[3] == Vector2i(0, 12), "negative coords: vs_spawns[3] clamped to (0, 12)")

	# 1.5 Cycle Canvas Size API
	ed._set_canvas_size_idx(2) # 38x26
	ed.vs_spawns[0] = Vector2i(36, 24)
	ed.cycle_canvas_size() # -> 19x13
	_assert_true(ed.grid_cols == 19 and ed.grid_rows == 13, "cycle_canvas_size cycled to 19x13")
	_assert_true(ed.vs_spawns[0] == Vector2i(18, 12), "cycle_canvas_size clamped vs_spawns[0]")

	# 1.6 Serialization roundtrip after downsizing
	ed.has_p3 = true
	var serialized: PackedByteArray = ed.serialize_to_bord()
	ed._init_grid(38, 26)
	var load_ok: bool = ed.load_from_bord(serialized)
	_assert_true(load_ok, "load_from_bord loaded downsized board")
	_assert_true(ed.grid_cols == 19 and ed.grid_rows == 13, "recovered grid_cols 19 and grid_rows 13")
	for i in range(4):
		_assert_true(ed.vs_spawns[i].x < 19 and ed.vs_spawns[i].y < 13, "post-load vs_spawns[%d] within [0, 18]x[0, 12]" % i)

	ed.queue_free()
	print("Canvas Downsizing Stress Tests: PASSED")


# ==============================================================================
# Challenge 2: EXT1 Trailer Discovery on Odd/Even Lengths & Offsets
# ==============================================================================
func test_ext1_trailer_discovery() -> void:
	print("\n--- Challenge 2: EXT1 Trailer Discovery Across Odd/Even Lengths & Offsets ---")
	var ed = EditorScene.instantiate()
	add_child(ed)

	# Build baseline board with EXT1 properties
	ed._init_grid(38, 26)
	ed.has_p3 = true
	ed.friendly_fire = true
	ed.default_mode = 2 # Versus
	ed.victory_rule = 1
	ed.starting_lives = 5
	ed.p3_spawn = Vector2i(15, 10)
	ed.vs_spawns[0] = Vector2i(2, 3)
	ed.vs_spawns[1] = Vector2i(4, 5)
	ed.vs_spawns[2] = Vector2i(6, 7)
	ed.vs_spawns[3] = Vector2i(8, 9)
	# Place some tiles
	ed.cells[5][5] = 0x0307
	ed.cells[10][10] = 0x0207

	var base_raw: PackedByteArray = ed.serialize_to_bord()
	var base_len: int = base_raw.size()
	print("Baseline serialized BORD length: %d bytes" % base_len)

	# 2.1 Multi-padding Stress Test: trailing bytes K in [0..31]
	# Alternates odd/even total lengths and odd/even alignments
	var padding_counts: Array[int] = [0, 1, 2, 3, 4, 5, 7, 8, 9, 11, 13, 15, 16, 21, 23, 27, 31]
	for pad in padding_counts:
		var buf: PackedByteArray = base_raw.duplicate()
		for p in range(pad):
			buf.append((p * 37 + 13) & 0xFF)
		var total_len: int = buf.size()
		var is_odd_len: bool = (total_len % 2 == 1)

		# Reset editor to clean state
		ed._init_grid(19, 13)
		ed.has_p3 = false
		ed.friendly_fire = false
		ed.default_mode = 0
		ed.victory_rule = 0
		ed.starting_lives = 3

		var ok: bool = ed.load_from_bord(buf)
		_assert_true(ok, "EXT1 discovery with %d padding bytes (len=%d, odd=%s)" % [pad, total_len, str(is_odd_len)])
		_assert_true(ed.grid_cols == 38 and ed.grid_rows == 26, "EXT1 cols=38 rows=26 with %d pad bytes" % pad)
		_assert_true(ed.has_p3 == true, "EXT1 has_p3 recovered with %d pad bytes" % pad)
		_assert_true(ed.friendly_fire == true, "EXT1 friendly_fire recovered with %d pad bytes" % pad)
		_assert_true(ed.default_mode == 2, "EXT1 default_mode=2 recovered with %d pad bytes" % pad)
		_assert_true(ed.victory_rule == 1 and ed.starting_lives == 5, "EXT1 victory & lives with %d pad bytes" % pad)
		_assert_true(ed.p3_spawn == Vector2i(15, 10), "EXT1 p3_spawn recovered with %d pad bytes" % pad)
		_assert_true(ed.vs_spawns[0] == Vector2i(2, 3) and ed.vs_spawns[3] == Vector2i(8, 9), "EXT1 vs_spawns recovered with %d pad bytes" % pad)

	# 2.2 Explicit odd lengths: 501 bytes and 503 bytes with EXT1 at even offset
	var buf_501: PackedByteArray = base_raw.duplicate()
	if buf_501.size() < 501:
		while buf_501.size() < 501:
			buf_501.append(0xAA)
	elif buf_501.size() > 501:
		buf_501 = buf_501.slice(0, 501)
	if buf_501.size() == 501:
		ed._init_grid(19, 13)
		var ok_501: bool = ed.load_from_bord(buf_501)
		_assert_true(ok_501, "load_from_bord succeeded on 501-byte buffer")
		_assert_true(ed.grid_cols == 38 and ed.has_p3 == true, "EXT1 detected in 501-byte buffer")

	var buf_503: PackedByteArray = base_raw.duplicate()
	if buf_503.size() < 503:
		while buf_503.size() < 503:
			buf_503.append(0xBB)
	if buf_503.size() == 503:
		ed._init_grid(19, 13)
		var ok_503: bool = ed.load_from_bord(buf_503)
		_assert_true(ok_503, "load_from_bord succeeded on 503-byte buffer")
		_assert_true(ed.grid_cols == 38 and ed.has_p3 == true, "EXT1 detected in 503-byte buffer")

	# 2.3 False Magic Stress Test: fake 'EXT1' header with invalid CRC
	var fake_header := PackedByteArray([
		0x45, 0x58, 0x54, 0x31, # 'EXT1'
		0x01, 0x00, 0x13, 0x0D,
		0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0x00, 0x00,
		0x00, 0x00, 0xDE, 0xAD  # False CRC 0xDEAD
	])
	var fake_after: PackedByteArray = base_raw.duplicate()
	fake_after.append_array(fake_header) # Real EXT1 is before fake EXT1
	ed._init_grid(19, 13)
	var ok_false: bool = ed.load_from_bord(fake_after)
	_assert_true(ok_false, "Scanner bypassed false EXT1 header with bad CRC and located valid EXT1")
	_assert_true(ed.grid_cols == 38 and ed.has_p3 == true, "EXT1 properties valid despite false trailing EXT1")

	# 2.4 Truncated & Corrupted Buffer Edge Cases
	_assert_true(ed.load_from_bord(PackedByteArray()) == false, "Empty buffer returns false")
	_assert_true(ed.load_from_bord(PackedByteArray([0x00, 0x01, 0x02])) == false, "3-byte buffer returns false")
	_assert_true(ed.load_from_bord(base_raw.slice(0, 23)) == false, "23-byte buffer returns false")

	# Buffer between 24 and 47 bytes (has base header but no room for EXT1)
	var short_buf: PackedByteArray = base_raw.slice(0, 36)
	var ok_short: bool = ed.load_from_bord(short_buf)
	_assert_true(ok_short, "36-byte buffer loads base header without crash")
	_assert_true(ed.grid_cols == 19 and ed.grid_rows == 13, "36-byte buffer falls back to default 19x13")
	_assert_true(ed.has_p3 == false, "36-byte buffer defaults has_p3=false")

	ed.queue_free()
	print("EXT1 Trailer Discovery Stress Tests: PASSED")


# ==============================================================================
# Challenge 3: Hidden Block Brush, 0x0900 Prefix & Rendering
# ==============================================================================
func test_hidden_block_brush_and_rendering() -> void:
	print("\n--- Challenge 3: Hidden Block Brush, 0x0900 Prefix & Rendering ---")
	var ed = EditorScene.instantiate()
	add_child(ed)

	# 3.1 Initial Default Brush State
	_assert_true(ed.current_hidden_goody == 0x0917, "Default current_hidden_goody is 0x0917 (Gold Coin with 0x0900 prefix)")

	# Set variant to HIDDEN and select block family 0 (White Block, t=0x07)
	ed._select_block_family(TileCatalog.BLOCK_FAMILIES[0]["t"], TileCatalog.BLOCK_FAMILIES[0]["name"])
	ed._set_block_variant(TileCatalog.FLAG_HIDDEN)

	var payload: int = (ed.current_brush >> 16) & 0xFFFF
	var variant_flags: int = ed.current_brush & 0xFF00
	var family_t: int = ed.current_brush & 0xFF

	_assert_true((payload & 0xFF00) == 0x0900, "current_brush payload has 0x0900 prefix: 0x%04X" % payload)
	_assert_true(payload == 0x0917, "current_brush payload is exactly 0x0917")
	_assert_true(variant_flags == TileCatalog.FLAG_HIDDEN, "current_brush variant flags == FLAG_HIDDEN (0x1200)")
	_assert_true(family_t == 0x07, "current_brush family low byte == 0x07")

	# 3.2 Iterate Over ALL Catalog Goodies
	# Verify that selecting each goody retains the 0x0900 prefix and formats brush cleanly
	# Make sure Goodies section is expanded
	ed._cat_collapsed["Goodies"] = false
	for g in TileCatalog.GOODIES:
		var g_id: int = g["id"]
		var goody_tile: int = g["tile"]
		var items: Array = [{"tile": goody_tile, "name": g["name"], "desc": g.get("desc", "")}]
		# Header is at cur_y .. cur_y + 20; first item is at cur_y + 20 .. cur_y + 42
		ed._handle_list_section_click("Goodies", items, 25.0, 4.0)

		_assert_true((ed.current_hidden_goody & 0xFF00) == 0x0900,
			"Goody %s: current_hidden_goody has 0x0900 prefix: 0x%04X" % [g["name"], ed.current_hidden_goody])
		_assert_true((ed.current_hidden_goody & 0xFF) == g_id,
			"Goody %s: low byte matches goody ID 0x%02X" % [g["name"], g_id])

		# Switch brush to block with this hidden goody
		ed._select_block_family(TileCatalog.BLOCK_FAMILIES[1]["t"], TileCatalog.BLOCK_FAMILIES[1]["name"]) # Red Block
		ed._set_block_variant(TileCatalog.FLAG_HIDDEN)

		var cur_payload: int = (ed.current_brush >> 16) & 0xFFFF
		_assert_true((cur_payload & 0xFF00) == 0x0900,
			"Goody %s: brush payload has 0x0900 prefix: 0x%04X" % [g["name"], cur_payload])
		_assert_true((cur_payload & 0xFF) == g_id,
			"Goody %s: brush payload matches goody ID 0x%02X" % [g["name"], g_id])

	# 3.3 Grid Placement & BORD Roundtrip with Non-Coin Goodies
	# Place Hidden Extra Life (0x1A -> 0x091A), Speed Shoes (0x1B -> 0x091B), Freeze (0x1C -> 0x091C)
	ed._init_grid(19, 13)
	var test_goodies: Array = [
		{"col": 3, "row": 3, "goody": 0x091A, "name": "Extra Life"},
		{"col": 4, "row": 3, "goody": 0x091B, "name": "Speed Shoes"},
		{"col": 5, "row": 3, "goody": 0x091C, "name": "Freeze Timer"},
		{"col": 6, "row": 3, "goody": 0x0917, "name": "Gold Coin"},
	]

	for tg in test_goodies:
		var cval: int = (tg["goody"] << 16) | TileCatalog.FLAG_HIDDEN | 0x07
		ed.cells[tg["row"]][tg["col"]] = cval

	var bord_bytes: PackedByteArray = ed.serialize_to_bord()
	ed._init_grid(19, 13)
	var reload_ok: bool = ed.load_from_bord(bord_bytes)
	_assert_true(reload_ok, "load_from_bord reloaded hidden blocks successfully")

	for tg in test_goodies:
		var loaded_cell: int = ed.cells[tg["row"]][tg["col"]]
		var p: int = (loaded_cell >> 16) & 0xFFFF
		var f: int = loaded_cell & 0xFF00
		_assert_true(p == tg["goody"], "Roundtrip preserved %s payload: 0x%04X == 0x%04X" % [tg["name"], p, tg["goody"]])
		_assert_true(f == TileCatalog.FLAG_HIDDEN, "Roundtrip preserved %s FLAG_HIDDEN" % tg["name"])

	# 3.4 Visual Rendering Verification in Godot
	for tg in test_goodies:
		var cell_val: int = ed.cells[tg["row"]][tg["col"]]
		var info: Dictionary = TileArt.resolve_cell(cell_val)

		_assert_true(info.get("hidden", false) == true, "TileArt.resolve_cell marks %s as hidden" % tg["name"])
		_assert_true(info.get("folder", "") == "block_sprites", "TileArt folder is block_sprites")
		_assert_true(info.get("frame", 0) > 0, "TileArt frame > 0")

		# Check sprite loading for both Remastered and Original
		var spr_hd = TileArt.get_sprite(info["folder"], info["frame"], true)
		var spr_sd = TileArt.get_sprite(info["folder"], info["frame"], false)
		_assert_true(spr_hd != null, "HD block sprite valid for %s hidden block" % tg["name"])
		_assert_true(spr_sd != null, "SD block sprite valid for %s hidden block" % tg["name"])

		# Simulate goody reveal upon block destruction in game.gd:
		# When broken, the block cell becomes the payload:
		var revealed_cell: int = (cell_val >> 16) & 0xFFFF
		_assert_true((revealed_cell & 0x0800) != 0,
			"Revealed cell for %s contains CELL_DOOR (0x0800): 0x%04X" % [tg["name"], revealed_cell])

		# In game.gd: (cell & CELL_DOOR) or t == 0x0A or t == 0x17...
		var hits_door_or_coin_branch: bool = bool((revealed_cell & 0x0800) != 0) or ((revealed_cell & 0xFF) == 0x17)
		_assert_true(hits_door_or_coin_branch, "Revealed %s cell hits game.gd goody branch" % tg["name"])

		# Verify goody_sprites lookup in TileArt
		var goody_info: Dictionary = TileArt.resolve_cell(revealed_cell)
		_assert_true(goody_info.get("folder", "") == "goody_sprites",
			"Revealed %s resolves to goody_sprites folder" % tg["name"])
		var g_spr_hd = TileArt.get_sprite("goody_sprites", (revealed_cell & 0xFF) + 1, true)
		var g_spr_sd = TileArt.get_sprite("goody_sprites", (revealed_cell & 0xFF) + 1, false)
		_assert_true(g_spr_hd != null, "HD goody sprite valid for revealed %s" % tg["name"])
		_assert_true(g_spr_sd != null, "SD goody sprite valid for revealed %s" % tg["name"])

	# 3.5 Contrast with Defective (Old) Brush without 0x0900 Prefix
	var defective_cell: int = (0x001A << 16) | TileCatalog.FLAG_HIDDEN | 0x07
	var def_revealed: int = (defective_cell >> 16) & 0xFFFF
	var def_hits_branch: bool = bool((def_revealed & 0x0800) != 0) or (def_revealed == 0x0A) or (def_revealed == 0x17) or (def_revealed == 0x18) or (def_revealed == 0x19)
	_assert_true(def_hits_branch == false,
		"CONFIRMED DEFECT: Raw low-byte 0x001A fails CELL_DOOR and renders blank in game.gd")

	ed.queue_free()
	print("Hidden Block Brush & Rendering Stress Tests: PASSED")


# ==============================================================================
# Challenge 4: Single-Player Controller Claiming in main_menu.gd
# ==============================================================================
func test_single_player_controller_claiming() -> void:
	print("\n--- Challenge 4: Single-Player Controller Claiming in main_menu.gd ---")
	var menu = MainMenuScene.instantiate()
	add_child(menu)

	# 4.1 Single-Player Baseline Setup
	Session.num_players = 1
	Session.player_device = [-1] # Keyboard 1 default
	Session.is_online = false

	# Create simulated Joypad Button A press from Device 0
	var ev_a0 := InputEventJoypadButton.new()
	ev_a0.device = 0
	ev_a0.button_index = JOY_BUTTON_A
	ev_a0.pressed = true

	# 4.2 First Press: Claim Slot 0
	menu._input(ev_a0)
	_assert_true(Session.player_device.size() > 0, "player_device is not empty")
	_assert_true(Session.player_device[0] == 0, "Device 0 claimed P1 slot on first press: %d" % Session.player_device[0])

	# 4.3 Second Press: Regression Test (Previously cycled to -1 keyboard!)
	menu._input(ev_a0)
	_assert_true(Session.player_device[0] == 0,
		"CRITICAL REGRESSION CHECK: Device 0 remains in P1 slot on second press (not reset to -1): %d" % Session.player_device[0])

	# 4.4 Third Press: Sustained idempotency
	menu._input(ev_a0)
	_assert_true(Session.player_device[0] == 0,
		"Device 0 remains in P1 slot on third press: %d" % Session.player_device[0])

	# 4.5 Switch to Device 2
	var ev_a2 := InputEventJoypadButton.new()
	ev_a2.device = 2
	ev_a2.button_index = JOY_BUTTON_A
	ev_a2.pressed = true

	menu._input(ev_a2)
	_assert_true(Session.player_device[0] == 2, "Device 2 claimed P1 slot from Device 0: %d" % Session.player_device[0])

	# Repeated press on Device 2
	menu._input(ev_a2)
	_assert_true(Session.player_device[0] == 2, "Device 2 remains in P1 slot on repeated press: %d" % Session.player_device[0])

	# 4.6 Non-A Buttons Should Not Trigger Claim
	var ev_b := InputEventJoypadButton.new()
	ev_b.device = 3
	ev_b.button_index = JOY_BUTTON_B
	ev_b.pressed = true

	menu._input(ev_b)
	_assert_true(Session.player_device[0] == 2, "Button B from device 3 did not claim slot: %d" % Session.player_device[0])

	var ev_x := InputEventJoypadButton.new()
	ev_x.device = 3
	ev_x.button_index = JOY_BUTTON_X
	ev_x.pressed = true

	menu._input(ev_x)
	_assert_true(Session.player_device[0] == 2, "Button X from device 3 did not claim slot: %d" % Session.player_device[0])

	# 4.7 Button Release Filtering
	var ev_rel := InputEventJoypadButton.new()
	ev_rel.device = 3
	ev_rel.button_index = JOY_BUTTON_A
	ev_rel.pressed = false # Release

	menu._input(ev_rel)
	_assert_true(Session.player_device[0] == 2, "Button release event did not change slot: %d" % Session.player_device[0])

	# 4.8 Empty Array Edge Case
	Session.player_device = []
	menu._input(ev_a0)
	_assert_true(Session.player_device.size() == 1 and Session.player_device[0] == 0,
		"Empty player_device properly initialized and claimed by Device 0")

	# 4.9 Multiplayer Mode (num_players == 2) Delegation Check
	Session.num_players = 2
	Session.player_device = [-1, -2] # Both on keyboard

	menu._input(ev_a0) # Device 0 claims
	_assert_true(Session.player_device[0] == 0, "Multiplayer: Device 0 claimed slot 0")

	menu._input(ev_a2) # Device 2 claims
	_assert_true(Session.player_device[1] == 2, "Multiplayer: Device 2 claimed slot 1")

	# Device 0 presses A again in 2-player -> should cycle slots
	menu._input(ev_a0)
	_assert_true(Session.player_device[1] == 0, "Multiplayer: Device 0 cycled to slot 1")

	menu.queue_free()
	print("Single-Player Controller Claiming Stress Tests: PASSED")


func _has_local_editor_guard(lines: PackedStringArray, li: int) -> bool:
	var lo: int = maxi(0, li - 5)
	var hi: int = mini(lines.size() - 1, li + 2)
	for j in range(lo, hi + 1):
		if "OS.has_feature(\"editor\")" in lines[j]:
			return true
	return false


# ==============================================================================
# Challenge 5: .pck Export Path Hygiene, Sanitization & Lobby Target Validation
# ==============================================================================
func test_export_hygiene_and_hardening() -> void:
	print("\n--- Challenge 5: .pck Export Path Hygiene & Hardening ---")

	# 5.1 Static scan of all res://scenes/*.gd for unguarded res://../ or globalize_path("res://...")
	if OS.has_feature("editor"):
		var rel_prefix := "res://" + "../"
		var ext_prefix := rel_prefix + "extracted"
		var globalize_res_prefix := "globalize_path(\"res:" + "//"
		var da := DirAccess.open("res://scenes")
		_assert_true(da != null, "Can open res://scenes for static hygiene scan")
		var scanned_gd_count := 0
		if da != null:
			da.list_dir_begin()
			var fname := da.get_next()
			while fname != "":
				if fname.ends_with(".gd"):
					scanned_gd_count += 1
					var src := FileAccess.get_file_as_string("res://scenes/" + fname)
					var lines := src.split("\n")
					for li in range(lines.size()):
						var line := lines[li].strip_edges()
						if line.begins_with("#"):
							continue
						if ext_prefix in line:
							var ok_file := fname in ["session.gd", "live3d.gd", "tile_art.gd"]
							_assert_true(ok_file and _has_local_editor_guard(lines, li),
								"%s:%d must not contain unguarded %s" % [fname, li + 1, ext_prefix])
						elif rel_prefix in line:
							_assert_true(_has_local_editor_guard(lines, li),
								"%s:%d contains %s without local OS.has_feature(\"editor\") guard" % [fname, li + 1, rel_prefix])
						if globalize_res_prefix in line:
							_assert_true(_has_local_editor_guard(lines, li),
								"%s:%d calls globalize_path(res://...) without local OS.has_feature(\"editor\") guard" % [fname, li + 1])
				fname = da.get_next()
			da.list_dir_end()
		_assert_true(scanned_gd_count >= 15, "Static hygiene scan checked >= 15 .gd files (actual=%d)" % scanned_gd_count)

	# 5.2 Session.ext_path & asset root constant checks
	var lv_dir := Session.ext_path("levels").replace("\\", "/")
	_assert_true(lv_dir.ends_with("/extracted/levels"), "Session.ext_path('levels') normalized: %s" % lv_dir)
	_assert_true(not lv_dir.begins_with("res://"), "Session.ext_path returns globalized path, not res://")
	_assert_true(Session.ext_path("/sprites") == Session.ext_path("sprites"), "Session.ext_path strips leading slash")
	_assert_true(Session.ext_path("extracted/sprites") == Session.ext_path("sprites"), "Session.ext_path strips duplicate extracted/ prefix")
	_assert_true(Audio.SFX_VARIANTS.get("original", "") == "audio/wav", "Audio.SFX_VARIANTS['original'] is relative")
	_assert_true(Audio.SFX_VARIANTS.get("light", "") == "audio/wav_hd", "Audio.SFX_VARIANTS['light'] is relative")
	_assert_true(Audio.SFX_VARIANTS.get("ai", "") == "audio/wav_ai", "Audio.SFX_VARIANTS['ai'] is relative")
	_assert_true(GameScript.SPRITES_DIR == "sprites", "GameScript.SPRITES_DIR is relative")
	_assert_true(GameScript.SPRITES_3D_DIR == "sprites_3d_frames", "GameScript.SPRITES_3D_DIR is relative")
	_assert_true(GameScript.LIVE_DIR == "sprites_live", "GameScript.LIVE_DIR is relative")
	_assert_true(GameScript.PICT_DIR == "pict", "GameScript.PICT_DIR is relative")
	_assert_true(Live3DScript._ext_dir("sprites_live") == Session.ext_path("sprites_live"), "Live3D._ext_dir matches Session.ext_path")
	_assert_true(TileArt._ext_dir("sprites/block_sprites") == Session.ext_path("sprites/block_sprites"), "TileArt._ext_dir matches Session.ext_path")

	# 5.3 Map filename sanitization & playtest state preservation
	_assert_true(MapEditorScript.sanitize_map_name("") == "custom_map", "Empty map name falls back to custom_map")
	_assert_true(MapEditorScript.sanitize_map_name("   ...  ") == "custom_map", "Dots/whitespace map name falls back to custom_map")
	var trav := MapEditorScript.sanitize_map_name("../../etc/passwd.bord")
	_assert_true(not (".." in trav) and not ("/" in trav) and not ("\\" in trav) and not trav.ends_with(".bord"),
		"Path traversal sanitized: %s" % trav)
	var bad_win := MapEditorScript.sanitize_map_name("C:\\dir:bad*?\"<>|name.BORD")
	for bad_ch in ["\\", "/", ":", "*", "?", "\"", "<", ">", "|"]:
		_assert_true(not (bad_ch in bad_win), "Sanitized name excludes '%s': %s" % [bad_ch, bad_win])
	_assert_true(MapEditorScript.sanitize_map_name("CON").to_upper() != "CON", "Windows reserved CON rejected")
	_assert_true(MapEditorScript.sanitize_map_name("nul.bord").to_upper() != "NUL", "Windows reserved nul.bord rejected")
	_assert_true(MapEditorScript.sanitize_map_name("COM1").to_upper() != "COM1", "Windows reserved COM1 rejected")
	_assert_true(MapEditorScript.sanitize_map_name("My_Level_01.bord") == "My_Level_01", "Valid .bord suffix stripped cleanly")

	var ed = EditorScene.instantiate()
	add_child(ed)
	ed.current_hidden_goody = 0x0919
	ed.enemy_facing_left = false
	ed.map_name = "Test_State_Roundtrip"
	var saved_ed_state: Dictionary = ed._save_editor_state()
	ed.current_hidden_goody = 0x090A
	ed.enemy_facing_left = true
	ed.map_name = "clobbered"
	ed._restore_editor_state(saved_ed_state)
	_assert_true(ed.current_hidden_goody == 0x0919, "Editor roundtrip preserved current_hidden_goody")
	_assert_true(ed.enemy_facing_left == false, "Editor roundtrip preserved enemy_facing_left")
	_assert_true(ed.map_name == "Test_State_Roundtrip", "Editor roundtrip preserved map_name")
	ed.queue_free()

	# 5.4 MainMenu join target, IPv4:Port & Crockford join-code validation
	var j_ip := MainMenuScript.parse_join_target("127.0.0.1")
	_assert_true(j_ip["ok"] == true and j_ip["ip"] == "127.0.0.1" and j_ip["port"] == 7777, "Plain IPv4 parses cleanly")
	var j_ip_port := MainMenuScript.parse_join_target("100.64.1.2:7780")
	_assert_true(j_ip_port["ok"] == true and j_ip_port["ip"] == "100.64.1.2" and j_ip_port["port"] == 7780, "IPv4:Port parses cleanly")
	var code_rt := RollbackNetScript.ip_to_join_code("192.168.1.42", 7781)
	var j_code := MainMenuScript.parse_join_target(code_rt)
	_assert_true(j_code["ok"] == true and j_code["ip"] == "192.168.1.42" and j_code["port"] == 7781,
		"Join code %s roundtrips IP+port cleanly" % code_rt)

	# Regression: "S01" / "SOI" inside Crockford payload body must NOT be stripped by prefix removal
	var soi_body_code := RollbackNetScript.ip_to_join_code("25.0.64.1", 7777)
	_assert_true("S01" in soi_body_code.substr(4), "Fixture IP 25.0.64.1 encodes S01 in body: %s" % soi_body_code)
	var soi_typed_code := soi_body_code.substr(0, 4) + soi_body_code.substr(4).replace("S01", "SOI")
	_assert_true(RollbackNetScript.join_code_to_ip(soi_typed_code) == "25.0.64.1",
		"SOI inside body preserved during IP decode: %s" % soi_typed_code)
	_assert_true(RollbackNetScript.join_code_to_port(soi_typed_code) == 7777,
		"SOI inside body preserved during port decode: %s" % soi_typed_code)
	var j_soi_body := MainMenuScript.parse_join_target(soi_typed_code)
	_assert_true(j_soi_body["ok"] == true and j_soi_body["ip"] == "25.0.64.1" and j_soi_body["port"] == 7777,
		"parse_join_target roundtrips SOI-in-body code: %s" % soi_typed_code)
	var bare_soi_body := soi_typed_code.substr(4)
	_assert_true(RollbackNetScript.join_code_to_ip(bare_soi_body) == "25.0.64.1",
		"Bare join code with SOI at offset >= 1 preserves body: %s" % bare_soi_body)

	for bad_target in ["", "SOI-INVALID", "SOI-00000-00000", "0.0.0.0", "255.255.255.255", "0.0.0.0:7777", "+1.0.0.1", "127.0.0.1:+7777", "127.0.0.1:-1", "999.0.0.1", "127.0.0.1:0", "127.0.0.1:70000", "127.0.0.1:abc", "1.2.3:7777", "127.0.0.1:7777:8888"]:
		var j_bad := MainMenuScript.parse_join_target(bad_target)
		_assert_true(j_bad["ok"] == false, "Invalid join target rejected: '%s'" % bad_target)

	print(".pck Export Path Hygiene & Hardening Tests: PASSED")
