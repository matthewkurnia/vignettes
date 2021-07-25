extends Particles2D


var time = 0

onready var player = Player.get_player_node()


func _process(delta):
	if player.is_on_floor():
		self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
				abs(player.velocity.x) > player.MAX_SPEED*1.5)
	else:
		self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
				abs(player.velocity.x) > player.MAX_SPEED*2.2)
	self.rotation = player.velocity.x / player.MAX_SPEED * 0.5
