extends Node2D


signal anim_played(anim_name)
signal anim_played_immediate(anim_name)


func play(anim_name: String):
	emit_signal("anim_played", anim_name)


func play_immediate(anim_name: String):
	emit_signal("anim_played_immediate", anim_name)
