class_name PlayerStateTackling
extends PlayerState

const DURATION_PRIOR_RECOVERY := 200
const FRICTION := 250

var time_after_tackle := Time.get_ticks_msec()
var is_tackle_complete := false


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.TACKLE))


func _process(delta: float) -> void:
	if is_tackle_complete:
		return
		
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	
	if player.velocity.length() == 0:
		is_tackle_complete = true
		time_after_tackle = Time.get_ticks_msec()
	else:
		if Time.get_ticks_msec() - time_after_tackle > DURATION_PRIOR_RECOVERY:
			transition_to(Player.State.RECOVERING)
