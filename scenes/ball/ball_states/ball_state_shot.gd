class_name BallStateShot
extends BallState

const SHOT_SPRITE_SCALE := 0.8
const RISE_SPEED := 10.0
const SHOT_DURATION := 1000.0

var timer := 0.0

func _enter_tree() -> void:
	set_ball_anim_from_velocity()
	ball.sprite.scale.y = SHOT_SPRITE_SCALE
	timer = 0.0
	
	if state_data.shot_height > ball.height:
		ball.height_velocity = sqrt(2 * Ball.GRAVITY * (state_data.shot_height - ball.height))
	
	
func _exit_tree() -> void:
	ball.sprite.scale.y = 1.0
	
	
func _physics_process(delta: float) -> void:
	timer += delta * 1000.0
	if timer > SHOT_DURATION:
		transition_to(Ball.State.FREEFORM)
	else:
		move_and_bounce(delta)
		ball.height = lerp(state_data.shot_height, 0.0, RISE_SPEED * delta)
