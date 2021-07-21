extends Area2D


const MIN_WEIGHT = 0.001
const MAX_WEIGHT = 0.08
const WEIGHT_ACCEL = 0.002

var default_offset = Vector2.ZERO
var focus_box = null
var focus_amount = 1.0
var weight = MIN_WEIGHT
var canvas_transform = Transform2D(0, Vector2.ZERO)

onready var player = Player.get_player_node()


func _process(delta):
	var target
	if focus_box:
		target = 0.5 * get_viewport_rect().size - ((1-focus_amount) *
				player.global_position + focus_amount *
				focus_box.get_global_focus_point())
	else:
		target = 0.5 * get_viewport_rect().size - player.global_position
	canvas_transform.origin = lerp(canvas_transform.origin, target, weight)
	weight = Util.lirpf(weight, MAX_WEIGHT, WEIGHT_ACCEL)
	get_viewport().set_canvas_transform(canvas_transform)
	pass


func area_entered(area):
	if area.is_in_group("focus_box"):
		focus_amount = area.focus_amount
		weight = MIN_WEIGHT
		focus_box = area


func area_exited(area):
	if area.is_in_group("focus_box"):
		weight = MIN_WEIGHT
		focus_box = null
