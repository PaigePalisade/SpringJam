class_name ScoreCounter

extends Label

var timer: float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer < 0.0 and not GlobalState.game_over:
		GlobalState.score += 5
		timer = 1.0
	text = "Score: %d" % GlobalState.score


func _on_menu_reset() -> void:
	GlobalState.score = 0
	timer = 1.0
