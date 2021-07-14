extends AnimationTree


export var initial_state = "idle"

onready var state_machine = self.get("parameters/playback")


func _ready():
	state_machine.start(initial_state)


func override_state(state: String):
	state_machine.start(state)


func set_player_seen(value: bool):
	self["parameters/conditions/player_seen"] = value


func set_player_lost(value: bool):
	self["parameters/conditions/player_lost"] = value


func set_player_visible(value: bool):
	set_player_seen(value)
	set_player_lost(not value)


func set_obstructed(value: bool):
	self["parameters/conditions/obstructed"] = value
