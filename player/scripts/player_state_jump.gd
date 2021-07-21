extends PlayerState


const GRAV_MULT = 2.0

onready var buffer = $Buffer


func enter():
	buffer.start()
	player.set_snap(false)


func update(delta):
	if player.velocity.y >= 0:
		emit_signal("finished", "fall")
	if Input.is_action_pressed("slide") and buffer.time_left == 0:
		player.velocity.y += player.GRAV * GRAV_MULT * 3
	elif Input.is_action_pressed("jump"):
		player.velocity.y += player.GRAV
	else:
		player.velocity.y += player.GRAV * GRAV_MULT
	
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR,
			player.ACCEL_AIR, false)
