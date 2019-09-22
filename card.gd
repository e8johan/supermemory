extends Node2D

export var is_flipped : bool = false
var face : String

signal flipped(card)
signal clicked(card)

onready var baksida = $baksida
onready var framsida = $framsida 
onready var clickable = $clickable

func _ready():
	framsida.visible = false
	baksida.visible = true
	
	clickable.connect("clicked", self, "_on_clickable_clicked")

func set_face(f : String):
	face = f
#	var image : Image = Image.new()
#	var res = image.load("res://images/" + face + ".png")
#	if res != OK:
#		print("ERROR: " + str(res))
#		return
#	var texture : ImageTexture = ImageTexture.new()
#	texture.create_from_image(image)
#	framsida.texture = texture
	framsida.texture = load("res://images/" + face + ".png")
	
func flip():
	if is_flipped:
		return
	framsida.visible = true
	baksida.visible = false
	is_flipped = true
	self.emit_signal("flipped", self)
	
func reset():
	if not is_flipped:
		return
	framsida.visible = false
	baksida.visible = true
	is_flipped = false
	self.emit_signal("flipped", self)

func _on_clickable_clicked():
	self.emit_signal("clicked", self)