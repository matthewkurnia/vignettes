extends Area2D


signal launch(direction)

const MAX_SPEED = 0.1
const ACCEL = 0.003
const PLAYER_LAUNCH_SPEED = 1400

var activated = false
var angle = 0
var angular_velo = 0

onready var anim_state_machine = $AnimationTree.get("parameters/playback")
onready var cooldown = $Cooldown


func _physics_process(delta):
	if not activated:
		angular_velo = Util.lirpf(angular_velo, 0, ACCEL)
		self.rotation += angular_velo
		return
	var dir = sign(Input.get_action_strength("move_right") -
				   Input.get_action_strength("move_left"))
	angular_velo = Util.lirpf(angular_velo, MAX_SPEED * dir, ACCEL)
	self.rotation += angular_velo
	if Input.is_action_just_pressed("jump"):
		deactivate()
		emit_signal("launch", Vector2.UP.rotated(rotation), PLAYER_LAUNCH_SPEED)


func activate():
	if cooldown.time_left > 0:
		return false
	activated = true
	anim_state_machine.travel("activate")
	return true


func deactivate():
	cooldown.start()
	activated = false
	anim_state_machine.travel("deactivate")
