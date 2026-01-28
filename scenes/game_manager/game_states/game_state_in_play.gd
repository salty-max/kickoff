class_name GameStateInPlay
extends GameState


func _enter_tree() -> void:
	GameEvents.team_scored.connect(_on_team_scored)


func _physics_process(delta: float) -> void:
	manager.time_left -= delta * 1000.0
	if manager.is_time_up():
		if manager.current_match.is_tied():
			transition_to(GameManager.State.OVERTIME)
		else:
			transition_to(GameManager.State.GAME_OVER)
			
			
func _on_team_scored(team_scored_on: String) -> void:
	var data := GameStateData.build().set_team_scored_on(team_scored_on)
	transition_to(GameManager.State.SCORED, data)
