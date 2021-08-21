extends Node2D


export(String, FILE) var next_scene


func _on_DialogPopup_tree_exited():
	Game.change_scene(next_scene)
