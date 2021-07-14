extends Node2D


export var ignore_scale = false
export var scroll_scale = 1.0


func _ready():
	if not ignore_scale:
		self.scale = scroll_scale * Vector2(1, 1)


func _process(delta):
	self.position = (-get_canvas_transform().origin +
					get_viewport_rect().size/2) * (1 - scroll_scale)
