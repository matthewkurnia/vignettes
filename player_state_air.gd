class_name PlayerAirState
extends PlayerState


func handle_air_movement():
	if abs(player.velocity.x) > player.MAX_SPEED:
		var fric_air = player.FRICTION_AIR_FAST
		if sign(player.dir) == sign(player.velocity.x):
			fric_air *= 0.1
		else:
			fric_air *= 16
		player.velocity.x = lerp(player.velocity.x,
								 player.dir * player.MAX_SPEED,
								 fric_air)
	else:
		if player.dir == 0:
			player.velocity.x = lerp(player.velocity.x, 0, player.FRICTION_AIR)
		elif player.dir < 0:
			player.velocity.x = max(player.velocity.x - player.ACCEL_AIR,
									-player.MAX_SPEED)
		else:
			player.velocity.x = min(player.velocity.x + player.ACCEL_AIR,
									player.MAX_SPEED)
