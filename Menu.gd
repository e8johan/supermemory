extends Control

export var card_count : int = 8 setget set_card_count

signal play
signal quit
signal about

func _ready():
	$MarginContainer/VBoxContainer/PlayButton.connect("button_up", self, "_on_play_pressed")
	$MarginContainer/VBoxContainer/HBoxContainer2/QuitButton.connect("button_up", self, "_on_quit_pressed")
	$MarginContainer/VBoxContainer/HBoxContainer2/AboutButton.connect("button_up", self, "_on_about_pressed")
	$MarginContainer/VBoxContainer/HBoxContainer/PlusButton.connect("button_up", self, "_on_plus_pressed")
	$MarginContainer/VBoxContainer/HBoxContainer/MinusButton.connect("button_up", self, "_on_minus_pressed")
	
func _on_play_pressed():
	self.emit_signal("play")
	
func _on_quit_pressed():
	self.emit_signal("quit")
	
func _on_about_pressed():
	self.emit_signal("about")
	
func set_card_count(count : int):
	card_count = count
	$MarginContainer/VBoxContainer/HBoxContainer/CardCountLabel.text = str(card_count)
	
	if card_count >= 16:
		$MarginContainer/VBoxContainer/HBoxContainer/PlusButton.disabled = true
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/PlusButton.disabled = false
	if card_count <= 2:
		$MarginContainer/VBoxContainer/HBoxContainer/MinusButton.disabled = true
	else:
		$MarginContainer/VBoxContainer/HBoxContainer/MinusButton.disabled = false

	
func _on_plus_pressed():
	set_card_count(card_count + 1)
	
		
func _on_minus_pressed():
	set_card_count(card_count - 1)
	
		
