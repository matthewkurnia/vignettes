class_name ColorNode
extends Node2D

export(Game.Layer) var layer = Game.Layer.OVERLAY
export var remote_path: NodePath
export var duplicate_remote = false
export var modulate_color = true


func _ready():
	var remote_transform = RemoteTransform2D.new()
	remote_transform.position = self.position
	call_deferred("reparrent", remote_transform)


func reparrent(rt):
	if remote_path:
		var remote_node = get_node(remote_path)
		var prev_position = remote_node.global_position
		if duplicate_remote:
			remote_node = remote_node.duplicate()
#			removes children nodes to make sure there are no cycles
			for child in remote_node.get_children():
				remote_node.remove_child(child)
		else:
			remote_node.get_parent().remove_child(remote_node)
		self.add_child(remote_node)
		remote_node.global_position = prev_position
	if modulate_color:
		self.modulate = Color.black
	get_parent().add_child(rt)
	get_parent().remove_child(self)
	Game.add_to_viewport(self, layer)
	rt.remote_path = self.get_path()
#	print(self.get_path())
