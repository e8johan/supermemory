extends Control

signal back

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/VBoxContainer/BackButton.connect("button_up", self, "_on_back_clicked")

func _on_back_clicked():
	emit_signal("back")