extends MultiMeshInstance3D
@export var clockRingTime: int

func _ready() -> void:
	$HourHand/Timer.start(clockRingTime)
