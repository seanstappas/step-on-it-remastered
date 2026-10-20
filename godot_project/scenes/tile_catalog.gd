class_name TileCatalog
extends RefCounted

# tile_catalog.gd — Definitive tile inventory for Step On It! Remastered
# Grounded in core/src/soi_grid.c, tools/ascii2bord.py, and full census of the 152 campaign boards.

# --- Variant flags for blocks ---
const FLAG_BACKGROUND := 0x0100   # Decorative mesh/trim (not standable)
const FLAG_BREAKABLE  := 0x0200   # Standable solid (head-bonkable / removable)
const FLAG_WALL       := 0x0300   # Permanent standable wall (0x0100 | 0x0200)
const FLAG_HIDDEN     := 0x1200   # Hidden treasure block (0x1000 SPECIAL | 0x0200 BREAKABLE)

# --- 25 Block Families (low-byte type step 6, frame = t + 1) ---
const BLOCK_FAMILIES := [
	{"t": 0x07, "name": "White Block",       "frame": 8},
	{"t": 0x0D, "name": "Red Block",         "frame": 14},
	{"t": 0x13, "name": "Green Block",       "frame": 20},
	{"t": 0x19, "name": "Blue Block",        "frame": 26},
	{"t": 0x1F, "name": "Pink Block",        "frame": 32},
	{"t": 0x25, "name": "White Ball",        "frame": 38},
	{"t": 0x2B, "name": "Red Ball",          "frame": 44},
	{"t": 0x31, "name": "Green Ball",        "frame": 50},
	{"t": 0x37, "name": "Blue Ball",         "frame": 56},
	{"t": 0x3D, "name": "Pink Ball",         "frame": 62},
	{"t": 0x43, "name": "Black Ring",        "frame": 68},
	{"t": 0x49, "name": "Silver Ring",       "frame": 74},
	{"t": 0x4F, "name": "Red Ring",          "frame": 80},
	{"t": 0x55, "name": "Green Ring",        "frame": 86},
	{"t": 0x5B, "name": "Blue Ring",         "frame": 92},
	{"t": 0x61, "name": "Pink Ring",         "frame": 98},
	{"t": 0x67, "name": "Black Frame",       "frame": 104},
	{"t": 0x6D, "name": "Blue Frame",        "frame": 110},
	{"t": 0x73, "name": "Green Frame",       "frame": 116},
	{"t": 0x79, "name": "Green Marble",      "frame": 122},
	{"t": 0x7F, "name": "Pink Marble",       "frame": 128},
	{"t": 0x85, "name": "Red Marble",        "frame": 134},
	{"t": 0x8B, "name": "Steel X-Frame",     "frame": 140},
	{"t": 0x91, "name": "? Question Block",  "frame": 146},
	{"t": 0x97, "name": "Wire Mesh",         "frame": 152},
]

# --- Transporters (5 color pairs: IN / OUT) ---
const TRANSPORTERS := [
	{"name": "Teleport Red (IN)",     "tile": 0x081A, "folder": "goody_sprites", "frame": 27, "color": "Red",    "is_in": true},
	{"name": "Teleport Red (OUT)",    "tile": 0x081B, "folder": "goody_sprites", "frame": 28, "color": "Red",    "is_in": false},
	{"name": "Teleport Blue (IN)",    "tile": 0x081C, "folder": "goody_sprites", "frame": 29, "color": "Blue",   "is_in": true},
	{"name": "Teleport Blue (OUT)",   "tile": 0x081D, "folder": "goody_sprites", "frame": 30, "color": "Blue",   "is_in": false},
	{"name": "Teleport Green (IN)",   "tile": 0x081E, "folder": "goody_sprites", "frame": 31, "color": "Green",  "is_in": true},
	{"name": "Teleport Green (OUT)",  "tile": 0x081F, "folder": "goody_sprites", "frame": 32, "color": "Green",  "is_in": false},
	{"name": "Teleport Pink (IN)",    "tile": 0x0820, "folder": "goody_sprites", "frame": 33, "color": "Pink",   "is_in": true},
	{"name": "Teleport Pink (OUT)",   "tile": 0x0821, "folder": "goody_sprites", "frame": 34, "color": "Pink",   "is_in": false},
	{"name": "Teleport Yellow (IN)",  "tile": 0x0822, "folder": "goody_sprites", "frame": 35, "color": "Yellow", "is_in": true},
	{"name": "Teleport Yellow (OUT)", "tile": 0x0823, "folder": "goody_sprites", "frame": 36, "color": "Yellow", "is_in": false},
]

