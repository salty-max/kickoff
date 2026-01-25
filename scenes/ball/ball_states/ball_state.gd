class_name BallState
extends Node

signal state_transition_requested(new_state: Ball.State, state_data: BallStateData)

var ball: Ball = null
var state_data: BallStateData
var player_detection_area: Area2D = null


func setup(ctx: BallStateContext) -> void:
	ball = ctx.ball
	state_data = ctx.state_data
	player_detection_area = ctx.player_detection_area


func transition_to(new_state: Ball.State, data: BallStateData = BallStateData.new()) -> void:
	state_transition_requested.emit(new_state, data)
	
	
func set_ball_anim_from_velocity() -> void:
	if ball.velocity == Vector2.ZERO:
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.IDLE))
	else:
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.ROLL), ball.velocity.x < 0)
		
		
func process_gravity(delta: float, bounciness: float = 0.0) -> void:
	if ball.height > 0 or ball.height_velocity > 0:
		ball.height_velocity -= Ball.GRAVITY * delta
		ball.height += ball.height_velocity
		if ball.height < 0:
			ball.height = 0
			if bounciness > 0 and ball.height_velocity < 0:
				ball.height_velocity = -ball.height_velocity * bounciness
				ball.velocity *= bounciness
				
				
func move_and_bounce(delta: float) -> void:
	var collision := ball.move_and_collide(ball.velocity * delta)
	if collision != null:
		ball.velocity = ball.velocity.bounce(collision.get_normal()) * Ball.BOUNCINESS
		ball.switch_state(Ball.State.FREEFORM)
		
		
func can_air_interact() -> bool:
	return false
