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

export var rot_degrees = 0.0
export var duration = 1.0
export var delay = 0.0
export(TransitionType) var transition_type

onready var parent = get_parent()
onready var tween = $Tween
onready var timer = $Timer


func _ready():
	start_rotation_delayed()


func start_rotation_delayed():
	timer.start(delay)
	yield(timer, "timeout")
	start_rotation()


func start_rotation():
	var starting_rotation = fmod(parent.rotation_degrees, 360)
	tween.interpolate_property(parent, "rotation_degrees", starting_rotation,
			starting_rotation + rot_degrees, duration, transition_type)
	tween.start()