# --- Stop/Go Switches & Blocks (5 color sets) ---
const SWITCHES := [
	# Switches
	{"name": "Switch Red",     "tile": 0x0824, "folder": "goody_sprites", "frame": 37, "desc": "Toggle Red Stop/Go blocks"},
	{"name": "Switch Blue",    "tile": 0x0826, "folder": "goody_sprites", "frame": 39, "desc": "Toggle Blue Stop/Go blocks"},
	{"name": "Switch Green",   "tile": 0x0828, "folder": "goody_sprites", "frame": 41, "desc": "Toggle Green Stop/Go blocks"},
	{"name": "Switch Pink",    "tile": 0x082A, "folder": "goody_sprites", "frame": 43, "desc": "Toggle Pink Stop/Go blocks"},
	{"name": "Switch Yellow",  "tile": 0x082C, "folder": "goody_sprites", "frame": 45, "desc": "Toggle Yellow Stop/Go blocks"},
	# Blocks (Solid / Passable)
	{"name": "Stop Red (Solid)",    "tile": 0x039D, "folder": "Stop_Go_sprite_family", "frame": 3, "desc": "Red block initially solid"},
	{"name": "Go Red (Pass)",       "tile": 0x01A3, "folder": "Stop_Go_sprite_family", "frame": 2, "desc": "Red block initially passable"},
	{"name": "Stop Blue (Solid)",   "tile": 0x03A9, "folder": "Stop_Go_sprite_family", "frame": 11, "desc": "Blue block initially solid"},
	{"name": "Go Blue (Pass)",      "tile": 0x01AF, "folder": "Stop_Go_sprite_family", "frame": 10, "desc": "Blue block initially passable"},
	{"name": "Stop Green (Solid)",  "tile": 0x03B5, "folder": "Stop_Go_sprite_family", "frame": 19, "desc": "Green block initially solid"},
	{"name": "Go Green (Pass)",     "tile": 0x01BB, "folder": "Stop_Go_sprite_family", "frame": 18, "desc": "Green block initially passable"},
	{"name": "Stop Pink (Solid)",   "tile": 0x03C1, "folder": "Stop_Go_sprite_family", "frame": 27, "desc": "Pink block initially solid"},
	{"name": "Go Pink (Pass)",      "tile": 0x01C7, "folder": "Stop_Go_sprite_family", "frame": 26, "desc": "Pink block initially passable"},
	{"name": "Stop Yellow (Solid)", "tile": 0x03CD, "folder": "Stop_Go_sprite_family", "frame": 35, "desc": "Yellow block initially solid"},
	{"name": "Go Yellow (Pass)",    "tile": 0x01D3, "folder": "Stop_Go_sprite_family", "frame": 34, "desc": "Yellow block initially passable"},
]

