extends Area2D


export(String, FILE) var next_scene


func on_body_entered(body):
	if body == Player.get_player_node():
		Game.change_scene(next_scene)
		Demo.set_spawn(Vector2.ZERO)
