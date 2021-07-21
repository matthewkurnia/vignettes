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
#	Banished special case
	if curr_anim == "banished":
		rig.visible = false
	else:
		rig.visible = true
#	Player face direction.
	if curr_anim == "slide" and abs(player.velocity.x) > 0.5:
		sprite.flip_h = player.velocity.x < 0
	elif curr_anim == "wall_slide":
		sprite.flip_h = player.get_wall_status() > 0
	else:
		if player.direction < 0:
			sprite.flip_h = true
		elif player.direction > 0:
			sprite.flip_h = false
	
#	Other anims
	if not player.is_on_floor():
		var ratio = abs(player.velocity.y)/player.JUMP_STRENGTH
		sprite.scale.x = 1 - ratio * 0.12
		sprite.scale.y = 1 + ratio * 0.13
		var ratio_x = player.velocity.x/(player.MAX_SPEED * 2)
		if player.velocity.y < 0:
			rig.rotation = lerp(rig.rotation, ratio_x * PI*0.07, 0.4)
		else:
			rig.rotation = lerp(rig.rotation, -ratio_x * PI*0.1, 0.05)
			
#		rig.rotation = lerp(rig.rotation, 0, 0.4)
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
	
	animation_tree["parameters/run/TimeScale/scale"] = min(max(0.5 +
			0.5 * abs(player.velocity.x)/player.MAX_SPEED, 1.0), 1.5)


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
