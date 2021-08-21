extends CanvasLayer


signal timeline_end

export var init_color: Color
export var final_color: Color
export(String) var timeline: String

onready var tween = $Tween
onready var color_rect = $BgrLayer/ColorRect
onready var clear_rect = $ColorNode/CanvasLayer/ColorRect


func _ready():
	print(timeline)
	Player.set_input_enabled(false)
	tween.interpolate_property(color_rect, "modulate", init_color,
			final_color, 0.4, Tween.TRANS_SINE)
	tween.interpolate_property(clear_rect, "modulate", init_color,
			final_color, 0.4, Tween.TRANS_SINE)
	tween.start()
	yield(tween, "tween_all_completed")
	var dialog = Dialogic.start(timeline)
	dialog.offset = 400 * Vector2.RIGHT
	self.add_child(dialog)
	dialog.connect("timeline_end", self, "timeline_end")


func timeline_end(timeline_name):
	tween.interpolate_property(color_rect, "modulate", final_color,
			init_color, 0.4, Tween.TRANS_SINE)
	tween.interpolate_property(clear_rect, "modulate", final_color,
			init_color, 0.4, Tween.TRANS_SINE)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("timeline_end")
	Player.set_input_enabled(true)
	self.queue_free()
