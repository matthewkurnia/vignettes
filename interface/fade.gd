extends ColorRect


onready var animation_player = $AnimationPlayer


func _ready():
	Player.fade = self


func fade_in():
	animation_player.play("fade")


func fade_out():
	animation_player.play_backwards("fade")
