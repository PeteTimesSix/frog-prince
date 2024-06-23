extends Node

@export var jiggle_distance: int = 2
@export var jiggle_interval: float = 0.8

var initial_points: PackedVector2Array
var line: Line2D
@onready var timer: Timer = $Timer

func _ready():
	assert(timer)
	timer.start(jiggle_interval)
	line = get_parent() as Line2D
	initial_points = line.points.duplicate()

func _on_timer_timeout():
	var i = 0
	for point in initial_points:
		var jiggled_point = Vector2(point.x + randi_range(-jiggle_distance, jiggle_distance), point.y + randi_range(-jiggle_distance, jiggle_distance))
		line.set_point_position(i, jiggled_point)
		i += 1
