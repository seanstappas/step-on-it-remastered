extends RefCounted
class_name RollbackNet

# rollback_net.gd — Deterministic Rollback Netcode over ENet UDP for Step On It! Remastered
# Implements:
# - Hybrid 2-Tick Delay (D = 2) + 16-Tick Rollback (W = 16)
# - 64-Frame Ring Buffer of raw C snapshots (soi_snapshot_save / soi_snapshot_load)
# - Star-Hub Packet Forwarding via P1 (P2 <-> P1 <-> P3)
# - Channel 0 Reliable (MATCH_INIT / BOARD_LOAD) & Channel 1 Unreliable (INPUT_TICK)
# - Built-in synthetic latency, jitter, and packet loss simulator for local testing!
# - Join code encoder/decoder (SOI-XXXX-XXXX)

const RING_BUFFER_SIZE := 64
var BASE_DELAY: int = 2
const MAX_ROLLBACK_WINDOW := 16

const CROCKFORD_ALPHABET := "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

static func encode_be16(arr: PackedByteArray, offset: int, val: int) -> void:
	arr[offset] = (val >> 8) & 0xFF
	arr[offset + 1] = val & 0xFF

static func decode_be16(arr: PackedByteArray, offset: int) -> int:
	return (int(arr[offset]) << 8) | int(arr[offset + 1])

static func encode_be32(arr: PackedByteArray, offset: int, val: int) -> void:
	arr[offset] = (val >> 24) & 0xFF
	arr[offset + 1] = (val >> 16) & 0xFF
	arr[offset + 2] = (val >> 8) & 0xFF
	arr[offset + 3] = val & 0xFF

static func decode_be32(arr: PackedByteArray, offset: int) -> int:
	return (int(arr[offset]) << 24) | (int(arr[offset + 1]) << 16) | (int(arr[offset + 2]) << 8) | int(arr[offset + 3])

const PKT_MATCH_INIT   := 0x01
const PKT_BOARD_LOAD   := 0x02
const PKT_META_CONFIRM := 0x03
const PKT_ADVANCE_REQ  := 0x04
const PKT_MATCH_END    := 0x06
const PKT_INPUT_TICK   := 0x10
const PKT_DROP_PEER    := 0x20
const IN_META_CONFIRM  := 1 << 7
const PROTOCOL_VERSION := 3

# Signals for state changes
signal match_started(bord_bytes: PackedByteArray, rng_seed: int, speed: int, num_players: int, mode: int, local_slot: int)
signal board_loaded(bord_bytes: PackedByteArray, rng_seed: int, is_retry: bool)
signal advance_requested(slot: int)
signal match_ended(reason: int)
signal peer_connected(slot: int)
signal peer_disconnected(slot: int)
signal desync_detected(tick: int, local_hash: int, remote_hash: int)
signal rift_stall_changed(stalled: bool)

# Local player slot: 0=P1, 1=P2, 2=P3
var local_slot: int = 0
var num_players: int = 2
var board_epoch: int = 0
var match_active: bool = false
var last_board_was_challenge_fail: bool = false
var next_base_delay: int = 2
var current_tick: int = 0
var last_confirmed_tick: int = 0
var last_confirmed_per_peer: Array = [-1, -1, -1]
var last_confirmed_input: Array = [0, 0, 0]
var earliest_mispredicted_tick: int = -1
var peer_ack_tick: Array = [0, 0, 0]
var peer_drop_tick: Dictionary = {}
var meta_confirmed_peers: Dictionary = {} # slot -> {"epoch": int, "tick": int, "hash": int}
var advance_requested_epoch: int = -1
var rolling_rtt_ms: float = 0.0
var consecutive_rift_frames: int = 0

# Ring buffer storing raw snapshots: snapshot_ring[tick % 64] = PackedByteArray
var snapshot_ring: Array = []

# Input history per player: input_history[player_idx][tick] = uint8
var input_history: Array = [{}, {}, {}]
var input_confirmed: Array = [{}, {}, {}]
var state_hash_history: Dictionary = {} # tick -> uint32

# Resimulation flag: true during rollback fast-forward so Audio / Particles are suppressed
var is_resimulating: bool = false
var is_stalled: bool = false
var stalled_frames: int = 0

# Network transport
var enet: ENetConnection = null
var peer_instances: Dictionary = {} # peer_id -> slot
var peer_to_obj: Dictionary = {}    # peer_id -> ENetPacketPeer
var dropped_peers: Dictionary = {}  # slot -> true (disconnected peers)
var is_host: bool = false

# Synthetic network simulation (for local testing of lag, jitter, and loss)
var simulate_latency_ms: float = 0.0
var simulate_jitter_ms: float = 0.0
var simulate_packet_loss: float = 0.0
var simulated_packet_queue: Array = [] # [{ "deliver_at": float, "data": PackedByteArray, "channel": int, "peer_id": int }]


func _init() -> void:
	snapshot_ring.resize(RING_BUFFER_SIZE)
	for i in range(RING_BUFFER_SIZE):
		snapshot_ring[i] = PackedByteArray()


