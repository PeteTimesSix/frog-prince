extends StaticBody2D

@export var target_scene: PackedScene

var changing = false

func on_leap_on(player_frog: PlayerFrog):
	if not changing:
		changing = true
		Fader.fade()
		await Fader.done_fading
		WinState.won = true
		get_tree().change_scene_to_packed(target_scene)
		Fader.unfade()
