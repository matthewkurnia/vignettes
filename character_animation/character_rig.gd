extends Node2D


signal anim_played(anim_name)
signal anim_played_immediate(anim_name)

onready var sprite = $Sprite


func play(anim_name: String):
	emit_signal("anim_played", anim_name)


func play_immediate(anim_name: String):
	emit_signal("anim_played_immediate", anim_name)


func flip_h(value):
	sprite.flip_h = value
