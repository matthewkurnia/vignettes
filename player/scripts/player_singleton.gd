extends Node


signal state_override(state)

export var PlayerDeath: PackedScene

var health: int
var actor: Node
var damage: int = 1
var spawn_position := Vector2.ZERO
var fade: ColorRect
var camera

onready var respawn_delay = $RespawnDelay
onready var fade_delay = $FadeDelay


func set_player_node(node):
	actor = node


func get_player_node():
	return actor


func set_spawn_position(pos: Vector2):
	spawn_position = pos


func start_death_sequence():
	var player_death = PlayerDeath.instance()
	player_death.global_position = actor.global_position
	actor.get_parent().add_child(player_death)
	Cam.shake(0.1, 16)
	emit_signal("state_override", "banished")
	
	respawn_delay.start()
	yield(respawn_delay, "timeout")
	
	fade.fade_in()
	
	fade_delay.start()
	yield(fade_delay, "timeout")
	
	fade.fade_out()
	actor.global_position = spawn_position
	Cam.reset_camera_position()
	emit_signal("state_override", "fall")
