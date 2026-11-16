class_name TileArt
extends RefCounted

# tile_art.gd — Unified tile art resolver and sprite loader for Step On It! Remastered
# Mirrors game.gd's exact cell rendering and sprite resolution rules.

const EnemyDefs = preload("res://scenes/enemy_defs.gd")
const TileCatalog = preload("res://scenes/tile_catalog.gd")

static var _FRAME_RE := RegEx.create_from_string("^f0*(\\d+)_\\d+x\\d+\\.png$")
static var _tex_cache: Dictionary = {}
static var _sprite_index: Dictionary = {}


static func clear_cache() -> void:
	_tex_cache.clear()
	_sprite_index.clear()


## Resolves any 32-bit cell value to folder, frame, and drawing metadata
static func resolve_cell(cell: int) -> Dictionary:
	if cell == 0:
		return {"type": "empty"}

	# Discrete P3 Red Key (0x0933), Red Lock (0x0934), Opened Red Door (0x0935)
	if cell == 0x0933:
		return {"folder": "goody_sprites", "frame": 9, "red": true, "name": "Key (P3 Red)"}
	if cell == 0x0934:
		return {"folder": "goody_sprites", "frame": 6, "red": true, "name": "Closed Door (P3 Red)"}
	if cell == 0x0935:
		return {"folder": "goody_sprites", "frame": 3, "red": true, "name": "Open Door (P3 Red)"}

	var t := cell & 0xFF

	# Enemy cell check (0x0400 flag in byte 1)
	if (cell & 0x0400) != 0:
		var etype := t
		var folder := EnemyDefs.get_folder(etype)
		var frame := 2
		var facing_left := (((cell >> 8) & 0xFF) == 0x05)
		if etype == 8: # Beanie
			frame = 66
		return {
			"type": "enemy",
			"folder": folder,
			"frame": frame,
			"etype": etype,
			"facing_left": facing_left,
			"name": EnemyDefs.get_enemy_name(etype)
		}

	# Stop/Go BLOCK: frames 2..35 in Stop_Go_sprite_family
	if t >= 0x9D and t <= 0xD3:
		var group: int = (t - 0x9D) / 12
		var is_solid := bool(cell & 0x0200)
		var sg_frame: int = group * 8 + (3 if is_solid else 2)
		var colors := ["Red", "Blue", "Green", "Pink", "Yellow"]
		var cname: String = colors[clampi(group, 0, 4)]
		return {
			"folder": "Stop_Go_sprite_family",
			"frame": sg_frame,
			"name": "Stop/Go %s (%s)" % [cname, "Solid" if is_solid else "Pass"],
			"cracked": bool(cell & 0x4000)
		}

	# Supportive block (standable solid, permanent or breakable)
	if (cell & 0x0200) != 0:
		var bframe: int = (t + 2) if (cell & 0x4000) else (t + 1)
		var is_perm := bool(cell & 0x0100)
		var is_hidden := bool(cell & 0x1000)
		var payload: int = (cell >> 16) & 0xFFFF
		var family_name := _get_block_family_name(t)
		var variant_str := "Wall" if is_perm else ("Hidden" if is_hidden else "Breakable")
		return {
			"folder": "block_sprites",
			"frame": bframe,
			"name": "%s (%s)" % [family_name, variant_str],
			"cracked": bool(cell & 0x4000),
			"hidden": is_hidden,
			"payload": payload
		}

	# Door, Goody, or Coin (0x0800 or standard coin IDs)
	if (cell & 0x0800) != 0 or t == 0x0A or t == 0x17 or t == 0x18 or t == 0x19:
		var gname := _get_goody_name(t)
		return {
			"folder": "goody_sprites",
			"frame": t + 1,
			"name": gname
		}

	# Permanent decorative / Mesh (0x0100, not standable)
	if (cell & 0x0100) != 0 and t != 0:
		var family_name := _get_block_family_name(t)
		return {
			"folder": "block_sprites",
			"frame": t + 1,
			"name": "%s (Background)" % family_name
		}

	return {"type": "unknown", "tile": cell, "name": "Unknown (0x%X)" % cell}


static func _get_block_family_name(t: int) -> String:
	for b in TileCatalog.BLOCK_FAMILIES:
		if b["t"] == t:
			return b["name"]
	return "Block 0x%02X" % t


static func _get_goody_name(t: int) -> String:
	for g in TileCatalog.GOODIES:
		if g["id"] == t:
			return g["name"]
	for d in TileCatalog.DOORS_AND_KEYS:
		if (d["tile"] & 0xFF) == t:
			return d["name"]
	for tr in TileCatalog.TRANSPORTERS:
		if (tr["tile"] & 0xFF) == t:
			return tr["name"]
	for sw in TileCatalog.SWITCHES:
		if (sw["tile"] & 0xFF) == t:
			return sw["name"]
	return "Goody 0x%02X" % t


