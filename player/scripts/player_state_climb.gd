extends PlayerState


const GRAV_MULT = 2.0

var direction = 1


func enter():
	direction = player.get_wall_status()
	player.set_snap(false)
	player.velocity.y = -500


func update(delta):
	if player.velocity.y >= 0:
		emit_signal("finished", "fall")
	if Input.is_action_pressed("slide"):
		player.velocity.y += player.GRAV * GRAV_MULT * 3
	
	player.velocity.y += player.GRAV
	player.velocity.x = direction * player.MAX_SPEED
