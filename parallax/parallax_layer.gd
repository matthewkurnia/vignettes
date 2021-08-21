extends Node2D


export var ignore_scale = false
export var scroll_scale = 1.0


func _ready():
	if not ignore_scale:
		self.scale = scroll_scale * Vector2(1, 1)
	else:
		for child in get_children():
			if child is ObjectPlacer2D:
				for c in child.get_children():
					c.position *= scroll_scale
			elif child is ColorNode:
				for a in child.get_children():
					if a is ObjectPlacer2D:
						for c in a.get_children():
							c.position *= scroll_scale
			elif child.has_method("set_position"):
				child.position *= scroll_scale


func _process(delta):
	self.position = (-get_canvas_transform().origin +
					get_viewport_rect().size/2) * (1 - scroll_scale)
