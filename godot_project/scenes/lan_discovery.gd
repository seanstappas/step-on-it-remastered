extends RefCounted

## lan_discovery.gd — Lightweight UDP LAN lobby beacon & listener.
## Hosts broadcast a compact JSON beacon on DISCOVERY_PORT (7778) from an
## ephemeral socket so host and client can also run on the same PC simultaneously.

const DISCOVERY_PORT := 7778
const MAGIC_PREFIX := "SOI1:"
const BROADCAST_INTERVAL_SEC := 0.8
const LOBBY_TTL_SEC := 3.5

var _tx: PacketPeerUDP = null
var _rx: PacketPeerUDP = null
var _broadcasting: bool = false
var _listening: bool = false
var _listen_port: int = DISCOVERY_PORT
var _beacon_info: Dictionary = {}
var _last_tx_sec: float = -999.0
var _lobbies: Dictionary = {} # lobby_id -> Dictionary
var _tx_targets_override: Array[String] = []
var listen_error: String = ""


static func mode_label(mode: int) -> String:
	match mode:
		0: return "Cooperate"
		1: return "Compete"
		3: return "Versus"
		_: return "Mode %d" % mode


static func encode_beacon(info: Dictionary) -> PackedByteArray:
	return (MAGIC_PREFIX + JSON.stringify(info)).to_utf8_buffer()


static func decode_beacon(pkt: PackedByteArray) -> Dictionary:
	if pkt.size() <= MAGIC_PREFIX.length():
		return {}
	var s := pkt.get_string_from_utf8()
	if not s.begins_with(MAGIC_PREFIX):
		return {}
	var parsed: Variant = JSON.parse_string(s.substr(MAGIC_PREFIX.length()))
	if not (parsed is Dictionary):
		return {}
	var d := parsed as Dictionary
	if not (d.has("lobby_id") and d.has("port") and d.has("players") and d.has("max_players") and d.has("mode")):
		return {}
	var lid := str(d["lobby_id"]).strip_edges()
	var port := int(d["port"])
	var players := int(d["players"])
	var max_p := int(d["max_players"])
	var mode := int(d["mode"])
	if lid.is_empty() or port < 1 or port > 65535 or max_p < 1 or max_p > 8 or players < 1 or players > 8:
		return {}
	return {
		"lobby_id": lid,
		"name": str(d.get("name", "Host")),
		"port": port,
		"players": players,
		"max_players": max_p,
		"mode": mode,
		"board": int(d.get("board", 401)),
		"map": str(d.get("map", "")),
		"build": int(d.get("build", 0)),
	}


static func get_broadcast_targets() -> Array[String]:
	var targets: Array[String] = ["255.255.255.255", "127.0.0.1"]
	for a in IP.get_local_addresses():
		if ":" in a or a == "127.0.0.1" or a.begins_with("169.254."):
			continue
		var parts := a.split(".")
		if parts.size() != 4:
			continue
		var o1 := parts[0].to_int()
		var o2 := parts[1].to_int()
		var is_rfc1918 := (o1 == 10) or (o1 == 172 and o2 >= 16 and o2 <= 31) or (o1 == 192 and o2 == 168)
		if is_rfc1918:
			var bcast := "%s.%s.%s.255" % [parts[0], parts[1], parts[2]]
			if not targets.has(bcast):
				targets.append(bcast)
	return targets


func start_broadcasting(info: Dictionary, target_port: int = DISCOVERY_PORT) -> Error:
	_stop_tx()
	_tx = PacketPeerUDP.new()
	_tx.set_broadcast_enabled(true)
	var err := _tx.bind(0, "0.0.0.0")
	if err != OK:
		_tx = null
		_broadcasting = false
		return err
	_beacon_info = info.duplicate(true)
	if str(_beacon_info.get("lobby_id", "")).is_empty():
		_beacon_info["lobby_id"] = "%08x%08x" % [randi(), Time.get_ticks_msec()]
	if int(_beacon_info.get("port", 0)) <= 0:
		_beacon_info["port"] = 7777
	_listen_port = target_port
	_broadcasting = true
	_last_tx_sec = -999.0
	return OK


func update_broadcast(info: Dictionary) -> void:
	for k in info.keys():
		_beacon_info[k] = info[k]
	_last_tx_sec = -999.0


func start_listening(port: int = DISCOVERY_PORT) -> Error:
	_stop_rx()
	listen_error = ""
	_listen_port = port
	_rx = PacketPeerUDP.new()
	var err := _rx.bind(port, "0.0.0.0")
	if err != OK:
		_rx = null
		_listening = false
		listen_error = "LAN scan unavailable (port %d busy)" % port
		return err
	_listening = true
	return OK


func refresh_scan() -> bool:
	var had := not _lobbies.is_empty()
	_lobbies.clear()
	return had


func poll(now_sec: float) -> bool:
	if _broadcasting and _tx != null:
		if now_sec - _last_tx_sec >= BROADCAST_INTERVAL_SEC:
			_last_tx_sec = now_sec
			var pkt := encode_beacon(_beacon_info)
			var targets: Array[String] = _tx_targets_override if not _tx_targets_override.is_empty() else get_broadcast_targets()
			for tgt in targets:
				_tx.set_dest_address(tgt, _listen_port)
				_tx.put_packet(pkt)

	var changed := false
	if _listening and _rx != null:
		while _rx.get_available_packet_count() > 0:
			var pkt := _rx.get_packet()
			var sender_ip := _rx.get_packet_ip()
			var d := decode_beacon(pkt)
			if d.is_empty() or sender_ip.is_empty():
				continue
			var lid := str(d["lobby_id"])
			var prev: Dictionary = _lobbies.get(lid, {})
			var prev_ip := str(prev.get("ip", ""))
			var chosen_ip := sender_ip
			if sender_ip == "127.0.0.1" and not prev_ip.is_empty() and prev_ip != "127.0.0.1":
				chosen_ip = prev_ip
			d["ip"] = chosen_ip
			d["last_seen_sec"] = now_sec
			if prev.is_empty():
				changed = true
			else:
				for vk in ["ip", "name", "port", "players", "max_players", "mode", "board", "map", "build"]:
					if prev.get(vk) != d.get(vk):
						changed = true
						break
			_lobbies[lid] = d

	for lid in _lobbies.keys():
		var entry: Dictionary = _lobbies[lid]
		if now_sec - float(entry.get("last_seen_sec", 0.0)) > LOBBY_TTL_SEC:
			_lobbies.erase(lid)
			changed = true

	return changed


func get_lobbies() -> Array:
	var arr: Array = []
	for v in _lobbies.values():
		arr.append((v as Dictionary).duplicate())
	arr.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		var na := str(a.get("name", ""))
		var nb := str(b.get("name", ""))
		if na != nb:
			return na < nb
		return str(a.get("ip", "")) < str(b.get("ip", ""))
	)
	return arr


func _stop_tx() -> void:
	_broadcasting = false
	if _tx != null:
		_tx.close()
		_tx = null


func _stop_rx() -> void:
	_listening = false
	if _rx != null:
		_rx.close()
		_rx = null


func stop() -> void:
	_stop_tx()
	_stop_rx()
	_lobbies.clear()
	listen_error = ""
