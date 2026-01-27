class_name PlayerStateVolley
extends PlayerState

const BONUS_POWER_MULTIPLIER := 1.5
const AIR_CONNECT_MIN_HEIGHT := 1.0
const AIR_CONNECT_MAX_HEIGHT := 20.0


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.VOLLEY))
	ball_detection_area.body_entered.connect(_on_ball_entered)
	
	
func _on_ball_entered(incoming_ball: Ball) -> void:
	if incoming_ball.can_air_connect(AIR_CONNECT_MIN_HEIGHT, AIR_CONNECT_MAX_HEIGHT):
		var destination := target_goal.get_random_target_position()
		var direction := ball.position.direction_to(destination)
		SoundPlayer.play(SoundPlayer.Sound.POWERSHOT)
		ball.shoot(direction * player.power * BONUS_POWER_MULTIPLIER, ball.height)
		
		
func on_animation_complete() -> void:
	transition_to(Player.State.RECOVERING)
