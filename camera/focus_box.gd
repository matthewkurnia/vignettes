tool
extends Area2D


export var extents = Vector2(1920, 1080) setget set_extents, get_extents
export var center_position = Vector2.ZERO setget set_center_pos, get_center_pos
export var focus_amount = 0.8

onready var collision = $CollisionShape2D


func set_extents(value):
	extents = value
	update()


func get_extents():
	return extents


func set_center_pos(value):
	center_position = value
	update()


func get_center_pos():
	return center_position


func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-0.5 * extents, extents), Color.red, false, 5.0)
		draw_circle(center_position, 20, Color.orange)


func _ready():
	if Engine.editor_hint:
		return
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = extents * 0.5


func get_global_focus_point():
	return self.global_position + center_position
