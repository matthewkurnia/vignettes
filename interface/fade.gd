extends ColorRect


signal fade_finished()

onready var animation_player = $AnimationPlayer


func _ready():
	Player.fade = self


func fade_in(playback_speed = 1.0):
	animation_player.playback_speed = playback_speed
	animation_player.play("fade")


func fade_out(playback_speed = 1.0):
	animation_player.playback_speed = playback_speed
	animation_player.play_backwards("fade")


func on_fade_finished(anim_name):
	emit_signal("fade_finished")
