extends Area2D


const BOUNCE_STRENGTH = 1200

onready var normal = Vector2.UP.rotated(self.rotation)
onready var player = Player.get_player_node()
onready var anim_state_machine = $Parts/AnimationTree.get("parameters/playback")


func get_player_bounce(velo):
	anim_state_machine.start("bounce")
	Music.fade_in_out("choir", 1.0)
	return Util.max_v(normal * BOUNCE_STRENGTH,
			(velo.bounce(normal).dot(normal)*0.5 + BOUNCE_STRENGTH * 0.5) * normal)
