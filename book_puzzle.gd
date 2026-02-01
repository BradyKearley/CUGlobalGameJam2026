extends Node3D

@export var correct_order = ["red", "green", "blue", "purple", "yellow"]

var current_order = []
var puzzle_solved = false

@onready var correct = $Correct
@onready var incorrect = $Incorrect
@onready var solved = $Solved

@onready var green = $Book_Green
@onready var blue = $Book_Blue
@onready var red = $Book_Red
@onready var purple = $Book_Purple
@onready var yellow = $Book_Yellow
@onready var clue = $Clue

func press_book(color: String):
	if puzzle_solved:
		return
	
	solved.play()

	current_order.append(color)

	# Check correctness so far
	for i in range(current_order.size()):
		if current_order[i] != correct_order[i]:
			reset_puzzle()
			return


	# Full solution entered
	if current_order.size() == correct_order.size():
		solve_puzzle()

func reset_puzzle():
	current_order.clear()
	print("Wrong order! Resetting.")

func solve_puzzle():
	correct.play()
	green.queue_free()
	blue.queue_free()
	red.queue_free()
	purple.queue_free()
	yellow.queue_free()
	puzzle_solved = true
	clue.play()
	give_key()

func give_key():
	# Spawn key, enable pickup, set variable, etc.
	pass
