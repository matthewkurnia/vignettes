extends Node2D


signal state_override(state)
signal thrust(direction)
signal release(direction)
signal recall(direction)

const CHARGE_KNOCKBACK = 700
const CATCH_KNOCKBACK = 450

export var spear_scene: PackedScene

var has_spear = true
var active = false
var direction = 1
var is_charging = false
var spear

onready var player = Player.get_player_node()
onready var cooldown = $Cooldown
onready var buffer = $Buffer
onready var delay = $Delay
onready var duration = $Duration
onready var charge = $Charge
onready var throw = $Throw
onready var recall = $Recall


func _input(event):
	if not has_spear:
		if Input.is_action_just_pressed("charge") and throw.time_left == 0:
			recall.start()
			recall()
		return
	if Input.is_action_pressed("charge") and recall.time_left == 0 and not is_charging and duration.time_left == 0:
		throw.start()
		is_charging = true
		charge.start()
		emit_signal("state_override", "charge")
	if is_charging:
		if Input.is_action_just_released("charge"):
			charge.stop()
			charge_release()
		return
	if Input.is_action_just_pressed("thrust"):
		if cooldown.time_left == 0:
			emit_signal("state_override", "thrust")
			cooldown.start()
			delay.start()
			duration.start()
		buffer.start()


func _physics_process(delta):
	if is_charging:
		return
	if has_spear:
		var dir = sign(Input.get_action_strength("move_right") -
					   Input.get_action_strength("move_left"))
		if dir != 0:
			direction = dir
		if buffer.time_left > 0 and cooldown.time_left == 0:
			emit_signal("state_override", "thrust")
			cooldown.start()
			delay.start()
			duration.start()
		if not active:
			return
		return


func recall():
	set_deferred("has_spear", true)
	var dir = (self.global_position - spear.global_position).normalized()
	player.velocity.y = min(dir.y*CATCH_KNOCKBACK, -CATCH_KNOCKBACK * 0.5)
	player.velocity.x = dir.x * CATCH_KNOCKBACK
	emit_signal("recall", dir)


func charge_release():
	if not is_charging:
		return
	var dir = Util.get_relative_mouse_position(self).normalized()
	spear = spear_scene.instance()
	player.get_parent().add_child(spear)
	spear.global_position = self.global_position
	spear.set_direction(dir)
	self.connect("recall", spear, "recall")
	has_spear = false
	is_charging = false
	player.velocity.y = min(-dir.y*CHARGE_KNOCKBACK, -CHARGE_KNOCKBACK * 0.5)
	player.velocity.x = -dir.x * CHARGE_KNOCKBACK
	emit_signal("release", dir)


func thrust():
	emit_signal("thrust", direction)
