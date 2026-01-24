class_name PlayerStateHurt
extends PlayerState

const AIR_FRICTION := 35.0
const HURT_DURATION := 1000.0
const HURT_HEIGHT_VELOCITY := 200.0
const BALL_TUMBLE_SPEED := 100.0

var elapsed_time := 0.0


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.HURT))
	player.height_velocity = HURT_HEIGHT_VELOCITY
	elapsed_time = 0.0
	if ball.get_carrier() == player:
		ball.tumble(state_data.hurt_direction * BALL_TUMBLE_SPEED)
	
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta * 1000.0
	if elapsed_time > HURT_DURATION:
		transition_to(Player.State.RECOVERING)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, AIR_FRICTION * delta)
