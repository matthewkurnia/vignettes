tool
extends Area2D


export var extents = Vector2(1920, 1080) setget set_extents
export var center_position = Vector2.ZERO setget set_center_pos
export var focus_amount = 0.8 setget set_focus_amount
export var margin = Vector2(100, 100) setget set_margin
export var lock_horizontal = false setget set_lock_horizontal
export var lock_vertical = false setget set_lock_vertical

onready var collision = $CollisionShape2D


func set_extents(value):
	extents = value
	update()


func set_center_pos(value):
	center_position = value
	update()


func set_focus_amount(value):
	focus_amount = value
	update()


func set_margin(value):
	margin = value
	update()


func set_lock_horizontal(value):
	lock_horizontal = value
	update()


func set_lock_vertical(value):
	lock_vertical = value
	update()


func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-0.5 * extents/focus_amount + margin,
				extents/focus_amount - 2*margin),
				Color.lightgreen, false, 5.0)
		draw_rect(Rect2(-0.5 * extents/focus_amount,
				extents/focus_amount),
				Color.lightseagreen, false, 5.0)
		if lock_horizontal:
			draw_line(Vector2(0, -400), Vector2(0, 400), Color.red, 5.0)
		if lock_vertical:
			draw_line(Vector2(-400, 0), Vector2(400, 0), Color.red, 5.0)
		draw_circle(center_position, 20, Color.lightcyan)


func _ready():
	if Engine.editor_hint:
		return
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = extents * 0.5 / focus_amount - margin


func get_global_focus_point():
	return self.global_position + center_position
