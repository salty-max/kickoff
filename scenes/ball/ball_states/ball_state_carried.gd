class_name BallStateCarried
extends BallState

const OFFSET_FROM_PLAYER := Vector2(10, 2)
const DRIBBLE_FREQUENCY := 10.0
const DRIBBLE_INTENSITY := 3.0

var dribble_time := 0.0

func _ready() -> void:
	assert(state_data.carrier != null, "Ball should have a carrier when entering CARRIED state")
	
	
func _physics_process(delta: float) -> void:
	var carrier = state_data.carrier
	var vx := 0.0
	dribble_time += delta
	
	if carrier.velocity != Vector2.ZERO:
		if carrier.velocity.x != 0:
			vx = cos(DRIBBLE_FREQUENCY * dribble_time) * DRIBBLE_INTENSITY
		
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.ROLL), carrier.facing.x < 0)		
	else:
		ball.update_animation(AnimUtils.get_ball_anim(AnimUtils.BallAnim.IDLE))
	
	process_gravity(delta)
	ball.position = carrier.position + Vector2(vx + carrier.facing.x * OFFSET_FROM_PLAYER.x, OFFSET_FROM_PLAYER.y)
