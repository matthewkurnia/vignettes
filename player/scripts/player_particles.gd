extends Particles2D


var time = 0

onready var player = Player.get_player_node()


func _process(delta):
	self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
			abs(player.velocity.x) > player.MAX_SPEED*1.5)
#	if player.is_on_floor():
#		time = OS.get_ticks_msec()
#	self.emitting = self.emitting and OS.get_ticks_msec() - time < 300
#	self.emitting = Input.is_action_pressed("slide")
#	self.emitting = player.velocity.length() > player.MAX_SPEED
