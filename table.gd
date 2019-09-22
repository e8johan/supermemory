extends Node2D

export var card_count : int = 8

onready var card_prefab = preload("res://card.tscn")

onready var gui = $GUI
onready var timer = $Timer
onready var menu = $Menu
onready var endgame = $EndGame

var _flipped_card = null
var _unflips = []

enum Screens { Game, Menu, EndGame }

func _ready():
	randomize()
	
	set_screen(Screens.Menu)

	timer.connect("timeout", self, "_on_timer_timeout")
	
	menu.connect("play", self, "_on_menu_play")
	menu.connect("quit", self, "_on_menu_quit")
	
	endgame.connect("playagain", self, "_on_menu_play")
	endgame.connect("menu", self, "_on_endgame_menu")

func set_screen(screen):
	match screen:
		Screens.Game:
			gui.show()
			menu.hide()
			endgame.hide()
		Screens.Menu:
			gui.hide()
			menu.show()
			endgame.hide()
		Screens.EndGame:
			gui.hide()
			menu.hide()
			endgame.show()

func _on_menu_play():
	set_screen(Screens.Game)
	init_game()
	
func _on_menu_quit():
	get_tree().quit()
	
func _on_endgame_menu():
	set_screen(Screens.Menu)

func _cols_from_cards(cards : int) -> int:
	match cards:
		2:
			return 2
		4:
			return 2
		6:
			return 3
		8:
			return 4
		10:
			return 4
		12:
			return 4
		14:
			return 5
		16:
			return 4
		18:
			return 6
		20:
			return 5
		22:
			return 6
		24:
			return 6
		26:
			return 7
		28:
			return 7
		30:
			return 8
		32:
			return 8

func init_game():
	gui.points = 0
	card_count = menu.card_count*2
	
	# Calculate the optimal card placement
	var cols : int = _cols_from_cards(card_count)
	var rows : int = ceil(float(card_count) / float(cols))
	
	var row_width : int = min((1920 - 200) / cols, (1080 - 200) / rows)
	var card_width : int = floor(row_width / 1.25)
	var row_offset : int = (row_width - card_width)
	var row_margin : int = (1920 - (card_width * cols + row_offset * (cols-1)))/2
	var last_row_margin : int = 0
	if card_count % cols > 0:
		var last_row_empty = (cols - (card_count % cols))
		last_row_margin = (last_row_empty*row_width)/2

	# Populate faces array
	var faces : Array = []
	for i in range(floor(card_count / 2)):
		var face : String = "kort-" + str(i+1)
		faces.append(face)
		faces.append(face)
	
	# Scramble cards
	var f2 : Array = []
	while faces.size():
		if f2.size() == 0:
			f2.append(faces[0])
		else:
			f2.insert(randi()%(f2.size()+1), faces[0])
		faces.remove(0)
	
	faces = f2
	
	for i in range(card_count):
		var r : int = floor(i / cols)
		var c : int = i % cols
		var extra : int = 0
		if r == rows-1:
			extra = last_row_margin
		
		var card = card_prefab.instance()
		card.add_to_group("cards")
		card.global_position = Vector2(row_margin + c*row_width + extra, 100 + r*row_width)
		card.scale = Vector2(card_width / 512.0, card_width / 512.0)
		self.add_child(card)
		card.set_face(faces[i])
		
		card.connect("clicked", self, "_on_card_clicked")
		card.connect("flipped", self, "_on_card_flipped")
		
func clear_game():
	var cards = _find_all_cards()
	while cards.size() > 0:
		cards[0].queue_free()
		cards.remove(0)

func _on_card_clicked(card):
	if not card.is_flipped:
		card.flip()

func _on_card_flipped(card):
	if card.is_flipped:
		if _flipped_card == null:
			_flipped_card = card
		else:
			if _flipped_card.face == card.face:
				# Match
				gui.points += 5
				_flipped_card = null
				if _are_all_cards_flipped():
					# Game complete - trigger new game
					clear_game()
					endgame.points = gui.points
					set_screen(Screens.EndGame)
			else:
				# Not matched
				if gui.points > 0:
					gui.points -= 1
				_unflips.append(card)
				_unflips.append(_flipped_card)
				timer.start()
				_flipped_card = null
				
func _on_timer_timeout():
	while _unflips.size():
		var card = _unflips[0]
		_unflips.remove(0)
		card.reset()

func _are_all_cards_flipped() -> bool:
	for card in _find_all_cards():
		if card.is_flipped == false:
			return false
	return true

func _find_all_cards() -> Array:
	var res : Array = []
	var children : = self.get_children()
	for child in children:
		if child.is_in_group("cards"):
			res.append(child)
	return res
