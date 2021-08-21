extends Sprite


const INTERVAL = 47

var state = 0

onready var init_pos = position
onready var n = 3


func _input(event):
	var ui_pressed = Input.is_action_just_pressed("ui_down")
	ui_pressed = ui_pressed or Input.is_action_just_pressed("ui_up")
	ui_pressed = ui_pressed or Input.is_action_just_pressed("ui_accept")
	ui_pressed = ui_pressed or Input.is_action_just_pressed("ui_cancel")
	if ui_pressed and get_tree().paused:
		$AudioStreamPlayer.play()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not Game.is_menu:
		get_tree().paused = not get_tree().paused
	get_parent().visible = get_tree().paused
	if not get_tree().paused:
		return
	if Input.is_action_just_pressed("ui_up"):
		state = (state-1 + n) % n
		self.position = init_pos + Vector2.DOWN * state * INTERVAL
	if Input.is_action_just_pressed("ui_down"):
		state = (state+1) % n
		self.position = init_pos + Vector2.DOWN * state * INTERVAL
	if Input.is_action_just_pressed("ui_accept"):
		match state:
			0:
				get_tree().paused = false
			1:
				get_tree().paused = false
				Game.change_scene_to_menu()
				set_process(false)
				yield(Game, "scene_changed")
				set_process(true)
			2:
				get_tree().quit()
