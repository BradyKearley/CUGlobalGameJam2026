extends Control

signal drink_selected(drink_name: String)
signal ui_closed

@onready var wine_button = $Panel/VBoxContainer/WineButton
@onready var martini_button = $Panel/VBoxContainer/MartiniButton
@onready var champagne_button = $Panel/VBoxContainer/ChampagneButton
@onready var close_button = $CloseButton

func _ready():
	wine_button.pressed.connect(_on_wine_button_pressed)
	martini_button.pressed.connect(_on_martini_button_pressed)
	champagne_button.pressed.connect(_on_champagne_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_wine_button_pressed():
	drink_selected.emit("Wine")
	close_ui()

func _on_martini_button_pressed():
	drink_selected.emit("Martini")
	close_ui()

func _on_champagne_button_pressed():
	drink_selected.emit("Champagne")
	close_ui()

func _on_close_button_pressed():
	close_ui()

func close_ui():
	ui_closed.emit()
	queue_free()
