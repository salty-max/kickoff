class_name Ball
extends AnimatableBody2D

const AIR_FRICTION := 35.0
const GROUND_FRICTION := 250.0
const BOUNCINESS := 0.8
const GRAVITY := 10.0
const DISTANCE_HIGH_PASS := 130
const SHOT_HEIGHT := 5.0

enum State {
	CARRIED,
	FREEFORM,
	SHOT
}

@export var max_height_reference := 100.0 # Height at which shadow is smallest
@export var min_shadow_scale := 0.4
@export var max_shadow_scale := 1.0

@onready var player_detection_area: Area2D = $PlayerDetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var shadow: Sprite2D = $Shadow

var velocity := Vector2.ZERO
var height := 0.0
var height_velocity := 0.0
var state_factory := BallStateFactory.new()
var current_state: BallState = null


func _ready() -> void:
	switch_state(State.FREEFORM)
	
	
func _process(_delta: float) -> void:
	sprite.position = Vector2.UP * height
	
	# Calculate shadow scale
	# As height goes from 0 to max_height_reference, 
	# scale goes from max_shadow_scale down to min_shadow_scale
	var shadow_factor = clamp(height / max_height_reference, 0.0, 1.0)
	var s = lerp(max_shadow_scale, min_shadow_scale, shadow_factor)
	
	shadow.scale = Vector2(s, s)


func switch_state(state: Ball.State, state_data: BallStateData = BallStateData.new()) -> void:
	if current_state:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	var ctx := BallStateContext.build().set_ball(self).set_player_detection_area(player_detection_area).set_state_data(state_data)
	current_state.setup(ctx)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", Ball.State.keys()[state])
	
	call_deferred("add_child", current_state)
	
	
func shoot(shot_velocity: Vector2, shot_height: float = SHOT_HEIGHT) -> void:
	velocity = shot_velocity
	var data := BallStateData.build().set_shot_height(shot_height)
	switch_state(Ball.State.SHOT, data)
	
	
func pass_to(destination: Vector2) -> void:
	var direction := position.direction_to(destination)
	var distance := position.distance_to(destination)
	var intensity := sqrt(2 * distance * GROUND_FRICTION)
	velocity = direction * intensity
	if distance > DISTANCE_HIGH_PASS:
		height_velocity = Ball.GRAVITY * distance / (1.8 * intensity)
	switch_state(Ball.State.FREEFORM)
	
	
func stop() -> void:
	velocity = Vector2.ZERO
	
	
func has_carrier() -> bool:
	return current_state.state_data.carrier != null
	
	
func get_carrier() -> Player:
	return current_state.state_data.carrier
	
	
func can_air_interact() -> bool:
	return current_state and current_state.can_air_interact()
	
	
func can_air_connect(min_height: float, max_height: float) -> bool:
	return height >= min_height and height <= max_height
	
	
func update_animation(anim_name: String, backwards: bool = false) -> void:
	assert(animation_player.has_animation(anim_name), str("No animation named %s for Ball", [anim_name]))
	if backwards:
		animation_player.play_backwards(anim_name)
		animation_player.advance(0)
	else:
		animation_player.play(anim_name)
		animation_player.advance(0)
