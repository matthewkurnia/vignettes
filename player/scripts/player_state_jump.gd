extends PlayerState


const DAMPING = 0.4


func enter():
	player.set_snap(false)


func update(delta):
	if player.velocity.y >= 0:
		emit_signal("finished", "fall")
	
	if Input.is_action_just_released("jump"):
		player.velocity.y *= DAMPING
	player.velocity.y += player.GRAV
	
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR, false)
