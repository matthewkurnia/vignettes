extends Node


signal state_changed(state)

export var initial_state: NodePath

var current_state
var previous_state

onready var states = {
	"idle" : $Idle,
	"run" : $Run,
	"jump": $Jump,
	"fall" : $Fall,
	"thrust" : $Thrust
}


func _ready():
	for state in states.values():
		state.connect("finished", self, "change_state")
	current_state = get_node(initial_state)
	current_state.enter()


func update(delta):
	current_state.update(delta)


func change_state(new_state):
	current_state.exit()
	previous_state = current_state
	current_state = states[new_state]
	current_state.enter()
	emit_signal("state_changed", new_state)
