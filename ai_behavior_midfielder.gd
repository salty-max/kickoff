class_name AIBehaviorMidfielder
extends AIBehaviorField

func perform_ai_decisions() -> void:
	_try_tackle(1.0) # Normal aggression
	
	if ball.get_carrier() == player:
		# Midfielders are the main playmakers
		_try_pass()
		_try_shoot()

func _get_on_duty_steering_force() -> Vector2:
	# Logic: Box-to-Box movement
	# They simply want to be relatively close to the ball at all times
	# but maintaining their "formation" offset
	
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
