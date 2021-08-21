extends Area2D


signal dialog_start
signal dialog_end

export(String) var timeline: String
export(PackedScene) var DialogPopup

var has_player = false

onready var animation_player = $AnimationPlayer
onready var indicator = $Indicator


func _input(event):
	if has_player and Input.is_action_just_pressed("move_up"):
		emit_signal("dialog_start")
		popup()


func popup():
	var dialog_popup = DialogPopup.instance()
	dialog_popup.timeline = timeline
	dialog_popup.connect("timeline_end", self, "terminate")
	get_parent().add_child(dialog_popup)
	animation_player.play("fade_out")
	yield(animation_player, "animation_finished")
	indicator.visible = false


func terminate():
	emit_signal("dialog_end")
	self.queue_free()


func on_body_entered(body):
	if body == Player.get_player_node():
		animation_player.play("popup")
		has_player = true


func on_body_exited(body):
	if body == Player.get_player_node():
		animation_player.play_backwards("popup")
		has_player = false
