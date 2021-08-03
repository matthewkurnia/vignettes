extends Node


enum Layer {MAIN, OVERLAY, PARTICLES, CLEAR}

var actor = null


func add_to_viewport(node: Node2D, layer):
	actor.add_to_viewport(node, layer)


func change_scene_to(scene: PackedScene):
	actor.change_scene_to(scene)
