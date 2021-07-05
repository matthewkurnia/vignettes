tool
extends Sprite


export var bend = 0.0


func _process(delta):
	self.material.set_shader_param("bend_ammount", bend)
