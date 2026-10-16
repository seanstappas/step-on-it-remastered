extends Node

# test_net_adversarial.gd — Adversarial Multi-Peer Rollback Test
# Tests:
# 1. 3-Player Star-Hub Forwarding (P1 host, P2 client, P3 client).
#    P2 and P3 communicate ONLY through P1 (no direct P2 <-> P3 socket).
# 2. Asymmetric Latency & Jitter:
#    - P1: 0 ms
#    - P2: 60 ms lag, 15 ms jitter, 10% packet loss
#    - P3: 120 ms lag, 30 ms jitter, 15% packet loss
# 3. 1,500 simulation ticks with continuous active input generation across all 3 players.
# 4. Verifies 0 state hash desyncs across all 3 peers.

const TARGET_TICKS := 1500

func _ready() -> void:
	print("==================================================================")
	print("Step On It! Remastered — Adversarial 3-Player Rollback Soak Test")
	print("==================================================================")

	var bord_path := ProjectSettings.globalize_path("res://../extracted/levels/board_401.bord")
	if not FileAccess.file_exists(bord_path):
		bord_path = ProjectSettings.globalize_path("res://levels/board_401.bord")
	var bord_bytes := FileAccess.get_file_as_bytes(bord_path)
	if bord_bytes.is_empty():
		print("FAIL: Could not load board_401.bord")
		get_tree().quit(1)
		return

	# 1. Initialize cores
	var core1 := SoiCore.new()
	var core2 := SoiCore.new()
	var core3 := SoiCore.new()

	# 2. Initialize 3 rollback net instances
	var net1 := RollbackNet.new() # P1 Host
	var net2 := RollbackNet.new() # P2 Client
	var net3 := RollbackNet.new() # P3 Client

	net1.num_players = 3
	net1.simulate_latency_ms = 80.0
	net1.simulate_jitter_ms = 20.0
	net1.simulate_packet_loss = 0.10

	net2.num_players = 3
	net2.simulate_latency_ms = 100.0
	net2.simulate_jitter_ms = 25.0
	net2.simulate_packet_loss = 0.12 # 12% loss

	net3.num_players = 3
	net3.simulate_latency_ms = 140.0
	net3.simulate_jitter_ms = 35.0
	net3.simulate_packet_loss = 0.15 # 15% loss

	var err1 := net1.start_host(7779, 3) # use port 7779
	if err1 != OK:
		print("FAIL: net1 start_host failed: ", err1)
		get_tree().quit(1)
		return

	var err2 := net2.start_client("127.0.0.1", 7779)
	var err3 := net3.start_client("127.0.0.1", 7779)
	if err2 != OK or err3 != OK:
		print("FAIL: net2 or net3 start_client failed: ", err2, " / ", err3)
		get_tree().quit(1)
		return

	print("Waiting for 3 peers to connect over 127.0.0.1:7779...")
	var sim_time := 0.0
	var connected := false
	for attempt in range(300):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)
		OS.delay_msec(5)
		if net1.get_connected_player_count() >= 3:
			connected = true
			break

	if not connected:
		print("FAIL: Timeout waiting for 3 peers connection. Connected count=", net1.get_connected_player_count())
		get_tree().quit(1)
		return
	print("All 3 peers connected successfully!")

	# 3. Channel 0 Handshake (MATCH_INIT)
	var match_started := [false, false] # [P2, P3]
	net2.match_started.connect(func(_b, _s, _sp, _np, _m, slot):
		print("P2 received MATCH_INIT! local_slot=", slot)
		match_started[0] = true
	)
	net3.match_started.connect(func(_b, _s, _sp, _np, _m, slot):
		print("P3 received MATCH_INIT! local_slot=", slot)
		match_started[1] = true
	)

	net1.send_match_init(bord_bytes, 777777, 2, 0)
	for attempt in range(150):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)
		OS.delay_msec(5)
		if match_started[0] and match_started[1]:
			break

	if not (match_started[0] and match_started[1]):
		print("FAIL: MATCH_INIT handshake failed! P2=%s, P3=%s" % [match_started[0], match_started[1]])
		get_tree().quit(1)
		return

	print("Handshake confirmed! Slots: P1=%d, P2=%d, P3=%d" % [net1.local_slot, net2.local_slot, net3.local_slot])
	if net1.local_slot != 0 or net2.local_slot != 1 or net3.local_slot != 2:
		print("FAIL: Slot assignments incorrect! Expected 0, 1, 2, got %d, %d, %d" % [net1.local_slot, net2.local_slot, net3.local_slot])
		get_tree().quit(1)
		return

	# 4. Initialize all 3 cores identically
	for core in [core1, core2, core3]:
		core.init(777777)
		core.set_input_assist(true)
		core.load_level(bord_bytes)
		core.set_play_mode(2)
		core.spawn_player3()
		core.limit_players(3)

	var h1 := core1.net_hash()
	var h2 := core2.net_hash()
	var h3 := core3.net_hash()
	if h1 != h2 or h1 != h3:
		print("FAIL: Initial net_hash mismatch: %X vs %X vs %X" % [h1, h2, h3])
		get_tree().quit(1)
		return
	print("Initial core state synchronized across 3 cores! Hash: %X" % h1)

	# 5. Adversarial simulation loop
	var desync_count := 0
	var rollbacks_p1 := 0
	var rollbacks_p2 := 0
	var rollbacks_p3 := 0
	var confirmed_hashes_p1: Dictionary = {}
	var confirmed_hashes_p2: Dictionary = {}
	var confirmed_hashes_p3: Dictionary = {}

	print("Simulating %d ticks with Star-Hub forwarding, asymmetric lag, and packet loss..." % TARGET_TICKS)
	var t := 0
	while t < TARGET_TICKS:
		sim_time += 0.014

		# Network receive
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)

		# Rollback on P1
		if net1.earliest_mispredicted_tick >= 0:
			var rb := net1.earliest_mispredicted_tick
			net1.earliest_mispredicted_tick = -1
			if rb < net1.current_tick:
				rollbacks_p1 += 1
				var snap: PackedByteArray = net1.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core1.snapshot_load(snap)
				net1.is_resimulating = true
				for st in range(rb, net1.current_tick):
					var sp1 := net1.get_or_predict_input(0, st)
					var sp2 := net1.get_or_predict_input(1, st)
					var sp3 := net1.get_or_predict_input(2, st)
					net1.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
					core1.tick3(sp1, sp2, sp3)
					confirmed_hashes_p1[st] = core1.net_hash()
					net1.record_state_hash(st, int(core1.net_hash() & 0xFFFFFFFF))
				net1.is_resimulating = false

		# Rollback on P2
		if net2.earliest_mispredicted_tick >= 0:
			var rb := net2.earliest_mispredicted_tick
			net2.earliest_mispredicted_tick = -1
			if rb < net2.current_tick:
				rollbacks_p2 += 1
				var snap: PackedByteArray = net2.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core2.snapshot_load(snap)
				net2.is_resimulating = true
				for st in range(rb, net2.current_tick):
					var sp1 := net2.get_or_predict_input(0, st)
					var sp2 := net2.get_or_predict_input(1, st)
					var sp3 := net2.get_or_predict_input(2, st)
					net2.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
					core2.tick3(sp1, sp2, sp3)
					confirmed_hashes_p2[st] = core2.net_hash()
					net2.record_state_hash(st, int(core2.net_hash() & 0xFFFFFFFF))
				net2.is_resimulating = false

		# Rollback on P3
		if net3.earliest_mispredicted_tick >= 0:
			var rb := net3.earliest_mispredicted_tick
			net3.earliest_mispredicted_tick = -1
			if rb < net3.current_tick:
				rollbacks_p3 += 1
				var snap: PackedByteArray = net3.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core3.snapshot_load(snap)
				net3.is_resimulating = true
				for st in range(rb, net3.current_tick):
					var sp1 := net3.get_or_predict_input(0, st)
					var sp2 := net3.get_or_predict_input(1, st)
					var sp3 := net3.get_or_predict_input(2, st)
					net3.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core3.snapshot_save()
					core3.tick3(sp1, sp2, sp3)
					confirmed_hashes_p3[st] = core3.net_hash()
					net3.record_state_hash(st, int(core3.net_hash() & 0xFFFFFFFF))
				net3.is_resimulating = false

		# Generate inputs for all 3 players
		var p1_raw := 0
		if (t / 15) % 2 == 0: p1_raw |= 0x02 # IN_RIGHT
		if t % 20 == 5:        p1_raw |= 0x04 # IN_JUMP

		var p2_raw := 0
		if (t / 20) % 2 == 1: p2_raw |= 0x01 # IN_LEFT
		if t % 30 == 10:       p2_raw |= 0x08 # IN_BLOCK_HIGH

		var p3_raw := 0
		if (t / 25) % 2 == 0: p3_raw |= 0x02 # IN_RIGHT
		if t % 35 == 12:       p3_raw |= 0x10 # IN_BLOCK_LOW

		# Schedule local inputs with D = 2
		net1.send_local_input(p1_raw)
		net2.send_local_input(p2_raw)
		net3.send_local_input(p3_raw)

		# Save pre-tick snapshots
		net1.snapshot_ring[net1.current_tick % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
		net2.snapshot_ring[net2.current_tick % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
		net3.snapshot_ring[net3.current_tick % RollbackNet.RING_BUFFER_SIZE] = core3.snapshot_save()

		# Inputs for current tick
		var in1_p1 := net1.get_or_predict_input(0, net1.current_tick)
		var in1_p2 := net1.get_or_predict_input(1, net1.current_tick)
		var in1_p3 := net1.get_or_predict_input(2, net1.current_tick)

		var in2_p1 := net2.get_or_predict_input(0, net2.current_tick)
		var in2_p2 := net2.get_or_predict_input(1, net2.current_tick)
		var in2_p3 := net2.get_or_predict_input(2, net2.current_tick)

		var in3_p1 := net3.get_or_predict_input(0, net3.current_tick)
		var in3_p2 := net3.get_or_predict_input(1, net3.current_tick)
		var in3_p3 := net3.get_or_predict_input(2, net3.current_tick)

		# Tick all cores
		core1.tick3(in1_p1, in1_p2, in1_p3)
		core2.tick3(in2_p1, in2_p2, in2_p3)
		core3.tick3(in3_p1, in3_p2, in3_p3)

		confirmed_hashes_p1[net1.current_tick] = core1.net_hash()
		confirmed_hashes_p2[net2.current_tick] = core2.net_hash()
		confirmed_hashes_p3[net3.current_tick] = core3.net_hash()

		net1.record_state_hash(net1.current_tick, int(core1.net_hash() & 0xFFFFFFFF))
		net2.record_state_hash(net2.current_tick, int(core2.net_hash() & 0xFFFFFFFF))
		net3.record_state_hash(net3.current_tick, int(core3.net_hash() & 0xFFFFFFFF))

		net1.current_tick += 1
		net2.current_tick += 1
		net3.current_tick += 1

		# Verify state hash convergence across all 3
		var check_tick := mini(net1.last_confirmed_tick, mini(net2.last_confirmed_tick, net3.last_confirmed_tick))
		if check_tick > 0 and confirmed_hashes_p1.has(check_tick) and confirmed_hashes_p2.has(check_tick) and confirmed_hashes_p3.has(check_tick):
			var ch1: int = confirmed_hashes_p1[check_tick]
			var ch2: int = confirmed_hashes_p2[check_tick]
			var ch3: int = confirmed_hashes_p3[check_tick]
			if ch1 != ch2 or ch1 != ch3:
				desync_count += 1
				print("DESYNC at tick %d: P1=%X P2=%X P3=%X" % [check_tick, ch1, ch2, ch3])
				break

		t += 1
		if t % 300 == 0:
			print("   Tick %d / %d (Rollbacks: P1=%d, P2=%d, P3=%d, Desyncs=%d)" %
				[t, TARGET_TICKS, rollbacks_p1, rollbacks_p2, rollbacks_p3, desync_count])

	# Drain remaining packets (disable loss during drain so all packets arrive)
	net1.simulate_packet_loss = 0.0
	net2.simulate_packet_loss = 0.0
	net3.simulate_packet_loss = 0.0

	for drain in range(120):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)

		# Drain rollback P1
		if net1.earliest_mispredicted_tick >= 0:
			var rb := net1.earliest_mispredicted_tick
			net1.earliest_mispredicted_tick = -1
			if rb < net1.current_tick:
				var snap: PackedByteArray = net1.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core1.snapshot_load(snap)
				for st in range(rb, net1.current_tick):
					var sp1 := net1.get_or_predict_input(0, st)
					var sp2 := net1.get_or_predict_input(1, st)
					var sp3 := net1.get_or_predict_input(2, st)
					net1.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
					core1.tick3(sp1, sp2, sp3)
					confirmed_hashes_p1[st] = core1.net_hash()
					net1.record_state_hash(st, int(core1.net_hash() & 0xFFFFFFFF))

		# Drain rollback P2
		if net2.earliest_mispredicted_tick >= 0:
			var rb := net2.earliest_mispredicted_tick
			net2.earliest_mispredicted_tick = -1
			if rb < net2.current_tick:
				var snap: PackedByteArray = net2.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core2.snapshot_load(snap)
				for st in range(rb, net2.current_tick):
					var sp1 := net2.get_or_predict_input(0, st)
					var sp2 := net2.get_or_predict_input(1, st)
					var sp3 := net2.get_or_predict_input(2, st)
					net2.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
					core2.tick3(sp1, sp2, sp3)
					confirmed_hashes_p2[st] = core2.net_hash()
					net2.record_state_hash(st, int(core2.net_hash() & 0xFFFFFFFF))

		# Drain rollback P3
		if net3.earliest_mispredicted_tick >= 0:
			var rb := net3.earliest_mispredicted_tick
			net3.earliest_mispredicted_tick = -1
			if rb < net3.current_tick:
				var snap: PackedByteArray = net3.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core3.snapshot_load(snap)
				for st in range(rb, net3.current_tick):
					var sp1 := net3.get_or_predict_input(0, st)
					var sp2 := net3.get_or_predict_input(1, st)
					var sp3 := net3.get_or_predict_input(2, st)
					net3.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core3.snapshot_save()
					core3.tick3(sp1, sp2, sp3)
					confirmed_hashes_p3[st] = core3.net_hash()
					net3.record_state_hash(st, int(core3.net_hash() & 0xFFFFFFFF))

	var final_h1 := core1.net_hash()
	var final_h2 := core2.net_hash()
	var final_h3 := core3.net_hash()
	if final_h1 != final_h2 or final_h1 != final_h3:
		desync_count += 1
		print("DESYNC at final state: P1=%X P2=%X P3=%X" % [final_h1, final_h2, final_h3])

	net1.close()
	net2.close()
	net3.close()

	print("==================================================================")
	print("3-Player Adversarial Summary:")
	print("   Ticks Simulated : %d" % t)
	print("   P1 Rollbacks    : %d" % rollbacks_p1)
	print("   P2 Rollbacks    : %d" % rollbacks_p2)
	print("   P3 Rollbacks    : %d" % rollbacks_p3)
	print("   Desyncs Detected: %d" % desync_count)
	print("   Final P1 Hash   : %X" % final_h1)
	print("   Final P2 Hash   : %X" % final_h2)
	print("   Final P3 Hash   : %X" % final_h3)

	if desync_count == 0 and rollbacks_p2 + rollbacks_p3 > 0 and final_h1 == final_h2 and final_h1 == final_h3:
		print("ADVERSARIAL 3P TEST: PASS (1500 ticks, 3 players, 0 desyncs, rollbacks healed successfully)")
		print("==================================================================")
		get_tree().quit(0)
	else:
		print("ADVERSARIAL 3P TEST: FAIL")
		print("==================================================================")
		get_tree().quit(1)
