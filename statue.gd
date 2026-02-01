extends StaticBody3D

@export var statue: String
@export var puzzle_manager: Node3D

func interact():
	puzzle_manager.press_statue(statue)
