class_name GameState
extends Node

signal state_transition_requested(new_state: GameManager.State, state_data: GameStateData)


var manager: GameManager = null
var state_data: GameStateData


func setup(ctx: GameStateContext) -> void:
	manager = ctx.manager
	state_data = ctx.state_data
	
	
func transition_to(new_state: GameManager.State, data: GameStateData = GameStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
