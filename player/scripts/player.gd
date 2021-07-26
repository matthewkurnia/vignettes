extends KinematicBody2D


const UP_DIRECTION = Vector2(0, -1)
const SNAP_VECTOR = Vector2(0, 70.0)
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
var prev_velo

onready var state_machine = $StateMachine
onready var rig = $PlayerRig
onready var controller = $PlayerController
onready var floor_ray_r = $Raycasts/FloorRayRight
onready var floor_ray_l = $Raycasts/FloorRayLeft
onready var wall_ray_r = $Raycasts/WallRayRight
onready var wall_ray_l = $Raycasts/WallRayLeft
onready var climb_ray_r = $Raycasts/ClimbRayRight
onready var climb_ray_l = $Raycasts/ClimbRayLeft
onready var slope_r = $Raycasts/SlopeDetectorRight
onready var slope_l = $Raycasts/SlopeDetectorLeft
onready var slope = $Raycasts/Slope


func _init():
	Player.set_player_node(self)


func _ready():
	Player.connect("state_override", state_machine, "change_state")


func _physics_process(delta):
	state_machine.update(delta)
	prev_velo = velocity
	handle_movement()


func handle_movement():
#	Created due to weird issues with steep slopes and behaviour of move_and_slide
	var floor_threshold = deg2rad(45)
	if sliding:
		floor_threshold = deg2rad(80)
	var velo = move_and_slide_with_snap(velocity, snap, UP_DIRECTION,
			not sliding, 4, floor_threshold)
	var collision
	if get_slide_count() > 0:
		collision = get_slide_collision(0)
	if collision:
		if collision.normal.dot(Vector2.UP) >= cos(0.25*PI):
			velocity.y = velo.y
		else:
			velocity = velo
	return


func set_snap(is_snapped):
	if is_snapped:
		snap = SNAP_VECTOR
		return
	snap = Vector2.ZERO


func get_floor_normal():
	if is_on_floor():
		if slope.is_colliding() and slope.get_collision_normal().dot(Vector2.UP) >= 0.68:
			return slope.get_collision_normal()
		return .get_floor_normal()
	return Vector2.UP


func get_wall_normal():
	if not wall_ray_l.is_colliding() and not wall_ray_r.is_colliding():
		return Vector2.ZERO
	elif wall_ray_l.is_colliding():
		return wall_ray_l.get_collision_normal()
	return wall_ray_r.get_collision_normal()


func get_wall_status():
#	returns 0 if not on wall.
#	returns 1 or -1 depending on which side of wall is colliding
	var normal = get_wall_normal()
	if normal:
		return -sign(normal.dot(Vector2.RIGHT))
	return 0


func is_on_wall():
	return get_wall_status() != 0


func get_edge_status():
#	for climbing special case
	if wall_ray_l.is_colliding() and not climb_ray_l.is_colliding() and direction < 0:
		return -1
	if wall_ray_r.is_colliding() and not climb_ray_r.is_colliding() and direction > 0:
		return 1
	return 0


func get_slope_status():
#	returns 0 if not approaching slope.
#	returns direction of slope otherwise.
	var not_slope = (not slope_l.is_colliding() and not slope_r.is_colliding() or
			(slope_l.is_colliding() and
			slope_l.get_collision_normal().dot(Vector2.UP) >= 0.95 and
			slope_r.is_colliding() and
			slope_r.get_collision_normal().dot(Vector2.UP) >= 0.95))
	if not_slope:
		return 0
	
	var space_state = get_world_2d().direct_space_state
	var mult = 1
	var collision_point = slope_l.get_collision_point()
	if slope_r.is_colliding() and slope_r.get_collision_normal().dot(Vector2.UP) > 0.95:
		collision_point = slope_r.get_collision_point()
		mult = -1
	var result = space_state.intersect_ray(
		collision_point + Vector2(mult * 35, 5),
		collision_point + Vector2(0, 5), [self], 1
	)
	if result:
#		print(result.normal)
#		print(result.position.x - collision_point.x)
		return result.position.x - collision_point.x + mult*5
	return 0


func get_ramp_status():
	if not floor_ray_l.is_colliding() and floor_ray_r.is_colliding():
		return velocity.y < 0
	if floor_ray_l.is_colliding() and not floor_ray_r.is_colliding():
		return velocity.y < 0
	return false
