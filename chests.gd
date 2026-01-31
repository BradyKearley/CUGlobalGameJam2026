extends Node3D
func _ready() -> void:
	$UnlockedChest.hide()

func unlock():
	$LockedChest.hide()
	$UnlockedChest.show()
