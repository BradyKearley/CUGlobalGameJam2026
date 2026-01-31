extends MeshInstance3D

@export var voice:AudioStreamMP3
@export var drink:AudioStreamMP3
@export var drinkName: String
func _ready() -> void:
	$Voice.stream = voice
	$Drink.stream = drink
	$Woman2.playIdle()
func playVoice():
	$Voice.play()
func playDrink():
	$Drink.play()
