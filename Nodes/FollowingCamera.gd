extends Camera2D

@export var TargetNode : Node2D = null
@export var max_y: int
@export var min_y: int

func _process(_delta) -> void:
	set_position(Vector2(position.x, min(0, clamp(TargetNode.global_position.y, min_y, max_y))))
