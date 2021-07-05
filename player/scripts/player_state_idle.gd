extends PlayerState


func enter():
	player.set_snap(true)


func exit():
	pass


func update(delta):
	if player.dir != 0:
		emit_signal("finished", "run")
	if not player.is_on_floor():
		emit_signal("finished", "fall")
	
	player.velocity.y += player.GRAV
	if abs(player.velocity.x) > player.MAX_SPEED:
		player.velocity.x = Util.lirpf(player.velocity.x, 0, player.FRICTION_FAST)
	else:
		player.velocity.x = Util.lirpf(player.velocity.x, 0, player.FRICTION)
