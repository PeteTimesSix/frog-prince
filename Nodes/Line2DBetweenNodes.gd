class_name Line2DBetweenNodes extends Line2D

@export var nodes_to_connect: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var size = nodes_to_connect.size()
	clear_points()
	for connected_node in nodes_to_connect:
		add_point(to_local(connected_node.global_position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var i = 0
	for connected_node in nodes_to_connect:
		set_point_position(i, to_local(connected_node.global_position))
		i += 1
