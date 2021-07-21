extends Area2D


onready var player = Player.get_player_node()
onready var animation_player = $AnimationPlayer
onready var static_body = $StaticBody
onready var timer = $Timer

var has_player = false
var active = true


func _physics_process(delta):
	if not has_player:
		animation_player.play("reactivate")
		set_physics_process(false)


func body_entered(body):
	if body == player:
		if active:
			animation_player.play("deactivate")
			timer.start()
		has_player = true


func body_exited(body):
	if body == player:
		has_player = false


func set_collision_active(is_active := true):
	var temp = int(is_active)
	active = is_active
	static_body.collision_layer = temp
	static_body.collision_mask = temp


func timer_timeout():
	set_physics_process(true)
