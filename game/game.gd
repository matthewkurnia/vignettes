extends Node2D


export var main_path: NodePath
export var overlay_path: NodePath
export var particles_path: NodePath
export var clear_path: NodePath

onready var main = get_node(main_path)
onready var overlay = get_node(overlay_path)
onready var particles = get_node(particles_path)
onready var clear = get_node(clear_path)


func _ready():
	Game.actor = self


func _process(delta):
	if main and overlay and particles:
		overlay.transform = main.get_canvas_transform()
		particles.transform = main.get_canvas_transform()
		clear.transform = main.get_canvas_transform()


func add_to_viewport(node: Node2D, layer):
	match layer:
		Game.Layer.OVERLAY:
			overlay.add_child(node)
		Game.Layer.PARTICLES:
			particles.add_child(node)
		Game.Layer.CLEAR:
			clear.add_child(node)
		_:
			pass
