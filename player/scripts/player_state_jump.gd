extends PlayerState


const GRAV_MULT = 2.0

var time = 0

onready var buffer = $Buffer


func enter():
	time = OS.get_ticks_msec()
	buffer.start()
	player.set_snap(false)


func update(delta):
	if player.velocity.y >= 0:
		emit_signal("finished", "fall")
	if player.is_on_floor() and OS.get_ticks_msec() - time > 100:
		if player.direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "run")
	if Input.is_action_pressed("slide") and buffer.time_left == 0:
		player.velocity.y += player.GRAV * GRAV_MULT * 3
	elif Input.is_action_pressed("jump"):
		player.velocity.y += player.GRAV
	else:
		player.velocity.y += player.GRAV * GRAV_MULT
	
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR,
			player.ACCEL_AIR, false)
