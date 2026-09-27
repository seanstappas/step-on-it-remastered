extends Node
## Renders every fitted frame of a live 3D family for `framematch.py <family> livegate`:
##   "<Godot>" --path godot_project --position 9000,9000 res://scenes/live_check.tscn -- --family=F --out=DIR
## [--scale=4] [--key=1] [--amb=1]. Writes DIR/fNN.png (what the game draws) and prints LIVE_CHECK_DONE.

func _ready() -> void:
	var fam := ""
	var out := ""
	var scale := 4
	var key := 1.0
	var amb := 1.0
	for a in OS.get_cmdline_user_args():
		var v := a.substr(a.find("=") + 1)
		if a.begins_with("--family="):
			fam = v
		elif a.begins_with("--out="):
			out = v
		elif a.begins_with("--scale="):
			scale = int(v)
		elif a.begins_with("--key="):
			key = float(v)
		elif a.begins_with("--amb="):
			amb = float(v)
	get_window().position = Vector2i(9000, 9000)
	var lv := Live3D.load_family(fam, self)
	if lv == null or out == "":
		push_error("live_check: no live rig for %s (or no --out)" % fam)
		get_tree().quit(1)
		return
	lv.key_mult = key
	lv.amb_mult = amb
	DirAccess.make_dir_recursive_absolute(out)
	var frames: Array = lv._xf.keys()
	frames.sort()
	for nn in frames:
		var tex := lv.texture_for("check", nn, nn, 0.0, scale)
		for i in 3:
			await RenderingServer.frame_post_draw
		tex.get_image().get_region(Rect2i(Vector2i.ZERO, lv.frame_size(nn, nn) * scale)).save_png("%s/f%02d.png" % [out, nn])
	print("LIVE_CHECK_DONE %d" % frames.size())
	lv.dispose()
	get_tree().quit()
