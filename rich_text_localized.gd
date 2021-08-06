class_name RichTextLocalized
extends RichTextLabel


func _set(property, value) -> bool:
	if property == "bbcode_text":
		bbcode_text = tr(value)
		return true
	return false


func _ready():
	bbcode_text = tr(bbcode_text)
