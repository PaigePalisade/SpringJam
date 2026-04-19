extends Control

signal reset

func _process(delta: float) -> void:
	if GlobalState.game_over:
		show()
	else:
		hide()

func _on_button_pressed() -> void:
	GlobalState.game_over = false
	reset.emit()
