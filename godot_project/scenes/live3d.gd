class_name Live3D
extends RefCounted
## REAL-TIME 3D sprites (REMASTERED, F4): a family's rig exported by `framematch.py <family> live`
## (extracted/sprites_live/<family>/model.glb + live.json) is posed between any two of its fitted frames
## -- every node's transform interpolated, the fitted camera placement lerped -- and rendered live, per
## entity, into a transparent viewport at the display's resolution; a second 2D pass applies the family's
## post steps (framematch "matte" / "fringe": the originals' keyed dark rim) and the P3 recolour. Lights,
## ambient and materials come from the Blender scene the frames were fitted in, converted to Godot's
## units (a Cycles sun of strength E lights a white surface to E/pi; a world of strength W adds W).
## Every frame's canvas puts the world origin at the same fitted spot from its top-left corner, so one
## viewport of the family's largest frame size serves every frame; the caller draws the frame's part.

const POST_SHADER := """
shader_type canvas_item;
render_mode blend_disabled;
uniform sampler2D src : filter_nearest;
uniform float rad = 0.0;
uniform float matte = 0.0;
uniform bool red = false;
uniform float mirror = 0.0;   // > 0: the frame's width in UV; its region is drawn mirrored (a left-facing entity)
float cov(vec4 c) {
	return matte > 0.0 ? min(1.0, c.a / matte) : c.a;
}
void fragment() {
	vec2 px = 1.0 / vec2(textureSize(src, 0));
	vec2 uv = UV;
	if (mirror > 0.0 && uv.x < mirror) {
		uv.x = mirror - uv.x;
	}
	vec4 c = texture(src, uv);
	float a = cov(c);
	for (int y = -4; y <= 4; y++) {
		for (int x = -4; x <= 4; x++) {
			if (float(max(abs(x), abs(y))) <= rad) {
				a = max(a, cov(texture(src, uv + vec2(float(x), float(y)) * px)));
			}
		}
	}
	if (red) {
		float max_bg = max(rgb.g, rgb.b);
		if (max_bg > rgb.r * 1.25 && max_bg > 0.15) {
			float luma = 0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b;
			vec3 shadow = vec3(0.557, 0.0, 0.0);
			vec3 highlight = vec3(0.898, 0.224, 0.208);
			rgb = mix(shadow, highlight, clamp(luma * 1.4, 0.0, 1.0));
		}
	}
	COLOR = vec4(rgb, a);
}
"""
const KEY_SCALE := 1.0 / PI
const AMBIENT_SCALE := 1.0
const SHADOW_BLUR := 1.5

var family := ""
var sheet := ""
var light_scale := 1.0            # overall trim on the converted lights (live.json "light_scale")
var key_scale := 1.0              # sun / ambient balance fitted to the SD frames (framematch `livecal`)
var amb_scale := 1.0
var key_mult := 1.0               # extra trims (calibration renders)
var amb_mult := 1.0
var _data: Dictionary
var _proto: Node3D
var _names: Array = []
var _xf := {}                     # frame -> Array[Transform3D] of the moving nodes
var _blend_shapes: Array = []     # [{node, shape}] channels exported from Blender
var _bs := {}                     # frame -> Array[float] of blend-shape weights
var _p0 := {}                     # frame -> Vector2: SD px from the canvas corner where the world origin lands
var _u := {}                      # frame -> world units per SD px
var _size := {}                   # frame -> Vector2i (SD px)
var _canvas := Vector2i.ONE       # the largest frame
var _rim := 0.0                   # fringe width, SD px
var _matte := 0.0
var _holder: Node
var _inst := {}                   # key -> {vp3, vp2, cam, nodes, mat, s, used}
var _post: Shader
var _jump := {}                   # "a,b" -> Array[bool]: node turns > SNAP_TURN between the two frames

const SNAP_TURN := 1.745329   # 100 deg: a turn this big between two frames is a symmetric model's wrap


