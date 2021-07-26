extends PlayerState


const GRAV_MULT = 2.0

var direction = 1
var time = 0


func enter():
	direction = player.get_edge_status()
	player.set_snap(false)
	player.velocity.y = -600
	time = OS.get_ticks_msec()


func update(delta):
	if player.velocity.y >= 0:
		emit_signal("finished", "fall")
	if Input.is_action_pressed("slide"):
		player.velocity.y = 1
		emit_signal("finished", "fall")
	if OS.get_ticks_msec() - time > 300:
		emit_signal("finished", "fall")
	
	player.velocity.y += player.GRAV
	player.velocity.x = direction * player.MAX_SPEED
