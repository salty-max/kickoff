class_name GameStateScored
extends GameState

const CELEBRATION_DURATION := 3000

var elapsed_time := 0.0


func _enter_tree() -> void:
	manager.add_to_score(state_data.team_scored_on)
	elapsed_time = 0.0
	
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta * 1000.0
	if elapsed_time > CELEBRATION_DURATION:
		elapsed_time = 0.0
		transition_to(GameManager.State.RESET, state_data)
