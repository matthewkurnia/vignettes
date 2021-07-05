extends Node2D


export var dimension = Vector2()

onready var anim_state_machine = $AnimationTree.get("parameters/playback")


func play(anim_name: String):
	anim_state_machine.travel(anim_name)


func play_immediate(anim_name: String):
	anim_state_machine.start(anim_name)


func get_dimension():
	return dimension
