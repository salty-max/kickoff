class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200


var player: Player
var ball: Ball
var time_since_last_ai_tick := 0.0
var opponent_detection_area: Area2D


func _ready() -> void:
	time_since_last_ai_tick = 0.0 + randi_range(0, AI_TICK_FREQUENCY)


func setup(_player: Player, _ball: Ball, _opponent_detection_area: Area2D) -> void:
	player = _player
	ball = _ball
	opponent_detection_area = _opponent_detection_area
	
	
func process_ai(delta: float) -> void:
	time_since_last_ai_tick += delta * 1000.0
	if time_since_last_ai_tick > AI_TICK_FREQUENCY:
		perform_ai_movement()
		perform_ai_decisions()
		time_since_last_ai_tick = 0.0
	
	
func perform_ai_movement() -> void:
	pass
	

func perform_ai_decisions() -> void:
	pass
		
		
func face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.facing = player.facing * -1
		
		
func is_ball_carried_by_teammate() -> bool:
	return ball.has_carrier() and ball.get_carrier() != player and ball.get_carrier().country == player.country
	
	
func is_ball_carried_by_opponent() -> bool:
	return ball.has_carrier() and ball.get_carrier().country != player.country
	
	
func has_opponents_nearby() -> bool:
	var players := opponent_detection_area.get_overlapping_bodies()
	return players.find_custom(func(p: Player): return p.country != player.country) > -1
