class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var player: Player = null
var ball: Ball = null
var state_data: PlayerStateData


func setup(_player: Player, _ball: Ball, _state_data: PlayerStateData) -> void:
	player = _player
	ball = _ball
	state_data = _state_data
	
	
func transition_to(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
	
	
func on_animation_complete() -> void:
	pass
