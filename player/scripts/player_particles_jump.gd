extends Particles2D


var prev_state = ""
var time = 0


func on_state_changed(state):
	if state == "jump" or prev_state == "fall":
		time = OS.get_ticks_msec()
	prev_state = state


func _process(delta):
	emitting =  OS.get_ticks_msec() - time < 100