## Load a family's live rig, or null when it has none (the sprite frames are drawn instead).
static func load_family(fam: String, holder: Node) -> Live3D:
	var dir := ProjectSettings.globalize_path("res://../extracted/sprites_live/" + fam)
	if not FileAccess.file_exists(dir + "/live.json") or not FileAccess.file_exists(dir + "/model.glb"):
		return null
	var data: Variant = JSON.parse_string(FileAccess.get_file_as_string(dir + "/live.json"))
	if not (data is Dictionary):
		return null
	var doc := GLTFDocument.new()
	var st := GLTFState.new()
	if doc.append_from_file(dir + "/model.glb", st) != OK:
		return null
	var lv := Live3D.new()
	lv.family = fam
	lv._data = data
	lv.sheet = str(data["sheet"])
	lv.light_scale = float(data.get("light_scale", 1.0))
	lv.key_scale = float(data.get("key_scale", 1.0))
	lv.amb_scale = float(data.get("amb_scale", 1.0))
	lv._holder = holder
	lv._proto = doc.generate_scene(st)
	lv._names = data["nodes"]
	lv._blend_shapes = data.get("blend_shapes", [])
	var sc := float(data.get("scale", 4))
	for stp in data.get("post", []):
		if (stp as Dictionary).has("fringe"):
			lv._rim = float(stp["fringe"].get("px", 2)) / sc
		if (stp as Dictionary).has("matte"):
			lv._matte = float(stp["matte"].get("thresh", 0.3))
	for k in (data["frames"] as Dictionary).keys():
		var fr: Dictionary = data["frames"][k]
		var xs: Array = []
		for m in fr["xf"]:
			xs.append(Transform3D(Vector3(m[0], m[4], m[8]), Vector3(m[1], m[5], m[9]),
				Vector3(m[2], m[6], m[10]), Vector3(m[3], m[7], m[11])))
		var n := int(k)
		var w := int(fr["w"])
		var h := int(fr["h"])
		var u := float(fr["cam"]["ortho_scale"]) / float(maxi(w, h))
		lv._xf[n] = xs
		lv._bs[n] = fr.get("bs", [])
		lv._u[n] = u
		lv._p0[n] = Vector2(w * 0.5 - float(fr["cam"]["x"]) / u, h * 0.5 + float(fr["cam"]["y"]) / u)
		lv._size[n] = Vector2i(w, h)
		lv._canvas = Vector2i(maxi(lv._canvas.x, w), maxi(lv._canvas.y, h))
	lv._apply_materials(lv._proto)
	lv._post = Shader.new()
	lv._post.code = POST_SHADER
	# the renders are sprite-sized: noisy soft-shadow kernels read as a dot pattern, so filter hard
	RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
	return lv

func has_frame(frame: int) -> bool:
	return _xf.has(frame)

## The SD px size of the part of the texture to draw for a pose between frames a and b.
func frame_size(a: int, b: int) -> Vector2i:
	var sa: Vector2i = _size[a]
	var sb: Vector2i = _size[b]
	return Vector2i(maxi(sa.x, sb.x), maxi(sa.y, sb.y))

