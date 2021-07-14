extends PlayerState


func enter():
	Util.set_time_scale(0.2)
	player.set_snap(false)


func exit():
	Util.set_time_scale(1.0)
	player.set_snap(false)


func update(delta):
	player.velocity.y += player.GRAV * 0.2
	if player.is_on_floor():
		handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL, false)
	else:
		handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR, false)


func release(direction):
	if player.is_on_floor() and player.velocity.y >= 0:
		emit_signal("finished", "idle")
	else:
		if player.velocity.y < 0:
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "fall")
	pass
