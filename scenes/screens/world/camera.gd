class_name Camera
extends Camera2D

const DISTANCE_TARGET := 100.0
const SHAKE_DURATION := 120.0
const SHAKE_INTENSITY := 5.0
const SMOOTHING_BALL_CARRIED := 2
const SMOOTHING_BALL_DEFAULT := 8

@export var ball: Ball

var is_shaking := false
var elapsed_time := Time.get_ticks_msec()

func _ready() -> void:
	GameEvents.impact_received.connect(_on_impact_received)
	elapsed_time = Time.get_ticks_msec()


func _physics_process(_delta: float) -> void:
	if ball.has_carrier():
		position = ball.get_carrier().position + ball.get_carrier().facing * DISTANCE_TARGET
		position_smoothing_speed = SMOOTHING_BALL_CARRIED
	else:
		position = ball.position
		position_smoothing_speed = SMOOTHING_BALL_DEFAULT
		
	if is_shaking and Time.get_ticks_msec() - elapsed_time < SHAKE_DURATION:
		offset = Vector2(randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY), randf_range(-SHAKE_INTENSITY, SHAKE_INTENSITY))
	else:
		is_shaking = false
		offset = Vector2.ZERO
		
func _on_impact_received(_impact_position: Vector2, is_high_impact: bool) -> void:
	if is_high_impact:
		is_shaking = true
		elapsed_time = Time.get_ticks_msec()
