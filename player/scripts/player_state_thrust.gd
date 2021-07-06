extends PlayerStateMove


const THRUST_SPEED = 1000

export var controller_path: NodePath

var is_knockbacked = false

onready var controller = get_node(controller_path)


func enter():
	is_knockbacked = false


func update(delta):
	player.velocity.y += player.GRAV
	if player.is_on_floor():
		handle_movement(player.FRICTION_FAST, player.FRICTION, player.ACCEL)
	else:
		handle_movement(player.FRICTION_AIR_FAST, player.FRICTION_AIR, player.ACCEL_AIR)


func launch(dir):
	player.set_snap(false)
	player.velocity = THRUST_SPEED * Vector2.RIGHT.rotated(dir)


func knockback(dir):
	if not is_knockbacked:
		player.velocity = THRUST_SPEED * Vector2.RIGHT.rotated(dir) * 0.8
	is_knockbacked = true


func _on_Duration_timeout():
	var next_state = "idle"
	if not player.is_on_floor():
		next_state = "fall"
	elif player.dir != 0:
		next_state = "run"
	emit_signal("finished", next_state)
