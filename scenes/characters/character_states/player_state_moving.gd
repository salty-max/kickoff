class_name PlayerStateMoving
extends PlayerState


func _physics_process(delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		ai_behavior.process_ai(delta)
	else:
		handle_movement()
	
	player.set_movement_animation()
	
	
func handle_movement() -> void:
	var direction := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = direction * player.speed
	if player.velocity != Vector2.ZERO:
		teammate_detection_area.rotation = player.velocity.angle()
		
	if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
		if player.has_ball():
			transition_to(Player.State.PASSING)
		elif can_teammate_pass_ball():
			ball.get_carrier().get_pass_request(player)
		else:
			player.swap_requested.emit(player)
	elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.has_ball():
			transition_to(Player.State.PREPPING_SHOT)
		elif ball.can_air_interact():
			if player.velocity == Vector2.ZERO:
				if player.is_facing_target_goal():
					transition_to(Player.State.VOLLEY)
				else:
					transition_to(Player.State.BICYCLE)
			else:
				transition_to(Player.State.HEADER)
		elif player.velocity != Vector2.ZERO:
			transition_to(Player.State.TACKLING)
		
		
func can_carry_ball()-> bool:
	return player.role != Player.Role.GOALKEEPER
		
		
func can_teammate_pass_ball() -> bool:
	return ball.get_carrier() != null and ball.get_carrier().country == player.country and ball.get_carrier().control_scheme == Player.ControlScheme.CPU
	
	
func can_pass() -> bool:
	return true
		
