extends Area2D


signal state_override(state)

export var controller_path: NodePath

onready var player = Player.get_player_node()
onready var player_controller = get_node(controller_path)


func area_entered(area):
	if area.is_in_group("piston"):
		Cam.shake(0.1, 6)
		player.velocity = area.get_player_bounce(player.velocity)
		emit_signal("state_override", "jump")
	if area.is_in_group("booster"):
		if area.activate():
			player_controller.banish_position = area.global_position
			if not area.is_connected("launch", player_controller, "launch"):
				area.connect("launch", player_controller, "launch")
			area.activate()
			emit_signal("state_override", "banished")
	if area.is_in_group("spikes"):
		player_controller.banish_position = player.global_position
		Player.start_death_sequence()
