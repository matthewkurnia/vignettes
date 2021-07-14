extends Node


const LAND_SCALE = Vector2(1.3, 0.75)

export var sprite_path: NodePath
export var animation_tree_path: NodePath
export var spear_path: NodePath

var curr_anim = ""

onready var player = Player.get_player_node()
onready var sprite = get_node(sprite_path)
onready var rig = get_parent()
onready var init_pos = rig.position
onready var animation_tree = get_node(animation_tree_path)
onready var spear = get_node(spear_path)


func _ready():
	get_parent().call_deferred("play_immediate", "idle")


func _input(event):
	if event is InputEventMouseMotion and curr_anim == "charge":
		var rot = Util.get_relative_mouse_position(player).angle()
		turn(rot)


func _process(delta):
	if curr_anim == "thrust":
		sprite.scale = Vector2(1, 1)
		rig.position = init_pos
		return
	if curr_anim == "charge":
		return
#	Player face direction.
	if player.direction < 0:
		sprite.flip_h = true
	elif player.direction > 0:
		sprite.flip_h = false
	
	if not player.is_on_floor():
		var speed_y = abs(player.velocity.y)
		var ratio = speed_y/player.JUMP_STRENGTH
		sprite.scale.x = 1 - ratio * 0.12
		sprite.scale.y = 1 + ratio * 0.13
		rig.rotation = lerp(rig.rotation, 0, 0.4)
		rig.position.y = lerp(rig.position.y, init_pos.y, 0.1)
	else:
		sprite.scale.x = lerp(sprite.scale.x, 1, 0.1)
		sprite.scale.y = lerp(sprite.scale.y, 1, 0.1)
		rig.position.y = lerp(rig.position.y,
				init_pos.y +
				abs(tan(player.get_floor_normal().angle_to(Vector2.UP))) * 10,
				0.1)
		rig.rotation = lerp(rig.rotation,
				(player.get_floor_normal().angle() + PI/2),
				0.2)
	
	animation_tree["parameters/run/TimeScale/scale"] = max(0.5 +
			0.5 * abs(player.velocity.x)/player.MAX_SPEED, 1.0)


func turn(direction):
	if cos(direction) > 0:
		sprite.flip_h = false
		rig.rotation = direction/5
	else:
		sprite.flip_h = true
		rig.rotation = (direction - sign(direction) * PI)/5


func _on_PlayerRig_anim_played(anim_name):
	if anim_name == "charge":
		get_parent().play_immediate(anim_name)
	if curr_anim == "fall" and ["idle", "run"].has(anim_name):
		sprite.scale.x = 1.3
		sprite.scale.y = 0.75
	curr_anim = anim_name


func release(direction):
	spear.visible = false


func recall(direction):
	spear.visible = true


func _on_SpearController_thrust(direction):
	sprite.flip_h = direction < 0
