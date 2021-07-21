class_name ColorNode
extends Node2D


enum Layer {OVERLAY, PARTICLES}

export(Layer) var layer = Layer.OVERLAY


func _ready():
	self.modulate = Color.black
	var remote_transform = RemoteTransform2D.new()
	remote_transform.position = self.position
	call_deferred("reparrent", remote_transform)


func reparrent(rt):
	get_parent().add_child(rt)
	get_parent().remove_child(self)
	match layer:
		Layer.OVERLAY:
			Game.add_to_viewport(self, Game.Layer.OVERLAY)
		Layer.PARTICLES:
			Game.add_to_viewport(self, Game.Layer.PARTICLES)
	rt.remote_path = self.get_path()
	print(self.get_path())
