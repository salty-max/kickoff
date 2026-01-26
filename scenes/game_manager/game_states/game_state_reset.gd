class_name GameStateReset
extends GameState

func _enter_tree() -> void:
	GameEvents.team_reset.emit()
	GameEvents.kickoff_ready.connect(_on_kickoff_ready)
	
	
func _on_kickoff_ready() -> void:
	transition_to(GameManager.State.KICKOFF, state_data)
