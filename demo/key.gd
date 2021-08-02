extends Area2D


signal collected

export var CollectEffect: PackedScene
export var door_path: NodePath

onready var player = Player.get_player_node()
onready var color_node = $ColorNode
onready var door = get_node(door_path)


func _ready():
	if Demo.get_key_collected(self):
		collect()


func collect():
	emit_signal("collected")
	Demo.set_key_collected(self)
	spawn_effect()
	self.visible = false
	set_deferred("monitoring", false)
	color_node.visible = false
	


func on_body_entered(body):
	if body == player:
		collect()


func spawn_effect():
	var collect_effect = CollectEffect.instance()
	collect_effect.position = self.position
	get_parent().call_deferred("add_child", collect_effect)
