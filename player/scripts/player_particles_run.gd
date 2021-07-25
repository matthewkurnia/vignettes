extends Particles2D


onready var player = Player.get_player_node()


func _process(delta):
	self.emitting = player.is_on_floor() and abs(player.velocity.x) > 250
	self.rotation = -sign(player.velocity.x) - player.get_floor_normal().angle_to(Vector2.UP)
