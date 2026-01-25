class_name PlayerStateDiving
extends PlayerState

const DIVE_DURATION := 500

var elapsed_time := 0.0

func _enter_tree() -> void:
	elapsed_time = 0.0
	var anim := AnimUtils.PlayerAnim.DIVE_DOWN
	var target_destination := Vector2(player.spawn_position.x, ball.position.y)
	var direction := player.position.direction_to(target_destination)
	
	if direction.y > 0:
		anim = AnimUtils.PlayerAnim.DIVE_DOWN
	else:
		anim = AnimUtils.PlayerAnim.DIVE_UP
		
	player.update_animation(AnimUtils.get_player_anim(anim))
	player.velocity = direction * player.speed
	
	
func _physics_process(delta: float) -> void:
	elapsed_time += delta * 1000.0
	if elapsed_time > DIVE_DURATION:
		transition_to(Player.State.RECOVERING)
