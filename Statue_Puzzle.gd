extends Node3D

@export var correct_order = ["knight", "bard", "king", "bard", "knight", "king", "knight"]

@onready var correct = $Correct
@onready var incorrect = $Incorrect
@onready var solved = $Solved
@onready var bard = $Bard_Statue/Bard
@onready var king = $King_Statue/King
@onready var knight = $Knight_Statue/Knight
@onready var light = $StatueLight
var current_order = []
var puzzle_solved = false

func press_statue(statue: String):
	if puzzle_solved:
		return
	
	solved.play()

	current_order.append(statue)

	# Check if the input so far is correct
	for i in range(current_order.size()):
		if current_order[i] != correct_order[i]:
			reset_puzzle()
			return
			

	# If full sequence entered correctly
	if current_order.size() == correct_order.size():
		solve_puzzle()

func reset_puzzle():
	current_order.clear()
	print("Wrong order! Resetting.")

func solve_puzzle():
	correct.play()
	bard.queue_free()
	king.queue_free()
	knight.queue_free()
	puzzle_solved = true
	light.show()
	print("Puzzle solved! Key obtained.")
	give_key()

func give_key():
	# Spawn key, enable pickup, set variable, etc.
	pass
