extends Marker3D
@export var loopRatio: int
func _ready():
	var tween = create_tween()
	tween.set_loops() 
	tween.tween_method(_rotate_z, 0.0, 360.0, loopRatio* 120.0) 

func _rotate_z(angle_degrees: float):
	rotation.z = -deg_to_rad(angle_degrees)


func _on_timer_timeout() -> void:
	$ClockSound.play()