static func ip_to_join_code(ip_str: String, port: int = 7777) -> String:
	var clean_ip := ip_str.strip_edges()
	if ":" in clean_ip:
		var sp := clean_ip.rsplit(":", false, 1)
		clean_ip = sp[0].strip_edges()
		if sp[1].is_valid_int():
			port = sp[1].to_int()
	var parts := clean_ip.split(".")
	if parts.size() != 4:
		return "SOI-00000-00000"
	for p in parts:
		if not p.is_valid_int():
			return "SOI-00000-00000"
		var val := p.to_int()
		if val < 0 or val > 255:
			return "SOI-00000-00000"
	var b0 := parts[0].to_int() & 0xFF
	var b1 := parts[1].to_int() & 0xFF
	var b2 := parts[2].to_int() & 0xFF
	var b3 := parts[3].to_int() & 0xFF
	var val48: int = (b0 << 40) | (b1 << 32) | (b2 << 24) | (b3 << 16) | (port & 0xFFFF)

	var chars := ""
	for i in range(10):
		var shift := (9 - i) * 5
		var idx := (val48 >> shift) & 0x1F
		chars += CROCKFORD_ALPHABET[idx]
	return "SOI-%s-%s" % [chars.substr(0, 5), chars.substr(5, 5)]


static func _strip_join_code_prefix(code_str: String) -> String:
	var clean := code_str.strip_edges().to_upper()
	if clean.begins_with("SOI-"):
		clean = clean.substr(4)
	elif clean.begins_with("SOI"):
		clean = clean.substr(3)
	return clean.replace("-", "").replace(" ", "")


static func join_code_to_ip(code_str: String) -> String:
	var clean := _strip_join_code_prefix(code_str)
	clean = clean.replace("O", "0").replace("I", "1").replace("L", "1")

	# Legacy 8-char hex compatibility
	if clean.length() == 8 and clean.is_valid_hex_number(false):
		var b0 := ("0x" + clean.substr(0, 2)).hex_to_int()
		var b1 := ("0x" + clean.substr(2, 2)).hex_to_int()
		var b2 := ("0x" + clean.substr(4, 2)).hex_to_int()
		var b3 := ("0x" + clean.substr(6, 2)).hex_to_int()
		return "%d.%d.%d.%d" % [b0, b1, b2, b3]

	if clean.length() != 10:
		return ""

	var val48: int = 0
	for i in range(10):
		var ch := clean[i]
		var idx := CROCKFORD_ALPHABET.find(ch)
		if idx < 0:
			return ""
		val48 = (val48 << 5) | idx

	var b3 := (val48 >> 16) & 0xFF
	var b2 := (val48 >> 24) & 0xFF
	var b1 := (val48 >> 32) & 0xFF
	var b0 := (val48 >> 40) & 0xFF
	return "%d.%d.%d.%d" % [b0, b1, b2, b3]


static func join_code_to_port(code_str: String) -> int:
	var clean := _strip_join_code_prefix(code_str)
	clean = clean.replace("O", "0").replace("I", "1").replace("L", "1")
	if clean.length() == 8 and clean.is_valid_hex_number(false):
		return 7777
	if clean.length() != 10:
		return 7777
	var val48: int = 0
	for i in range(10):
		var ch := clean[i]
		var idx := CROCKFORD_ALPHABET.find(ch)
		if idx < 0:
			return 7777
		val48 = (val48 << 5) | idx
	var port := val48 & 0xFFFF
	return port if port > 0 else 7777


func reset() -> void:
	current_tick = 0
	last_confirmed_tick = 0
	last_confirmed_per_peer = [-1, -1, -1]
	last_confirmed_input = [0, 0, 0]
	earliest_mispredicted_tick = -1
	peer_ack_tick = [0, 0, 0]
	rolling_rtt_ms = 0.0
	consecutive_rift_frames = 0
	is_resimulating = false
	is_stalled = false
	stalled_frames = 0
	board_epoch = 0
	match_active = false
	last_board_was_challenge_fail = false
	dropped_peers.clear()
	peer_drop_tick.clear()
	meta_confirmed_peers.clear()
	advance_requested_epoch = -1
	input_history = [{}, {}, {}]
	input_confirmed = [{}, {}, {}]
	state_hash_history.clear()
	for i in range(RING_BUFFER_SIZE):
		snapshot_ring[i] = PackedByteArray()


func reset_for_match_start() -> void:
	var was_active := match_active
	var drops := dropped_peers.duplicate()
	reset()
	match_active = was_active
	dropped_peers = drops
	for d in dropped_peers.keys():
		peer_drop_tick[int(d)] = 0


func reset_for_new_board() -> void:
	var saved_drops: Dictionary = dropped_peers.duplicate()
	var next_epoch: int = (board_epoch + 1) & 0x3F
	var was_active: bool = match_active
	reset()
	board_epoch = next_epoch
	match_active = was_active
	dropped_peers = saved_drops
	for d_slot in dropped_peers.keys():
		peer_drop_tick[int(d_slot)] = 0


