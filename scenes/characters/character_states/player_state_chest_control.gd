class_name PlayerStateChestControl
extends PlayerState

const CONTROL_DURATION := 200

var timer := 0.0


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.CHEST_CONTROL))
	player.velocity = Vector2.ZERO
	timer = 0.0
	
	
func _physics_process(delta: float) -> void:
	timer += delta * 1000.0
	if timer > CONTROL_DURATION:
		transition_to(Player.State.MOVING)
