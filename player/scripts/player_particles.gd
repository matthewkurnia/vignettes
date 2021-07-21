extends Particles2D


onready var player = Player.get_player_node()


func _process(delta):
	self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
			abs(player.velocity.x) > player.MAX_SPEED*1.5)
#	self.emitting = player.velocity.length() > player.MAX_SPEED
