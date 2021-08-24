class_name TitleCard
extends Control


export var delay = 5.0
export(String, FILE) var scene_path
export(String) var text

onready var timer = Timer.new()
onready var label = $CenterContainer/Title


func _ready():
#	get_viewport().set_canvas_transform(Transform2D(0, Vector2.ZERO))
	get_viewport().call_deferred("set_canvas_transform", Transform2D(0, Vector2.ZERO))
	add_child(timer)
	timer.connect("timeout", self, "change_scene")
	timer.one_shot = true
	timer.autostart = true
	timer.start(delay)
	label.text = text
	Music.change_deck("silence")


func _input(event):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		timer.stop()
		change_scene()


func change_scene():
	Game.change_scene(scene_path)
