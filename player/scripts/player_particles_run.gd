extends Particles2D




func _process(delta):
	var player = Player.get_player_node()
	if not player:
		return
	self.emitting = player.is_on_floor() and abs(player.velocity.x) > 250
	self.rotation = -sign(player.velocity.x) - player.get_floor_normal().angle_to(Vector2.UP)
