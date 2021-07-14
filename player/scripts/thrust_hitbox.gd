extends Area2D


var enemies_hit = []

onready var player = Player.get_player_node()


func _physics_process(delta):
	if not monitoring:
		if player.direction != 0:
			self.scale.x = sign(player.direction)
		return
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemy") and not enemies_hit.has(body):
			body.hit(Player.damage, player.velocity)
			enemies_hit.append(body)


func start_monitoring():
	enemies_hit.clear()
	self.monitoring = true


func stop_monitoring():
	self.monitoring = false
