extends StaticBody2D

@export var splashdown: Marker2D
@export var splashdown_effect: PackedScene

func on_leap_on(player_frog: PlayerFrog):
	var splash = splashdown_effect.instantiate()
	self.add_child(splash)
	splash.global_position = player_frog.global_position
	player_frog.audio_splash.play()
	player_frog.disable_controls()
	player_frog.hide()
	Fader.fade()
	await Fader.done_fading
	player_frog.global_position = splashdown.global_position
	player_frog.show()
	Fader.unfade()
	await Fader.done_unfading
	player_frog.enable_controls()
