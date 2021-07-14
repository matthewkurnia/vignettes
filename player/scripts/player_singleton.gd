extends Node


var direction: int
var health: int
var actor: Node
var orb: Node
var damage: int = 1


func set_player_node(node):
	actor = node


func get_player_node():
	return actor


func set_orb_node(node):
	orb = node


func get_orb_node():
	return orb
