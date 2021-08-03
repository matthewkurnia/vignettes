extends Area2D


export var next_scene: PackedScene


func on_body_entered(body):
	if body == Player.get_player_node():
		Game.change_scene_to(next_scene)
