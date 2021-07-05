tool
extends Viewport


func _get_configuration_warning():
	if get_child_count() == 0:
		return "Add puppet as child node"
	return ""


func _ready():
	var pup = get_children()[0]
	get_parent().connect("anim_played", pup, "play")
	get_parent().connect("anim_played_immediate", pup, "play_immediate")


func _process(delta):
	if not Engine.editor_hint:
		return
	var children = get_children()
	if not children.empty():
		self.size = children[0].dimension
		children[0].position = 0.5 * self.size
