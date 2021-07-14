extends PlayerState


const THRUST_SPEED = 900

export var controller_path: NodePath

var thrust_dir = 1
var y_velo = 0

onready var controller = get_node(controller_path)
onready var timer = $Timer


func enter():
	player.set_snap(player.is_on_floor())
	player.velocity.x = 0


func update(delta):
	if timer.time_left > 0:
		player.set_snap(sign(player.get_floor_normal().dot(Vector2.RIGHT)) ==
						sign(thrust_dir))
		return
	player.velocity.y += player.GRAV
	if player.is_on_floor():
		handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL, true, 0)
	else:
		handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR, true, 0)


func thrust(direction):
	timer.start()
	thrust_dir = direction
	y_velo = player.velocity.y
	if player.is_on_floor():
		player.velocity = player.get_floor_normal().rotated(thrust_dir*0.5*PI) * THRUST_SPEED
	else:
		player.velocity.x = thrust_dir * THRUST_SPEED
		player.velocity.y = 0


func _on_Duration_timeout():
	var next_state = "idle"
	if not player.is_on_floor():
		player.velocity.y = min(-400, y_velo)
		next_state = "jump"
	elif player.direction != 0:
		next_state = "run"
	emit_signal("finished", next_state)