# Initialize network host (Player 1) or client (Player 2 or 3)
func start_host(port: int = 7777, max_peers: int = 4) -> Error:
	close()
	enet = ENetConnection.new()
	var err := enet.create_host_bound("0.0.0.0", port, max_peers, 2)
	if err == OK:
		is_host = true
		local_slot = 0
	return err


func start_client(address: String, port: int = 7777) -> Error:
	close()
	enet = ENetConnection.new()
	var err := enet.create_host(1, 2)
	if err == OK:
		is_host = false
		enet.connect_to_host(address, port, 2)
	return err


func close() -> void:
	if enet:
		for p in enet.get_peers():
			if p.get_state() == ENetPacketPeer.STATE_CONNECTED:
				p.peer_disconnect_now(0)
		enet.flush()
		enet.destroy()
		enet = null
	peer_instances.clear()
	peer_to_obj.clear()
	simulated_packet_queue.clear()
	reset()


func get_connected_player_count() -> int:
	return 1 + peer_instances.size()


func get_active_remote_peer_count() -> int:
	var count := 0
	for s in range(num_players):
		if s != local_slot and not dropped_peers.has(s):
			count += 1
	return count


static func _get_session() -> Node:
	var ml = Engine.get_main_loop()
	if ml and ml is SceneTree and ml.root:
		return ml.root.get_node_or_null("Session")
	return null


func send_match_init(bord_bytes: PackedByteArray, rng_seed: int, speed: int, mode: int, victory_rule: int = 0, friendly_fire: int = 0, start_board_num: int = 0) -> void:
	if not enet:
		return
	local_slot = 0
	board_epoch = 0
	dropped_peers.clear()
	peer_drop_tick.clear()
	meta_confirmed_peers.clear()
	advance_requested_epoch = -1
	match_active = true
	var peers := enet.get_peers()
	print("send_match_init: peers=%d blen=%d mode=%d rule=%d ff=%d start=%d" % [peers.size(), bord_bytes.size(), mode, victory_rule, friendly_fire, start_board_num])
	var s := _get_session()
	var assist_val: int = 1 if (s != null and bool(s.get("input_assist"))) else 0
	var p3_any_val: int = 1 if (s != null and bool(s.get("p3_any_key"))) else 0
	if s != null:
		s.set("online_start_board", start_board_num)
	for idx in range(peers.size()):
		var peer: ENetPacketPeer = peers[idx]
		var pid := peer.get_instance_id()
		var peer_slot: int = peer_instances.get(pid, idx + 1)
		var pkt := PackedByteArray()
		var blen := bord_bytes.size()
		pkt.resize(0x10 + blen + 6)
		pkt[0] = PKT_MATCH_INIT
		pkt[1] = ((PROTOCOL_VERSION & 0x0F) << 4) | (num_players & 0x0F)
		pkt[2] = peer_slot
		pkt[3] = mode
		pkt[4] = 255 if victory_rule < 0 else (victory_rule & 0xFF)
		pkt[5] = 255 if friendly_fire < 0 else (friendly_fire & 0xFF)
		pkt[6] = assist_val
		pkt[7] = speed
		pkt[8] = BASE_DELAY
		pkt[9] = p3_any_val
		encode_be16(pkt, 0x0A, blen)
		encode_be32(pkt, 0x0C, rng_seed)
		for b in range(blen):
			pkt[0x10 + b] = bord_bytes[b]
		var my_build_id: int = SoiCore.build_id() if ClassDB.class_has_method("SoiCore", "build_id") else 0
		encode_be32(pkt, 0x10 + blen, my_build_id)
		encode_be16(pkt, 0x10 + blen + 4, start_board_num & 0xFFFF)
		peer.send(0, pkt, ENetPacketPeer.FLAG_RELIABLE)
	enet.flush()
	match_started.emit(bord_bytes, rng_seed, speed, num_players, mode, 0)


func send_board_load(bord_bytes: PackedByteArray, rng_seed: int, is_retry: bool = false, was_challenge_fail: bool = false) -> void:
	if not enet or not is_host:
		return
	BASE_DELAY = next_base_delay
	var blen := bord_bytes.size()
	var pkt := PackedByteArray()
	pkt.resize(8 + blen)
	pkt[0] = PKT_BOARD_LOAD
	pkt[1] = (1 if is_retry else 0) | (2 if was_challenge_fail else 0) | ((BASE_DELAY & 0x07) << 2)
	encode_be16(pkt, 2, blen)
	encode_be32(pkt, 4, rng_seed)
	for b in range(blen):
		pkt[8 + b] = bord_bytes[b]
	print("send_board_load: blen=%d seed=%d retry=%s cfail=%s delay=%d pkt_len=%d" % [blen, rng_seed, str(is_retry), str(was_challenge_fail), BASE_DELAY, pkt.size()])
	_broadcast_packet(pkt, 0, ENetPacketPeer.FLAG_RELIABLE)


