class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State, state_data: PlayerStateData)

var player: Player = null
var ball: Ball = null
var teammate_detection_area: Area2D
var ball_detection_area: Area2D
var target_goal: Goal
var state_data: PlayerStateData
var ai_behavior: AIBehavior
var tackle_hitbox: Area2D


func setup(ctx: PlayerStateContext) -> void:
	player = ctx.player
	ball = ctx.ball
	state_data = ctx.state_data
	teammate_detection_area = ctx.teammate_detection_area
	target_goal = ctx.target_goal
	ball_detection_area = ctx.ball_detection_area
	ai_behavior = ctx.ai_behavior
	tackle_hitbox = ctx.tackle_hitbox
	
	
func transition_to(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
	
	
func can_carry_ball()-> bool:
	return false
	
	
func can_pass() -> bool:
	return false
	
	
func is_ready_for_kickoff() -> bool:
	return false
	
	
func on_animation_complete() -> void:
	pass
