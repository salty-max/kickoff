class_name PlayerStateMoving
extends PlayerState

func _physics_process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		pass
	else:
		handle_movement()
		set_movement_animation()
	
	
func handle_movement() -> void:
	var direction := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = direction * player.speed
	if player.velocity != Vector2.ZERO:
		teammate_detection_area.rotation = player.velocity.angle()
	
	if player.has_ball():
		if KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			transition_to(Player.State.PREPPING_SHOT)
		elif KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
			transition_to(Player.State.PASSING)
	elif ball.can_air_interact() and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.velocity == Vector2.ZERO:
			pass
		else:
			transition_to(Player.State.HEADER)
	
	#if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		#transition_to(Player.State.TACKLING)
	
	
func set_movement_animation() -> void:
	if player.velocity.length() > 0:
		player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.RUN))
	else:
		player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.IDLE))
