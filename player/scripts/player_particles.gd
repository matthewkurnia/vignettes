extends Particles2D


var time = 0

onready var player = Player.get_player_node()


func _process(delta):
	self.emitting = (abs(player.velocity.y) > player.JUMP_STRENGTH or
			abs(player.velocity.x) > player.MAX_SPEED*1.5)
	self.rotation = player.velocity.x / player.MAX_SPEED * 0.3
