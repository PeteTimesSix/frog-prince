extends HSlider

@export var bus_name: String = "Master"

@onready var audio_bus := AudioServer.get_bus_index(bus_name)
@onready var test_sound := $"../TestSound"

func _ready() -> void:
	var db = AudioServer.get_bus_volume_db(audio_bus)
	value = db_to_linear(db)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus, db)

func _on_drag_ended(value_changed):
	test_sound.play()
