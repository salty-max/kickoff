class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var player: Player = null
var ball: Ball = null
var teammate_detection_area: Area2D
var state_data: PlayerStateData


func setup(ctx: PlayerStateContext) -> void:
	player = ctx.player
	ball = ctx.ball
	state_data = ctx.state_data
	teammate_detection_area = ctx.teammate_detection_area
	
	
func transition_to(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
	
	
func on_animation_complete() -> void:
	pass