func send_match_end(reason: int) -> void:
	if not enet:
		return
	var pkt := PackedByteArray()
	pkt.resize(2)
	pkt[0] = PKT_MATCH_END
	pkt[1] = reason & 0xFF
	_broadcast_packet(pkt, 0, ENetPacketPeer.FLAG_RELIABLE)
	if enet:
		enet.flush()
	match_ended.emit(reason)


func send_meta_confirm(terminal_tick: int, state_hash: int) -> void:
	var h32: int = state_hash & 0xFFFFFFFF
	meta_confirmed_peers[local_slot] = {
		"epoch": board_epoch,
		"tick": terminal_tick,
		"hash": h32,
	}
	for s in meta_confirmed_peers.keys():
		if int(s) != local_slot and not dropped_peers.has(int(s)):
			var rem: Dictionary = meta_confirmed_peers[s]
			if int(rem.get("epoch", -1)) == board_epoch:
				var rem_tick: int = int(rem.get("tick", -1))
				var rem_hash: int = int(rem.get("hash", 0))
				if (rem_tick != terminal_tick) or (h32 != 0 and rem_hash != 0 and h32 != rem_hash):
					desync_detected.emit(terminal_tick, h32, rem_hash)
	var pkt := PackedByteArray()
	pkt.resize(10)
	pkt[0] = PKT_META_CONFIRM
	pkt[1] = ((board_epoch & 0x3F) << 2) | (local_slot & 0x03)
	encode_be32(pkt, 2, terminal_tick)
	encode_be32(pkt, 6, h32)
	_broadcast_packet(pkt, 0, ENetPacketPeer.FLAG_RELIABLE)


func all_meta_confirmed() -> bool:
	var first_tick: int = -1
	var first_hash: int = 0
	for s in range(num_players):
		if dropped_peers.has(s):
			continue
		if not meta_confirmed_peers.has(s):
			return false
		var entry: Dictionary = meta_confirmed_peers[s]
		if int(entry.get("epoch", -1)) != board_epoch:
			return false
		var t: int = int(entry.get("tick", -1))
		var h: int = int(entry.get("hash", 0))
		if first_tick == -1:
			first_tick = t
			first_hash = h
		else:
			if t != first_tick:
				return false
			if first_hash != 0 and h != 0 and first_hash != h:
				return false
	return true


func _handle_meta_confirm(pkt: PackedByteArray, from_peer_id: int) -> void:
	if pkt.size() < 10:
		return
	var pkt_epoch: int = (pkt[1] >> 2) & 0x3F
	var slot: int = pkt[1] & 0x03
	if slot < 0 or slot >= 3 or slot == local_slot or dropped_peers.has(slot):
		return
	if pkt_epoch != board_epoch:
		return
	var term_tick: int = decode_be32(pkt, 2)
	var rem_hash: int = decode_be32(pkt, 6)
	meta_confirmed_peers[slot] = {
		"epoch": pkt_epoch,
		"tick": term_tick,
		"hash": rem_hash,
	}
	if meta_confirmed_peers.has(local_slot):
		var loc: Dictionary = meta_confirmed_peers[local_slot]
		if int(loc.get("epoch", -1)) == board_epoch:
			var loc_tick: int = int(loc.get("tick", -1))
			var loc_hash: int = int(loc.get("hash", 0))
			if (loc_tick != term_tick) or (loc_hash != 0 and rem_hash != 0 and loc_hash != rem_hash):
				desync_detected.emit(term_tick, loc_hash, rem_hash)
	if local_slot == 0:
		for pid in peer_to_obj.keys():
			if pid != from_peer_id:
				var p_obj: ENetPacketPeer = peer_to_obj[pid]
				if p_obj and p_obj.get_state() == ENetPacketPeer.STATE_CONNECTED:
					p_obj.send(0, pkt, ENetPacketPeer.FLAG_RELIABLE)
		if enet:
			enet.flush()


func send_advance_request() -> void:
	advance_requested_epoch = board_epoch
	var pkt := PackedByteArray()
	pkt.resize(2)
	pkt[0] = PKT_ADVANCE_REQ
	pkt[1] = ((board_epoch & 0x3F) << 2) | (local_slot & 0x03)
	_broadcast_packet(pkt, 0, ENetPacketPeer.FLAG_RELIABLE)
	advance_requested.emit(local_slot)


func _handle_advance_req(pkt: PackedByteArray, from_peer_id: int) -> void:
	if pkt.size() < 2:
		return
	var pkt_epoch: int = (pkt[1] >> 2) & 0x3F
	var slot: int = pkt[1] & 0x03
	if slot < 0 or slot >= 3 or dropped_peers.has(slot):
		return
	if pkt_epoch != board_epoch:
		return
	advance_requested_epoch = board_epoch
	if is_host:
		for pid in peer_to_obj.keys():
			if pid != from_peer_id:
				var p_obj: ENetPacketPeer = peer_to_obj[pid]
				if p_obj and p_obj.get_state() == ENetPacketPeer.STATE_CONNECTED:
					p_obj.send(0, pkt, ENetPacketPeer.FLAG_RELIABLE)
		if enet:
			enet.flush()
	advance_requested.emit(slot)


