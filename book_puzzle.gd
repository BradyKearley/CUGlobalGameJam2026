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

func press_book(color: String):
	if puzzle_solved:
		return

	current_order.append(color)

	# Check if the input so far is correct
	for i in range(current_order.size()):
		if current_order[i] != correct_order[i]:
			incorrect.play()
			reset_puzzle()
			return
		else:
			correct.play()
			

	# If full sequence entered correctly
	if current_order.size() == correct_order.size():
		solve_puzzle()

func reset_puzzle():
	current_order.clear()
	print("Wrong order! Resetting.")

func solve_puzzle():
	solved.play()
	green.hide()
	blue.hide()
	red.hide()
	purple.hide()
	yellow.hide()
	puzzle_solved = true
	print("Puzzle solved! Key obtained.")
	give_key()

func give_key():
	# Spawn key, enable pickup, set variable, etc.
	pass
