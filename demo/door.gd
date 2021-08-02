extends StaticBody2D


export var Indicator: PackedScene

var keys = []
var indicators = []
var keys_collected = 0
var opened = false

onready var animation_player = $AnimationPlayer


func _ready():
	for key in get_tree().get_nodes_in_group("key"):
		if key.door == self:
			keys.append(key)
	add_indicators(keys)


func add_indicators(key_array):
	var n = key_array.size()
	var offset = (n-1) * -20
	for i in range(n):
		var indicator = Indicator.instance()
		indicator.position.x = offset + i * 40
		key_array[i].connect("collected", self, "collect")
		indicators.append(indicator)
		self.add_child(indicator)


func collect():
	if keys_collected == indicators.size():
		return
	keys_collected += 1


func open():
	if opened:
		return
	opened = true
	collision_layer = 0
	collision_mask = 0
	animation_player.play("open")
	pass


func on_body_entered(body):
	if body == Player.get_player_node():
		for i in range(keys_collected):
			indicators[i].collect()
		if keys_collected == keys.size():
			open()
