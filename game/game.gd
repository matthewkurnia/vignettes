extends Node2D


enum Layer {MAIN, OVERLAY, PARTICLES}

var main
var overlay
var particles


func _process(delta):
	if main and overlay and particles:
		overlay.transform = main.get_canvas_transform()
		particles.transform = main.get_canvas_transform()


func add_to_viewport(node: Node2D, layer):
	match layer:
		Layer.OVERLAY:
			overlay.add_child(node)
		Layer.PARTICLES:
			particles.add_child(node)
		_:
			pass
