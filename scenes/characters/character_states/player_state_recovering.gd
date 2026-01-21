class_name PlayerStateRecovering
extends PlayerState

const RECOVERY_DURATION := 500

var time_start_recovery := Time.get_ticks_msec()


func _enter_tree() -> void:
	time_start_recovery = Time.get_ticks_msec()
	player.velocity = Vector2.ZERO
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.RECOVER))


func _process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_recovery > RECOVERY_DURATION:
		transition_to(Player.State.MOVING)
