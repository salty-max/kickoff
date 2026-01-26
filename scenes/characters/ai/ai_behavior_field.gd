class_name AIBehaviorField
extends AIBehavior

const SPREAD_ASSIST_FACTOR := 0.8
const SHOT_DISTANCE := 150
const SHOT_PROBABILITY := 0.3
const TACKLE_DISTANCE := 15
const TACKLE_PROBABILITY := 0.3
const PASS_PROBABILITY := 0.05


func perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	
	if player.has_ball():
		total_steering_force += get_carrier_steering_force()
	elif is_ball_carried_by_teammate():
		total_steering_force += get_assist_formation_steering_force()
	else:
		total_steering_force += get_on_duty_steering_force()
		
		if total_steering_force.length_squared() < 1:
			if is_ball_carried_by_opponent():
				total_steering_force += get_spawn_steering_force()
			elif not ball.has_carrier():
				total_steering_force += get_ball_proximity_steering_force()
				total_steering_force += get_density_around_ball_steering_force()
		
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed
	
	
func perform_ai_decisions() -> void:
	_try_tackle()
	
	if ball.get_carrier() == player:
		_try_shoot()
		_try_pass()


# --- Common Actions ---

func _try_tackle(aggression_mult: float = 1.0) -> void:
	if is_ball_carried_by_opponent() and player.position.distance_to(ball.position) <= TACKLE_DISTANCE:
		if randf() < (TACKLE_PROBABILITY * aggression_mult):
			player.switch_state(Player.State.TACKLING)


func _try_shoot(distance_override: float = SHOT_DISTANCE) -> void:
	var target = player.target_goal.get_center_target_position()
	if player.position.distance_to(target) < distance_override and randf() < SHOT_PROBABILITY:
		player.face_towards_target_goal()
		var shot_direction := player.position.direction_to(player.target_goal.get_random_target_position())
		var data := PlayerStateData.build().set_shot_power(player.power).set_shot_direction(shot_direction)
		player.switch_state(Player.State.SHOOTING, data)


func _try_pass() -> void:
	if randf() < PASS_PROBABILITY and has_opponents_nearby() and has_teammate_in_view():
		player.switch_state(Player.State.PASSING)
	
	
# --- Shared Steering Logic ---

func get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)


func get_carrier_steering_force() -> Vector2:
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


func get_ball_proximity_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, ball.position, 50, 1, 120, 0)
	var direction := player.position.direction_to(ball.position)
	return direction * weight


func get_spawn_steering_force() -> Vector2:
	var weight := get_bicircular_weight(player.position, player.spawn_position, 30, 0, 100, 1)
	var direction := player.position.direction_to(player.spawn_position)
	return direction * weight
	
	
func get_density_around_ball_steering_force() -> Vector2:
	var teammates_near_ball_count := ball.get_proximity_teammates_count(player.country)
	if teammates_near_ball_count == 0:
		return Vector2.ZERO
	var weight := 1 - 1.0 / teammates_near_ball_count
	var direction := ball.position.direction_to(player.position)
	return direction * weight


func get_bicircular_weight(position: Vector2, center: Vector2, inner_r: float, inner_w: float, outer_r: float, outer_w: float) -> float:
	var d := position.distance_to(center)
	if d > outer_r: return outer_w
	elif d < inner_r: return inner_w
	return lerpf(inner_w, outer_w, (d - inner_r) / (outer_r - inner_r))
