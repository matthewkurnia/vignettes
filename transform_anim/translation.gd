tool
extends Node2D


enum TransitionType {
	LINEAR,
	SINE,
	QUINT,
	QUART,
	QUAD,
	EXPO,
	ELASTIC,
	CUBIC,
	CIRC,
	BOUNCE,
	BACK
}

export (PoolVector2Array) var offset = [Vector2.ZERO] setget set_offset
export var duration = 1.0
export (TransitionType) var transition_type

var index = 0

onready var n = offset.size()
onready var parent = get_parent()
onready var init_pos = parent.position
onready var tween = $Tween


func set_offset(value):
	offset = value
	update()


func _draw():
	if Engine.editor_hint:
		for point in offset:
			draw_circle(point, 6.0, Color.yellow)


func _ready():
	if Engine.editor_hint:
		return
	go_to_next_pos()


func go_to_next_pos():
	tween.interpolate_property(parent, "position", init_pos + offset[index],
			init_pos + offset[(index + 1) % n], duration, transition_type)
	tween.start()
	index = (index + 1) % n
