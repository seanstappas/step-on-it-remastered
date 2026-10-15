extends Node

# test_net_edge_cases.gd — Adversarial Unit & Integration Test Suite for:
# 1. Join Code encoding & decoding vectors across all IPv4 classes and invalid strings.
# 2. 3-Player mid-match peer drop (P3 disconnects mid-game; P1 & P2 continue with 0 desyncs and 0 stalls).
# 3. 2-Player peer disconnect unblocking (P2 disconnects; P1 unblocks immediately).
# 4. Host disconnect handling on Client (Host disconnects; client receives peer_disconnected(0) and unblocks).

func _ready() -> void:
	print("==================================================================")
	print("Step On It! Remastered — Netcode Edge Cases & Disconnect Test")
	print("==================================================================")

	var failures := 0

	# -------------------------------------------------------------------------
	# 1. Join Code Unit Tests
	# -------------------------------------------------------------------------
	print("\n--- Test Suite 1: Join Code Encoding & Decoding ---")
	var vectors := [
		["127.0.0.1", "SOI-3Z000-027K1"],
		["10.0.0.1", "SOI-0A000-027K1"],
		["192.168.1.100", "SOI-60N00-P87K1"],
		["172.16.254.1", "SOI-5C23Z-027K1"],
		["0.0.0.0", "SOI-00000-007K1"],
		["255.255.255.255", "SOI-7ZZZZ-ZY7K1"],
	]

	for v in vectors:
		var ip: String = v[0]
		var expected_code: String = v[1]
		var code := RollbackNet.ip_to_join_code(ip)
		if code != expected_code:
			print("FAIL: ip_to_join_code(%s) = %s, expected %s" % [ip, code, expected_code])
			failures += 1
		var decoded_ip := RollbackNet.join_code_to_ip(code)
		if decoded_ip != ip:
			print("FAIL: join_code_to_ip(%s) = %s, expected %s" % [code, decoded_ip, ip])
			failures += 1

	# Edge case: plain IPs must NOT be treated as Join Codes
	var plain_ips := ["10.0.0.1", "1.2.3.4", "10.1.2.3", "0.0.0.0"]
	for ip_str in plain_ips:
		var res := RollbackNet.join_code_to_ip(ip_str)
		if res != "":
			print("FAIL: join_code_to_ip('%s') returned '%s' instead of empty string!" % [ip_str, res])
			failures += 1
		else:
			print("PASS: plain IP '%s' correctly rejected as Join Code" % ip_str)

	# Invalid strings / non-Crockford
	var invalid_codes := ["SOI-UUUUU-UUUUU", "NOTAHEX!", "12-34-56", "SOI-123", "SOI-1234-5678-9999"]
	for inv in invalid_codes:
		var res := RollbackNet.join_code_to_ip(inv)
		if res != "":
			print("FAIL: join_code_to_ip('%s') returned '%s' instead of empty string!" % [inv, res])
			failures += 1

	# Case insensitivity, whitespace tolerance and Crockford aliases (O->0, I->1, L->1)
	if RollbackNet.join_code_to_ip("soi-3z000-027k1") != "127.0.0.1":
		print("FAIL: Lowercase join code failed to decode")
		failures += 1
	if RollbackNet.join_code_to_ip("SOI - 3Z000 - 027K1") != "127.0.0.1":
		print("FAIL: Spaced join code failed to decode")
		failures += 1
	if RollbackNet.join_code_to_ip("SOI-3ZOOO-027K1") != "127.0.0.1":
		print("FAIL: O->0 Crockford alias failed to decode")
		failures += 1
	if RollbackNet.join_code_to_ip("SOI-3Z000-027KI") != "127.0.0.1":
		print("FAIL: I->1 Crockford alias failed to decode")
		failures += 1
	if RollbackNet.join_code_to_ip("SOI-3Z000-027KL") != "127.0.0.1":
		print("FAIL: L->1 Crockford alias failed to decode")
		failures += 1

	# Legacy 8-char hex compatibility
	if RollbackNet.join_code_to_ip("SOI-7F00-0001") != "127.0.0.1":
		print("FAIL: Legacy 8-char hex join code failed to decode")
		failures += 1

	# ip_to_join_code error handling
	if RollbackNet.ip_to_join_code("not.an.ip") != "SOI-00000-00000":
		print("FAIL: Non-ip string didn't fallback to SOI-00000-00000")
		failures += 1
	if RollbackNet.ip_to_join_code("256.0.0.1") != "SOI-00000-00000":
		print("FAIL: Out of range IP byte didn't fallback to SOI-00000-00000")
		failures += 1

	print("Join Code unit tests completed (Failures: %d)" % failures)
	if failures > 0:
		get_tree().quit(1)
		return

	# Load test board bytes
	var bord_path := ProjectSettings.globalize_path("res://../extracted/levels/board_401.bord")
	if not FileAccess.file_exists(bord_path):
		bord_path = ProjectSettings.globalize_path("res://levels/board_401.bord")
	var bord_bytes := FileAccess.get_file_as_bytes(bord_path)
	if bord_bytes.is_empty():
		print("FAIL: Could not load board_401.bord")
		get_tree().quit(1)
		return

	# -------------------------------------------------------------------------
	# 2. Integration Test: 3-Player Mid-Match Peer Drop (P3 drops, P1 & P2 heal)
	# -------------------------------------------------------------------------
	print("\n--- Test Suite 2: 3-Player Mid-Match Peer Drop & Star-Hub Relay ---")
	var core1 := SoiCore.new()
	var core2 := SoiCore.new()
	var core3 := SoiCore.new()

	var net1 := RollbackNet.new()
	var net2 := RollbackNet.new()
	var net3 := RollbackNet.new()

	net1.num_players = 3
	net2.num_players = 3
	net3.num_players = 3

	net1.simulate_latency_ms = 40.0
	net2.simulate_latency_ms = 40.0
	net3.simulate_latency_ms = 40.0

	var port_3p := 7781
	var e1 := net1.start_host(port_3p, 3)
	var e2 := net2.start_client("127.0.0.1", port_3p)
	var e3 := net3.start_client("127.0.0.1", port_3p)
	if e1 != OK or e2 != OK or e3 != OK:
		print("FAIL: Failed to start 3P network instances: %d, %d, %d" % [e1, e2, e3])
		get_tree().quit(1)
		return

	var sim_time := 0.0
	for attempt in range(200):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)
		OS.delay_msec(5)
		if net1.get_connected_player_count() >= 3:
			break

	if net1.get_connected_player_count() < 3:
		print("FAIL: 3P connection timeout")
		get_tree().quit(1)
		return

	var m_started := [false, false]
	net2.match_started.connect(func(_b, _s, _sp, _np, _m, _sl): m_started[0] = true)
	net3.match_started.connect(func(_b, _s, _sp, _np, _m, _sl): m_started[1] = true)
	net1.send_match_init(bord_bytes, 12345, 2, 0)

	for attempt in range(100):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)
		OS.delay_msec(5)
		if m_started[0] and m_started[1]:
			break

	for c in [core1, core2, core3]:
		c.init(12345)
		c.load_level(bord_bytes)
		c.set_play_mode(0)
		c.limit_players(3)

	var p2_notified_p3_drop := [false]
	net2.peer_disconnected.connect(func(slot: int) -> void:
		if slot == 2:
			p2_notified_p3_drop[0] = true
	)

	print("Simulating 300 ticks with all 3 players active...")
	for t in range(300):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)

		# Rollbacks
		for pair in [[net1, core1], [net2, core2], [net3, core3]]:
			var net_inst: RollbackNet = pair[0]
			var c_inst: SoiCore = pair[1]
			if net_inst.earliest_mispredicted_tick >= 0:
				var rb: int = net_inst.earliest_mispredicted_tick
				net_inst.earliest_mispredicted_tick = -1
				if rb < net_inst.current_tick:
					var snap: PackedByteArray = net_inst.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
					c_inst.snapshot_load(snap)
					net_inst.is_resimulating = true
					for st in range(rb, net_inst.current_tick):
						var sp1: int = net_inst.get_or_predict_input(0, st)
						var sp2: int = net_inst.get_or_predict_input(1, st)
						var sp3: int = net_inst.get_or_predict_input(2, st)
						net_inst.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = c_inst.snapshot_save()
						c_inst.tick3(sp1, sp2, sp3)
						net_inst.record_state_hash(st, int(c_inst.net_hash() & 0xFFFFFFFF))
					net_inst.is_resimulating = false

		# Step inputs
		net1.send_local_input(2 if (t & 1) else 1)
		net2.send_local_input(4 if (t & 2) else 0)
		net3.send_local_input(1 if (t & 4) else 0)

		net1.snapshot_ring[net1.current_tick % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
		net2.snapshot_ring[net2.current_tick % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
		net3.snapshot_ring[net3.current_tick % RollbackNet.RING_BUFFER_SIZE] = core3.snapshot_save()

		core1.tick3(net1.get_or_predict_input(0, net1.current_tick), net1.get_or_predict_input(1, net1.current_tick), net1.get_or_predict_input(2, net1.current_tick))
		core2.tick3(net2.get_or_predict_input(0, net2.current_tick), net2.get_or_predict_input(1, net2.current_tick), net2.get_or_predict_input(2, net2.current_tick))
		core3.tick3(net3.get_or_predict_input(0, net3.current_tick), net3.get_or_predict_input(1, net3.current_tick), net3.get_or_predict_input(2, net3.current_tick))

		net1.record_state_hash(net1.current_tick, int(core1.net_hash() & 0xFFFFFFFF))
		net2.record_state_hash(net2.current_tick, int(core2.net_hash() & 0xFFFFFFFF))
		net3.record_state_hash(net3.current_tick, int(core3.net_hash() & 0xFFFFFFFF))

		net1.current_tick += 1
		net2.current_tick += 1
		net3.current_tick += 1

	print("At tick 300: Simulating sudden drop/disconnect of Player 3...")
	net3.close()

	# Process disconnect on P1 and forward PKT_DROP_PEER to P2
	for attempt in range(50):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		OS.delay_msec(2)
		if net1.dropped_peers.has(2) and p2_notified_p3_drop[0]:
			break

	if not net1.dropped_peers.has(2):
		print("FAIL: Host did not register P3 drop!")
		failures += 1
	else:
		print("PASS: Host correctly registered P3 in dropped_peers!")

	if not p2_notified_p3_drop[0]:
		print("FAIL: P2 did not receive PKT_DROP_PEER for P3!")
		failures += 1
	else:
		print("PASS: P2 successfully received Star-Hub forwarded PKT_DROP_PEER for P3!")

	var desyncs_detected := [0]
	net1.desync_detected.connect(func(tk, lh, rh):
		print("DESYNC on Net1 tick %d: local %X != remote %X" % [tk, lh, rh])
		desyncs_detected[0] += 1
	)
	net2.desync_detected.connect(func(tk, lh, rh):
		print("DESYNC on Net2 tick %d: local %X != remote %X" % [tk, lh, rh])
		desyncs_detected[0] += 1
	)

	print("Continuing simulation for 400 more ticks between P1 and P2 with P3 dropped...")
	for t in range(300, 700):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)

		for pair in [[net1, core1], [net2, core2]]:
			var net_inst: RollbackNet = pair[0]
			var c_inst: SoiCore = pair[1]
			if net_inst.earliest_mispredicted_tick >= 0:
				var rb: int = net_inst.earliest_mispredicted_tick
				net_inst.earliest_mispredicted_tick = -1
				if rb < net_inst.current_tick:
					var snap: PackedByteArray = net_inst.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
					c_inst.snapshot_load(snap)
					net_inst.is_resimulating = true
					for st in range(rb, net_inst.current_tick):
						var sp1: int = net_inst.get_or_predict_input(0, st)
						var sp2: int = net_inst.get_or_predict_input(1, st)
						var sp3: int = net_inst.get_or_predict_input(2, st)
						net_inst.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = c_inst.snapshot_save()
						c_inst.tick3(sp1, sp2, sp3)
						net_inst.record_state_hash(st, int(c_inst.net_hash() & 0xFFFFFFFF))
					net_inst.is_resimulating = false

		# Neither P1 nor P2 should enter Rift Stall!
		if net1.check_rift_stall() or net2.check_rift_stall():
			print("FAIL: Unexpected Rift Stall occurred on tick %d after peer drop!" % t)
			failures += 1
			break

		net1.send_local_input(2 if (t & 1) else 1)
		net2.send_local_input(4 if (t & 2) else 0)

		net1.snapshot_ring[net1.current_tick % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
		net2.snapshot_ring[net2.current_tick % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()

		var in1_0 := net1.get_or_predict_input(0, net1.current_tick)
		var in1_1 := net1.get_or_predict_input(1, net1.current_tick)
		var in1_2 := net1.get_or_predict_input(2, net1.current_tick)

		var in2_0 := net2.get_or_predict_input(0, net2.current_tick)
		var in2_1 := net2.get_or_predict_input(1, net2.current_tick)
		var in2_2 := net2.get_or_predict_input(2, net2.current_tick)

		core1.tick3(in1_0, in1_1, in1_2)
		core2.tick3(in2_0, in2_1, in2_2)

		net1.record_state_hash(net1.current_tick, int(core1.net_hash() & 0xFFFFFFFF))
		net2.record_state_hash(net2.current_tick, int(core2.net_hash() & 0xFFFFFFFF))

		net1.current_tick += 1
		net2.current_tick += 1

	# Drain remaining in-flight packets so all rollbacks finalize
	for drain in range(60):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		for pair in [[net1, core1], [net2, core2]]:
			var net_inst: RollbackNet = pair[0]
			var c_inst: SoiCore = pair[1]
			if net_inst.earliest_mispredicted_tick >= 0:
				var rb: int = net_inst.earliest_mispredicted_tick
				net_inst.earliest_mispredicted_tick = -1
				if rb < net_inst.current_tick:
					var snap: PackedByteArray = net_inst.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
					c_inst.snapshot_load(snap)
					for st in range(rb, net_inst.current_tick):
						var sp1: int = net_inst.get_or_predict_input(0, st)
						var sp2: int = net_inst.get_or_predict_input(1, st)
						var sp3: int = net_inst.get_or_predict_input(2, st)
						net_inst.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = c_inst.snapshot_save()
						c_inst.tick3(sp1, sp2, sp3)
						net_inst.record_state_hash(st, int(c_inst.net_hash() & 0xFFFFFFFF))

	if desyncs_detected[0] > 0 or core1.net_hash() != core2.net_hash():
		print("FAIL: Desync detected between P1 and P2! Net1 hash: %X, Net2 hash: %X, Desync events: %d" % [
			core1.net_hash(), core2.net_hash(), desyncs_detected[0]
		])
		failures += 1
	else:
		print("PASS: P1 and P2 simulated 400 ticks after P3 drop with 0 desyncs and 0 stalls! Final hash: %X" % core1.net_hash())

	net1.close()
	net2.close()

	# -------------------------------------------------------------------------
	# 3. Integration Test: 2-Player Disconnect Unblocking (P2 drops -> P1 unblocks)
	# -------------------------------------------------------------------------
	print("\n--- Test Suite 3: 2-Player Disconnect Unblocking ---")
	var net_2p_host := RollbackNet.new()
	var net_2p_client := RollbackNet.new()
	net_2p_host.num_players = 2
	net_2p_client.num_players = 2

	var port_2p := 7782
	net_2p_host.start_host(port_2p, 2)
	net_2p_client.start_client("127.0.0.1", port_2p)

	for attempt in range(100):
		sim_time += 0.016
		net_2p_host.poll_network(sim_time)
		net_2p_client.poll_network(sim_time)
		OS.delay_msec(5)
		if net_2p_host.get_connected_player_count() >= 2:
			break

	var p1_notified_p2_drop := [false]
	net_2p_host.peer_disconnected.connect(func(slot: int) -> void:
		if slot == 1:
			p1_notified_p2_drop[0] = true
	)

	# Simulate P2 dropping
	net_2p_client.close()

	for attempt in range(50):
		sim_time += 0.016
		net_2p_host.poll_network(sim_time)
		OS.delay_msec(2)
		if p1_notified_p2_drop[0]:
			break

	if not p1_notified_p2_drop[0]:
		print("FAIL: Host did not receive peer_disconnected signal for P2!")
		failures += 1
	else:
		print("PASS: Host received peer_disconnected for P2")

	if net_2p_host.get_active_remote_peer_count() != 0:
		print("FAIL: get_active_remote_peer_count should be 0, got %d" % net_2p_host.get_active_remote_peer_count())
		failures += 1
	else:
		print("PASS: Active remote peer count is 0")

	if net_2p_host.check_rift_stall():
		print("FAIL: check_rift_stall should return false when all remote peers dropped!")
		failures += 1
	else:
		print("PASS: check_rift_stall returned false (unblocked cleanly)")

	net_2p_host.close()

	# -------------------------------------------------------------------------
	# 4. Integration Test: Host Disconnect on Client
	# -------------------------------------------------------------------------
	print("\n--- Test Suite 4: Host Disconnect on Client ---")
	var host_h := RollbackNet.new()
	var client_c := RollbackNet.new()
	host_h.num_players = 2
	client_c.num_players = 2

	var port_hc := 7783
	host_h.start_host(port_hc, 2)
	client_c.start_client("127.0.0.1", port_hc)

	for attempt in range(100):
		sim_time += 0.016
		host_h.poll_network(sim_time)
		client_c.poll_network(sim_time)
		OS.delay_msec(5)
		if host_h.get_connected_player_count() >= 2:
			break

	var client_notified_host_drop := [false]
	client_c.peer_disconnected.connect(func(slot: int) -> void:
		if slot == 0:
			client_notified_host_drop[0] = true
	)

	# Host disconnects
	host_h.close()

	for attempt in range(50):
		sim_time += 0.016
		client_c.poll_network(sim_time)
		OS.delay_msec(2)
		if client_notified_host_drop[0]:
			break

	if not client_notified_host_drop[0]:
		print("FAIL: Client was not notified of host disconnect (slot 0)!")
		failures += 1
	else:
		print("PASS: Client successfully received peer_disconnected(0) on host drop")

	if client_c.check_rift_stall():
		print("FAIL: Client stalled after host disconnect!")
		failures += 1
	else:
		print("PASS: Client unblocked with no rift stall")

	client_c.close()

	print("==================================================================")
	if failures == 0:
		print("EDGE CASES TEST: PASS (All join code, disconnect, and drop tests passed!)")
		print("==================================================================")
		get_tree().quit(0)
	else:
		print("EDGE CASES TEST: FAIL (%d test failures)" % failures)
		print("==================================================================")
		get_tree().quit(1)
