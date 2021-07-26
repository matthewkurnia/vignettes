extends PlayerState


const GRAV_MULT = 2


func enter():
	player.set_snap(true)
	if player.velocity.y > player.MAX_SPEED:
		Cam.shake(0.1, 7)
	var normal = player.get_floor_normal()
	player.velocity = player.prev_velo.slide(normal)
#	print(rad2deg(player.velocity.angle_to(Vector2.UP)))
	if player.get_slope_status() != 0:
		player.position.x += player.get_slope_status()


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
	
#	var normal = slope_ray.get_collision_normal()
	var normal = player.get_floor_normal()
	player.velocity.y += player.GRAV * GRAV_MULT
#	player.velocity.x = Util.lirpf(player.velocity.x,
#			player.MAX_SPEED * sign(normal.dot(Vector2.RIGHT)),
#			player.FRICTION_FAST * 0.5)
	player.velocity = player.velocity.slide(normal).clamped(1600)
	player.set_snap(true)
