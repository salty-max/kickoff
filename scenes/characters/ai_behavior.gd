class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200
const SPREAD_ASSIST_FACTOR := 0.8
const SHOT_DISTANCE := 150
const SHOT_PROBABILITY := 0.3
const TACKLE_DISTANCE := 15
const TACKLE_PROBABILITY := 0.3

var player: Player
var ball: Ball
var time_since_last_ai_tick := 0.0


func _ready() -> void:
	time_since_last_ai_tick = 0.0 + randi_range(0, AI_TICK_FREQUENCY)


func setup(_player: Player, _ball: Ball) -> void:
	player = _player
	ball = _ball
	
	
func process_ai(delta: float) -> void:
	time_since_last_ai_tick += delta * 1000.0
	if time_since_last_ai_tick > AI_TICK_FREQUENCY:
		_perform_ai_movement()
		_perform_ai_decisions()
		time_since_last_ai_tick = 0.0
	
	
func _perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	if player.has_ball():
		total_steering_force += get_carrier_sterring_force()
	elif player.role != Player.Role.GOALKEEPER:
		total_steering_force += _get_on_duty_steering_force()
		if is_ball_carried_by_teammate():
			total_steering_force += get_assist_formation_steering_force()
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed
	
	
func _perform_ai_decisions() -> void:
	if is_ball_carried_by_opponent() and player.position.distance_to(ball.position) <= TACKLE_DISTANCE and randf() < TACKLE_PROBABILITY:
		player.switch_state(Player.State.TACKLING) 
	if ball.get_carrier() == player:
		var target = player.target_goal.get_center_target_position()
		if player.position.distance_to(target) < SHOT_DISTANCE and randf() < SHOT_PROBABILITY:
			face_towards_target_goal()
			var shot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
			var data := PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
			player.switch_state(Player.State.SHOOTING, data) 
	
	
func _get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
	
	
func get_carrier_sterring_force() -> Vector2:
	var target := player.target_goal.get_center_target_position()
	var direction := player.position.direction_to(target)
	var weight := get_bicircular_weight(player.position, target, 100, 0, 150, 1)
	return direction * weight
	
	
func get_assist_formation_steering_force() -> Vector2:
	var spawn_difference := ball.get_carrier().spawn_position - player.spawn_position
	var assist_destination := ball.get_carrier().position - spawn_difference * SPREAD_ASSIST_FACTOR
	var direction := player.position.direction_to(assist_destination)
	var weight := get_bicircular_weight(player.position, assist_destination, 30, 0.2, 60, 1)
	return direction * weight
	
	
func get_bicircular_weight(position: Vector2, center_target_position: Vector2, inner_circle_radius: float, inner_circle_weight: float, outer_circle_radius: float, outer_circle_weight: float) -> float:
	var distance_to_center := position.distance_to(center_target_position)
	if distance_to_center > outer_circle_radius:
		return outer_circle_weight
	elif distance_to_center < inner_circle_radius:
		return inner_circle_weight
	else:
		var distance_to_inner_radius := distance_to_center - inner_circle_radius
		var close_range_distance := outer_circle_radius - inner_circle_radius
		return lerpf(inner_circle_weight, outer_circle_weight, distance_to_inner_radius / close_range_distance)
		
		
func face_towards_target_goal() -> void:
	if not player.is_facing_target_goal():
		player.facing = player.facing * -1
		
		
func is_ball_carried_by_teammate() -> bool:
	return ball.has_carrier() and ball.get_carrier() != player and ball.get_carrier().country == player.country
	
	
func is_ball_carried_by_opponent() -> bool:
	return ball.has_carrier() and ball.get_carrier().country != player.country
