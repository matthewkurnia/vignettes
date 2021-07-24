extends PlayerState


const GRAV_MULT = 1.5
const TERMINAL_VELO = 1600.0

var slide_assisted = false


func enter():
	slide_assisted = false
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
	var terminal_velo = TERMINAL_VELO
	if Input.is_action_pressed("jump"):
		grav_mult = 0.5
		terminal_velo *= 0.4
	if Input.is_action_pressed("slide"):
		grav_mult *= 2
		terminal_velo = TERMINAL_VELO
		if not slide_assisted and player.get_slope_status() != 0:
			slide_assisted = true
			player.position.x += player.get_slope_status()
	player.velocity.y = Util.lirpf(player.velocity.y, terminal_velo, player.GRAV * grav_mult)
#	player.velocity.y = min(player.velocity.y + player.GRAV * grav_mult, terminal_velo)
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR)
