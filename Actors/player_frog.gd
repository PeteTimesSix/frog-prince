class_name PlayerFrog extends CharacterBody2D

const ROTATION_SPEED := 5.0
const LEAP_TIME := 0.8
const LEAP_MIN_WINDUP := 0.1
const LEAP_MAX_WINDUP := 0.8
const LEAP_DISTANCE := 180.0
const LEAP_COOLDOWN := 0.5

enum State { STANDING, LEAPING, DEAD }

var state := State.STANDING
var leap_windup_time: float = 0.0
var leap_timer: float = 0.0

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var audio_jump: AudioStreamPlayer2D = $Jump
@onready var audio_splash: AudioStreamPlayer2D = $Splash
@onready var leap_preview: Node2D = $LeapPreview
@onready var floor_collider: Area2D = $FloorCollider

var home_node: Node 

var leap_charging := false

# Called when the node enters the scene tree for the first time.
func _ready():
	home_node = get_parent()

func _process(delta):
	leap_timer -= delta
	if Input.is_action_just_pressed("cancel_leap"):
		leap_charging = false
		leap_preview.hide()
		leap_windup_time = 0
	elif Input.is_action_just_pressed("leap"):
		leap_charging = true
	
	match state:
		State.STANDING:
			velocity = Vector2.ZERO
				
			if leap_timer < -LEAP_COOLDOWN:
				if Input.is_action_just_released("leap") and leap_charging:
					leap_charging = false
					leap()
					
				if leap_charging:
					if leap_windup_time == 0:
						leap_preview.show()
						anim_player.play("leap_windup")
					leap_windup_time += delta
					var leap_factor = min(LEAP_MAX_WINDUP, max(LEAP_MIN_WINDUP, leap_windup_time) / LEAP_MAX_WINDUP)
					leap_preview.position = Vector2.UP * LEAP_DISTANCE * leap_factor
				else:
					leap_windup_time = 0
				
			var turn: float
			if Config.mouse_driven:
				var dir_vector = get_global_mouse_position() - global_position
				var angle_diff = dir_vector.angle() + (PI / 2.0)
				global_rotation = rotate_toward(global_rotation, angle_diff, delta * ROTATION_SPEED)
			else:
				turn = Input.get_axis("turn_left", "turn_right")
				rotate(turn * delta * ROTATION_SPEED)
		State.LEAPING:
			if leap_timer <= 0:
				land()
		
func _physics_process(delta):
	if state != State.LEAPING:
		check_standing()
	move_and_slide()

func leap():
	state = State.LEAPING
	leap_preview.hide()
	var leap_factor = min(LEAP_MAX_WINDUP, max(LEAP_MIN_WINDUP, leap_windup_time) / LEAP_MAX_WINDUP) * LEAP_TIME
	velocity = Vector2.UP.rotated(global_rotation) * LEAP_DISTANCE * (1.0 / LEAP_TIME)
	leap_timer = leap_factor
	leap_windup_time = 0.0
	anim_player.play("leap", -1, 1.0 / leap_factor)
	audio_jump.play()
	if get_parent() != home_node:
		leave_landing()
		reparent(home_node)

func check_standing():
	if floor_collider.has_overlapping_bodies():
		var overlap_bodies = floor_collider.get_overlapping_bodies()
		var best_match = null
		var best_match_distance = INF
		
		for overlap_body in overlap_bodies:
			if overlap_body.is_in_group("safe_landing"):
				var distance = (overlap_body.global_position - global_position).length_squared()
				if distance < best_match_distance:
					best_match = overlap_body
					best_match_distance = distance
					
		if best_match != null:
			if best_match != get_parent():
				leave_landing()
				land_on(best_match)
		else:
			for overlap_body in overlap_bodies:
				if not overlap_body.is_in_group("safe_landing"):
					var distance = (overlap_body.global_position - global_position).length_squared()
					if distance < best_match_distance:
						best_match = overlap_body
						best_match_distance = distance
			if best_match != get_parent():
				leave_landing()
				land_on(best_match)
	else:
		if get_parent() != home_node:
			leave_landing()
			land_on_ground()

func land():
	velocity = Vector2.ZERO
	state = State.STANDING
	leap_timer = 0.0
	anim_player.play("leap_land")

func land_on_ground():
	reparent(home_node)
	pass
	
func leave_landing():
	var current_landing = get_parent()
	if current_landing != home_node:
		if current_landing.has_method("on_leap_off"):
			current_landing.on_leap_off(self)
	
func land_on(landing):
	if landing.has_method("on_leap_on"):
		landing.on_leap_on(self)
	reparent(landing)
		
func disable_controls():
	state = State.DEAD
	
func enable_controls():
	state = State.STANDING
