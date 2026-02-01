
extends MeshInstance3D

class_name Bartender

@export var voice:AudioStreamMP3
@export var voiceTwo:AudioStreamMP3

@onready var wine = $Bar/Wine2
@onready var martini = $Bar/Martini2
@onready var champagne = $Bar/Champagne

func _ready() -> void:
	$Voice.stream = voice
	$Man.playIdle()
func playVoice():
	$Voice.play()
func swapVoice():
	$Voice.stream = voiceTwo
	
func hideWine():
	wine.hide()
func hideChampagne():
	champagne.hide()
func hideMartini():
	martini.hide()
