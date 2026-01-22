class_name PlayerStateFactory

var states: Dictionary


func _init() -> void:
	states = {
		Player.State.BICYCLE: PlayerStateBicycle,
		Player.State.CHEST_CONTROL: PlayerStateChestControl,
		Player.State.HEADER: PlayerStateHeader,
		Player.State.MOVING: PlayerStateMoving,
		Player.State.PASSING: PlayerStatePassing,
		Player.State.PREPPING_SHOT: PlayerStatePreppingShot,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.SHOOTING: PlayerStateShooting,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.VOLLEY: PlayerStateVolley
	}
	
	
func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "Player: State doesn't exist")
	return states.get(state).new()