## Resolve an extracted/ subdirectory in both packaged builds and editor/CLI dev runs
static func _ext_dir(rel: String) -> String:
	var ml := Engine.get_main_loop() as SceneTree
	var s_node: Node = ml.root.get_node_or_null("Session") if (ml != null and ml.root != null) else null
	if s_node != null and s_node.has_method("ext_path"):
		return s_node.ext_path(rel)
	var pkg_base := OS.get_executable_path().get_base_dir().path_join("extracted")
	if DirAccess.dir_exists_absolute(pkg_base):
		return pkg_base.path_join(rel)
	if OS.has_feature("editor"):
		var dev_base := ProjectSettings.globalize_path("res://../extracted")
		if DirAccess.dir_exists_absolute(dev_base):
			return dev_base.path_join(rel)
	return pkg_base.path_join(rel)


## Build index of available sprite frames for a given presentation mode
static func _folder_index(folder: String, remastered: bool) -> Dictionary:
	var cache_key := "%s_%s" % [folder, "hd" if remastered else "sd"]
	if _sprite_index.has(cache_key):
		return _sprite_index[cache_key]

	var idx: Dictionary = {}
	var dirs: Array[String] = []

	if remastered:
		# Remastered: 4x HD sheets + 3D frame overlay (3D frames win frame-by-frame)
		var hd_dir := _ext_dir("sprites_hd/" + folder)
		dirs.append(hd_dir)
		var td_dir := _ext_dir("sprites_3d_frames/" + folder)
		dirs.append(td_dir)
	else:
		var sd_dir := _ext_dir("sprites/" + folder)
		dirs.append(sd_dir)

	for dir in dirs:
		var da := DirAccess.open(dir)
		if da == null:
			continue
		for f in da.get_files():
			var m := _FRAME_RE.search(f)
			if m != null:
				idx[int(m.get_string(1))] = dir.path_join(f)

	_sprite_index[cache_key] = idx
	return idx


## Load texture for a given sprite folder and frame
static func get_sprite(folder: String, frame: int, remastered: bool, flip: bool = false, red: bool = false) -> Texture2D:
	if folder == "":
		return null

	var key := "%s_%d_%s_%s_%s" % [folder, frame, "hd" if remastered else "sd", "flip" if flip else "norm", "red" if red else "base"]
	if _tex_cache.has(key):
		return _tex_cache[key]

	var idx := _folder_index(folder, remastered)
	var target_frame := frame
	if not idx.has(target_frame):
		for f in range(target_frame - 1, 0, -1):
			if idx.has(f):
				target_frame = f
				break
		if not idx.has(target_frame):
			for f in range(target_frame + 1, target_frame + 20):
				if idx.has(f):
					target_frame = f
					break

	var path: String = idx.get(target_frame, "")
	if path != "" and FileAccess.file_exists(path):
		var img := Image.load_from_file(path)
		if img != null:
			if red:
				_redden(img)
			if flip:
				img.flip_x()
			if remastered:
				_prep_hd(img)
			var tex := ImageTexture.create_from_image(img)
			_tex_cache[key] = tex
			return tex

	_tex_cache[key] = null
	return null


static func _prep_hd(img: Image) -> void:
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	img.fix_alpha_edges()
	img.generate_mipmaps()


static func _redden(img: Image) -> void:
	if img.get_format() != Image.FORMAT_RGBA8:
		img.convert(Image.FORMAT_RGBA8)
	var shadow := Color(0.557, 0.0, 0.0, 1.0)
	var highlight := Color(0.898, 0.224, 0.208, 1.0)
	for y in img.get_height():
		for x in img.get_width():
			var c := img.get_pixel(x, y)
			if c.a > 0.01:
				var max_bg := maxf(c.g, c.b)
				if max_bg > c.r * 1.25 and max_bg > 0.15:
					var luma := 0.299 * c.r + 0.587 * c.g + 0.114 * c.b
					var tint := shadow.lerp(highlight, clampf(luma * 1.4, 0.0, 1.0))
					img.set_pixel(x, y, Color(tint.r, tint.g, tint.b, c.a))


## Logical SD (32px scale) size of a texture
static func logical_size(tex: Texture2D, remastered: bool) -> Vector2:
	if tex == null:
		return Vector2.ZERO
	var s := tex.get_size()
	if remastered:
		return s / 4.0
	return s
