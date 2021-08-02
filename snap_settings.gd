tool
class_name SnapConfig
extends Node


const SAVE_PATH = "res://addons/rmsmartshape/snap_config.cfg"

var config_file = ConfigFile.new()
var settings = {
	"use" : false,
	"relative" : false,
	"step" : Vector2(8, 8),
	"offset" : Vector2(0, 0)
}


func _init():
	load_settings()


func save_settings():
	for key in settings.keys():
		config_file.set_value("snap", key, settings[key])
	
	var error = config_file.save(SAVE_PATH)
	if error != OK:
		print("Failed saving settings file.")


func load_settings():
	var error = config_file.load(SAVE_PATH)
	if error != OK:
		print("Failed loading settings file. Error code is %s." % error)
		return false
	
	for key in settings.keys():
		settings[key] = config_file.get_value("snap", key, null)
	return true


func set_use(value: bool):
	settings["use"] = value
	save_settings()

func get_use():
	return settings["use"]


func set_relative(value: bool):
	settings["relative"] = value
	save_settings()

func get_relative():
	return settings["relative"]


func set_step(value: Vector2):
	settings["step"] = value
	save_settings()

func get_step():
	return settings["step"]


func set_offset(value: Vector2):
	settings["offset"] = value
	save_settings()

func get_offset():
	return settings["offset"]
