class_name LandedProxy extends Node2D

var stored_position: Vector2
var stored_rotation: float

func _ready():
	store()
	
func store():
	stored_position = global_position
	stored_rotation = global_rotation
