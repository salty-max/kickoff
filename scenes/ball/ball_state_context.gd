class_name BallStateContext
extends RefCounted

var ball: Ball
var player_detection_area: Area2D
var state_data: BallStateData


static func build() -> BallStateContext:
	return BallStateContext.new()


func set_ball(_ball: Ball) -> BallStateContext:
	ball = _ball
	return self
	
	
func set_player_detection_area(_player_detection_area: Area2D) -> BallStateContext:
	player_detection_area = _player_detection_area
	return self
	
	
func set_state_data(_state_data: BallStateData) -> BallStateContext:
	state_data = _state_data
	return self