func poll_network(time_now_sec: float) -> void:
	# Process synthetic delayed queue first
	if simulated_packet_queue.size() > 0:
		var ready_pkts := []
		var remaining := []
		for item in simulated_packet_queue:
			if time_now_sec >= item["deliver_at"]:
				ready_pkts.append(item)
			else:
				remaining.append(item)
		simulated_packet_queue = remaining
		for item in ready_pkts:
			_process_packet(item["data"], item["peer_id"])

	if not enet:
		return

	var event := enet.service()
	while event[0] != ENetConnection.EVENT_NONE:
		var event_type: int = event[0]
		var peer: ENetPacketPeer = event[1]
		var pid := peer.get_instance_id()
		if event_type == ENetConnection.EVENT_CONNECT:
			if is_host:
				if match_active or peer_instances.size() >= num_players - 1:
					peer.peer_disconnect_now(0)
					event = enet.service()
					continue
				var assigned_slot := -1
				for slot in range(1, num_players):
					var taken := false
					for p_slot in peer_instances.values():
						if p_slot == slot:
							taken = true
							break
					if not taken:
						assigned_slot = slot
						break
				if assigned_slot < 0:
					peer.peer_disconnect_now(0)
					event = enet.service()
					continue
				peer_to_obj[pid] = peer
				peer_instances[pid] = assigned_slot
				dropped_peers.erase(assigned_slot)
				peer_drop_tick.erase(assigned_slot)
				peer_connected.emit(assigned_slot)
			else:
				peer_to_obj[pid] = peer
				peer_instances[pid] = 0
				peer_connected.emit(0)
		elif event_type == ENetConnection.EVENT_DISCONNECT:
			var slot: int = peer_instances.get(pid, -1)
			peer_instances.erase(pid)
			peer_to_obj.erase(pid)
			if slot >= 0:
				if match_active:
					dropped_peers[slot] = true
					var last_t: int = int(last_confirmed_per_peer[slot])
					var drop_t: int = maxi(0, last_t + 1)
					peer_drop_tick[slot] = drop_t
					if drop_t < current_tick:
						if earliest_mispredicted_tick == -1 or drop_t < earliest_mispredicted_tick:
							earliest_mispredicted_tick = drop_t
					for tk in range(drop_t, current_tick + BASE_DELAY + 1):
						input_history[slot][tk] = 0
						input_confirmed[slot][tk] = true
					_update_last_confirmed_tick()
					if is_host:
						var drop_pkt := PackedByteArray()
						drop_pkt.resize(2 + 4 + RING_BUFFER_SIZE)
						drop_pkt[0] = PKT_DROP_PEER
						drop_pkt[1] = slot
						encode_be32(drop_pkt, 2, drop_t)
						for k in range(RING_BUFFER_SIZE):
							var tk: int = drop_t - 1 - k
							drop_pkt[6 + k] = (int(input_history[slot].get(tk, 0)) & 0x7F) if tk >= 0 else 0
						_broadcast_packet(drop_pkt, 0, ENetPacketPeer.FLAG_RELIABLE)
				peer_disconnected.emit(slot)
		elif event_type == ENetConnection.EVENT_RECEIVE:
			var pkt: PackedByteArray = peer.get_packet()
			if (simulate_latency_ms > 0.0 or simulate_packet_loss > 0.0) and pkt.size() > 0 and pkt[0] == PKT_INPUT_TICK:
				if randf() >= simulate_packet_loss:
					var jitter := randf_range(-simulate_jitter_ms, simulate_jitter_ms) if simulate_jitter_ms > 0 else 0.0
					var delay_sec := (simulate_latency_ms + jitter) / 1000.0
					simulated_packet_queue.append({
						"deliver_at": time_now_sec + max(0.0, delay_sec),
						"data": pkt,
						"channel": event[2] if event.size() > 2 else 1,
						"peer_id": pid
					})
			else:
				_process_packet(pkt, pid)
		event = enet.service()


func _process_packet(pkt: PackedByteArray, peer_id: int) -> void:
	if pkt.size() < 1:
		return
	var pkt_type := pkt[0]
	if pkt_type == PKT_INPUT_TICK:
		_handle_input_tick(pkt, peer_id)
	elif pkt_type == PKT_MATCH_INIT:
		_handle_match_init(pkt)
	elif pkt_type == PKT_BOARD_LOAD:
		_handle_board_load(pkt)
	elif pkt_type == PKT_META_CONFIRM:
		_handle_meta_confirm(pkt, peer_id)
	elif pkt_type == PKT_ADVANCE_REQ:
		_handle_advance_req(pkt, peer_id)
	elif pkt_type == PKT_DROP_PEER:
		_handle_drop_peer(pkt)
	elif pkt_type == PKT_MATCH_END:
		_handle_match_end(pkt, peer_id)


