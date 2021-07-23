extends PlayerState


const GRAV_MULT = 2


func enter():
	player.set_snap(true)
#	Cam.shake(0.1, 9)
#	if player.get_floor_normal().dot(Vector2.UP) < cos(deg2rad(25)):
#		player.velocity.x = (player.MAX_SPEED * 3 *
#				 sign(player.get_floor_normal().dot(Vector2.RIGHT)))
#		Cam.shake(0.1, 9)
	if player.velocity.y > player.MAX_SPEED:
		Cam.shake(0.1, 7)
#	player.velocity.x = player.get_floor_normal().dot(Vector2.RIGHT) * player.velocity.y


func exit():
	pass


func update(delta):
	if not player.is_on_floor():
		emit_signal("finished", "fall")
	if Input.is_action_just_released("slide"):
		if player.direction != 0:
			emit_signal("finished", "run")
		else:
			emit_signal("finished", "idle")
	
	player.velocity.y += player.GRAV * GRAV_MULT
	var temp = player.get_floor_normal().dot(Vector2.RIGHT)
	if abs(temp) < 0.05:
		temp = 0
	player.velocity.x = Util.lirpf(player.velocity.x,
			player.MAX_SPEED * sign(temp),
			player.FRICTION_FAST * 0.5)
#	handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL)
