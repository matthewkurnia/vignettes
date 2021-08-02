extends Sprite


export var line_path: NodePath

onready var path = get_node(line_path)


func _ready():
	if path.points.size() >= 2:
		position = path.points[1]
