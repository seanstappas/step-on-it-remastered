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

	var p401 := Session.ext_path("levels/board_401.bord")
	var p402 := Session.ext_path("levels/board_402.bord")
	if not FileAccess.file_exists(p401): p401 = "res://levels/board_401.bord"
	if not FileAccess.file_exists(p402): p402 = "res://levels/board_402.bord"

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

	# Test 1.5: Frozen-Tick Tally PKT_META_CONFIRM & Schedule Stability (NET-01, NET-05, NET-08)
	net1.reset_for_new_board()
	net2.reset_for_new_board()
	for f in range(10):
		net1.send_local_input(0)
		net2.send_local_input(0)
		net1.current_tick += 1
		net2.current_tick += 1
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(2)

	var frozen_sched_1: int = int(net1.last_confirmed_per_peer[net1.local_slot])
	var frozen_sched_2: int = int(net2.last_confirmed_per_peer[net2.local_slot])
	# Simulate 120 frozen frames at tally screen (do NOT call send_local_input)
	for f in range(120):
		if not net1.are_all_peers_confirmed_through(net1.current_tick - 1) and int(net1.last_confirmed_per_peer[net1.local_slot]) >= 0:
			net1._send_input_packet(int(net1.last_confirmed_per_peer[net1.local_slot]))
		if not net2.are_all_peers_confirmed_through(net2.current_tick - 1) and int(net2.last_confirmed_per_peer[net2.local_slot]) >= 0:
			net2._send_input_packet(int(net2.last_confirmed_per_peer[net2.local_slot]))
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)

	if int(net1.last_confirmed_per_peer[net1.local_slot]) != frozen_sched_1 or int(net2.last_confirmed_per_peer[net2.local_slot]) != frozen_sched_2:
		print("FAIL: last_confirmed_per_peer[local_slot] drifted during frozen tally frames!")
		get_tree().quit(1)
		return

	net1.send_meta_confirm(10, 0x11223344)
	net2.send_meta_confirm(10, 0x11223344)
	for f in range(30):
		sim_t += 0.016
		net1.poll_network(sim_t)
		net2.poll_network(sim_t)
		OS.delay_msec(2)
		if net1.all_meta_confirmed() and net2.all_meta_confirmed():
			break

	if not net1.all_meta_confirmed() or not net2.all_meta_confirmed():
		print("FAIL: PKT_META_CONFIRM was not confirmed on frozen tally ticks!")
		get_tree().quit(1)
		return

	# Stale board_epoch rejection test
	net1.meta_confirmed_peers.clear()
	var stale_pkt := PackedByteArray()
	stale_pkt.resize(10)
	stale_pkt[0] = RollbackNet.PKT_META_CONFIRM
	stale_pkt[1] = (((net1.board_epoch + 5) & 0x3F) << 2) | 1
	RollbackNet.encode_be32(stale_pkt, 2, 10)
	RollbackNet.encode_be32(stale_pkt, 6, 0x11223344)
	net1._handle_meta_confirm(stale_pkt, 1)
	if net1.meta_confirmed_peers.has(1):
		print("FAIL: Stale board_epoch PKT_META_CONFIRM was accepted!")
		get_tree().quit(1)
		return

	# Mismatched terminal hash desync detection test
	var meta_desync_fired := [false]
	var cb := func(_t: int, _lh: int, _rh: int): meta_desync_fired[0] = true
	net1.desync_detected.connect(cb)
	net1.meta_confirmed_peers[0] = {"epoch": net1.board_epoch, "tick": 10, "hash": 0x11223344}
	var bad_pkt := PackedByteArray()
	bad_pkt.resize(10)
	bad_pkt[0] = RollbackNet.PKT_META_CONFIRM
	bad_pkt[1] = ((net1.board_epoch & 0x3F) << 2) | 1
	RollbackNet.encode_be32(bad_pkt, 2, 10)
	RollbackNet.encode_be32(bad_pkt, 6, 0x99999999)
	net1._handle_meta_confirm(bad_pkt, 1)
	net1.desync_detected.disconnect(cb)
	if not meta_desync_fired[0]:
		print("FAIL: Mismatched PKT_META_CONFIRM did not fire desync_detected!")
		get_tree().quit(1)
		return
	print("PASS: Frozen tally PKT_META_CONFIRM, epoch filtering, and hash verification passed")

	# Test 2: Next Board Progression (PKT_BOARD_LOAD with is_retry = false)
	var p2_board_loaded := [false]
	var p2_loaded_bytes := [PackedByteArray()]
	var p2_loaded_seed := [0]
	var p2_is_retry := [true]
	var host_board_loaded_count := [0]

	net1.board_loaded.connect(func(_bb: PackedByteArray, _seed_val: int, _retry: bool):
		host_board_loaded_count[0] += 1
	)

	net2.board_loaded.connect(func(bb: PackedByteArray, seed_val: int, retry: bool):
		p2_board_loaded[0] = true
		p2_loaded_bytes[0] = bb
		p2_loaded_seed[0] = seed_val
		p2_is_retry[0] = retry
	)

	net1.send_board_load(b402, 998877, false, true)
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

	if p2_loaded_bytes[0].size() != b402.size() or p2_loaded_seed[0] != 998877 or p2_is_retry[0] != false or not net2.last_board_was_challenge_fail:
		print("FAIL: board_loaded packet contents corrupted: size=%d seed=%d retry=%s cfail=%s" %
			[p2_loaded_bytes[0].size(), p2_loaded_seed[0], str(p2_is_retry[0]), str(net2.last_board_was_challenge_fail)])
		get_tree().quit(1)
		return
	print("PASS: Next board packet correctly delivered and decoded (size=%d seed=%d is_retry=false cfail=true)" %
		[p2_loaded_bytes[0].size(), p2_loaded_seed[0]])

	if host_board_loaded_count[0] != 0:
		print("FAIL: Host emitted board_loaded during send_board_load!")
		get_tree().quit(1)
		return
	print("PASS: Host did not double-fire board_loaded")

	# Test 3: Synced Cores on new board from divergent prior seeds (NET-02) & rollback stop at level_complete (NET-03)
	var c1 := SoiCore.new()
	var c2 := SoiCore.new()
	c1.init(11111); c1.load_level(b401); c1.set_play_mode(0); c1.limit_players(2)
	c2.init(22222); c2.load_level(b401); c2.set_play_mode(0); c2.limit_players(2)

	# Next level with synchronized seed
	c1.set_seed(p2_loaded_seed[0])
	c2.set_seed(p2_loaded_seed[0])
	c1.next_level(b402)
	c2.next_level(p2_loaded_bytes[0])
	if c1.net_hash() != c2.net_hash():
		print("FAIL: Core net_hash divergence after set_seed + next_level: %X vs %X" % [c1.net_hash(), c2.net_hash()])
		get_tree().quit(1)
		return
	print("PASS: Both cores converged from divergent seeds to identical net_hash after set_seed + next_level: %X" % c1.net_hash())

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
