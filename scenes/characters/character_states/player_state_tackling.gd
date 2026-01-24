class_name PlayerStateTackling
extends PlayerState

const DURATION_PRIOR_RECOVERY := 200
const FRICTION := 250

var elapsed_time := 0.0

func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.TACKLE))
	tackle_hitbox.monitoring = true
	elapsed_time = 0.0

func _exit_tree() -> void:
	tackle_hitbox.monitoring = false

func _physics_process(delta: float) -> void:
	elapsed_time += delta
	
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * FRICTION)
	
	if player.velocity == Vector2.ZERO or elapsed_time > DURATION_PRIOR_RECOVERY:
		transition_to(Player.State.RECOVERING)
