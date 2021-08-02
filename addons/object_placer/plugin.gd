tool
extends EditorPlugin


var eds = get_editor_interface().get_selection()
var placer = null


func _enter_tree():
	eds.connect("selection_changed", self, "_on_selection_changed")
	pass


func _exit_tree():
	eds.disconnect("selection_changed", self, "_on_selection_changed")
	pass


func _on_selection_changed():
	# Returns an array of selected nodes
	var selected = eds.get_selected_nodes() 

	if not selected.empty():
		# Always pick first node in selection
		var selected_node = selected[0]
		if selected_node is ObjectPlacer2D:
			placer = selected_node
			return
	placer = null
	return


func forward_canvas_gui_input(event):
	if placer:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_RIGHT:
				if not placer.object_scene:
					push_error("Object not set")
				else:
					execute_add_command(placer)
					pass
				return true
	return false


func execute_add_command(placer):
	var object = placer.object_scene.instance()
	var scene_root = get_tree().get_edited_scene_root()
	var mp = scene_root.get_global_mouse_position()
	mp = mp - Vector2(fmod(mp.x, placer.snap), fmod(mp.y, placer.snap))
	var undo_redo = get_undo_redo()
	undo_redo.create_action("Add Object")
	undo_redo.add_do_method(self, "add_object", mp, placer, object)
	undo_redo.add_undo_method(self, "remove_object", placer, object)
	undo_redo.commit_action()


func add_object(mp, placer: ObjectPlacer2D, object):
	var scene_root = get_tree().get_edited_scene_root()
	object.position = mp - placer.position
	placer.add_child(object)
	object.owner = scene_root


func remove_object(placer: ObjectPlacer2D, object):
	placer.remove_child(object)


func handles(object):
	if object is Resource:
		return false
	return object is ObjectPlacer2D
