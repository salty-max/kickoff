class_name GameStateOvertime
extends GameState


func _enter_tree() -> void:
	GameEvents.team_scored.connect(_on_team_scored)
	
	
func _on_team_scored(team_scored_on: String) -> void:
	manager.add_to_score(team_scored_on)
	transition_to(GameManager.State.GAME_OVER)
