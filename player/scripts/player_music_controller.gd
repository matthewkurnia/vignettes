extends Node2D


var current_state = ""
var arpeggio_time = 0

onready var player = get_parent()


func _process(delta):
	var velo = player.velocity
	Music.fade("drums", velo.length() > 200)
	Music.fade("bass", velo.length() > player.MAX_SPEED * 1.5)
	if velo.y < -player.JUMP_STRENGTH:
		arpeggio_time = OS.get_ticks_msec()
	Music.fade("arpeggio", OS.get_ticks_msec() - arpeggio_time < 1000)
	pass


func state_changed(state):
	current_state = state
