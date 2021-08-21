extends Node


signal scene_loaded(scene)

var loader
var wait_frames
var time_max = 100 # msec
var current_scene


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)


func load_scene(path: String):
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		push_error("load interactive failed")
		return
	set_process(true)


func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			emit_signal("scene_loaded", resource.instance())
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			push_error("error during loading")
			loader = null
			break


func update_progress():
	pass
