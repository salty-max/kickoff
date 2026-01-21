class_name BallState
extends Node

signal state_transition_requested(new_state: Ball.State, state_data: BallStateData)

var ball: Ball = null
var state_data: BallStateData
var player_detection_area: Area2D = null


func setup(_ball: Ball, _state_data: BallStateData, _detection_area: Area2D) -> void:
	ball = _ball
	state_data = _state_data
	player_detection_area = _detection_area


func transition_to(new_state: Ball.State, data: BallStateData = BallStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
