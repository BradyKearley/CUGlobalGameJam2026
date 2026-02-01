extends StaticBody3D

@export var book_color: String
@export var puzzle_manager: Node3D


func interact():
	puzzle_manager.press_book(book_color)