## The live render of entity `key` posed f of the way from frame a to b, `scale` display px per SD
## px, recoloured for P3 when `red`, mirrored when `flip`. Its top-left frame_size(a, b) part is the
## sprite's own canvas (same anchor as its fNN frame).
func texture_for(key: String, a: int, b: int, f: float, scale: int, red: bool = false, flip: bool = false) -> Texture2D:
	if not (_xf.has(a) and _xf.has(b)):
		return null
	var e: Dictionary = _inst.get(key, {})
	if e.is_empty() or int(e["s"]) != scale:
		release(key)
		e = _make(scale)
		_inst[key] = e
	var xa: Array = _xf[a]
	var xb: Array = _xf[b]
	var nodes: Array = e["nodes"]
	var jump := _jumps(a, b)
	for i in nodes.size():
		if nodes[i] != null:
			if jump[i]:                  # the Spinner's half turn wraps f17 -> f02: same picture, no sweep
				(nodes[i] as Node3D).transform = xa[i] if f < 0.5 else xb[i]
			else:
				(nodes[i] as Node3D).transform = (xa[i] as Transform3D).interpolate_with(xb[i], f)
	var ba: Array = _bs.get(a, [])
	var bb: Array = _bs.get(b, [])
	var blends: Array = e["blends"]
	for i in mini(blends.size(), mini(ba.size(), bb.size())):
		var blend: Dictionary = blends[i]
		if not blend.is_empty():
			(blend["node"] as MeshInstance3D).set_blend_shape_value(
				int(blend["index"]), lerpf(float(ba[i]), float(bb[i]), f))
	var u := lerpf(_u[a], _u[b], f)
	var p0: Vector2 = (_p0[a] as Vector2).lerp(_p0[b], f)
	var cam: Camera3D = e["cam"]
	cam.position = Vector3((_canvas.x * 0.5 - p0.x) * u, -(_canvas.y * 0.5 - p0.y) * u, 5.0)
	cam.size = maxi(_canvas.x, _canvas.y) * u
	(e["mat"] as ShaderMaterial).set_shader_parameter("red", red)
	(e["mat"] as ShaderMaterial).set_shader_parameter("mirror", float(frame_size(a, b).x) / float(_canvas.x) if flip else 0.0)
	e["used"] = Engine.get_process_frames()
	return (e["vp2"] as SubViewport).get_texture()

func release(key: String) -> void:
	if _inst.has(key):
		(_inst[key]["vp2"] as Node).queue_free()     # vp3 is its child
		_inst.erase(key)

## Per node: does it turn more than SNAP_TURN from frame a's pose to frame b's (cached per pair)?
func _jumps(a: int, b: int) -> Array:
	var k := "%d,%d" % [a, b]
	if not _jump.has(k):
		var xa: Array = _xf[a]
		var xb: Array = _xf[b]
		var out: Array = []
		for i in xa.size():
			var qa := Quaternion((xa[i] as Transform3D).basis.orthonormalized())
			var qb := Quaternion((xb[i] as Transform3D).basis.orthonormalized())
			var ang := (qa.inverse() * qb).get_angle()
			out.append(minf(ang, TAU - ang) > SNAP_TURN)
		_jump[k] = out
	return _jump[k]

func release_all() -> void:
	for k in _inst.keys():
		release(k)

## Free the renders and the loaded model (a node outside the tree); call when the holder goes away.
func dispose() -> void:
	release_all()
	if _proto != null:
		_proto.free()
		_proto = null

## Free the renders of entities not drawn for a while (killed, left the board).
func release_idle(frames: int = 30) -> void:
	var now := Engine.get_process_frames()
	for k in _inst.keys():
		if now - int(_inst[k]["used"]) > frames:
			release(k)

