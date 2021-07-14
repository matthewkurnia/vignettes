extends Area2D


signal recall(direction)

const SPEED = 50
const GRAV = 1

var velocity := Vector2.ZERO
var pinned = false


onready var chain = $Chain
onready var player = Player.get_player_node()


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	if not pinned:
		if not bodies.empty():
			pinned = true
			var temp = self.global_position
			get_parent().remove_child(self)
			bodies[0].add_child(self)
			self.global_position = temp
		else:
			velocity.y += GRAV
			velocity = velocity.clamped(SPEED)
			self.global_position += velocity


func _process(delta):
	chain.points[1] = (player.global_position - self.global_position).rotated(
					  -self.rotation)
	self.rotation = velocity.angle()


func recall(direction):
	emit_signal("recall", direction)
	self.queue_free()


func set_direction(dir):
	velocity = dir * SPEED
