class_name BallStateFreeform
extends BallState

const BOUNCINESS := 0.8

func _enter_tree() -> void:
	player_detection_area.body_entered.connect(_on_player_entered)
	
	
func _physics_process(delta: float) -> void:
	set_ball_anim_from_velocity()
	var friction = Ball.AIR_FRICTION if ball.height > 0 else Ball.GROUND_FRICTION
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, friction * delta)
	process_gravity(delta, BOUNCINESS)
	ball.move_and_collide(ball.velocity * delta)
	
	
func _on_player_entered(body: Player) -> void:
	var data := BallStateData.build().set_carrier(body)
	transition_to(Ball.State.CARRIED, data)
