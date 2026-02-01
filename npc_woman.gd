extends Node3D

@export var playIdleAnimation:bool = true

func _ready() -> void:
	if playIdleAnimation:
		playIdle()

func playIdle():
	$AnimationPlayer.play("Woman_Idle")
func playWalking():
	$AnimationPlayer.play("Woman_Walk")
