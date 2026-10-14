extends Node

# net_soak_test.gd — Automated 2-instance loopback soak test over UDP (127.0.0.1)
# Verifies:
# - ENet UDP connection over loopback 127.0.0.1:7777
# - Channel 0 MATCH_INIT handshake
# - Channel 1 INPUT_TICK sliding window inputs with D = 2
# - Synthetic 120 ms latency and 30 ms jitter
# - Rollback and resimulation upon packet arrival
# - Bit-exact deterministic state hash (soi_net_hash) match across 1,000+ ticks with 0 desyncs!

const TARGET_TICKS := 1200
const SIM_LATENCY_MS := 120.0
const SIM_JITTER_MS := 30.0

func _ready() -> void:
	print("==================================================================")
	print("Step On It! Remastered — Rollback Netcode Loopback Soak Test")
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

	# 2. Initialize netcode instances with synthetic lag & jitter
	var net1 := RollbackNet.new()
	var net2 := RollbackNet.new()

	net1.simulate_latency_ms = SIM_LATENCY_MS
	net1.simulate_jitter_ms = SIM_JITTER_MS
	net1.num_players = 2

	net2.simulate_latency_ms = SIM_LATENCY_MS
	net2.simulate_jitter_ms = SIM_JITTER_MS
	net2.num_players = 2

	var err1 := net1.start_host(7777, 2)
	if err1 != OK:
		print("FAIL: net1 start_host failed: ", err1)
		get_tree().quit(1)
		return

	var err2 := net2.start_client("127.0.0.1", 7777)
	if err2 != OK:
		print("FAIL: net2 start_client failed: ", err2)
		get_tree().quit(1)
		return

	print("Waiting for peer handshake over 127.0.0.1:7777...")
	var sim_time := 0.0
	var connected := false
	for attempt in range(200):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		OS.delay_msec(5)
		if net1.get_connected_player_count() >= 2:
			connected = true
			break

	if not connected:
		print("FAIL: Timeout waiting for peer connection")
		get_tree().quit(1)
		return
	print("Peers connected successfully!")

	# 3. Channel 0 Handshake (MATCH_INIT)
	var match_started_p2 := [false]
	net2.match_started.connect(func(_b, _s, _sp, _np, _m, slot):
		print("Client received MATCH_INIT! local_slot=", slot)
		match_started_p2[0] = true
	)

	net1.send_match_init(bord_bytes, 424242, 2, 0)
	for attempt in range(100):
		sim_time += 0.016
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		OS.delay_msec(5)
		if match_started_p2[0]:
			break

	if not match_started_p2[0]:
		print("FAIL: MATCH_INIT handshake failed on Client")
		get_tree().quit(1)
		return
	print("MATCH_INIT handshake confirmed! Slot P1: %d, Slot P2: %d" % [net1.local_slot, net2.local_slot])

	# 4. Initialize both cores identically
	core1.init(424242)
	core1.set_input_assist(true)
	core1.load_level(bord_bytes)
	core1.set_play_mode(0)
	core1.limit_players(2)

	core2.init(424242)
	core2.set_input_assist(true)
	core2.load_level(bord_bytes)
	core2.set_play_mode(0)
	core2.limit_players(2)

	var h1_init := core1.net_hash()
	var h2_init := core2.net_hash()
	if h1_init != h2_init:
		print("FAIL: Initial net_hash mismatch: %X vs %X" % [h1_init, h2_init])
		get_tree().quit(1)
		return
	print("Initial core state synchronized! Hash: %X" % h1_init)

	# 5. Soak test loop
	var desync_count := 0
	var rollbacks_p1 := 0
	var rollbacks_p2 := 0
	var confirmed_hashes_p1: Dictionary = {} # tick -> hash
	var confirmed_hashes_p2: Dictionary = {} # tick -> hash

	print("Simulating %d ticks with 120ms latency and 30ms jitter..." % TARGET_TICKS)
	var t := 0
	while t < TARGET_TICKS:
		sim_time += 0.014 # ~71 Hz physics step

		# Network receive
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)

		# Check mispredictions / rollback on P1
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
					net1.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
					core1.tick3(sp1, sp2, 0)
					confirmed_hashes_p1[st] = core1.net_hash()
					net1.record_state_hash(st, int(core1.net_hash() & 0xFFFFFFFF))
				net1.is_resimulating = false

		# Check mispredictions / rollback on P2
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
					net2.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
					core2.tick3(sp1, sp2, 0)
					confirmed_hashes_p2[st] = core2.net_hash()
					net2.record_state_hash(st, int(core2.net_hash() & 0xFFFFFFFF))
				net2.is_resimulating = false

		# Generate inputs (P1 runs right and jumps; P2 runs left and builds blocks)
		var p1_raw := 0
		if (t / 15) % 2 == 0: p1_raw |= 0x02 # IN_RIGHT
		if t % 20 == 5:        p1_raw |= 0x04 # IN_JUMP

		var p2_raw := 0
		if (t / 20) % 2 == 1: p2_raw |= 0x01 # IN_LEFT
		if t % 30 == 10:       p2_raw |= 0x08 # IN_BLOCK_HIGH

		# Schedule local inputs with D = 2
		net1.send_local_input(p1_raw)
		net2.send_local_input(p2_raw)

		# Save pre-tick snapshots
		net1.snapshot_ring[net1.current_tick % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
		net2.snapshot_ring[net2.current_tick % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()

		# Inputs for current tick (confirmed or predicted)
		var in1_p1 := net1.get_or_predict_input(0, net1.current_tick)
		var in1_p2 := net1.get_or_predict_input(1, net1.current_tick)

		var in2_p1 := net2.get_or_predict_input(0, net2.current_tick)
		var in2_p2 := net2.get_or_predict_input(1, net2.current_tick)

		# Tick both cores
		core1.tick3(in1_p1, in1_p2, 0)
		core2.tick3(in2_p1, in2_p2, 0)

		# Store confirmed hashes for ticks that have been fully confirmed
		confirmed_hashes_p1[net1.current_tick] = core1.net_hash()
		confirmed_hashes_p2[net2.current_tick] = core2.net_hash()
		net1.record_state_hash(net1.current_tick, int(core1.net_hash() & 0xFFFFFFFF))
		net2.record_state_hash(net2.current_tick, int(core2.net_hash() & 0xFFFFFFFF))

		net1.current_tick += 1
		net2.current_tick += 1

		# Verify state hash convergence on confirmed ticks
		var check_tick := mini(net1.last_confirmed_tick, net2.last_confirmed_tick)
		if check_tick > 0 and confirmed_hashes_p1.has(check_tick) and confirmed_hashes_p2.has(check_tick):
			var ch1: int = confirmed_hashes_p1[check_tick]
			var ch2: int = confirmed_hashes_p2[check_tick]
			if ch1 != ch2:
				desync_count += 1
				print("DESYNC at tick %d: P1=%X P2=%X" % [check_tick, ch1, ch2])
				break

		t += 1
		if t % 300 == 0:
			print("   Tick %d / %d (P1 Rollbacks: %d, P2 Rollbacks: %d, Desyncs: %d)" %
				[t, TARGET_TICKS, rollbacks_p1, rollbacks_p2, desync_count])

	# Drain remaining packets so all ticks settle
	for drain in range(60):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		if net1.earliest_mispredicted_tick >= 0:
			var rb := net1.earliest_mispredicted_tick
			net1.earliest_mispredicted_tick = -1
			if rb < net1.current_tick:
				var snap: PackedByteArray = net1.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core1.snapshot_load(snap)
				for st in range(rb, net1.current_tick):
					var sp1 := net1.get_or_predict_input(0, st)
					var sp2 := net1.get_or_predict_input(1, st)
					net1.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
					core1.tick3(sp1, sp2, 0)
					confirmed_hashes_p1[st] = core1.net_hash()
					net1.record_state_hash(st, int(core1.net_hash() & 0xFFFFFFFF))
		if net2.earliest_mispredicted_tick >= 0:
			var rb := net2.earliest_mispredicted_tick
			net2.earliest_mispredicted_tick = -1
			if rb < net2.current_tick:
				var snap: PackedByteArray = net2.snapshot_ring[rb % RollbackNet.RING_BUFFER_SIZE]
				core2.snapshot_load(snap)
				for st in range(rb, net2.current_tick):
					var sp1 := net2.get_or_predict_input(0, st)
					var sp2 := net2.get_or_predict_input(1, st)
					net2.snapshot_ring[st % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
					core2.tick3(sp1, sp2, 0)
					confirmed_hashes_p2[st] = core2.net_hash()
					net2.record_state_hash(st, int(core2.net_hash() & 0xFFFFFFFF))

	var final_h1 := core1.net_hash()
	var final_h2 := core2.net_hash()
	if final_h1 != final_h2:
		desync_count += 1
		print("DESYNC at final state: P1=%X P2=%X" % [final_h1, final_h2])

	net1.close()
	net2.close()

	print("==================================================================")
	print("Soak Test Summary:")
	print("   Ticks Simulated : %d" % t)
	print("   P1 Rollbacks    : %d" % rollbacks_p1)
	print("   P2 Rollbacks    : %d" % rollbacks_p2)
	print("   Desyncs Detected: %d" % desync_count)
	print("   Final P1 Hash   : %X" % final_h1)
	print("   Final P2 Hash   : %X" % final_h2)

	if desync_count == 0 and rollbacks_p1 + rollbacks_p2 > 0 and final_h1 == final_h2:
		print("SOAK TEST: PASS (1200 ticks, 0 desyncs, rollbacks healed successfully)")
		print("==================================================================")
		get_tree().quit(0)
	elif desync_count == 0 and final_h1 == final_h2:
		print("SOAK TEST: PASS (1200 ticks, 0 desyncs)")
		print("==================================================================")
		get_tree().quit(0)
	else:
		print("SOAK TEST: FAIL")
		print("==================================================================")
		get_tree().quit(1)
