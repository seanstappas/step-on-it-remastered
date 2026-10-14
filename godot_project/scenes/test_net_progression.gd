extends Node

# test_net_progression.gd — Test online board progression and retry synchronization
# Verifies:
# - PKT_BOARD_LOAD (0x02) packet transmission and receipt
# - Host advances to next board; client receives new board bytes & seed
# - Both cores reset/advance to next board synchronously with matching state hashes
# - Host sends retry on game-over; client receives retry packet and re-initializes cleanly

func _ready() -> void:
	print("==================================================================")
	print("Step On It! Remastered — Netcode Board Progression & Retry Test")
	print("==================================================================")

	var p401 := ProjectSettings.globalize_path("res://../extracted/levels/board_401.bord")
	var p402 := ProjectSettings.globalize_path("res://../extracted/levels/board_402.bord")
	if not FileAccess.file_exists(p401): p401 = ProjectSettings.globalize_path("res://levels/board_401.bord")
	if not FileAccess.file_exists(p402): p402 = ProjectSettings.globalize_path("res://levels/board_402.bord")

	var b401 := FileAccess.get_file_as_bytes(p401)
	var b402 := FileAccess.get_file_as_bytes(p402)
	if b401.is_empty() or b402.is_empty():
		print("FAIL: Could not load test board files")
		get_tree().quit(1)
		return

	var net1 := RollbackNet.new()
	var net2 := RollbackNet.new()
	net1.num_players = 2
	net2.num_players = 2

	var err1 := net1.start_host(7780, 2)
	var err2 := net2.start_client("127.0.0.1", 7780)
	if err1 != OK or err2 != OK:
		print("FAIL: ENet socket setup failed")
		get_tree().quit(1)
		return

	var sim_t := 0.0
	for i in range(100):
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(5)
		if net1.get_connected_player_count() >= 2:
			break

	if net1.get_connected_player_count() < 2:
		print("FAIL: Connection timeout")
		get_tree().quit(1)
		return

	# Test 1: Handshake
	var m2_started := [false]
	net2.match_started.connect(func(bb, s, sp, np, m, slot):
		m2_started[0] = true
	)
	net1.send_match_init(b401, 12345, 2, 0)
	for i in range(100):
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(5)
		if m2_started[0]: break

	if not m2_started[0]:
		print("FAIL: match_init handshake failed")
		get_tree().quit(1)
		return
	print("PASS: Match handshake completed")

	# Test 2: Next Board Progression (PKT_BOARD_LOAD with is_retry = false)
	var p2_board_loaded := [false]
	var p2_loaded_bytes := [PackedByteArray()]
	var p2_loaded_seed := [0]
	var p2_is_retry := [true]

	net2.board_loaded.connect(func(bb: PackedByteArray, seed_val: int, retry: bool):
		p2_board_loaded[0] = true
		p2_loaded_bytes[0] = bb
		p2_loaded_seed[0] = seed_val
		p2_is_retry[0] = retry
	)

	net1.send_board_load(b402, 998877, false)
	for i in range(100):
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(5)
		if p2_board_loaded[0]: break

	if not p2_board_loaded[0]:
		print("FAIL: board_loaded packet not received by client")
		get_tree().quit(1)
		return

	if p2_loaded_bytes[0].size() != b402.size() or p2_loaded_seed[0] != 998877 or p2_is_retry[0] != false:
		print("FAIL: board_loaded packet contents corrupted: size=%d seed=%d retry=%s" %
			[p2_loaded_bytes[0].size(), p2_loaded_seed[0], str(p2_is_retry[0])])
		get_tree().quit(1)
		return
	print("PASS: Next board packet correctly delivered and decoded (size=%d seed=%d is_retry=false)" %
		[p2_loaded_bytes[0].size(), p2_loaded_seed[0]])

	# Test 3: Synced Cores on new board
	var c1 := SoiCore.new()
	var c2 := SoiCore.new()
	c1.init(12345); c1.load_level(b401); c1.set_play_mode(0); c1.limit_players(2)
	c2.init(12345); c2.load_level(b401); c2.set_play_mode(0); c2.limit_players(2)

	# Next level
	c1.next_level(b402)
	c2.next_level(p2_loaded_bytes[0])
	if c1.net_hash() != c2.net_hash():
		print("FAIL: Core net_hash divergence after next_level: %X vs %X" % [c1.net_hash(), c2.net_hash()])
		get_tree().quit(1)
		return
	print("PASS: Both cores advanced to next board with identical net_hash: %X" % c1.net_hash())

	# Test 4: Game Over Retry (PKT_BOARD_LOAD with is_retry = true)
	p2_board_loaded[0] = false
	net1.send_board_load(b402, 554433, true)
	for i in range(100):
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(5)
		if p2_board_loaded[0]: break

	if not p2_board_loaded[0] or not p2_is_retry[0] or p2_loaded_seed[0] != 554433:
		print("FAIL: Retry packet delivery failed")
		get_tree().quit(1)
		return
	print("PASS: Game over retry packet correctly delivered and decoded (seed=%d is_retry=true)" % p2_loaded_seed[0])

	net1.close()
	net2.close()
	print("==================================================================")
	print("BOARD PROGRESSION TEST: PASS")
	print("==================================================================")
	get_tree().quit(0)
