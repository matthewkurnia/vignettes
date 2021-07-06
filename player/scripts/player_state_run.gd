extends PlayerStateMove


func enter():
	player.set_snap(true)


func exit():
	pass


func update(delta):
	if player.dir == 0:
		emit_signal("finished", "idle")
	if not player.is_on_floor():
		emit_signal("finished", "fall")
	
	player.velocity.y += player.GRAV
	
	handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL)
