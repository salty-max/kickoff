class_name BallStateShot
extends BallState

const SHOT_SPRITE_SCALE := 0.8
const SHOT_HEIGHT := 5.0
const RISE_SPEED := 5.0  # Higher value = faster climb
const SHOT_DURATION := 1000.0

var elapsed_time := Time.get_ticks_msec()

func _enter_tree() -> void:
	ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.ROLL), ball.velocity.x < 0)
	ball.sprite.scale.y = SHOT_SPRITE_SCALE
	elapsed_time = Time.get_ticks_msec()
	
	
func _exit_tree() -> void:
	ball.sprite.scale.y = 1.0
	
	
func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - elapsed_time > SHOT_DURATION:
		transition_to(Ball.State.FREEFORM)
	else:
		ball.move_and_collide(ball.velocity * delta)
		ball.height = lerp(ball.height, SHOT_HEIGHT, RISE_SPEED * delta)
