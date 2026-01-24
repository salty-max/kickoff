class_name PlayerStateContext
extends RefCounted

var player: Player
var ball: Ball
var teammate_detection_area: Area2D
var ball_detection_area: Area2D
var state_data: PlayerStateData
var target_goal: Goal
var ai_behavior: AIBehavior
var tackle_hitbox: Area2D


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
	
	
func set_ball_detection_area(_ball_detection_area: Area2D) -> PlayerStateContext:
	ball_detection_area = _ball_detection_area
	return self
	
	
func set_target_goal(_goal: Goal) -> PlayerStateContext:
	target_goal = _goal
	return self
	
	
func set_state_data(_state_data: PlayerStateData) -> PlayerStateContext:
	state_data = _state_data
	return self
	
	
func set_ai_behavior(_ai_behavior: AIBehavior) -> PlayerStateContext:
	ai_behavior = _ai_behavior
	return self
	
	
func set_tackle_hitbox(_tackle_hitbox: Area2D) -> PlayerStateContext:
	tackle_hitbox = _tackle_hitbox
	return self
