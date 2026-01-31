extends Node3D

@onready var color_rect = $CanvasLayer/ColorRect

func _ready() -> void:
	# Fade out ColorRect on ready
	color_rect.modulate.a = 1.0 # Start fully opaque
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, 5) # Fade to transparent over 1 second
	# IMPORTANT: Disable mouse input on ColorRect so it doesn't block UI buttons
	tween.tween_callback(_disable_color_rect_mouse_input)

func _disable_color_rect_mouse_input():
	"""Disable mouse input on ColorRect so it doesn't block note UI buttons"""
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	print("GameManager: ColorRect mouse input disabled")

func _on_game_loop_timer_timeout() -> void:
	# Fade in ColorRect when game loop finishes
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 1.0, .1) # Fade to opaque over 0.5 seconds
	$DeathTimer.start()
	

func _on_death_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main_game.tscn")
