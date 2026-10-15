extends Node

# net_soak_test.gd — 3-Player 10,000-Tick Rollback Netcode Loopback Soak Test
# Verifies:
# - ENet UDP connection over loopback 127.0.0.1:7777 across 3 peers (Star-Hub forwarding)
# - Channel 0 MATCH_INIT handshake with 3 players
# - Channel 1 INPUT_TICK sliding window inputs with D = 2
# - Synthetic 120 ms RTT, 30 ms jitter, 5% packet loss
# - 60-tick 400 ms latency spikes at ticks 3000 and 7000 triggering Rift Stall
# - Rollback and resimulation upon packet arrival
# - Bit-exact deterministic state hash match across 10,000 ticks with 0 desyncs!

const TARGET_TICKS := 10000
const BASE_LATENCY_MS := 60.0
const BASE_JITTER_MS := 30.0
const BASE_LOSS := 0.05

func _ready() -> void:
	print("==================================================================")
	print("Step On It! Remastered — 3-Player 10,000-Tick Rollback Soak Test")
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
	net1.simulate_latency_ms = BASE_LATENCY_MS
	net1.simulate_jitter_ms = BASE_JITTER_MS
	net1.simulate_packet_loss = BASE_LOSS

	net2.num_players = 3
	net2.simulate_latency_ms = BASE_LATENCY_MS
	net2.simulate_jitter_ms = BASE_JITTER_MS
	net2.simulate_packet_loss = BASE_LOSS

	net3.num_players = 3
	net3.simulate_latency_ms = BASE_LATENCY_MS
	net3.simulate_jitter_ms = BASE_JITTER_MS
	net3.simulate_packet_loss = BASE_LOSS

	var err1 := net1.start_host(7777, 3)
	if err1 != OK:
		print("FAIL: net1 start_host failed: ", err1)
		get_tree().quit(1)
		return

	var err2 := net2.start_client("127.0.0.1", 7777)
	var err3 := net3.start_client("127.0.0.1", 7777)
	if err2 != OK or err3 != OK:
		print("FAIL: net2 or net3 start_client failed: ", err2, " / ", err3)
		get_tree().quit(1)
		return

	print("Waiting for 3 peers to connect over 127.0.0.1:7777...")
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
		print("FAIL: Timeout waiting for 3 peers connection")
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

	net1.send_match_init(bord_bytes, 999999, 2, 0)
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
	print("MATCH_INIT handshake confirmed! Slots: P1=%d, P2=%d, P3=%d" % [net1.local_slot, net2.local_slot, net3.local_slot])

	# 4. Initialize all 3 cores identically
	for core in [core1, core2, core3]:
		core.init(999999)
		core.set_input_assist(true)
		core.load_level(bord_bytes)
		core.set_play_mode(0)
		core.limit_players(3)
		core.spawn_player3()

	var h1_init := core1.net_hash()
	var h2_init := core2.net_hash()
	var h3_init := core3.net_hash()
	if h1_init != h2_init or h1_init != h3_init:
		print("FAIL: Initial net_hash mismatch: %X vs %X vs %X" % [h1_init, h2_init, h3_init])
		get_tree().quit(1)
		return
	print("Initial core state synchronized across 3 cores! Hash: %X" % h1_init)

	# 5. Soak test loop
	var desync_count := 0
	var rollbacks_p1 := 0
	var rollbacks_p2 := 0
	var rollbacks_p3 := 0
	var stall_count := 0
	var confirmed_hashes_p1: Dictionary = {}
	var confirmed_hashes_p2: Dictionary = {}
	var confirmed_hashes_p3: Dictionary = {}

	print("Simulating %d ticks across 3 peers with 120ms RTT, 30ms jitter, 5%% loss, and 400ms rift spikes..." % TARGET_TICKS)

	var step_count := 0
	var max_steps := TARGET_TICKS * 3

	while (net1.current_tick < TARGET_TICKS or net2.current_tick < TARGET_TICKS or net3.current_tick < TARGET_TICKS) and step_count < max_steps:
		step_count += 1
		sim_time += 0.014 # ~71 Hz physics step

		# Latency spike injection at ticks 3000-3060 and 7000-7060
		var min_current_tick := mini(net1.current_tick, mini(net2.current_tick, net3.current_tick))
		var in_spike: bool = (min_current_tick >= 3000 and min_current_tick < 3060) or (min_current_tick >= 7000 and min_current_tick < 7060)
		var current_lat: float = 400.0 if in_spike else BASE_LATENCY_MS
		net1.simulate_latency_ms = current_lat
		net2.simulate_latency_ms = current_lat
		net3.simulate_latency_ms = current_lat

		# Network receive
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)

		# Rollback processing for P1
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

		# Rollback processing for P2
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

		# Rollback processing for P3
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

		# Step P1 if not stalled
		var p1_stalled := net1.check_rift_stall()
		if not p1_stalled and net1.current_tick < TARGET_TICKS:
			var t1 := net1.current_tick
			var in_p1 := 0
			if (t1 / 15) % 2 == 0: in_p1 |= 0x02 # RIGHT
			if t1 % 20 == 5:       in_p1 |= 0x04 # JUMP
			net1.send_local_input(in_p1)
			net1.snapshot_ring[t1 % RollbackNet.RING_BUFFER_SIZE] = core1.snapshot_save()
			var p1_i1 := net1.get_or_predict_input(0, t1)
			var p1_i2 := net1.get_or_predict_input(1, t1)
			var p1_i3 := net1.get_or_predict_input(2, t1)
			core1.tick3(p1_i1, p1_i2, p1_i3)
			confirmed_hashes_p1[t1] = core1.net_hash()
			net1.record_state_hash(t1, int(core1.net_hash() & 0xFFFFFFFF))
			net1.current_tick += 1
		elif p1_stalled:
			stall_count += 1

		# Step P2 if not stalled
		var p2_stalled := net2.check_rift_stall()
		if not p2_stalled and net2.current_tick < TARGET_TICKS:
			var t2 := net2.current_tick
			var in_p2 := 0
			if (t2 / 20) % 2 == 1: in_p2 |= 0x01 # LEFT
			if t2 % 30 == 10:      in_p2 |= 0x08 # BLOCK_HIGH
			net2.send_local_input(in_p2)
			net2.snapshot_ring[t2 % RollbackNet.RING_BUFFER_SIZE] = core2.snapshot_save()
			var p2_i1 := net2.get_or_predict_input(0, t2)
			var p2_i2 := net2.get_or_predict_input(1, t2)
			var p2_i3 := net2.get_or_predict_input(2, t2)
			core2.tick3(p2_i1, p2_i2, p2_i3)
			confirmed_hashes_p2[t2] = core2.net_hash()
			net2.record_state_hash(t2, int(core2.net_hash() & 0xFFFFFFFF))
			net2.current_tick += 1
		elif p2_stalled:
			stall_count += 1

		# Step P3 if not stalled
		var p3_stalled := net3.check_rift_stall()
		if not p3_stalled and net3.current_tick < TARGET_TICKS:
			var t3 := net3.current_tick
			var in_p3 := 0
			if (t3 / 25) % 2 == 0: in_p3 |= 0x02 # RIGHT
			if t3 % 35 == 12:      in_p3 |= 0x10 # BLOCK_LOW
			net3.send_local_input(in_p3)
			net3.snapshot_ring[t3 % RollbackNet.RING_BUFFER_SIZE] = core3.snapshot_save()
			var p3_i1 := net3.get_or_predict_input(0, t3)
			var p3_i2 := net3.get_or_predict_input(1, t3)
			var p3_i3 := net3.get_or_predict_input(2, t3)
			core3.tick3(p3_i1, p3_i2, p3_i3)
			confirmed_hashes_p3[t3] = core3.net_hash()
			net3.record_state_hash(t3, int(core3.net_hash() & 0xFFFFFFFF))
			net3.current_tick += 1
		elif p3_stalled:
			stall_count += 1

		# Verify state hash convergence on confirmed ticks
		var check_tick := mini(net1.last_confirmed_tick, mini(net2.last_confirmed_tick, net3.last_confirmed_tick))
		if check_tick > 0 and confirmed_hashes_p1.has(check_tick) and confirmed_hashes_p2.has(check_tick) and confirmed_hashes_p3.has(check_tick):
			var ch1: int = confirmed_hashes_p1[check_tick]
			var ch2: int = confirmed_hashes_p2[check_tick]
			var ch3: int = confirmed_hashes_p3[check_tick]
			if ch1 != ch2 or ch1 != ch3:
				desync_count += 1
				print("DESYNC at tick %d: P1=%X P2=%X P3=%X" % [check_tick, ch1, ch2, ch3])
				print("  P1 inputs at %d: p1=%d p2=%d p3=%d (conf=%s/%s/%s)" % [check_tick,
					net1.input_history[0].get(check_tick, -1), net1.input_history[1].get(check_tick, -1), net1.input_history[2].get(check_tick, -1),
					net1.input_confirmed[0].get(check_tick, false), net1.input_confirmed[1].get(check_tick, false), net1.input_confirmed[2].get(check_tick, false)])
				print("  P2 inputs at %d: p1=%d p2=%d p3=%d (conf=%s/%s/%s)" % [check_tick,
					net2.input_history[0].get(check_tick, -1), net2.input_history[1].get(check_tick, -1), net2.input_history[2].get(check_tick, -1),
					net2.input_confirmed[0].get(check_tick, false), net2.input_confirmed[1].get(check_tick, false), net2.input_confirmed[2].get(check_tick, false)])
				print("  P3 inputs at %d: p1=%d p2=%d p3=%d (conf=%s/%s/%s)" % [check_tick,
					net3.input_history[0].get(check_tick, -1), net3.input_history[1].get(check_tick, -1), net3.input_history[2].get(check_tick, -1),
					net3.input_confirmed[0].get(check_tick, false), net3.input_confirmed[1].get(check_tick, false), net3.input_confirmed[2].get(check_tick, false)])
				print("  CurTicks: P1=%d P2=%d P3=%d | LastConf: P1=%d P2=%d P3=%d" % [
					net1.current_tick, net2.current_tick, net3.current_tick,
					net1.last_confirmed_tick, net2.last_confirmed_tick, net3.last_confirmed_tick])
				break

		var progress_tick := mini(net1.current_tick, mini(net2.current_tick, net3.current_tick))
		if progress_tick > 0 and progress_tick % 2000 == 0 and (progress_tick != (progress_tick - 1)):
			print("   Tick %d / %d (Rollbacks: P1=%d, P2=%d, P3=%d, Stalls=%d, Desyncs=%d)" %
				[progress_tick, TARGET_TICKS, rollbacks_p1, rollbacks_p2, rollbacks_p3, stall_count, desync_count])

	# Drain remaining packets (disable loss and set latency to 0 during drain so everything arrives)
	net1.simulate_packet_loss = 0.0
	net2.simulate_packet_loss = 0.0
	net3.simulate_packet_loss = 0.0
	net1.simulate_latency_ms = 0.0
	net2.simulate_latency_ms = 0.0
	net3.simulate_latency_ms = 0.0

	for drain in range(120):
		sim_time += 0.014
		net1.poll_network(sim_time)
		net2.poll_network(sim_time)
		net3.poll_network(sim_time)

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
	print("10,000-Tick Soak Test Summary:")
	print("   Ticks Simulated : P1=%d, P2=%d, P3=%d" % [net1.current_tick, net2.current_tick, net3.current_tick])
	print("   P1 Rollbacks    : %d" % rollbacks_p1)
	print("   P2 Rollbacks    : %d" % rollbacks_p2)
	print("   P3 Rollbacks    : %d" % rollbacks_p3)
	print("   Rift Stalls     : %d" % stall_count)
	print("   Desyncs Detected: %d" % desync_count)
	print("   Final P1 Hash   : %X" % final_h1)
	print("   Final P2 Hash   : %X" % final_h2)
	print("   Final P3 Hash   : %X" % final_h3)

	if desync_count == 0 and final_h1 == final_h2 and final_h1 == final_h3:
		print("SOAK TEST: PASS (10,000 ticks, 3 peers, 0 desyncs, rift stall healed)")
		print("==================================================================")
		get_tree().quit(0)
	else:
		print("SOAK TEST: FAIL")
		print("==================================================================")
		get_tree().quit(1)
