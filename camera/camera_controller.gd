extends Area2D


const MIN_WEIGHT = 0.001
const MAX_WEIGHT = 0.07
const WEIGHT_ACCEL = 0.0007

var default_offset = Vector2.ZERO
var focus_box = null
var focus_amount = 1.0
var weight = MIN_WEIGHT
var canvas_transform = Transform2D(0, Vector2.ZERO)
var shake_strength = 0.0

onready var player = Player.get_player_node()
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
	if focus_box:
		target = 0.5 * get_viewport_rect().size - ((1-focus_amount) *
				player.global_position + focus_amount *
				focus_box.get_global_focus_point())
		if focus_box.lock_horizontal:
			target.x = 0.5 * get_viewport_rect().size.x - focus_box.get_global_focus_point().x
		if focus_box.lock_vertical:
			target.y = 0.5 * get_viewport_rect().size.y - focus_box.get_global_focus_point().y
	else:
		target = 0.5 * get_viewport_rect().size - player.global_position
	canvas_transform.origin = lerp(canvas_transform.origin, target, weight)
	weight = Util.lirpf(weight, MAX_WEIGHT, WEIGHT_ACCEL)
	get_viewport().set_canvas_transform(canvas_transform)
	pass


func reset_camera_position():
	canvas_transform.origin = 0.5 * get_viewport_rect().size - player.global_position


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
		weight = MIN_WEIGHT
		focus_box = null


func _on_ShakeTimer_timeout():
	shake_strength = 0
