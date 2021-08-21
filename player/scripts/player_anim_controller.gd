extends Node


const LAND_SCALE = Vector2(1.3, 0.75)

export var sprite_path: NodePath
export var clear_path: NodePath
export var animation_tree_path: NodePath

var curr_anim = ""

onready var player = Player.get_player_node()
onready var sprite = get_node(sprite_path)
onready var clear = get_node(clear_path)
onready var rig = get_parent()
onready var init_pos = rig.position
onready var animation_tree = get_node(animation_tree_path)


func _ready():
	get_parent().call_deferred("play_immediate", "idle")


func _process(delta):
	if ["wall_slide", "slide"].has(curr_anim):
		$Slide.volume_db = min(player.velocity.length()/10 - 80, -5)
	else:
		$Slide.volume_db = -80
	
#	Banished special case
	if curr_anim == "banished":
		rig.visible = false
	else:
		rig.visible = true
#	Player face direction.
	if curr_anim == "slide" and abs(player.velocity.x) > 0.5:
		set_flip(player.velocity.x < 0)
	elif curr_anim == "wall_slide":
		set_flip(player.get_wall_status() > 0)
	else:
		if player.direction < 0:
			set_flip(true)
		elif player.direction > 0:
			set_flip(false)
	
#	Other anims
	if not player.is_on_floor():
		var ratio = abs(player.velocity.y)/player.JUMP_STRENGTH
		sprite.scale.x = 1 - ratio * 0.12
		sprite.scale.y = 1 + ratio * 0.13
		var ratio_x = player.velocity.x/(player.MAX_SPEED * 2)
		if curr_anim == "wall_slide":
			var init_angle = player.get_wall_normal().angle_to(Vector2.UP)
			rig.rotation = lerp(rig.rotation,
					(abs(init_angle) - 0.5*PI) * -sign(init_angle), 0.1)
		if player.velocity.y < 0:
			rig.rotation = lerp(rig.rotation, ratio_x * PI*0.07, 0.4)
		else:
			rig.rotation = lerp(rig.rotation, -ratio_x * PI*0.1, 0.05)
		rig.position.y = lerp(rig.position.y, init_pos.y, 0.1)
	else:
		sprite.scale.x = lerp(sprite.scale.x, 1, 0.1)
		sprite.scale.y = lerp(sprite.scale.y, 1, 0.1)
		rig.position.y = lerp(rig.position.y,
				init_pos.y +
				abs(tan(player.get_floor_normal().angle_to(Vector2.UP))) * 5,
				0.1)
		rig.rotation = lerp(rig.rotation,
				Util.clamp_signed(player.get_floor_normal().angle() + 0.5*PI, 0, 0.25*PI),
				0.2)
	
	animation_tree["parameters/run/TimeScale/scale"] = min(max(0.5 +
			0.5 * abs(player.velocity.x)/player.MAX_SPEED, 1.0), 1.5)
	var glide = (Input.is_action_pressed("jump") and
			not Input.is_action_pressed("slide"))
	if glide and curr_anim == "fall":
		rig.play("glide")
	elif not glide and curr_anim == "glide":
		rig.play("fall")
#	animation_tree["parameters/jump/Add2/add_amount"] = lerp(
#		animation_tree["parameters/jump/Add2/add_amount"], flap, 0.07
#	)
#	animation_tree["parameters/fall/Add2/add_amount"] = lerp(
#		animation_tree["parameters/fall/Add2/add_amount"], flap, 0.07
#	)


func _on_PlayerRig_anim_played(anim_name):
#	print(anim_name)
	if anim_name == "charge":
		get_parent().play_immediate(anim_name)
	if curr_anim == "fall" and ["idle", "run"].has(anim_name):
		$Land.play()
		sprite.scale.x = 1.3
		sprite.scale.y = 0.75
	curr_anim = anim_name


func set_flip(value):
	sprite.flip_h = value
	clear.flip_h = value
