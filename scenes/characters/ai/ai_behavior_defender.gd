class_name AIBehaviorDefender
extends AIBehaviorField

const PRESS_DISTANCE := 60.0
const LANE_WIDTH_THRESHOLD := 80.0

func perform_ai_decisions() -> void:
	_try_tackle(2.0)
	
	if ball.get_carrier() == player:
		_try_pass()
		_try_shoot(SHOT_DISTANCE * 0.5)

func get_on_duty_steering_force() -> Vector2:
	var ball_is_threatening = is_ball_carried_by_opponent() or (ball.position.distance_to(player.own_goal.position) < 300)
	
	if not ball_is_threatening:
		return get_spawn_steering_force()

	var direction: Vector2
	var weight: float
	
	# ZONAL LOGIC
	var vertical_dist_to_ball = abs(player.spawn_position.y - ball.position.y)
	var is_ball_on_other_flank = vertical_dist_to_ball > LANE_WIDTH_THRESHOLD
	
	if is_ball_on_other_flank:
		# --- COVER MODE (Weak Side) ---
		# FIX: Use direction_to(Vector2.ZERO) to ensure we always move towards the field center.
		# This prevents "wrong side" math errors if goal coordinates are confusing.
		
		var goal_pos = player.own_goal.get_center_target_position()
		
		# Calculate a vector pointing from the Goal -> Center of Field
		var direction_to_field_center = goal_pos.direction_to(Vector2.ZERO)
		
		# Move 80 pixels away from the goal line towards the center
		var cover_point_x = goal_pos.x + (direction_to_field_center.x * 80)
		
		# Cover Spot: Center of the field width (Y=0), but close to goal (X=Calculated)
		var cover_spot = Vector2(cover_point_x, 0)
		
		direction = player.position.direction_to(cover_spot)
		weight = get_bicircular_weight(player.position, cover_spot, 5, 0, 40, 1)
		
	else:
		# --- ACTIVE MODE (Strong Side) ---
		var dist_to_ball = player.position.distance_to(ball.position)
		
		if dist_to_ball < PRESS_DISTANCE:
			# Pressing
			direction = player.position.direction_to(ball.position)
			weight = 1.0
		else:
			# Jockeying
			var goal_pos = player.own_goal.get_center_target_position()
			var defense_spot = goal_pos.lerp(ball.position, 0.4)
			var final_spot = defense_spot.lerp(player.spawn_position, 0.5)
			
			direction = player.position.direction_to(final_spot)
			weight = get_bicircular_weight(player.position, final_spot, 10, 0, 50, 1)

	return direction * weight
