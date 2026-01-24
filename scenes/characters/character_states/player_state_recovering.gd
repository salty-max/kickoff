class_name PlayerStateRecovering
extends PlayerState

const RECOVERY_DURATION := 500

var timer := 0.0


func _enter_tree() -> void:
	timer = 0.0
	player.velocity = Vector2.ZERO
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.RECOVER))


func _physics_process(delta: float) -> void:
	timer += delta * 1000.0
	if timer > RECOVERY_DURATION:
		transition_to(Player.State.MOVING)
