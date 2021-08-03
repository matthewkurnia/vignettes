extends CanvasLayer


func reset():
	for child in get_children():
		child.queue_free()
