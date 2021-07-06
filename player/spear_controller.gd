extends Node2D


signal state_override(state)
signal launch(direction)
signal knockback(direction)
signal thrust(direction)

var active = false
var direction

onready var thrust_transform = $ThrustTransform
onready var hitbox = $ThrustTransform/Hitbox
onready var cooldown = $Cooldown
onready var buffer = $Buffer
onready var delay = $Delay
onready var duration = $Duration


func _unhandled_input(event):
	if Input.is_action_just_pressed("thrust"):
		if cooldown.time_left == 0:
			emit_signal("state_override", "thrust")
		buffer.start()


func _physics_process(delta):
	if buffer.time_left > 0 and cooldown.time_left == 0:
		emit_signal("state_override", "thrust")
	if not active:
		return
	var bodies = hitbox.get_overlapping_bodies()
	if not bodies.empty():
		emit_signal("knockback", direction + PI)


func thrust(dir):
	emit_signal("thrust", (get_global_mouse_position() - self.global_position).angle())
	cooldown.start()
	delay.start()
	duration.start()


func set_active(is_active):
	active = is_active
	if is_active:
		direction = (get_global_mouse_position() - self.global_position).angle()
		thrust_transform.rotation = direction
		emit_signal("launch", direction)


func _on_Delay_timeout():
	set_active(true)


func _on_Duration_timeout():
	set_active(false)