func _handle_match_end(pkt: PackedByteArray, from_peer_id: int) -> void:
	if pkt.size() < 2:
		return
	var reason: int = pkt[1]
	if is_host:
		for pid in peer_to_obj.keys():
			if pid != from_peer_id:
				var p_obj: ENetPacketPeer = peer_to_obj[pid]
				if p_obj and p_obj.get_state() == ENetPacketPeer.STATE_CONNECTED:
					p_obj.send(0, pkt, ENetPacketPeer.FLAG_RELIABLE)
		if enet:
			enet.flush()
	match_ended.emit(reason)


func _handle_drop_peer(pkt: PackedByteArray) -> void:
	if pkt.size() < 2:
		return
	var slot := pkt[1]
	if slot >= 0 and slot < 3 and slot != local_slot:
		if pkt.size() >= 6:
			var drop_t := maxi(0, decode_be32(pkt, 2))
			var last_t := drop_t - 1
			peer_drop_tick[slot] = drop_t
			var win_len := mini(RING_BUFFER_SIZE, pkt.size() - 6)
			for k in range(win_len):
				var tk := last_t - k
				if tk >= 0:
					var val: int = pkt[6 + k] & 0x7F
					var prev_pred: int = get_or_predict_input(slot, tk)
					if tk < current_tick and prev_pred != val:
						if earliest_mispredicted_tick == -1 or tk < earliest_mispredicted_tick:
							earliest_mispredicted_tick = tk
					input_history[slot][tk] = val
					input_confirmed[slot][tk] = true
			if drop_t < current_tick:
				if earliest_mispredicted_tick == -1 or drop_t < earliest_mispredicted_tick:
					earliest_mispredicted_tick = drop_t
			for tk in range(drop_t, current_tick + BASE_DELAY + 1):
				input_history[slot][tk] = 0
				input_confirmed[slot][tk] = true
		dropped_peers[slot] = true
		_update_last_confirmed_tick()
		peer_disconnected.emit(slot)


func record_state_hash(tick: int, hash_val: int) -> void:
	state_hash_history[tick] = hash_val
	if state_hash_history.size() > 128:
		var oldest := current_tick - 128
		for tk in state_hash_history.keys():
			if tk < oldest:
				state_hash_history.erase(tk)


func _send_input_packet(anchor_tick: int) -> void:
	if anchor_tick < 0:
		return
	var pkt := PackedByteArray()
	pkt.resize(20 + 16)
	pkt[0] = PKT_INPUT_TICK
	pkt[1] = ((board_epoch & 0x3F) << 2) | (local_slot & 0x03)
	var rift: int = clampi(current_tick - last_confirmed_tick, -32768, 32767)
	encode_be16(pkt, 2, rift & 0xFFFF)
	encode_be32(pkt, 4, anchor_tick) # head_tick
	encode_be32(pkt, 8, last_confirmed_tick) # ack_tick
	var hash_tick: int = (last_confirmed_tick / 8) * 8
	var hash_val: int = int(state_hash_history.get(hash_tick, 0))
	encode_be32(pkt, 12, hash_tick)
	encode_be32(pkt, 16, hash_val)

	for k in range(16):
		var t := anchor_tick - k
		if t >= 0:
			pkt[20 + k] = int(input_history[local_slot].get(t, 0)) & 0x7F
		else:
			pkt[20 + k] = 0

	_broadcast_packet(pkt, 1, ENetPacketPeer.FLAG_UNSEQUENCED)


func send_ack_windows(anchor: int) -> void:
	if anchor < 0:
		return
	_send_input_packet(anchor)
	var min_peer_ack := anchor
	var has_peer_ack := false
	for s in range(num_players):
		if s != local_slot and not dropped_peers.has(s):
			min_peer_ack = mini(min_peer_ack, int(peer_ack_tick[s]))
			has_peer_ack = true
	if has_peer_ack and (anchor - min_peer_ack) > 15:
		_send_input_packet(min_peer_ack + 15)


func send_local_input(local_input: int, current_state_hash: int = 0) -> void:
	var clean_input: int = local_input & 0x7F
	var prev_scheduled: int = int(last_confirmed_per_peer[local_slot])
	var desired: int = current_tick + BASE_DELAY
	var target_tick: int = desired
	if prev_scheduled >= desired:
		target_tick = prev_scheduled
	elif prev_scheduled >= 0:
		target_tick = maxi(desired, prev_scheduled + 1)

	var start_fill: int = 0 if prev_scheduled < 0 else maxi(current_tick, prev_scheduled + 1)
	for tk in range(start_fill, target_tick + 1):
		if not input_confirmed[local_slot].get(tk, false):
			input_history[local_slot][tk] = clean_input
			input_confirmed[local_slot][tk] = true
	last_confirmed_per_peer[local_slot] = target_tick

	if current_state_hash != 0 and current_tick > 0:
		record_state_hash(current_tick - 1, current_state_hash)

	send_ack_windows(target_tick)


