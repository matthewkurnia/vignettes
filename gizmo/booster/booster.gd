extends Area2D


signal launch(direction)

const MAX_SPEED = 0.1
const ACCEL = 0.003
const PLAYER_LAUNCH_SPEED = 1400

export var line_path: NodePath

var active = false
var index = 0
var inc = -1
var angle = 0
var angular_velo = 0

onready var anim_state_machine = $AnimationTree.get("parameters/playback")
onready var cooldown = $Cooldown
onready var delay = $Delay
onready var tween = $Tween
onready var arrow = $ColorNode/Arrow
onready var path = get_parent()
onready var n = path.points.size()


func _ready():
	position = path.points[index]
	pass


func activate():
	if cooldown.time_left > 0 or active:
		return false
	active = true
	arrow.visible = false
	start_launch_sequence()
	return true


func deactivate():
	active = false
	cooldown.start()
	arrow.visible = true
	anim_state_machine.travel("deactivate")
	index = (index + 1) % n
	tween.remove_all()
	tween.interpolate_property(self, "position", position, path.points[index],
			4.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()


func start_launch_sequence():
	anim_state_machine.travel("activate")
	
	index = (index + 1) % n
	tween.remove_all()
	tween.interpolate_property(self, "position", position, path.points[index],
			0.8, Tween.TRANS_CUBIC)
	tween.start()
	delay.start()
	yield(delay, "timeout")
	
	emit_signal("launch", Vector2.UP.rotated(global_rotation), PLAYER_LAUNCH_SPEED)
	deactivate()


func get_banish_position():
	return path.global_position + path.points[index].rotated(get_parent().rotation)
