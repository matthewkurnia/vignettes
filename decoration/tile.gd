tool
extends Sprite


func set_tile_factor():
	self.material.set_shader_param("tile_factor", self.scale)
