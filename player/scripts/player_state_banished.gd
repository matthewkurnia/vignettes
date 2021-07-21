extends PlayerState


const GRAV_MULT = 2.0

var direction = 1


func enter():
	player.set_snap(false)


func update(delta):
	player.velocity = Vector2.ZERO
