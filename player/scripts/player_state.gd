class_name PlayerState
extends State


onready var player = Player.get_player_node()


func _ready():
	player = Player.get_player_node()
