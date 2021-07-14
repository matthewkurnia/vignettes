extends Sprite


func _process(delta):
	self.global_rotation = 0.2 * get_parent().global_rotation
