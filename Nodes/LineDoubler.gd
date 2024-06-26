extends Node

@export var distance: int = 10
@export var invert: bool = false

var initial_points: PackedVector2Array
@onready var line: Line2D = get_parent()

func _ready():
	var initial_points = line.points.duplicate() as PackedVector2Array
	var normals: Array[Vector2] = []
	normals.resize(initial_points.size() - 1)
	for i in normals.size():
		normals[i] = initial_points[i].direction_to(initial_points[i + 1]).orthogonal()
	var offset_points = line.points.duplicate() as PackedVector2Array
	for i in offset_points.size():
		var normal = normals[i] if i == 0 else ((normals[i] + normals[i - 1]).normalized() if i < offset_points.size() - 1 else normals[i - 1])
		offset_points.set(i, offset_points[i] + (-distance if invert else distance) * normal)
	var between_points_1: Array[Vector2] = []
	var between_points_2: Array[Vector2] = []
	between_points_1.resize(initial_points.size())
	between_points_2.resize(initial_points.size())
	for i in initial_points.size():
		var even =  i % 2 == 0
		between_points_1[i] = initial_points[i] if even else offset_points[i]
		between_points_2[i] = offset_points[i] if even else initial_points[i]
	between_points_1.reverse()
	offset_points.reverse()
	line.points = initial_points + PackedVector2Array(between_points_1) + PackedVector2Array(between_points_2) #+ offset_points
		
