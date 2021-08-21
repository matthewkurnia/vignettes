extends Node


export var bpm = 60
export var bars = 4
export var time_sig = Vector2(4, 4)
export(AudioStream) var stream
export(String) var bus = "Music"

var curr_player: AudioStreamPlayer = null

onready var duration = bars * time_sig.x * (4/time_sig.y) / bpm * 60
onready var anim_player = $AnimationPlayer


func _ready():
#	play_track()
#	$AudioStreamPlayer.play()
	var loop = anim_player.get_animation("loop")
	anim_player.call_deferred("play", "loop")
	loop.length = duration
#	anim_player.play("loop")


func _process(delta):
	pass
#	if curr_player:
#		if curr_player.get_playback_position() >= duration:
#			print("A")
#			play_track()
#		print(curr_player.get_playback_position())


func play_track():
	var audio_player = AudioStreamPlayer.new()
	curr_player = audio_player
	add_child(audio_player)
	audio_player.stream = stream
	audio_player.bus = bus
	audio_player.play()
	audio_player.connect("finished", audio_player, "queue_free")