# --- Doors & Keys ---
const DOORS_AND_KEYS := [
	{"name": "Key (Univ)",        "tile": 0x0907, "folder": "goody_sprites", "frame": 8,  "desc": "Unlocks the Universal door"},
	{"name": "Closed Door (Univ)", "tile": 0x0904, "folder": "goody_sprites", "frame": 5,  "desc": "Closed exit door (Univ)"},
	{"name": "Open Door (Univ)",   "tile": 0x0901, "folder": "goody_sprites", "frame": 2,  "desc": "Opened exit door (Univ)"},

	{"name": "Key (P1 Blue)",     "tile": 0x0908, "folder": "goody_sprites", "frame": 9,  "desc": "Unlocks P1 Blue door"},
	{"name": "Closed Door (P1)",  "tile": 0x0905, "folder": "goody_sprites", "frame": 6,  "desc": "Closed exit door (P1 Blue)"},
	{"name": "Open Door (P1)",    "tile": 0x0902, "folder": "goody_sprites", "frame": 3,  "desc": "Opened exit door (P1 Blue)"},

	{"name": "Key (P2 Green)",    "tile": 0x0909, "folder": "goody_sprites", "frame": 10, "desc": "Unlocks P2 Green door"},
	{"name": "Closed Door (P2)",  "tile": 0x0906, "folder": "goody_sprites", "frame": 7,  "desc": "Closed exit door (P2 Green)"},
	{"name": "Open Door (P2)",    "tile": 0x0903, "folder": "goody_sprites", "frame": 4,  "desc": "Opened exit door (P2 Green)"},

	{"name": "Key (P3 Red)",      "tile": 0x0933, "folder": "goody_sprites", "frame": 9,  "desc": "Unlocks P3 Red door", "red": true},
	{"name": "Closed Door (P3)",  "tile": 0x0934, "folder": "goody_sprites", "frame": 6,  "desc": "Closed exit door (P3 Red)", "red": true},
	{"name": "Open Door (P3)",    "tile": 0x0935, "folder": "goody_sprites", "frame": 3,  "desc": "Opened exit door (P3 Red)", "red": true},
]

# --- Goodies (all 20 authentic pickups) ---
const GOODIES := [
	{"id": 0x0A, "name": "Silver Coin",    "tile": 0x090A, "folder": "goody_sprites", "frame": 11, "desc": "+500 points"},
	{"id": 0x17, "name": "Gold Coin",      "tile": 0x0917, "folder": "goody_sprites", "frame": 24, "desc": "+1000 points"},
	{"id": 0x18, "name": "Large Gem",       "tile": 0x0918, "folder": "goody_sprites", "frame": 25, "desc": "+2000 points"},
	{"id": 0x19, "name": "Gold Bars",      "tile": 0x0919, "folder": "goody_sprites", "frame": 26, "desc": "+5000 points"},
	{"id": 0x10, "name": "1UP Extra Life", "tile": 0x0910, "folder": "goody_sprites", "frame": 17, "desc": "+1 Life"},
	{"id": 0x11, "name": "Magic Potion",   "tile": 0x0911, "folder": "goody_sprites", "frame": 18, "desc": "Arrow Ammo (+1)"},
	{"id": 0x12, "name": "Magic Arrow",    "tile": 0x0912, "folder": "goody_sprites", "frame": 19, "desc": "Magic Ball Ammo (+1)"},
	{"id": 0x13, "name": "Clock (+2500)",  "tile": 0x0913, "folder": "goody_sprites", "frame": 20, "desc": "+2500 Bonus Time"},
	{"id": 0x14, "name": "Clock (+5000)",  "tile": 0x0914, "folder": "goody_sprites", "frame": 21, "desc": "+5000 Bonus Time"},
	{"id": 0x15, "name": "Clock (+7500)",  "tile": 0x0915, "folder": "goody_sprites", "frame": 22, "desc": "+7500 Bonus Time"},
	{"id": 0x16, "name": "Clock (+10000)", "tile": 0x0916, "folder": "goody_sprites", "frame": 23, "desc": "+10000 Bonus Time"},
	{"id": 0x0B, "name": "Star Bonus",     "tile": 0x090B, "folder": "goody_sprites", "frame": 12, "desc": "Level Cleared Objective Star"},
	{"id": 0x0C, "name": "Score Mult 2x",  "tile": 0x090C, "folder": "goody_sprites", "frame": 13, "desc": "2x End-of-Level Bonus"},
	{"id": 0x0D, "name": "Score Mult 3x",  "tile": 0x090D, "folder": "goody_sprites", "frame": 14, "desc": "3x End-of-Level Bonus"},
	{"id": 0x0E, "name": "Score Mult 4x",  "tile": 0x090E, "folder": "goody_sprites", "frame": 15, "desc": "4x End-of-Level Bonus"},
	{"id": 0x0F, "name": "Score Mult 5x",  "tile": 0x090F, "folder": "goody_sprites", "frame": 16, "desc": "5x End-of-Level Bonus"},
	{"id": 0x2E, "name": "Turtle (Slow)",  "tile": 0x092E, "folder": "goody_sprites", "frame": 47, "desc": "Slows all enemies for ~10s"},
	{"id": 0x2F, "name": "Magnifier",      "tile": 0x092F, "folder": "goody_sprites", "frame": 48, "desc": "Reveals all hidden treasure"},
	{"id": 0x30, "name": "Shield",         "tile": 0x0930, "folder": "goody_sprites", "frame": 49, "desc": "Invulnerability i-frames (~10s)"},
	{"id": 0x31, "name": "Thunderballs",   "tile": 0x0931, "folder": "goody_sprites", "frame": 50, "desc": "Defeats all real enemies"},
	{"id": 0x32, "name": "Speed Shoes",    "tile": 0x0932, "folder": "goody_sprites", "frame": 51, "desc": "2x Movement Speed (~20s)"},
]

