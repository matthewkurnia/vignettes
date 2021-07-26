extends PlayerState


const GRAV_MULT = 1.5
const TERMINAL_VELO = 1600.0

export var buffer_path: NodePath

onready var buffer = get_node(buffer_path)


func _input(event):
	if Input.is_action_just_pressed("jump"):
		buffer.start()

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
	if player.get_wall_status() == 0:
		if player.velocity.y < 0:
			emit_signal("finished", "jump")
		else:
			emit_signal("finished", "fall")
	if buffer.time_left > 0:
		buffer.stop()
		player.velocity.y = min(-player.JUMP_STRENGTH,
								player.velocity.y * 0.8 - player.JUMP_STRENGTH)
		player.velocity.x = -player.get_wall_status() * player.JUMP_STRENGTH
		emit_signal("finished", "jump")
		return
	
	var grav_mult = GRAV_MULT
	var terminal_velo = 500
	if player.velocity.y < 0:
		if Input.is_action_pressed("slide"):
			grav_mult = GRAV_MULT * 4
			terminal_velo = TERMINAL_VELO
		if Input.is_action_pressed("jump"):
			grav_mult = 1.0
		else:
			grav_mult = GRAV_MULT * 2
	else:
		if Input.is_action_pressed("slide"):
			grav_mult = GRAV_MULT * 2
			terminal_velo = TERMINAL_VELO
		else:
			grav_mult = 0.3
	if sign(player.direction) * player.get_wall_status() != -1:
		player.velocity.x = Util.lirpf(player.velocity.x,
				player.MAX_SPEED * player.get_wall_status(), player.ACCEL)
	player.velocity.y = min(player.velocity.y + player.GRAV * grav_mult, terminal_velo)
	handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR)
