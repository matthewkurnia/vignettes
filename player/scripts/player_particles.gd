extends Particles2D


var time = 0

onready var player = Player.get_player_node()


func _process(delta):
	if player.is_on_floor() or player.is_on_wall():
		time = OS.get_ticks_msec()
		self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
				abs(player.velocity.x) > player.MAX_SPEED*1.5)
	elif OS.get_ticks_msec() - time < 400:
		self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
				abs(player.velocity.x) > player.MAX_SPEED*2)
	else:
		self.emitting = false
	self.rotation = Util.clamp_signed(player.velocity.x / player.MAX_SPEED * 0.5, 0.0, deg2rad(75))
