class_name Player
extends CharacterBody2D

const CONTROL_SCHEME_SPRITES_MAP: Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const GRAVITY := 8.0

enum ControlScheme {
	CPU,
	P1,
	P2
}

enum State {
	BICYCLE,
	HEADER,
	MOVING,
	PASSING,
	PREPPING_SHOT,
	RECOVERING,
	SHOOTING,
	TACKLING,
	VOLLEY,
}

@export var control_scheme: ControlScheme
@export var speed: float = 80.0
@export var power: float = 70.0
@export var ball: Ball
@export var own_goal: Goal
@export var target_goal: Goal

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var control_sprite: Sprite2D = $Sprite/ControlSprite
@onready var teammate_detection_area: Area2D = $TeammateDetectionArea
@onready var ball_detection_area: Area2D = $BallDetectionArea

var facing := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()


func _ready() -> void:
	switch_state(State.MOVING)
	set_control_texture()


func _physics_process(delta: float) -> void:
	set_facing()
	set_sprites_visibility()
	flip_sprites()
	process_gravity(delta)
	move_and_slide()


func process_gravity(delta: float) -> void:
	if height > 0:
		height_velocity -= GRAVITY * delta
		height += height_velocity
		if height < 0:
			height = 0
			
	sprite.position = Vector2.UP * height
	
	
func switch_state(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		remove_child(current_state)
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	var ctx := PlayerStateContext.build().set_player(self).set_ball(ball).set_teammate_detection_area(teammate_detection_area).set_ball_detection_area(ball_detection_area).set_state_data(state_data).set_target_goal(target_goal)
	current_state.setup(ctx)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = str("State: ", Player.State.keys()[state])
	
	call_deferred("add_child", current_state)
		
		
func set_facing() -> void:
	if velocity.x > 0:
		facing = Vector2.RIGHT
	elif velocity.x < 0:
		facing = Vector2.LEFT
		
		
func flip_sprites() -> void:
	if facing == Vector2.RIGHT:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
		
func set_sprites_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU
		
		
func set_control_texture() -> void:
	control_sprite.texture = CONTROL_SCHEME_SPRITES_MAP[control_scheme]
	

func update_animation(anim_name: String) -> void:
	assert(animation_player.has_animation(anim_name), str("No animation named %s for Player", [anim_name]))
	animation_player.play(anim_name)
		
		
func has_ball() -> bool:
	return ball.get_carrier() == self
	
	
func _on_animation_complete() -> void:
	if current_state != null:
		current_state.on_animation_complete()
