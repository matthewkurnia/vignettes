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
	
	player.velocity.y += player.GRAV
	
	if abs(player.velocity.x) > player.MAX_SPEED:
		var fric = player.FRICTION_FAST
		var t = sign(player.dir) * sign(player.velocity.x)
		if t > 0:
			fric *= 0.0
		elif t < 0:
			fric *= 2
		player.velocity.x = Util.lirpf(player.velocity.x,
									   player.dir * player.MAX_SPEED,
									   fric)
		player.set_snap(sign(player.get_floor_normal().dot(Vector2.RIGHT)) ==
							 player.dir)
	else:
		if player.dir < 0:
			player.velocity.x = max(player.velocity.x - player.ACCEL,
									-player.MAX_SPEED)
		else:
			player.velocity.x = min(player.velocity.x + player.ACCEL,
									player.MAX_SPEED)
