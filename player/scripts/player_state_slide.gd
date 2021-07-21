extends PlayerState


const GRAV_MULT = 2

export var slope_detector_path: NodePath

onready var slope_detector = get_node(slope_detector_path)


func enter():
	player.set_snap(true)
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
	if abs(temp) < 0.05 and slope_detector.is_colliding():
		temp = 0
	player.velocity.x = Util.lirpf(player.velocity.x,
			player.MAX_SPEED * sign(temp),
			player.FRICTION_FAST * 0.5)
#	handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL)
