extends Area2D

signal clicked

func _input_event(viewport, event, shape_id):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			self.emit_signal("clicked")