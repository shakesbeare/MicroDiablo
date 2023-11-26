class_name Action

var type: ActionType
var needs_move: bool
var move_target: Vector2

enum ActionType { Move }


func _init(
	type: ActionType,
	needs_move: bool = false,
	move_target: Vector2 = Vector2.ZERO
):
	self.type = type
	self.needs_move = needs_move
	self.move_target = move_target
