class_name PlayerStateChestControl
extends PlayerState

const CONTROL_DURATION := 200

var elapsed_time := Time.get_ticks_msec()


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.CHEST_CONTROL))
	player.velocity = Vector2.ZERO
	elapsed_time = Time.get_ticks_msec()
	
	
func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - elapsed_time > CONTROL_DURATION:
		transition_to(Player.State.MOVING)
