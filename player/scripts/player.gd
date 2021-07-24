extends KinematicBody2D


const UP_DIRECTION = Vector2(0, -1)
const SNAP_VECTOR = Vector2(0, 120.0)
const GRAV = 25.0
const MAX_SPEED = 400.0
const ACCEL = 13
const ACCEL_AIR = 9
const FRICTION = 15
const FRICTION_FAST = 15
const FRICTION_AIR = 10
const FRICTION_AIR_FAST = 12
const JUMP_STRENGTH = 700.0

var velocity = Vector2()
var snap = Vector2()
var direction = 0
var sliding = false

onready var state_machine = $StateMachine
onready var rig = $PlayerRig
onready var controller = $PlayerController
onready var floor_ray_r = $Raycasts/FloorRayRight
onready var floor_ray_l = $Raycasts/FloorRayLeft
onready var wall_ray_r1 = $Raycasts/WallRayRight1
onready var wall_ray_r2 = $Raycasts/WallRayRight2
onready var wall_ray_l1 = $Raycasts/WallRayLeft1
onready var wall_ray_l2 = $Raycasts/WallRayLeft2
onready var climb_ray_r = $Raycasts/ClimbRayRight
onready var climb_ray_l = $Raycasts/ClimbRayLeft
onready var slope_r = $Raycasts/SlopeDetectorRight
onready var slope_l = $Raycasts/SlopeDetectorLeft
onready var slope_cr = $Raycasts/SlopeDetectorCenterRight
onready var slope_cl = $Raycasts/SlopeDetectorCenterLeft


func _init():
	Player.set_player_node(self)


func _ready():
	Player.connect("state_override", state_machine, "change_state")


func _physics_process(delta):
	state_machine.update(delta)
	var prev_velo = velocity
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
#	returns 1 or -1 depending on which side of wall is colliding
	var wall_l = wall_ray_l1.is_colliding() or wall_ray_l2.is_colliding()
	var wall_r = wall_ray_r1.is_colliding() or wall_ray_r2.is_colliding()
	if not wall_l and not wall_r:
		return 0
	elif wall_l:
		return -1
	return 1


func get_edge_status():
#	for climbing special case
	return ((wall_ray_l1.is_colliding() and not climb_ray_l.is_colliding() and direction < 0) or
			(wall_ray_r1.is_colliding() and not climb_ray_r.is_colliding() and direction > 0))


func get_slope_status():
#	returns 0 if not approaching slope.
#	returns direction of slope otherwise.
	if not slope_l.is_colliding() and not slope_r.is_colliding():
		return 0
	var space_state = get_world_2d().direct_space_state
	var l = ((slope_l.is_colliding() and
			slope_l.get_collision_normal().dot(Vector2.UP) > 0.95) and
			(not slope_r.is_colliding() or
			slope_r.get_collision_normal().dot(Vector2.UP) < 0.95))
	var r = ((slope_r.is_colliding() and
			slope_r.get_collision_normal().dot(Vector2.UP) > 0.95) and
			(not slope_l.is_colliding() or
			slope_l.get_collision_normal().dot(Vector2.UP) < 0.95))
	if l:
		var collision_point = slope_l.get_collision_point()
		var result = space_state.intersect_ray(
			collision_point + Vector2(50, 1),
			collision_point + Vector2(0, 1), [self], 1
		)
		if result:
			return result.position.x - collision_point.x + 7
	if r:
		var collision_point = slope_r.get_collision_point()
		var result = space_state.intersect_ray(
			collision_point + Vector2(-50, 1),
			collision_point + Vector2(0, 1), [self], 1
		)
		if result:
			return result.position.x - collision_point.x - 7
	return 0
