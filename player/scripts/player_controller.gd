extends Node


signal state_override(state)

onready var coyote = $Coyote
onready var buffer = $Buffer
onready var player = Player.get_player_node()


func _physics_process(delta):
	if player.is_on_floor():
		coyote.start()
		if buffer.time_left > 0:
			emit_signal("state_override", "jump")


func _unhandled_input(event):
	if Input.is_action_just_pressed("jump"):
		buffer.start()
		if coyote.time_left > 0:
			emit_signal("state_override", "jump")
	player.dir = sign(Input.get_action_strength("move_right") -
					  Input.get_action_strength("move_left"))
