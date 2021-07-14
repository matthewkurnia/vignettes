extends Node


signal state_override(state)

var current_state = ""

onready var coyote = $Coyote
onready var buffer = $Buffer
onready var player = Player.get_player_node()


func _physics_process(delta):
	player.direction = sign(Input.get_action_strength("move_right") -
					  Input.get_action_strength("move_left"))
	if ["thrust", "charge"].has(current_state):
		return
	if player.is_on_floor():
		coyote.start()
		if buffer.time_left > 0:
			emit_signal("state_override", "jump")
			player.velocity.y = -player.JUMP_STRENGTH


func _input(event):
	if ["thrust", "charge"].has(current_state):
		return
	if Input.is_action_just_pressed("jump"):
		buffer.start()
		if coyote.time_left > 0:
			emit_signal("state_override", "jump")
			player.velocity.y = -player.JUMP_STRENGTH


func state_changed(state):
	current_state = state
