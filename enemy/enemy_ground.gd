class_name GroundedEnemy
extends Enemy


export var gravity = 20
export var snap_distance = 70

var snap_vector = Vector2.DOWN
var target_h_velo = 0.0


func _physics_process(delta):
	if spear:
		self.global_position = spear.global_position
		return
	velocity.y += gravity
	if chasing:
		move_to_player(chase_speed, chase_accel)
	velocity.x = Util.lirpf(velocity.x, target_h_velo, accel)
	velocity.y = move_and_slide_with_snap(velocity, snap_distance * snap_vector,
			Vector2.UP, true).y
	set_snap(is_on_floor())


func set_snap(value: bool):
	if value:
		snap_vector = Vector2.DOWN
	else:
		snap_vector = Vector2.ZERO


func move_horizontal(velo: float, acceleration: float = ACCEL):
	target_h_velo = velo
	accel = acceleration
	set_direction(sign(velo))


func move_to_player(speed: float, acceleration: float = ACCEL):
	var d = sign(player.global_position - self.global_position)
	move_horizontal(d * speed, acceleration)


func move_opposite(speed: float, acceleration: float = ACCEL):
	move_horizontal(speed * -direction, acceleration)


func knockback(value: Vector2):
	velocity.x = value.x * 1.5
	jump(300)


func jump(strength):
	set_snap(false)
	velocity.y -= strength
