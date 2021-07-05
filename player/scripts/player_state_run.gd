extends PlayerState


func enter():
	player.set_snap(true)


func exit():
	pass


func update(delta):
	if player.dir == 0:
		emit_signal("finished", "idle")
	if not player.is_on_floor():
		emit_signal("finished", "fall")
#	if Input.is_action_just_pressed("jump"):
#		emit_signal("finished", "jump")
	
	player.velocity.y += player.GRAV
	
	if abs(player.velocity.x) > player.MAX_SPEED:
		player.velocity.x = lerp(player.velocity.x,
								 player.dir * player.MAX_SPEED,
								 player.FRICTION_FAST)
	else:
		if player.dir < 0:
			player.velocity.x = max(player.velocity.x - player.ACCEL,
									-player.MAX_SPEED)
		else:
			player.velocity.x = min(player.velocity.x + player.ACCEL,
									player.MAX_SPEED)