func _handle_input_tick(pkt: PackedByteArray, from_peer_id: int) -> void:
	if pkt.size() < 20:
		return
	var pkt_epoch: int = (pkt[1] >> 2) & 0x3F
	var slot: int = pkt[1] & 0x03
	if pkt_epoch != board_epoch:
		return
	if slot < 0 or slot >= 3 or slot == local_slot or dropped_peers.has(slot):
		return
	var head_tick := decode_be32(pkt, 4)
	var ack_tick := decode_be32(pkt, 8)
	peer_ack_tick[slot] = maxi(int(peer_ack_tick[slot]), ack_tick)

	var remote_rift_raw := decode_be16(pkt, 2)
	var remote_rift: int = (remote_rift_raw - 65536) if remote_rift_raw >= 32768 else remote_rift_raw
	var local_rift: int = current_tick - last_confirmed_tick
	if (local_rift - remote_rift) > 3:
		consecutive_rift_frames += 1
	elif (remote_rift - local_rift) > 3:
		consecutive_rift_frames -= 1
	else:
		consecutive_rift_frames = 0

	if ack_tick > 0 and input_confirmed[local_slot].get(ack_tick, false):
		var est_rtt_ticks: int = maxi(0, (current_tick + BASE_DELAY) - ack_tick)
		var est_rtt_ms: float = est_rtt_ticks * 14.0
		rolling_rtt_ms = rolling_rtt_ms * 0.9 + est_rtt_ms * 0.1
		if is_host:
			if rolling_rtt_ms > 120.0:
				next_base_delay = 4
			elif rolling_rtt_ms > 60.0:
				next_base_delay = 3
			else:
				next_base_delay = 2

	var win_len := pkt.size() - 20
	for k in range(win_len):
		var t := head_tick - k
		if t < 0:
			continue
		var val: int = pkt[20 + k] & 0x7F
		if not input_confirmed[slot].get(t, false):
			var predicted_val: int = get_or_predict_input(slot, t)
			var had_pred: bool = input_history[slot].has(t)
			input_history[slot][t] = val
			input_confirmed[slot][t] = true
			if t < current_tick and had_pred and predicted_val != val:
				if earliest_mispredicted_tick == -1 or t < earliest_mispredicted_tick:
					earliest_mispredicted_tick = t

	# Advance last_confirmed_per_peer contiguously
	while input_confirmed[slot].get(last_confirmed_per_peer[slot] + 1, false):
		last_confirmed_per_peer[slot] += 1
		last_confirmed_input[slot] = int(input_history[slot][last_confirmed_per_peer[slot]]) & 0x7F

	_update_last_confirmed_tick()

	# Check desync hash
	var hash_tick := decode_be32(pkt, 12)
	var remote_hash := decode_be32(pkt, 16)
	if hash_tick > 0 and remote_hash != 0 and hash_tick <= last_confirmed_tick and earliest_mispredicted_tick < 0 and state_hash_history.has(hash_tick):
		var local_hash: int = int(state_hash_history[hash_tick])
		if local_hash != remote_hash:
			print("DESYNC at tick %d: local %X != remote %X" % [hash_tick, local_hash, remote_hash])
			desync_detected.emit(hash_tick, local_hash, remote_hash)

	# If hosting (slot 0), forward packet to other peers (Star-Hub forwarding)
	if local_slot == 0:
		for pid in peer_to_obj.keys():
			if pid != from_peer_id:
				var p_obj: ENetPacketPeer = peer_to_obj[pid]
				if p_obj and p_obj.get_state() == ENetPacketPeer.STATE_CONNECTED:
					p_obj.send(1, pkt, ENetPacketPeer.FLAG_UNSEQUENCED)
		if enet:
			enet.flush()


func _update_last_confirmed_tick() -> void:
	var min_c := 999999999
	var found := false
	for s in range(num_players):
		if s != local_slot and not dropped_peers.has(s):
			min_c = mini(min_c, maxi(0, int(last_confirmed_per_peer[s])))
			found = true
	if found:
		last_confirmed_tick = min_c
	else:
		last_confirmed_tick = current_tick


func are_all_peers_confirmed_through(tick: int) -> bool:
	for s in range(num_players):
		if s != local_slot and not dropped_peers.has(s):
			if int(last_confirmed_per_peer[s]) < tick:
				return false
	return true


func get_or_predict_input(slot: int, tick: int) -> int:
	if peer_drop_tick.has(slot) and tick >= int(peer_drop_tick[slot]):
		return 0
	if input_history[slot].has(tick):
		return int(input_history[slot][tick]) & 0x7F
	if dropped_peers.has(slot):
		input_history[slot][tick] = 0
		return 0
	var pred: int = int(last_confirmed_input[slot]) & 0x7F
	input_history[slot][tick] = pred
	return pred


