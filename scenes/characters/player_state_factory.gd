class_name PlayerStateFactory

var states: Dictionary


func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering
	}
	
	
func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "Player: State doesn't exist")
	return states.get(state).new()
