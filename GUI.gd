extends MarginContainer

export var points : int = 0 setget set_points

func set_points(p : int) -> void:
	points = p
	$HBoxContainer/PointsLabel.text = str(points)