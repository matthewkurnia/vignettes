extends Node2D


onready var particles = $ColorNode/Particles2D
onready var animated_sprite = $AnimatedSprite


func _ready():
	particles.emitting = true
	animated_sprite.rotation = randf() * 2*PI
	animated_sprite.play()
	yield(get_tree().create_timer(1.0), "timeout")
	self.queue_free()
