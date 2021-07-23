extends Node2D


func set_time_scale(time_scale):
	Engine.time_scale = time_scale


func lirpf(from: float, to: float, amount: float) -> float:
	amount = abs(amount)
	var dir := sign(to - from)
	var res := from + dir*amount
	if dir > 0 and res > to:
		return to
	elif dir < 0 and res < to:
		return to
	return res


func lirpv(from: Vector2, to: Vector2, distance: float) -> Vector2:
	distance = abs(distance)
	var difference := to - from
	var resultant := difference.normalized() * distance
	if resultant.length() > difference.length():
		return to
	return from + resultant


func min_v(vector1: Vector2, vector2: Vector2) -> Vector2:
	if vector1.length() < vector2.length():
		return vector1
	return vector2


func max_v(vector1: Vector2, vector2: Vector2) -> Vector2:
	if vector1.length() > vector2.length():
		return vector1
	return vector2


func get_relative_mouse_position(node: Node2D):
	return (get_global_mouse_position() -
			node.get_canvas_transform().origin -
			node.get_global_transform().origin)
