extends Area2D


var enemy_skewered = null


func recall(direction):
	if enemy_skewered:
		enemy_skewered.unskewer()
		enemy_skewered.knockback(direction * 200)


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy"):
			body.skewer(Player.damage, self)
			set_physics_process(false)
			enemy_skewered = body
