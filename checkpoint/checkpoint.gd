tool
extends Area2D


export var size = Vector2(300, 300) setget set_size
export var spawn_offset = Vector2.ZERO setget set_spawn_offset

var player

onready var collision = $CollisionShape2D


func set_size(value):
	size = value
	update()


func set_spawn_offset(value):
	spawn_offset = value
	update()


func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-0.5*size, size), Color.green, false, 5.0)
		draw_arc(spawn_offset, 10, -0.1, 2*PI, 30, Color.greenyellow, 5.0)


func _ready():
	if Engine.editor_hint:
		return
	player = Player.get_player_node()
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = 0.5 * size


func on_body_entered(body):
	if body == player:
		Player.set_spawn_position(self.global_position + spawn_offset)
