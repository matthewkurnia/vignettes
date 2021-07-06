extends Node2D


export var spear_path: NodePath

var curr_anim = ""

onready var spear = get_node(spear_path)


func _process(delta):
	if ["charge", "thrust"].has(curr_anim):
		print("ASDF")
		spear.visible = true
	else:
		spear.visible = false


func _on_PlayerPuppet_animation_started(anim_name):
	curr_anim = anim_name
