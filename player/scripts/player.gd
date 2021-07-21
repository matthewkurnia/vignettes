extends KinematicBody2D


const UP_DIRECTION = Vector2(0, -1)
const SNAP_VECTOR = Vector2(0, 70.0)
const GRAV = 25.0
const MAX_SPEED = 360.0
const ACCEL = 30
const ACCEL_AIR = 20
const FRICTION = 20
const FRICTION_FAST = 15
const FRICTION_AIR = 15
const FRICTION_AIR_FAST = 12
const JUMP_STRENGTH = 700.0

var velocity = Vector2()
var snap = Vector2()
var direction = 0
var sliding = false

onready var state_machine = $StateMachine
onready var rig = $PlayerRig
onready var controller = $PlayerController
onready var floor_ray_r = $FloorRayRight
onready var floor_ray_l = $FloorRayLeft
onready var wall_ray_r1 = $WallRayRight1
onready var wall_ray_r2 = $WallRayRight2
onready var wall_ray_l1 = $WallRayLeft1
onready var wall_ray_l2 = $WallRayLeft2


func _init():
	Player.set_player_node(self)


func _physics_process(delta):
	state_machine.update(delta)
	handle_movement()


func handle_movement():
#	Created due to weird issues with steep slopes and behaviour of move_and_slide
	if sliding:
		velocity = move_and_slide_with_snap(velocity, snap, UP_DIRECTION,
				not floor_ray_r.is_colliding() and not floor_ray_l.is_colliding(),
				4, deg2rad(80))
		return
	var v = Vector2()
	if floor_ray_r.is_colliding():
		v = Vector2(min(velocity.x, 0), velocity.y)
		velocity = move_and_slide_with_snap(v, snap, UP_DIRECTION, true)
#		velocity.y = min(velocity.y, 2000)
		return
	elif floor_ray_l.is_colliding():
		v = Vector2(max(velocity.x, 0), velocity.y)
		velocity = move_and_slide_with_snap(v, snap, UP_DIRECTION, true)
#		velocity.y = min(velocity.y, 2000)
		return
	velocity.y = move_and_slide_with_snap(velocity, snap, UP_DIRECTION, true).y
	return


func set_snap(is_snapped):
	if is_snapped:
		snap = SNAP_VECTOR
		return
	snap = Vector2.ZERO


func get_wall_status():
#	returns 0 if not on wall.
#	Returns 1 or -1 depending on which side of wall is colliding
	var wall_l = wall_ray_l1.is_colliding() or wall_ray_l2.is_colliding()
	var wall_r = wall_ray_r1.is_colliding() or wall_ray_r2.is_colliding()
	if not wall_l and not wall_r:
		return 0
	elif wall_l:
		return -1
	return 1


func get_edge_status():
#	for climbing special case
	return ((wall_ray_l1.is_colliding() and not wall_ray_l2.is_colliding() and direction < 0) or
			(wall_ray_r1.is_colliding() and not wall_ray_r2.is_colliding() and direction > 0))
