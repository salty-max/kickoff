class_name GameStateGameOver
extends GameState


func _enter_tree() -> void:
	var winner_country := manager.get_winner_country()
	GameEvents.game_over.emit(winner_country)
