extends RemoteTransform2D


export(Game.Layer) var layer = Game.Layer.OVERLAY
export var node_path: NodePath


func _ready():
	self.modulate = Color.black
	var remote_transform = RemoteTransform2D.new()
	remote_transform.position = self.position
	call_deferred("reparrent", remote_transform)


func reparrent(rt):
	get_parent().add_child(rt)
	get_parent().remove_child(self)
	Game.add_to_viewport(self, layer)
	rt.remote_path = self.get_path()
#	print(self.get_path())
