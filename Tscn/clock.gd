extends MultiMeshInstance3D
@export var clockRingTime: int

func _ready() -> void:
	$Marker3D/Timer.start(clockRingTime)
