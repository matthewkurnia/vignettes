extends Sprite


const INTERVAL = 44

export var menu_label_path: NodePath

var state = 0

onready var init_pos = position
onready var n = 2
onready var menu_label = get_node(menu_label_path)


func _ready():
	print(Demo.fresh())
	if not Demo.fresh():
		n = 3
		menu_label.set("text", "MENU_2")


func _process(delta):
	get_viewport().set_canvas_transform(Transform2D(0, Vector2.ZERO))
	if Input.is_action_just_pressed("ui_up"):
		state = (state-1 + n) % n
		self.position = init_pos + Vector2.DOWN * state * INTERVAL
	if Input.is_action_just_pressed("ui_down"):
		state = (state+1) % n
		self.position = init_pos + Vector2.DOWN * state * INTERVAL
	if Input.is_action_just_pressed("ui_accept"):
		if n == 2:
			match state:
				0:
					Demo.reset_data()
					Game.change_scene_fresh()
				1:
					get_tree().quit()
		elif n == 3:
			match state:
				0:
					Game.change_scene(Demo.get_last_scene())
				1:
					Demo.reset_data()
					Game.change_scene_fresh()
				2:
					get_tree().quit()
