class_name PlayerStateShooting
extends PlayerState


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.KICK))
	
	
func shoot_ball() -> void:
	ball.shoot(state_data.shot_direction * state_data.shot_power)
	
	
func on_animation_complete() -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		transition_to(Player.State.RECOVERING)
	else:
		transition_to(Player.State.MOVING)
		
	shoot_ball()
