extends MeshInstance3D
@export var voice:AudioStreamMP3

func _ready() -> void:
	$Voice.stream = voice
func playVoice():
	$Voice.play()
