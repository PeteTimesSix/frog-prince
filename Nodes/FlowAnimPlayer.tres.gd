extends AnimationPlayer

@export var anim: String = "flow"
@export var speed: float = 1.0
@export var start_offset: float = 0.0
@export var speed_modified_by_difficulty = false

var difficulty_stored: float

func _ready():
	assert(has_animation(anim))
	assert(speed > 0)
	difficulty_stored = Config.difficulty_modifier
	if speed_modified_by_difficulty:
		play(anim, -1, speed * Config.difficulty_modifier)
	else:
		play(anim, -1, speed)
	if start_offset != 0.0:
		seek(start_offset)
		
func _process(delta):
	if speed_modified_by_difficulty and difficulty_stored != Config.difficulty_modifier:
		play(anim, -1, speed * Config.difficulty_modifier)
		difficulty_stored = Config.difficulty_modifier
		
