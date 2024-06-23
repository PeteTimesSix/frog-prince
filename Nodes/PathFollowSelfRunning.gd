extends PathFollow2D

@export var speed: float = 25.0

func _process(delta):
	progress += delta * speed * Config.difficulty_modifier
