extends Node


const LAND_SCALE = Vector2(1.3, 0.75)

export var sprite_path: NodePath
export var animation_tree_path: NodePath

var curr_anim = ""

onready var player = Player.get_player_node()
onready var sprite = get_node(sprite_path)
onready var init_pos = sprite.position
onready var rig = get_parent()
onready var animation_tree = get_node(animation_tree_path)


func _ready():
	get_parent().call_deferred("play_immediate", "idle")


func _on_PlayerRig_anim_played(anim_name):
	if curr_anim == "fall" and ["idle", "run"].has(anim_name):
		sprite.scale.x = 1.3
		sprite.scale.y = 0.75
	curr_anim = anim_name


func _process(delta):
#	Player face direction.
	if player.dir < 0:
		sprite.flip_h = true
	elif player.dir > 0:
		sprite.flip_h = false
	
#	Player Sprite scale and rotation animation.
	if not player.is_on_floor():
		var speed_y = abs(player.velocity.y)
		var ratio = speed_y/player.JUMP_STRENGTH
		sprite.scale.x = 1 - ratio * 0.12
		sprite.scale.y = 1 + ratio * 0.13
		rig.rotation = lerp(rig.rotation, 0, 0.2)
		sprite.position.y = lerp(sprite.position.y, init_pos.y, 0.1)
	else:
		sprite.scale.x = lerp(sprite.scale.x, 1, 0.1)
		sprite.scale.y = lerp(sprite.scale.y, 1, 0.1)
		sprite.position.y = lerp(sprite.position.y,
				init_pos.y +
				abs(tan(player.get_floor_normal().angle_to(Vector2.UP))) * 20,
				0.1)
		rig.rotation = lerp(rig.rotation,
				(player.get_floor_normal().angle() + PI/2) * 0.5,
				0.2)
	
	if curr_anim == "run":
		animation_tree["parameters/run/TimeScale/scale"] = (0.5 +
				0.5 * abs(player.velocity.x)/player.MAX_SPEED)
	else:
		animation_tree["parameters/run/TimeScale/scale"] = 1.0
