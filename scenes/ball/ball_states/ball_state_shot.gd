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
	ball.height = Ball.SHOT_HEIGHT
	GameEvents.impact_received.emit(ball.position, true)
	shot_particles.emitting = true
	
	
func _exit_tree() -> void:
	ball.sprite.scale.y = 1.0
	shot_particles.emitting = false
	
	
func _physics_process(delta: float) -> void:
	timer += delta * 1000.0
	if timer > SHOT_DURATION:
		transition_to(Ball.State.FREEFORM)
	else:
		move_and_bounce(delta)
		ball.height = lerp(state_data.shot_height, 0.0, RISE_SPEED * delta)
