extends Node


const TRACK_LIST = [
	"arpeggio",
	"base",
	"bass",
	"choir",
	"drums",
	"glitch",
	"strings"
]

var current_deck = "silence"
var ignore = false
var tracks_playing = []

onready var timer = $Timer


func _process(delta):
	pass
#	yield(get_tree().create_timer(15), "timeout")
#	print("ASEDGSDAF")
#	fade_in("drums")


func change_deck(deck: String):
	if current_deck != "silence":
		var mixing_deck = get_node(current_deck)
		mixing_deck.stop("Song")
#		var curr_song = mixing_deck.get_current_song()
#		var n = curr_song._get_core().get_child_count()
#		for i in range(n):
#			mixing_deck.fade_out("Song", i)
#		ignore = true
#		timer.start(mixing_deck.transition_beats)
#		yield(timer, "timeout")
#		ignore = false
	tracks_playing.clear()
	current_deck = deck
	if current_deck != "silence":
		get_node(deck).quickplay("Song")
		var n = get_node(deck).get_current_song()._get_core().get_child_count()
		for i in range(n):
			get_node(deck).mute("Song", i)
		fade_in("base")


func fade(track, condition):
	if condition:
		fade_in(track)
	else:
		fade_out(track)


func play(track):
	if ignore or current_deck == "silence":
		return
	if not tracks_playing.has(track):
		get_node(current_deck).unmute("Song", TRACK_LIST.find(track))
		tracks_playing.append(track)


func fade_in_out(track, delay = 2.0):
	fade_in(track)
	yield(get_tree().create_timer(delay), "timeout")
	fade_out(track)


func fade_in(track):
	if ignore or current_deck == "silence":
		return
	if not tracks_playing.has(track):
#		print("fade in")
		get_node(current_deck).fade_in("Song", TRACK_LIST.find(track))
		tracks_playing.append(track)
#	get_node(current_deck).fade_in("Song", TRACK_LIST.find(track))


func fade_out(track):
	if ignore or current_deck == "silence":
		return
	if tracks_playing.has(track):
#		print("fade out")
		tracks_playing.erase(track)
		get_node(current_deck).fade_out("Song", TRACK_LIST.find(track))
#	get_node(current_deck).fade_out("Song", TRACK_LIST.find(track))
