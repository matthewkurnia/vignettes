extends Area2D


const MIN_WEIGHT = 0.001
const RETURN_WEIGHT = 0.03
const MAX_WEIGHT = 0.07
const WEIGHT_ACCEL = 0.0007

var default_offset = Vector2(0, -180)
var focus_box = null
var focus_amount = 1.0
var weight = MIN_WEIGHT
var canvas_transform = Transform2D(0, Vector2.ZERO)
var shake_strength = 0.0

onready var player = Player.get_player_node()
onready var target_player = player.global_position
onready var shake_timer = $ShakeTimer


func _init():
	Cam.actor = self


func _ready():
	reset_camera_position()


func _process(delta):
#	shake
	canvas_transform.origin += shake_strength * Vector2.RIGHT.rotated(randf() * 2*PI)
	
#	normal follow
	var target
	var look_ahead_x = (max(abs(player.velocity.x) - player.MAX_SPEED, 0) *
			sign(player.velocity.x)) * 0.8
#	var look_ahead_y = (max(abs(player.velocity.y) - player.JUMP_STRENGTH, 0) *
#			sign(player.velocity.y)) * 0.5
	var look_ahead_y = max((player.velocity.y - 300) * 0.7, 0)
	target_player = lerp(
		target_player,
		player.global_position + Vector2(look_ahead_x, look_ahead_y) + default_offset,
		0.1
	)
#	target_player = player.global_position + player.velocity * 0.4 * Vector2(1, 0)
	if focus_box:
		target = 0.5 * get_viewport_rect().size - ((1-focus_amount) *
				target_player + focus_amount *
				focus_box.get_global_focus_point())
		if focus_box.lock_horizontal:
			target.x = 0.5 * get_viewport_rect().size.x - focus_box.get_global_focus_point().x
		if focus_box.lock_vertical:
			target.y = 0.5 * get_viewport_rect().size.y - focus_box.get_global_focus_point().y
	else:
		target = 0.5 * get_viewport_rect().size - target_player
	canvas_transform.origin = lerp(canvas_transform.origin, target, weight)
	weight = Util.lirpf(weight, MAX_WEIGHT, WEIGHT_ACCEL)
	get_viewport().set_canvas_transform(canvas_transform)
	pass


func reset_camera_position():
	canvas_transform.origin = 0.5 * get_viewport_rect().size - player.global_position
	target_player = player.global_position+ default_offset


func shake(duration: float, strength: float):
	shake_timer.start(duration)
	shake_strength = strength


func area_entered(area):
	if area.is_in_group("focus_box"):
		focus_amount = area.focus_amount
		weight = MIN_WEIGHT
		focus_box = area


func area_exited(area):
	if area.is_in_group("focus_box"):
		focus_box = null
		weight = RETURN_WEIGHT


func _on_ShakeTimer_timeout():
	shake_strength = 0
