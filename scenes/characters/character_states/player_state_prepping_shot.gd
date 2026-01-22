class_name PlayerStatePreppingShot
extends PlayerState

const MAX_BONUS_DELAY := 1000.0
const EASE_REWARD_FACTOR := 2.0

var shot_direction := Vector2.ZERO
var time_start_shot = Time.get_ticks_msec()


func _enter_tree() -> void:
	time_start_shot = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.PREP_KICK))
	shot_direction = player.facing
	
	
func _process(delta: float) -> void:
	shot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	
	if KeyUtils.is_action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var press_duration = clampf(Time.get_ticks_msec() - time_start_shot, 0.0, MAX_BONUS_DELAY)
		var ease_time: float = press_duration / MAX_BONUS_DELAY
		var bonus := ease(ease_time, EASE_REWARD_FACTOR)
		var shot_power: float = player.power * (1 + bonus)
		
		shot_direction = shot_direction.normalized()
		
		var data := PlayerStateData.build().set_shot_direction(shot_direction).set_shot_power(shot_power)
		transition_to(Player.State.SHOOTING, data)
