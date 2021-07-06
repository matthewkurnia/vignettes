extends KinematicBody2D


const UP_DIRECTION = Vector2(0, -1)
const SNAP_VECTOR = Vector2(0, 70.0)
const GRAV = 25.0
const MAX_SPEED = 460.0
const ACCEL = 40
const ACCEL_AIR = 30
const FRICTION = 30
const FRICTION_FAST = 25
const FRICTION_AIR = 20
const FRICTION_AIR_FAST = 17
const JUMP_STRENGTH = 900.0

var velocity = Vector2()
var snap = Vector2()
var dir = 0

onready var state_machine = $StateMachine
onready var rig = $PlayerRig
onready var controller = $PlayerController
onready var floor_ray_r = $FloorRayRight
onready var floor_ray_l = $FloorRayLeft


func _init():
	Player.set_player_node(self)


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		velocity.x = dir * 1000
	state_machine.update(delta)
	handle_movement()


func handle_movement():
#	Created due to weird issues with steep slopes and behaviour of move_and_slide
	var v = Vector2()
	if floor_ray_r.is_colliding():
		v = Vector2(min(velocity.x, 0), velocity.y)
		velocity.x = move_and_slide_with_snap(v, snap, UP_DIRECTION, true).x
		velocity.y = min(velocity.y, 2000)
		return
	elif floor_ray_l.is_colliding():
		v = Vector2(max(velocity.x, 0), velocity.y)
		velocity.x = move_and_slide_with_snap(v, snap, UP_DIRECTION, true).x
		velocity.y = min(velocity.y, 2000)
		return
	velocity.y = move_and_slide_with_snap(velocity, snap, UP_DIRECTION, true).y
	return


func set_snap(is_snapped):
	if is_snapped:
		snap = SNAP_VECTOR
		return
	snap = Vector2.ZERO
