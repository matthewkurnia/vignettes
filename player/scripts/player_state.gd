class_name PlayerState
extends State


onready var player = Player.get_player_node()


func handle_movement(friction_fast, friction, acceleration, grounded: bool = true, fric_mult = 0.1):
	if abs(player.velocity.x) > player.MAX_SPEED:
		var t = sign(player.direction) * sign(player.velocity.x)
		if t > 0:
			friction_fast *= fric_mult
		elif t < 0:
			friction_fast *= 2
		player.velocity.x = Util.lirpf(player.velocity.x,
									   player.direction * player.MAX_SPEED,
									   friction_fast)
		if player.is_on_floor() and grounded:
			player.set_snap((sign(player.get_floor_normal().dot(Vector2.RIGHT)) ==
					sign(player.direction)) or player.get_floor_normal() == Vector2.UP)
	else:
		if player.direction == 0:
			player.velocity.x = Util.lirpf(player.velocity.x, 0,
										   friction)
		else:
			player.velocity.x = Util.lirpf(player.velocity.x,
										   player.direction * player.MAX_SPEED,
										   acceleration)
