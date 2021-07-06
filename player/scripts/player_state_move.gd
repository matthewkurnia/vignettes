class_name PlayerStateMove
extends PlayerState


func handle_movement(friction_fast, friction, acceleration):
	if abs(player.velocity.x) > player.MAX_SPEED:
		var t = sign(player.dir) * sign(player.velocity.x)
		if t > 0:
			friction_fast *= 0.05
		elif t < 0:
			friction_fast *= 2
		player.velocity.x = Util.lirpf(player.velocity.x,
									   player.dir * player.MAX_SPEED,
									   friction_fast)
	else:
		if player.dir == 0:
			player.velocity.x = Util.lirpf(player.velocity.x, 0,
										   friction)
		else:
			player.velocity.x = Util.lirpf(player.velocity.x,
										   player.dir * player.MAX_SPEED,
										   acceleration)
