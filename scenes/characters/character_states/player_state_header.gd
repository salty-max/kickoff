class_name PlayerStateHeader
extends PlayerState

const BONUS_POWER_MULTIPLIER := 1.3
const START_HEIGHT := 0.1
const HEIGHT_VELOCITY := 1.5
const AIR_CONNECT_MIN_HEIGHT := 10.0
const AIR_CONNECT_MAX_HEIGHT := 30.0


func _enter_tree() -> void:
	player.update_animation(AnimUtils.get_player_anim(AnimUtils.PlayerAnim.HEADER))
	player.height = START_HEIGHT
	player.height_velocity = HEIGHT_VELOCITY
	ball_detection_area.body_entered.connect(_on_ball_entered)
	
	
func _physics_process(_delta: float) -> void:
	if player.height == 0:
		transition_to(Player.State.RECOVERING)
		
	
func _on_ball_entered(incoming_ball: Ball) -> void:
	if incoming_ball.can_air_connect(AIR_CONNECT_MIN_HEIGHT, AIR_CONNECT_MAX_HEIGHT):
		SoundPlayer.play(SoundPlayer.Sound.POWERSHOT)
		incoming_ball.shoot(player.velocity.normalized() * player.power * BONUS_POWER_MULTIPLIER, player.height)
