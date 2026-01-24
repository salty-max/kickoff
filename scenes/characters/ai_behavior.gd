class_name AIBehavior
extends Node

const AI_TICK_FREQUENCY := 200

var player: Player
var ball: Ball
var time_since_last_ai_tick := 0.0


func _ready() -> void:
	time_since_last_ai_tick = 0.0 + randi_range(0, AI_TICK_FREQUENCY)


func setup(_player: Player, _ball: Ball) -> void:
	player = _player
	ball = _ball
	
	
func process_ai(delta: float) -> void:
	time_since_last_ai_tick += delta * 1000.0
	if time_since_last_ai_tick > AI_TICK_FREQUENCY:
		_perform_ai_movement()
		_perform_ai_decisions()
		time_since_last_ai_tick = 0.0
	
	
func _perform_ai_movement() -> void:
	var total_steering_force := Vector2.ZERO
	total_steering_force += _get_on_duty_steering_force()
	total_steering_force = total_steering_force.limit_length(1.0)
	player.velocity = total_steering_force * player.speed
	
func _perform_ai_decisions() -> void:
	pass
	
	
func _get_on_duty_steering_force() -> Vector2:
	return player.weight_on_duty_steering * player.position.direction_to(ball.position)
