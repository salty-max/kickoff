class_name BallStateCarried
extends BallState

const OFFSET_FROM_PLAYER := Vector2(10, 2)
const DRIBBLE_FREQUENCY := 10.0
const DRIBBLE_INTENSITY := 3.0

var dribble_time := 0.0

func _enter_tree() -> void:
	assert(state_data.carrier != null, "Ball should have a carrier when entering CARRIED state")
	GameEvents.ball_carried.emit(state_data.carrier.full_name)
	
	
func _exit_tree() -> void:
	GameEvents.ball_released.emit()
	
	
func _physics_process(delta: float) -> void:
	var vx := 0.0
	dribble_time += delta
	
	if state_data.carrier.velocity != Vector2.ZERO:
		if state_data.carrier.velocity.x != 0:
			vx = cos(DRIBBLE_FREQUENCY * dribble_time) * DRIBBLE_INTENSITY
		
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.ROLL), state_data.carrier.facing.x < 0)		
	else:
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.IDLE))
	
	process_gravity(delta)
	ball.position = state_data.carrier.position + Vector2(vx + state_data.carrier.facing.x * OFFSET_FROM_PLAYER.x, OFFSET_FROM_PLAYER.y)