func _make(scale: int) -> Dictionary:
	var px := _canvas * scale
	var vp3 := SubViewport.new()
	vp3.size = px
	vp3.transparent_bg = true
	vp3.own_world_3d = true
	vp3.msaa_3d = Viewport.MSAA_8X
	vp3.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color.WHITE
	env.ambient_light_energy = float(_data["world"]) * AMBIENT_SCALE * light_scale * amb_scale * amb_mult
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	var we := WorldEnvironment.new()
	we.environment = env
	vp3.add_child(we)
	for L in _data["lights"]:
		if str(L["type"]) != "SUN":
			continue
		var d := Vector3(L["dir"][0], L["dir"][1], L["dir"][2]).normalized()
		var dl := DirectionalLight3D.new()
		dl.transform = Transform3D.IDENTITY.looking_at(d, Vector3.FORWARD if absf(d.y) > 0.99 else Vector3.UP)
		dl.light_color = Color(L["color"][0], L["color"][1], L["color"][2]).linear_to_srgb()
		dl.light_energy = float(L["energy"]) * KEY_SCALE * light_scale * key_scale * key_mult
		dl.shadow_enabled = bool(L["shadow"])
		dl.shadow_blur = SHADOW_BLUR          # Cycles' 4.5-deg sun: soft edges, without PCSS's noise
		dl.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
		dl.directional_shadow_max_distance = 20.0
		vp3.add_child(dl)
	var cam := Camera3D.new()
	cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	cam.keep_aspect = Camera3D.KEEP_WIDTH if _canvas.x >= _canvas.y else Camera3D.KEEP_HEIGHT
	cam.near = 0.1
	cam.far = 20.0
	cam.current = true
	vp3.add_child(cam)
	var model := _proto.duplicate() as Node3D
	vp3.add_child(model)
	var nodes: Array = []
	for n in _names:
		nodes.append(model.find_child(String(n).validate_node_name(), true, false))
	var blends: Array = []
	for channel in _blend_shapes:
		var spec: Dictionary = channel
		var mesh := model.find_child(String(spec["node"]).validate_node_name(), true, false) as MeshInstance3D
		var index := -1
		if mesh != null and mesh.mesh != null:
			index = mesh.find_blend_shape_by_name(StringName(spec["shape"]))
		blends.append({"node": mesh, "index": index} if index >= 0 else {})
	var vp2 := SubViewport.new()
	vp2.size = px
	vp2.transparent_bg = true
	vp2.disable_3d = true
	vp2.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	var rect := ColorRect.new()
	rect.size = Vector2(px)
	var sm := ShaderMaterial.new()
	sm.shader = _post
	sm.set_shader_parameter("src", vp3.get_texture())
	sm.set_shader_parameter("rad", _rim * float(scale))
	sm.set_shader_parameter("matte", _matte)
	rect.material = sm
	vp2.add_child(rect)
	vp2.add_child(vp3)                    # a child viewport renders before its parent: same-frame pose
	_holder.add_child(vp2)
	return {"vp3": vp3, "vp2": vp2, "cam": cam, "nodes": nodes, "blends": blends, "mat": sm, "s": scale,
		"used": Engine.get_process_frames()}

## Godot's own materials for the exported surfaces: the Principled values, with Blender's "Specular IOR
## Level" (0.5 = F0 4%, linear) mapped onto Godot's specular (F0 = 0.16 * s^2).
func _apply_materials(root: Node) -> void:
	var mats := {}
	for name in (_data["materials"] as Dictionary).keys():
		var m: Dictionary = _data["materials"][name]
		var sm := StandardMaterial3D.new()
		sm.albedo_color = Color(m["color"][0], m["color"][1], m["color"][2]).linear_to_srgb()
		sm.roughness = float(m["rough"])
		sm.metallic = float(m["metal"])
		sm.metallic_specular = clampf(sqrt(float(m["spec"]) * 0.5), 0.0, 1.0)
		if float(m.get("coat", 0.0)) > 0.0:
			sm.clearcoat_enabled = true
			sm.clearcoat = float(m["coat"])
			sm.clearcoat_roughness = float(m.get("coat_rough", 0.03))
		if float(m.get("emit", 0.0)) > 0.0:
			sm.emission_enabled = true
			var ec: Array = m["emit_color"]
			sm.emission = Color(ec[0], ec[1], ec[2]).linear_to_srgb()
			sm.emission_energy_multiplier = float(m["emit"])
		mats[name] = sm
	for mi in root.find_children("*", "MeshInstance3D", true, false):
		var mesh: Mesh = (mi as MeshInstance3D).mesh
		for i in mesh.get_surface_count():
			var src := mesh.surface_get_material(i)
			if src != null and mats.has(src.resource_name):
				(mi as MeshInstance3D).set_surface_override_material(i, mats[src.resource_name])