func check_rift_stall() -> bool:
	if get_active_remote_peer_count() == 0:
		if is_stalled:
			is_stalled = false
			stalled_frames = 0
			consecutive_rift_frames = 0
			rift_stall_changed.emit(false)
		return false
	if current_tick > BASE_DELAY and (current_tick - last_confirmed_tick) >= MAX_ROLLBACK_WINDOW:
		if not is_stalled:
			is_stalled = true
			rift_stall_changed.emit(true)
		stalled_frames += 1
		consecutive_rift_frames += 1
		var target_tick: int = int(last_confirmed_per_peer[local_slot])
		if target_tick >= 0:
			send_ack_windows(target_tick)
		return true
	if is_stalled:
		is_stalled = false
		stalled_frames = 0
		rift_stall_changed.emit(false)
	return false


func _handle_match_init(pkt: PackedByteArray) -> void:
	if pkt.size() < 0x10:
		return
	var proto: int = (pkt[1] >> 4) & 0x0F
	if proto != PROTOCOL_VERSION:
		print("Protocol version mismatch: local=%d remote=%d" % [PROTOCOL_VERSION, proto])
		match_ended.emit(2)
		close()
		return
	var blen: int = decode_be16(pkt, 0x0A)
	if blen < 0x1A or pkt.size() < 0x10 + blen + 4:
		print("Malformed MATCH_INIT packet: size=%d blen=%d expected >= %d" % [pkt.size(), blen, 0x10 + blen + 4])
		close()
		return
	var parsed_np: int = pkt[1] & 0x0F
	var parsed_slot: int = pkt[2]
	if parsed_np < 1 or parsed_np > 3 or parsed_slot < 0 or parsed_slot >= parsed_np:
		print("Invalid MATCH_INIT player/slot metadata: num_players=%d local_slot=%d" % [parsed_np, parsed_slot])
		close()
		return
	var remote_build_id: int = decode_be32(pkt, 0x10 + blen)
	var local_build_id: int = SoiCore.build_id() if ClassDB.class_has_method("SoiCore", "build_id") else 0
	if local_build_id != 0 and remote_build_id != 0 and local_build_id != remote_build_id:
		print("Build ID mismatch: local=%X remote=%X" % [local_build_id, remote_build_id])
		match_ended.emit(2)
		close()
		return
	match_active = true
	board_epoch = 0
	advance_requested_epoch = -1
	num_players = parsed_np
	local_slot = parsed_slot
	var mode: int = pkt[3]
	var victory_rule: int = -1 if int(pkt[4]) == 255 else int(pkt[4])
	var friendly_fire: int = -1 if int(pkt[5]) == 255 else int(pkt[5])
	var input_assist: int = pkt[6]
	var speed: int = pkt[7]
	var base_delay_val: int = pkt[8]
	var p3_any_key_val: int = pkt[9]
	var rng_seed: int = decode_be32(pkt, 0x0C)
	var bord_bytes: PackedByteArray = pkt.slice(0x10, 0x10 + blen)
	var start_board_num: int = decode_be16(pkt, 0x10 + blen + 4) if pkt.size() >= 0x10 + blen + 6 else 0
	var s := _get_session()
	if s != null:
		s.set("victory_rule", victory_rule)
		s.set("friendly_fire", friendly_fire)
		s.set("input_assist", (input_assist != 0))
		s.set("p3_any_key", (p3_any_key_val != 0))
		s.set("online_start_board", start_board_num)
	BASE_DELAY = clampi(base_delay_val, 2, 4)
	next_base_delay = BASE_DELAY
	match_started.emit(bord_bytes, rng_seed, speed, num_players, mode, local_slot)


func _handle_board_load(pkt: PackedByteArray) -> void:
	if pkt.size() < 8:
		return
	var blen: int = decode_be16(pkt, 2)
	if pkt.size() < 8 + blen:
		print("Malformed BOARD_LOAD packet: size=%d expected >= %d" % [pkt.size(), 8 + blen])
		return
	var is_retry: bool = (pkt[1] & 1) != 0
	last_board_was_challenge_fail = (pkt[1] & 2) != 0
	var new_delay: int = (pkt[1] >> 2) & 0x07
	if new_delay >= 2 and new_delay <= 4:
		BASE_DELAY = new_delay
		next_base_delay = new_delay
	var rng_seed: int = decode_be32(pkt, 4)
	var bord_bytes: PackedByteArray = pkt.slice(8, 8 + blen)
	print("_handle_board_load: pkt_len=%d blen=%d seed=%d retry=%s cfail=%s delay=%d slice_len=%d" %
		[pkt.size(), blen, rng_seed, str(is_retry), str(last_board_was_challenge_fail), BASE_DELAY, bord_bytes.size()])
	board_loaded.emit(bord_bytes, rng_seed, is_retry)


func _broadcast_packet(pkt: PackedByteArray, channel: int, flags: int) -> void:
	if not enet:
		return
	for p in enet.get_peers():
		if p.get_state() == ENetPacketPeer.STATE_CONNECTED:
			p.send(channel, pkt, flags)
	enet.flush()
