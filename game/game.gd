extends Node2D


enum Layer {MAIN, OVERLAY, BACKGROUND}

var main
var overlay
var background


func _process(delta):
	if main and overlay and background:
		overlay.transform = main.get_canvas_transform()
		background.transform = main.get_canvas_transform()


func add_to_viewport(node: Node2D, layer):
	match layer:
		Layer.OVERLAY:
			overlay.add_child(node)
		Layer.BACKGROUND:
			background.add_child(node)
		_:
			pass
