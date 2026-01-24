class_name PlayerStateMoving
extends PlayerState

const WALK_ANIM_THRESHOLD := 0.6

func _physics_process(delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		ai_behavior.process_ai(delta)
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
			if player.is_facing_target_goal():
				transition_to(Player.State.VOLLEY)
			else:
				transition_to(Player.State.BICYCLE)
		else:
			transition_to(Player.State.HEADER)
	
	#if player.velocity != Vector2.ZERO and KeyUtils.is_action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		#transition_to(Player.State.TACKLING)
	
	
func set_movement_animation() -> void:
	var velocity := player.velocity.length()
	
	if velocity < 1:
		player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.IDLE))
	elif velocity < player.speed * WALK_ANIM_THRESHOLD:
		player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.WALK))
	else:
		player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.RUN))
		
		
