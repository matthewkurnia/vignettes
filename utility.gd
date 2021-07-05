extends Node


func lirpf(from: float, to: float, amount: float) -> float:
	amount = abs(amount)
	var dir := sign(to - from)
	var res := from + dir*amount
	if dir > 0 and res > to:
		return to
	elif res < to:
		return to
	return res


func lirpv(from: Vector2, to: Vector2, distance: float) -> Vector2:
	distance = abs(distance)
	var difference := to - from
	var resultant := difference.normalized() * distance
	if resultant.length() > difference.length():
		return to
	return from + resultant
