extends Node

# headless_relay.gd — Tier 3 Headless Relay for Step On It! Remastered
# Listens on UDP ENet (default port 7777, or configured via --relay=PORT)
# Forwards reliable Channel 0 (MATCH_INIT / BOARD_LOAD) and unsequenced Channel 1 (INPUT_TICK)
# between all connected peers.

var port: int = 7777
var enet: ENetConnection = null
var peers: Dictionary = {} # peer_id -> ENetPacketPeer

func _ready() -> void:
	for a in OS.get_cmdline_args() + OS.get_cmdline_user_args():
		if a.begins_with("--relay="):
			var p_str := a.substr(8).strip_edges()
			if p_str.is_valid_int():
				port = p_str.to_int()
		elif a == "--relay":
			port = 7777

	enet = ENetConnection.new()
	var err := enet.create_host_bound("0.0.0.0", port, 8, 2)
	if err != OK:
		print("FAIL: headless_relay failed to bind on port %d (err %d)" % [port, err])
		get_tree().quit(1)
		return

	print("Step On It! Remastered Headless Relay listening on 0.0.0.0:%d" % port)

func _physics_process(_delta: float) -> void:
	if not enet:
		return
	var event := enet.service()
	while event[0] != ENetConnection.EVENT_NONE:
		var event_type: int = event[0]
		var peer: ENetPacketPeer = event[1]
		var pid := peer.get_instance_id()

		if event_type == ENetConnection.EVENT_CONNECT:
			peers[pid] = peer
			print("Relay: peer connected (id=%d, total=%d)" % [pid, peers.size()])
		elif event_type == ENetConnection.EVENT_DISCONNECT:
			peers.erase(pid)
			print("Relay: peer disconnected (id=%d, total=%d)" % [pid, peers.size()])
		elif event_type == ENetConnection.EVENT_RECEIVE:
			var pkt: PackedByteArray = peer.get_packet()
			var channel: int = event[2] if event.size() > 2 else 0
			var flags: int = ENetPacketPeer.FLAG_RELIABLE if channel == 0 else ENetPacketPeer.FLAG_UNSEQUENCED
			for other_pid in peers.keys():
				if other_pid != pid:
					var other_peer: ENetPacketPeer = peers[other_pid]
					if other_peer and other_peer.get_state() == ENetPacketPeer.STATE_CONNECTED:
						other_peer.send(channel, pkt, flags)
			enet.flush()
		event = enet.service()
