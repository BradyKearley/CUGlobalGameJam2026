extends Node3D

@export var playIdleAnimation:bool = true

func _ready() -> void:
	if playIdleAnimation:
		playIdle()
func playIdle():
	$AnimationPlayer.play("Man_Idle")
func playWalking():
	$AnimationPlayer.play("Man_Walk")
