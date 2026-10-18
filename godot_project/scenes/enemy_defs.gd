class_name EnemyDefs
extends RefCounted

## Shared enemy type and sprite folder definitions
## Matching core SoiEnemyType enum (soi_core.h)

const ENEMY_FOLDER := {
	1: "ant_sprites", 2: "ostrich_sprites", 3: "hippo_sprites", 4: "piggy_sprites",
	5: "disk_sprites", 6: "smiley_sprites", 7: "hammer_sprites", 8: "beenie_sprites",
	9: "robo_sprites", 10: "walker_sprites", 11: "teeth_sprites",
	12: "cannon_sprites", 13: "spinner_sprites", 14: "Gargoyle_sprites", 15: "knight_sprites",
	16: "bigger_mblock",   # creeper (bord 16/17): a pulsing block that walks the grid (sssf 1016)
}

static func get_folder(etype: int) -> String:
	return ENEMY_FOLDER.get(etype, "")
