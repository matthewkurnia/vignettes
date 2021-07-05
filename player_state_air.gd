class_name PlayerAirState
extends PlayerState


func handle_air_movement():
	if abs(player.velocity.x) > player.MAX_SPEED:
		var fric_air = player.FRICTION_AIR_FAST
		var t = sign(player.dir) * sign(player.velocity.x)
		if t > 0:
			fric_air *= 0.1
		elif t < 0:
			fric_air *= 2
		player.velocity.x = Util.lirpf(player.velocity.x,
									   player.dir * player.MAX_SPEED,
									   fric_air)
	else:
		if player.dir == 0:
			player.velocity.x = Util.lirpf(player.velocity.x, 0,
										   player.FRICTION_AIR)
		else:
			player.velocity.x = Util.lirpf(player.velocity.x,
										   player.dir * player.MAX_SPEED,
										   player.ACCEL_AIR)
