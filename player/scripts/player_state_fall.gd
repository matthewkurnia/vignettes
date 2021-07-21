extends PlayerState


const GRAV_MULT = 1.5
const TERMINAL_VELO = 1600.0


func enter():
	player.set_snap(false)


func update(delta):
	if player.is_on_floor():
		if Input.is_action_pressed("slide"):
			emit_signal("finished", "slide")
		elif player.direction != 0:
			emit_signal("finished", "run")
		else:
			emit_signal("finished", "idle")
	
	var grav_mult = GRAV_MULT
	if Input.is_action_pressed("slide"):
		grav_mult *= 2
	player.velocity.y = min(player.velocity.y + player.GRAV * grav_mult, TERMINAL_VELO)
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR)
