class_name AIBehaviorForward
extends AIBehaviorField

func perform_ai_decisions() -> void:
	# Lazy defense: 0.5x tackle probability
	_try_tackle(0.5)
	
	if ball.get_carrier() == player:
		# Forwards are selfish. They shoot from further away (1.5x distance)
		_try_shoot(SHOT_DISTANCE * 1.5)
		
		# Only pass if absolutely forced
		if randf() < (PASS_PROBABILITY * 0.5): 
			player.switch_state(Player.State.PASSING)

func get_on_duty_steering_force() -> Vector2:
	# Logic: Find space behind the defense
	
	if is_ball_carried_by_opponent():
		# When defending, stay high up the pitch (waiting for counter-attack)
		# Don't drop back further than the center circle usually
		var waiting_spot = Vector2(player.spawn_position.x, ball.position.y)
		return player.position.direction_to(waiting_spot) * 0.5
	
	else:
		# When attacking (but not carrying), push towards the enemy goal
		var goal_x = player.target_goal.position.x
		# Stay slightly offset from goal to be open for a cross
		var target_spot = Vector2(goal_x - (sign(goal_x) * 100), ball.position.y) 
		return player.position.direction_to(target_spot)
