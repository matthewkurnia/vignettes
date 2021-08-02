extends Node2D


var collected = false

onready var animation_player = $AnimationPlayer
onready var color_sprite = $ColorNode/Sprite
onready var animated_sprite = $AnimatedSprite


func _ready():
	animated_sprite.rotation = randf() * 2*PI
	animation_player.playback_speed = 1 + randf()


func collect():
	if collected:
		return
	collected = true
	color_sprite.visible = false
	animated_sprite.play()
	pass
