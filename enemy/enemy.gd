class_name Enemy
extends KinematicBody2D


signal enemy_died()
signal flip_sprite(flip)
signal override_state(state)

const ACCEL = 40
const CHASE_ACCEL = 50

export var health = 3

var velocity = Vector2()
var direction = 1 setget set_direction, get_direction
var chasing = false
var chase_speed = 300
var chase_accel = 50
var accel = ACCEL
var spear = null

onready var player = Player.get_player_node()


func _ready():
	self.add_to_group("enemy")


func set_direction(dir):
	if dir == 0:
		return
	if sign(dir) != direction:
		emit_signal("flip_sprite", sign(dir) < 0)
	direction = sign(dir)


func get_direction():
	return direction


func take_damage(damage):
	health -= damage
	if health == 0:
		emit_signal("enemy_died")


func knockback(value: Vector2):
	pass


func hit(damage, knockback = Vector2.UP * 300):
	self.take_damage(damage)
	self.knockback(knockback)
	emit_signal("override_state", "staggered")


func skewer(damage, spear_node):
	self.take_damage(damage)
	spear = spear_node
	self.collision_mask = 0
	emit_signal("override_state", "skewered")


func unskewer():
	spear = null
	self.collision_mask = 1
	emit_signal("override_state", "staggered")


func chase_player(is_chasing_player: bool, chasing_speed: float = 300, chasing_accel: float = CHASE_ACCEL):
	chasing = is_chasing_player
	chase_speed = chasing_speed
	chase_accel = chasing_accel
