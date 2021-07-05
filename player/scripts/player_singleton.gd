extends Node


var direction: int
var health: int
var actor: Node


func set_player_node(node):
	actor = node


func get_player_node():
	return actor
