class_name AirEnemy
extends Enemy


var target_velo = Vector2.ZERO
var origin = Vector2.ZERO


func _ready():
	set_origin(position)


func _physics_process(delta):
	if spear:
		self.global_position = spear.global_position
		velocity = move_and_slide(Vector2.ZERO)
		return
	if chasing:
		move(chase_speed * (player.global_position - self.global_position).normalized(),
			 chase_accel)
	velocity = Util.lirpv(velocity, target_velo, accel)
	velocity = move_and_slide(velocity)


func move(velo: Vector2, acceleration: float):
	target_velo = velo
	accel = acceleration
	set_direction(velo.dot(Vector2.RIGHT))


func move_to_player(speed: float, acceleration: float = ACCEL):
	var velo = speed * (player.global_position -
			   self.global_position).normalized()
	move(velo, acceleration)


func move_random(speed: float, acceleration: float = ACCEL):
	var dir = Vector2.RIGHT.rotated(randf() * 2*PI)
	var velo = (origin - self.position +
			Vector2.RIGHT * 0.001).rotated((randf() - 0.5) * PI).normalized()
	move(velo * speed, acceleration)


func knockback(value: Vector2):
	velocity = value * 1.5


func set_origin(pos: Vector2):
	origin = pos
