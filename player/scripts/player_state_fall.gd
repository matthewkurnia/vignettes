extends PlayerStateMove


const GRAV_MULT = 1.5
const TERMINAL_VELO = 1600.0


func enter():
	player.set_snap(false)


func update(delta):
	if player.is_on_floor():
		if player.dir != 0:
			emit_signal("finished", "run")
		else:
			emit_signal("finished", "idle")
	player.velocity.y = min(player.velocity.y + player.GRAV * GRAV_MULT, TERMINAL_VELO)
	
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR)
