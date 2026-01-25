class_name BallStateFreeform
extends BallState

const MAX_CAPTURE_HEIGHT := 25

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered)
	
	
func _physics_process(delta: float) -> void:
	set_ball_anim_from_velocity()
	var friction = Ball.AIR_FRICTION if ball.height > 0 else Ball.GROUND_FRICTION
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, Ball.BOUNCINESS)
	move_and_bounce(delta)
	
	
func _on_player_entered(body: Player) -> void:
	if body.can_carry_ball() and ball.height < MAX_CAPTURE_HEIGHT:
		var data := BallStateData.build().set_carrier(body)
		body.control_ball()
		transition_to(Ball.State.CARRIED, data)
	
	
func can_air_interact() -> bool:
	return true
