extends Area2D


signal player_visible(is_visible)

export var buffer_time = 3.0

var player_in_area = false
var chasing = false

onready var player = Player.get_player_node()
onready var buffer = $Buffer


func _ready():
	buffer.wait_time = buffer_time


func _physics_process(delta):
	var player_seen = raycast(player)
	if player_in_area:
		if player_seen:
			buffer.stop()
			set_chasing(true)
		elif chasing:
			start_buffer()
	elif chasing:
		if player_seen:
			buffer.stop()
		else:
			start_buffer()
	else:
		pass
	
#	if not player_seen:
#		if buffer.is_stopped():
#			buffer.start()
#	else:
#		buffer.stop()


func start_buffer():
	if buffer.is_stopped():
		buffer.start()


func set_chasing(value):
	if value == chasing:
		return
	if value:
		print("player seen")
		emit_signal("player_visible", true)
	chasing = value


func raycast(target):
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self.global_position,
			target.global_position, [self], collision_mask)
	return result.collider == player


func _on_PlayerDetector_body_entered(body):
	if body == player:
		player_in_area = true


func _on_PlayerDetector_body_exited(body):
	if body == player:
		player_in_area = false


func _on_Buffer_timeout():
	set_chasing(false)
	emit_signal("player_visible", false)
	print("player lost")
