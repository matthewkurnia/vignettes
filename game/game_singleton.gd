extends Node


signal scene_changed(path)

enum Layer {MAIN, OVERLAY, PARTICLES, CLEAR}

var actor = null
var is_menu = true


func add_to_viewport(node: Node2D, layer):
	actor.add_to_viewport(node, layer)


func change_scene(scene_path: String):
	actor.change_scene(scene_path)


func change_scene_to_menu():
	change_scene(actor.MAIN_PATH)


func change_scene_fresh():
	change_scene(Demo.STARTING_PATH)
