extends Node
## session.gd — tiny autoload singleton that carries the player's board choice
## from the menu into the game scene (registered as "Session" in project.godot).

var board_path: String = ""
var board_list: PackedStringArray = PackedStringArray()
var board_index: int = -1

## Advance to the next board in the picked list. Returns false at the end.
func advance() -> bool:
	if board_index >= 0 and board_index + 1 < board_list.size():
		board_index += 1
		board_path = board_list[board_index]
		return true
	return false
