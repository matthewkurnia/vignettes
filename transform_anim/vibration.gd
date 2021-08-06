extends Timer


export var amplitude = 2.0

onready var init_pos = get_parent().position


func on_timeout():
	get_parent().set("position", init_pos + amplitude * Vector2(rand_range(1, -1), rand_range(1, -1)))
