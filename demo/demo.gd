extends Node


const SAVE_PATH = "res://demo_save.data"
const RESET = true


var demo_data = {
	"scene": null,
	"spawn": Vector2.ZERO
}


func _enter_tree():
	if RESET:
		return
	load_data()


func save_data():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_var(demo_data)
	file.close()


func load_data():
	var file = File.new()
	if file.file_exists(SAVE_PATH):
		file.open(SAVE_PATH, File.READ)
		demo_data = file.get_var()
		file.close()
	else:
		file.open(SAVE_PATH, File.WRITE)
		file.close()
		save_data()


func get_spawn():
	return demo_data.spawn


func set_spawn(spawn_position: Vector2):
	demo_data.spawn = spawn_position
	save_data()


func get_scene():
	return demo_data.scene


func set_scene(scene: PackedScene):
	demo_data.scene = scene
	save_data()


func set_key_collected(key: Node):
	var path = key.get_path()
	demo_data[path] = true
	save_data()


func get_key_collected(key: Node):
	var path = key.get_path()
	return demo_data.keys().has(path)
