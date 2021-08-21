class_name MainRoot
extends Node2D


#	class node for the main layer for building levels. insert more code here if necesary
export var level_name: String


func _ready():
	if level_name:
		Music.change_deck(level_name)


func _exit_tree():
	pass
