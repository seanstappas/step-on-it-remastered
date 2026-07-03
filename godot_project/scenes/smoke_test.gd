extends Node
## Smoke test for the SoiCore GDExtension: load a level, tick, print state.
## Attach to a Node and run, or call from the front-end. Verifies the C core is
## reachable from GDScript once the extension is built.

# Input bits (7-action platformer — matches core/include/soi_core.h).
const IN_RIGHT := 1 << 1
const IN_JUMP := 1 << 2

func _ready() -> void:
	var core := SoiCore.new()
	core.init(1)

	# Load a level: the real front-end reads a converted BORD; here, load one
	# straight from the extracted resources if present.
	var path := "res://../extracted/levels/board_401.bord"
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		push_warning("no BORD at %s — ticking an empty world" % path)
	else:
		core.load_level(bytes)

	print("P1 start: (%d, %d)  bonus=%d" % [core.player_x(1), core.player_y(1), core.bonus_time()])

	for i in range(60):
		core.tick(IN_RIGHT, 0)

	print("after 60 ticks: P1 x=%d score=%d enemies=%d tick=%d" %
		[core.player_x(1), core.player_score(1), core.enemy_count(), core.tick_count()])
	print("state hash = %d" % core.state_hash())
