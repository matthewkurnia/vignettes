extends Node


signal state_override(state)

var current_state = ""
var prev_wall_status = 0
var prev_edge_status = false
var banish_position = Vector2.ZERO

onready var coyote = $Coyote
onready var buffer = $Buffer
onready var slide = $Slide
onready var player = Player.get_player_node()


func _physics_process(delta):
	if current_state == "banished":
		player.global_position = banish_position
	if just_touched_wall():
		emit_signal("state_override", "wall_slide")
	if not player.is_on_floor() and just_reached_edge():
		emit_signal("state_override", "climb")
	if Input.is_action_just_pressed("slide"):
		slide.start()
	player.direction = sign(Input.get_action_strength("move_right") -
					  Input.get_action_strength("move_left"))
	player.sliding = Input.is_action_pressed("slide")
	
#	Handling Jump
	if player.is_on_floor():
		coyote.start()
		if buffer.time_left > 0:
			buffer.stop()
			emit_signal("state_override", "jump")
			jump()
			return
	if Input.is_action_just_pressed("jump"):
		buffer.start()
		if coyote.time_left > 0:
			emit_signal("state_override", "jump")
			jump()


func _input(event):
	if current_state == "banished":
		return


func jump():
	var mul = 1.0
	if slide.time_left > 0:
		mul = 1.5
	player.velocity.y = min(-player.JUMP_STRENGTH,
			player.velocity.y * 0.5 - player.JUMP_STRENGTH * mul)


func launch(direction, speed):
	player.velocity = direction.normalized() * speed
	emit_signal("state_override", "jump")


func state_changed(state):
	current_state = state


func just_touched_wall():
	if player.is_on_floor():
		prev_wall_status = 0
		return false
	if player.get_wall_status() != prev_wall_status:
		prev_wall_status = player.get_wall_status()
		return player.get_wall_status() != 0
	return false


func just_reached_edge():
	if prev_edge_status:
		prev_edge_status = player.get_edge_status()
		return false
	prev_edge_status = player.get_edge_status()
	return prev_edge_status
