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

enum {TO_TARGET, TO_INIT}

export var target_scale = Vector2(1, 1)
export var duration_to_target = 1.0
export var duration_to_init = 1.0
export var delay = 0.0
export(TransitionType) var transition_to_target
export(TransitionType) var transition_to_init

var state = TO_TARGET
var init_scale = Vector2(1, 1)

onready var parent = get_parent()
onready var tween = $Tween
onready var timer = $Timer


func start_scale_tween_delayed():
	timer.start(delay)
	yield(timer, "timeout")
	start_scale_tween()


func start_scale_tween():
	var duration
	var transition
	var t_scale
	match state:
		TO_TARGET:
			duration = duration_to_target
			transition = transition_to_target
			t_scale = target_scale
			state = TO_INIT
		TO_INIT:
			duration = duration_to_init
			transition = transition_to_init
			t_scale = init_scale
			state = TO_TARGET
	tween.interpolate_property(parent, "scale", parent.scale, t_scale, duration, transition)
	tween.start()