# --- Enemies (19 types, etype matches EnemyDefs & SoiCore) ---
const ENEMIES := [
	{"etype": 12, "name": "Turret/Cannon",  "tile": 0x1E140601, "folder": "cannon_sprites", "frame": 2},
	{"etype": 5,  "name": "Wheelie",        "tile": 0x0602,     "folder": "disk_sprites",   "frame": 2},
	{"etype": 5,  "name": "Wheelie (slow)", "tile": 0x0603,     "folder": "disk_sprites",   "frame": 2},
	{"etype": 10, "name": "Walker",         "tile": 0x14000604, "folder": "walker_sprites", "frame": 2},
	{"etype": 3,  "name": "Hippo",          "tile": 0x1E140705, "folder": "hippo_sprites",  "frame": 2},
	{"etype": 7,  "name": "Hammer",         "tile": 0x1E140706, "folder": "hammer_sprites", "frame": 2},
	{"etype": 8,  "name": "Beanie H",       "tile": 0x0607,     "folder": "beenie_sprites", "frame": 66},
	{"etype": 8,  "name": "Beanie V",       "tile": 0x0608,     "folder": "beenie_sprites", "frame": 66},
	{"etype": 13, "name": "Spinner",        "tile": 0x0609,     "folder": "spinner_sprites","frame": 2},
	{"etype": 11, "name": "Teeth",          "tile": 0x1E14070A, "folder": "teeth_sprites",  "frame": 2},
	{"etype": 6,  "name": "Smiley",         "tile": 0x1E14070B, "folder": "smiley_sprites", "frame": 2},
	{"etype": 1,  "name": "Ant",            "tile": 0x1E14070C, "folder": "ant_sprites",    "frame": 2},
	{"etype": 15, "name": "Knight",         "tile": 0x1E14060D, "folder": "knight_sprites", "frame": 2},
	{"etype": 14, "name": "Gargoyle",       "tile": 0x1E14060E, "folder": "Gargoyle_sprites","frame": 2},
	{"etype": 9,  "name": "Robo",           "tile": 0x060F,     "folder": "robo_sprites",   "frame": 2},
	{"etype": 16, "name": "Creeper H",      "tile": 0x14000610, "folder": "bigger_mblock",  "frame": 2},
	{"etype": 16, "name": "Creeper V",      "tile": 0x14000611, "folder": "bigger_mblock",  "frame": 2},
	{"etype": 2,  "name": "Ostrich",        "tile": 0x1E140712, "folder": "ostrich_sprites","frame": 2},
	{"etype": 4,  "name": "Piggy",          "tile": 0x1E140713, "folder": "piggy_sprites",  "frame": 2},
]

# --- Spawns ---
const SPAWNS := [
	{"name": "P1 Spawn",   "tile": -1, "folder": "BP_sprites", "frame": 2},
	{"name": "P2 Spawn",   "tile": -2, "folder": "GP_sprites", "frame": 2},
	{"name": "P3 Spawn",   "tile": -3, "folder": "BP_sprites", "frame": 2, "red": true},
	{"name": "VS Spawn 1", "tile": -4, "folder": "",           "frame": 0},
	{"name": "VS Spawn 2", "tile": -5, "folder": "",           "frame": 0},
	{"name": "VS Spawn 3", "tile": -6, "folder": "",           "frame": 0},
	{"name": "VS Spawn 4", "tile": -7, "folder": "",           "frame": 0},
]
