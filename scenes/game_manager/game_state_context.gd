class_name GameStateContext
extends RefCounted

var manager: GameManager
var state_data: GameStateData


static func build() -> GameStateContext:
	return GameStateContext.new()


func set_manager(_manager: GameManager) -> GameStateContext:
	manager = _manager
	return self 
	
	
func set_state_data(_state_data: GameStateData) -> GameStateContext:
	state_data = _state_data
	return self 
