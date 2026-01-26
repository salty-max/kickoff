class_name PlayerStateCelebrating
extends PlayerState

const AIR_FRICTION := 60.0
const CELEBRATING_HEIGHT_VELOCITY := 2.0

var initial_delay := randi_range(200, 500)
var elapsed_time := 0.0


func _enter_tree() -> void:
	GameEvents.team_reset.connect(_on_team_reset)


func _physics_process(delta: float) -> void:
	elapsed_time += delta * 1000.0
	if player.height == 0 and elapsed_time > initial_delay:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * AIR_FRICTION)
	
	
func celebrate() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.CELEBRATE))
	player.height = 0.1
	player.height_velocity = CELEBRATING_HEIGHT_VELOCITY
	
	
func _on_team_reset() -> void:
	var data := PlayerStateData.build().set_reset_position(player.spawn_position)
	transition_to(Player.State.RESETING, data)
	
