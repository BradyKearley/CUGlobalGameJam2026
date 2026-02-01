extends Control

signal note_closed
var text: String
func _on_button_pressed() -> void:
	note_closed.emit()
	queue_free()
func _ready() -> void:
	$Panel/RichTextLabel.text = text
