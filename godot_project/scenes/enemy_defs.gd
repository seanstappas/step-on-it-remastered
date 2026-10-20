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

const ENEMY_NAME := {
	1: "Ant", 2: "Ostrich", 3: "Hippo", 4: "Piggy",
	5: "Wheelie", 6: "Smiley", 7: "Hammer", 8: "Beanie",
	9: "Robo", 10: "Walker", 11: "Teeth",
	12: "Cannon", 13: "Spinner", 14: "Gargoyle", 15: "Knight",
	16: "Creeper",
}

static func get_folder(etype: int) -> String:
	return ENEMY_FOLDER.get(etype, "")

static func get_enemy_name(etype: int) -> String:
	return ENEMY_NAME.get(etype, "Enemy")
