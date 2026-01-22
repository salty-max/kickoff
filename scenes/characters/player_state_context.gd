class_name PlayerStateContext
extends RefCounted

var player: Player
var ball: Ball
var teammate_detection_area: Area2D
var state_data: PlayerStateData


static func build() -> PlayerStateContext:
	return PlayerStateContext.new()
	
	
func set_player(_player: Player) -> PlayerStateContext:
	player = _player
	return self


func set_ball(_ball: Ball) -> PlayerStateContext:
	ball = _ball
	return self
	
	
func set_teammate_detection_area(_teammate_detection_area: Area2D) -> PlayerStateContext:
	teammate_detection_area = _teammate_detection_area
	return self
	
	
func set_state_data(_state_data: PlayerStateData) -> PlayerStateContext:
	state_data = _state_data
	return self
