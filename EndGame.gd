extends Control

export var points : int = 0 setget set_points

signal playagain
signal menu

func _ready():
	$MarginContainer/VBoxContainer/PlayAgainButton.connect("button_up", self, "_on_play_again_clicked")
	$MarginContainer/VBoxContainer/MenuButton.connect("button_up", self, "_on_menu_clicked")

func set_points(p : int) -> void:
	points = p
	$MarginContainer/VBoxContainer/PointsLabel.text = str(points) + " " + tr("poäng")
	
func _on_play_again_clicked():
	emit_signal("playagain")

func _on_menu_clicked():
	emit_signal("menu")	